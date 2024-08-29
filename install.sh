#!/bin/bash

# Load environment variables from .env file
set -o allexport; source .env; set +o allexport

# Set download and extraction paths
JSON_URL="${EXB_URL}?f=json&folder=${EXB_URL_FOLDER}"
DOWNLOAD_PATH="./download"
EXTRACT_PATH="./ArcGISExperienceBuilder"

# Create the download and extraction directories if they do not exist
mkdir -p "$DOWNLOAD_PATH"

# Fetch the actual ZIP URL from the JSON
echo "Fetching ZIP file URL from JSON at $JSON_URL"
ZIP_URL=$(curl -s $JSON_URL | grep -o '"url":"[^"]*' | cut -d'"' -f4)

echo "ZIP_URL is set to: $ZIP_URL"

# Check if download was successful
if [ -z "$ZIP_URL" ]; then
  echo "Failed to fetch actual ZIP file URL."
  exit 1
fi

# Download and unzip the file if it hasn't been extracted already
if [ ! -d "$EXTRACT_PATH" ] || [ ! "$(ls -A $EXTRACT_PATH)" ]; then
  echo "Downloading ZIP file from $ZIP_URL..."
  if curl -L "$ZIP_URL" -o "$DOWNLOAD_PATH/exb.zip"; then
    echo "Unzipping file..."
    if unzip "$DOWNLOAD_PATH/exb.zip" -d "$INSTALL_PATH"; then
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

# Install dependencies

# Install server dependencies if node_modules does not exist
cd "$EXTRACT_PATH/server"
if [ ! -d "node_modules" ]; then
  echo "Installing server dependencies..."
  npm install
  npm audit fix
else
  echo "Server dependencies already installed."
fi
cd "../../"

# Wait for background processes to finish
wait

# Install client dependencies if node_modules does not exist
cd "$EXTRACT_PATH/client"
if [ ! -d "node_modules" ]; then
  echo "Installing client dependencies..."
  npm install
  npm audit fix
else
  echo "Client dependencies already installed."
fi
cd "../../"

# Clean up the download folder
echo "Cleaning up the download folder..."
rm -rf $DOWNLOAD_PATH

# Wait for background processes to finish
wait

echo "Installation completed."