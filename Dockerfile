# Use the official Node.js slim image as a base
FROM node:20-slim

# Set the working directory
WORKDIR /usr/src/app

# Copy the installed ArcGISExperienceBuilder files into the container
COPY ./ArcGISExperienceBuilder /usr/src/app/ArcGISExperienceBuilder

# Expose the ports
EXPOSE 4000
EXPOSE 4001

# Set up volumes to expose specific folders
VOLUME /usr/src/app/ArcGISExperienceBuilder/client
VOLUME /usr/src/app/ArcGISExperienceBuilder/server/public/apps

# Set the working directory to server
WORKDIR /usr/src/app/ArcGISExperienceBuilder/server

# Start both processes (server and client)
CMD ["bash", "-c", "npm start & cd ../client && npm start"]