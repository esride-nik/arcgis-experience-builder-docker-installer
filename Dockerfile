# Use the official Node.js slim image as a base
FROM node:20-slim

# Copy the installed ArcGISExperienceBuilder files into the container
COPY ./ArcGISExperienceBuilder/client /usr/src/app/ArcGISExperienceBuilder/client_template
COPY ./ArcGISExperienceBuilder/server /usr/src/app/ArcGISExperienceBuilder/server
COPY ./ArcGISExperienceBuilder/*.txt ./ArcGISExperienceBuilder/*.json /usr/src/app/ArcGISExperienceBuilder/
RUN mkdir -p /usr/src/app/ArcGISExperienceBuilder/client

# These ports are exposed in the yml file - this is only for documentation
EXPOSE 4000
EXPOSE 4001

# Necessary volumes are also exposed in the yml file

# Copy initialization script
COPY ./entrypoint.sh /usr/src/app/entrypoint.sh
RUN chmod +x /usr/src/app/entrypoint.sh

# Use ENTRYPOINT for initializing the container
ENTRYPOINT ["bash", "/usr/src/app/entrypoint.sh"]

# Start both processes (server and client)
CMD ["bash", "-c", "cd /usr/src/app/ArcGISExperienceBuilder/server && npm start & cd /usr/src/app/ArcGISExperienceBuilder/client && npm start"]