#! /bin/sh

set -e

python_version=$1
python_xyz=$(pyenv install --list | grep -Ee " ${python_version}.[0-9]+$"     \
             | tail -n1 | tr -d " ")

# Define OpenSSL linking.
openssl_prefix=/opt/ssl/1.0.2
export CFLAGS="-I${openssl_prefix}/include"
export LDFLAGS="-L${openssl_prefix}/lib"

# Install the specified Python version.
eval "$(pyenv init -)"
pyenv install "$python_xyz"
mv $PYENV_ROOT/versions/${python_xyz} $PYENV_ROOT/versions/${python_version}
