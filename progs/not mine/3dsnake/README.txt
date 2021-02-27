Thank you for downloading Snakecaster. It was compiled using Axe Parser 0.5.3b.
Enjoy!

     __  __  __ |    __  __  __  __ |_  __  __
    |__ |  ||  ||_/ |__||   |  ||__ |  |__||
    ___||  ||_/|| \ |__ |__ |_/|___||_ |__ |

--------------------------------------------------------------------------------
INSTALLATION
--------------------------------------------------------------------------------

Use TI Connect or TiLP to download SNAK3D.8xp to your calculator. That's it! No
other files are needed.

To play, you can run Asm(prgmSNAK3D from the home screen or start it from any
popular shell supporting the Ion format, including Ion, MirageOS, and DoorsCS.

--------------------------------------------------------------------------------
MENU
--------------------------------------------------------------------------------

Some brief instructions are displayed when the program starts. It is not meant
to be complete, only as a quick reminder; please continue reading for detailed
descriptions of controls.

Press 2nd or ENTER to start the game, or press MODE or CLEAR to quit.

--------------------------------------------------------------------------------
GAMEPLAY
--------------------------------------------------------------------------------

After a brief pause of about half a second (to prepare you for a new game or new
level), the game begins. The main game screen is composed of three sections:

+   **2D panel (top-left)**

    This area displays your game in a classic (albeit simplistic) Nibbles
    format. The moving segment is the snake. The flashing dots are the apples.
    Your goal, as always, is to consume as many apples as possible (by running
    over them) without crashing into a wall or into yourself. (Basically, just
    avoid anything that's solid black.)

    Use the arrow keys to navigate the snake in the 2D panel.

+   **3D panel (bottom)**

    This is the fun part. The large bottom panel displays the same game world as
    the 2D panel, but raycasted (first-person 3D from the perspective of the
    snake's head).

    If you choose to use the 3D panel to play the game, you can use Y= to turn
    left and GRAPH to turn right. Note that this is different from the arrow
    keys in the 2D panel: when you press an arrow key, you move in that
    direction, but if you press Y= or GRAPH, you turn toward that direction.

    Also note that the two panels show exactly the same game. If you change
    direction with the arrow keys, you'll also turn in the 3D panel; if you turn
    with Y= or GRAPH, you also change direction in the 2D panel.

+   **Info panel (top right)**

    The top-right section of the screen displays the current level number and
    the number of points you have. In addition, it displays the bonus count,
    which (rounded down) is the number of points added to your score when you
    consume the next apple.

    The bonus count starts at 10.0 and counts down as the snake moves. If you
    reach an apple after the bonus count reaches zero, no points are awarded.

Each time the snake consumes an apple, it grows in length. In the first level it
grows by four segments, in the second it grows by six, in the third eight, and
so on. When the snake gets long enough, the next level begins with a new pattern
of walls. After eight levels, you win.

--------------------------------------------------------------------------------
AUTHOR
--------------------------------------------------------------------------------

Copyright (C) 2011 DEEP THOUGHT (ti.42.plus@gmail.com), a member of:

+   **[Omnimaga Coders of Tomorrow](http://www.omnimaga.org/)**

    The most hyperactive forum around. Join us in #omnimaga on EFnet!

+   **[Revolution Software](http://www.revolutionsoftware.org/)**

    Seven years and counting, and still home to so many amazing projects.

+   **[ClrHome](http://clrhome.org/)**

    Come here for suggestions and bug reports. Or just for the heck of it.
    ClrHome is home to many active calculator projects and online tools.

You are free to download, use, and transfer this software at will. If the source
has been made available to the public (in the case of TI-BASIC programs, if the
program is not edit-locked), you may assume that you are also allowed to modify
and redistribute the program with your modifications, so long as both the
original author (DEEP THOUGHT) and the person making any modifications are
clearly identified.
