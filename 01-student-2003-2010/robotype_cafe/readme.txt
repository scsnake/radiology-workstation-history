________________________________________________________________ 

RoboType, Version 3.1
Copyright (c) 2002 Ziff Davis Media, Inc.
Written by Gregory A. Wolking
First Published in PC Magazine, US Edition, September 3, 2002, v21n15
http://www.pcmag.com/utilities/
________________________________________________________________ 

PLATFORMS:
Windows 95/98/Me/NT4/2000/XP

DESCRIPTION:
Do you find yourself typing the same phrases and paragraphs over and over? Perhaps you prepare business documents that contain paragraphs worded in a standard way. Or maybe you're a technical support provider and repeatedly receive the same questions in email. Or maybe there are certain long and complicated URLs that you find yourself needing to give out all the time. Some programs have macro expansion facilities, but not all. You could save your reusable text in a document and cut and paste from there, but that approach is clumsy. A better solution is RoboType 3, which adds a text expansion feature to almost any Windows program. You define abbreviations for the words, phrases, and paragraphs that you frequently retype and RoboType 3 does the rest, replacing your abbreviations with the expanded text. This latest update of RoboType includes numerous enhancements. A new "groups" feature lets you organize your abbreviations by category. The new "tag" feature lets you use variables such as date and time when defining the expanded text. In addition to the larger enhancements, you'll many smaller refinements throughout the program.

REVISION HISTORY:
Changes in Version 3.1
- Edit control now wraps lines automatically to fit the available area.
- Custom font setting is now preserved from one session to the next.
- "Matching abbreviation found" prompt during a Merge operation now gives a better explanation of what's going on, and provides the options "Yes", "Yes to all", "No", "No to all", and "Cancel merge".
- When a merge fails or is cancelled, program now gives a specific error message ("Out of memory", "User canceled", etc.) instead of a "generic" message listing all possible causes.
- Auto search is no longer disabled when a dialog box is active under Win 9x. Note, however, that if your expansion contains line breaks and you're working in a single-line edit control, the first line break in the expansion will cause RoboType to click the dialog's default button, as if you had pressed the Enter key yourself.
- Auto search now detects abbreviations up to 32 characters in length.
- Keystroke monitor now recognizes the numeric keypad, including digits and the characters "/", "*", "+", and "-".
- When you use Auto search to build or edit the expansion for an abbreviation using other abbreviations in the current library, RoboType no longer replaces the tags with the appropriate text. Instead, it copies the tags verbatim. If you do want the tags replaced instead of copied, use Manual search to expand the abbreviation.
- Date and time tags now support "date math", allowing you to calculate dates and times in the past or future by adding or subtracting an offset from the current system clock.
- When the Merge command finds a matching abbreviation and you choose not to update the existing abbreviation from the library being merged, the existing abbreviation no longer moves to a different group.
- The Select all command now works properly when you right-click on the Expansion edit field while the Abbreviation list has the input focus, selecting all of the text in the field instead of all of the abbreviations in the list.
- Startup code is more forgiving when the system startup sequence includes more than one reference to RoboType. If an existing instance sees that another instance is already running but has not yet created its main window, the second instance waits an extra 5 seconds to give the first instance a chance to finish initializing before presenting an error message.

Changes in Version 3.0:
- Added an "abbreviation groups" feature, and enhanced the Merge command to support it.
- Enhanced functionality in the abbreviation list: multi-selection, in-place editing.
- Added support for "tags" in the expansion text--replaceable expressions for current information such as the time, date, and current user's logon name. 
- The vertical divider between the abbreviation list and expansion edit control now acts as a splitter bar.
- Menus have been reorganized and some commands renamed to make the command structure more logical. 
- The online help has been reorganized and expanded.
- The "Advanced options" dialog adds a new setting for the Auto search mechanism: Do not append a trailing space when typing an expansion.
- The Edit menu includes new Find and Find next commands. 
- A new "Select All" command on the Edit and context menus allows selection of all abbreviations in the list or all text in the Expansion edit control, whichever has the input focus.
- The tray icon's context menu has a new Reset command for use when a misbehaving application corrupts the system hooks that RoboType depends on. Toggling the Active, Auto search, or Manual search settings also resets the hooks.
- A new "Create auto-start shortcut" command makes it easier to configure RoboType to start with the desired library loaded at system startup or user logon.
- Fixed a synchronization problem that occurred when you first loaded a library from disk.
- The Manual search mechanism no longer pops up a modal message box when it can't access the clipboard, since this sometimes caused a crash.
- The Window size, position, and layout are now saved when RoboType is terminated as part of a Windows shutdown or logoff. 

Changes in Version 2.2:
- Removed the operating system version check so the program would run under 
Windows 2000.

Changes in Version 2.1:
- Added the "Validate on Load" option to the "File" menu. Since chained 
abbreviations are only a problem under certain circumstances, this lets the user 
disable the automatic validation check when a library is loaded and thereby 
suppress the error message when a file does contain chained abbreviations.

- Main window no longer gets lost when "Hide main window at startup" is selected 
and program is launched from a shortcut with the "Minimized" property set.

- Manual Search feature: "Abbreviation Detected" message box is no longer 
"always on top".

- Manual Search feature: "Abbreviation detected" prompt now displays the correct 
message, according to the replacement method chosen.

- Manual Search feature: When the "Type replacement text immediately" option is 
selected, the prompt message box is now attached to the target window to 
encourage the user to respond immediately.

- Manual Search feature: Fixed bug that prevented the user's replacement text 
from being placed into the clipboard until the "alert sound effect" finished 
playing.

- Program has been recompiled with Visual C++ version 6.0.

Changes in Version 2.0
- Version 1 used a clipboard-based technique that did not work with some 
applications. Version 2 adds an "automatic mode" that, with the original "manual 
mode", enables RoboType to work with virtually any Windows application.

THANKS TO OUR VERSION 3 BETA TESTERS:
Alec Burgess 
Glenn Charles 
Robert Eisenbach 
Josh Fitzgerald 
Ken Holt
Bruno Sonnino 

INSTALLATION:
To install RoboType 3, run the provided Setup utility and follow the prompts. Note that to install the program under Windows NT-based systems (NT4, 2000, XP), you must be logged on as a system administrator.

Setup doesn't offer to create a StartUp shortcut for the program. Most users will want RoboType to start with a particular library loaded, and new users won't have created any libraries yet. Once you've created the library you wish to use at system startup, load the library and use the Create start-up shortcut command in RoboType's File menu. This creates a shortcut to the desired library in the current user's StartUp folder so it's available at logon. Note that you shouldn't create any shortcuts to RoboType libraries in the common StartUp folder. If the common shortcut and a user's shortcut refer to different libraries, there's no way to predict which would be loaded at logon.

If you are already using an older version of RoboType, you should exit the program before you run Setup to avoid having to restart your system. Previous versions of RoboType did not come with a Setup utility, so the Version 3 Setup utility will not detect the existing copy of the program and offer to install in the same location. If you point Setup to the current version's location, it will update the existing files.

To remove RoboType from your system, exit the program and use Control Panel | Add/Remove Programs. If you don't exit the program before removing it from your system, Setup might have to restart your system to complete the removal. If you terminate RoboType before you begin, Setup will be able to remove the program completely without requiring a restart.

For details on program operation, refer to the program's online help file.

FILE LIST:
Setup.exe     - RoboType 3 installation program
readme.txt    - the file you are reading
license.txt   - PC Magazine Utilities license agreement
rt3_src.zip   - RoboType 3 source code (for programmers)

SUPPORT:
Help for PC Magazine's free utilities can be obtained in our online discussion area on the World Wide Web (http://discuss.pcmag.com/pcmag). You may find an answer to your question simply by reading the posted messages. The authors of current utilities generally visit this forum daily. If the author is not available and the forum sysops can't answer your question, the Utilities column editor, who also checks the forum each day, will contact the author for you.

LICENSE INFORMATION:
PC Magazine programs are copyrighted and cannot be distributed, whether modified or unmodified. Use is subject to the terms and conditions of the license agreement distributed with the programs.

----

Gregory A. Wolking, the author of RoboType 3, is the primary sysop in the PC Magazine Utilities Support forum (discuss.pcmag.com/pcmag). Sheryl Canter is the editor of the Utilities column, and a Contributing Editor of PC Magazine.
