#! /bin/sh

set -e
here=$(readlink -f "$0" | xargs dirname)

sh $here/perl_install.sh

openssl_version=1.0.2
openssl_prefix=/opt/ssl/${openssl_version}

openssl_name=openssl-${openssl_version}
openssl_targz=$openssl_name.tar.gz

echo " ---> Installing OpenSSL ${openssl_version}..."
echo "      ---> OpenSSL ${openssl_version}: downloading..."
curl -s https://www.openssl.org/source/openssl-${openssl_version}.tar.gz -O
tar -xzf openssl-${openssl_version}.tar.gz

PATH=/opt/perl/bin:$PATH
cd openssl-${openssl_version}
echo "      ---> OpenSSL ${openssl_version}: patching..."
patch -Np1 -i /home/scripts/ssl10_fix_parallel_build.patch >/dev/null
echo "      ---> OpenSSL ${openssl_version}: configuring..."
./config --prefix=${openssl_prefix} --openssldir=${openssl_prefix}/ssl        \
         --libdir=lib -Wl,-rpath=${openssl_prefix}/lib                        \
         shared zlib-dynamic >/dev/null
echo "      ---> OpenSSL ${openssl_version}: building..."
make >/dev/null 2>&1
echo "      ---> OpenSSL ${openssl_version}: installing..."
make install_sw >/dev/null 2>&1

cd ..
echo "      ---> OpenSSL ${openssl_version}: cleaning..."
rm -rf $openssl_name
rm -f $openssl_targz

echo "      ---> OpenSSL ${openssl_version}: linking CA certificates..."
rmdir ${openssl_prefix}/ssl/certs
ln -s /etc/pki/tls/certs ${openssl_prefix}/ssl/certs
ln -s /etc/pki/tls/cert.pem ${openssl_prefix}/ssl/cert.pem

echo "      ---> OpenSSL ${openssl_version}: updating environment..."
rc2=/etc/profile.d/02-link-openssl.sh
echo "# Add dynamic linking to OpenSSL." >> $rc2
echo "export LD_LIBRARY_PATH=${openssl_prefix}/lib:\$LD_LIBRARY_PATH" >> $rc2
echo "" >> $rc2

sh $here/perl_remove.sh
