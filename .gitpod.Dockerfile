FROM zephyrada/zephyr-sdk-ada-arm:v0.2.0-alpha

# Install custom tools, runtimes, etc.
# For example "bastet", a command-line tetris clone:
# RUN brew install bastet
#
# More information: https://www.gitpod.io/docs/config-docker/

USER root
RUN apt-get update && apt-get install -y \
    gprbuild \
    gpg \
    && wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null \
    | gpg --dearmor - \
    | sudo tee /usr/share/keyrings/kitware-archive-keyring.gpg >/dev/null \
    && echo 'deb [signed-by=/usr/share/keyrings/kitware-archive-keyring.gpg] https://apt.kitware.com/ubuntu/ focal main' \
    | sudo tee /etc/apt/sources.list.d/kitware.list >/dev/null \
    && apt-get update && apt-get install -y cmake

# restore ada modules
RUN git clone https://github.com/zephyr-ada/cmake-ada.git && \
    cd cmake-ada && \
    cmake -P install.cmake && \
    cd .. && \
    rm -rf cmake-ada
    
USER $USERNAME
