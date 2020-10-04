MAKEFLAGS += --warn-undefined-variables
SHELL := bash
.SHELLFLAGS := -eu -o pipefail -c
.DEFAULT_GOAL := help
.ONESHELL:


IMAGE := alfred-ocr
build: .build
.PHONY: build


%.txt: .build
	docker run -v $$PWD:/work -w /work --rm $(IMAGE) tesseract $(basename $@) $(basename $@)

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

.PHONY:
help:           ## Show this help.
	@grep '.*:.*##' Makefile | grep -v grep  | sort | sed 's/:.* ##/:/g' | column -t -s:
