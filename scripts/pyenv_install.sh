#! /bin/sh

PYENV_ROOT=/opt/pyenv
PATH=$PYENV_ROOT/bin:$PATH

# Download PyEnv.
curl -s https://codeload.github.com/pyenv/pyenv/zip/master -o pyenv.zip
unzip -q pyenv.zip pyenv-master/*
mv pyenv-master $PYENV_ROOT
rm -f pyenv.zip

# Add PyEnv initialisation to profile.
rc3=/etc/profile.d/03-set-pyenv.sh
echo "# Enable PyEnv" >> $rc3
echo "export PYENV_ROOT=$PYENV_ROOT" >> $rc3
echo "export PATH=\$PYENV_ROOT/bin:\$PATH" >> $rc3
echo 'eval "$(pyenv init -)"' >> $rc3
echo "" >> $rc3
