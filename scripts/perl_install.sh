#! /bin/sh

set -e

perl_version=5.30.2
perl_prefix=/opt/perl

echo "      ---> Perl5: downloading..."
curl -s https://www.cpan.org/src/5.0/perl-${perl_version}.tar.gz -O
tar -xzf perl-${perl_version}.tar.gz

cd perl-${perl_version}
echo "      ---> Perl5: configuring..."
sh Configure -des -Dprefix=${perl_prefix} >/dev/null
echo "      ---> Perl5: building..."
make -j8 >/dev/null 2>&1
echo "      ---> Perl5: installing..."
make install >/dev/null 2>&1

echo "      ---> Perl5: cleaning..."
cd ..
rm -rf perl-${perl_version}
rm -f perl-${perl_version}.tar.gz
