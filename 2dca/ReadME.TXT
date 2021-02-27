Author Pseudoname..: Iambian Zenith
Date...............: 02-15-2012, 11:01 AM
Version............: 2.02
Project Title......: 2D Cellular Automata
Platform...........: TI-83/84 Series calculator

--------------------
>Warning: 
THE FOLLOWING SERIES OF DOTS MUST FIT ON ONE LINE.
.............................................................................
DO NOT VIEW THIS DOCUMENT
WITH WORD-WRAP ENABLED.

-------------------- 
>Forward

Made popular by Conway and his "Game of Life", 2-dimensional cellular
automata is a 0-player game, where upon giving it an intial setting, it
plays out the field by itself. The point is to input a setting that keeps
on going for as long as possible. The default settings includes the famous
rule set "Conway's Game of Life" with wrap-around borders for an effectively
infinite playing field, along with whatever image was last found on the
calculator's graph screen.

This program also includes other rule sets in which you can deviate from
the normal Game of Life and see how other rules for 2D cellular automata
work. You may also load and save from image files found on the calculator.

For more information, give this page a good reading:
http://en.wikipedia.org/wiki/Cellular_automaton

Also see this page, since that's what this software starts with:
http://en.wikipedia.org/wiki/Conway%27s_Game_of_Life

-------------------- 
>Usage: To set up

The default settings work well enough.

To change what's on the playing field, select from the main menu "Save/Load".
On the bottom half of the screen is a pair of thumbnails containing what you
want to load from or save over and the game screen, on the left and right
sides, respectively. Pushing up or down will cycle the calculator image
files "Pic0" through "Pic9". Continuing to cycle past these will let you
access default images that are built into the 2D cellular automata program.
You are not able to save over these images but you can always load from them.

To properly read this screen, the arrow in the middle shows in which
direction the data is going. An arrow pointing to the right indicates that
you want to load an image from a file to the game screen, whereas an arrow
pointing to the left indicates that you want to save the game screen to an
image file. To complete the operation, push the 2nd or ENTER button, and the
thumbnails below will change to match each other. When you are done, push
the MODE or CLEAR button to exit back to the main menu.


To change the rule set, select the "Change Rules" from the main menu. From
here, push up or down to cycle through the rule sets. Push the 2nd or ENTER
button to select the rule you want to use. The text below "Current ruleset:"
and "Change rules to:" will match each other. Push MODE or CLEAR to exit
back to the main menu.

The numbers below a ruleset indicate the details of that rule. Since this
program operates on a Moore neighborhood, each cell has eight neighbors. The
"B" indicates the number of neighbors needed for a dead (off) cell to come
back to life. The "S" indicates how many cells are needed as neighbors for
an already alive cell to stay alive (on). valid numbers range from 0 through
8.

If you attempt to select "Custom Ruleset" as a rule set, you will be asked
to enter in these numbers. The first will be the births ("B") rule, and the
second will be the survival ("S") rule. To set these, push the number keys
that correspond to what you want. To clear a number, just push that number
key again. When you are done with that rule, push 2nd or ENTER to confirm
your selection. To go back, push MODE. To clear off all numbers, push CLEAR.
Only after you are done setting the rules will the Custom Ruleset be set.
If you already have a rule set coded in, just push 2nd or ENTER repeatedly,
making no further changes until it is set.

NOTE: It is perfectly acceptable and valid to have an empty ruleset.


To change other options, select "Next" from the main menu, then select
"Options" from this new menu. Pushing 2nd or ENTER on the options menu will
cycle the available settings:

"Wraparound"/"Dead borders" : Wraparound is the default. This causes the
2D cellular automata to "stitch" all sides of the screen so that things
wrap around. Dead borders, on the other hand, simulates dead cells in the
areas you cannot see, thus limiting any growth. This could be useful if you
have any glider guns that you want to keep running indefinitely.

"Fast mode on"/"Fast mode off" : Turning on fast mode will enable the use
of a compatible calculator's 15MHz clock, which is 2.5 times faster than
the original 6MHz clock found on the TI-83 Plus calculators. If you attempt
to enable fast mode on a device that doesn't support it, it will do nothing,
even though it indicates that it should. Not going to fix that.

Push MODE or CLEAR to exit out of the options menu, then push either button
again to make it back to the main menu.

-------------------- 
>Usage: Playing

To begin the 2D cellular automata engine, push "Begin Run" and the program
will start showing you each generation that goes on.

In order to halt the program, push and hold [2nd] or [ENTER].
In order to put the program in step-by-step mode, push [Y=].
After putting it in step-by-step mode, push [2nd] or [ENTER] to step forward
one generation. To take it out of step-by-step mode, push [Y=] again.

To exit the cellular automata, push [MODE] or [CLEAR]. Keep in mind that your
progress is preserved until you exit the program. This feature allows you
to change any settings. When you're ready to go back to playing the game,
you will notice that "Begin Run" has changed to "Continue Run". Select that.

You may also save your progress to an image file by hitting the Save/Load
option and saving to a "PicX" file, where X is a number between 0 and 9. Make
sure that the arrow in the middle is pointing to the left.

-------------------- 
>Controls

From the title screen:
2nd  / Enter = Select option
Mode / Clear = Cancel or quit
Up   / Down  = Move cursor

From the save/load screen:
Left         = Enter SAVE mode
Right        = Enter LOAD mode
Up   / Down  = Cycle pic files / internal image files
2nd  / Enter = Perform SAVE/LOAD action
Mode / Clear = Exit to main menu

From the options screen:
2nd  / Enter = Toggle option
Mode / Clear = Exit to previous menu
Up   / Down  = Move cursor

From the rule change screen:
2nd  / Enter = Change rule to that which is selected
Mode / Clear = Exit to main menu
Up   / Down  = Cycle through rulesets

If you select "Custom Ruleset" from rule change menu:
You will be asked to select "birth" rules, then "survival" rules
in that order.
2nd  / Enter = Accept changes. If you select this from the "birth" rules,
               you'll move on to editing "survival" rules. If you were on
               "survival", then you'll finalize your changes and finish
               selecting the Custom Ruleset as your new rule.
Clear        = Erase data from currently editing rule.
Mode         = Go back or cancel
Number keys  = Apply the rule. If that number is already listed, then it
[0-8]          will remove it.

While the Cellular Automaton is running:
2nd          = Hold to pause the CA
Mode         = Quit CA. Unless you fully exit, you can continue from where
               you left off. You can also change any settings in the meantime
Y=           = Enable step-by-step mode. To advance the CA, you must hit the
               2nd button. To disable step-by-step mode, hit Y= again.

-------------------- 
>Features

* From the Options menu, you can select whether you want the CA field to
  wrap around, or to cut off its edges as a "dead zone".
* If you have a TI-83+SE/TI-84+[SE] calculator, you can select from the
  Options menu to attempt to use 15MHz. If you have a normal TI-83+,
  selecting this option will not do anything.
* You can view thumbnails on any currently select image file, and compare it
  to what is on the CA field at the time. There is visual feedback when you
  successfully complete any options on the Save/Load menu.
* You can create your own rules, so you can play around with the settings, or
  implement a rule that you have seen but isn't a default in my program.
* Images that you can use for good fun comes built into this program. Just
  cycle past all the pic files in the Save/Load menu to get to them.
* You can stop the CA at any time and change options. You can also put the CA
  into step-by-step mode and watch the CA run one generation at a time.


-------------------- 
>Copyright

All content not owned by me:
Copyright (C) to their respective owners.

Everything that I could own:
Copyright (C) 2007-2012 Rodger Weisman (Iambian Zenith)
Rights reserved according to common sense. I expect you to use it.

-------------------- 
>Disclaimer

This software is full of cherries. It may make your calculator delicious.
Please do not eat the calculator. I don't want to be liable for that.
The cherries may clog your calculator's processor. This is normal.
I also don't want to be liable for that.

This software is provided AS-IS. Use at your own risk.

-------------------- 
> Changes

0.10 - Initial conception and creation.
1.00 - Dropped helpsystem support and reduced size (at expense of speed)
1.02 - Supposedly fixed a loading error when the pic file is not archived.
1.03 - (cast as 1.02). Implemented new algorithm, added changing rulesets.
       Fixed long-standing bug with loading images from RAM.
2.00 - Rebuilt from the ground up, with the exception of certain routines.
       Ditched the menu system. Went with something simpler. Changed core
       routines to operate on a vertically-aligned buffer. Much work was done.
2.01 - I never reached 2.00. Too many great ideas from Runer112 kept me from
       finishing the rebuild as it was to be. From optimizations to ideas,
       we're taking LUT abuse to the next level! Too bad the new cheesier
       menu system is nowhere near done at this point.
2.02 - Finished (I think). Added more default patterns and rulesets. Finished
       the menu system. Added a couple of features. Blah blah blah.

-------------------- 
> Building

If you're using a Windows operating system, just copy "spasm.exe" into the
same folder as the source files, and then double-click "Z_MAKE.bat". The
result should build into the same folder as "Cellauto.8xp".

SPASM can be downloaded from here:
http://wabbit.codeplex.com/releases/view/45088

