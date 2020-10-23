#!/bin/bash

set -e

RUNTIME=${RUNTIME:?missing runtime}
IMAGE=${IMAGE:?image missing}

if [ ! -d "$(pwd)/demos/$RUNTIME" ]; then
    echo "folder $(pwd)/demos/$RUNTIME not exist, will skip related test"
    exit 0
fi

if [[ "$RUNTIME" = "java8" ]] || [[ "$RUNTIME" = "java11" ]]; then 
    MOUNT=$(pwd)/demos/$RUNTIME/target
    HANDLER=examples.Hello::handleRequest
    INITIALIZER=examples.Hello::initialize
else 
    MOUNT=$(pwd)/demos/$RUNTIME 
    HANDLER=index.handler
    INITIALIZER=initializer
fi 

echo "mount: $MOUNT"

echo "docker run --rm -v $MOUNT:/code $IMAGE -h $HANDLER -i $INITIALIZER"

if ! docker run --rm -it -v $MOUNT:/code $IMAGE -h $HANDLER -i $INITIALIZER | grep -q '2' ; then
    echo "runtime $RUNTIME test failed"; 
    exit 1; 
fi 