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

| dranch | main | exb_included | dependencies_included |
| - | - | - | - |
| ExB | downloads and unzips ExB | has ExB included, unzipped | has ExB included, unzipped |
| dependencies | installs dependencies on first run to local drive | installs dependencies on first run to local drive | has node_modules included |
| project files | client and apps folder mapped to local drive | client and apps folder mapped to local drive | drive |
| runtime | runs client and server on ports 3000 and 3001 | runs client and server on ports 3000 and 3001 | 3001 |
| image size | 1.09 GB (based on node:20 image) | ? | ? |
| initial build time* | 25 min | ? | ? |

<small>* on my machine ;)</small>

## ToDos

* create alternative containers
* expose webpack and tsconfig files
* monitor build time
* export container file to compare size

## How to use

* Edit ``.env`` file to enter your local folders.
* Run ``docker-compose build`` (not necessary when running container from DockerHub) and ``docker-compose up`` here to run the container.
