# Wie optimiere ich Web Page Performance mit dem Apache?

Der Browser Google Chrom bietet die Möglichkeit **Network Utilization**
und **Web Page Performance** Audits vorzunehmen. Folgende Änderungen
habe ich in der **.htaccess** Datei vorgenommen:

Header unset Pragma

FileETag None

Header unset ETag

ExpiresActive on

ExpiresByType text/html "access plus 4 days"

ExpiresByType image/gif "access plus 12 month"

ExpiresByType image/jpeg "access plus 12 month"

ExpiresByType image/png "access plus 12 month"

ExpiresByType text/css "access plus 12 month"

ExpiresByType application/pdf "access plus 12 month"

ExpiresByType audio/mpeg "access plus 12 month"

ExpiresByType application/javascript "access plus 12 month"

\<FilesMatch "\\.(jpg|png|gif)\$"\>

\<IfModule mod\_expires.c\>

  Header set Cache-Control "public"

\</IfModule\>

\</FilesMatch\>
