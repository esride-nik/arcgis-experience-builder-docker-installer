#!/bin/sh

# Ensure the download and extraction paths are set
DOWNLOAD_PATH=${ROOT_PATH/downloaded:-/usr/src/app/downloaded}
EXB_PATH=${ROOT_PATH:-/usr/src/app/extracted}

# Create the download and extraction directories if they do not exist
mkdir -p $DOWNLOAD_PATH
mkdir -p $EXB_PATH

# Fetch the actual ZIP URL from the JSON
echo "Fetching actual ZIP file URL from JSON..."
ACTUAL_ZIP_URL=$(curl -s $ZIP_URL | jq -r '.url')

# Check if the URL extraction was successful
if [ -z "$ACTUAL_ZIP_URL" ]; then
  echo "Failed to fetch actual ZIP file URL."
  exit 1
fi

# Download and unzip the file if it hasn't been extracted already
if [ ! -d "$EXB_PATH" ] || [ ! "$(ls -A $EXB_PATH)" ]; then
  echo "Downloading ZIP file from $ACTUAL_ZIP_URL..."
  if curl -L $ACTUAL_ZIP_URL -o $DOWNLOAD_PATH/exb.zip; then
    echo "Unzipping file..."
    if unzip $DOWNLOAD_PATH/exb.zip -d $EXB_PATH; then
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
cd $EXB_PATH/server

# Install server dependencies if node_modules does not exist
if [ ! -d "node_modules" ]; then
  echo "Installing server dependencies..."
  npm install
fi

# Set working directory for client
cd $EXB_PATH/client

# Install client dependencies if node_modules does not exist
if [ ! -d "node_modules" ]; then
  echo "Installing client dependencies..."
  npm install
fi

# Clean up the download folder
echo "Cleaning up the download folder..."
rm -rf $DOWNLOAD_PATH

# Start both processes
cd $EXB_PATH/server
npm start &

cd $EXB_PATH/client
npm start

# Wait for background processes
wait