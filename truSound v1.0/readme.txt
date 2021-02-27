TruSound by Brian Coventry aka thepenguin77

Since RealSound only works on older calculators that have the extra Ram, I decided to make this program to give everyone a chance

But I managed to slighty top realsound as this program gets on average 8% compression for each song.

To see this in action and for a tutorial on making songs, check out the video: http://www.youtube.com/watch?v=5CEN-omB1Aw


;##########################################################
		Making a new song
;##########################################################

I've tried to make this process as simple as possible, but it is still rather complex.

1. First, to make my c++ program run on your computer, you are going to have to install the runtime libraries. 
	If your computer is 32 bit, download the first, if it is 64 bit, download the second, if you are unsure, assume 32 bit:
		- 32 bit - http://www.microsoft.com/downloads/en/details.aspx?familyid=A7B7A05E-6DE6-4D3A-A423-37BF0912DB84&displaylang=en
		- 64 bit - http://www.microsoft.com/downloads/en/details.aspx?familyid=BD512D9E-43C8-4655-81BF-9350143D5867&displaylang=en
	Since I know programs can get old pretty quickly, if the year is 2015 and these links don't work:
	go to google and search vcredist_x86.exe and vcredist_x64.exe respectively.

2. Send TRUSPEED.8xp to your calculator. (/8xk/TRUSPEED.8xp)
3. Run it with Asm(prgmTRUSPEED)  (Asm( is found in [2nd] catalog)
4. Remember the sample rate the program comes up with.

5. Find a song, any song will work
6. Convert the song to a .wav file in either 8 or 16 bit that will fit on your calculator with the sample rate provided by TRUSPEED.

Here are the steps for step 6:
	1. Download Audacity and install it. http://audacity.sourceforge.net/. (it's very useful for other stuff too)
	2. Open your song with audacity
	3. Highlight the section of the song that you want to keep, just be conscious of size. (23000 bytes per second)
	4. Edit>Trim
	5. Project>Align Tracks...>Align with zero
	6. Click on the Project rate in the bottom left corner, and change it to the sample rate provided by TRUSPEED.
	7. Edit>Preferences>File Formats>Uncompressed File Format: Change this to either WAV (microsoft 16 bit) or WAV (microsoft 8 bit).
	8. File>Export As WAV...: Save the song in the /wav folder.
		Remember, the name you put here is the name that will show up on the calculator (keep it 8 or less characters)

7. Double click on doubleClickMe.bat.
8. Type: convert <program name>   So say my song file was song.wav, I would type:    convert song
9. Send the resulting file in the /8xk folder to your calculator.
10. Play it!


;##############################################################
		Sending the files to calc
;##############################################################

Sending huge files like these to your calculator can cause quite a bit of trouble. These apps are about 50 times bigger than normal ones.

The two ways to send the files, direct usb and silverlink, each have their pros and cons.

Direct usb:
	Pros:
		-Fast
		-Everyone has the cord needed
	Cons:
		-Unreliable
		-Ti-connect won't accept files over about 1.1MB.
Silverlink:
	Pros:
		-Very reliable
	Cons:
		-About half as fast as usb
		-special cord needed

Here are some general things to make the trasnfer easier:
	-low batteries can screw with usb, if in doubt, change them
	-Ti-Connect won't send files over 1.1MB to your calculator, either make it smaller, or send it with the silverlink
	-If validation on calculator fails, try cutting off a hundredth of a second from your song and try again

I have heard that TiLP doesn't have nearly as many problems as Ti-Connect, so you might want to try that if you can't get it to work.


;##############################################################
		Making headphones
;#############################################################

Any way you look at it, you are going to need a 2.5 mm headphone jack. 

The easiest way to get headphones is just to buy an adapter. Go to radioshack and ask for a 2.5 mm to 3.5 mm headphone jack. (~$10)

Or if you are adventurous, you could cut apart an 83+ link cable, or an xbox headset, and splice the wires with regular headphones.
	

When you use your headphones though, you will quickly realize that you need to have some kind of amplifier. The calculator cannot play very loud music
	so you either need nice headphones, or powered speakers.


;###############################################################
		Trusound (the computer program)
;###############################################################

Here is everything you need to know about the computer converter.

-Input .wav's must be either 8 or 16 bit and either mono or stereo
-The command line syntax is: truSound input.wav output.bin
-playCode.bin gets tacked on the front of the converted sound file and is what actually plays the song

Compression:
	When I opened up a .wav file in a hex editor, I noticed that there were quite a few numbers centering around 0x80. That
	is the property that I exploit. When my program sees a string of numbers all between 0x77 and 0x88, it subtracts 0x79 from them 
	and stores them as nibbles. What this means is that quiet sections are cut to about half their size.


Just a heads up about compressing .wav files, LZ77 does not work.


;################################################################
			Other
;################################################################

While you don't have to use the sample rate provided by TRUSPEED, your calculator is still going to play the song at that speed.
	Which means that if you set your sample rate too high, the song will play in slow motion, too low, it will be sped up.

Feel free to modify or use this program however you like. Just make sure you give me credit if you steal the code ;)


;#########################
	Contact
;#########################

If you need to contact me you can:

email me at bcoventry@live.com (although I hardly check)
	or
pm me at omnimaga.org  thepenguin77




