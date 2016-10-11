<h1>Bermuda Word</h1>

This is a partial copy of the original Bermuda Word reader for older Windows versions. It is only to show the architecture that was set up to create the 44 different educational Software program executables in ISBN.txt.

The VB files contain the framework that offer the possibility of running the HTML+CSS+Javascript source in an executable, and also the plug-ins necessary to perform back-end tasks like <a href='README.md#DBG'>debugging</a>, persistency, sorting, decryption, tests ui setup or automated registration at bermudaword.com. The perl scripts respectively create a HTML browser package and encrypt that and load it into a single .exe file.

The base directory contains some of the necessary scripts and html files. The language directory would contain the source files and the resulting HTML browser package and is excluded from this repository.

The images show one of the Windows Software programs running, the executable included is a demo version of the full program.

<h3>Framework:</h3>

<h6 id="DBG">DBG</h6>
usage:
"DBG§$MESSAGESTRING"
example:
top.location.href = "DBG§Checking if TeacherCurrentMyWordsNumber $TEACHERCURRENTMYWORDSNUMBER and TeacherCurrentChapterTestCounter $TEACHERCURRENTCHAPTERTESTCOUNTER are empty:";

<h6 id="SET">SET</h6>
usage:
"SET§$VARIABLE§$VALUE§$[OPTIONAL: NO_REFRESH]" (NO_REFRESH used if value does not need to be updated on screen)
example:
top.location.href = "SET§TEACHERCURRENT + $CHAPTERNUMBER§999§NO_REFRESH";

<h6 id="GET">GET</h6>
usage:
example:
top.location.href = "GET§<<<BASEHTMLFILEPART>>>MainSmallMenu.htm<>"+NextChapterPage+"<>§Finished<<<TRANLANGOTHERTHANENG>>>.htm§<<<PAGETABLE>>>§NO";

<h6 id="CFG">CFG</h6>
usage:
"CFG§$THEME_OR_CONFIGURATION_GROUP_TO_SET§[OPTIONAL: PARSE] (PARSE if this influences other variables and need reparsing of all settings, for example in case CFG group influences certain SETs)
example:
top.location.href = "CFG§LAYOUTSINGLE§PARSE";


<h3>Screenprints:</h3>

<img src="Bermuda-Word-Learn-to-Read-French-Beginners-Stories-Demo.jpg"></img>

<img src="Bermuda-Word-Learn-to-Read-French-Beginners-Stories-Example-Too.jpg"></img>
