# Introduction

Docker image with Tanaguru A11y tester preinstalled.

# Details
## Install instructions:

    docker pull varkal/tanaguru

## Usage instructions:

    docker pull varkal/tanaguru
    docker run -d -t -p 8080:8080 --cap-add SYS_PTRACE varkal/tanaguru /bin/bash

Wait several seconds for tomcat7 start.

You should be then able to point your browser at : `http//localhost:8080/` (on Linux) or `http://boot.2.docker.ip:8080/` (if you are on Windows or Mac OSX)

The default account is : tanaguru@email.com / tanaguru

# Build Tanaguru docker image

The work is still in progress, as @mfaure is making some minor adjustments on the Tanaguru side to add the possibility to choose the database remote host in CLI, so we could implement microservice pattern with low coupling (see this discussion for details http://discuss.tanaguru.org/t/image-docker-installation-tanaguru-mysql/68)
