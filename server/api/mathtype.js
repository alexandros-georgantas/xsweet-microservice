const cheerio = require('cheerio')
const { logger } = require('@coko/server')
const { readFile } = require('./helpers')

const getAllAttributes = node => {
  return (
    node.attributes ||
    Object.keys(node.attribs).map(name => ({ name, value: node.attribs[name] }))
  )
}

const getTexFiles = async xmlFiles => {
  const errorList = [] // This will be a list of indices of the texFiles that didn't have the right thing in them.
  const texFiles = []
  for (let i = 0; i < xmlFiles.length; i += 1) {
    const thisXml = xmlFiles[i]

    try {
      // eslint-disable-next-line prefer-destructuring
      texFiles[i] = thisXml.split('<tex display="block">')[1].split('</tex>')[0]
    } catch (e) {
      // It's entirely possible that we won't have one of those in our MathML. What do we do without it?
      // It seems like we should be able to use MathJax to convert regular MathML, but MathJax maybe doesn't go that way?
      logger.error(`Didn't find <text display="block"> in MathML!`, e)
      texFiles[i] = thisXml
      errorList.push(i)
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
  const xmlFiles = await Promise.all(
    sortedTexFilesList.map(async file => {
      const thisFile = await readFile(file)
      return thisFile.toString()
    }),
  )

  // Next, strip out everything but the TeX in there.

  // logger.info('making texFiles!')
  const { texFiles, errorList } = await getTexFiles(xmlFiles)
  // logger.info('texFiles: ', texFiles)

  // Potential problem: before this point, all WMF files have been wrapped in <figures></figures> which split paragraphs
  // This makes all equations block. This might not be what is wanted, but we would have to go upstream to fix this.
  logger.info('Reintegrating TeX into HTML')
  const $ = cheerio.load(html)

  $('img').each((i, elem) => {
    if (!errorList.includes(i)) {
      // If it's in the error list, we're just going to leave the offending WMF for now.
      // const img = $(elem).find('img')[0]
      const attributes = getAllAttributes(elem)
      const src = attributes.find(attr => attr.name === 'src').value
      // right now src looks like file:/home/node/xsweet/_conversion-44126Z2v7r29G1Fh/word/media/image47.wmf
      if (src.indexOf('/word/media/image') > -1 && src.indexOf('.wmf') > -1) {
        // Check if the parent is a paragraph, and if so, wrap it in inline?
        const parentTag = $(elem).parent().prop('tagName').toLowerCase()
        if (parentTag === 'p') {
          // I am using fake tags to avoid the later math fixing, these are replaced after the math-fixing has been run.
          $(elem).replaceWith(`<math@inline>${texFiles[i]}</math@inline>`)
        } else {
          $(elem).replaceWith(`<math@display>${texFiles[i]}</math@display>`)
        }
      }
    }
  })
  const outputHtml = await $('body').html()

  // logger.info('output: ', outputHtml)
  return outputHtml
}

module.exports = { reintegrateMathType }
