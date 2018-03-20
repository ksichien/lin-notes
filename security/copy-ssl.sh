#!/bin/bash
TARGETS=(gl.vandelayindustries.com ns.vandelayindustries.com smb.vandelayindustries.com www.vandelayindustries.com)
ZABBIX='zbx.vandelayindustries.com'

# copy certificates and private keys from zabbix ca server to target servers
for t in ${TARGETS[*]}; do
    scp -i ~/.ssh/${ZABBIX} ${USER}@${ZABBIX}:/home/${USER}/certs/cacert.pem . # zabbix ca server certificate
    scp -i ~/.ssh/${ZABBIX} ${USER}@${ZABBIX}:/home/${USER}/certs/${t}.pem . # target server certificate
    scp -i ~/.ssh/${ZABBIX} ${USER}@${ZABBIX}:/home/${USER}/private/${t}.key . # target server private key
    scp -i ~/.ssh/${t} cacert.pem ${USER}@${t}:/home/${USER}/certs/cacert.pem
    scp -i ~/.ssh/${t} ${t}.pem ${USER}@${t}:/home/${USER}/certs/${t}.pem
    scp -i ~/.ssh/${t} ${t}.key ${USER}@${t}:/home/${USER}/private/${t}.key
done
