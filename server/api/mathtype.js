const cheerio = require('cheerio')
// const striptags = require('striptags') // maybe use this if we want to keep text in tags in LaTeX?
const { logger } = require('@coko/server')
const { readFile } = require('./helpers')

const getAllAttributes = node => {
  return (
    node.attributes ||
    Object.keys(node.attribs).map(name => ({ name, value: node.attribs[name] }))
  )
}

const getTexFiles = async xmlFiles => {
  // xmlFiles is coming in as an array of {filename: source} objects

  const errorList = [] // This will be a list of filenames of the texFiles that didn't have the right thing in them.
  const texFiles = {}

  const texFilesList = Object.keys(xmlFiles)
  for (let i = 0; i < texFilesList.length; i += 1) {
    const thisFilename = texFilesList[i]
    const thisXml = xmlFiles[thisFilename]

    try {
      // eslint-disable-next-line prefer-destructuring
      texFiles[thisFilename] = thisXml
        .split(/<tex display="[a-z]*">/)[1]
        .split('</tex>')[0]
      // logger.info('found TeX: ', texFiles[i])
      if (texFiles[thisFilename].match(/<[a-z_]+>/)) {
        // If we are here, there are XML tags in the TeX. Let's try to remove them.
        // This method removes XML tags BUT leaves the content. Not 100% sure that's what we should do.
        // texFiles[i] = striptags(texFiles[i], {
        //   encodePlaintextTagDelimiters: false,
        // })
        // This method is taking out specifc tags, though it's possible other things might be getting through!
        texFiles[thisFilename] = texFiles[thisFilename]
          .replaceAll(/<font_style_def>[\s\S]*?<\/font_style_def>/g, '')
          .replaceAll(/<ruler>[\s\S]*?<\/ruler>/g, '')
          .replaceAll(/<halign>[\s\S]*?<\/halign>/g, '')
          .replaceAll(/<valign>[\s\S]*?<\/valign>/g, '')
          .replaceAll(/<nudge>[\s\S]*?<\/nudge>/g, '')
          .replaceAll(/<color_def>[\s\S]*?<\/color_def>/g, '')
          .replaceAll(/<color>[\s\S]*?<\/color>/g, '')
        if (texFiles[thisFilename].match(/<[a-z_]+>/)) {
          logger.info(`\nFound XML tag in LaTeX: ${texFiles[thisFilename]}`)
        }
      }
    } catch (e) {
      // It's entirely possible that we won't have one of those in our MathML. What do we do without it?
      // It seems like we should be able to use MathJax to convert regular MathML, but MathJax maybe doesn't go that way?
      logger.error(
        `Didn't find <tex display="block"> or <tex display="inline"> in MathML!`,
      )

      logger.error(thisXml)
      texFiles[thisFilename] = thisXml
      errorList.push(thisFilename)
    }
  }
  return { texFiles, errorList }
}

const reintegrateMathType = async (html, texFilesList) => {
  // This gets the current HTML from the docx file and the list of tex file paths
  // NOTE that the textFilesList is not actually sorted! First we need to sort it.
  // (Files are coming in "image1.xml", "image10.xml", "image11.xml", "image2.xml", etc.)
  // It is important to have them in the correct order so we can reinsert them correctly.
  const sortedTexFilesList = texFilesList.sort((x, y) => {
    const a = parseInt(x.split('/media/tex/image')[1].split('.xml')[0], 10)
    const b = parseInt(y.split('/media/tex/image')[1].split('.xml')[0], 10)
    if (a > b) return 1
    if (b > a) return -1
    return 0
  })

  // First, read in all the XML files as an array of strings
  const xmlFiles = {}
  await Promise.all(
    sortedTexFilesList.map(async file => {
      const fileName = file.split('/').pop().split('.')[0]
      const thisFile = await readFile(file)
      xmlFiles[fileName] = thisFile.toString()
      return null
    }),
  )
  // Next, strip out everything but the TeX in there.

  // logger.info('making texFiles!')
  const { texFiles, errorList } = await getTexFiles(xmlFiles)

  // Potential problem: before this point, all WMF files have been wrapped in <figures></figures> which split paragraphs
  // This makes all equations block. This might not be what is wanted, but we would have to go upstream to fix this.
  logger.info('Reintegrating TeX into HTML')
  const $ = cheerio.load(html)
  // logger.info('Loaded HTML')
  // console.log('Images: ', $('img').length)
  // console.log('TexFiles: ', texFiles)
  $('img').each((i, elem) => {
    if (!errorList.includes(i)) {
      // If it's in the error list, we're just going to leave the offending WMF for now.
      // const img = $(elem).find('img')[0]
      const attributes = getAllAttributes(elem)
      const src = attributes.find(attr => attr.name === 'src')?.value || ''

      if (!src) {
        // for some word art, we were getting imgs without src?
        $(elem).replaceWith('')
      } else if (
        src.indexOf('/word/media/image') > -1 &&
        src.indexOf('.wmf') > -1 // sometimes these are coming in as pngs?
      ) {
        const myImage = src.split('/').pop().split('.')[0]
        // Check if the parent is a paragraph, and if so, wrap it in inline?
        const parentTag = $(elem).parent().prop('tagName').toLowerCase()
        if (parentTag === 'p') {
          // I am using fake tags to avoid the later math fixing, these are replaced after the math-fixing has been run.
          $(elem).replaceWith(`<math@inline>${texFiles[myImage]}</math@inline>`)
        } else {
          $(elem).replaceWith(
            `<math@display>${texFiles[myImage]}</math@display>`,
          )
        }
      }
    }
  })
  const outputHtml = $('body').html()
  return outputHtml
}

module.exports = { reintegrateMathType }
