# Homework Environment

This repository contains the environment that should be used for developing your homework solutions and where all tests on your solutions will be run.  It contains files for creating and setting up a docker container where your code and the tests can run.  You will have two types of programming assignments during the semester.  The first type are standard C programming assignment that utilize a linux environment with the C standard library and POSIX.  The second type are programming assignments working on the Unix-like teaching operating system, xv6.  The xv6 OS runs inside the qemu machine emulator which runs inside the docker container.

Follow the instructions below to install docker and setup the container.  After the container is running, you will have a directory, `cs537-projects/`, where you can clone the assignment starting repositories.  You can use your host machine to work on your solution code, and then compile and run your code and the provided tests from inside the docker container.  The `cs537-projects` directory will be accessible from your host machine and from within the docker container.

## Install docker

Follow the instructions on Docker's official website to [install Docker](https://docs.docker.com/engine/install/)(or Docker Desktop) on your machine. Make sure you install Docker Compose as well.

To verify if Docker is installed correctly, run:
```bash
docker run hello-world
```

If the installation is successful, you should see the following message:
```
Hello from Docker!
This message shows that your installation appears to be working correctly.
...
```

To verify if Docker compose is installed, run:
```bash
docker compose version
```
You should see something similar to the following:
```
Docker Compose version v...
```

NOTE: Docker is already installed on CSL machines. To start the service on CSL machine, follow the instructions on [this page](https://csl.cs.wisc.edu/docs/csl/docker/).

For an introduction to Docker, you can look at this [lecture on Wed, Sep 13](https://tyler.caraza-harter.com/cs544/f23/schedule.html) 


## Setup a Container for assignments

Clone this repository and navigate to the directory where the `docker-compose.yml` and `Dockerfile` are located.

### Build the Docker Image locally

Run the following command to build the Docker image (don't forget the trailing dot): 
```bash
docker build -t cs537-v1 --platform=linux/amd64 .
```

It should create a Docker image named `cs537-v1`. You can verify the image exists by running: 
```bash
docker images
```   

### Bring up the Docker Compose Environment

Start the container with Docker Compose by running:
```bash
docker compose up -d
```

This will start a container named `cs537-projects`. You can verify it is running with the command: 
```bash
docker ps -a
```

You should also see a new directory `cs537-projects/` in the current folder. This directory is mounted to `/cs537-projects` inside the container, meaning any changes you make in `./cs537-projects` on your host machine will be reflected in the container's `/cs537-projects` directory.  This folder is where you should do all of your assignments for the course.  Individual assignment repositories should be cloned into this directory.

### Access the container

To access the container, run:
```bash
docker exec -it cs537-projects bash
```

It opens a bash session inside the container. You can run this command multiple times to open multiple bash sessions in the same container.  When you are finished with your bash session inside the container, simply `exit`.

### Stop the container

Once you're done using the container, you can stop it with:
```bash
docker stop cs537-projects
```

Stopping the container does not delete it or the work inside.


## Reusing the container 

Once the docker image and the container are created, it will remain saved on your machine. So, the next time you want to use this container, follow these steps:

1. **Start the container**
    ```bash 
    docker start cs537-projects
    ```

2. **Access the container with bash**
    ```bash
    docker exec -it cs537-projects bash
    ```

3.  **Stop the container** (after exiting the bash session)
    ```bash
    docker stop cs537-projects
    ```
