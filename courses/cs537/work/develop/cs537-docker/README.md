# Homework Environment

This repository contains the environment that should be used for developing your homework solutions and where all tests on your solutions will be run.  It contains files for creating and setting up a docker container where your code and the tests can run.  You will have two types of programming assignments during the semester.  The first type are standard C programming assignment that utilize a linux environment with the C standard library and POSIX.  The second type are programming assignments working on the Unix-like teaching operating system, xv6.  The xv6 OS runs inside the qemu machine emulator which runs inside the docker container.

Follow the instructions below to install docker and setup the container.  After the container is running, you will have a directory, `cs537-projects/`, where you can clone the assignment starting repositories.  You can use your host machine to work on your solution code, and then compile and run your code and the provided tests from inside the docker container.  The `cs537-projects` directory will be accessible from your host machine and from within the docker container.

# Install and Bring Up the Container
[Linux](linux.md)
[Windows](windows.md)