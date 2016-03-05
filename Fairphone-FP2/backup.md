# Backing up your android based Fairphone FP2 using ssh and rsync

## SSHelper configuration

Install [SSHelper](https://play.google.com/store/apps/details?id=com.arachnoid.sshelper) from google play store or from its homepage [here](http://arachnoid.com/android/SSHelper/index.html).

* [X] Disable password logins
* [ ] Enable Zeroconf broadcast
* [ ] Enable log display server
* [ ] Enable clipboard display server
* [X] Prevent standby while running

## SSH configuration

Check connection to your device:

	$ ssh <android-ip> -p2222
	u0_a115@FP2:/data/data/com.arachnoid.sshelper/home $ exit

Create a specific ssh key for using with your device:

	ssh-keygen -b 4096 -t rsa -C "fp2@xy" -f ~/.ssh/id_fp2

Now copy your new key to your device:

	$ ssh-copy-id -i ~/.ssh/id_fp2 <android-ip>
	SSHelper Version 8.4 Copyright 2014, P. Lutus
	Default password is "admin" (recommend: change it)
	user@<android-ip>'s password: 
	Number of key(s) added: 1
	Now try logging into the machine, with:   "ssh '<android-ip>'"
	and check to make sure that only the key(s) you wanted were added.

Check connection with ssh key:

	$ ssh -i ~/.ssh/id_fp2 <android-ip> -p2222

## Mounting via sshfs

	$ mkdir -p mnt/fp2
	$ sshfs <android-ip>:/storage/emulated/0 mnt/fp2/
	$ ls ~/mnt/fp2

## Backing up a directory

	mkdir -p backup/fp2
	rsync -rlcv --stats --progress \
	  --exclude=.thumbnails \
	  --delete \
	  <android-ip>:/storage/emulated/0/{DCIM,Documents,Downloads,Android} ~/backup/fp2 1>&2 || return 1

Happy syncing!

# Links

* [How to rsync to android](http://askubuntu.com/questions/343502/how-to-rsync-to-android)
