#!/bin/bash
# https://networklessons.com/uncategorized/openssl-certification-authority-ca-ubuntu-server/
CA_DIR='/root/ca'
COUNTRY='DE'
STATE='Berlin'
LOCALITY='Berlin'
ORGANIZATION='Vandelay-Industries'
SERVER='zabbix.vandelayindustries.com'

# adjust /usr/local/ssl/openssl.conf as needed

# create ca folder and subdirectories
mkdir -p ${CA_DIR}/newcerts ${CA_DIR}/certs ${CA_DIR}/crl ${CA_DIR}/private ${CA_DIR}/requests
# create certificate database
touch ${CA_DIR}/index.txt
# create serial file with initial serial number 1234
echo '1234' > ${CA_DIR}/serial

# enhance security
chmod -R 600 ${CA_DIR}

# generate private key for ca with passphrase
openssl genrsa -aes256 -out private/cakey.key 4096
# generate certificate for ca
openssl req -new -x509 -key ${CA_DIR}/private/cakey.key -out certs/cacert.pem -days 1825 -set_serial 0

# generate private key for zabbix server without passphrase
openssl genrsa -out ${CA_DIR}/private/${SERVER}.key 2048
# generate csr based on private key for zabbix server
openssl req -new -key ${CA_DIR}/private/${SERVER}.key -out ${CA_DIR}/requests/${SERVER}.csr \
            -subj "/C=${COUNTRY}/ST=${STATE}/L=${LOCALITY}/O=${ORGANIZATION}/CN=${SERVER}"
# generate certificate based on private key and csr for zabbix server
openssl ca -in ${CA_DIR}/requests/${SERVER}.csr -out ${CA_DIR}/certs/${SERVER}.pem
