#!/bin/bash

TestingURL="http://www.youtube.com/watch?v=moSFlvxnbgk"
Video=""

if [ "$1" == "$TestingURL" ];
then
  echo "Using Video Cache"
  cp video.test.mp4 video.mp4
else
  # Download YouTube Video
  rm video.mp4
  youtube-dl --format=18 --output "video.mp4" --no-overwrites "$1"
fi

rm -r images
mkdir images

# Convert Video to Images
avconv -i video.mp4 -r 1 -f image2 images/%05d.png

# Images to Barcode
convert images/*.png -resize 1x266\! images/movie%05d.jpg
montage -geometry +0+0 -tile x1 images/movie*.jpg static/barcode.png

#Barcode to Unique Colors
convert static/barcode.png -unique-colors -geometry x500\! static/barcode_colors.png

# Barcode to Histogram
convert static/barcode.png -colors 256 -format %c histogram:info:- |
  sed 's/:.*#/ #/' |
  while read count color colorname; do
    height=$count
    if [ "$height" -gt "400" ]; then
      height=400
    fi
    convert -size 1x$height xc:$color miff:-
  done |
    convert - -alpha set -gravity south -background none +append \
      static/histogram.png

# 5 Color Palette
convert static/barcode.png +dither -colors 5 -unique-colors -filter box -resize 2110% static/palette.png
