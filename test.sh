#!/bin/bash

set -e

RUNTIME=${RUNTIME:?missing runtime}
IMAGE=${IMAGE:?image missing}

if [[ "$RUNTIME" = "java8" ]]; then 
    MOUNT=$(pwd)/demos/$RUNTIME/target
    HANDLER=examples.Hello::handleRequest
else 
    MOUNT=$(pwd)/demos/$RUNTIME 
    HANDLER=index.handler
fi 

echo "mount: $MOUNT"

if ! docker run --rm -it -v $MOUNT:/code $IMAGE $HANDLER | grep -q 'hello' ; then 
    echo "runtime $RUNTIME test failed"; 
    exit 1; 
fi 