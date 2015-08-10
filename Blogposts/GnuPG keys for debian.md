# Erstellen eines GPG Keys

GnuPG erstellt per default DSA Keys mit einer Schlüssellänge von 1024
bits und **SHA1** als hash Algorithmus. Debian bevorzugt aufgrund
einiger Schwächen von SHA1, Schlüssel mit einer Länge von 2048 Bits und
**SHA2** hash Algorithmus.

Mit den folgenden Einstellungen in *\~/.gnupg/gpg.conf*, werden
Schlüssel von GnuPG gemäss den [Anforderungen von
Debian](http://keyring.debian.org/creating-key.html) erstellt:

vim \~/.gnupg/gpg.conf

    personal-digest-preferences SHA256
    cert-digest-algo SHA256
    default-preference-list SHA512 SHA384 SHA256 SHA224 AES256 AES192 AES CAST5 ZLIB BZIP2 ZIP Uncompressed
