#!/bin/bash

# Dependency Check for Equirectangular to Slippy Map Tiles
# Checks if required tools are installed locally to avoid using Docker.

REQUIRED_TOOLS=("wget" "gdalbuildvrt" "gdalwarp" "gdal2tiles" "cwebp")
MISSING_TOOLS=()

echo "--- Checking Dependencies ---"

for TOOL in "${REQUIRED_TOOLS[@]}"; do
    if command -v "$TOOL" >/dev/null 2>&1; then
        VERSION=""
        case "$TOOL" in
            gdal*)
                VERSION=$($TOOL --version 2>/dev/null | head -n 1)
                ;;
            wget)
                VERSION=$(wget --version 2>/dev/null | head -n 1)
                ;;
            cwebp)
                VERSION=$(cwebp -version 2>/dev/null)
                ;;
            *)
                VERSION="installed"
                ;;
        esac
        echo "✅ $TOOL ($VERSION)"
    else
        echo "❌ $TOOL"
        MISSING_TOOLS+=("$TOOL")
    fi
done

echo ""

if [ ${#MISSING_TOOLS[@]} -eq 0 ]; then
    echo "--- All dependencies met! ---"
    echo "You can run the scripts in 'scripts/' directly without Docker."
else
    echo "--- Missing dependencies: ${MISSING_TOOLS[*]} ---"
    echo "Please install these tools locally or use the Docker workflow documented in README.md."
    exit 1
fi
