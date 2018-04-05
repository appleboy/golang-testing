FROM golang:1.9.5-alpine3.7

LABEL maintainer="Bo-Yi Wi <appleboy.tw@gmail.com>"

RUN apk update && \
  apk upgrade --update-cache --available
RUN apk add git make curl perl bash build-base zlib-dev ucl-dev

RUN git clone https://github.com/upx/upx.git && cd upx && \
  git submodule update --init --recursive && \
  make all && cp -r src/upx.out /usr/local/bin/upx

RUN rm -rf /var/cache/apk/*

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
# install misspell tool
RUN go get -u github.com/client9/misspell/cmd/misspell
# install node-prune tool
RUN go get -u github.com/tj/node-prune/cmd/node-prune
# install dep Go dependency management tool
RUN go get -u github.com/golang/dep/cmd/dep
# Versioned Go Prototype (vgo)
RUN go get -u golang.org/x/vgo

# install cloc tool
RUN curl https://raw.githubusercontent.com/AlDanial/cloc/master/cloc -o /usr/bin/cloc \
  && chmod 755 /usr/bin/cloc

ADD coverage.sh /usr/bin/coverage

WORKDIR $GOPATH
