#! /bin/sh

set -e

BASE_DEPENDENCIES=$(echo "
    zlib-devel bzip2-devel ncurses-devel sqlite-devel readline-devel gpg      \
    gdbm-devel db4-devel libpcap-devel xz-devel libffi-devel tk tk-devel      \
    openssl-devel e2fsprogs-devel keyutils-libs-devel krb5-devel              \
    libselinux-devel libsepol-devel
")

echo "      ---> Removing building dependencies..."
yum remove -y $BASE_DEPENDENCIES >/dev/null
yum clean all >/dev/null
