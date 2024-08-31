#!/bin/sh

# Ensure that the target directories exist
mkdir -p /usr/src/app/ArcGISExperienceBuilder/client
chmod -R 755 ./client

# echo "Copying all the files.. be patient if this is the first start, it's gonna take a while.."
# cp -r -u /usr/src/app/ArcGISExperienceBuilder/client_template/* /usr/src/app/client

echo "Check if client folder is empty..."
# if [ -z \"$(ls -A /usr/src/app/client)\" ]; then 
if [ "$(ls -A /usr/src/app/ArcGISExperienceBuilder/client 2>/dev/null | wc -l)" -eq 0 ]; then
    echo "..yeah it's empty! Copying all the files.. be patient, it's gonna take a while.."
    cp -r /usr/src/app/ArcGISExperienceBuilder/client_template/* /usr/src/app/ArcGISExperienceBuilder/client; else
    echo "..it's not empty, skipping the copy."
fi

# Need this as a workaround, otherwise the CMD in the Dockerfile will fail
cd /

# Continue with the default command
echo "Starting application..."
exec "$@"
