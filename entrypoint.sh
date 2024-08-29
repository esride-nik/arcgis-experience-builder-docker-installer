#!/bin/sh

# Set working directory for client
cd /usr/src/app/ArcGISExperienceBuilder/client

# Check if tsconfig.json exists in the user’s mapped volume; if not, copy it from the container
if [ ! -f /usr/src/app/client_tsconfig/tsconfig.json ]; then
    echo "Copying tsconfig.json to user directory..."
    cp tsconfig.json /usr/src/app/client_tsconfig/
fi

# Check if webpack directory exists in the user’s mapped volume; if not, copy it from the container
if [ ! -d /usr/src/app/client_webpack ]; then
    echo "Copying webpack directory to user directory..."
    cp -r webpack /usr/src/app/client_webpack
fi

# Continue with the default command
exec "$@"
