#!/bin/sh

# Ensure the download and extraction paths are set
DOWNLOAD_PATH=${DOWNLOAD_PATH:-/usr/src/app/downloaded}
EXB_PATH=${EXB_PATH:-/usr/src/app/extracted}

# Create the download and extraction directories if they do not exist
mkdir -p $DOWNLOAD_PATH
mkdir -p $EXB_PATH

# Download and unzip the file if it hasn't been extracted already
if [ ! -d "$EXB_PATH" ] || [ ! "$(ls -A $EXB_PATH)" ]; then
  echo "Downloading ZIP file..."
  if curl -L $ZIP_URL -o $DOWNLOAD_PATH/downloaded.zip; then
    echo "Unzipping file..."
    if unzip $DOWNLOAD_PATH/downloaded.zip -d $EXB_PATH; then
      echo "Unzipping completed."
    else
      echo "Failed to unzip file."
      exit 1
    fi
  else
    echo "Failed to download ZIP file."
    exit 1
  fi
else
  echo "Files already extracted."
fi

# Install dependencies and start server

# Set working directory for server
cd /usr/src/app/server

# Install server dependencies if node_modules does not exist
if [ ! -d "node_modules" ]; then
  echo "Installing server dependencies..."
  npm install
fi

# Set working directory for client
cd /usr/src/app/client

# Install client dependencies if node_modules does not exist
if [ ! -d "node_modules" ]; then
  echo "Installing client dependencies..."
  npm install
fi

# Start both processes
cd /usr/src/app/server
npm start &

cd /usr/src/app/client
npm start

# Wait for background processes
wait