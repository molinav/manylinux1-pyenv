#! /bin/sh

set -e

python_version=$1
python_version_xyz=$(pyenv install --list                                     \
                     | grep -Ee " ${python_version}.[0-9]+$"                  \
                     | tail -n1 | tr -d " ")

pyenv_folder_xy=$PYENV_ROOT/versions/${python_version}
pyenv_folder_xyz=$PYENV_ROOT/versions/${python_version_xyz}

# Define OpenSSL linking.
openssl_prefix=/opt/openssl/1.0.2

# Install the specified Python version.
eval "$(pyenv init -)"
ln -s $openssl_prefix /usr/local/ssl
pyenv install "${python_version_xyz}"
rm -f /usr/local/ssl
ln -s ${pyenv_folder_xyz} ${pyenv_folder_xy}

# Update profile to start this Python shell as default.
rc3=/etc/profile.d/03-set-pyenv.sh
echo "pyenv shell ${python_version}" >> $rc3
echo "" >> $rc3

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

# Remove test folders and byte-compiled files.
rm -f ${pyenv_folder}/lib/libpython*.a
rm -rf ${pyenv_folder}/**/test
find ${pyenv_folder}/ -noleaf -type f -name "*.py[co]" -exec rm -f {} \;
