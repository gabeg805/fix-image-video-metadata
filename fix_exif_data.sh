#!/bin/bash

f="$1"

# Skip files that already have their exif data
if [ $(exiftool "$f" | grep -i 'create\|original' | grep -i "date" | wc -l) -ne 0 ]
then
	exit
fi

# Skip files that do not start with IMG or PXL and is not a number
if [ "${f:0:3}" != "IMG" -a "${f:0:3}" != "PXL" -a "${f:0:4}" != "PANO" -a "${f:0:6}" != "signal" -a "${f:0:10}" != "Screenshot" ]
then
	if  [ "${f:0:1}" -eq "${f:0:1}" ] 2> /dev/null
	then
		:
	else
		echo "$f"
		exit
	fi
fi

# Starts with number
if  [ "${f:0:1}" -eq "${f:0:1}" ] 2> /dev/null
then
	t="${f:0:4}:${f:4:2}:${f:6:2} ${f:9:2}:${f:11:2}:${f:13:2}"

# Starts with PANO
elif [ "${f:0:4}" == "PANO" ]
then
	t="${f:5:4}:${f:9:2}:${f:11:2} ${f:14:2}:${f:16:2}:${f:18:2}"

# Starts with signal
elif [ "${f:0:6}" == "signal" ]
then
	if [ "${f:20:1}" == "-" ]
	then
		t="${f:7:4}:${f:12:2}:${f:15:2} ${f:18:2}:${f:21:2}:${f:24:2}"
	else
		t="${f:7:4}:${f:12:2}:${f:15:2} ${f:18:2}:${f:20:2}:${f:22:2}"
	fi

# Starts with Screenshot
elif [ "${f:0:10}" == "Screenshot" ]
then
	t="${f:11:4}:${f:15:2}:${f:17:2} ${f:20:2}:${f:22:2}:${f:24:2}"

# Starts with IMG or PXL
else
	t="${f:4:4}:${f:8:2}:${f:10:2} ${f:13:2}:${f:15:2}:${f:17:2}"
fi

# Print debug info
echo "$f | $t"

# Change exif data
exiftool -DateTimeOriginal="$t" -overwrite_original "$f"

