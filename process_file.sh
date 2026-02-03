#!/bin/bash

INPUT_FILE=$1
OUTPUT_DIR="./tiles"
ZOOM_LEVELS="0-6" # Start small to test; increase to 8 or 10 later

if [ -z "$1" ]; then
    echo "Usage: ./process_file.sh <input_tif>"
    exit 1
fi

# Detect OS for CPU count
if [[ "$OSTYPE" == "darwin"* ]]; then
    THREADS=$(sysctl -n hw.ncpu)
else
    THREADS=$(nproc 2>/dev/null || echo 2)
fi

rm -rf "$OUTPUT_DIR" temp_mercator.tif

echo "--- Step 1: Reprojecting (with Pole Clipping) ---"
# Using a slightly smaller bounding box to avoid edge cases at the poles
# -20037508.34 is the limit; we'll use 20037508 to be safe.
gdalwarp -t_srs EPSG:3857 \
         -te -20037508 -20037508 20037508 20037508 \
         -r bilinear \
         -of GTiff \
         -co COMPRESS=LZW \
         -overwrite \
         "$INPUT_FILE" temp_mercator.tif

echo "--- Step 2: Generating XYZ Tiles ---"
# Check if gdal2tiles.py is in path and call it
gdal2tiles --xyz --zoom=$ZOOM_LEVELS \
    --processes=$THREADS --webviewer=none \
    temp_mercator.tif "$OUTPUT_DIR"

rm temp_mercator.tif

echo "--- Step 3: Converting PNGs to WebP ---"
# Convert PNGs to WebP (Quality 75, Effort 6)
find "$OUTPUT_DIR" -name "*.png" -print0 | xargs -0 -I {} -P $THREADS \
    sh -c 'cwebp -q 75 -m 6 "{}" -o "${1%.png}.webp" && rm "{}"' -- {}

echo "--- Done! ---"