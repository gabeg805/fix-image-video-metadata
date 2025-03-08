#!/bin/bash

f="$1"

# Not a video
if [ "${f##*.}" != "mp4" ]
then
	exit
fi

# Starts with number
if  [ "${f:0:1}" -eq "${f:0:1}" ] 2> /dev/null
then
	t="${f:0:4}-${f:4:2}-${f:6:2}T${f:9:2}:${f:11:2}:${f:13:2}.000000Z"

# Starts with VID_
elif [ "${f:0:4}" == "VID_" ]
then
	t="${f:4:4}-${f:8:2}-${f:10:2}T${f:13:2}:${f:15:2}:${f:17:2}.000000Z"

# Unknown
else
	exit
fi

# Print debug info
echo "$f | $t"

# Change metadata
ffmpeg -i "$f" -metadata creation_time="$t" -codec copy "new_${f}" -update 1

