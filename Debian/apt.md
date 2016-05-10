# apt tricks

### reinstall

	apt-get install --reinstalle packagename

### Debugging apt-get

      apt-get -duV -o Debug::pkgProblemResolver=yes install xy

### Remove unused packages

	apt-get install deborphan
	deborphan -n | xargs apt-get -y purge

## Find files in apt packages

	apt-get install apt-file
	apt-file update
	apt-file find xy
