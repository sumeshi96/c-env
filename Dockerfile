FROM ubuntu:22.10

RUN apt-get update && \
    apt-get install -y git build-essential cmake clang nano gdb