FROM quay.io/pypa/manylinux1_x86_64

# Set basic info.
ENV LANG=POSIX
ENV LANGUAGE=POSIX
ENV LC_ALL=POSIX
ENV TZ=UTC
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Install base dependencies.
COPY scripts/base_install.sh /home/scripts/
RUN sh /home/scripts/base_install.sh

# Install Perl to build OpenSSL.
COPY scripts/perl_install.sh /home/scripts/
RUN sh /home/scripts/perl_install.sh

# Install OpenSSL 1.0.2.
COPY scripts/ssl10_install.sh /home/scripts/
COPY scripts/openssl-1.0.2-fix_parallel_build-1.patch /home/scripts/
RUN sh /home/scripts/ssl10_install.sh

# Launch the bash shell with the default profile.
RUN rm -rf /home/scripts
RUN echo "Done!"
CMD ["bash", "-l"]
