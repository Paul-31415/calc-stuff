TI-Freakware Contest ID 57

##########################################################################################################
# _____   _____   _   _   _____   _       _____        _____   _____        ___   _____   _____   __   _ # 
#|  _  \ /  _  \ | | | | |  _  \ | |     | ____|      |  _  \ |  _  \      /   | /  ___| /  _  \ |  \ | |# 
#| | | | | | | | | | | | | |_| | | |     | |__        | | | | | |_| |     / /| | | |     | | | | |   \| |# 
#| | | | | | | | | | | | |  _  { | |     |  __|       | | | | |  _  /    / / | | | |  _  | | | | | |\   |# 
#| |_| | | |_| | | |_| | | |_| | | |___  | |___       | |_| | | | \ \   / /  | | | |_| | | |_| | | | \  |# 
#|_____/ \_____/ \_____/ |_____/ |_____| |_____|      |_____/ |_|  \_\ /_/   |_| \_____/ \_____/ |_|  \_|#
##########################################################################################################

Best viewed in Notepad Maximized WordWrap Ti83Pluspc font or font with spacing equivalent.

==================================
=      Double Dragon 1.0.0       =
= By Chipmaster: Patrick Stetter =
=           7.30.06              =
==================================

--------------------
-Table of Contents:-
--------------------
1. Introduction
-1.1 Installation Requirements
-1.2 How to Install
-1.3 Build
-1.4 A Few Words

2. Plot
-2.1 Intro
-2.2 Game Objectives

3. Controls
-3.1 Menus
--3.1.1 Main Menu
--3.1.2 HighScore
--3.1.3 Others
-3.2 Movement
-3.3 Fighting
-3.4 Objects
-3.5 Special Keys

4. Save/Loading
4.1 How to Save
4.2 How to Load
4.3 Cheating Prevention
4.4 The Appvar

5. HighScores
5.1 How to Make One
5.2 How to View

6. Tips
6.1 Dealing With Size
6.2 Gameplay Tips

7. Closing Words

8. Previous Builds

9. Bug Fixes

10. License Info

11. Contact Information

12. Credit




===
=1=  Introduction
===

=====
=1.1=
=====
	Double Dragon requires a TI83+, TI83+ Silver Edition, TI84+, or TI84+ Silver Edition.  The game is approximately 16KB on computer and 15393 bytes on calculator.  Also an appvar of size 44 bytes will be created as needed on calculator and resides in ROM when the game is not running, and RAM while it is.  Double Dragon also requires MirageOS (not ION) or another shell that can play MOS files.  While the game is not running, it may reside in ROM, and be moved to RAM when run from MirageOS or stay in RAM permanentally.

=====
=1.2=
=====
	To install the game you may use Graphlink, TI Connect, or TILP.  If you use TI Connect, simply select the Double Dragon.8xp file, right click it, select send to TI device.  Also, you will need MirageOS or compatible shell to run Double Dragon.  You can get MirageOS at http://www.ticalc.org/archives/files/fileinfo/139/13949.html.  After you send the file to your calculator and Mirage is on your calculator, just run Mirage (through the Apps Menu), and a program called Ddragon will apear under the programs list.  You can further customize it by putting it in a folder and allowing Mirage to display program images (from Mirage [Alpha][2nd][Down][Down][Down] and make sure it is checked).

=====
=1.3=
=====
	The current build is 1.0.0.   This is the first release of Double Dragon intended solely for participation in the TI-Freakware Contest.  A subsequent public release will be made after such an action is approved by TI-Freakware for contest purposes.

=====
=1.4=
=====
	Double Dragon represents weeks of very intense work put forth by myself.  I've tried my best to make the game as enjoyable as possible for the user.  I ask you, the user, to enjoy the game.  The original idea for the game came from a childhood game.  I used to play Double Dragon for my Gameboy.  I loved the game, and I thought it would be the perfect program to remake for the calculator.  I hope you enjoy the game, and that my asm headaches haven't been for nothing.  I don't have that much to say, so I'll just say this:  Enjoy.


===
=2=  Plot
===

=====
=2.1=
=====
	As the Nintendo version goes, your girlfriend gets kidnapped by a gang, the TI Mafia in this case (I know, super original, right?).  You are knocked down and they get away.  You then have to fight your way, through various levels battling the mob to rescue your girlfriend.

=====
=2.2=
=====
	The goal of the game is to stay alive as long as you can and defeat the TI Mafia to save your girlfriend.  Each level gets more and more challenging and introduces new weapons for you to use against your opponents.  Utilize the weapons wisely to defeat the TI Mafia.


===
=3=  Controls
===

=====
=3.1= Menus
=====

=======
=3.1.1=
=======
	To use the Main Menu, simply scroll up and down using the Up and Down arrows, and press 2nd to select the option of your choice.  Alternately, you can press the number corresponding to that option.

=======
=3.1.2=
=======
	To set a New High Score, press up and down to select the character, right to move over a character, delete or left to backspace and enter to enter the name.  Max of 20 characters.  To view a highscore, simply select it from the Main Menu, and press any key (other than 2nd) to return.

=======
=3.1.3=
=======
	The other Menus can be accessed in a similar way as the highscore menu.  Also the opening screen can be advanced quickly by pressing enter.

=====
=3.2=
=====
	Double Dragon features 8 directional movement.  To move your character use the arrow buttons.  Left and Right move the character left and right.  Up makes the character jump.  Down makes him crouch.  Also, combinations of these will work as well.  For instance down right will make the character crouch and move right.  Up Left will make the character jump up and to the left.  Also when in the air you can move left and right by simply pressing left and right.

=====
=3.3=
=====
	In Double Dragon you can punch, kick, and jump kick your oponents in hand-to-hand combat.  To punch, press 2nd.  To Kick, press Alpha.  To Jump Kick, jump into your opponent.

=====
=3.4=
=====
	Also in Double Dragon, you have the ability to use some of the object around you to fight your enemy.  To pick up an object, move over it and press Link (the [X,T,Theta,n] button).  To use it press 2nd.  If it is a box, it will be thrown and cannot be used twice.  If it is a pipe, you swing it around your body and can be used as many times as you wish.  If it is an Ax you can chop with it and it can be used as many times as you like.  You can put down an object at any time by pressing the Link button again.

=====
=3.5=
=====
	While playing the game there are a few special keys.  Clear brings up the pause menu where you can continue your game, exit with saving, or exit without saving.  Enter pauses the game.  Sto-> will exit the program fast to Mirage (teacher key).  And Mirage Interrupts work with the game so they can be used as well (ie.  On+Mode will quit to the homescreen directly).


===
=4=  Saving/Loading
===

=====
=4.1=
=====
	To save your current game, press clear.  That will bring up the pause menu.  From there press 2 to quit and save.

=====
=4.2=
=====
	To load your last saved game on the main menu select option 2 (Continue Game).

=====
=4.3=
=====
	To prevent cheating, a saved game can only be loaded from once.  So you have to resave if you have continued a game and want to play it again.  This is to prevent people from having unlimited tries at beating a difficult part of the game.  Unfortunately, using a fast quit method (Sto-> or On+Mode will not save the game and you will lose all progress and not be able to load from the last point again).

=====
=4.4=
=====
	The appvar that the game creates is for storing the saved game.  If you are upgrading from a previous version it may be necessary to delete the appvar for compatibility issues.  If you delete the appvar at any time, you will lose your currently saved game.  The saved game is not encrypted, and I don't plan on it.  I'm not going to stop you from getting calcsys and looking at the source and editting the appvar.  It's your game once you download it, so do what you will.  I just hope that most users will want to play the game honestly.


===
=5=  HighScores
===

=====
=5.1=
=====
	After you are defeated or beat the game, the calculator will determine if you have the highest highscore.  If you do, you will be prompted to enter your name.  See 3.1.2 for more info.

=====
=5.2=
=====
	To view a highscore simply select it from the main menu.


===
=6=  Tips
===

=====
=6.1=
=====
	To deal with the large file size I would recommend that you keep both DDragon.8xp and DDragon (the appvar) in archive and only unarchive them with MirageOS when you are playing them.  By using this method with all of your games you can free up enough ram to play them, and only use up ROM (which you have more of...probably).  Some may ask why I didn't just make this an app.  To them I say that I wanted this game to be run from Mirage, I don't see much difference if you keep it in archive until you use it, and it's cool because it's size is over the 8kb limit for asm programs (well, that's the general rule of thumb, although the actual rule is more complex).

=====
=6.2=
=====
	This game is a button masher at heart.  You want to jump around and make full use of your movement when in combat.  Also take advantage of the crouch.  You can be hit when crouching so this gives you a strategic advantage against your foes.  Use the weapons around you.  Weapons do more damage and accrue more points than punching or kicking, so use them.  Lastly, on the tougher enemies, have patience.  Although it seems like they will never die, they will.  And going crazy and losing control is not going to help you win the game (and might actually slow down killing the opponent).

===
=7=  Closing words
===

	There's not an awful lot to say.  I enjoyed making the game.  I hope you enjoy playing it.


===
=8=  Previous Builds
===

-1.0.0 First Release


===
=9=  Bug Fixes
===

-1.0.0 First Release


====
=10=  License Info
====

	The source of this program is to be open to the public.  This comes with a few limitations.  First and foremost:  You cannot release another version of this game without my permission (and it must be released with me as a coauthor).  The use of any routines from this source that are mine (routines by others will be stated later on) can be used in your programs as long as you give credit.  Other than that, feel free to explore the source.  Oh, and just for my own protection, I figure I'll include the GNU General Public License because that might catch some loop holes that I've missed in the 2 minutes I spent typing this section.




GNU General Public License
Table of Contents

    * GNU GENERAL PUBLIC LICENSE
    *
          o Preamble
          o TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
          o How to Apply These Terms to Your New Programs

GNU GENERAL PUBLIC LICENSE

Version 2, June 1991

Copyright (C) 1989, 1991 Free Software Foundation, Inc.  
51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA

Everyone is permitted to copy and distribute verbatim copies
of this license document, but changing it is not allowed.

Preamble

The licenses for most software are designed to take away your freedom to share and change it. By contrast, the GNU General Public License is intended to guarantee your freedom to share and change free software--to make sure the software is free for all its users. This General Public License applies to most of the Free Software Foundation's software and to any other program whose authors commit to using it. (Some other Free Software Foundation software is covered by the GNU Lesser General Public License instead.) You can apply it to your programs, too.

When we speak of free software, we are referring to freedom, not price. Our General Public Licenses are designed to make sure that you have the freedom to distribute copies of free software (and charge for this service if you wish), that you receive source code or can get it if you want it, that you can change the software or use pieces of it in new free programs; and that you know you can do these things.

To protect your rights, we need to make restrictions that forbid anyone to deny you these rights or to ask you to surrender the rights. These restrictions translate to certain responsibilities for you if you distribute copies of the software, or if you modify it.

For example, if you distribute copies of such a program, whether gratis or for a fee, you must give the recipients all the rights that you have. You must make sure that they, too, receive or can get the source code. And you must show them these terms so they know their rights.

We protect your rights with two steps: (1) copyright the software, and (2) offer you this license which gives you legal permission to copy, distribute and/or modify the software.

Also, for each author's protection and ours, we want to make certain that everyone understands that there is no warranty for this free software. If the software is modified by someone else and passed on, we want its recipients to know that what they have is not the original, so that any problems introduced by others will not reflect on the original authors' reputations.

Finally, any free program is threatened constantly by software patents. We wish to avoid the danger that redistributors of a free program will individually obtain patent licenses, in effect making the program proprietary. To prevent this, we have made it clear that any patent must be licensed for everyone's free use or not licensed at all.

The precise terms and conditions for copying, distribution and modification follow.
TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION

0. This License applies to any program or other work which contains a notice placed by the copyright holder saying it may be distributed under the terms of this General Public License. The "Program", below, refers to any such program or work, and a "work based on the Program" means either the Program or any derivative work under copyright law: that is to say, a work containing the Program or a portion of it, either verbatim or with modifications and/or translated into another language. (Hereinafter, translation is included without limitation in the term "modification".) Each licensee is addressed as "you".

Activities other than copying, distribution and modification are not covered by this License; they are outside its scope. The act of running the Program is not restricted, and the output from the Program is covered only if its contents constitute a work based on the Program (independent of having been made by running the Program). Whether that is true depends on what the Program does.

1. You may copy and distribute verbatim copies of the Program's source code as you receive it, in any medium, provided that you conspicuously and appropriately publish on each copy an appropriate copyright notice and disclaimer of warranty; keep intact all the notices that refer to this License and to the absence of any warranty; and give any other recipients of the Program a copy of this License along with the Program.

You may charge a fee for the physical act of transferring a copy, and you may at your option offer warranty protection in exchange for a fee.

2. You may modify your copy or copies of the Program or any portion of it, thus forming a work based on the Program, and copy and distribute such modifications or work under the terms of Section 1 above, provided that you also meet all of these conditions:

    a) You must cause the modified files to carry prominent notices stating that you changed the files and the date of any change. 
    b) You must cause any work that you distribute or publish, that in whole or in part contains or is derived from the Program or any part thereof, to be licensed as a whole at no charge to all third parties under the terms of this License. 
    c) If the modified program normally reads commands interactively when run, you must cause it, when started running for such interactive use in the most ordinary way, to print or display an announcement including an appropriate copyright notice and a notice that there is no warranty (or else, saying that you provide a warranty) and that users may redistribute the program under these conditions, and telling the user how to view a copy of this License. (Exception: if the Program itself is interactive but does not normally print such an announcement, your work based on the Program is not required to print an announcement.) 

These requirements apply to the modified work as a whole. If identifiable sections of that work are not derived from the Program, and can be reasonably considered independent and separate works in themselves, then this License, and its terms, do not apply to those sections when you distribute them as separate works. But when you distribute the same sections as part of a whole which is a work based on the Program, the distribution of the whole must be on the terms of this License, whose permissions for other licensees extend to the entire whole, and thus to each and every part regardless of who wrote it.

Thus, it is not the intent of this section to claim rights or contest your rights to work written entirely by you; rather, the intent is to exercise the right to control the distribution of derivative or collective works based on the Program.

In addition, mere aggregation of another work not based on the Program with the Program (or with a work based on the Program) on a volume of a storage or distribution medium does not bring the other work under the scope of this License.

3. You may copy and distribute the Program (or a work based on it, under Section 2) in object code or executable form under the terms of Sections 1 and 2 above provided that you also do one of the following:

    a) Accompany it with the complete corresponding machine-readable source code, which must be distributed under the terms of Sections 1 and 2 above on a medium customarily used for software interchange; or, 
    b) Accompany it with a written offer, valid for at least three years, to give any third party, for a charge no more than your cost of physically performing source distribution, a complete machine-readable copy of the corresponding source code, to be distributed under the terms of Sections 1 and 2 above on a medium customarily used for software interchange; or, 
    c) Accompany it with the information you received as to the offer to distribute corresponding source code. (This alternative is allowed only for noncommercial distribution and only if you received the program in object code or executable form with such an offer, in accord with Subsection b above.) 

The source code for a work means the preferred form of the work for making modifications to it. For an executable work, complete source code means all the source code for all modules it contains, plus any associated interface definition files, plus the scripts used to control compilation and installation of the executable. However, as a special exception, the source code distributed need not include anything that is normally distributed (in either source or binary form) with the major components (compiler, kernel, and so on) of the operating system on which the executable runs, unless that component itself accompanies the executable.

If distribution of executable or object code is made by offering access to copy from a designated place, then offering equivalent access to copy the source code from the same place counts as distribution of the source code, even though third parties are not compelled to copy the source along with the object code.

4. You may not copy, modify, sublicense, or distribute the Program except as expressly provided under this License. Any attempt otherwise to copy, modify, sublicense or distribute the Program is void, and will automatically terminate your rights under this License. However, parties who have received copies, or rights, from you under this License will not have their licenses terminated so long as such parties remain in full compliance.

5. You are not required to accept this License, since you have not signed it. However, nothing else grants you permission to modify or distribute the Program or its derivative works. These actions are prohibited by law if you do not accept this License. Therefore, by modifying or distributing the Program (or any work based on the Program), you indicate your acceptance of this License to do so, and all its terms and conditions for copying, distributing or modifying the Program or works based on it.

6. Each time you redistribute the Program (or any work based on the Program), the recipient automatically receives a license from the original licensor to copy, distribute or modify the Program subject to these terms and conditions. You may not impose any further restrictions on the recipients' exercise of the rights granted herein. You are not responsible for enforcing compliance by third parties to this License.

7. If, as a consequence of a court judgment or allegation of patent infringement or for any other reason (not limited to patent issues), conditions are imposed on you (whether by court order, agreement or otherwise) that contradict the conditions of this License, they do not excuse you from the conditions of this License. If you cannot distribute so as to satisfy simultaneously your obligations under this License and any other pertinent obligations, then as a consequence you may not distribute the Program at all. For example, if a patent license would not permit royalty-free redistribution of the Program by all those who receive copies directly or indirectly through you, then the only way you could satisfy both it and this License would be to refrain entirely from distribution of the Program.

If any portion of this section is held invalid or unenforceable under any particular circumstance, the balance of the section is intended to apply and the section as a whole is intended to apply in other circumstances.

It is not the purpose of this section to induce you to infringe any patents or other property right claims or to contest validity of any such claims; this section has the sole purpose of protecting the integrity of the free software distribution system, which is implemented by public license practices. Many people have made generous contributions to the wide range of software distributed through that system in reliance on consistent application of that system; it is up to the author/donor to decide if he or she is willing to distribute software through any other system and a licensee cannot impose that choice.

This section is intended to make thoroughly clear what is believed to be a consequence of the rest of this License.

8. If the distribution and/or use of the Program is restricted in certain countries either by patents or by copyrighted interfaces, the original copyright holder who places the Program under this License may add an explicit geographical distribution limitation excluding those countries, so that distribution is permitted only in or among countries not thus excluded. In such case, this License incorporates the limitation as if written in the body of this License.

9. The Free Software Foundation may publish revised and/or new versions of the General Public License from time to time. Such new versions will be similar in spirit to the present version, but may differ in detail to address new problems or concerns.

Each version is given a distinguishing version number. If the Program specifies a version number of this License which applies to it and "any later version", you have the option of following the terms and conditions either of that version or of any later version published by the Free Software Foundation. If the Program does not specify a version number of this License, you may choose any version ever published by the Free Software Foundation.

10. If you wish to incorporate parts of the Program into other free programs whose distribution conditions are different, write to the author to ask for permission. For software which is copyrighted by the Free Software Foundation, write to the Free Software Foundation; we sometimes make exceptions for this. Our decision will be guided by the two goals of preserving the free status of all derivatives of our free software and of promoting the sharing and reuse of software generally.

NO WARRANTY

11. BECAUSE THE PROGRAM IS LICENSED FREE OF CHARGE, THERE IS NO WARRANTY FOR THE PROGRAM, TO THE EXTENT PERMITTED BY APPLICABLE LAW. EXCEPT WHEN OTHERWISE STATED IN WRITING THE COPYRIGHT HOLDERS AND/OR OTHER PARTIES PROVIDE THE PROGRAM "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE. THE ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE PROGRAM IS WITH YOU. SHOULD THE PROGRAM PROVE DEFECTIVE, YOU ASSUME THE COST OF ALL NECESSARY SERVICING, REPAIR OR CORRECTION.

12. IN NO EVENT UNLESS REQUIRED BY APPLICABLE LAW OR AGREED TO IN WRITING WILL ANY COPYRIGHT HOLDER, OR ANY OTHER PARTY WHO MAY MODIFY AND/OR REDISTRIBUTE THE PROGRAM AS PERMITTED ABOVE, BE LIABLE TO YOU FOR DAMAGES, INCLUDING ANY GENERAL, SPECIAL, INCIDENTAL OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE OR INABILITY TO USE THE PROGRAM (INCLUDING BUT NOT LIMITED TO LOSS OF DATA OR DATA BEING RENDERED INACCURATE OR LOSSES SUSTAINED BY YOU OR THIRD PARTIES OR A FAILURE OF THE PROGRAM TO OPERATE WITH ANY OTHER PROGRAMS), EVEN IF SUCH HOLDER OR OTHER PARTY HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGES.
END OF TERMS AND CONDITIONS
How to Apply These Terms to Your New Programs

If you develop a new program, and you want it to be of the greatest possible use to the public, the best way to achieve this is to make it free software which everyone can redistribute and change under these terms.

To do so, attach the following notices to the program. It is safest to attach them to the start of each source file to most effectively convey the exclusion of warranty; and each file should have at least the "copyright" line and a pointer to where the full notice is found.

one line to give the program's name and an idea of what it does.
Copyright (C) yyyy  name of author

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

Also add information on how to contact you by electronic and paper mail.

If the program is interactive, make it output a short notice like this when it starts in an interactive mode:

Gnomovision version 69, Copyright (C) year name of author
Gnomovision comes with ABSOLUTELY NO WARRANTY; for details
type `show w'.  This is free software, and you are welcome
to redistribute it under certain conditions; type `show c' 
for details.

The hypothetical commands `show w' and `show c' should show the appropriate parts of the General Public License. Of course, the commands you use may be called something other than `show w' and `show c'; they could even be mouse-clicks or menu items--whatever suits your program.

You should also get your employer (if you work as a programmer) or your school, if any, to sign a "copyright disclaimer" for the program, if necessary. Here is a sample; alter the names:

Yoyodyne, Inc., hereby disclaims all copyright
interest in the program `Gnomovision'
(which makes passes at compilers) written 
by James Hacker.

signature of Ty Coon, 1 April 1989
Ty Coon, President of Vice

This General Public License does not permit incorporating your program into proprietary programs. If your program is a subroutine library, you may consider it more useful to permit linking proprietary applications with the library. If this is what you want to do, use the GNU Lesser General Public License instead of this License. 




====
=11=  Contact Information
====
	Patrick Stetter - Chipmaster
	Chipmaster32@gmail.com

====
=12=  Credit
====
	Jason Kovacs and Dan Englender for use of: 	fastline, quittoshell
	Joe Wingbermuehle for use of:  			ifastcopy, irandom
	TI for use of:  				bcalls :)
	Sigma for use of:				My getplot routine	
