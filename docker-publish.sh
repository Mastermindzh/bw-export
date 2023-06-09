#!/bin/bash

DOCKER_SCOPE=${DOCKER_USERNAME:-"mastermindzh"}

TAGS=(
    "latest"
    "$(cat package.json | grep version | head -1 | awk -F: '{ print $2}' | sed 's/[\",]//g' | tr -d '[[:space:]]')"
)

NAME=$(cat package.json | grep name | head -1 | awk -F: '{ print $2}' | sed 's/[\",]//g' | tr -d '[[:space:]]')

docker build -t "$DOCKER_SCOPE/$NAME:latest" .

for tag in "${TAGS[@]}"; do
    docker tag "$DOCKER_SCOPE/$NAME:latest" "$DOCKER_SCOPE/$NAME:$tag"
    docker push "$DOCKER_SCOPE/$NAME:$tag"
done
