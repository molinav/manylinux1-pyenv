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
FROM quay.io/pypa/manylinux1_x86_64
ARG version

# Set basic info.
ENV LANG=POSIX
ENV LANGUAGE=POSIX
ENV LC_ALL=POSIX
ENV TZ=UTC
ENV SSL_CERT_FILE=
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Remove original Python installations.
RUN rm -rf /opt/python /opt/_internal /tmp/*

# Install PyEnv and Python version.
COPY scripts/perl-helper /home/scripts/
COPY scripts/openssl-helper /home/scripts/
COPY scripts/pyenv-helper /home/scripts/
RUN sh /home/scripts/pyenv-helper configure
RUN sh /home/scripts/pyenv-helper install --version "$version"

# Upgrade basic Python libraries.
COPY scripts/requirements /home/scripts/requirements
RUN sh /home/scripts/pyenv-helper upgrade --version "$version"

# Launch the bash shell with the default profile.
RUN rm -rf /home/scripts
RUN echo "Done!"
CMD ["bash", "-l"]
