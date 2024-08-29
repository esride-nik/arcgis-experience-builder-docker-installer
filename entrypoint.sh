#!/bin/sh

# Set working directory for client
cd /usr/src/app/ArcGISExperienceBuilder/client

# Ensure that the target directories exist
mkdir -p /usr/src/app/client

# Check if tsconfig.json exists in the user’s mapped volume; if not, copy it from the container
if [ ! -f /usr/src/app/client/tsconfig.json ]; then
    echo "Copying tsconfig.json to user directory..."
    cp ./tsconfig.json /usr/src/app/client/
fi

# Check if webpack directory exists in the user’s mapped volume; if not, copy it from the container
if [ ! -d /usr/src/app/client/webpack ]; then
    echo "Copying webpack directory to user directory..."
    cp -r ./webpack /usr/src/app/client/
fi

# Continue with the default command
echo "Starting application..."
# exec "$@"
