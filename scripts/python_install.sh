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
ln -s $PYENV_ROOT/versions/${python_xyz} $PYENV_ROOT/versions/${python_version}

# Upgrade pip, setuptools and wheel.
pyenv shell ${python_version}
if [ "$python_version" = "2.6" ]; then
    pip install --no-cache-dir --upgrade "pip < 10"
    pip install --no-cache-dir --upgrade "wheel < 0.30"
    pip install --no-cache-dir --upgrade "setuptools < 37"
elif [ "$python_version" = "2.7" ]; then
    pip install --no-cache-dir --upgrade "pip < 21"
    pip install --no-cache-dir --upgrade "wheel < 0.36"
    pip install --no-cache-dir --upgrade "setuptools < 45"
elif [ "$python_version" = "3.2" ]; then
    pip install --no-cache-dir --upgrade "pip < 7.1.1"
    pip install --no-cache-dir --upgrade "wheel < 0.32"
    pip install --no-cache-dir --upgrade "setuptools < 30"
elif [ "$python_version" = "3.3" ]; then
    pip install --no-cache-dir --upgrade "pip < 18"
    pip install --no-cache-dir --upgrade "wheel < 0.30"
    pip install --no-cache-dir --upgrade "setuptools < 40"
elif [ "$python_version" = "3.4" ]; then
    pip install --no-cache-dir --upgrade "pip < 20"
    pip install --no-cache-dir --upgrade "wheel < 0.34"
    pip install --no-cache-dir --upgrade "setuptools < 44"
else
    pip install --no-cache-dir --upgrade "pip < 21"
    pip install --no-cache-dir --upgrade "wheel < 0.36"
    pip install --no-cache-dir --upgrade "setuptools < 50"
fi
pyenv shell system

# Remove byte-compiled files.
find $PYENV_ROOT/versions/${python_version}/                                  \
    -type f -name "*.py[co]" -exec rm {} \;
