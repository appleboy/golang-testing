.PHONY: build

export PROJECT_PATH = /go/src/github.com/appleboy/golang-testing

all:

install:
	go get -u github.com/kardianos/govendor

sync:
	govendor sync

build:
ifeq ($(tag),)
	@echo "Usage: make $@ tag=<tag>"
	@exit 1
endif
	docker build --no-cache -f Dockerfile$(tag) -t appleboy/golang-testing:$(tag) .

docker_compose_test: clean
	docker-compose -f docker/docker-compose.yml config
	docker-compose -f docker/docker-compose.yml run golang-testing
	docker-compose -f docker/docker-compose.yml down

docker_test: clean
	docker run --rm \
		-v $(PWD):$(PROJECT_PATH) \
		-w=$(PROJECT_PATH) \
		appleboy/golang-testing \
		sh -c "make sync && coverage all"

test: clean sync
	sudo cp coverage.sh /usr/local/bin/coverage
	coverage testing

clean:
	-rm -rf .cover
	-docker-compose -f docker/docker-compose.yml down
