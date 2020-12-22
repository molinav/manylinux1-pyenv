FROM quay.io/pypa/manylinux1_x86_64

# Set basic info.
ENV LANG=POSIX
ENV LANGUAGE=POSIX
ENV LC_ALL=POSIX
ENV TZ=UTC
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Copy helper scripts.
COPY scripts /home/scripts

# Install base dependencies.
RUN sh /home/scripts/base_install.sh

# Install Perl to build OpenSSL.
RUN sh /home/scripts/perl_install.sh

# Install OpenSSL 1.0.2.
RUN sh /home/scripts/ssl10_install.sh

# Launch the bash shell with the default profile.
RUN rm -rf /home/scripts
RUN echo "Done!"
CMD ["bash", "-l"]
