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

# Install base dependencies.
COPY scripts/base_install.sh /home/scripts/
RUN sh /home/scripts/base_install.sh

# Install OpenSSL 1.0.2.
COPY scripts/perl_install.sh /home/scripts/
COPY scripts/perl_remove.sh /home/scripts/
COPY scripts/ssl10_install.sh /home/scripts/
COPY scripts/ssl10_fix_parallel_build.patch /home/scripts/
RUN sh /home/scripts/ssl10_install.sh

# Install PyEnv.
COPY scripts/pyenv_install.sh /home/scripts/
RUN sh /home/scripts/pyenv_install.sh

# Install Python versions.
COPY scripts/python_install.sh /home/scripts/
RUN sh -l /home/scripts/python_install.sh $version

# Remove base dependencies.
COPY scripts/base_remove.sh /home/scripts/
RUN sh /home/scripts/base_remove.sh

# Launch the bash shell with the default profile.
RUN rm -rf /home/scripts
RUN echo "Done!"
CMD ["bash", "-l"]
