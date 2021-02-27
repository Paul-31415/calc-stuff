Thank you for downloading Absolute Madness. Slide back, eat your desk, and enjoy
the game!



========    ASCII    ========

________________________________________________________________________________

            --   --  ---     -----   --   -  -----|   ----|   ----|
             |\ /|    / \     |   \  | \  |   |__    |____   |____
             | V |   /---\    |   /  |  \ |   |           |       |
            --   -- --   --  -----   -   --  -----|  |----   |----
________________________________________________________________________________
 


========    INSTALLATION    ========

Use TI Connect or TiLP to download NESS.8xp to your calculator. That's it!

To play, you can run prgmNESS from the home screen or start it from any popular
shell, such as MirageOS or DoorsCS.



========    MENU    ========

Before you even reach the menu, you may see a message telling you that your high
score data has been cleared. This is normal for a first run; it will appear
again if you ever try to tamper with the high score data (stored in list MDATA).
I'm warning you!

At the main menu, use the arrow keys to navigate, 2nd or ENTER to select, and
CLEAR to go back a level or quit.

play:

	Start playing the game.
	
	new:
	
		Starts a new game from level 1.
	
	edit:
	
		Opens the level editor, allowing you to design your own levels. See the
		section below about the level editor for details.
	
	sav:
	
		Opens a submenu to load a saved game. See the section below on saving
		games for more information.

high:

	Opens the high score table; press ENTER to return to the main menu.

quit:

	What do you think, genius?



========    GAMEPLAY    ========

Absolute Madness is a puzzle/action platformer. Your goal is to avoid the
spikes, floating enemies, and falling boulders and reach the right side of the
screen in each level. There are many things that make Absolute Madness unique as
a platformer, so read on!

Left and right:

	Use the left and right arrow keys to move left and right. (Simple, right?)
	
	Rarely, you'll notice that a repeating arrow key (left or right) "misses a
	beat" and leaves you a single block short of where you should be. This is a
	problem only on the faster calculators (TI-83 Plus Silver Edition, TI-84
	Plus, and TI-84 Plus Silver Edition) and is caused by the program running
	a bit faster than the calculator can handle repeating keypresses. (How
	ironic. A TI-BASIC program going too fast.) The simplest way to avoid this
	pitfall is to press and release the arrow keys repeatedly, instead of
	holding it down.

Jumping:

	Use the up arrow key to jump. To jump to the left or right, press the left
	or right arrow keys right after you release the up arrow. It takes some
	practice to get used to this, but it's the only way to handle directional
	jumping in TI-BASIC. Remember you cannot hold two buttons down at a time, or
	the calculator will ignore both of them.
	
	Practice jumping in the first few levels, because by the time you get to the
	more difficult ones, you'll be required to jump precisely. (By the last
	level, you should be fairly adept at perfectly timing your jumps.)
	
	The sequence of a jump is as follows: one frame after you press the up
	arrow, the character moves up one block; the second frame, it moves up
	another block; in the third, it "hangs" in midair; then it starts falling.
	You cannot jump again until after the third frame, when it starts falling.
	You'll notice that if you just happen to land on a block on the second
	frame, pressing up immediately still does nothing; just keep pressing it
	until you do jump. You're always able to move left and right (unless
	something blocks the way, of course).
	
	You can land on anything (literally, anything) with a flat top.

Dimension swapping:

	Beginning in level five (this was supposed to be a surprise), some levels
	begin requiring you to swap between two maps ("dimensions"). Press ALPHA to
	swap. Not all levels have two dimensions, and when there's only one, ALPHA
	does nothing. Swapping into a filled block will cause you to lose a life.

Bonus packs:

	Some levels provide the opportunity to acquire a bonus pack, in the shape of
	two small brackets with an open center. Each bonus pack provides one point;
	five points makes a life. Not all bonus packs are accessible. Levels 4, 8,
	12, and 16 are special "bonus levels" that let you recover some extra
	points (in preparation for some truly insane puzzles).
	
	When you lose a life, all bonus packs in that level are disabled, even if
	they still appear.



========    SAVING    ========

Trust me; you will need this.

During the game, press VARS to open the game save dialog. Select the slot in
which you wish to save by pressing 2nd or ENTER, or press CLEAR to cancel. The
game saves your current level, points, and timer (what?). Your position in a
level is not saved. All data is stored in list MDATA.



========    EDITOR    ========

Absolute Madness has full external level support, including a fully-featured
built-in level editor. Access it from the second game menu.

In the editor, press Y= and WINDOW to switch the active block style, then use
2nd to insert at the current cursor point. Use GRAPH to test a level; you will
return to the level editor as soon as you either die or complete your custom
level.

Levels are stored as lists, and can be stored to any valid TI-83 Plus list name.
Do not use L1, L2, L3, or L4 because they are used by the game itself. Named
lists (lists whose names begin with the small L found in 2nd [LIST] > OPS B:L
followed by one to five letters) are recommended.

Saving levels:

	Press TRACE while in the level editor, and when the program quits press the
	STO> button. "Ans->" should be pasted in your homescreen. Type one to five
	more letters to name your list, then press ENTER.

Opening levels:

	Press ZOOM while in the level editor, and when prompted press 2nd [LIST],
	find your list, and select it. It should be pasted into the prompt screen;
	press ENTER to load.

If you create a level you think worthy of sharing, send it to me! My contact
information is below. Level packs shared with me will be posted in a public
repository for others to enjoy.



========    FILES    ========

Absolute Madness uses many variables. Most are cleaned up upon normal return
(quitting from the main menu). Only the following are really useful at all:

NESS:

	Program NESS contains the entire game. If you want to keep playing, please
	don't delete it (for obvious reasons).

MDATA:

	All saved games and high scores, including high-score names, are saved in
	this list. Please do not have this archived.



========    EGGS    ========

Find four of the five instances of the number 42 hidden throughout the game, and
you get a gold star :)



========    CONTACT    ========

Made by Deep Thought (ti.42.plus@gmail.com)
            a member of

    Omnimaga Coders of Tomorrow
        http://www.omnimaga.org/
        The most hyperactive forum around. Join us in #omnimaga on EFnet!

    Revolution Software
        http://www.revolutionsoftware.org/
        Seven years and counting, and still home to so many amazing projects.

    ClrHome Productions
        http://clrhome.org/
        Come here for suggestions and bug reports. Or just for the heck of it.



========    RIGHTS    ========

Copyright (C) 2011 DEEP THOUGHT

You are free to download, use, and transfer this software at will. If the source
has been made publicly viewable (in the case of TI-BASIC programs, if the
program is not edit-locked), you may assume that you are allowed to edit it as
well, as long as you and the original developer (DEEP THOUGHT) are clearly
identified.