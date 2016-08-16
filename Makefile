.PHONY: build

export PROJECT_PATH = /go/src/github.com/appleboy/golang-testing

all:

install:
	glide install

update:
	glide update

build:
	docker build --no-cache -f Dockerfile1.7 -t appleboy/golang-testing:1.7 .
	docker build --no-cache -f Dockerfile1.6.3 -t appleboy/golang-testing:1.6.3 .
	docker build --no-cache -f Dockerfile1.5.4 -t appleboy/golang-testing:1.5.4 .

docker_compose_test: clean
	docker-compose -f docker/docker-compose.yml config
	docker-compose -f docker/docker-compose.yml run golang-testing
	docker-compose -f docker/docker-compose.yml down

docker_test: clean
	docker run --rm \
		-v $(PWD):$(PROJECT_PATH) \
		-w=$(PROJECT_PATH) \
		appleboy/golang-testing \
		sh -c "make update && coverage all"

test: clean install
	sudo cp coverage.sh /usr/local/bin/coverage
	coverage testing

clean:
	-rm -rf .cover
	-docker-compose -f docker/docker-compose.yml down
