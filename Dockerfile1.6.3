FROM golang:1.6.3-alpine

LABEL maintainer="Bo-Yi Wi <appleboy.tw@gmail.com>"

RUN apk update \
  && apk add git make curl perl bash build-base && rm -rf /var/cache/apk/*

# install glide package management.
RUN curl https://glide.sh/get | sh

# install golang tools
RUN go get -u github.com/jstemmer/go-junit-report
RUN go get -u github.com/axw/gocov/gocov
RUN go get -u github.com/AlekSi/gocov-xml
RUN go get -u github.com/golang/lint/golint
RUN go get -u github.com/mitchellh/gox
# a markdown processor for Go
RUN go get -u github.com/russross/blackfriday-tool
# install govendor tool
RUN go get -u github.com/kardianos/govendor
# install embedmd tool
RUN go get -u github.com/campoy/embedmd

# install cloc tool
RUN curl https://raw.githubusercontent.com/AlDanial/cloc/master/cloc -o /usr/bin/cloc \
  && chmod 755 /usr/bin/cloc

ADD coverage.sh /usr/bin/coverage

WORKDIR $GOPATH
