# Use the official Node.js slim image as a base
FROM node:20-slim

# Install bash and other necessary tools
RUN apt-get update && apt-get install -y bash curl unzip jq && rm -rf /var/lib/apt/lists/*

# Set the working directory
WORKDIR /usr/src/app

# Copy the rest of the application files
COPY . /usr/src/app

# Copy initialization script
COPY init.sh /usr/src/app/init.sh
RUN chmod +x /usr/src/app/init.sh

# Expose the ports
EXPOSE 3000
EXPOSE 3001

# Run the initialization script using bash
CMD ["/bin/bash", "/usr/src/app/init.sh"]