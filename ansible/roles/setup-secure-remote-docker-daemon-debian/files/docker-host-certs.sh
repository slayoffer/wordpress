#!/bin/bash

set -eu

#set -x ; debugging

# CHANGE SERVER USER !!!
USER="{{ username }}"

# CHANGE CERT PASSWORD !!!
PASSWORD="{{ certificate_password }}"

cd /home/"$USER"
echo "you are now in $PWD"

if [ ! -d "/home/$USER/.docker" ] 
then
    echo "Directory ./docker/ does not exist"
    echo "Creating the directory"
    mkdir -pv /home/"$USER"/.docker
fi

cd /home/"$USER"/.docker

# Disable error handling
set +e
sudo rm *.pem
# Re-enable error handling
set -e

openssl genrsa -aes256 -passout pass:"$PASSWORD" -out ca-key.pem 4096

# CHANGE CN here!
openssl req -new -x509 -days 3650 -key ca-key.pem -passin pass:"$PASSWORD" -sha256 -out ca.pem -subj "/C=TR/ST=./L=./O=./CN={{ remote_server_fqdn }}"

openssl genrsa -out server-key.pem 4096

# CHANGE CN here!
openssl req -subj "/CN={{ remote_server_fqdn }}" -sha256 -new -key server-key.pem -out server.csr

# CHANGE CNs and IPs here! THESE ARE IPS VIA WHICH DOCKER CLIENTS CAN ACCESS THIS DOCKER-HOST
echo subjectAltName = DNS:"{{ remote_server_fqdn }}",DNS:"{{ remote_server_shortname }}",IP:{{ remote_server_public_ip }},IP:{{ remote_server_local_ip }},IP:127.0.0.1 >> extfile.cnf

echo extendedKeyUsage = serverAuth >> extfile.cnf

openssl x509 -req -days 3650 -sha256 -in server.csr -CA ca.pem -CAkey ca-key.pem -passin "pass:$PASSWORD" \
  -CAcreateserial -out server-cert.pem -extfile extfile.cnf

openssl genrsa -out key.pem 4096

openssl req -subj '/CN=client' -new -key key.pem -out client.csr

echo extendedKeyUsage = clientAuth > extfile-client.cnf

openssl x509 -req -days 3650 -sha256 -in client.csr -CA ca.pem -CAkey ca-key.pem -passin "pass:$PASSWORD" \
  -CAcreateserial -out cert.pem -extfile extfile-client.cnf

echo "Removing unnecessary files i.e. client.csr extfile.cnf server.csr"
rm -v client.csr server.csr extfile.cnf extfile-client.cnf

echo "Changing the permissions to readonly by root for the server files."

chmod -v 0400 ca-key.pem key.pem server-key.pem

echo "Changing the permissions of the client files to read-only by everyone"

chmod -v 0444 ca.pem server-cert.pem cert.pem
