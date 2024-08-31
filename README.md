<style>
  table th {
    background-color: #555;
  }
  table td:first-child {
    background-color: #555;
    font-weight:bold;
  }
</style>

# Running ArcGIS Experience Builder on Docker

ArcGIS Experience Builder (ExB) is Esri's WYSIWYG Editor for Web GIS applications. The developer edition (DevEd) enables developers to create their own custom widgets and themes. The installation routine requires a couple of steps that I tried to wrap in an easy installation routine and put in a container.

## Motivation

As a developer, I want to install my dev environment hassle-free and nicely separated from everything else going on on my machine, including the chance of trace-free removal. If you can't or don't want to install anything at all, [that's a different story](https://code.visualstudio.com/docs/devcontainers/containers). But assuming that basic tools like the IDE (I'm using VS Code) and Git are installed on the machine), I still need to install Node.JS on my machine, following the [default instructions](https://developers.arcgis.com/experience-builder/guide/install-guide/) for installing ExB DevEd.

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

### Installation

* Run ``./install.sh``
* Edit ``.env`` file to enter your local folders.
* Edit ``server/package.json`` to use ports 4000 and 4001 in the start script:
  ```
  "start": "cross-env EXB_HTTP_PORT=4000 EXB_HTTPS_PORT=4001 NODE_ENV=production node src/server",
  ```
* Run ``docker-compose build`` to build the container.
* To share with your peers, 
  * export the container by running ``docker save -o <image-file-name>.tar <image-name>:tag``, 
  * modify your ``docker-compose.yml`` file by commenting out the ``build: .`` line, uncommenting the following line and filling in your exported image name and tag: 
    ```
    # image: <image-file-name>:<tag>  # Reference the pre-built image
    ```
  * deliver ``.tar`` file and the ``docker-compose.yml``, as this file contains the volume mappings etc.
  * What, you don't know your image name and tag? Run ``docker images`` on the console to get a nice list.

### Run it and develop
* If you got a ``.tar`` and a ``docker-compose.yml`` file with an image and you want to import it, run ``docker load -i <image-file-name>.tar``.
* Run ``docker-compose up`` to run the container. This should start the server process and the compiler / bundler process on client side. <ul>Please note: Be patient at the first start. All files from the standard client folder are gonna be copied from the container into a mapped folder on your hard drive, which points to ``<your_repository_folder>/client``! This step is gonna be skipped if this folder is not empty.</ul>
* If you're using ``web-extension-repos`` (which you should) to version control your only code, just clone them into the client folder as always. Try [my samples repo](https://github.com/esride-nik/ExB-workshop) if you don't believe me! To work with it, just keep using Git in these repos as you like.


## Current status

### ExB version 1.15 using Node 20

The container uses ExB version 1.15 and the [offically recommended Node version 20](https://developers.arcgis.com/experience-builder/guide/release-versions/) on the official [``node:20-slim``](https://hub.docker.com/_/node) image.

### TODOs

* include editing ``server/package.json`` in ``install.sh``
* include the ports in the ``.env`` file to make them configurable
* script to export image to sub-folder and add modified docker-compose.yml

### Side note

These scripts have been generated with the help of AI tools.