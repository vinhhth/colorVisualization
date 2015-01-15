Usage
=====
`virtualenv env`

`source env/bin/activate`

`pip intall -r requirements.txt`

`python ./app.py`

Download YouTube Video
======================

`youtube-dl --format=18 --output "video.%(ext)s" --no-overwrites https://www.youtube.com/watch\?v\=moSFlvxnbgk`

Convert Video to Images
=======================
`mkdir images`

`avconv -i video.mp4 -r 1 -f image2 images/%05d.png`

Images to Barcode
=================
`convert *.png -resize 1x266\! movie.jpg`

`montage -geometry +0+0 -tile x1 *.jpg barcode.png`

Barcode to Unique Colors
========================
`convert barcode.jpg -unique-colors -geometry x500\! barcode_colors.jpg`

Barcode to Histogram
====================
    convert rose: -colors 256 -format %c histogram:info:- |
        sed 's/:.*#/ #/' |
          while read count color colorname; do
            convert -size 1x$count xc:$color miff:-
          done |
            convert - -alpha set -gravity south -background none +append \
                    unique_color_histogram.png


5 Color Palette
=============
`convert barcode.jpg +dither -colors 5 -unique-colors -filter box -resize 2110% palette.jpg`

