#! /bin/sh

set -e

perl_version=5.30.2
perl_prefix=/opt/perl

echo "      ---> Downloading Perl..."
curl -s https://www.cpan.org/src/5.0/perl-${perl_version}.tar.gz -O
tar -xzf perl-${perl_version}.tar.gz

cd perl-${perl_version}
echo "      ---> Configuring Perl..."
sh Configure -des -Dprefix=${perl_prefix} >/dev/null
echo "      ---> Building Perl..."
make -j8 >/dev/null 2>&1
echo "      ---> Installing Perl..."
make install >/dev/null 2>&1

echo "      ---> Cleaning..."
rm -rf perl-${perl_version}
rm -f perl-${perl_version}.tar.gz
