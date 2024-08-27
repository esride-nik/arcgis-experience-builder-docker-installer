<style>
  table th {
    background-color: #555;
  }
  table td:first-child {
    background-color: #555;
    font-weight:bold;
  }
</style>

# Docker template for ArcGIS Experience Builder (ExB)

This repo contains some approaches to put ExB into a docker container. 

## Motivation

As a developer, I want to install my dev environment hassle-free and nicely separated from everything else going on on my machine, including the chance of trace-free removal. If you can't or don't want to install anything at all, [that's a different story](https://code.visualstudio.com/docs/devcontainers/containers). But assuming that basic tools like the IDE (I'm using VS Code) and Git are installed on the machine), I still need to install Node.JS on my machine, following the [default instructions](https://developers.arcgis.com/experience-builder/guide/install-guide/).

### The Node version
Why can a local Node installation become a problem? The [recommended Node version](https://developers.arcgis.com/experience-builder/guide/release-versions/) differs over the course of progressing ExB versions. ExB and the Jimu Framework keep introducing quite a number of breaking changes with their version updates, so it might be necessary to use different Node versions while maintaining your projects. This is especially the case if you're developing custom widgets to be used within the ExB version, that is embedded in your ArcGIS Enterprise (AGE) installation. Each [AGE update brings a new ExB version](https://developers.arcgis.com/experience-builder/guide/release-versions/) and with it the need to migrate your custom widgets, which should always be developed for and tested with the ExB version they're intended to be used in.

### The installation process
The rest of the installation process uses ``npm`` to install third-party packages and puts everything in a folder on your hard drive. Thus, deletion of these components is trace-free. However, you still need to run ``npm install`` in two different folders manually before you can run the software.

### The development runtime
While developing, you need to run two processes in parallel: The ``server`` process gives you the backend of your WYSIWYG application. Here you pull in widgets and data sources and connect them to each other and you take care of your layout. The ``client`` process runs the TypeScript compiler and Webpack to bundle your widget so that the local server can make use of your custom code. It doesn't hurt much - you need to keep two consoles open running both processes, which you can do manually or create your own startup script. You can also run the server process as a task on OS level. I usually keep both consoles open within VS Code and open up a third one to do ad-hoc things like firing Git commands. But still, from time to time you mix things up and having the necessary processes running in a container without open consoles just feels more fluffy.


## How it works

I won't bundle ExB and all third-party sources in a container to put it on Docker hub. First of all, it would be a quite large container and second, that would count as redistribution of software that I don't own and I would surely run into licencing issues.

Instead, this repo provides
1. an installation script to run <b>the installation process</b> in just one step
2. a ``Dockerfile`` and ``docker-compose.yml`` to build the container that includes <b>the Node version</b> and starts <b>the development runtime</b>, exposed on pre-defined ports for http and https. While the standard ports for ExB are 3000 for http and 3001 for https, the container is exposing ports 4000 and 4001 by default to avoid conflicts with manual installations.

## How to use

* Run ``init.sh`` in an admin console
* Edit ``.env`` file to enter your local folders.
* Run ``docker-compose build`` (not necessary when running container from DockerHub) and ``docker-compose up`` or ``docker run <imageId>`` here to run the container.


## Current status

### ExB version 1.15 using Node 20

The container uses ExB version 1.15 and the [offically recommended Node version 20](https://developers.arcgis.com/experience-builder/guide/release-versions/) on the official [``node:20-slim``](https://hub.docker.com/_/node) image.

## Different approaches

| branch | main | nodeSlimImage |
| - | - | - |
| Node image | node:20 | node:20-slim | 
| project files | client and apps folder mapped to local drive | client and apps folder mapped to local drive |
| webpack-config & tsconfig | accessible because client folder mapped to local drive | accessible because client folder mapped to local drive |
| runtime | runs client and server on ports 3000 and 3001 | runs client and server on ports 3000 and 3001 |
| image size | 1.09 GB (based on node:20 image) | 215.8 MB |
| initial startup time* | 25 min | 21.5 min until unzipped + 4.5 min for installing node_modules |

<small>* running ``docker-compose up`` on my machine ;)</small>

### Side note

These scripts have been generated with the help of AI tools.