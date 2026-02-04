#!/bin/bash

# Collect all input files
INPUT_FILES=("$@")
OUTPUT_DIR="./tiles"
ZOOM_LEVELS="0-8" # For 500m data, consider 0-9 or 0-10

if [ "$#" -lt 1 ]; then
    echo "Usage: ./process_file.sh <input_file1> [input_file2 ...]"
    exit 1
fi

# Detect OS for CPU count
if [[ "$OSTYPE" == "darwin"* ]]; then
    THREADS=$(sysctl -n hw.ncpu)
else
    THREADS=$(nproc 2>/dev/null || echo 2)
fi

rm -rf "$OUTPUT_DIR"
# Note: We do not remove temp_mercator.tif here to check for its existence below.
[ -f merged_source.vrt ] && rm merged_source.vrt

# Step 0: Merge multiple inputs if necessary
if [ -f "temp_mercator.tif" ]; then
    echo "Artifact temp_mercator.tif exists. Skipping Steps 0 and 1."
else
    if [ "${#INPUT_FILES[@]}" -gt 1 ]; then
        echo "--- Step 0: Merging multiple source files ---"
        gdalbuildvrt -srcnodata 0 merged_source.vrt "${INPUT_FILES[@]}"
        ACTUAL_INPUT="merged_source.vrt"
    else
        ACTUAL_INPUT="${INPUT_FILES[0]}"
    fi

    echo "--- Step 1: Reprojecting (with Pole Clipping) ---"
    # Using a slightly smaller bounding box to avoid edge cases at the poles
    # -20037508.34 is the limit; we'll use 20037508 to be safe.
    gdalwarp -t_srs EPSG:3857 \
             -te -20037508 -20037508 20037508 20037508 \
             -r bilinear \
             -of GTiff \
             -co COMPRESS=LZW \
             -co BIGTIFF=YES \
             -co TILED=YES \
             -dstalpha \
             -overwrite \
             "$ACTUAL_INPUT" temp_mercator.tif
fi

echo "--- Step 2: Generating XYZ Tiles ---"
gdal2tiles --xyz --zoom=$ZOOM_LEVELS \
    --processes=$THREADS --webviewer=none \
    temp_mercator.tif "$OUTPUT_DIR"

# Cleanup intermediate VRT if it exists (but keep temp_mercator.tif for future runs)
[ -f merged_source.vrt ] && rm merged_source.vrt

echo "--- Done! ---"