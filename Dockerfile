FROM ubuntu:18.04

ENV XDG_CACHE_HOME /tmp/.cache
ENV PYTEST_ADDOPTS="-o cache_dir=/tmp"
ENV PYLINTHOME=/tmp

RUN apt-get update -y && \
  apt-get install -y tesseract-ocr libtesseract-dev && \
  rm -rf /var/lib/apt/lists/*
