# Wie erstelle ich Images (.bin .toc .cue) von einer Audio-CD?

Mit dem Softwarepaket
[cdrdao](http://packages.qa.debian.org/c/cdrdao.html) lassen sich Images
von Audio-CD's erstellen.

	cdrdao read-cd --read-raw --paranoia-mode 3 --datafile image.bin --device /dev/sr0 image.toc

Note: Es ist nicht möglich ein .iso Image aus einer audio-cd zu
erstellen.

	toc2cue image.toc image.cue

Note: Einige CD Brenner Software mögen eher .toc's andere .cue's
