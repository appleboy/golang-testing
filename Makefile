.PHONY: build

export PROJECT_PATH = /go/src/github.com/appleboy/golang-testing

all:

install:
	glide install

update:
	glide update

build:
	docker build --no-cache -t appleboy/golang-testing .

test: clean
	docker-compose -f docker/docker-compose.yml config
	docker-compose -f docker/docker-compose.yml run golang-testing
	docker-compose -f docker/docker-compose.yml down

clean:
	-rm -rf .cover
	-docker-compose -f docker/docker-compose.yml down
