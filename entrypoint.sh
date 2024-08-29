#!/bin/sh

# Ensure that the target directories exist
mkdir -p /usr/src/app/client

echo "Contents of /usr/src/app/client:"
cd /usr/src/app/client
ls

echo "Check if it's empty"
if [ -z \"$(ls -A /usr/src/app/client)\" ]; then 
    echo "..yeah it's empty! Copying all the files.. be patient, it's gonna take a while.."
    cp -r /usr/src/app/ArcGISExperienceBuilder/client_template/* /usr/src/app/client
fi

# Continue with the default command
echo "Starting application..."
exec "$@"
