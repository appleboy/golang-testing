# golang-testing

![Golang Testing](https://farm2.staticflickr.com/1622/24407557644_36087ca6de.jpg)

**Docker image includes golang coverage tools for testing.**

[![Build Status](https://travis-ci.org/appleboy/golang-testing.svg?branch=master)](https://travis-ci.org/appleboy/golang-testing) [![codecov](https://codecov.io/gh/appleboy/golang-testing/branch/master/graph/badge.svg)](https://codecov.io/gh/appleboy/golang-testing) [![Go Report Card](https://goreportcard.com/badge/github.com/appleboy/golang-testing)](https://goreportcard.com/report/github.com/appleboy/golang-testing)

## Feature

The docker images includes the following `golang` tools.

* [x] [go-junit-report](https://github.com/jstemmer/go-junit-report) Convert go test output to junit xml
* [x] [gocov](https://github.com/axw/gocov/gocov) Coverage testing tool
* [x] [gocov-xml](https://github.com/AlekSi/gocov-xml) XML (Cobertura) export
* [x] [golint](https://github.com/golang/lint/golint) This is a linter for Go source code.
* [x] [glide](https://github.com/Masterminds/glide) Package Management for Golang
* [x] [cloc](https://github.com/AlDanial/cloc) Count Lines of Code.

## Usage

Pull the latest `golang-testing` docker image.

```
$ docker pull appleboy/golang-testing
```

### run docker command

Run testing in single docker command.

```
$ export PROJECT_PATH=/go/src/github.com/appleboy/golang-testing
$ docker run --rm \
    -v $(PWD):$PROJECT_PATH \
    -w=$PROJECT_PATH \
    appleboy/golang-testing \
    sh -c "coverage all"
```

Change `PROJECT_PATH` variable. Replace `github.com/appleboy/golang-testing` with your github path.

### run docker-compose command

Please see [docker/docker-compose.yml](./docker/docker-compose.yml) example file. Run the following command.

```
$ export PROJECT_PATH=/go/src/github.com/appleboy/golang-testing
$ docker-compose -f docker/docker-compose.yml run golang-testing \
  sh -c "coverage all"
```

## Install Coverage tool

Copy `coverage.sh` to `/usr/local/bin/coverage` and change permission.

```
$ curl -fsSL https://raw.githubusercontent.com/appleboy/golang-testing/master/coverage.sh /usr/local/bin/coverage
$ chmod +x /usr/local/bin/coverage
```

coverage tool document:

```
Generate test coverage statistics for Go packages.

  -- Command Flag --
  -h | --help                    Display this help and exit
  -m | --mode                    Set coverage mode. (set|count|atomic)
  -d | --dir                     Set store coverage folder (default is ".cover")

  -- Command Action --
  tool                           Install go dependency tools like gocov or golint.
  testing                        Run go testing for all packages
  coverage                       Generate coverage report for all packages
  junit                          Generate coverage xml report for junit plugin
  lint                           Generate Lint report for all packages
  vet                            Generate Vet report for all packages
  cloc                           Generate Count Lines of Code report for all files
  all                            Execute coverage、junit、lint、vet and cloc report

Contribute and source at https://github.com/appleboy/golang-testing
```

## Screenshot

![Testing](./screenshot/screen.png)
