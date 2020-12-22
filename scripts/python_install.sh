#! /bin/sh

set -e

python_version=$1

# Define OpenSSL linking.
openssl_prefix=/opt/ssl/1.0.2
export CFLAGS="-I${openssl_prefix}/include"
export LDFLAGS="-L${openssl_prefix}/lib"

# Install the specified Python version.
eval "$(pyenv init -)"
pyenv install "$python_version"
