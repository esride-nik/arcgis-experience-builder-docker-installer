# Use the official Node.js image as a base
FROM node:20

# Set the working directory for the server
WORKDIR /usr/src/app/server

# Copy server package.json and package-lock.json
COPY server/package*.json ./

# Set the working directory for the client
WORKDIR /usr/src/app/client

# Copy client package.json and package-lock.json
COPY client/package*.json ./

# Copy the rest of the application files
COPY . /usr/src/app

# Copy initialization script
COPY init.sh /usr/src/app/init.sh
RUN chmod +x /usr/src/app/init.sh

# Expose the ports
EXPOSE 3000
EXPOSE 3001

# Run the initialization script
CMD ["/usr/src/app/init.sh"]
