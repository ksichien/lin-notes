#!/bin/bash
# convert from .cer (DER encoding) file to .pem (base64 encoding) file
openssl x509 -inform DER -in domain.name.cer -out domain.name.pem

# decrypt an encrypted private key file
openssl rsa -in encrypted.key -out decrypted.key

# convert .pem (public certificate) and .key (private key) to .pfx (pkcs12) file
openssl pkcs12 -export -out domain.name.pfx -inkey decrypted.key -in domain.name.pem

# view a certificate's contents
openssl x509 -in domain.name.pem -noout -text
