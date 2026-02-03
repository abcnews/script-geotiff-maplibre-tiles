#!/bin/bash

# Ensure we have an input file
if [ -z "$1" ]; then
    echo "Usage: ./go.sh <input_tif>"
    exit 1
fi

IMAGE_NAME="gdal-processor:local"

# Build the docker image
echo "--- Building Docker Image ($IMAGE_NAME) ---"
docker build -t $IMAGE_NAME .

# Run the processing script inside the container
# Mounting the current directory to /data in the container
echo "--- Running GDAL Processing in Docker ---"
docker run --rm -v "$(pwd):/data" $IMAGE_NAME ./process_file.sh "$1"
