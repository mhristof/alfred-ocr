MAKEFLAGS += --warn-undefined-variables
SHELL := bash
.SHELLFLAGS := -eu -o pipefail -c
.DEFAULT_GOAL := zip
.ONESHELL:


IMAGE := alfred-ocr
build: .build
.PHONY: build


%.txt: .build
	docker run -v "$(PWD):/work" -w /work --rm $(IMAGE) tesseract '$(basename $@)' '$(basename $@)'

zip: info.plist  Dockerfile Makefile
	zip -r $(IMAGE).alfredworkflow $^

.build: 
	docker build -t $(IMAGE) .
	touch .build

bash: .build
	docker run --rm -it $(IMAGE) /bin/bash
.PHONY: bash

run: .build
	docker run --rm -it $(IMAGE)
.PHONY: run

clean:
	rm -rf .build
.PHONY: clean

minor:  ## Create a minor git tag and push it
	sed -i "" 's/$(shell semver current | tr -d 'v' )/$(shell semver -n | rev | cut -d ' ' -f1 | rev | tr -d 'v')/' info.plist
	make commitVersion
	semver
	git push --tags

patch:  ## Create a patch git tag and push it
	sed -i "" 's/$(shell semver current | tr -d 'v' )/$(shell semver -p -n | rev | cut -d ' ' -f1 | rev | tr -d 'v')/' info.plist
	make commitVersion
	semver --patch
	git push --tags

.PHONY:
help:           ## Show this help.
	@grep '.*:.*##' Makefile | grep -v grep  | sort | sed 's/:.* ##/:/g' | column -t -s:
