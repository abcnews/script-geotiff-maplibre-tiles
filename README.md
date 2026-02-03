# Equirectangular to Slippy Map Tiles

A automated utility to convert high-resolution equirectangular images (Plate Carrée) into Web Mercator slippy map tiles (XYZ format). This is ideal for creating custom map layers for MapLibre GL JS, Leaflet, or OpenLayers.

## Dependencies

- **Docker**: Used to run the GDAL environment without requiring local installation of GIS tools.

## Quick Start

1. **Place your source image** (e.g., a `.tif` or `.jpg`) in the project directory.
2. **Run the processing script**:

   ```bash
   ./go.sh your_source_image.tif
   ```

The script will:
1. Build the Docker image (first run only).
2. Reproject the image to EPSG:3857 (Web Mercator).
3. Generate XYZ tiles at zoom levels 0-6 (can be adjusted in `process_file.sh`).
4. Convert all PNG tiles to optimized WebP images.
5. Clean up temporary files.

The resulting tiles will be available in the `./tiles` directory.

## Example Data Source

A great source for high-resolution planetary imagery is NASA's **Blue Marble: Next Generation**:
- [NASA Blue Marble - Base Topography and Bathymetry](https://science.nasa.gov/earth/earth-observatory/blue-marble-next-generation/base-topography-bathymetry/)

