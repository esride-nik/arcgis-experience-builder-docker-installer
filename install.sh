#!/bin/bash

# Load environment variables from .env file
set -o allexport; source .env; set +o allexport

# Set download and extraction paths
JSON_URL="${EXB_URL}?f=json&folder=${EXB_URL_FOLDER}"
DOWNLOAD_PATH="${INSTALL_PATH}/downloaded"
EXTRACT_PATH="${INSTALL_PATH}/ArcGISExperienceBuilder"

echo "DOWNLOAD_PATH is set to: $DOWNLOAD_PATH"
echo "EXTRACT_PATH is set to: $EXTRACT_PATH"

# Create the download and extraction directories if they do not exist
mkdir -p "$DOWNLOAD_PATH"
mkdir -p "$EXTRACT_PATH"

# Fetch the actual ZIP URL from the JSON
echo "Fetching ZIP file URL from URL $JSON_URL"
ZIP_URL=$(curl -s $JSON_URL | jq -r '.url')

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
    if unzip "$DOWNLOAD_PATH/exb.zip" -d "$EXTRACT_PATH"; then
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
fi

# Install client dependencies if node_modules does not exist
cd "$EXTRACT_PATH/client"
if [ ! -d "node_modules" ]; then
  echo "Installing client dependencies..."
  npm install
  npm audit fix
fi

# Clean up the download folder
echo "Cleaning up the download folder..."
rm -rf $DOWNLOAD_PATH

echo "Installation completed."