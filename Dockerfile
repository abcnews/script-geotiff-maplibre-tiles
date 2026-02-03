# Use Fedora as requested
FROM fedora:41

# Install GDAL and Python bindings
RUN dnf install -y \
    gdal \
    python3-gdal \
    python3-pip \
    libwebp-tools \
    && dnf clean all

# Set the working directory
WORKDIR /data

# Default command
CMD ["/bin/bash"]
