const multer = require('multer')
const path = require('path')
const tmp = require('tmp-promise')
const fs = require('fs-extra')
const cheerio = require('cheerio')
const { exec, execFile } = require('child_process')
const axios = require('axios')

const imageCleaner = html => {
    const $ = cheerio.load(html)
    $('img[src]').each((i, elem) => {
	const $elem = $(elem)
	$elem.remove()
    })
    return $.html()
}

const contentFixer = html => {
    const $ = cheerio.load(html)
    $('p').each((i, elem) => {
	const $elem = $(elem)
	if (!$elem.attr('class')) {
	    $elem.attr('class', 'paragraph')
	}
    })
    return $.html()
    //return $('container').html()
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
	      resolve(true)
	  })
      })

const conversionHandler = async filePath => {
    const buf = await readFile(filePath)
    const { path: tmpDir, cleanup } = await tmp.dir({
	prefix: '_conversion-',
	unsafeCleanup: true,
	dir: process.cwd(),
    })

    await writeFile(path.join(tmpDir, path.basename(filePath)), buf)

    await new Promise((resolve, reject) => {
	execFile(
	    'unzip',
	    ['-o', `${tmpDir}/${path.basename(filePath)}`, '-d', tmpDir],
	    (error, stdout, stderr) => {
		if (error) {
		    reject(error)
		}
		resolve(stdout)
	    },
	)
    })

    await new Promise((resolve, reject) => {
	exec(
	    `sh ${path.resolve(
        __dirname,
        '..',
        '..',
        'scripts',
        'docx-splitter',
        'xsweet_splitter_execute_chain.sh',
      )} ${tmpDir}`,
	    (error, stdout, stderr) => {
		if (error) {
		    reject(error)
		}
		resolve(stdout)
	    },
	)
    })

    const html = await readFile(
	path.join(tmpDir, 'outputs', 'HTML5.html'),
	'utf8',
    )

    const cleaned = imageCleaner(html)
    const fixed = contentFixer(cleaned)
    return fixed
}

const queueHandler = async (
    filePath,
    callbackURL,
    serviceCredentialId,
    serviceCallbackTokenId,
    bookComponentId,
    responseToken,
) => {
    try {
	const buf = await readFile(filePath)
	const { path: tmpDir, cleanup } = await tmp.dir({
	    prefix: '_conversion-',
	    unsafeCleanup: true,
	    dir: process.cwd(),
	})

	await writeFile(path.join(tmpDir, path.basename(filePath)), buf)

	await new Promise((resolve, reject) => {
	    execFile(
		'unzip',
		['-o', `${tmpDir}/${path.basename(filePath)}`, '-d', tmpDir],
		(error, stdout, stderr) => {
		    if (error) {
			reject(error)
		    }
		    resolve(stdout)
		},
	    )
	})

	await new Promise((resolve, reject) => {
	    exec(
		`sh ${path.resolve(
          __dirname,
          '..',
          '..',
          'scripts',
          'docx-splitter',
          'xsweet_splitter_execute_chain.sh',
        )} ${tmpDir}`,
		(error, stdout, stderr) => {
		    if (error) {
			reject(error)
		    }
		    resolve(stdout)
		},
	    )
	})

	const html = await readFile(
	    path.join(tmpDir, 'outputs', 'HTML5.html'),
	    'utf8',
	)

	const cleaned = imageCleaner(html)
	const fixed = contentFixer(cleaned)

	await axios({
	    method: 'post',
	    url: `${callbackURL}/api/xsweet`,
	    data: {
		convertedContent: fixed,
		serviceCredentialId,
		serviceCallbackTokenId,
		bookComponentId,
		responseToken,
	    },
	})

	await cleanup()
	await fs.remove(filePath)
	return true
    } catch (e) {
	await fs.remove(filePath)
	return axios({
	    method: 'post',
	    url: `${callbackURL}/api/xsweet`,
	    data: {
		convertedContent: undefined,
		error: e,
		serviceCredentialId,
		serviceCallbackTokenId,
		bookComponentId,
		responseToken,
	    },
	})
    }
}

module.exports = {
    uploadHandler,
    readFile,
    writeFile,
    queueHandler,
    conversionHandler,
}
