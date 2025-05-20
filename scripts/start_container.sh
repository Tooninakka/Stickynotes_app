#!/bin/bash
set -e

# Pull the Docker image from Docker Hub
docker pull tooninakka97/stickynotes_app

# Run the Docker image as a container
echo
docker run -d -p 7000:7000 tooninakka97/stickynotes_app