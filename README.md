# spaceengineers-ocr-clipboard-linux
repo for scripts and resources for linux users to copy text in space engineers

this is working for me with a very low rate of failure (once in a blue moon it might miss a '.' so keep your eyes pealed when fine tuning the settings)
UPDATE
now using improved traineddata and i no longer see errors. But seeing as rarely failing to see '.' was the last issue and that gps always have 2 digits following the '.', the script has been modified to check to see if its there and if it isnt, it inserts it into the string.

Long story short, 
(ill explain everything i did to produce the traineddata later so if someone wants to reproduce and improve upon process)

You need
xdotool
maim
xclip
imagemagick
and tesseract-ocr with i think english tessdata installed

place SEfont.traineddata into /usr/share/tessdata/

read and follow the instructions in the gpsSEclip.sh file

bind the script to a key combination of your choosing with whatever it is you use to manage your hotkeys 

(ie sxhkd in my case)

and copy away

sorry if its a bit of a mess, ill refine instructions and make things clearer later

@ me (@Dig#3443) in keens linux discord channel if you need help
