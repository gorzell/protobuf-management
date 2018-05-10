.PHONY: build

clean:
	./gradlew clean

compile:
	./gradlew generateProto

build:
	./gradlew build

package:
	./gradlew build gem

lint:
	docker run --rm -v $(shell pwd):/workspace:ro chaossystems/prototool:local lint /workspace/src/proto
