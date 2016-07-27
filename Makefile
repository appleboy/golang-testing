.PHONY: build

export PROJECT_PATH = /go/src/github.com/appleboy/golang-testing

all:

install:
	glide install

update:
	glide update

build:
	docker build --no-cache -t appleboy/golang-testing .

docker_test: clean
	docker-compose -f docker/docker-compose.yml config
	docker-compose -f docker/docker-compose.yml run golang-testing
	docker-compose -f docker/docker-compose.yml down

test: clean
	docker run --rm \
		-v $(PWD):$(PROJECT_PATH) \
		-w=$(PROJECT_PATH) \
		appleboy/golang-testing \
		sh -c "make update && coverage all"

clean:
	-rm -rf .cover
	-docker-compose -f docker/docker-compose.yml down
