# GeoTIFF to MapLibre (Slippy Map) Tiles

An automated utility to convert high-resolution geographic imagery (GeoTIFF) into Web Mercator slippy map tiles (XYZ format). This is ideal for creating custom map layers for MapLibre GL JS, Leaflet, or OpenLayers.

This repo uses Docker to run the GDAL environment without requiring local installation of GIS tools. If you have them locally, feel free to run the scripts directly.

## Quick Start

1. **Check for local dependencies**:
   ```bash
   scripts/0.\ check-deps.sh
   ```
   If you have all tools installed locally, you can skip the Docker steps.

2. **Download example imagery**:
   ```bash
   # Default (Black Marble 2016)
   scripts/1.\ fetch-imagery.sh

   # Or specify a specific NASA product template
   scripts/1.\ fetch-imagery.sh "https://assets.science.nasa.gov/.../january/world.topo.bathy.200401.3x21600x21600.{tile}_geo.tif"
   ```
   This will download high-resolution tiles into the `./src` folder.

3. **Build the Docker container**:
   ```bash
   docker build -t gdal-processor:local .
   ```

4. **Generate the XYZ tiles**:
   Run the processing script inside the Docker container. This will merge multiple inputs (if provided), reproject to Web Mercator, and generate tiles:
   ```bash
   docker run --rm -v "$(pwd):/data:Z" gdal-processor:local scripts/2.\ create-tiles.sh src/*.tif
   ```
   *Note: For a single file, just replace `src/*.tif` with your file path.*

5. **Convert tiles to WebP (Optional)**:
   To optimize for the web, convert the generated PNG tiles to WebP:
   ```bash
   docker run --rm -v "$(pwd):/data:Z" gdal-processor:local scripts/3.\ convert-webp.sh
   ```

## How it Works

The process follows these steps:
1. **Merge multiple inputs** into a single virtual dataset (VRT) if needed.
2. **Reproject** the image to EPSG:3857 (Web Mercator) with pole clipping for slippy map compatibility.
3. **Generate XYZ tiles** at zoom levels 0-8 (can be adjusted in `scripts/2. create-tiles.sh`).
4. **Convert PNG tiles** to optimized WebP images (if the optional step is run).

The resulting tiles will be available in the `./tiles` directory.

## Data Sources

A great source for high-resolution planetary imagery is NASA:

- [Blue Marble: Next Generation](https://science.nasa.gov/earth/earth-observatory/collections/blue-marble/) - Base Topography and Bathymetry.
- [Black Marble](https://science.nasa.gov/earth/earth-observatory/earth-at-night/maps/) - Earth at night.

## Compatibility & Input Formats

While this repo is built built for Blue Marble equirectangular (Plate Carrée) NASA imagery, it is compatible with **any dataset supported by GDAL**.

- **Projections**: The `scripts/2. create-tiles.sh` script uses `gdalwarp` to automatically reproject your data from its source projection into EPSG:3857 (Web Mercator).
- **Format**: GeoTIFF is the only tested format, but you might have luck inputting something else.
- **Multi-file Inputs**: If you provide multiple files (e.g., `src/*.tif`), the script automatically merges them into a single continuous map using a Virtual Dataset (VRT).
