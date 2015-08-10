# Vorbereitung

	aptitude -t testing install dh-make fakeroot devscripts \
	  debian-policy gnu-standards developers-reference \
	  build-essential libdpkg-perl git-buildpackage quilt \
	  lintian piuparts

	vim ~/.bashrc
	  DEBEMAIL=your@email.ch
	  DEBFULLNAME="Firstname Lastname"
	  export DEBEMAIL DEBFULLNAME

# Finde ein Paket

dass Hilfe benötigt und Du betreuen möchtest: [wnpp](http://www.debian.org/devel/wnpp/) / [orphanded](http://www.debian.org/devel/wnpp/orphaned)

* wnpp-alert
* ITP / Intent to Package (reportbug)

> First, as (developer-guide) tells, you need to report an "ITP" (Intent to Package) bug against the "wnpp" pseudo-package (reportbug wnpp will do it). And you must close this bug in the first changelog entry.

Bug erstellen um ein neues Packet bei Debian aufzunehmen:

	aptitude install reportbug
	reportbug -$\,$-email username@domain.tld wnpp
	git setup

# For a good packaging

we need two branches. **Master** is all upstream original source files. **Debian** is upstream + debian control files debian/\*

	git branch debian
	git checkout debian

Create all ./debian/\* files

	mkdir -p debian/source

	vim debian/source/format
	  3.0 (quilt)

	vim debian/compat
	  7

	vim debian/watch
	  version=3
	  http://githubredir.debian.net/github/micressor/fadecut/([$\backslash$d$\backslash$.]*).tar.gz

Let’s setup debhelper tiny rules file

	cp /usr/share/doc/debhelper/examples/rules.tiny ./debian/rules

Now we can use very easy fadecut.\* files to configure our debian
package.

	vim debian/dirs
	  usr/bin
	vim debian/docs
	  README
	  TODO
	vim debian/fadecut.install
	  fadecut usr/bin
	vim debian/fadecut.manpages
	  fadecut.1

Check manpage syntax

	LC_ALL=en_US.UTF-8 MANWIDTH=80 man --warnings -E UTF-8 -l ./aspsms-t.notify.1 >/dev/null

* [Creating man pages](http://wiki.redbrick.dcu.ie/mw/Creating_Man_Pages)

	vim debian/fadecut.examples
	  examples/*

# Build the package

Tag upstream on master branch

	git checkout master
	git tag 0.0.1 commitid
	git checkout debian
	git merge 0.0.1
	git archive --format=tar --prefix=fadecut-0.0.1/ 0.0.1 | bzip2 > ../fadecut_0.0.1.orig.tar.bz2
	git archive --format=tar --prefix=fadecut-0.0.1/ 0.0.1 | gzip > ../fadecut_0.0.1.orig.tar.gz

Update ./debian/changelog only debian packaging related changes between versions. If this is the first release, we have to create a logentry which is closes our ITP Bug. It is important, to document everything what you changed on the debian packaging dch -i

# Build without singing

    dpkg-buildpackage -uc -us
    ll ../fadecut_0.0.2*
    w-r--r-- 1 maba maba 11K 9. Feb 16:04 ../fadecut_0.0.1-1_all.deb
    -rw-r--r-- 1 maba maba 1.7K 9. Feb 16:04 ../fadecut_0.0.1-1_amd64.changes
    -rw-r--r-- 1 maba maba 2.0K 9. Feb 16:04 ../fadecut_0.0.1-1.debian.tar.gz
    -rw-r--r-- 1 maba maba 767 9. Feb 16:04 ../fadecut_0.0.1-1.dsc
    -rw-r--r-- 1 maba maba 19K 9. Feb 16:03 ../fadecut_0.0.1.orig.tar.bz2

# Quality checks with lintian

Lintian will check now the package for a lot of debian policies. We have
to fix all warnings and errors.

    lintian -i -v -I -$\,$-pedantic ../fadecut_0.0.1-1_source.changes | grep -v N:

Check install/uninstall witz

    git add debian/\$files
    git commit
    git push

sign and upload. Create account on <http://mentors.debian.net,> if you
have no one

    vim ~/.dput.cnf
    [mentors]
    fqdn = mentors.debian.net
    incoming = /upload/marco@balmer.name/xyz
    method = http
    allow_unsigned_uploads = 0
    progress_indicator = 2

    dpkg-buildpackage
    dput mentors fadecut_0.0.1-1_amd64.changes

Find a sponsor: <http://wiki.debian.org/Mentors/BTS> Find a sponsor at
debian-mentors mailinglist A sponsor has uploaded your package? Yes!

    git tag debian/0.0.1-1 commitid
    git checkout master
    git push
    git push -$\,$-tags

# Send bug report to sponsorship-requests

    reportbug -$\,$-no-query-bts -$\,$-severity=normal $\backslash$
      -$\,$-email=marco@balmer.name -$\,$-gpg -$\,$-paranoid $\backslash$
      -$\,$-subject="RFS: fadecut/0.1.4-1" $\backslash$
      -i fadecut-rfs-template.txt sponsorship-requests

# pbuilder

    apt-get install debian-archive-keyring

Create debian testing environment under ubuntu:

    sudo DIST=testing pbuilder create -$\,$-debootstrapopts -$\,$-keyring=/usr/share/keyrings/debian-archive-kyring.gpg
    pbuilder create -$\,$-debootstrapopts -$\,$-arch=amd64
    cd /tmp
    apt-get source couriergrey
    pbuilder build *.dsc

# Anhang

## Links

<http://www.debian.org/doc/maint-guide/index.de.html#contents>

<http://wiki.debian.org/PackagingWithGit>

<http://wiki.debian.org/MaintainerScripts>

<http://www.debian.org/doc/manuals/developers-reference/pkgs.html#newpackage>

<http://wiki.debian.org/DebianMaintainer>

<http://debian.wgdd.de/howto/howto-aptrep#aptrep_prereq_rephowto>

<http://wiki.debian.org/Keysigning>

<http://db.debian.org/>

<http://debconf.org/>

<https://nm.debian.org/dm_list.html>

<http://wiki.ubuntuusers.de/pbuilder>

<http://molly.corsac.net/~corsac/debian/new/>

<http://wiki.debian.org/DebianMentorsFaq>

<http://raphaelhertzog.com/2011/02/10/best-practices-when-sponsoring-debian-packages/>

<http://wiki.debian.org/DebianMentorsFaq#How_do_I_add_a_new_package_to_the_archive.3F>

<http://honk.sigxcpu.org/projects/git-buildpackage/manual-html/gbp.html>
<http://wiki.debian.org/Mentors/BTS> Check license of each source file?

    licensecheck /path/to/source

## tutorial for perl packages

    \url{http://mathforum.org/~ken/perl_modules.html}

import upstream source to master branch

    git-import-orig -$\,$-upstream-branch=master -$\,$-upstream-tag=upstream/0.3.2 /tmp/couriergrey-0.3.2.tar.gz

## Bedeutung des Status bei dpkg

    \$ dpkg -l fadecut
    ||/ Name           Version      Architektur  Beschreibung
    +++-==============-============-============-=================================
    ii  fadecut        0.1.1-1      all          toolset to rip audiostreams, cut,

 

    First character: The possible value for the first character. The first character signifies the desired state, like we (or some user) is marking the package for installation 

    u: Unknown (an unknown state) 
    i: Install (marked for installation) 
    r: Remove (marked for removal) 
    p: Purge (marked for purging) 
    h: Hold 

    Second Character: The second character signifies the current state, whether it is installed or not. The possible values are 

    n: Not- The package is not installed 
    i: Inst – The package is successfully installed 
    c: Cfg-files – Configuration files are present 
    u: Unpacked- The package is stilled unpacked 
    f: Failed-cfg- Failed to remove configuration files 
    h: Half-inst- The package is only partially installed 
    W: trig-aWait 
    t: Trig-pend 

    Let’s move to the third character 
    Third Character: This corresponds to the error state. The possible value include 
    R: Reinst-required The package must be installed.
