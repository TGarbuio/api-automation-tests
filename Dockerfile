FROM node:18-bullseye

RUN apt-get update \
  && apt-get install -y --no-install-recommends default-jre \
  && rm -rf /var/lib/apt/lists/*
