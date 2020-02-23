#!/bin/bash
# Dependencies: xdotool tesseract-ocr imagemagick maim/scrot xclip/xsel
# you can easily use scrot and xsel instead of maim and xclip
# This script is a derivative of one found here
# https://askubuntu.com/questions/280475/how-can-instantaneously-extract-text-from-a-screen-area-using-ocr-tools


# ######################################################### PLEASE READ
# you can use slop to produce geometry for the screenshots
# https://github.com/naelstrof/slop
# if you have maim you have slop
# just run slop in the terminal and trace around the text field for the name, x, y and z of the gps
# the output will look like whats in the 4 vars below, replace the vars below with your values
# see example pre processed images for an idea of what to aim for
# you may need to tweak the values a little if you are in windowed mode (i did)
#  if so it may help to comment out the mogrify commands below, run the script via a hot key with the space 
#  engineers window being the active window and check the tempClip images to see if they are aligned correctly
#  when adjusting these vars remember that the format is [width]x[height]+[x screen coordinate]+[y screen coordinate]
# These were for a screen resolution of 1920x1200 and a window size of 1920x1178 borderless
# if your resolution or window size is similar you may only need to tweak these values.
gNAME="923x40+760+284" 
gX="255x40+795+853"
gY="255x40+1109+853"
gZ="255x40+1423+853"
# change to directory of your choice leaving tempClip or choosing a different name.
# tempClip will be the file name of the images grabbed from the screen
# view these images when fine tuning your geometry vars above
SCR_IMG="/path/to/where/you/want/to/store/the/tempClip"

#trap "rm $SCR_IMG*" EXIT
# you could uncomment above but i'd leave it for the moment for debug purposes
# deletes the images at the end of the script

# starts off building the gps
GPSSE="GPS:"

# ########################################### PLEASE READ
# notes on mogrify
# modulate, normalize, channel RGB and negate are to change the image to black on white, this vastly improves the success rate
# adaptive sharpen and scale and sitting a sweet spot thats netting me the best results
# depending on your resolution/window size etc you may want to tweak these
#
# UPDATE: old adaptive sharpen setting was '-adaptive-sharpen 5%' and it was sitting between -normalize and -channel, but anywhere before
#  scale should be fine.
# i have removed adaptive sharpen when using the latest traineddata as it does more harm than good (atleast in my case). With the current 
#  settings i havent seen any errors. Prior to that it would only fail to spot '.' and seeing as gps in the gps menu always have 2 digits 
#  following '.', the script has been modified to check for '.' and insert it if its absent.
#
# i wouldn't move adaptive sharpen more than 1% at a time up or down at a time, and the higher it goes the longer the process takes
#  you can also move adaptive sharpen to after scale but this will also increase the time the processing takes as the image is larger
#  If your adaptive sharpen value gets high you may want to uncomment out the ffplay (from ffmpeg) line below and point it at an system
#  sound to indicate that the script has ended
# scale you can tweak up or down by 5-10 % at a time to find what works best for you
# You can share your successful sweet spots and screen resolution to help others
# My screen is 1920x1200 and the SE window is 1920x1178 borderless 
# MY settings with the old traineddata were adaptive sharpen of 5% and scale of 150%

ACTIVEWINVAR=$(xdotool getactivewindow)
# name
maim -i $ACTIVEWINVAR -g $gNAME $SCR_IMG.png
#mogrify -modulate 100,0 -normalize -channel RGB -negate -scale 110% $SCR_IMG.png
GPSSE+="$(echo $(tesseract $SCR_IMG.png stdout -l SEfont) |sed -e 's/[[:space:]]*$//' ):"
# x
maim -i $ACTIVEWINVAR -g $gX ${SCR_IMG}x.png
mogrify -modulate 100,0 -normalize -channel RGB -negate -scale 110% ${SCR_IMG}x.png
GPSSE+="$(echo $(tesseract ${SCR_IMG}x.png stdout -l SEfont -c tessedit_char_whitelist=1234567890-.) | tr -d ' \f'):"
if [ "${GPSSE: -4:1}" != "." ]
then
    GPSSE="${GPSSE%???}.${GPSSE: -3}"
fi
# y
maim -i $ACTIVEWINVAR -g $gY ${SCR_IMG}y.png
#mogrify -modulate 100,0 -normalize -channel RGB -negate -scale 110% ${SCR_IMG}y.png
GPSSE+="$(echo $(tesseract ${SCR_IMG}y.png stdout -l SEfont -c tessedit_char_whitelist=1234567890-.) | tr -d ' \f'):"
if [ "${GPSSE: -4:1}" != "." ]
then
    GPSSE="${GPSSE%???}.${GPSSE: -3}"
fi
# z
maim -i $ACTIVEWINVAR -g $gZ ${SCR_IMG}z.png
#mogrify -modulate 100,0 -normalize -channel RGB -negate -scale 110% ${SCR_IMG}z.png
GPSSE+="$(echo $(tesseract ${SCR_IMG}z.png stdout -l SEfont -c tessedit_char_whitelist=1234567890-.) | tr -d ' \f'):"
if [ "${GPSSE: -4:1}" != "." ]
then
    GPSSE="${GPSSE%???}.${GPSSE: -3}"
fi



# one is likely enough for you so comment what you don't need
echo ${GPSSE} | xclip -i -selection primary
echo ${GPSSE} | xclip -i -selection clipboard

# image processing early on was taking a lot of time (before i cracked and trained tesseract on the SE font)
# this line was to play a sound to indicate that the script was done
#ffplay -nodisp -autoexit /path/to/whatever/file.mp3

exit
