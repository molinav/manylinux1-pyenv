#! /bin/sh

set -e

openssl_version=1.0.2
openssl_prefix=/opt/ssl/${openssl_version}

openssl_name=openssl-${openssl_version}
openssl_targz=$openssl_name.tar.gz
openssl_patch=openssl-${openssl_version}-fix_parallel_build-1.patch

echo "      ---> OpenSSL ${openssl_version}: downloading..."
curl -s https://www.openssl.org/source/openssl-${openssl_version}.tar.gz -O
curl -s http://www.linuxfromscratch.org/patches/blfs/7.7/$openssl_patch -O
tar -xzf openssl-${openssl_version}.tar.gz

PATH=/opt/perl/bin:$PATH
cd openssl-${openssl_version}
echo "      ---> OpenSSL ${openssl_version}: patching..."
patch -Np1 -i ../$openssl_patch >/dev/null
echo "      ---> OpenSSL ${openssl_version}: configuring..."
./config --prefix=${openssl_prefix} --openssldir=${openssl_prefix}/ssl        \
         --libdir=lib -Wl,-rpath=${openssl_prefix}/lib                        \
         shared zlib-dynamic >/dev/null
echo "      ---> OpenSSL ${openssl_version}: building..."
make >/dev/null 2>&1
echo "      ---> OpenSSL ${openssl_version}: installing..."
make install >/dev/null 2>&1

cd ..
echo "      ---> OpenSSL ${openssl_version}: cleaning..."
rm -rf $openssl_name
rm -f $openssl_targz
rm -f $openssl_patch

echo "      ---> OpenSSL ${openssl_version}: linking CA certificates..."
rmdir ${openssl_prefix}/ssl/certs
ln -s /etc/pki/tls/certs ${openssl_prefix}/ssl/certs
ln -s /etc/pki/tls/cert.pem ${openssl_prefix}/ssl/cert.pem
