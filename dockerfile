# Use an official PHP image as the base image
FROM php:8.1-apache

# Install Python and additional dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3 \
    python3-pip \
    python3-virtualenv \
    cmake \
    libboost-all-dev \
    build-essential \
    libx11-dev \
    libgtk-3-dev \
    libopenblas-dev \
    libjpeg62

# Create a directory named "pvenv" in the root directory
RUN mkdir /pvenv

# Set the desired path for the virtual environment
ENV VIRTUAL_ENV /pvenv

# Create the virtual environment using virtualenv
RUN python3 -m virtualenv $VIRTUAL_ENV

# Activate the virtual environment
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

# Install Python dependencies using the virtual environment
RUN $VIRTUAL_ENV/bin/pip install --upgrade pip \
    && apt-get install -y --no-install-recommends libboost-python-dev \
    && $VIRTUAL_ENV/bin/pip install boost boost-py dlib face_recognition

# Change ownership of the /pvenv directory to www-data:www-data
RUN chown -R www-data:www-data /pvenv

# Run the application:
COPY hello.py .
CMD ["python", "hello.py"]