# spaceengineers-ocr-clipboard-linux
repo for scripts and resources for linux users to copy text in space engineers

this is working for me with a very low rate of failure (once in a blue moon it might miss a '.' so keep your eyes pealed when fine tuning the settings)

Long story short, 
(ill explain everything i did to produce the traineddata later so if someone wants to reproduce and improve upon process)

You need \n
xdotool
maim
xclip
imagemagick
and tesseract-ocr with i think english lang data installed

place SEfont.traineddata into /usr/share/tessdata/

read and follow the instructions in the gpsSEclip.sh file

bind the script to a key combination of your choosing with whatever it is you use to manage your hotkeys 

(ie sxhkd in my case)

and copy away

sorry if its a bit of a mess, ill refine instructions and make things clearer later

@ me (@Dig#3443) in keens linux discord channel if you need help
