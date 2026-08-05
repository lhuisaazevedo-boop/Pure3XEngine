#!/data/data/com.termux/files/usr/bin/bash

echo "======================================="
echo " Pure3XEngine Android - Assinatura"
echo "======================================="

keytool -genkeypair \
-alias P3XE \
-keyalg RSA \
-keysize 4096 \
-validity 36500 \
-keystore P3XE.keystore

echo
echo "Assinatura criada:"
echo "$(pwd)/P3XE.keystore"
