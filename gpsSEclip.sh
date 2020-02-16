#!/bin/bash
# Dependencies: xdotool tesseract-ocr imagemagick maim/scrot xclip/xsel
# you can easily use scrot and xsel instead of maim and xclip
# This script is a derivative of one found here
# https://askubuntu.com/questions/280475/how-can-instantaneously-extract-text-from-a-screen-area-using-ocr-tools
# tried both xsel and xclip but neither could put the selection into wines clipboard


# ######################################################### PLEASE READ
# you can use slop to produce geometry for the screenshots
# https://github.com/naelstrof/slop
# if you have maim you have slop
# just run slop in the terminal and trace around the text field for the name, x, y and z of the gps
# the output will look like whats in the 4 vars below, replace the vars below with your values
# see example pre processed images for an idea of what to aim for
# you may need to tweak the values a little if you are in windowed mode (i did)
#  if so it may help to comment out the mogrify commands below
gNAME="923x40+760+284"
gX="255x40+795+853"
gY="255x40+1109+853"
gZ="255x40+1423+853"
# change to directory of your choice leaving tempClip or choosing a different name.
# tempClip will be the file name of the images grabbed from the screen
# view these images when fine tuning your geometry vars above
SCR_IMG="/home/q_p/Projects/2020/SE/OCR/tempClip"

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
# i wouldn't move adaptive sharpen more than 1% at a time up or down, and the higher it goes the longer the process takes
#  you can also move adaptive sharpen to after scale but this will also increase the tim the processing takes as the image is larger
#  If your adaptive sharpen value gets high you may want to uncomment out the ffplay (from ffmpeg) line below and point it at an system
#  sound to indicate that the script has ended
# scale you can tweak up or down by 5-10 % to find what works best for you
# You can share your successful sweet spots and screen resolution to help others
# My screen is 1920x1200 and the SE window is 1920x1178 borderless

# name
maim -i $(xdotool getactivewindow) -g $gNAME $SCR_IMG.png
mogrify -modulate 100,0 -normalize -adaptive-sharpen 5% -channel RGB -negate -scale 150% $SCR_IMG.png
GPSSE="${GPSSE}$(echo $(tesseract $SCR_IMG.png stdout -l SEfont -c tessedit_char_whitelist='abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890-#!,[]._ ?') |sed -e 's/[[:space:]]*$//' ):"
# x
maim -i $(xdotool getactivewindow) -g $gX ${SCR_IMG}x.png
mogrify -modulate 100,0 -normalize -adaptive-sharpen 5% -channel RGB -negate -scale 150% ${SCR_IMG}x.png
GPSSE="${GPSSE}$(echo $(tesseract ${SCR_IMG}x.png stdout -l SEfont -c tessedit_char_whitelist=1234567890-.) | tr -d ' '):"
# y
maim -i $(xdotool getactivewindow) -g $gY ${SCR_IMG}y.png
mogrify -modulate 100,0 -normalize -adaptive-sharpen 5% -channel RGB -negate -scale 150% ${SCR_IMG}y.png
GPSSE="${GPSSE}$(echo $(tesseract ${SCR_IMG}y.png stdout -l SEfont -c tessedit_char_whitelist=1234567890-.) | tr -d ' '):"
# z
maim -i $(xdotool getactivewindow) -g $gZ ${SCR_IMG}z.png
mogrify -modulate 100,0 -normalize -adaptive-sharpen 5% -channel RGB -negate -scale 150% ${SCR_IMG}z.png
GPSSE="${GPSSE}$(echo $(tesseract ${SCR_IMG}z.png stdout -l SEfont -c tessedit_char_whitelist=1234567890-.) | tr -d ' '):"


# throwing it at all selections to see if it would change the clipboard inside wine/SE
# it would not
# one is likely enough for you so uncomment what you don't need
# im able to get the past back into the wine/SE clipboard by pasting outside of wine and copying it again
# there should be a way to force sync the X clipboard to wine but i haven't really looked yet
echo ${GPSSE} | xclip -i -selection primary
echo ${GPSSE} | xclip -i -selection secondary
echo ${GPSSE} | xclip -i -selection clipboard

# image processing early on was taking a lot of time (before i cracked and trained tesseract on the SE font)
# this line was to play a sound to inticate that the script was done
#ffplay -nodisp -autoexit /home/q_p/Projects/2020/SE/OCR/CHRONO_12leveling.mp3

exit
