# Use the official Node.js image as a base
FROM node:20

# Install curl, unzip, and jq
RUN apt-get update && apt-get install -y curl unzip jq && rm -rf /var/lib/apt/lists/*

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

# Run the initialization script
CMD ["/usr/src/app/init.sh"]