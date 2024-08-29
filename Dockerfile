# Use the official Node.js slim image as a base
FROM node:20-slim

# Set the working directory inside the container
WORKDIR /usr/src/app

# Copy the installed ArcGISExperienceBuilder files into the container
COPY ./ArcGISExperienceBuilder /usr/src/app/ArcGISExperienceBuilder

# These ports are exposed in the yml file - this is only for documentation
EXPOSE 4000
EXPOSE 4001

# Necessary volumes are also exposed in the yml file

# Copy the entry-point script into the container
COPY entrypoint.sh /usr/src/app/entrypoint.sh
RUN chmod +x /usr/src/app/entrypoint.sh

# Set the entry-point script to run before the main CMD
ENTRYPOINT ["/usr/src/app/entrypoint.sh"]

# Start both processes (server and client)
CMD ["bash", "-c", "cd /usr/src/app/ArcGISExperienceBuilder/server && npm start & cd ../client && npm start"]