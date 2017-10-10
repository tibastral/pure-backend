// https://lazamar.github.io/calling-elm-functions-synchronously/

const http = require('http');
const elmProgram = require('./elmMain')
const worker = elmProgram.ElmMain.worker()
const util = require('util')

const hostname = '127.0.0.1';
const port = 3000;
var responses = {}

worker.ports.done.subscribe(function(value, key) {
  res = responses[key]
  res.statusCode = value.statusCode;
  res.setHeader('Content-Type', value.contentType);
  res.end(value.result);
  responses = responses.delete(key)
})


const runElmProgram = function (req, response) {
  const key = hash(response)
  responses = responses.push({key : response})

  worker.ports.sendData.send({response: req.url, key: key});
}

const server = http.createServer(runElmProgram)

server.listen(port, hostname, () => {
  console.log(`Server running at http://${hostname}:${port}/`);
});