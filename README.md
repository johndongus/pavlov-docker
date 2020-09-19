

## Installation (Ubuntu)
This is only been tested for docker on linux
```bash
# Update package sources
$ apt-get update

# Install git & docker
$ apt-get install docker docker.io git

# Clone pavlov-docker repo
$ git clone https://hostname/YOUR-USERNAME/YOUR-REPOSITORY

# Navigate to pavlov-docker folder created by git
$ cd ./pavlov-docker/
```


## Configuration / Building
Before Building please configure the files accordingly, these files must be within the same folder as *Dockerfile*
* Game.ini - Pavlov configuration file
* RconSettings.txt - Password & Port for rcon
* mods.txt - List of id's of admins
* start.sh - Start file for container, server port can be changed inside

```bash
# Build docker container
$ docker build --tag="pav:latest"
```


## Usage

```bash
# Running container
$ docker run -p7777 -p9100 --name pavlovserver pav

# Killing container
$ docker kill pavlovserver
```
