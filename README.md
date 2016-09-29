# docker-wkhtmltopdf-aas
[![License (3-Clause BSD)](https://img.shields.io/badge/license-BSD%203--Clause-brightgreen.svg)](http://opensource.org/licenses/BSD-3-Clause)
[![Build Status](https://travis-ci.org/Traum-Ferienwohnungen/docker-wkhtmltopdf-aas.svg?branch=master)](https://travis-ci.org/Traum-Ferienwohnungen/docker-wkhtmltopdf-aas)
[![Code Climate](https://codeclimate.com/github/Traum-Ferienwohnungen/docker-wkhtmltopdf-aas/badges/gpa.svg)](https://codeclimate.com/github/Traum-Ferienwohnungen/docker-wkhtmltopdf-aas)
[![Issue Count](https://codeclimate.com/github/Traum-Ferienwohnungen/docker-wkhtmltopdf-aas/badges/issue_count.svg)](https://codeclimate.com/github/Traum-Ferienwohnungen/docker-wkhtmltopdf-aas)
[![Test Coverage](https://codeclimate.com/github/Traum-Ferienwohnungen/docker-wkhtmltopdf-aas/badges/coverage.svg)](https://codeclimate.com/github/Traum-Ferienwohnungen/docker-wkhtmltopdf-aas/coverage)
[![dependencies Status](https://david-dm.org/Traum-Ferienwohnungen/docker-wkhtmltopdf-aas/status.svg)](https://david-dm.org/Traum-Ferienwohnungen/docker-wkhtmltopdf-aas)
[![bitHound Overall Score](https://www.bithound.io/github/Traum-Ferienwohnungen/docker-wkhtmltopdf-aas/badges/score.svg)](https://www.bithound.io/github/Traum-Ferienwohnungen/docker-wkhtmltopdf-aas)
[![](https://images.microbadger.com/badges/image/traumfewo/docker-wkhtmltopdf-aas.svg)](http://microbadger.com/images/traumfewo/docker-wkhtmltopdf-aas)

wkhtmltopdf in a docker container as a rest api web service.<br>
This image is based on the [wkhtmltopdf container](https://hub.docker.com/r/traumfewo/docker-wkhtmltopdf).

## Live demo

[https://docker-wkhtmltopdf-aas.herokuapp.com](https://docker-wkhtmltopdf-aas.herokuapp.com)<br>
Token: travisci


## Running the service

```bash
docker build -t pdf-service .
docker run -t -e API_TOKEN='travisci' -p 127.0.0.1:80:5555 pdf-service
```

## Using the webservice via JSON API
#### Python example

```python
import json
import requests
url = 'http://<docker_host>:<port>/'
data = {
    'contents': open('/file/to/convert.html').read().encode('base64'),
    'token': 'your-secret-api-token',
    'options': {
        'margin-right': '20',
        'margin-bottom': '20',
        'page-width': '105mm',
        'page-height': '40mm'
    }
}
headers = { 'Content-Type': 'application/json', }
response = requests.post(url, data=json.dumps(data), headers=headers)
with open('/path/to/local/file.pdf', 'wb') as f:
    f.write(response.content)
```

#### Shell example
```bash
content=$(echo "<html>Your HTML content</html>" | base64)
footer=$(echo "<html>Your HTML footer</html>" | base64)
curl -vvv -H "Content-Type: application/json" -X POST -d \
    '{"contents": "'"$content"'",
      "token": "your-secret-api-token",
      "options": {
        "margin-top": "20",
        "margin-left": "20",
        "margin-right": "20",
        "margin-bottom": "30"
      },
      "footer": "'"$footer"'"}' \
http://<docker_host>:<port> -o OUTPUT_NAME.pdf
```
#### PHP example
```php
$url = 'http://<docker_host>:<port>/';
$ch = curl_init();
curl_setopt($ch, CURLOPT_URL, $url);
curl_setopt($ch, CURLOPT_HTTPHEADER, array('Content-type: application/json'));
curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
$body = json_encode([
    'contents' => base64_encode($html),
    'token' => 'your-secret-api-token',
]);
# print response
curl_setopt($ch, CURLOPT_POSTFIELDS, $body);
echo curl_exec($ch);

```

## Features

The containing features are easy to disable in case you don't need them. <br> For example disable prometheus metrics:
```coffeescript
app.use status()
# app.use prometheusMetrics()
app.use log('combined')
app.use '/', express.static(__dirname + '/documentation')
```

**Auto generated self-hosting documentation (/)**

![alt text](https://i.imgur.com/ikv7Zg7.png)


**Simple Service Status Overview (/status)**

![alt text]( https://i.imgur.com/ELq65Ie.png)


**Standard Apache combine format HTTP logging (stdout)**
```
::ffff:172.17.0.1 - - [11/Sep/2016:14:04:15 +0000] "GET / HTTP/1.1" 200 13500 "-" "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/53.0.2785.101 Safari/537.36"
::ffff:172.17.0.1 - - [11/Sep/2016:14:04:15 +0000] "GET /main.css HTTP/1.1" 200 133137 "http://localhost/" "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/53.0.2785.101 Safari/537.36"
::ffff:172.17.0.1 - - [11/Sep/2016:14:04:16 +0000] "GET /favicon.ico HTTP/1.1" 404 24 "http://localhost/" "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/53.0.2785.101 Safari/537.36"
```

**Prometheus Metrics for service monitoring (/metrics)**
```
# HELP up 1 = up, 0 = not up
# TYPE up gauge
up 1
# HELP nodejs_memory_heap_total_bytes value of process.memoryUsage().heapTotal
# TYPE nodejs_memory_heap_total_bytes gauge
nodejs_memory_heap_total_bytes 29421568
# HELP nodejs_memory_heap_used_bytes value of process.memoryUsage().heapUsed
# TYPE nodejs_memory_heap_used_bytes gauge
nodejs_memory_heap_used_bytes 22794784
# HELP http_request_seconds number of http responses labeled with status code
# TYPE http_request_seconds histogram
```

## Security

The API (PDF generation) is secured by an api token and can therefore be public hosted. The metrics, status and documentation are not protected by the api token (disable or protect them in case you need it). Keep in mind that you should always use https for communication with the service.

## Tests

  To run the test suite, first setup the docker container and install the dependencies, then run `npm test`:

```bash
$ docker build -t pdf-service .
$ docker run -t -e API_TOKEN='travisci' -p 127.0.0.1:80:5555 pdf-service
$ export API_TOKEN=travisci
$ npm install
$ npm test
```

## Philosophy
This Service follows the following architectual design principles
- horizontal scalability, be stateless
- don't reeinvent the wheel, use libraries
- start testing early, keep 100% code coverage
- keep it simple stupid (kiss), few files, few sloc, no stuff
- high performance via non blocking asynchronous code

## Contributing

Issues, pull requests and questions are welcome.<br>
The development of the container takes place on
[Github](https://github.com/Traum-Ferienwohnungen/docker-wkhtmltopdf-aas/issues).<br>If you have a question or a bug report to file, you can report as a github issue.


### Pull Requests

 - Fork the repository
 - Make changes
 - If required, write tests covering the new functionality
 - Ensure all tests pass and 100% code coverage is achieved (run `npm test`)
 - Raise pull request
