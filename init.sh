#!/bin/sh

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
cd /usr/src/app/server

# Install server dependencies if node_modules does not exist
if [ ! -d "node_modules" ]; then
  echo "Installing server dependencies..."
  npm ci
fi

# Set working directory for client
cd /usr/src/app/client

# Install client dependencies if node_modules does not exist
if [ ! -d "node_modules" ]; then
  echo "Installing client dependencies..."
  npm ci
fi

# Start both processes
cd /usr/src/app/server
npm start &

cd /usr/src/app/client
npm start

# Wait for background processes
wait
