.PHONY: build

clean:
	./gradlew clean

compile:
	./gradlew generateProto

build:
	./gradlew build

lint:
	docker run --rm -v $(shell pwd):/workspace:ro chaossystems/prototool:master lint /workspace/src/proto
