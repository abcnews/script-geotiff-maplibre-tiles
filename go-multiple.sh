#!/bin/bash

# Define the input files in the specific order: A1-D1 then A2-D2
FILES=(
    "src/world.topo.bathy.200401.3x21600x21600.A1_geo.tif"
    "src/world.topo.bathy.200401.3x21600x21600.B1_geo.tif"
    "src/world.topo.bathy.200401.3x21600x21600.C1_geo.tif"
    "src/world.topo.bathy.200401.3x21600x21600.D1_geo.tif"
    "src/world.topo.bathy.200401.3x21600x21600.A2_geo.tif"
    "src/world.topo.bathy.200401.3x21600x21600.B2_geo.tif"
    "src/world.topo.bathy.200401.3x21600x21600.C2_geo.tif"
    "src/world.topo.bathy.200401.3x21600x21600.D2_geo.tif"
)

# Run the processing script inside the container
# Mounting the current directory to /data in the container
echo "--- Running GDAL Processing in Docker ---"
docker run --rm --memory="10g" -v "$(pwd):/data:Z" gdal-processor:local ./process_files.sh "${FILES[@]}"

