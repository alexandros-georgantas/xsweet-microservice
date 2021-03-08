const { startServer } = require('@coko/server')
// const tmp = require('tmp-promise')
// const fs = require('fs-extra')
// const cheerio = require('cheerio')
// const path = require('path')
// const { exec, execFile } = require('child_process')
// const { readFile, writeFile } = require('./api/helpers')

// const imageCleaner = html => {
//   const $ = cheerio.load(html)
//   $('img[src]').each((i, elem) => {
//     const $elem = $(elem)
//     $elem.remove()
//   })
//   return $.html()
// }

// const handler = async filePath => {
//   const buf = await readFile(filePath)
//   //   console.log('here3')

//   const { path: tmpDir, cleanup } = await tmp.dir({
//     prefix: '_conversion-',
//     unsafeCleanup: true,
//     dir: process.cwd(),
//   })

//   await writeFile(path.join(tmpDir, path.basename(filePath)), buf)
//   //   console.log('here4')
//   await new Promise((resolve, reject) => {
//     execFile(
//       'unzip',
//       ['-o', `${tmpDir}/${path.basename(filePath)}`, '-d', tmpDir],
//       (error, stdout, stderr) => {
//         if (error) {
//           reject(error)
//         }
//         resolve(stdout)
//       },
//     )
//   })
//   //   console.log('here5')
//   await new Promise((resolve, reject) => {
//     exec(
//       `sh ${path.resolve(
//         __dirname,
//         '..',
//         'scripts',
//         'execute_chain.sh',
//       )} ${tmpDir}`,
//       (error, stdout, stderr) => {
//         if (error) {
//           reject(error)
//         }
//         resolve(stdout)
//       },
//     )
//   })
//   //   console.log('here6')
//   const html = await readFile(
//     path.join(tmpDir, 'outputs', 'HTML5.html'),
//     'utf8',
//   )
//   //   console.log('here6')
//   const cleaned = imageCleaner(html)
//   console.log('done')
//   await cleanup()
//   await fs.remove(filePath)
// }
// const init = async () => {
//   startServer().then(async () => {
//     boss.subscribe('xsweet-conversion', async job => {
//       const { data } = job
//       const { filePath } = data
//       return handler(filePath)
//     })
//   })
// }
// init()
startServer()
