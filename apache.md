# apache authentifizieren über client zertifikat

	<Location / >
	  DAV On
	  SSLRequireSSL
	  SSLVerifyClient required
	  SSLVerifyDepth  2
	  # Bedinung e-mail adresse ist im client certificate enthalten
	  SSLRequire %{SSL_CLIENT_S_DN_Email}  eq "email@domain.tld"
	</Location>
