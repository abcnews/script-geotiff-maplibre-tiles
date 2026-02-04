#!/bin/bash

OUTPUT_DIR="${1:-./tiles}"

# Detect OS for CPU count
if [[ "$OSTYPE" == "darwin"* ]]; then
    THREADS=$(sysctl -n hw.ncpu)
else
    THREADS=$(nproc 2>/dev/null || echo 2)
fi

echo "--- Step 3: Converting PNGs to WebP ---"
# Convert PNGs to WebP (Quality 75, Effort 6)
find "$OUTPUT_DIR" -name "*.png" -print0 | xargs -0 -I {} -P $THREADS \
    sh -c 'cwebp -q 95 -m 6 "{}" -o "${1%.png}.webp" && rm "{}"' -- {}

echo "--- Conversion Done! ---"
