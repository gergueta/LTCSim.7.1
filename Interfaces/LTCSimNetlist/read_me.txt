API Kit
Cohesion Systems, inc
http://www.CohesionSystems.com

Cohesion Designer v5.1
2001 08 03



Contents of this API Kit:
-------------------------

All source code, linked libraries, and makefiles needed to build example programs on both UNIX and PC:
--> asciinet: Plain-text netlister for Hierarchy
--> scback:   Generic back-annotation for Schematic
--> ascin:    ASCII-to-schematic converter
--> ascout:   Schematic-to-ASCII converter
--> asyin:    ASCII-to-symbol converter
--> asyout:   Symbol-to-ASCII converter
--> edifin:   Graphical-EDIF-to-symbol converter
--> edifout:  Symbol-to-Graphical-EDIF converter

lib/
Directory of DLL wrappers for PC version only

ecs32/navlists
Sample programs that are built on Hierarchy Navigator. These programs are hosted by the Hierarchy Navigator, which is required to be running at the time these are used. In fact, you must launch these programs from the Hierarchy Navigator itself (using the menus such as "Generate"). These programs traverse a resolved hierarchy, not individual schematic sheets. Think of them as "connectivity processors".

ecs32/schlists
Sample programs that are built on Schematic Files. These programs directly access the schematic files themselves, and they do not have access to the resolved hierarchy. Think of them as "drawing processors". They can be run stand-alone, such as from a script.

ecs32/utility
Sample programs that are built on Schematic and Symbol files. These programs directly access the files, similar to the programs in ecs32/schlists. They can be run stand-alone, such as from a script.



Building:
---------

There are two build environments supported by these files: Visual Studio for the PC, and 'make' on UNIX / LINUX.

PC:

--> Map the project root to virtual drive Z:, using the .bat script provided. You will need to modify the .bat script to your particular path.

--> Each directory has a .dsp/.dsw environment. You can load these into Visual Studio v6, and simply build.

UNIX / LINUX:

--> Each directory has a 'makefile.unix'.

--> There is a .cshrc file in the root directory. Set the switch at the top of the .cshrc file to "release".

--> The project root is typically linked to '/hds/source/'. For example:
'su'
'mkdir /hds/'
'ln -s <projectRoot> /hds/source/'

--> You will need an object file directory, just below the 'makefile.unix'. Make this directory 'release_unix', and link the makefile into that directory. Then go into that directory for the build. For example:
'mkdir release_unix'
'cd release_unix'
'ln -s ../makefile.unix ./makefile'
'make'