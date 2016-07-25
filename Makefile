.PHONY: build

all:

install:
	glide install

update:
	glide update

build:
	docker build --no-cache -t appleboy/golang-testing .

test: clean
	docker-compose -f docker/docker-compose.yml run golang-build
	docker-compose -f docker/docker-compose.yml down

clean:
	-rm -rf .cover
