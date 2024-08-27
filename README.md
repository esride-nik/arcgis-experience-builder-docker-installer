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

## Choices

### Node version

The container works work ExB version 1.15 and the [offically recommended Node version 20](https://developers.arcgis.com/experience-builder/guide/release-versions/).

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

## ToDos

* create alternative containers
* expose webpack and tsconfig files
* monitor build time
* export container file to compare size

## How to use

* Edit ``.env`` file to enter your local folders.
* Run ``docker-compose build`` (not necessary when running container from DockerHub) and ``docker-compose up`` or ``docker run <imageId>`` here to run the container.
