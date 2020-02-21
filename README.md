# spaceengineers-ocr-clipboard-linux
## About
This repo is for scripts and resources for linux users to copy text in space engineers.

The scripts use [tesseract-ocr](https://github.com/tesseract-ocr/tesseract) with trained data produced from turning SE's font into a ttf and using that font to train tesseract. While this is still OCR and of course there *will* be missed or mistaken characters, for me, so far in the case of copying gps, there has been none. I have yet to test with copying programmable block scripts or other text sources, but will soon.

**TODO**: fully explain method to produce ttf font and train tesseract


There are 2 scripts:

* gpsSEclip.sh - This script when configured reads the name, x, y and z of a gps from the gps menu and formats as the copy to clipboard function would, it then places it into the clipboard. Should be bound to a hotkey.
* **TODO**: txtselSEclip.sh - This script wrestles focus from the SE window and allows you to draw a box around text in the game to be scanned by tesseract and placed into the clipboard.

## Known/expected problems
* Very small characters not being detected or being mistaken for each other, like . and , or ' and ` (this is not an issue with gps x, y or z coordinates though)
* The font was very much a first pass and I didn't expect such good results, (beginners luck?). I, bearing that in mind, while making the font I grew a tad impatient and seeing as I was at the time focusing on gps. I decided to skip fine tuning brackets, assuming I would return to fine tuning the font later. Namely []{}(). Because they were characters that required the most tweaking and I wanted to get to testing/training tesseract. So because of this brackets may be prone to being mistaken for each other or even other characters, like [] being seen as 0. This will not be good for copying prog block code so I will likely reproduce the font and thus the trained data at some point when working on txtselSEclip.sh.
* I and ! love being mistaken for each other.
* ^ is a problem.

## Requirements
You need (links lead to installation instructions)

* xdotool - (Found in any distro's repositories)
* [maim](https://github.com/naelstrof/maim#installation) - (Should be in most distro's repositories. Can be substituted for scrot or other cli screenshot tools but you'll have to adjust the syntax)
* xclip (Found in any distro's repositories, can be substituted for xsel but you'll have to adjust the syntax)
* imagemagick (Found in any distro's repositories)
* [tesseract-ocr](https://tesseract-ocr.github.io/tessdoc/Home.html) with i think english traineddata/langpack installed (Should be in most distro's repositories, you dont need to install the development package)

## Setup
* Ensure all the above packages are installed
* Place SEfont.traineddata into /usr/share/tessdata/

### gpsSEclip.sh
* Place the script in a place of your choosing
* Make it executable `chmod +x /path/to/your/gpsSEclip.sh`
* Bind it to a hotkey like super+c, different DEs have different tools for this, web search for "[your DE here ie Gnome/Mate] bind script to hotkey", or use sxhkd/xbindkeys.
* Open gpsSEclip.sh in a text editor and 
  1. Follow the instructions to set the gNAME, gX, gY, gZ and SCR_IMG variables.
  * Test run the script with your hotkey while the SE gps menu is active and a gps is selected.
  * Check the images in example_pre_processed_images directory and compare your tempClip images with the examples.
  * Adjust gNAME, gX, gY and gZ if you need to and repeat 2,3 and 4 till satisfied.
  * Un-comment the three `mogrify` commands on line 62, line 74 and line 82.
  * Attempt to copy and paste a gps using your hotkey. If it works you are done.
  * Should you notice it making mistakes (missing or mistaken characters), follow the advice in the scripts comments starting at line 37 to fine tune mogrify's adjustments to the image. Repeat this till you reduce or remove missing or mistaken characters to your satisfaction.
* Some advice. When adjusting mogrify to get better accuracy, if there are just a few characters in the name field failing to be detected correctly but the x y and z fields are persistently correct. It may be beset to settle with what you have, because lets be honest the coordinates are much more important than a few hold out characters in the name. Though I would like to hear about those characters and your resolution / gNAME/X/Y/Z variable values.
* @ me (@Dig#3443) in keens linux discord channel if you need help

**TODO** put all instructions here and make them easier to follow

### txtselSEclip.sh
* **TODO**

@ me (@Dig#3443) in keens linux discord channel if you need help
