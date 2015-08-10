# Robustes Forward Secrecy (FS) konfigurieren mit Apache 2.4

RC4 gilt als [theoretisch
geknackt](http://www.heise.de/security/meldung/Erneuter-Krypto-Angriff-auf-SSL-TLS-Verschluesselung-1822963.html).
Also habe ich mit mit der SSLCipherSuite von Apache beschäftigt um eine
**für den Moment** optimale Konfiguration zu finden.

Zum Testen eignet sich das [Testtool von
SSLLabs](https://www.ssllabs.com/ssltest/index.htm) hervorragend.

## Variante 1

Getestet mit ssllabs am 15.11.2013 mit der Wertung 95/90/90. Kein FS für
XP IE6/8 und Java 6u45

    SSLProtocol -ALL +TLSv1 +TLSv1.1 +TLSv1.2
    SSLCipherSuite "ECDHE-RSA-AES128-GCM-SHA256 ECDHE-RSA-AES256-GCM-SHA384
    ECDHE-R+SA-AES128-SHA256 ECDHE-RSA-AES256-SHA384 ECDHE-RSA-RC4-SHA
    ECDHE-RSA-AES128-SHA+ ECDHE-RSA-AES256-SHA ECDHE-RSA-DES-CBC3-SHA
    AES128-GCM-SHA256 AES256-GCM-SHA38+4 AES128-SHA256 AES256-SHA256
    AES128-SHA AES256-SHA DES-CBC3-SHA !aNULL !ADH !eNULL !LOW !EXP !MD5 +HIGH

## Variante 2

Getestet mit ssllabs am 15.11.2013 mit der Wertung 95/80/90 kein FS für
XP IE6/8 und Java 6u45 / This server provides robust Forward Secrecy
support.

    SSLProtocol -ALL +TLSv1 +TLSv1.1 +TLSv1.2
    SSLCipherSuite "EECDH+ECDSA+AESGCM EECDH+aRSA+AESGCM
    EECDH+ECDSA+SHA384 EECDH++ECDSA+SHA256 EECDH+aRSA+SHA384
    EECDH+aRSA+SHA256 EECDH+aRSA+RC4 EECDH EDH+aRSA +!aNULL
    !eNULL !LOW !3DES !MD5 !EXP !PSK !SRP !DSS !aNULL !ADH
    !eNULL !LOW !EXP"
    +!MD5

## Variante 3

Getestet mit ssllabs am 15.11.2013 mit der Wertung This server provides
robust Forward Secrecy support. Only first connection attempt simulated.
Browsers tend to retry with a lower protocol version. **IE6 auf XP
fail**.

    SSLProtocol -ALL +TLSv1 +TLSv1.1 +TLSv1.2
    SSLHonorCipherOrder On
    SSLCipherSuite "EECDH+ECDSA+AESGCM EECDH+aRSA+AESGCM
    EECDH+ECDSA+SHA384 EECDH+E+CDSA+SHA256 EECDH+aRSA+SHA384
    EECDH+aRSA+SHA256 EECDH+aRSA+RC4 EECDH EDH+aRSA+!aNULL
    !eNULL !LOW !3DES !MD5 !EXP !PSK !SRP !DSS !aNULL !ADH
    !eNULL !LOW !EXP+!MD5 RC4-SHA"

## Zusammenfassung

Variante 2 scheint gemäss ssllabs am besten, da sie den besten [Forward
Secrecy](http://de.wikipedia.org/wiki/Forward_Secrecy) support über alle
Plattformen bietet. Die [Android
Katastrophe](http://op-co.de/blog/posts/android_ssl_downgrade) zwingt
dazu, sofern Android Geräte Zugang zum Webserver brauchen, dass RC4
aktiviert ist.

[Gemäss Ivan
Ristic](http://www.heise.de/security/artikel/Forward-Secrecy-testen-und-einrichten-1932806.html)
scheint hier RC4-SHA der beste Kompromiss. Daher ist bei Variante drei
diese Option am Schluss noch mit drin.

Mit Variante 3 steht auf allen Plattformen **Forward Secrecy** zur
Verfügung. **Mit Ausnahme von IE6 auf XP.**

# Referenz

[SSL/TLS Deployment Best
Practices](https://www.ssllabs.com/projects/best-practices/index.html)
