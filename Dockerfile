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
COPY scripts/ssl10_fix_parallel_build.patch /home/scripts/
RUN sh /home/scripts/ssl10_install.sh

# Remove Perl.
COPY scripts/perl_remove.sh /home/scripts/
RUN sh /home/scripts/perl_remove.sh

# Install PyEnv versions.
COPY scripts/pyenv_install.sh /home/scripts/
RUN sh /home/scripts/pyenv_install.sh

# Install Python versions.
COPY scripts/python_install.sh /home/scripts/
RUN sh -l /home/scripts/python_install.sh 2.6.9
RUN sh -l /home/scripts/python_install.sh 2.7.18
RUN sh -l /home/scripts/python_install.sh 3.2.6
RUN sh -l /home/scripts/python_install.sh 3.3.7
RUN sh -l /home/scripts/python_install.sh 3.4.10
RUN sh -l /home/scripts/python_install.sh 3.5.10
RUN sh -l /home/scripts/python_install.sh 3.6.12
RUN sh -l /home/scripts/python_install.sh 3.7.9
RUN sh -l /home/scripts/python_install.sh 3.8.6
RUN sh -l /home/scripts/python_install.sh 3.9.0

# Launch the bash shell with the default profile.
RUN rm -rf /home/scripts
RUN echo "Done!"
CMD ["bash", "-l"]
