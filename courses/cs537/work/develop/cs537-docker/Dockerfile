# FROM --platform=linux/amd64 ubuntu:22.04
FROM ubuntu:22.04
# COPY xv6.tar.gz /
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=America/Chicago
RUN apt-get update && apt-get install -y build-essential qemu qemu-system-x86 gdb git expect tzdata gawk valgrind pkg-config libfuse-dev libfuse2 vim nano fuse attr
RUN apt-get update && apt-get install -y --no-install-recommends \
      python3-pip openssh-client \
    && rm -rf /var/lib/apt/lists/*

# python-gitlab for API access
RUN pip3 install --no-cache-dir python-gitlab