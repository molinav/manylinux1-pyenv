#! /bin/sh

openssl_version=1.0.2
openssl_prefix=/opt/ssl/${openssl_version}

openssl_name=openssl-${openssl_version}
openssl_targz=$openssl_name.tar.gz
openssl_patch=openssl-$openssl_version-fix_parallel_build-1.patch

echo "      ---> Downloading OpenSSL ${openssl_version}..."
curl -s https://www.openssl.org/source/openssl-${openssl_version}.tar.gz -O
curl -s http://www.linuxfromscratch.org/patches/blfs/7.7/$openssl_patch -O
tar -xzf openssl-${openssl_version}.tar.gz

PATH=/opt/perl/bin:$PATH
cd openssl-${openssl_version}
echo "      ---> Patching OpenSSL ${openssl_version}..."
patch -Np1 -i ../$openssl_patch
echo "      ---> Configuring OpenSSL ${openssl_version}..."
./config --prefix=${openssl_prefix} --openssldir=${openssl_prefix}/ssl        \
         --libdir=lib -Wl,-rpath=${openssl_prefix}/lib                        \
         shared zlib-dynamic
echo "      ---> Building OpenSSL ${openssl_version}..."
make -j8
echo "      ---> Installing OpenSSL  ${openssl_version}..."
make install_sw

cd ..
echo "      ---> Cleaning..."
rm -rf $openssl_name
rm -f $openssl_targz
rm -f $openssl_patch

echo "Linking CA certificates..."
rmdir ${openssl_prefix}/ssl/certs
ln -s /etc/pki/tls/certs ${openssl_prefix}/ssl/certs
ln -s /etc/pki/tls/cert.pem ${openssl_prefix}/ssl/cert.pem
