.PHONY: build

all:

build:
	docker build --no-cache -t appleboy/golang-testing .

clean:
	-rm -rf .cover
