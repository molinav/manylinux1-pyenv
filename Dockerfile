#
# Copyright (C) 2020 Víctor Molina García
# MIT License
#
# Dockerfile to create manylinux1 containers with a minimal installation
# of Python environments 2.6+ and 3.2+ through PyEnv. Prebuilt images
# are available at:
#
#     https://hub.docker.com/r/molinav/manylinux1-pyenv
#
# If not running interactively, you must configure the shell manually
# by calling `. /etc/profile`, which will activate PyEnv and set the
# shell to the installed Python version.
#
# To build a specific image, you need to specify the Python version as
# build argument. For example, to install Python 3.8, you must type:
#
#     docker build --tag manylinux1-pyenv-3.8 . --build-arg version=3.8
#
# A live interactive session can be launched afterwards by typing:
#
#     docker run --name py38-live --rm -it manylinux1-pyenv-3.8
#
FROM centos:5

# Set basic info.
ENV LANG=POSIX
ENV LANGUAGE=POSIX
ENV LC_ALL=POSIX
ENV TZ=UTC
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Repair package system.
COPY scripts/helper /home/scripts/
COPY scripts/helper-yum /home/scripts/
RUN sh /home/scripts/helper yum repair-yum
RUN sh /home/scripts/helper yum repair-curl
RUN sh /home/scripts/helper yum repair-base
RUN sh /home/scripts/helper yum repair-epel

# Install PyEnv and Python version.
COPY scripts/helper-pyenv /home/scripts/
RUN sh /home/scripts/helper pyenv configure

# Upgrade basic Python libraries.
ARG version
COPY scripts/helper-perl /home/scripts/
COPY scripts/helper-openssl /home/scripts/
RUN sh /home/scripts/helper pyenv install -v "$version"
COPY scripts/requirements /home/scripts/requirements
RUN sh /home/scripts/helper pyenv upgrade -v "$version"

# Add manylinux1 allowed packages.
RUN sh /home/scripts/helper yum repair-manylinux1

# Launch the bash shell with the default profile.
RUN rm -rf /home/scripts
CMD ["bash", "-l"]
