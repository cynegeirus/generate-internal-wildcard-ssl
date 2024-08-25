#!/bin/bash

create_config_file() {
    cat <<EOL > $CONFIG_FILE
[ req ]
default_bits       = 2048
distinguished_name = req_distinguished_name
req_extensions     = req_ext

[ req_distinguished_name ]
countryName                 = $COUNTRY
stateOrProvinceName         = $STATE
localityName                = $LOCALITY
organizationName            = $ORGANIZATION
commonName                  = $COMMON_NAME

[ req_ext ]
subjectAltName = @alt_names

[alt_names]
EOL

    # Add the DNS entries to the config file
    for ((i=0; i<${#DOMAINS[@]}; i++)); do
        echo "DNS.$((i+1)) = ${DOMAINS[$i]}" >> $CONFIG_FILE
    done
}

# Function to gather user input
gather_input() {
    read -p "Enter the directory to store the files (default: ./ssl_cert): " DIR
    DIR=${DIR:-./ssl_cert}
    mkdir -p $DIR
    cd $DIR

    read -p "Enter the country code (2 letters): " COUNTRY
    read -p "Enter the state or province: " STATE
    read -p "Enter the locality (e.g., city): " LOCALITY
    read -p "Enter the organization name: " ORGANIZATION
    read -p "Enter the common name (e.g., server FQDN or YOUR name): " COMMON_NAME

    echo "Enter the domain names (e.g., *.dev.company.local, *.test.company.local)."
    echo "Press Enter after each domain. When finished, press Enter on an empty line."
    
    DOMAINS=()
    while true; do
        read -p "Domain: " DOMAIN
        if [ -z "$DOMAIN" ]; then
            break
        fi
        DOMAINS+=($DOMAIN)
    done
}

CONFIG_FILE="san.cnf"
PRIVATE_KEY="private.key"
CSR_FILE="sslcert.csr"

echo "Wildcard SAN SSL Certificate Generator"
echo "--------------------------------------"

gather_input

create_config_file

openssl genrsa -out $PRIVATE_KEY 2048

openssl req -out $CSR_FILE -new -key $PRIVATE_KEY -nodes -config $CONFIG_FILE

echo "CSR and private key have been generated in the directory: $DIR"
echo "Send the CSR file to your domain management team for signing."
