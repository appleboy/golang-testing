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
