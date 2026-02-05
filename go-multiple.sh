#!/bin/bash


# Run the processing script inside the container
# Mounting the current directory to /data in the container
echo "--- Running GDAL Processing in Docker ---"
docker run --rm --memory="10g" -v "$(pwd):/data:Z" gdal-processor:local ./process_files.sh src/*

