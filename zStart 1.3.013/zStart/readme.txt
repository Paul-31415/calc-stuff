zStart by Brian Coventry aka thepenguin77

This app truly is the "swiss army knife" of utility apps for the 84+. zStart runs on every ram clear to
setup your calculator environment to do just about anything you want. Features include: Mathprint/Classic,
Degrees/Radians, Diagnostic On/Off, fixing lcd (ALCDFIX), setting contrast, running archived programs, 
editing archived programs, displaying 8 level grayscale picture on startup, running programs on ram 
clears/startup, custom fonts with an on-calc editor, enabling Axe, shortcut keys to run programs/compile
axe programs/recall tokens, enabling omnicalc/catalog help, copy/paste, base conversions, molar mass 
calculations, 14% speed increase in basic programs, and more!

There's my ticalc.org description, this app basically does whatever you want it to, plus, it is fully
expandable to run your own programs when it runs.

*If something goes wrong*
	If something doesn't work right and your calculator isn't turning on correctly, just hold VARS.
	Holding VARS will tell zStart to do nothing. For more info, check "Running on Ramclear"

	I don't expect anything to go wrong as 99% of the time everything works correctly. I'm just putting
	this here so it's easy to find.


Also, I don't update ticalc.org as much as I update omnimaga.org. So for the most recent version of zStart:

1. Go to this page: http://www.omnimaga.org/index.php?action=ezportal;sa=page;p=13&userSearch=thepenguin77
2. Scroll down to "Signature:"
3. Click on the link to zStart


zStart    -> 83+ Silver Edition, 84+ Basic Edition, 84+ Silver Edition
zStart83  -> 83+ Basic Edition


One more thing: zHelp.8xp is the new on-calc readme. I suggest running it. (After enabling "run from home" of course)


;###############################
	Features 
;###############################

Here is the full list of features sorted by awesomeness:

running on Ram Clears
setting Mathprint/Classic
setting radians/degrees
fixing lcd (ALCDFIX)
setting contrast
running archived programs
editing archived programs
8 level grayscale picture on start up
running programs on ram clears/startup/zStart
custom fonts with an on-calc editor
integration with Axe:
	- compiling programs from the homescreen
	- enabling Axe's token hook
shortcut keys to run programs/compile programs/recall tokens
enabling omnicalc/catalog help
copying/pasting in basic programs
base conversions
molar mass calculations
%14 speed increase in anything running from flash (all basic programs)
classic style ram clears on MP OS's
jumping straight to a Lbl in basic programs
disabling stat wizards
killing the MP popup
executing from memory addresses over $C000
archiving programs from the PRGM menu
archiving all programs
RCLing archived programs
safe ram clears (archive all, clear ram, unarchive them back)
allow calculator to function with headphones in (normally freezes)
hooks/appvars are only created if they are going to be needed


and don't forget, these options get reinstalled after every single ram clear

	(or if you refuse to use a supported OS, it appears last in the app list)





;###############################
	This Readme
;###############################

First, this readme is going to list all of the features of this app by how they actually appear in the app,
after that, I'll go over all of the things that aren't immediately apparent, like the shortcut keys and 
molar mass/base conversions.


;##############################
	Installed
;##############################

This is basically just the master flag for the app. If this says no, zStart won't do a single thing.


;###############################
	Set Picture
;###############################

This allows you to have a 8 level grayscale picture appear whenever you turn your calculator on.

This is the final product of my other project level8.

to make your own pictures:

1. Download gimp. (Photoshop will work too, but you will have to figure it out yourself)
2. Open your picture
3. Get the picture down to 96 pixels wide by 64 tall
4. Desaturate the picture
5. Image > mode > indexed. Select 8 colors
6. Back to RGB mode
7. Save the picture as a .bmp and make sure it saves in 24 bit mode.
8. Put the picture in the same folder as level8.exe
9. Double click on doubleClickMe.bat
10. Now use level8.exe to convert it. Type:     level8 picture.bmp picture.8xp    replace picture with your file name

			 so for a file name called "brian", I would type in: 	level8 brian.bmp brian.8xp


While viewing the picture, you can also adjust the contrast with +/- and the refresh rate with *//. Setting the refresh
rate correctly will lead to nearly perfect grayscale.


;#################################
	Set Defaults
;#################################

This allows you to customize what you want your default settings to be:

Angle: Radians or Degrees
Diagnostic: On or Off        (this is the R and R^2 in lineReg)

These two are for OS 2.53
	MathPrint: MathPrint or Classic    
	Kill pop up: Yes or No        (This automatically kills the stupid reminder pop up)

This is for OS 2.55
	Stat wizards: yes or no		(do you want the new stat wizards or not?)


;###################################
	Catalog Help
;###################################

This turns on catalog help. But this also actually prevent catalog help from crashing when the extra ram page is used.


;####################################
	OmniCalc
;####################################

Turns on OmniCalc with whatever settings you want.

1. Go into OmniCalc and get it all set up.
2. Go into zStart, save settings, and activate it

Use the version of OmniCalc that I included. Which is 1.26, (as of 9/2/2012, the most recent)

I know there is a problem with Omnicalc's memory restore, I need to upload this update, but if it becomes a problem for you,
  email me a few times until you finally convice me to fix it. (I almost want you to do this)


;####################################
	Hardware
;####################################

Save contrast: put your contrast where you like it and select this

Get delay: This fixes the problem of games being all garbled on calcs with slow LCD drivers. (ALCDFIX)
	Just click on this once and never worry about it again

Reset those: This zeros "Save Contrast" and "Get Delay"

Use fast memory timings: TI adds in a stupid delay for the calculator when it is running in 15MHz mode, 
	this removes it, you can expect a 14% speed increase in anything that runs from flash

Execute >C000: TI also added in a stupid protection that makes the calculator crash if execution proceeds to 
	an address that is above C000h. Setting this removes that protection.

;#####################################
	Run on Ram Clear
;#####################################

Here it is. This is why this App is so useful.

========Warning!!!============== 
Do not install if your batteries are low. 
Don't pull out your batteries while it is installing.

Doing these two could result in destroying your OS. (Which can be resent, so don't worry too much)

Also for good measure, uninstall this before you delete zStart, although, there shouldn't be any negative effects.
================================


Ok, enough warnings. Installing and uninstalling is very easy, I even added a loading bar.

This only works on versions 1.19, 2.43, 2.53, 2.55. Although it says success on other versions, it doesn't actually do anything.


Now, I have never had any trouble with this, but if you do, there are a few things you can try.

1. Holding VARS while you clear ram will make zStart not run. Then you can fix the culprit setting.
	
2. This actually isn't related to zStart, but I had to code for it. If your calculator won't boot while holding VARS,
	try holding CLEAR. This will tell the OS not to even look at the archive. Your calculator should boot, however,
	it will not show any programs in the archive. If this is the case, your archive is corrupted and you should look
	online for help. (A mem clear will fix it)


Old RAM Clear: If you have 2.53 or 2.55, TI changed the ram clear screen, this changes it back

;####################################
	Custom Font
;####################################

This allows you to use your own fonts

Controls for the editor:
	2nd / enter - toggle pixel
	Alpha - show all characters and select one
	Arrows - move
	Clear - save and quit
	+ - forward a character
	- = backward a character
	* = forward 16 characters
	/ = backward 16 characters

You can't edit character D6 because it is "enter" and is very glitchy.

These don't work on the 83+ edition, sorry... (but hey, zStart didn't use to work at all on the 83+BE)


;####################################
;	Program Settings
;####################################

Shell: This is the shell used to run asm programs, if you leave it at None, there is a chance
	That certain games that need a shell will crash. (I included the ION libraries, but for the Mirage and DCS
	libraries, you actually have to have them on your calc.)

Turning on: This is the program that runs when you turn your calculator on, this option is here so you can disable it

Ram Clears: This is the program that runs when you have a ram clear, this option is here so you can disable it

On zStart: This runs a program after zStart installs all of its settings, there are quite a few rules on this

Run from home: This sets up a parser hook to run archive/unarchive basic/asm programs from the homescreen. In the event
	that an archived basic program encounters an error, zStart will open an archived program edit session on the 
	basic program, so really, you'll never even know it's archived.

Parser hook chain: This allows you to chain to other parser hooks. Basically, if there is an app that allows you to 
	change the way the BASIC Parser works (like xLib, zChem, Symbolic, etc) then you can chain to it with this

  Steps for chaining:
    1. The chain must exists in an app (it can't be a program that you run)
    2. Install the other chain (you usually just run the app)
    3. Go into zStart and run this option
    4. If all went well, zStart should show the name of the other app and you should be good to go

    5. Press this option again to uninstall the chain



Developers: If you are going to use zStart to run your program, you need to realize that the header you use
	matters. If you use a shell header, zStart will act like your program is running from a shell
	and it will set up memory accordingly. When the program is done, zStart will also do the normal cleanups
	that a shell would do.

	What this means is that if you are going to have your program run on Ram Clears, you probably should not
	use a header so that the ram clear appears to go as normal. zStart will run your program right before
	the calculator displays "RAM Cleared," so any changes you make will show up. But if you don't care, go 
	ahead and run a game or even an app, your calculator just won't look normal anymore.

Running on zStart: I added this option in to make zStart really customizable, you are basically executing code
	just like I do, which means there are some rules. Firstly, you can't touch $8000-$8100, this is where I 
	have the appVar stored, so if you clear it, you'll destroy your appvar. Secondly, this has to be a program,
	apps don't return, and if it doesn't return, I can't archive the appVar. Lastly, you really should make this
	program a Ti-OS program and you shouldn't touch the screen, you can disobey this, but you really shouldn't.

	Also, I run this program after I've installed all of my settings, so if you're going to install a hook, 
	please chain to mine ;)



;####################################
;	Axe Settings
;####################################

Enable Hook: This will enable the axe token hook

Compile for: this is the same option that's inside axe


;#####################################
;	Shortcuts
;####################################

Here is a really cool feature of zStart, I've added in all kinds of shortcut keys that do stuff 
that you normally can't do, here is the list going down the calculator

(This list also exists in zHelp and zHelpLit (zHelp is more descriptive too!))

	
ON + Y= 			Use this to make headphones not crash the calculator, (you have to disable it to send stuff though)
ON + Stats			Instant APD (Auto Power Down), it's just like letting your calculator sit for 5 minutes
ON + Math			Toggle MathPrint (OS 2.53+)
ON + Apps			Run MirageOS
ON + Prgm			Run DoorsCS versions 9-5 (higher versions have more priority)
ON + Vars			Archives all programs
ON + Clear			Restores all of zStart's hooks, (like opening and closing it)
ON + Sin			Switches between degrees and radians
ON + ^				Kills all hooks that zStart uses
ON + /				Changes the Compile For: for axe
ON + numbers homescreen		Executes the shortcut associated with that key
ON + numbers exec prgm screen	Set running this program as a shortcut
ON + numbers edit prgm screen	Set axe compiling this program as a shortcut
ON + numbers apps screen	Set running this app as a shortcut
ON + numbers token menus	Set this token as a shortcut
ON + * prgm screens		Archive this program
ON + +				Enable base conversions
ON + 0 prgm screen		Set this prgm to run on zStart
ON + . prgm/app screen		Set this prgm/app to run on ram clear
ON + (-) prgm/app screen	Set this prgm/app to run when turning on
ON + Enter prgm exec screen	Run this prgm
ON + Enter prgm edit screen	Have Axe compile this prgm

Program Editor shortcuts:
ON + Zoom			Axe compile (zoom mode) and then run
ON + Trace			Axe compile and then run
ON + Del			If editing archived program, quits without saving
ON + Vars 			Brings up a list of all Lbl's so you can jump to them
ON + ^				Pastes whatever was last deleted with CLEAR (undo)
ON + *				Archives the program you are editing
ON + Sto			Compile the currently editing program with Axe and quites
ON + +	 			Puts the current line in the clipboard (4000 byte max)
ON + Enter 			Paste whatever is in the clipboard

A few notes about these
	- Except the program editor ones, you have to be at the homescreen for these to work
		the MATH menu is fine, but Y= is not
	- You can probably figure out what most of these do by just trying them, most give a message
	- When assigning shortcuts, you have to press the button twice



;#######################################
	Prgm Editor
;#######################################

Firstly, with zStart, you can edit archived programs. When you edit them, it makes a temporary copy
of the program in ram, and that is what you edit. Then when you quit, the temporary copy replaces the original
copy. I did this so that you can crash your calculator while editing and you still won't lose your program. 
In reality, you really should just leave your programs in the archive.

For the temporary copy, I changed the last letter of the name, that's why it looks weird.


The Lbl Menu:
 	If you press ON + VARS while editing a program, a list of all the Lbls pops up. Just move around to select
	the label you want to jump to.

Copying and pasting:
 	This is pretty straight forward. Press ON + PRGM to copy. ON + Enter to paste. Just remember that you
	can't copy more than 4000 bytes. But you wouldn't need to do that unless you are trying to break 
	something. ;) 

	You only get 380 bytes on the 83+ due to memory restrictions (this is still more than you need though)


;#####################################
	Base Conversion
;#####################################

This is a parser hook that allows you to convert hexidecimal and binary into decimal. It doesn't run inside basic
programs, and it's pretty hacky. So, if you're not using it, it's best to disable it with ON + CLEAR or similar.

Baser Converter:
	This converts binary and decimal. Enable it with ON + +. To make a number hexadecimal, put a h after it.
	To make a number binary, put a b after it.

	FFFFh = 65,535, 10011101b = 157

	Then, if you want to convert the answer to another base, use Omnicalc's base conversion. Enable it with
	ON + LOG and then you can have your answers in hex or binary




Molar mass converter:
	This used to be part of zStart but I had to move it into zChem for space reasons, it has it's own readme


;#####################################
	API entry points
;#####################################

If you're an assembly programmer, then I have some cool API entry ponts for you:

Since 1.3.005:
 - 408Ah - install all of zStart's hooks
	uses the $8000-$8100 region
 - 408Dh - RunOp1
	this returns carry if the program thinks it was run from a shell, this means it might require a bit
	  more cleanup than usual
 - 4090h - EditOp1 (using the TI-OS editor)
	(errOffset) is the offset that the editor will start at


The best way to check if these exist in a version of zStart is to check the address for a jump ($C3), if it is a 
  jump, then the entry point works

;#####################################
	Miscellaneous
;#####################################

VARS and CLEAR will both stop zStart from running on ram clears

If you have omnicalc installed, or the running programs parser hook, zStart will make a fake program entry
that is always at the very start of the VAT. To save space, I use it's name as storage. If you see it, don't
worry, it's not a glitch. (It will always move itself back to the start and will always revert any changes you 
make to the name, so feel free to play with it)

I try to make zStart as environmentally friendly as possible, this means I only create hooks if I need to and I typically
backup hooks if I need to make a temporary one. The same goes for OFFSCRPT/ONSCRPT, I only make them if you enabled an
option that actually needs them. Lastly, all of my hooks chain seamlessly with Omnicalc, so zStart and omnicalc both
work at the same time.

I know there is a problem with Omnicalc's memory restore, I need to upload this update, but if it becomes a problem for you,
  email me a few times until you finally convice me to fix it. (I almost want you to do this)



;#####################################
	Modifying
;#####################################

Really I leave zStart up for modifying. Since it is running on ram clear you might as well make use of it yourself.

All you need to do is make a spot in the appVar, make yourself a new menu, and make it do something when exiting. 


Also, if you don't feel like messing with my app, I left three spots for you to do stuff: ram clears, turning on,
and running every time zStart runs. This should really be all you could ever need.


And don't just copy and paste my code, that's no fun. You can steal routines, but don't steal the whole thing. And of course
I would love some credit :D.


;#######################################
	Change log
;#######################################

Changes since 1.3.000
 - Lot's of fixes relating to basic programs
 - Fixes with the basic label menu
 - Added Undo in basic menu
 - Added quitting without saving on archived basic programs
 - Fixed Goto when error memory on assembly program
 - Added instant APD
 - Added the ability to run MirageOS
 - Added the ability to run DCS
 - Added the ability to compile axe programs straight from the editor
 - Copy changed from [Prgm] to [+]
 - Max copy size decreased to 2900 bytes
 - Ability to edit archived programs by pressing their number
 - 2nd + Format and 2nd + TblSet no longer screw up the program editor
 - Added API entry points


Changes since 1.3.005 (the most recent ticalc.org version)

v1.3.006
 All of these changes apply to the program editor
 - [ON] + [* ] - archive the current program
 - [ON] + [Zoom] - Zoom compile, test, and re-edit the program (works in basic too)
 - [ON] + [Trace] - Regular compile, test, and re-edit the program (works in basic too)
 - [ON] + [Sto] - Regular compile and re-edit the program
 - All goto's are now instant goto's (like on basic errors)
 - The Lbl menu now supports mid-line Lbl's (Btm now goes to the very end also)
 These ones don't apply to the program editor
 - You can now reset your contrast and LCD delay settings
 - The LCD delay setting will remember the lower two bits of your port $29 setting
 - API program editing now works better
 - API program running can support apps (silly, I know)

v1.3.007
 - Initial TI-83+BE release

v1.3.008
 - Fixed a bunch of Error Undefined's on new ram programs
 - There is now a separate 83+ version. I even gave it it's own name and appvar.

v1.3.009
 - Added running on RAM clear for 83+
 - Added on-calc readme
 - Added parser hook chaining
 - Added Execute >C000 for 83+
 - Added permanent lower case active
 - Added 5 letter names to label menu
 - Fixed pictures on 83+
 - Fixed running when turning on on 83+
 - Fixed token shortcuts on 83+
 - Fixed Err:Undefined when doing ON + DEL program editor
 - Fixed copy/paste/undo for the 83+ (though you only get 380 bytes)
 - Fixed program editor recall stuff
 - Fixed catalog help related stuff
 - Changed ON + num in edit menu to edit rather than compile
 - Removed chemistry stuff - now in zChem.8xk
 - Removed auto-complete in label menu

v1.3.010
 - Fixed - quitting a basic program during Input/Prompt now deletes the temporary file
 - Fixed - hook chaining now works!!!
 - Fixed - weird label menu glitch
 - Fixed - execute >C000 doesn't crash on 83+BE
 - Fixed - some sillyness with Axe names that are a single .
 - Changed - ON + STO now goes back to the homescreen

v1.3.011
 - Fixed the issue with it freezing on inputs
 - Fixed crashing when trying to install on the wrong OS
 - Fixed (probably) the C000 issue a few people had on 83+BE's
 - Fixed an issue involving interrupts and port (07)

v1.3.012
 - Fixed - run on ram clear installer
 - Fixed - apd re-enabled when zStart quits

v1.3.013
 - Added - ON + MATH - toggle MathPrint
 - Fixed - run on ram clear (it finally works)
 - Fixed - a few graphical issues within the app
 - Fixed - Setting shortcuts is a little faster


;#########################
	Contact
;#########################

If you need to contact me or if you have an awesome idea for an extra feature you can:

email me at bcoventry77@gmail.com	
	or
pm me at omnimaga.org  thepenguin77






























