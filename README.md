# Wildcard SAN SSL Certificate Guide for Internal Use

This guide outlines the steps to generate and request a wildcard SAN (Subject Alternative Name) SSL certificate for internal domains (e.g., `*.company.local`). If you have subdomains (e.g., `*.dev.company.local`), you'll need to prepare a certificate request and get it signed by your organization's certificate authority.

## Requirements

### 1. Create a Directory and Generate a Private Key

First, create a directory to store your files. Then, generate a private key using the following command:

```bash
openssl genrsa -out private.key 2048
```

> **Note:** The `openssl` command is not available on Windows by default, but you can run it using Git Bash or a similar terminal.

### 2. Prepare a Configuration File

In the same directory, create a configuration file (e.g., `san.cnf`). The content of the file can look like this:

```ini
[ req ]
default_bits       = 2048
distinguished_name = req_distinguished_name
req_extensions     = req_ext

[ req_distinguished_name ]
countryName                 = Country Name (2 letter code)
stateOrProvinceName         = State or Province Name (full name)
localityName                = Locality Name (eg, city)
organizationName            = Organization Name (eg, company)
commonName                  = Common Name (e.g. server FQDN or YOUR name)

[ req_ext ]
subjectAltName = @alt_names

[alt_names]
DNS.1   = *.dev.company.local
DNS.2   = *.test.company.local
```

You only need to update the lines that start with `DNS.`. These lines specify the domain names for which the certificate will be valid. You can add as many domain names as needed by incrementing the number (e.g., `DNS.3`, `DNS.4`, etc.).

### 3. Generate a Certificate Signing Request (CSR)

Now, create a certificate signing request using your private key and the configuration file:

```bash
openssl req -out sslcert.csr -new -key private.key -nodes -config san.cnf
```

This command generates a `.csr` file, which you can submit to your domain management team to request the certificate signature.

## Submitting the CSR

Email the `.csr` file to your organization's domain management team (e.g., `domainmanagement@company.local`) with a request to sign the certificate. Typically, you will receive a `.cer` file in DER format.

## Converting the Certificate to PEM Format

To convert the `.cer` file to PEM (Base64 encoded), use the following command:

```bash
openssl x509 -inform DER -in certificate.cer -out certificate.crt
```

Now, you can use the `private.key` and `certificate.crt` files to enable SSL on your services.

## Additional Resources

- [SAN SSL Certificate Guide](https://geekflare.com/san-ssl-certificate/)
- [How to Create a SAN Certificate](https://gist.github.com/htekgulds/5b8247f6550902fc9d4b04c18e097ca1)

## Issues, Feature Requests, or Support
Please use the **New Issue** button to submit issues, feature requests, or support inquiries directly to me. You can also send an e-mail to [akin.bicer@outlook.com.tr](mailto:akin.bicer@outlook.com.tr).
