#!/bin/bash
# Examples:
# Blue Marble (January):   "https://assets.science.nasa.gov/content/dam/science/esd/eo/images/bmng/bmng-topography-bathymetry/january/world.topo.bathy.200401.3x21600x21600.{tile}_geo.tif"
# Blue Marble (February):  "https://assets.science.nasa.gov/content/dam/science/esd/eo/images/bmng/bmng-topography-bathymetry/february/world.topo.bathy.200402.3x21600x21600.{tile}_geo.tif"
# Black Marble (Default):  "https://assets.science.nasa.gov/content/dam/science/esd/eo/images/imagerecords/144000/144898/BlackMarble_2016_{tile}_geo.tif"

# Default to Black Marble 2016 if no template is provided
DEFAULT_TEMPLATE="https://assets.science.nasa.gov/content/dam/science/esd/eo/images/imagerecords/144000/144898/BlackMarble_2016_{tile}_geo.tif"
TILES=("A1" "B1" "C1" "D1" "A2" "B2" "C2" "D2")
SRC_DIR="./src"

# Use first argument as template, or fallback to default
URL_TEMPLATE="${1:-$DEFAULT_TEMPLATE}"

# Ensure source directory exists
mkdir -p "$SRC_DIR"

echo "--- Downloading NASA Imagery Tiles ---"
echo "Template: $URL_TEMPLATE"
echo "Target:   $SRC_DIR"

for TILE in "${TILES[@]}"; do
    # Replace {tile} with the current tile identifier
    # Using bash string substitution: ${var//search/replace}
    URL="${URL_TEMPLATE//\{tile\}/$TILE}"
    
    # Extract filename from URL for logging
    FILE=$(basename "$URL")
    
    echo ""
    echo "--> Downloading $TILE ($FILE)..."
    wget --continue "$URL" -P "$SRC_DIR"
done

echo ""
echo "--- All downloads completed in $SRC_DIR ---"
