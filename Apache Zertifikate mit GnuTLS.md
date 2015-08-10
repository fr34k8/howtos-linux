# SSL - Server - Zertifikate mit Apache und GnuTLS benutzen

Ein weiters Stück Technik für Fans.

# Was wir für Debian brauchen

**apt-get install ca-certificates gnutls-bin**

# Privat key erstellen

**certtool --generate-privkey --bits 4096 --outfile
rsa\_domain.tld.key**

    Generating a private key...
    Generating a 4096 bit RSA private key...

Den neuen privat key prüfen

**certtool --key-info --infile rsa\_domain.tld.key**

# Zertifikat-Request erstellen

**certtool --generate-request --load-privkey rsa\_domain.tld.key
--outfile request\_rsa\_domain.tld.csr**

    Generating a PKCS #10 certificate request...
    Country name (2 chars): CH
    Organization name: company
    Organizational unit name:
    Locality name: Bern
    State or province name: BE
    Common name: domain.tld
    Enter a challenge password:
    Is this also a TLS web server certificate? (y/N): y

# Signieren

Den **request\_rsa\_domain.tld.csr** bei
[CAcert](https://www.cacert.org) signieren lassen.

# Das neue Zertifikat prüfen

**certtool --certificate-info --infile request\_rsa\_domain.tld.pem**

# Apache konfigurieren


      SSLEngine on
      SSLProxyEngine on
      SSLProtocol -ALL +SSLv3 +TLSv1 +TLSv1.1 +TLSv1.2
      SSLCipherSuite ALL:!aNULL:!ADH:!eNULL:!LOW:!EXP:!MD5:RC4+RSA:+HIGH2
      SSLCertificateFile /home/user/web/key/rsa_domain.tld.pem
      SSLCertificateKeyFile /home/user/web/key/rsa_domain.tld.key
      SSLCACertificateFile /etc/ssl/certs/ca-ertificates.crt

**apache2ctl reload**

# Zertifikat durch Zugriff prüfen

**gnutls-cli -f domain.tld -p 443**

     - Got a certificate list of 3 certificates.
     - Certificate[0] info: ...

# Zertifikats-Kette prüfen

Mit dieser Kommando Reihenfolge kann geprüft werden, ob das Zertifikat
in der Kette bis zum Root CA von CAcert geprüft werden kann. Dieser
Vorgang lässt sich auch mit allen anderen Zertifikatsstellen
durchführen.

**cat rsa\_domain.tld.pem \>chain-test.pem**

**cat /etc/ssl/certs/cacert.org\_class3.pem \>\>chain-test.pem**

**cat /etc/ssl/certs/cacert.org\_root.pem \>\>chain-test.pem**

**certtool --verify-chain --infile ./chain-test.pem**

    Certificate[0]: CN=domain.tld
    Certificate[1]: O=CAcert Inc.,OU=http://www.CAcert.org,CN=CAcert Class 3 Root
    Certificate[2]: O=Root CA,OU=http://www.cacert.org,CN=CA Cert Signing Authority,EMAIL=support@cacert.org
    Chain verification output: Verified.
