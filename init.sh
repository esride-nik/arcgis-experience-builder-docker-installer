#!/bin/sh

# Ensure the download and extraction paths are set
DOWNLOAD_PATH=${DOWNLOAD_PATH:-/usr/src/app/downloaded}
EXB_PATH=${EXB_PATH:-/usr/src/app/extracted}

# Create the download and extraction directories if they do not exist
mkdir -p $DOWNLOAD_PATH
mkdir -p $EXB_PATH

# Download and unzip the file if it doesn't already exist
if [ ! -d "$DOWNLOAD_PATH" ]; then
  mkdir -p $DOWNLOAD_PATH
  echo "Downloading ZIP file..."
  curl -L $ZIP_URL -o $DOWNLOAD_PATH/downloaded.zip
  echo "Unzipping file..."
  unzip $DOWNLOAD_PATH/downloaded.zip -d $EXB_PATH
fi

# Install dependencies and start server

# Set working directory for server
cd /usr/src/app/ArcGISExperienceBuilder/server

# Install server dependencies if node_modules does not exist
if [ ! -d "node_modules" ]; then
  echo "Installing server dependencies..."
  npm ci
fi

# Set working directory for client
cd /usr/src/app/ArcGISExperienceBuilder/client

# Install client dependencies if node_modules does not exist
if [ ! -d "node_modules" ]; then
  echo "Installing client dependencies..."
  npm ci
fi

# Start both processes
cd /usr/src/app/ArcGISExperienceBuilder/server
npm start &

cd /usr/src/app/ArcGISExperienceBuilder/client
npm start

# Wait for background processes
wait
