#!/bin/bash

cd /data/noelia/Julkiset-videot
for i in *.mp4
do
	if [[ ! -f "${i%.mp4}.jpg" ]]
	then
		# Generate a thumbnail
		echo "${i%.mp4}.jpg" is not a file, imma gonna make one...
		ffmpegthumbnailer -s 250 -i "${i}" -o "${i%.mp4}.jpg" -c jpeg
		# Generate a square thumbnail
		echo also a "${i%.mp4}.mini.jpg"
		convert "${i%.mp4}.jpg" -resize "64x64^" -gravity center -crop 64x64+0+0 +repage "${i%.mp4}.mini.jpg"
	fi

        if [[ ! -f "mobile/${i%}" ]]
	then
		# Generate highly packed mobile version (240p height)
		echo "mobile/${i%}" is not a file, imma gonna ffmpeg one for you...
		/opt/ffmpeg -i "${i}" -vcodec libx264 -acodec aac -strict experimental -ac 2 -r 15 -ab 44100 -vf "scale=trunc((oh*a)/2)*2:240" mobile/"${i}"
	fi

	if [[ ! -f "webm/${i%.mp4}.webm" ]]
	then
		# Generate webm version with "normal internet speed" quality
		echo "webm/${i%.mp4}.webm" is not a file, imma gonna ffmpeg one for you. This gonna take a while...
		/opt/ffmpeg -i "${i}" -codec:v libvpx -quality good -cpu-used 0 -b:v 1M  -qmin 0 -qmax 50 -maxrate 500k -bufsize 1000k -threads 4 -codec:a libvorbis webm/"${i%.mp4}.webm"
	fi

done

chown -R www-data:www-data .
