const multer = require('multer')
const path = require('path')
const fs = require('fs-extra')
const cheerio = require('cheerio')

const imageCleaner = html => {
  const $ = cheerio.load(html)
  $('img[src]').each((i, elem) => {
    const $elem = $(elem)
    $elem.remove()
  })
  return $.html()
}

// encode file to base64
const base64EncodeFile = filePath =>
  fs.readFileSync(filePath).toString('base64')

const imagesHandler = html => {
  const $ = cheerio.load(html)
  $('img[src]').each((i, elem) => {
    const $elem = $(elem)
    if ($elem.attr('src').includes('file:')) {
      let filePath = $elem.attr('src').split(':')[1].replace(/\/\//, '/')

      if (!fs.existsSync(filePath)) {
        filePath = $elem.attr('src').split(':')[1].replace('word', '')
        filePath.replace(/\/\//, '/')
      }
      const ext = filePath.slice(filePath.lastIndexOf('.') + 1, filePath.length)
      $elem.attr(
        'src',
        `data:image/${ext};base64,${base64EncodeFile(filePath)}`,
      )

      $elem.wrap('<figure/>')
    }
  })

  return $.html()
}

const boxFixer = html => {
  const $ = cheerio.load(html)
  $('p').each((i, elem) => {
    const $elem = $(elem)
    if ($elem.attr('data-style')) {
      $elem.attr('class', 'paragraph')
      $elem.wrap('<aside class="short note"></aside>')
      $elem.removeAttr('data-style')
    }
  })
  return $('container').html()
}

const mathFixer = html => {
  const $ = cheerio.load(html)
  $(
    'p math-display, h2 math-display, h3 math-display, h4 math-display, h5 math-display, h6 math-display',
  ).each((i, elem) => {
    // We are getting back math-display in the form <p><math-display>[equation]</math-display></p>
    // Wax sees math-display as a block-level node; if it is nested in a paragraph, we get <p>[equotion]</p>
    // This looks for math-display inside of a paragraph and replaces it with <math-display>[equation]</math-display>
    const $elem = $(elem)
    const newMath = $elem.text().replaceAll('\\\\', '\\')

    $($elem[0].parentNode).replaceWith(
      String.raw`<math-display>${newMath}</math-display>`,
    )
  })
  $('math-inline').each((i, elem) => {
    const $elem = $(elem)
    const newMath = $elem.text().replaceAll('\\\\', '\\')
    $elem.replaceWith(String.raw`<math-inline>${newMath}</math-inline>`)
  })

  return $('body').html()
}

const contentFixer = html => {
  const $ = cheerio.load(html)
  $('p').each((i, elem) => {
    const $elem = $(elem)
    if (!$elem.attr('class')) {
      $elem.attr('class', 'paragraph')
    }
  })
  return $('container').html()
}

const storage = multer.diskStorage({
  destination: async (req, file, cb) => {
    await fs.ensureDir('temp/')
    return cb(null, 'temp/')
  },

  // By default, multer removes file extensions so let's add them back
  filename: (req, file, cb) =>
    cb(
      null,
      `${file.fieldname}-${Date.now()}${path.extname(file.originalname)}`,
    ),
})

const fileFilter = (req, file, cb) => {
  // Accept docxs only
  if (!file.originalname.match(/\.(docx)$/)) {
    req.fileValidationError = 'Only docx files are allowed!'
    return cb(null, false)
  }
  return cb(null, true)
}
const uploadHandler = multer({ storage, fileFilter }).single('docx')

const readFile = (filePath, encoding = undefined) =>
  new Promise((resolve, reject) => {
    if (encoding) {
      fs.readFile(filePath, encoding, (err, data) => {
        if (err) {
          return reject(err)
        }
        return resolve(data)
      })
    } else {
      fs.readFile(filePath, (err, data) => {
        if (err) {
          return reject(err)
        }
        return resolve(data)
      })
    }
  })

const writeFile = (filePath, data) =>
  new Promise((resolve, reject) => {
    fs.writeFile(filePath, data, err => {
      if (err) {
        return reject(err)
      }
      return resolve(true)
    })
  })

module.exports = {
  uploadHandler,
  readFile,
  writeFile,
  imageCleaner,
  imagesHandler,
  contentFixer,
  mathFixer,
  boxFixer,
}
