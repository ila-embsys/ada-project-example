FROM zephyrada/zephyr-sdk-ada-arm:v0.2.0-alpha

# Install custom tools, runtimes, etc.
# For example "bastet", a command-line tetris clone:
# RUN brew install bastet
#
# More information: https://www.gitpod.io/docs/config-docker/

USER root
RUN apt update && apt install gprbuild
USER gitpod
