# Converting flac to opus

	apt-get install libav-tools
	avconv -i audio.flac -f wav - | opusenc --bitrate 256 - audio.opus
