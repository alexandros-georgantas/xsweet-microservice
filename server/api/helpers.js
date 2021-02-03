const multer = require('multer')
const path = require('path')
const fs = require('fs')
const fse = require('fs-extra')

const storage = multer.diskStorage({
  destination: async (req, file, cb) => {
    await fse.ensureDir('temp/')
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
  // Accept EPUBs only
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
      resolve(true)
    })
  })

module.exports = { uploadHandler, readFile, writeFile }
