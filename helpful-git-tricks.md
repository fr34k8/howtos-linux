# Helpful git command line tricks

man gittutorial

# git config

Nun dürfen wir noch unseren Namen und unsere Email einstellen mit denen
die Commits später gezeichnet werden ( /.gitconfig).

    git config --global user.name "Vorname Nachname"
    git config --global user.email email@domain.tld

# Automatische E-Mails einrichten

    cd /path-to-bare-git-repo/.git/hooks
    ln -sf /usr/share/doc/git-core/contrib/hooks/post-receive-email post-receive
    chmod a+x /usr/share/doc/git-core/contrib/hooks/post-receive-email
    git-config hooks.mailinglist "to@example.org"

# Workflow

	cd ~/src
	git init

oder

	git clone ssh://alice@git.domain.tld:22/project project
	vi ~/.git/description
	vi test.txt
	git diff
	git add test.txt
	git diff --cached
	git commit
	git log
	git log -p
	git push

# Branches

Branche erstellen und nutzen

    git branche
    git branche mybranche
    git checkout mybranche

### Merge {#merge .unnumbered}

Merge den Branch **Test** in den **Master** Branch

    git checkout master
    git merge Test

# Repo zusammenführen

    git remote add bob /home/bob/git
    git fetch bob
    git merge bob/master

# pull and push

    cd /home/alice/project
    git pull /home/bob/myrepo master

# Remove Tag from remote repo

    git tag -d v0.0.1
    git push origin :refs/tags/v0.0.1

# File wiederherstellen

Ein gelöschtes (nicht-commitedes) File wiederherstellen.

    git checkout boo-bar.txt

# Create patch

    git create format patch
    git format-patch -1

# Setup remote branch to track

Branch debian set up to track remote nach einem git clone den debian
branch anhängen.

    git checkout -b debian origin/debian

# Links

* [My Git Workflow](http://osteele.com/archives/2008/05/my-git-workflow)

* [Git tipps](http://git.or.cz/gitwiki/GitTips) or [GitFaq](https://git.wiki.kernel.org/index.php/GitFaq)

* [Using Git to manage a web site](http://toroid.org/ams/git-website-howto)

* [Dangling objects](http://www.kernel.org/pub/software/scm/git/docs/user-manual.html#dangling-objects)

* [Repack of Git repository fails](http://stackoverflow.com/questions/4826639/repack-of-git-repository-fails)

* [Managing ZIP-based file formats in git](http://the-gay-bar.com/2010/06/23/managing-zip-based-file-formats-in-git/)
