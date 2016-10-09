#!./perl
#!perl
######################################################################
# Name: FormatHTMLTexts.pl
# Synopsis: This script formats html pages from dual word list to html.
# Usage: FormatHTMLTexts.pl <LanguageFrom> <Group> [-t <LanguageTo>] -f <filenames separated by '/'>
#                           -c <chapter names or number corresponding with filenames>
#                           [-T <Original Title in Source Language>] [-V <Original Title in Target Language>]
#                           [-website <groupnamelowercase> <chapterfileshortnamestouse>]
#                           [-pdf <Title> <Chapter>|All [-interlinear [-flowingenglish [-addcsv]]]
#                           [-nopause] [-prod <drive>] [-trace]
#
#       *<LanguageFrom> can be Dutch, English, French, German, Georgian, Greek, Hungarian, Indonesian,
#        Italian, Polish, Portuguese, Russian, Spanish, Swedish, Basque or Urdu;
#        actually this just depends on available texts and whether
#        this script has been adjusted for that language;
#        just make sure that if you choose a language and group
#        that there are text files in the right format available
#        in the path /<LanguageFrom>/<Group>
#       *-t <LanguageTo> defines Target language, which can now be
#        English (default), Dutch, French, German, Spanish and Portuguese
#       *-f <filenames separated by '/'> define the filenames you wish to include in the e-book
#         N.B. Make sure that files with these names exist!
#             if this option is not given there will be alphabetical
#             folgord of the file chapternames of all the files that are in the $Group directory
#       *-c <full Chaptername1/Chaptername2/Chaptername3/etc.etc.>
#             if this option is not given it will use the filenames as chapternames
#       *-T <Original Title in Source Language>] (used for book title)
#       *-V <Original Title in Target Language>] (used for book title translation)
#       *[-DicE|-DicD] Create extra dictionary from English (TRAN1) or Dutch (TRAN2) to the LanguageTo language
#        so usage would be "FreFairyMake -DicD" (FreFairyMake creates French to English dictionary, using -DicD we add Dutch to English if there is a Dutch translation)
#        so use -DicE with FreFairyMakeDutch to create a dictionary from French and English to Dutch in this case...
#       *[-RedoAudio] Redoes Audio even if already exists
#       *[-prod <drive>] creates the actual e-book executable at <drive>:/<LanguageFrom>/<Group>
#       *[-website <group lowercase> <story name>]
#        N.B. This option skips creation of e-book executable!
#       *[-pdf <Title> <Chapter>|All [-interlinear [-flowingenglish [-addcsv]]]
#        N.B. This option creates html for pdf only, skips creating executable app!
#        [-interlinear] option makes html for interlinear pdf instead of pop-ups
#       *-RefreshWebIndex (only deletes and recreates website index files
#       *-demo (creates shortened demo version of the book)
#       *-quick (basically just skips the FormatHTMLTexts.pl when run in Make
#       *-discount <discount> (adds discount in pdf afterword, default is 30%)
#       *-lessons (skips rest of making, just does the chapter word counts and lists for now)
#       *-trace (debugging of this script)
#       *-editable (in final tool, enable editing of base data files
#                   in the future tool should be able to recompile)
#       *-app <title> <story> (turns on -pdf -interlinear and adds pop-ups and sound)
#	*-print (make high quality print edition, i.e. chapter starts on even page plus hires pics)
#	*-printloqual (low quality pics print edition, chapter even page, for e-book)
#       *-mainlang <language> (if outputting everything for App content,
#                              this shows for which language to output all,
#                              and which official ISO language code to put in,
#                              and to get audio for which tales (all or just first two or something) ).
#       *-RefreshAppIndex (only overwrites the images, scripts, css and root index files
#                          except for language.js and keys.js!!!!!!!)
#	*-wtf (website template file, will generate story file with only the pdf html page bits
#              for the itemdetail pages of the new HypLern website)
######################################################################
#
# Author        : A.W.Th. van den End
#                       
# Date          : 13-03-2007    Format Text to HTML new version (based on 2006 simple version)
#                 09-05-2007    Add Parsing and Chaptering/Paging
#                 07-07-2007    Add PopUp Translation via Java Script
#                 15-12-2007    Extend to Full e-Book Formatting
#                               &create top menu frame with page, chapter & options
#                 05-04-2008    Swedish added
#                 11-11-2009    Portuguese added
#                 03-02-2010    Automatic Website creation added for Website 2.0
#                 05-06-2010    Automatic PDF creation added
#                 01-07-2010    Polish added
#                 20-11-2011    Indonesian added
#                 16-03-2012    Hungarian added
#                 09-06-2013    Urdu added
#                 01-09-2013    Website creation 3.0
#                 25-02-2014    Lots of esthetical editing
#                 07-05-2014    Enhanced security
#                 03-02-2015    Automated demo versions output
#                 12-05-2015	Cleaner version 3.0 of Tool including Spaced Repetition
#                 15-06-2015	Ontario App creation, output stories for App
#                               with interlinear and pop-up both, and sound
#                 01-03-2016	Add arguments for print edition (hires&chapter even page)
#                 05-06-2016	Add scripting for App content to output all for chosen language
#                               and just two example stories for non-chosen languages
#
# *All Copyrights for this script by Ittolaja Inc. acquired from Bermuda Word BV
######################################################################


######################################################################
#
# EDITING SHORT CUTS
#
######################################################################
#
# # FIX SPACES IN PDF -> added _'s to beautify interlinear muck
#
######################################################################


# use libraries
use Roman;

# Setting Variables
$ChapterCounter = 1 ;
$MainGroup = "Main" ;
$Template = "../Base/HTML/Main/HTMLTemplate_Text.htm" ;
#Set basic font
#$FONTFAMILY = "Times New Roman";
$FONTFAMILY = "Arial";
#Set default character set
$DEFAULTCHARSET = "" ;
$TestGrepArguments = "@ARGV";
# tja
$LastPageAudioCounter = 0;
@MAINMESSPARTS = ("");
$REDOROOTSFILE = "NO";
$PreFixDone = "no";
$SufFixDone = "no";
$PreFixChosen = "none";
$SufFixChosen = "none";

# Turn tracing on
if ($TestGrepArguments =~ "-trace") {
  $TRACING = "ON";
}

# Print Help
$AA = "@ARGV"; #Get AllArguments
if ($TRACING eq "ON") {
  print "Arguments: $AA\n";
} else { print ".";}
if ($AA =~ " -h " || $AA =~ " -H " || $AA =~ / -h$/ || $AA =~ / -H$/ || $AA =~ " \/h " || $AA =~ / \/H$/ || $AA =~ "-help" || $AA =~ "\/help" || $AA =~ "-Help" || $AA =~ "\/Help" || $AA =~ "-HELP" || $AA =~ "\/HELP")
{
  #There is a sign of distress, let's show the help:
  print "######################################################################################\n";
  print "# Name: FormatHTMLTexts.pl                                                           #\n";
  print "# Synopsis: This script formats html pages from dual word list to html.              #\n";
  print "# Usage: FormatHTMLTexts.pl                                                          #\n";
  print "# <LanguageFrom> <Group> [-t <LanguageTo>] -f <filenames separated by '/'>           #\n";
  print "# -c <chapter names or number corresponding with filenames> [ -DicE | -DicD ]      #\n";
  print "# [-T <Original Title in Source Language>] [-V <Original Title in Target Language>]  #\n";
  print "# [-website <groupnamelowercase> <chapterfileshortnamestouse>]                       #\n";
  print "# [-pdf <Title> <Chapter>|All [-interlinear [-flowingenglish [-addcsv]]]             #\n";
  print "# [-nopause] [-prod <drive>] [-trace]                                                #\n";
  print "#                                                                                    #\n";
  print "#       *<LanguageFrom> can be Dutch, English, French, German, Georgian, Greek,      #\n";
  print "#        Hungarian, Indonesian, Italian, Polish, Portuguese, Russian, Spanish,       #\n";
  print "#        Swedish, Basque or Urdu;                                                    #\n";
  print "#        actually this just depends on available texts and whether                   #\n";
  print "#        this script has been adjusted for the language..                            #\n";
  print "#        just make sure that if you choose a language and group                      #\n";
  print "#        that there are text files in the right format available                     #\n";
  print "#        in the path /<LanguageFrom>/<Group>                                         #\n";
  print "#       *-t <LanguageTo> defines Target language, which can now be                   #\n";
  print "#             English (default), Dutch, French, German, Spanish and Portuguese       #\n";
  print "#       *-f <filenames separated by '/'> define the filenames                        #\n";
  print "#             that you wish to include in the e-book                                 #\n";
  print "#         N.B. Make sure that files with these names exist!                          #\n";
  print "#             if this option is not given there will be alphabetical                 #\n";
  print "#             folgord of the file chapternames of all the files                      #\n";
  print "#             that are in the $Group directory                                       #\n";
  print "#       *-c <full Chaptername1/Chaptername2/Chaptername3/etc.etc.>                   #\n";
  print "#             if this option is not given it will use the filenames as chapternames  #\n";
  print "#       *-T <Original Title in Source Language>] (used for book title)               #\n";
  print "#       *-V <Original Title in Target Language>] (used for book title translation)   #\n";
  print "#       *[-DicE|-DicD] Create extra dictionary from English (TRAN1) or             #\n";
  print "#        Dutch (TRAN2) to the LanguageTo language, so usage is 'FreFairyMake -DicD' #\n";
  print "#        (FreFairyMake by default creates French to English dictionary,              #\n";
  print "#        so by using -DicD we add Dutch to English if there is a Dutch translation) #\n";
  print "#        so use -DicE with FreFairyMakeDutch                                        #\n";
  print "#        to create a dictionary from French and English to Dutch in this case...     #\n";
  print "#       *-RedoAudio Redoes Audio if already exists                                   #\n";
  print "#       *[-prod <drive>] creates the actual e-book at <drive>:/<LanguageFrom>/<Group>#\n";
  print "#       *[-website <group lowercase> <story chapter smart name>]                     #\n";
  print "#        N.B. This option creates webpages only, skips creating executable app!      #\n";
  print "#       *[-pdf <Title> <Chapter>|All [-interlinear [-flowingenglish [-addcsv]]]      #\n";
  print "#        N.B. This option creates html for pdf only, skips creating executable app!  #\n";
  print "#        [-interlinear] option makes html for interlinear pdf instead of pop-ups     #\n";
  print "#       *-RefreshWebIndex (only deletes and recreates website index files            #\n";
  print "#       *-demo (creates shortened demo version of the book)                          #\n";
  print "#       *-quick (basically just skips the FormatHTMLTexts.pl when run in Make        #\n";
  print "#       *-discount <discount> (adds discount in pdf afterword, default is 30%)       #\n";
  print "#       *-lessons (skips rest, just does the chapter word counts and lists for now)  #\n";
  print "#       *-trace                debugging of this script                              #\n";
  print "#       *-editable (in final tool, enable editing of base data files                 #\n";
  print "#                   in the future tool should be able to recompile)                  #\n";
  print "#       *-app <title> <story> (turns on '-pdf -interlinear', adds pop-ups and sound  #\n";
  print "#       *-print (high quality print, i.e. chapter starts on even page plus hires pics#\n";
  print "#       *-printloqual (low quality pics print edition, chapter even page, for e-book)#\n";
  print "#       *-mainlang <language> (if outputting everything for App content,             #\n";
  print "#                              this shows for which language to output all,          #\n";
  print "#                              and which official ISO language code to put in,       #\n";
  print "#            and to get audio for which tales (all or just first two or something) ).#\n";
  print "#       *-RefreshAppIndex (only overwrites the images, scripts, css and root index   #\n";
  print "#                          except for language.js and keys.js!!!!!!!)                #\n";
  print "#	*-wtf (website template file, will generate story file with only the pdf html #\n";
  print "#              page bits for the itemdetail pages of the new HypLern website)        #\n";
  print "######################################################################################\n";
  exit 0;
}

# If the Make needs to be quick, let's get this over with quick
#if ("@ARGV" =~ "-quick") { exit; } #bye
# ehh that's too quick, then nothing can change, have to skip some stuff instead

# If arguments contain "-editable" add "Editing" option to main menu
if ("@ARGV" =~ "\-editable") {
  $EDITABLE = "YES";
}

# Set Language Variable
$Language = shift(@ARGV);
if (-e "..\\..\\Languages\\$Language" && $Language ne "") {
   #Continue
} else {
  print "The first argument given should be the Language of the course or e-books that you want to format.\n" ;
  print "The language '$Language' is not supported. Only the following languages are possible,\n" ;
  $SupportedLanguages = `dir /B ..\\..\\Languages`;
  print "$SupportedLanguages\n";
  exit 0 ;
}

#Set basic language variables        and        exceptions
   $PARCHAR="§"; $QC1="'"; $QC2="`"; $QC3="´"; 
   # Title and contents
   $TIETEL = "Title" ;
   $KONTENDS = "Contents" ;
if ($Language eq "Urdu")       { $LanguageDutch = "Urdu" ; $LanguageDutchBVN = "Urdu" ; $LA = "UR" ; $TIETEL = "Title" ; $KONTENDS = "Contents" }
if ($Language eq "Hungarian")  { $LanguageDutch = "Hongaars" ; $LanguageDutchBVN = "Hongaarse" ; $LA = "HU" ; $TIETEL = "C&#237;m" ; $KONTENDS = "Tartalomjegyz&#233;k" }
if ($Language eq "Russian")    { $LanguageDutch = "Russisch" ; $LanguageDutchBVN = "Russische" ; $LA = "RU" ; $QC1=chr 39 ; $QC2=chr 1 ; $QC3=chr 1 ; $TIETEL = "&#1053;&#1072;&#1079;&#1074;&#1072;&#1085;&#1080;&#1077;" ; $KONTENDS = "&#1057;&#1086;&#1076;&#1077;&#1088;&#1078;&#1072;&#1085;&#1080;&#1077;" }
if ($Language eq "Georgian")   { $LanguageDutch = "Georgisch" ; $LanguageDutchBVN = "Georgische" ; $LA = "KV" ; $TIETEL = "Title" ; $KONTENDS = "Contents" }
if ($Language eq "French")     { $LanguageDutch = "Frans" ; $LanguageDutchBVN = "Franse" ; $LA = "FR" ; $TIETEL = "Titre" ; $KONTENDS = "Table des Mati&#232;res" }
if ($Language eq "Spanish")    { $LanguageDutch = "Spaans" ; $LanguageDutchBVN = "Spaanse" ; $LA = "ES" ; $TIETEL = "T&#237;tulo" ; $KONTENDS = "&#205;ndice" }
if ($Language eq "Portuguese") { $LanguageDutch = "Portugees" ; $LanguageDutchBVN = "Portugese" ; $LA = "PO" ; $TIETEL = "T&#237;tulo" ; $KONTENDS = "Indice" }
if ($Language eq "Dutch")      { $LanguageDutch = "Nederlands" ; $LanguageDutchBVN = "Nederlandse" ; $LA = "DU" ; $TIETEL = "Titel" ; $KONTENDS = "Inhoud" }
if ($Language eq "Swedish")    { $LanguageDutch = "Zweeds" ; $LanguageDutchBVN = "Zweedse" ; $LA = "SV" ; $DEFAULTCHARSET = "Latin-1" ; $TIETEL = "Titel" ; $KONTENDS = "Inneh&#229;l" }
if ($Language eq "German")     { $LanguageDutch = "Duits" ; $LanguageDutchBVN = "Duitse" ; $LA = "DE" ; $TIETEL = "Titel" ; $KONTENDS = "Inhaltsangabe" }
if ($Language eq "Italian")    { $LanguageDutch = "Italiaans" ; $LanguageDutchBVN = "Italiaanse" ; $LA = "IT" ; $TIETEL = "Titolo" ; $KONTENDS = "Indice" }
if ($Language eq "English")    { $LanguageDutch = "Engels" ; $LanguageDutchBVN = "Engelse" ; $LA = "EN" ; $TIETEL = "Title" ; $KONTENDS = "Contents" }
if ($Language eq "Greek")      { $LanguageDutch = "Grieks" ; $LanguageDutchBVN = "Griekse" ; $LA = "GR" ; $TIETEL = "Title" ; $KONTENDS = "Contents" }
if ($Language eq "Indonesian") { $LanguageDutch = "Indonesisch" ; $LanguageDutchBVN = "Indonesische" ; $LA = "IN" ; $TIETEL = "Judul" ; $KONTENDS = "Daftar Isi" }
if ($Language eq "Polish")     { $LanguageDutch = "Pools" ; $LanguageDutchBVN = "Poolse" ; $LA = "PL" ; $TIETEL = "Tytu&#322;" ; $KONTENDS = "Spis Tre&#347;ci" }
if ($Language eq "Basque")     { $LanguageDutch = "Basque" ; $LanguageDutchBVN = "Basque" ; $LA = "BA" ; $TIETEL = "Title" ; $KONTENDS = "Contents" }

$CapLanguageDutch = uc($LanguageDutch);
$CapLanguageDutchBVN = uc($LanguageDutchBVN);
$CapLanguage = uc($Language);
$LCLanguage = lc($Language);


#Set Group
$TestSecondArgument = $ARGV[0];
$SupportedGroups = `dir /B ..\\..\\Languages\\$Language\\Texts`;
if ($TestSecondArgument eq "" || $TestSecondArgument =~ "-" || !(-e "..\\..\\Languages\\$Language\\Texts\\$TestSecondArgument")) {
  print "The second argument given should be the Group of the course or e-books that you want to format;\n" ;
  print "For example 'format French VerneTourDuMonde' or 'format French All'\n";

  if ($SupportedGroups eq "" || $SupportedGroups =~ "File Not Found" || $SupportedGroups =~ "Bestand Niet Gevonden") {
  	print "Currently no groups defined in path ..\\..\\Languages\\$Language\n";
  } else {
    print "Currently the following groups are defined in path ..\\..\\Languages\\$Language:\n";
    print $SupportedGroups;
  }
  exit 0 ;
}


# CREATE LANGUAGE PART OF SHORT UNIQUE LANGUAGE-GROUP CODE FOR KEY
if ($Language eq "Urdu")       { $LANCOD = "URD" }
if ($Language eq "Hungarian")  { $LANCOD = "HUN" }
if ($Language eq "Georgian")   { $LANCOD = "GEO" }
if ($Language eq "Russian")    { $LANCOD = "RUS" }
if ($Language eq "French")     { $LANCOD = "FRE" }
if ($Language eq "Spanish")    { $LANCOD = "SPA" }
if ($Language eq "Portuguese") { $LANCOD = "POR" }
if ($Language eq "Dutch")      { $LANCOD = "DUT" }
if ($Language eq "Swedish")    { $LANCOD = "SWE" }
if ($Language eq "German")     { $LANCOD = "GER" }
if ($Language eq "Italian")    { $LANCOD = "ITA" }
if ($Language eq "English")    { $LANCOD = "ENG" }
if ($Language eq "Greek")      { $LANCOD = "GRE" }
if ($Language eq "Indonesian") { $LANCOD = "IND" }
if ($Language eq "Polish")     { $LANCOD = "POL" }
if ($Language eq "Basque")     { $LANCOD = "BAS" }


$numberofpages = "100+" ;
# Create HTML path if it does not exist yet
if (-e "..\\..\\Languages\\$Language\\HTML") {
   #Continue
   # if -demo get numberofpages from special file that is created when not -demo
} else {
   #Create HTML dir
   `mkdir ..\\..\\Languages\\$Language\\HTML`;
}

#Check whether one specific group or ALL
if ($ARGV[0] eq "All") {
   # Find all groups
   @DirOutput = `dir /B /AD ..\\..\\Languages\\$Language\\Texts\\*` ;
   foreach $Group(@DirOutput) {
      chop $Group ;
      push (@Groups, $Group) ;
   }
} else {
   # Group is Argument one
   $Group = $ARGV[0];
   @Groups = ("$Group");
}

# define LanguageTo variable, default english
$TranTo = "TRAN1" ;
$TranToLanguage = "English" ;
$LCTranToLanguage = "english" ;
$FilenameLanguage = "" ; # for English filenames have no language spec (i.e. About.htm or AboutDutch.htm)

$TLN = 1;
$NrOfArg = 0;
$TranOrgLang = $Language;
if ("@ARGV" =~ "-t ") {
   foreach $ARGUMENT (@ARGV) {
      if ($ARGUMENT eq "-t") {
      	$TranTo = $ARGV[$NrOfArg + 1] ;
      	last;
      }
      $NrOfArg = $NrOfArg + 1;
   }
   #$TranTo =~ s/\n//g;
   if ($TranTo ne "English" && $TranTo ne "Dutch" && $TranTo ne "French" && $TranTo ne "German" && $TranTo ne "Spanish") {
      print "!   The optional -t argument given should be\n" ;
      print "!   followed by the Language of translation\n" ;
      print "!   that you want to format;\n" ;
      print "!   Currently only English, Dutch, French, German and Spanish are possible.\n" ;
      exit 0 ;
   }
   if ($TranTo eq "Dutch")   { $TranTo = "TRAN2"; $TranToLanguage = "Dutch";   $TLN = 2; $LCTranToLanguage = "dutch"; $FilenameLanguage = "Dutch"; $TranOrgLang = $LanguageDutch }
   if ($TranTo eq "French")  { $TranTo = "TRAN3"; $TranToLanguage = "French";  $TLN = 3; $LCTranToLanguage = "french"; $FilenameLanguage = "French"; $TranOrgLang = $LanguageFrench }
   if ($TranTo eq "German")  { $TranTo = "TRAN4"; $TranToLanguage = "German";  $TLN = 4; $LCTranToLanguage = "german"; $FilenameLanguage = "German"; $TranOrgLang = $LanguageGerman }
   if ($TranTo eq "Spanish") { $TranTo = "TRAN5"; $TranToLanguage = "Spanish"; $TLN = 5; $LCTranToLanguage = "spanish"; $FilenameLanguage = "Spanish"; $TranOrgLang = $LanguageSpanish }
   if ($TranTo eq "Portuguese") { $TranTo = "TRAN6"; $TranToLanguage = "Portuguese"; $TLN = 6; $LCTranToLanguage = "portuguese"; $FilenameLanguage = "Portuguese"; $TranOrgLang = $LanguagePortuguese }
}


# CREATE GROUP PART OF SHORT UNIQUE LANGUAGE-GROUP CODE FOR KEY
$TARCOD = uc ( substr $TranToLanguage, 0, 3 ) ;


# Turn LESSONS to yes
if ($TestGrepArguments =~ "-lessons") {
  $LESSONS = "yes";
}


# Turn PRINTVERSION to yes
if ($TestGrepArguments =~ "-print") {
  $PRINTVERSION = "yes";
  if ($TestGrepArguments =~ "-printloqual") {
    $LOWQUALITY = "yes";
  }
}

if ($TRACING eq "ON") {
  print("Translation To : $TranToLanguage\n");
  print "Groups:\n@Groups\n" ;
} else { print ".";}

# Check if create website option is On
$NrOfArg=0;
if ("@ARGV" =~ "-website") {
   foreach $ARGUMENT (@ARGV) {
      if ($ARGUMENT =~ /-website/i) {
      	$WebsiteOn = "yes" ;
      	$WebsiteHTMLName = $ARGV[$NrOfArg + 1] ;
      	$WebsiteStory = $ARGV[$NrOfArg + 2] ;
      }
      if ($ARGUMENT =~ /-RefreshWebIndex/i) {
        $OnlyWebIndex = "yes";
        if ($TRACING eq "ON") {
          print "Don't forget that you have to manually (or via batch command) remove the index files first!!!\n";
        } else { print ".";}
      }
      $NrOfArg = $NrOfArg + 1;
   }
   if ($WebsiteStory eq "") { print "No Website story chosen...\n"; exit ; }
   if ($TRACING eq "ON") {
     print "Website Building is 'On', overruling other functions!\nStories incorporated will be '$WebsiteStory'...\n";
   } else { print ".";}
   if (-e "..\\..\\Site\\$Language") {
     #`copy ..\\..\\Site\\Pics\\* ..\\..\\Site\\$Language\\Pics`;
     # continue
   } else {
     `mkdir ..\\..\\Site\\$Language`;
     `mkdir ..\\..\\Site\\$Language\\Pics`;
     `mkdir ..\\..\\Site\\$Language\\Sounds`;
     #`copy ..\\..\\Site\\Pics\\* ..\\..\\Site\\$Language\\Pics`;
     if ($TRACING eq "ON") {
       print "Creating path ..\\..\\Site\\$Language\n";
     } else { print ".";}
   }
}


# Get nice booktitle
$NrOfArg=0;
if ("@ARGV" =~ "-nice") {
   foreach $ARGUMENT (@ARGV) {
      if ($ARGUMENT eq "-nice") {
      	$NiceBookName = $ARGV[$NrOfArg + 1] ;
      	last;
      }
      $NrOfArg = $NrOfArg + 1;
   }
   if ($NiceBookName eq "")
   {
     if ($TRACING eq "ON") {
       print "No nice book name, using file name as default...\n";
     } else { print ".";}
     $NiceBookName = $WebsiteHTMLName;
   } else {
     if ($TRACING eq "ON") {
       print "Nice book name is $NiceBookName...\n";
     } else { print ".";}
   }
}


# Check if create pdf option is On (-app turns both -pdf and -interlinear on)
$NrOfArg=0;
if ("@ARGV" =~ "-pdf" || "@ARGV" =~ "-app") {
   if ("@ARGV" =~ "-interlinear" || "@ARGV" =~ "-app") {
      $SPEFO = "INTERLINEAR";
   }
   if ("@ARGV" =~ "-flowingenglish") {
      $FlowingEnglish = "yes";
   }
   if ("@ARGV" =~ "-addcsv") {
      $AddCSVFile = "yes";
   }
   if ("@ARGV" =~ "-wtf") {
      $WTFile = "yes, please";
   }
   $NrOfArg = 0;
   foreach $ARGUMENT (@ARGV) {
      if ($ARGUMENT eq "-app") {
      	$APPOn = "yes" ;
      	$PDFOn = "yes" ;
        $PDFStory = $ARGV[$NrOfArg + 1] ; # can be ALL
        $APPStory = $ARGV[$NrOfArg + 1] ; # can be ALL
      	last;
      }
      $NrOfArg = $NrOfArg + 1;
   }
   $NrOfArg = 0;
   foreach $ARGUMENT (@ARGV) {
      if ($ARGUMENT eq "-pdf") {
      	$PDFOn = "yes" ;
      	$PDFTitle = $ARGV[$NrOfArg + 1] ;
      	$PDFStory = $ARGV[$NrOfArg + 2] ;
      	if ($TRACING eq "ON") {
      	   print "PDF Story is $PDFStory\n";
      	} else { print "."; }
      	last;
      }
      $NrOfArg = $NrOfArg + 1;
   }
   if ("@ARGV" =~ "-discount") {
     $DISCOUNT = "30\% Discount";
     $NrOfArg = 0;
     foreach $ARGUMENT (@ARGV) {
       if ($ARGUMENT eq "-discount") {
      	$DISCOUNT = $ARGV[$NrOfArg + 1] ;
      	last;
       }
       $NrOfArg = $NrOfArg + 1;
     }
     if ($DISCOUNT !~ m/\%/ && $DISCOUNT !~ m/\$/) {
       if ($TRACING eq "ON") {
         print "DISCOUNT contains neither '\%' nor '\$', setting standard DISCOUNT of 30\%!\n";
       } else { print "."; }
       $DISCOUNT = "30\% Discount";
     }
   }
   if ("@ARGV" =~ "-isbn") {
     $NrOfArg = 0;
     foreach $ARGUMENT (@ARGV) {
       if ($ARGUMENT eq "-isbn") {
      	$ISBN = $ARGV[$NrOfArg + 1] ;
      	last;
       }
       $NrOfArg = $NrOfArg + 1;
     }
   }
   $HypLernPath = "HypLern";
   if ("@ARGV" =~ "-mainlang" && $APPOn eq "yes") {
     $NrOfArg = 0;
     foreach $ARGUMENT (@ARGV) {
       if ($ARGUMENT eq "-mainlang") {
      	$MAINLANG = $ARGV[$NrOfArg + 1] ;     	
      	if ($MAINLANG ne "HypLern") {
      	  if ($MAINLANG =~ " ") {
      	    $HypLernPath = "HypLern ".$MAINLANG;
      	    ($MAINLANG,$MAINSTORY) = split(/ /,$MAINLANG);
      	    $CapStory = uc($MAINSTORY);
      	    $AppTitle = $CapLanguage." ".$CapStory;
      	  } else {
            $HypLernPath = "HypLern ".$MAINLANG." Reader";
            $AppTitle = $CapLanguage;
          }
          print "Mainlang is ".$MAINLANG.". HypLernPath will be '".$HypLernPath."', ok?\n";
          #print "---Press Any Key---\n\n";
          #`pause`;
        }
      	last;
       }
       $NrOfArg = $NrOfArg + 1;
     }
   }
   $REFRESHAPPINDEX = "NO";
   if ($APPOn eq "yes" && "@ARGV" =~ "-RefreshAppIndex") {
     $NrOfArg = 0;
     foreach $ARGUMENT (@ARGV) {
       if ($ARGUMENT eq "-RefreshAppIndex") {
       	$REFRESHAPPINDEX = "YES";
      	$FileToRefresh = $ARGV[$NrOfArg + 1] ;
      	if ($FileToRefresh !~ m/\./) {
          $FileToRefresh = "";
        } else {
          print "Just refresh file $FileToRefresh!\n";
        }
      	last;
       }
       $NrOfArg = $NrOfArg + 1;
     }
   }
   if ($PDFStory eq "") { print "No PDF story chosen...\n"; exit ; }
   if ($TRACING eq "ON") {
     print "PDF Creation is 'On', Story incorporated will be '$PDFStory'...\n";
   } else { print ".";}
   if (-e "..\\..\\Pdf\\$Language") {
     # continue
   } else {
     `mkdir ..\\..\\Pdf\\$Language`;
     `mkdir ..\\..\\Pdf\\$Language\\Pics`;
     if ($TRACING eq "ON") {
       print "Creating path ..\\..\\Pdf\\$Language and ..\\..\\Pdf\\$Language\\Pics !\n";
     } else { print ".";}
   }
}

# APP INIT
# app story code will be built up like this:
# <base language code>___<author code>___<story code>___<target language code>[_<target language code>] (columns 4 and up are meant for any future multi-linear translations)

# N.B. Filename length based on OS
# iOS file=255 path=1024
# OSx file=255
# Windows mobile file=260
# Windows file=260
# Android file=127 !!!!!!!!!!!!!

# Windows local path example: 84 length
# C:\Users\Work\AppData\Local\Packages\io.cordova.myapp2027a0_h35559jr9hy9m\LocalState
# Android is much shorter, but let's say it's 60 so keep filename under 60
# nonetheless, because of Android constraint, keep filenames to max. 30 (?)
# <base language code>		= 3
# ___				= 3
# <author code>			= 10 -> if you shorten this, more room for the story code, vice versa, if you have longer author code, less room for story codes
# ___				= 3
# <story code>			= 18 -> probably longer, if author is shorter, or if Android path is shorter and leaves more room for filename
# ___				= 3
# <target language code>	= 3 -> later max 20? 5 target languages x 3 character code length plus five underscores
# ---------------------------------------------------
# total				= 43 -> max 60
# ---------------------------------------------------
# app path total: www/texts	= 10
# extendedDataDirectory:	= ??

# get app base and target language codes
if ($APPOn eq "yes") {
  open (FILE, "..\\..\\Languages\\App_Language_Codes.txt") || die "file $file is niet te vinden. ($!)\n";
  @APPCODES = <FILE>;
  close (FILE);
  foreach $AppCodeLine (@APPCODES) {
    ($AppLangCodePart,$AppLanguagePart,$Dummy) = split(/;/,$AppCodeLine);
    if ($AppLanguagePart eq "$Language") {
      $AppLangCode = $AppLangCodePart;
    }
    if ($AppLanguagePart eq "$TranToLanguage") {
      $AppTargCode = $AppLangCodePart;
    }
  }
  if ($AppLangCode eq "") {
    print "Tried to find App language code, but could not locate anything called \"$Language\" in the ISO 639-3 Language Code list.\n";
    exit;
  } else {
    if ($AppTargCode eq "") {
      print "Found base language $Language code \"$AppLangCode\" but could not locate target language \"$TranToLanguage\" in the ISO 639-3 Language Code list.\n";
      exit;
    } else {
      if ($TRACING eq "ON") {
        print "\nThis story / these stories are in language $Language from ISO 639-3 list with code \"$AppLangCode\".\n";
        print "The target language ISO 639-3 code is \"$AppTargCode\".\n";
      } else { print ".";}
    }
  }
  if ($MAINLANG eq $Language) {
    # main language is this one, lets set MAINLANGCODE to this AppLangCode for language.js
    $MAINLANGCODE = $AppLangCode;
  }
}

if ($APPOn eq "yes" && $HypLernPath ne "HypLern" ) {
  # table for shop site links, has to become something like this in the App: "<strong><a class=buyblue href='https://learn-to-read-foreign-languages.com/collections/".$LCLanguage.' title='Bermuda Word Shop' target='_blank' >LEARN-TO-READ-FOREIGN-LANGUAGES.COM</a></strong>"
  #$LTRFL = "https://learn-to-read-foreign-languages.com/collections/".$LCLanguage;
  #$PROVIDERCODE = "var optionHash = {};\n// These are the links per language to the respective app for the respective provider
  $PROVIDER = "Bermuda Word Shop";
  $PROVIDERSITE = "https://learn-to-read-foreign-languages.com/collections/".$LCLanguage;
  if ( "@ARGV" =~ m/provider microsoft/i ) {
    $PROVIDER = "Microsoft Store";
    if ($Language eq "Dutch") {
      $PROVIDERSITE = "https://www.microsoft.com/en-us/store/p/hyplern-dutch-reader/9nblggh4rwcp";
    }
    if ($Language eq "French") {
      $PROVIDERSITE = "https://www.microsoft.com/en-us/store/p/hyplern-french-reader/9nblggh4rxtk";
    }
    if ($Language eq "German") {
      $PROVIDERSITE = "https://www.microsoft.com/en-us/store/p/hyplern-german-reader/9nblggh4s8g5";
    }
    if ($Language eq "Hungarian") {
      $PROVIDERSITE = "https://www.microsoft.com/en-us/store/p/hyplern-hungarian-reader/9nblggh4wwr9";
    }
    if ($Language eq "Italian") {
      $PROVIDERSITE = "https://www.microsoft.com/en-us/store/p/hyplern-italian-reader/9nblggh4tsw0";
    }
    if ($Language eq "Russian") {
      $PROVIDERSITE = "https://www.microsoft.com/en-us/store/p/hyplern-russian-reader/9nblggh4rz2v";
    }
    if ($Language eq "Spanish") {
      $PROVIDERSITE = "https://www.microsoft.com/en-us/store/p/hyplern-spanish-reader/9nblggh4s79p";
    }
    if ($Language eq "Swedish") {
      $PROVIDERSITE = "https://www.microsoft.com/en-us/store/p/hyplern-swedish-reader/9nblggh4s8zj";
    }
  }
  if ( "@ARGV" =~ m/provider amazon/i ) {
    $PROVIDER = "Amazon Appstore for Android";
    if ($Language eq "Dutch") {
      $PROVIDERSITE = "https://www.amazon.com/Bermuda-Word-HypLern-Dutch-Reader/dp/B01HJ9W8QI";
    }
    if ($Language eq "French") {
      $PROVIDERSITE = "https://www.amazon.com/Bermuda-Word-HypLern-French-Reader/dp/B01HHF7U0I";
    }
    if ($Language eq "German") {
      $PROVIDERSITE = "https://www.amazon.com/Bermuda-Word-HypLern-German-Reader/dp/B01HLUSEC2";
    }
    if ($Language eq "Hungarian") {
      $PROVIDERSITE = "https://www.amazon.com/Bermuda-Word-HypLern-Hungarian-Reader/dp/B01GRBXYXA";
    }
    if ($Language eq "Italian") {
      $PROVIDERSITE = "https://www.amazon.com/Bermuda-Word-HypLern-Italian-Reader/dp/B01K16S6XK";
    }
    if ($Language eq "Russian") {
      $PROVIDERSITE = "https://www.amazon.com/Bermuda-Word-HypLern-Russian-Reader/dp/B01HMZLH7K";
    }
    if ($Language eq "Spanish") {
      $PROVIDERSITE = "https://www.amazon.com/Bermuda-Word-HypLern-Spanish-Reader/dp/B01HOI8FTI";
    }
    if ($Language eq "Swedish") {
      $PROVIDERSITE = "https://www.amazon.com/Bermuda-Word-HypLern-Swedish-Reader/dp/B01GSRIKO6";
    }
  }
  # for google, add check whether Folk, Fairy, Legends or Beginner is included in current Group, this means it's level AB -> HypLern $Language Beginner, otherwise choose level BC -> HypLern $Language Advanced
  if ( "@ARGV" =~ m/provider google/i ) {
    $PROVIDER = "Google Play Store in the coming weeks";
    $PROVIDERSITE = "https://play.google.com/store/search?q=hyplern&c=apps";
    if ($Language eq "Dutch") {
      $PROVIDER = "Google Play Store";
      if ($Group =~ m/fairytales/i || $Group =~ m/folktales/i || $Group =~ m/volksverhalen/i) {
      	$PROVIDERSITE = "https://play.google.com/store/apps/details?id=com.bermudaword.hyplerndutchbeginner";
      } else {
      	$PROVIDERSITE = "https://play.google.com/store/apps/details?id=com.bermudaword.hyplerndutchadvanced";
      }
    }
    if ($Language eq "French") {
      $PROVIDER = "Google Play Store";
      if ($Group =~ m/fairytales/i || $Group =~ m/guerber/i || $Group =~ m/folktales/i || $Group =~ m/beginner/i || $Group =~ m/legends/i ) {
        $PROVIDERSITE = "https://play.google.com/store/apps/details?id=com.bermudaword.hyplernfrenchbeginner";
      } else {
        $PROVIDERSITE = "https://play.google.com/store/apps/details?id=com.bermudaword.hyplernfrenchadvanced";
      }
    }
  }
}

if ($APPOn eq "yes" && $Language eq $MAINLANG && $HypLernPath ne "HypLern") {

  # create language.js if RefreshAppIndex is on with android or windows counter
  if ($HypLernPath ne "HypLern" && $MAINLANG eq $Language && ( "@ARGV" =~ "RefreshAppIndex windows" || "@ARGV" =~ "RefreshAppIndex android" ) ) {
    $WriteFile = "..\\Cordova\\AppProjects\\".$HypLernPath."\\".$HypLernPath."\\www\\scripts\\language.js";
    if ("@ARGV" =~ m/RefreshAppIndex windows/i) {
      $LanguageCodeScriptContents = "\ï\»\¿\/\* globals console,document,window,cordova \*\/\n// device, my very own one line device plugin\nvar device = \"windows\";\n// language, only this language allows word practice\nvar language_code = \"".$MAINLANGCODE."\";\n";
    }
    if ("@ARGV" =~ m/RefreshAppIndex android/i) {
      $LanguageCodeScriptContents = "\ï\»\¿\/\* globals console,document,window,cordova \*\/\n// device, my very own one line device plugin\nvar device = \"android\";\n// language, only this language allows word practice\nvar language_code = \"".$MAINLANGCODE."\";\n";
    }
    print "WriteFile is ".$WriteFile."\n";
    open (WRITEFILE, ">$WriteFile") || die "file $WriteFile kan niet worden aangemaakt, ($!)\n";
    print WRITEFILE $LanguageCodeScriptContents ;
    close (WRITEFILE);
  }
  
  $FileToRefresh =~ s/\n//g;
  # copy HypLern base scripts and css and all that
  if ($MAINLANG ne "" && $MAINLANG ne "HypLern" && $MAINLANG eq $Language) {
    # css
    $CSSTargetPath = "..\\Cordova\\AppProjects\\".$HypLernPath."\\".$HypLernPath."\\www\\css";
    if ($FileToRefresh eq "") {
      `copy ..\\Cordova\\AppProjects\\HypLern\\HypLern\\www\\css\\*.css \"$CSSTargetPath\"`;
    } else {
      `copy ..\\Cordova\\AppProjects\\HypLern\\HypLern\\www\\css\\$FileToRefresh \"$CSSTargetPath\"`;
    }
    # images
    $IMGTargetPath = "..\\Cordova\\AppProjects\\".$HypLernPath."\\".$HypLernPath."\\www\\images";
    if ($FileToRefresh eq "") {
      `copy ..\\Cordova\\AppProjects\\HypLern\\HypLern\\www\\images\\* \"$IMGTargetPath\"`;
    } else {
      `copy ..\\Cordova\\AppProjects\\HypLern\\HypLern\\www\\images\\$FileToRefresh \"$IMGTargetPath\"`;
    }
    # scripts
    $SCRTargetPath = "..\\Cordova\\AppProjects\\".$HypLernPath."\\".$HypLernPath."\\www\\scripts";
    if ($FileToRefresh eq "") {
      `copy ..\\Cordova\\AppProjects\\HypLern\\HypLern\\www\\scripts\\hyplern.js \"$SCRTargetPath\"`;
      `copy ..\\Cordova\\AppProjects\\HypLern\\HypLern\\www\\scripts\\vocabulary.js \"$SCRTargetPath\"`;
      `copy ..\\Cordova\\AppProjects\\HypLern\\HypLern\\www\\scripts\\wanderhyplern.js \"$SCRTargetPath\"`;
      `copy ..\\Cordova\\AppProjects\\HypLern\\HypLern\\www\\scripts\\subhyplern.js \"$SCRTargetPath\"`;
      `copy ..\\Cordova\\AppProjects\\HypLern\\HypLern\\www\\scripts\\actions.js \"$SCRTargetPath\"`;
      `copy ..\\Cordova\\AppProjects\\HypLern\\HypLern\\www\\scripts\\menus.js \"$SCRTargetPath\"`;
      `copy ..\\Cordova\\AppProjects\\HypLern\\HypLern\\www\\scripts\\constants.js \"$SCRTargetPath\"`;
      `copy ..\\Cordova\\AppProjects\\HypLern\\HypLern\\www\\scripts\\options.js \"$SCRTargetPath\"`;
      `copy ..\\Cordova\\AppProjects\\HypLern\\HypLern\\www\\scripts\\index.js \"$SCRTargetPath\"`;
      `copy ..\\Cordova\\AppProjects\\HypLern\\HypLern\\www\\scripts\\platformOverrides.js \"$SCRTargetPath\"`;
    } else {
      `copy ..\\Cordova\\AppProjects\\HypLern\\HypLern\\www\\scripts\\$FileToRefresh \"$SCRTargetPath\"`;
    }
    # index
    $INDTargetPath = "..\\Cordova\\AppProjects\\".$HypLernPath."\\".$HypLernPath."\\www";
    if ($FileToRefresh eq "") {
      `copy ..\\Cordova\\AppProjects\\HypLern\\HypLern\\www\\vocabulary.html \"$INDTargetPath\"`;
      `copy ..\\Cordova\\AppProjects\\HypLern\\HypLern\\www\\about.html \"$INDTargetPath\"`;
      `copy ..\\Cordova\\AppProjects\\HypLern\\HypLern\\www\\index.html \"$INDTargetPath\"`;
      `copy ..\\Cordova\\AppProjects\\HypLern\\HypLern\\www\\wanderlust.html \"$INDTargetPath\"`;
    } else {
      `copy ..\\Cordova\\AppProjects\\HypLern\\HypLern\\www\\$FileToRefresh \"$INDTargetPath\"`;
    }
    $INDEXFILENEW = "";
    if ($FileToRefresh =~ "index" || $FileToRefresh eq "") {
      # replace <CENTER><B>HUNGARIAN</B></CENTER> in index file if you copy that one automatically too
      $ReadFile = "..\\Cordova\\AppProjects\\".$HypLernPath."\\".$HypLernPath."\\www\\index.html" ;
      open (READFILE, "$ReadFile") || die "file $ReadFile cannot be found. ($!)\n";
      @INDEXFILE = <READFILE>;
      close (READFILE);
      foreach $IndexFileLine (@INDEXFILE) {
        $IndexFileLine =~ s/\<CENTER\>\<B\>HUNGARIAN\<\/B\>\<\/CENTER\>/\<CENTER\>\<B\>$AppTitle\<\/B\>\<\/CENTER\>/;
        #push (@INDEXFILENEW,$IndexFileLine);
        $INDEXFILENEW = $INDEXFILENEW.$IndexFileLine;
      }
      print "WriteFile is ".$ReadFile."\n";
      open (WRITEFILE, ">$ReadFile") || die "file $ReadFile kan niet worden aangemaakt, ($!)\n";
      print WRITEFILE $INDEXFILENEW ;
      close (WRITEFILE);
    }
    # wanderlust
    $WANDERLUSTFILENEW = "";
    if ($FileToRefresh =~ "wanderlust" || $FileToRefresh eq "") {
      # make sure only the correct languages are shown in the wanderlust library
      $ReadFile = "..\\Cordova\\AppProjects\\".$HypLernPath."\\".$HypLernPath."\\www\\wanderlust.html" ;
      open (READFILE, "$ReadFile") || die "file $ReadFile cannot be found. ($!)\n";
      @WANDERLUST = <READFILE>;
      close (READFILE);
      foreach $WanderlustFileLine (@WANDERLUST) {
        $WanderlustFileLine =~ s/          \<span class\=\"$Language link\" onclick\=\"findIndex\(\'$AppLangCode\'\)\;\"\>\<a href\=\"\#\"\>\<img src\=\"images\/$LCLanguage\.jpg\" \/\>\<\/a\>\<\/span\>\<FLAGCODE\>\n//;
        $WanderlustFileLine =~ s/          \<span class\=\"$Language link\" onclick\=\"findIndex\(\'$AppLangCode\'\)\;\"\>\<a href\=\"\#\"\>\<img src\=\"images\/$LCLanguage\.jpg\" \/\>\<\/a\>\<\/span\>\n//;
        # for now get rid of Polish, Portuguese and Indonesian (no story images yet)
        $WanderlustFileLine =~ s/          \<span class\=\"Polish link\" onclick\=\"findIndex\(\'pol\'\)\;\"\>\<a href\=\"\#\"\>\<img src\=\"images\/polish\.jpg\" \/\>\<\/a\>\<\/span\>\<FLAGCODE\>\n//;
        $WanderlustFileLine =~ s/          \<span class\=\"Polish link\" onclick\=\"findIndex\(\'pol\'\)\;\"\>\<a href\=\"\#\"\>\<img src\=\"images\/polish\.jpg\" \/\>\<\/a\>\<\/span\>\n//;
        $WanderlustFileLine =~ s/          \<span class\=\"Portuguese link\" onclick\=\"findIndex\(\'por\'\)\;\"\>\<a href\=\"\#\"\>\<img src\=\"images\/portuguese\.jpg\" \/\>\<\/a\>\<\/span\>\<FLAGCODE\>\n//;
        $WanderlustFileLine =~ s/          \<span class\=\"Portuguese link\" onclick\=\"findIndex\(\'por\'\)\;\"\>\<a href\=\"\#\"\>\<img src\=\"images\/portuguese\.jpg\" \/\>\<\/a\>\<\/span\>\n//;
        $WanderlustFileLine =~ s/          \<span class\=\"Indonesian link\" onclick\=\"findIndex\(\'ind\'\)\;\"\>\<a href\=\"\#\"\>\<img src\=\"images\/indonesian\.jpg\" \/\>\<\/a\>\<\/span\>\<FLAGCODE\>\n//;
        $WanderlustFileLine =~ s/          \<span class\=\"Indonesian link\" onclick\=\"findIndex\(\'ind\'\)\;\"\>\<a href\=\"\#\"\>\<img src\=\"images\/indonesian\.jpg\" \/\>\<\/a\>\<\/span\>\n//;
        #push (@WANDERLUSTFILENEW,$WanderlustFileLine);
        $WANDERLUSTFILENEW = $WANDERLUSTFILENEW.$WanderlustFileLine;
      }
      print "WriteFile is ".$ReadFile."\n";
      open (WRITEFILE, ">$ReadFile") || die "file $ReadFile kan niet worden aangemaakt, ($!)\n";
      print WRITEFILE $WANDERLUSTFILENEW ;
      close (WRITEFILE);
    }
      
    # copy App icons and splash screens (groan)
    if ($FileToRefresh eq "") {
      # main icon base
      $IMGTargetPath = "..\\Cordova\\AppProjects\\".$HypLernPath."\\".$HypLernPath."\\res";
      if (-e $IMGTargetPath) {
        $output = `xcopy /E /Y /F ..\\Cordova\\AppProjects\\HypLern\\HypLern\\res \"$IMGTargetPath\"`;
        if ($TRACING eq "ON") {
          print $output;
        } else { print ".";}
      } else {
        if ($TRACING eq "ON") {
          print "Path $IMGTargetPath does not exist, build this project once first!";
        } else { print ".";}
      }
    }
    # copy build.json
    if ($FileToRefresh eq "") {
      # root root
      $ROOTargetPath = "..\\Cordova\\AppProjects\\".$HypLernPath."\\".$HypLernPath;
      `copy ..\\Cordova\\AppProjects\\HypLern\\HypLern\\build.json \"$ROOTargetPath\"`;
    }
      
    # built icon and screens per platform (first check if this is necessary, seemed to me that new build didn't overwrite old image files)
    # windows
    $IMGTargetPath = "..\\Cordova\\AppProjects\\".$HypLernPath."\\".$HypLernPath."\\platforms\\windows\\images";
    if (-e $IMGTargetPath) {
      $output = `xcopy /E /Y /F ..\\Cordova\\AppProjects\\HypLern\\HypLern\\platforms\\windows\\images \"$IMGTargetPath\"`;
      if ($TRACING eq "ON") {
        print $output;
      } else { print ".";}
    } else {
      `mkdir \"..\\Cordova\\AppProjects\\$HypLernPath\\$HypLernPath\\platforms\\windows"`;
      `mkdir \"..\\Cordova\\AppProjects\\$HypLernPath\\$HypLernPath\\platforms\\windows\\images"`;
      if ($TRACING eq "ON") {
        print "Creating path ..\\Cordova\\AppProjects\\".$HypLernPath."\\".$HypLernPath."\\platforms\\windows\\images !\n";
      } else { print ".";}
      $output = `xcopy /E /Y /F ..\\Cordova\\AppProjects\\HypLern\\HypLern\\platforms\\windows\\images \"$IMGTargetPath\"`;
    }
    # android
    $IMGTargetPath = "..\\Cordova\\AppProjects\\".$HypLernPath."\\".$HypLernPath."\\platforms\\android\\res";
    if (-e $IMGTargetPath) {
      $output = `xcopy /E /Y /F ..\\Cordova\\AppProjects\\HypLern\\HypLern\\platforms\\android\\res \"$IMGTargetPath\"`;
      if ($TRACING eq "ON") {
        print $output;
      } else { print ".";}
    } else {
      `mkdir \"..\\Cordova\\AppProjects\\$HypLernPath\\$HypLernPath\\platforms\\android"`;
      `mkdir \"..\\Cordova\\AppProjects\\$HypLernPath\\$HypLernPath\\platforms\\android\\res"`;
      if ($TRACING eq "ON") {
        print "Creating path ..\\Cordova\\AppProjects\\".$HypLernPath."\\".$HypLernPath."\\platforms\\android\\res !\n";
      } else { print ".";}
      $output = `xcopy /E /Y /F ..\\Cordova\\AppProjects\\HypLern\\HypLern\\platforms\\android\\res \"$IMGTargetPath\"`;
    }
  }
}

if ("@ARGV" =~ "-RefreshAppIndex") {
  exit 0;
}

# check if no pause is set (-nopause means no pauses in running)
if ("@ARGV" =~ "-nopause") {
   $PAUSENEEDED = "FALSE";
} else {
   $PAUSENEEDED = "TRUE";
}

# check if dictionary option is set (-DicD is DutchToTarget Dictionary aanvullen, -DicE is EnglishToTarget Dictionary aanvullen)
if ("@ARGV" =~ "-DicD") {
   if ($Language ne "Dutch") {
     $DICCWORDON = "YES";
     $DICCWORDLANGUAGE="Dutch";
   } else {
     if ($TRACING eq "ON") {
       print "You don't need extra dictionary Dutch-$TranToLanguage as Base language is already Dutch...\n";
     } else { print ".";}
   }
}
if ("@ARGV" =~ "-DicE") {
  if ($Language ne "English") {
    $DICCWORDON = "YES";
    $DICCWORDLANGUAGE="English";
  } else {
    if ($TRACING eq "ON") {
      print "You don't need extra dictionary English-$TranToLanguage as Base language is already English...\n";
    } else { print ".";}
  }
}

# check if audiofiles need to be reformatted (from .mp3 or .wav to .dat)
if ("@ARGV" =~ /-RedoAudio/i) {
  if ($TRACING eq "ON") {
    print "Redo Audio!\n";
  } else { print ".";}
  $REDO_AUDIO = "YES";
  $EmptyDataDir = `del ..\\..\\Languages\\$Language\\Audio\\$Group\\Data\\*.dat` ;
  if ($? != 0) { print "Help! ".$EmptyDataDir ; }
}

# check if production option is set (create e-book on designated drive)
if ("@ARGV" =~ "-prod" || "@ARGV" =~ "-PROD") {
   $NrOfArg = 0;
   foreach $ARGUMENT (@ARGV) {
      if ($ARGUMENT eq "-prod") {
         $PRODDRIVE = $ARGV[$NrOfArg+1];
         $PRODDRIVE =~ s/://g;
         $LENPRODDRIVE = length $PRODDRIVE;
         $PRODDRIVE = uc($PRODDRIVE);
         if ($LENPRODDRIVE ne 1) {
            $PRODDRIVE = "";
         } else {
            $TEMPPROD = $PRODDRIVE;
            $PRODDRIVE =~ s/^([A-Z])/CORRECT/g;
            if ($PRODDRIVE eq "CORRECT") {
               $PRODDRIVE = $TEMPPROD;
            } else {
               $PRODDRIVE = "";
            }        
         }
      }
      $NrOfArg = $NrOfArg + 1;      
   }
   if ($PRODDRIVE eq "") {
      if ($TRACING eq "ON") {
        print "No (correct) prod drive entered, TOPROD argument will be ignored...\n";
      } else { print ".";}
      $TOPROD = "no";
   } else {
      $TOPROD = "yes";
      if ($TRACING eq "ON") {
        print "TOPROD is $PRODDRIVE\n";
      } else { print ".";}
   }
} else {
   if ($TRACING eq "ON") {
     print "No (correct) prod drive entered, TOPROD argument will be ignored...\n";
   } else { print ".";}
   $TOPROD = "no";
}


# check if demo mode (only gets max of three pages of chapter then prints full product advertisement page
if ("@ARGV" =~ "-demo" || $MAINSTORY eq "Free") {
   print "MAINSTORY is $MAINSTORY!\n";
   $DEMOWANTED = "TRUE";
} else {
   $DEMOWANTED = "FALSE";
}

###############################################################################################################################
#
# MAIN SCRIPT
#
###############################################################################################################################

# if 'no pause' option is set, don't pause
if ($PAUSENEEDED =~ "TRUE") {
   print "---Press Any Key---\n\n";
   `pause`;
} else {
   if ($TRACING eq "ON") {
     print "\n";
   } else { print ".";}
}

#FOR EVERY GROUP, RUN THE REST OF THIS FORMATTING SCRIPT
foreach $Group (@Groups)
{
   if ($TRACING eq "ON") {
     print "Current Group: $Group\n";
   } else { print ".";}
   
  
   # CREATE GROUP PART OF SHORT UNIQUE LANGUAGE-GROUP CODE FOR KEY
   $GRPCOD = uc ( substr $Group, 0, 3 ) ;

  if ($TRACING eq "ON") {
   print "SPECIFIC REGISTRY PRODUCT CODE IS ".$LANCOD.$TARCOD.$GRPCOD."\n";
  } else { print ".";}

   $TestGrepArguments = "@ARGV";
   # Get Original Title
   if ($TestGrepArguments !~ "-T")		# Should be original title in French, but looks like this is only used to give title to book on web page, plus it's used wrong as well, filled out as translated title
   {
      if ($TRACING eq "ON") {
        print "No title given, title will be Group $Group\n";
      } else { print ".";}
      $TitleOrg = $Group;
   }
   else
   {
      $NrOfArg = 0;
      foreach $ARGUMENT (@ARGV)
      {
         if ($ARGUMENT eq "-T")
         {
            $TitleOrg = $ARGV[$NrOfArg+1];
         }
         $NrOfArg = $NrOfArg + 1;      
      }
      if ($TitleOrg eq "")
      {
         if ($TRACING eq "ON") {
           print "No title given, title will be Group $Group\n";
         } else { print ".";}
         $TitleOrg = $Group;
      }
      else
      {
         if ($TRACING eq "ON") {
           print "Original Title is $TitleOrg\n";
         } else { print ".";}
      }
   }

   # Get Translation of Title
   if ($TestGrepArguments !~ "-V")		# This should be the translation of the original title, it is used in UPPERCASE version as e-book title and as translation of original title (not sure where)
   {
      if ($TRACING eq "ON") {
        print "No title translation given, title translation will be Group $Group\n";
      } else { print ".";}
      $Title = $Group;
   }
   else
   {
      $NrOfArg = 0;
      foreach $ARGUMENT (@ARGV)
      {
         if ($ARGUMENT eq "-V")
         {
            $Title = $ARGV[$NrOfArg+1];
         }
         $NrOfArg = $NrOfArg + 1;      
      }
      if ($Title eq "")
      {
         if ($TRACING eq "ON") {
           print "No title translation given, title translation will be Group $Group\n";
         } else { print ".";}
         $Title = $Group;
      }
      else
      {
         if ($TRACING eq "ON") {
           print "Title Translation is $Title\n";
         } else { print ".";}
      }
   }
   if ($DEMOWANTED eq "TRUE") {
      $TitleOrg = $TitleOrg." Demo";
      $Title = $Title." Demo";
   }

   # grab all .htm files in the \Texts\$Group dir (where sources reside)
   @DIROUTPUT = `dir ..\\..\\Languages\\$Language\\Texts\\$Group\\*.htm`;
   foreach $DIRLINE(@DIROUTPUT)
   {
      $MatchName = $Language.$Group."Text";
      if ($DIRLINE =~ "$MatchName")
      {
         @DIRLINE = split ("$Group", $DIRLINE, 2) ;
         $Filename = $Language.$Group.$DIRLINE[1];
         push (@Files, $Filename);
      }
   }

   # check whether HTML\\Main already exists, if yes, delete all, if no create dir
   if (-e "..\\..\\Languages\\$Language\\HTML\\Main")
   {
      # if not formatting one specific file, delete all files in target dir
      $Targetdir = "..\\..\\Languages\\$Language\\HTML\\Main" ;
      `del $Targetdir\\*.htm`;
      `copy ..\\..\\Tool\\Base\\Java\\Main\\JavaMap.htm $Targetdir`;
      `copy ..\\..\\Tool\\Base\\Style\\Main\\StyleMap.htm $Targetdir`;
   }
   else
   {
      #create dir
      `mkdir ..\\..\\Languages\\$Language\\HTML\\Main`;
      $Targetdir = "..\\..\\Languages\\$Language\\HTML\\Main" ;
      `copy ..\\..\\Tool\\Base\\Java\\Main\\JavaMap.htm $Targetdir`;
      `copy ..\\..\\Tool\\Base\\Style\\Main\\StyleMap.htm $Targetdir`;
   }

   # check whether HTML\\$Group already exists, if yes, delete all, if no create dir
   if (-e "..\\..\\Languages\\$Language\\HTML\\$Group")
   {
      # if not formatting one specific file, delete all files in target dir
      $Targetdir = "..\\..\\Languages\\$Language\\HTML\\$Group" ;
      `del $Targetdir\\*.htm`;
   }
   else
   {
      #create dir
      `mkdir ..\\..\\Languages\\$Language\\HTML\\$Group`;
   }

   # check for special arguments concerning files/chapternames
   $FirstPartOfFileName = $Language.$Group."Text" ;
   $TEXTLEVEL = "BC"; # default texts are intermediate to advanced
   for ($NR = 0; $NR < @ARGV+1; $NR++)
   {
      # -f overrules autosearching for files
      # These names are also used as shortnames.
      # -c specifies the long Chapter names of these respective chapters
      if ($ARGV[$NR] eq "-f")
      {
         $ChapterFileNames = $ARGV[$NR+1];
         @ChapterFileNames = split('\/',$ChapterFileNames);
         if ($TRACING eq "ON") {
           print("Chapter File Names : @ChapterFileNames\n");
         } else { print ".";}
         @ChapterShortNames = @ChapterFileNames;
         @StringFiles = ();
         foreach $ChapterFileName(@ChapterFileNames)
         {
            push(@StringFiles,$FirstPartOfFileName.$ChapterFileName.".htm\n");
         }
         $FileNamesSpecified = "YES";
      }
      if ($ARGV[$NR] eq "-alt")
      {
         $ChapterLongNamesAlternative = $ARGV[$NR+1];
         @ChapterLongNamesAlternative = split('\/',$ChapterLongNamesAlternative);
         if ($TRACING eq "ON") {
           print ("Chapter Long Names Alternative : @ChapterLongNamesAlternative\n");
         } else { print ".";}
      }
      if ($ARGV[$NR] eq "-XEnglish")
      {
         $ChapterLongNamesTranslationEnglish = $ARGV[$NR+1];
         @ChapterLongNamesTranslationEnglish = split('\/',$ChapterLongNamesTranslationEnglish);
         if ($TRACING eq "ON") {
           print ("Chapter Long Names Translation for English: @ChapterLongNamesTranslationEnglish\n");
         } else { print ".";}
      }
      if ($ARGV[$NR] eq "-XDutch")
      {
         $ChapterLongNamesTranslationDutch = $ARGV[$NR+1];
         @ChapterLongNamesTranslationDutch = split('\/',$ChapterLongNamesTranslationDutch);
         if ($TRACING eq "ON") {
           print ("Chapter Long Names Translation for Dutch: @ChapterLongNamesTranslationDutch\n");
         } else { print ".";}
      }
      if ($ARGV[$NR] eq "-c")
      {
         $ChapterNames = $ARGV[$NR+1];
         @ChapterNames = split('\/',$ChapterNames);
         if ($TRACING eq "ON") {
           print("Chapter Names : @ChapterNames\n");
         } else { print ".";}
         @ChapterLongNames = @ChapterNames;
         $ChapterNamesSpecified = "YES";
      }
      if ($ARGV[$NR] eq "-wc")
      {
      	 $ChapterWords = $ARGV[$NR+1];
      	 @ChapterWords = split('\/',$ChapterWords);
         if ($TRACING eq "ON") {
           print("Chapter Word Total : @ChapterWords\n");
         } else { print ".";}
      }
      if ($ARGV[$NR] eq "-nwc")
      {
      	 $ChapterUniqueWords = $ARGV[$NR+1];
      	 @ChapterUniqueWords = split('\/',$ChapterUniqueWords);
         if ($TRACING eq "ON") {
           print("Chapter Unique Words : @ChapterUniqueWords\n");
         } else { print ".";}
      }
      if ($ARGV[$NR] eq "-lvl") {
      	$TEXTLEVEL = $ARGV[$NR+1];
        if ($TRACING eq "ON") {
          print("Chapter Level : $TEXTLEVEL\n");
        } else { print ".";}
      }
      if ($ARGV[$NR] eq "-author")
      {
      	 $ChapterAuthor = $ARGV[$NR+1];
      	 @ChapterAuthors = split('\/',$ChapterAuthor);
         if ($TRACING eq "ON") {
           print("Chapter Authors : @ChapterAuthors\n");
         } else { print ".";}
      }
      if ($ARGV[$NR] eq "-group")
      {
         $StoryGroups = $ARGV[$NR+1];
         @StoryGroups = split('\/',$StoryGroups);
         if ($TRACING eq "ON") {
           print("Story Groups : @StoryGroups\n");
         } else { print ".";}
      }
      if ($ARGV[$NR] eq "-authornice")
      {
      	 $ChapterNiceAuthor = $ARGV[$NR+1];
      	 @ChapterNiceAuthors = split('\/',$ChapterNiceAuthor);
         if ($TRACING eq "ON") {
           print("Chapter Nice Authors : @ChapterNiceAuthors\n");
         } else { print ".";}
      }
   }

   #find files & chapter shortnames
   $HighestChapterNumber = 0;
   @SortedFiles=();
   $FirstPartOfFileName = $Language.$Group."Text" ;
   foreach $FilesEntry(@Files)
   {
      $FilesEntry =~ s/$FirstPartOfFileName// ;
      $FilesEntry =~ s/.htm\n// ;
      if ($FilesEntry =~ /^\d+$/)
      {
         #print "$FilesEntry is a number\n";
         if ($FilesEntry >= $HighestChapterNumber)
         {
            $HighestChapterNumber = $FilesEntry ;
         }
      }
      else
      {
         #print "$FilesEntry is a string\n";
         if ($FilesEntry !~ "Title")
         {
            if ($FileNamesSpecified ne "YES")
            {
               push(@StringFiles,$FirstPartOfFileName.$FilesEntry.".htm\n") ;
            }
            if ($ChapterNamesSpecified ne "YES")
            {
               push(@ChapterShortNames,$FilesEntry);
               push(@ChapterLongNames,$FilesEntry);
            }
         }
         else
         {
            $TitleFile = $FirstPartOfFileName.$FilesEntry.".htm\n";
            $TitleShortName = "Title";
         }
      }
   }

   #adding Title
   if ($TitleShortName eq "Title" && $WebsiteOn ne "yes")
   {
      unshift(@StringFiles,$TitleFile);			#full file names
      unshift(@ChapterShortNames,"Title");		#short chapter names
      #unshift(@ChapterLongNames,"Title & Contents");	#long chapter names
   }

   #Adding numbered chapters
   for ($NR = 0; $NR < $HighestChapterNumber +1 ; $NR++)
   {
      if ($NR != 0)
      {
         $FileName = $FirstPartOfFileName.$NR.".htm\n" ;
         push(@SortedFiles,$FileName) ;
         push(@ChapterLongNames,"$NR") ;
         push(@ChapterShortNames,"$NR") ;
      }
   }
   if ($TRACING eq "ON") {
     print "@ChapterShortNames\n";
   } else { print ".";}
   unshift(@SortedFiles,@StringFiles) ;
   @Files = @SortedFiles;
   # to have only number or name in an array we remember the shortnames
   @ShortFiles = @SortedShortFiles;
   if ($TRACING eq "ON") {
     print "Long Chapter Names: @ChapterLongNames\n";
     print "Short Chapter Names: @ChapterShortNames\n";
     print "Long Chapter Names: @ChapterLongNames\n";
     print "Long Chapter Names Alternative: @ChapterLongNamesAlternative\n";
   } else { print ".";}

   if ($TRACING eq "ON") {
     print "Files:\n@Files" ;
   } else { print ".";}

   if (@Files == 0)
   {
      if ($TRACING eq "ON") {
        print "No Files, Skipping...\n";
      } else { print ".";}
      if ($PAUSENEEDED =~ "TRUE")
      {
         print "---Press Any Key---\n\n";
         `pause`;
         next;
      }
      else
      {
         if ($TRACING eq "ON") {
           print "\n";
         } else { print ".";}
      }
   }
   else
   {
      if ($PAUSENEEDED =~ "TRUE")
      {
         print "---Press Any Key---\n\n";
         `pause`;
      }
      else
      {
         if ($TRACING eq "ON") {
           print "\n";
         } else { print ".";}
      }
   }


  # Start of file formatting loop
  # he this should be a bigger event!
  # START OF FILE FORMATTING LOOP!!!!
  foreach $file (@Files)
  {
    $FINISHEDWITHMESSPARTS = "YES";
    $FirstPartOfFileName = $Language.$Group."Text" ;
    $relevantpartoffile = $file ;
    $relevantpartoffile =~ s/$FirstPartOfFileName// ;
    $relevantpartoffile =~ s/.htm\n// ;
    if ($WebsiteOn eq "yes" && $WebsiteStory !~ /$relevantpartoffile/i ) {
      if ($TRACING eq "ON") {
        print "Website building is on, and $WebsiteStory does not contain $relevantpartoffile\n";
      } else { print ".";}
      next;
    }
    if ($AddCSVFile eq "yes") {
      $CSVFile = "..\\..\\Pdf\\$Language\\".$relevantpartoffile.".txt";
    }
    #reset variables
    $RECORDEDCHARS = "";
    $NEWTEXT = "";
    $NR = 0;
    $NEWPART = "";
    $RECORD = "NO";
  
    $printfile = $file;
    chop $printfile;
    if ($TRACING eq "ON") {
      print("File is nu : $printfile");
    } else { print ".";}
  
    open (FILE, "..\\..\\Languages\\$Language\\Texts\\$Group\\$file") || die "file $file is niet te vinden. ($!)\n";
  
    @INHOUD = <FILE>;
    close (FILE);
    #print "@INHOUD"; 
  
    $INHOUD = "@INHOUD";
    $NROFCHARS = length ($INHOUD);
  
    #Extract Arab Number from filename and Convert to Roman Chapter Number
    #So we can build Chapter frame
  
    $ArabNumberOfChapter = $file ;
    $ArabNumberOfChapter =~ s/$FirstPartOfFileName// ;
    $ArabNumberOfChapter =~ s/.htm\n// ;
    $RomanNumberOfChapter = roman($ArabNumberOfChapter) ;
    $RomanNumberOfChapter = uc($RomanNumberOfChapter) ;
  
    #print "Current ArabNumberOfChapter is $ArabNumberOfChapter\n";
  
    if ($ArabNumberOfChapter =~ /^\d+$/ && $ArabNumberOfChapter != 0)
    {
      if ($TRACING eq "ON") {
        print " - Chapter ".$RomanNumberOfChapter." ( ".$ArabNumberOfChapter." )\n";
      } else { print ".";}
    }
    else
    {
      $RomanNumberOfChapter = $ArabNumberOfChapter ;
      if ($TRACING eq "ON") {
        print " - $ArabNumberOfChapter ( $ArabNumberOfChapter)\n";
      } else { print ".";}
    }
  
    # remove chapter number from page name
    $filepart = $FirstPartOfFileName ;
  
    # BEFORE WE GO ANY FURTHER IT WOULD BE NICE TO GET THE CHARACTER SET THAT IS USED
    # SO THAT WE CAN USE IT FOR OUR OWN HTML AND EVERYTHING WILL BE NICE AND READABLE
  
    @CHARSET = split ( /charset=/ , $INHOUD ) ;
    $CHARSET = $CHARSET[1] ;
    @CHARSET = split ( /\"/ , $CHARSET ) ;
    $CHARSET = $CHARSET[0] ;
  
    if ($TRACING eq "ON") {
      print "Current Windows Character Set :  $CHARSET  \n" ;
    } else { print ".";}
  
    if ($DEFAULTCHARSET ne "")
    {
      $CHARSET = $DEFAULTCHARSET ;
    }
    if ($TRACING eq "ON") {
      print "Overruling Windows Character Set : $CHARSET  \n" ;
    } else { print ".";}
  
  
    # EDIT $INHOUD TEMPORARILY TO CHANGE CERTAIN STRINGS ALREADY INTO PARSE CODES, TO AVOID LATER CONFLICT
    $INHOUD =~ s/<IMG/### Q ###/g;
    $INHOUD =~ s/<\/IMG>/###Q Q###/g;
    
    if ( $PDFOn eq "yes") {
      $INHOUD =~ s/loading picture//g;
    }
  
    @ALLCHARS = split(//,$INHOUD);
  
    # WORD RECORDING
    # ====================================================
    @RECORDONWORD = ("RU'>","RU\">","=RU>","FR'>","FR\">","=FR>","BE'>","=BE>","GB'>","US'>","-US>","al'>","al\">","ne'>","pt'>","ity>","on\">","ion>","llE>","amE>","pan>","PAN>","mal>","on\">","ace>","ck'>","<BR>") ;
  
    #For paragraph codes $AFTERWORD eq "<o:p","<O:P","<h2>","<h1>","<b><","<B><","<b s","</h2","</h1\>","</b>","</B>"
    @RECONAFTERWD = ("<o:p","<O:P","<h2>","<h1>","<i><","<I><","<b><","<B><","<b s","</h2","</h1\>","</b>","</B>","</i>","</I>","&lt;","><P>","><p>") ;
  
    # END RECORDING IF AFTERWORD IS "</sp","</SP","<spa","<SPA","</p>","</P>","<st1","</st","<![e"
    @ENDRECORDING = ("</sp","</SP","<spa","<SPA","</p>","</P>","<st1","</st","<![e","<p c") ;
  
    # END RECORDING IF WORD IS "><b "
    @ENDRECONWORD = ("><b ") ;
  
    $RECORDONWORD = join ("&&&",@RECORDONWORD) ;
    $RECONAFTERWD = join ("&&&",@RECONAFTERWD) ;
    $ENDRECORDING = join ("&&&",@ENDRECORDING) ;
    $ENDRECONWORD = join ("&&&",@ENDRECONWORD) ;
  
    $RECORDONWORD = "&&&".$RECORDONWORD."&&&" ;
    $RECONAFTERWD = "&&&".$RECONAFTERWD."&&&" ;
    $ENDRECORDING = "&&&".$ENDRECORDING."&&&" ;
    $ENDRECONWORD = "&&&".$ENDRECONWORD."&&&" ;
  
    $StartTime = `time /T`;
  
    open (RECORDFILE, ">recording") || die "recording file cannot be opened. ($!)\n"; 
    for ($NR = 0; $NR < $NROFCHARS; $NR++) {
  
      if ($RECORD eq "yes" && $ALLCHARS[$NR] ne "\n" )
      {
         print RECORDFILE $ALLCHARS[$NR] ;
         #$RECORDEDCHARS = $RECORDEDCHARS . $ALLCHARS[$NR] ;
      }
      
      $AFTERWORD = "&&&".$ALLCHARS[$NR+1].$ALLCHARS[$NR+2].$ALLCHARS[$NR+3].$ALLCHARS[$NR+4]."&&&";
      $WORD = "&&&".$ALLCHARS[$NR-3].$ALLCHARS[$NR-2].$ALLCHARS[$NR-1].$ALLCHARS[$NR]."&&&";
  
      $where = index($RECORDONWORD,$WORD);
      if ( $where >= 0 )
      {
        $RECORD = "yes" ;
      }
  
      $where = index($RECONAFTERWD,$AFTERWORD);
      if ( $where >= 0 )
      {
        $RECORD = "yes" ;
      }
  
      $where = index($ENDRECORDING,$AFTERWORD);
      if ( $where >= 0 )
      {
        $RECORD = "no" ;
      }
  
      $where = index($ENDRECONWORD,$WORD);
      if ( $where >= 0 )
      {
        $RECORD = "no" ;
      }
    }
    close (RECORDFILE) ;
  
    #print "Started First Process $StartTime" ;
    $CurrentTime = `time /T`;
    #print "Finishd First Process $CurrentTime" ;
  
    open (FILE, "recording") || die "recording file cannot be found. ($!)\n";
    @RECORDEDCHARS = <FILE>;
    close (FILE);
    $RECORDEDCHARS = join("",@RECORDEDCHARS);
    #print $RECORDEDCHARS;
  
    # substitute "<h2>","<h1>" for <B>
    $RECORDEDCHARS =~ s/\<h2\>/\<B\>/g;
    $RECORDEDCHARS =~ s/\<h1\>/\<B\>/g;
  
    # substitute "</h2","</h1>" for </B>
    $RECORDEDCHARS =~ s/\<\/h2\>/\<\/B\>/g ;
    $RECORDEDCHARS =~ s/\<\/h1\>/\<\/B\>/g ;
  
    # substitute "o:p>" for same plus enters
    $RECORDEDCHARS =~ s/\<\/o\:p\>/\<\/o\:p\>\n\n/g ;
  
    # add spaces to breaks
    $RECORDEDCHARS =~ s/<BR>/ <BR> /g;
    #$RECORDEDCHARS =~ s/\-/ \- /g;
    $RECORDEDCHARS =~ s/\: / \: /g;
    $RECORDEDCHARS =~ s/\;\; /\; \; /g;
    $RECORDEDCHARS =~ s/\, / \, /g;
    $RECORDEDCHARS =~ s/\. / \. /g;
    $RECORDEDCHARS =~ s/\! / \! /g;
    $RECORDEDCHARS =~ s/\? / \? /g;
    $RECORDEDCHARS =~ s/\" / \" /g;
    #$RECORDEDCHARS =~ s/\¡/\¡ /g;
    $RECORDEDCHARS =~ s/<I>/ <I> /g;
    $RECORDEDCHARS =~ s/<\/I>/ <\/I> /g;
  
    #ff teveel aan enters prunen
    $RECORDEDCHARS =~ s/\n\n\n/\n\n/g;
  
    # THE PART ABOVE OF THIS SCRIPT FORMATS THE TEXT INTO READABLE AND INSERTABLE TEXT
    # WE ARE READY NOW FOR THE NEXT STEP: FORMAT THE RIGHT TEXTS (ORG, TRAN1 and TRAN2) INTO COMMENTS
  
    # FIRST LETS SET DOWN THE BASE MAPPINGS FOR COMMENT REFERENCE AND COMMENT TEXT AND OTHER HTML OBJECTS
  
    # end of text object
    $ETOBJ = "" ;
    $ETOBJ = $ETOBJ."<!-- TEXT END OBJECT -->\n" ;
    $ETOBJ = $ETOBJ."</P>\n" ;
  
    # table start object
    $TSOBJ = "<BR>" ;
  
    # table start object
    $TEOBJ = "" ;
  
    $SPOBJ = "<#L><!-- PARAGRAPH -->";
  
    $SMOBJ = "<#L>";
  
    # comment reference
    $CROBJ = "<!--<<<PGCR>>>-->¶K<<<CRNR>>>¶L§<<<CRNR>>>§DO_REFRESH¶M<<<CRNR>>>¶N<<<CRNR>>>¶O<<<CRNR>>>¶P<<<COMMENTREFERENCE>>>";
  
    if ($SPEFO eq "INTERLINEAR") {
      if ($TRACING eq "ON") {
        print "printing interlinear version\n";
      } else { print ".";}
        if ($APPOn ne "yes") {
          $PDFOBJ = "<span class='text'><span class='main'><<<COMMENTREFERENCE>>></span><span class='int'><<<COMMENTTEXT>>></span></span>";
        } else {
          $PDFOBJ = "<!--<<<PGCR>>>--><span class='text'><span id='a<<<CRNR>>>' onmouseover=¶Ka<<<CRNR>>>¶Lc<<<CRNR>>>¶Monmouseout=\"Hide¶O<<<CRNR>>>')\" class='main'><<<COMMENTREFERENCE>>></span><span class='int' id='c<<<CRNR>>>'><<<COMMENTTEXT>>></span></span>";
        }
    } else {
      # this is for 'pop-up' pdf's but only works with certain pdf creators that can handle links...
      $PDFOBJ = "<a href='https://www.learn-to-read-foreign-languages.com/products/".$LCLanguage."-fairytales' title='<<<COMMENTTEXT>>>' target='_blank'><<<COMMENTREFERENCE>>></a>";
    }
  
   # }$AddCSVFile = "yes" then later remove <span class='text'><span class='main'><<<COMMENTREFERENCE>>></span><span class='interlinear'><<<COMMENTTEXT>>></span></span>"
  
  
    $CTOBJ = "¶Q<<<CRNR>>>><<<COMMENTTEXT>>>¶R";
  
    $LIOBJ = "" ;
  
    # TEN LANGEN LESTE
    # MAKEN WE EEN RECORD MET DE BASIS HTML ERIN...
    open (TEMPLATE, $Template) || die "file $Template is niet te vinden. ($!)\n";
  
    @INHOUDTEMPLATE = <TEMPLATE>;
    close (TEMPLATE);
    #print "@INHOUDTEMPLATE"; 
  
    $INHOUDTEMPLATE = "@INHOUDTEMPLATE";
  
  
    # NOW WE CAN START CYCLING THROUGH THE ORG, TRAN1 AND TRAN2 AND CREATE SOME NICE COMMENTS
    # SPLIT $RECORDEDCHARS ON ORG, BAS1, BAS2, TRAN1 AND TRAN2
  
    @RECORDEDCHARS = split (/&lt;ORG&gt;|&lt;BAS1&gt;|&lt;BAS2&gt;|&lt;TRAN1&gt;|&lt;TRAN2&gt;|&lt;TRAN3&gt;|&lt;TRAN4&gt;|&lt;TRAN5&gt;|&lt;TRAN6&gt;/,$RECORDEDCHARS) ;
  
    #print "\nRECORD 1 - HEADER \n " ;
    $HEADER = $RECORDEDCHARS[0];
    #print $HEADER;
  
    #print "\nRECORD 2 - ORG \n " ;
    $ORG = $RECORDEDCHARS[1];
    #print $ORG;
  
    #print "\nRECORD 3 - BAS1 \n " ;
    $BAS1 = $RECORDEDCHARS[2];
  
    #print "\nRECORD 4 - BAS2 \n " ;
    $BAS2 = $RECORDEDCHARS[3];
    #print $BAS2;
  
    #print "\nRECORD 5 - TRAN1 \n " ;
    $TRAN1 = $RECORDEDCHARS[4];
    #print $TRAN1;
    $TRAN1 =~ s/\-/&#8209;/g;		# avoid that it fucks up on dash characters if they seem part of impossible range, for example "n-&" or "n- "
  
    #print "\nRECORD 6 - TRAN2 \n " ;
    $TRAN2 = $RECORDEDCHARS[5];
    #print $TRAN2;
    $TRAN2 =~ s/\-/&#8209;/g;		# avoid that it fucks up on dash characters if they seem part of impossible range, for example "n-&" or "n- "
  
    #print "\nRECORD 7 - TRAN3 \n " ;
    $TRAN3 = $RECORDEDCHARS[6];
    #print $TRAN3;
    $TRAN3 =~ s/\-/&#8209;/g;		# avoid that it fucks up on dash characters if they seem part of impossible range, for example "n-&" or "n- "
  
    #print "\nRECORD 8 - TRAN4 \n " ;
    $TRAN4 = $RECORDEDCHARS[7];
    #print $TRAN4;
    $TRAN4 =~ s/\-/&#8209;/g;		# avoid that it fucks up on dash characters if they seem part of impossible range, for example "n-&" or "n- "
  
    #print "\nRECORD 9 - TRAN5 \n " ;
    $TRAN5 = $RECORDEDCHARS[8];
    #print $TRAN5;
    $TRAN5 =~ s/\-/&#8209;/g;		# avoid that it fucks up on dash characters if they seem part of impossible range, for example "n-&" or "n- "
  
    #print "\nRECORD 10 - TRAN6 \n " ;
    $TRAN6 = $RECORDEDCHARS[9];
    #print $TRAN6;
    $TRAN6 =~ s/\-/&#8209;/g;		# avoid that it fucks up on dash characters if they seem part of impossible range, for example "n-&" or "n- "
  
    # ALLE TEKSTEN (ORG, BAS1, BAS2, TRAN1, TRAN2, etc) ZIJN NU IN APARTE RECORDS GESTOPT.
    # WIJ GEBRUIKEN ALLEEN RECORDS 2 (ORG) en 3 (BAS1)
    # EVENTUEEL 4 (BAS2) IN HET GEVAL VAN NON-LATIN CHARACTER SET
    # EN EEN VAN DE VERTALINGSRECORDS 5 (TRAN1), 6 (TRAN2), 7 (TRAN3), 8 (TRAN4), of 9 (TRAN5)
  
    # VAN DE RECORD VARIABELEN WORDEN ARRAYS GEMAAKT
    # DE ARRAY VAN BAS1 WORDT GEBRUIKT OM BIJ TE HOUDEN WAAR WE ZIJN IN DE HOOFDTEKST (ORG)
    # DE HOOFDTEKST (ORG) WORDT GEBRUIKT VOOR DE OPMAAK
  
    # DE BAS1, TRAN1, TRAN2, TRAN3 en TRAN4 SPLITTEN WE OP =
    # ( DE VERTALINGSSPLIT  :..._ MOET WEER ZIJN TERUGGEWIJZIGD IN = )
    # DOOR BAS1 LOPEN WE WEIL WE DE INDEX BIJ HOUDEN
    # PER RECORD IN ARRAY BAS1 VOEGEN WE VOOR DAT RECORD IN DE HOOFDTEKST EEN COMMENT TOE
    # INDIEN GEEN PUNT OF HTMLCODE (IN DAT GEVAL WAT ANDERS TOEVOEGEN)
  
    # split the array on = sign
    @BAS1 = split (/=/, $BAS1 ) ;
    @BAS2 = split (/=/, $BAS2 ) ;
    @TRAN1 = split (/=/, $TRAN1 ) ;
    @TRAN2 = split (/=/, $TRAN2 ) ;
    @TRAN3 = split (/=/, $TRAN3 ) ;
    @TRAN4 = split (/=/, $TRAN4 ) ;
    @TRAN5 = split (/=/, $TRAN5 ) ;
    @TRAN6 = split (/=/, $TRAN6 ) ;
  
    # we dont need the first and last records in the array
    shift @BAS1;
    shift @BAS2;
    shift @TRAN1;
    shift @TRAN2;
    shift @TRAN3;
    shift @TRAN4;
    shift @TRAN5;
    shift @TRAN6;
  
    # ALL THIS REVOLVES AROUND ORG, FIRST WE ADD BEGIN TEXT OBJECT TO FUTURE COPY OF ORG (NEWTEXT)
    # FOR ANY TEXT THAT DOESN'T NEED COMMENTING
    $NEWTEXT = "" ;
  
    # WE CYCLE THROUGH BAS1
    $StartTime = `time /T`;
  
    $counter = 0 ;
  
    $SOUNDPART = "";
  
    if ($AddCSVFile eq "yes" && $FlowingEnglish eq "yes") {
      $ORIGINALPARTCSVSAVEDUPFORPRINTING = "";
      open (CSVTEXT, ">$CSVFile") || die "csvtext file cannot be opened. ($!)\n";
    }
  
    open (NEWTEXT, ">newtext") || die "newtext file cannot be opened. ($!)\n";
    foreach $BAS1WORD (@BAS1)
    {
      #print "Now at $BAS1WORD...\n";
      #beautify bas1word
      $BAS1WORD =~ s/^ //g ; #alleen voor of achter, anders kan je geen woorden samentrekken......
                             #of inderdaad met underscore werken?
                             #underscore wordt tegenwoordig gebruikt als temp - opslag!!!
      $BAS1WORD =~ s/ $//g ;
      $BAS1WORD =~ s/\n//g ;
      $BAS1WORD =~ s/_/ /g ;
      $BAS1WORD =~ s/\+/-/g;
      $BAS1WORD =~ s/\://g;
    
      #get and beautify bas2word (optional phonetic)
      $BAS2WORD = $BAS2[$counter] ;
      $BAS2WORD =~ s/ //g ;
      $BAS2WORD =~ s/\n//g ;  
  
      #get and beautify tran1word (english)
      $TRAN1WORD = $TRAN1[$counter] ;
      $TRAN1WORD =~ s/\n//g ;
      $TRAN1WORD =~ s/\+//g ;
      $TRAN1WORD =~ s/\://g ;
      $TRAN1WORD =~ s/^ //g ;
      $TRAN1WORD =~ s/^ //g ;
      $TRAN1WORD =~ s/^ //g ;
      $TRAN1WORD =~ s/ $//g ;
      $TRAN1WORD =~ s/ $//g ;
      $TRAN1WORD =~ s/ $//g ;
      #get and beautify tran2word (dutch)
      $TRAN2WORD = $TRAN2[$counter] ;
      $TRAN2WORD =~ s/\n//g ;
      $TRAN2WORD =~ s/\+//g ;
      $TRAN2WORD =~ s/\://g ;
      $TRAN2WORD =~ s/^ //g ;
      $TRAN2WORD =~ s/^ //g ;
      $TRAN2WORD =~ s/^ //g ;
      $TRAN2WORD =~ s/ $//g ;
      $TRAN2WORD =~ s/ $//g ;
      $TRAN2WORD =~ s/ $//g ;
      #get and beautify tran3word (french)
      $TRAN3WORD = $TRAN3[$counter] ;
      $TRAN3WORD =~ s/\n//g ;
      $TRAN3WORD =~ s/\+//g ;
      $TRAN3WORD =~ s/\://g ;
      $TRAN3WORD =~ s/^ //g ;
      $TRAN3WORD =~ s/^ //g ;
      $TRAN3WORD =~ s/^ //g ;
      $TRAN3WORD =~ s/ $//g ;
      $TRAN3WORD =~ s/ $//g ;
      $TRAN3WORD =~ s/ $//g ;
      #get and beautify tran4word (german)  
      $TRAN4WORD = $TRAN4[$counter] ;
      $TRAN4WORD =~ s/\n//g ;
      $TRAN4WORD =~ s/\+//g ;
      $TRAN4WORD =~ s/\://g ;
      $TRAN4WORD =~ s/^ //g ;
      $TRAN4WORD =~ s/^ //g ;
      $TRAN4WORD =~ s/^ //g ;
      $TRAN4WORD =~ s/ $//g ;
      $TRAN4WORD =~ s/ $//g ;
      $TRAN4WORD =~ s/ $//g ;
      #get and beautify tran5word (spanish)
      $TRAN5WORD = $TRAN5[$counter] ;
      $TRAN5WORD =~ s/\n//g ;
      $TRAN5WORD =~ s/\+//g ;
      $TRAN5WORD =~ s/\://g ;
      $TRAN5WORD =~ s/^ //g ;
      $TRAN5WORD =~ s/^ //g ;
      $TRAN5WORD =~ s/^ //g ;
      $TRAN5WORD =~ s/ $//g ;
      $TRAN5WORD =~ s/ $//g ;
      $TRAN5WORD =~ s/ $//g ;
      #get and beautify tran6word (portuguese)
      $TRAN6WORD = $TRAN6[$counter] ;
      $TRAN6WORD =~ s/\n//g ;
      $TRAN6WORD =~ s/\+//g ;
      $TRAN6WORD =~ s/\://g ;
      $TRAN6WORD =~ s/^ //g ;
      $TRAN6WORD =~ s/^ //g ;
      $TRAN6WORD =~ s/^ //g ;
      $TRAN6WORD =~ s/ $//g ;
      $TRAN6WORD =~ s/ $//g ;
      $TRAN6WORD =~ s/ $//g ;
  
      #debug some specific meaning
      #if ($TRAN2WORD =~ "is expect") { print $TRAN2WORD; }
  
      #build template for new word part
      if ($PDFOn ne "yes") {
        $NEWPART = $CROBJ.$CTOBJ ;
      } else {
        $NEWPART = "<NOBR>".$PDFOBJ ;
        print ".";
      }
  
      $QUOTESCHARS = "\\".$QC1."\\".$QC2."\\".$QC3;
  
      # changing spaces in &nbsp; for BAS2WORD
      $BAS2WORDF = $BAS2WORD;
      $BAS2WORDF =~ s/ /&nbsp;/g ;
      $BAS2WORDFWITHOUTWEIRDCHARS = $BAS2WORDF ;
      $BAS2WORDFWITHOUTWEIRDCHARS =~ s/[$QUOTESCHARS]/&#39;/g ;
      #print $BAS2WORDFWITHOUTWEIRDCHARS;
  
      # changing spaces in &nbsp; for TRAN1WORD
      $TRAN1WORDF = $TRAN1WORD;
      $TRAN1WORDF =~ s/ /&nbsp;/g ;
      $TRAN1WORDFWITHOUTWEIRDCHARS = $TRAN1WORDF ;
      $TRAN1WORDFWITHOUTWEIRDCHARS =~ s/[$QUOTESCHARS]/&#39;/g ;
      if ( ( $Language eq "Russian" || $Language eq "Georgian" ) && $PDFOn ne "yes" )
      {
         $TRAN1WORDF = $TRAN1WORDF."&nbsp;&#123;".$BAS2WORDFWITHOUTWEIRDCHARS."&#125;&nbsp;";
      }
    
      # changing spaces in &nbsp; for TRAN2WORD
      $TRAN2WORDF = $TRAN2WORD;
      $TRAN2WORDF =~ s/ /&nbsp;/g ;
      $TRAN2WORDFWITHOUTWEIRDCHARS = $TRAN2WORDF ;
      $TRAN2WORDFWITHOUTWEIRDCHARS =~ s/[$QUOTESCHARS]/&#39;/g ;
      if ( ( $Language eq "Russian" || $Language eq "Georgian" ) && $PDFOn ne "yes" )
      {
         $TRAN2WORDF = $TRAN2WORDF."&nbsp;&#123;".$BAS2WORDFWITHOUTWEIRDCHARS."&#125;&nbsp;";
      }
    
      # changing spaces in &nbsp; for TRAN3WORD
      $TRAN3WORDF = $TRAN3WORD;
      $TRAN3WORDF =~ s/ /&nbsp;/g ;
      $TRAN3WORDFWITHOUTWEIRDCHARS = $TRAN3WORDF ;
      $TRAN3WORDFWITHOUTWEIRDCHARS =~ s/[$QUOTESCHARS]/&#39;/g ;
    
      # changing spaces in &nbsp; for TRAN4WORD
      $TRAN4WORDF = $TRAN4WORD;
      $TRAN4WORDF =~ s/ /&nbsp;/g ;
      $TRAN4WORDFWITHOUTWEIRDCHARS = $TRAN4WORDF ;
      $TRAN4WORDFWITHOUTWEIRDCHARS =~ s/[$QUOTESCHARS]/&#39;/g ;
    
      # changing spaces in &nbsp; for TRAN5WORD
      $TRAN5WORDF = $TRAN5WORD;
      $TRAN5WORDF =~ s/ /&nbsp;/g ;
      $TRAN5WORDFWITHOUTWEIRDCHARS = $TRAN5WORDF ;
      $TRAN5WORDFWITHOUTWEIRDCHARS =~ s/[$QUOTESCHARS]/&#39;/g ;
      
      # changing spaces in &nbsp; for TRAN6WORD
      $TRAN6WORDF = $TRAN6WORD;
      $TRAN6WORDF =~ s/ /&nbsp;/g ;
      $TRAN6WORDFWITHOUTWEIRDCHARS = $TRAN6WORDF ;
      $TRAN6WORDFWITHOUTWEIRDCHARS =~ s/[$QUOTESCHARS]/&#39;/g ;
  
      #PARSING
      # parsing objects for BAS1...
      if ($BAS1WORD =~ " "  && $PDFOn ne "yes") {
        $NEWPART =~ s/<<<COMMENTREFERENCE>>>/\<NOBR\>$BAS1WORD\<\/NOBR\>/g ;
      } else {
        $NEWPART =~ s/<<<COMMENTREFERENCE>>>/$BAS1WORD/g ;
      }
      $BAS1WORDWITHOUTWEIRDCHARS = $BAS1WORD ;
      $BAS1WORDWITHOUTWEIRDCHARS =~ s/[$QUOTESCHARS]/&#39;/g ;
      $NEWPART =~ s/<<<COMMENTREFERENCEWITHOUTWEIRDCHARS>>>/$BAS1WORDWITHOUTWEIRDCHARS/g ;
    
      # Add translation (TRAN1 to 6) depending on target language  
      if ($TranTo eq "TRAN1")
      {
        $NEWPART =~ s/<<<COMMENTTEXT>>>/$TRAN1WORDF/g ;
        $NEWPART =~ s/<<<COMMENTTEXTWITHOUTWEIRDCHARS>>>/$TRAN1WORDFWITHOUTWEIRDCHARS/g ;
        $TRANWORD = $TRAN1WORDFWITHOUTWEIRDCHARS ;
      }
      if ($TranTo eq "TRAN2")
      {
        $NEWPART =~ s/<<<COMMENTTEXT>>>/$TRAN2WORDF/g ;
        $NEWPART =~ s/<<<COMMENTTEXTWITHOUTWEIRDCHARS>>>/$TRAN2WORDFWITHOUTWEIRDCHARS/g ;
        $TRANWORD = $TRAN2WORDFWITHOUTWEIRDCHARS ;
      }
      if ($TranTo eq "TRAN3")
      {
        $NEWPART =~ s/<<<COMMENTTEXT>>>/$TRAN3WORDF/g ;
        $NEWPART =~ s/<<<COMMENTTEXTWITHOUTWEIRDCHARS>>>/$TRAN3WORDFWITHOUTWEIRDCHARS/g ;
        $TRANWORD = $TRAN3WORDFWITHOUTWEIRDCHARS ;
      }
      if ($TranTo eq "TRAN4")
      {
        $NEWPART =~ s/<<<COMMENTTEXT>>>/$TRAN4WORDF/g ;
        $NEWPART =~ s/<<<COMMENTTEXTWITHOUTWEIRDCHARS>>>/$TRAN4WORDFWITHOUTWEIRDCHARS/g ;
        $TRANWORD = $TRAN4WORDFWITHOUTWEIRDCHARS ;
      }
      if ($TranTo eq "TRAN5")
      {
        $NEWPART =~ s/<<<COMMENTTEXT>>>/$TRAN5WORDF/g ;
        $NEWPART =~ s/<<<COMMENTTEXTWITHOUTWEIRDCHARS>>>/$TRAN5WORDFWITHOUTWEIRDCHARS/g ;
        $TRANWORD = $TRAN5WORDFWITHOUTWEIRDCHARS ;
      }
      if ($TranTo eq "TRAN6")
      {
        $NEWPART =~ s/<<<COMMENTTEXT>>>/$TRAN6WORDF/g ;
        $NEWPART =~ s/<<<COMMENTTEXTWITHOUTWEIRDCHARS>>>/$TRAN6WORDFWITHOUTWEIRDCHARS/g ;
        $TRANWORD = $TRAN6WORDFWITHOUTWEIRDCHARS ;
      }
      # if Create English Base Dictionary is ON
      if ($DICCWORDON eq "YES" && $DICCWORDLANGUAGE eq "English")
      {
        $DICCWORD = $TRAN1WORDFWITHOUTWEIRDCHARS ; # get base english dictionary words also
      }
    
      if ($DICCWORDON eq "YES" && $DICCWORDLANGUAGE eq "Dutch")
      {
        $DICCWORD = $TRAN2WORDFWITHOUTWEIRDCHARS ; # get base dutch dictionary words also
      }
  
      $NEWPART =~ s/<<<PGCR>>>/<<<IDPAGE>>>\_$ChapterCounter\_$counter/g ;
      $NEWPART =~ s/<<<CRNR>>>/$ChapterCounter\_$counter/g ;
  
      # FOR PDF INTERLINEAR CHOOSE BETWEEN LITERAL OR MORE READABLE, OR TRY TO KEEP BOTH (PHILOSOPHY)
      if ($PDFOn eq "yes") {
     
        #if ($NEWPART =~ m/water/i) { print "NEWPART is ".$NEWPART." and TRANWORDEDITED is ".$TRANWORDEDITED." and TRANWORD is ".$TRANWORD; }
      	
        $TRANWORDEDITED = $TRANWORD;
        # if meaning starts with "(", change to "#" temporarily so extra enter doesn't influence it
        if ($TRANWORD =~ m/^\(/) {
          #if ( $TRANWORD =~ "that" || $TRANWORD =~ "overwent" || $TRANWORD =~ "the" ) { print "TRANWORD IS ".$TRANWORD."\n"; }
          $NEWPART =~ s/\(/\#haakjeopenen\#/;
          $NEWPART =~ s/\)/\#haakjesluiten\#/;
          $TRANWORDEDITED =~ s/\(/\#haakjeopenen\#/;
          $TRANWORDEDITED =~ s/\)/\#haakjesluiten\#/;
        }
        $NEWPART =~ s/\'/#appelstrofje#/g;
        $NEWPART =~ s/\&\#369\;/#achteltje#/g;
        $TRANWORDEDITED =~ s/\&\#39\;/#appelstrofje#/g;
        $TRANWORDEDITED =~ s/\&\#369\;/#achteltje#/g;
      }
      
      # for {root-root; engroot-engroot} stuff, if pdf, cut out original language bit and move to front and nice english to (back), unless compound verb 
      if ($PDFOn eq "yes" && $TRANWORD =~ m/\{/) {
         ($CHECKPREMESS,$CHECKPOSTMESS) = split(/\{/,$TRANWORD);
         if ($CHECKPREMESS =~ m/\[/) {
           # this contains full sentence as well or something before the root, and since duplication is already done, this is the first or only one
           # so move original language bit to front and remove what was there
           ($PREMESS,$MAINMESS,$POSTMESS) = split (/\[|\]/,$TRANWORD);
           ($PREPOSTMESS,$MAINPOSTMESS,$POSTPOSTMESS) = split (/\{|\}/,$POSTMESS);
           $TRANWORDEDITED = $MAINPOSTMESS."\[".$MAINMESS."\]";
           $NEWPART =~ s/$TRANWORD/$TRANWORDEDITED/;
         } else {
           if ($TRANWORD =~ m/\;\&nbsp\;/) {
             ($PREMESS,$MAINMESS,$POSTMESS) = split(/\{|\}/,$TRANWORD);
             ($UNUSEDBIT,$USEDBIT) = split(/\;\&nbsp\;/,$MAINMESS);
             if ($UNUSEDBIT =~ m/\&nbsp\;| /) {
               # this is compound verb, leave in the back
               $TRANWORDEDITED = $PREMESS."\(".$MAINMESS."\)".$POSTMESS;
               $NEWPART =~ s/$TRANWORD/$TRANWORDEDITED/;
             } else {
               $TRANWORDEDITED = $USEDBIT."\(".$PREMESS."\)".$POSTMESS;
               $NEWPART =~ s/$TRANWORD/$TRANWORDEDITED/;
             }
           } else {
             ($PREMESS,$MAINMESS,$POSTMESS) = split(/\{|\}/,$TRANWORD);
             $TRANWORDEDITED = $PREMESS."\<BR\>\{".$MAINMESS."\}".$POSTMESS;
             $NEWPART =~ s/$TRANWORD/$TRANWORDEDITED/;
           }
         }
      }
      
      
      # TWO ISSUES TO SOLVE:
      
      # A.
      # For pop-up and flash card (both have more space) create separate TRANWORD that in fact adds the full sentence...
      # probably need hash from CRNR to this full sentence entry
      # so add CRNR occurrence in standard word-meaning template
      
      # B.
      # for interlinear spacing issues, need to split up the idiomatic "sentences" and spread them between original words according to space...
      
      # solutions:
      # A. add (CRNR) to meaning entries and CRNR -> full meaning hash entry, then when writing int and pnt remove (CRNR), and for pop-up replace by full meaning from hash entry
      #    replacing may be a hassle, the alternative is to add the TRANWORD or "TRANWORDEDITED" (if it replaced TRANWORD) to a hash as well, and replace all CRNRs either to hash-int-pnt or hash-pop-up (pfff)
      # B. measure length of code and compare to length of original, cut up in x pieces (number of original words), give warning if too long still, add remainder at end
      
      
      
      
  
  
      # for pdfs and whole sentences interlinear stuff, remove original sentence [original sentence; translated sentence]
      if ($PDFOn eq "yes" && $NEWPART =~ m/\[/) {
         ($PREMUCK,$MAINMUCK,$POSTMUCK) = split(/\[|\]/,$NEWPART);
         if ($MAINMUCK =~ m/\;/) {
         	  ($USEDBIT,$UNUSEDBIT) = split(/\;psbn\&\;/,(reverse($MAINMUCK)));
         	  $NEWPART = $PREMUCK."\[".(reverse($USEDBIT))."\]".$POSTMUCK;
         	  $LASTWHOLESENTENCE = reverse($UNUSEDBIT);
         }
         ($PREMUCK,$MAINMUCK,$POSTMUCK) = split(/\[|\]/,$TRANWORDEDITED);
         if ($MAINMUCK =~ m/\;/) {
         	  ($USEDBIT,$UNUSEDBIT) = split(/\;psbn\&\;/,(reverse($MAINMUCK)));
         	  $TRANWORDEDITED = $PREMUCK."\[".(reverse($USEDBIT))."\]".$POSTMUCK;
         }
      }
  
      if ($Language ne "Urdu") { # phucks up phonetics (however these should be moved to phonetics tag anyway!!!)
        # Check length of $TRANWORD, if longer than X characters, insert <BR>
        if ($PDFOn ne "yes") {
          $NEWPART =~ s/\[/\<BR\>\[/g;
          $NEWPART =~ s/\{/\<BR\>\{/g;	# for pdf this one should be removed already and changed to ()
          if (($NEWPART !~ m/\[/) && (length($TRANWORD) > 30)) {
            $NEWPART =~ s/\&nbsp;\(\)/&nbsp;\(\)\<BR\>/g;
            $NEWPART =~ s/\&nbsp;\(/\<BR\>\(/g;
            $NEWPART =~ s/\,\&nbsp;/\,\<BR\>/g; # I don't think we want comma's down there :-)
          }
          if (($NEWPART =~ m/\[/) && length($TRANWORD) > 30) {
            $NEWPART =~ s/\;\&nbsp\;/\;\<BR\>\&nbsp\;/g;
          }
        }
        if ($PDFOn eq "yes") {
          # place return UNLESS already one there for [
          if ($NEWPART =~ m/\(/ && $TRANWORDEDITED !~ m/\<BR\>/) {
        	  $NEWPART =~ s/\(/\<BR\>\(/;
            $TRANWORDEDITED =~ s/\(/\<BR\>\(/g;
          }
          
          # if whole sentence thingy is underway, in case of flowingenglish, remove tranword
          if ($PDFOn eq "yes" && $FlowingEnglish ne "yes") {
            if ($WHOLESENTENCETHINGYUNDERWAY eq "yes") {
              if ($NEWPART =~ m/\[/) {
                $WHOLESENTENCETHINGYUNDERWAY = "no";
              }
            }
            if ($WHOLESENTENCETHINGYUNDERWAY ne "yes") {
              $LASTMAINMESSBAS1WORD = "";
            }
          }
          
          # if whole sentence thingy is underway, IN CASE OF FLOWINGENGLISH, remove tranword
          if ($FlowingEnglish eq "yes") {
            if ($WHOLESENTENCETHINGYUNDERWAY eq "yes") {
              if ($NEWPART =~ m/\[/) {
                $WHOLESENTENCETHINGYUNDERWAY = "no";
              } else {
                $NEWPART =~ s/$TRANWORDEDITED//;
              }
            }
          }
          
          $REMOVEDSECONDOCCURRENCEOFWHOLESENTENCETHINGY = "no";
          # if for pdf, remove same [ ] whole sentence thingies, only need the first one
          if ($NEWPART =~ m/\[/) {
            $TRANWORDEDITEDPEW = $TRANWORDEDITED;
            $TRANWORDEDITEDPEW =~ s/\[/\<BR\>\[/g;
            ($TRANWORDEDITED,$MUCK) = split(/\&nbsp\;\<BR\>/,$TRANWORDEDITEDPEW);
            ($PREMESS,$MAINMESS,$POSTMESS) = split(/\[|\]/,$NEWPART);
            if ($MAINMESS eq $LASTMAINMESS) {
              if ($FlowingEnglish ne "yes") {
                # this is the last part of the [whole sentence], start splitting it up and measuring it
                # get bas1word length and compare to see how much of the [whole sentence] fits here
                @MAINMESSPARTSTMP = @MAINMESSPARTS;
                $BAS1WORDUSED = $BAS1WORD;
                $LENBAS1WORD = length($BAS1WORDUSED);
                @BAS1WORDSPLIT = split(/\&/,$BAS1WORDUSED);
                $BAS1WORDWRDCH = 0;
                $BAS1WORDWRDCH = @BAS1WORDSPLIT - 1;
                if ($Language eq "Russian") {
                  $LENBAS1WORD = $LENBAS1WORD - ($BAS1WORDWRDCH*5.8);
                } else {
                  $LENBAS1WORD = $LENBAS1WORD - ($BAS1WORDWRDCH*4);
                }
                foreach $SMALLLETTER ("-"," ","f","r","i","j","l","t") {
                  if ($BAS1WORD =~ $SMALLLETTER) {
                    $LENBAS1WORD = $LENBAS1WORD - 0.6;
                  }
                }
                # account for standard spaces
                $LENBAS1WORD = $LENBAS1WORD + 2;
                $MESSPART = 1;
                $MAINMESSTAKEN = "";
                $LENMEASUREMESSPART = 0;
                $CHOSENLENMEASUREMESSPART = 0;
                foreach $MAINMESSPART (@MAINMESSPARTSTMP) {
                  $MEASUREMESSPART = $MAINMESSPART;
                  $MEASUREMESSPART =~ s/\<BR\>//;
                  $MEASUREMESSPART =~ s/\&nbsp\;/ /g;
                  $MEASUREMESSPART =~ s/\&\#8209\;/\-/g;
                  $MEASUREMESSPART =~ s/\&\#39\;/\'/g;
                  $MEASUREMESSPARTADD =~ s/\<MINISPACEBLOCK\>/ /g;
                  $MEASUREMESSPART =~ s/\<REMSPC\_\_\_\>//g;
                  $MEASUREMESSPART =~ s/\<REMSPC\_\_\>//g;
                  $MEASUREMESSPART =~ s/\<REMSPC\_\>//g;
                  $MEASUREMESSPART = $MEASUREMESSPART.$MEASUREMESSPARTADD;
                  $LENMEASUREMESSPART = $LENMEASUREMESSPART + length($MEASUREMESSPART);
                  foreach $SMALLLETTER ("-"," ","f","r","i","j","l","t") {
                    if ($MEASUREMESSPART =~ $SMALLLETTER) {
                      $LENMEASUREMESSPART = $LENMEASUREMESSPART - 0.4;
                    }
                  }
                  $CHOSENLENMEASUREMESSPART = $LENMEASUREMESSPART;
                  $MAINMESSTAKEN = $MAINMESSTAKEN."&nbsp;".$MAINMESSPART;
                  shift(@MAINMESSPARTS);
                  $MESSPART = $MESSPART + 1;
                }
      	        #$NEWPART = $PREMESS.$POSTMESS;
                # place following part of [whole sentence] instead of the whole sentence for int and pnt uses and the [whole sentence] for pop-up uses
      	      	if ($FINISHEDWITHMESSPARTS eq "NO") {
                  $NEWPART = $PREMESS."\<br\>\<span class\=\'intmess\' id\=\'iend$ChapterCounter\_$counter\'\>".$MAINMESSTAKEN."]\<\/span\>\<span class\=\'popmess\'\>\[".$LASTWHOLESENTENCE.";<BR>".$LASTMAINMESS."\]\<\/span\>".$POSTMESS;
                  $TRANWORDEDITED = $TRANWORDEDITED."\&nbsp\;\<br\>".$MAINMESSTAKEN."]";
                } else {
                  $NEWPART = $PREMESS."\<br\>\<span class\=\'intmess\' id\=\'iend$ChapterCounter\_$counter\'\>&nbsp;&nbsp;&nbsp;]\<\/span\>\<span class\=\'popmess\'\>\[".$LASTWHOLESENTENCE.";<BR>".$LASTMAINMESS."\]\<\/span\>".$POSTMESS;
                }
                $FINISHEDWITHMESSPARTS = "YES";
                $THISWASLASTONEOFSPLATLINE = "YES";
                $LASTMAINMESS = "";
              } else {
                $PREMUCK = "";
                $MAINMUCK = "";
                $POSTMUCK = "";
                ($PREMUCK,$MAINMUCK,$POSTMUCK) = split(/\<BR\>\[|\]/,$TRANWORDEDITED);
                $TRANWORDOLD = $PREMUCK."\[".$MAINMUCK."\]".$POSTMUCK;
                $NEWPART =~ s/\>$PREMUCK\[$MAINMUCK\]$POSTMUCK/\>\&nbsp\;/;
                $NEWPART =~ s/\>$PREMUCK/\>\&nbsp\;/;
                $TRANWORDEDITED = "";
              }
      	      # this is the last occurrence of [ so for the last word of [sentence]
      	      $LASTMAINMESSBAS1WORD = $LASTMAINMESSBAS1WORD.$BAS1WORD;
      	      # turn wholesentencethingy off again
      	      #$WHOLESENTENCETHINGYUNDERWAY = "no";
      	      # let aftershit know we removed [shit]
              $REMOVEDSECONDOCCURRENCEOFWHOLESENTENCETHINGY = "yes";
      	    } else {
      	      # this is the first part of the [whole sentence], start splitting it up and measuring it
      	      $FINISHEDWITHMESSPARTS = "NO";
      	      $SETFINISHEDWITHMESSPARTS = "NO";
      	      @MAINMESSPARTS = split(/ |&nbsp;/,$MAINMESS);
      	      @MAINMESSPARTSTMP = @MAINMESSPARTS;
      	      # get bas1word length and compare to see how much of the [whole sentence] fits here
              $BAS1WORDUSED = $BAS1WORD;
              $LENBAS1WORD = length($BAS1WORDUSED);
              @BAS1WORDSPLIT = split(/\&/,$BAS1WORDUSED);
              $BAS1WORDWRDCH = 0;
              $BAS1WORDWRDCH = @BAS1WORDSPLIT - 1;
              if ($Language eq "Russian") {
                $LENBAS1WORD = $LENBAS1WORD - ($BAS1WORDWRDCH*5.8);
              } else {
                $LENBAS1WORD = $LENBAS1WORD - ($BAS1WORDWRDCH*4);
              }
              foreach $SMALLLETTER ("-"," ","f","r","i","j","l","t") {
                if ($BAS1WORD =~ $SMALLLETTER) {
                  $LENBAS1WORD = $LENBAS1WORD - 0.6;
                }
              }
              # account for standard spaces
              $LENBAS1WORD = $LENBAS1WORD + 2;
              $MESSPART = 1;
              $MAINMESSTAKEN = "";
              $LENMEASUREMESSPART = 0;
              $CHOSENLENMEASUREMESSPART = 0;
      	      foreach $MAINMESSPART (@MAINMESSPARTSTMP) {
                $MEASUREMESSPART = $MAINMESSPART;
                $MEASUREMESSPART =~ s/\<BR\>//;
                $MEASUREMESSPART =~ s/\&nbsp\;/ /g;
                $MEASUREMESSPART =~ s/\&\#8209\;/\-/g;
                $MEASUREMESSPART =~ s/\&\#39\;/\'/g;
                $MEASUREMESSPARTADD =~ s/\<MINISPACEBLOCK\>/ /g;
                $MEASUREMESSPART =~ s/\<REMSPC\_\_\_\>//g;
                $MEASUREMESSPART =~ s/\<REMSPC\_\_\>//g;
                $MEASUREMESSPART =~ s/\<REMSPC\_\>//g;
                $MEASUREMESSPART = $MEASUREMESSPART.$MEASUREMESSPARTADD;
                $LENMEASUREMESSPART = $LENMEASUREMESSPART + length($MEASUREMESSPART);
                foreach $SMALLLETTER ("-"," ","f","r","i","j","l","t") {
                  if ($MEASUREMESSPART =~ $SMALLLETTER) {
                    $LENMEASUREMESSPART = $LENMEASUREMESSPART - 0.4;
                  }
                }
                if ($LENMEASUREMESSPART < ($LENBAS1WORD * 1.5) ) {
                  $CHOSENLENMEASUREMESSPART = $LENMEASUREMESSPART;
                  if ($MESSPART == 1 && @MAINMESSPARTSTMP != 1) {
                    $MAINMESSTAKEN = $MAINMESSPART;
                  } else {
                    if ($MESSPART == @MAINMESSPARTSTMP) {
                      $MAINMESSTAKEN = $MAINMESSTAKEN."&nbsp;".$MAINMESSPART;
                      $SETFINISHEDWITHMESSPARTS = "YES";
                    } else {
                      if ($MAINMESSTAKEN eq "") {
                      	$MAINMESSTAKEN = $MAINMESSPART;
                      } else {
                        $MAINMESSTAKEN = $MAINMESSTAKEN."&nbsp;".$MAINMESSPART;
                      }
                    }
                  }
                  shift(@MAINMESSPARTS);
                } else {
                  if ($CHOSENLENMEASUREMESSPART == 0) {
                    $CHOSENLENMEASUREMESSPART = $LENMEASUREMESSPART ;
                  }
                  # skip, if none added, add this one
                  if ($MESSPART == 1 ) {
                    if (@MAINMESSPARTSTMP == 1) {
                      $MAINMESSTAKEN = $MAINMESSTAKEN."&nbsp;".$MAINMESSPART;
                      $SETFINISHEDWITHMESSPARTS = "YES";
                    } else {
                      $MAINMESSTAKEN = $MAINMESSPART;
                    }
                    $CHOSENLENMEASUREMESSPART = $LENMEASUREMESSPART;
                    shift(@MAINMESSPARTS);
                  }
                }
                $MESSPART = $MESSPART + 1;
              }
              @RESTOFMESS = @MAINMESSPARTS;
              $LASTMAINMESS = $MAINMESS;
              $ThisIsTheFirstPartOfTheSentence = "yes";
              $WHOLESENTENCETHINGYUNDERWAY = "yes";
      	      if ($FlowingEnglish ne "yes") {
                # place first part of [whole sentence] instead of the whole sentence for int and pnt uses and the [whole sentence] for pop-up uses
                $NEWPART = $PREMESS."\<br\>\<span class\=\'intmess\' id\=\'ibeg$ChapterCounter\_$counter\'\>\[".$MAINMESSTAKEN."\<\/span\>\<span class\=\'popmess\'\>\[".$LASTWHOLESENTENCE.";<BR>".$MAINMESS."\]\<\/span\>".$POSTMESS;
                $TRANWORDEDITED = $TRANWORDEDITED."\&nbsp\;\<br\>".$MAINMESSTAKEN;
                #if ($NEWPART =~ "which") { print "Added $MAINMESSTAKEN in $TRANWORDEDITED!\n"; }
                $lastcounter = $counter;
      	      } else {
      	      	# flowing english, leave alone
                $PREMUCK = "";
                $MAINMUCK = "";
                $POSTMUCK = "";
                ($PREMUCK,$MAINMUCK,$POSTMUCK) = split(/\<BR\>\[|\]/,$TRANWORDEDITED);
                $NEWPART =~ s/$PREMUCK\[$MAINMUCK\]$POSTMUCK/$MAINMUCK/;
                $TRANWORDEDITED = $MAINMUCK;
              }
              if ($SETFINISHEDWITHMESSPARTS eq "YES") {
                $FINISHEDWITHMESSPARTS = "YES";
              }
              $LASTMAINMESSBAS1WORD = $BAS1WORD;
            }
          } else {
            if ($WHOLESENTENCETHINGYUNDERWAY eq "yes") {
              ($PREMESS,$MAINMESS,$POSTMESS) = split(/\<span class\=\'int\' id\=\'c$ChapterCounter\_$counter\'\>|\<\/span\>\<\/span\>/,$NEWPART);
      	      @MAINMESSPARTSTMP = @MAINMESSPARTS;
      	      # get bas1word length and compare to see how much of the [whole sentence] fits here
              $BAS1WORDUSED = $BAS1WORD;
              $LENBAS1WORD = length($BAS1WORDUSED);
              @BAS1WORDSPLIT = split(/\&/,$BAS1WORDUSED);
              $BAS1WORDWRDCH = 0;
              $BAS1WORDWRDCH = @BAS1WORDSPLIT - 1;
              if ($Language eq "Russian") {
                $LENBAS1WORD = $LENBAS1WORD - ($BAS1WORDWRDCH*5.8);
              } else {
                $LENBAS1WORD = $LENBAS1WORD - ($BAS1WORDWRDCH*4);
              }
              foreach $SMALLLETTER ("-"," ","f","r","i","j","l","t") {
                if ($BAS1WORD =~ $SMALLLETTER) {
                  $LENBAS1WORD = $LENBAS1WORD - 0.6;
                }
              }
              # account for standard spaces
              $LENBAS1WORD = $LENBAS1WORD + 2;
              $MESSPART = 1;
              $MAINMESSTAKEN = "";
              $LENMEASUREMESSPART = 0;
              $CHOSENLENMEASUREMESSPART = 0;
      	      foreach $MAINMESSPART (@MAINMESSPARTSTMP) {
                $MEASUREMESSPART = $MAINMESSPART;
                $MEASUREMESSPART =~ s/\<BR\>//;
                $MEASUREMESSPART =~ s/\&nbsp\;/ /g;
                $MEASUREMESSPART =~ s/\&\#8209\;/\-/g;
                $MEASUREMESSPART =~ s/\&\#39\;/\'/g;
                $MEASUREMESSPARTADD =~ s/\<MINISPACEBLOCK\>/ /g;
                $MEASUREMESSPART =~ s/\<REMSPC\_\_\_\>//g;
                $MEASUREMESSPART =~ s/\<REMSPC\_\_\>//g;
                $MEASUREMESSPART =~ s/\<REMSPC\_\>//g;
                $MEASUREMESSPART = $MEASUREMESSPART.$MEASUREMESSPARTADD;
                $LENMEASUREMESSPART = $LENMEASUREMESSPART + length($MEASUREMESSPART);
                foreach $SMALLLETTER ("-"," ","f","r","i","j","l","t") {
                  if ($MEASUREMESSPART =~ $SMALLLETTER) {
                    $LENMEASUREMESSPART = $LENMEASUREMESSPART - 0.4;
                  }
                }
                if ($LENMEASUREMESSPART < ($LENBAS1WORD * 1.5) ) {
                  if ($MESSPART == 1 && @MAINMESSPARTSTMP != 1) {
                    $MAINMESSTAKEN = $MAINMESSPART;
                  } else {
                    if ($MESSPART == @MAINMESSPARTSTMP) {
                      $MAINMESSTAKEN = $MAINMESSTAKEN."&nbsp;".$MAINMESSPART;
                      $SETFINISHEDWITHMESSPARTS = "YES";
                    } else {
                      $MAINMESSTAKEN = $MAINMESSTAKEN."&nbsp;".$MAINMESSPART;
                    }
                  }
                  shift(@MAINMESSPARTS);
                } else {
                  if ($CHOSENLENMEASUREMESSPART == 0) {
                    $CHOSENLENMEASUREMESSPART = $LENMEASUREMESSPART ;
                  }
                  # skip, if none added, add this one
                  if ($MESSPART == 1) {
                    if (@MAINMESSPARTSTMP == 1) {
                      $MAINMESSTAKEN = $MAINMESSPART;
                      $SETFINISHEDWITHMESSPARTS = "YES";
                    } else {
                      $MAINMESSTAKEN = $MAINMESSPART;
                    }
                    shift(@MAINMESSPARTS);
                    $CHOSENLENMEASUREMESSPART = $LENMEASUREMESSPART;
                  }
                }
                $MESSPART = $MESSPART + 1;
              }
              @RESTOFMESS = @MAINMESSPARTS;
      	      if ($FlowingEnglish ne "yes") {
      	      	if ($FINISHEDWITHMESSPARTS eq "NO") {
                  # place following part of [whole sentence] instead of the whole sentence for int and pnt uses and the [whole sentence] for pop-up uses
                  $NEWPART = $PREMESS."\<br\>\<span class\=\'intmess\' id\=\'imid$ChapterCounter\_$counter\'\>".$MAINMESSTAKEN."\<\/span\>\<span class\=\'popmess\'\>\[".$LASTWHOLESENTENCE.";<BR>".$LASTMAINMESS."\]\<\/span\>\<\/span\>\<\/span\>".$POSTMESS;
                  $TRANWORDEDITED = $TRANWORDEDITED."\&nbsp\;\<br\>".$MAINMESSTAKEN;
                } else {
                  $NEWPART = $PREMESS."\<br\>\<span class\=\'popmess\'\>\[".$LASTWHOLESENTENCE.";<BR>".$LASTMAINMESS."\]\<\/span\>\<\/span\>\<\/span\>".$POSTMESS;
                  #print "Adding popmess to $PREMESS...\n" ;
                  $TRANWORDEDITED = $TRANWORDEDITED."\&nbsp\;\<br\>";
                }
                if ($SETFINISHEDWITHMESSPARTS eq "YES") {
                  $FINISHEDWITHMESSPARTS = "YES";
                }
              }
              #$LASTMAINMESSBAS1WORD = $LASTMAINMESSBAS1WORD.$BAS1WORD;
            } else {
              $LASTMAINMESSBAS1WORD = $BAS1WORD;
            }
          }
        }
      }
  
      # here copy any ( ) at the back to the front in case of InterlinearBooks format and forget about what was in front
      if ($PDFOn eq "yes" && $FlowingEnglish eq "yes" && $NEWPART =~ m/\(/ && $NEWPART !~ m/\[/) {
        $PREMUCK = "";
        $MAINMESS = "";
        $POSTMUCK = "";
        ($PREMUCK,$MAINMESS,$POSTMUCK) = split(/\<BR\>\(|\)/,$TRANWORDEDITED);
        $NEWPART =~ s/\>$PREMUCK\<BR\>\($MAINMESS\)$POSTMUCK/\>$MAINMESS/;
        $TRANWORDEDITED = $MAINMESS;
      }
  
      # fix the initial () again (if FlowingEnglish is yes then these have disappeared with contents if other ( ) existed, if not, now is the chance to add them
      if ($PDFOn eq "yes") {
        if ($FlowingEnglish ne "yes") {
          $NEWPART =~ s/\#haakjeopenen\#/\(/;
          $NEWPART =~ s/\#haakjesluiten\#/\)/;
          $TRANWORDEDITED =~ s/\#haakjeopenen\#/\(/;
          $TRANWORDEDITED =~ s/\#haakjesluiten\#/\)/;
        } else {
          $NEWPART =~ s/\#haakjeopenen\#//;
          $NEWPART =~ s/\#haakjesluiten\#//;
          $TRANWORDEDITED =~ s/\#haakjeopenen\#//;
          $TRANWORDEDITED =~ s/\#haakjesluiten\#//;
        }
        $NEWPART =~ s/\#appelstrofje\#/\'/g;
        $NEWPART =~ s/\#achteltje\#/\&\#369\;/g;
        $TRANWORDEDITED =~ s/\#appelstrofje\#/\&\#39\;/g;
        $TRANWORDEDITED =~ s/\#achteltje\#/\&\#369\;/g;
      }
      
  
      # SOUND AND PHONETIC NOTES
      # CREATING PHONETIC LIST PROBABLY IS BEST AFTERWARDS, THIS IS ONLY NECESSARY FOR RUSSIAN, GEORGIAN, POLISH?, HUNGARIAN? and URDU, or make it separate option
      # for prepare script.......
    
      #maybe decrypt or unzip during installation or something or perhaps it is possible to create a dat file,
      #since the wavs aren't that big, do that
  
      # if basword is empty make sure it is not used to find original part
      if ($BAS1WORD eq "") {
         $BAS1WORD = "<empty>" ;
      }
  
      #change specific chars
      if ($BAS1WORD =~ "I>" || $BAS1WORD =~ "B>" || $BAS1WORD =~ "<o:p>" || $BAS1WORD =~ "&quot;" || $BAS1WORD =~ m/[\?\!\,\.\:\(\)\*]/ || $BAS1WORD =~ "--" || $BAS1WORD eq "-" || $BAS1WORD =~ "<BR>" || $BAS1WORD =~ "<br>") {
         $NEWPART = $BAS1WORD ;
         $BAS1WORD = "<empty>" ;
      }
  
      # now we have to get the original text up to and including the current BAS1WORD
      # for this we can use substr $ORG, pos, [lengthofword, replacement]
      # and pos $string (returns position of last character after $)
  
      $POSITION = "empty" ;
  
      #print "Now looking for $BAS1WORD in original text...\n";
      #PROBLEM: Roman I will get picked up by <I> sign
  
      while ( $ORG =~ m/$BAS1WORD/g )
      {
         #fill position with first occurrence of BAS1WORD
         if ($POSITION eq "empty")
         {
            $POSITION = pos $ORG ;
            $CHARBEHINDBASWORD = substr $ORG, $POSITION, 2 ;
            if ($CHARBEHINDBASWORD =~ ">") {
              $CHARBEHINDBASWORD = substr $ORG, ($POSITION-1), 200 ;
              if ($TRACING eq "ON") {
                print "skip, it's probably html code: $CHARBEHINDBASWORD print scheitzooi ";
              } else { print ".";}
              $POSITION = "empty";
              $Guila = "Grootje";
            } else {
              done;
            }
         }
         #print "Matched position $POSITION...\n";
      }
  
      $ORIGINALPART = "" ;
  
      $CHARBEHINDBASWORD = substr $ORG, $POSITION, 1 ;
      $ORIGINALPART = substr $ORG, 0, $POSITION, " " ;
  
  
      #correct characters before and after basword
      if ($CHARBEHINDBASWORD eq "-")
      {     
        $ORIGINALPART =~ s/$BAS1WORD/$NEWPART-/;
      }
      else
      {
        if ($ORIGINALPART =~ "-" && $PDFOn ne "yes")
        {
        	# first place nobreaks around nobreakable word (broken words give weird translation positions outside screen)
          $NOBREAKREPLACE = "<NOBR>".$BAS1WORD."</NOBR>" ;
          $ORIGINALPART =~ s/$BAS1WORD/$NOBREAKREPLACE/ ;
        }
        
        #fill occurrences of BAS1WORD (also htmlmarkers) with original BAS1WORD, however, need to correct htmlmarkers if they were htmlmarkers...  
        $ORIGINALPART =~ s/$BAS1WORD(?!\>)/$NEWPART\&nbsp\; /;
        #$ORIGINALPART =~ s/\&nbsp\; \>/\>/g;
      }
  
  
      if ($Guila eq "Grootje") {
         $Guila = "Nootje";
         if ($TRACING eq "ON") {
           print $ORIGINALPART." tiefus";
         } else { print ".";}
      }
  
      $ORIGINALPART =~ s/- \&nbsp\;/\&nbsp\;-\&nbsp\;/g;
      $ORIGINALPART =~ s/-\&nbsp\;/\&nbsp\;-\&nbsp\;/g;
      $ORIGINALPART =~ s/ \&nbsp\;/\&nbsp\;/g;
      
            
      # nou eens zien
      $URCHYWORD = "which it";
      $URCHYAFTER = "knowever";
      
      if ($PDFOn eq "yes") {
  
        $TRANWORDSPLITADD = "";
        $TRANWORDSPLATADD = "";
      	
        # next space block
        if ($NEXTSPACEBLOCK ne "") {
          # <BR> is used for sentences <br> within meanings
          if ($ORIGINALPART !~ m/\<BR\>  \<BR\>/ && $ORIGINALPART !~ m/<LB>/i) { # avoid adding spaces to first word of sentence
            #if ($TRANWORDEDITED =~ $URCHYAFTER) { print "NSB is $NEXTSPACEBLOCK, there we go!";}
            #print "Dit is het eerste woord NA het lange woord, ik voeg '$NEXTSPACEBLOCK' toe...\n";
            $ORIGINALPART =~ s/\<span class\=\'int\'\>/\<span class\=\'int\'\>$NEXTSPACEBLOCK/;
            $ORIGINALPART =~ s/\<span class\=\'int\' id\=\'c(\w+)\_(\w+)\'\>/\<span class\=\'int\' id\=\'c$1\_$2\'\>$NEXTSPACEBLOCK/;
            #if ($TRANWORDEDITED =~ $URCHYAFTER) { print "ORIGINALPART is now $ORIGINALPART!";}
            # vergeet TRANWORDEDITED niet!
            $TRANWORDSPLITADD = $NEXTSPACEBLOCK;
            $NEXTSPACEBLOCK = "";
          } else {
            $NEXTSPACEBLOCK = "";
          }
        }
      
        # next space second block
        if ($NEXTSPACESECONDBLOCK ne "") {
          #if ($LASTTRANWORDEDITED =~ "which\&nbsp\;it") { print "NSB is $NEXTSPACESECONDBLOCK, there we go! ORIGINALPART is $ORIGINALPART";}
          if ($ORIGINALPART !~ m/\<BR\>  \<BR\>/ && $ORIGINALPART !~ m/<LB>/i && $ORIGINALPART =~ /\<BR\>/i) { # avoid adding spaces to first word of sentence
            #print "Dit is het eerste woord NA het lange woord, ik voeg '$NEXTSPACEBLOCK' toe...\n";
            $ORIGINALPART =~ s/\&nbsp\;\<BR\>/\<BR\>$NEXTSPACESECONDBLOCK/i;
            # sub class intmess for lineparts including a line id so whole line can be made visible
            $ORIGINALPART =~ s/\<br\>\<span class\=\'intmess\' id\=\'i(\w+)\_(\w+)\'\>/\<br\>\<span class\=\'intmess\' id\=\'i$1\_$2\'\>$NEXTSPACESECONDBLOCK/i;
            #if ($TRANWORDEDITED =~ $URCHYAFTER) { print "ORIGINALPART is now $ORIGINALPART!";}
            # vergeet TRANWORDEDITED niet!
            $TRANWORDSPLATADD = $NEXTSPACESECONDBLOCK;
            $NEXTSPACESECONDBLOCK = "";
          } else {
            $NEXTSPACESECONDBLOCK = "";
          }
        }

        $NEXTSPACEBLOCK = "";
        $NEXTSPACESECONDBLOCK = "";
        
        
        # adding space within [ ] should be regulated by code above
        if ($THISWASLASTONEOFSPLATLINE eq "YES") {
          $TRANWORDSPLATADD = "";
          $THISWASLASTONEOFSPLATLINE = "NO";
        }
        
         	
        #if ( $TRANWORDEDITED =~ $SURCHYWORD || $LASTTRANWORD =~ $SURCHYWORD ) { print "TRANWORDEDITED IS ".$TRANWORDEDITED."\n"; }
        
        # get length of tranword first row and second row   ISSUE IS THAT TRANWORDSPLAT NOW SEEMS TO BE THE FULL SENTENCE!!!!
        ($TRANWORDSPLIT,$TRANWORDSPLAT) = split(/\&nbsp\;\<BR\>|\&nbsp\;\<br\>/,$TRANWORDEDITED);
        if ($TRANWORDSPLIT eq $TRANWORDEDITED) {	
          ($TRANWORDSPLIT,$TRANWORDSPLAT) = split(/\<BR\>|\<br\>/,$TRANWORDEDITED);
        }
        #print "splitting ".$TRANWORDEDITED."\n";
        
        $TRANWORDSPLIT =~ s/\<BR\>//;
        $TRANWORDSPLIT =~ s/\<i\>//;
        $TRANWORDSPLIT =~ s/\<\/i\>//;
        $TRANWORDSPLIT =~ s/\&nbsp\;/ /g;
        $TRANWORDSPLIT =~ s/\&\#8209\;/\-/g;
        $TRANWORDSPLIT =~ s/\&\#39\;/\'/g;
        $TRANWORDSPLITADD =~ s/\<MINISPACEBLOCK\>/ /g;
        $TRANWORDSPLIT =~ s/\<REMSPC\_\_\_\>//g;
        $TRANWORDSPLIT =~ s/\<REMSPC\_\_\>//g;
        $TRANWORDSPLIT =~ s/\<REMSPC\_\>//g;
        $TRANWORDSPLIT = $TRANWORDSPLIT.$TRANWORDSPLITADD;
        $LENTRANWORDSPLIT = length($TRANWORDSPLIT);
        foreach $SMALLLETTER ("-"," ","f","r","i","j","l","t") {
          if ( $TRANWORDSPLIT =~ m/$SMALLLETTER/ ) {
            $LENTRANWORDSPLIT = $LENTRANWORDSPLIT - 0.4;
          }
        }
        #print $TRANWORDSPLIT." (".$LENTRANWORDSPLIT.")";
        
        if ($TRANWORDSPLAT =~ m/\;/ && $TRANWORDSPLAT =~ m/\[/ ) {
         	($USEDBIT,$UNUSEDBIT) = split(/\;psbn\&\;/,(reverse($MAINMUCK)));
         	$TRANWORDSPLAT = "\[".(reverse($USEDBIT));
        }
        $TRANWORDSPLAT =~ s/\<BR\>//;
        $TRANWORDSPLAT =~ s/\<i\>//;
        $TRANWORDSPLAT =~ s/\<\/i\>//;
        $TRANWORDSPLAT =~ s/\&nbsp\;/ /g;
        $TRANWORDSPLAT =~ s/\&\#8209\;/\-/g;
        $TRANWORDSPLAT =~ s/\&\#39\;/\'/g;
        $TRANWORDSPLATADD =~ s/\<MINISPACEBLOCK\>/ /g;
        $TRANWORDSPLAT =~ s/\<REMSPC\_\_\_\>//g;
        $TRANWORDSPLAT =~ s/\<REMSPC\_\_\>//g;
        $TRANWORDSPLAT =~ s/\<REMSPC\_\>//g;
        $TRANWORDSPLAT = $TRANWORDSPLAT.$TRANWORDSPLATADD;
        $LENTRANWORDSPLAT = length($TRANWORDSPLAT);
        foreach $SMALLLETTER ("-"," ","f","r","i","j","l","t") {
          if ($TRANWORDSPLAT =~ $SMALLLETTER) {
            $LENTRANWORDSPLAT = $LENTRANWORDSPLAT - 0.4;
          }
        }
        # print $TRANWORDSPLAT." (".$LENTRANWORDSPLAT."); ";
        
       # if ( $TRANWORDSPLAT =~ $SURCHYAFTER || $LASTTRANWORD =~ $SURCHYWORD ) { print "BAS1WORDUSED IS ".$BAS1WORDUSED." AND TRANWORDSPLIT IS ".$TRANWORDSPLIT." and TRANWORDSPLAT IS ".$TRANWORDSPLAT."\n"; }
        
        #if ($LASTMAINMESSBAS1WORD ne "") {
        #  $BAS1WORDUSED = $LASTMAINMESSBAS1WORD;
        #} else {
          $BAS1WORDUSED = $BAS1WORD;
        #}
        $LENBAS1WORD = length($BAS1WORDUSED);
        @BAS1WORDSPLIT = split(/\&/,$BAS1WORDUSED);
        $BAS1WORDWRDCH = 0;
        $BAS1WORDWRDCH = @BAS1WORDSPLIT - 1;
        if ($Language eq "Russian") {
          $LENBAS1WORD = $LENBAS1WORD - ($BAS1WORDWRDCH*5.8);
        } else {
          $LENBAS1WORD = $LENBAS1WORD - ($BAS1WORDWRDCH*4);
        }
        foreach $SMALLLETTER ("-"," ","f","r","i","j","l","t") {
          if ($BAS1WORD =~ $SMALLLETTER) {
            $LENBAS1WORD = $LENBAS1WORD - 0.6;
          }
        }
        # account for standard spaces
        $LENBAS1WORD = $LENBAS1WORD + 2;
        #print $BAS1WORDUSED." (".$LENBAS1WORD.")";
        
        # find new next spaceblock, if any
        #if ( $TRANWORDEDITED =~ "even" ) { print $ORIGINALPART."  lengths $BAS1WORD(".$LENBAS1WORD.") TRANWORDEDITED is $TRANWORDEDITED $TRANWORDSPLIT(".$LENTRANWORDSPLIT.") $TRANWORDSPLAT(".$LENTRANWORDSPLAT.")\n"; }
        
        
        #if ($TRANWORDSPLIT =~ $URCHYWORD) { print "Check if $LENTRANWORDSPLIT > $LENBAS1WORD*1.5 - 1! Add $NUMBEROFEXTRASPACES!"; }
        if ( ($LENTRANWORDSPLIT > 3) && ($LENBAS1WORD < 14) && ($LENTRANWORDSPLIT > ($LENBAS1WORD*1.5) - 1 ) ) {
          $NUMBEROFEXTRASPACES = ( ( $LENTRANWORDSPLIT - ($LENBAS1WORD*1.5) + 2 ) );
          for ($NOUDAARGAANWE = 0; $NOUDAARGAANWE < $NUMBEROFEXTRASPACES ; $NOUDAARGAANWE++) {
             $NEXTSPACEBLOCK = $NEXTSPACEBLOCK."<MINISPACEBLOCK>";
          }
          #if ( $TRANWORDSPLIT =~ $SURCHYWORD || $LASTTRANWORD =~ $SURCHYWORD ) { print "NEXTSPACEBLOCK is ".$NEXTSPACEBLOCK."\n"; }
          #for ($NOUDAARGAANWE = 0; $NOUDAARGAANWE < $NUMBEROFEXTRASPACES-4 ; $NOUDAARGAANWE++) {
          #   $AFTERNEXTSPACEBLOCK = $AFTERNEXTSPACEBLOCK."<MINISPACEBLOCK>";
          #}
        }
        
        # determine next space SECOND interlinear line block, if any
        #if ($TRANWORDEDITED =~ "which\&nbsp\;it") { print "For $TRANWORDEDITED, check if $LENTRANWORDSPLAT > $LENBAS1WORD*1.5 - 1! Add $NUMBEROFEXTRASPACES!"; }
        if ( ($LENTRANWORDSPLAT > 4) && ($LENBAS1WORD < 11) && ($LENTRANWORDSPLAT > ($LENBAS1WORD*1.5) - 1 ) ) {
          $NUMBEROFEXTRASECONDSPACES = ( ( $LENTRANWORDSPLAT - ($LENBAS1WORD*1.5) + 2 ) );
          for ($NOUDAARGAANWE = 0; $NOUDAARGAANWE < ($NUMBEROFEXTRASECONDSPACES) ; $NOUDAARGAANWE++) {
            $NEXTSPACESECONDBLOCK = $NEXTSPACESECONDBLOCK."<MINISPACEBLOCK>";
          }
          #if ( $TRANWORDEDITED =~ "which\&nbsp\;it" ) { print "NEXTSPACESECONDBLOCK is ".$NEXTSPACESECONDBLOCK."\n"; }
          #for ($NOUDAARGAANWE = 0; $NOUDAARGAANWE < ($NUMBEROFEXTRASECONDSPACES-4) ; $NOUDAARGAANWE++) {
          #  $AFTERNEXTSPACESECONDBLOCK = $AFTERNEXTSPACESECONDBLOCK."<MINISPACEBLOCK>";
          #}
        }
        
        #print "NEXTSPACEBLOCK is now $NEXTSPACEBLOCK, AFTERNEXTSPACEBLOCK is now $AFTERNEXTSPACEBLOCK\n"; 
      }
      
      $LASTORIGINALPART = $ORIGINALPART;
      
      # for debugging purposes up the nextspaceblock chain
      $LASTTRANWORDEDITED = $TRANWORDEDITED;
      
  
      # maximaliseren aantal spaties (see final htm, 9 x &nbsp; at length(presence-his) - length(szine)   why ?????  )
      # verdwenen "." opzoeken bij tudhatta
      # shepherds cloak spaties verneuken de komma d'rachter
      # tijdelijk toevoegen "!!!" waar tranword langer is dan basword zodat je kan dubbelchecken of 't gelukt is
      
      
      
      # print for tab csv file
      # }$AddCSVFile = "yes" then later remove <span class='text'><span class='main'><<<COMMENTREFERENCE>>></span><span class='interlinear'><<<COMMENTTEXT>>></span></span>"
      if ($AddCSVFile eq "yes" && $FlowingEnglish eq "yes") {
        $ORIGINALPARTCSV = $ORIGINALPART;
        if ($ORIGINALPART =~ "\#\#\#DUTJES\#\#\#") {
           # contains pictures, wemove
           ($TRASH,$ORIGINALPARTCSV) = split(/\#\#\#DUTJES\#\#\#/,$ORIGINALPART);
        }
        $ORIGINALPARTCSV =~ s/\<\/CENTER\>//g;
        $ORIGINALPARTCSV =~ s/\<span class\=\'text\'\>\<span class\=\'main\'\>//g;
        $ORIGINALPARTCSV =~ s/\<\/span\>\<\/span\>//g;
        $ORIGINALPARTCSV =~ s/\<MINISPACEBLOCK\>//g;
        $ORIGINALPARTCSV =~ s/\<NOBR\>//g;
        $ORIGINALPARTCSV =~ s/\<\/NOBR\>//g;
        $ORIGINALPARTCSV =~ s/\<LB\>/\n/g;
        $ORIGINALPARTCSV =~ s/\<BR\>/\n/g;
        $ORIGINALPARTCSV =~ s/\<B\>//g;
        $ORIGINALPARTCSV =~ s/\<\/B\>//g;
        $ORIGINALPARTCSV =~ s/\&nbsp\;/ /g;
        $ORIGINALPARTCSV =~ s/  / /g;
        $ORIGINALPARTCSV =~ s/^ //g;
        $ORIGINALPARTCSV =~ s/^ //g;
        if ($ThisIsTheFirstPartOfTheSentence eq "yes") {
          $ORIGINALPARTCSVSAVEDUP = $ORIGINALPARTCSV;
          $ORIGINALPARTCSVSAVEDUP =~ s/\<\/span\>\<span class\=\'int\'\>/<SAVEDUPBIT>\t/g;
          $ORIGINALPARTCSV = "";
          $ThisIsTheFirstPartOfTheSentence = "no";
          #print "Saved up part now ".$ORIGINALPARTCSVSAVEDUP."!\n";
        } else {
          if ($WHOLESENTENCETHINGYUNDERWAY eq "yes") {
            # part of an already given sentence in the english part, just add to SAVEDUP bit
            $ORIGINALPARTCSV =~ s/\<\/span\>\<span class\=\'int\'>// ;
            $ORIGINALPARTCSVSAVEDUP =~ s/\<SAVEDUPBIT\>/ $ORIGINALPARTCSV\<SAVEDUPBIT\>/;
            $ORIGINALPARTCSV = "";
            #print "Saved up part now ".$ORIGINALPARTCSVSAVEDUP."!\n";
          } else {
            if ($REMOVEDSECONDOCCURRENCEOFWHOLESENTENCETHINGY ne "yes") {
              $ORIGINALPARTCSV =~ s/\<\/span\>\<span class\=\'int\'\>/\t/g;
            }
          }
        }
        $ORIGINALPARTCSV =~ s/^ //g;
        $ORIGINALPARTCSV =~ s/^ //g;
        if ($ORIGINALPARTCSV ne "" && $REMOVEDSECONDOCCURRENCEOFWHOLESENTENCETHINGY ne "yes") {
          $ORIGINALPARTCSV = $ORIGINALPARTCSV."\n";
          if ($AddCSVFile eq "yes" && $FlowingEnglish eq "yes") {
            $ORIGINALPARTCSVSAVEDUPFORPRINTING = $ORIGINALPARTCSVSAVEDUPFORPRINTING.$ORIGINALPARTCSV;
          }
        }
        if ($REMOVEDSECONDOCCURRENCEOFWHOLESENTENCETHINGY eq "yes") {
          # part of an already given sentence in the english part, just add to SAVEDUP bit
          $ORIGINALPARTCSV =~ s/\<\/span\>\<span class\=\'int\'>// ;
          $ORIGINALPARTCSVSAVEDUP =~ s/\<SAVEDUPBIT\>/ $ORIGINALPARTCSV\<SAVEDUPBIT\>/;
          #print "Saved up part now ".$ORIGINALPARTCSVSAVEDUP."!\n";
          $ORIGINALPARTCSVSAVEDUP =~ s/\<SAVEDUPBIT\>/ /;
          $ORIGINALPARTCSVSAVEDUP =~ s/  / /g;
          $ORIGINALPARTCSVSAVEDUP =~ s/  / /g;
          $ORIGINALPARTCSVSAVEDUP = $ORIGINALPARTCSVSAVEDUP."\n";
          if ($AddCSVFile eq "yes" && $FlowingEnglish eq "yes") {
            $ORIGINALPARTCSVSAVEDUPFORPRINTING = $ORIGINALPARTCSVSAVEDUPFORPRINTING.$ORIGINALPARTCSVSAVEDUP;
          }
        }
      }
      
  
      print NEWTEXT $ORIGINALPART ;
     
      # FILL DATABASE
      #get original base word
      $ORIBAS1WORD = $BAS1WORD;
  
      #change special chars to UNICODE
      #change cyrillic chars for UNICODE chars 
      if ($Language eq "Russian")
      {
        for ($charnr = 192 ; $charnr < 256 ; $charnr++)
        {
          $charch = chr($charnr);
          $newcharnr = $charnr + 848 ;
          $ORIBAS1WORD =~ s/$charch/\&\#$newcharnr\;/g;
          $TRANWORD =~ s/$charch/\&\#$newcharnr\;/g;
        }
      }
      if ($Language eq "Swedish" || $Language eq "German")
      {
        $BaseSwCh = chr(195);
        $LargeAOp = chr(133);
        $SmallAOp = chr(165);
        $LargeAUp = chr(132);
        $SmallAUp = chr(164);
        $LargeOUp = chr(150);
        $SmallOUp = chr(182);
        $LargeAO = $BaseSwCh.$LargeAOp;
        $SmallAO = $BaseSwCh.$SmallAOp;
        $LargeAU = $BaseSwCh.$LargeAUp;
        $SmallAU = $BaseSwCh.$SmallAUp;
        $LargeOU = $BaseSwCh.$LargeOUp;
        $SmallOU = $BaseSwCh.$SmallOUp;
        $ORIBAS1WORD =~ s/$LargeAO/&#197;/g;
        $ORIBAS1WORD =~ s/$SmallAO/&#229;/g;
        $ORIBAS1WORD =~ s/$LargeAU/&#196;/g;
        $ORIBAS1WORD =~ s/$SmallAU/&#228;/g;
        $ORIBAS1WORD =~ s/$LargeOU/&#214;/g;
        $ORIBAS1WORD =~ s/$SmallOU/&#246;/g;
        $TRANWORD =~ s/$LargeAO/&#197;/g;
        $TRANWORD =~ s/$SmallAO/&#229;/g;
        $TRANWORD =~ s/$LargeAU/&#196;/g;
        $TRANWORD =~ s/$SmallAU/&#228;/g;
        $TRANWORD =~ s/$LargeOU/&#214;/g;
        $TRANWORD =~ s/$SmallOU/&#246;/g;
      }
  
      # ADD CODE TO TRANWORD TBV CLK DEL VB PRINCIPE
      if ($TRANWORD ne "") {
        $TRANWORD = $TRANWORD."*".$ChapterCounter."-".$counter."*";
        
        if ($Language eq "Georgian" || $Language eq "Russian") {
          $TRANWORD = $TRANWORD."\{".$BAS2WORDFWITHOUTWEIRDCHARS."\}";
        }
      }
    
      #Change uppercase to lowercase
      #if other than russian (do Russian via unicodes, and Urdu doesn't have upper-lowercase difference)
      if ($Language ne "Russian" && $Language ne "Urdu")
      {
        $KEYBAS1WORD = lc($ORIBAS1WORD) ;
      }
      else
      {
        if ($Language eq "Russian") {
          $KEYBAS1WORD = $ORIBAS1WORD ;
          #change uppercase (unicode 1040-1071) to lower case (unicode 1072-1103)
          for ($unicodenumber = 1040 ; $unicodenumber < 1072 ; $unicodenumber++)
          {
            $lcunicodenumber = $unicodenumber + 32 ;
      	
            $KEYBAS1WORD =~ s/$unicodenumber/$lcunicodenumber/g ;
          }
        }
      }
      
      #wittle expewiment
      #$KEYBAS1WORD = "(".$ChapterCounter.")".$KEYBAS1WORD;
      # IT IS UNNECESSARY TO SORT KEYWORDS ON CHAPTERCOUNTER AS KEYWORDS HAVE THE FIRST OCCURRENCE OF THEIR WORD ON THE FIRST POSITION OF MEANINGLINE WHICH CONTAINS CHAPTER
  
  
      #check if this is last word of sentence. Save as lastlastword later on (so you know you have first word of sentence).
      $ENDWORD = "";
      if ($CHARBEHINDBASWORD eq ".")
      {
        $ENDWORD = "(.)";
      }
  
      # CREATE FIRST TWO ENTRIES OF A WORDCOMBINATION FOR A KEYWORD
      # ADD THIS WORD TO DATABASE, AND ADD THE LAST TWO WORDS BEFORE IT, UNLESS IT WAS A $LASTWORD
      if (! $ALLBASWORDS{$KEYBAS1WORD}) # if this word does not yet exist as a keyword
      {
  
        if ($LASTENDWORD eq "(.)" || $LASTORIBAS1WORD eq "") # if this word is somehow the first
        {
          #create first three entries of a five word combination of which the first two entries of the first three are empty
          $ALLBASWORDS{$KEYBAS1WORD}="-=-;;-=-;;".$ORIBAS1WORD."(".$ChapterCounter."-".$counter.$ENDWORD.")=".$TRANWORD;
        }
        else
        {
          if ($BEFORELASTENDWORD eq "(.)" || $BEFORELASTORIBAS1WORD eq "") # if this word is the second in a row
          {
            #create first three entries of a five word combination and keep the first entry empty
            $ALLBASWORDS{$KEYBAS1WORD}="-=-;;".$LASTORIBAS1WORD."=".$LASTTRANWORD.";;".$ORIBAS1WORD."(".$ChapterCounter."-".$counter.$ENDWORD.")=".$TRANWORD;
          }
          else
          {
            #create first three entries of a five word combination
            $ALLBASWORDS{$KEYBAS1WORD}=$BEFORELASTORIBAS1WORD."=".$BEFORELASTTRANWORD.";;".$LASTORIBAS1WORD."=".$LASTTRANWORD.";;".$ORIBAS1WORD."(".$ChapterCounter."-".$counter.$ENDWORD.")=".$TRANWORD;
          }
        }
      }
      else
      {
        # if this word already exists as a keyword
        if ($TRANWORD eq "")
        {
          $TRANWORD = "()" ;
        }
        if ($LASTENDWORD eq "(.)" || $LASTORIBAS1WORD eq "") # if this word is somehow the first
        {
          #create first three entries of a five word combination of which the first two entries of the first three are empty
          $ALLBASWORDS{$KEYBAS1WORD}=$ALLBASWORDS{$KEYBAS1WORD}."::-=-;;-=-;;".$ORIBAS1WORD."(".$ChapterCounter."-".$counter.$ENDWORD.")=".$TRANWORD;
        }
        else
        {
        	if ($BEFORELASTENDWORD eq "(.)" || $BEFORELASTORIBAS1WORD eq "") # if this word is the second in a row
          {
            #add first three entries of a five word combination and keep the first entry empty
            $ALLBASWORDS{$KEYBAS1WORD}=$ALLBASWORDS{$KEYBAS1WORD}."::-=-;;".$LASTORIBAS1WORD."=".$LASTTRANWORD.";;".$ORIBAS1WORD."(".$ChapterCounter."-".$counter.$ENDWORD.")=".$TRANWORD;
          }
          else
          {
            #add first three entries of a five word combination to an existing key
            $ALLBASWORDS{$KEYBAS1WORD}=$ALLBASWORDS{$KEYBAS1WORD}."::".$BEFORELASTORIBAS1WORD."=".$BEFORELASTTRANWORD.";;".$LASTORIBAS1WORD."=".$LASTTRANWORD.";;".$ORIBAS1WORD."(".$ChapterCounter."-".$counter.$ENDWORD.")=".$TRANWORD;
  
          }
        }
      }
    
      # CREATE FOURTH ENTRY OF LAST KEYWORD
      # ADD THIS WORD TO THE LAST $KEYBAS1WORD IF THE LAST $KEYBAS1WORD WAS NOT A $LASTWORD
      if ($LASTENDWORD ne "(.)" && $LASTORIBAS1WORD ne "") # if not a lastword or empty
      {
        # create last entry of a five word combination
        $ALLBASWORDS{$LASTKEYBAS1WORD}=$ALLBASWORDS{$LASTKEYBAS1WORD}.";;".$ORIBAS1WORD."=".$TRANWORD;
      }
      else
      {
        #if ($LASTORIBAS1WORD ne "")
        #{
          $ALLBASWORDS{$LASTKEYBAS1WORD}=$ALLBASWORDS{$LASTKEYBAS1WORD}.";;-=-";
        #}
      }
      
      # CREATE FIFTH ENTRY OF BEFORE LAST KEYWORD
      # ADD THIS WORD TO THE BEFORE LAST $KEYBAS1WORD IF THE WORD BEFORE IT WAS NOT A "." or empty
      if ($BEFORELASTENDWORD ne "(.)" && $LASTENDWORD ne "(.)" && $LASTORIBAS1WORD ne "") # if not a lastword or empty
      {
        # create last entry of a five word combination
        $ALLBASWORDS{$BEFORELASTKEYBAS1WORD}=$ALLBASWORDS{$BEFORELASTKEYBAS1WORD}.";;".$ORIBAS1WORD."=".$TRANWORD;
      }
      else
      {
        #if ($LASTORIBAS1WORD ne "")
        #{
          $ALLBASWORDS{$BEFORELASTKEYBAS1WORD}=$ALLBASWORDS{$BEFORELASTKEYBAS1WORD}.";;-=-";
        #}
      }
  
      # THIS IS FOR AN ALTERNATIVE DICTIONARY: OVERRULING LANGUAGE BASE TO TARGET ? 1
      if ($DICCWORDON eq "YES" && $TRANWORD ne "" && $TRANWORD ne "()")
      {
        # for DICCWORD KEY change upper to lower
        $KEYDICCWORD = lc($DICCWORD) ;
  
        # ADD THIS WORD TO DATABASE, AND ADD THE LAST WORD BEFORE IT, UNLESS IT WAS A $LASTWORD
        if (! $ALLDICCWORDS{$KEYDICCWORD}) # if this word does not yet exist as a keyword
        {
          #create first three entries of a five word combination of which the first two entries of the first three are empty
          if ($LASTENDWORD eq "(.)" || $LASTDICCWORD eq "") # if this word is somehow the first
          {
            $ALLDICCWORDS{$KEYDICCWORD}="-=-;;-=-;;".$DICCWORD."(".$ChapterCounter."-".$counter.$ENDWORD.")=".$TRANWORD;
          }
          else
          {
            if ($BEFORELASTENDWORD eq "(.)" || $BEFORELASTDICCWORD eq "") # if this word is the second in a row
            {
              #create first three entries of a five word combination and keep the first entry empty
              $ALLDICCWORDS{$KEYDICCWORD}="-=-;;".$LASTDICCWORD."=".$LASTTRANWORD.";;".$DICCWORD."(".$ChapterCounter."-".$counter.$ENDWORD.")=".$TRANWORD;
            }
            else
            {
              #create first three entries of a five word combination
              $ALLDICCWORDS{$KEYDICCWORD}=$BEFORELASTDICCWORD."=".$BEFORELASTTRANWORD.";;".$LASTDICCWORD."=".$LASTTRANWORD.";;".$DICCWORD."(".$ChapterCounter."-".$counter.$ENDWORD.")=".$TRANWORD;
            }
          }
        }
        else
        {
          # if this word already exists as a keyword
          if ($LASTENDWORD eq "(.)" || $LASTDICCWORD eq "") # if this word is somehow the first
          {
            #create first three entries of a five word combination of which the first two entries of the first three are empty
            $ALLDICCWORDS{$KEYDICCWORD}=$ALLDICCWORDS{$KEYDICCWORD}."::-=-;;-=-;;".$DICCWORD."(".$ChapterCounter."-".$counter.$LASTWORD.")=".$TRANWORD;
          }
          else
          {
            if ($BEFORELASTENDWORD eq "(.)" || $BEFORELASTDICCWORD eq "") # if this word is the second in a row
            {
              #add first three entries of a five word combination and keep the first entry empty
              $ALLDICCWORDS{$KEYDICCWORD}=$ALLDICCWORDS{$KEYDICCWORD}."::-=-;;".$LASTDICCWORD."=".$LASTTRANWORD.";;".$DICCWORD."(".$ChapterCounter."-".$counter.$ENDWORD.")=".$TRANWORD;
            }
            else
            {
              #add first three entries of a five word combination to an existing key
              $ALLDICCWORDS{$KEYDICCWORD}=$ALLDICCWORDS{$KEYDICCWORD}."::".$BEFORELASTDICCWORD."=".$BEFORELASTTRANWORD.";;".$LASTDICCWORD."=".$LASTTRANWORD.";;".$DICCWORD."(".$ChapterCounter."-".$counter.$ENDWORD.")=".$TRANWORD;
            }
          }
        }
  
        # CREATE FOURTH ENTRY OF LAST KEYWORD
        # ADD THIS WORD TO THE LAST $KEYDICCWORD IF THE LAST $KEYDICCWORD WAS NOT AN $ENDWORD
        if ($LASTENDWORD ne "(.)" && $LASTDICCWORD ne "") # if not an endword or empty
        {
          # create last entry of a five word combination
          $ALLDICCWORDS{$LASTKEYDICCWORD}=$ALLDICCWORDS{$LASTKEYDICCWORD}.";;".$DICCWORD."=".$TRANWORD;
        }
        else
        {
          $ALLDICCWORDS{$LASTKEYDICCWORD}=$ALLDICCWORDS{$LASTKEYDICCWORD}.";;-=-";
        }
        
        # CREATE FIFTH ENTRY OF BEFORE LAST KEYWORD
        # ADD THIS WORD TO THE LAST $KEYDICCWORD IF THE LAST $KEYDICCWORD WAS NOT A $LASTWORD
        if ($BEFORELASTENDWORD ne "(.)" && $LASTDICCWORD ne "") # if not a lastword or empty
        {
          # create last entry of a five word combination
          $ALLDICCWORDS{$BEFORELASTKEYDICCWORD}=$ALLDICCWORDS{$BEFORELASTKEYDICCWORD}.";;".$DICCWORD."=".$TRANWORD;
        }
        else
        {
          $ALLDICCWORDS{$BEFORELASTKEYDICCWORD}=$ALLDICCWORDS{$BEFORELASTKEYDICCWORD}.";;-=-";
        }
      }
    
      #tbv normal Dictionary
      $BEFORELASTORIBAS1WORD = $LASTORIBAS1WORD ;
      $LASTORIBAS1WORD = $ORIBAS1WORD ;
      $BEFORELASTTRANWORD = $LASTTRANWORD ;
      $LASTTRANWORD = $TRANWORD ;
      $BEFORELASTENDWORD = $LASTENDWORD ;
      $LASTENDWORD = $ENDWORD ;
      $BEFORELASTKEYBAS1WORD = $LASTKEYBAS1WORD ;
      $LASTKEYBAS1WORD = $KEYBAS1WORD ;
  
      #tbv !EXTRA! DICCtionary (-DicE (from English to target language) or -DicD (from Dutch to target language))
      # (also uses (before (last)) tranword and (before (last)) endword
      # but has already been done for normal DICtionary)
      $BEFORELASTDICCWORD = $LASTDICCWORD ;
      $LASTDICCWORD = $DICCWORD ;
      $BEFORELASTKEYDICCWORD = $LASTKEYDICCWORD ;
      $LASTKEYDICCWORD = $KEYDICCWORD ;
      
      #count counter to a count it has never counted before
      $counter = $counter + 1 ;
    }
    # finish foreach $BAS1WORD (@BAS1) (per chapter, so now finishing up this specific chapter)
    
    #format, print and close flowing english CSV file:
    if ($AddCSVFile eq "yes" && $FlowingEnglish eq "yes") {
      # format flowing english (punctuation)
      $ORIGINALPARTCSVSAVEDUPFORPRINTING =~ s/\<\/I\>//g;
      $ORIGINALPARTCSVSAVEDUPFORPRINTING =~ s/\<I\>//g;
      
      #try using (\W+) here instead of separate punct
      $ORIGINALPARTCSVSAVEDUPFORPRINTING =~ s/\n, /, \n/g;
      $ORIGINALPARTCSVSAVEDUPFORPRINTING =~ s/\n\. /\. \n/g;
      $ORIGINALPARTCSVSAVEDUPFORPRINTING =~ s/\n; /; \n/g;
      $ORIGINALPARTCSVSAVEDUPFORPRINTING =~ s/\n\: /\: \n/g;
      $ORIGINALPARTCSVSAVEDUPFORPRINTING =~ s/\n\! /\! \n/g;
      $ORIGINALPARTCSVSAVEDUPFORPRINTING =~ s/ ,/,/g;
      $ORIGINALPARTCSVSAVEDUPFORPRINTING =~ s/ \./\./g;
      $ORIGINALPARTCSVSAVEDUPFORPRINTING =~ s/ ;/;/g;
      $ORIGINALPARTCSVSAVEDUPFORPRINTING =~ s/ \:/\:/g;
      $ORIGINALPARTCSVSAVEDUPFORPRINTING =~ s/ \!/\!/g;
      
      
      $ORIGINALPARTCSVSAVEDUPFORPRINTING =~ s/\n \n/\n\n/g;
      $ORIGINALPARTCSVSAVEDUPFORPRINTING =~ s/\n /\n/g;
      $ORIGINALPARTCSVSAVEDUPFORPRINTING =~ s/\n\n\n/\n\n/g;
      $ORIGINALPARTCSVSAVEDUPFORPRINTING =~ s/\t\t/\t/g;
      $ORIGINALPARTCSVSAVEDUPFORPRINTING =~ s/\s\t/\t/g;
      $ORIGINALPARTCSVSAVEDUPFORPRINTING =~ s#\t+(\w+)(\W+)\n#$2\t$1$2\n#g;
      $ORIGINALPARTCSVSAVEDUPFORPRINTING =~ s/\t(\w+)\s(\w+)(\W+)\n/$3\t$1 $2$3\n/g;
      $ORIGINALPARTCSVSAVEDUPFORPRINTING =~ s/\t(\w+)\s(\w+)\s(\w+)(\W+)\n/$4\t$1 $2 $3$4\n/g;
      $ORIGINALPARTCSVSAVEDUPFORPRINTING =~ s/\t(\w+)\s(\w+)\s(\w+)\s(\w+)(\W+)\n/$5\t$1 $2 $3 $4$5\n/g;
      $ORIGINALPARTCSVSAVEDUPFORPRINTING =~ s/\t(\w+)\s(\w+)\s(\w+)\s(\w+)\s(\w+)(\W+)\n/$6\t$1 $2 $3 $4 $5$6\n/g;
      $ORIGINALPARTCSVSAVEDUPFORPRINTING =~ s/\t(\w+)\s(\w+)\s(\w+)\s(\w+)\s(\w+)\s(\w+)(\W+)\n/$7\t$1 $2 $3 $4 $5 $6$7\n/g;
      $ORIGINALPARTCSVSAVEDUPFORPRINTING =~ s/\t(\w+)\s(\w+)\s(\w+)\s(\w+)\s(\w+)\s(\w+)\s(\w+)(\W+)\n/$8\t$1 $2 $3 $4 $5 $6 $7$8\n/g;
      $ORIGINALPARTCSVSAVEDUPFORPRINTING =~ s/\t(\w+)\s(\w+)\s(\w+)\s(\w+)\s(\w+)\s(\w+)\s(\w+)\s(\w+)(\W+)\n/$9\t$1 $2 $3 $4 $5 $6 $7 $8$9\n/g;
      $ORIGINALPARTCSVSAVEDUPFORPRINTING =~ s/\t(\w+)\s(\w+)\s(\w+)\s(\w+)\s(\w+)\s(\w+)\s(\w+)\s(\w+)\s(\w+)(\W+)\n/$10\t$1 $2 $3 $4 $5 $6 $7 $8 $9$10\n/g;
      $ORIGINALPARTCSVSAVEDUPFORPRINTING =~ s/\t(\w+)\s(\w+)\s(\w+)\s(\w+)\s(\w+)\s(\w+)\s(\w+)\s(\w+)\s(\w+)\s(\w+)(\W+)\n/$11\t$1 $2 $3 $4 $5 $6 $7 $8 $9 $10$11\n/g;
      $ORIGINALPARTCSVSAVEDUPFORPRINTING =~ s/\t(\w+)\s(\w+)\s(\w+)\s(\w+)\s(\w+)\s(\w+)\s(\w+)\s(\w+)\s(\w+)\s(\w+)\s(\w+)(\W+)\n/$12\t$1 $2 $3 $4 $5 $6 $7 $8 $9 $10 $11$12\n/g;
      # this needs to go on a bit unfortunately
      
      
      # to utf or something
      $Udoubleacute = chr(197).chr(176);
      $udoubleacute = chr(197).chr(177);
      $Odoubleacute = chr(197).chr(144);
      $odoubleacute = chr(197).chr(145);
      $Uacute = chr(195).chr(154);
      $uacute = chr(195).chr(186);
      $Aacute = chr(195).chr(129);
      $aacute = chr(195).chr(161);
      $Iacute = chr(195).chr(141);
      $iacute = chr(195).chr(173);
      
      $ORIGINALPARTCSVSAVEDUPFORPRINTING =~ s/\&\#8209\;/\-/g;
      $ORIGINALPARTCSVSAVEDUPFORPRINTING =~ s/\&\#368\;/$Udoubleacute/g;
      $ORIGINALPARTCSVSAVEDUPFORPRINTING =~ s/\&\#369\;/$udoubleacute/g;
      $ORIGINALPARTCSVSAVEDUPFORPRINTING =~ s/\&\#336\;/$Odoubleacute/g;
      $ORIGINALPARTCSVSAVEDUPFORPRINTING =~ s/\&\#337\;/$odoubleacute/g;
      $ORIGINALPARTCSVSAVEDUPFORPRINTING =~ s/\&\#8209\;/\-/g;
      $ORIGINALPARTCSVSAVEDUPFORPRINTING =~ s/Ú/$Uacute/g;
      $ORIGINALPARTCSVSAVEDUPFORPRINTING =~ s/ú/$uacute/g;
      $ORIGINALPARTCSVSAVEDUPFORPRINTING =~ s/Ó/Ã?/g;
      $ORIGINALPARTCSVSAVEDUPFORPRINTING =~ s/ó/Ã³/g;
      $ORIGINALPARTCSVSAVEDUPFORPRINTING =~ s/É/Ã?/g;
      $ORIGINALPARTCSVSAVEDUPFORPRINTING =~ s/é/Ã©/g;
      $ORIGINALPARTCSVSAVEDUPFORPRINTING =~ s/Í/$Iacute/g;
      $ORIGINALPARTCSVSAVEDUPFORPRINTING =~ s/í/$iacute/g;
      $ORIGINALPARTCSVSAVEDUPFORPRINTING =~ s/Á/$Aacute/g;
      $ORIGINALPARTCSVSAVEDUPFORPRINTING =~ s/á/$aacute/g;
      $ORIGINALPARTCSVSAVEDUPFORPRINTING =~ s/Ö/Ãµ/g;
      $ORIGINALPARTCSVSAVEDUPFORPRINTING =~ s/ö/Ã¶/g;
      $ORIGINALPARTCSVSAVEDUPFORPRINTING =~ s/Ü/Ã»/g;
      $ORIGINALPARTCSVSAVEDUPFORPRINTING =~ s/ü/Ã¼/g;
      
      $ORIGINALPARTCSVSAVEDUPFORPRINTING =~ s/\n\t/\t/g;
      $ORIGINALPARTCSVSAVEDUPFORPRINTING =~ s/\n\n/\n|\n/g;
      # print flowing english
      if ($TRACING eq "ON") {
        print "Printing csv file in UTF mode...\n";
      } else { print ".";}
      print CSVTEXT "ï»¿".$ORIGINALPARTCSVSAVEDUPFORPRINTING;
      close (CSVTEXT);
    }
  
    $LongChapterCounter = $ChapterCounter - 1 ;
    $CounterListChapterName = $ChapterLongNames[$LongChapterCounter] ;
    #print "CounterListChapterName is $CounterListChapterName\n";
    push (@ChapterCounters,$ChapterCounter."\t".$CounterListChapterName."(".$counter.")<BR>");
    #help goofy
    push (@ChapterWordCounters,$counter);
    $TotalCounter = $TotalCounter + $counter ;
    $ChapterCounter = $ChapterCounter + 1 ;
  
    #close pagefile
    close (NEWTEXT) ;
  
    #print "Started Second Process $StartTime" ;
    $CurrentTime = `time /T`;
    #print "Finishd Second Process $CurrentTime\n" ;
  
    open (FILE, "newtext") || die "newtext file cannot be found. ($!)\n";
    @NEWTEXT = <FILE>;
    close (FILE);
    $NEWTEXT = join("",@NEWTEXT);
  
  
  
    $NEWTEXT = $NEWTEXT.$ORG.$ETOBJ ;
  
    # add enters &nbsp;<o:p></o:p>
    $NEWTEXT =~ s/<O:P><\/O:P>/<o:p><\/o:p>/g ;
    $NEWTEXT =~ s/\<o:p\>\<\/o:p\>\n\n\<\/B\>\n\n\<o:p\>\&nbsp\;\<\/o:p\>/\<\/B\>\n$TEOBJ\n$SPOBJ\n$TSOBJ\n/g ;
    $NEWTEXT =~ s/\<o:p\>\<\/o:p\>\n\n\<\/B\>/\<\/B\>\n$TEOBJ\n$SPOBJ\n$TSOBJ\n/g ;
    $NEWTEXT =~ s/\<o:p\>\<\/o:p\>\n\n\<o:p\>\<\/o:p\>/\n$TEOBJ\n$SPOBJ\n$TSOBJ\n/g ;
    $NEWTEXT =~ s/\<o:p\>\<\/o:p\>\n\n \<o:p\>\<\/o:p\>/\n$TEOBJ\n$SPOBJ\n$TSOBJ\n/g ;
    $NEWTEXT =~ s/\<o:p\>\<\/o:p\>\n\n\<o:p\>\&nbsp;\<\/o:p\>/\n$TEOBJ\n$SPOBJ\n$TSOBJ\n/g ;
    $NEWTEXT =~ s/<\/B>\n\n\<o:p\>\<\/o:p\>/<\/B>\n\n$TEOBJ\n$SPOBJ\n$TSOBJ\n/g ;
    $NEWTEXT =~ s/\<o:p\>\&nbsp\;\<\/o:p\>/\n$SPOBJ\n/g ;
    $NEWTEXT =~ s/\&nbsp\;\<o:p\>\<\/o:p\>/\n$SPOBJ\n/g ;
    $NEWTEXT =~ s/\<o:p\>\<\/o:p\>/\n$SPOBJ\n/g ;
  
    $NEWTEXT =~ s/<P class=MsoNormal>/\n$SPOBJ\n/g ;
  
  
  
    # EDIT $INHOUD/NEWTEXT TO CHANGE BACK CERTAIN STRINGS FROM PARSE CODES, TO AVOID LATER CONFLICT
    $NEWTEXT =~ s/### Q ###/<img/g;
    $NEWTEXT =~ s/###Q Q###/<\/img>/g;
  
  
  
  
    #################################################################################
    # CREATING FILES
    #################################################################################
  
    # split NEWTEXT in 15.000 CHARS PAGES
  
    #if there is <LB> means that the text is formatted already, only linebreak on <LB>
    $PREFORMATTED = "NO";
    if ($NEWTEXT !~ "<LB>")
    {
      #@NEWTEXTPARAGRAPHS = split (/<!-- PARAGRAPH -->/,$NEWTEXT) ;
      $NEWTEXT =~ s/\. \"/\_\"<!--linebreak>/g;
  
      #first remove all the spaces
      $NEWTEXT =~ s/ <BR> /<BR>/g;
      $NEWTEXT =~ s/ \- /\- /g;
      $NEWTEXT =~ s/ \: /\: /g;
      $NEWTEXT =~ s/\; \; /\;\; /g;
      $NEWTEXT =~ s/ \, /\, /g;
      $NEWTEXT =~ s/ \. /\. /g;
      $NEWTEXT =~ s/ \! /\! /g;
      $NEWTEXT =~ s/ \? /\? /g;
      $NEWTEXT =~ s/ \" /\" /g;
  
      #make me beautiful (haal linebreak toevoeging ff weg)
      $NEWTEXT =~ s/\.\"/\_\"<!--linebreak>/g;
      $NEWTEXT =~ s/\.\.\.\&nbsp\;\&nbsp\;/\.\.\.\&nbsp\; <!--linebreak>/g;
      $NEWTEXT =~ s/\!&nbsp; /!&nbsp; <!--linebreak>/g;
      $NEWTEXT =~ s/\?&nbsp; /\?&nbsp; <!--linebreak>/g;
      $NEWTEXT =~ s/\&nbsp\;  \_\"<!--linebreak>/\.\"\&nbsp\; <!--linebreak>/g;
      $NEWTEXT =~ s/\&nbsp\;  \,/\,\&nbsp\; <!--linebreak>/g;
      $NEWTEXT =~ s/\&nbsp\;   \; /\;\&nbsp\; <!--linebreak>/g;
      $NEWTEXT =~ s/\&nbsp\;   \: /\:\&nbsp\; <!--linebreak>/g;
      $NEWTEXT =~ s/<\#L>/<\#L><!--linebreak>/g;
      $NEWTEXT =~ s/<BR><BR>/<BR><BR><!--linebreak>/g;
      $NEWTEXT =~ s/ <BR>/<BR>/g;
      $NEWTEXT =~ s/\. \"<BR><BR>/\.\"<BR><BR>/g;
      $NEWTEXT =~ s/\. /\.&nbsp; <\!--linebreak>/g;
      $NEWTEXT =~ s/\.&nbsp;&nbsp;\"<BR><BR>/\.\"<BR><BR>/g;
      $NEWTEXT =~ s/\.&nbsp;/\.&nbsp;<\!--linebreak>/g;
      $NEWTEXT =~ s/<\/DIV>&nbsp; - <\!-- /<\/DIV>&nbsp; - <\!--linebreak><\!-- /g;
  
      #beautify
      $NEWTEXT =~ s/<P>//g;
      $NEWTEXT =~ s/<BR><BR>\n<BR><BR>/<BR><BR>/g;
      $NEWTEXT =~ s/ <BR> /<BR>/g;
      $NEWTEXT =~ s/<BR><BR>\n<BR>/<BR><BR>/g;
    }
    else
    {
      $NEWTEXT =~ s/<LB>/<!--linebreak>/g;
      $PREFORMATTED = "YES";
      #beautify
      $NEWTEXT =~ s/<P>//g;
      $NEWTEXT =~ s/<BR><BR>\n<BR><BR>/<BR><BR>/g;
      $NEWTEXT =~ s/ <BR> /<BR>/g;
      $NEWTEXT =~ s/<BR><BR>\n<BR>/<BR><BR>/g;
      $NEWTEXT =~ s/&nbsp; /&nbsp;/g;
      #$NEWTEXT =~ s/ - /-/g;
    }
  
    #No line break on a roman number
    $NEWTEXT =~ s/I\<\/DIV\>\.\&nbsp\; <!--linebreak>/I<\/DIV\>\.\&nbsp\; /g;
    $NEWTEXT =~ s/V\<\/DIV\>\.\&nbsp\; <!--linebreak>/V<\/DIV\>\.\&nbsp\; /g;
    $NEWTEXT =~ s/X\<\/DIV\>\.\&nbsp\; <!--linebreak>/X<\/DIV\>\.\&nbsp\; /g;
    $NEWTEXT =~ s/L\<\/DIV\>\.\&nbsp\; <!--linebreak>/L<\/DIV\>\.\&nbsp\; /g;
  
    @NEWTEXTPARAGRAPHS = split (/<!--linebreak>/,$NEWTEXT) ;
    $MAXNR = @NEWTEXTPARAGRAPHS ;
    $PAGELENGTH = 0 ;
    $LASTPARLENGTH = 0;
    $NEWTEXT = "" ;
    $TEXTNR = $PAGENUMBER ;
  
    #print "ArabNumberOfChapter is $ArabNumberOfChapter and TEXTNR is $TEXTNR + 1\n";
    $ChapterPage{$ArabNumberOfChapter} = $TEXTNR + 1 ;
  
    @PAGELINKS = ("");
  
    for ($NR = 0; $NR < $MAXNR+1; $NR++)
    {
      $NEWTEXT = $NEWTEXT.$NEWTEXTPARAGRAPHS[$NR] ;
      $PARLENGTH = length($NEWTEXTPARAGRAPHS[$NR]) ;
      $PAGELENGTH = $PAGELENGTH + $PARLENGTH ;
      #note the nextparlength so you don't leave one or two words of a paragraph on the next page
      $NEXTPARLENGTH = length($NEWTEXTPARAGRAPHS[$NR+1]) ;
      $AFTERNEXTPARLENGTH = length($NEWTEXTPARAGRAPHS[$NR+2]) ;
    
      #Add extra length for breaks!
      if ( $NEWTEXTPARAGRAPHS[$NR] =~ "<#L>" )
      {
        $PAGELENGTH = $PAGELENGTH + 2000 ;
      }
    
      #Add extra length for breaks!
      if ( $NEWTEXTPARAGRAPHS[$NR] =~ "<BR>" )
      {
        $PAGELENGTH = $PAGELENGTH + 2500 ;
      }
    
      #Add extra length for empty lines!
      if ( $NEWTEXTPARAGRAPHS[$NR] =~ "<!-- PARAGRAPH -->" )
      {
        $PAGELENGTH = $PAGELENGTH + 800 ;
      }
      #In case of chapter heading also add extra length
      if ( $NEWTEXTPARAGRAPHS[$NR] =~ "-------------" )
      {
        $PAGELENGTH = $PAGELENGTH + 3200 ;
      }
    
      if ($Language eq "Russian" || $Language eq "Urdu" || $Language eq "Georgian")
      {
        $MAXPARLENGTH = "35000";
        if ($Language eq "Georgian") {
          $MAXPARLENGTH = "25000";
          $PAGELENGTH = $PAGELENGTH + 1000;
        }
      }
      else
      {
        $MAXPARLENGTH = "40000";
      }
    
      if ( $PREFORMATTED eq "YES" || ( $PREFORMATTED = "NO" && $PARLENGTH > 1000 && $NEXTPARLENGTH < 1000 && ( ($PAGELENGTH + $NEXTPARLENGTH + $AFTERNEXTPARLENGTH) > $MAXPARLENGTH ) ) || ( $PREFORMATTED = "NO" && $PAGELENGTH > $MAXPARLENGTH && $LASTPARLENGTH > 1000 ) || ($NR == $MAXNR) ||  ($PREFORMATTED = "NO" && (($PAGELENGTH + $NEXTPARLENGTH + $AFTERNEXTPARLENGTH) > $MAXPARLENGTH) && $NEXTPARLENGTH < 20 && $AFTERNEXTPARLENGTH < 20 ) || ( $PREFORMATTED eq "YES" ) )
      {
        $TEXTNR = $TEXTNR + 1 ;
  
        $PAGELENGTH = 0 ;
       
        # Create pagenumber links and <<<MARK>>> for this page
        $NEWTEXT = $SMOBJ.$NEWTEXT.$SPOBJ ;
           
        $FINISHEDTEXT = $INHOUDTEMPLATE ;
        $FINISHEDTEXT =~ s/<<<HTMLCODE>>>/$TSOBJ\n$NEWTEXT\n$TEOBJ/;
        $FINISHEDTEXT =~ s/<<<CHARSET>>>/$CHARSET/;
  
        #choose text style
        $FINISHEDTEXT =~ s/<<<LANGUAGE>>>/$LA/g;
        $FINISHEDTEXT =~ s/<<<CHAPTERCODE>>>/$RomanNumberOfChapter/;
  
        # print version PRINTVERSION eq yes $TEXTNR % 2 == 0 )
        if ( $PRINTVERSION eq "yes" && ( $TEXTNR % 2 != 0 ) && $FINISHEDTEXT !~ "img" && ( $FINISHEDTEXT =~ "\<\#L\>\<\#L\>" || $FINISHEDTEXT !~ "span" ) ) {
          if ($TRACING eq "ON") {
            print "Page ".$TEXTNR." $FINISHEDTEXT ";
          } else { print ".";}
          # skip
          $TEXTNR = $TEXTNR - 1 ;
        } else { 
  
          # DE LAATSTE ACTIE IS HET WEGSCHRIJVEN VAN DE NIEUWE HTML FILEPAGE...
          $WriteFile = "..\\..\\Languages\\$Language\\HTML\\$Group\\Course$filepart$TEXTNR.htm" ;
          open (NEWFILE, ">$WriteFile") || die "file $WriteFile kan niet worden aangemaakt, ($!)\n" ;
          print NEWFILE $FINISHEDTEXT ;
          close (NEWFILE) ;
          $NEWTEXT = "" ;
        }
        
        #print "ArabNumberOfChapter is $ArabNumberOfChapter\n";
        if ($DEMOWANTED eq "TRUE" && $ArabNumberOfChapter ne "Title" && $NR > 1) {
          #poop out a demo version, stop at page 3 every time    ADD DUMMY DEMO PAGE WITH <DEMOADCODE> ONLY ON IT!!!
          $NR = $MAXNR + 2 ;
          
          # Create extra page, with pagenumber links and the whole chicken kaboodle
          $TEXTNR = $TEXTNR + 1 ;
          $NEWTEXT = "<DEMOADCODE>" ;
           
          $FINISHEDTEXT = $INHOUDTEMPLATE ;
          $FINISHEDTEXT =~ s/<<<HTMLCODE>>>/$TSOBJ\n$NEWTEXT\n$TEOBJ/;
          $FINISHEDTEXT =~ s/<<<CHARSET>>>/$CHARSET/;
  
          #choose text style
          $FINISHEDTEXT =~ s/<<<LANGUAGE>>>/$LA/g;
          $FINISHEDTEXT =~ s/<<<CHAPTERCODE>>>/$RomanNumberOfChapter/;
          
          # DE LAATSTE ACTIE IS HET WEGSCHRIJVEN VAN DE NIEUWE HTML FILEPAGE...
          $WriteFile = "..\\..\\Languages\\$Language\\HTML\\$Group\\Course$filepart$TEXTNR.htm" ;
          open (NEWFILE, ">$WriteFile") || die "file $WriteFile kan niet worden aangemaakt, ($!)\n" ;
          print NEWFILE $FINISHEDTEXT ;
          close (NEWFILE) ;
          $NEWTEXT = "" ;
        }
      }
      $LASTPARLENGTH = $PARLENGTH;
    }
  
    $PAGENUMBER = $TEXTNR ;
  
    $CHAPTERNUMBER = $ArabNumberOfChapter ;
  
    $CHAPTERPAGES[$CHAPTERNUMBER] = $PAGENUMBER;
  
  #END LOOP FOR FILE !!!!!!!!!!!!!!!!!!!
  }
  
  #set base variables
  $FILEBASE = "Course$filepart" ;
  
  # CREATE CHAPTER PART
  
  #vervang <<<CHAPTEROPTIONS>>> door alle chapteroptions
  $CHAPTEROPTIONS = "                  <option selected value='Choose Chapter'    >-</option>\n" ;
  $TelKleineVriendTel = -1;
  $ChapterDemoPages = "#";
  foreach $ShortFileName(@ChapterShortNames)
  {
     #print "Doing something with ShortFileName $ShortFileName\n";
     $TelKleineVriendTel = $TelKleineVriendTel + 1 ;
     $PageNumber = $ChapterPage{$ShortFileName} ;
     if ($ShortFileName =~ /^\d+$/ && $ShortFileName != 0)
     {
        $RomanChapter = roman($ShortFileName) ;
        $RomanChapter = uc ($RomanChapter) ;
     }
     else
     {
        $RomanChapter = $ChapterLongNames[$TelKleineVriendTel];
     }
     $CHAPTEROPTIONS = $CHAPTEROPTIONS."                  <option value= '".$PageNumber."'    >&nbsp;&nbsp;$RomanChapter&nbsp;&nbsp;&nbsp;</option>\n" ;
     $CHAPTERLINKS[$TelKleineVriendTel] = "onclick=\"ChangePageNew($PageNumber); return false;\"";
     $ChapterFirstPages[$TelKleineVriendTel]=$PageNumber;
     $PageNumberPlusOne = $PageNumber + 1 ;
     $ChapterDemoPages = $ChapterDemoPages."#".$PageNumber."#".$PageNumberPlusOne;
  }
  $ChapterPageArray[$TelKleineVriendTel] = $NR ;
  $ChapterNumberArray[$TelKleineVriendTel] = $TelKleineVriendTel ;
  
  $ChapterDemoPages = $ChapterDemoPages."#";
  
  #print "ChapterPageArray is ".$ChapterPageArray[$TelKleineVriendTel]."\n";
  #print "ChapterNumberArray is ".$ChapterNumberArray[$TelKleineVriendTel]."\n";
  
  # RECREATE PAGES WITH PAGENUMBERS, PAGEOPTIONS AND CHAPTEROPTIONS CUSTOM CODES, AND INCLUDE AUDIO PAGE LINK
  if (-e "..\\..\\Languages\\$Language\\Audio\\$Group\\Data") {
    # don't do nothing
  } else {
    `mkdir ..\\..\\Languages\\$Language\\Audio\\$Group\\Data`;
  }
  $CurrentShortFile = 0 ;
  $ChapterCounter = 1 ;
  $RealPageNumber = 0 ;
  
  #vervang <<<PAGEOPTIONS>>> door alle pageroptions
  $PAGEOPTIONS = "                  <option selected value='Choose Page'    >-</option>\n" ;
  for ($NR = 1; $NR < $PAGENUMBER +1; $NR++)
  {
     if ($TRACING eq "ON") {
       print "\nOk, starting page handling process,\n";
     } else { print ".";}
     
     $ReadFile = "..\\..\\Languages\\$Language\\HTML\\$Group\\Course$filepart$NR.htm" ;
     open (READFILE, "$ReadFile") || die "file $ReadFile cannot be found. ($!)\n";
     @TESTTEXT = <READFILE>;
     close (READFILE);
     $TESTTEXT = join ("",@TESTTEXT) ;
     
     $PageNumberCounter = $PageNumberCounter + 1 ;
     $PageNumberCounterForWebFiles = $PageNumberCounterForWebFiles + 1 ;
     $PageNumberCounterForSoundFiles = $PageNumberCounterForSoundFiles + 1 ;
     
     # initialize ThisIsANewChapter
     $ThisIsANewChapter = "NO";
  
     # Get Chapter Number for this page
     if ( $ChapterPage{$NextChapterKey} <= $NR && $ChapterPage{$NextChapterKey} != 0 )
     {
        $CurrentShortFile = $CurrentShortFile + 1 ;
        if ($TRACING eq "ON") {
          print "\nNew Chapter, setting PageNumberCounter and PageNumberCounterForSoundFiles to 1!\n";
        } else { print ".";}
        $PageNumberCounter = 1 ;
        $PageZIndexCounterLeft = 2000000 ;
        $PageZIndexCounterRight = 2000000 ;
        $SkippedPageNumberCounter = 0 ;
        $PageNumberCounterForSoundFiles = 1 ;
        $RealLastPageAudioCounters = "";
        $ThisIsANewChapter = "YES";
     }
     if ($TRACING eq "ON") {
       print "page number $PageNumberCounter\n";
       print "page number for sound files is $PageNumberCounterForSoundFiles\n";
       print "page number for web pages is $PageNumberCounterForWebFiles\n";
     } else { print ".";}
     
     if ($TRACING eq "ON") {
       print "\n";
       print "Processing CurrentShortFile $CurrentShortFile...\n";
     } else { print ".";}
     # create chapter abbreviation for behind page number in menu
     $ChapterAbbreviation = $CurrentShortFile ;
     if ( $ChapterAbbreviation == 0 )
     {
        $NiceShortChapterAbbreviation = "<<<Title>>>";
        #print "Counting NiceShortChapterAbbreviation $NiceShortChapterAbbreviation\n";
     }
     #if ( $ChapterAbbreviation == 0 )
     #{
     #   $NiceShortChapterAbbreviation = "<<<Contents>>>";
     #}
     if ( $ChapterAbbreviation >= 1 )
     {
        $ShortChapterAbbreviation = roman($ChapterAbbreviation) ;
        $NiceShortChapterAbbreviation = uc($ShortChapterAbbreviation) ;
        #print "Counting NiceShortChapterAbbreviation $NiceShortChapterAbbreviation\n";
     }
  
     $HoofdstukNummert = $ChapterAbbreviation ;
     $RomanChapter = $ChapterLongNames[$HoofdstukNummert];
     $HighSpace = chr(160);
     $RomanChapterHighSpaced = $RomanChapter;
     $RomanChapterHighSpaced =~ s/ /$HighSpace/g;
     if (0 == $NR % 2) {
       #even
     } else {
       #odd
       $PAGEOPTIONS = $PAGEOPTIONS."                  <option value= '".$NR."'    >$NR&nbsp;&nbsp;($RomanChapterHighSpaced)&nbsp;&nbsp;&nbsp;</option>\n" ;
     }
     $ChapterLastPages[$HoofdstukNummert] = $NR;
    
     # FOR EACH PAGE FILE, ENTER CUSTOMCODE PAGENUMBER, LASTPAGE, NEXTPAGE, LASTCHAP, NEXTCHAP
     # Get First Chapter Key
     $FirstChapterKey = $ChapterShortNames[0] ;
     # Get Last Chapter Key
     $LastChapterKey = $ChapterShortNames[$TelKleineVriendTel] ;
     # Get Current Chapter Key
     $CurrentChapterKey = $ChapterShortNames[$CurrentShortFile] ;
     $CurrentChapterKeyLongName = $ChapterLongNames[$CurrentShortFile];
     # meuh, looks like I look for a non-existent variable first time, so probably in case of title or contents, so next ones go right
     if ($CurrentChapterKeyLongNameAlternative ne "") { 
       $CurrentChapterKeyLongNameAlternative = $ChapterLongNamesAlternative[$CurrentShortFile];
       $CurrentChapterKeyLongNameTranslationEnglish = $ChapterLongNamesTranslationEnglish[$CurrentShortFile+1];
       $CurrentChapterKeyLongNameTranslationDutch = $ChapterLongNamesTranslationDutch[$CurrentShortFile+1];
     } else {
       $CurrentChapterKeyLongNameAlternative = $CurrentChapterKeyLongName;
     }
     
     # Get Next Chapter Key
     $NextChapterKey = $ChapterShortNames[$CurrentShortFile+1] ;
     # Get Last Chapter Key
     $PrevChapterKey = $ChapterShortNames[$CurrentShortFile-1] ;
  
     if ($TRACING eq "ON") {
       print "CurrentShortFile is $CurrentShortFile, CurrentChapterKey is $CurrentChapterKey, Next Chapter Key is $NextChapterKey\n";
     } else { print ".";}
  
     if ($TRACING eq "ON") {
       print "\nOk, CurrentChapterKey is $CurrentChapterKey!\n";
     } else { print ".";}
  
     $PageNumber = $NR ;
     $LastPage = 1 ;                            #default last (previous) page is first page
     $NextPage = $PAGENUMBER ;                  #default next page is last (final) page
     if ($PageNumber > 1)                       #if not first page...
     {
        $LastPage = $PageNumber - 1 ;
     }
     if ($PageNumber < $PAGENUMBER)             #if not final page...
     {
        $NextPage = $PageNumber + 1 ;
     }
     $PrevChap = $ChapterPage{$FirstChapterKey} ; #default last chapter page is first chapter
     $NextChap = $ChapterPage{$LastChapterKey} ;  #default next chapter page is last chapter
     if ($CurrentShortFile > 1)                     #if not first chapter...
     {
        $PrevChap = $ChapterPage{$PrevChapterKey} ;
     }
     if ($CurrentShortFile < $TelKleineVriendTel)      #if not final chapter...
     {
        $NextChap = $ChapterPage{$NextChapterKey} ;
     }
     $PageAfterNextPage=$NextPage+1;
     $PageAfterPrevChapterPage=$PrevChap+1;
     $PageAfterNextChapterPage=$NextChap+1;
     $CurrentChapterPage = $ChapterPage{$CurrentChapterKey} ;
     
     $RealNextPage = $NextPage;
     if ($NR == $NextPage)
     {
        $RealNextPage = $NextPage + 1;
     }
     
     # ADD TextFile name to TEXTFILES variable for ParseFile for TemplateList
     $TEXTFILES=$TEXTFILES."GET§Course".$filepart."Main.htm<>$NR<>§Course$filepart$NR.htm<>Course$filepart$RealNextPage.htm§<<<PAGETABLE>>><><<<PTWOTABLE>>>§NO\n";
     $TEXTFILES=$TEXTFILES."GET§Course".$filepart."MainOff.htm<>$NR<>§Course$filepart$NR.htm<>Course$filepart$RealNextPage.htm§<<<PAGETABLE>>><><<<PTWOTABLE>>>§NO\n";
     
     $ReadFile = "..\\..\\Languages\\$Language\\HTML\\$Group\\Course$filepart$NR.htm" ;
     open (READFILE, "$ReadFile") || die "file $ReadFile cannot be found. ($!)\n";
     @ALLTEXT = <READFILE>;
     close (READFILE);
     $ALLTEXT = join ("",@ALLTEXT) ; # add ###CHAPTERDIVISIONCODE### here if first or last page
     if ($APPOn eq "yes" && $ThisIsANewChapter eq "YES") {
       $ALLTEXT = "###CHAPTERDIVISIONCODE###".$ALLTEXT;
     }
     if ($TRACING eq "ON") {
       print "Opened file $ReadFile\n";
     } else { print ".";}
     
     $ALLTEXT =~ s/<<<BASEHTMLFILEPART>>>/$FILEBASE/g;
     
     # set chapter number for Word Database File
     $ChapterCounter = $CurrentShortFile + 1 ;
     
     if ($PageNumber == "1")
     {
        $CustomCodesForStartingPage = "<!--CUSTOMCODE--<<<PAGENUMBER>>>,$PageNumber,<<<PREVPAGE>>>,$LastPage,<<<NEXTPAGE>>>,$NextPage,<<<PREVCHAPTERPAGE>>>,$PrevChap,<<<NEXTCHAPTERPAGE>>>,$NextChap,<<<CURRENTCHAPTERPAGE>>>,Course$filepart$CurrentChapterPage.htm,<<<CURRENTPAGE>>>,Course$filepart$PageNumber.htm,<<<PAGEAFTERNEXTPAGE>>>,$PageAfterNextPage,<<<PAGEAFTERPREVCHAPTERPAGE>>>,$PageAfterPrevChapterPage,<<<PAGEAFTERNEXTCHAPTERPAGE>>>,$PageAfterNextChapterPage--CUSTOMCODE-->";
     }
     if ($WebsiteOn ne "yes" && $PDFOn ne "yes") {
       $ALLTEXT =~ s/<<<CUSTOMCODE>>>/<! --CUSTOMCODE--<<<PAGENUMBER>>>,$PageNumber,<<<PREVPAGE>>>,$LastPage,<<<NEXTPAGE>>>,$NextPage,<<<PREVCHAPTERPAGE>>>,$PrevChap,<<<NEXTCHAPTERPAGE>>>,$NextChap,<<<CURRENTCHAPTERPAGE>>>,Course$filepart$CurrentChapterPage.htm,<<<CURRENTPAGE>>>,Course$filepart$PageNumber.htm,<<<PAGEAFTERNEXTPAGE>>>,$PageAfterNextPage,<<<PAGEAFTERPREVCHAPTERPAGE>>>,$PageAfterPrevChapterPage,<<<PAGEAFTERNEXTCHAPTERPAGE>>>,$PageAfterNextChapterPage--CUSTOMCODE-->/;
     }
     else
     {
       $ALLTEXT =~ s/<<<CUSTOMCODE>>>//g;
     }
  
     # HIER SKIPPED HET SCRIPT EIGENLIJK DE GEHELE PRODUCTIE VAN HTML INDIEN OPGESTART TBV DE WEBSITE (en onderhavig verhaal niet op de website hoeft)
     if ($WebsiteOn eq "yes" && $WebsiteStory !~ $CurrentChapterKey)
     {
       if ($TRACING eq "ON") {
         print "\nWebsiteOn is yes and CurrentChapter $CurrentChapterKey can not be found in WebsiteStory definition $WebsiteStory!\n";
       } else { print ".";}
       next;
     }
     # idem voor PDF
     if ($PDFOn eq "yes" && $PDFStory !~ $CurrentChapterKey && $PDFStory ne "All" && $PDFStory ne "all" )
     {
       next;
     }
               
     # avoid working with non-MAINLANG language stories other than those provided in the ..\\Base\\App\\scripts\\keys.js
     # open Subhyplern file to get current full story names
     $HYPLERNKEYFILETEXT = "";
     $HypLernBaseKeysFile = "..\\Cordova\\AppProjects\\".$HypLernPath."\\".$HypLernPath."\\www\\scripts\\keys.js";
     open (READFILE, $HypLernBaseKeysFile) || die "file $HypLernBaseKeysFile cannot be found. ($!)\n";
     @HYPLERNKEYFILETEXT = <READFILE>;
     close (READFILE);
     $HYPLERNKEYFILETEXT = "@HYPLERNKEYFILETEXT";
  
     # SOUND OF MUSIC or empty page
     if ($ALLTEXT =~ "<img>" || ($PDFOn ne "yes" && $ALLTEXT !~ "DO_REFRESH") ) # skip this page in PageNumberCounter
     {
       if ($TRACING eq "ON") {
         print "\nThis page skipped in PageNumberCounter because it contains <img>!\n";
         print "$ALLTEXT\n";     # ehh does this ever happen? I guess nothing contains <img>?
       } else { print ".";}
       
       $PageNumberCounter = $PageNumberCounter - 1 ;
       $SkippedPageNumberCounter = $SkippedPageNumberCounter + 1;
       
       $PageNumberCounterForSoundFiles = $PageNumberCounterForSoundFiles - 1 ;
       $LastSoundFile = $SoundFile;
  
       if ($TRACING eq "ON") {
         print "page number $PageNumberCounter\n";
         print "page number for sound files is $PageNumberCounterForSoundFiles\n";
         print "page number for web pages is $PageNumberCounterForWebFiles\n";
       } else { print ".";}
       
     }
     else
     {
       if ($TRACING eq "ON") {
         print "CurrentShortFile is $CurrentShortFile...\n";
       } else { print ".";}
       if ($CurrentShortFile > 0) # all chapters minus title and contents, AND check whether there is a soundfile for that page
       {
         $CurrentChapterNumberForSound = $CurrentShortFile + 1;
         $SoundFile = $CurrentChapterKey."Page".$PageNumberCounterForSoundFiles ;
         $CurrentSoundFile = "..\\..\\Languages\\$Language\\Audio\\$Group\\Sound\\$CurrentChapterKey\\".$CurrentChapterKey."Page".$PageNumberCounterForSoundFiles ;
         if ($APPOn eq "yes" && ( $MAINLANG eq "" || ($MAINLANG eq $Language && $MAINSTORY ne "Free") || $HYPLERNKEYFILETEXT =~ "\_$CurrentChapterKey\"" ) ) {
           $StoryAuthor = $ChapterAuthors[$CurrentShortFile-1];
           if ($StoryAuthor eq "") {
             $StoryAuthor = $ChapterAuthors[0];
           }
           $TargetSoundPath = "..\\Cordova\\AppProjects\\".$HypLernPath."\\".$HypLernPath."\\www\\texts\\".$AppLangCode."\\".$StoryAuthor."_".$CurrentChapterKey."\\sounds";
           if (!-e $TargetSoundPath) {
             $output = `mkdir "$TargetSoundPath"`;
             if ($? != 0) {
               print "Something went wrong trying to create ".$TargetSoundPath."\n";
             }
           }
           $TargetSoundFile = $TargetSoundPath."\\".$CurrentChapterKey."Page".$PageNumberCounterForSoundFiles ;
         } else {
           $TargetSoundFile = "..\\..\\Site\\$Language\\Sounds\\".$CurrentChapterKey."Page".$PageNumberCounterForSoundFiles ;
         }
         if ($TRACING eq "ON") {
           print "Looking for Soundfile $CurrentSoundFile...\n";
         } else { print ".";}
         if (-f $CurrentSoundFile.".wav")
         {
           $AudioFileType = "wav" ;
         }
         if (-f $CurrentSoundFile.".mp3")
         {
           $AudioFileType = "mp3" ;
         }
         if (-f $CurrentSoundFile.".wma")
         {
           $AudioFileType = "wma" ;
         }
         if (-f $CurrentSoundFile.".".$AudioFileType)
         {
  
           $CurrentSoundFile = $CurrentSoundFile.".".$AudioFileType ;
           $TargetSoundFile = $TargetSoundFile.".".$AudioFileType ;
           $SoundFile = $SoundFile.".".$AudioFileType ;
           
           if ($TRACING eq "ON") {
             print "Current Soundfile is $CurrentSoundFile...\n";
           } else { print ".";}
           
           if ( ( $WebsiteOn eq "yes" && $OnlyWebIndex ne "yes" ) || $PDFOn eq "yes")
           {
             if ($APPOn eq "yes") {
               #print "Copying audio file?\n";
             }
             if ($WebsiteStory =~ $CurrentChapterKey)
             {
               $SoundPageNumberCounterMinusOne = $PageNumberCounterForSoundFiles - 1;
               $LastSoundFile = $CurrentChapterKey."Page".$SoundPageNumberCounterMinusOne.".".$AudioFileType;
               if (-f "$TargetSoundFile" && $REDO_AUDIO ne "YES")
               {
                 if ($TRACING eq "ON") {
                   print "Already $TargetSoundFile present...\n";
                 } else { print ".";}
                 $AUDIOEXISTS = "yes";
               } else {
                 if ($TRACING eq "ON") {
                   print "Copy soundfile $CurrentSoundFile to $TargetSoundFile...\n";
                 } else { print ".";}
                 $TEST = `copy $CurrentSoundFile $TargetSoundFile` ;
                 if ($? != 0) {
                   print "Error copying $CurrentSoundFile to $TargetSoundFile...\n";
                 } else {
                   $AUDIOEXISTS = "yes";
                 }
               }
               $ALLTEXT =~ s/<<<PAGETOPLEFT>>>/<<<HEADERLEFT>>><<<SOUNDLEFT>>><<<PAGETOPLEFT>>><<<SOUNDRIGHT>>><<<HEADERRIGHT>>>/;
               $SOUNDLEFT = "&nbsp;&nbsp;&nbsp;<a onclick=\"playleft('<<<PLAYLEFT>>>');\"><img SRC='..\/Pics\/Earpic.gif' WIDTH='8' BORDER='0'><\/a>&nbsp;<a onclick=\"stopall('<<<PLAYLEFT>>>');\"><img SRC='..\/Pics\/Stoppic.gif' WIDTH='8' BORDER='0'><\/a>&nbsp;-&nbsp;";
               $SOUNDLEFTSINGLE = "&nbsp;&nbsp;&nbsp;<a onclick=\"playleft('<<<PLAYLEFT>>>');\"><img SRC='..\/Pics\/Earpic.gif' WIDTH='8' BORDER='0'><\/a>&nbsp;<a onclick=\"stopall('<<<PLAYLEFT>>>');\"><img SRC='..\/Pics\/Stoppic.gif' WIDTH='8' BORDER='0'><\/a>&nbsp;-&nbsp;";
               $SOUNDRIGHT = "&nbsp;-&nbsp;<a onclick=\"playright('<<<PLAYRIGHT>>>');\"><img SRC='..\/Pics\/Earpic.gif' WIDTH='8' BORDER='0'><\/a>&nbsp;<a onclick=\"stopall('<<<PLAYRIGHT>>>');\"><img SRC='..\/Pics\/Stoppic.gif' WIDTH='8' BORDER='0'><\/a>";
               $SOUNDRIGHTSINGLE = "&nbsp;-&nbsp;<a onclick=\"playright('<<<PLAYRIGHT>>>');\"><img SRC='..\/Pics\/Earpic.gif' WIDTH='8' BORDER='0'><\/a>&nbsp;<a onclick=\"stopall('<<<PLAYRIGHT>>>');\"><img SRC='..\/Pics\/Stoppic.gif' WIDTH='8' BORDER='0'><\/a>";
             }
             if ($APPOn eq "yes" && ( $MAINLANG eq "" || ($MAINLANG eq $Language && $MAINSTORY ne "Free") || $HYPLERNKEYFILETEXT =~ "\_$CurrentChapterKey\"" ) ) {
               if (-f "$TargetSoundFile" && $REDO_AUDIO ne "YES") {
                 if ($TRACING eq "ON") {
                   print "Already $TargetSoundFile present...\n";
                 } else { print ".";}
                 $AUDIOEXISTS = "yes";
               } else {
                 if ($TRACING eq "ON") {
                   print "Copy soundfile $CurrentSoundFile to $TargetSoundFile...\n";
                 } else { print ".";}
                 $TEST = `copy $CurrentSoundFile "$TargetSoundFile"` ;
                 if ($? != 0) {
                   print "Error copying $CurrentSoundFile to $TargetSoundFile...\n";
                 } else {
                   $AUDIOEXISTS = "yes";
                 }
               }
             }
             if (($PDFStory ne "") && ($PDFStory =~ $CurrentChapterKey || $PDFStory eq "All" || $PDFStory eq "all"))
             {
               $ALLTEXT =~ s/<<<PAGETOPLEFT>>>/<<<KOBIE>>><<<PAGETOPLEFT>>>/;
             }
             if (-f "$CurrentSoundFile")
             {
               if ($TRACING eq "ON") {
                 print "PDF, but audio present, so set AUDIOEXISTS to yes for commercial text...\n";
               } else { print ".";}
               $AUDIOEXISTS = "yes";
             }
           } else {
             # IN CASE NOT FOR WEBSITE, MANAGE SOUNDS FOR E-BOOK
             $TargetSoundFile = "HypLern".$CurrentChapterNumberForSound."0".$PageNumberCounter.".dat" ;
             if (-f "..\\..\\Languages\\$Language\\Audio\\$Group\\Data\\$TargetSoundFile")
             {
               $ALLTEXT =~ s/<<<PAGETOPLEFT>>>/<<<PAGETOPLEFT>>>&nbsp;&nbsp;&nbsp;-&nbsp;<A HREF='DUMMY' title='<<<Sound>>>' onclick=\"stopandstart('$TargetSoundFile');\"><img SRC='..\\Media\\Earpic.gif' WIDTH='<<<FONTSIZE>>>' BORDER='0'><\/A>&nbsp;<A HREF='AUD§DummySound' title='<<<Turn Off Sound>>>'><img SRC='..\\Media\\Stoppic.gif' WIDTH='<<<FONTSIZE>>>' BORDER='0'><\/A>&nbsp;&nbsp;/ ;
               if ($TRACING eq "ON") {
                 print "Audio file exists, skipping...\n" ;
               } else { print ".";}
             }
             else
             {
               if ( ( $DEMOWANTED eq "TRUE" && ( $TargetSoundFile =~ m/01\.dat/i || $TargetSoundFile =~ m/02\.dat/i ) ) || $DEMOWANTED eq "FALSE" )
               {
                 if ($TRACING eq "ON") {
                   print "Copy soundfile $CurrentSoundFile to ..\\..\\Languages\\$Language\\Audio\\$Group\\Data\\$TargetSoundFile\n";
                 } else { print ".";}
                 $TEST = `copy $CurrentSoundFile ..\\..\\Languages\\$Language\\Audio\\$Group\\Data\\$TargetSoundFile` ;
                 if ($? == 0 )
                 {
                   $ALLTEXT =~ s/<<<PAGETOPLEFT>>>/<<<PAGETOPLEFT>>>&nbsp;&nbsp;&nbsp;-&nbsp;<A HREF='DUMMY' title='<<<Sound>>>' onclick=\"stopandstart('$TargetSoundFile');\"><img SRC='..\\Media\\Earpic.gif' WIDTH='<<<FONTSIZE>>>' BORDER='0'><\/A>&nbsp;<A HREF='AUD§DummySound' title='<<<Turn Off Sound>>>'><img SRC='..\\Media\\Stoppic.gif' WIDTH='<<<FONTSIZE>>>' BORDER='0'><\/A>&nbsp;&nbsp;/ ;
                 }
                 else
                 {
                   if ($TRACING eq "ON") {
                     print "Something went wrong while copying... $TEST\n" ;
                   } else { print ".";}
                 }
               }
             }
           }
         }
         else
         {
           $NoSoundFound = "Soundfile ..\\..\\Languages\\$Language\\Audio\\$Group\\Sound\\$CurrentChapterKey\\".$CurrentChapterKey."Page".$PageNumberCounterForSoundFiles.".".$AudioFileType." does not exist, skipping sound for this page...\n";
           if ($TRACING eq "ON") {
             print $NoSoundFound;
           }  else { print ".";}
           $SoundPageNumberCounterMinusOne = $PageNumberCounterForSoundFiles - 1;
           $LastSoundFile = $CurrentChapterKey."Page".$SoundPageNumberCounterMinusOne.".".$AudioFileType;
         }
       }
     }
  
     #Create TopRightChapterName and Page number entries for every page
     if ($CurrentChapterKey =~ /^\d+$/ )
     {
        #If A Number, Turn into "Chapter <Roman Number>"
        $RomanChapter = roman($CurrentChapterKey) ;
        $RomanChapter = uc ($RomanChapter) ;
        $TopRightChapterName = "Chapter ".$RomanChapter ;
     }
     else
     {
        $TopRightChapterName = $CurrentChapterKeyLongName ;
        $TopRightChapterNameAlternative = $CurrentChapterKeyLongNameAlternative;
        $TopRightChapterNameTranslationEnglish = $CurrentChapterKeyLongNameTranslationEnglish;
        $TopRightChapterNameTranslationDutch = $CurrentChapterKeyLongNameTranslationDutch;
     }
     $ALLTEXT =~ s/<<<IDPAGE>>>/$PageNumber/g;
     if ($WebsiteOn eq "yes")
     {
       #$ALLTEXT =~ s/<<<CHAPTERNAME>>>/<<<LOBBY>>>/;
       $ALLTEXT =~ s/<<<PAGETOPLEFT>>>/$PageNumber<<<RIGHTSIDEOFPAGENUMBER>>>/;
     } else {
       if ($PageNumber == 1) {
         $ALLTEXT =~ s/<<<CHAPTERNAME>>>//;
         $ALLTEXT =~ s/<<<PAGETOPLEFT>>>//;
         #if ($PDFOn eq "yes" && $ALSOCOUNTCOVER ne "yes") {
         #  $skippedpagenumbers = $skippedpagenumbers + 1;
         #}
       } else {
         if ($PDFOn eq "yes") {
           # we're going to add letter to reader, so always add one to pagenumber
           $PageNumber = $PageNumber + 1;
           # Skip this page if there are neither words (=links) nor images on it
           if ( $ALLTEXT !~ "href\=\'http" && $ALLTEXT !~ "span" && $ALLTEXT !~ "img" && $ALLTEXT !~ "l1" && $PRINTVERSION ne "yes" ) {
             # for every one of these occurrences, add one to $skippedpagenumbers
             $skippedpagenumbers = $skippedpagenumbers + 1;
           }
           $PageNumber = $PageNumber - $skippedpagenumbers;
           
           $ALLTEXT =~ s/<<<CHAPTERNAME>>>/$TopRightChapterName/;
           if ($APPOn ne "yes") {
             $ALLTEXT =~ s/<<<PAGETOPLEFT>>>/$PageNumber/;
           } else {
             $PageNumberCounterReal = $PageNumberCounter + $SkippedPageNumberCounter;
             $ALLTEXT =~ s/<<<PAGETOPLEFT>>>/$PageNumberCounterReal/;
           }
         } else {
           $ALLTEXT =~ s/<<<CHAPTERNAME>>>/$TopRightChapterName/;
           $ALLTEXT =~ s/<<<PAGETOPLEFT>>>/$PageNumber/;
         }
       }
     }
     
     # now add page number after ¶L, like in front of DIV, so when you do CLK it can find the sentence it's in
     if ($APPOn ne "yes") {
       $ALLTEXT =~ s/\¶L§/\¶L§$PageNumber\_/g;
     } else {
       $ALLTEXT =~ s/\¶L§/\¶L§$PageNumberCounterReal\_/g;
     }
        # make sure you save above page to a total of pages string so you can later get this pagenumber using basic wordcode
  
     # some beautification of the text
     $ALLTEXT =~ s/ &nbsp;/&nbsp;/g;
     $ALLTEXT =~ s/&nbsp;   \!/\!&nbsp; /g;
     $ALLTEXT =~ s/&nbsp;   \! \»/!\»&nbsp; /g;
     $ALLTEXT =~ s/&nbsp;  \.\,/\.\,&nbsp; /g;
     $ALLTEXT =~ s/\,&nbsp;  \"/\,&nbsp;\"/g;
     $ALLTEXT =~ s/\.&nbsp;  \"/\.&nbsp;&nbsp;\"/g;
     $ALLTEXT =~ s/\:&nbsp;  \"/\:&nbsp;&nbsp;\"/g;
     $ALLTEXT =~ s/\;&nbsp;  \"/\;&nbsp;&nbsp;\"/g;
     $ALLTEXT =~ s/\,&nbsp; /\,&nbsp; /g;
     $ALLTEXT =~ s/\.&nbsp; /\.&nbsp; /g;
     $ALLTEXT =~ s/\:&nbsp; /\:&nbsp; /g;
     $ALLTEXT =~ s/\;&nbsp; /\;&nbsp; /g;
     $ALLTEXT =~ s/&nbsp;  -/&nbsp; -&nbsp; /g;
     $ALLTEXT =~ s/\n\n\n/\n\n/g;
     $ALLTEXT =~ s/  / /g;
     $ALLTEXT =~ s/  / /g;
     $ALLTEXT =~ s/  / /g;
     $ALLTEXT =~ s/- -/-/g;
     $ALLTEXT =~ s/\!&nbsp;&nbsp;\"<BR>/\!\"<BR>/g;
     $ALLTEXT =~ s/<\/DIV>&nbsp; \'\./<\/DIV>\'\.&nbsp; /g;
     $ALLTEXT =~ s/<\/DIV>\. \"<BR>/<\/DIV>\.\"<BR>/g;
     $ALLTEXT =~ s/<\/DIV>&nbsp;  \./<\/DIV>\.&nbsp; /g;
     
  
     if ($TRACING eq "ON") {
       print "\nTreat characters...\n";
     } else { print ".";}
     
     if ($Language eq "Russian" || $Language eq "Urdu" || $Language eq "Georgian")
     {
        if ($Language eq "Russian") {
          #change cyrillic chars for HTML code 
          for ($charnr = 192 ; $charnr < 256 ; $charnr++)
          {
             $charch = chr($charnr);
             $newcharnr = $charnr + 848 ;
             $ALLTEXT =~ s/$charch/\&\#$newcharnr\;/g;
          }
        }
        # add paragraph sign used for replacing text
        $charch = chr(182);
        $ALLTEXT =~ s/$charch/\&\#182\;/g;
        $charch = chr(167);
        $ALLTEXT =~ s/$charch/\&\#167\;/g;
     }
     
     if ($Language eq "Swedish" || $Language eq "French" || $Language eq "Spanish" || $Language eq "Italian" || $Language eq "German" || $Language eq "Dutch" || $Language eq "English" || $Language eq "Portuguese" || $Language eq "Indonesian" || $Language eq "Hungarian" || $Language eq "Polish")
     {
        for ($charnr = 130 ; $charnr < 255 ; $charnr++)
        {
           $charch = chr($charnr);
           $ALLTEXT =~ s/$charch/\&\#$charnr\;/g;
        }
     }
      
     if ( $Language eq "Swedish" || $Language eq "Polish" )
     {
        # add paragraph sign used for replacing text
        $charch = chr(182);
        $ALLTEXT =~ s/$charch/\&\#182\;/g;
        $charch = chr(167);
        $ALLTEXT =~ s/$charch/\&\#167\;/g;
     	
        $BaseSwCh	= chr(195);
        $LargeAOp	= chr(133);
        $SmallAOp	= chr(165);
        $LargeAUp	= chr(132);
        $SmallAUp	= chr(164);
        $LargeOUp	= chr(150);
        $SmallOUp	= chr(182);
        $Aacute	= chr(195).chr(129);
        $aacute	= chr(195).chr(161);
        $Acirc	= chr(195).chr(130);
        $acirc	= chr(195).chr(162);
        $acute	= chr(194).chr(180);
        $AElig	= chr(195).chr(134);
        $aelig	= chr(195).chr(166);
        $Agrave	= chr(195).chr(128);
        $agrave	= chr(195).chr(160);
        $alefsym	= chr(226).chr(132).chr(181);
        $Alpha	= chr(206).chr(145);
        $alpha	= chr(206).chr(177);
        $amp	= chr(38);
        $and	= chr(226).chr(136).chr(167);
        $ang	= chr(226).chr(136).chr(160);
        $Aring	= chr(195).chr(133);
        $aring	= chr(195).chr(165);
        $asymp	= chr(226).chr(137).chr(136);
        $Atilde	= chr(195).chr(131);
        $atilde	= chr(195).chr(163);
        $Auml	= chr(195).chr(132);
        $auml	= chr(195).chr(164);
        $bdquo	= chr(226).chr(128).chr(158);
        $Beta	= chr(206).chr(146);
        $beta	= chr(206).chr(178);
        $brvbar	= chr(194).chr(166);
        $bull	= chr(226).chr(128).chr(162);
        $cap	= chr(226).chr(136).chr(169);
        $Ccedil	= chr(195).chr(135);
        $ccedil	= chr(195).chr(167);
        $cedil	= chr(194).chr(184);
        $cent	= chr(194).chr(162);
        $Chi	= chr(206).chr(167);
        $chi	= chr(207).chr(135);
        $circ	= chr(203).chr(134);
        $clubs	= chr(226).chr(153).chr(163);
        $cong	= chr(226).chr(137).chr(133);
        $copy	= chr(194).chr(169);
        $crarr	= chr(226).chr(134).chr(181);
        $cup	= chr(226).chr(136).chr(170);
        $curren	= chr(194).chr(164);
        $dagger	= chr(226).chr(128).chr(160);
        $Dagger	= chr(226).chr(128).chr(161);
        $darr	= chr(226).chr(134).chr(147);
        $dArr	= chr(226).chr(135).chr(147);
        $deg	= chr(194).chr(176);
        $Delta	= chr(206).chr(148);
        $delta	= chr(206).chr(180);
        $diams	= chr(226).chr(153).chr(166);
        $divide	= chr(195).chr(183);
        $Eacute	= chr(195).chr(137);
        $eacute	= chr(195).chr(169);
        $Ecirc	= chr(195).chr(138);
        $ecirc	= chr(195).chr(170);
        $Egrave	= chr(195).chr(136);
        $egrave	= chr(195).chr(168);
        $empty	= chr(226).chr(136).chr(133);
        $emsp	= chr(226).chr(128).chr(131);
        $ensp	= chr(226).chr(128).chr(130);
        $Epsilon	= chr(206).chr(149);
        $epsilon	= chr(206).chr(181);
        $equiv	= chr(226).chr(137).chr(161);
        $Eta	= chr(206).chr(151);
        $eta	= chr(206).chr(183);
        $ETH	= chr(195).chr(144);
        $eth	= chr(195).chr(176);
        $Euml	= chr(195).chr(139);
        $euml	= chr(195).chr(171);
        $euro	= chr(226).chr(130).chr(172);
        $exist	= chr(226).chr(136).chr(131);
        $fnof	= chr(198).chr(146);
        $forall	= chr(226).chr(136).chr(128);
        $frac12	= chr(194).chr(189);
        $frac14	= chr(194).chr(188);
        $frac34	= chr(194).chr(190);
        $frasl	= chr(226).chr(129).chr(132);
        $Gamma	= chr(206).chr(147);
        $gamma	= chr(206).chr(179);
        $ge	= chr(226).chr(137).chr(165);
        $harr	= chr(226).chr(134).chr(148);
        $hArr	= chr(226).chr(135).chr(148);
        $hearts	= chr(226).chr(153).chr(165);
        $hellip	= chr(226).chr(128).chr(166);
        $Iacute	= chr(195).chr(141);
        $iacute	= chr(195).chr(173);
        $Icirc	= chr(195).chr(142);
        $icirc	= chr(195).chr(174);
        $iexcl	= chr(194).chr(161);
        $Igrave	= chr(195).chr(140);
        $igrave	= chr(195).chr(172);
        $image	= chr(226).chr(132).chr(145);
        $infin	= chr(226).chr(136).chr(158);
        $int	= chr(226).chr(136).chr(171);
        $Iota	= chr(206).chr(153);
        $iota	= chr(206).chr(185);
        $iquest	= chr(194).chr(191);
        $isin	= chr(226).chr(136).chr(136);
        $Iuml	= chr(195).chr(143);
        $iuml	= chr(195).chr(175);
        $Kappa	= chr(206).chr(154);
        $kappa	= chr(206).chr(186);
        $Lambda	= chr(206).chr(155);
        $lambda	= chr(206).chr(187);
        $lang	= chr(226).chr(140).chr(169);
        $laquo	= chr(194).chr(171);
        $larr	= chr(226).chr(134).chr(144);
        $lArr	= chr(226).chr(135).chr(144);
        $lceil	= chr(226).chr(140).chr(136);
        $ldquo	= chr(226).chr(128).chr(156);
        $le	= chr(226).chr(137).chr(164);
        $lfloor=chr(226).chr(140).chr(138);
        $lowast=chr(226).chr(136).chr(151);
        $loz=chr(226).chr(151).chr(138);
        $lrm=chr(226).chr(128).chr(142);
        $lsaquo=chr(226).chr(128).chr(185);
        $lsquo=chr(226).chr(128).chr(152);
        $macr=chr(194).chr(175);
        $mdash=chr(226).chr(128).chr(148);
        $micro=chr(194).chr(181);
        $middot=chr(194).chr(183);
        $minus=chr(226).chr(136).chr(146);
        $Mu=chr(206).chr(156);
        $mu=chr(206).chr(188);
        $nabla=chr(226).chr(136).chr(135);
        $nbsp=chr(194).chr(160);
        $ndash=chr(226).chr(128).chr(147);
        $ne=chr(226).chr(137).chr(160);
        $ni=chr(226).chr(136).chr(139);
        $not=chr(194).chr(172);
        $notin=chr(226).chr(136).chr(137);
        $nsub=chr(226).chr(138).chr(132);
        $Ntilde=chr(195).chr(145);
        $ntilde=chr(195).chr(177);
        $Nu=chr(206).chr(157);
        $nu=chr(206).chr(189);
        $Oacute=chr(195).chr(147);
        $oacute=chr(195).chr(179);
        $Ocirc=chr(195).chr(148);
        $ocirc=chr(195).chr(180);
        $OElig=chr(197).chr(146);
        $oelig=chr(197).chr(147);
        $Ograve=chr(195).chr(146);
        $ograve=chr(195).chr(178);
        $oline=chr(226).chr(128).chr(190);
        $Omega=chr(206).chr(169);
        $omega=chr(207).chr(137);
        $Omicron=chr(206).chr(159);
        $omicron=chr(206).chr(191);
        $oplus=chr(226).chr(138).chr(149);
        $or=chr(226).chr(136).chr(168);
        $ordf=chr(194).chr(170);
        $ordm=chr(194).chr(186);
        $Oslash=chr(195).chr(152);
        $oslash=chr(195).chr(184);
        $Otilde=chr(195).chr(149);
        $otilde=chr(195).chr(181);
        $otimes=chr(226).chr(138).chr(151);
        $Ouml=chr(195).chr(150);
        $ouml=chr(195).chr(182);
        # add paragraph sign used for replacing text
        $charch = chr(182);
        $part=chr(226).chr(136).chr(130);
        $permil=chr(226).chr(128).chr(176);
        $perp=chr(226).chr(138).chr(165);
        $Phi=chr(206).chr(166);
        $phi=chr(207).chr(134);
        $Pi=chr(206).chr(160);
        $pi=chr(207).chr(128);
        $piv=chr(207).chr(150);
        $plusmn=chr(194).chr(177);
        $pound=chr(194).chr(163);
        $prime=chr(226).chr(128).chr(178);
        $Prime=chr(226).chr(128).chr(179);
        $prod=chr(226).chr(136).chr(143);
        $prop=chr(226).chr(136).chr(157);
        $Psi=chr(206).chr(168);
        $psi=chr(207).chr(136);
        $radic=chr(226).chr(136).chr(154);
        $rang=chr(226).chr(140).chr(170);
        $raquo=chr(194).chr(187);
        $rarr=chr(226).chr(134).chr(146);
        $rArr=chr(226).chr(135).chr(146);
        $rceil=chr(226).chr(140).chr(137);
        $rdquo=chr(226).chr(128).chr(157);
        $real=chr(226).chr(132).chr(156);
        $reg=chr(194).chr(174);
        $rfloor=chr(226).chr(140).chr(139);
        $Rho=chr(206).chr(161);
        $rho=chr(207).chr(129);
        $rlm=chr(226).chr(128).chr(143);
        $rsaquo=chr(226).chr(128).chr(186);
        $rsquo=chr(226).chr(128).chr(153);
        $sbquo=chr(226).chr(128).chr(154);
        $Scaron=chr(197).chr(160);
        $scaron=chr(197).chr(161);
        $sdot=chr(226).chr(139).chr(133);
        #$sect=chr(194).chr(167);
        $shy=chr(194).chr(173);
        $Sigma=chr(206).chr(163);
        $sigma=chr(207).chr(131);
        $sigmaf=chr(207).chr(130);
        $sim=chr(226).chr(136).chr(188);
        $spades=chr(226).chr(153).chr(160);
        $sub=chr(226).chr(138).chr(130);
        $sube=chr(226).chr(138).chr(134);
        $sum=chr(226).chr(136).chr(145);
        $sup1=chr(194).chr(185);
        $sup2=chr(194).chr(178);
        $sup3=chr(194).chr(179);
        $sup=chr(226).chr(138).chr(131);
        $supe=chr(226).chr(138).chr(135);
        $szlig=chr(195).chr(159);
        $Tau=chr(206).chr(164);
        $tau=chr(207).chr(132);
        $there4=chr(226).chr(136).chr(180);
        $Theta=chr(206).chr(152);
        $theta=chr(206).chr(184);
        $thetasym=chr(207).chr(145);
        $thinsp=chr(226).chr(128).chr(137);
        $THORN=chr(195).chr(158);
        $thorn=chr(195).chr(190);
        $tilde=chr(203).chr(156);
        $times=chr(195).chr(151);
        $trade=chr(226).chr(132).chr(162);
        $Uacute=chr(195).chr(154);
        $uacute=chr(195).chr(186);
        $uarr=chr(226).chr(134).chr(145);
        $uArr=chr(226).chr(135).chr(145);
        $Ucirc=chr(195).chr(155);
        $ucirc=chr(195).chr(187);
        $Ugrave=chr(195).chr(153);
        $ugrave=chr(195).chr(185);
        $uml=chr(194).chr(168);
        $upsih=chr(207).chr(146);
        $Upsilon=chr(206).chr(165);
        $upsilon=chr(207).chr(133);
        $Uuml=chr(195).chr(156);
        $uuml=chr(195).chr(188);
        $weierp=chr(226).chr(132).chr(152);
        $Xi=chr(206).chr(158);
        $xi=chr(206).chr(190);
        $Yacute=chr(195).chr(157);
        $yacute=chr(195).chr(189);
        $yen=chr(194).chr(165);
        $yuml=chr(195).chr(191);
        $Yuml=chr(197).chr(184);
        $Zeta=chr(206).chr(150);
        $zeta=chr(206).chr(182);
        $zwj=chr(226).chr(128).chr(141);
        $zwnj=chr(226).chr(128).chr(140);
        #$gt=">";
        #$lt="<";
        $LargeAO = $BaseSwCh.$LargeAOp;
        $SmallAO = $BaseSwCh.$SmallAOp;
        $LargeAU = $BaseSwCh.$LargeAUp;
        $SmallAU = $BaseSwCh.$SmallAUp;
        $LargeOU = $BaseSwCh.$LargeOUp;
        $SmallOU = $BaseSwCh.$SmallOUp;
        $ALLTEXT =~ s/$LargeAO/&#197;/g;
        $ALLTEXT =~ s/$SmallAO/&#229;/g;
        $ALLTEXT =~ s/$LargeAU/&#196;/g;
        $ALLTEXT =~ s/$SmallAU/&#228;/g;
        $ALLTEXT =~ s/$LargeOU/&#214;/g;
        $ALLTEXT =~ s/$SmallOU/&#246;/g;
        $ALLTEXT =~ s/$Aacute/&Aacute;/g;
        $ALLTEXT =~ s/$aacute/&aacute;/g;
        $ALLTEXT =~ s/$Acirc/&Acirc;/g;
        $ALLTEXT =~ s/$acirc/&acirc;/g;
        $ALLTEXT =~ s/$acute/&acute;/g;
        $ALLTEXT =~ s/$AElig/&AElig;/g;
        $ALLTEXT =~ s/$aelig/&aelig;/g;
        $ALLTEXT =~ s/$Agrave/&Agrave;/g;
        $ALLTEXT =~ s/$agrave/&agrave;/g;
        $ALLTEXT =~ s/$alefsym/&alefsym;/g;
        $ALLTEXT =~ s/$Alpha/&Alpha;/g;
        $ALLTEXT =~ s/$alpha/&alpha;/g;
        #$ALLTEXT =~ s/$amp/&amp;/g;
        #$ALLTEXT =~ s/$and/&and;/g;
        #$ALLTEXT =~ s/$ang/&ang;/g;
        $ALLTEXT =~ s/$Aring/&Aring;/g;
        $ALLTEXT =~ s/$aring/&aring;/g;
        $ALLTEXT =~ s/$asymp/&asymp;/g;
        $ALLTEXT =~ s/$Atilde/&Atilde;/g;
        $ALLTEXT =~ s/$atilde/&atilde;/g;
        $ALLTEXT =~ s/$Auml/&Auml;/g;
        $ALLTEXT =~ s/$auml/&auml;/g;
        #$ALLTEXT =~ s/$bdquo/&bdquo;/g;
        $ALLTEXT =~ s/$Beta/&Beta;/g;
        $ALLTEXT =~ s/$beta/&beta;/g;
        $ALLTEXT =~ s/$brvbar/&brvbar;/g;
        $ALLTEXT =~ s/$bull/&bull;/g;
        $ALLTEXT =~ s/$cap/&cap;/g;
        $ALLTEXT =~ s/$Ccedil/&Ccedil;/g;
        $ALLTEXT =~ s/$ccedil/&ccedil;/g;
        $ALLTEXT =~ s/$cedil/&cedil;/g;
        $ALLTEXT =~ s/$cent/&cent;/g;
        $ALLTEXT =~ s/$Chi/&Chi;/g;
        $ALLTEXT =~ s/$chi/&chi;/g;
        $ALLTEXT =~ s/$circ/&circ;/g;
        $ALLTEXT =~ s/$clubs/&clubs;/g;
        $ALLTEXT =~ s/$cong/&cong;/g;
        $ALLTEXT =~ s/$copy/&copy;/g;
        $ALLTEXT =~ s/$crarr/&crarr;/g;
        $ALLTEXT =~ s/$cup/&cup;/g;
        $ALLTEXT =~ s/$curren/&curren;/g;
        $ALLTEXT =~ s/$dagger/&dagger;/g;
        $ALLTEXT =~ s/$Dagger/&Dagger;/g;
        $ALLTEXT =~ s/$darr/&darr;/g;
        $ALLTEXT =~ s/$dArr/&dArr;/g;
        $ALLTEXT =~ s/$deg/&deg;/g;
        $ALLTEXT =~ s/$Delta/&Delta;/g;
        $ALLTEXT =~ s/$delta/&delta;/g;
        $ALLTEXT =~ s/$diams/&diams;/g;
        $ALLTEXT =~ s/$divide/&divide;/g;
        $ALLTEXT =~ s/$Eacute/&Eacute;/g;
        $ALLTEXT =~ s/$eacute/&eacute;/g;
        $ALLTEXT =~ s/$Ecirc/&Ecirc;/g;
        $ALLTEXT =~ s/$ecirc/&ecirc;/g;
        $ALLTEXT =~ s/$Egrave/&Egrave;/g;
        $ALLTEXT =~ s/$egrave/&egrave;/g;
        #$ALLTEXT =~ s/$empty/&empty;/g;
        #$ALLTEXT =~ s/$emsp/&emsp;/g;
        #$ALLTEXT =~ s/$ensp/&ensp;/g;
        $ALLTEXT =~ s/$Epsilon/&Epsilon;/g;
        $ALLTEXT =~ s/$epsilon/&epsilon;/g;
        #$ALLTEXT =~ s/$equiv/&equiv;/g;
        $ALLTEXT =~ s/$Eta/&Eta;/g;
        $ALLTEXT =~ s/$eta/&eta;/g;
        $ALLTEXT =~ s/$ETH/&ETH;/g;
        $ALLTEXT =~ s/$eth/&eth;/g;
        $ALLTEXT =~ s/$Euml/&Euml;/g;
        $ALLTEXT =~ s/$euml/&euml;/g;
        $ALLTEXT =~ s/$euro/&euro;/g;
        #$ALLTEXT =~ s/$exist/&exist;/g;
        #$ALLTEXT =~ s/$fnof/&fnof;/g;
        #$ALLTEXT =~ s/$forall/&forall;/g;
        $ALLTEXT =~ s/$frac12/&frac12;/g;
        $ALLTEXT =~ s/$frac14/&frac14;/g;
        $ALLTEXT =~ s/$frac34/&frac34;/g;
        $ALLTEXT =~ s/$frasl/&frasl;/g;
        $ALLTEXT =~ s/$Gamma/&Gamma;/g;
        $ALLTEXT =~ s/$gamma/&gamma;/g;
        #$ALLTEXT =~ s/$ge/&ge;/g;
        $ALLTEXT =~ s/$harr/&harr;/g;
        $ALLTEXT =~ s/$hArr/&hArr;/g;
        #$ALLTEXT =~ s/$hearts/&hearts;/g;
        #$ALLTEXT =~ s/$hellip/&hellip;/g;
        $ALLTEXT =~ s/$Iacute/&Iacute;/g;
        $ALLTEXT =~ s/$iacute/&iacute;/g;
        $ALLTEXT =~ s/$Icirc/&Icirc;/g;
        $ALLTEXT =~ s/$icirc/&icirc;/g;
        $ALLTEXT =~ s/$iexcl/&iexcl;/g;
        $ALLTEXT =~ s/$Igrave/&Igrave;/g;
        $ALLTEXT =~ s/$igrave/&igrave;/g;
        #$ALLTEXT =~ s/$image/&image;/g;
        $ALLTEXT =~ s/$infin/&infin;/g;
        $ALLTEXT =~ s/$int/&int;/g;
        $ALLTEXT =~ s/$Iota/&Iota;/g;
        $ALLTEXT =~ s/$iota/&iota;/g;
        $ALLTEXT =~ s/$iquest/&iquest;/g;
        $ALLTEXT =~ s/$isin/&isin;/g;
        $ALLTEXT =~ s/$Iuml/&Iuml;/g;
        $ALLTEXT =~ s/$iuml/&iuml;/g;
        $ALLTEXT =~ s/$Kappa/&Kappa;/g;
        $ALLTEXT =~ s/$kappa/&kappa;/g;
        $ALLTEXT =~ s/$Lambda/&Lambda;/g;
        $ALLTEXT =~ s/$lambda/&lambda;/g;
        $ALLTEXT =~ s/$lang/&lang;/g;
        $ALLTEXT =~ s/$laquo/&laquo;/g;
        $ALLTEXT =~ s/$larr/&larr;/g;
        $ALLTEXT =~ s/$lArr/&lArr;/g;
        $ALLTEXT =~ s/$lceil/&lceil;/g;
        $ALLTEXT =~ s/$ldquo/&ldquo;/g;
        $ALLTEXT =~ s/$le/&le;/g;
        $ALLTEXT =~ s/$lfloor/&lfloor;/g;
        $ALLTEXT =~ s/$lowast/&lowast;/g;
        $ALLTEXT =~ s/$loz/&loz;/g;
        $ALLTEXT =~ s/$lrm/&lrm;/g;
        $ALLTEXT =~ s/$lsaquo/&lsaquo;/g;
        $ALLTEXT =~ s/$lsquo/&lsquo;/g;
        $ALLTEXT =~ s/$macr/&macr;/g;
        $ALLTEXT =~ s/$mdash/&mdash;/g;
        $ALLTEXT =~ s/$micro/&micro;/g;
        $ALLTEXT =~ s/$middot/&middot;/g;
        $ALLTEXT =~ s/$minus/&minus;/g;
        $ALLTEXT =~ s/$Mu/&Mu;/g;
        $ALLTEXT =~ s/$mu/&mu;/g;
        $ALLTEXT =~ s/$nabla/&nabla;/g;
        #$ALLTEXT =~ s/$nbsp/&nbsp;/g;
        #$ALLTEXT =~ s/$ndash/&ndash;/g;
        $ALLTEXT =~ s/$ne/&ne;/g;
        $ALLTEXT =~ s/$ni/&ni;/g;
        #$ALLTEXT =~ s/$not/&not;/g;
        #$ALLTEXT =~ s/$notin/&notin;/g;
        #$ALLTEXT =~ s/$nsub/&nsub;/g;
        $ALLTEXT =~ s/$Ntilde/&Ntilde;/g;
        $ALLTEXT =~ s/$ntilde/&ntilde;/g;
        $ALLTEXT =~ s/$Nu/&Nu;/g;
        $ALLTEXT =~ s/$nu/&nu;/g;
        $ALLTEXT =~ s/$Oacute/&Oacute;/g;
        $ALLTEXT =~ s/$oacute/&oacute;/g;
        $ALLTEXT =~ s/$Ocirc/&Ocirc;/g;
        $ALLTEXT =~ s/$ocirc/&ocirc;/g;
        $ALLTEXT =~ s/$OElig/&OElig;/g;
        $ALLTEXT =~ s/$oelig/&oelig;/g;
        $ALLTEXT =~ s/$Ograve/&Ograve;/g;
        $ALLTEXT =~ s/$ograve/&ograve;/g;
        $ALLTEXT =~ s/$oline/&oline;/g;
        $ALLTEXT =~ s/$Omega/&Omega;/g;
        $ALLTEXT =~ s/$omega/&omega;/g;
        $ALLTEXT =~ s/$Omicron/&Omicron;/g;
        $ALLTEXT =~ s/$omicron/&omicron;/g;
        $ALLTEXT =~ s/$oplus/&oplus;/g;
        #$ALLTEXT =~ s/$or/&or;/g;
        $ALLTEXT =~ s/$ordf/&ordf;/g;
        $ALLTEXT =~ s/$ordm/&ordm;/g;
        $ALLTEXT =~ s/$Oslash/&Oslash;/g;
        $ALLTEXT =~ s/$oslash/&oslash;/g;
        $ALLTEXT =~ s/$Otilde/&Otilde;/g;
        $ALLTEXT =~ s/$otilde/&otilde;/g;
        #$ALLTEXT =~ s/$otimes/&otimes;/g;
        $ALLTEXT =~ s/$Ouml/&Ouml;/g;
        $ALLTEXT =~ s/$ouml/&ouml;/g;
        #$ALLTEXT =~ s/$para/&para;/g;
        $ALLTEXT =~ s/$charch/\&\#182\;/g;
        #$ALLTEXT =~ s/$part/&part;/g;
        $ALLTEXT =~ s/$permil/&permil;/g;
        $ALLTEXT =~ s/$perp/&perp;/g;
        $ALLTEXT =~ s/$Phi/&Phi;/g;
        $ALLTEXT =~ s/$phi/&phi;/g;
        $ALLTEXT =~ s/$Pi/&Pi;/g;
        $ALLTEXT =~ s/$pi/&pi;/g;
        #$ALLTEXT =~ s/$piv/&piv;/g;
        #$ALLTEXT =~ s/$plusmn/&plusmn;/g;
        $ALLTEXT =~ s/$pound/&pound;/g;
        $ALLTEXT =~ s/$prime/&prime;/g;
        $ALLTEXT =~ s/$Prime/&Prime;/g;
        $ALLTEXT =~ s/$prod/&prod;/g;
        $ALLTEXT =~ s/$prop/&prop;/g;
        $ALLTEXT =~ s/$Psi/&Psi;/g;
        $ALLTEXT =~ s/$psi/&psi;/g;
        $ALLTEXT =~ s/$radic/&radic;/g;
        $ALLTEXT =~ s/$rang/&rang;/g;
        $ALLTEXT =~ s/$raquo/&raquo;/g;
        $ALLTEXT =~ s/$rarr/&rarr;/g;
        $ALLTEXT =~ s/$rArr/&rArr;/g;
        $ALLTEXT =~ s/$rceil/&rceil;/g;
        $ALLTEXT =~ s/$rdquo/&rdquo;/g;
        $ALLTEXT =~ s/$real/&real;/g;
        $ALLTEXT =~ s/$reg/&reg;/g;
        $ALLTEXT =~ s/$rfloor/&rfloor;/g;
        $ALLTEXT =~ s/$Rho/&Rho;/g;
        $ALLTEXT =~ s/$rho/&rho;/g;
        $ALLTEXT =~ s/$rlm/&rlm;/g;
        $ALLTEXT =~ s/$rsaquo/&rsaquo;/g;
        $ALLTEXT =~ s/$rsquo/&rsquo;/g;
        $ALLTEXT =~ s/$sbquo/&sbquo;/g;
        $ALLTEXT =~ s/$Scaron/&Scaron;/g;
        $ALLTEXT =~ s/$scaron/&scaron;/g;
        $ALLTEXT =~ s/$sdot/&sdot;/g;
        $ALLTEXT =~ s/$sect/&sect;/g;
        $ALLTEXT =~ s/$shy/&shy;/g;
        $ALLTEXT =~ s/$Sigma/&Sigma;/g;
        $ALLTEXT =~ s/$sigma/&sigma;/g;
        $ALLTEXT =~ s/$sigmaf/&sigmaf;/g;
        $ALLTEXT =~ s/$sim/&sim;/g;
        $ALLTEXT =~ s/$spades/&spades;/g;
        $ALLTEXT =~ s/$sub/&sub;/g;
        $ALLTEXT =~ s/$sube/&sube;/g;
        $ALLTEXT =~ s/$sum/&sum;/g;
        $ALLTEXT =~ s/$sup1/&sup1;/g;
        $ALLTEXT =~ s/$sup2/&sup2;/g;
        $ALLTEXT =~ s/$sup3/&sup3;/g;
        $ALLTEXT =~ s/$sup/&sup;/g;
        $ALLTEXT =~ s/$supe/&supe;/g;
        $ALLTEXT =~ s/$szlig/&szlig;/g;
        $ALLTEXT =~ s/$Tau/&Tau;/g;
        $ALLTEXT =~ s/$tau/&tau;/g;
        #$ALLTEXT =~ s/$there4/&there4;/g;
        $ALLTEXT =~ s/$Theta/&Theta;/g;
        $ALLTEXT =~ s/$theta/&theta;/g;
        $ALLTEXT =~ s/$thetasym/&thetasym;/g;
        $ALLTEXT =~ s/$thinsp/&thinsp;/g;
        $ALLTEXT =~ s/$THORN/&THORN;/g;
        $ALLTEXT =~ s/$thorn/&thorn;/g;
        $ALLTEXT =~ s/$tilde/&tilde;/g;
        $ALLTEXT =~ s/$times/&times;/g;
        $ALLTEXT =~ s/$trade/&trade;/g;
        $ALLTEXT =~ s/$Uacute/&Uacute;/g;
        $ALLTEXT =~ s/$uacute/&uacute;/g;
        $ALLTEXT =~ s/$uarr/&uarr;/g;
        $ALLTEXT =~ s/$uArr/&uArr;/g;
        $ALLTEXT =~ s/$Ucirc/&Ucirc;/g;
        $ALLTEXT =~ s/$ucirc/&ucirc;/g;
        $ALLTEXT =~ s/$Ugrave/&Ugrave;/g;
        $ALLTEXT =~ s/$ugrave/&ugrave;/g;
        $ALLTEXT =~ s/$uml/&uml;/g;
        $ALLTEXT =~ s/$upsih/&upsih;/g;
        $ALLTEXT =~ s/$Upsilon/&Upsilon;/g;
        $ALLTEXT =~ s/$upsilon/&upsilon;/g;
        $ALLTEXT =~ s/$Uuml/&Uuml;/g;
        $ALLTEXT =~ s/$uuml/&uuml;/g;
        $ALLTEXT =~ s/$weierp/&weierp;/g;
        $ALLTEXT =~ s/$Xi/&Xi;/g;
        $ALLTEXT =~ s/$xi/&xi;/g;
        $ALLTEXT =~ s/$Yacute/&Yacute;/g;
        $ALLTEXT =~ s/$yacute/&yacute;/g;
        #$ALLTEXT =~ s/$yen/&yen;/g;
        $ALLTEXT =~ s/$yuml/&yuml;/g;
        $ALLTEXT =~ s/$Yuml/&Yuml;/g;
        $ALLTEXT =~ s/$Zeta/&Zeta;/g;
        $ALLTEXT =~ s/$zeta/&zeta;/g;
        $ALLTEXT =~ s/$zwj/&zwj;/g;
        $ALLTEXT =~ s/$zwnj/&zwnj;/g;
        #$ALLTEXT =~ s/$gt/&gt;/g;
        #$ALLTEXT =~ s/$lt/&lt;/g;
     }
  
     #Standardize top margins (remove superfluous paragraph returns on top)
     $ALLTEXT =~ s/\n\n  \n\n<#L><\!-- PARAGRAPH -->\n<BR>//g;
     $ALLTEXT =~ s/<BR>\n<#L>                                     \n<#L>/<BR>\n<#L>/g;
     $ALLTEXT =~ s/<BR>\n<#L> \n\n\<#L><\!-- PARAGRAPH -->\n<BR>/<BR>\n<#L>/g;
     $ALLTEXT =~ s/<BR>\n<#L> \n<#L>/<BR>\n<#L>/g;
     $ALLTEXT =~ s/<BR>\n<#L>\n<#L>/<BR>\n<#L>/g;
     $ALLTEXT =~ s/<BR>\n<#L>\n\n<#L><\!-- PARAGRAPH -->\n<BR>/<BR>\n<#L>/g;
     $ALLTEXT =~ s/<BR>\n<#L>\n\n \n<#L>\n\n      /<BR>\n<#L>/g;
     $ALLTEXT =~ s/<BR>\n<#L>\n\n \n<#L>/<BR>\n<#L>/g;
     $ALLTEXT =~ s/<BR>\n<#L>\n\n \n\n<#L><\!-- PARAGRAPH -->\n<BR>/<BR>\n<#L>/g;
     $ALLTEXT =~ s/<#L><!-- PARAGRAPH -->\n<BR>/<#L>/g;
     $ALLTEXT =~ s/<BR>\n \n <BR>\n<#L>\n \n\n<#L>/<BR><BR><BR>/g;
     $ALLTEXT =~ s/<#L>/<BR>/g;
     $ALLTEXT =~ s/<!-- PARAGRAPH -->\n//g;
     $ALLTEXT =~ s/<!-- PARAGRAPH -->//g;
     $ALLTEXT =~ s/\n \n <BR>\n \n <BR>\n<BR>\n \n\n\n<BR>/<BR><BR><BR>/g;
     $ALLTEXT =~ s/ \n <BR>\n \n <BR>\n<BR>\n \n\n<BR>/\n<BR><BR><BR>\n/g;
     $ALLTEXT =~ s/<BR>\n\n \n<BR>/\n<BR><BR>\n/g;
     $ALLTEXT =~ s/\n \n/\n/g;
     $ALLTEXT =~ s/\n\n\n/\n\n/g;
     $ALLTEXT =~ s/\n<BR>\n/\n<BR><BR>\n/g;
     $ALLTEXT =~ s/ <BR>\n <BR>\n<BR><BR>/<BR><BR><BR>\n/g;
     $ALLTEXT =~ s/\n <BR>\n <BR>\n<BR> /\n<BR><BR><BR>\n/g;
     $ALLTEXT =~ s/\n <BR>\n <BR>\n<BR>/<BR><BR><BR>\n/g;
     $ALLTEXT =~ s/<BR><BR>\n\n<BR><BR>/\n<BR><BR><BR>\n/g;
     $ALLTEXT =~ s/<BR><BR><BR>/<BR><BR>/g;
     $ALLTEXT =~ s/\n\n\n/\n\n/g;
     $ALLTEXT =~ s/\n<BR> \n<BR><BR>\n<BR> \n<BR>/\n<BR><BR>\n/g;
     $ALLTEXT =~ s/\n<BR>\n<BR><BR>\n\n<BR> \n<BR>/\n<BR><BR>\n/g;
     $ALLTEXT =~ s/\n<BR>\n<BR><BR>\n\n<BR><BR>\n<BR>\n<BR> \n<BR>/\n<BR><BR>\n/g;
     $ALLTEXT =~ s/\n<BR><BR>\n<BR>\n<BR> \n<BR>/\n<BR><BR>\n/g;
     $ALLTEXT =~ s/<BR><BR>\n<BR>/<BR><BR>\n/g;
     $ALLTEXT =~ s/<BR><BR>\n\n <BR>/<BR><BR>\n/g;
     $ALLTEXT =~ s/<BR><BR>\n <BR> <BR> /<BR><BR>/g;
     $ALLTEXT =~ s/<\/p>\n<BR>\n<BR><BR>\n /<\/p>\n<BR><BR>\n/;
     $ALLTEXT =~ s/<\/p><BR><BR>/<\/p>\n<BR><BR>/;
     $ALLTEXT =~ s/<\/p>\n\n<BR>\n<BR><BR>\n\n /<\/p>\n<BR><BR>\n/g;
     $ALLTEXT =~ s/ <BR>\n <p class=MsoNormal>\n <BR>\n<BR> /<BR><BR>\n/g;
     $ALLTEXT =~ s/ <BR>\n <p class=MsoNormal>\n <BR>\n<BR><BR>\n<BR> /<BR><BR>\n/g;
     $ALLTEXT =~ s/ <BR>\n <p class=MsoNormal>\n <BR>\n<BR><BR>/<BR><BR>\n/g;
     $ALLTEXT =~ s/<BR><BR>\n<BR>/<BR><BR>\n/g;
     $ALLTEXT =~ s/<BR><BR>\n<BR>/<BR><BR>\n/g;
     $ALLTEXT =~ s/<BR>\n<BR> <BR><BR>/<BR>\n<BR><BR>/;
     $ALLTEXT =~ s/ <\/p>\n <BR>\n <p class=MsoNormal>\n <BR>\n<BR>/<\/p>\n<BR><BR>\n/g;
     $ALLTEXT =~ s/<BR>\n<BR>//g;
     
     #Correct text too much spaces;
     $ALLTEXT =~ s/&nbsp; \!\"/\!\"&nbsp;&nbsp; /g;
     $ALLTEXT =~ s/&nbsp; \?\"/\?\"&nbsp;&nbsp; /g;
     $ALLTEXT =~ s/&nbsp; \;\"/\;\"&nbsp;&nbsp; /g;
     $ALLTEXT =~ s/&nbsp; \:\"/\:\"&nbsp;&nbsp; /g;
     $ALLTEXT =~ s/&nbsp; \.\"/\.\"/g;
     $ALLTEXT =~ s/&nbsp; \!/\!&nbsp;&nbsp; /g;
     $ALLTEXT =~ s/&nbsp; \?/\?&nbsp;&nbsp; /g;
     $ALLTEXT =~ s/&nbsp; \./\./g;
     $ALLTEXT =~ s/&nbsp; \,/\,/g;
     $ALLTEXT =~ s/&nbsp; \)/\)/g;
     $ALLTEXT =~ s/&nbsp; \;/ \; &nbsp;/g;
     $ALLTEXT =~ s/&nbsp; \:/ \: &nbsp;/g;
     
     $ALLTEXT =~ s/ \;\"/\;\"/g;
     $ALLTEXT =~ s/ \:\"/\:\"/g;
     $ALLTEXT =~ s/&nbsp; \"\./\"\./g;
     $ALLTEXT =~ s/&nbsp; \"\,/\"\,/g;
     
     #Correct text too little spaces;
     $ALLTEXT =~ s/\.\-/\.&nbsp;&nbsp; \-/g;
     $ALLTEXT =~ s/\?\-/\?&nbsp;&nbsp; \-/g;
     $ALLTEXT =~ s/\!\-/\!&nbsp;&nbsp; \-/g;
     $ALLTEXT =~ s/\,\-/\,&nbsp;&nbsp; \-/g;
     $ALLTEXT =~ s/\.\.\./\.\.\.&nbsp;/g;
     $ALLTEXT =~ s/\.\.\.&nbsp;\./\.\.\.&nbsp;/g;
     $ALLTEXT =~ s/&nbsp; \"/&nbsp;\"/g;
     $ALLTEXT =~ s/<#F> \"/&nbsp;\"/g;
     $ALLTEXT =~ s/\: &nbsp;\)/\:\)/g;
     $ALLTEXT =~ s/<\! --/<\!--/g;
     $ALLTEXT =~ s/, </,&nbsp;&nbsp; </g;
     $ALLTEXT =~ s/\. /\.&nbsp;&nbsp; /g;
     $ALLTEXT =~ s/&nbsp; /&nbsp; /g;
     
     #Correct spaces before and after Double Quotes (x times because we don't use 'g' option and there can be a few on a page)
     $ALLTEXT =~ s/--> <A/--><A/g;
     $ALLTEXT =~ s/&nbsp;\"/&nbsp;_first_\"/;
     $ALLTEXT =~ s/&nbsp;\"/\"&nbsp;/;
     $ALLTEXT =~ s/&nbsp;\"/&nbsp;_first_\"/;
     $ALLTEXT =~ s/&nbsp;\"/\"&nbsp;/;
     $ALLTEXT =~ s/&nbsp;\"/&nbsp;_first_\"/;
     $ALLTEXT =~ s/&nbsp;\"/\"&nbsp;/;
     $ALLTEXT =~ s/&nbsp;\"/&nbsp;_first_\"/;
     $ALLTEXT =~ s/&nbsp;\"/\"&nbsp;/;
     $ALLTEXT =~ s/&nbsp;\"/&nbsp;_first_\"/;
     $ALLTEXT =~ s/&nbsp;\"/\"&nbsp;/;
     $ALLTEXT =~ s/&nbsp;\"/&nbsp;_first_\"/;
     $ALLTEXT =~ s/&nbsp;\"/\"&nbsp;/;
     $ALLTEXT =~ s/&nbsp;\"/&nbsp;_first_\"/;
     $ALLTEXT =~ s/&nbsp;\"/\"&nbsp;/;
     $ALLTEXT =~ s/&nbsp;\"/&nbsp;_first_\"/;
     $ALLTEXT =~ s/&nbsp;\"/\"&nbsp;/;
     $ALLTEXT =~ s/&nbsp;\"/&nbsp;_first_\"/;
     $ALLTEXT =~ s/&nbsp;\"/\"&nbsp;/;
     $ALLTEXT =~ s/&nbsp;\"/&nbsp;_first_\"/;
     $ALLTEXT =~ s/&nbsp;\"/\"&nbsp;/;
     $ALLTEXT =~ s/&nbsp;\"/&nbsp;_first_\"/;
     $ALLTEXT =~ s/&nbsp;\"/\"&nbsp;/;
     $ALLTEXT =~ s/&nbsp;\"/&nbsp;_first_\"/;
     $ALLTEXT =~ s/&nbsp;\"/\"&nbsp;/;
     $ALLTEXT =~ s/&nbsp;_first_\"/&nbsp;&nbsp;\"/g;
     
     #Correct spaces before and after Single Quotes (x times because we don't use 'g' option and there can be a few on a page)
     $ALLTEXT =~ s/&nbsp;\'/&nbsp;_first_\'/;
     $ALLTEXT =~ s/&nbsp;\'/\'&nbsp;/;
     $ALLTEXT =~ s/&nbsp;\'/&nbsp;_first_\'/;
     $ALLTEXT =~ s/&nbsp;\'/\'&nbsp;/;
     $ALLTEXT =~ s/&nbsp;\'/&nbsp;_first_\'/;
     $ALLTEXT =~ s/&nbsp;\'/\'&nbsp;/;
     $ALLTEXT =~ s/&nbsp;\'/&nbsp;_first_\'/;
     $ALLTEXT =~ s/&nbsp;\'/\'&nbsp;/;
     $ALLTEXT =~ s/&nbsp;\'/&nbsp;_first_\'/;
     $ALLTEXT =~ s/&nbsp;\'/\'&nbsp;/;
     $ALLTEXT =~ s/&nbsp;\'/&nbsp;_first_\'/;
     $ALLTEXT =~ s/&nbsp;\'/\'&nbsp;/;
     $ALLTEXT =~ s/&nbsp;\'/&nbsp;_first_\'/;
     $ALLTEXT =~ s/&nbsp;\'/\'&nbsp;/;
     $ALLTEXT =~ s/&nbsp;\'/&nbsp;_first_\'/;
     $ALLTEXT =~ s/&nbsp;\'/\'&nbsp;/;
     $ALLTEXT =~ s/&nbsp;\'/&nbsp;_first_\'/;
     $ALLTEXT =~ s/&nbsp;\'/\'&nbsp;/;
     $ALLTEXT =~ s/&nbsp;\'/&nbsp;_first_\'/;
     $ALLTEXT =~ s/&nbsp;\'/\'&nbsp;/;
     $ALLTEXT =~ s/&nbsp;\'/&nbsp;_first_\'/;
     $ALLTEXT =~ s/&nbsp;\'/\'&nbsp;/;
     $ALLTEXT =~ s/&nbsp;\'/&nbsp;_first_\'/;
     $ALLTEXT =~ s/&nbsp;\'/\'&nbsp;/;
     $ALLTEXT =~ s/&nbsp;_first_\'/&nbsp;&nbsp;&nbsp;\'/g;
  
     #correct exclamation and question marks apart
     $ALLTEXT =~ s/\? &nbsp;\!/\?\! &nbsp;/g;
     $ALLTEXT =~ s/\! &nbsp;\!/\!\! &nbsp;/g;
     
     #correct hookje left, should attach to next word
     $ALLTEXT =~ s/\(\<\/NOBR\>/\<\/NOBR\>\(/g;
     
     #meer
     $ALLTEXT =~ s/\! &nbsp;/\!&nbsp;/g;
     $ALLTEXT =~ s/;- &/;-&/g;
     
     #various
     $ALLTEXT =~ s/\: &nbsp; <BR><BR>/\: &nbsp; <BR>/g;
     $ALLTEXT =~ s/<\!&nbsp;-- TEXT END OBJECT -->\n<\/P>//g;
     
     #correct final shit
     $ALLTEXT =~ s/  / /g;
     $ALLTEXT =~ s/\.&nbsp;&nbsp; \"/\.\"&nbsp; /g;
     $ALLTEXT =~ s/\.&nbsp;&nbsp; \'/\.\'&nbsp; /g;
     $ALLTEXT =~ s/\!&nbsp;&nbsp; \"/\!\"&nbsp; /g;
     $ALLTEXT =~ s/\!&nbsp;&nbsp; \'/\!\'&nbsp; /g;
     $ALLTEXT =~ s/\?&nbsp;&nbsp; \"/\?\"&nbsp; /g;
     $ALLTEXT =~ s/\?&nbsp;&nbsp; \'/\?\'&nbsp; /g;
     $ALLTEXT =~ s/&nbsp;&nbsp;\" \,&nbsp;&nbsp; /\"\,&nbsp; /g;
     $ALLTEXT =~ s/\, \" /\,\"&nbsp; /g;
     $ALLTEXT =~ s/\>\, \"\¶/\>\,&nbsp; \"\¶/g;
     $ALLTEXT =~ s/\.\.&nbsp;&nbsp; \.&nbsp;&nbsp; /\.\.\.&nbsp;&nbsp; /g;
     $ALLTEXT =~ s/\!\"&nbsp;  \,&nbsp;&nbsp; /\!\"\,&nbsp;&nbsp; /g;
     $ALLTEXT =~ s/\!&nbsp;&nbsp; \! \"/\!\!\"&nbsp;&nbsp; /g;
     
     #Correct spaces before and after Double Quotes (x times because we don't use 'g' option and there can be a few on a page)
     $ALLTEXT =~ s/\"/_first_/;
     $ALLTEXT =~ s/\"/_second_/;
     $ALLTEXT =~ s/\"/_first_/;
     $ALLTEXT =~ s/\"/_second_/;
     $ALLTEXT =~ s/\"/_first_/;
     $ALLTEXT =~ s/\"/_second_/;
     $ALLTEXT =~ s/\"/_first_/;
     $ALLTEXT =~ s/\"/_second_/;
     $ALLTEXT =~ s/\"/_first_/;
     $ALLTEXT =~ s/\"/_second_/;
     $ALLTEXT =~ s/\"/_first_/;
     $ALLTEXT =~ s/\"/_second_/;
     $ALLTEXT =~ s/\"/_first_/;
     $ALLTEXT =~ s/\"/_second_/;
     $ALLTEXT =~ s/\"/_first_/;
     $ALLTEXT =~ s/\"/_second_/;
     $ALLTEXT =~ s/\"/_first_/;
     $ALLTEXT =~ s/\"/_second_/;
     $ALLTEXT =~ s/\"/_first_/;
     $ALLTEXT =~ s/\"/_second_/;
     
     #Correct spaces before and after Double Quotes (x times because we don't use 'g' option and there can be a few on a page)
     $ALLTEXT =~ s/\'/_firstsq_/;
     $ALLTEXT =~ s/\'/_secondsq_/;
     $ALLTEXT =~ s/\'/_firstsq_/;
     $ALLTEXT =~ s/\'/_secondsq_/;
     $ALLTEXT =~ s/\'/_firstsq_/;
     $ALLTEXT =~ s/\'/_secondsq_/;
     $ALLTEXT =~ s/\'/_firstsq_/;
     $ALLTEXT =~ s/\'/_secondsq_/;
     $ALLTEXT =~ s/\'/_firstsq_/;
     $ALLTEXT =~ s/\'/_secondsq_/;
     $ALLTEXT =~ s/\'/_firstsq_/;
     $ALLTEXT =~ s/\'/_secondsq_/;
     $ALLTEXT =~ s/\'/_firstsq_/;
     $ALLTEXT =~ s/\'/_secondsq_/;
     $ALLTEXT =~ s/\'/_firstsq_/;
     $ALLTEXT =~ s/\'/_secondsq_/;
     $ALLTEXT =~ s/\'/_firstsq_/;
     $ALLTEXT =~ s/\'/_secondsq_/;
     $ALLTEXT =~ s/\'/_firstsq_/;
     $ALLTEXT =~ s/\'/_secondsq_/;
     
     # double quotes
     $ALLTEXT =~ s/_first_ /_first_/g;
     $ALLTEXT =~ s/_first_&nbsp;/_first_/g;
     $ALLTEXT =~ s/_first_ /_first_/g;
     $ALLTEXT =~ s/_first_&nbsp;/_first_/g;
     $ALLTEXT =~ s/ _second_/_second_/g;
     $ALLTEXT =~ s/&nbsp;_second_/_second_/g;
     $ALLTEXT =~ s/ _second_/_second_/g;
     $ALLTEXT =~ s/&nbsp;_second_/_second_/g;
     
     $ALLTEXT =~ s/\._first_/\.&nbsp; \"/g;
     $ALLTEXT =~ s/\,_first_/\,&nbsp; \"/g;
     $ALLTEXT =~ s/\!_first_/\!&nbsp; \"/g;
     $ALLTEXT =~ s/\?_first_/\?&nbsp; \"/g;
     $ALLTEXT =~ s/\:_first_/\:&nbsp; \"/g;
     $ALLTEXT =~ s/\;_first_/\;&nbsp; \"/g;
     $ALLTEXT =~ s/_second_ \./\"\.&nbsp; /g;
     $ALLTEXT =~ s/_second_ \,/\"\,&nbsp; /g;
     $ALLTEXT =~ s/_second_ \!/\"\!&nbsp; /g;
     $ALLTEXT =~ s/_second_ \?/\"\?&nbsp; /g;
     $ALLTEXT =~ s/_second_ \:/\"\:&nbsp; /g;
     $ALLTEXT =~ s/_second_ \;/\"\;&nbsp; /g;
     
     # single quotes
     $ALLTEXT =~ s/_firstsq_ /_firstsq_/g;
     $ALLTEXT =~ s/_firstsq_&nbsp;/_firstsq_/g;
     $ALLTEXT =~ s/_firstsq_ /_firstsq_/g;
     $ALLTEXT =~ s/_firstsq_&nbsp;/_firstsq_/g;
     $ALLTEXT =~ s/ _secondsq_/_secondsq_/g;
     $ALLTEXT =~ s/&nbsp;_secondsq_/_secondsq_/g;
     $ALLTEXT =~ s/ _secondsq_/_secondsq_/g;
     $ALLTEXT =~ s/&nbsp;_secondsq_/_secondsq_/g;
     
     $ALLTEXT =~ s/\._firstsq_/\.&nbsp; \'/g;
     $ALLTEXT =~ s/\,_firstsq_/\,&nbsp; \'/g;
     $ALLTEXT =~ s/\!_firstsq_/\!&nbsp; \'/g;
     $ALLTEXT =~ s/\?_firstsq_/\?&nbsp; \'/g;
     $ALLTEXT =~ s/\:_firstsq_/\:&nbsp; \'/g;
     $ALLTEXT =~ s/\;_firstsq_/\;&nbsp; \'/g;
     $ALLTEXT =~ s/_secondsq_ \./\'\.&nbsp; /g;
     $ALLTEXT =~ s/_secondsq_ \,/\'\,&nbsp; /g;
     $ALLTEXT =~ s/_secondsq_ \!/\'\!&nbsp; /g;
     $ALLTEXT =~ s/_secondsq_ \?/\'\?&nbsp; /g;
     $ALLTEXT =~ s/_secondsq_ \:/\'\:&nbsp; /g;
     $ALLTEXT =~ s/_secondsq_ \;/\'\;&nbsp; /g;
     
     $ALLTEXT =~ s/&nbsp;&nbsp;/&nbsp;/g;
     $ALLTEXT =~ s/&nbsp; &nbsp;/&nbsp;/g;
     $ALLTEXT =~ s/&nbsp;&nbsp;/&nbsp;/g;
     $ALLTEXT =~ s/&nbsp; &nbsp;/&nbsp;/g;
     
     $ALLTEXT =~ s/  / /g;
     $ALLTEXT =~ s/  / /g;
     
     $ALLTEXT =~ s/_first_/\"/g;
     $ALLTEXT =~ s/_second_/\"/g;
  
     $ALLTEXT =~ s/_firstsq_/\'/g;
     $ALLTEXT =~ s/_secondsq_/\'/g;
     
     
     # SHIT SINGLE QUOTES WORDEN GEHINDERD DOOR OCCURRENCES LIKE l'es
     $ALLTEXT =~ s/stool\<\/span\>\<\/span\>\.\'\&nbsp\;\&nbsp\;\&nbsp\;\<\/nobr\>/stool\<\/span\>\<\/span\>\.\&nbsp\;\&nbsp\;\&nbsp\;\'\<\/nobr\>/;
     
     
     #FINAL FINAL VERBESSERUNGEN
     $ALLTEXT =~ s/\, \&\#182\;/\,&nbsp;&nbsp; \&\#182\;/g;
     $ALLTEXT =~ s/\, \¶/\,&nbsp;&nbsp;&nbsp; \¶/g;
     $ALLTEXT =~ s/\,&nbsp;&nbsp;\¶/\,&nbsp;&nbsp;&nbsp; \¶/g;
     $ALLTEXT =~ s/\. \,/\.\,/g;
     $ALLTEXT =~ s/ \,/\,/g;
     $ALLTEXT =~ s/\.&nbsp; \,/\.\,/g;
     $ALLTEXT =~ s/\.&nbsp; \./\.\./g;
     $ALLTEXT =~ s/&nbsp; /&nbsp;&nbsp; /g;
     $ALLTEXT =~ s/&nbsp;&nbsp; ' /'&nbsp;&nbsp; /g;
     $ALLTEXT =~ s/&nbsp;&nbsp; -&nbsp;&nbsp; - /&nbsp;&nbsp; --&nbsp;&nbsp /g; 
     
     
     #NEE NU ECHT FINAL FINAL FINAL VERBESSERUNGEN
     $ALLTEXT =~ s/\<\!&nbsp;&nbsp; /\<\!/g;
     
     
     #some html codes don't get right so get them right
     if ($ALLTEXT =~ "<img>") {
       @PICTUREARRAY = split (/<img>|<\/img>/,$ALLTEXT);
       $PICTURENAME = $PICTUREARRAY[1];
     }
     if ($WebsiteOn eq "yes") {
       # for older browsers, use forward slashes
       $ALLTEXT =~ s/<img>/<div id=picpage$NR ALIGN=LEFT style=\"POSITION: relative; width:100%; overflow:visible; \"><img SRC=\"..\/Media\//g;
       #$ALLTEXT =~ s/<\/img>/\" WIDTH=\"100%\" style=\"POSITION: absolute; border-top: 1px solid <<<CELLTOPLEFTCOLOR>>>; border-right: 1px solid <<<CELLBOTTOMRIGHTCOLOR>>>; border-bottom: 1px solid <<<CELLBOTTOMRIGHTCOLOR>>>; border-left: 1px solid <<<CELLTOPLEFTCOLOR>>>;\"><\/div>/g;
       $ALLTEXT =~ s/<\/img>/\" WIDTH=\"100%\" style=\"POSITION: absolute; border: 0px;\"><\/div>/g;
     } else {
       # not for website
       if ($PDFOn ne "yes") {
          # format of pictures and header for HypLern Book
          $ALLTEXT =~ s/<img>/<div id=picpage$NR ALIGN=LEFT style=\"POSITION: relative; width:100%; overflow:visible; \"><img SRC=\"..\\Media\\/g;
          #$ALLTEXT =~ s/<\/img>/\" WIDTH=\"100%\" style=\"POSITION: absolute; border-top: 1px solid <<<CELLTOPLEFTCOLOR>>>; border-right: 1px solid <<<CELLBOTTOMRIGHTCOLOR>>>; border-bottom: 1px solid <<<CELLBOTTOMRIGHTCOLOR>>>; border-left: 1px solid <<<CELLTOPLEFTCOLOR>>>;\"><\/div>/g;
          $ALLTEXT =~ s/<\/img>/\" WIDTH=\"100%\" style=\"POSITION: absolute; border: 0px solid;\"><\/div>/g;
          #if ($ALLTEXT =~ "img") { print $ALLTEXT."\n"; }
       } else {
       	# PDF (simpler, no audio)
          $ALLTEXT =~ s/<\/img>/\" WIDTH=\"500\" HEIGHT=\"500\">/g;
          $ALLTEXT =~ s/<img>/<img SRC=\"..\\Media\\/g;
       }
     }
     
     # remove superfluous enter on first page / title page 
     $ALLTEXT =~ s/<BR><CENTER>/<CENTER>/g;
     $ALLTEXT =~ s/<BR> <CENTER>/<CENTER>/g;
     $ALLTEXT =~ s/<BR><CENTER>/<CENTER>/g;
     
     # remove title bar on first page
     if ($PageNumber == 1) {
        $FirstLineBlah = substr($ALLTEXT,100) ;
        if ($TRACING eq "ON") {
          print "FIRST LINE BLA!!!!\n";
          print $FirstLineBlah;
          print "END OF FIRST LINE BLA!!!!\n";
        } else { print ".";}
     }
     
     if ($PDFOn eq "yes") {
     	# FIX SPACES IN PDF
     	$ALLTEXT =~ s/\_\_\_\</\&nbsp\;\&nbsp\;\&nbsp\;\</g;
     	$ALLTEXT =~ s/\_\_\</\&nbsp\;\&nbsp\;\&nbsp\;\</g;
     	$ALLTEXT =~ s/\_\</\&nbsp\;\</g;
     	$ALLTEXT =~ s/\&nbsp\;\_\_\_/\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;/g;
     	$ALLTEXT =~ s/\&nbsp\;\_\_/\&nbsp\;\&nbsp\;\&nbsp\;/g;
     	$ALLTEXT =~ s/\&nbsp\;\_/\&nbsp\;\&nbsp\;/g;
     	$ALLTEXT =~ s/\>\_\_\_/\>\&nbsp\;\&nbsp\;\&nbsp\;/g;
     	$ALLTEXT =~ s/\>\_\_/\>\&nbsp\;\&nbsp\;/g;
     	$ALLTEXT =~ s/\>\_/\>\&nbsp\;/g;
     	$ALLTEXT =~ s/\&nbsp\;\<REMSPC_\>//g;
     	$ALLTEXT =~ s/\&nbsp\;\&nbsp\;\<REMSPC__\>//g;
     	$ALLTEXT =~ s/\&nbsp\;\<REMSPC__\>//g;
     	$ALLTEXT =~ s/\&nbsp\;\&nbsp\;\&nbsp\;\<REMSPC___\>//g;
     	$ALLTEXT =~ s/\&nbsp\;\&nbsp\;\<REMSPC___\>//g;
     	$ALLTEXT =~ s/\&nbsp\;\<REMSPC___\>//g;
     	$ALLTEXT =~ s/\<MINISPACEBLOCK\>\<REMSPC_\>//g;
     	$ALLTEXT =~ s/\<MINISPACEBLOCK\>\<MINISPACEBLOCK\>\<REMSPC__\>//g;
     	$ALLTEXT =~ s/\<MINISPACEBLOCK\>\<MINISPACEBLOCK\>\<MINISPACEBLOCK\>\<REMSPC___\>//g;
     	if ($ALLTEXT =~ "pressing") {
     		print $ALLTEXT;
        }
     } else {
     	$ALLTEXT =~ s/\_\_\_\</\</g;
     	$ALLTEXT =~ s/\_\_\</\</g;
     	$ALLTEXT =~ s/\_\</\</g;
     	$ALLTEXT =~ s/\&nbsp\;\_\_\_/\&nbsp\;/g;
     	$ALLTEXT =~ s/\&nbsp\;\_\_/\&nbsp\;/g;
     	$ALLTEXT =~ s/\&nbsp\;\_/\&nbsp\;/g;
     	$ALLTEXT =~ s/\>\_\_\_/\&nbsp\;/g;
     	$ALLTEXT =~ s/\>\_\_/\&nbsp\;/g;
     	$ALLTEXT =~ s/\>\_/\&nbsp\;/g;
     	$ALLTEXT =~ s/\&nbsp\;\<REMSPC_\>/\&nbsp\;/g;
     	$ALLTEXT =~ s/\&nbsp\;\<REMSPC__\>/\&nbsp\;/g;
     	$ALLTEXT =~ s/\&nbsp\;\<REMSPC___\>/\&nbsp\;/g;
     	$ALLTEXT =~ s/\<REMSPC_\>//g;
     	$ALLTEXT =~ s/\<REMSPC__\>//g;
     	$ALLTEXT =~ s/\<REMSPC___\>//g;
     }
     $FORMATTEDTEXT = $ALLTEXT ;
     $LASTNR = $PageNumber ;
     $SpaceReplace = "¯";
     #dingen parseable maken
     $ALLTEXT =~ s/&nbsp;/$SpaceReplace/g;
     $ALLTEXT =~ s/&#182;/¶/g;
  
     #translate help, information and messaging
     $MessagingTranslationFile = "..\\Base\\Parse\\Main\\Messages.htm" ;
     open (MESSTRANS, "<$MessagingTranslationFile") || die "file $MessagingTranslationFile kan niet worden gevonden, ($!)\n";
     @MessTransEntries = <MESSTRANS>;
     close MESSTRANS;
     if ($TRACING eq "ON") {
       print "To internationalise information, help and other messaging, change all occurrences of:\n";
     } else { print ".";}
     foreach $MessTransEntry (@MessTransEntries)
     {
        @MessTransLine = split(/#/,$MessTransEntry);
        $MessGrep = $MessTransLine[0];
        $MessChange = $MessTransLine[$TLN];
        if ($ALLTEXT =~ $MessGrep)
        {
           $ALLTEXT =~ s/$MessGrep/$MessChange/g;
           if ($TRACING eq "ON") {
             print "$MessTransLine[0] to $MessTransLine[$TLN]\n";
           } else { print ".";}
        }
     }
  
     #########################################################################
     ##
     ##  END OF SOFTWARE E-BOOK WRITING (HYPLERN.EXE -> <LANGUAGE>-<GROUP>.EXE FILE ON USB STICK)
     ##
     #########################################################################
     # WRITE FILE 
     #
  
     # remove first page header but add <BR><BR> (this doesn't work anymore, as it is now in base language) PLUS ONLY DO THIS ON FIRST PAGE
     #$ALLTEXT =~ s/\¶A1\¶BTitle \& Contents<\/p>/<BR><BR><BR>/g;
       
     if ( ($CurrentShortFile == 1) ) {
       $SECONDCHAPTERPAGENUMBER = $SECONDCHAPTERPAGENUMBER + 1;
       if ($SECONDCHAPTERPAGENUMBER == 3) {
         $FIRSTPAGETEXTSAVEDFORHELP = $ALLTEXT;
       }
     }
     # make sure you save the page to a total of pages string so you can later get this pagenumber using basic wordcode
     $TOTALOFPAGESSTRING = $TOTALOFPAGESSTRING.$ALLTEXT;
     
     if ($AUDIOEXISTS eq "yes") {
        $AUDIOINCLUDED = " with audio and ";
        $AUDIOINCLUDEDDUTCH = " met audio en ";
        $LISTENTO = " and listen to ";
        $LISTENTODUTCH = " en luister naar ";
        $AUDIOLISTEN = " and listening ";
        $AUDIOLISTENDUTCH = " en luisteren ";
     }
  
     if ($DEMOWANTED eq "TRUE") {
       if ($TranToLanguage eq "English") {
         # replace <DEMOADCODE> with the demo ad code
         if ($APPOn ne "yes" ) {
           $DEMOADCODESTRING = "Find the whole story on:<br><br>";
           $DEMOADCODESTRING = $DEMOADCODESTRING."<strong><a class=buyblue href='https://www.learn-to-read-foreign-languages.com' title='Bermuda Word Shop' target='_blank' >LEARN-TO-READ-FOREIGN-LANGUAGES.COM</a></strong><br><br>";
         } else {
           $DEMOADCODESTRING = "Find the whole story in the full App here in the <strong><a class=buyblue href='".$PROVIDERSITE."' title='$PROVIDER' target='_blank' >".$PROVIDER." !</a></strong>";
           $DEMOADCODESTRING = $DEMOADCODESTRING."<br><br>";
         }
         if ($PDFOn eq "yes") {
            if ($APPOn ne "yes") {
              # only for PDF
              $DEMOADCODESTRING = $DEMOADCODESTRING."<span style='text'>Read $Language stories with interlinear translation on your computer, smartphone or tablet. ";
              $DEMOADCODESTRING = $DEMOADCODESTRING."Or get the e-book $AUDIOINCLUDED pop-up translation using the Bermuda Word App from our site learn-to-read-foreign-languages.com. This adds word practice using spaced repetition, ";
              $DEMOADCODESTRING = $DEMOADCODESTRING."to teach you $Language reading $AUDIOLISTEN by growing your vocabulary fast and easy!<br>";
            } else {
              $DEMOADCODESTRING = $DEMOADCODESTRING."<span style='text'>Read $Language stories with interlinear or pop-up translation on your computer, smartphone or tablet. ";
              $DEMOADCODESTRING = $DEMOADCODESTRING."You learn common words just by reading, and for more difficult words the App adds word practice using spaced repetition, ";
              $DEMOADCODESTRING = $DEMOADCODESTRING."to teach you $Language reading $AUDIOLISTEN by growing your vocabulary fast and easy!<br>";
            }
         }
         $DEMOADCODESTRING = $DEMOADCODESTRING."<ul><li><strong>Perfect your $Language reading $AUDIOLISTEN</strong></li>";
         $DEMOADCODESTRING = $DEMOADCODESTRING."<li><strong>Beginners and advanced students</strong></li>";
         $DEMOADCODESTRING = $DEMOADCODESTRING."<li><strong>Learn thousands of new words just by reading</strong></li>";
         $DEMOADCODESTRING = $DEMOADCODESTRING."<li><strong>The spaced repetition software will make sure you remember them!</strong></li></ul>";
         if ($WebsiteOn eq "yes") {
           $DEMOADCODESTRING = $DEMOADCODESTRING."<strong>Read $LISTENTO</strong> $Language stories by $Language authors <strong>in $Language</strong> with an automatic <strong>pop-up translation in context</strong>. ";
           $DEMOADCODESTRING = $DEMOADCODESTRING."The software will help you <strong>learn new words fast</strong> and <strong>remember them</strong>. ";
           $DEMOADCODESTRING = $DEMOADCODESTRING."So go through the book freely and learn while reading. ";
           $DEMOADCODESTRING = $DEMOADCODESTRING."Or let the program guide you through the chapters and have you<strong> test each unknown word</strong> the number of times required to <strong>retain them in your memory</strong>. ";
           $DEMOADCODESTRING = $DEMOADCODESTRING."This way you will assimilate an advanced vocabulary <strong>fast and easy</strong>.</span>";
         }
         $ALLTEXT =~ s/<DEMOADCODE>/$DEMOADCODESTRING/;
       }
       if ($TranToLanguage eq "Dutch") {
         #This one is for the demo ad page
         $DEMOADCODESTRING = "Vind het hele verhaal op:<br><br>";
         $DEMOADCODESTRING = $DEMOADCODESTRING."<strong><a class=buyblue href='https://www.learn-to-read-foreign-languages.com' title='Bermuda Word Shop' target='_blank' >LEARN-TO-READ-FOREIGN-LANGUAGES.COM</a></strong><br><br>";
         if ($PDFOn eq "yes") {
            $DEMOADCODESTRING = $DEMOADCODESTRING."<span style='text'>Lees $LanguageDutchBVN verhalen met interlinear vertaling op je iPhone, iPad, Android smartphone of Tablet. ";
            $DEMOADCODESTRING = $DEMOADCODESTRING."Of lees de versie van het e-book $AUDIOINCLUDEDDUTCH pop-up vertaling met de Bermuda Word App van onze site learn-to-read-foreign-languages.com. ";
            $DEMOADCODESTRING = $DEMOADCODESTRING." Inclusief woordoefeningen met zelf instelbaar interval, ";
         }
         $DEMOADCODESTRING = $DEMOADCODESTRING."om je $LanguageDutch lezen $AUDIOLISTENDUTCH te leren door snel en gemakkelijk je woordenschat te vergroten!<br>";
         $DEMOADCODESTRING = $DEMOADCODESTRING."<ul><li><strong>Leer vloeiend in $LanguageDutch lezen $AUDIOLISTENDUTCH</strong></li>";
         $DEMOADCODESTRING = $DEMOADCODESTRING."<li><strong>Voor beginners en gevorderden</strong></li>";
         $DEMOADCODESTRING = $DEMOADCODESTRING."<li><strong>Leer honderden nieuwe woorden</strong></li>";
         $DEMOADCODESTRING = $DEMOADCODESTRING."<li><strong>De herhaling met interval zorgt ervoor dat je ze onthoudt!</strong></li></ul>";
         if ($WebsiteOn eq "yes") {
           $DEMOADCODESTRING = $DEMOADCODESTRING."<p><strong>Lees $LISTENTODUTCH</strong> $LanguageDutchBVN verhalen door $LanguageDutchBVN auteurs <strong>in $LanguageDutch</strong> met een automatische <strong>pop-up vertaling in context</strong>. ";
           $DEMOADCODESTRING = $DEMOADCODESTRING."De software helpt je <strong>snel nieuwe woorden te leren</strong> en <strong>ze te onthouden</strong>. ";
           $DEMOADCODESTRING = $DEMOADCODESTRING."Dus lees het e-book vrij en leer terwijl je leest. ";
           $DEMOADCODESTRING = $DEMOADCODESTRING."Of laat het programma je door de hoofdstukken leiden en je<strong> elk nieuw woord laten testen</strong> het aantal keren benodigd om <strong>ze te onthouden</strong>. ";
           $DEMOADCODESTRING = $DEMOADCODESTRING."Op deze manier assimileer je een gevorderde woordenschat <strong>snel en gemakkelijk</strong>.</p>";
         }
         $ALLTEXT =~ s/<DEMOADCODE>/$DEMOADCODESTRING/;
       }
       $ALLTEXT =~ s/<\/p>\n <BR>/<BR><BR>\n/g;
     }
     $ALLTEXT =~ s/<\/P>\n<BR><BR>/\n<BR><BR>\n/g;
  
     if ($PDFOn ne "yes" && $WebSiteOn ne "yes") {
       # write page
       $WriteFile = "..\\..\\Languages\\$Language\\HTML\\".$Group."\\Course$filepart$NR.htm" ;
       if ($TRACING eq "ON") {
         print "Creating File $WriteFile...\n" ;
       } else { print ".";}
       open (WRITEFILE, ">$WriteFile") || die "file $WriteFile kan niet worden aangemaakt, ($!)\n";
       print WRITEFILE $ALLTEXT ;
       close (WRITEFILE);
     }
  
     ##########################################################################
     # IF OPTION CREATE PDF IS ON:
     # Create pdf pages, use the following string per word original-meaning pair:
     #"<a href="http://www.bermudaword.com/is/dit/=/this"><font color="white" size="1">i:</font>Dit</a>"
     # and use the following string to separate pages:
     #"<br clear=all style='mso-special-character:line-break;page-break-before:always'>"
     
     if ($TRACING eq "ON") {
       print "Checking whether PDFOn equals 'yes' and current story equals '$PDFStory' or All (Current is $CurrentChapterKey)...\n";
     } else { print ".";}
     
     if ( $PDFOn eq "yes" && ( $PDFStory =~ $CurrentChapterKey || $PDFStory eq "All" || $PDFStory eq "all" ) )
     {
       # Skip this page if there are neither words (=links) nor images on it
       if ( $ALLTEXT !~ "href\=\'http" && $ALLTEXT !~ "span" && $ALLTEXT !~ "img" && $ALLTEXT !~ "l1" && $PRINTVERSION ne "yes" ) {
         next;
       }
          
       $SitePageNumber = $SitePageNumber + 1 ;
       if ($TRACING eq "ON") {
         print "PDF Creation is 'On', PDFStory within '$PDFStory'... Printing this page to pdf...\n";
       } else { print ".";}
     
       $ALLTEXT =~ s/<LASTFORMATTEDTEXT>//;
       $ALLTEXT =~ s/<FORMATTEDTEXT>//;
       $ALLTEXT =~ s/$SpaceReplace/&nbsp;/g;
       $ALLTEXT =~ s/¶A/<BR><p class=atxt>/g ;
       $ALLTEXT =~ s/¶B/&nbsp;&nbsp;&nbsp;&nbsp;/g ;
       $ALLTEXT =~ s/\<\!\&nbsp\;\&nbsp\; \-\- TEXT END OBJECT \-\-\>//g;
       $ALLTEXT =~ s/<\/NOBR> '>/ '>/g;
       $ALLTEXT =~ s/\/=\/<NOBR>/\/=\//g;
       $ALLTEXT =~ s/<<<LANGUAGE>>>/$Language/g;
       #$ALLTEXT =~ s/\<BR\>\(/\&nbsp\;\(/g;
       if ($Language ne "Urdu") {
         $ALLTEXT =~ s/<TEXTALIGN_DEF_JUSTIFY>/justify/g;
         $ALLTEXT =~ s/<FONTSIZE_DEF_12PT>/8pt/g;
         $ALLTEXT =~ s/<LINEHEIGHT_DEF_13PT>/9pt/g;
       } else {
         $ALLTEXT =~ s/<TEXTALIGN_DEF_JUSTIFY>/right/g;
         $ALLTEXT =~ s/<FONTSIZE_DEF_12PT>/18pt/g;
         $ALLTEXT =~ s/<LINEHEIGHT_DEF_13PT>/25pt/g;
       }
       
           
      $ALLTEXT =~ s/\&nbsp\;\&nbsp\; /\&nbsp\;\&nbsp\;\&nbsp\;\<\/NOBR\> /ig;
      $ALLTEXT =~ s/\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\<\/NOBR\> /\&nbsp\;\&nbsp\;\&nbsp\;\<\/NOBR\> /ig;
  
      $ALLTEXT =~ s/ HEIGHT\=\"500\"//g;
      $ALLTEXT =~ s/<BR><BR>\(/<BR>\(/g;
      $ALLTEXT =~ s/\{/\(/g;
      $ALLTEXT =~ s/\}/\)/g;
  
      $ALLTEXT =~ s/\&nbsp\;\&nbsp\;\&nbsp\;\<\/NOBR\> \'\;/\'\;\&nbsp\;\&nbsp\;\&nbsp\;\<\/NOBR\> /ig;
      $ALLTEXT =~ s/\<\/span\>\, \"\<NOBR\>/\<\/span\>\,\&nbsp\;\&nbsp\;\&nbsp\;\<\/NOBR\> \<NOBR\>\"/ig;
      $ALLTEXT =~ s/\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\<\/NOBR\> \'\;/\'\;\&nbsp\;\&nbsp\;\&nbsp\;\<\/NOBR\> /ig;
      $ALLTEXT =~ s/\<\/span\> \: \"\<NOBR\>/\<\/span\>\:\&nbsp\;\&nbsp\;\&nbsp\;\<\/NOBR\> \<NOBR\>\"/ig;
      $ALLTEXT =~ s/\<\/span\> \: \'\<NOBR\>/\<\/span\>\:\&nbsp\;\&nbsp\;\&nbsp\;\<\/NOBR\> \<NOBR\>\'/ig;
      $ALLTEXT =~ s/\<\/span\> \: \&nbsp\;\&nbsp\;\&nbsp\;\<\/NOBR\>/\<\/span\>\:\&nbsp\;\&nbsp\;\&nbsp\;\<\/NOBR\>/ig;
      $ALLTEXT =~ s/\<\/span\> \: \&nbsp\;\<BR\>/\<\/span\>\:\&nbsp\;\&nbsp\;\&nbsp\;\<\/NOBR\>\<BR\>/ig;
      $ALLTEXT =~ s/\<\/span\> \; \"\<NOBR\>/\<\/span\>\;\&nbsp\;\&nbsp\;\&nbsp\;\<\/NOBR\> \<NOBR\>\"/ig;
      $ALLTEXT =~ s/\<\/span\> \; \'\<NOBR\>/\<\/span\>\;\&nbsp\;\&nbsp\;\&nbsp\;\<\/NOBR\> \<NOBR\>\'/ig;
      $ALLTEXT =~ s/\<\/span\> \; \&nbsp\;\&nbsp\;\&nbsp\;\<\/NOBR\>/\<\/span\>\;\&nbsp\;\&nbsp\;\&nbsp\;\<\/NOBR\>/ig;
      $ALLTEXT =~ s/\<\/span\> \; \&nbsp\;\<BR\>/\<\/span\>\;\&nbsp\;\&nbsp\;\&nbsp\;\<\/NOBR\>\<BR\>/ig;
      $ALLTEXT =~ s/\<\/span\>\.\' \<NOBR\>/\<\/span\>\.\'\&nbsp\;\&nbsp\;\&nbsp\;\<\/NOBR\> \<NOBR\>/ig;
      
      
      $ALLTEXT =~ s/\<\/span\> \:\"\&nbsp\;\<BR\>/\<\/span\>\:\"\&nbsp\;\<BR\>/ig;
      $ALLTEXT =~ s/\<\/span\> \;\"\&nbsp\;\<BR\>/\<\/span\>\;\"\&nbsp\;\<BR\>/ig;
      
      $ALLTEXT =~ s/\<\/span\> \; \"\<BR\>/\<\/span\>\;\"\&nbsp\;\<BR\>/ig;
      
      $ALLTEXT =~ s/\.\&nbsp\;\&nbsp\;\&nbsp\;\<\/NOBR\> \"\<\/I\>/\.\"\<\/I\>\<\/NOBR\>\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;/ig;
      
      $ALLTEXT =~ s/\"\&nbsp\;\&nbsp\;\&nbsp\;\<\/NOBR\> \./\.\"\&nbsp\;\&nbsp\;\&nbsp\;\<\/NOBR\> /g;
      
      $ALLTEXT =~ s/\&nbsp\;\)/\)/g;
      
      $ALLTEXT =~ s/<MINISPACEBLOCK>/\&nbsp\;/g;
  
      $ALLTEXT =~ s/<SPACEBLOCK>\&nbsp\;/\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;/ig;
      $ALLTEXT =~ s/<SPACEBLOCK>\,\&nbsp\;/\,\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;/ig;
      $ALLTEXT =~ s/<SPACEBLOCK>\,\"\&nbsp\;/\,\"\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;/ig;
      $ALLTEXT =~ s/<SPACEBLOCK>\,\'\&nbsp\;/\,\'\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;/ig;
      $ALLTEXT =~ s/<SPACEBLOCK>\.\&nbsp\;/\.\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;/ig;
      $ALLTEXT =~ s/<SPACEBLOCK>\.\"\&nbsp\;/\.\"\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;/ig;
      $ALLTEXT =~ s/<SPACEBLOCK>\.\'\&nbsp\;/\.\'\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;/ig;
      $ALLTEXT =~ s/<SPACEBLOCK>\:\&nbsp\;/\:\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;/ig;
      $ALLTEXT =~ s/<SPACEBLOCK>\:\"\&nbsp\;/\:\"\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;/ig;
      $ALLTEXT =~ s/<SPACEBLOCK>\:\'\&nbsp\;/\:\'\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;/ig;
      $ALLTEXT =~ s/<SPACEBLOCK>\;\&nbsp\;/\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;/ig;
      $ALLTEXT =~ s/<SPACEBLOCK>\;\"\&nbsp\;/\;\"\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;/ig;
      $ALLTEXT =~ s/<SPACEBLOCK>\;\'\&nbsp\;/\;\'\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;/ig;
      $ALLTEXT =~ s/<SPACEBLOCK>\"\&nbsp\;/\"\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;/ig;
      $ALLTEXT =~ s/<SPACEBLOCK>\'\&nbsp\;/\'\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;/ig;
  
  
  
      $ALLTEXT =~ s/<BIGSPACEBLOCK>\&nbsp\;/\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;/ig;
      $ALLTEXT =~ s/<BIGSPACEBLOCK>\,\&nbsp\;/\,\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;/ig;
      $ALLTEXT =~ s/<BIGSPACEBLOCK>\,\"\&nbsp\;/\,\"\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;/ig;
      $ALLTEXT =~ s/<BIGSPACEBLOCK>\,\'\&nbsp\;/\,\'\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;/ig;
      $ALLTEXT =~ s/<BIGSPACEBLOCK>\.\&nbsp\;/\.\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;/ig;
      $ALLTEXT =~ s/<BIGSPACEBLOCK>\.\"\&nbsp\;/\.\"\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;/ig;
      $ALLTEXT =~ s/<BIGSPACEBLOCK>\.\'\&nbsp\;/\.\'\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;/ig;
      $ALLTEXT =~ s/<BIGSPACEBLOCK>\:\&nbsp\;/\:\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;/ig;
      $ALLTEXT =~ s/<BIGSPACEBLOCK>\:\"\&nbsp\;/\:\"\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;/ig;
      $ALLTEXT =~ s/<BIGSPACEBLOCK>\:\'\&nbsp\;/\:\'\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;/ig;
      $ALLTEXT =~ s/<BIGSPACEBLOCK>\;\&nbsp\;/\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;/ig;
      $ALLTEXT =~ s/<BIGSPACEBLOCK>\;\"\&nbsp\;/\;\"\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;/ig;
      $ALLTEXT =~ s/<BIGSPACEBLOCK>\;\'\&nbsp\;/\;\'\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;/ig;
      $ALLTEXT =~ s/<BIGSPACEBLOCK>\"\&nbsp\;/\"\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;/ig;
      $ALLTEXT =~ s/<BIGSPACEBLOCK>\'\&nbsp\;/\'\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;/ig;
  
  
      # exceptin for . , at abbreviations
      $ALLTEXT =~ s/\.\&nbsp\;\,\&nbsp\;\&nbsp\;\&nbsp\;/\.\,\&nbsp\;\&nbsp\;\&nbsp\;/g;
  
  
      #for those FN spots where you need the text to shift a little bit to push a word to the next line
      $ALLTEXT =~ s/<FNSPACEBLOCK6>/\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;/g;
      $ALLTEXT =~ s/<FNSPACEBLOCK7>/\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;/g;
      $ALLTEXT =~ s/<FNSPACEBLOCK8>/\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;/g;
      $ALLTEXT =~ s/<FNSPACEBLOCK9>/\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;/g;
  
  
  
     # SHIT SINGLE QUOTES WORDEN GEHINDERD DOOR OCCURRENCES LIKE l'es
     $ALLTEXT =~ s/stool\<\/span\>\<\/span\>\.\'\&nbsp\;\&nbsp\;\&nbsp\;\<\/nobr\>/stool\<\/span\>\<\/span\>\.\&nbsp\;\&nbsp\;\&nbsp\;\'\<\/nobr\>/;
  
  
  
  
     # beautification of word groups with single spaces (need to be splayed a bit)
  
     $ALLTEXT =~ s/\<span class\=\'main\'\>(\w+)\s/\<span class\=\"main\"\>$1&nbsp;&nbsp;&nbsp;/g;
     
     $ALLTEXT =~ s/(\w+)\s(\w+)\<\/span\>\<span class\=\'int\'\>/$1&nbsp;&nbsp;&nbsp;$2\<\/span\>\<span class\=\'int\'\>/g;
     $ALLTEXT =~ s/class\=\'main\'\>(\w+)\s(\w+)/class\=\"main\"\>$1&nbsp;&nbsp;&nbsp;$2/g;
     $ALLTEXT =~ s/class\=\'main\'\>&#224; l/class\=\"main\"\>&#224;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;l/g;
  
      #$ALLTEXT =~ s/\<\/span\>\.\' \<NOBR\>/\<\/span\>\.\'\&nbsp\;\&nbsp\;\&nbsp\;\<\/NOBR\> \<NOBR\>/ig;
      
      # make sure all pictures have one <br> above them
      $ALLTEXT =~ s/\<\/p\>\n \<CENTER\>\<img/\<\/p\>\n \<BR\> \<CENTER\>\<img/ig;
      
      # last NOBR
      $ALLTEXT =~ s/\<\/span\>\.\<BR\>/\<\/span\>\.\<\/NOBR\>\<BR\>/g;
      $ALLTEXT =~ s/\<\/span\>\.\"\<BR\>/\<\/span\>\.\"\<\/NOBR\>\<BR\>/g;
      
      # missing NOBR
      $ALLTEXT =~ s/\<\/span\> \: /\<\/span\>\:\<\/NOBR\>/g;
      
      # rommel voor Georgian en Russian
      if ($Language eq "Russian" || $Language eq "Georgian") {
        $ALLTEXT =~ s/\&\#123\;/\<BR\>\&\#123\;/g;
      }
      
      # cursief leestekens correct
      $ALLTEXT =~ s/\<\/span\>\&nbsp\;\&nbsp\;\&nbsp\;\<\/NOBR\> \<\/\I\> \.\"/\<\/span\>\<\/\I\>\.\"\<\/NOBR\>/ig;
      $ALLTEXT =~ s/\<\/span\>\&nbsp\;\&nbsp\;\&nbsp\;\<\/NOBR\> \<\/I\>\,\&nbsp\;\&nbsp\;\&nbsp\;\<\/NOBR\>/\<\/span\>\<\/I\>\,\&nbsp\;\&nbsp\;\&nbsp\;\<\/NOBR\>/ig;
      $ALLTEXT =~ s/\<\/span\>\&nbsp\;\&nbsp\;\&nbsp\;\<\/NOBR\> \<\/I\>\:\"\<BR\>/\<\/span\>\<\/I\>\:\"\<\/NOBR\>\<BR\>/ig;
  
      # generic muck
      $ALLTEXT =~ s/\<\/span\>\&nbsp\;\&nbsp\;\&nbsp\;\<\/NOBR\> \'\,\&nbsp\;\&nbsp\;\&nbsp\;\<\/NOBR\>/\<\/span\>\'\,\&nbsp\;\&nbsp\;\&nbsp\;\<\/NOBR\>/ig;
  
      if ($PDFOn eq "yes") {
        # Indien plaatje
        if ($ALLTEXT =~ "img SRC") {
          # get picture
          if ($PICTURENAME !~ "182") {
            #print $PICTURENAME."\n";
            if ($PICTURENAME =~ "Earpic") {
              `copy ..\\..\\Site\\Pics\\$PICTURENAME ..\\..\\Pdf\\$Language\\Pics`;
            } else {
              `copy ..\\Base\\Media\\$Language\\$Group\\$PICTURENAME ..\\..\\Pdf\\$Language\\Pics`;
            }
            $ALLTEXT =~ s/..\\Media/Pics/g;
          }
        }
      }
        
       # International Messaging
       #translate help, information and messaging
       $MessagingTranslationFile = "..\\Base\\Parse\\Main\\Messages.htm" ;
       open (MESSTRANS, "<$MessagingTranslationFile") || die "file $MessagingTranslationFile kan niet worden gevonden, ($!)\n";
       @MessTransEntries = <MESSTRANS>;
       close MESSTRANS;
       if ($TRACING eq "ON") {
         print "To internationalise information, help and other messaging, change all occurrences of:\n";
       } else { print ".";}
       foreach $MessTransEntry (@MessTransEntries)
       {
         if ($MessTransEntry !~ "BASE VALUE") {
           @MessTransLine = split(/#/,$MessTransEntry);
           $MessGrep = $MessTransLine[0];
           $MessChange = $MessTransLine[$TLN];
           if ($ALLTEXT =~ $MessGrep)
           {
             $ALLTEXT =~ s/$MessGrep/$MessChange/g;
             if ($TRACING eq "ON") {
               print "$MessTransLine[0] to $MessTransLine[$TLN]\n";
             } else { print ".";}
           }
         }
       }
  
       # save pagefile into site directory
       $lclanguageto=lc($TranToLanguage);
       $LASTNR=$PageNumber-1; # now write file if not page 0
       $NEXTNR=$PageNumber+1;
       $BEFORELASTNR=$LASTNR-1;
       # links MET plaatje moet zo worden: <DIV align='right'>Puccettino - La Familia Degli Taglialegni&nbsp;&nbsp;&nbsp;&nbsp;65</DIV>
       
       # WAARSCHUWING MOCHT JE NOG AAN PDF'S WERKEN, <<<LOBBY>>> BESTAAT NIET!?!?!? wordt verwisseld met <<<CHAPTERNAME>>> maar die bestaat namelijk niet!?? Of alleen in originele files ofzo?
       
       if ($ALLTEXTPAGELEFT =~ "picpage") {
         $ALLTEXT =~ s/$LASTNR<<<KOBIEWANKENOBIE>>>/$TopRightChapterName/;
         $ALLTEXT =~ s/<<<LOBBY>>>/$LASTNR<\/DIV>/;
       }
       if ($ALLTEXTPAGELEFT !~ "picpage") {
         $ALLTEXT =~ s/<<<KOBIE>>>//;
         $ALLTEXT =~ s/<<<KOBIEWANKENOBIE>>><<<LOBBY>>>/<\/DIV>/;
       }
       if ($ALLTEXTPAGERIGHT !~ "picpage") {
         $ALLTEXT =~ s/<<<KOBIE>>>//;
         $ALLTEXT =~ s/<<<KOBIEWANKENOBIE>>>//;
         $ALLTEXT =~ s/<<<LOBBY>>>/$TopRightChapterName/;
       }
       if ($ALLTEXTPAGERIGHT =~ "picpage") {
         $ALLTEXT =~ s/<<<KOBIE>>>//;
         $ALLTEXT =~ s/<<<KOBIEWANKENOBIE>>>//;
         $ALLTEXT =~ s/<<<LOBBY>>>/$TopRightChapterName/;
       }
       $ALLTEXT =~ s/<DIV align='right'>//g;
       #$ALLTEXT =~ s/100\%/600px/g;
       
       if ($TranToLanguage eq "Dutch") {
         $ALLTEXT =~ s/<<<TARGETLANGUAGEIFNOTDUTCH>>>//g;
         $ALLTEXT =~ s/<<<DUTCHLANGUAGEBVN>>>/Nederlandse/g;
         $ALLTEXT =~ s/<<<ENGLISHLANGUAGEBVN>>>/Engelse/g;
         $ALLTEXT =~ s/<<<FRENCHLANGUAGEBVN>>>/Franse/g;
         $ALLTEXT =~ s/<<<GERMANLANGUAGEBVN>>>/Duitse/g;
         $ALLTEXT =~ s/<<<ITALIANLANGUAGEBVN>>>/Italiaanse/g;
         $ALLTEXT =~ s/<<<RUSSIANLANGUAGEBVN>>>/Russische/g;
         $ALLTEXT =~ s/<<<HUNGARIANLANGUAGEBVN>>>/Hongaarse/g;
         $ALLTEXT =~ s/<<<SPANISHLANGUAGEBVN>>>/Spaanse/g;
         $ALLTEXT =~ s/<<<SWEDISHLANGUAGEBVN>>>/Zweedse/g;
         $ALLTEXT =~ s/<<<GREEKLANGUAGEBVN>>>/Griekse/g;
         $ALLTEXT =~ s/<<<PORTUGUESELANGUAGEBVN>>>/Portugese/g;
         $ALLTEXT =~ s/<<<INDONESIANLANGUAGEBVN>>>/Indonesische/g;
         $ALLTEXT =~ s/<<<POLISHLANGUAGEBVN>>>/Poolse/g;
         $ALLTEXT =~ s/<<<URDULANGUAGEBVN>>>/Urdu/g;
       }
       if ($TranToLanguage eq "English") {
         $ALLTEXT =~ s/<<<TARGETLANGUAGEIFNOTDUTCH>>>/$TranToLanguage/g;
         $ALLTEXT =~ s/<<<DUTCHLANGUAGEBVN>>>/Dutch/g;
         $ALLTEXT =~ s/<<<ENGLISHLANGUAGEBVN>>>/English/g;
         $ALLTEXT =~ s/<<<FRENCHLANGUAGEBVN>>>/French/g;
         $ALLTEXT =~ s/<<<GERMANLANGUAGEBVN>>>/German/g;
         $ALLTEXT =~ s/<<<ITALIANLANGUAGEBVN>>>/Italian/g;
         $ALLTEXT =~ s/<<<RUSSIANLANGUAGEBVN>>>/Russian/g;
         $ALLTEXT =~ s/<<<HUNGARIANLANGUAGEBVN>>>/Hungarian/g;
         $ALLTEXT =~ s/<<<SPANISHLANGUAGEBVN>>>/Spanish/g;
         $ALLTEXT =~ s/<<<SWEDISHLANGUAGEBVN>>>/Swedish/g;
         $ALLTEXT =~ s/<<<GREEKLANGUAGEBVN>>>/Greek/g;
         $ALLTEXT =~ s/<<<PORTUGUESELANGUAGEBVN>>>/Portuguese/g;
         $ALLTEXT =~ s/<<<INDONESIANLANGUAGEBVN>>>/Indonesian/g;
         $ALLTEXT =~ s/<<<POLISHLANGUAGEBVN>>>/Polish/g;
         $ALLTEXT =~ s/<<<URDULANGUAGEBVN>>>/Urdu/g;
       }
       
       if ($ALLTEXT =~ "&nbsp;&nbsp;&nbsp;&nbsp;Title") # aha, dit is alleen bij English Fairytales of Short Stories, hm wel handig om een Bermuda Word phagina te hebben of referentie in het begin
       {
          $ALLTEXT = $ALLTEXT."<br><br><center><img src='..\\Main\\Pics\\BermudaWordHomeMap.jpg' HEIGHT='150' WIDTH='450' border=0></center>" ;
       }
       
       #$REPLACEMENTPAGEID = "\<p id\=\'page".$PageNumber."\' class\=atxt\>";
       $ALLTEXT =~ s/<BR><p class=atxt>/<p class=atxt>/g;
  
       if ($APPOn ne "yes") {
       	 $lengthALLTEXT = length($ALLTEXT);
       	 #print "HERE LENGTH IS ".$lengthALLTEXT."\n";
         $TOTALTEXT = $TOTALTEXT.$ALLTEXT."\n</div>\n<br clear=all style='mso-special-character:line-break;page-break-before:always'>\n<div class='page'>" ;     
       } else {
       	 #print "page number for sound files is $PageNumberCounterForSoundFiles\n";
         #print "page number for separate chapters is $PageNumberCounter\n";
         $PageIDCounter = $PageNumberCounter + $SkippedPageNumberCounter + 1;
         $PageIDCounterMinusOne = $PageIDCounter - 1;
         $PageIDCounterPlusOne = $PageIDCounter + 1;
         $PageAudioCounter = $PageNumberCounterForSoundFiles + 1;
         

         # I know what the contents of the before last page was, so I can fill out <<<LASTPAGEAUDIOCOUNTER>>>.
         if ( $LASTALLTEXT !~ m/\¶M/i || $PageIDCounterMinusOne == 2 ) {
           $TOTALTEXT =~ s/<<<LASTPAGEAUDIOCOUNTER>>>/0/g;
         } else {
           $TOTALTEXT =~ s/<<<LASTPAGEAUDIOCOUNTER>>>/$LastLastPageAudioCounter/g;
         }

         # Ok. Here I know what the contents of the last page were, namely ALLTEXT, so I can fill out its <<<PAGEAUDIOCOUNTER>>>.
         if ( $ALLTEXT !~ m/\¶M/i || $PageIDCounterMinusOne == 1 ) {
           $TOTALTEXT =~ s/<<<PAGEAUDIOCOUNTER>>>/0/g;
           $LastPageAudioCounter = 0;
         } else {
           $TOTALTEXT =~ s/<<<PAGEAUDIOCOUNTER>>>/$LastPageAudioCounter/g;
         }
         
         # Then I also know what <<<LASTNEXTPAGEAUDIOCOUNTER>>> is, the current LastPageAudioCounter
         if ( $ALLTEXT !~ m/\¶M/i || $PageIDCounterMinusOne == 1 ) {
           $TOTALTEXT =~ s/<<<LASTNEXTPAGEAUDIOCOUNTER>>>/0/g;
         } else {
           $TOTALTEXT =~ s/<<<LASTNEXTPAGEAUDIOCOUNTER>>>/$LastPageAudioCounter/g;
         }

         # Turn <<<NEXTPAGEAUDIOCOUNTER>>> into <<<LASTNEXTPAGEAUDIOCOUNTER>>>
         $TOTALTEXT =~ s/<<<NEXTPAGEAUDIOCOUNTER>>>/<<<LASTNEXTPAGEAUDIOCOUNTER>>>/g;
         
         # now add audio page gegevens aan SHOW routine, or maybe don't...
         $ALLTEXT =~ s/\¶M/\'\,$PageNumberCounterForSoundFiles\,$PageIDCounterMinusOne\¶M/g;
         
         if ($PageIDCounterMinusOne != 1 && $ALLTEXT =~ m/\¶M/i) {
           $AudioToPageArrays[$CurrentShortFile] = $AudioToPageArrays[$CurrentShortFile]."   audioToPageArray\[\"".$PageNumberCounterForSoundFiles."\"\] \= \"".$PageIDCounterMinusOne."\";\n";
           if ($TRACING eq "ON") {
             print "Ik voeg audioarray ".$PageNumberCounterForSoundFiles.",".$PageIDCounterMinusOne." toe voor ".$TopRightChapterName."!!!\n";
           } else { print ".";}
           $PlayAudioPageButton = "<a style=\"z-index: 14000000\" onclick=\"playAudio('manplay',".$PageNumberCounterForSoundFiles.",".$PageIDCounterMinusOne.");\"><img class=\"audiobutt\" src=\"..\/..\/..\/images\/RightButton\.gif\"\><\/a>";
           $PauseAudioPageButton = "<a style=\"z-index: 3000000\" onclick=\"playAudio('pause',".$PageNumberCounterForSoundFiles.",".$PageIDCounterMinusOne.");\"><img class=\"audiobutt\" src=\"..\/..\/..\/images\/PauseButton\.gif\"\><\/a>";
           $StopAudioPageButton = "<a style=\"z-index: 14000000\" onclick=\"playAudio('stop',".$PageNumberCounterForSoundFiles.",".$PageIDCounterMinusOne.");\"><img class=\"audiobutt\" src=\"..\/..\/..\/images\/StopButton\.gif\"\><\/a>";
           if ($AUDIOEXISTS eq "yes") {
             #$ALLTEXT =~ s/<p class=atxt>$PageIDCounterMinusOne&nbsp;&nbsp;&nbsp;&nbsp;$TopRightChapterName<\/p>/<p class=atxt>$PlayAudioPageButton&nbsp;$PauseAudioPageButton&nbsp;$StopAudioPageButton&nbsp;&nbsp;$PageIDCounterMinusOne&nbsp;&nbsp;&nbsp;&nbsp;$TopRightChapterName<\/p>/;
             $ALLTEXT =~ s/<p class=atxt>$PageIDCounterMinusOne&nbsp;&nbsp;&nbsp;&nbsp;$TopRightChapterName<\/p>/<p class=atxt>&nbsp;&nbsp;&nbsp;$PlayAudioPageButton&nbsp;&nbsp;&nbsp;$StopAudioPageButton&nbsp;&nbsp;$PageIDCounterMinusOne&nbsp;&nbsp;&nbsp;&nbsp;<\/NOBR>$TopRightChapterName<\/p>/;
           }
         } else {
           if ($PageIDCounter != 1) {
             #$PlayAudioPageButton = "<span><img style=\"width: 16px;\" src=\"..\/..\/..\/images\/AppTrns\.gif\"\><\/span>";
             #$PauseAudioPageButton = "<span><img style=\"width: 16px;\" src=\"..\/..\/..\/images\/AppTrns\.gif\"\><\/span>";
             #$StopAudioPageButton = "<span><img style=\"width: 16px;\" src=\"..\/..\/..\/images\/AppTrns\.gif\"\><\/span>";
             #$ALLTEXT =~ s/<p class=atxt>$PageIDCounterMinusOne&nbsp;&nbsp;&nbsp;&nbsp;$TopRightChapterName<\/p>/<p class=atxt>$PlayAudioPageButton&nbsp;$PauseAudioPageButton&nbsp;$StopAudioPageButton&nbsp;&nbsp;$PageIDCounterMinusOne&nbsp;&nbsp;&nbsp;&nbsp;$TopRightChapterName<\/p>/;
             $ALLTEXT =~ s/<p class=atxt>$PageIDCounterMinusOne&nbsp;&nbsp;&nbsp;&nbsp;$TopRightChapterName<\/p>/<p class=atxt>$PageIDCounterMinusOne&nbsp;&nbsp;&nbsp;&nbsp;<\/NOBR>$TopRightChapterName<\/p>/;
           } else {
             $ALLTEXT =~ s/<p class=atxt>$PageIDCounterMinusOne&nbsp;&nbsp;&nbsp;&nbsp;$TopRightChapterName<\/p>//;
           }
         }
         
         $TOTALTEXT = $TOTALTEXT.$ALLTEXT."\n</div>\n<br>\n<div id='page".$PageIDCounter."' class='page' onclick=\"clickPage(".$PageIDCounter.",<<<PAGEAUDIOCOUNTER>>>,<<<LASTPAGEAUDIOCOUNTER>>>,<<<NEXTPAGEAUDIOCOUNTER>>>);\" onmouseover=\"bookmarkPage(".$PageIDCounter.");\" ontouchend=\"endFinger(".$PageIDCounter.",<<<PAGEAUDIOCOUNTER>>>,<<<LASTPAGEAUDIOCOUNTER>>>,<<<NEXTPAGEAUDIOCOUNTER>>>);\">\n";
         
         # REPLACE ALL THIS SHIT WITH ONE MOUSEOVER / CLICK / DOUBLECLICK / WHATEVER FOR THE TOTAL DIV
         # THIS HAS TO SEND DIV ID ONLY (PAGE NR) AND SCRIPT WILL CHECK WHERE CLICK WAS LOCATIIIIDDD
         # EHH THAT DOESN'T WORK, I DON'T KNOW THE OTHER SIDE OF PAGE IN PIXELS
         # OK GETTING SCREEN WIDTH AND HEIGHT FOR THAT
         
         $PageZIndexCounterLeft = $PageZIndexCounterLeft + 2000;
         $TOTALTEXT = $TOTALTEXT."  <span class=\"tl link\" style=\"z-index: ".$PageZIndexCounterLeft."\" onclick=\"togglePopInt(".$PageIDCounter.");\">\n";
         $TOTALTEXT = $TOTALTEXT."    <img class=\"tl\" src=\"..\/..\/..\/images\/AppTrns.gif\"\>\n";
         $TOTALTEXT = $TOTALTEXT."  <\/span>\n";
         $TOTALTEXT = $TOTALTEXT."  <span class=\"sl link\" style=\"z-index: ".$PageZIndexCounterLeft."\" onclick=\"toggleAudio(".$PageIDCounter.");\">\n";
         $TOTALTEXT = $TOTALTEXT."    <img class=\"sl\" src=\"..\/..\/..\/images\/AppTrns.gif\"\>\n";
         $TOTALTEXT = $TOTALTEXT."  <\/span>\n";
         $PageZIndexCounterLeft = $PageZIndexCounterLeft + 2000;
         $TOTALTEXT = $TOTALTEXT."  <span class=\"pl link\" style=\"z-index: ".$PageZIndexCounterLeft."\" onclick=\"goPage(".$PageIDCounterMinusOne.",<<<LASTPAGEAUDIOCOUNTER>>>);\">\n";
         $TOTALTEXT = $TOTALTEXT."    <img class=\"pl\" src=\"..\/..\/..\/images\/AppTrns.gif\"\>\n";
         $TOTALTEXT = $TOTALTEXT."  <\/span>\n";
         
         
         $PageZIndexCounterRight = $PageZIndexCounterRight + 2000;
         $TOTALTEXT = $TOTALTEXT."  <span class=\"tr\" style=\"z-index: 0\">\n";
         $TOTALTEXT = $TOTALTEXT."    <img class=\"tr\" src=\"..\/..\/..\/images\/AppTrns.gif\"\>\n";
         $TOTALTEXT = $TOTALTEXT."  <\/span>\n";
         #$TOTALTEXT = $TOTALTEXT."  <span class=\"sr link\" style=\"z-index: ".$PageZIndexCounterRight."\" onclick=\"bookMark(".$PageIDCounter.");\">\n";
         #$TOTALTEXT = $TOTALTEXT."    <img class=\"sr\" src=\"..\/..\/..\/images\/AppTrns.gif\">\n";
         #$TOTALTEXT = $TOTALTEXT."  <\/span>\n";
         $PageZIndexCounterRight = $PageZIndexCounterRight + 2000;
         $TOTALTEXT = $TOTALTEXT."  <span class=\"pr link\" style=\"z-index: ".$PageZIndexCounterRight."\" onclick=\"goPage(".$PageIDCounterPlusOne.",<<<NEXTPAGEAUDIOCOUNTER>>>);\">\n";
         $TOTALTEXT = $TOTALTEXT."      <img class=\"pr\" src=\"..\/..\/..\/images\/AppTrns.gif\">\n";
         $TOTALTEXT = $TOTALTEXT."  <\/span>\n<br>\n";
         
         # finally save LASTALLTEXT
         $LASTLASTALLTEXT = $LASTALLTEXT;
         $LASTALLTEXT = $ALLTEXT;
         $LastLastPageAudioCounter = $LastPageAudioCounter;
         $LastPageAudioCounter = $PageAudioCounter;
         if ($PageAudioCounter > 0) {
           #print "Set current RealLastPageAudioCounter ".$RealLastPageAudioCounters[$CurrentShortFile]." to really last counter ".$PageAudioCounter."!\n";
           $RealLastPageAudioCounters[$CurrentShortFile] = $PageAudioCounter;
         }
       }
     }
  
     if ($APPOn ne "yes") {
       $TOTALTEXT =~ s/<p class=atxt>1&nbsp;&nbsp;&nbsp;&nbsp;Title<\/p>//g;
       $TOTALTEXT =~ s/<p id=\'page1\' class=atxt>1&nbsp;&nbsp;&nbsp;&nbsp;Title<\/p>//g;
     } else {
       $TOTALTEXT =~ s/<p class=atxt>1&nbsp;&nbsp;&nbsp;&nbsp;$TopRightChapterName<\/p>//g;
       $TOTALTEXT =~ s/<p id=\'page1\' class=atxt>1&nbsp;&nbsp;&nbsp;&nbsp;$TopRightChapterName<\/p>//g;
     }
     
  
     # IF OPTION CREATE WEBSITE IS ON:
     # NOW USE HTMLTemplate_SitePage into $UNFORMATTEDTEXT TO CREATE SITE PAGES (create tests below when you have the dictionary pairs)
     # replace ¶A,¶B and ¶K to ¶R with their parsing values in $UNFORMATTEDTEXT
     # put $LASTUNFORMATTEDTEXT and $UNFORMATTEDTEXT into HTMLTemplate_SitePage template H,1|1,2|2,3|3,4|4,5|5,6|6,7|etc
     # CREATE JAVA PATH CHECK VARIABLE!!!! -> disguised checks where java checks if url is used and not local something:
     # save url in the beginning in variable, take sub part of it in different places in the java code (if java doesn't work, it's useless)
     # unhide boodschap if java doesn't work (not run from internet oid)
     
     if ($TRACING eq "ON") {
       print "Checking whether WebsiteOn equals 'yes' and definition '$WebsiteStory' contains current chapter $CurrentChapterKey)...\n";
     } else { print ".";}
     
     if ($WebsiteOn eq "yes" && $WebsiteStory =~ $CurrentChapterKey)
     {
       $SitePageNumber = $SitePageNumber + 1 ;
  
       if ($TRACING eq "ON") {
         print "\n\nWebsitebuilding is 'On', current chapter $CurrentChapterKey in definition '$WebsiteStory'... Printing this sitepagenumber $SitePageNumber to site...\n";
       } else { print ".";}
  
       $lclanguageto=lc($TranToLanguage);
  
  
       # Create the page with the menu and the index page for this particular book we run this script for,
       # so either a new menu page or add this to the existing one, and on the right the information on that particular menu item
       # so the right page if we click this book in the menu!
       $ReadFile = "../Base/HTML/Site/HTMLTemplate_SiteMenu.htm" ;
       open (READFILE, "$ReadFile") || die "file $ReadFile cannot be found. ($!)\n";
       @ALLTEXT = <READFILE>;
       close (READFILE);
       $ALLTEXT = join ("",@ALLTEXT) ;   
  
       $FrontPicture = $Language."Front";
  
       # CREATE LANGUAGE INDEX PAGES
       # Without Refresh of index.htm (create if not there, add story to menu if there)
       if ($ThisIsTheFirstPage ne "NO") {
           if ($TRACING eq "ON") {
             print "This is the first page, first create or edit the language menu page!\n" ;
           } else { print ".";}
  
           # (RE)CREATE <LANGUE> LIBRARY PAGE
           if ($NiceBookName eq "FAIRYTALES") { $BookName = "FairyTales"; $EnglishRealNiceBookName = "Fairytales"; $DutchRealNiceBookName = "Sprookjes" }
           if ($NiceBookName eq "SHORTSTORIES") { $BookName = "ShortStories"; $EnglishRealNiceBookName = "Short Stories"; $DutchRealNiceBookName = "Korte Verhalen" }
           if ($NiceBookName eq "FAIRYTALESII") { $BookName = "FairyTalesII"; $EnglishRealNiceBookName = "Fairytales II"; $DutchRealNiceBookName = "Sprookjes II" }
           if ($NiceBookName eq "SHORTSTORIESII") { $BookName = "ShortStoriesII"; $EnglishRealNiceBookName = "Short Stories II"; $DutchRealNiceBookName = "Korte Verhalen II" }
           if ($NiceBookName eq "FAIRYTALESIII") { $BookName = "FairyTalesIII"; $EnglishRealNiceBookName = "Fairytales III"; $DutchRealNiceBookName = "Sprookjes III" }
           if ($NiceBookName eq "SHORTSTORIESIII") { $BookName = "ShortStoriesIII"; $EnglishRealNiceBookName = "Short Stories III"; $DutchRealNiceBookName = "Korte Verhalen III" }
           if ($NiceBookName eq "CULTURALI") { $BookName = "Cultural"; $EnglishRealNiceBookName = "Articles"; $DutchRealNiceBookName = "Artikelen" }   # news, history, culture, hobby, etc
           if ($NiceBookName eq "CULTURALII") { $BookName = "CulturalII"; $EnglishRealNiceBookName = "Articles II"; $DutchRealNiceBookName = "Artikelen II" }
           if ($NiceBookName eq "CULTURALIII") { $BookName = "CulturalIII"; $EnglishRealNiceBookName = "Articles III"; $DutchRealNiceBookName = "Artikelen III" }
           $LCBookName = lc($BookName);
  
           foreach $WebsiteLanguage ("English","Dutch") {
             $LCWebsiteLanguage = lc($WebsiteLanguage);
             # read index file for this language, index.htm for english and <$LCWebsiteLanguage>.htm for any other
             if ($WebsiteLanguage eq "English") { $indexfile = "index"; } else { $indexfile = $LCWebsiteLanguage; }
             $ReadFile = "../../Site/".$Language."/".$indexfile.".htm" ;
  
             # make sure newest index base file is always used for the rest of the total file
             ($IndexPagePart1,$Dummy,$IndexPagePart2,$Dummy,$IndexPagePart3) = split("<SPLITCODE>",$ALLTEXT);
             if (-e $ReadFile) {
  
                 # get existing
                 open (READFILE, "$ReadFile") || die "file $ReadFile cannot be found. ($!)\n";
                 @INDEXTEXT = <READFILE>;
                 close (READFILE);
                 $INDEXTEXT = join ("",@INDEXTEXT) ;
  
                 #file exists, add story in empty slot (click on item will show right page explanation for it)
                 ($Dummy,$LibraryPage,$Dummy,$LibraryPage2,$Dummy) = split("<SPLITCODE>",$INDEXTEXT);
                 if ($LibraryPage =~ "<SPLITCODE_$NiceBookName>")
                 {
                   # the book belongs in first part of html code (fairytales)
                   ($LibraryPagePart1,$BOOKSLOT,$LibraryPagePart3) = split("<SPLITCODE_$NiceBookName>",$LibraryPage);
                   $LibraryPageNew = $LibraryPagePart1."<SPLITCODE_$NiceBookName><BOOKSLOTNEW><SPLITCODE_$NiceBookName>".$LibraryPagePart3;
  
                   #recreate total text (except for second page of course, that's added later)
                   if ($WebsiteLanguage eq "English") {
                     #set new bookslot link and picture
                     $BOOKSLOTNEWENGLISH = "<a href='".$WebsiteHTMLName."menu_".$LCWebsiteLanguage.".htm' title='$EnglishRealNiceBookName'><img src='Pics\/$Language$BookName$WebsiteLanguage.jpg' class=noborder width='100px' height='150px' /></a>";
                     $ALLTEXTBASEENGLISH = $IndexPagePart1."<SPLITCODE>".$LibraryPageNew."<SPLITCODE>".$IndexPagePart2."<SPLITCODE>".$LibraryPage2."<SPLITCODE>".$IndexPagePart3;
                   }
                   if ($WebsiteLanguage eq "Dutch") {
                     $BOOKSLOTNEWDUTCH = "<a href='".$WebsiteHTMLName."menu_".$LCWebsiteLanguage.".htm' title='$DutchRealNiceBookName'><img src='Pics\/$Language$BookName$WebsiteLanguage.jpg' class=noborder width='100px' height='150px' /></a>";
                     $ALLTEXTBASEDUTCH = $IndexPagePart1."<SPLITCODE>".$LibraryPageNew."<SPLITCODE>".$IndexPagePart2."<SPLITCODE>".$LibraryPage2."<SPLITCODE>".$IndexPagePart3;
                   }
                 } else {
                   # the book belongs in second part of html code (short stories and culture texts)
                   ($LibraryPagePart1,$BOOKSLOT,$LibraryPagePart3) = split("<SPLITCODE_$NiceBookName>",$LibraryPage2);
                   $LibraryPageNew = $LibraryPagePart1."<SPLITCODE_$NiceBookName><BOOKSLOTNEW><SPLITCODE_$NiceBookName>".$LibraryPagePart3;
  
                   #recreate total text (except for second page of course, that's added later)
                   if ($WebsiteLanguage eq "English") {
                     $BOOKSLOTNEWENGLISH = "<a href='".$WebsiteHTMLName."menu_".$LCWebsiteLanguage.".htm' title='$EnglishRealNiceBookName'><img src='Pics\/$Language$BookName$WebsiteLanguage.jpg' class=noborder width='100px' height='150px' /></a>";
                     $ALLTEXTBASEENGLISH = $IndexPagePart1."<SPLITCODE>".$LibraryPage."<SPLITCODE>".$IndexPagePart2."<SPLITCODE>".$LibraryPageNew."<SPLITCODE>".$IndexPagePart3;
                   }
                   if ($WebsiteLanguage eq "Dutch") {
                     $BOOKSLOTNEWDUTCH = "<a href='".$WebsiteHTMLName."menu_".$LCWebsiteLanguage.".htm' title='$DutchRealNiceBookName'><img src='Pics\/$Language$BookName$WebsiteLanguage.jpg' class=noborder width='100px' height='150px' /></a>";
                     $ALLTEXTBASEDUTCH = $IndexPagePart1."<SPLITCODE>".$LibraryPage."<SPLITCODE>".$IndexPagePart2."<SPLITCODE>".$LibraryPageNew."<SPLITCODE>".$IndexPagePart3;
                   }
                 }
  
             } else {
                 # just use template
  
                 #file does not exist already, add story in empty slot (click on item will show right page explanation for it)
                 ($Dummy,$LibraryPage,$Dummy,$LibraryPage2,$Dummy) = split("<SPLITCODE>",$ALLTEXT);
                 if ($LibraryPage =~ "<SPLITCODE_$NiceBookName>")
                 {
                   # the book belongs in first part of html code (fairytales)
                   ($LibraryPagePart1,$BOOKSLOT,$LibraryPagePart3) = split("<SPLITCODE_$NiceBookName>",$LibraryPage);
                   $LibraryPageNew = $LibraryPagePart1."<SPLITCODE_$NiceBookName><BOOKSLOTNEW><SPLITCODE_$NiceBookName>".$LibraryPagePart3;
  
                   #recreate total text (except for second page of course, that's added later)
                   if ($WebsiteLanguage eq "English") {
                     $BOOKSLOTNEWENGLISH = "<a href='".$WebsiteHTMLName."menu_".$LCWebsiteLanguage.".htm' title='$EnglishRealNiceBookName'><img src='Pics\/$Language$BookName$WebsiteLanguage.jpg' class=noborder width='100px' height='150px' /></a>";
                     $ALLTEXTBASEENGLISH = $IndexPagePart1."<SPLITCODE>".$LibraryPageNew."<SPLITCODE>".$IndexPagePart2."<SPLITCODE>".$LibraryPage2."<SPLITCODE>".$IndexPagePart3;
                   }
                   if ($WebsiteLanguage eq "Dutch") {
                     $BOOKSLOTNEWDUTCH = "<a href='".$WebsiteHTMLName."menu_".$LCWebsiteLanguage.".htm' title='$DutchRealNiceBookName'><img src='Pics\/$Language$BookName$WebsiteLanguage.jpg' class=noborder width='100px' height='150px' /></a>";
                     $ALLTEXTBASEDUTCH = $IndexPagePart1."<SPLITCODE>".$LibraryPageNew."<SPLITCODE>".$IndexPagePart2."<SPLITCODE>".$LibraryPage2."<SPLITCODE>".$IndexPagePart3;
                   }
                 } else {
                   # the book belongs in second part of html code (short stories and culture texts)
                   ($LibraryPagePart1,$BOOKSLOT,$LibraryPagePart3) = split("<SPLITCODE_$NiceBookName>",$LibraryPage2);
                   $LibraryPageNew = $LibraryPagePart1."<SPLITCODE_$NiceBookName><BOOKSLOTNEW><SPLITCODE_$NiceBookName>".$LibraryPagePart3;
  
                   #recreate total text (except for second page of course, that's added later)
                   if ($WebsiteLanguage eq "English") {
                     $BOOKSLOTNEWENGLISH = "<a href='".$WebsiteHTMLName."menu_".$LCWebsiteLanguage.".htm' title='$EnglishRealNiceBookName'><img src='Pics\/$Language$BookName$WebsiteLanguage.jpg' class=noborder width='100px' height='150px' /></a>";
                     $ALLTEXTBASEENGLISH = $IndexPagePart1."<SPLITCODE>".$LibraryPage."<SPLITCODE>".$IndexPagePart2."<SPLITCODE>".$LibraryPageNew."<SPLITCODE>".$IndexPagePart3;
                   }
                   if ($WebsiteLanguage eq "Dutch") {
                     $BOOKSLOTNEWDUTCH = "<a href='".$WebsiteHTMLName."menu_".$LCWebsiteLanguage.".htm' title='$DutchRealNiceBookName'><img src='Pics\/$Language$BookName$WebsiteLanguage.jpg' class=noborder width='100px' height='150px' /></a>";
                     $ALLTEXTBASEDUTCH = $IndexPagePart1."<SPLITCODE>".$LibraryPage."<SPLITCODE>".$IndexPagePart2."<SPLITCODE>".$LibraryPageNew."<SPLITCODE>".$IndexPagePart3;
                   }
                 }
              }
  
              # LARGE RIGHTSIDE ADS
              if ($Language eq "Dutch") {
                   $LARGEADRIGHTSIDEDUTCH = "\n<a href='http://www.vanstockum.nl/boeken/romans-spanning/literaire-roman-novelle/nl/bbliterair%252C-als-dat-maar-goed-gaat-marten-toonder-9789023430803/' onclick='window.open(this.href); return false;'><img style=\"border-style: none; border-width: 0px; margin-top: 10px; margin-left: 0px; margin-bottom: 10px;\" title=\"Marten Toonder - Als Dat Maar Goed Gaat\" alt=\"Marten Toonder - Als Dat Maar Goed Gaat\" src='Pics\/alsdatmaargoedgaat.jpg' align=right width='100px' height='150px' /></img></a>";
                   $LARGEADRIGHTSIDEDUTCH = $LARGEADRIGHTSIDEDUTCH."\n<a href='http://www.vanstockum.nl/boeken/romans-spanning/literaire-thriller/nl/de-kraamhulp-esther-verhoef-9789041423696/' onclick='window.open(this.href); return false;'><img style=\"border-style: none; border-width: 0px; margin-top: 10px; margin-left: 0px; margin-bottom: 10px;\" title=\"Esther Verhoef - De Kraamhulp\" alt=\"Esther Verhoef - De Kraamhulp\" src='Pics\/kraamhulp.jpg' align=left width='100px' height='150px' /></img></a>";
                   $LARGEADRIGHTSIDEDUTCH = $LARGEADRIGHTSIDEDUTCH."\n<a href='http://www.vanstockum.nl/boeken/romans-spanning/literaire-roman-novelle/nl/de-ontdekking-van-de-hemel-harry-mulisch-9789023472780/' onclick='window.open(this.href); return false;'><img style=\"border-style: none; border-width: 0px; margin-top: 10px; margin-left: 22px; margin-bottom: 10px;\" title=\"Harry Mulisch - De Ontdekking Van De Hemel\" alt=\"Harry Mulisch - De Ontdekking Van De Hemel\"src='Pics\/ontdekkingvandehemel.jpg' align=center width='100px' height='150px' /></img></a>";
                   $LARGEADRIGHTSIDEDUTCH = $LARGEADRIGHTSIDEDUTCH."<!-- BEGIN BANNER VANSTOCKUM -->";
                   $LARGEADRIGHTSIDEDUTCH = $LARGEADRIGHTSIDEDUTCH."<br><div align=center><div style=\"position:relative; width:209px; height:60px;\">";
                   $LARGEADRIGHTSIDEDUTCH = $LARGEADRIGHTSIDEDUTCH."<div id=\"vst_banner-rechts\" style=\"position:absolute; right:0; top:0; width:209px; height:60px; background-image:url";
                   $LARGEADRIGHTSIDEDUTCH = $LARGEADRIGHTSIDEDUTCH."(http://www.vanstockum.nl/images/banners/banner5/right.gif);\">";
                   $LARGEADRIGHTSIDEDUTCH = $LARGEADRIGHTSIDEDUTCH."<input id=\"banner5-input\" value=\"Nederlands\" disabled='disabled' type=\"text\" style=\"position:absolute; left:64px; top:20px; border:0 none; width:85px; height:17px;";
                   $LARGEADRIGHTSIDEDUTCH = $LARGEADRIGHTSIDEDUTCH."font-family:Verdana, Arial, Helvetica, sans-serif; font-size:10px;\" />";
                   $LARGEADRIGHTSIDEDUTCH = $LARGEADRIGHTSIDEDUTCH."<a href=\"javascript:submit_banner5();\"><img src=\"http://www.vanstockum.nl/images/banners/banner5/button.gif\" border=\"0\" ";
                   $LARGEADRIGHTSIDEDUTCH = $LARGEADRIGHTSIDEDUTCH."style=\"position:absolute; right:4px; top:20px;\"/></a></div></div><script language=\"javascript\">function submit_banner5(){";
                   $LARGEADRIGHTSIDEDUTCH = $LARGEADRIGHTSIDEDUTCH."window.location='http://www.vanstockum.nl/tips#nederlands'}</script></div>";
                   $LARGEADRIGHTSIDEDUTCH = $LARGEADRIGHTSIDEDUTCH."<!-- EINDE BANNER VANSTOCKUM -->";
                   
                   #copy for english
                   $LARGEADRIGHTSIDEENGLISH = $LARGEADRIGHTSIDEDUTCH;
                   # Bol ad
                   #$LARGEADRIGHTSIDEDUTCH = "\n<script type='text/javascript' language='javascript'>";
                   #$LARGEADRIGHTSIDEDUTCH = $LARGEADRIGHTSIDEDUTCH."var bol_pml={\"id\":\"bol_script1396381562374\",\"baseUrl\":\"partnerprogramma.bol.com\",\"secure\":false,";
                   #$LARGEADRIGHTSIDEDUTCH = $LARGEADRIGHTSIDEDUTCH."\"nrProducts\":\"4\",\"title\":\"\",\"price_color\":\"#CB0100\",\"priceRangeId\":\"none\",\"catID\":\"8293+255\",\"header\":true,";
                   #$LARGEADRIGHTSIDEDUTCH = $LARGEADRIGHTSIDEDUTCH."\"urlPrefix\":\"http:\/\/aai.bol.com\/aai\",\"site_id\":\"27295\",\"target\":true,\"rating\":true,\"price\":true,\"image_size\":false,";
                   #$LARGEADRIGHTSIDEDUTCH = $LARGEADRIGHTSIDEDUTCH."\"link_name\":\"Ittolaja\",\"link_subid\":\"Dutch\",\"image_position\":\"left\",\"width\":\"340\",\"cols\":\"2\",";
                   #$LARGEADRIGHTSIDEDUTCH = $LARGEADRIGHTSIDEDUTCH."\"background_color\":\"#FFFFFF\",\"text_color\":\"#000000\",\"link_color\":\"#0000FF\",\"border_color\":\"#D2D2D2\",\"letter_type\":\"verdana\",\"letter_size\":\"10\"};";
                   #$LARGEADRIGHTSIDEDUTCH = $LARGEADRIGHTSIDEDUTCH."<\/script><script id=\"bol_script1396381562374\" src=\"http:\/\/partnerprogramma.bol.com\/partner\/static\/js\/aai\/clientBestsellerGenerator.js\" type=\"text\/javascript\"><\/script>";
              }
              if ($Language eq "English") {
                   $LARGEADRIGHTSIDEDUTCH = "\n<a href='http://www.vanstockum.nl/boeken/kinderboeken/fictie-kinder--en-jeugdboeken-algemeen/gb/twilight-meyer-stephenie-9780756968250/' onclick='window.open(this.href); return false;'><img style=\"border-style: none; border-width: 0px; margin-top: 10px; margin-left: 0px; margin-bottom: 10px;\" title=\"Stephenie Meyer - Twilight\" alt=\"Stephenie Meyer - Twilight\" src='Pics\/twilight.jpg' align=right width='100px' height='150px' /></img></a>";
                   $LARGEADRIGHTSIDEDUTCH = $LARGEADRIGHTSIDEDUTCH."\n<a href='http://www.vanstockum.nl/boeken/romans-spanning/thriller/gb/john-grisham-boxed-set-grisham-john-9780345544100/' onclick='window.open(this.href); return false;'><img style=\"border-style: none; border-width: 0px; margin-top: 10px; margin-left: 0px; margin-bottom: 10px;\" title=\"John Grisham - 3 boxed set\" alt=\"John Grisham - 3 boxed set\" src='Pics\/grishamtrilogy.jpg' align=left width='100px' height='150px' /></img></a>";
                   $LARGEADRIGHTSIDEDUTCH = $LARGEADRIGHTSIDEDUTCH."\n<a href='http://www.vanstockum.nl/boeken/romans-spanning/literaire-fictie-algemeen/gb/dear-life-munro-alice-9780099578642/' onclick='window.open(this.href); return false;'><img style=\"border-style: none; border-width: 0px; margin-top: 10px; margin-left: 22px; margin-bottom: 10px;\" title=\"Alice Munro - Dear Life\" alt=\"Alice Munro - Dear Life\"src='Pics\/dearlife.jpg' align=center width='100px' height='150px' /></img></a>";
                   $LARGEADRIGHTSIDEDUTCH = $LARGEADRIGHTSIDEDUTCH."<!-- BEGIN BANNER VANSTOCKUM -->";
                   $LARGEADRIGHTSIDEDUTCH = $LARGEADRIGHTSIDEDUTCH."<br><div align=center><div style=\"position:relative; width:209px; height:60px;\">";
                   $LARGEADRIGHTSIDEDUTCH = $LARGEADRIGHTSIDEDUTCH."<div id=\"vst_banner-rechts\" style=\"position:absolute; right:0; top:0; width:209px; height:60px; background-image:url";
                   $LARGEADRIGHTSIDEDUTCH = $LARGEADRIGHTSIDEDUTCH."(http://www.vanstockum.nl/images/banners/banner5/right.gif);\">";
                   $LARGEADRIGHTSIDEDUTCH = $LARGEADRIGHTSIDEDUTCH."<input id=\"banner5-input\" value=\"Engels\" disabled='disabled' type=\"text\" style=\"position:absolute; left:64px; top:20px; border:0 none; width:85px; height:17px;";
                   $LARGEADRIGHTSIDEDUTCH = $LARGEADRIGHTSIDEDUTCH."font-family:Verdana, Arial, Helvetica, sans-serif; font-size:10px;\" />";
                   $LARGEADRIGHTSIDEDUTCH = $LARGEADRIGHTSIDEDUTCH."<a href=\"javascript:submit_banner5();\"><img src=\"http://www.vanstockum.nl/images/banners/banner5/button.gif\" border=\"0\" ";
                   $LARGEADRIGHTSIDEDUTCH = $LARGEADRIGHTSIDEDUTCH."style=\"position:absolute; right:4px; top:20px;\"/></a></div></div><script language=\"javascript\">function submit_banner5(){";
                   $LARGEADRIGHTSIDEDUTCH = $LARGEADRIGHTSIDEDUTCH."window.location='http://www.vanstockum.nl/search?q%5Bfilters%5D=1&q%5Bnur%5D=2124&q%5Bmediatype%5D=1&q%5Blanguage%5D=1&q%5Bavailability%5D=available&q%5Bsort%5D=score&q%5Bsortorder%5D=descending&q%5Blanguage%5D=2&q%5Bmediatype%5D=1&q%5Bprice%5D=&q%5Byear%5D=&q%5Bavailability%5D=available&q%5Bchange_filter%5D=1&q%5Bstore%5D=0'}</script></div>";
                   $LARGEADRIGHTSIDEDUTCH = $LARGEADRIGHTSIDEDUTCH."<!-- EINDE BANNER VANSTOCKUM -->";
                   
                   #copy for english
                   $LARGEADRIGHTSIDEENGLISH = $LARGEADRIGHTSIDEDUTCH;
                   # Bol ad
                   #$LARGEADRIGHTSIDEDUTCH = "\n<script type='text/javascript' language='javascript'>";
                   #$LARGEADRIGHTSIDEDUTCH = $LARGEADRIGHTSIDEDUTCH."var bol_pml={\"id\":\"bol_script1396301191447\",\"baseUrl\":\"partnerprogramma.bol.com\",\"secure\":false,";
                   #$LARGEADRIGHTSIDEDUTCH = $LARGEADRIGHTSIDEDUTCH."\"nrProducts\":\"4\",\"title\":\"\",\"price_color\":\"#CB0100\",\"priceRangeId\":\"none\",\"catID\":\"8292+2510\",\"header\":true,";
                   #$LARGEADRIGHTSIDEDUTCH = $LARGEADRIGHTSIDEDUTCH."\"urlPrefix\":\"http:\/\/aai.bol.com\/aai\",\"site_id\":\"27295\",\"target\":true,\"rating\":true,\"price\":true,\"image_size\":false,";
                   #$LARGEADRIGHTSIDEDUTCH = $LARGEADRIGHTSIDEDUTCH."\"link_name\":\"Ittolaja\",\"link_subid\":\"English\",\"image_position\":\"left\",\"width\":\"340\",\"cols\":\"2\",";
                   #$LARGEADRIGHTSIDEDUTCH = $LARGEADRIGHTSIDEDUTCH."\"background_color\":\"#FFFFFF\",\"text_color\":\"#000000\",\"link_color\":\"#0000FF\",\"border_color\":\"#D2D2D2\",\"letter_type\":\"verdana\",\"letter_size\":\"10\"};";
                   #$LARGEADRIGHTSIDEDUTCH = $LARGEADRIGHTSIDEDUTCH."<\/script><script id=\"bol_script1396301191447\" src=\"http:\/\/partnerprogramma.bol.com\/partner\/static\/js\/aai\/clientBestsellerGenerator.js\" type=\"text\/javascript\"><\/script>";
              }
              if ($Language eq "French") {
                   $LARGEADRIGHTSIDEDUTCH = "\n<a href='http://www.vanstockum.nl/boeken/romans-spanning/spionageroman/fr/un-lieu-incertain-vargas-fred-9782290023501/' onclick='window.open(this.href); return false;'><img style=\"border-style: none; border-width: 0px; margin-top: 10px; margin-left: 0px; margin-bottom: 10px;\" title=\"Fred Vargas - Un Lieu Incertain\" alt=\"Fred Vargas - Un Lieu Incertain\" src='Pics\/UnLieuIncertain.jpg' align=right width='100px' height='150px' /></img></a>";
                   $LARGEADRIGHTSIDEDUTCH = $LARGEADRIGHTSIDEDUTCH."\n<a href='http://www.vanstockum.nl/boeken/studieboeken/fr/les-rivieres-pourpres-grang-jean-christophe-9782253171676/' onclick='window.open(this.href); return false;'><img style=\"border-style: none; border-width: 0px; margin-top: 10px; margin-left: 0px; margin-bottom: 10px;\" title=\"Jean-Christophe Grangé - Les Rivières Pourpres\" alt=\"Jean-Christophe Grangé - Les Rivières Pourpres\" src='Pics\/LesRivieresPourpres.jpg' align=left width='100px' height='150px' /></img></a>";
                   $LARGEADRIGHTSIDEDUTCH = $LARGEADRIGHTSIDEDUTCH."\n<a href='http://www.vanstockum.nl/boeken/romans-spanning/vertaalde-literaire-roman-novelle/fr/les-particules-elementaires.-elementarteilchen%252C-franz%25C3%2583%25C2%25B6sische-ausgabe-houellebecq-michel-9782290028599/' onclick='window.open(this.href); return false;'><img style=\"border-style: none; border-width: 0px; margin-top: 10px; margin-left: 22px; margin-bottom: 10px;\" title=\"Michel Houellebecq - Les Particules Élémentaires\" alt=\"Michel Houellebecq - Les Particules Élémentaires\"src='Pics\/LesParticulesElementaires.jpg' align=center width='100px' height='150px' /></img></a>";
                   $LARGEADRIGHTSIDEDUTCH = $LARGEADRIGHTSIDEDUTCH."<!-- BEGIN BANNER VANSTOCKUM -->";
                   $LARGEADRIGHTSIDEDUTCH = $LARGEADRIGHTSIDEDUTCH."<br><div align=center><div style=\"position:relative; width:209px; height:60px;\">";
                   $LARGEADRIGHTSIDEDUTCH = $LARGEADRIGHTSIDEDUTCH."<div id=\"vst_banner-rechts\" style=\"position:absolute; right:0; top:0; width:209px; height:60px; background-image:url";
                   $LARGEADRIGHTSIDEDUTCH = $LARGEADRIGHTSIDEDUTCH."(http://www.vanstockum.nl/images/banners/banner5/right.gif);\">";
                   $LARGEADRIGHTSIDEDUTCH = $LARGEADRIGHTSIDEDUTCH."<input id=\"banner5-input\" value=\"Frans\" disabled='disabled' type=\"text\" style=\"position:absolute; left:64px; top:20px; border:0 none; width:85px; height:17px;";
                   $LARGEADRIGHTSIDEDUTCH = $LARGEADRIGHTSIDEDUTCH."font-family:Verdana, Arial, Helvetica, sans-serif; font-size:10px;\" />";
                   $LARGEADRIGHTSIDEDUTCH = $LARGEADRIGHTSIDEDUTCH."<a href=\"javascript:submit_banner5();\"><img src=\"http://www.vanstockum.nl/images/banners/banner5/button.gif\" border=\"0\" ";
                   $LARGEADRIGHTSIDEDUTCH = $LARGEADRIGHTSIDEDUTCH."style=\"position:absolute; right:4px; top:20px;\"/></a></div></div><script language=\"javascript\">function submit_banner5(){";
                   $LARGEADRIGHTSIDEDUTCH = $LARGEADRIGHTSIDEDUTCH."window.location='http://www.vanstockum.nl/search?q%5Bnur%5D=2124&search_dropdown=language%3A4&q%5Bq%5D=&x=22&y=14'}</script></div>";
                   $LARGEADRIGHTSIDEDUTCH = $LARGEADRIGHTSIDEDUTCH."<!-- EINDE BANNER VANSTOCKUM -->";
                   
                   #copy for english
                   $LARGEADRIGHTSIDEENGLISH = $LARGEADRIGHTSIDEDUTCH;
                   # Bol ad
                   #$LARGEADRIGHTSIDEDUTCH = "\n<script type='text/javascript' language='javascript'>";
                   #$LARGEADRIGHTSIDEDUTCH = $LARGEADRIGHTSIDEDUTCH."var bol_pml={\"id\":\"bol_script1396302536921\",\"baseUrl\":\"partnerprogramma.bol.com\",\"secure\":false,";
                   #$LARGEADRIGHTSIDEDUTCH = $LARGEADRIGHTSIDEDUTCH."\"nrProducts\":\"4\",\"title\":\"\",\"price_color\":\"#CB0100\",\"priceRangeId\":\"none\",\"catID\":\"8294+2510\",\"header\":true,";
                   #$LARGEADRIGHTSIDEDUTCH = $LARGEADRIGHTSIDEDUTCH."\"urlPrefix\":\"http:\/\/aai.bol.com\/aai\",\"site_id\":\"27295\",\"target\":true,\"rating\":true,\"price\":true,\"image_size\":false,";
                   #$LARGEADRIGHTSIDEDUTCH = $LARGEADRIGHTSIDEDUTCH."\"link_name\":\"Ittolaja\",\"link_subid\":\"French\",\"image_position\":\"left\",\"width\":\"340\",\"cols\":\"2\",";
                   #$LARGEADRIGHTSIDEDUTCH = $LARGEADRIGHTSIDEDUTCH."\"background_color\":\"#FFFFFF\",\"text_color\":\"#000000\",\"link_color\":\"#0000FF\",\"border_color\":\"#D2D2D2\",\"letter_type\":\"verdana\",\"letter_size\":\"10\"};";
                   #$LARGEADRIGHTSIDEDUTCH = $LARGEADRIGHTSIDEDUTCH."<\/script><script id=\"bol_script1396302536921\" src=\"http:\/\/partnerprogramma.bol.com\/partner\/static\/js\/aai\/clientBestsellerGenerator.js\" type=\"text\/javascript\"><\/script>";
              }
              if ($Language eq "German") {
                   $LARGEADRIGHTSIDEDUTCH = "\n<a href='http://www.vanstockum.nl/boeken/romans-spanning/literaire-roman-novelle/de/der-schwarm-schtzing-frank-9783596164530/' onclick='window.open(this.href); return false;'><img style=\"border-style: none; border-width: 0px; margin-top: 10px; margin-left: 0px; margin-bottom: 10px;\" title=\"Frank Schätzing - Der Schwarm\" alt=\"Frank Schätzing - Der Schwarm\" src='Pics\/DerSchwarm.jpg' align=right width='100px' height='150px' /></img></a>";
                   $LARGEADRIGHTSIDEDUTCH = $LARGEADRIGHTSIDEDUTCH."\n<a href='http://www.vanstockum.nl/boeken/geschiedenis-algemeen/moderne-geschiedenis-1870-heden/de/eine-frau-in-berlin-anonyma-9783821847375/' onclick='window.open(this.href); return false;'><img style=\"border-style: none; border-width: 0px; margin-top: 10px; margin-left: 0px; margin-bottom: 10px;\" title=\"Anonyma - Eine Frau in Berlin\" alt=\"Anonyma - Eine Frau in Berlin\" src='Pics\/EineFrauInBerlin.jpg' align=left width='100px' height='150px' /></img></a>";
                   $LARGEADRIGHTSIDEDUTCH = $LARGEADRIGHTSIDEDUTCH."\n<a href='http://www.vanstockum.nl/boeken/romans-spanning/literaire-roman-novelle/de/der-vorleser-schlink-bernhard-9783257229530/' onclick='window.open(this.href); return false;'><img style=\"border-style: none; border-width: 0px; margin-top: 10px; margin-left: 22px; margin-bottom: 10px;\" title=\"Bernhard Schlink - Der Vorleser\" alt=\"Bernhard Schlink - Der Vorleser\"src='Pics\/DerVorleser.jpg' align=center width='100px' height='150px' /></img></a>";
                   $LARGEADRIGHTSIDEDUTCH = $LARGEADRIGHTSIDEDUTCH."<!-- BEGIN BANNER VANSTOCKUM -->";
                   $LARGEADRIGHTSIDEDUTCH = $LARGEADRIGHTSIDEDUTCH."<br><div align=center><div style=\"position:relative; width:209px; height:60px;\">";
                   $LARGEADRIGHTSIDEDUTCH = $LARGEADRIGHTSIDEDUTCH."<div id=\"vst_banner-rechts\" style=\"position:absolute; right:0; top:0; width:209px; height:60px; background-image:url";
                   $LARGEADRIGHTSIDEDUTCH = $LARGEADRIGHTSIDEDUTCH."(http://www.vanstockum.nl/images/banners/banner5/right.gif);\">";
                   $LARGEADRIGHTSIDEDUTCH = $LARGEADRIGHTSIDEDUTCH."<input id=\"banner5-input\" value=\"Duits\" disabled='disabled' type=\"text\" style=\"position:absolute; left:64px; top:20px; border:0 none; width:85px; height:17px;";
                   $LARGEADRIGHTSIDEDUTCH = $LARGEADRIGHTSIDEDUTCH."font-family:Verdana, Arial, Helvetica, sans-serif; font-size:10px;\" />";
                   $LARGEADRIGHTSIDEDUTCH = $LARGEADRIGHTSIDEDUTCH."<a href=\"javascript:submit_banner5();\"><img src=\"http://www.vanstockum.nl/images/banners/banner5/button.gif\" border=\"0\" ";
                   $LARGEADRIGHTSIDEDUTCH = $LARGEADRIGHTSIDEDUTCH."style=\"position:absolute; right:4px; top:20px;\"/></a></div></div><script language=\"javascript\">function submit_banner5(){";
                   $LARGEADRIGHTSIDEDUTCH = $LARGEADRIGHTSIDEDUTCH."window.location='http://www.vanstockum.nl/search?q%5Bnur%5D=2124&search_dropdown=language%3A3&q%5Bq%5D=&x=20&y=6'}</script></div>";
                   $LARGEADRIGHTSIDEDUTCH = $LARGEADRIGHTSIDEDUTCH."<!-- EINDE BANNER VANSTOCKUM -->";
                   
                   #copy for english
                   $LARGEADRIGHTSIDEENGLISH = $LARGEADRIGHTSIDEDUTCH;
                 # Bol ad
                   #$LARGEADRIGHTSIDEDUTCH = "\n<script type='text/javascript' language='javascript'>";
                   #$LARGEADRIGHTSIDEDUTCH = $LARGEADRIGHTSIDEDUTCH."var bol_pml={\"id\":\"bol_script1396402175649\",\"baseUrl\":\"partnerprogramma.bol.com\",\"secure\":false,";
                   #$LARGEADRIGHTSIDEDUTCH = $LARGEADRIGHTSIDEDUTCH."\"nrProducts\":\"4\",\"title\":\"\",\"price_color\":\"#CB0100\",\"priceRangeId\":\"none\",\"catID\":\"8296+2510\",\"header\":true,";
                   #$LARGEADRIGHTSIDEDUTCH = $LARGEADRIGHTSIDEDUTCH."\"urlPrefix\":\"http:\/\/aai.bol.com\/aai\",\"site_id\":\"27295\",\"target\":true,\"rating\":true,\"price\":true,\"image_size\":false,";
                   #$LARGEADRIGHTSIDEDUTCH = $LARGEADRIGHTSIDEDUTCH."\"link_name\":\"Ittolaja\",\"link_subid\":\"German\",\"image_position\":\"left\",\"width\":\"340\",\"cols\":\"2\",";
                   #$LARGEADRIGHTSIDEDUTCH = $LARGEADRIGHTSIDEDUTCH."\"background_color\":\"#FFFFFF\",\"text_color\":\"#000000\",\"link_color\":\"#0000FF\",\"border_color\":\"#D2D2D2\",\"letter_type\":\"verdana\",\"letter_size\":\"10\"};";
                   #$LARGEADRIGHTSIDEDUTCH = $LARGEADRIGHTSIDEDUTCH."<\/script><script id=\"bol_script1396402175649\" src=\"http:\/\/partnerprogramma.bol.com\/partner\/static\/js\/aai\/clientBestsellerGenerator.js\" type=\"text\/javascript\"><\/script>";
              }
              if ($Language eq "Hungarian") {
                   $LARGEADRIGHTSIDEDUTCH = "\n<BR><BR><A href='http:\/\/www.pegasusboek.nl' onclick=\"window.open(this.href); return false;\"><img src='..\/Pics\/kop_pegasus_2013.jpg' class=noborder width='312px' height='57px' align='middle' /><FONT color=orange><B>Boekhandel Pegasus - Oost-Europese Talen</B></FONT><\/A>";
                   #copy for english
                   $LARGEADRIGHTSIDEENGLISH = $LARGEADRIGHTSIDEDUTCH;
              }
              if ($Language eq "Indonesian") {
                 if ($WebsiteLanguage eq "English") {
                   # Amazon ad
                   $LARGEADRIGHTSIDEENGLISH = "<DUMMY>";
                   #$LARGEADRIGHTSIDEENGLISH = "\n<script type=\"text\/javascript\"> ";
                   #$LARGEADRIGHTSIDEENGLISH = $LARGEADRIGHTSIDEENGLISH."amzn_assoc_ad_type = \"search\"; amzn_assoc_tracking_id = \"bermword-20\"; amzn_assoc_marketplace = \"amazon\"; amzn_assoc_region = \"US\"; ";
                   #$LARGEADRIGHTSIDEENGLISH = $LARGEADRIGHTSIDEENGLISH."amzn_assoc_show_price = \"true\"; amzn_assoc_show_rating = \"true\"; amzn_assoc_show_image = \"true\"; amzn_assoc_width = \"336\"; ";
                   #$LARGEADRIGHTSIDEENGLISH = $LARGEADRIGHTSIDEENGLISH."amzn_assoc_height =  \"280\"; amzn_assoc_default_search_key =  \"indonesian edition\"; amzn_assoc_department =  \"Books\";";
                   #$LARGEADRIGHTSIDEENGLISH = $LARGEADRIGHTSIDEENGLISH."<\/script><script type=\"text\/javascript\" ";
                   #$LARGEADRIGHTSIDEENGLISH = $LARGEADRIGHTSIDEENGLISH."src=\"http:\/\/ws-na.amazon-adsystem.com\/widgets\/q?rt=tf_sw&ServiceVersion=20070822&MarketPlace=US&Operation=GetScript&ID=OneJS&WS=1&source=ac\">";
                   #$LARGEADRIGHTSIDEENGLISH = $LARGEADRIGHTSIDEENGLISH."<\/script>";
                 }
                 if ($WebsiteLanguage eq "Dutch") {
                   # Amazon ad
                   $LARGEADRIGHTSIDEDUTCH = "<DUMMY>";
                   #$LARGEADRIGHTSIDEDUTCH = "\n<script type=\"text\/javascript\"> ";
                   #$LARGEADRIGHTSIDEDUTCH = $LARGEADRIGHTSIDEDUTCH."amzn_assoc_ad_type = \"search\"; amzn_assoc_tracking_id = \"bermword-20\"; amzn_assoc_marketplace = \"amazon\"; amzn_assoc_region = \"US\"; ";
                   #$LARGEADRIGHTSIDEDUTCH = $LARGEADRIGHTSIDEDUTCH."amzn_assoc_show_price = \"true\"; amzn_assoc_show_rating = \"true\"; amzn_assoc_show_image = \"true\"; amzn_assoc_width = \"336\"; ";
                   #$LARGEADRIGHTSIDEDUTCH = $LARGEADRIGHTSIDEDUTCH."amzn_assoc_height =  \"280\"; amzn_assoc_default_search_key =  \"indonesian edition\"; amzn_assoc_department =  \"Books\";";
                   #$LARGEADRIGHTSIDEDUTCH = $LARGEADRIGHTSIDEDUTCH."<\/script><script type=\"text\/javascript\" ";
                   #$LARGEADRIGHTSIDEDUTCH = $LARGEADRIGHTSIDEDUTCH."src=\"http:\/\/ws-na.amazon-adsystem.com\/widgets\/q?rt=tf_sw&ServiceVersion=20070822&MarketPlace=US&Operation=GetScript&ID=OneJS&WS=1&source=ac\">";
                   #$LARGEADRIGHTSIDEDUTCH = $LARGEADRIGHTSIDEDUTCH."<\/script>";
                 }
              }
              if ($Language eq "Italian") {
                 # Van Stockum ad
                   #$LARGEADRIGHTSIDEDUTCH = "\n<A class=atxt id=a9_3 onmouseover=\"Show('a9_3','c9_3')\" onmouseover=\"Hide('c9_3')\"><img src='Pics\/$Language$BookName$WebsiteLanguage.jpg' align=left class=noborder width='100px' height='150px' /></img></A><DIV class=ctxt id=c9_3><script language=\"javascript\" src=\"http://www.vanstockum.nl/partner/book/11255356\"></script></DIV>";
                   $LARGEADRIGHTSIDEDUTCH = "\n<a href='http://www.vanstockum.nl/boeken/romans-spanning/cartoons/it/asterix-e-gli-allori-di-cesare.-die-lorbeeren-des-c%25C3%2583%25C2%25A4sar%252C-italienische-ausgabe-9788804625476/' onclick='window.open(this.href); return false;'><img style=\"border-style: none; border-width: 0px; margin-top: 10px; margin-left: 0px; margin-bottom: 10px;\" title=\"Goscinny & Uderzo - Asterix E Cesare\" alt=\"Goscinny & Uderzo - Asterix E Cesare\" src='Pics\/asterixecesare.jpg' align=right width='100px' height='150px' /></img></a>";
                   $LARGEADRIGHTSIDEDUTCH = $LARGEADRIGHTSIDEDUTCH."\n<a href='http://www.vanstockum.nl/boeken/romans-spanning/literaire-fictie-algemeen/it/casa-sul-lago-della-luna-duranti-francesca-9781899293278/' onclick='window.open(this.href); return false;'><img style=\"border-style: none; border-width: 0px; margin-top: 10px; margin-left: 0px; margin-bottom: 10px;\" title=\"Francesca Duranti - La Casa Sul Lago Della Luna\" alt=\"Francesca Duranti - La Casa Sul Lago Della Luna\" src='Pics\/casasullagodellaluna.jpg' align=left width='100px' height='150px' /></img></a>";
                   $LARGEADRIGHTSIDEDUTCH = $LARGEADRIGHTSIDEDUTCH."\n<a href='http://www.vanstockum.nl/search?q%5Bnur%5D=&search_dropdown=&q%5Bq%5D=Il+Nome+Della+Rosa&x=0&y=0' onclick='window.open(this.href); return false;'><img style=\"border-style: none; border-width: 0px; margin-top: 10px; margin-left: 22px; margin-bottom: 10px;\" title=\"Umberto Eco - Il Nome Della Rosa\" alt=\"Umberto Eco - Il Nome Della Rosa\"src='Pics\/nomedellarosa.jpg' align=center width='100px' height='150px' /></img></a>";
                   $LARGEADRIGHTSIDEDUTCH = $LARGEADRIGHTSIDEDUTCH."<!-- BEGIN BANNER VANSTOCKUM -->";
                   $LARGEADRIGHTSIDEDUTCH = $LARGEADRIGHTSIDEDUTCH."<br><div align=center><div style=\"position:relative; width:209px; height:60px;\">";
                   $LARGEADRIGHTSIDEDUTCH = $LARGEADRIGHTSIDEDUTCH."<div id=\"vst_banner-rechts\" style=\"position:absolute; right:0; top:0; width:209px; height:60px; background-image:url";
                   $LARGEADRIGHTSIDEDUTCH = $LARGEADRIGHTSIDEDUTCH."(http://www.vanstockum.nl/images/banners/banner5/right.gif);\">";
                   $LARGEADRIGHTSIDEDUTCH = $LARGEADRIGHTSIDEDUTCH."<input id=\"banner5-input\" value=\"Italiaans\" disabled='disabled' type=\"text\" style=\"position:absolute; left:64px; top:20px; border:0 none; width:85px; height:17px;";
                   $LARGEADRIGHTSIDEDUTCH = $LARGEADRIGHTSIDEDUTCH."font-family:Verdana, Arial, Helvetica, sans-serif; font-size:10px;\" />";
                   $LARGEADRIGHTSIDEDUTCH = $LARGEADRIGHTSIDEDUTCH."<a href=\"javascript:submit_banner5();\"><img src=\"http://www.vanstockum.nl/images/banners/banner5/button.gif\" border=\"0\" ";
                   $LARGEADRIGHTSIDEDUTCH = $LARGEADRIGHTSIDEDUTCH."style=\"position:absolute; right:4px; top:20px;\"/></a></div></div><script language=\"javascript\">function submit_banner5(){";
                   $LARGEADRIGHTSIDEDUTCH = $LARGEADRIGHTSIDEDUTCH."window.location='http://www.vanstockum.nl/search?q%5Bfilters%5D=1&q%5Bnur%5D=2124&q%5Blanguage%5D=6&q%5Bavailability%5D=available&q%5Bsort%5D=score&q%5Bsortorder%5D=descending&q%5Blanguage%5D=6&q%5Bmediatype%5D=1&q%5Bprice%5D=&q%5Byear%5D=&q%5Bavailability%5D=available&q%5Bchange_filter%5D=1&q%5Bstore%5D=0'}</script></div>";
                   $LARGEADRIGHTSIDEDUTCH = $LARGEADRIGHTSIDEDUTCH."<!-- EINDE BANNER VANSTOCKUM -->";
                   
                   #copy for english
                   $LARGEADRIGHTSIDEENGLISH = $LARGEADRIGHTSIDEDUTCH;
                   #$LARGEADRIGHTSIDEDUTCH = "\n<BR><BR><script language=\"javascript\" src=\"http://www.vanstockum.nl/partner/overview\"></script>";
                   #$LARGEADRIGHTSIDEDUTCH = "\n<BR><BR><A href='http:\/\/www.bonardi.nl\/open_nl.html' onclick=\"window.open(this.href); return false;\"><img src='..\/Pics\/LBtrans.gif' class=noborder width='147px' height='151px' align='right' /><FONT color=blue align=left><B><BR>Libreria Bonardi<BR><BR>De enige<BR>Italiaanse boekhandel<BR>in Nederland!</B></FONT><\/A>";
              }
              if ($Language eq "Polish") {
                   # Pegasus ad
                   $LARGEADRIGHTSIDEDUTCH = "\n<BR><BR><A href='http:\/\/www.pegasusboek.nl' onclick=\"window.open(this.href); return false;\"><img src='..\/Pics\/kop_pegasus_2013.jpg' class=noborder width='312px' height='57px' align='middle' /><FONT color=orange><B>Boekhandel Pegasus - Oost-Europese Talen</B></FONT><\/A>";
                   $LARGEADRIGHTSIDEENGLISH = $LARGEADRIGHTSIDEDUTCH;
              }
              if ($Language eq "Portuguese") {
                 if ($WebsiteLanguage eq "English") {
                   # Amazon ad
                   $LARGEADRIGHTSIDEENGLISH = "<DUMMY>";
                   #$LARGEADRIGHTSIDEENGLISH = "\n<script type=\"text\/javascript\"> ";
                   #$LARGEADRIGHTSIDEENGLISH = $LARGEADRIGHTSIDEENGLISH."amzn_assoc_ad_type = \"search\"; amzn_assoc_tracking_id = \"bermword-20\"; amzn_assoc_marketplace = \"amazon\"; amzn_assoc_region = \"US\"; ";
                   #$LARGEADRIGHTSIDEENGLISH = $LARGEADRIGHTSIDEENGLISH."amzn_assoc_show_price = \"true\"; amzn_assoc_show_rating = \"true\"; amzn_assoc_show_image = \"true\"; amzn_assoc_width = \"336\"; ";
                   #$LARGEADRIGHTSIDEENGLISH = $LARGEADRIGHTSIDEENGLISH."amzn_assoc_height =  \"280\"; amzn_assoc_default_search_key =  \"portuguese edition\"; amzn_assoc_department =  \"Books\";";
                   #$LARGEADRIGHTSIDEENGLISH = $LARGEADRIGHTSIDEENGLISH."<\/script><script type=\"text\/javascript\" ";
                   #$LARGEADRIGHTSIDEENGLISH = $LARGEADRIGHTSIDEENGLISH."src=\"http:\/\/ws-na.amazon-adsystem.com\/widgets\/q?rt=tf_sw&ServiceVersion=20070822&MarketPlace=US&Operation=GetScript&ID=OneJS&WS=1&source=ac\">";
                   #$LARGEADRIGHTSIDEENGLISH = $LARGEADRIGHTSIDEENGLISH."<\/script>";
                 }
                 if ($WebsiteLanguage eq "Dutch") {
                   # Amazon ad
                   $LARGEADRIGHTSIDEDUTCH = "<DUMMY>";
                   #$LARGEADRIGHTSIDEDUTCH = "\n<script type=\"text\/javascript\"> ";
                   #$LARGEADRIGHTSIDEDUTCH = $LARGEADRIGHTSIDEDUTCH."amzn_assoc_ad_type = \"search\"; amzn_assoc_tracking_id = \"bermword-20\"; amzn_assoc_marketplace = \"amazon\"; amzn_assoc_region = \"US\"; ";
                   #$LARGEADRIGHTSIDEDUTCH = $LARGEADRIGHTSIDEDUTCH."amzn_assoc_show_price = \"true\"; amzn_assoc_show_rating = \"true\"; amzn_assoc_show_image = \"true\"; amzn_assoc_width = \"336\"; ";
                   #$LARGEADRIGHTSIDEDUTCH = $LARGEADRIGHTSIDEDUTCH."amzn_assoc_height =  \"280\"; amzn_assoc_default_search_key =  \"portuguese edition\"; amzn_assoc_department =  \"Books\";";
                   #$LARGEADRIGHTSIDEDUTCH = $LARGEADRIGHTSIDEDUTCH."<\/script><script type=\"text\/javascript\" ";
                   #$LARGEADRIGHTSIDEDUTCH = $LARGEADRIGHTSIDEDUTCH."src=\"http:\/\/ws-na.amazon-adsystem.com\/widgets\/q?rt=tf_sw&ServiceVersion=20070822&MarketPlace=US&Operation=GetScript&ID=OneJS&WS=1&source=ac\">";
                   #$LARGEADRIGHTSIDEDUTCH = $LARGEADRIGHTSIDEDUTCH."<\/script>";
                 }
              }
              if ($Language eq "Russian") {
                   # Pegasus ad
                   $LARGEADRIGHTSIDEDUTCH = "\n<BR><BR><A href='http:\/\/www.pegasusboek.nl' onclick=\"window.open(this.href); return false;\"><img src='..\/Pics\/kop_pegasus_2013.jpg' class=noborder width='312px' height='57px' valign='middle' /><FONT color=orange><B>Boekhandel Pegasus - Oost-Europese Talen</B></FONT><\/A>";
                   $LARGEADRIGHTSIDEENGLISH = $LARGEADRIGHTSIDEDUTCH;
              }
              if ($Language eq "Spanish") {
                   $LARGEADRIGHTSIDEDUTCH = "\n<a href='http://www.vanstockum.nl/boeken/kinderboeken/fictie-13-15-jaar/es/la-ciudad-de-las-bestias-allende-isabel-9788497935692/' onclick='window.open(this.href); return false;'><img style=\"border-style: none; border-width: 0px; margin-top: 10px; margin-left: 0px; margin-bottom: 10px;\" title=\"Isabel Allende - La Ciudad De Las Bestias\" alt=\"Isabel Allende - La Ciudad De Las Bestias\" src='Pics\/LaCiudadDeLasBestias.jpg' align=right width='100px' height='150px' /></img></a>";
                   $LARGEADRIGHTSIDEDUTCH = $LARGEADRIGHTSIDEDUTCH."\n<a href='http://www.vanstockum.nl/boeken/romans-spanning/literaire-fictie-algemeen/es/la-casa-de-los-amores-imposibles--the-house-of-impossible-loves-barrio-cristina-lopez-9780345804266/' onclick='window.open(this.href); return false;'><img style=\"border-style: none; border-width: 0px; margin-top: 10px; margin-left: 0px; margin-bottom: 10px;\" title=\"Christina López Barrio - La Casa De Los Amores Imposibles\" alt=\"Christina López Barrio - La Casa De Los Amores Imposibles\" src='Pics\/LaCasaDeLosAmoresImposibles.jpg' align=left width='100px' height='150px' /></img></a>";
                   $LARGEADRIGHTSIDEDUTCH = $LARGEADRIGHTSIDEDUTCH."\n<a href='http://www.vanstockum.nl/boeken/romans-spanning/literaire-fictie-algemeen/es/el-amor-en-los-tiempos-del-colera--love-in-the-time-of-cholera-garca-mrquez-gabriel-9780307387264/' onclick='window.open(this.href); return false;'><img style=\"border-style: none; border-width: 0px; margin-top: 10px; margin-left: 22px; margin-bottom: 10px;\" title=\"Gabriel García Márquez - El Amor En Los Tiempos Del Cólera\" alt=\"Gabriel García Márquez - El Amor En Los Tiempos Del Cólera\"src='Pics\/ElAmorEnLosTiemposDelColera.jpg' align=center width='100px' height='150px' /></img></a>";
                   $LARGEADRIGHTSIDEDUTCH = $LARGEADRIGHTSIDEDUTCH."<!-- BEGIN BANNER VANSTOCKUM -->";
                   $LARGEADRIGHTSIDEDUTCH = $LARGEADRIGHTSIDEDUTCH."<br><div align=center><div style=\"position:relative; width:209px; height:60px;\">";
                   $LARGEADRIGHTSIDEDUTCH = $LARGEADRIGHTSIDEDUTCH."<div id=\"vst_banner-rechts\" style=\"position:absolute; right:0; top:0; width:209px; height:60px; background-image:url";
                   $LARGEADRIGHTSIDEDUTCH = $LARGEADRIGHTSIDEDUTCH."(http://www.vanstockum.nl/images/banners/banner5/right.gif);\">";
                   $LARGEADRIGHTSIDEDUTCH = $LARGEADRIGHTSIDEDUTCH."<input id=\"banner5-input\" value=\"Spaans\" disabled='disabled' type=\"text\" style=\"position:absolute; left:64px; top:20px; border:0 none; width:85px; height:17px;";
                   $LARGEADRIGHTSIDEDUTCH = $LARGEADRIGHTSIDEDUTCH."font-family:Verdana, Arial, Helvetica, sans-serif; font-size:10px;\" />";
                   $LARGEADRIGHTSIDEDUTCH = $LARGEADRIGHTSIDEDUTCH."<a href=\"javascript:submit_banner5();\"><img src=\"http://www.vanstockum.nl/images/banners/banner5/button.gif\" border=\"0\" ";
                   $LARGEADRIGHTSIDEDUTCH = $LARGEADRIGHTSIDEDUTCH."style=\"position:absolute; right:4px; top:20px;\"/></a></div></div><script language=\"javascript\">function submit_banner5(){";
                   $LARGEADRIGHTSIDEDUTCH = $LARGEADRIGHTSIDEDUTCH."window.location='http://www.vanstockum.nl/search?q%5Bnur%5D=2124&search_dropdown=language%3A12&q%5Bq%5D=&x=31&y=16'}</script></div>";
                   $LARGEADRIGHTSIDEDUTCH = $LARGEADRIGHTSIDEDUTCH."<!-- EINDE BANNER VANSTOCKUM -->";
                   
                   #copy for english
                   $LARGEADRIGHTSIDEENGLISH = $LARGEADRIGHTSIDEDUTCH;
                   # Bol ad
                   #$LARGEADRIGHTSIDEDUTCH = "\n<script type='text/javascript' language='javascript'>";
                   #$LARGEADRIGHTSIDEDUTCH = $LARGEADRIGHTSIDEDUTCH."var bol_pml={\"id\":\"bol_script1396406651884\",\"baseUrl\":\"partnerprogramma.bol.com\",\"secure\":false,";
                   #$LARGEADRIGHTSIDEDUTCH = $LARGEADRIGHTSIDEDUTCH."\"nrProducts\":\"4\",\"title\":\"\",\"price_color\":\"#CB0100\",\"priceRangeId\":\"none\",\"catID\":\"8298+2510\",\"header\":true,";
                   #$LARGEADRIGHTSIDEDUTCH = $LARGEADRIGHTSIDEDUTCH."\"urlPrefix\":\"http:\/\/aai.bol.com\/aai\",\"site_id\":\"27295\",\"target\":true,\"rating\":true,\"price\":true,\"image_size\":false,";
                   #$LARGEADRIGHTSIDEDUTCH = $LARGEADRIGHTSIDEDUTCH."\"link_name\":\"Ittolaja\",\"link_subid\":\"Spanish\",\"image_position\":\"left\",\"width\":\"340\",\"cols\":\"2\",";
                   #$LARGEADRIGHTSIDEDUTCH = $LARGEADRIGHTSIDEDUTCH."\"background_color\":\"#FFFFFF\",\"text_color\":\"#000000\",\"link_color\":\"#0000FF\",\"border_color\":\"#D2D2D2\",\"letter_type\":\"verdana\",\"letter_size\":\"10\"};";
                   #$LARGEADRIGHTSIDEDUTCH = $LARGEADRIGHTSIDEDUTCH."<\/script><script id=\"bol_script1396406651884\" src=\"http:\/\/partnerprogramma.bol.com\/partner\/static\/js\/aai\/clientBestsellerGenerator.js\" type=\"text\/javascript\"><\/script>";              
              }
              if ($Language eq "Swedish") {
                 # Bokus ad
                 $LARGEADRIGHTSIDE = "\n<br><script type='text\/javascript'>";
                 $LARGEADRIGHTSIDE = $LARGEADRIGHTSIDE."(function(){var d=new Date();var ds=d.getYear()+'-'+d.getMonth()+'-'+d.getDate();";
                 $LARGEADRIGHTSIDE = $LARGEADRIGHTSIDE."document.write('<script type=\"text/javascript\" charset=\"ISO-8859-1\" src=\"http:\/\/www.bokus.com\/generated\/external\/toplists\/bokustoppen_banner.js?'+ds+'\"><\\/script>');";
                 $LARGEADRIGHTSIDE = $LARGEADRIGHTSIDE."})();";
                 $LARGEADRIGHTSIDE = $LARGEADRIGHTSIDE."<\/script><script type='text\/javascript'>";
                 $LARGEADRIGHTSIDE = $LARGEADRIGHTSIDE."document.write(BokusTop.GetCode(\"text-375x250\", \"http:\/\/tracker.tradedoubler.com\/click?p=362&g=19550564&a=2388667&url=\"));";
                 $LARGEADRIGHTSIDE = $LARGEADRIGHTSIDE."</script>";
                 $LARGEADRIGHTSIDEENGLISH = $LARGEADRIGHTSIDE;
                 $LARGEADRIGHTSIDEDUTCH = $LARGEADRIGHTSIDE;
              }
              
              # SMALL THIRDROW ADS
              if ($Language eq "Dutch") {
                 # Bermuda Word ad
                 if ($WebsiteHTMLName =~ "fairytales") {
                    $SMALLADTHIRDROW = "<object width=\"340\" height=\"191\"><param name=\"movie\" value=\"//www.youtube.com/v/u1OQajEIKrg?hl=en_US&amp;version=3&amp;rel=0\"></param><param name=\"allowFullScreen\" value=\"true\"></param><param name=\"allowscriptaccess\" value=\"always\"></param><embed src=\"//www.youtube.com/v/jcE6WyLhgC0?hl=en_US&amp;version=3&amp;rel=0\" type=\"application/x-shockwave-flash\" width=\"340\" height=\"191\" allowscriptaccess=\"always\" allowfullscreen=\"true\"></embed></object>";
                    $SMALLADTHIRDROWENGLISH = $SMALLADTHIRDROW;
                    $SMALLADTHIRDROWDUTCH = $SMALLADTHIRDROW;
                 }
                 if ($WebsiteHTMLName =~ "shortstories") {
                    $SMALLADTHIRDROW = "<object width=\"340\" height=\"191\"><param name=\"movie\" value=\"//www.youtube.com/v/u1OQajEIKrg?hl=en_US&amp;version=3&amp;rel=0\"></param><param name=\"allowFullScreen\" value=\"true\"></param><param name=\"allowscriptaccess\" value=\"always\"></param><embed src=\"//www.youtube.com/v/jcE6WyLhgC0?hl=en_US&amp;version=3&amp;rel=0\" type=\"application/x-shockwave-flash\" width=\"340\" height=\"191\" allowscriptaccess=\"always\" allowfullscreen=\"true\"></embed></object>";
                    $SMALLADTHIRDROWENGLISHSS = $SMALLADTHIRDROW;
                    $SMALLADTHIRDROWDUTCHSS = $SMALLADTHIRDROW;
                 }
              }
              if ($Language eq "English") {
                 # Bermuda Word ad
                 if ($WebsiteHTMLName =~ "fairytales") {
                    #$SMALLADTHIRDROW = "<object width=\"340\" height=\"191\"><param name=\"movie\" value=\"//www.youtube.com/v/u1OQajEIKrg?hl=en_US&amp;version=3&amp;rel=0\"></param><param name=\"allowFullScreen\" value=\"true\"></param><param name=\"allowscriptaccess\" value=\"always\"></param><embed src=\"//www.youtube.com/v/u1OQajEIKrg?hl=en_US&amp;version=3&amp;rel=0\" type=\"application/x-shockwave-flash\" width=\"340\" height=\"191\" allowscriptaccess=\"always\" allowfullscreen=\"true\"></embed></object>";
                    #$SMALLADTHIRDROWENGLISH = $SMALLADTHIRDROW;
                    #$SMALLADTHIRDROWDUTCH = $SMALLADTHIRDROW;
                 }
                 if ($WebsiteHTMLName =~ "shortstories") {
                    #$SMALLADTHIRDROW = "<object width=\"340\" height=\"191\"><param name=\"movie\" value=\"//www.youtube.com/v/Ru55vlMarh4?version=3&amp;hl=en_US&amp;rel=0\"></param><param name=\"allowFullScreen\" value=\"true\"></param><param name=\"allowscriptaccess\" value=\"always\"></param><embed src=\"//www.youtube.com/v/Ru55vlMarh4?version=3&amp;hl=en_US&amp;rel=0\" type=\"application/x-shockwave-flash\" width=\"340\" height=\"191\" allowscriptaccess=\"always\" allowfullscreen=\"true\"></embed></object>";
                    #$SMALLADTHIRDROWENGLISHSS = $SMALLADTHIRDROW;
                    #$SMALLADTHIRDROWDUTCHSS = $SMALLADTHIRDROW;
                 }
              }
              if ($Language eq "French") {
                 # Bermuda Word ad
                 if ($WebsiteHTMLName =~ "fairytales") {
                    $SMALLADTHIRDROW = "<object width=\"340\" height=\"191\"><param name=\"movie\" value=\"//www.youtube.com/v/4lh7BSNk3xE?version=3&amp;hl=en_US&amp;rel=0\"></param><param name=\"allowFullScreen\" value=\"true\"></param><param name=\"allowscriptaccess\" value=\"always\"></param><embed src=\"//www.youtube.com/v/4lh7BSNk3xE?version=3&amp;hl=en_US&amp;rel=0\" type=\"application/x-shockwave-flash\" width=\"340\" height=\"191\" allowscriptaccess=\"always\" allowfullscreen=\"true\"></embed></object>";
                    $SMALLADTHIRDROWENGLISH = $SMALLADTHIRDROW;
                    $SMALLADTHIRDROWDUTCH = $SMALLADTHIRDROW;
                 }
                 if ($WebsiteHTMLName =~ "shortstories") {
                    $SMALLADTHIRDROW = "<object width=\"340\" height=\"191\"><param name=\"movie\" value=\"//www.youtube.com/v/Ft9D6bbsWTo?hl=en_US&amp;version=3&amp;rel=0\"></param><param name=\"allowFullScreen\" value=\"true\"></param><param name=\"allowscriptaccess\" value=\"always\"></param><embed src=\"//www.youtube.com/v/Ft9D6bbsWTo?hl=en_US&amp;version=3&amp;rel=0\" type=\"application/x-shockwave-flash\" width=\"340\" height=\"191\" allowscriptaccess=\"always\" allowfullscreen=\"true\"></embed></object>";
                    $SMALLADTHIRDROWENGLISHSS = $SMALLADTHIRDROW;
                    $SMALLADTHIRDROWDUTCHSS = $SMALLADTHIRDROW;
                 }
              }
              if ($Language eq "German") {
                 # Bermuda Word ad
                 if ($WebsiteHTMLName =~ "fairytales") {
                    $SMALLADTHIRDROW = "<object width=\"340\" height=\"191\"><param name=\"movie\" value=\"//www.youtube.com/v/VT0Y56M3Kh4?hl=en_US&amp;version=3&amp;rel=0\"></param><param name=\"allowFullScreen\" value=\"true\"></param><param name=\"allowscriptaccess\" value=\"always\"></param><embed src=\"//www.youtube.com/v/VT0Y56M3Kh4?hl=en_US&amp;version=3&amp;rel=0\" type=\"application/x-shockwave-flash\" width=\"340\" height=\"191\" allowscriptaccess=\"always\" allowfullscreen=\"true\"></embed></object>";
                    $SMALLADTHIRDROWENGLISH = $SMALLADTHIRDROW;
                    $SMALLADTHIRDROWDUTCH = $SMALLADTHIRDROW;
                 }
                 if ($WebsiteHTMLName =~ "shortstories") {
                    $SMALLADTHIRDROW = "<object width=\"340\" height=\"191\"><param name=\"movie\" value=\"//www.youtube.com/v/Z7iHw2G4Nzo?version=3&amp;hl=en_US&amp;rel=0\"></param><param name=\"allowFullScreen\" value=\"true\"></param><param name=\"allowscriptaccess\" value=\"always\"></param><embed src=\"//www.youtube.com/v/Z7iHw2G4Nzo?version=3&amp;hl=en_US&amp;rel=0\" type=\"application/x-shockwave-flash\" width=\"340\" height=\"191\" allowscriptaccess=\"always\" allowfullscreen=\"true\"></embed></object>";
                    $SMALLADTHIRDROWENGLISHSS = $SMALLADTHIRDROW;
                    $SMALLADTHIRDROWDUTCHSS = $SMALLADTHIRDROW;
                 }
              }
              if ($Language eq "Hungarian") {
                 # Bermuda Word ad
                 if ($WebsiteHTMLName =~ "fairytales") {
                    $SMALLADTHIRDROW = "<object width=\"340\" height=\"191\"><param name=\"movie\" value=\"//www.youtube.com/v/D1YOILGoZec?hl=en_US&amp;version=3&amp;rel=0\"></param><param name=\"allowFullScreen\" value=\"true\"></param><param name=\"allowscriptaccess\" value=\"always\"></param><embed src=\"//www.youtube.com/v/D1YOILGoZec?hl=en_US&amp;version=3&amp;rel=0\" type=\"application/x-shockwave-flash\" width=\"340\" height=\"191\" allowscriptaccess=\"always\" allowfullscreen=\"true\"></embed></object>";
                    $SMALLADTHIRDROWENGLISH = $SMALLADTHIRDROW;
                    $SMALLADTHIRDROWDUTCH = $SMALLADTHIRDROW;
                 }
                 if ($WebsiteHTMLName =~ "shortstories") {
                    $SMALLADTHIRDROW = "<object width=\"340\" height=\"191\"><param name=\"movie\" value=\"//www.youtube.com/v/D1YOILGoZec?version=3&amp;hl=en_US&amp;rel=0\"></param><param name=\"allowFullScreen\" value=\"true\"></param><param name=\"allowscriptaccess\" value=\"always\"></param><embed src=\"//www.youtube.com/v/D1YOILGoZec?version=3&amp;hl=en_US&amp;rel=0\" type=\"application/x-shockwave-flash\" width=\"340\" height=\"191\" allowscriptaccess=\"always\" allowfullscreen=\"true\"></embed></object>";
                    $SMALLADTHIRDROWENGLISHSS = $SMALLADTHIRDROW;
                    $SMALLADTHIRDROWDUTCHSS = $SMALLADTHIRDROW;
                 }
              }
              if ($Language eq "Indonesian") {
                 # Bermuda Word ad
                 if ($WebsiteHTMLName =~ "fairytales") {
                    #$SMALLADTHIRDROW = "<object width=\"340\" height=\"191\"><param name=\"movie\" value=\"//www.youtube.com/v/u1OQajEIKrg?hl=en_US&amp;version=3&amp;rel=0\"></param><param name=\"allowFullScreen\" value=\"true\"></param><param name=\"allowscriptaccess\" value=\"always\"></param><embed src=\"//www.youtube.com/v/u1OQajEIKrg?hl=en_US&amp;version=3&amp;rel=0\" type=\"application/x-shockwave-flash\" width=\"340\" height=\"191\" allowscriptaccess=\"always\" allowfullscreen=\"true\"></embed></object>";
                    #$SMALLADTHIRDROWENGLISH = $SMALLADTHIRDROW;
                    #$SMALLADTHIRDROWDUTCH = $SMALLADTHIRDROW;
                 }
                 if ($WebsiteHTMLName =~ "shortstories") {
                    #$SMALLADTHIRDROW = "<object width=\"340\" height=\"191\"><param name=\"movie\" value=\"//www.youtube.com/v/Ru55vlMarh4?version=3&amp;hl=en_US&amp;rel=0\"></param><param name=\"allowFullScreen\" value=\"true\"></param><param name=\"allowscriptaccess\" value=\"always\"></param><embed src=\"//www.youtube.com/v/Ru55vlMarh4?version=3&amp;hl=en_US&amp;rel=0\" type=\"application/x-shockwave-flash\" width=\"340\" height=\"191\" allowscriptaccess=\"always\" allowfullscreen=\"true\"></embed></object>";
                    #$SMALLADTHIRDROWENGLISHSS = $SMALLADTHIRDROW;
                    #$SMALLADTHIRDROWDUTCHSS = $SMALLADTHIRDROW;
                 }
              }
              if ($Language eq "Italian") {
                 # Bermuda Word ad
                 if ($WebsiteHTMLName =~ "fairytales") {
                    $SMALLADTHIRDROW = "<object width=\"340\" height=\"191\"><param name=\"movie\" value=\"//www.youtube.com/v/vX38khwWCJc?hl=en_US&amp;version=3&amp;rel=0\"></param><param name=\"allowFullScreen\" value=\"true\"></param><param name=\"allowscriptaccess\" value=\"always\"></param><embed src=\"//www.youtube.com/v/vX38khwWCJc?hl=en_US&amp;version=3&amp;rel=0\" type=\"application/x-shockwave-flash\" width=\"340\" height=\"191\" allowscriptaccess=\"always\" allowfullscreen=\"true\"></embed></object>";
                    $SMALLADTHIRDROWENGLISH = $SMALLADTHIRDROW;
                    $SMALLADTHIRDROWDUTCH = $SMALLADTHIRDROW;
                 }
                 if ($WebsiteHTMLName =~ "shortstories") {
                    $SMALLADTHIRDROW = "<object width=\"340\" height=\"191\"><param name=\"movie\" value=\"//www.youtube.com/v/vX38khwWCJc?version=3&amp;hl=en_US&amp;rel=0\"></param><param name=\"allowFullScreen\" value=\"true\"></param><param name=\"allowscriptaccess\" value=\"always\"></param><embed src=\"//www.youtube.com/v/vX38khwWCJc?version=3&amp;hl=en_US&amp;rel=0\" type=\"application/x-shockwave-flash\" width=\"340\" height=\"191\" allowscriptaccess=\"always\" allowfullscreen=\"true\"></embed></object>";
                    $SMALLADTHIRDROWENGLISHSS = $SMALLADTHIRDROW;
                    $SMALLADTHIRDROWDUTCHSS = $SMALLADTHIRDROW;
                 }
              }
              if ($Language eq "Polish") {
                 # Bermuda Word ad
                 if ($WebsiteHTMLName =~ "fairytales") {
                    $SMALLADTHIRDROW = "<object width=\"340\" height=\"191\"><param name=\"movie\" value=\"//www.youtube.com/v/myIg356X6FY?hl=en_US&amp;version=3&amp;rel=0\"></param><param name=\"allowFullScreen\" value=\"true\"></param><param name=\"allowscriptaccess\" value=\"always\"></param><embed src=\"//www.youtube.com/v/myIg356X6FY?hl=en_US&amp;version=3&amp;rel=0\" type=\"application/x-shockwave-flash\" width=\"340\" height=\"191\" allowscriptaccess=\"always\" allowfullscreen=\"true\"></embed></object>";
                    $SMALLADTHIRDROWENGLISH = $SMALLADTHIRDROW;
                    $SMALLADTHIRDROWDUTCH = $SMALLADTHIRDROW;
                 }
                 if ($WebsiteHTMLName =~ "shortstories") {
                    $SMALLADTHIRDROW = "<object width=\"340\" height=\"191\"><param name=\"movie\" value=\"//www.youtube.com/v/myIg356X6FY?version=3&amp;hl=en_US&amp;rel=0\"></param><param name=\"allowFullScreen\" value=\"true\"></param><param name=\"allowscriptaccess\" value=\"always\"></param><embed src=\"//www.youtube.com/v/myIg356X6FY?version=3&amp;hl=en_US&amp;rel=0\" type=\"application/x-shockwave-flash\" width=\"340\" height=\"191\" allowscriptaccess=\"always\" allowfullscreen=\"true\"></embed></object>";
                    $SMALLADTHIRDROWENGLISHSS = $SMALLADTHIRDROW;
                    $SMALLADTHIRDROWDUTCHSS = $SMALLADTHIRDROW;
                 }
              }
              if ($Language eq "Portuguese") {
                 # Bermuda Word ad
                 if ($WebsiteHTMLName =~ "fairytales") {
                    #$SMALLADTHIRDROW = "<object width=\"340\" height=\"191\"><param name=\"movie\" value=\"//www.youtube.com/v/u1OQajEIKrg?hl=en_US&amp;version=3&amp;rel=0\"></param><param name=\"allowFullScreen\" value=\"true\"></param><param name=\"allowscriptaccess\" value=\"always\"></param><embed src=\"//www.youtube.com/v/u1OQajEIKrg?hl=en_US&amp;version=3&amp;rel=0\" type=\"application/x-shockwave-flash\" width=\"340\" height=\"191\" allowscriptaccess=\"always\" allowfullscreen=\"true\"></embed></object>";
                    #$SMALLADTHIRDROWENGLISH = $SMALLADTHIRDROW;
                    #$SMALLADTHIRDROWDUTCH = $SMALLADTHIRDROW;
                 }
                 if ($WebsiteHTMLName =~ "shortstories") {
                    #$SMALLADTHIRDROW = "<object width=\"340\" height=\"191\"><param name=\"movie\" value=\"//www.youtube.com/v/Ru55vlMarh4?version=3&amp;hl=en_US&amp;rel=0\"></param><param name=\"allowFullScreen\" value=\"true\"></param><param name=\"allowscriptaccess\" value=\"always\"></param><embed src=\"//www.youtube.com/v/Ru55vlMarh4?version=3&amp;hl=en_US&amp;rel=0\" type=\"application/x-shockwave-flash\" width=\"340\" height=\"191\" allowscriptaccess=\"always\" allowfullscreen=\"true\"></embed></object>";
                    #$SMALLADTHIRDROWENGLISHSS = $SMALLADTHIRDROW;
                    #$SMALLADTHIRDROWDUTCHSS = $SMALLADTHIRDROW;
                 }
              }
              if ($Language eq "Russian") {
                 # Bermuda Word ad
                 if ($WebsiteHTMLName =~ "fairytales") {
                    $SMALLADTHIRDROW = "<object width=\"340\" height=\"191\"><param name=\"movie\" value=\"//www.youtube.com/v/u1OQajEIKrg?hl=en_US&amp;version=3&amp;rel=0\"></param><param name=\"allowFullScreen\" value=\"true\"></param><param name=\"allowscriptaccess\" value=\"always\"></param><embed src=\"//www.youtube.com/v/u1OQajEIKrg?hl=en_US&amp;version=3&amp;rel=0\" type=\"application/x-shockwave-flash\" width=\"340\" height=\"191\" allowscriptaccess=\"always\" allowfullscreen=\"true\"></embed></object>";
                    $SMALLADTHIRDROWENGLISH = $SMALLADTHIRDROW;
                    $SMALLADTHIRDROWDUTCH = $SMALLADTHIRDROW;
                 }
                 if ($WebsiteHTMLName =~ "shortstories") {
                    $SMALLADTHIRDROW = "<object width=\"340\" height=\"191\"><param name=\"movie\" value=\"//www.youtube.com/v/Ru55vlMarh4?version=3&amp;hl=en_US&amp;rel=0\"></param><param name=\"allowFullScreen\" value=\"true\"></param><param name=\"allowscriptaccess\" value=\"always\"></param><embed src=\"//www.youtube.com/v/Ru55vlMarh4?version=3&amp;hl=en_US&amp;rel=0\" type=\"application/x-shockwave-flash\" width=\"340\" height=\"191\" allowscriptaccess=\"always\" allowfullscreen=\"true\"></embed></object>";
                    $SMALLADTHIRDROWENGLISHSS = $SMALLADTHIRDROW;
                    $SMALLADTHIRDROWDUTCHSS = $SMALLADTHIRDROW;
                 }
              }
              if ($Language eq "Spanish") {
                 # Bermuda Word ad
                 if ($WebsiteHTMLName =~ "fairytales") {
                    $SMALLADTHIRDROW = "<object width=\"340\" height=\"191\"><param name=\"movie\" value=\"//www.youtube.com/v/yLNqMsj1Wf8?version=3&amp;hl=en_US&amp;rel=0\"></param><param name=\"allowFullScreen\" value=\"true\"></param><param name=\"allowscriptaccess\" value=\"always\"></param><embed src=\"//www.youtube.com/v/yLNqMsj1Wf8?version=3&amp;hl=en_US&amp;rel=0\" type=\"application/x-shockwave-flash\" width=\"340\" height=\"191\" allowscriptaccess=\"always\" allowfullscreen=\"true\"></embed></object>";
                    $SMALLADTHIRDROWENGLISH = $SMALLADTHIRDROW;
                    $SMALLADTHIRDROWDUTCH = $SMALLADTHIRDROW;
                 }
                 if ($WebsiteHTMLName =~ "shortstories") {
                    $SMALLADTHIRDROW = "<object width=\"340\" height=\"191\"><param name=\"movie\" value=\"//www.youtube.com/v/yLNqMsj1Wf8?version=3&amp;hl=en_US&amp;rel=0\"></param><param name=\"allowFullScreen\" value=\"true\"></param><param name=\"allowscriptaccess\" value=\"always\"></param><embed src=\"//www.youtube.com/v/yLNqMsj1Wf8?version=3&amp;hl=en_US&amp;rel=0\" type=\"application/x-shockwave-flash\" width=\"340\" height=\"191\" allowscriptaccess=\"always\" allowfullscreen=\"true\"></embed></object>";
                    $SMALLADTHIRDROWENGLISHSS = $SMALLADTHIRDROW;
                    $SMALLADTHIRDROWDUTCHSS = $SMALLADTHIRDROW;
                 }
              }
              if ($Language eq "Swedish") {
                 # Bermuda Word ad
                 if ($WebsiteHTMLName =~ "fairytales") {
                    $SMALLADTHIRDROW = "<object width=\"340\" height=\"191\"><param name=\"movie\" value=\"//www.youtube.com/v/w6TlWnSa6v0?hl=en_US&amp;version=3&amp;rel=0\"></param><param name=\"allowFullScreen\" value=\"true\"></param><param name=\"allowscriptaccess\" value=\"always\"></param><embed src=\"//www.youtube.com/v/w6TlWnSa6v0?hl=en_US&amp;version=3&amp;rel=0\" type=\"application/x-shockwave-flash\" width=\"340\" height=\"191\" allowscriptaccess=\"always\" allowfullscreen=\"true\"></embed></object>";
                    $SMALLADTHIRDROWENGLISH = $SMALLADTHIRDROW;
                    $SMALLADTHIRDROWDUTCH = $SMALLADTHIRDROW;
                 }
                 if ($WebsiteHTMLName =~ "shortstories") {
                    $SMALLADTHIRDROW = "<object width=\"340\" height=\"191\"><param name=\"movie\" value=\"//www.youtube.com/v/dATveGbxkRA?version=3&amp;hl=en_US&amp;rel=0\"></param><param name=\"allowFullScreen\" value=\"true\"></param><param name=\"allowscriptaccess\" value=\"always\"></param><embed src=\"//www.youtube.com/v/dATveGbxkRA?version=3&amp;hl=en_US&amp;rel=0\" type=\"application/x-shockwave-flash\" width=\"340\" height=\"191\" allowscriptaccess=\"always\" allowfullscreen=\"true\"></embed></object>";
                    $SMALLADTHIRDROWENGLISHSS = $SMALLADTHIRDROW;
                    $SMALLADTHIRDROWDUTCHSS = $SMALLADTHIRDROW;
                 }
              }
              # Bookshop Webpage Menu
              if ($WebsiteLanguage eq "English") {
                 # website in english
                 $MENUFIRSTTEXTENGLISH = $MENUFIRSTTEXTENGLISH."<div align='center'><a href='../<bwhome>.htm' title='Home'><img src='../Pics/BermudaWordHomeMap.jpg' class=noborder width='170px' height='50px'/></div></a><div class=smallish><br><br></div>";
                 $MENUFIRSTTEXTENGLISH = $MENUFIRSTTEXTENGLISH."<CENTER><B>LEARN TO READ $CapLanguage<\/B><div class=smallish><br><br></div>";
                 $MENUFIRSTTEXTENGLISH = $MENUFIRSTTEXTENGLISH."<\/CENTER>";
                 $MENUFIRSTTEXTENGLISH = $MENUFIRSTTEXTENGLISH."1. Check out our stories displayed on the left or go to our <a class=buyblue href='https://www.learn-to-read-foreign-languages.com' title='Bermuda Word Shop'><b>SITE</b></a> and download a demo of the e-book software.<br>";
                 $MENUFIRSTTEXTENGLISH = $MENUFIRSTTEXTENGLISH."2. <a class=buyblue href='https://www.learn-to-read-foreign-languages.com' title='Bermuda Word Shop'><b>BUY</b></a> them, with the pop-up translation and spaced repetition you will quickly develop a large vocabulary.<br>";
                 $MENUFIRSTTEXTENGLISH = $MENUFIRSTTEXTENGLISH."3. Soon you'll be able to read $Language bestsellers and literature like the ones sold via our partners linked below! ";
                 $MENUFIRSTTEXTENGLISH = $MENUFIRSTTEXTENGLISH."\n";
              }
              if ($WebsiteLanguage eq "Dutch") {
                 # website in dutch
                 $MENUFIRSTTEXTDUTCH = $MENUFIRSTTEXTDUTCH."<div align='center'><a href='../<bwhome>.htm' title='Home'><img src='../Pics/BermudaWordHomeMap.jpg' class=noborder width='170px' height='50px'/></a></div><div class=smallish><br><br></div>";
                 $MENUFIRSTTEXTDUTCH = $MENUFIRSTTEXTDUTCH."<CENTER><B>LEER $CapLanguageDutch LEZEN<\/B><div class=smallish><br><br></div>";
                 $MENUFIRSTTEXTDUTCH = $MENUFIRSTTEXTDUTCH."<\/CENTER>";
                 $MENUFIRSTTEXTDUTCH = $MENUFIRSTTEXTDUTCH."1. Bekijk de demo's van de e-books hiernaast of ga naar onze <a class=buyblue href='https://www.learn-to-read-foreign-languages.com' title='Bermuda Word Shop'><b>SITE</b></a> en download een demo van de e-book software.<br>";
                 $MENUFIRSTTEXTDUTCH = $MENUFIRSTTEXTDUTCH."2. <a class=buyblue href='https://www.learn-to-read-foreign-languages.com' title='Bermuda Word Shop'><b>KOOP</b></a> ze, en met de ingebouwde pop-up vertaling en spaced repetition krijg je snel een grote woordenschat.<br>";
                 $MENUFIRSTTEXTDUTCH = $MENUFIRSTTEXTDUTCH."3. Daarna kan je $LanguageDutchBVN boeken lezen zoals verkocht via onze partners bereikbaar via de link hieronder: ";
                 $MENUFIRSTTEXTDUTCH = $MENUFIRSTTEXTDUTCH."\n";
              }
              
           }
           if ($TRACING eq "ON") {
             print "Changed $BOOKSLOT to $BOOKSLOTNEW";
           } else { print ".";}
  
           # generic
           $MENUFIRSTTEXTENGLISH = $MENUFIRSTTEXTENGLISH."<BR>";
           $MENUFIRSTTEXTDUTCH = $MENUFIRSTTEXTDUTCH."<BR>";
  
           $ALLTEXTENGLISH = $ALLTEXTBASEENGLISH;
           $ALLTEXTENGLISH =~ s/<<<LANGUAGE>>>/$Language/g;
           $ALLTEXTENGLISH =~ s/<dutchlanguage>/Dutch/g;
           $ALLTEXTENGLISH =~ s/<englishlanguage>/English/g;
           $ALLTEXTENGLISH =~ s/<frenchlanguage>/French/g;
           $ALLTEXTENGLISH =~ s/<germanlanguage>/German/g;
           $ALLTEXTENGLISH =~ s/<italianlanguage>/Italian/g;
           $ALLTEXTENGLISH =~ s/<russianlanguage>/Russian/g;
           $ALLTEXTENGLISH =~ s/<spanishlanguage>/Spanish/g;
           $ALLTEXTENGLISH =~ s/<swedishlanguage>/Swedish/g;
           $ALLTEXTENGLISH =~ s/<greeklanguage>/Greek/g;
           $ALLTEXTENGLISH =~ s/<portugueselanguage>/Portuguese/g;
           $ALLTEXTENGLISH =~ s/<indonesianlanguage>/Indonesian/g;
           $ALLTEXTENGLISH =~ s/<polishlanguage>/Polish/g;
           $ALLTEXTENGLISH =~ s/<hungarianlanguage>/Hungarian/g;
           $ALLTEXTENGLISH =~ s/<urdulanguage>/Urdu/g;
           $ALLTEXTENGLISH =~ s/<BOOKSLOTNEW>/$BOOKSLOTNEWENGLISH/;
           $ALLTEXTENGLISH =~ s/<RIGHTPAGETEXT>/$MENUFIRSTTEXTENGLISH/;
           $ALLTEXTENGLISH =~ s/<LARGEADRIGHTSIDE>/$LARGEADRIGHTSIDEENGLISH/;
           $ALLTEXTENGLISH =~ s/<sitelang>/index/g;
           $ALLTEXTENGLISH =~ s/<bwhome>/index/g;
           $ALLTEXTENGLISH =~ s/<shop>/shop/g;
           $ALLTEXTENGLISH =~ s/<CapitalShop>/Shop/g;
           $ALLTEXTENGLISH =~ s/<thispageinenglish>/index/g;
           $ALLTEXTENGLISH =~ s/<thispageindutch>/dutch/g;
           $ALLTEXTENGLISH =~ s/<THIRDROWAD>/$SMALLADTHIRDROWENGLISH/;
           
           $ALLTEXTDUTCH = $ALLTEXTBASEDUTCH;
           $ALLTEXTDUTCH =~ s/<<<LANGUAGE>>>/$Language/g;
       	 $ALLTEXTDUTCH =~ s/<dutchlanguage>/Nederlands/g;
           $ALLTEXTDUTCH =~ s/<englishlanguage>/Engels/g;
           $ALLTEXTDUTCH =~ s/<frenchlanguage>/Frans/g;
           $ALLTEXTDUTCH =~ s/<germanlanguage>/Duits/g;
           $ALLTEXTDUTCH =~ s/<italianlanguage>/Italiaans/g;
           $ALLTEXTDUTCH =~ s/<russianlanguage>/Russisch/g;
           $ALLTEXTDUTCH =~ s/<spanishlanguage>/Spaans/g;
           $ALLTEXTDUTCH =~ s/<swedishlanguage>/Zweeds/g;
           $ALLTEXTDUTCH =~ s/<greeklanguage>/Grieks/g;
           $ALLTEXTDUTCH =~ s/<portugueselanguage>/Portugees/g;
           $ALLTEXTDUTCH =~ s/<indonesianlanguage>/Indonesisch/g;
           $ALLTEXTDUTCH =~ s/<polishlanguage>/Pools/g;
           $ALLTEXTDUTCH =~ s/<hungarianlanguage>/Hongaars/g;
           $ALLTEXTDUTCH =~ s/<urdulanguage>/Urdu/g;
           $ALLTEXTDUTCH =~ s/<BOOKSLOTNEW>/$BOOKSLOTNEWDUTCH/;
           $ALLTEXTDUTCH =~ s/<RIGHTPAGETEXT>/$MENUFIRSTTEXTDUTCH/;
           $ALLTEXTDUTCH =~ s/<LARGEADRIGHTSIDE>/$LARGEADRIGHTSIDEDUTCH/;
           $ALLTEXTDUTCH =~ s/<sitelang>/dutch/g;
           $ALLTEXTDUTCH =~ s/<bwhome>/dutch/g;
           $ALLTEXTDUTCH =~ s/<shop>/winkel/g;
           $ALLTEXTDUTCH =~ s/<CapitalShop>/Winkel/g;
           $ALLTEXTDUTCH =~ s/<thispageindutch>/dutch/g;
           $ALLTEXTDUTCH =~ s/<thispageinenglish>/index/g;
           $ALLTEXTDUTCH =~ s/<THIRDROWAD>/$SMALLADTHIRDROWDUTCH/;
           
           
           $WriteFile = "../../Site/".$Language."/index.htm" ;
           if ($TRACING eq "ON") {
             print "Creating File $WriteFile... (English menu file for this book)...\n" ;
           } else { print ".";}
           open (WRITEFILE, ">$WriteFile") || die "file $WriteFile kan niet worden aangemaakt, ($!)\n";
           print WRITEFILE $ALLTEXTENGLISH ;
           close (WRITEFILE);
          
           #now in dutch (or other languages)
  
           $WriteFile = "../../Site/".$Language."/dutch.htm" ;
           if ($TRACING eq "ON") {
             print "Creating File $WriteFile... (Dutch menu file for this book)...\n" ;
           } else { print ".";}
           open (WRITEFILE, ">$WriteFile") || die "file $WriteFile kan niet worden aangemaakt, ($!)\n";
           print WRITEFILE $ALLTEXTDUTCH ;
           close (WRITEFILE);
       }
  
       if ($ThisIsTheFirstPage ne "NO") {
           if ($TRACING eq "ON") {
             print "This is the first page, first define menu pages for language!\n" ;
           } else { print ".";}
           $ThisIsTheFirstPage = "NO";
           $FrontPicture = $Language."Front";
           
           if ($WebsiteHTMLName =~ "fairytales") {
               # fairytale website in dutch
               $MENUSTORYTEXTDUTCH = $MENUSTORYTEXTDUTCH."<CENTER><B>$CapLanguageDutchBVN SPROOKJES<\/B><\/CENTER><BR>";
               $MENUSTORYTEXTDUTCH = $MENUSTORYTEXTDUTCH."Lees $LanguageDutchBVN sprookjes ";
               $MENUSTORYTEXTDUTCH = $MENUSTORYTEXTDUTCH."in het $LanguageDutch met een automatische pop-up vertaling in context ";
               $MENUSTORYTEXTDUTCH = $MENUSTORYTEXTDUTCH."en assimileer zo met gemak een woordenschat voor gevorderden. ";
               $MENUSTORYTEXTDUTCH = $MENUSTORYTEXTDUTCH."Steun ons en <a class=buyblue href='https://www.learn-to-read-foreign-languages.com' title='Bermuda Word Shop'><b>KOOP</b></a> onze Intelligente E-Books! "; 
               $MENUSTORYTEXTDUTCH = $MENUSTORYTEXTDUTCH."<BR><BR>";
               $MENUSTORYTEXTDUTCH = $MENUSTORYTEXTDUTCH."<CHAPTERLINKS>";
               $MENUSTORYTEXTDUTCH = $MENUSTORYTEXTDUTCH."<BR><BR>";
               $LASTFORMATTEDTEXTDUTCH = $MENUSTORYTEXTDUTCH;
               #set new bookslot link and picture
               $BOOKSLOTNEWDUTCH = "<a href='".$WebsiteHTMLName."menu_dutch.htm' title='$NiceBookName'><img src='Pics\/".$Language.$BookName."Dutch.jpg' class=noborder width='100px' height='150px' /></a>";
  
               # fairytale website in english
               $MENUSTORYTEXTENGLISH = $MENUSTORYTEXTENGLISH."<CENTER><B>$CapLanguage FAIRYTALES<\/B><\/CENTER><BR>";
               $MENUSTORYTEXTENGLISH = $MENUSTORYTEXTENGLISH."Read $Language fairytales ";
               $MENUSTORYTEXTENGLISH = $MENUSTORYTEXTENGLISH."in $Language with an automatic pop-up translation in context ";
               $MENUSTORYTEXTENGLISH = $MENUSTORYTEXTENGLISH."and assimilate with ease an advanced vocabulary. ";
               $MENUSTORYTEXTENGLISH = $MENUSTORYTEXTENGLISH."Support us and <a class=buyblue href='https://www.learn-to-read-foreign-languages.com' title='Bermuda Word Shop'><b>BUY</b></a> our Intelligent E-Books! ";
               $MENUSTORYTEXTENGLISH = $MENUSTORYTEXTENGLISH."<BR><BR>";
               $MENUSTORYTEXTENGLISH = $MENUSTORYTEXTENGLISH."<CHAPTERLINKS>";
               $MENUSTORYTEXTENGLISH = $MENUSTORYTEXTENGLISH."<BR><BR>";
               $LASTFORMATTEDTEXTENGLISH = $MENUSTORYTEXTENGLISH;
               #set new bookslot link and picture
               $BOOKSLOTNEWENGLISH = "<a href='".$WebsiteHTMLName."menu_english.htm' title='$NiceBookName'><img src='Pics\/".$Language.$BookName."English.jpg' class=noborder width='100px' height='150px' /></a>";
           }
           
           if ($WebsiteHTMLName =~ "shortstories") {
               # shortstory website in dutch
               $MENUSTORYTEXTDUTCH = $MENUSTORYTEXTDUTCH."<CENTER><B>$CapLanguageDutchBVN VERHALEN<\/B><\/CENTER><BR>";
               $MENUSTORYTEXTDUTCH = $MENUSTORYTEXTDUTCH."Lees $LanguageDutchBVN korte verhalen ";
               $MENUSTORYTEXTDUTCH = $MENUSTORYTEXTDUTCH."in het $LanguageDutch met een automatische pop-up vertaling in context ";
               $MENUSTORYTEXTDUTCH = $MENUSTORYTEXTDUTCH."en assimileer zo met gemak een woordenschat voor gevorderden. ";
               $MENUSTORYTEXTDUTCH = $MENUSTORYTEXTDUTCH."Steun ons en <a class=buyblue href='https://www.learn-to-read-foreign-languages.com' title='Bermuda Word Shop'><b>KOOP</b></a> onze Intelligente E-Books! "; 
               $MENUSTORYTEXTDUTCH = $MENUSTORYTEXTDUTCH."<BR><BR>";
               $MENUSTORYTEXTDUTCH = $MENUSTORYTEXTDUTCH."<CHAPTERLINKS>";
               $MENUSTORYTEXTDUTCH = $MENUSTORYTEXTDUTCH."<BR><BR>";
               $LASTFORMATTEDTEXTDUTCH = $MENUSTORYTEXTDUTCH;
               #set new bookslot link and picture
               $BOOKSLOTNEWDUTCH = "<a href='".$WebsiteHTMLName."menu_dutch.htm' title='$NiceBookName'><img src='Pics\/".$Language.$BookName."Dutch.jpg' class=noborder width='100px' height='150px' /></a>";
  
               # shortstory website in english
               $MENUSTORYTEXTENGLISH = $MENUSTORYTEXTENGLISH."<CENTER><B>$CapLanguage SHORTSTORIES<\/B><\/CENTER><BR>";
               $MENUSTORYTEXTENGLISH = $MENUSTORYTEXTENGLISH."Read $Language short stories ";
               $MENUSTORYTEXTENGLISH = $MENUSTORYTEXTENGLISH."in $Language with an automatic pop-up translation in context ";
               $MENUSTORYTEXTENGLISH = $MENUSTORYTEXTENGLISH."and assimilate with ease an advanced vocabulary. ";
               $MENUSTORYTEXTENGLISH = $MENUSTORYTEXTENGLISH."Support us and <a class=buyblue href='https://www.learn-to-read-foreign-languages.com' title='Bermuda Word Shop'><b>BUY</b></a> our Intelligent E-Books! ";
               $MENUSTORYTEXTENGLISH = $MENUSTORYTEXTENGLISH."<BR><BR>";
               $MENUSTORYTEXTENGLISH = $MENUSTORYTEXTENGLISH."<CHAPTERLINKS>";
               $MENUSTORYTEXTENGLISH = $MENUSTORYTEXTENGLISH."<BR><BR>";
               $LASTFORMATTEDTEXTENGLISH = $MENUSTORYTEXTENGLISH;
               #set new bookslot link and picture
               $BOOKSLOTNEWENGLISH = "<a href='".$WebsiteHTMLName."menu_english.htm' title='$NiceBookName'><img src='Pics\/".$Language.$BookName."English.jpg' class=noborder width='100px' height='150px' /></a>";
           }
  
           $thispageindutch = $WebsiteHTMLName."menu_dutch";
           $thispageinenglish = $WebsiteHTMLName."menu_english";
  
           $ALLTEXTENGLISH = $ALLTEXTBASEENGLISH;
           $ALLTEXTENGLISH =~ s/<<<LANGUAGE>>>/$Language/g;
           $ALLTEXTENGLISH =~ s/<dutchlanguage>/Dutch/g;
           $ALLTEXTENGLISH =~ s/<englishlanguage>/English/g;
           $ALLTEXTENGLISH =~ s/<frenchlanguage>/French/g;
           $ALLTEXTENGLISH =~ s/<germanlanguage>/German/g;
           $ALLTEXTENGLISH =~ s/<italianlanguage>/Italian/g;
           $ALLTEXTENGLISH =~ s/<russianlanguage>/Russian/g;
           $ALLTEXTENGLISH =~ s/<spanishlanguage>/Spanish/g;
           $ALLTEXTENGLISH =~ s/<swedishlanguage>/Swedish/g;
           $ALLTEXTENGLISH =~ s/<greeklanguage>/Greek/g;
           $ALLTEXTENGLISH =~ s/<portugueselanguage>/Portuguese/g;
           $ALLTEXTENGLISH =~ s/<indonesianlanguage>/Indonesian/g;
           $ALLTEXTENGLISH =~ s/<polishlanguage>/Polish/g;
           $ALLTEXTENGLISH =~ s/<hungarianlanguage>/Hungarian/g;
           $ALLTEXTENGLISH =~ s/<urdulanguage>/Urdu/g;
           $ALLTEXTENGLISH =~ s/<sitelang>/index/g;
           $ALLTEXTENGLISH =~ s/<bwhome>/index/g;
           $ALLTEXTENGLISH =~ s/<shop>/shop/g;
           $ALLTEXTENGLISH =~ s/<CapitalShop>/Shop/g;
           $ALLTEXTENGLISH =~ s/<RIGHTPAGETEXT>/$MENUSTORYTEXTENGLISH/;
           $ALLTEXTENGLISH =~ s/<thispageinenglish>/$thispageinenglish/;
           $ALLTEXTENGLISH =~ s/<thispageindutch>/$thispageindutch/;
           $ALLTEXTENGLISH =~ s/<BOOKSLOTNEW>/$BOOKSLOTNEWENGLISH/;
  
  
           $ALLTEXTDUTCH = $ALLTEXTBASEDUTCH;
           $ALLTEXTDUTCH =~ s/<<<LANGUAGE>>>/$Language/g;
           $ALLTEXTDUTCH =~ s/<dutchlanguage>/Nederlands/g;
           $ALLTEXTDUTCH =~ s/<englishlanguage>/Engels/g;
           $ALLTEXTDUTCH =~ s/<frenchlanguage>/Frans/g;
           $ALLTEXTDUTCH =~ s/<germanlanguage>/Duits/g;
           $ALLTEXTDUTCH =~ s/<italianlanguage>/Italiaans/g;
           $ALLTEXTDUTCH =~ s/<russianlanguage>/Russisch/g;
           $ALLTEXTDUTCH =~ s/<spanishlanguage>/Spaans/g;
           $ALLTEXTDUTCH =~ s/<swedishlanguage>/Zweeds/g;
           $ALLTEXTDUTCH =~ s/<greeklanguage>/Grieks/g;
           $ALLTEXTDUTCH =~ s/<portugueselanguage>/Portugees/g;
           $ALLTEXTDUTCH =~ s/<indonesianlanguage>/Indonesisch/g;
           $ALLTEXTDUTCH =~ s/<polishlanguage>/Pools/g;
           $ALLTEXTDUTCH =~ s/<hungarianlanguage>/Hongaars/g;
           $ALLTEXTDUTCH =~ s/<urdulanguage>/Urdu/g;
           $ALLTEXTDUTCH =~ s/<sitelang>/dutch/g;
           $ALLTEXTDUTCH =~ s/<bwhome>/dutch/g;
           $ALLTEXTDUTCH =~ s/<shop>/winkel/g;
           $ALLTEXTDUTCH =~ s/<CapitalShop>/Winkel/g;
           $ALLTEXTDUTCH =~ s/<RIGHTPAGETEXT>/$MENUSTORYTEXTDUTCH/;
           $ALLTEXTDUTCH =~ s/<thispageinenglish>/$thispageinenglish/;
           $ALLTEXTDUTCH =~ s/<thispageindutch>/$thispageindutch/;
           $ALLTEXTDUTCH =~ s/<BOOKSLOTNEW>/$BOOKSLOTNEWDUTCH/;
           
           
           
           $WriteFile = "../../Site/".$Language."/".$WebsiteHTMLName."menu_english.htm" ;
           if ($TRACING eq "ON") {
             print "Creating File $WriteFile... (English menu file for this book)...\n" ;
           } else { print ".";}
           open (WRITEFILE, ">$WriteFile") || die "file $WriteFile kan niet worden aangemaakt, ($!)\n";
           print WRITEFILE $ALLTEXTENGLISH ;
           close (WRITEFILE);
  
           
           $WriteFile = "../../Site/".$Language."/".$WebsiteHTMLName."menu_dutch.htm" ;
           if ($TRACING eq "ON") {
             print "Creating File $WriteFile... (Dutch menu file for this book)...\n" ;
           } else { print ".";}
           open (WRITEFILE, ">$WriteFile") || die "file $WriteFile kan niet worden aangemaakt, ($!)\n";
           print WRITEFILE $ALLTEXTDUTCH ;
           close (WRITEFILE);
       }
  
  
       # HERE THE MENU PAGE SHOULD HAVE BEEN UPDATED !!!!! 
  
       # NOW START FRESH WITH THIS PARTICULAR BOOK THE SCRIPT IS RUNNING FOR !!!!!
  
  
       # Create the pages for this particular book we run this script for
       $ReadFile = "../Base/HTML/Site/HTMLTemplate_SitePage.htm" ;
       open (READFILE, "$ReadFile") || die "file $ReadFile cannot be found. ($!)\n";
       @ALLTEXT = <READFILE>;
       close (READFILE);
       $ALLTEXT = join ("",@ALLTEXT) ;
       #print $ALLTEXT."\n";
       #print "---Press Any Key---\n\n";
       #`pause`;
  
  
       
       if ($Language ne "Urdu") {
         $ALLTEXT =~ s/<<<CSS_EXCEPTION>>>//g;
         #$ALLTEXT =~ s/<TEXTALIGN_DEF_JUSTIFY>/justify/g;
         #$ALLTEXT =~ s/<FONTSIZE_DEF_12PT>/12pt/g;
         #$ALLTEXT =~ s/<LINEHEIGHT_DEF_13PT>/13pt/g;
       } else {
         $ALLTEXT =~ s/<<<CSS_EXCEPTION>>>/urdu/g;
         #$ALLTEXT =~ s/<TEXTALIGN_DEF_JUSTIFY>/right/g;
         #$ALLTEXT =~ s/<FONTSIZE_DEF_12PT>/18pt/g;
         #$ALLTEXT =~ s/<LINEHEIGHT_DEF_13PT>/25pt/g;
         #$ALLTEXT =~ s/<LASTFORMATTEDTEXT>/<BR><BR><LASTFORMATTEDTEXT>/;
         #$ALLTEXT =~ s/<FORMATTEDTEXT>/<BR><BR><FORMATTEDTEXT>/;
       }
  
  
       if ($TRACING eq "ON") {
         print "\nSitePageNumber: $SitePageNumber\n";
       } else { print ".";}
       if ($LASTNR != 1)
       {
         $ALLTEXT =~ s/<LASTFORMATTEDTEXT>/$LASTFORMATTEDTEXT/;
         # kan engels of nederlands zijn dus niet generiek overschrijven, maar per sitelang file (op 't eind als ie write doet voor deze page)
       }
       else
       {
         # LIJKT NOOIT LASTNR = 0 TE ZIJN
         if ($TRACING eq "ON") {
           print "LASTNR is $LASTNR, leave LASTFORMATTEDTEXT to language EBOOKHOME\n" ;
         } else { print ".";}
         #$ALLTEXT =~ s/<LASTFORMATTEDTEXT>/$EBOOKHOME/;
       }
  
       $ALLTEXT =~ s/<FORMATTEDTEXT>/$FORMATTEDTEXT/;
  
       
       $ALLTEXT =~ s/\&#182;A/<BR><<<NEXTPAGESIGN>>>/g ;
       $ALLTEXT =~ s/\&#182;B/&nbsp;&nbsp;&nbsp;&nbsp;/g ;
       $ALLTEXT =~ s/\&#182;K/<A class=atxt id=a/g ;
       $ALLTEXT =~ s/\&#182;L/ href='DUMMY' onclick="BoterGeultje('CLK/g ;
       $ALLTEXT =~ s/\&#182;M/ onmouseover="Show('a/g ;
       $ALLTEXT =~ s/\&#182;N/','c/g ;
       $ALLTEXT =~ s/\&#182;O/')" onmouseout="Hide('c/g ;
       $ALLTEXT =~ s/\&#182;P/')">/g ;
       $ALLTEXT =~ s/\&#182;Q/<\/A><DIV class=ctxt id=c/g ;
       $ALLTEXT =~ s/\&#182;R/<\/DIV>/g ;
       $ALLTEXT =~ s/<<<LANGUAGE>>>/$Language/g;
  
       
       # deze ook nog vervangen
       $ALLTEXT =~ s/<<<CELLTOPLEFTCOLOR>>>/gray/g;
       $ALLTEXT =~ s/<<<CELLBOTTOMRIGHTCOLOR>>>/silver/g;
       $ALLTEXT =~ s/<<<CELLBOTTOMRIGHTCOLOR>>>/silver/g;
       $ALLTEXT =~ s/<<<CELLTOPLEFTCOLOR>>>/gray/g;
       $ALLTEXT =~ s/<<<FONTSIZE>>>/9/g;
       $ALLTEXT =~ s/ href='DUMMY' onclick=\"BoterGeultje//g;
       $ALLTEXT =~ s/&#167;DO\_REFRESH//g;
       $LastPageNumber = $PageNumber - 1;
  
       if ($PageNumber == 2) { if ($TRACING eq "ON") { print $ALLTEXT } }
  
       $ALLTEXT =~ s/\(\'CLK&#167;[0-9]{1}\_[0-9]{1}\_[0-9]{6}//g;
       $ALLTEXT =~ s/\(\'CLK&#167;[0-9]{1}\_[0-9]{1}\_[0-9]{5}//g;
       $ALLTEXT =~ s/\(\'CLK&#167;[0-9]{1}\_[0-9]{1}\_[0-9]{4}//g;
       $ALLTEXT =~ s/\(\'CLK&#167;[0-9]{1}\_[0-9]{1}\_[0-9]{3}//g;
       $ALLTEXT =~ s/\(\'CLK&#167;[0-9]{1}\_[0-9]{1}\_[0-9]{2}//g;
       $ALLTEXT =~ s/\(\'CLK&#167;[0-9]{1}\_[0-9]{1}\_[0-9]{1}//g;
       $ALLTEXT =~ s/\(\'CLK&#167;[0-9]{1}\_[0-9]{2}\_[0-9]{6}//g;
       $ALLTEXT =~ s/\(\'CLK&#167;[0-9]{1}\_[0-9]{2}\_[0-9]{5}//g;
       $ALLTEXT =~ s/\(\'CLK&#167;[0-9]{1}\_[0-9]{2}\_[0-9]{4}//g;
       $ALLTEXT =~ s/\(\'CLK&#167;[0-9]{1}\_[0-9]{2}\_[0-9]{3}//g;
       $ALLTEXT =~ s/\(\'CLK&#167;[0-9]{1}\_[0-9]{2}\_[0-9]{2}//g;
       $ALLTEXT =~ s/\(\'CLK&#167;[0-9]{1}\_[0-9]{2}\_[0-9]{1}//g;
       $ALLTEXT =~ s/\(\'CLK&#167;[0-9]{1}\_[0-9]{3}\_[0-9]{6}//g;
       $ALLTEXT =~ s/\(\'CLK&#167;[0-9]{1}\_[0-9]{3}\_[0-9]{5}//g;
       $ALLTEXT =~ s/\(\'CLK&#167;[0-9]{1}\_[0-9]{3}\_[0-9]{4}//g;
       $ALLTEXT =~ s/\(\'CLK&#167;[0-9]{1}\_[0-9]{3}\_[0-9]{3}//g;
       $ALLTEXT =~ s/\(\'CLK&#167;[0-9]{1}\_[0-9]{3}\_[0-9]{2}//g;
       $ALLTEXT =~ s/\(\'CLK&#167;[0-9]{1}\_[0-9]{3}\_[0-9]{1}//g;
       $ALLTEXT =~ s/\(\'CLK&#167;[0-9]{1}\_[0-9]{4}\_[0-9]{6}//g;
       $ALLTEXT =~ s/\(\'CLK&#167;[0-9]{1}\_[0-9]{4}\_[0-9]{5}//g;
       $ALLTEXT =~ s/\(\'CLK&#167;[0-9]{1}\_[0-9]{4}\_[0-9]{4}//g;
       $ALLTEXT =~ s/\(\'CLK&#167;[0-9]{1}\_[0-9]{4}\_[0-9]{3}//g;
       $ALLTEXT =~ s/\(\'CLK&#167;[0-9]{1}\_[0-9]{4}\_[0-9]{2}//g;
       $ALLTEXT =~ s/\(\'CLK&#167;[0-9]{1}\_[0-9]{4}\_[0-9]{1}//g;
       $ALLTEXT =~ s/\(\'CLK&#167;[0-9]{1}\_[0-9]{5}\_[0-9]{6}//g;
       $ALLTEXT =~ s/\(\'CLK&#167;[0-9]{1}\_[0-9]{5}\_[0-9]{5}//g;
       $ALLTEXT =~ s/\(\'CLK&#167;[0-9]{1}\_[0-9]{5}\_[0-9]{4}//g;
       $ALLTEXT =~ s/\(\'CLK&#167;[0-9]{1}\_[0-9]{5}\_[0-9]{3}//g;
       $ALLTEXT =~ s/\(\'CLK&#167;[0-9]{1}\_[0-9]{5}\_[0-9]{2}//g;
       $ALLTEXT =~ s/\(\'CLK&#167;[0-9]{1}\_[0-9]{5}\_[0-9]{1}//g;
       $ALLTEXT =~ s/\(\'CLK&#167;[0-9]{2}\_[0-9]{1}\_[0-9]{6}//g;
       $ALLTEXT =~ s/\(\'CLK&#167;[0-9]{2}\_[0-9]{1}\_[0-9]{5}//g;
       $ALLTEXT =~ s/\(\'CLK&#167;[0-9]{2}\_[0-9]{1}\_[0-9]{4}//g;
       $ALLTEXT =~ s/\(\'CLK&#167;[0-9]{2}\_[0-9]{1}\_[0-9]{3}//g;
       $ALLTEXT =~ s/\(\'CLK&#167;[0-9]{2}\_[0-9]{1}\_[0-9]{2}//g;
       $ALLTEXT =~ s/\(\'CLK&#167;[0-9]{2}\_[0-9]{1}\_[0-9]{1}//g;
       $ALLTEXT =~ s/\(\'CLK&#167;[0-9]{2}\_[0-9]{2}\_[0-9]{6}//g;
       $ALLTEXT =~ s/\(\'CLK&#167;[0-9]{2}\_[0-9]{2}\_[0-9]{5}//g;
       $ALLTEXT =~ s/\(\'CLK&#167;[0-9]{2}\_[0-9]{2}\_[0-9]{4}//g;
       $ALLTEXT =~ s/\(\'CLK&#167;[0-9]{2}\_[0-9]{2}\_[0-9]{3}//g;
       $ALLTEXT =~ s/\(\'CLK&#167;[0-9]{2}\_[0-9]{2}\_[0-9]{2}//g;
       $ALLTEXT =~ s/\(\'CLK&#167;[0-9]{2}\_[0-9]{2}\_[0-9]{1}//g;
       $ALLTEXT =~ s/\(\'CLK&#167;[0-9]{2}\_[0-9]{3}\_[0-9]{6}//g;
       $ALLTEXT =~ s/\(\'CLK&#167;[0-9]{2}\_[0-9]{3}\_[0-9]{5}//g;
       $ALLTEXT =~ s/\(\'CLK&#167;[0-9]{2}\_[0-9]{3}\_[0-9]{4}//g;
       $ALLTEXT =~ s/\(\'CLK&#167;[0-9]{2}\_[0-9]{3}\_[0-9]{3}//g;
       $ALLTEXT =~ s/\(\'CLK&#167;[0-9]{2}\_[0-9]{3}\_[0-9]{2}//g;
       $ALLTEXT =~ s/\(\'CLK&#167;[0-9]{2}\_[0-9]{3}\_[0-9]{1}//g;
       $ALLTEXT =~ s/\(\'CLK&#167;[0-9]{2}\_[0-9]{4}\_[0-9]{6}//g;
       $ALLTEXT =~ s/\(\'CLK&#167;[0-9]{2}\_[0-9]{4}\_[0-9]{5}//g;
       $ALLTEXT =~ s/\(\'CLK&#167;[0-9]{2}\_[0-9]{4}\_[0-9]{4}//g;
       $ALLTEXT =~ s/\(\'CLK&#167;[0-9]{2}\_[0-9]{4}\_[0-9]{3}//g;
       $ALLTEXT =~ s/\(\'CLK&#167;[0-9]{2}\_[0-9]{4}\_[0-9]{2}//g;
       $ALLTEXT =~ s/\(\'CLK&#167;[0-9]{2}\_[0-9]{4}\_[0-9]{1}//g;
       $ALLTEXT =~ s/\(\'CLK&#167;[0-9]{2}\_[0-9]{5}\_[0-9]{6}//g;
       $ALLTEXT =~ s/\(\'CLK&#167;[0-9]{2}\_[0-9]{5}\_[0-9]{5}//g;
       $ALLTEXT =~ s/\(\'CLK&#167;[0-9]{2}\_[0-9]{5}\_[0-9]{4}//g;
       $ALLTEXT =~ s/\(\'CLK&#167;[0-9]{2}\_[0-9]{5}\_[0-9]{3}//g;
       $ALLTEXT =~ s/\(\'CLK&#167;[0-9]{2}\_[0-9]{5}\_[0-9]{2}//g;
       $ALLTEXT =~ s/\(\'CLK&#167;[0-9]{2}\_[0-9]{5}\_[0-9]{1}//g;
       $ALLTEXT =~ s/\(\'CLK&#167;[0-9]{3}\_[0-9]{1}\_[0-9]{6}//g;
       $ALLTEXT =~ s/\(\'CLK&#167;[0-9]{3}\_[0-9]{1}\_[0-9]{5}//g;
       $ALLTEXT =~ s/\(\'CLK&#167;[0-9]{3}\_[0-9]{1}\_[0-9]{4}//g;
       $ALLTEXT =~ s/\(\'CLK&#167;[0-9]{3}\_[0-9]{1}\_[0-9]{3}//g;
       $ALLTEXT =~ s/\(\'CLK&#167;[0-9]{3}\_[0-9]{1}\_[0-9]{2}//g;
       $ALLTEXT =~ s/\(\'CLK&#167;[0-9]{3}\_[0-9]{1}\_[0-9]{1}//g;
       $ALLTEXT =~ s/\(\'CLK&#167;[0-9]{3}\_[0-9]{2}\_[0-9]{6}//g;
       $ALLTEXT =~ s/\(\'CLK&#167;[0-9]{3}\_[0-9]{2}\_[0-9]{5}//g;
       $ALLTEXT =~ s/\(\'CLK&#167;[0-9]{3}\_[0-9]{2}\_[0-9]{4}//g;
       $ALLTEXT =~ s/\(\'CLK&#167;[0-9]{3}\_[0-9]{2}\_[0-9]{3}//g;
       $ALLTEXT =~ s/\(\'CLK&#167;[0-9]{3}\_[0-9]{2}\_[0-9]{2}//g;
       $ALLTEXT =~ s/\(\'CLK&#167;[0-9]{3}\_[0-9]{2}\_[0-9]{1}//g;
       $ALLTEXT =~ s/\(\'CLK&#167;[0-9]{3}\_[0-9]{3}\_[0-9]{6}//g;
       $ALLTEXT =~ s/\(\'CLK&#167;[0-9]{3}\_[0-9]{3}\_[0-9]{5}//g;
       $ALLTEXT =~ s/\(\'CLK&#167;[0-9]{3}\_[0-9]{3}\_[0-9]{4}//g;
       $ALLTEXT =~ s/\(\'CLK&#167;[0-9]{3}\_[0-9]{3}\_[0-9]{3}//g;
       $ALLTEXT =~ s/\(\'CLK&#167;[0-9]{3}\_[0-9]{3}\_[0-9]{2}//g;
       $ALLTEXT =~ s/\(\'CLK&#167;[0-9]{3}\_[0-9]{3}\_[0-9]{1}//g;
       $ALLTEXT =~ s/\(\'CLK&#167;[0-9]{3}\_[0-9]{4}\_[0-9]{6}//g;
       $ALLTEXT =~ s/\(\'CLK&#167;[0-9]{3}\_[0-9]{4}\_[0-9]{5}//g;
       $ALLTEXT =~ s/\(\'CLK&#167;[0-9]{3}\_[0-9]{4}\_[0-9]{4}//g;
       $ALLTEXT =~ s/\(\'CLK&#167;[0-9]{3}\_[0-9]{4}\_[0-9]{3}//g;
       $ALLTEXT =~ s/\(\'CLK&#167;[0-9]{3}\_[0-9]{4}\_[0-9]{2}//g;
       $ALLTEXT =~ s/\(\'CLK&#167;[0-9]{3}\_[0-9]{4}\_[0-9]{1}//g;
       $ALLTEXT =~ s/\(\'CLK&#167;[0-9]{3}\_[0-9]{5}\_[0-9]{6}//g;
       $ALLTEXT =~ s/\(\'CLK&#167;[0-9]{3}\_[0-9]{5}\_[0-9]{5}//g;
       $ALLTEXT =~ s/\(\'CLK&#167;[0-9]{3}\_[0-9]{5}\_[0-9]{4}//g;
       $ALLTEXT =~ s/\(\'CLK&#167;[0-9]{3}\_[0-9]{5}\_[0-9]{3}//g;
       $ALLTEXT =~ s/\(\'CLK&#167;[0-9]{3}\_[0-9]{5}\_[0-9]{2}//g;
       $ALLTEXT =~ s/\(\'CLK&#167;[0-9]{3}\_[0-9]{5}\_[0-9]{1}//g;
       $ALLTEXT =~ s/\(\'CLK&#167;[0-9]{4}\_[0-9]{1}\_[0-9]{6}//g;
       $ALLTEXT =~ s/\(\'CLK&#167;[0-9]{4}\_[0-9]{1}\_[0-9]{5}//g;
       $ALLTEXT =~ s/\(\'CLK&#167;[0-9]{4}\_[0-9]{1}\_[0-9]{4}//g;
       $ALLTEXT =~ s/\(\'CLK&#167;[0-9]{4}\_[0-9]{1}\_[0-9]{3}//g;
       $ALLTEXT =~ s/\(\'CLK&#167;[0-9]{4}\_[0-9]{1}\_[0-9]{2}//g;
       $ALLTEXT =~ s/\(\'CLK&#167;[0-9]{4}\_[0-9]{1}\_[0-9]{1}//g;
       $ALLTEXT =~ s/\(\'CLK&#167;[0-9]{4}\_[0-9]{2}\_[0-9]{6}//g;
       $ALLTEXT =~ s/\(\'CLK&#167;[0-9]{4}\_[0-9]{2}\_[0-9]{5}//g;
       $ALLTEXT =~ s/\(\'CLK&#167;[0-9]{4}\_[0-9]{2}\_[0-9]{4}//g;
       $ALLTEXT =~ s/\(\'CLK&#167;[0-9]{4}\_[0-9]{2}\_[0-9]{3}//g;
       $ALLTEXT =~ s/\(\'CLK&#167;[0-9]{4}\_[0-9]{2}\_[0-9]{2}//g;
       $ALLTEXT =~ s/\(\'CLK&#167;[0-9]{4}\_[0-9]{2}\_[0-9]{1}//g;
       $ALLTEXT =~ s/\(\'CLK&#167;[0-9]{4}\_[0-9]{3}\_[0-9]{6}//g;
       $ALLTEXT =~ s/\(\'CLK&#167;[0-9]{4}\_[0-9]{3}\_[0-9]{5}//g;
       $ALLTEXT =~ s/\(\'CLK&#167;[0-9]{4}\_[0-9]{3}\_[0-9]{4}//g;
       $ALLTEXT =~ s/\(\'CLK&#167;[0-9]{4}\_[0-9]{3}\_[0-9]{3}//g;
       $ALLTEXT =~ s/\(\'CLK&#167;[0-9]{4}\_[0-9]{3}\_[0-9]{2}//g;
       $ALLTEXT =~ s/\(\'CLK&#167;[0-9]{4}\_[0-9]{3}\_[0-9]{1}//g;
       $ALLTEXT =~ s/\(\'CLK&#167;[0-9]{4}\_[0-9]{4}\_[0-9]{6}//g;
       $ALLTEXT =~ s/\(\'CLK&#167;[0-9]{4}\_[0-9]{4}\_[0-9]{5}//g;
       $ALLTEXT =~ s/\(\'CLK&#167;[0-9]{4}\_[0-9]{4}\_[0-9]{4}//g;
       $ALLTEXT =~ s/\(\'CLK&#167;[0-9]{4}\_[0-9]{4}\_[0-9]{3}//g;
       $ALLTEXT =~ s/\(\'CLK&#167;[0-9]{4}\_[0-9]{4}\_[0-9]{2}//g;
       $ALLTEXT =~ s/\(\'CLK&#167;[0-9]{4}\_[0-9]{4}\_[0-9]{1}//g;
       $ALLTEXT =~ s/\(\'CLK&#167;[0-9]{4}\_[0-9]{5}\_[0-9]{6}//g;
       $ALLTEXT =~ s/\(\'CLK&#167;[0-9]{4}\_[0-9]{5}\_[0-9]{5}//g;
       $ALLTEXT =~ s/\(\'CLK&#167;[0-9]{4}\_[0-9]{5}\_[0-9]{4}//g;
       $ALLTEXT =~ s/\(\'CLK&#167;[0-9]{4}\_[0-9]{5}\_[0-9]{3}//g;
       $ALLTEXT =~ s/\(\'CLK&#167;[0-9]{4}\_[0-9]{5}\_[0-9]{2}//g;
       $ALLTEXT =~ s/\(\'CLK&#167;[0-9]{4}\_[0-9]{5}\_[0-9]{1}//g;        
  
       if ($TRACING eq "ON") {
         print "Current Pagenumber is $PageNumber...\n";
       } else { print ".";}
  
       @ALLTEXTPAGES = split(/\<PAGESPLIT\>/,$ALLTEXT);
       $ALLTEXTPAGELEFT = $ALLTEXTPAGES[0];
       $ALLTEXTPAGERIGHT = $ALLTEXTPAGES[1];
  
       if ($LastSoundFile =~ "Page2\." && $DEMOWANTED eq "TRUE") {   	     	
         $ALLTEXT =~ s/<<<SOUNDRIGHT>>>//;
       }
       if ($LastSoundFile !~ "Page0." && $SoundFile !~ "Page0." && $ALLTEXTPAGELEFT !~ "picpage" && $ALLTEXTPAGELEFT !~ "<FIRSTPAGETEXT>" && $ALLTEXTPAGERIGHT !~ "picpage") {
         $ALLTEXT =~ s/<<<SOUNDLEFT>>>/$SOUNDLEFT/;
         $ALLTEXT =~ s/<<<SOUNDRIGHT>>>//;
         $ALLTEXT =~ s/<<<SOUNDLEFT>>>//;
         $ALLTEXT =~ s/<<<SOUNDRIGHT>>>/$SOUNDRIGHT/;
       }
       if ($LastSoundFile !~ "Page0." && $ALLTEXTPAGELEFT !~ "picpage" && $ALLTEXTPAGELEFT !~ "<FIRSTPAGETEXT>" && $ALLTEXTPAGERIGHT =~ "picpage") {   	     	
         $ALLTEXT =~ s/<<<SOUNDLEFT>>>/$SOUNDLEFTSINGLE/;
         $ALLTEXT =~ s/<<<SOUNDRIGHT>>>//;
       }
       if ( $SoundFile !~ "Page0." && ($LastSoundFile =~ "Page0." || $ALLTEXTPAGELEFT =~ "picpage" || $ALLTEXTPAGELEFT =~ "<FIRSTPAGETEXT>") && $ALLTEXTPAGERIGHT !~ "picpage") {
         $ALLTEXT =~ s/<<<SOUNDLEFT>>>//;
         $ALLTEXT =~ s/<<<SOUNDRIGHT>>>/$SOUNDRIGHTSINGLE/;
       }
       if ( $SoundFile !~ "Page0." && ($LastSoundFile =~ "Page0." || $ALLTEXTPAGELEFT =~ "picpage" || $ALLTEXTPAGELEFT =~ "<FIRSTPAGETEXT>") && $ALLTEXTPAGERIGHT =~ "picpage") {
  
         $ALLTEXT =~ s/<<<SOUNDLEFT>>>//;
         $ALLTEXT =~ s/<<<SOUNDRIGHT>>>/$SOUNDRIGHTSINGLE/;
       }
  
  
       $ALLTEXT =~ s/\n<BR><BR>//g;
       $ALLTEXT =~ s/\n <BR>/\n/g;
  
       if ($OnlyWebIndex ne "yes") {
         if ($ALLTEXT =~ "img SRC") {
           # get picture
           if ($PICTURENAME !~ "182") {
             #print $PICTURENAME."\n";
             if ($PICTURENAME =~ "Earpic") {
               #now taken from Site\\Pics instead of Site\\$Language\\Pics
               #`copy ..\\..\\Site\\Pics\\$PICTURENAME ..\\..\\Site\\$Language\\Pics`;
             } else {
               `copy ..\\Base\\Media\\$Language\\$Group\\$PICTURENAME ..\\..\\Site\\$Language\\Pics`;
             }
             $ALLTEXT =~ s/..\/Media/Pics/g;
           }
         }
       }
  
       # International Messaging
       #translate help, information and messaging
       $MessagingTranslationFile = "..\\Base\\Parse\\Main\\Messages.htm" ;
       open (MESSTRANS, "<$MessagingTranslationFile") || die "file $MessagingTranslationFile kan niet worden gevonden, ($!)\n";
       @MessTransEntries = <MESSTRANS>;
       close MESSTRANS;
       if ($TRACING eq "ON") {
         print "To internationalise information, help and other messaging, change all occurrences of:\n";
       } else { print ".";}
       foreach $MessTransEntry (@MessTransEntries)
       {
         if ($MessTransEntry !~ "BASE VALUE") {
           @MessTransLine = split(/#/,$MessTransEntry);
           $MessGrep = $MessTransLine[0];
           $MessChange = $MessTransLine[$TLN];
           if ($ALLTEXT =~ $MessGrep)
           {
             $ALLTEXT =~ s/$MessGrep/$MessChange/g;
             if ($TRACING eq "ON") {
                print "$MessTransLine[0] to $MessTransLine[$TLN]\n";
             } else { print ".";}
           }
         }
       }
  
       # save pagefile into site directory
       $LASTNR=$SitePageNumber-1; # now write file if not page 0
       $NEXTNR=$SitePageNumber+1;
       $NNXTNR=$SitePageNumber+2;
       $THISNR=$SitePageNumber;
       $BEFORELASTNR=$LASTNR-1;
       $BBFORELASTNR=$LASTNR-2;
       # no sound left, no sound right: <DIV align='right'>Chaptername&nbsp;&nbsp;&nbsp;&nbsp;65</DIV> and right change to <DIV align='left'>65&nbsp;&nbsp;&nbsp;&nbsp;Chaptername</DIV>
       if ($ALLTEXT !~ "<<<PLAY" ) {
         #$ALLTEXT =~ s/<<<HEADERLEFT>>>/<DIV align='right'>$TopRightChapterName/;
         $ALLTEXT =~ s/$LASTNR<<<RIGHTSIDEOFPAGENUMBER>>>&nbsp;&nbsp;&nbsp;&nbsp;<<<CHAPTERNAME>>>/<DIV align='right'>$TopLeftChapterName&nbsp;&nbsp;&nbsp;&nbsp;$LASTNR<\/DIV>/;
         $ALLTEXT =~ s/$THISNR<<<RIGHTSIDEOFPAGENUMBER>>>&nbsp;&nbsp;&nbsp;&nbsp;<<<CHAPTERNAME>>>/<DIV align='left'>$THISNR&nbsp;&nbsp;&nbsp;&nbsp;$TopRightChapterName<\/DIV>/;
         $ALLTEXT =~ s/<<<RIGHTSIDEOFPAGENUMBER>>>//g;
       }
       
       # no sound left, sound right: 
       if ( $ALLTEXT !~ "<<<PLAYLEFT>>>" && $ALLTEXT =~ "<<<PLAYRIGHT>>>") {
         $ALLTEXT =~ s/$LASTNR<<<RIGHTSIDEOFPAGENUMBER>>>&nbsp;&nbsp;&nbsp;&nbsp;<<<CHAPTERNAME>>>/<DIV align='right'>$TopLeftChapterName&nbsp;&nbsp;&nbsp;&nbsp;$LASTNR<\/DIV>/;
         $ALLTEXT =~ s/<<<HEADERLEFT>>>//;
         $ALLTEXT =~ s/<<<RIGHTSIDEOFPAGENUMBER>>>//g;
         $ALLTEXT =~ s/<<<HEADERRIGHT>>>&nbsp;&nbsp;&nbsp;&nbsp;<<<CHAPTERNAME>>>/&nbsp;&nbsp;&nbsp;&nbsp;$TopRightChapterName<\/DIV>/;
       }
       
       # sound left, no sound right: 
       if ( $ALLTEXT =~ "<<<PLAYLEFT>>>" && $ALLTEXT !~ "<<<PLAYRIGHT>>>") {
         $ALLTEXT =~ s/$THISNR<<<RIGHTSIDEOFPAGENUMBER>>>&nbsp;&nbsp;&nbsp;&nbsp;<<<CHAPTERNAME>>>/<DIV align='left'>$THISNR&nbsp;&nbsp;&nbsp;&nbsp;$TopRightChapterName<\/DIV>/;
         $ALLTEXT =~ s/<<<HEADERLEFT>>>/<DIV align='right'>$TopLeftChapterName&nbsp;&nbsp;&nbsp;&nbsp;/;
         $ALLTEXT =~ s/<<<RIGHTSIDEOFPAGENUMBER>>><<<HEADERRIGHT>>>&nbsp;&nbsp;&nbsp;&nbsp;<<<CHAPTERNAME>>>/<\/DIV>/;
       }
       
       # sound left and sound right:
       if ( $ALLTEXT =~ "<<<PLAYLEFT>>>" && $ALLTEXT =~ "<<<PLAYRIGHT>>>") {
         $ALLTEXT =~ s/<<<HEADERLEFT>>>/<DIV align='right'>$TopLeftChapterName&nbsp;&nbsp;&nbsp;&nbsp;/;
         $ALLTEXT =~ s/<<<RIGHTSIDEOFPAGENUMBER>>><<<HEADERRIGHT>>>&nbsp;&nbsp;&nbsp;&nbsp;<<<CHAPTERNAME>>>/<\/DIV>/;
         $ALLTEXT =~ s/<<<HEADERRIGHT>>>&nbsp;&nbsp;&nbsp;&nbsp;<<<CHAPTERNAME>>>/&nbsp;&nbsp;&nbsp;&nbsp;$TopRightChapterName<\/DIV>/;
         $ALLTEXT =~ s/<<<HEADERLEFT>>>//;
         $ALLTEXT =~ s/<<<RIGHTSIDEOFPAGENUMBER>>>//g;
       }
       
       # NOW ADD SOUNDFILES
       $ALLTEXT =~ s/<<<PLAYLEFT>>>/Sounds\/$LastSoundFile/g;
       $ALLTEXT =~ s/<<<PLAYRIGHT>>>/Sounds\/$SoundFile/g;
  
       if ($SitePageNumber == 1) {
         $THISPAGEWITHENGLISHSUBTITLESANDSITEINENGLISH = $WebsiteHTMLName."english.htm" ;
         $THISPAGEWITHDUTCHSUBTITLESANDSITEINDUTCH = $WebsiteHTMLName."dutch.htm" ;
       } else {
         $THISPAGEWITHENGLISHSUBTITLESANDSITEINENGLISH = $WebsiteHTMLName."english-".$LASTNR."-".$SitePageNumber.".htm" ;
         $THISPAGEWITHDUTCHSUBTITLESANDSITEINDUTCH = $WebsiteHTMLName."dutch-".$LASTNR."-".$SitePageNumber.".htm" ;
         # for starting purposes (you want the essential page beginning from the left)
         $THISPAGEWITHENGLISHSUBTITLESANDSITEINENGLISHPLUSONE = $WebsiteHTMLName."english-".$THISNR."-".$NEXTNR.".htm" ;
         $THISPAGEWITHDUTCHSUBTITLESANDSITEINDUTCHPLUSONE = $WebsiteHTMLName."dutch-".$THISNR."-".$NEXTNR.".htm" ;
       }
       if ($Language eq "English") {
         if ($SitePageNumber == 1) {
           $THISPAGEWITHDUTCHSUBTITLESANDSITEINDUTCH = $WebsiteHTMLName."dutch.htm" ;
           $THISPAGEWITHENGLISHSUBTITLESANDSITEINENGLISH = $WebsiteHTMLName."dutch.htm" ;
         } else {
           $THISPAGEWITHDUTCHSUBTITLESANDSITEINDUTCH = $WebsiteHTMLName."dutch-".$LASTNR."-".$SitePageNumber.".htm" ;
           $THISPAGEWITHENGLISHSUBTITLESANDSITEINENGLISH = $WebsiteHTMLName."dutch-".$LASTNR."-".$SitePageNumber.".htm" ;
           # for starting purposes (you want the essential page beginning from the left)
           $THISPAGEWITHDUTCHSUBTITLESANDSITEINDUTCHPLUSONE = $WebsiteHTMLName."dutch-".$THISNR."-".$NEXTNR.".htm" ;
           $THISPAGEWITHENGLISHSUBTITLESANDSITEINENGLISHPLUSONE = $WebsiteHTMLName."dutch-".$THISNR."-".$NEXTNR.".htm" ;
         }
       }
       if ($Language eq "Dutch") {
         if ($SitePageNumber == 1) {
           $THISPAGEWITHENGLISHSUBTITLESANDSITEINENGLISH = $WebsiteHTMLName."english.htm" ;
           $THISPAGEWITHDUTCHSUBTITLESANDSITEINDUTCH = $WebsiteHTMLName."english.htm" ;
         } else {
           $THISPAGEWITHENGLISHSUBTITLESANDSITEINENGLISH = $WebsiteHTMLName."english-".$LASTNR."-".$SitePageNumber.".htm" ;
           $THISPAGEWITHDUTCHSUBTITLESANDSITEINDUTCH = $WebsiteHTMLName."english-".$LASTNR."-".$SitePageNumber.".htm" ;
           # for starting purposes (you want the essential page beginning from the left)
           $THISPAGEWITHENGLISHSUBTITLESANDSITEINENGLISHPLUSONE = $WebsiteHTMLName."english-".$THISNR."-".$NEXTNR.".htm" ;
           $THISPAGEWITHDUTCHSUBTITLESANDSITEINDUTCHPLUSONE = $WebsiteHTMLName."english-".$THISNR."-".$NEXTNR.".htm" ;
         }
       }
  
       if ($TRACING eq "ON") {
         print "Number of Pages in Chapter: ".$CHAPTERPAGES[$CurrentShortFile-1]."\n" ;
       } else { print ".";}
  
       if ((($ALLTEXTPAGERIGHT =~ "onmouseover" || $ALLTEXTPAGERIGHT =~ "img" ) && $ALLTEXTPAGERIGHT !~ "<LASTPAGECODE>" )) {
         if ($TRACING eq "ON") {
           print "Setting Nextpage value...\n";
         } else { print ".";}
         $NEXTPAGENAMEINENGLISH = "<a href='".$WebsiteHTMLName."english-".$NEXTNR."-".$NNXTNR.".htm'><img SRC='..\/Pics\/Nextsign.gif' align=right WIDTH='9' BORDER='0'><\/a>";
         $NEXTPAGENAMEINDUTCH = "<a href='".$WebsiteHTMLName."dutch-".$NEXTNR."-".$NNXTNR.".htm'><img SRC='..\/Pics\/Nextsign.gif' align=right WIDTH='9' BORDER='0'><\/a>";
         $NextFileNameInEnglish = $WebsiteHTMLName."english-".$NEXTNR."-".$NNXTNR.".htm";
         $NextFileNameInDutch = $WebsiteHTMLName."dutch-".$NEXTNR."-".$NNXTNR.".htm";
       } else {
         if ($TRACING eq "ON") {
           print "Set NEXTPAGENAME to nothing...\n";
         } else { print ".";}
         $NEXTPAGENAMEINENGLISH = "";
         $NEXTPAGENAMEINDUTCH = "";
         $NextFileNameInEnglish = "not available, end of chapter...";
         $NextFileNameInDutch = "not available, end of chapter...";
       }
       if ($SitePageNumber > 2) {
         if ($TRACING eq "ON") {
           print "Setting Lastpage value...\n";
         } else { print ".";}
         $LASTPAGENAMEINENGLISH = "<a href='".$WebsiteHTMLName."english-".$BBFORELASTNR."-".$BEFORELASTNR.".htm'><img SRC='..\/Pics\/Lastsign.gif' align=left WIDTH='16' BORDER='0'><\/a>";
         $LASTPAGENAMEINDUTCH = "<a href='".$WebsiteHTMLName."dutch-".$BBFORELASTNR."-".$BEFORELASTNR.".htm'><img SRC='..\/Pics\/Lastsign.gif' align=left WIDTH='16' BORDER='0'><\/a>";
       }
       if ($SitePageNumber == 2) {
         if ($TRACING eq "ON") {
           print "Setting Lastpage value to starting page...\n";
         } else { print ".";}
         $LASTPAGENAMEINENGLISH = "<a href='".$WebsiteHTMLName."menu_english.htm'><img SRC='..\/Pics\/Lastsign.gif' align=left WIDTH='16' BORDER='0'><\/a>";
         $LASTPAGENAMEINDUTCH = "<a href='".$WebsiteHTMLName."menu_dutch.htm'><img SRC='..\/Pics\/Lastsign.gif' align=left WIDTH='16' BORDER='0'><\/a>";
       }
       
       if ($ALLTEXT !~ "<FIRSTPAGETEXT>" && $LASTNR != 0) {
         # THIS SEEMS TO BE SET ALWAYS!??!?!?!
         if ($TRACING eq "ON") {
           print "Set NEXTPAGESIGN to LASTPAGENAME...\n";
         } else { print ".";}
         $ALLTEXT =~ s/<<<NEXTPAGESIGN>>>/<LASTPAGENAME>/;
       }
       if ($ALLTEXT =~ "NEXTPAGESIGN") {
         if ($TRACING eq "ON") {
           print "Set NEXTPAGESIGN to NEXTPAGENAME...\n";
         } else { print ".";}
       }
       $ALLTEXT =~ s/<<<NEXTPAGESIGN>>>/<NEXTPAGENAME>/;
       if ($TranToLanguage eq "Dutch") {
         $ALLTEXT =~ s/<<<TARGETLANGUAGEIFNOTDUTCH>>>//g;
       }
       if ($TranToLanguage eq "English") {
         $ALLTEXT =~ s/<<<TARGETLANGUAGEIFNOTDUTCH>>>/$TranToLanguage/g;
       }
  
       $ALLTEXT =~ s/<tolanguage>/$lclanguageto/g;
  
       # if this is the first page of a chapter, add link to menu page (and small version for margin)
       if ($ThisIsANewChapter eq "YES" || $LASTNR == 1) {
       	 #print "This is a new Chapter!!!\n";
           # this is for giving the chapter names in the margin a different tint
           $TINTNUMBER = $TINTNUMBER + 1 ;
           # calculate the number of pages in this chapter
           $TOTALPAGESOFTHISCHAPTER = $LASTNR - $LASTFIRSTNR ;
           $LASTFIRSTNR = $LASTNR ;
           # for english menu (the subtitles) link to the right chapters (exception for if the book language is also English, then we'll link to dutch subtitles!
           if ($NiceShortChapterAbbreviation ne "<<<Title>>>" && $NiceShortChapterAbbreviation ne "<<<Contents>>>") {
               #$CHAPTERLINKSENGLISH = $CHAPTERLINKSENGLISH.$LASTNR." / ".$TOTALPAGESOFTHISCHAPTER.")<\/A><BR><A title='$TopRightChapterNameTranslationEnglish' href='$THISPAGEWITHENGLISHSUBTITLESANDSITEINENGLISHPLUSONE' >".$NiceShortChapterAbbreviation."&nbsp;-&nbsp;".$TopRightChapterName." (".$THISNR."-";
               $CHAPTERLINKSENGLISH = $CHAPTERLINKSENGLISH."<\/A><BR><A title='$TopRightChapterNameTranslationEnglish' href='$THISPAGEWITHENGLISHSUBTITLESANDSITEINENGLISHPLUSONE' >".$NiceShortChapterAbbreviation."&nbsp;-&nbsp;".$TopRightChapterName;
               $CHAPTERLINKSENGLISHSMALL = $CHAPTERLINKSENGLISHSMALL."<A class=mtxt$TINTNUMBER title='$TopRightChapterNameTranslationEnglish' href='$THISPAGEWITHENGLISHSUBTITLESANDSITEINENGLISHPLUSONE'>".$NiceShortChapterAbbreviation."&nbsp;-&nbsp;".$TopRightChapterNameAlternative."<\/a><br><br>";
           } else {
               $LASTFIRSTNR = 0 ;
               #$CHAPTERLINKSENGLISH = $CHAPTERLINKSENGLISH."<A title='Title & Contents' href='$THISPAGEWITHENGLISHSUBTITLESANDSITEINENGLISH' >$TIETEL & $KONTENDS (1-";
               $CHAPTERLINKSENGLISH = $CHAPTERLINKSENGLISH."<A title='Title & Contents' href='$THISPAGEWITHENGLISHSUBTITLESANDSITEINENGLISH' >$TIETEL & $KONTENDS";
               $CHAPTERLINKSENGLISHSMALL = $CHAPTERLINKSENGLISHSMALL."<A class=mtxt$TINTNUMBER title='Title & Contents' href='$THISPAGEWITHENGLISHSUBTITLESANDSITEINENGLISH'>$TIETEL & $KONTENDS<\/a><br><br>";
           }
  
           # if dutch menu (the subtitles) link to the right chapters (exception for if the book language is also Dutch, then we'll link to english subtitles!
           if ($NiceShortChapterAbbreviation ne "<<<Title>>>" && $NiceShortChapterAbbreviation ne "<<<Contents>>>") {
               #$CHAPTERLINKSDUTCH = $CHAPTERLINKSDUTCH.$LASTNR." / ".$TOTALPAGESOFTHISCHAPTER.")<\/A><BR><A title='$TopRightChapterNameTranslationDutch' href='$THISPAGEWITHDUTCHSUBTITLESANDSITEINDUTCHPLUSONE' >".$NiceShortChapterAbbreviation."&nbsp;-&nbsp;".$TopRightChapterName." (".$THISNR."-";
               $CHAPTERLINKSDUTCH = $CHAPTERLINKSDUTCH."<\/A><BR><A title='$TopRightChapterNameTranslationDutch' href='$THISPAGEWITHDUTCHSUBTITLESANDSITEINDUTCHPLUSONE' >".$NiceShortChapterAbbreviation."&nbsp;-&nbsp;".$TopRightChapterName;
               $CHAPTERLINKSDUTCHSMALL = $CHAPTERLINKSDUTCHSMALL."<A class=mtxt$TINTNUMBER title='$TopRightChapterNameTranslationDutch' href='$THISPAGEWITHDUTCHSUBTITLESANDSITEINDUTCHPLUSONE'>".$NiceShortChapterAbbreviation."&nbsp;-&nbsp;".$TopRightChapterNameAlternative."<\/a><br><br>";
           } else {
               $LASTFIRSTNR = 0 ;
               #$CHAPTERLINKSDUTCH = $CHAPTERLINKSDUTCH."<A title='Titel & Inhoud' href='$THISPAGEWITHDUTCHSUBTITLESANDSITEINDUTCH' >$TIETEL & $KONTENDS (1-";
               $CHAPTERLINKSDUTCH = $CHAPTERLINKSDUTCH."<A title='Titel & Inhoud' href='$THISPAGEWITHDUTCHSUBTITLESANDSITEINDUTCH' >$TIETEL & $KONTENDS";
               $CHAPTERLINKSDUTCHSMALL = $CHAPTERLINKSDUTCHSMALL."<A class=mtxt$TINTNUMBER title='Titel & Inhoud' href='$THISPAGEWITHDUTCHSUBTITLESANDSITEINDUTCH'>$TIETEL & $KONTENDS<\/a><br><br>";
           }
           if ($TRACING eq "ON") {
             print "Created $WebsiteHTMLName chapter link for Chapter $NiceShortChapterAbbreviation...\n";
           } else { print ".";}
       }
  
       if ($SitePageNumber == 1) {
           if ($TRACING eq "ON") {
       	   print "SITEPAGENUMBER IS ONE!!!!!!!!!!!\n";
       	 } else { print ".";}
       	 # website in english
       	 $ALLTEXTENGLISH = $ALLTEXT;
       	 $ALLTEXTENGLISH =~ s/<<<LANGUAGE>>>/$Language/g;
           $ALLTEXTENGLISH =~ s/<<<SAMEPAGEINENGLISH>>>/$THISPAGEWITHENGLISHSUBTITLESANDSITEINENGLISH/g;
           $ALLTEXTENGLISH =~ s/<<<SAMEPAGEINDUTCH>>>/$THISPAGEWITHDUTCHSUBTITLESANDSITEINDUTCH/g;
           $ALLTEXTENGLISH =~ s/<dutchlanguage>/Dutch/g;
           $ALLTEXTENGLISH =~ s/<englishlanguage>/English/g;
           $ALLTEXTENGLISH =~ s/<frenchlanguage>/French/g;
           $ALLTEXTENGLISH =~ s/<germanlanguage>/German/g;
           $ALLTEXTENGLISH =~ s/<italianlanguage>/Italian/g;
           $ALLTEXTENGLISH =~ s/<russianlanguage>/Russian/g;
           $ALLTEXTENGLISH =~ s/<spanishlanguage>/Spanish/g;
           $ALLTEXTENGLISH =~ s/<swedishlanguage>/Swedish/g;
           $ALLTEXTENGLISH =~ s/<greeklanguage>/Greek/g;
           $ALLTEXTENGLISH =~ s/<portugueselanguage>/Portuguese/g;
           $ALLTEXTENGLISH =~ s/<indonesianlanguage>/Indonesian/g;
           $ALLTEXTENGLISH =~ s/<polishlanguage>/Polish/g;
           $ALLTEXTENGLISH =~ s/<hungarianlanguage>/Hungarian/g;
           $ALLTEXTENGLISH =~ s/<urdulanguage>/Urdu/g;
           $ALLTEXTENGLISH =~ s/<translation>/translation/g;
       	 $ALLTEXTENGLISH =~ s/<sitelang>/english/g;
       	 $ALLTEXTENGLISH =~ s/<bwhome>/index/g;
       	 $ALLTEXTENGLISH =~ s/<websiteindex>/index/g;
       	 $ALLTEXTENGLISH =~ s/<<<BookName>>>/$BookName/g;
       	 $ALLTEXTENGLISH =~ s/<<<LCBookName>>>/$LCBookName/g;
       	 $ALLTEXTENGLISH =~ s/<<<RealNiceBookName>>>/$EnglishRealNiceBookName/g;
       	 $ALLTEXTENGLISH =~ s/<<<BookLanguage>>>/$Language/g;
       	 $ALLTEXTENGLISH =~ s/<<<LanguageIndependentBookLanguage>>>/$Language/g;
       	 $ALLTEXTENGLISH =~ s/<<<LCLanguageTo>>>/$lclanguageto/g;
       	 $ALLTEXTENGLISH =~ s/<<<TranToLanguage>>>/$TranToLanguage/g;
       	 $ALLTEXTENGLISH =~ s/<FIRSTPAGETEXT>/$FIRSTPAGETEXTENGLISH/;
       	 $ALLTEXTENGLISH =~ s/<LASTPAGENAME>/$LASTPAGENAMEINENGLISH/;
           $ALLTEXTENGLISH =~ s/<NEXTPAGENAME>/$NEXTPAGENAMEINENGLISH/;
           $ALLTEXTENGLISH =~ s/<LASTFORMATTEDTEXT>/$LASTFORMATTEDTEXTENGLISH/;
       	 $TopLeftChapterName = $TopRightChapterName;
           #$WriteFile = "..\\..\\Site\\".$Language."\\".$WebsiteHTMLName."english.htm" ;
           #print "Creating File $WriteFile... (Next Chapter Page is $NextChap)!\n" ;
           #print "Next file is $NextFileNameInEnglish\n";
           #open (WRITEFILE, ">$WriteFile") || die "file $WriteFile kan niet worden aangemaakt, ($!)\n";
           #print WRITEFILE $ALLTEXTENGLISH ;
           #close (WRITEFILE);
           
           # website in dutch
           $ALLTEXTDUTCH = $ALLTEXT;
           $ALLTEXTDUTCH =~ s/<<<LANGUAGE>>>/$Language/g;
           $ALLTEXTDUTCH =~ s/<<<SAMEPAGEINENGLISH>>>/$THISPAGEWITHENGLISHSUBTITLESANDSITEINENGLISH/g;
           $ALLTEXTDUTCH =~ s/<<<SAMEPAGEINDUTCH>>>/$THISPAGEWITHDUTCHSUBTITLESANDSITEINDUTCH/g;
       	 $ALLTEXTDUTCH =~ s/<dutchlanguage>/Nederlands/g;
           $ALLTEXTDUTCH =~ s/<englishlanguage>/Engels/g;
           $ALLTEXTDUTCH =~ s/<frenchlanguage>/Frans/g;
           $ALLTEXTDUTCH =~ s/<germanlanguage>/Duits/g;
           $ALLTEXTDUTCH =~ s/<italianlanguage>/Italiaans/g;
           $ALLTEXTDUTCH =~ s/<russianlanguage>/Russisch/g;
           $ALLTEXTDUTCH =~ s/<spanishlanguage>/Spaans/g;
           $ALLTEXTDUTCH =~ s/<swedishlanguage>/Zweeds/g;
           $ALLTEXTDUTCH =~ s/<greeklanguage>/Grieks/g;
           $ALLTEXTDUTCH =~ s/<portugueselanguage>/Portugees/g;
           $ALLTEXTDUTCH =~ s/<indonesianlanguage>/Indonesisch/g;
           $ALLTEXTDUTCH =~ s/<polishlanguage>/Pools/g;
           $ALLTEXTDUTCH =~ s/<hungarianlanguage>/Hongaars/g;
           $ALLTEXTDUTCH =~ s/<urdulanguage>/Urdu/g;
           $ALLTEXTDUTCH =~ s/<translation>/vertaling/g;
           $ALLTEXTDUTCH =~ s/<sitelang>/dutch/g;
           $ALLTEXTDUTCH =~ s/<bwhome>/dutch/g;
           $ALLTEXTDUTCH =~ s/<websiteindex>/dutch/g;
       	 $ALLTEXTDUTCH =~ s/<<<BookName>>>/$BookName/g;
       	 $ALLTEXTDUTCH =~ s/<<<LCBookName>>>/$LCBookName/g;
       	 $ALLTEXTDUTCH =~ s/<<<RealNiceBookName>>>/$DutchRealNiceBookName/g;
       	 $ALLTEXTDUTCH =~ s/<<<BookLanguage>>>/$Language/g;
       	 $ALLTEXTDUTCH =~ s/<<<LanguageIndependentBookLanguage>>>/$LanguageDutchBVN/g;
       	 $ALLTEXTDUTCH =~ s/<<<LCLanguageTo>>>/$lclanguageto/g;
       	 $ALLTEXTDUTCH =~ s/<<<TranToLanguage>>>/$TranToLanguage/g;
           $ALLTEXTDUTCH =~ s/<FIRSTPAGETEXT>/$FIRSTPAGETEXTDUTCH/;
       	 $ALLTEXTDUTCH =~ s/<LASTPAGENAME>/$LASTPAGENAMEINDUTCH/;
           $ALLTEXTDUTCH =~ s/<NEXTPAGENAME>/$NEXTPAGENAMEINDUTCH/;
           $ALLTEXTDUTCH =~ s/<LASTFORMATTEDTEXT>/$LASTFORMATTEDTEXTDUTCH/;
           $ALLTEXTDUTCH =~ s/<DEMOADCODE>/$DEMOADCODESTRING/;
       	 $TopLeftChapterName = $TopRightChapterName;
       	 #$WriteFile = "..\\..\\Site\\".$Language."\\".$WebsiteHTMLName."dutch.htm" ;
           #print "Creating File $WriteFile... (Next Chapter Page is $NextChap)!\n" ;
           #print "Next file is $NextFileNameInDutch\n";
           #open (WRITEFILE, ">$WriteFile") || die "file $WriteFile kan niet worden aangemaakt, ($!)\n";
           #print WRITEFILE $ALLTEXTDUTCH ;
           #close (WRITEFILE);
           
           $WROTEAPAGE = "YES";
       }
       
       if ($SitePageNumber > 1 && ($ALLTEXTPAGERIGHT =~ "onmouseover" || $ALLTEXTPAGERIGHT =~ "img" )) {
         # website in english
         $ALLTEXTENGLISH = $ALLTEXT;
         $ALLTEXTENGLISH =~ s/<<<LANGUAGE>>>/$Language/g;
         $ALLTEXTENGLISH =~ s/<<<SAMEPAGEINENGLISH>>>/$THISPAGEWITHENGLISHSUBTITLESANDSITEINENGLISH/g;
         $ALLTEXTENGLISH =~ s/<<<SAMEPAGEINDUTCH>>>/$THISPAGEWITHDUTCHSUBTITLESANDSITEINDUTCH/g;
         $ALLTEXTENGLISH =~ s/<dutchlanguage>/Dutch/g;
         $ALLTEXTENGLISH =~ s/<englishlanguage>/English/g;
         $ALLTEXTENGLISH =~ s/<frenchlanguage>/French/g;
         $ALLTEXTENGLISH =~ s/<germanlanguage>/German/g;
         $ALLTEXTENGLISH =~ s/<italianlanguage>/Italian/g;
         $ALLTEXTENGLISH =~ s/<russianlanguage>/Russian/g;
         $ALLTEXTENGLISH =~ s/<spanishlanguage>/Spanish/g;
         $ALLTEXTENGLISH =~ s/<swedishlanguage>/Swedish/g;
         $ALLTEXTENGLISH =~ s/<greeklanguage>/Greek/g;
         $ALLTEXTENGLISH =~ s/<portugueselanguage>/Portuguese/g;
         $ALLTEXTENGLISH =~ s/<indonesianlanguage>/Indonesian/g;
         $ALLTEXTENGLISH =~ s/<polishlanguage>/Polish/g;
         $ALLTEXTENGLISH =~ s/<hungarianlanguage>/Hungarian/g;
         $ALLTEXTENGLISH =~ s/<urdulanguage>/Urdu/g;
         $ALLTEXTENGLISH =~ s/<translation>/translation/g;
         $ALLTEXTENGLISH =~ s/<sitelang>/english/g;
         $ALLTEXTENGLISH =~ s/<bwhome>/index/g;
         $ALLTEXTENGLISH =~ s/<websiteindex>/index/g;
         $ALLTEXTENGLISH =~ s/<<<BookName>>>/$BookName/g;
         $ALLTEXTENGLISH =~ s/<<<LCBookName>>>/$LCBookName/g;
         $ALLTEXTENGLISH =~ s/<<<RealNiceBookName>>>/$EnglishRealNiceBookName/g;
         $ALLTEXTENGLISH =~ s/<<<BookLanguage>>>/$Language/g;
         $ALLTEXTENGLISH =~ s/<<<LanguageIndependentBookLanguage>>>/$Language/g;
         $ALLTEXTENGLISH =~ s/<<<LCLanguageTo>>>/$lclanguageto/g;
         $ALLTEXTENGLISH =~ s/<<<TranToLanguage>>>/$TranToLanguage/g;
         $ALLTEXTENGLISH =~ s/<FIRSTPAGETEXT>/$FIRSTPAGETEXTENGLISH/;
         $ALLTEXTENGLISH =~ s/<LASTPAGENAME>/$LASTPAGENAMEINENGLISH/;
         $ALLTEXTENGLISH =~ s/<NEXTPAGENAME>/$NEXTPAGENAMEINENGLISH/;
         $ALLTEXTENGLISH =~ s/<LASTFORMATTEDTEXT>/$LASTFORMATTEDTEXTENGLISH/;
         $TopLeftChapterName = $TopRightChapterName;
  
         # website in dutch
         $ALLTEXTDUTCH = $ALLTEXT;
         $ALLTEXTDUTCH =~ s/<<<LANGUAGE>>>/$Language/g;
         $ALLTEXTDUTCH =~ s/<<<SAMEPAGEINENGLISH>>>/$THISPAGEWITHENGLISHSUBTITLESANDSITEINENGLISH/g;
         $ALLTEXTDUTCH =~ s/<<<SAMEPAGEINDUTCH>>>/$THISPAGEWITHDUTCHSUBTITLESANDSITEINDUTCH/g;
         $ALLTEXTDUTCH =~ s/<dutchlanguage>/Nederlands/g;
         $ALLTEXTDUTCH =~ s/<englishlanguage>/Engels/g;
         $ALLTEXTDUTCH =~ s/<frenchlanguage>/Frans/g;
         $ALLTEXTDUTCH =~ s/<germanlanguage>/Duits/g;
         $ALLTEXTDUTCH =~ s/<italianlanguage>/Italiaans/g;
         $ALLTEXTDUTCH =~ s/<russianlanguage>/Russisch/g;
         $ALLTEXTDUTCH =~ s/<spanishlanguage>/Spaans/g;
         $ALLTEXTDUTCH =~ s/<swedishlanguage>/Zweeds/g;
         $ALLTEXTDUTCH =~ s/<greeklanguage>/Grieks/g;
         $ALLTEXTDUTCH =~ s/<portugueselanguage>/Portugees/g;
         $ALLTEXTDUTCH =~ s/<indonesianlanguage>/Indonesisch/g;
         $ALLTEXTDUTCH =~ s/<polishlanguage>/Pools/g;
         $ALLTEXTDUTCH =~ s/<hungarianlanguage>/Hongaars/g;
         $ALLTEXTDUTCH =~ s/<urdulanguage>/Urdu/g;
         $ALLTEXTDUTCH =~ s/<translation>/vertaling/g;
         $ALLTEXTDUTCH =~ s/<sitelang>/dutch/g;
         $ALLTEXTDUTCH =~ s/<bwhome>/dutch/g;
         $ALLTEXTDUTCH =~ s/<websiteindex>/dutch/g;
         $ALLTEXTDUTCH =~ s/<<<BookName>>>/$BookName/g;
         $ALLTEXTDUTCH =~ s/<<<LCBookName>>>/$LCBookName/g;
         $ALLTEXTDUTCH =~ s/<<<RealNiceBookName>>>/$DutchRealNiceBookName/g;
         $ALLTEXTDUTCH =~ s/<<<BookLanguage>>>/$Language/g;
         $ALLTEXTDUTCH =~ s/<<<LanguageIndependentBookLanguage>>>/$LanguageDutchBVN/g;
         $ALLTEXTDUTCH =~ s/<<<LCLanguageTo>>>/$lclanguageto/g;
         $ALLTEXTDUTCH =~ s/<<<TranToLanguage>>>/$TranToLanguage/g;
         $ALLTEXTDUTCH =~ s/<FIRSTPAGETEXT>/$FIRSTPAGETEXTDUTCH/;
         $ALLTEXTDUTCH =~ s/<LASTPAGENAME>/$LASTPAGENAMEINDUTCH/;
         $ALLTEXTDUTCH =~ s/<NEXTPAGENAME>/$NEXTPAGENAMEINDUTCH/;
         $ALLTEXTDUTCH =~ s/<LASTFORMATTEDTEXT>/$LASTFORMATTEDTEXTDUTCH/;
         $TopLeftChapterName = $TopRightChapterName;
       }
       $ALLTEXTENGLISH =~ s/<DEMOADCODE>/$DEMOADCODESTRING/;
       $ALLTEXTDUTCH =~ s/<DEMOADCODE>/$DEMOADCODESTRING/;
   
       if ($lclanguageto eq "english") {
         $ALLTEXTTOWRITE = $ALLTEXTENGLISH;
       }
       if ($lclanguageto eq "dutch") {
         $ALLTEXTTOWRITE = $ALLTEXTDUTCH;
       }
       
       # clean up demo mess
       if ($DEMOWANTED eq "TRUE") {
       	$ALLTEXTTOWRITE =~ s/<<<HEADERLEFT>>>//;
       	$ALLTEXTTOWRITE =~ s/<<<RIGHTSIDEOFPAGENUMBER>>>//;
       	$ALLTEXTTOWRITE =~ s/<<<HEADERRIGHT>>>//;
       	$ALLTEXTTOWRITE =~ s/<<<CHAPTERNAME>>>//;
       }
   
       if ($WROTEAPAGE eq "NO") {
         $WriteFile = "..\\..\\Site\\".$Language."\\".$WebsiteHTMLName."$lclanguageto-".$LASTNR."-".$SitePageNumber.".htm" ;
         if ($TRACING eq "ON") {
           print "Creating File $WriteFile... (Next Chapter Page is $NextChap)!\n" ;
           print "Next file is $NextFileNameInEnglish\n";
         } else { print "."; }
         if ($OnlyWebIndex ne "yes") {
           open (WRITEFILE, ">$WriteFile") || die "file $WriteFile kan niet worden aangemaakt, ($!)\n";
           print WRITEFILE $ALLTEXTTOWRITE ;
           close (WRITEFILE);
         }
           
         $WROTEAPAGE = "YES";
       } else {
         $WROTEAPAGE = "NO";
       }
     }
     # in the end, save $FORMATTEDTEXT to $LASTFORMATTEDTEXT
     $LASTFORMATTEDTEXT = $FORMATTEDTEXT;
     
  }
  
  
  if ($WebsiteOn eq "yes" && $DEMOWANTED eq "TRUE") {
    $WriteFile = "..\\..\\Site\\".$Language."\\".$WebsiteHTMLName."$lclanguageto-".$LASTNR."-".$SitePageNumber.".htm" ;
    $ALLTEXTTOWRITE =~ s/\<img SRC\=\'\.\.\/Pics\/Nextsign\.gif\' align\=right WIDTH\=\'9\' BORDER\=\'0\'\>//;
    if ($TRACING eq "ON") {
      print "Creating File $WriteFile... (Next Chapter Page is $NextChap)!\n" ;
      print "Next file is $NextFileNameInEnglish\n";
    } else { print "."; }
    if ($OnlyWebIndex ne "yes") {
      open (WRITEFILE, ">$WriteFile") || die "file $WriteFile kan niet worden aangemaakt, ($!)\n";
      print WRITEFILE $ALLTEXTTOWRITE ;
      close (WRITEFILE);
    }
  }
  
  
  # store last page number
  $LASTPAGENUMBERT = $SitePageNumber; # use this as Last page number to determine end of chapter adding loop, first page is always 1 of course.
  
  
  #now add the chapter links to the menu text (and, snik, to all pages as hidden page???) Nean, I choselde margin chapters....
  if ($WebsiteOn eq "yes") {
  
       # Add last pagenumber of last chapter and last calculation of total...
       $TOTALPAGESOFTHISCHAPTER = $LASTNR - $LASTFIRSTNR ;
       #$CHAPTERLINKSENGLISH = $CHAPTERLINKSENGLISH.$LASTNR." / ".$TOTALPAGESOFTHISCHAPTER.")<\/A><BR>" ;
       $CHAPTERLINKSENGLISH = $CHAPTERLINKSENGLISH."<\/A><BR>" ;
       #$CHAPTERLINKSENGLISH = $CHAPTERLINKSENGLISH.$LASTNR." / ".$TOTALPAGESOFTHISCHAPTER.")<\/A><BR>" ;
       $CHAPTERLINKSENGLISH = $CHAPTERLINKSENGLISH."<\/A><BR>" ;
       
       #first the english menu page, english_english and dutch_english pages
       $MenuFile = "../../Site/".$Language."/".$WebsiteHTMLName."menu_english.htm" ;
       open (READFILE, "$MenuFile") || print "file $MenuFile cannot be found. ($!)\n";
       @ALLTEXT = <READFILE>;
       close (READFILE);
       $ALLTEXT = join ("",@ALLTEXT) ;
       # place relevant video ad
       if ($WebsiteHTMLName =~ "fairytales") {
          $ALLTEXTENGLISH =~ s/<THIRDROWAD>/$SMALLADTHIRDROWENGLISH/;
       }
       if ($WebsiteHTMLName =~ "shortstories") {
          $ALLTEXTENGLISH =~ s/<THIRDROWAD>/$SMALLADTHIRDROWENGLISHSS/;
       }
       # now replace <CHAPTERLINKS> code by actual Chapter Links
       #$TITNING = "<B>Chapters</B> (Start-End / Total*)<BR>\n";
       $TITNING = "<B>Chapters</B><BR>\n";
       #$WARLE = "\n<I>*Including one or two empty pages at the end</I>\n";
       $WARLE = "\n";
       $CHAPTERLINKSENGLISH = $TITNING.$CHAPTERLINKSENGLISH.$WARLE ;
       $ALLTEXT =~ s/<CHAPTERLINKS>/$CHAPTERLINKSENGLISH/;
       if ($TRACING eq "ON") {
         print "Editing File $MenuFile... (Add chapter links)...\n" ;
       } else { print "."; }
       open (WRITEFILE, ">$MenuFile") || print "file $MenuFile kan niet worden aangemaakt, ($!)\n";
       print WRITEFILE $ALLTEXT ;
       close (WRITEFILE);
  
       if ($TRACING eq "ON") {
         print "Inserting chapterlinks here: $CHAPTERLINKSDUTCH\n";
       } else { print "."; }
       $MenuFile = "../../Site/".$Language."/".$WebsiteHTMLName."menu_dutch.htm" ;
       open (READFILE, "$MenuFile") || print "file $MenuFile cannot be found. ($!)\n";
       @ALLTEXT = <READFILE>;
       close (READFILE);
       $ALLTEXT = join ("",@ALLTEXT) ;
       # place relevant video ad
       if ($WebsiteHTMLName =~ "fairytales") {
          $ALLTEXT =~ s/<THIRDROWAD>/$SMALLADTHIRDROWDUTCH/;
       }
       if ($WebsiteHTMLName =~ "shortstories") {
       	$ALLTEXT =~ s/<THIRDROWAD>/$SMALLADTHIRDROWDUTCHSS/;
       }
       # now replace <CHAPTERLINKS> code by actual Chapter Links
       #$TITNING = "<B>Hoofdstukken</B> (Begin-Einde / Totaal*)<BR>\n";
       $TITNING = "<B>Hoofdstukken</B><BR>\n";
       #$WARLE = "\n<I>*Inclusief een of twee lege pagina's aan het eind</I>\n";
       $WARLE = "\n";
       $CHAPTERLINKSDUTCH = $TITNING.$CHAPTERLINKSDUTCH.$WARLE ;
       $ALLTEXT =~ s/<CHAPTERLINKS>/$CHAPTERLINKSDUTCH/;
       if ($TRACING eq "ON") {
         print "Editing File $MenuFile... (Add chapter links)...\n" ;
       } else { print "."; }
       open (WRITEFILE, ">$MenuFile") || print "file $MenuFile kan niet worden aangemaakt, ($!)\n";
       print WRITEFILE $ALLTEXT ;
       close (WRITEFILE);
       
       #$MenuFile = "../../Site/".$Language."/".$WebsiteHTMLName."english.htm" ;
       #open (READFILE, "$MenuFile") || print "file $MenuFile cannot be found. ($!)\n";
       #@ALLTEXT = <READFILE>;
       #close (READFILE);
       #$ALLTEXT = join ("",@ALLTEXT) ;
       ## now replace <CHAPTERLINKS> code by actual Chapter Links         ???!?!? BUT THERE AINT NO CHAPTERLINKS CODE HERE???
       #$ALLTEXT =~ s/<CHAPTERLINKS>/$CHAPTERLINKSENGLISH/;
       #print "Editing File $MenuFile... (Add chapter links)...\n" ;
       #open (WRITEFILE, ">$MenuFile") || print "file $MenuFile kan niet worden aangemaakt, ($!)\n";
       #print WRITEFILE $ALLTEXT ;
       #close (WRITEFILE);
       
       #$MenuFile = "../../Site/".$Language."/".$WebsiteHTMLName."dutch.htm" ;
       #open (READFILE, "$MenuFile") || print "file $MenuFile cannot be found. ($!)\n";
       #@ALLTEXT = <READFILE>;
       #close (READFILE);
       #$ALLTEXT = join ("",@ALLTEXT) ;
       ## now replace <CHAPTERLINKS> code by actual Chapter Links         ???!?!? BUT THERE AINT NO CHAPTERLINKS CODE HERE???
       #$ALLTEXT =~ s/<CHAPTERLINKS>/$CHAPTERLINKSDUTCH/;
       #print "Editing File $MenuFile... (Add chapter links)...\n" ;
       #open (WRITEFILE, ">$MenuFile") || print "file $MenuFile kan niet worden aangemaakt, ($!)\n";
       #print WRITEFILE $ALLTEXT ;
       #close (WRITEFILE);
  
   
    #EDIT THE FOLLOWING TO ONLY REPLACE CHAPTERS FOR THE TO-LANGUAGE FILES YOU'RE RUNNING THE SCRIPT FOR AS THIS WAY IT TAKES TOO MUCH TIME!!!!
       # IF YOU WANT TO ADD ALL CHAPTERS TO EVERY PAGE IN THE LEFT MENU BAR, ENTER HERE :-)     ( $LASTPAGENUMBERT BEING THE LAST PAGE )
       if ($OnlyWebIndex ne "yes") {
         for ($ChapterBarPage=1; $ChapterBarPage < $LASTPAGENUMBERT+1; $ChapterBarPage=$ChapterBarPage+2) {
           $ChapterBarPagePlusOne = $ChapterBarPage + 1 ;
           if ($lclanguageto eq "english") {
             $PageFile = "../../Site/".$Language."/".$WebsiteHTMLName."english-$ChapterBarPage-$ChapterBarPagePlusOne.htm" ;
             open (READFILE, "$PageFile") || print "file $PageFile cannot be found. ($!)\n";
             @ALLTEXT = <READFILE>;
             close (READFILE);
             $ALLTEXT = join ("",@ALLTEXT) ;
             # now replace <CHAPTERLINKS> code by actual Chapter Links
             $ALLTEXT =~ s/<CHAPTERLINKS>/$CHAPTERLINKSENGLISHSMALL/;
             if ($TRACING eq "ON") {
               print "Editing File $PageFile... (Add chapter links)...\n" ;
             } else { print "."; }
             open (WRITEFILE, ">$PageFile") || print "file $PageFile kan niet worden aangemaakt, ($!)\n";
             print WRITEFILE $ALLTEXT ;
             close (WRITEFILE);
           }
  
           if ($lclanguageto eq "dutch") {
             $PageFile = "../../Site/".$Language."/".$WebsiteHTMLName."dutch-$ChapterBarPage-$ChapterBarPagePlusOne.htm" ;
             open (READFILE, "$PageFile") || print "file $PageFile cannot be found. ($!)\n";
             @ALLTEXT = <READFILE>;
             close (READFILE);
             $ALLTEXT = join ("",@ALLTEXT) ;
             # now replace <CHAPTERLINKS> code by actual Chapter Links
             $ALLTEXT =~ s/<CHAPTERLINKS>/$CHAPTERLINKSDUTCHSMALL/;
             if ($TRACING eq "ON") {
               print "Editing File $PageFile... (Add chapter links)...\n" ;
             } else { print "."; }
             open (WRITEFILE, ">$PageFile") || print "file $PageFile kan niet worden aangemaakt, ($!)\n";
             print WRITEFILE $ALLTEXT ;
             close (WRITEFILE);
           }
         }
       }
  }
  
 
  
  if ($PDFOn eq "yes") {
  
    # N.B. Filename length based on OS
    # iOS file=255 path=1024
    # OSx file=255
    # Windows mobile file=260
    # Windows file=260
    # Android file=127 !!!!!!!!!!!!!
  
    # Windows local path example: 84 length
    # C:\Users\Work\AppData\Local\Packages\io.cordova.myapp2027a0_h35559jr9hy9m\LocalState
    # Android is much shorter, but let's say it's 60 so keep filename under 60
    # nonetheless, because of Android constraint, keep filenames to max. 30 (?)
    # <base language code>	= 3
    # ___				= 3
    # <author code>		= 10 -> if you shorten this, more room for the story code, vice versa, if you have longer author code, less room for story codes
    # ___				= 3
    # <story code>		= 18 -> probably longer, if author is shorter, or if Android path is shorter and leaves more room for filename
    # ___				= 3
    # <target language code>	= 3 -> later max 20? 5 target languages x 3 character code length plus five underscores
    # ---------------------------------------------------
    # total			= 43 -> max 60
    # ---------------------------------------------------
    # app path total: www/texts	= 10
    # extendedDataDirectory:	= ??
  
    # if App, divide into stories, if not, keep whole
    if ($APPOn eq "yes") {
      if ($TRACING eq "ON") {
        print "Parting into stories...\n";
      } else { print "."; }
      @STORIES = @ChapterFileNames;
      @STORYORIGINALTITLES = @ChapterNames;
      shift @STORYORIGINALTITLES; # remove title/contents
      @STORYTRANSLATEDTITLES = @ChapterLongNamesTranslationEnglish;
      shift @STORYTRANSLATEDTITLES; # remove title/contents
      @STORYCONTENTS = split(/###CHAPTERDIVISIONCODE###/,$TOTALTEXT);
      shift @STORYCONTENTS; # skip title/contents
    } else {
      @STORIES = ("Bother");
      @STORYORIGINALTITLES = ("Bother");
      @STORYTRANSLATEDTITLES = ("Bother");
    }
    
    for ($StoryNumber = 0; $StoryNumber < @STORIES; $StoryNumber++) {
    
      if ($TRACING eq "ON") {
        print "Doing story number $StoryNumber...\n";
      } else { print "."; }
      
      $StoryFileName = $STORIES[$StoryNumber]; # still need this for the picturename and will use this for the key after all and put the full name in an associative array
      if ($APPOn eq "yes") {
        $TOTALTEXT = $STORYCONTENTS[$StoryNumber];  # pdf doesn't have chapterdivisioncodes so stays whole
      }
      
      if ($APPOn eq "yes") {
        # do author, you'll probably have to create an associative array for author as well if you want to include weird characters
        $StoryAuthor = $ChapterAuthors[$StoryNumber];
        if ($StoryAuthor eq "") {
          $StoryAuthor = $ChapterAuthors[0];
        }
        $StoryWords = $ChapterWords[$StoryNumber];
        $StoryUniqueWords = $ChapterUniqueWords[$StoryNumber];
        $StoryNiceAuthor = $ChapterNiceAuthors[$StoryNumber];
        if ($StoryNiceAuthor eq "") {
          $StoryNiceAuthor = $ChapterNiceAuthors[0];
        }
        $STORYORITITLE = $STORYORIGINALTITLES[$StoryNumber];
        $STORYTARTITLE = $STORYTRANSLATEDTITLES[$StoryNumber];
        
        # also get last audio
        $RealLastPageAudioCounter = $RealLastPageAudioCounters[$StoryNumber+1];
        $AudioToPageArray = $AudioToPageArrays[$StoryNumber+1];
      
        # get the nice title and put it in array in subhyplern.js
        $StoryName = $ChapterNames[$StoryNumber+1];

        # neatify the story title before giving it to subhyplern.js
        @StoryNameChars = split(//,$StoryName);
        for ($charnr = 130 ; $charnr < 255 ; $charnr++)
        {
          $charch = chr($charnr);
          $StoryName =~ s/$charch/\&\#$charnr\;/g;
        }
      
        # create line for subhyplern.js
        #print "Trying to work with constants.js now...\n";
        $StoryArrayPart = "storyHash\[\"".$StoryAuthor."_".$StoryFileName."\"\] \= \"".$StoryNiceAuthor."_".$StoryName."_Level ".$TEXTLEVEL.", ".$StoryWords."\"\;";
      
        # open Subhyplern file to get current full story names
        $SUBLRNTEXT = "";
        $SubhyplernFile = "..\\Base\\App\\scripts\\constants.js";
        open (READFILE, $SubhyplernFile) || die "file $SubhyplernFile cannot be found. ($!)\n";
        @SUBLRNTEXT = <READFILE>;
        close (READFILE);
        foreach $SUBLRNTEXTLINE (@SUBLRNTEXT) {
          $SUBLRNTEXT = $SUBLRNTEXT."$SUBLRNTEXTLINE";
        }
        
        # do your thang
        ($SUBLRNTEXTPARTONE,$SUBLRNTEXTSTORYCODES,$SUBLRNTEXTPARTTWO) = split(/\/\/\<SUBLRNSTORYCODES\>/,$SUBLRNTEXT);
        #print "Extracted current SUBLRNTEXTSTORYCODES ".$SUBLRNTEXTSTORYCODES." from SUBLRNTEXT ".$SUBLRNTEXT." !";
        if ($SUBLRNTEXTSTORYCODES !~ "\"".$StoryAuthor."_".$StoryFileName."\"") {
          $SUBLRNTEXTSTORYCODES = $SUBLRNTEXTSTORYCODES."\n".$StoryArrayPart;
          #print "Trying to add StoryArrayPart ".$StoryArrayPart." to them ...\n";
        }
        #print "SUBLRNTEXTSTORYCODES now ".$SUBLRNTEXTSTORYCODES."...\n";
        
        # write codes to file
        open (WRITEFILE, ">$SubhyplernFile") || die "file $SubhyplernFile kan niet worden aangemaakt, ($!)\n";
        $FINALSUBLRNTEXT = $SUBLRNTEXTPARTONE."\/\/\<SUBLRNSTORYCODES\>".$SUBLRNTEXTSTORYCODES."\/\/\<SUBLRNSTORYCODES\>".$SUBLRNTEXTPARTTWO;
        print WRITEFILE $FINALSUBLRNTEXT ;
        close (WRITEFILE);
        #copy ..\\Base\\App\\scripts\\constants.js variables manually to subhyplern.js
        #this can be worked into an automatic build process
        #for now Visual Studio will add spaces in front of every line and fuck up the files
      }
     
      # PDF or App paths
      $lclanguageto=lc($TranToLanguage);
      $LCLanguage =lc($Language);
      
      # create default App text link key
      $StoryAuthor =~ s/ /\-/g;
      
      # make sure there's no spaces or underscores in the story filename key
      $StoryFileName =~ s/ /\-/g;
      $StoryFileName =~ s/\_/\-/g;
      
      # key
      $AppTextKey = $AppLangCode."_".$StoryAuthor."_".$StoryFileName;
      
      # path
      $AppTextPath = $StoryAuthor."_".$StoryFileName;
      
      # create language root with iso code and create story path (need that for story image and story gray image)
      if ($APPOn eq "yes") {
        if (-e "..\\Cordova\\AppProjects\\".$HypLernPath."\\".$HypLernPath."\\www\\texts\\".$AppLangCode) {
          # Yay!
        } else {
          `mkdir "..\\Cordova\\AppProjects\\$HypLernPath\\$HypLernPath\\www\\texts\\$AppLangCode"`;
        }
        if (-e "..\\Cordova\\AppProjects\\".$HypLernPath."\\".$HypLernPath."\\www\\texts\\".$AppLangCode."\\".$AppTextPath) {
          # Yay!
        } else {
          `mkdir "..\\Cordova\\AppProjects\\$HypLernPath\\$HypLernPath\\www\\texts\\$AppLangCode\\$AppTextPath"`;
        }
      }
      
      #print "Checking AppTextPath $AppTextPath against contents of HYPLERNKEYFILETEXT $HYPLERNKEYFILETEXT!\n";      
      if ($APPOn eq "yes" && ( $MAINLANG eq "" || ($MAINLANG eq $Language && $MAINSTORY ne "Free") || $HYPLERNKEYFILETEXT =~ "\_$AppTextPath\"" ) ) {
        if ($TRACING eq "ON") {
          print "Ontario AppTextKey is $AppTextKey\n";
        } else { print "."; }
        $WriteFile = "..\\Cordova\\AppProjects\\".$HypLernPath."\\".$HypLernPath."\\www\\texts\\".$AppLangCode."\\".$AppTextPath."\\text.htm" ;
        $StoryTitle = $STORYTARTITLE ;
      } else {
      	if ($APPOn ne "yes") {
          if ($lclanguageto eq "english") {
            $WriteFile = "..\\..\\Pdf\\".$Language."\\$Language ".$PDFTitle." subtitled in English.htm" ;
            $StoryTitle = $Language." ".$PDFTitle." subtitled in English" ;
          }
          if ($lclanguageto eq "dutch") {
            $WriteFile = "..\\..\\Pdf\\".$Language."\\$LanguageDutchBVN ".$PDFTitle." subtitels in Nederlands.htm" ;
            $StoryTitle = $LanguageDutchBVN." ".$PDFTitle." subtitels in Nederlands" ;
          }
        }
      }
      
      # COPY CORRECT IMAGES FOR APP
      if ($APPOn eq "yes" && ( $MAINLANG eq "" || ($MAINLANG eq $Language && $MAINSTORY ne "Free") || $HYPLERNKEYFILETEXT =~ "\_$AppTextPath\"" ) ) {	
        if ($TRACING eq "ON") {
          print "Copying pictures to $AppLangCode\\$AppTextPath\\images\n";
        } else { print "."; }
        #\<img SRC\=\"Pics\\|\"
        @PICARRAY = split(/<img SRC=\"Pics\\|\"/,$TOTALTEXT);
        if (-e "..\\Cordova\\AppProjects\\".$HypLernPath."\\".$HypLernPath."\\www\\texts\\".$AppLangCode."\\".$AppTextPath."\\images") {
          #yay!
        } else {
          `mkdir "..\\Cordova\\AppProjects\\$HypLernPath\\$HypLernPath\\www\\texts\\$AppLangCode\\$AppTextPath\\images"`;
        }
        for ($ArrayNumber = 0; $ArrayNumber < @PICARRAY; $ArrayNumber++) {
          if ($PICARRAY[$ArrayNumber] =~ m/\.jpg|\.gif|\.png|\.bmp|\.jpeg/i) {
            $PicName = $PICARRAY[$ArrayNumber];
            $Output = `copy ..\\Base\\Media\\$Language\\$Group\\$PicName "..\\Cordova\\AppProjects\\$HypLernPath\\$HypLernPath\\www\\texts\\$AppLangCode\\$AppTextPath\\images\\$PicName" 2>&1`;
            if ($? != 0) {
              if ($TRACING eq "ON") {
                print "He gatsie! Kon het plaatje niet copuleren! Fout: $Output\n";
              } else { print "."; }
            } else {
              #yay!
              #print "$PicName, ";
            }
          }
        }
      }
      
  
      # CREATIE VAN PDF PAGES
      if ($APPOn eq "yes") {
        $ReadFile = "..\\Base\\HTML\\Main\\HTMLTemplate_APPPage.htm" ;
      } else {
        $ReadFile = "..\\Base\\HTML\\Main\\HTMLTemplate_PDFPage.htm" ;
      }
      open (READFILE, "$ReadFile") || die "file $ReadFile cannot be found. ($!)\n";
      @INITIALTEXT = <READFILE>;
      $INITIALRAWTEXT = "@INITIALTEXT";
      ($INITIALTEXT,$ENDTEXT) = split("<<<SPLITAPPTEMPLATE>>>",$INITIALRAWTEXT);
      close (READFILE);
    
      #print "$INITIALPDFTEXT\n";
    
      $ADEMOOF = "";
      if ($DEMOWANTED eq "TRUE") {
        $ADEMOOF = "a demo of";
        $ADEMOOFDUTCH = "een demo van";
        $THEFULLVERSION = "the full version of this App, or ";
        $THEFULLVERSIONDUTCH = "de volledige versie van deze App, of ";
      }
    
      if ($AUDIOEXISTS eq "yes") {
        $INCLUDESAUDIO = " includes audio";
        $INCLUDESAUDIODUTCH = " is met audio";
        $ANDLISTENING = " and listening";
        $ANDLISTENINGDUTCH = " en luisteren";
      }
      
      if ($DISCOUNT ne "") {
        $DUTCHDISCOUNT = $DISCOUNT." op";
        $DISCOUNT = $DISCOUNT." on";
      }
      
      $EXTRAINFO = "</nobr><br><center><img src='..\\Main\\Pics\\BermudaWordHomeMap.jpg' WIDTH='70%' border=0></center><br><span class='text'>";
      if ($lclanguageto eq "dutch") {
      	if ($APPOn ne "yes") {
          $EXTRAINFO = $EXTRAINFO."Het boek dat je nu leest bevat $ADEMOOFDUTCH de papieren of digitale versie van de krachtige e-boek App van Bermuda Word. ";
          $EXTRAINFO = $EXTRAINFO."Onze e-boeken met geïntegreerde software zorgen ervoor dat je vloeiend wordt in $LanguageDutch lezen$ANDLISTENINGDUTCH, snel en gemakkelijk! ";
          $EXTRAINFO = $EXTRAINFO."Ga naar <a href='https://learn-to-read-foreign-languages.com'>learn-to-read-foreign-languages.com</a> en ontvang <b><span style='color: #ff0000;'>$DUTCHDISCOUNT</span></b> de App versie van dit e-boek!</span>";
          $EXTRAINFO = $EXTRAINFO."<br><br><img src='..\\Main\\Pics\\Example-$Language-$Group-$lclanguageto.jpg' WIDTH='100%' border=0>";
          $EXTRAINFO = $EXTRAINFO."\n</div>\n<br clear=all style='page-break-before:always'><br>\n<div class='page'>";
          $EXTRAINFO = $EXTRAINFO."<span class='text'>De standalone e-reader software bevat de e-boek tekst,$INCLUDESAUDIODUTCH en integreert <b>spaced repetition woordoefeningen</b> ";
          $EXTRAINFO = $EXTRAINFO."voor <b>optimaal leren van een taal</b>. Kies je font type of grootte en lees als je zou doen met een normale e-reader. ";
          $EXTRAINFO = $EXTRAINFO."Zonder woorden opzoeken doorlezen door de <b>onmiddelijke mouse-over pop-up vertalingen</b>, of klik een woord om het <b>toe te voegen aan je woordenlijst</b>. ";
          $EXTRAINFO = $EXTRAINFO."De software weet welke woorden zeldzaam zijn en meer oefening nodig hebben. ";
          $EXTRAINFO = $EXTRAINFO."<br><br><img src='..\\Main\\Pics\\Example-$Language-$Group-$lclanguageto-menu.jpg' WIDTH='100%' border=0><br><br>";
          $EXTRAINFO = $EXTRAINFO."Met het Bermuda Word e-boek programma <b>onthoud je alle woorden</b> makkelijk door lezen$ANDLISTENINGDUTCH en efficiënt oefenen!</span>";
          $EXTRAINFO = $EXTRAINFO."<br><br><center><b>LEARN-TO-READ-FOREIGN-LANGUAGES.COM</b></center>\n";
          $EXTRAINFO = $EXTRAINFO."<br><center><b><span style='color: #888888;'>Copyright &#169; 2006-2016 Bermuda Word</span></b></center>\n";
        } else {
          $EXTRAINFO = $EXTRAINFO."Het verhaal dat je nu leest is $ADEMOOFDUTCH de App versie van dit e-boek van Bermuda Word. ";
          $EXTRAINFO = $EXTRAINFO."Deze e-boeken met geïntegreerde software zorgen ervoor dat je vloeiend wordt in $LanguageDutch lezen$ANDLISTENINGDUTCH, snel en gemakkelijk! ";
          $EXTRAINFO = $EXTRAINFO."Ga naar <a href='https://learn-to-read-foreign-languages.com' target='_blank' title='Bermuda Word Shop'>learn-to-read-foreign-languages.com</a> als <b>je $THEFULLVERSIONDUTCH een interlineaire papieren of e-reader versie van dit verhaal wil met aparte mp3's erbij</b>!</span>";
          $EXTRAINFO = $EXTRAINFO."<br><br><center><img src='..\\..\\..\\images\\Kindle.jpg' style=\"width: 100%; max-width: 500px; border: 0;\"></center>";
          $EXTRAINFO = $EXTRAINFO."\n</div>\n<br clear=all style='page-break-before:always'><br>\n<div class='page'>";
          $EXTRAINFO = $EXTRAINFO."<span class='text'>Deze standalone e-reader App bevat de e-boek tekst,$INCLUDESAUDIODUTCH en integreert <b>spaced repetition woordoefeningen</b> ";
          $EXTRAINFO = $EXTRAINFO."voor <b>optimaal leren van een taal</b>. Kies je font type of grootte en lees als je zou doen met een normale e-reader. ";
          $EXTRAINFO = $EXTRAINFO."Zonder woorden opzoeken doorlezen door de <b>interlineaire vertaling, of de onmiddelijke mouse-over pop-up vertalingen</b>, en klik een woord om het <b>toe te voegen aan je woordenlijst</b>. ";
          $EXTRAINFO = $EXTRAINFO."De software weet welke woorden zeldzaam zijn en meer oefening nodig hebben. ";
          $EXTRAINFO = $EXTRAINFO."<br><br><center><img src='..\\..\\..\\images\\BWB.jpg' width='100%' border=0></center><br><br>";
          $EXTRAINFO = $EXTRAINFO."Met de HypLern App van Bermuda Word <b>onthoud je alle woorden</b> makkelijk door lezen$ANDLISTENINGDUTCH en efficiënt oefenen!</span>";
          $EXTRAINFO = $EXTRAINFO."<br><br><center><b><a href='https://learn-to-read-foreign-languages.com'>LEARN-TO-READ-FOREIGN-LANGUAGES.COM</a></b></center>\n";
          $EXTRAINFO = $EXTRAINFO."<br><center><b><span style='color: #888888;'>Copyright &#169; 2006-2016 Bermuda Word</span></b></center>\n";
        }
      }
      if ($lclanguageto eq "english") {
      	if ($APPOn ne "yes") {
          $EXTRAINFO = $EXTRAINFO."The book you're now reading contains $ADEMOOF the paper or digital paper version of the powerful e-book application from Bermuda Word. ";
          $EXTRAINFO = $EXTRAINFO."Our software integrated e-books allow you to become fluent in $Language reading$ANDLISTENING, fast and easy! ";
          $EXTRAINFO = $EXTRAINFO."Go to <a href='https://learn-to-read-foreign-languages.com' target='_blank' title='Bermuda Word Shop'>learn-to-read-foreign-languages.com</a>, and get <b><span style='color: #ff0000;'>$DISCOUNT</span></b> the App version of this e-book!</span>";
          $EXTRAINFO = $EXTRAINFO."<br><br><img src='..\\Main\\Pics\\Example-$Language-$Group-$lclanguageto.jpg' WIDTH='100%' border=0>";
          $EXTRAINFO = $EXTRAINFO."\n</div>\n<br clear=all style='page-break-before:always'><br>\n<div class='page'>";
          $EXTRAINFO = $EXTRAINFO."<span class='text'>The standalone e-reader software contains the e-book text,$INCLUDESAUDIO and integrates <b>spaced repetition word practice</b> ";
          $EXTRAINFO = $EXTRAINFO."for <b>optimal language learning</b>. Choose your font type or size and read as you would with a regular e-reader. ";
          $EXTRAINFO = $EXTRAINFO."Stay immersed with <b>interlinear</b> or <b>immediate mouse-over pop-up translation</b> and click on difficult words to <b>add them to your wordlist</b>. ";
          $EXTRAINFO = $EXTRAINFO."The software knows which words are low frequency and need more practice. ";
          $EXTRAINFO = $EXTRAINFO."<br><br><img src='..\\Main\\Pics\\Example-$Language-$Group-$lclanguageto-menu.jpg' WIDTH='100%' border=0><br><br>";
          $EXTRAINFO = $EXTRAINFO."With the Bermuda Word e-book program you <b>memorize all words</b> fast and easy just by reading$ANDLISTENING and efficient practice!</span>";
          $EXTRAINFO = $EXTRAINFO."<br><br><center><b>LEARN-TO-READ-FOREIGN-LANGUAGES.COM</b></center>\n";
          $EXTRAINFO = $EXTRAINFO."<br><br><center><b><span style='color: #888888;'>Copyright &#169; 2006-2016 Bermuda Word</span></b></center>\n";
        } else {
          $EXTRAINFO = $EXTRAINFO."The story you're now reading is $ADEMOOF the App version of an interlinear e-book published on Amazon. ";
          #$EXTRAINFO = $EXTRAINFO."These software integrated e-books allow you to become fluent in $Language reading$ANDLISTENING, fast and easy! ";
          $EXTRAINFO = $EXTRAINFO."Check out all our interlinear e-books and paperbacks at <a href='https://www.amazon.com/s/field-keywords=bermuda+word+interlinear' target='_blank' title='Amazon'>Amazon</a>!</b></span>";
          $EXTRAINFO = $EXTRAINFO."<br><br><center><img src='..\\..\\..\\images\\Kindle.jpg' style=\"width: 100%; max-width: 500px; border: 0;\"></center>";
          $EXTRAINFO = $EXTRAINFO."\n</div>\n<br clear=all style='page-break-before:always'><br>\n<div class='page'>";
          $EXTRAINFO = $EXTRAINFO."<span class='text'>The App contains the e-book text,$INCLUDESAUDIO and integrates <b>spaced repetition word practice</b> ";
          $EXTRAINFO = $EXTRAINFO."for <b>optimal language learning</b>. Choose your font type or size and read as you would with a regular e-reader. ";
          $EXTRAINFO = $EXTRAINFO."Stay immersed with <b>the easy interlinear or immediate mouse-over pop-up translation</b> and click on difficult words to <b>add them to your wordlist</b>. ";
          $EXTRAINFO = $EXTRAINFO."The software knows which words are low frequency and need more practice. ";
          #$EXTRAINFO = $EXTRAINFO."<br><br><center><img class='bigger' src='..\\..\\..\\images\\BWB.jpg' width='100%' border=0></center><br><br>";
          $EXTRAINFO = $EXTRAINFO."With the HypLern App from Bermuda Word you <b>memorize all words</b> fast and easy just by reading$ANDLISTENING and efficient practice!</span>";
          $EXTRAINFO = $EXTRAINFO."<br><br><center><b><a href='https://learn-to-read-foreign-languages.com' target='_blank' title='Bermuda Word Shop'>LEARN-TO-READ-FOREIGN-LANGUAGES.COM</a></b></center>\n";
          $EXTRAINFO = $EXTRAINFO."<br><br><center><b><span style='color: #888888;'>Copyright &#169; 2006-2016 Bermuda Word</span></b></center>\n";
        }
      }
      $EXTRAINFO = $EXTRAINFO."</div>\n";
    
      # FIT IN FOREWORD
      #$FOREWORD = "\n</div>\n<br clear=all style='mso-special-character:line-break;page-break-before:always'>\n<div class='page'>\n";
      $FOREWORD = "</nobr><center><img src='..\\Main\\Pics\\BermudaWordHomeMap.jpg' WIDTH='70%' border=0></center><br><span class='text'>\n";
      if ($lclanguageto eq "dutch") {
        $FOREWORD = $FOREWORD."Beste Lezer en Talen student!<br><br>\n\n";
        $FOREWORD = $FOREWORD."Je leest de interlineaire editie van onze Bermuda Word pop-up e-boeken die we verkopen op <a href='https://learn-to-read-foreign-languages.com' target='_blank' title='Bermuda Word Shop'>learn-to-read-foreign-languages.com</a>. Voor je $LanguageDutch begint te lezen, lees alsjeblieft de uitleg van onze methode.<br><br>\n\n";
        $FOREWORD = $FOREWORD."Daar we willen dat je $LanguageDutch leest en leert bestaat onze methode primair uit woord-voor-woord vertalingen en idiomatisch Nederlands waar nodig. Zie dit voorbeeld voor Frans:<br><br>\n\n";
        $FOREWORD = $FOREWORD."Il&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;y&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;avait&nbsp;&nbsp;&nbsp;&nbsp;du&nbsp;&nbsp;&nbsp;&nbsp;vin<br>\n";
        $FOREWORD = $FOREWORD."<span style='color: dimgray;'>Het&nbsp;&nbsp;er&nbsp;&nbsp;&nbsp;&nbsp;had&nbsp;&nbsp;van de&nbsp;&nbsp;wijn<br>\n";
        $FOREWORD = $FOREWORD."[Er&nbsp;was&nbsp;wijn]<\/span><br><br>\n\n";
        $FOREWORD = $FOREWORD."Deze methode werkt het best als je de tekst herleest tot je de vaak voorkomende woorden hebt geleerd slechts door te lezen, en dan de moeilijke woorden leert door ze te markeren en herhalen of te oefenen met de App.<br><br>\n\n";
        $FOREWORD = $FOREWORD."Vergeet niet een kijkje te nemen naar onze e-boek App met geïntegreerde educatie software die we aanbieden op <a href='https://learn-to-read-foreign-languages.com' target='_blank' title='Bermuda Word Shop'>learn-to-read-foreign-languages.com</a>! Voor meer informatie kijk op de laatste twee pagina's!<br><br>\n\n";
        $FOREWORD = $FOREWORD."Bedankt voor het geduld, veel plezier met lezen en leren!<br><br>\n\n";
        $FOREWORD = $FOREWORD."Kees van den End<br><br>\n\n";
        $FOREWORD = $FOREWORD."<center><b>LEARN-TO-READ-FOREIGN-LANGUAGES.COM</b></center>\n";
        $FOREWORD = $FOREWORD."<center><b><span style='color: #888888;'>Copyright © 2006-2016 Bermuda Word</span></b></center>\n";
        $FOREWORD = $FOREWORD."\n</div>\n<br clear=all style='mso-special-character:line-break;page-break-before:always'><br>\n<div class='page'>";
      }
      if ($lclanguageto eq "english") {
        $FOREWORD = $FOREWORD."Dear Reader and Language Learner!<br><br>\n\n";
        $FOREWORD = $FOREWORD."You're reading the Kindle learner edition of our Bermuda Word pop-up e-books which we sell at <a href='https://learn-to-read-foreign-languages.com' target='_blank' title='Bermuda Word Shop'>learn-to-read-foreign-languages.com</a>. Before you start reading $Language, please read this explanation of our method.<br><br>\n\n";
        $FOREWORD = $FOREWORD."Since we want you to read $Language and to learn $Language, our method consists primarily of word-for-word literal translations, but we add idiomatic English if this helps understanding the sentence. \n\n";
        $FOREWORD = $FOREWORD."For example for French:<br>\n";
        $FOREWORD = $FOREWORD."Il&nbsp;&nbsp;&nbsp;y&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;avait&nbsp;&nbsp;&nbsp;&nbsp;du&nbsp;&nbsp;&nbsp;&nbsp;vin<br>\n";
        $FOREWORD = $FOREWORD."<span style='color: dimgray;'>It&nbsp;&nbsp;&nbsp;there&nbsp;&nbsp;had&nbsp;&nbsp;of the&nbsp;&nbsp;wine<br>\n";
        $FOREWORD = $FOREWORD."[There&nbsp;&nbsp;was&nbsp;&nbsp;wine]<\/span><br><br>\n\n";
        $FOREWORD = $FOREWORD."This method works best if you re-read the text until you know the high frequency words just by reading, and then mark and learn the low frequency words in your reader or practice them with our brilliant App.<br><br>\n\n";
        $FOREWORD = $FOREWORD."Don't forget to take a look at the e-book App with integrated learning software that we offer at <a href='https://learn-to-read-foreign-languages.com' target='_blank' title='Bermuda Word Shop'>learn-to-read-foreign-languages.com</a>! For more info check the last two pages of this e-book!<br><br>\n\n";
        $FOREWORD = $FOREWORD."Thanks for your patience and enjoy the story and learning $Language!<br><br>\n\n";
        $FOREWORD = $FOREWORD."Kees van den End<br><br>\n\n";
        $FOREWORD = $FOREWORD."<center><b>LEARN-TO-READ-FOREIGN-LANGUAGES.COM</b></center>\n";
        $FOREWORD = $FOREWORD."<center><b><span style='color: #888888;'>Copyright © 2006-2016 Bermuda Word</span></b></center>\n";
        $FOREWORD = $FOREWORD."\n</div>\n<br clear=all style='mso-special-character:line-break;page-break-before:always'><br>\n<div class='page'>";
      }
      
      if ($APPOn ne "yes") {
        $TOTALTEXT =~ s/\<div class\=\'page\'\>/\<div class\=\'page\'\>$FOREWORD/;
      }
      
      $TOTALTEXT =~ s/\<p class\=atxt\>/\<p class\=pruttxt\>/;

      if ($APPOn ne "yes") {
        $TOTALTEXT =~ s/\<p class\=pruttxt\>(\d+)\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;$StoryName\<\/p\>//;
        $TOTALTEXT =~ s/\<p class\=pruttxt\>(\d)\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;$StoryName\<\/p\>//;
      } else {
        $TOTALTEXT =~ s/\<p class\=pruttxt\>(\d)\&nbsp\;\&nbsp\;\&nbsp\;\&nbsp\;<\/NOBR>$StoryName\<\/p\>//;
      }
     
    
      if ($ISBN ne "") {
        $TOTALTEXT =~ s/\<BR\>\<\/B\>\<\/CENTER\>/\<BR\>\<BR\>ISBN\: $ISBN\<\/B\>\<\/CENTER\>/;
        if ($TOTALTEXT !~ "ISBN") {
          $TOTALTEXT =~ s/\<\/CENTER\>\<BR\>/\<BR\>\<BR\>ISBN\: $ISBN\<\/CENTER\>/;
        }
      }
  
      # finish with PDF, print to file
      if ($TRACING eq "ON") {
        print "Creating File $WriteFile...!\n" ;
      } else { print "."; }
      
      $FINALTEXT = $INITIALTEXT."\n".$TOTALTEXT."\n".$EXTRAINFO.$ENDTEXT."</body>\n</html>";
      # manage story title
      $FINALTEXT =~ s/<<<STORY TITLE CLEAN>>>/$StoryTitle/;   
      $FINALTEXT =~ s/<<<STORY TITLE>>>/$StoryName/;
      $FINALTEXT =~ s/<<<LANGUAGE_CODE>>>/$AppLangCode/g;
      $FINALTEXT =~ s/<<<LANGUAGE>>>/$CapLanguage/g;
      $FINALTEXT =~ s/<<<STORYKEY>>>/$AppTextKey/g;
      $FINALTEXT =~ s/<<<AUTHORSTORY>>>/$AppTextPath/g;
      $FINALTEXT =~ s/<<<STORYNAME>>>/$StoryFileName/g;
      $FINALTEXT =~ s/<<<AUDIOTOPAGEARRAY>>>/$AudioToPageArray/g;
      # fill out last audio file numbert
      $FINALTEXT =~ s/<<<LASTAUDIO>>>/$RealLastPageAudioCounter/;
      $FINALTEXT =~ s/<<<LASTPAGEAUDIOCOUNTER>>>/$RealLastPageAudioCounter/g;
      $FINALTEXT =~ s/<<<PAGEAUDIOCOUNTER>>>/0/g;
      $FINALTEXT =~ s/<<<NEXTPAGEAUDIOCOUNTER>>>/0/g;
      $FINALTEXT =~ s/<<<LASTNEXTPAGEAUDIOCOUNTER>>>/0/g;
      # manage image locations in App
      if ($APPOn eq "yes" && ( $MAINLANG eq "" || ( $MAINLANG eq $Language && $MAINSTORY ne "Free") || $HYPLERNKEYFILETEXT =~ "\_$AppTextPath\"" ) ) {
        $FINALTEXT =~ s/\.\.\\Main\\Pics/\.\.\/\.\.\/\.\.\/images/g;
        $FINALTEXT =~ s/Pics\\/images\//g;
        $FINALTEXT =~ s/<img SRC=\"images/<img class='book' SRC=\"images/g;
        #$FINALTEXT =~ s/ WIDTH=\"500\"/ width=\"100%\"/g;
        $FINALTEXT =~ s/ WIDTH=\"500\"//g;
        $FINALTEXT =~ s/\"class/\" class/g;
        $FINALTEXT =~ s/<<<STORYLANGUAGE>>>/$Language/g;

        $FINALPOP = $FINALTEXT;
        $FINALINT = $FINALTEXT;
        $FINALPNT = $FINALTEXT;
        foreach $Kokos ("pop","int","pnt") {
          if ($Kokos eq "pop") {
            # pop-up stuff
            $FINALPOP =~ s/\¶K/\"Show\(\'/g;
            $FINALPOP =~ s/\¶L/\'\,\'/g;
            $FINALPOP =~ s/\¶M/\)\" /g;
            $FINALPOP =~ s/\¶N/\'\)\" /g;
            $FINALPOP =~ s/\¶O/\(\'c/g;
            $FINALPOP =~ s/\'onmouseover/\' onmouseover/g;
            $FINALPOP =~ s/\'onmouseover/\' onmouseover/g;
            $FINALPOP =~ s/\'onmouseover/\' onmouseover/g;
            $FINALPOP =~ s/\'id\=/\' id\=/g;
            $FINALPOP =~ s/\'id\=/\' id\=/g;
            $FINALPOP =~ s/\'id\=/\' id\=/g;
            # try to add onclick for flash card purposes
            $FINALPOP =~ s/onmouseover\=\"Show\(\'(\w+)\'\,\'(\w+)\'\,(\d+)\,(\d+)\)\"/onclick\=\"Show\(\'$1\'\,\'$2\',$3\,$4\)\" onmouseover\=\"Show\(\'$1\'\,\'$2\',$3\,$4\)\"/g;
            # remove spaces behind carriage return if popmess last entry
            $FINALPOP =~ s/<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class='intmess'/<BR><span class='intmess'/ig;
            $FINALPOP =~ s/<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class='intmess'/<BR><span class='intmess'/ig;
            $FINALPOP =~ s/<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class='intmess'/<BR><span class='intmess'/ig;
            $FINALPOP =~ s/<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class='intmess'/<BR><span class='intmess'/ig;
            $FINALPOP =~ s/<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class='intmess'/<BR><span class='intmess'/ig;
            $FINALPOP =~ s/<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class='intmess'/<BR><span class='intmess'/ig;
            $FINALPOP =~ s/<BR>&nbsp;&nbsp;&nbsp;&nbsp;<span class='intmess'/<BR><span class='intmess'/ig;
            $FINALPOP =~ s/<BR>&nbsp;&nbsp;&nbsp;<span class='intmess'/<BR><span class='intmess'/ig;
            $FINALPOP =~ s/<BR>&nbsp;&nbsp;<span class='intmess'/<BR><span class='intmess'/ig;
            $FINALPOP =~ s/<BR>&nbsp;<span class='intmess'/<BR><span class='intmess'/ig;
            $FINALPOP =~ s/'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;/'>/g;
            $FINALPOP =~ s/'>&nbsp;&nbsp;&nbsp;&nbsp;/'>/g;
            $FINALPOP =~ s/'>&nbsp;&nbsp;&nbsp;/'>/g;
            $FINALPOP =~ s/'>&nbsp;&nbsp;/'>/g;
            $FINALPOP =~ s/'>&nbsp;/'>/g;
            $FINALPOP =~ s/<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;\(/<BR>\(/ig;
            $FINALPOP =~ s/<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;\(/<BR>\(/ig;
            $FINALPOP =~ s/<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;\(/<BR>\(/ig;
            $FINALPOP =~ s/<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;\(/<BR>\(/ig;
            $FINALPOP =~ s/<BR>&nbsp;&nbsp;&nbsp;&nbsp;\(/<BR>\(/ig;
            $FINALPOP =~ s/<BR>&nbsp;&nbsp;&nbsp;\(/<BR>\(/ig;
            $FINALPOP =~ s/<BR>&nbsp;&nbsp;\(/<BR>\(/ig;
            $FINALPOP =~ s/<BR>&nbsp;\(/<BR>\(/ig;
            $FINALPOP =~ s/<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;/<BR>/ig;
            $FINALPOP =~ s/<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;/<BR>/ig;
            $FINALPOP =~ s/<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;/<BR>/ig;
            $FINALPOP =~ s/<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;/<BR>/ig;
            $FINALPOP =~ s/<BR>&nbsp;&nbsp;&nbsp;&nbsp;/<BR>/ig;
            $FINALPOP =~ s/<BR>&nbsp;&nbsp;&nbsp;/<BR>/ig;
            $FINALPOP =~ s/<BR>&nbsp;&nbsp;/<BR>/ig;
            $FINALPOP =~ s/<BR>&nbsp;/<BR>/ig;
            $FINALPOP =~ s/&nbsp;&nbsp;&nbsp;<\/NOBR>/&nbsp;<\/NOBR>/ig;
            # css and filename
            $FINALPOP =~ s/\_int\.css/\.css/;
            $FINALPOP =~ s/<<<POPINT_CODE>>>/int/g;
            $FINALPOP =~ s/<<<CURPINT>>>/pop/g;
            foreach $Ananas ("all","man","aut") {
              $FINALPOPSPEC = $FINALPOP;
              $FINALPOPSPEC =~ s/<<<CURAUDIO>>>/$Ananas/g;
              $WriteFileSpec = $WriteFile;
              $WriteFileSpec =~ s/text\.htm/text\_pop\_$Ananas\.htm/;
              open (WRITEFILE, ">$WriteFileSpec") || die "file $WriteFileSpec kan niet worden aangemaakt, ($!)\n";
              print WRITEFILE $FINALPOPSPEC ;
              close (WRITEFILE);
            }
          }
      	  if ($Kokos eq "int") {
            $FINALINT =~ s/\¶K/\"Show\(\'/g;
            $FINALINT =~ s/\¶L/\'\,\'/g;
            $FINALINT =~ s/\¶M/\)\" /g;
      	    $FINALINT =~ s/onmouseout\=\"Hide\¶O(\d+)\_(\d+)\'\)\" //g;
      	    $FINALINT =~ s/onmouseout\=\"Hide\¶O(\d+)\_(\d+)\'\)\" //g;
      	    $FINALINT =~ s/onmouseout\=\"Hide\¶O(\d+)\_(\d+)\'\)\" //g;
      	    $FINALINT =~ s/onmouseout\=\"Hide\¶O(\d+)\_(\d+)\'\)\" //g;
      	    $FINALINT =~ s/onmouseout\=\"Hide\¶O(\d+)\_(\d+)\'\)\" //g;
      	    $FINALINT =~ s/onmouseout\=\"Hide\¶O(\d+)\_(\d+)\'\)\" //g;
      	    $FINALINT =~ s/onmouseout\=\"Hide\¶O(\d+)\_(\d+)\'\)\"//g;
      	    $FINALINT =~ s/onmouseout\=\"Hide\¶O(\d+)\_(\d+)\'\)\"//g;
      	    $FINALINT =~ s/onmouseout\=\"Hide\¶O(\d+)\_(\d+)\'\)\"//g;
      	    $FINALINT =~ s/onmouseout\=\"Hide\¶O(\d+)\_(\d+)\'\)\"//g;
      	    $FINALINT =~ s/onmouseout\=\"Hide\¶O(\d+)\_(\d+)\'\)\"//g;
      	    $FINALINT =~ s/onmouseout\=\"Hide\¶O(\d+)\_(\d+)\'\)\"//g;
      	    $FINALINT =~ s/onmouseout\=\"Hide\¶O(\d)\_(\d+)\'\)\" //g;
      	    $FINALINT =~ s/onmouseout\=\"Hide\¶O(\d)\_(\d+)\'\)\" //g;
      	    $FINALINT =~ s/onmouseout\=\"Hide\¶O(\d)\_(\d+)\'\)\" //g;
      	    $FINALINT =~ s/onmouseout\=\"Hide\¶O(\d)\_(\d+)\'\)\" //g;
      	    $FINALINT =~ s/onmouseout\=\"Hide\¶O(\d)\_(\d+)\'\)\" //g;
      	    $FINALINT =~ s/onmouseout\=\"Hide\¶O(\d)\_(\d+)\'\)\" //g;
      	    $FINALINT =~ s/onmouseout\=\"Hide\¶O(\d)\_(\d+)\'\)\"//g;
      	    $FINALINT =~ s/onmouseout\=\"Hide\¶O(\d)\_(\d+)\'\)\"//g;
      	    $FINALINT =~ s/onmouseout\=\"Hide\¶O(\d)\_(\d+)\'\)\"//g;
      	    $FINALINT =~ s/onmouseout\=\"Hide\¶O(\d)\_(\d+)\'\)\"//g;
      	    $FINALINT =~ s/onmouseout\=\"Hide\¶O(\d)\_(\d+)\'\)\"//g;
      	    $FINALINT =~ s/onmouseout\=\"Hide\¶O(\d)\_(\d+)\'\)\"//g;
      	    $FINALINT =~ s/onmouseout\=\"Hide\¶O(\d)\_(\d)\'\)\" //g;
      	    $FINALINT =~ s/onmouseout\=\"Hide\¶O(\d)\_(\d)\'\)\" //g;
      	    $FINALINT =~ s/onmouseout\=\"Hide\¶O(\d)\_(\d)\'\)\" //g;
      	    $FINALINT =~ s/onmouseout\=\"Hide\¶O(\d)\_(\d)\'\)\" //g;
      	    $FINALINT =~ s/onmouseout\=\"Hide\¶O(\d)\_(\d)\'\)\" //g;
      	    $FINALINT =~ s/onmouseout\=\"Hide\¶O(\d)\_(\d)\'\)\" //g;
      	    $FINALINT =~ s/onmouseout\=\"Hide\¶O(\d)\_(\d)\'\)\"//g;
      	    $FINALINT =~ s/onmouseout\=\"Hide\¶O(\d)\_(\d)\'\)\"//g;
      	    $FINALINT =~ s/onmouseout\=\"Hide\¶O(\d)\_(\d)\'\)\"//g;
      	    $FINALINT =~ s/onmouseout\=\"Hide\¶O(\d)\_(\d)\'\)\"//g;
      	    $FINALINT =~ s/onmouseout\=\"Hide\¶O(\d)\_(\d)\'\)\"//g;
      	    $FINALINT =~ s/onmouseout\=\"Hide\¶O(\d)\_(\d)\'\)\"//g;
      	    $FINALINT =~ s/class\=\'int\'id\=\'/class\=\'int\' id\=\'/g;
      	    # change all onmouseover into onclick
      	    $FINALINT =~ s/\'onmouseover/\' onclick/g;
      	    $FINALINT =~ s/\'onmouseover/\' onclick/g;
      	    $FINALINT =~ s/\'onmouseover/\' onclick/g;
      	    $FINALINT =~ s/\' onmouseover/\' onclick/g;
      	    $FINALINT =~ s/\' onmouseover/\' onclick/g;
      	    $FINALINT =~ s/\' onmouseover/\' onclick/g;
            $FINALINT =~ s/<<<POPINT_CODE>>>/pop/g;
            $FINALINT =~ s/<<<CURPINT>>>/int/g;
            foreach $Ananas ("all","man","aut") {
              $FINALINTSPEC = $FINALINT;
              $FINALINTSPEC =~ s/<<<CURAUDIO>>>/$Ananas/g;
              $WriteFileSpec = $WriteFile;
              $WriteFileSpec =~ s/text\.htm/text\_int\_$Ananas\.htm/;
              open (WRITEFILE, ">$WriteFileSpec") || die "file $WriteFileSpec kan niet worden aangemaakt, ($!)\n";
              print WRITEFILE $FINALINTSPEC ;
              close (WRITEFILE);
            }
          }
          # the following is for a combination of pop-up and interlinear
          # the interlinear text pops up when clicked? 
          if ($Kokos eq "pnt") {
            # pop-up stuff
            $FINALPNT =~ s/\¶K/\"Show\(\'/g;
            $FINALPNT =~ s/\¶L/\'\,\'/g;
            $FINALPNT =~ s/\¶M/\)\" /g;
      	    $FINALPNT =~ s/onmouseout\=\"Hide\¶O(\d+)\_(\d+)\'\)\" //g;
      	    $FINALPNT =~ s/onmouseout\=\"Hide\¶O(\d+)\_(\d+)\'\)\" //g;
      	    $FINALPNT =~ s/onmouseout\=\"Hide\¶O(\d+)\_(\d+)\'\)\" //g;
      	    $FINALPNT =~ s/onmouseout\=\"Hide\¶O(\d+)\_(\d+)\'\)\" //g;
      	    $FINALPNT =~ s/onmouseout\=\"Hide\¶O(\d+)\_(\d+)\'\)\" //g;
      	    $FINALPNT =~ s/onmouseout\=\"Hide\¶O(\d+)\_(\d+)\'\)\" //g;
      	    $FINALPNT =~ s/onmouseout\=\"Hide\¶O(\d+)\_(\d+)\'\)\"//g;
      	    $FINALPNT =~ s/onmouseout\=\"Hide\¶O(\d+)\_(\d+)\'\)\"//g;
      	    $FINALPNT =~ s/onmouseout\=\"Hide\¶O(\d+)\_(\d+)\'\)\"//g;
      	    $FINALPNT =~ s/onmouseout\=\"Hide\¶O(\d+)\_(\d+)\'\)\"//g;
      	    $FINALPNT =~ s/onmouseout\=\"Hide\¶O(\d+)\_(\d+)\'\)\"//g;
      	    $FINALPNT =~ s/onmouseout\=\"Hide\¶O(\d+)\_(\d+)\'\)\"//g;
      	    $FINALPNT =~ s/onmouseout\=\"Hide\¶O(\d)\_(\d+)\'\)\" //g;
      	    $FINALPNT =~ s/onmouseout\=\"Hide\¶O(\d)\_(\d+)\'\)\" //g;
      	    $FINALPNT =~ s/onmouseout\=\"Hide\¶O(\d)\_(\d+)\'\)\" //g;
      	    $FINALPNT =~ s/onmouseout\=\"Hide\¶O(\d)\_(\d+)\'\)\" //g;
      	    $FINALPNT =~ s/onmouseout\=\"Hide\¶O(\d)\_(\d+)\'\)\" //g;
      	    $FINALPNT =~ s/onmouseout\=\"Hide\¶O(\d)\_(\d+)\'\)\" //g;
      	    $FINALPNT =~ s/onmouseout\=\"Hide\¶O(\d)\_(\d+)\'\)\"//g;
      	    $FINALPNT =~ s/onmouseout\=\"Hide\¶O(\d)\_(\d+)\'\)\"//g;
      	    $FINALPNT =~ s/onmouseout\=\"Hide\¶O(\d)\_(\d+)\'\)\"//g;
      	    $FINALPNT =~ s/onmouseout\=\"Hide\¶O(\d)\_(\d+)\'\)\"//g;
      	    $FINALPNT =~ s/onmouseout\=\"Hide\¶O(\d)\_(\d+)\'\)\"//g;
      	    $FINALPNT =~ s/onmouseout\=\"Hide\¶O(\d)\_(\d+)\'\)\"//g;
      	    $FINALPNT =~ s/onmouseout\=\"Hide\¶O(\d)\_(\d)\'\)\" //g;
      	    $FINALPNT =~ s/onmouseout\=\"Hide\¶O(\d)\_(\d)\'\)\" //g;
      	    $FINALPNT =~ s/onmouseout\=\"Hide\¶O(\d)\_(\d)\'\)\" //g;
      	    $FINALPNT =~ s/onmouseout\=\"Hide\¶O(\d)\_(\d)\'\)\" //g;
      	    $FINALPNT =~ s/onmouseout\=\"Hide\¶O(\d)\_(\d)\'\)\" //g;
      	    $FINALPNT =~ s/onmouseout\=\"Hide\¶O(\d)\_(\d)\'\)\" //g;
      	    $FINALPNT =~ s/onmouseout\=\"Hide\¶O(\d)\_(\d)\'\)\"//g;
      	    $FINALPNT =~ s/onmouseout\=\"Hide\¶O(\d)\_(\d)\'\)\"//g;
      	    $FINALPNT =~ s/onmouseout\=\"Hide\¶O(\d)\_(\d)\'\)\"//g;
      	    $FINALPNT =~ s/onmouseout\=\"Hide\¶O(\d)\_(\d)\'\)\"//g;
      	    $FINALPNT =~ s/onmouseout\=\"Hide\¶O(\d)\_(\d)\'\)\"//g;
      	    $FINALPNT =~ s/onmouseout\=\"Hide\¶O(\d)\_(\d)\'\)\"//g;
      	    $FINALPNT =~ s/class\=\'int\'id\=\'/class\=\'int\' id\=\'/g;
      	    # change all onmouseover into onclick
      	    $FINALPNT =~ s/\'onmouseover\=\"Show\(\'(\w+)\'\,\'(\w+)\'\,(\d+)\,(\d+)\)\"/\' onclick\=\"Show\(\'$1\'\,\'$2\',$3\,$4\)\"/g;
      	    $FINALPNT =~ s/\'onmouseover\=\"Show\(\'(\w+)\'\,\'(\w+)\'\,(\d+)\,(\d+)\)\"/\' onclick\=\"Show\(\'$1\'\,\'$2\',$3\,$4\)\"/g;
      	    $FINALPNT =~ s/\'onmouseover\=\"Show\(\'(\w+)\'\,\'(\w+)\'\,(\d+)\,(\d+)\)\"/\' onclick\=\"Show\(\'$1\'\,\'$2\',$3\,$4\)\"/g;
      	    $FINALPNT =~ s/\' onmouseover\=\"Show\(\'(\w+)\'\,\'(\w+)\'\,(\d+)\,(\d+)\)\"/\' onclick\=\"Show\(\'$1\'\,\'$2\',$3\,$4\)\"/g;
      	    $FINALPNT =~ s/\' onmouseover\=\"Show\(\'(\w+)\'\,\'(\w+)\'\,(\d+)\,(\d+)\)\"/\' onclick\=\"Show\(\'$1\'\,\'$2\',$3\,$4\)\"/g;
      	    $FINALPNT =~ s/\' onmouseover\=\"Show\(\'(\w+)\'\,\'(\w+)\'\,(\d+)\,(\d+)\)\"/\' onclick\=\"Show\(\'$1\'\,\'$2\',$3\,$4\)\"/g;
      	    $FINALPNT =~ s/\'onmouseover/\' onclick/g;
      	    $FINALPNT =~ s/\'onmouseover/\' onclick/g;
      	    $FINALPNT =~ s/\'onmouseover/\' onclick/g;
      	    $FINALPNT =~ s/\' onmouseover/\' onclick/g;
      	    $FINALPNT =~ s/\' onmouseover/\' onclick/g;
      	    $FINALPNT =~ s/\' onmouseover/\' onclick/g;
            # css and filename
            $FINALPNT =~ s/\_int\.css/\_pnt\.css/;
            $FINALPNT =~ s/<<<POPINT_CODE>>>/pnt/g;
            $FINALPNT =~ s/<<<CURPINT>>>/pnt/g;
            # ouch this is not very clean programming
            # and it's getting worse, three identical files just to reflect audio setting persistence, sad... sad...
            foreach $Ananas ("all","man","aut") {
              $FINALPNTSPEC = $FINALPNT;
              $FINALPNTSPEC =~ s/<<<CURAUDIO>>>/$Ananas/g;
              $WriteFileSpec = $WriteFile;
              $WriteFileSpec =~ s/text\.htm/text\_pnt\_$Ananas\.htm/;
              open (WRITEFILE, ">$WriteFileSpec") || die "file $WriteFileSpec kan niet worden aangemaakt, ($!)\n";
              print WRITEFILE $FINALPNTSPEC ;
              close (WRITEFILE);
            }
          }
        }
      } else {
      	if ($PDFOn eq "yes" && $APPOn ne "yes") {
      	  if ($PRINTVERSION eq "yes" && $LOWQUALITY ne "yes") {
      	    $FINALTEXT =~ s/\.jpg/\_print\.jpg/g;
      	  }
          open (WRITEFILE, ">$WriteFile") || die "file $WriteFile kan niet worden aangemaakt, ($!)\n";
          print WRITEFILE $FINALTEXT ;
          close (WRITEFILE);
        }
      }
 
  
      # for App, now add this book link to all index files
      if ($APPOn eq "yes") {
        
        @IndexKeys = ("large_authr", "large_words", "detal_authr", "detal_words");
        
        foreach $IndexKey (@IndexKeys) {
  
          # create index file format name part
          $IndexKeyFileNamePart = "_".$IndexKey;
  
          # set sort key
          $SortedAppTextKey = "<words>_<author>_<story>";
          if ($IndexKey =~ "authr") {
            $SortedAppTextKey = "<author>_<story>";
          }

          $StoryWordsFormatted = $StoryWords;
          $lengthStoryWords = length($StoryWords);
          if ($lengthStoryWords == 1) { $StoryWordsFormatted = "0000".$StoryWords; }
          if ($lengthStoryWords == 2) { $StoryWordsFormatted = "000".$StoryWords; }
          if ($lengthStoryWords == 3) { $StoryWordsFormatted = "00".$StoryWords; }
          if ($lengthStoryWords == 4) { $StoryWordsFormatted = "0".$StoryWords; }
          $StoryWordsFormatted = $TEXTLEVEL.$StoryWordsFormatted;
          $SortedAppTextKey =~ s/\<author\>/$StoryAuthor/;
          $SortedAppTextKey =~ s/\<story\>/$StoryFileName/;
          $SortedAppTextKey =~ s/\<words\>/$StoryWordsFormatted/;
          $SortedAppTextKey =~ s/ /\-/g;
  
          # open index template to get the before and after parts
          open (READFILE, "..\\Base\\HTML\\App\\index_template.html") || die "file index_template.html cannot be found. ($!)\n";
          @INDEXTEXT = <READFILE>;
          $INDEXTEXT = "@INDEXTEXT";
          close (READFILE);
          
          # get the before and after of the index files
          ($INDEXPARTONE,$DUMMY,$DUMMYTOO,$INDEXPARTTWO) = split(/<STORYCODES>/,$INDEXTEXT);
  
          # open or init index file
          $IndexFile = "..\\Cordova\\AppProjects\\".$HypLernPath."\\".$HypLernPath."\\www\\texts\\$AppLangCode\\index".$IndexKeyFileNamePart.".html";
          if (-e $IndexFile) {
            open (READFILE, $IndexFile) || die "file $IndexFile cannot be found. ($!)\n";
            @INDEXTEXT = <READFILE>;
            $INDEXTEXT = "@INDEXTEXT";
            close (READFILE);
          } else {
            # we'll still have the $INDEXTEXT of the template to work with
          }
        
          # get all story codes
          ($DUMMY,$OWNSTORYCODES,$BUYSTORYCODES,$DUMMYTOO) = split(/<STORYCODES>/,$INDEXTEXT);
          @OWNSTORYCODES = split(/<STORYCODE>/,$OWNSTORYCODES);
          @BUYSTORYCODES = split(/<STORYCODE>/,$BUYSTORYCODES);
        
          if ($INDEXTEXT =~ "$AppTextKey\"" && $JUSTREDOGROUPCONTENT eq "ON") {
            if ($TRACING eq "ON") {
              print "OoooOOooOOoOoooooOOOooooOOH! De code $AppTextKey bestaat al in index".$IndexKeyFileNamePart.".html!\n";
            } else { print "."; }
          } else {
            if ($TRACING eq "ON") {
              print "Voeg code story link $AppTextKey toe aan index".$IndexKeyFileNamePart.".html!\n";
            } else { print "."; }

            # PICTURES
            # create picture name
            $PictureName = $StoryFileName;
            #$BaseFile = "..\\Base\\Media\\$Language\\$Group\\App\\".$PictureName."_large.jpg";
            $BaseFile = "..\\Base\\Media\\App\\Images\\".$PictureName."_large.jpg";
            $TargetFile = "..\\Cordova\\AppProjects\\".$HypLernPath."\\".$HypLernPath."\\www\\texts\\".$AppLangCode."\\".$AppTextPath."\\".$PictureName.".jpg";
            # if you add a library mode with large pics, carousel might be nice, and side swipe, in that case...
            $Output = `copy $BaseFile "$TargetFile" 2>&1`;
            if ($TRACING eq "ON") {
              print "Trying to copy $BaseFile to $TargetFile: $Output\n";
            } else { print "."; }
            # now the gray variant
            #$BaseFile = "..\\Base\\Media\\$Language\\$Group\\App\\".$PictureName."_gray.jpg";
            $BaseFile = "..\\Base\\Media\\App\\Images\\".$PictureName."_gray.jpg";
            $TargetFile = "..\\Cordova\\".AppProjects."\\".$HypLernPath."\\".$HypLernPath."\\www\\texts\\".$AppLangCode."\\".$AppTextPath."\\gray.jpg";
            $Output = `copy $BaseFile "$TargetFile" 2>&1`;
            if ($TRACING eq "ON") {
              print "Trying to copy $BaseFile to \"$TargetFile\": $Output\n";
            } else { print "."; }
            
            # remove anything with $AppTextKey if already there
            if ($INDEXTEXT =~ $AppTextKey) {
              @NEWOWNSTORYCODES = ();
              foreach $OWNSTORYCODE (@OWNSTORYCODES) {
                if ($OWNSTORYCODE !~ "$AppTextKey\"") {
               	  push (@NEWOWNSTORYCODES,$OWNSTORYCODE);
                } else {
                  if ($TRACING eq "ON") {
                    print "\n\n\nRemoved $OWNSTORYCODE\n\n\n";
                  } else { print "."; }
                }
              }
              @OWNSTORYCODES = @NEWOWNSTORYCODES;
              @NEWBUYSTORYCODES = ();
              foreach $BUYSTORYCODE (@BUYSTORYCODES) {
                if ($BUYSTORYCODE !~ "$AppTextKey\"") {
                  push (@NEWBUYSTORYCODES,$BUYSTORYCODE);
                } else {
                  if ($TRACING eq "ON") {
                    print "\n\n\nRemoved $BUYSTORYCODE\n\n\n";
                  } else { print "."; }
                }
              }
              @BUYSTORYCODES = @NEWBUYSTORYCODES;
            }
            # now add the new STORYCODE, if detail, don't use picture
            #print "\n\n\nPushing $SortedAppTextKey!\n\n\n";
            if ($IndexKey !~ "detal") {
              push (@OWNSTORYCODES,"\n<span class=\"$SortedAppTextKey link\" id=\"ownlink_$AppTextKey\" onclick=\"findText('$AppTextKey.htm');\"></span>");
              push (@BUYSTORYCODES,"\n<span class=\"$SortedAppTextKey link\" id=\"buylink_$AppTextKey\"><a href=\"".$PROVIDERSITE."\"><img class=\"library\" src=\"$AppTextPath/gray.jpg\" style=\"width: 160px;\"\/><\/a><\/span>");

            } else {
              push (@OWNSTORYCODES,"\n<span class=\"$SortedAppTextKey link\" id=\"ownlink_detail_$AppTextKey\" onclick=\"findText('$AppTextKey.htm');\"></span>");
              push (@BUYSTORYCODES,"\n<span class=\"$SortedAppTextKey link\" id=\"buylink_detail_$AppTextKey\"><FORM><FIELDSET class=\"link\" style=\"width: 90%; color: gray;\"><a class=\"link\" style=\"color: gray\" href=\"".$PROVIDERSITE."\"><span>".$StoryNiceAuthor."</span>,&nbsp;<span>".$StoryName."</span>,&nbsp;<span>level ".$TEXTLEVEL.", ".$StoryWords." words</span></a></FIELDSET></FORM></span>");
            }
  
            # and sort all codes according to this SortedAppTextKey
            # OWN
            @SORTEDOWNSTORYCODES = sort(@OWNSTORYCODES);
            @TWOTIMESSORTEDOWNSTORYCODES = sort(@SORTEDOWNSTORYCODES);
            sort(@TWOTIMESSORTEDOWNSTORYCODES);
            #print "Unsorted: @OWNSTORYCODES\n\n\n";
            #print "Sorted: @TWOTIMESSORTEDOWNSTORYCODES\n\n\n";
            $SORTEDOWNSTORYCODES = join("<STORYCODE>",@TWOTIMESSORTEDOWNSTORYCODES);
            $SORTEDOWNSTORYCODES =~ s/\n \n/\n/g;
            $SORTEDOWNSTORYCODES =~ s/\n\n/\n/g;
            $SORTEDOWNSTORYCODES =~ s/\n  \n/\n/g;
            $SORTEDOWNSTORYCODES =~ s/\n /\n/g;
            $SORTEDOWNSTORYCODES =~ s/ \n/\n/g;
            $SORTEDOWNSTORYCODES =~ s/ \<span /\<span /g;
            $SORTEDOWNSTORYCODES =~ s/ \<span /\<span /g;
            $SORTEDOWNSTORYCODES =~ s/ \<span /\<span /g;
            $SORTEDOWNSTORYCODES =~ s/ \<span /\<span /g;
            $SORTEDOWNSTORYCODES =~ s/ \<span /\<span /g;
            $SORTEDOWNSTORYCODES =~ s/ \<span /\<span /g;
            # BUY
            @SORTEDBUYSTORYCODES = sort(@BUYSTORYCODES);
            @TWOTIMESSORTEDBUYSTORYCODES = sort(@SORTEDBUYSTORYCODES);
            sort(@TWOTIMESSORTEDBUYSTORYCODES);
            #print "Unsorted: @BUYSTORYCODES\n\n\n";
            #print "Sorted: @TWOTIMESSORTEDBUYSTORYCODES\n\n\n";
            $SORTEDBUYSTORYCODES = join("<STORYCODE>",@TWOTIMESSORTEDBUYSTORYCODES);
            $SORTEDBUYSTORYCODES =~ s/\n \n/\n/g;
            $SORTEDBUYSTORYCODES =~ s/\n\n/\n/g;
            $SORTEDBUYSTORYCODES =~ s/\n  \n/\n/g;
            $SORTEDBUYSTORYCODES =~ s/\n /\n/g;
            $SORTEDBUYSTORYCODES =~ s/ \n/\n/g;
            $SORTEDBUYSTORYCODES =~ s/ \<span /\<span /g;
            $SORTEDBUYSTORYCODES =~ s/ \<span /\<span /g;
            $SORTEDBUYSTORYCODES =~ s/ \<span /\<span /g;
            $SORTEDBUYSTORYCODES =~ s/ \<span /\<span /g;
            $SORTEDBUYSTORYCODES =~ s/ \<span /\<span /g;
            $SORTEDBUYSTORYCODES =~ s/ \<span /\<span /g;
          }
                 
          if ($TRACING eq "ON") {
            print "Creating File ..\\Cordova\\AppProjects\\".$HypLernPath."\\".$HypLernPath."\\www\\$IndexFile...!\n" ;
          } else { print "."; }
          open (WRITEFILE, ">$IndexFile") || die "file $IndexFile kan niet worden aangemaakt, ($!)\n";
          $FINALTEXT = $INDEXPARTONE."<STORYCODES>".$SORTEDOWNSTORYCODES."<STORYCODES>".$SORTEDBUYSTORYCODES."<STORYCODES>".$INDEXPARTTWO;
          print WRITEFILE $FINALTEXT ;
          close (WRITEFILE);
        }
      }
    }
  }
  
  
  # Try and sort those App codes once and for all dammit
  if ($APPOn eq "yes") {
    
    # for both index files
    foreach $IndexKey (@IndexKeys) {
  
      # create index file format name part
      $IndexKeyFileNamePart = "_".$IndexKey;
      
      # open or init index file
      $IndexFile = "..\\Cordova\\AppProjects\\".$HypLernPath."\\".$HypLernPath."\\www\\texts\\$AppLangCode\\index".$IndexKeyFileNamePart.".html";
      open (READFILE, $IndexFile) || die "file $IndexFile cannot be found. ($!)\n";
      @INDEXTEXT = <READFILE>;
      $INDEXTEXT = "@INDEXTEXT";
      close (READFILE);

      # get all story codes
      ($DUMMY,$OWNSTORYCODES,$BUYSTORYCODES,$DUMMYTOO) = split(/<STORYCODES>/,$INDEXTEXT);
      @OWNSTORYCODES = split(/<STORYCODE>/,$OWNSTORYCODES);
      @BUYSTORYCODES = split(/<STORYCODE>/,$BUYSTORYCODES);
    
      # and sort all codes according to this SortedAppTextKey
      # OWN
      @SORTEDOWNSTORYCODES = sort(@OWNSTORYCODES);
      @TWOTIMESSORTEDOWNSTORYCODES = sort(@SORTEDOWNSTORYCODES);
      sort(@TWOTIMESSORTEDOWNSTORYCODES);
      #print "Unsorted: @STORYCODES\n\n\n";
      #print "Sorted: @SORTEDSTORYCODES\n\n\n";
      $SORTEDOWNSTORYCODES = join("<STORYCODE>",@TWOTIMESSORTEDOWNSTORYCODES);
      $SORTEDOWNSTORYCODES =~ s/\n \n/\n/g;
      $SORTEDOWNSTORYCODES =~ s/\n\n/\n/g;
      $SORTEDOWNSTORYCODES =~ s/\n  \n/\n/g;
      $SORTEDOWNSTORYCODES =~ s/\n /\n/g;
      $SORTEDOWNSTORYCODES =~ s/ \n/\n/g;
      $SORTEDOWNSTORYCODES =~ s/ \<span /\<span /g;
      $SORTEDOWNSTORYCODES =~ s/ \<span /\<span /g;
      $SORTEDOWNSTORYCODES =~ s/ \<span /\<span /g;
      $SORTEDOWNSTORYCODES =~ s/ \<span /\<span /g;
      $SORTEDOWNSTORYCODES =~ s/ \<span /\<span /g;
      $SORTEDOWNSTORYCODES =~ s/ \<span /\<span /g;
      # BUY
      @SORTEDBUYSTORYCODES = sort(@BUYSTORYCODES);
      @TWOTIMESSORTEDBUYSTORYCODES = sort(@SORTEDBUYSTORYCODES);
      sort(@TWOTIMESSORTEDBUYSTORYCODES);
      #print "Unsorted: @STORYCODES\n\n\n";
      #print "Sorted: @SORTEDSTORYCODES\n\n\n";
      $SORTEDBUYSTORYCODES = join("<STORYCODE>",@TWOTIMESSORTEDBUYSTORYCODES);
      $SORTEDBUYSTORYCODES =~ s/\n \n/\n/g;
      $SORTEDBUYSTORYCODES =~ s/\n\n/\n/g;
      $SORTEDBUYSTORYCODES =~ s/\n  \n/\n/g;
      $SORTEDBUYSTORYCODES =~ s/\n /\n/g;
      $SORTEDBUYSTORYCODES =~ s/ \n/\n/g;
      $SORTEDBUYSTORYCODES =~ s/ \<span /\<span /g;
      $SORTEDBUYSTORYCODES =~ s/ \<span /\<span /g;
      $SORTEDBUYSTORYCODES =~ s/ \<span /\<span /g;
      $SORTEDBUYSTORYCODES =~ s/ \<span /\<span /g;
      $SORTEDBUYSTORYCODES =~ s/ \<span /\<span /g;
      $SORTEDBUYSTORYCODES =~ s/ \<span /\<span /g;
    
            
      if ($TRACING eq "ON") {
        print "Creating File ..\\Cordova\\AppProjects\\".$HypLernPath."\\".$HypLernPath."\\www\\".$IndexFile."...!\n" ;
      } else { print "."; }
      open (WRITEFILE, ">$IndexFile") || die "file $IndexFile kan niet worden aangemaakt, ($!)\n";
      $FINALTEXT = $INDEXPARTONE."<STORYCODES>".$SORTEDOWNSTORYCODES."<STORYCODES>".$SORTEDBUYSTORYCODES."<STORYCODES>".$INDEXPARTTWO;
      $FINALTEXT =~ s/^   / /g;
      $FINALTEXT =~ s/^   / /g;
      $FINALTEXT =~ s/^   / /g;
      $FINALTEXT =~ s/<<<LANGUAGE>>>/$CapLanguage/;
      if ( $MAINLANG eq $Language || ( $MAINLANG eq "HypLern" && $Language eq "Hungarian") ) {
        $FINALTEXT =~ s/<<<BACKTARGET>>>/index/g;
        $FINALTEXT =~ s/<<<CURRENTINDEXBACKTARG>>>/\.\.\/\.\.\/wanderlust\.html/g;
      } else {
      	$FINALTEXT =~ s/<<<BACKTARGET>>>/wanderlust/g;
        $FINALTEXT =~ s/<<<CURRENTINDEXBACKTARG>>>/\.\.\/index\.html/g;
      }
      # one time set Sort to other than this code
      if ($IndexKeyFileNamePart =~ "large_authr") {
      	#$FINALTEXT =~ s/index_detail_words\.html/index_detail\.html/g; }
      	# THIS STUFF HAS TO BE SCRIPTED TO BE ABLE TO GO FROM LARGE TO DETAIL OR DETAIL_WORDS DEPENDING ON SETTING,
      	# AND FROM DETAIL OR DETAIL_WORDS TO LARGE OR LARGE WORDS, DEPENDING ON SETTING!!!
      	$FINALTEXT =~ s/index_large_authr/index_large_words/g;
      	$FINALTEXT =~ s/index_detal_words/index_detal_authr/g;
      	$FINALTEXT =~ s/<<<LEFTTAB>>>/white/g;
      	$FINALTEXT =~ s/<<<LEFTTABBORDER>>>/lightgray/g;
      	$FINALTEXT =~ s/<<<LEFTTABZINDEX>>>/21000/g;
      	$FINALTEXT =~ s/<<<RITETAB>>>/lightgray/g;
      	$FINALTEXT =~ s/<<<RITETABBORDER>>>/white/g;
      	$FINALTEXT =~ s/<<<RITETABZINDEX>>>/20000/g;
      	$FINALTEXT =~ s/<<<STORYFOLDERCLASS>>>/storyimgfolder/g;
      	
      }
      if ($IndexKeyFileNamePart =~ "detal_words") {
      	#$FINALTEXT =~ s/index_detail_words\.html/index_detail\.html/g; }
      	# THIS STUFF HAS TO BE SCRIPTED TO BE ABLE TO GO FROM LARGE TO DETAIL OR DETAIL_WORDS DEPENDING ON SETTING,
      	# AND FROM DETAIL OR DETAIL_WORDS TO LARGE OR LARGE WORDS, DEPENDING ON SETTING!!!
        $FINALTEXT =~ s/\<div style\=\"text\-align\: center\;\"\>/\<div\>/;
      	$FINALTEXT =~ s/index_large_authr/index_detal_authr/g;
      	$FINALTEXT =~ s/index_detal_words/index_large_words/g;
      	$FINALTEXT =~ s/<<<LEFTTAB>>>/lightgray/g;
      	$FINALTEXT =~ s/<<<LEFTTABBORDER>>>/white/g;
      	$FINALTEXT =~ s/<<<LEFTTABZINDEX>>>/20000/g;
      	$FINALTEXT =~ s/<<<RITETAB>>>/white/g;
      	$FINALTEXT =~ s/<<<RITETABBORDER>>>/lightgray/g;
      	$FINALTEXT =~ s/<<<RITETABZINDEX>>>/21000/g;
      	$FINALTEXT =~ s/<<<STORYFOLDERCLASS>>>/storytxtfolder/g;
      }
      if ($IndexKeyFileNamePart =~ "detal_authr") {
      	#$FINALTEXT =~ s/index_detail_words\.html/index_detail\.html/g; }
      	# THIS STUFF HAS TO BE SCRIPTED TO BE ABLE TO GO FROM LARGE TO DETAIL OR DETAIL_WORDS DEPENDING ON SETTING,
      	# AND FROM DETAIL OR DETAIL_WORDS TO LARGE OR LARGE WORDS, DEPENDING ON SETTING!!!
        $FINALTEXT =~ s/\<div style\=\"text\-align\: center\;\"\>/\<div\>/;
      	$FINALTEXT =~ s/index_detal_words/index_large_temps/g;
      	$FINALTEXT =~ s/index_large_authr/index_detal_words/g;
      	$FINALTEXT =~ s/index_large_temps/index_large_authr/g;
      	$FINALTEXT =~ s/<<<LEFTTAB>>>/white/g;
      	$FINALTEXT =~ s/<<<LEFTTABBORDER>>>/lightgray/g;
      	$FINALTEXT =~ s/<<<LEFTTABZINDEX>>>/21000/g;
      	$FINALTEXT =~ s/<<<RITETAB>>>/lightgray/g;
      	$FINALTEXT =~ s/<<<RITETABBORDER>>>/white/g;
      	$FINALTEXT =~ s/<<<RITETABZINDEX>>>/20000/g;
      	$FINALTEXT =~ s/<<<STORYFOLDERCLASS>>>/storytxtfolder/g;
      }
      # he en large_words dan?
      if ($IndexKeyFileNamePart =~ "large_words") {
      	$FINALTEXT =~ s/<<<LEFTTAB>>>/lightgray/g;
      	$FINALTEXT =~ s/<<<LEFTTABBORDER>>>/white/g;
      	$FINALTEXT =~ s/<<<LEFTTABZINDEX>>>/20000/g;
      	$FINALTEXT =~ s/<<<RITETAB>>>/white/g;
      	$FINALTEXT =~ s/<<<RITETABBORDER>>>/lightgray/g;
      	$FINALTEXT =~ s/<<<RITETABZINDEX>>>/21000/g;
      	$FINALTEXT =~ s/<<<STORYFOLDERCLASS>>>/storyimgfolder/g;
      }
      $CurIndexFileName = "index".$IndexKeyFileNamePart;
      $FINALTEXT =~ s/<<<CURRENTINDEXFILENAME>>>/$CurIndexFileName/;
      $FINALTEXT =~ s/<<<CURRENTINDEXLANGUAGE>>>/$AppLangCode/;
      print WRITEFILE $FINALTEXT ;
      close (WRITEFILE);
    }
  }
  
  # end if website is 'On', butt make sure no link on last page "<img SRC='../Pics/Nextsign.gif' align=right WIDTH='9' BORDER='0'>"
  if ($WebsiteOn eq "yes")
  {
    if ($OnlyWebIndex ne "yes") {
      #laatste copyslag (or rather don't)
      #`copy ..\\..\\Site\\Pics\\Nextsign.gif ..\\..\\Site\\$Language\\Pics`;
      #still need the book pictures!!!
      $EnglishBookPicture = $Language.$BookName."English.jpg";
      $DutchBookPicture = $Language.$BookName."Dutch.jpg";
      if ($TRACING eq "ON") {
        print "Copying $EnglishBookPicture and $DutchBookPicture...\n";
      } else { print "."; }
      `copy ..\\Base\\Media\\$Language\\$Group\\$EnglishBookPicture ..\\..\\Site\\$Language\\Pics`;
      `copy ..\\Base\\Media\\$Language\\$Group\\$DutchBookPicture ..\\..\\Site\\$Language\\Pics`;
      exit 0;
    } else {
      exit 0;
    }
  } 
  
  # MOST OF THE FOLLOWING IS FOR THE OLD SOFTWARE, EXCEPT FOR THE WORD COUNT STUFF
  if ($APPOn ne "yes" || $PDFOn ne "yes") {
  
    #create dummy page
    $WriteFile = "..\\..\\Languages\\$Language\\HTML\\$Group\\Course$filepart$NR.htm" ;
    if ($TRACING eq "ON") {
      print "Creating File $WriteFile...\n" ;
    } else { print ".";}
    open (WRITEFILE, ">$WriteFile") || die "file $WriteFile kan niet worden aangemaakt, ($!)\n";
    print WRITEFILE "   \n" ;
    close (WRITEFILE);
  
    $LASTDUMMYNR = $NR + 1;
    #create last dummy pages / dummy last pages
    $WriteFile = "..\\..\\Languages\\$Language\\HTML\\$Group\\Course$filepart$LASTDUMMYNR.htm" ;
    if ($TRACING eq "ON") {
      print "Creating File $WriteFile...\n" ;
    } else { print ".";}
    open (WRITEFILE, ">$WriteFile") || die "file $WriteFile kan niet worden aangemaakt, ($!)\n";
    print WRITEFILE "   \n" ;
    close (WRITEFILE);
  
    # CREATIE VAN START SCREEN
    $ReadFile = "../Base/HTML/Main/HTMLTemplate_Start.htm" ;
    open (READFILE, "$ReadFile") || die "file $ReadFile cannot be found. ($!)\n";
    @ALLTEXT = <READFILE>;
    close (READFILE);
    $ALLTEXT = join ("",@ALLTEXT) ;
  
    #choose text style
    $ALLTEXT =~ s/<<<CHARSET>>>/$CHARSET/;
    $ALLTEXT =~ s/<<<FONTFAMILY>>>/$FONTFAMILY/g;
    $ALLTEXT =~ s/<<<LANGUAGE>>>/$LA/g;
    $ALLTEXT =~ s/<<<BASEHTMLFILEPART>>>/$FILEBASE/g;
    $ALLTEXT =~ s/<<<MAINGROUP>>>/$MainGroup/g;
    $ALLTEXT =~ s/<<<GROUP>>>/$Group/g;
    $ALLTEXT =~ s/<<<LONGLANG>>>/$Language/g;
    if ($TranToLanguage eq "English") {
      $TitleUC = uc($Title);
      $ALLTEXT =~ s/<<<GROUPTL>>>/$TitleUC/g;
      $LanguageUC = uc($Language);
      $ALLTEXT =~ s/<<<LONGLANGTL>>>/$LanguageUC/g;
      $ALLTEXT =~ s/<<<LANGDOMAIN>>>/com/g;
    }
    if ($TranToLanguage eq "Dutch") {
      $TitleUC = uc($Title);
      $ALLTEXT =~ s/<<<GROUPTL>>>/$TitleUC/g;
      $ALLTEXT =~ s/<<<LONGLANGTL>>>/$CapLanguageDutchBVN/g;
      $ALLTEXT =~ s/<<<LANGDOMAIN>>>/nl/g;
    }
    if ($WebsiteOn ne "yes") {
      $ALLTEXT =~ s/<<<CUSTOMCODES>>>/$CustomCodesForStartingPage/g;
    }
    if ($TranToLanguage ne "English")
    {
      $ALLTEXT =~ s/<<<TRANLANGOTHERTHANENG>>>/$TranToLanguage/g;
    }
    else
    {
      $ALLTEXT =~ s/<<<TRANLANGOTHERTHANENG>>>//g;
    }
  
    #translate help, information and messaging
    $MessagingTranslationFile = "..\\Base\\Parse\\Main\\Messages.htm" ;
    open (MESSTRANS, "<$MessagingTranslationFile") || die "file $MessagingTranslationFile kan niet worden gevonden, ($!)\n";
    @MessTransEntries = <MESSTRANS>;
    close MESSTRANS;
    if ($TRACING eq "ON") {
      print "To internationalise information, help and other messaging, change all occurrences of:\n";
    } else { print "."; }
    foreach $MessTransEntry (@MessTransEntries)
    {
      @MessTransLine = split(/#/,$MessTransEntry);
      $MessGrep = $MessTransLine[0];
      $MessChange = $MessTransLine[$TLN];
      if ($ALLTEXT =~ $MessGrep)
      {
        $ALLTEXT =~ s/$MessGrep/$MessChange/g;
        if ($TRACING eq "ON") {
          print "$MessTransLine[0] to $MessTransLine[$TLN]\n";
        } else { print "."; }
      }
    }
  
    $WriteFile = "..\\..\\Languages\\".$Language."\\HTML\\".$Group."\\Course".$Language."Start.htm" ;
    if ($TRACING eq "ON") {
      print "Creating File $WriteFile...\n" ;
    } else { print "."; }
    open (WRITEFILE, ">$WriteFile") || die "file $WriteFile kan niet worden aangemaakt, ($!)\n";
    print WRITEFILE $ALLTEXT ;
    close (WRITEFILE);
  
  
    #Create Main page with framesets
    # CREATIE VAN GROUP MAIN TEXT (het Main Frame met text en top menu frame erin)
    $ReadFile = "../Base/HTML/Main/HTMLTemplate_GroupMain.htm" ;
    open (READFILE, "$ReadFile") || die "file $ReadFile cannot be found. ($!)\n";
    @ALLTEXT = <READFILE>;
    close (READFILE);
    $ALLTEXT = join ("",@ALLTEXT) ;
    
    #choose text style
    $ALLTEXT =~ s/<<<CHARSET>>>/$CHARSET/;
    $ALLTEXT =~ s/<<<FONTFAMILY>>>/$FONTFAMILY/g;
    $ALLTEXT =~ s/<<<LANGUAGE>>>/$LA/g;
    $ALLTEXT =~ s/<<<BASEHTMLFILEPART>>>/$FILEBASE/g;
    $ALLTEXT =~ s/<<<MAINGROUP>>>/$MainGroup/g;
    $ALLTEXT =~ s/<<<GROUP>>>/$Group/g;
    $ALLTEXT =~ s/<<<LONGLANG>>>/$Language/g;
    
    #translate help, information and messaging
    $MessagingTranslationFile = "..\\Base\\Parse\\Main\\Messages.htm" ;
    open (MESSTRANS, "<$MessagingTranslationFile") || die "file $MessagingTranslationFile kan niet worden gevonden, ($!)\n";
    @MessTransEntries = <MESSTRANS>;
    close MESSTRANS;
    if ($TRACING eq "ON") {
      print "To internationalise information, help and other messaging, change all occurrences of:\n";
    } else { print "."; }
    foreach $MessTransEntry (@MessTransEntries)
    {
      @MessTransLine = split(/#/,$MessTransEntry);
      $MessGrep = $MessTransLine[0];
      $MessChange = $MessTransLine[$TLN];
      if ($ALLTEXT =~ $MessGrep)
      {
        $ALLTEXT =~ s/$MessGrep/$MessChange/g;
        if ($TRACING eq "ON") {
          print "$MessTransLine[0] to $MessTransLine[$TLN]\n";
        } else { print "."; }
      }
    }
    
    $WriteFile = "..\\..\\Languages\\".$Language."\\HTML\\".$Group."\\Course".$filepart."Main.htm" ;
    if ($TRACING eq "ON") {
      print "Creating File $WriteFile...\n" ;
    } else { print "."; }
    open (WRITEFILE, ">$WriteFile") || die "file $WriteFile kan niet worden aangemaakt, ($!)\n";
    print WRITEFILE $ALLTEXT ;
    close (WRITEFILE);
  
  
    #Create MainOff page with framesets
    # CREATIE VAN GROUP MAIN OFF TEXT (het Main Frame met text en no menu frame erin)
    $ReadFile = "../Base/HTML/Main/HTMLTemplate_GroupMainOff.htm" ;
    open (READFILE, "$ReadFile") || die "file $ReadFile cannot be found. ($!)\n";
    @ALLTEXT = <READFILE>;
    close (READFILE);
    $ALLTEXT = join ("",@ALLTEXT) ;
    
    #choose text style
    $ALLTEXT =~ s/<<<CHARSET>>>/$CHARSET/;
    $ALLTEXT =~ s/<<<FONTFAMILY>>>/$FONTFAMILY/g;
    $ALLTEXT =~ s/<<<LANGUAGE>>>/$LA/g;
    $ALLTEXT =~ s/<<<BASEHTMLFILEPART>>>/$FILEBASE/g;
    $ALLTEXT =~ s/<<<MAINGROUP>>>/$MainGroup/g;
    $ALLTEXT =~ s/<<<GROUP>>>/$Group/g;
    $ALLTEXT =~ s/<<<LONGLANG>>>/$Language/g;
    
    #translate help, information and messaging
    $MessagingTranslationFile = "..\\Base\\Parse\\Main\\Messages.htm" ;
    open (MESSTRANS, "<$MessagingTranslationFile") || die "file $MessagingTranslationFile kan niet worden gevonden, ($!)\n";
    @MessTransEntries = <MESSTRANS>;
    close MESSTRANS;
    if ($TRACING eq "ON") {
      print "To internationalise information, help and other messaging, change all occurrences of:\n";
    } else { print "."; }
    foreach $MessTransEntry (@MessTransEntries)
    {
      @MessTransLine = split(/#/,$MessTransEntry);
      $MessGrep = $MessTransLine[0];
      $MessChange = $MessTransLine[$TLN];
      if ($ALLTEXT =~ $MessGrep)
      {
        $ALLTEXT =~ s/$MessGrep/$MessChange/g;
        if ($TRACING eq "ON") {
          print "$MessTransLine[0] to $MessTransLine[$TLN]\n";
        } else { print "."; }
      }
    }
    
    $WriteFile = "..\\..\\Languages\\".$Language."\\HTML\\".$Group."\\Course".$filepart."MainOff.htm" ;
    if ($TRACING eq "ON") {
      print "Creating File $WriteFile...\n" ;
    } else { print "."; }
    open (WRITEFILE, ">$WriteFile") || die "file $WriteFile kan niet worden aangemaakt, ($!)\n";
    print WRITEFILE $ALLTEXT ;
    close (WRITEFILE);
    
    
    # CREATE UBERFRAME
    $UberFrameBaseFile = "../Base/HTML/Main/HTMLTemplate_GroupMenu.htm" ;
    $ReadFile = $UberFrameBaseFile ;
    open (READFILE, "$ReadFile") || die "file $ReadFile cannot be found. ($!)\n";
    @ALLTEXT = <READFILE>;
    close (READFILE);
    $ALLTEXT = join ("",@ALLTEXT) ;
    
    #choose text style
    $ALLTEXT =~ s/<<<CHARSET>>>/$CHARSET/;
    $ALLTEXT =~ s/<<<FONTFAMILY>>>/$FONTFAMILY/g;
    $ALLTEXT =~ s/<<<LANGUAGE>>>/$LA/g;
    $ALLTEXT =~ s/<<<LONGLANG>>>/$Language/g;
    $ALLTEXT =~ s/<<<BASEHTMLFILEPART>>>/$FILEBASE/g;
    
    #vervang <<<PAGEOPTIONS>>> en <<<CHAPTEROPTIONS>>> door alle options
    $ALLTEXT =~ s/<<<PAGEOPTIONS>>>/$PAGEOPTIONS/;
    $ALLTEXT =~ s/<<<CHAPTEROPTIONS>>>/$CHAPTEROPTIONS/;
    
    #generate color map
    # define subs
    sub backwards { $b cmp $a; }
    
    # Create color template
    $Template = "<A class=C href='DUMMY' STYLE='background-color:#<R><G><B>' onclick=\"MM_jump<COLORMENUTYPE>Color('<R><G><B>')\">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</A>" ;
    
    for ($NR = 200; $NR < 256 ; $NR=$NR+11)
    {
       $HEXJE = sprintf("%lx",$NR) ;
       $HEXJE = uc $HEXJE ;
       $LENHEXJE = length $HEXJE ;
       if ($LENHEXJE eq 1)
       {
          $HEXJE = "0".$HEXJE ;
       }
       $Cols = $Cols.",".$HEXJE ;
    }
    $Cols = substr($Cols,1) ;
    
    @RCols = split(",",$Cols) ;
    @GCols = split(",",$Cols) ;
    @BCols = split(",",$Cols) ;
    
    foreach $CurGCol(@GCols)
    {
       $NR = 0 ;
       foreach $CurBCol(@BCols)
       {
          foreach $CurRCol(@RCols)
          {
             $FilledTemplate = $Template ;
             $FilledTemplate =~ s/<R>/$CurRCol/g ;
             $FilledTemplate =~ s/<G>/$CurGCol/g ; 
             $FilledTemplate =~ s/<B>/$CurBCol/g ;
             $CodeTLParseLine = "CFG§TL$CurRCol$CurGCol$CurBCol§<<<TOOLCOLOR>>>§$CurRCol$CurGCol$CurBCol§NO\nCFG§TL$CurRCol$CurGCol$CurBCol§<<<COLORSCHEMETL>>>§none.jpg§NO\n";
             $CodeBGParseLine = "CFG§BC$CurRCol$CurGCol$CurBCol§<<<BACKCOLOR>>>§$CurRCol$CurGCol$CurBCol§NO\nCFG§BC$CurRCol$CurGCol$CurBCol§<<<COLORSCHEMEBG>>>§none.jpg§NO\n";
             $CodeTXParseLine = "CFG§TX$CurRCol$CurGCol$CurBCol§<<<FONTCOLOR>>>§$CurRCol$CurGCol$CurBCol§NO\n";
             $TotalParseTLCode = $TotalParseTLCode.$CodeTLParseLine;
             $TotalParseBGCode = $TotalParseBGCode.$CodeBGParseLine;
             $TotalParseTXCode = $TotalParseTXCode.$CodeTXParseLine;
             if ($NR > 2)
             {
                $ContentTwo = $FilledTemplate.$ContentTwo ;
             }
             else
             {
                $Content = $Content.$FilledTemplate ;
             }
          }
          if ($Direction eq "forward")
          {
             @RCols=sort @RCols;
             $Direction = "backward";
          }
          else
          {
             @RCols=sort backwards @RCols;
             $Direction = "forward";
          }
                   $NR = $NR + 1 ;
       }
       $ContentTwo = "<BR>".$ContentTwo;
       $Content = $Content."<BR>";
    }
    $ContentTwo = substr($ContentTwo,4) ;
    $Content = $Content.$ContentTwo."<BR>" ;
    
    #vervang color options
    $TEXTCOLORMAP = $Content;
    $COLORMAP = $Content;
    $TEXTCOLORMAP =~ s/<TYPE>/TX/g;
    $PAGECOLORMAP = $COLORMAP;
    $TOOLCOLORMAP = $COLORMAP;
    $PAGECOLORMAP =~ s/<TYPE>/BC/g;
    $TOOLCOLORMAP =~ s/<TYPE>/TL/g;
    $CX = "71"; 
    $CY = "-35";
    
    #voeg de overige backgrounds toe aan de backcolormap:
    $COLORMENU = "<TABLE BORDER='1' WIDTH='120' HEIGHT='80' BACKGROUND='..\\Media\\<<<TOOLBACKGROUNDPICTURE>>>' BGCOLOR='<<<TOOLBACKGROUNDCOLOR>>>'>";
    $COLORMENU = $COLORMENU."<TR><TD COLSPAN='5' WIDTH='120' HEIGHT='10' onclick=\"ShowMenu('sub_toolcolormap','sub_backcolormap','$CX','$CY')\"></TD></TR>";
    $COLORMENU = $COLORMENU."<TR HEIGHT='65' ALIGN='center'>";
    $COLORMENU = $COLORMENU."<TD WIDTH='8' onclick=\"ShowMenu('sub_toolcolormap','sub_backcolormap','$CX','$CY')\"></TD>";
    $COLORMENU = $COLORMENU."<TD BACKGROUND='..\\Media\\<<<COLORSCHEMEBG>>>' BGCOLOR='<<<BACKCOLOR>>>' WIDTH='50' onclick=\"ShowMenu('sub_toolcolormap','sub_pagecolormap','$CX','$CY')\">";
    $COLORMENU = $COLORMENU."<A STYLE='color:#<<<FONTCOLOR>>>; FONT-SIZE: 6pt;' onclick=\"ShowMenu('sub_toolcolormap','sub_textcolormap','$CX','$CY'); Hide('sub_pagecolormap');\">Text<BR>Text<BR>Text</A></TD>";
    $COLORMENU = $COLORMENU."<TD WIDTH='4' onclick=\"ShowMenu('sub_toolcolormap','sub_backcolormap','$CX','$CY')\"></TD>";
    $COLORMENU = $COLORMENU."<TD BACKGROUND='..\\Media\\<<<COLORSCHEMEBG>>>' BGCOLOR='<<<BACKCOLOR>>>' WIDTH='50' onclick=\"ShowMenu('sub_toolcolormap','sub_pagecolormap','$CX','$CY')\">";
    $COLORMENU = $COLORMENU."<A STYLE='color:#<<<FONTCOLOR>>>; FONT-SIZE: 6pt;' onclick=\"ShowMenu('sub_toolcolormap','sub_textcolormap','$CX','$CY'); Hide('sub_pagecolormap');\">Text<BR>Text<BR>Text</A></TD>";
    $COLORMENU = $COLORMENU."<TD WIDTH='8' onclick=\"ShowMenu('sub_toolcolormap','sub_backcolormap','$CX','$CY')\"></TD></TR>";
    $COLORMENU = $COLORMENU."<TR HEIGHT='5'><TD COLSPAN='5' WIDTH='120' onclick=\"ShowMenu('sub_toolcolormap','sub_backcolormap','$CX','$CY')\"></TD></TR></TABLE><A onclick=\"Hide('sub_toolcolormap')\" STYLE='BACKGROUND-COLOR: WHITE; COLOR: BLACK; FONT-SIZE: 12pt;'><B>CANCEL</B></A>";
    
    $TOOLCOLORMAP = $TOOLCOLORMAP."<A href='DUMMY' onClick=\"MM_jumpToolColorPic('TOOLCOLORCODECRUMP')\"><img SRC='..\\Media\\crump.JPG' WIDTH='64' HEIGHT='64' alt='Crumpled Paper' BORDER='1'></A>";
    $TOOLCOLORMAP = $TOOLCOLORMAP."<A href='DUMMY' onClick=\"MM_jumpToolColorPic('TOOLCOLORCODEWHITE')\"><img SRC='..\\Media\\white.JPG' WIDTH='64' HEIGHT='64' alt='White Background' BORDER='1'></A>";
    $TOOLCOLORMAP = $TOOLCOLORMAP."<A href='DUMMY' onClick=\"MM_jumpToolColorPic('TOOLCOLORCODEBLACK')\"><img SRC='..\\Media\\black.JPG' WIDTH='64' HEIGHT='64' alt='Black Background' BORDER='1'></A>";
    $TOOLCOLORMAP = $TOOLCOLORMAP."<A href='DUMMY' onClick=\"MM_jumpToolColorPic('TOOLCOLORCODEOLD')\"><img SRC='..\\Media\\old.jpg' WIDTH='64' HEIGHT='64' alt='Parchment' BORDER='1'></A><BR>";
    $TOOLCOLORMAP = $TOOLCOLORMAP."<A href='DUMMY' onClick=\"MM_jumpToolColorPic('TOOLCOLORCODEFADEGREEN')\"><img SRC='..\\Media\\fadegreen.bmp' WIDTH='64' HEIGHT='64' alt='Fading Green' BORDER='1'></A>";
    $TOOLCOLORMAP = $TOOLCOLORMAP."<A href='DUMMY' onClick=\"MM_jumpToolColorPic('TOOLCOLORCODEFADERED')\"><img SRC='..\\Media\\fadered.bmp' WIDTH='64' HEIGHT='64' alt='Fading Red' BORDER='1'></A>";
    $TOOLCOLORMAP = $TOOLCOLORMAP."<A href='DUMMY' onClick=\"MM_jumpToolColorPic('TOOLCOLORCODEFADEGRAY')\"><img SRC='..\\Media\\fadegray.bmp' WIDTH='64' HEIGHT='64' alt='Fading Gray' BORDER='1'></A>";
    $TOOLCOLORMAP = $TOOLCOLORMAP."<A href='DUMMY' onClick=\"MM_jumpToolColorPic('TOOLCOLORCODEFADEBLUE')\"><img SRC='..\\Media\\fadeblue.bmp' WIDTH='64' HEIGHT='64' alt='Fading Blue' BORDER='1'></A><BR>";
    $TOOLCOLORMAP = $TOOLCOLORMAP."<A href='DUMMY' onClick=\"MM_jumpToolColorPic('TOOLCOLORCODECAMOGREEN')\"><img SRC='..\\Media\\camogreen.JPG' WIDTH='64' HEIGHT='64' alt='Camouflage Green' BORDER='1'></A>";
    $TOOLCOLORMAP = $TOOLCOLORMAP."<A href='DUMMY' onClick=\"MM_jumpToolColorPic('TOOLCOLORCODECAMOPINK')\"><img SRC='..\\Media\\camopink.JPG' WIDTH='64' HEIGHT='64' alt='Camouflage Red' BORDER='1'></A>";
    $TOOLCOLORMAP = $TOOLCOLORMAP."<A href='DUMMY' onClick=\"MM_jumpToolColorPic('TOOLCOLORCODECAMOGRAY')\"><img SRC='..\\Media\\camogray.JPG' WIDTH='64' HEIGHT='64' alt='Camouflage Grey' BORDER='1'></A>";
    $TOOLCOLORMAP = $TOOLCOLORMAP."<A href='DUMMY' onClick=\"MM_jumpToolColorPic('TOOLCOLORCODECAMOBLUE')\"><img SRC='..\\Media\\camoblue.JPG' WIDTH='64' HEIGHT='64' alt='Camouflage Blue' BORDER='1'></A><BR>";
    $TOOLCOLORMAP = $TOOLCOLORMAP."<A href='DUMMY' onClick=\"MM_jumpToolColorPic('TOOLCOLORCODETRANSPARENT')\"><img SRC='..\\Media\\transparent.GIF' WIDTH='64' HEIGHT='64' alt='Transparent' BORDER='1'></A>";
    #$TOOLCOLORMAP = $TOOLCOLORMAP."<A href='DUMMY' onClick=\"MM_jumpToolColorPic('TOOLCOLORCODEVAGUE')\"><img SRC='..\\Media\\vague.GIF' WIDTH='64' HEIGHT='64' alt='Vague' BORDER='1'></A>";
    #$TOOLCOLORMAP = $TOOLCOLORMAP."<A href='DUMMY' onClick=\"MM_jumpToolColorPic('TOOLCOLORCODENEWBOOK')\"><img SRC='..\\Media\\NewBook.jpg' WIDTH='64' HEIGHT='64' alt='New Book' BORDER='1'></A>";
    #$TOOLCOLORMAP = $TOOLCOLORMAP."<A href='DUMMY' onClick=\"MM_jumpToolColorPic('TOOLCOLORCODEOLDBOOK')\"><img SRC='..\\Media\\OldBook.jpg' WIDTH='64' HEIGHT='64' alt='Old Book' BORDER='1'></A><BR>";
    #$TOOLCOLORMAP = $TOOLCOLORMAP."<A href='DUMMY' onClick=\"MM_jumpToolColorPic('TOOLCOLORCODECUSTOM1')\"><img SRC='..\\Media\\custom1.jpg' WIDTH='64' HEIGHT='64' alt='Custom 1' BORDER='1'></A>";
    $TOOLCOLORMAP = $TOOLCOLORMAP."<A href='DUMMY' onClick=\"MM_jumpToolColorPic('TOOLCOLORCODECUSTOM2')\"><img SRC='..\\Media\\custom2.jpg' WIDTH='64' HEIGHT='64' alt='Custom 2' BORDER='1'></A>";
    $TOOLCOLORMAP = $TOOLCOLORMAP."<A href='DUMMY' onClick=\"MM_jumpToolColorPic('TOOLCOLORCODECUSTOM3')\"><img SRC='..\\Media\\custom3.jpg' WIDTH='64' HEIGHT='64' alt='Custom 3' BORDER='1'></A>";
    $TOOLCOLORMAP = $TOOLCOLORMAP."<A href='DUMMY' onClick=\"MM_jumpToolColorPic('TOOLCOLORCODECUSTOM4')\"><img SRC='..\\Media\\custom4.jpg' WIDTH='64' HEIGHT='64' alt='Custom 4' BORDER='1'></A><BR>";
    $TOOLCOLORMAP = $TOOLCOLORMAP."<A onclick=\"Hide('sub_toolcolormap'); Hide('sub_backcolormap');\" STYLE='BACKGROUND-COLOR: WHITE; COLOR: BLACK; FONT-SIZE: 12pt;'><B>CANCEL</B></A>";;
    
    $PAGECOLORMAP = $PAGECOLORMAP."<A href='DUMMY' onClick=\"MM_jumpPageColorPic('PAGECOLORCODECRUMP')\"><img SRC='..\\Media\\crump.JPG' WIDTH='64' HEIGHT='64' alt='Crumpled Paper' BORDER='0'></A>";
    $PAGECOLORMAP = $PAGECOLORMAP."<A href='DUMMY' onClick=\"MM_jumpPageColorPic('PAGECOLORCODEWHITE')\"><img SRC='..\\Media\\white.JPG' WIDTH='64' HEIGHT='64' alt='White Background' BORDER='0'></A>";
    $PAGECOLORMAP = $PAGECOLORMAP."<A href='DUMMY' onClick=\"MM_jumpPageColorPic('PAGECOLORCODEBLACK')\"><img SRC='..\\Media\\black.JPG' WIDTH='64' HEIGHT='64' alt='Black Background' BORDER='0'></A>";
    $PAGECOLORMAP = $PAGECOLORMAP."<A href='DUMMY' onClick=\"MM_jumpPageColorPic('PAGECOLORCODEOLD')\"><img SRC='..\\Media\\old.jpg' WIDTH='64' HEIGHT='64' alt='Parchment' BORDER='0'></A><BR>";
    $PAGECOLORMAP = $PAGECOLORMAP."<A href='DUMMY' onClick=\"MM_jumpPageColorPic('PAGECOLORCODEFADEGREEN')\"><img SRC='..\\Media\\fadegreen.bmp' WIDTH='64' HEIGHT='64' alt='Fading Green' BORDER='0'></A>";
    $PAGECOLORMAP = $PAGECOLORMAP."<A href='DUMMY' onClick=\"MM_jumpPageColorPic('PAGECOLORCODEFADERED')\"><img SRC='..\\Media\\fadered.bmp' WIDTH='64' HEIGHT='64' alt='Fading Red' BORDER='0'></A>";
    $PAGECOLORMAP = $PAGECOLORMAP."<A href='DUMMY' onClick=\"MM_jumpPageColorPic('PAGECOLORCODEFADEGRAY')\"><img SRC='..\\Media\\fadegray.bmp' WIDTH='64' HEIGHT='64' alt='Fading Gray' BORDER='0'></A>";
    $PAGECOLORMAP = $PAGECOLORMAP."<A href='DUMMY' onClick=\"MM_jumpPageColorPic('PAGECOLORCODEFADEBLUE')\"><img SRC='..\\Media\\fadeblue.bmp' WIDTH='64' HEIGHT='64' alt='Fading Blue' BORDER='0'></A><BR>";
    $PAGECOLORMAP = $PAGECOLORMAP."<A href='DUMMY' onClick=\"MM_jumpPageColorPic('PAGECOLORCODECAMOGREEN')\"><img SRC='..\\Media\\camogreen.JPG' WIDTH='64' HEIGHT='64' alt='Camouflage Green' BORDER='0'></A>";
    $PAGECOLORMAP = $PAGECOLORMAP."<A href='DUMMY' onClick=\"MM_jumpPageColorPic('PAGECOLORCODECAMOPINK')\"><img SRC='..\\Media\\camopink.JPG' WIDTH='64' HEIGHT='64' alt='Camouflage Red' BORDER='0'></A>";
    $PAGECOLORMAP = $PAGECOLORMAP."<A href='DUMMY' onClick=\"MM_jumpPageColorPic('PAGECOLORCODECAMOGRAY')\"><img SRC='..\\Media\\camogray.JPG' WIDTH='64' HEIGHT='64' alt='Camouflage Grey' BORDER='0'></A>";
    $PAGECOLORMAP = $PAGECOLORMAP."<A href='DUMMY' onClick=\"MM_jumpPageColorPic('PAGECOLORCODECAMOBLUE')\"><img SRC='..\\Media\\camoblue.JPG' WIDTH='64' HEIGHT='64' alt='Camouflage Blue' BORDER='0'></A><BR>";
    $PAGECOLORMAP = $PAGECOLORMAP."<A href='DUMMY' onClick=\"MM_jumpPageColorPic('PAGECOLORCODETRANSPARENT')\"><img SRC='..\\Media\\transparent.GIF' WIDTH='256' HEIGHT='64' alt='Transparent' BORDER='0'><B><CENTER>Transparent</CENTER></B></A>";
    #$PAGECOLORMAP = $PAGECOLORMAP."<A href='DUMMY' onClick=\"MM_jumpPageColorPic('PAGECOLORCODETRANSPARENT')\"><img SRC='..\\Media\\vague.GIF' WIDTH='64' HEIGHT='64' alt='Vague' BORDER='0'></A>";
    #$PAGECOLORMAP = $PAGECOLORMAP."<A href='DUMMY' onClick=\"MM_jumpPageColorPic('PAGECOLORCODETRANSPARENT')\"><img SRC='..\\Media\\NewBook.jpg' WIDTH='64' HEIGHT='64' alt='New Book' BORDER='0'></A>";
    #$PAGECOLORMAP = $PAGECOLORMAP."<A href='DUMMY' onClick=\"MM_jumpPageColorPic('PAGECOLORCODETRANSPARENT')\"><img SRC='..\\Media\\OldBook.jpg' WIDTH='64' HEIGHT='64' alt='Old Book' BORDER='0'></A><BR>";
    #$PAGECOLORMAP = $PAGECOLORMAP."<A href='DUMMY' onClick=\"MM_jumpPageColorPic('PAGECOLORCODETRANSPARENT')\"><img SRC='..\\Media\\custom1.jpg' WIDTH='64' HEIGHT='64' alt='Custom 1' BORDER='0'></A>";
    #$PAGECOLORMAP = $PAGECOLORMAP."<A href='DUMMY' onClick=\"MM_jumpPageColorPic('PAGECOLORCODETRANSPARENT')\"><img SRC='..\\Media\\custom2.jpg' WIDTH='64' HEIGHT='64' alt='Custom 2' BORDER='0'></A>";
    #$PAGECOLORMAP = $PAGECOLORMAP."<A href='DUMMY' onClick=\"MM_jumpPageColorPic('PAGECOLORCODETRANSPARENT')\"><img SRC='..\\Media\\custom3.jpg' WIDTH='64' HEIGHT='64' alt='Custom 3' BORDER='0'></A>";
    #$PAGECOLORMAP = $PAGECOLORMAP."<A href='DUMMY' onClick=\"MM_jumpPageColorPic('PAGECOLORCODETRANSPARENT')\"><img SRC='..\\Media\\custom4.jpg' WIDTH='64' HEIGHT='64' alt='Custom 4' BORDER='0'></A><BR>";
    $PAGECOLORMAP = $PAGECOLORMAP."<A onclick=\"Hide('sub_toolcolormap'); Hide('sub_pagecolormap');\" STYLE='BACKGROUND-COLOR: WHITE; COLOR: BLACK; FONT-SIZE: 12pt;'><B>CANCEL</B></A>";
    
    $TEXTCOLORMAP =~ s/<COLORMENUTYPE>/Text/g;
    $TEXTCOLORMAP = $TEXTCOLORMAP."<A onclick=\"Hide('sub_toolcolormap'); Hide('sub_textcolormap');\" STYLE='BACKGROUND-COLOR: WHITE; COLOR: BLACK; FONT-SIZE: 12pt;'><B>CANCEL</B></A>";
    $TOOLCOLORMAP =~ s/<COLORMENUTYPE>/Tool/g;
    $TOOLCOLORMAP =~ s/<<<BACKCOLOR>>>/<<<TOOLCOLOR>>>/g;
    $PAGECOLORMAP =~ s/<COLORMENUTYPE>/Page/g;
    
    #vervang textcolor en backcolor templates door de colormaps:
    $ALLTEXT =~ s/<<<COLORMENU>>>/$COLORMENU/;
    $ALLTEXT =~ s/<<<TEXTCOLORMAP>>>/$TEXTCOLORMAP/;
    $ALLTEXT =~ s/<<<TOOLCOLORMAP>>>/$TOOLCOLORMAP/;
    $ALLTEXT =~ s/<<<PAGECOLORMAP>>>/$PAGECOLORMAP/;
    
    #vervang title
    $ALLTEXT =~ s/<<<TITLEORG>>>/$TitleOrg/g;
    $ALLTEXT =~ s/<<<TITLETRANS>>>/$Title/g;
    
    $WriteFile = "..\\..\\Languages\\$Language\\HTML\\$Group\\Course".$filepart."Menu.htm" ;
    if ($TRACING eq "ON") {
      print "Creating File $WriteFile...\n" ;
    } else { print "."; }
    open (WRITEFILE, ">$WriteFile") || die "file $WriteFile kan niet worden aangemaakt, ($!)\n";
    print WRITEFILE $ALLTEXT ;
    close (WRITEFILE);



    # ADD PARSING, JAVA AND STYLE FILES TO PATH
    `copy ..\\Base\\Java\\Main\\*.htm ..\\..\\Languages\\$Language\\HTML\\Main` ;
    `copy ..\\Base\\Parse\\Main\\Parse.htm ..\\..\\Languages\\$Language\\HTML\\Main` ;
    `copy ..\\Base\\Style\\Main\\*.htm ..\\..\\Languages\\$Language\\HTML\\Main` ;
    `copy ..\\Base\\Config\\HypLernTest.htm ..\\..\\Languages\\$Language\\HTML\\Main` ;
    
    # PARSE PARSING AND JAVA FILES
    # REMOVE DEBUG FROM JAVA HERE AS WELL!!!!! AND TEST!!!
    $JavaBaseFile = "../../Languages/$Language/HTML/Main/JavaMap.htm" ;
    $ReadFile = $JavaBaseFile ;
    open (READFILE, "$ReadFile") || die "file $ReadFile cannot be found. ($!)\n";
    @ALLTEXT = <READFILE>;
    close (READFILE);
    $ALLTEXT = join ("",@ALLTEXT) ;
    #choose text style
    $ALLTEXT =~ s/<<<LANGUAGE>>>/$LA/g;
    $ALLTEXT =~ s/<<<BASEHTMLFILEPART>>>/$FILEBASE/g;
    $ALLTEXT =~ s/<<<LONGLANG>>>/$Language/g;
    if ($TranToLanguage ne "English")
    {
      $ALLTEXT =~ s/<<<TRANLANGOTHERTHANENG>>>/$TranToLanguage/g;
    }
    else
    {
      $ALLTEXT =~ s/<<<TRANLANGOTHERTHANENG>>>//g;
    }
    #vervang <<<PAGEOPTIONS>>> en <<<CHAPTEROPTIONS>>> door alle options
    $ALLTEXT =~ s/<<<PAGEOPTIONS>>>/$PAGEOPTIONS/;
    $ALLTEXT =~ s/<<<CHAPTEROPTIONS>>>/$CHAPTEROPTIONS/;
    #vervang title
    $ALLTEXT =~ s/<<<TITLEORG>>>/$TitleOrg/g;
    $ALLTEXT =~ s/<<<TITLETRANS>>>/$Title/g;
    #translate help, information and messaging
    foreach $MessTransEntry (@MessTransEntries)
    {
      @MessTransLine = split(/#/,$MessTransEntry);
      $MessGrep = $MessTransLine[0];
      $MessChange = $MessTransLine[$TLN];
      if ($ALLTEXT =~ $MessGrep)
      {
        $ALLTEXT =~ s/$MessGrep/$MessChange/g;
        if ($TRACING eq "ON") {
          print "$MessTransLine[0] to $MessTransLine[$TLN]\n";
        } else { print "."; }
      }
    }
    $WriteFile = "..\\..\\Languages\\$Language\\HTML\\Main\\JavaMap.htm" ;
    if ($TRACING eq "ON") {
      print "Creating File $WriteFile...\n" ;
    } else { print "."; }
    open (WRITEFILE, ">$WriteFile") || die "file $WriteFile kan niet worden aangemaakt, ($!)\n";
    print WRITEFILE $ALLTEXT ;
    close (WRITEFILE);
    
    
    $ParseBaseFile = "../../Languages/$Language/HTML/Main/Parse.htm" ;
    $ReadFile = $ParseBaseFile ;
    open (READFILE, "$ReadFile") || die "file $ReadFile cannot be found. ($!)\n";
    @ALLTEXT = <READFILE>;
    close (READFILE);
    $ALLTEXT = join ("",@ALLTEXT) ;
    
    #choose text style
    $ALLTEXT =~ s/<<<BASEHTMLFILEPART>>>/$FILEBASE/g;
    if ($TranToLanguage ne "English")
    {
      $ALLTEXT =~ s/<<<TRANLANGOTHERTHANENG>>>/$TranToLanguage/g;
    }
    else
    {
      $ALLTEXT =~ s/<<<TRANLANGOTHERTHANENG>>>//g;
    }
    #vervang textfile entries
    $ALLTEXT =~ s/<<<TEXTFILES>>>/$TEXTFILES/;
    
    #$WEIRDCHARBASE = chr(246);
    #$WEIRDCHARREPLACE = "246" ;
    #$CHARPARSING = "CHR§NUMB§".$WEIRDCHARBASE."§".$WEIRDCHARREPLACE."§NO" ;
    
    #ADD MESSAGE STYLE PARSING TO PARSE FOR IN-PROGRAM PARSING
    #$PARSESTDMESSAGESTYLECODES = "STD\§NONE\§ChapterStatus<<<Locked>>>\§ChapterStatusLocked\§YES\n";
    #$PARSESTDMESSAGESTYLECODES = $PARSESTDMESSAGESTYLECODES."STD\§NONE\§ChapterStatus<<<Unlocked>>>\§ChapterStatusUnlocked\§YES\n";
    #$PARSESTDMESSAGESTYLECODES = $PARSESTDMESSAGESTYLECODES."STD\§NONE\§ChapterStatus<<<Finished>>>\§ChapterStatusFinished\§YES\n";
    #$ALLTEXT =~ s/<<<PARSESTDMESSAGESTYLECODES>>>/$PARSESTDMESSAGESTYLECODES/;
    
    #translate help, information and messaging
    foreach $MessTransEntry (@MessTransEntries)
    {
      @MessTransLine = split(/#/,$MessTransEntry);
      $MessGrep = $MessTransLine[0];
      $MessChange = $MessTransLine[$TLN];
      if ($ALLTEXT =~ $MessGrep)
      {
        $ALLTEXT =~ s/$MessGrep/$MessChange/g;
        if ($TRACING eq "ON") {
          print "In Parsefile, change $MessTransLine[0] to $MessTransLine[$TLN]\n";
        } else { print ".";}
      }
    }
    
    #vervang textfile entries
    $ALLTEXT =~ s/<<<CHARPARSING>>>/$CHARPARSING/;
    
    #vervang color codes
    $COLORPARSING = $TotalParseTLCode.$TotalParseBGCode.$TotalParseTXCode ;
    chop $COLORPARSING;
    $ALLTEXT =~ s/<<<COLORPARSING>>>/$COLORPARSING/;
    
    #vervang security codes for debug/test purposes
    #$SecSpace = "80.056.614.912" ;
    #$SecSerial = "1,824,816,167" ;
    #$SecSerial = "9C14-AA76" ;
    
    # ADD SECURITY CODES TO PARSE FILE
    if ($TOPROD eq "yes")
    {
      $SecPath = $PRODDRIVE.": ";
      $SecDrive = $PRODDRIVE.": ";
    }
    else
    {
      $SecPath = `cd`;
      $SecDrive = "";
      
      #create PRODDRIVE var yourself! It's the current work disk
      $PRODDRIVESTRING = `cd`;
      chop $PRODDRIVESTRING;
      $PRODDRIVE = substr $PRODDRIVESTRING,0,1;
    }
    
    $SecSpaceLine = `cd Bin & ntfsinfo.exe $SecPath`;
    $SecSpaceLine =~ s/[^0-9 ]//g;
    $SecSpaceLine =~ s/    / /g;
    $SecSpaceLine =~ s/   / /g;
    $SecSpaceLine =~ s/  / /g;
    $SecSpaceLine =~ s/  / /g;
    $SecSpaceLine =~ s/  / /g;
    $SecSpaceLine =~ s/  / /g;
    $SecSpaceLine =~ s/  / /g;
    $SecSpaceLine =~ s/  / /g;
    @SecSpaceArray = split(" ",$SecSpaceLine);
    $SecSpace = $SecSpaceArray[0];
    $SecSpace = $SecSpace * 1024;
    $SecSerialLine = `cd Bin & vol $SecDrive| grep " is "`;
    @SecSerialArray = split(" ",$SecSerialLine);
    foreach $SecSerialEntry(@SecSerialArray)
    {
       if ($SecSerialEntry =~ "-")
       {
          $SecSerial = $SecSerialEntry;
       }
    }
    $SecSerial =~ s/-//;
    #$SecSerial = hex($SecSerial);
    
    if ($TRACING eq "ON") {
      print "\nUnformatted Security Space Code: ".$SecSpace."-eos-\n";
      print "\nUnformatted Security SerialCode: ".$SecSerial."-eos-\n\n";
    } else { print "."; }
    
    #format SecSpace
    $s=-1;
    $SecSpace = reverse($SecSpace);
    @SecSpaceChars=split("",$SecSpace);
    foreach $SecSpaceChar(@SecSpaceChars)
    {
       $s=$s+1;
       if ($s == 3)
       {
          $s = 0;
          $SecSpaceString = $SecSpaceString.".";
       }
       $SecSpaceString = $SecSpaceString.$SecSpaceChar;
    }
    $SecSpace = reverse($SecSpaceString);
    $SecSpace =~ s/\,//g;
    $SecSpace =~ s/\.//g;
    
    #format SecSerial
    $s=-1;
    $SecSerial = reverse($SecSerial);
    @SecSerialChars=split("",$SecSerial);
    foreach $SecSerialChar(@SecSerialChars)
    {
       $s=$s+1;
       if ($s == 3)
       {
          $s = 0;
          $SecSerialString = $SecSerialString.".";
       }
       $SecSerialString = $SecSerialString.$SecSerialChar;
    }
    $SecSerial = reverse($SecSerialString);
    $SecSerial =~ s/\,//g;
    $SecSerial =~ s/\.//g;
    
    $SecManuOutput = `LUSB.exe`;
    @SecManuOutputWholeArray = split(/\= $PRODDRIVE\:\\/, $SecManuOutput);
    $SecManuOutputSecondPart = @SecManuOutputWholeArray[1];
    @SecManuOutputSecondArray = split(/\nUSB Port Name/,$SecManuOutputSecondPart);
    $SecManuOutputRightPart = $SecManuOutputSecondArray[0];
    @SecManuOutputTargetPartArray = split(/\nUSB Serial/, $SecManuOutputRightPart);
    $SecManuOutputTargetPart = $SecManuOutputTargetPartArray[1];
    @SecManuOutputCodeArray = split(/ \= /, $SecManuOutputTargetPart);
    $SecManu = $SecManuOutputCodeArray[1];
    
    ###############
    ## DANGER!!! ##
    if ($SecManu eq "") {$SecManu = "1"}; # Installing on C:, bypassing Manufacturer ID Security
    ## DANGER!!! ##
    ###############
    
    # ABOVE MEANS THAT THE VERSION YOU INSTALL FROM C: CAN BE COPIED TO ANY OTHER C: WITH SAME DISK SIZE AND SERIAL NUMBER!!!
    
    # CREATING UNIQUE SECURITY KEY
    for ($EKY = 0; $EKY < 16; $EKY++) {
      $GeneratedEKYchar = int(rand(15));
      $GeneratedEKYchar =~ s/10/A/;
      $GeneratedEKYchar =~ s/11/B/;
      $GeneratedEKYchar =~ s/12/C/;
      $GeneratedEKYchar =~ s/13/D/;
      $GeneratedEKYchar =~ s/14/E/;
      $GeneratedEKYchar =~ s/15/F/;
      $SecurityKey = $SecurityKey.$GeneratedEKYchar;
    }
    $SecurityKey = $LANCOD.$TARCOD.$GRPCOD.$SecurityKey;
    
    # OVERRIDING SECURITY CODES WITH DOWNLOADABLE VERSIONS
    $SecManu = $TranOrgLang.$Title;
    $SecManu =~ s/ //g;
    $SecManu =~ s/\-//g;
    $SecSpace = $Title.$TranOrgLang;
    $SecSpace =~ s/ //g;
    $SecSpace =~ s/\-//g;
    $SecSerial = reverse ($Title.$TranOrgLang);
    $SecSerial =~ s/ //g;
    $SecSerial =~ s/\-//g;
    
    $SECURITYCODESPACE = "SEC§NONE§SecSpace§".$SecSpace."§NO" ;
    $SECURITYCODESERIAL = "SEC§NONE§SecSerial§".$SecSerial."§NO" ;
    $SECURITYCODEMANU = "SEC§NONE§SecManu§".$SecManu."§NO" ;
    $SECURITYCODEKEY = "SEC§NONE§GeheimeSleutel§".$SecurityKey."§NO" ;
    
    $SECURITYCODES = $SECURITYCODESPACE."\n".$SECURITYCODESERIAL."\n".$SECURITYCODEMANU."\n".$SECURITYCODEKEY ;
    $ALLTEXT =~ s/<<<SECURITYCODES>>>/$SECURITYCODES/;
    
    if ($TRACING eq "ON") {
      print "All Keys Together issen: ".$SECURITYCODES."\n";
    } else { print "."; }
    
    $WriteFile = "..\\..\\Languages\\$Language\\HTML\\Main\\Parse.htm" ;
    if ($TRACING eq "ON") {
      print "Creating File $WriteFile...\n" ;
    } else { print "."; }
    open (WRITEFILE, ">$WriteFile") || die "file $WriteFile kan niet worden aangemaakt, ($!)\n";
    print WRITEFILE $ALLTEXT ;
    close (WRITEFILE);
  }
  #END OF IF APPON EQ YES (ALL ABOVE WAS FOR SOFTWARE PRODUCT...)

#END LOOP FOR GROUP ???WUTT??? THIS IS ALMOST NEVER USED, NORMALLY PROCESSES ONLY ONE GROUP, NOT EVEN SURE IF ALL VARS ARE INITED FOR NEXT GROUP...
}


# get all pagecodes from TOTALOFPAGESSTRING
if ($TRACING eq "ON") {
  print "Creating list of wordcodes to pagenumbers for generic word lists:\n";
} else { print "."; }
if ($APPOn ne "yes") {
  @AllTotalOfPagesStringWordCodesArray = split(/\¶L\&\#167\;|\&\#167\;DO\_REFRESH\¶M/,$TOTALOFPAGESSTRING);
} else {
  @AllTotalOfPagesStringWordCodesArray = split(/\<NOBR\>\<\!\-\-|\-\-\>\<span class\=\'text\'\>/,$TOTALOFPAGESSTRING);
}
print "\nLength of AllTotalOfPagesStringWordCodesArray is ".@AllTotalOfPagesStringWordCodesArray."\n";
foreach $AllTotalOfPagesStringWordCodesString (@AllTotalOfPagesStringWordCodesArray) {
  if ($DidNotPush eq "YES") {
    ($pagenumbert,$chapternumber,$wordnumber) = split(/\_/,$AllTotalOfPagesStringWordCodesString);
    $AllTotalOfPagesCountersIncludingPages{$chapternumber."_".$wordnumber} = $pagenumbert;
    $DidNotPush = "NO";
  } else {
    $DidNotPush = "YES";
  }
}

#cleanup
`del newtext`;
`del recording`;


# read existing roots file so possible to get root for each word
if (-f "..\\..\\Languages\\$Language\\Frequency\\roots.csv") {
  $ReadFile = "..\\..\\Languages\\$Language\\Frequency\\roots.csv" ;
  open (READFILE, "$ReadFile") || die "file $ReadFile cannot be found. ($!)\n";
  @WordsToRoot = <READFILE>;
  close (READFILE);
  $WordsToRoot = join("###",@WordsToRoot);
  @ALLWORDSTOROOTS = @WordsToRoot ;
}

# read existing preandsuffixes file so it's possible to get root for each word
if (-f "..\\..\\Languages\\$Language\\Frequency\\PreAndSuffixes.csv") {
  $ReadFile = "..\\..\\Languages\\$Language\\Frequency\\PreAndSuffixes.csv" ;
  open (READFILE, "$ReadFile") || die "file $ReadFile cannot be found. ($!)\n";
  @PreAndSuffixes = <READFILE>;
  close (READFILE);
  $PreAndSuffixes = join("###",@PreAndSuffixes);
}


if ($TRACING eq "ON") {
  print "Creating generic word lists:\n";
} else { print "."; }

@BASWORDSKEYS = keys %ALLBASWORDS;

#wittle expewiment to doublecheck if unique words are correctly done by chapter, as KEYWORDS order seems kind of not sorted on chapter
#@ALLBASWORDS = sort (@BASWORDSKEYS);
#This does work because KEYWORDS ARE ALREADY THE FIRST UNQIUE OCCURRENCE, and meaningline's first entry is the first unique occurrence of that keyword, and contains the correct chapter
@ALLBASWORDS = @BASWORDSKEYS;
$NumberOfUniqueWords = @ALLBASWORDS;

%seen = ();
%sheen = ();
%tseen = ();
%taseen = ();
%tbseen = ();
%tcseen = ();     #Chapter Number unique hash
%tdseen = ();	  #Unique words (for unique words per chapter)
%tqseen = ();     #Unique words with chapter
%txseen = ();     #Unique words no chapter
%tuseen = ();     #Unit based system
%snoreseen = ();  #Edit chapter menu options, this seen thing has no end...
$CharTen = chr(10);
foreach $item (@ALLBASWORDS) {

   $allmeanings=$ALLBASWORDS{$item};
   
   
   $ALLBASWORDS{$item} =~ s/\*[0-9]{3}-[0-9]{5}\*//g;
   $ALLBASWORDS{$item} =~ s/\*[0-9]{2}-[0-9]{5}\*//g;
   $ALLBASWORDS{$item} =~ s/\*[0-9]{1}-[0-9]{5}\*//g;
   $ALLBASWORDS{$item} =~ s/\*[0-9]{3}-[0-9]{4}\*//g;
   $ALLBASWORDS{$item} =~ s/\*[0-9]{2}-[0-9]{4}\*//g;
   $ALLBASWORDS{$item} =~ s/\*[0-9]{1}-[0-9]{4}\*//g;
   $ALLBASWORDS{$item} =~ s/\*[0-9]{3}-[0-9]{3}\*//g;
   $ALLBASWORDS{$item} =~ s/\*[0-9]{2}-[0-9]{3}\*//g;
   $ALLBASWORDS{$item} =~ s/\*[0-9]{1}-[0-9]{3}\*//g;
   $ALLBASWORDS{$item} =~ s/\*[0-9]{3}-[0-9]{2}\*//g;
   $ALLBASWORDS{$item} =~ s/\*[0-9]{2}-[0-9]{2}\*//g;
   $ALLBASWORDS{$item} =~ s/\*[0-9]{1}-[0-9]{2}\*//g;
   $ALLBASWORDS{$item} =~ s/\*[0-9]{3}-[0-9]{1}\*//g;
   $ALLBASWORDS{$item} =~ s/\*[0-9]{2}-[0-9]{1}\*//g;
   $ALLBASWORDS{$item} =~ s/\*[0-9]{1}-[0-9]{1}\*//g;
   #if ($ALLBASWORDS{$item} !~ "\=\;" && $ALLBASWORDS{$item} !~ "\=\(\)\;") {
   if ($item ne "<empty>") {

     push(@ALLBASWORDSDATABASEUNSORTED, "\n".$item." => ".$ALLBASWORDS{$item}."<BR>") unless $seen{$item}++;

     @meaninglines=split(/::/,$allmeanings);
     $wordfrequency=@meaninglines;
     #print "item $item wordfreq $wordfrequency\n";  # this is a nice start to do something with roots! take substring from word and compare to all other words
     $keycode="";
     foreach $meaningline(@meaninglines) {
     	
       if ($Language eq "French" || $Language eq "Spanish" || $Language eq "Italian" || $Language eq "German" || $Language eq "Dutch" || $Language eq "English" || $Language eq "Portuguese" || $Language eq "Indonesian" || $Language eq "Hungarian" || $Language eq "Swedish") {
         for ($charnr = 130 ; $charnr < 255 ; $charnr++) {
           $charch = chr($charnr);
           $meaningline =~ s/$charch/\&\#$charnr\;/g;
         }
       }

       $meaningline =~ s/\;\;\&nbsp\;/\;\:\&nbsp\;/g;
     	
       #if ($meaningline =~ "5-218") { print "Aha! Found in meaningline\n".$meaningline."\n"; }
   
       #$meaningline =~ s/\; \; / \: /g;
       @meaningentries = split(/;;|=/,$meaningline);
       $original       = $meaningentries[4];
       $originalnum    = $original;
       $originalnum    =~ s/\(\.\)/L/g;
       if ($originalnum =~ "L") {
          $originalnum =~ s/L//g;
          $originalnum = "L".$originalnum;
       }
       @originalnumline = split (/\(|\)/,$originalnum);
       $originalnum = $originalnumline[1];
       if ($originalnum !~ "\-") {
         print "Hey! Originalnum does not contain '-', check meaningline:\n".$meaningline."\n";
       }
       @oripluscode=split(/\(|\)/,$original);
       $oricode = $oripluscode[1];
       if ($keycode eq "") { $keycode = $oricode; }
       $original =~ s/\-\d+\)/\)/g;
       $original =~ s/\-\d+\(\.\)\)/\)/g;
       $lcoriginal = lc($original);

       $meaning=$meaningentries[5];
       
       
       # create different if for this kind of checks
       # something like if $PhoneticLanguages =~ "#".$Language."#"
       # cuz this is kinda inefficient
       if ($meaning =~ m/\{/ && ( $Language eq "Russian" || $Language eq "Georgian" ) ) {
         ($mess,$phonetic,$moremess) = split(/\{|\}/,$meaning);
       }
         
       
       #MEANING SPLITTEN IN MEANING EN CHAPTERCODE-WORDNUMBERCODE
       @MeaningLine = split(/\*/,$meaning);
       $meaning = $MeaningLine[0];
       $chapterandcounter = $MeaningLine[1];
       $meaning =~ s/  //g;
       $meaning =~ s/\(\)//g;
       $meaning =~ s/&nbsp;&nbsp;/&nbsp;/g;
       $meaning =~ s/&nbsp;-&nbsp;\(/-&nbsp;\(/g;
       $meaning =~ s/\(&nbsp;-&nbsp;/\(-/g;
       $meaning =~ s/&nbsp;\,&nbsp;/\,&nbsp;/g;
       $meaning =~ s/&nbsp;-&nbsp;/-/g;
       $meaning =~ s/&nbsp;&nbsp;/&nbsp;/g;
       $meaning =~ s/  / /g;
       $meaning =~ s/&nbsp;;;/;;/g;
       $meaning =~ s/&nbsp;\:\:/\:\:/g;
       $meaning =~ s/ \;\;/\;\;/g;
       $meaning =~ s/ \:\:/\:\:/g;
       
       # Get rid of the dashes in wordcodes
       $chapterandcounter =~ s/\-/\_/g;
       $originalnum =~ s/\-/\_/g;
       
       
       # Find page with chapterandcounter
       $pagecode = $AllTotalOfPagesCountersIncludingPages{$chapterandcounter};
       if ($pagecode eq "" || $pagecode == 0) {
          #print "skip this one\n";
          next;
       }

       $justchapterandcounter = $chapterandcounter;
       $chapterandcounter = $pagecode."_".$chapterandcounter;
       
       # Try to get rid of higher meanings
       $meaning =~ s/ \(.*?\)//g;
       $meaning =~ s/\(.*?\) //g;
       $meaning =~ s/\(.*?\)//g;
       if ($meaning =~ m/\[/ || $meaning =~ m/\&\#123\;/ || $meaning =~ m/\{/) {
         #print $meaning." contains high level explanation, remove and replace by ";
         $meaning =~ s/ \[/\[/;
         @TOTALMEANINGS = split(/\[|\&\#123\;|\{/,$meaning);
         $meaning = $TOTALMEANINGS[0];  # extract literal meaning
         #print $meaning."\n";
       }
       #remove any first and last spacez
       $meaning =~ s/^ //g;
       $meaning =~ s/^\&nbsp\;//g;
       $meaning =~ s/\&nbsp\;$//g;
       
       if ( $original eq "" || $meaning eq "" || $original !~ m/\(/ || $original =~ m/\<empty\>/ )
       {
          next;
       }
       
       @originalline = split(/\(|\)/,$original);
       $ChapterNumber = $originalline[1];
       $originalnochapter = $original;
       $originalnochapter =~ s/\(\d+\)//g;
       $lcoriginalnochapter = lc($originalnochapter);
       
       
       if ( $DEMOWANTED eq "TRUE" && $ChapterDemoPages =~ "#".$pagecode."#" ) {
       	  if ($TRACING eq "ON") {
            print $ChapterDemoPages." contain ".$pagecode."\n";
          } else { print "."; }
          $DemoChapterWordCounters[$ChapterNumber] = $DemoChapterWordCounters[$ChapterNumber] + 1;
       } else {
          if ($DEMOWANTED eq "TRUE") {
             next;
          }
       }
       
       # eigenlijk kunnen we onderstaande word of rootfreq info alleen kloppend krijgen als we de hele shit runnen, maar daar lijkt geen memory voor de zijn :(
       if ($APPOn eq "yes") {
         # get a hash of wordfreq per story for later use -> if wordfreq is only high in story, not in group or all, it means it's still rare in general
         $STORYWORDFREQS{$lcoriginalnochapter,$ChapterNumber} = $STORYWORDFREQS{$lcoriginalnochapter,$ChapterNumber} + 1;
       
         # also get a hash of wordfreq per group -> if in a group, wordfreq is still low, it means either it is rare in general or even rare in a novel
         $StoryGroup = $StoryGroups[$ChapterNumber]; # add this info to .bat if that still fits
         $GROUPSTORYWORDFREQS{$originalnochapter,$StoryGroup} = $GROUPSTORYWORDFREQS{$originalnochapter,$StoryGroup} + 1;
       
         # get a hash of wordfreq for all stories (this has to be re-run with every new story/group of stories), this also implies you create a megareader.bat for each language to produce this list/info
         $ALLSTORYWORDFREQS{$lcoriginalnochapter} = $ALLSTORYWORDFREQS{$lcoriginalnochapter} + 1;
       }
       
       # also add a check for if word(root) and meaning are similar/same (cognate)
       
       # ROOTS - N.B. ROOTS CAN BE COMPOUND ROOTS!!! NOT SURE HOW TO DEAL WITH THOSE!!!
       # also get a hash of wordfreq per story per root       NO, NOT -ALSO- BUT -INSTEAD-! ROOT IS MORE PRECISE
       # DO THIS ONLY ONCE
       # for now, only for title, to see if this works     
       #if ($ChapterNumber == 2) {
      
       
       if ($SEPARATEROOT eq "YES") {
         if (-f "..\\..\\Languages\\$Language\\Frequency\\roots.csv" && $REDOROOTSFILE eq "NO") {
           if ($WordsToRoot =~ "###".$lcoriginalnochapter.",") {
             ($Unneeded,$WordRootPlusAfter) = split("###".$lcoriginalnochapter.",",$WordsToRoot);
       	     ($WordRoot,$PlusAfter) = split("###",$WordRootPlusAfter);
       	     # found da root, but wait, why am I doing this? To create the real frequency I guess...
       	     $lcoriginalnochapterroot = $WordRoot;
       	   } else {
       	     # if no root found, add it via prefixes if there
       	     if ( -f "..\\..\\Languages\\$Language\\Frequency\\PreAndSuffixes.csv" && (!-f "..\\..\\Languages\\$Language\\Frequency\\roots.csv" || $REDOROOTSFILE eq "YES")) {
               # recreate roots file (initially here only the array ALLWORDSTOROOTS
               for ($charnr = 130 ; $charnr < 255 ; $charnr++) {
                 $charch = chr($charnr);
                 $PreAndSuffixes =~ s/$charch/\&\#$charnr\;/g;
               }
               @PreAndSuffixes = split("###",$PreAndSuffixes);
               $PreFixDone = "no";
               $SufFixDone = "no";
               $PreFixChosen = "none";
               $SufFixChosen = "none";
               if ($ALLWORDSTOROOTSALREADYFOUND !~ "###".$lcoriginalnochapter."###") {
                 $lcoriginalnochapterroot = $lcoriginalnochapter;
                 # now find the smallest root for each word, roots should be sorted on longest first!!! check encrypt script on how to do that (did same there with vars)
                 foreach $possibleprefixorsuffixline(@PreAndSuffixes) {
                   ($PreFix,$SufFix) = split(",",$possibleprefixorsuffixline);
                   #chop $PreFix;
                   #chop $SufFix;
                   $PreFix =~ s/\n//;
                   $SufFix =~ s/\n//;
                   $LenPreFix = length $PreFix;
                   $LenSufFix = length $SufFix;
                   $lcoriginalnochapterprefix = substr ($lcoriginalnochapter,0,$LenPreFix);
                   $lcoriginalnochaptersuffix = substr ($lcoriginalnochapter,-$LenSufFix);
                   $lenoriginalnochapter = length $lcoriginalnochapter;
                   #print "Trying out $PreFix and $SufFix versus $lcoriginalnochapterprefix and $lcoriginalnochaptersuffix\n";
                   if ( length lcoriginalnochapter > 1 && $lenoriginalnochapter >= $LenPreFix + 1 && $LenPreFix > 0 && $PreFixDone ne "yes" && $lcoriginalnochapterprefix eq $PreFix) {
                     #print "PreFix is $PreFix, checking whether lcoriginalnochapter $lcoriginalnochapter contains any.\n";
                     $lcoriginalnochapterroot = substr ($lcoriginalnochapterroot,$LenPreFix);
                     $PreFixChosen = $PreFix;
                     $PreFixDone = "yes";
                   }
                   if ( length lcoriginalnochapter > 1 && $lenoriginalnochapter >= $LenSufFix + 1 && $LenSufFix > 0 && $SufFixDone ne "yes" && $lcoriginalnochaptersuffix eq $SufFix) {
                     #print "SufFix is $SufFix, checking whether lcoriginalnochapter $lcoriginalnochapter contains any.\n";
                     $lenoriginalnochapter = length $lcoriginalnochapterroot;
                     $lcoriginalnochapterroot = substr ($lcoriginalnochapterroot,0,$lenoriginalnochapter - $LenSufFix);
                     $SufFixChosen = $SufFix;
                     $SufFixDone = "yes";
                   }
                   if ($PreFixDone eq "yes" && $SufFixDone eq "yes") {
                     last;
                   }
                 }
                 if ($PreFixDone eq "yes" || $SufFixDone eq "yes") {
                   #print "For word ".$lcoriginalnochapter.", removed ".$PreFixChosen." and/or ".$SufFixChosen." to get root ".$lcoriginalnochapterroot."!\n"; 
                 }
                 #if ($ALLWORDSTOROOTSALREADYFOUND =~ "###".$lcoriginalnochapter."###" || $ALLWORDSTOROOTSALREADYFOUND{$lcoriginalnochapter} ne "") {
                    # well I'll be darned, why didn't the earlier if statement pick this up!?!?
                 #} else {
                   push (@ALLWORDSTOROOTS,$lcoriginalnochapter.",".$lcoriginalnochapterroot);
                   $ALLWORDSTOROOTSALREADYFOUND = $ALLWORDSTOROOTSALREADYFOUND."###".$lcoriginalnochapter."###".$lcoriginalnochapterroot."###";
                   $ALLWORDSTOROOTSALREADYFOUND{$lcoriginalnochapter} = $lcoriginalnochapterroot;
                 #}
               } else {
                 $lcoriginalnochapterroot = $ALLWORDSTOROOTSALREADYFOUND{$lcoriginalnochapter};
               }
             } 
       	   }
         } else {
           if ( -f "..\\..\\Languages\\$Language\\Frequency\\PreAndSuffixes.csv" && (!-f "..\\..\\Languages\\$Language\\Frequency\\roots.csv" || $REDOROOTSFILE eq "YES")) {
             # recreate roots file (initially here only the array ALLWORDSTOROOTS
             $ReadFile = "..\\..\\Languages\\$Language\\Frequency\\PreAndSuffixes.csv" ;
             open (READFILE, "$ReadFile") || die "file $ReadFile cannot be found. ($!)\n";
             @PreAndSuffixes = <READFILE>;
             close (READFILE);
             $PreAndSuffixes = join("###",@PreAndSuffixes);
             for ($charnr = 130 ; $charnr < 255 ; $charnr++) {
               $charch = chr($charnr);
               $PreAndSuffixes =~ s/$charch/\&\#$charnr\;/g;
             }
             @PreAndSuffixes = split("###",$PreAndSuffixes);
             $PreFixDone = "no";
             $SufFixDone = "no";
             $PreFixChosen = "none";
             $SufFixChosen = "none";
             if ($ALLWORDSTOROOTSALREADYFOUND !~ "###".$lcoriginalnochapter."###") {
               $lcoriginalnochapterroot = $lcoriginalnochapter;
               # now find the smallest root for each word, roots should be sorted on longest first!!! check encrypt script on how to do that (did same there with vars)
               foreach $possibleprefixorsuffixline(@PreAndSuffixes) {
                 ($PreFix,$SufFix) = split(",",$possibleprefixorsuffixline);
                 #chop $PreFix;
                 #chop $SufFix;
                 $PreFix =~ s/\n//;
                 $SufFix =~ s/\n//;
                 $LenPreFix = length $PreFix;
                 $LenSufFix = length $SufFix;
                 $lcoriginalnochapterprefix = substr ($lcoriginalnochapter,0,$LenPreFix);
                 $lcoriginalnochaptersuffix = substr ($lcoriginalnochapter,-$LenSufFix);
                 $lenoriginalnochapter = length $lcoriginalnochapter;
                 #print "Trying out $PreFix and $SufFix versus $lcoriginalnochapterprefix and $lcoriginalnochaptersuffix\n";
                 if ( length lcoriginalnochapter > 1 && $lenoriginalnochapter >= $LenPreFix + 1 && $LenPreFix > 0 && $PreFixDone ne "yes" && $lcoriginalnochapterprefix eq $PreFix) {
                   #print "PreFix is $PreFix, checking whether lcoriginalnochapter $lcoriginalnochapter contains any.\n";
                   $lcoriginalnochapterroot = substr ($lcoriginalnochapterroot,$LenPreFix);
                   $PreFixChosen = $PreFix;
                   $PreFixDone = "yes";
                 }
                 if ( length lcoriginalnochapter > 1 && $lenoriginalnochapter >= $LenSufFix + 1 && $LenSufFix > 0 && $SufFixDone ne "yes" && $lcoriginalnochaptersuffix eq $SufFix) {
                   #print "SufFix is $SufFix, checking whether lcoriginalnochapter $lcoriginalnochapter contains any.\n";
                   $lenoriginalnochapter = length $lcoriginalnochapterroot;
                   $lcoriginalnochapterroot = substr ($lcoriginalnochapterroot,0,$lenoriginalnochapter - $LenSufFix);
                   $SufFixChosen = $SufFix;
                   $SufFixDone = "yes";
                 }
                 if ($PreFixDone eq "yes" && $SufFixDone eq "yes") {
                   last;
                 }
               }
               if ($PreFixDone eq "yes" || $SufFixDone eq "yes") {
                 #print "For word ".$lcoriginalnochapter.", removed ".$PreFixChosen." and/or ".$SufFixChosen." to get root ".$lcoriginalnochapterroot."!\n"; 
               }
               #if ($ALLWORDSTOROOTSALREADYFOUND =~ "###".$lcoriginalnochapter."###" || $ALLWORDSTOROOTSALREADYFOUND{$lcoriginalnochapter} ne "") {
                  # well I'll be darned, why didn't the earlier if statement pick this up!?!?
               #} else {
                 push (@ALLWORDSTOROOTS,$lcoriginalnochapter.",".$lcoriginalnochapterroot);
                 $ALLWORDSTOROOTSALREADYFOUND = $ALLWORDSTOROOTSALREADYFOUND."###".$lcoriginalnochapter."###".$lcoriginalnochapterroot."###";
                 $ALLWORDSTOROOTSALREADYFOUND{$lcoriginalnochapter} = $lcoriginalnochapterroot;
               #}
             } else {
               $lcoriginalnochapterroot = $ALLWORDSTOROOTSALREADYFOUND{$lcoriginalnochapter};
             } 
           } else {
             # there's (n)either roots file (n)or pre- or suffixes file, so we'll have to satisfy ourselves with the frequency of just the word
             $lcoriginalnochapterroot = $lcoriginalnochapter;
             push (@ALLWORDSTOROOTS,$lcoriginalnochapter.",".$lcoriginalnochapterroot);
           }
         }
       
         # did we create a separate root? Then also make these root hashes, together calcerlate difficulty (unique word but with same root is medium, more words and more roots is easy, unique word unique root difficult, etc)
         if ($lcoriginalnochapter ne $lcoriginalnochapterroot) {
            # fill story word root hash
           $STORYWORDROOTFREQS{$lcoriginalnochapterroot,$ChapterNumber} = $STORYWORDFREQS{$lcoriginalnochapterroot,$ChapterNumber} + 1;
           # fill story group word root hash
           $GROUPSTORYWORDROOTFREQS{$lcoriginalnochapterroot,$StoryGroup} = $GROUPSTORYWORDROOTFREQS{$lcoriginalnochapterroot,$StoryGroup} + 1;
           # also get a has of wordfreq for all stories per root
           $ALLSTORYWORDROOTFREQS{$lcoriginalnochapterroot} = $ALLSTORYWORDFREQS{$lcoriginalnochapterroot} + 1;
         }
       } else {
         # if we don't do root specifically lets just add it as empty spot here for later adventures
         $lcoriginalnochapterroot = $lcoriginalnochapter;
       }
       # end of root stuff
       
       
       # this is for old software I think
       push(@ALLCLICKWORDSDATABASEUNSORTED, "<!--".$originalnum."_".$wordfrequency."--><A href='CLK".$chapterandcounter."'>".$originalnochapter."=".$meaning."=".$justchapterandcounter."<BR>") unless $taseen{"_".$originalnochapter."=".$meaning."=".$justchapterandcounter."<BR>"}++;


       # this array holds the keys from chapterandcounter to word and meaning        ### !!! COULD ADD WORD OR ROOT FREQ HERE VIA ARRAYS (SO FIRST COUNT THEM, THEN BEFORE WRITING BELOW STRING TO FILE, ADD FREQS !!! ###
       if ($APPOn eq "yes") {
         if ($ChapterNumber > 1) {
           $ChapterAuthor = $ChapterAuthors[$ChapterNumber-2];
           if ($ChapterAuthor eq "") {
             $ChapterAuthor = $ChapterAuthors[0];
           }
           $AppTextPath = $ChapterAuthor."_".$STORIES[$ChapterNumber-2];
           $AppTextWords{$AppTextPath} = $AppTextWords{$AppTextPath}."wordHash[\"".$originalnum."\"] = \"".$originalnochapter.",".$meaning.",".$wordfrequency.",".$lcoriginalnochapterroot.",rootfrequency\";\n";
           # if you change $wordfrequency into wordfrequency, you can replace it later with the three different wordfrequencies (story_level_all) for detailed calculations, a possible fourth level is "corpus"
           # same for roots gathered...
         }
       }
       
       if ($APPOn eq "yes") {
          push(@ALLAPPWORDSUNSORTED, $ChapterNumber.",".$chapterandcounter.",".$originalnochapter.",".$lcoriginalnochapter.",".$lcoriginalnochapterroot.",".$ChapterNumber );
       }

       # for unit based system, calcerlate (change wordfreq later, 10 freq average to practice x 2000 unknown words is 20.000 extra sentences to practice? so needs to be 5 x 1000 unknown words)
       $CalcerlatedWordFreq = 21 - $wordfrequency;
       if ($CalcerlatedWordFreq < 1) {
       	 $CalcerlatedWordFreq = 1;
       }
       $CurrentPageWordFreq = $PagesForUnitSystem[$pagecode];
       if ($CurrentPageWordFreq ne "") {
         $CurrentPageWordFreq = $CurrentPageWordFreq + $CalcerlatedWordFreq;
         $PagesForUnitSystem[$pagecode] = $CurrentPageWordFreq;
       } else {
       	 $PagesForUnitSystem[$pagecode] = $CalcerlatedWordFreq;
       }
       $WordsForUnitSystem[$pagecode] = $WordsForUnitSystem[$pagecode] . "::".$originalnum."_".$wordfrequency."_".$ChapterNumber."_".$originalnochapter."=".$meaning unless $tuseen{"_".$originalnochapter."=".$meaning."<BR>"}++;

       # for unit based system, only words that have a wordfreq of x or lower will need be practiced separately, namely 10 - x
       
       # when calcerlating (10 x ) re-reading of pages, subtract from word freq of each word on page, btw re-reading 150 pages x 10 is 1,500 pages to divide over 50 units, is 30 pages
       
       # calcerlate re-read pages per unit by giving each page a reading effort value of 10, or based on word freq max 10, or lower, then adding pages to unit diff number, for max unit re-read diff
       
       # for example, unit one consists of page 1-5 and re-reading page 1-5, and re-reading page 1-5 adds up to about 50 of word freq max difficulty
       # however when doing unit two, reading 1-10 adds only 0,9 for the first five, so leaves 0,5 room for some sentences :-)
       # twiet
       
       # think of something fun to add per unit to keep spirits up,
       # for example in unit one, add a guess of which words people now know if they were absolute beginner (a, az, egy)
       # or average (what, ev, er)
       
       # after having calcerlated the re-reading of all pages in all the units, evenly add pages with sentences
       
       

       push(@ALLTESTWORDSDATABASEUNSORTED, "<!--".$originalnum."_".$wordfrequency."--><A href='CLK".$chapterandcounter."'>".$originalnochapter."=".$meaning."=".$chapterandcounter."<BR>") unless $tbseen{"_".$originalnochapter."=".$meaning."<BR>"}++;

       if ($Language eq "Russian" || $Language eq "Georgian") {
         push(@ALLPHONWORDSDATABASEUNSORTED, "<!--".$originalnum."_".$wordfrequency."--><A href='CLK".$chapterandcounter."'>".$originalnochapter."=".$phonetic."=".$chapterandcounter."<BR>") unless $tpseen{"_".$originalnochapter."=".$phonetic."<BR>"}++;
       }

       #$ALLUNIQUEWORDSPERCHAPTER[$ChapterNumber-1] = ($ALLUNIQUEWORDSPERCHAPTER[$ChapterNumber-1] + 1) unless $tdseen {$originalnochapter."=".$meaning}++;
       $ALLUNIQUEWORDSPERCHAPTER[$ChapterNumber-1] = ($ALLUNIQUEWORDSPERCHAPTER[$ChapterNumber-1] + 1) unless $tdseen {$lcoriginalnochapter."(".$ChapterNumber.")"}++;
       $ALLNEWWORDSPERCHAPTER[$ChapterNumber-1] = ($ALLNEWWORDSPERCHAPTER[$ChapterNumber-1] + 1) unless $tdseen {$lcoriginalnochapter}++;

       # Here the script is getting the unique words per chapter, but HOW FOR MOTHER NATURES SAKE DID THAT WORK WHEN I DIDN'T SORT ON CHAPTER BEFORE!?!?!?!?
       # hmmmm because words are ALREADY defined as unique per chapter, in the sense that the KEYWORD is taken from the first chapter where encountered, then other occurrences added!
       # (this means that above NEW WORDS are already calculated in KEYWORDS: for 'a' the first 'a' that shows up will also show which chapter it occurred)
       # so per e-book the "new word" calculation will be fine, and the per chapter calculation in following e-books will just look at whether word occurs in that chapter
       # only thing is, what is $ChapterNumber used for....... It is used to check per chapter per word in current book if word is still unique compared to finished books... 
       # So that's why it works :-) KEYWORDS ARE IN NATURE THE FIRST OCCURRENCES OF WORDS!!! 
       $Kees = "(".$ChapterNumber.")".$lcoriginalnochapter;
       $Kees =~ s/\) /\)/;
       if ($TRACING eq "ON") {
         print $Kees.",";
       } else { print "."; }
       push (@ALLNEWWORDSUNSORTED,$Kees) unless $tqseen {$lcoriginalnochapter}++;
       push (@ALLNEWWORDSNOCHAPTER,$lcoriginalnochapter) unless $txseen {$lcoriginalnochapter}++;

       $ChapterNameWithSpaceUnicode = $ChapterLongNames[$ChapterNumber-1];
       $HighSpace = chr(160);
       $ChapterNameWithSpaceUnicode =~ s/ /$HighSpace/g;
       if ($ChapterNumber =~ m/^\d+$/) #we're going to include title chapter and make it some kind of tutorial
       {
         $CHAPTERTESTOPTIONS[$ChapterNumber-1] = "                  <option value= 'LAYOUTTESTINWORDTST§CHAPTER§".$ChapterNumber."§12'    ><<<Test Chapter>>> '".$ChapterNameWithSpaceUnicode."'</option>" unless $tcseen{$ChapterNumber}++;
         if ( ($Chapternumber-1) == 0 && $DebugStatementAboutNowHandlingTitleChapter ne "YES" ) {
           if ($TRACING eq "ON") {
             print "Now handling Title chapter\n";
           } else { print "."; }
           $DebugStatementAboutNowHandlingTitleChapter = "YES";
         }
         $CHAPTERNAMESJAVAVARS=$CHAPTERNAMESJAVAVARS."  ChapterName[".$ChapterNumber."]=\"".$ChapterNameWithSpaceUnicode."\";\n" unless $tdseen{$ChapterNumber}++;
         if ($ChapterNumber > $LastChapterNumbert)
         {
            $HighestChapterNumbert = $ChapterNumber;
         }
         $ManualChapterShortName = $ChapterShortNames[$ChapterNumber-1].".htm";
         $CHAPTEREDITPAGES[$ChapterNumber-1]="   <A href='GET§<<<BASEHTMLFILEPART>>>MainEditMenu.htm<><<<PAGENUMBER>>><>§".$ManualChapterShortName."§<<<PAGEEDIT>>>§NO'>Edit\t".$ChapterNumber."\t".$ChapterNameWithSpaceUnicode."</A><BR>\n"  unless $snoreseen{$ChapterNumber}++;
       }
     }
     print ".";
   } else {
     if ($TRACING eq "ON") {
       print "Geweigerd: $item => $allmeanings\n";
     } else { print "."; }
   }
}


# CREATING WORD ROOT FILE

if ( -f "..\\..\\Languages\\$Language\\Frequency\\PreAndSuffixes.csv" && (!-f "..\\..\\Languages\\$Language\\Frequency\\roots.csv" || $REDOROOTSFILE eq "YES")) {
  print "\n(Re)creating root file !!!!!!!!!\n";
  @UNIQALLWORDSTOROOTS = do { my %wordseen; grep { !$wordseen{$_}++ } @ALLWORDSTOROOTS };
  @SORTEDUNIQALLWORDSTOROOTS = sort @UNIQALLWORDSTOROOTS;
  $ALLWORDSTOROOTS = join("\n",@SORTEDUNIQALLWORDSTOROOTS);
  $WriteFile = "..\\..\\Languages\\$Language\\Frequency\\roots.csv" ;
  open (WRITEFILE, ">$WriteFile") || die "file $WriteFile kan niet worden aangemaakt, ($!)\n";
  print WRITEFILE $ALLWORDSTOROOTS ;
  close (WRITEFILE);
}


# THIS CAN BE USED TO FIX PREANDSUFFIXES FILE!
if ($SORTFIXES eq "yes") {
  foreach $PreFixOrSufFix (@PreAndSuffixes) {
    ($PreFix,$SufFix) = split(",",$PreFixOrSufFix);
    $PreFix =~ s/\n//;
    $SufFix =~ s/\n//;
    $LenPreFix = length $PreFix;
    $LenSufFix = length $SufFix;
    if ($PreFix ne "") {
      $AllPreFixEs[$LenPreFix] = $AllPreFixEs[$LenPreFix].$PreFix.",\n";
    }
    if ($SufFix ne "") {
      $AllSufFixEs[$LenSufFix] = $AllSufFixEs[$LenSufFix].",".$SufFix."\n";
    }
  }
  foreach $PreFixOnLength (@AllPreFixEs) {
    unshift @AllPreFixEsSorted, $PreFixOnLength;
  }
  foreach $SufFixOnLength (@AllSufFixEs) {
    unshift @AllSufFixEsSorted, $SufFixOnLength;
  }
  # these arrays are from long to small
  $ALLPREFIXES = join("",@AllPreFixEsSorted);
  print $ALLPREFIXES;
  $ALLSUFFIXES = join("",@AllSufFixEsSorted);
  print $ALLSUFFIXES;
  $ALLPREANDSUFFIXES = $ALLSUFFIXES."\n".$ALLPREFIXES;
  $WriteFile = "..\\..\\Languages\\$Language\\Frequency\\PreAndSuffixesSort.csv" ;
  open (WRITEFILE, ">$WriteFile") || die "file $WriteFile kan niet worden aangemaakt, ($!)\n";
  print WRITEFILE $ALLPREANDSUFFIXES ;
  close (WRITEFILE);
}

if ($APPOn eq "yes") {
  @ALLAPPWORDS = sort (@ALLAPPWORDSUNSORTED);
  $ALLAPPWORDS = join(",",@ALLAPPWORDS);
  $ALLAPPWORDS = ",".$ALLAPPWORDS.",";
  #print $ALLAPPWORDS;
}



# NEED TO BE ABLE TO GRAB WORD OR PAGE

# click word, does what? Uses chapter, page and wordcounter to get:
# word + meaning
# this info can already be gotten from HypLernWordsAll.htm

# source data:
# app int/pnt text file: <!--42_3_10--><span class='text'><span id='a3_10' onclick="Show('a3_10','c3_10',1,2)" class='main'>gubancol&#243;dott</span>
# push(@ALLAPPWORDSUNSORTED, $ChapterNumber.",".$chapterandcounter.",".$originalnochapter.",".$lcoriginalnochapter.",".$lcoriginalnochapterroot.",".$ChapterNumber );

# probably add the code to click, code just needs page and word_id

# flash card template, just contains empty items
# javascript checks flash card word files and fills empty items
# there is also a link to page per item

# for this, javascript needs flash card file with date in seconds and coded lcoriginalnochapter
# inside the file are the links to the story/pages


# I click a word. Javascript stores the word -> fileNAME is current time plus story_and_page_code plus word, plus meaning.
# I go to flash cards. The template consists of empty items. Javascript reads path. Gets time-sorted. oldest flash card is put on top.
# From fileNAME I retrieve word and meaning to place in item and use story_and_page_code to create link to page.
# if page link is clicked it will use story+special bookmark sign to highlight specific word.

# I test the oldest word. Javascript changes the filename to most recent time. 


# so I need a file that has code to word + meaning
# above I can find storykey using the chapternumber and create hash for each AppTextPath
if ($APPOn eq "yes" ) {
  for ($storynr = 0 ; $storynr < 99 ; $storynr++) {
    $ChapterAuthor = $ChapterAuthors[$storynr];
    if ($ChapterAuthor eq "") {
      $ChapterAuthor = $ChapterAuthors[0];
    }
    $AppTextPath = $ChapterAuthor."_".$STORIES[$storynr];
    if ($STORIES[$storynr] ne "") {
      $AppTextWordString = "\ï\»\¿\/\* globals console,document,window,cordova \*\/\nvar wordHash = \{\}\;\n".$AppTextWords{$AppTextPath};

      #print $AppTextWordString;
      if  ( $MAINLANG eq "" || $MAINLANG eq $Language || $HYPLERNKEYFILETEXT =~ "\_$AppTextPath\"" ) {
        $WriteFile = "..\\Cordova\\AppProjects\\".$HypLernPath."\\".$HypLernPath."\\www\\texts\\".$AppLangCode."\\".$AppTextPath."\\words.js";
        print "WriteFile is ".$WriteFile."\n";
        open (WRITEFILE, ">$WriteFile") || die "file $WriteFile kan niet worden aangemaakt, ($!)\n";
        print WRITEFILE $AppTextWordString ;
        close (WRITEFILE);
      }
    }
  }
  # create language.js specifically for this go in case of filled $MAINLANG
  if ($HypLernPath ne "HypLern" && $MAINLANG eq $Language) {
    $WriteFile = "..\\Cordova\\AppProjects\\".$HypLernPath."\\".$HypLernPath."\\www\\scripts\\language.js";
    $LanguageCodeScriptContents = "\ï\»\¿\/\* globals console,document,window,cordova \*\/\n// device, my very own one line device plugin\nvar device = \"android\";\n// language, only this language allows word practice\nvar language_code = \"".$MAINLANGCODE."\";\n";
    print "WriteFile is ".$WriteFile."\n";
    open (WRITEFILE, ">$WriteFile") || die "file $WriteFile kan niet worden aangemaakt, ($!)\n";
    print WRITEFILE $LanguageCodeScriptContents ;
    close (WRITEFILE);
  }
  # copy HypLern base scripts and css and all that
  if ($MAINLANG ne "" && $MAINLANG ne "HypLern") {
    # css
    $CSSTargetPath = "..\\Cordova\\AppProjects\\".$HypLernPath."\\".$HypLernPath."\\www\\css";
    `copy ..\\Cordova\\AppProjects\\HypLern\\HypLern\\www\\css\\*.css \"$CSSTargetPath\"`;
    # images
    $IMGTargetPath = "..\\Cordova\\AppProjects\\".$HypLernPath."\\".$HypLernPath."\\www\\images";
    `copy ..\\Cordova\\AppProjects\\HypLern\\HypLern\\www\\images\\* \"$IMGTargetPath\"`;
    # scripts
    $SCRTargetPath = "..\\Cordova\\AppProjects\\".$HypLernPath."\\".$HypLernPath."\\www\\scripts";
    `copy ..\\Cordova\\AppProjects\\HypLern\\HypLern\\www\\scripts\\hyplern.js \"$SCRTargetPath\"`;
    `copy ..\\Cordova\\AppProjects\\HypLern\\HypLern\\www\\scripts\\vocabulary.js \"$SCRTargetPath\"`;
    `copy ..\\Cordova\\AppProjects\\HypLern\\HypLern\\www\\scripts\\wanderhyplern.js \"$SCRTargetPath\"`;
    `copy ..\\Cordova\\AppProjects\\HypLern\\HypLern\\www\\scripts\\subhyplern.js \"$SCRTargetPath\"`;
    `copy ..\\Cordova\\AppProjects\\HypLern\\HypLern\\www\\scripts\\actions.js \"$SCRTargetPath\"`;
    `copy ..\\Cordova\\AppProjects\\HypLern\\HypLern\\www\\scripts\\menus.js \"$SCRTargetPath\"`;
    `copy ..\\Cordova\\AppProjects\\HypLern\\HypLern\\www\\scripts\\constants.js \"$SCRTargetPath\"`;
    `copy ..\\Cordova\\AppProjects\\HypLern\\HypLern\\www\\scripts\\options.js \"$SCRTargetPath\"`;
    `copy ..\\Cordova\\AppProjects\\HypLern\\HypLern\\www\\scripts\\index.js \"$SCRTargetPath\"`;
    `copy ..\\Cordova\\AppProjects\\HypLern\\HypLern\\www\\scripts\\platformOverrides.js \"$SCRTargetPath\"`;
    # index
    $INDTargetPath = "..\\Cordova\\AppProjects\\".$HypLernPath."\\".$HypLernPath."\\www";
    `copy ..\\Cordova\\AppProjects\\HypLern\\HypLern\\www\\vocabulary.html \"$INDTargetPath\"`;
    `copy ..\\Cordova\\AppProjects\\HypLern\\HypLern\\www\\wanderlust.html \"$INDTargetPath\"`;
    `copy ..\\Cordova\\AppProjects\\HypLern\\HypLern\\www\\about.html \"$INDTargetPath\"`;
    `copy ..\\Cordova\\AppProjects\\HypLern\\HypLern\\www\\index.html \"$INDTargetPath\"`;
  
    # replace <CENTER><B>HUNGARIAN</B></CENTER> in index file if you copy that one automatically too
    $ReadFile = "..\\Cordova\\AppProjects\\".$HypLernPath."\\".$HypLernPath."\\www\\index.html" ;
    open (READFILE, "$ReadFile") || die "file $ReadFile cannot be found. ($!)\n";
    @INDEXFILE = <READFILE>;
    close (READFILE);
    foreach $IndexFileLine (@INDEXFILE) {
      $IndexFileLine =~ s/\<CENTER\>\<B\>HUNGARIAN\<\/B\>\<\/CENTER\>/\<CENTER\>\<B\>$CapLanguage\<\/B\>\<\/CENTER\>/;
      push (@INDEXFILENEW,$IndexFileLine);
    }
    print "WriteFile is ".$ReadFile."\n";
    open (WRITEFILE, ">$ReadFile") || die "file $ReadFile kan niet worden aangemaakt, ($!)\n";
    print WRITEFILE "@INDEXFILENEW" ;
    close (WRITEFILE);
  
    # copy App icons and splash screens (groan)
    # main icon base
    #$IMGTargetPath = "..\\Cordova\\AppProjects\\".$HypLernPath."\\".$HypLernPath;
    #`xcopy /Y /E ..\\Cordova\\AppProjects\\HypLern\\HypLern\\res \"IMGTargetPath\"`;
    # built icon and screens per platform (first check if this is necessary, seemed to me that new build didn't overwrite old image files)
    # windows
    #$IMGTargetPath = "..\\Cordova\\AppProjects\\".$HypLernPath."\\".$HypLernPath."\\platforms\\windows\\images";
    #`copy ..\\Cordova\\AppProjects\\HypLern\\HypLern\\platforms\\windows\\images\\* \"IMGTargetPath\"`;
  }
  
}

# WORDFREQ EN WORDROOT KAN ME FF NIX MEER SCHELEN, MAAR ALS JE T ERIN WIL, HIERONDER IS DE CODE:


#$storynr = 1;
#print "@CHAPTERWORDS";

# HERE WE INJECT WORDFREQS (STORY-GROUP-ALL) INTO CLICK/SHOW ARGUMENTS
#
# in javascript these codes can be used to determine difficulty of word, best would be to whittle them down to root as well
#
# source data:
# app int/pnt text file: <!--42_3_10--><span class='text'><span id='a3_10' onclick="Show('a3_10','c3_10',1,2)" class='main'>gubancol&#243;dott</span>
# push(@ALLAPPWORDSUNSORTED, $ChapterNumber.",".$chapterandcounter.",".$originalnochapter.",".$lcoriginalnochapter.",".$lcoriginalnochapterroot.",".$ChapterNumber );
# ..\\..\\Languages\\$Language\\HTML\\$Group\\HypLernWordsAll.htm
# Make word file with hash of totalpages_chapterincltitle_wordnumbercounter to
# frequency_in_story and frequency_in_book and freqinallbooks?, ie 42_3_10::1_1_2 

#USE THESE HASHES!!! CALCERLATE A WORD LEVEL FROM THE THREE STORYWORDFREQS!!! HMM WELL ACTUALLY MAYBE JUST USE ALLWORDFREQ, ALL THOSE OCCURRING <10 WITHOUT KNOWN ROOT(?) 
       # get a hash of wordfreq per story for later use -> if wordfreq is only high in story, not in group or all, it means it's still rare in general
       #$STORYWORDFREQS{$lcoriginalnochapter,$ChapterNumber} = $STORYWORDFREQS{$lcoriginalnochapter,$ChapterNumber} + 1;
       
       # also get a hash of wordfreq per group -> if in a group, wordfreq is still low, it means either it is rare in general or even rare in a novel
       #$StoryGroup = $StoryGroups[$ChapterNumber]; # add this info to .bat if that still fits
       #$GROUPSTORYWORDFREQS{$originalnochapter,$StoryGroup} = $STORYWORDFREQS{$originalnochapter,$StoryGroup} + 1;
       
       # get a hash of wordfreq for all stories (this has to be re-run with every new story/group of stories), this also implies you create a megareader.bat for each language to produce this list/info
       #$ALLSTORYWORDFREQS{$lcoriginalnochapter} = $ALLSTORYWORDFREQS{$lcoriginalnochapter} + 1;

       # did we create a separate root? Then also make these root hashes, together calcerlate difficulty (unique word but with same root is medium, more words and more roots is easy, unique word unique root difficult, etc)
       #if ($lcoriginalnochapter ne $lcoriginalnochapterroot) {
       	 # fill story word root hash
         #$STORYWORDROOTFREQS{$lcoriginalnochapterroot,$ChapterNumber} = $STORYWORDFREQS{$lcoriginalnochapterroot,$ChapterNumber} + 1;
         # fill story group word root hash
         #$GROUPSTORYWORDROOTFREQS{$lcoriginalnochapterroot,$StoryGroup} = $GROUPSTORYWORDROOTFREQS{$lcoriginalnochapterroot,$StoryGroup} + 1;
         # also get a has of wordfreq for all stories per root
         #$ALLSTORYWORDROOTFREQS{$lcoriginalnochapterroot} = $ALLSTORYWORDFREQS{$lcoriginalnochapterroot} + 1;
       #}

# NOW FOR ALL APP WHOLE STORY FILES, ADD FREQ CODE
# for each story path (<Author>_<ChapterShortName>), possibly by using those arrays from the Make.bat arguments
#for ($storynr = 0 ; $storynr < 99 ; $storynr++) {
#  $AppTextPath = $ChapterAuthors[$storynr]."_".$STORIES[$storynr];
#  foreach $Kokos ("pop","int","pnt") {
#    foreach $Ananas ("all","man","aut") {
#      $ReadFile = "..\\Cordova\\AppProjects\\".$HypLernPath."\\".$HypLernPath."\\www\\texts\\".$AppLangCode."\\".$AppTextPath."\\text_".$Kokos."_".$Ananas.".htm" ;
#      open (READFILE, "$ReadFile") || die "file $ReadFile cannot be found. ($!)\n";
#      @ALLTEXT = <READFILE>;
#      close (READFILE);
#      $ALLTEXT = join ("",@ALLTEXT) ;
#      $lengthpagefile = @ALLTEXT;
      
      #print "\nNow going through the following file: ".$ReadFile." of length ".$lengthpagefile;
#      $storynrplusone = $storynr + 1;
#      @CHAPTERWORDS = split("\,$storynrplusone\,",$ALLAPPWORDS);
#      shift(@CHAPTERWORDS);
#      pop(@CHAPTERWORDS);
#      foreach $CHAPTERWORD (@CHAPTERWORDS) {
      	# now calculate the "level" of this word depending on word freq and word-root freq:
      	# story,group,all where x is >1 and y>x
      	# 1,1,1 means word is very rare
      	# x,x,x means word is story based, so still very rare
      	# x,y,y means word is group based, so medium to rare
      	# x,x,y means word occurs more if more text is supplied, medium to rare
      	# x,y,z means word occurs more if more text is supplied, so not rare, dependent on frequency abundant to medium
      	# 1,x,x means word is group based, so medium to rare
      	# 1,x,y means word occurs more if more text is supplied
      	# 1,1,x means word occurs more if more text is supplied, probably medium-rare
      	# 1,
#      	if ( $CHAPTERWORD ne ",") {
      	  
#      	}
#      }
      
      #print "\n$CHAPTERWORDS\n";
#      if ($Kokos eq "pop") {
#        # insert wordfreqs into this stuff: <!--6_2_0--><span class='text'><span id='a2_0' onclick="Show('a2_0','c2_0',1,2)" onmouseover="Show('a2_0','c2_0',1,2)" 
#        $ALLTEXT =~ s/onclick\=\"Show\(\'(\w+)\'\,\'(\w+)\'\,(\d+)\,(\d+)\)\" onmouseover\=\"Show\(\'(\w+)\'\,\'(\w+)\'\,(\d+)\,(\d+)\)\"/onclick\=\"Show\(\'$1\'\,\'$2\',$3\,$4\)\" onmouseover\=\"Show\(\'$1\'\,\'$2\',$3\,$4\)\"/g;
#      }
#      if ($Kokos eq "pnt" || $Kokos eq "int") {
#        # insert wordfreqs into this stuff: <!--6_2_1--><span class='text'><span id='a2_1' onclick="Show('a2_1','c2_1',1,2)" class='main'>L&#211;FI&#211;
#      }
#      $WriteFile = $ReadFile;
#      open (WRITEFILE, ">$WriteFile") || die "file $WriteFile kan niet worden aangemaakt, ($!)\n";
#      print WRITEFILE $ALLTEXT ;
#      close (WRITEFILE);
      
      # ehh now that we're done with the story-page, write each single page for performance pujposes :\ change javascript to reflect persistence option per-page
      # only way to make scrolling possible there is to add three-part-template........................................ check how Kindle does it, scroll down at end of page is next page
      # and every page a list of javascript objects, OR make the whole story a json file, of which the pages can be filled into the template parts
      
#    }
#  }
#}


# take editoptions and join
$CHAPTEREDITPAGES = join(//,@CHAPTEREDITPAGES);

# getting there, da holy grail
@ALLNEWWORDS = sort (@ALLNEWWORDSUNSORTED);
$ALLNEWWORDS = join("<BR>",@ALLNEWWORDS);
$ALLNEWWORDS = "<BR>".$ALLNEWWORDS."<BR>";
$ALLNEWWORDSNOCHAPTER = join("<BR>",@ALLNEWWORDSNOCHAPTER);
$ALLNEWWORDSNOCHAPTER = "<BR>".$ALLNEWWORDSNOCHAPTER."<BR>";

# now sort arrays
@ALLTESTWORDSDATABASE = sort (@ALLBASWORDSDATABASEUNSORTED);
@ALLCLICKWORDSDATABASE = sort (@ALLCLICKWORDSDATABASEUNSORTED);
@ALLTESTWORDSDATABASE = sort (@ALLTESTWORDSDATABASEUNSORTED);

# CALCULATE DIFFERENTLY SOMEHOW, THIS IS USELESS
#$MostHighestChapterNumbert = $HighestChapterNumbert + 1 ;
$MostHighestChapterNumbert = (@ChapterLastPages) + 1 ;
$CHAPTERTESTOPTIONS = join("\n",@CHAPTERTESTOPTIONS);
$CHAPTERNAMESJAVAVARS=$CHAPTERNAMESJAVAVARS."  ChapterName[0]=\"First Dummy Chapter\";\n";
$CHAPTERNAMESJAVAVARS=$CHAPTERNAMESJAVAVARS."  ChapterName[$MostHighestChapterNumbert]=\"Last Dummy Chapter\";\n";
$HeadpieceNumbert = 0;
foreach $ChapterLastPage(@ChapterLastPages)
{
  $ChapterLastPagePlusEnus = $ChapterLastPage + 1;
  $HeadpieceNumbert = $HeadpieceNumbert + 1;
  $CHAPTERNAMESJAVAVARS=$CHAPTERNAMESJAVAVARS."  ChapterLastPage[$HeadpieceNumbert]=".$ChapterLastPagePlusEnus.";\n";
}

# CREATE WORD DATABASE FILE WITH ALL DETAILS
$WriteFile = "..\\..\\Languages\\$Language\\HTML\\$Group\\Course".$Language.$Group."WordInfo.htm" ;
if ($TRACING eq "ON") {
  print "Creating File $WriteFile...\n" ;
} else { print "."; }
open (WRITEFILE, ">$WriteFile") || die "file $WriteFile kan niet worden aangemaakt, ($!)\n";
print WRITEFILE "<html>\n<BR><B>Number Of Words: </B>$TotalCounter<BR>\n<B>Number Of Unique Words: </B>$NumberOfUniqueWords<BR>\n<B>Number Of Words Per Chapter: </B><BR>\n@ChapterCounters<BR>\n@ALLBASWORDSDATABASEUNSORTED\n</html>\n" ;
close (WRITEFILE);

# CREATE WORD DATABASE FILE FOR DICTIONARY PURPOSES
if (-e "..\\..\\Dictionaries\\$Language") {
   #kont-in-you
} else {
   # veur deze tael is nog geun directory voor dictionairies, aanmaken
   `mkdir ..\\..\\Dictionaries\\$Language`;
   
}
$WriteFile = "..\\..\\Dictionaries\\$Language\\$TranToLanguage.$Language.$Group.htm" ;
if ($TRACING eq "ON") {
  print "Creating File $WriteFile...\n" ;
} else { print "."; }
open (WRITEFILE, ">$WriteFile") || die "file $WriteFile kan niet worden aangemaakt, ($!)\n";
$ALLBASWORDSDATABASE = "@ALLBASWORDSDATABASEUNSORTED";
$ALLBASWORDSDATABASE =~ s/<empty>/()/g;
$ALLBASWORDSDATABASE =~ s/<BR>//g;
$ALLBASWORDSDATABASE =~ s/&nbsp;/ /g;
$ALLBASWORDSDATABASE =~ s/ ;;/;;/g;
$ALLBASWORDSDATABASE =~ s/ ::/::/g;

#$ALLBASWORDSDATABASE =~ s/\*\~\@/\'/g;
print WRITEFILE "$ALLBASWORDSDATABASE" ;
close (WRITEFILE);

if ($DICCWORDON eq "YES")
{
  @DICCWORDSKEYS = keys %ALLDICCWORDS;

  @ALLDICCWORDS = sort (@DICCWORDSKEYS);
  $NumberOfUniqueWords = @ALLDICCWORDS;

  %seen = ();
  $CharTen = chr(10);
  foreach $item (@ALLDICCWORDS)
  {
    $ALLDICCWORDS{$item} =~ s/\*[0-9]{3}-[0-9]{5}\*//g;
    $ALLDICCWORDS{$item} =~ s/\*[0-9]{2}-[0-9]{5}\*//g;
    $ALLDICCWORDS{$item} =~ s/\*[0-9]{1}-[0-9]{5}\*//g;
    $ALLDICCWORDS{$item} =~ s/\*[0-9]{3}-[0-9]{4}\*//g;
    $ALLDICCWORDS{$item} =~ s/\*[0-9]{2}-[0-9]{4}\*//g;
    $ALLDICCWORDS{$item} =~ s/\*[0-9]{1}-[0-9]{4}\*//g;
    $ALLDICCWORDS{$item} =~ s/\*[0-9]{3}-[0-9]{3}\*//g;
    $ALLDICCWORDS{$item} =~ s/\*[0-9]{2}-[0-9]{3}\*//g;
    $ALLDICCWORDS{$item} =~ s/\*[0-9]{1}-[0-9]{3}\*//g;
    $ALLDICCWORDS{$item} =~ s/\*[0-9]{3}-[0-9]{2}\*//g;
    $ALLDICCWORDS{$item} =~ s/\*[0-9]{2}-[0-9]{2}\*//g;
    $ALLDICCWORDS{$item} =~ s/\*[0-9]{1}-[0-9]{2}\*//g;
    $ALLDICCWORDS{$item} =~ s/\*[0-9]{3}-[0-9]{1}\*//g;
    $ALLDICCWORDS{$item} =~ s/\*[0-9]{2}-[0-9]{1}\*//g;
    $ALLDICCWORDS{$item} =~ s/\*[0-9]{1}-[0-9]{1}\*//g;
    $ALLDICCWORDS{$item} =~ s/\*[0-9]{3}\_[0-9]{5}\*//g;
    $ALLDICCWORDS{$item} =~ s/\*[0-9]{2}\_[0-9]{5}\*//g;
    $ALLDICCWORDS{$item} =~ s/\*[0-9]{1}\_[0-9]{5}\*//g;
    $ALLDICCWORDS{$item} =~ s/\*[0-9]{3}\_[0-9]{4}\*//g;
    $ALLDICCWORDS{$item} =~ s/\*[0-9]{2}\_[0-9]{4}\*//g;
    $ALLDICCWORDS{$item} =~ s/\*[0-9]{1}\_[0-9]{4}\*//g;
    $ALLDICCWORDS{$item} =~ s/\*[0-9]{3}\_[0-9]{3}\*//g;
    $ALLDICCWORDS{$item} =~ s/\*[0-9]{2}\_[0-9]{3}\*//g;
    $ALLDICCWORDS{$item} =~ s/\*[0-9]{1}\_[0-9]{3}\*//g;
    $ALLDICCWORDS{$item} =~ s/\*[0-9]{3}\_[0-9]{2}\*//g;
    $ALLDICCWORDS{$item} =~ s/\*[0-9]{2}\_[0-9]{2}\*//g;
    $ALLDICCWORDS{$item} =~ s/\*[0-9]{1}\_[0-9]{2}\*//g;
    $ALLDICCWORDS{$item} =~ s/\*[0-9]{3}\_[0-9]{1}\*//g;
    $ALLDICCWORDS{$item} =~ s/\*[0-9]{2}\_[0-9]{1}\*//g;
    $ALLDICCWORDS{$item} =~ s/\*[0-9]{1}\_[0-9]{1}\*//g;
    if ($item !~ "\=\;" && $item !~ "\=\(\)\;") {
      push(@ALLDICCWORDSDATABASE, "\n".$item." => ".$ALLDICCWORDS{$item}."<BR>") unless $sheen{$item}++;
    }
  }

  # CREATE DICC WORD DATABASE FILE FOR DICTIONARY PURPOSES
  $WriteFile = "..\\..\\Dictionaries\\$DICCWORDLANGUAGE\\$TranToLanguage.$Language.$Group.htm" ;
  if ($TRACING eq "ON") {
    print "Creating File $WriteFile...\n" ;
  } else { print "."; }
  open (WRITEFILE, ">$WriteFile") || die "file $WriteFile kan niet worden aangemaakt, ($!)\n";
  $ALLDICCWORDSDATABASE = "@ALLDICCWORDSDATABASE";
  $ALLDICCWORDSDATABASE =~ s/<empty>/()/g;
  $ALLDICCWORDSDATABASE =~ s/<BR>//g;
  $ALLDICCWORDSDATABASE =~ s/&nbsp;/ /g;
  $ALLDICCWORDSDATABASE =~ s/ ;;/;;/g;
  $ALLDICCWORDSDATABASE =~ s/ ::/::/g;
  #$ALLDICCWORDSDATABASE =~ s/\*\~\@/\'/g;
  print WRITEFILE "$ALLDICCWORDSDATABASE" ;
  close (WRITEFILE);
}

if ($DICCWORDON eq "YES") {
	exit;
}

# CREATE WORD DATABASE FILE FOR CLICK PURPOSES
$WriteFile = "..\\..\\Languages\\$Language\\HTML\\$Group\\HypLernWordsAll.htm" ;
if ($TRACING eq "ON") {
  print "Creating File $WriteFile...\n" ;
} else { print "."; }
open (WRITEFILE, ">$WriteFile") || die "file $WriteFile kan niet worden aangemaakt, ($!)\n";
$ALLCLICKWORDSDATABASE = join($CharTen,@ALLCLICKWORDSDATABASE);
$ALLCLICKWORDSDATABASE =~ s/<empty>/()/g;
$ALLCLICKWORDSDATABASE =~ s/&nbsp;/ /g;
#$ALLCLICKWORDSDATABASE =~ s/\*\~\@/\'/g;
print WRITEFILE "<BR><B>Click Words (All)</B><BR><BR><BR>".$CharTen;
print WRITEFILE "<FORM style=\"border-top: 2px solid gray; border-right: 2px solid #DDDDDD; border-bottom: 2px solid #DDDDDD; border-left: 2px solid gray; width:<<<TABLEWIDTH>>>px; height:500px; overflow:auto; background-color: silver;\">".$CharTen;
print WRITEFILE "<!--DIVCHAR--><BR>".$CharTen;
print WRITEFILE "$ALLCLICKWORDSDATABASE".$CharTen;
print WRITEFILE "<!--DIVCHAR--><BR>".$CharTen;
print WRITEFILE "</FORM>".$CharTen;
close (WRITEFILE);

# CREATE WORD DATABASE FILE FOR TEST PURPOSES
$WriteFile = "..\\..\\Languages\\$Language\\HTML\\$Group\\HypLernWordsTst.htm" ;
if ($TRACING eq "ON") {
  print "Creating File $WriteFile...\n" ;
} else { print "."; }
open (WRITEFILE, ">$WriteFile") || die "file $WriteFile kan niet worden aangemaakt, ($!)\n";
$ALLTESTWORDSDATABASE = join($CharTen,@ALLTESTWORDSDATABASE);
$ALLTESTWORDSDATABASE =~ s/<empty>/()/g;
$ALLTESTWORDSDATABASE =~ s/&nbsp;/ /g;
#$ALLTESTWORDSDATABASE =~ s/\*\~\@/\'/g;
print WRITEFILE "<BR><B>Test Words (Only Unique Original=Meaning Combinations)</B><BR><BR><BR>".$CharTen;
print WRITEFILE "<FORM style=\"border-top: 2px solid gray; border-right: 2px solid #DDDDDD; border-bottom: 2px solid #DDDDDD; border-left: 2px solid gray; width:<<<TABLEWIDTH>>>px; height:500px; overflow:auto; background-color: silver;\">".$CharTen;
print WRITEFILE "<!--DIVCHAR--><BR>".$CharTen;
print WRITEFILE "$ALLTESTWORDSDATABASE".$CharTen;
print WRITEFILE "<!--DIVCHAR--><BR>".$CharTen;
print WRITEFILE "</FORM>".$CharTen;
close (WRITEFILE);

$WORDLISTFILES="TMP§KLIK§<<<WORDSDB>>>§HypLernWordsAll.htm§NO\nTMP§TEST§<<<WORDTST>>>§HypLernWordsTst.htm§NO\n";

# if Russian or Georgian, add wordlistfile for Phonetics
# change this to if $PhoneticLanguage eq "yes" 
if ($Language eq "Russian" || $Language eq "Georgian") {

  # CREATE WORD DATABASE PHILE FOR PHON / SCRIPT TEST PURPOSES
  $WriteFile = "..\\..\\Languages\\$Language\\HTML\\$Group\\HypLernPhonTst.htm" ;
  if ($TRACING eq "ON") {
    print "Creating File $WriteFile...\n" ;
  } else { print "."; }
  open (WRITEFILE, ">$WriteFile") || die "file $WriteFile kan niet worden aangemaakt, ($!)\n";
  $ALLPHONWORDSDATABASE = join($CharTen,@ALLPHONWORDSDATABASEUNSORTED);
  $ALLPHONWORDSDATABASE =~ s/<empty>/()/g;
  $ALLPHONWORDSDATABASE =~ s/&nbsp;/ /g;
  #$ALLPHONWORDSDATABASE =~ s/\*\~\@/\'/g;
  print WRITEFILE "<BR><B>Test Words (Only Unique Original=Phonetic Combinations)</B><BR><BR><BR>".$CharTen;
  print WRITEFILE "<FORM style=\"border-top: 2px solid gray; border-right: 2px solid #DDDDDD; border-bottom: 2px solid #DDDDDD; border-left: 2px solid gray; width:<<<TABLEWIDTH>>>px; height:500px; overflow:auto; background-color: silver;\">".$CharTen;
  print WRITEFILE "<!--DIVCHAR--><BR>".$CharTen;
  print WRITEFILE "$ALLPHONWORDSDATABASE".$CharTen;
  print WRITEFILE "<!--DIVCHAR--><BR>".$CharTen;
  print WRITEFILE "</FORM>".$CharTen;
  close (WRITEFILE);

  $WORDLISTFILES = $WORDLISTFILES."TMP§NONE§<<<PHONTST>>>§HypLernPhonTst.htm§NO\n";
}

#ADD TO WORDLISTFILES FOR PARSE
$ParseBaseFile = "../../Languages/$Language/HTML/Main/Parse.htm" ;
$ReadFile = $ParseBaseFile ;
open (READFILE, "$ReadFile") || die "file $ReadFile cannot be found. ($!)\n";
@ALLTEXT = <READFILE>;
close (READFILE);
$ALLTEXT = join ("",@ALLTEXT) ;
chop $WORDLISTFILES;
$ALLTEXT =~ s/<<<WORDLISTFILES>>>/$WORDLISTFILES/g;
$WriteFile = "..\\..\\Languages\\$Language\\HTML\\Main\\Parse.htm" ;
if ($TRACING eq "ON") {
  print "Creating File $WriteFile...\n" ;
} else { print "."; }
open (WRITEFILE, ">$WriteFile") || die "file $WriteFile kan niet worden aangemaakt, ($!)\n";
print WRITEFILE $ALLTEXT ;
close (WRITEFILE);

	

# this might be the time to think about getting roots

# HIER VOOR APP ZOOI TOEVOEGEN
# 1. woordcounters per chapter; total, unique, new
# 2. woordenlijsten van unique en/of new invoegen in story
# 2a.possibly for this create one huge product with all stories
# 3. flash card files
# 4. generic test files, contain all difficult words from file, randomize HTMLinside creation in top that makes the random chosen words visible (and testable)

if ($APPOn eq "yes") {
	        
  @IndexKeys = ("large","detail");
        
  foreach $IndexKey (@IndexKeys) {
  
    # create index file format name part
    $IndexKeyFileNamePart = "_".$IndexKey;
  
    # set sort key
    $SortedAppTextKey = "<author>_<story>";
    $SortedAppTextKey =~ s/\<author\>/$OriginalAuthor/;
    $SortedAppTextKey =~ s/\<story\>/$StoryFilename/;
    $SortedAppTextKey =~ s/ /\-/g;
  
    # open or init index file
    $IndexFile = "..\\Cordova\\AppProjects\\".$HypLernPath."\\".$HypLernPath."\\www\\texts\\$AppLangCode\\index".$IndexKeyFileNamePart.".html";
    open (READFILE, $IndexFile) || die "file $IndexFile cannot be found. ($!)\n";
    @INDEXTEXT = <READFILE>;
    $INDEXTEXT = "@INDEXTEXT";
    close (READFILE);
    
    $ChaptahNumbah = 0;
    foreach $ChapterFileCode (@ChapterFileNames) {
      $ChaptahNumbah = $ChaptahNumbah + 1;
      
      # REPLACE <CHAPTER>WORDCOUNTS with info from @ChapterCounters and @
      # push (@ChapterCounters,$ChapterCounter."\t".$CounterListChapterName."(".$counter.")<BR>");
      # $ALLUNIQUEWORDSPERCHAPTER[$ChapterNumber-1] = ($ALLUNIQUEWORDSPERCHAPTER[$ChapterNumber-1] + 1) unless $tdseen {$lcoriginalnochapter."(".$ChapterNumber.")"}++;

      ($Dimmy,$NumberOfWords,$Demmy) = split(/(|)/,$ChapterCounters[$ChaptahNumbah]);
      
      print "Replacing <<<$ChapterFileCode_APPWORDCOUNTCODE>>> with $NumberOfWords!\n";

      # for now leave it at number of words
      $INDEXTEXT =~ s/<<<$ChapterFileCode_APPWORDCOUNTCODE>>>/$NumberOfWords/g;
      
    }
        
    if ($TRACING eq "ON") {
      print "Creating File ..\\Cordova\\AppProjects\\".$HypLernPath."\\".$HypLernPath."\\www\\$IndexFile...!\n" ;
    } else { print "."; }
    open (WRITEFILE, ">$IndexFile") || die "file $IndexFile kan niet worden aangemaakt, ($!)\n";
    print WRITEFILE $INDEXTEXT ;
    close (WRITEFILE);
  }
      
  # now if APPOn is yes, build App, then rename file (if that works), for windows might need to temporarily rename the emulator package? not sure how else
    
  #exit 0;
}


if ($PDFOn eq "yes" && APPOn ne "yes") { exit 0; }   # for app we need same as software, ie wordlists




# HERE BE UNITS


       # for unit based system, only words that have a wordfreq of x or lower will need be practiced separately, namely 10 - x
       
       # when calcerlating (10 x ) re-reading of pages, subtract from word freq of each word on page, btw re-reading 150 pages x 10 is 1,500 pages to divide over 50 units, is 30 pages
       
       # calcerlate re-read pages per unit by giving each page a reading effort value of 10, or based on word freq max 10, or lower, then adding pages to unit diff number, for max unit re-read diff
       
       # for example, unit one consists of page 1-5 and re-reading page 1-5, and re-reading page 1-5 adds up to about 50 of word freq max difficulty
       # however when doing unit two, reading 1-10 adds only 0,9 for the first five, so leaves 0,5 room for some sentences :-)
       # twiet
       
       # think of something fun to add per unit to keep spirits up,
       # for example in unit one, add a guess of which words people now know if they were absolute beginner (a, az, egy)
       # or average (what, ev, er)
       
       # after having calcerlated the re-reading of all pages in all the units, evenly add pages with sentences
       

# eersjt maar eensj ff sjien hoe dit gaat met 
print "Phagina Scores! @PagesForUnitSystem\n";

print "Words for page 8:".$WordsForUnitSystem[8]."\n";
print "\n\nWords for page 140:".$WordsForUnitSystem[140]."\n\n\n";






# if LESSONS is on, quit
if ($LESSONS eq "yes") {
 exit 0;
}


# Add testpage shit to Menu and internationalise messaging
$UberFrameBaseFile = "..\\..\\Languages\\$Language\\HTML\\$Group\\Course".$filepart."Menu.htm" ;
$ReadFile = $UberFrameBaseFile ;
open (READFILE, "$ReadFile") || die "file $ReadFile cannot be found. ($!)\n";
@ALLTEXT = <READFILE>;
close (READFILE);
$ALLTEXT = join ("",@ALLTEXT) ;


#voeg phonetic test option toe als Russisch of Georgisch
if ($Language eq "Russian" || $Language eq "Georgian") {
  $PHONETICOPTION = "                  <option value= 'LAYOUTTESTINPHONTST§ALL§§12'    ><<<Test Phonetics>>></option>";
  $CHAPTERTESTOPTIONS = $PHONETICOPTION.$CHAPTERTESTOPTIONS;
  # now in place where {phonetic} is added, also dump to file!
}


#vervang <<<CHAPTERTESTOPTIONS>>> door alle options
$ALLTEXT =~ s/<<<CHAPTERTESTOPTIONS>>>/$CHAPTERTESTOPTIONS/;

# if editable add Editing
if ($EDITABLE eq "YES") {
  $EDITINGOPTION = "<option value='LAYOUTSINGLEEDIT'       ><<<Editing>>></option>\n";
  $ALLTEXT =~ s/<<<EDITINGOPTION>>>/$EDITINGOPTION/;
}

#translate help, information and messaging
foreach $MessTransEntry (@MessTransEntries)
{
  @MessTransLine = split(/#/,$MessTransEntry);
  $MessGrep = $MessTransLine[0];
  $MessChange = $MessTransLine[$TLN];
  if ($ALLTEXT =~ $MessGrep)
  {
    $ALLTEXT =~ s/$MessGrep/$MessChange/g;
    if ($TRACING eq "ON") {
      print "$MessTransLine[0] to $MessTransLine[$TLN]\n";
    } else { print ".";}
  }
}
$WriteFile = $UberFrameBaseFile ;
if ($TRACING eq "ON") {
  print "Creating File $WriteFile...\n" ;
} else { print "."; }
open (WRITEFILE, ">$WriteFile") || die "file $WriteFile kan niet worden aangemaakt, ($!)\n";
print WRITEFILE $ALLTEXT ;
close (WRITEFILE);


#Create MainEditMenu page with framesets
# CREATIE VAN GROUP MAIN TEXT (het Main Frame met text en top menu frame erin) VOOR EDIT
$ReadFile = "../Base/HTML/Main/HTMLTemplate_GroupMainEditMenu.htm" ;
open (READFILE, "$ReadFile") || die "file $ReadFile cannot be found. ($!)\n";
@ALLTEXT = <READFILE>;
close (READFILE);
$ALLTEXT = join ("",@ALLTEXT) ;

#choose text style
$ALLTEXT =~ s/<<<CHARSET>>>/$CHARSET/;
$ALLTEXT =~ s/<<<FONTFAMILY>>>/$FONTFAMILY/g;
$ALLTEXT =~ s/<<<LANGUAGE>>>/$LA/g;
$ALLTEXT =~ s/<<<BASEHTMLFILEPART>>>/$FILEBASE/g;
$ALLTEXT =~ s/<<<MAINGROUP>>>/$MainGroup/g;
$ALLTEXT =~ s/<<<GROUP>>>/$Group/g;
$ALLTEXT =~ s/<<<LONGLANG>>>/$Language/g;

# if editable add Editing
if ($EDITABLE eq "YES") {
  $EDITINGOPTION = "<option value='LAYOUTSINGLEEDIT'       ><<<Editing>>></option>\n";
  $ALLTEXT =~ s/<<<EDITINGOPTION>>>/$EDITINGOPTION/;
}

#translate help, information and messaging
$MessagingTranslationFile = "..\\Base\\Parse\\Main\\Messages.htm" ;
open (MESSTRANS, "<$MessagingTranslationFile") || die "file $MessagingTranslationFile kan niet worden gevonden, ($!)\n";
@MessTransEntries = <MESSTRANS>;
close MESSTRANS;
if ($TRACING eq "ON") {
  print "To internationalise information, help and other messaging, change all occurrences of:\n";
} else { print "."; }
foreach $MessTransEntry (@MessTransEntries)
{
  @MessTransLine = split(/#/,$MessTransEntry);
  $MessGrep = $MessTransLine[0];
  $MessChange = $MessTransLine[$TLN];
  if ($ALLTEXT =~ $MessGrep)
  {
    $ALLTEXT =~ s/$MessGrep/$MessChange/g;
    if ($TRACING eq "ON") {
      print "$MessTransLine[0] to $MessTransLine[$TLN]\n";
    } else { print "."; }
  }
}

$WriteFile = "..\\..\\Languages\\$Language\\HTML\\$Group\\Course".$filepart."MainEditMenu.htm" ;
if ($TRACING eq "ON") {
  print "Creating File $WriteFile...\n" ;
} else { print "."; }
open (WRITEFILE, ">$WriteFile") || die "file $WriteFile kan niet worden aangemaakt, ($!)\n";
print WRITEFILE $ALLTEXT ;
close (WRITEFILE);


#Create MainSmallMenu page with framesets
# CREATIE VAN GROUP MAIN TEXT (het Main Frame met text en top menu frame erin)
$ReadFile = "../Base/HTML/Main/HTMLTemplate_GroupMainSmallMenu.htm" ;
open (READFILE, "$ReadFile") || die "file $ReadFile cannot be found. ($!)\n";
@ALLTEXT = <READFILE>;
close (READFILE);
$ALLTEXT = join ("",@ALLTEXT) ;

#choose text style
$ALLTEXT =~ s/<<<CHARSET>>>/$CHARSET/;
$ALLTEXT =~ s/<<<FONTFAMILY>>>/$FONTFAMILY/g;
$ALLTEXT =~ s/<<<LANGUAGE>>>/$LA/g;
$ALLTEXT =~ s/<<<BASEHTMLFILEPART>>>/$FILEBASE/g;
$ALLTEXT =~ s/<<<MAINGROUP>>>/$MainGroup/g;
$ALLTEXT =~ s/<<<GROUP>>>/$Group/g;
$ALLTEXT =~ s/<<<LONGLANG>>>/$Language/g;

#vervang <<<CHAPTERTESTOPTIONS>>> door alle options
$ALLTEXT =~ s/<<<CHAPTERTESTOPTIONS>>>/$CHAPTERTESTOPTIONS/;

# if editable add Editing
if ($EDITABLE eq "YES") {
  $EDITINGOPTION = "<option value='LAYOUTSINGLEEDIT'       ><<<Editing>>></option>\n";
  $ALLTEXT =~ s/<<<EDITINGOPTION>>>/$EDITINGOPTION/;
}

#translate help, information and messaging
$MessagingTranslationFile = "..\\Base\\Parse\\Main\\Messages.htm" ;
open (MESSTRANS, "<$MessagingTranslationFile") || die "file $MessagingTranslationFile kan niet worden gevonden, ($!)\n";
@MessTransEntries = <MESSTRANS>;
close MESSTRANS;
if ($TRACING eq "ON") {
  print "To internationalise information, help and other messaging, change all occurrences of:\n";
} else { print "."; }
foreach $MessTransEntry (@MessTransEntries)
{
  @MessTransLine = split(/#/,$MessTransEntry);
  $MessGrep = $MessTransLine[0];
  $MessChange = $MessTransLine[$TLN];
  if ($ALLTEXT =~ $MessGrep)
  {
    $ALLTEXT =~ s/$MessGrep/$MessChange/g;
    if ($TRACING eq "ON") {
      print "$MessTransLine[0] to $MessTransLine[$TLN]\n";
    } else { print "."; }
  }
}

$WriteFile = "..\\..\\Languages\\$Language\\HTML\\$Group\\Course".$filepart."MainSmallMenu.htm" ;
if ($TRACING eq "ON") {
  print "Creating File $WriteFile...\n" ;
} else { print "."; }
open (WRITEFILE, ">$WriteFile") || die "file $WriteFile kan niet worden aangemaakt, ($!)\n";
print WRITEFILE $ALLTEXT ;
close (WRITEFILE);


#ADD $CHAPTERNAMESJAVAVARS TO JAVAMAP FILE
$JavaBaseFile = "../../Languages/$Language/HTML/Main/JavaMap.htm" ;
$ReadFile = $JavaBaseFile ;
open (READFILE, "$ReadFile") || die "file $ReadFile cannot be found. ($!)\n";
@ALLTEXT = <READFILE>;
close (READFILE);
$ALLTEXT = join ("",@ALLTEXT) ;
$ALLTEXT =~ s/<<<CHAPTERNAMESJAVAVARS>>>/$CHAPTERNAMESJAVAVARS/g;
if ($TranToLanguage ne "English")
{
  $ALLTEXT =~ s/<<<TRANLANGOTHERTHANENG>>>/$TranToLanguage/g;
}
else
{
  $ALLTEXT =~ s/<<<TRANLANGOTHERTHANENG>>>//g;
}
$WriteFile = $JavaBaseFile ;
if ($TRACING eq "ON") {
  print "Creating File $WriteFile...\n" ;
} else { print "."; }
open (WRITEFILE, ">$WriteFile") || die "file $WriteFile kan niet worden aangemaakt, ($!)\n";
print WRITEFILE $ALLTEXT ;
close (WRITEFILE);


#ADD $CHAPTERNAMESJAVAVARS TO HypLernTest FILE
$TestBaseFile = "../../Languages/$Language/HTML/Main/HypLernTest.htm" ;
$ReadFile = $TestBaseFile ;
open (READFILE, "$ReadFile") || die "file $ReadFile cannot be found. ($!)\n";
@ALLTEXT = <READFILE>;
close (READFILE);
$ALLTEXT = join ("",@ALLTEXT) ;
$ALLTEXT =~ s/<<<CHAPTERNAMESJAVAVARS>>>/$CHAPTERNAMESJAVAVARS/g;
if ($TranToLanguage ne "English")
{
  $ALLTEXT =~ s/<<<TRANLANGOTHERTHANENG>>>/$TranToLanguage/g;
}
else
{
  $ALLTEXT =~ s/<<<TRANLANGOTHERTHANENG>>>//g;
}
$WriteFile = $TestBaseFile ;
if ($TRACING eq "ON") {
  print "Creating File $WriteFile...\n" ;
} else { print "."; }
open (WRITEFILE, ">$WriteFile") || die "file $WriteFile kan niet worden aangemaakt, ($!)\n";
print WRITEFILE $ALLTEXT ;
close (WRITEFILE);



foreach $UNIQUEBASWORD(@ALLBASWORDS)
{
   #if russian, should begin with lower case Russian character, so 1040 - 1070
   if ($Language eq "Russian")
   {
   	  #get unicode from first russian char
  	  $FIRSTCHARBASWORDUNICODE = substr ($UNIQUEBASWORD,2,4);
      if ($FIRSTCHARBASWORDUNICODE > 1039 && $FIRSTCHARBASWORDUNICODE < 1072)
      {
         push(@ALLUNIQUEBASWORDS,$UNIQUEBASWORD."<BR>\n");
      }
   }
   else
   {
   	  push(@ALLUNIQUEBASWORDS,$UNIQUEBASWORD."<BR>\n");
   }
   
   #urdu heeft geen hoofdletters
}

# CREATE WORD LIST WITH ALL UNIQUE WORDS IN LOWERCASE (KEYS OF WORD DATABASE FILE)
#$WriteFile = "..\\..\\Languages\\$Language\\HTML\\$Group\\Course".$Language.$Group."WordKeys.htm" ;
#print "Creating File $WriteFile...\n" ;
#open (WRITEFILE, ">$WriteFile") || die "file $WriteFile kan niet worden aangemaakt, ($!)\n";
#print WRITEFILE "<html>\n<BR>\n@ALLUNIQUEBASWORDS\n</html>\n" ;
#close (WRITEFILE);


#Copy Test page 
$ReadFile = "..\\..\\Languages\\$Language\\HTML\\Main\\HypLernTest.htm" ;
open (READFILE, "$ReadFile") || die "file $ReadFile cannot be found. ($!)\n";
@ALLTEXT = <READFILE>;
close (READFILE);
$ALLTEXT = join ("",@ALLTEXT) ;
#choose text style
$ALLTEXT =~ s/<<<CHARSET>>>/$CHARSET/;
$ALLTEXT =~ s/<<<FONTFAMILY>>>/$FONTFAMILY/g;
$ALLTEXT =~ s/<<<LANGUAGE>>>/$LA/g;
$ALLTEXT =~ s/<<<BASEHTMLFILEPART>>>/$FILEBASE/g;
$ALLTEXT =~ s/<<<MAINGROUP>>>/$MainGroup/g;
$ALLTEXT =~ s/<<<GROUP>>>/$Group/g;
$ALLTEXT =~ s/<<<LONGLANG>>>/$Language/g;
#translate help, information and messaging
$MessagingTranslationFile = "..\\Base\\Parse\\Main\\Messages.htm" ;
open (MESSTRANS, "<$MessagingTranslationFile") || die "file $MessagingTranslationFile kan niet worden gevonden, ($!)\n";
@MessTransEntries = <MESSTRANS>;
close MESSTRANS;
if ($TRACING eq "ON") {
  print "To internationalise information, help and other messaging, change all occurrences of:\n";
} else { print "."; }
foreach $MessTransEntry (@MessTransEntries)
{
  @MessTransLine = split(/#/,$MessTransEntry);
  $MessGrep = $MessTransLine[0];
  $MessChange = $MessTransLine[$TLN];
  if ($ALLTEXT =~ $MessGrep)
  {
    $ALLTEXT =~ s/$MessGrep/$MessChange/g;
    if ($TRACING eq "ON") {
      print "$MessTransLine[0] to $MessTransLine[$TLN]\n";
    } else { print "."; }
  }
}
$WriteFile = "..\\..\\Languages\\$Language\\HTML\\Main\\HypLernTest.htm" ;
if ($TRACING eq "ON") {
  print "Creating File $WriteFile...\n" ;
} else { print "."; }
open (WRITEFILE, ">$WriteFile") || die "file $WriteFile kan niet worden aangemaakt, ($!)\n";
print WRITEFILE $ALLTEXT ;
close (WRITEFILE);


# copy security and other files (you can later add extra detail to it if you wish)
if ($TRACING eq "ON") {
  print "Copying Help$FilenameLanguage.htm, ";
} else { print "."; }
`copy ..\\Base\\Extra\\Help$FilenameLanguage.htm ..\\..\\Languages\\$Language\\HTML\\Main\\Help$FilenameLanguage.htm`;

if ($TRACING eq "ON") {
  print "About$FilenameLanguage.htm, ";
} else { print "."; }
`copy ..\\Base\\Extra\\About$FilenameLanguage.htm ..\\..\\Languages\\$Language\\HTML\\Main\\About$FilenameLanguage.htm`;
  
if ($TRACING eq "ON") {
  print "Usage$FilenameLanguage.htm, ";
} else { print "."; }
`copy ..\\Base\\Extra\\Usage$FilenameLanguage.htm ..\\..\\Languages\\$Language\\HTML\\Main\\Usage$FilenameLanguage.htm`;
  
if ($TRACING eq "ON") {
  print "Progress$FilenameLanguage.htm, ";
} else { print "."; }
`copy ..\\Base\\Extra\\Progress$FilenameLanguage.htm ..\\..\\Languages\\$Language\\HTML\\Main\\Progress$FilenameLanguage.htm`;

if ($TRACING eq "ON") {
  print "ChapterDone$FilenameLanguage.htm, ";
} else { print "."; }
`copy ..\\Base\\Extra\\ChapterDone$FilenameLanguage.htm ..\\..\\Languages\\$Language\\HTML\\Main\\ChapterDone$FilenameLanguage.htm`;

if ($TRACING eq "ON") {
  print "Finished$FilenameLanguage.htm, ";
} else { print "."; }
`copy ..\\Base\\Extra\\Finished$FilenameLanguage.htm ..\\..\\Languages\\$Language\\HTML\\Main\\Finished$FilenameLanguage.htm`;

if ($TRACING eq "ON") {
  print "Method$FilenameLanguage.htm and ";
} else { print "."; }
`copy ..\\Base\\Extra\\Method$FilenameLanguage.htm ..\\..\\Languages\\$Language\\HTML\\Main\\Method$FilenameLanguage.htm`;

if ($TRACING eq "ON") {
  print "Settings.htm and ";
} else { print "."; }
`copy ..\\Base\\Extra\\Settings.htm ..\\..\\Languages\\$Language\\HTML\\Main\\Settings.htm`;

if ($TRACING eq "ON") {
  print "Editing.htm and ";
} else { print "."; }
`copy ..\\Base\\Extra\\Editing.htm ..\\..\\Languages\\$Language\\HTML\\Main\\Editing.htm`;

for ($MANUALCHAPTERFILENUMBER=0;$MANUALCHAPTERFILENUMBER < $MostHighestChapterNumbert; $MANUALCHAPTERFILENUMBER++) {
  $ManualChapterShortName = $ChapterShortNames[$MANUALCHAPTERFILENUMBER].".htm";
  if ($TRACING eq "ON") {
    print "editable file ..\\..\\Languages\\$Language\\Manual\\$Group\\$ManualChapterShortName and ";
  } else { print "."; }
  `copy ..\\..\\Languages\\$Language\\Manual\\$Group\\$ManualChapterShortName ..\\..\\Languages\\$Language\\HTML\\Main\\$ManualChapterShortName`;
}

if ($TRACING eq "ON") {
  print "Erandsrs$FilenameLanguage.htm and ";
} else { print "."; }
`copy ..\\Base\\Extra\\Erandsrs$FilenameLanguage.htm ..\\..\\Languages\\$Language\\HTML\\Main\\Erandsrs$FilenameLanguage.htm`;

if ($TRACING eq "ON") {
  print "MyWords$FilenameLanguage.htm and ";
} else { print "."; }
`copy ..\\Base\\Extra\\MyWords$FilenameLanguage.htm ..\\..\\Languages\\$Language\\HTML\\Main\\MyWords$FilenameLanguage.htm`;

if ($TRACING eq "ON") {
  print "HypLernWords.htm...\n";
} else { print "."; }
`copy ..\\Base\\Extra\\HypLernWords.htm ..\\..\\Languages\\$Language\\HTML\\Main\\HypLernWords.htm`;

# Add first half of second page of this book if containing pop-ups to the help section:
$TheHelpFile = "..\\..\\Languages\\$Language\\HTML\\Main\\Help".$FilenameLanguage.".htm" ;
$ReadFile = $TheHelpFile ;
open (READFILE, "$ReadFile") || die "file $ReadFile cannot be found. ($!)\n";
@ALLTEXT = <READFILE>;
close (READFILE);
$ALLTEXT = join ("",@ALLTEXT) ;
($DUMMY,$FIRSTPAGETEXTSAVEDFORHELPTEXT) = split(/\<\/p\>\n /,$FIRSTPAGETEXTSAVEDFORHELP);
($FIRSTPAGETEXTSAVEDFORHELPTEXTFIRSTLINE,$DUMMY) = split(/R\./,$FIRSTPAGETEXTSAVEDFORHELPTEXT);
$FIRSTPAGETEXTSAVEDFORHELPTEXTFIRSTLINEPLUSENDANDNONBR = "<DIV style='text-align: justify; border: 1pt solid black'>".$FIRSTPAGETEXTSAVEDFORHELPTEXTFIRSTLINE."R\.</DIV>";
$ALLTEXT =~ s/<<<POPUPEXAMPLECODE>>>/$FIRSTPAGETEXTSAVEDFORHELPTEXTFIRSTLINEPLUSENDANDNONBR/g;
# vervang dit: STD§NONE§¶L§ href='DUMMY' onclick="BoterGeultje('CLK§YES
# verwijs naar ander script wat iets anders of nix doet met het weurd, wellicht bv een nep woordlijstje :-)
$ALLTEXT =~ s/\¶L/ href\=\'DUMMY\' onclick\=\"HoningPotje\(\'CLK/g;
$ALLTEXT =~ s/\¶M/\'\)\" onmouseover\=\"ShowHelp\(\'a/g;
$ALLTEXT =~ s/\¶O/\'\)\" onmouseout\=\"HideHelp\(\'c/g;
$ALLTEXT =~ s/<<<CUSTOMCODES>>>//g;
foreach $MessTransEntry (@MessTransEntries)
{
  @MessTransLine = split(/#/,$MessTransEntry);
  $MessGrep = $MessTransLine[0];
  $MessChange = $MessTransLine[$TLN];
  if ($ALLTEXT =~ $MessGrep)
  {
    $ALLTEXT =~ s/$MessGrep/$MessChange/g;
    if ($TRACING eq "ON") {
      print "$MessTransLine[0] to $MessTransLine[$TLN]\n";
    } else { print "."; }
  }
}
$WriteFile = $TheHelpFile ;
if ($TRACING eq "ON") {
  print "Creating File $WriteFile...\n" ;
} else { print "."; }
open (WRITEFILE, ">$WriteFile") || die "file $WriteFile kan niet worden aangemaakt, ($!)\n";
print WRITEFILE $ALLTEXT ;
close (WRITEFILE);


# Add parse of above "about" file for number of words by $TotalCounter and number of unique words by $NumberOfUniqueWords...
$TheAboutFile = "..\\..\\Languages\\$Language\\HTML\\Main\\About".$FilenameLanguage.".htm" ;
$ReadFile = $TheAboutFile ;
open (READFILE, "$ReadFile") || die "file $ReadFile cannot be found. ($!)\n";
@ALLTEXT = <READFILE>;
close (READFILE);
$ALLTEXT = join ("",@ALLTEXT) ;
#vervang <<<TOTALNUMBEROFWORDSINSTORY>>> en <<<UNIQUEWORDSINSTORY>>> door $TotalCounter en $NumberOfUniqueWords 
if ($Group =~ "Demo") {
  $OriginalGroup = $Group;
  $OriginalGroup =~ s/Demo//g;
  ###################################################################################
  # GET SOME DATA
  # read total and unique word count from original "about" file...
  $TheOriginalAboutFile = "..\\..\\Tool\\System\\$Language\\$OriginalGroup\\About.htm" ;
  open (ABOUTFILE, "$TheOriginalAboutFile") || die "file $TheOriginalAboutFile cannot be found. ($!)\n";
  @ABOUTTEXT = <ABOUTFILE>;
  close (ABOUTFILE);
  $ABOUTTEXT = join ("",@ABOUTTEXT) ;
  ($GEEUW,$TotalWordCountDemo,$GAAP) = split(/product of\&nbsp\;\&nbsp\;\<B\>\<FONT COLOR\=\"\#0000FF\"\>|\<\/FONT\> words in/,$ALLTEXT) ;
  ($GEEUW,$UniqueWordsDemo,$GAAP) = split(/mastered \<FONT COLOR\=\"\#0000FF\"\>|\<\/FONT\> unique words/,$ALLTEXT);

  $ALLTEXT =~ s/<<<TOTALNUMBEROFWORDSINSTORY>>>/$TotalWordCountDemo/;
  $ALLTEXT =~ s/<<<UNIQUEWORDSINSTORY>>>/$UniqueWordsDemo/;
} else {
  $ALLTEXT =~ s/<<<TOTALNUMBEROFWORDSINSTORY>>>/$TotalCounter/;
  $ALLTEXT =~ s/<<<UNIQUEWORDSINSTORY>>>/$NumberOfUniqueWords/;
}
foreach $MessTransEntry (@MessTransEntries)
{
  @MessTransLine = split(/#/,$MessTransEntry);
  $MessGrep = $MessTransLine[0];
  $MessChange = $MessTransLine[$TLN];
  if ($ALLTEXT =~ $MessGrep)
  {
    $ALLTEXT =~ s/$MessGrep/$MessChange/g;
    if ($TRACING eq "ON") {
      print "$MessTransLine[0] to $MessTransLine[$TLN]\n";
    } else { print "."; }
  }
}
$WriteFile = $TheAboutFile ;
if ($TRACING eq "ON") {
  print "Creating File $WriteFile...\n" ;
} else { print "."; }
open (WRITEFILE, ">$WriteFile") || die "file $WriteFile kan niet worden aangemaakt, ($!)\n";
print WRITEFILE $ALLTEXT ;
close (WRITEFILE);
# if not Demo backup about file containing the original product's actual number of words and stuff
if ($Group !~ "Demo") {
  `mkdir "..\\..\\Tool\\System\\$Language"`;
  `mkdir "..\\..\\Tool\\System\\$Language\\$Group"`;
  `copy $TheAboutFile ..\\..\\Tool\\System\\$Language\\$Group\\About.htm"`;
}

# Make word info file
$ALLTEXT = "<<<TOTALWORDS>>>".$TotalCounter."<<<TOTALWORDS>>><<<UNIQUEWORDS>>>".$NumberOfUniqueWords."<<<UNIQUEWORDS>>>";
$WriteFile = "..\\..\\Languages\\$Language\\HTML\\Main\\Info.htm" ;
if ($TRACING eq "ON") {
  print "Creating File $WriteFile...\n" ;
} else { print "."; }
open (WRITEFILE, ">$WriteFile") || die "file $WriteFile kan niet worden aangemaakt, ($!)\n";
print WRITEFILE $ALLTEXT ;
close (WRITEFILE);

# Add parse of "usage" file for back to book message...
$TheUsageFile = "..\\..\\Languages\\$Language\\HTML\\Main\\Usage".$FilenameLanguage.".htm" ;
$ReadFile = $TheUsageFile ;
open (READFILE, "$ReadFile") || die "file $ReadFile cannot be found. ($!)\n";
@ALLTEXT = <READFILE>;
close (READFILE);
$ALLTEXT = join ("",@ALLTEXT) ;
foreach $MessTransEntry (@MessTransEntries)
{
  @MessTransLine = split(/#/,$MessTransEntry);
  $MessGrep = $MessTransLine[0];
  $MessChange = $MessTransLine[$TLN];
  if ($ALLTEXT =~ $MessGrep)
  {
    $ALLTEXT =~ s/$MessGrep/$MessChange/g;
    if ($TRACING eq "ON") {
      print "$MessTransLine[0] to $MessTransLine[$TLN]\n";
    } else { print "#"; }
  }
}
$WriteFile = $TheUsageFile ;
if ($TRACING eq "ON") {
  print "Creating File $WriteFile...\n" ;
} else { print "."; }
open (WRITEFILE, ">$WriteFile") || die "file $WriteFile kan niet worden aangemaakt, ($!)\n";
print WRITEFILE $ALLTEXT ;
close (WRITEFILE);

# Add parse of "Erandsrs" file for back to book message...
$TheErandsrsFile = "..\\..\\Languages\\$Language\\HTML\\Main\\Erandsrs".$FilenameLanguage.".htm" ;
$ReadFile = $TheErandsrsFile ;
open (READFILE, "$ReadFile") || die "file $ReadFile cannot be found. ($!)\n";
@ALLTEXT = <READFILE>;
close (READFILE);
$ALLTEXT = join ("",@ALLTEXT) ;
foreach $MessTransEntry (@MessTransEntries)
{
  @MessTransLine = split(/#/,$MessTransEntry);
  $MessGrep = $MessTransLine[0];
  $MessChange = $MessTransLine[$TLN];
  if ($ALLTEXT =~ $MessGrep)
  {
    $ALLTEXT =~ s/$MessGrep/$MessChange/g;
    if ($TRACING eq "ON") {
      print "$MessTransLine[0] to $MessTransLine[$TLN]\n";
    } else { print "#"; }
  }
}
$WriteFile = $TheErandsrsFile ;
if ($TRACING eq "ON") {
  print "Creating File $WriteFile...\n" ;
} else { print "."; }
open (WRITEFILE, ">$WriteFile") || die "file $WriteFile kan niet worden aangemaakt, ($!)\n";
print WRITEFILE $ALLTEXT ;
close (WRITEFILE);

# Add parse of "Words" file for back to book message...
$TheWordsFile = "..\\..\\Languages\\$Language\\HTML\\Main\\HypLernWords.htm" ;
$ReadFile = $TheWordsFile ;
open (READFILE, "$ReadFile") || die "file $ReadFile cannot be found. ($!)\n";
@ALLTEXT = <READFILE>;
close (READFILE);
$ALLTEXT = join ("",@ALLTEXT) ;
foreach $MessTransEntry (@MessTransEntries)
{
  @MessTransLine = split(/#/,$MessTransEntry);
  $MessGrep = $MessTransLine[0];
  $MessChange = $MessTransLine[$TLN];
  if ($ALLTEXT =~ $MessGrep)
  {
    $ALLTEXT =~ s/$MessGrep/$MessChange/g;
    if ($TRACING eq "ON") {
      print "$MessTransLine[0] to $MessTransLine[$TLN]\n";
    } else { print "#"; }
  }
}
$WriteFile = $TheWordsFile ;
if ($TRACING eq "ON") {
  print "Creating File $WriteFile...\n" ;
} else { print "."; }
open (WRITEFILE, ">$WriteFile") || die "file $WriteFile kan niet worden aangemaakt, ($!)\n";
print WRITEFILE $ALLTEXT ;
close (WRITEFILE);


# Add parse of "My Words" Info file for back to book message...
$TheMyWordsInfoFile = "..\\..\\Languages\\$Language\\HTML\\Main\\MyWords$FilenameLanguage.htm" ;
$ReadFile = $TheMyWordsInfoFile ;
open (READFILE, "$ReadFile") || die "file $ReadFile cannot be found. ($!)\n";
@ALLTEXT = <READFILE>;
close (READFILE);
$ALLTEXT = join ("",@ALLTEXT) ;
foreach $MessTransEntry (@MessTransEntries)
{
  @MessTransLine = split(/#/,$MessTransEntry);
  $MessGrep = $MessTransLine[0];
  $MessChange = $MessTransLine[$TLN];
  if ($ALLTEXT =~ $MessGrep)
  {
    $ALLTEXT =~ s/$MessGrep/$MessChange/g;
    if ($TRACING eq "ON") {
      print "$MessTransLine[0] to $MessTransLine[$TLN]\n";
    } else { print "."; }
  }
}
$WriteFile = $TheMyWordsInfoFile ;
if ($TRACING eq "ON") {
  print "Creating File $WriteFile...\n" ;
} else { print "."; }
open (WRITEFILE, ">$WriteFile") || die "file $WriteFile kan niet worden aangemaakt, ($!)\n";
print WRITEFILE $ALLTEXT ;
close (WRITEFILE);


# Add parse of "method" file for back to book message...
$TheMethodFile = "..\\..\\Languages\\$Language\\HTML\\Main\\Method".$FilenameLanguage.".htm" ;
$ReadFile = $TheMethodFile ;
open (READFILE, "$ReadFile") || die "file $ReadFile cannot be found. ($!)\n";
@ALLTEXT = <READFILE>;
close (READFILE);
$ALLTEXT = join ("",@ALLTEXT) ;
foreach $MessTransEntry (@MessTransEntries)
{
  @MessTransLine = split(/#/,$MessTransEntry);
  $MessGrep = $MessTransLine[0];
  $MessChange = $MessTransLine[$TLN];
  if ($ALLTEXT =~ $MessGrep)
  {
    $ALLTEXT =~ s/$MessGrep/$MessChange/g;
    if ($TRACING eq "ON") {
      print "$MessTransLine[0] to $MessTransLine[$TLN]\n";
    } else { print "."; }
  }
}
$WriteFile = $TheMethodFile ;
if ($TRACING eq "ON") {
  print "Creating File $WriteFile...\n" ;
} else { print "."; }
open (WRITEFILE, ">$WriteFile") || die "file $WriteFile kan niet worden aangemaakt, ($!)\n";
print WRITEFILE $ALLTEXT ;
close (WRITEFILE);


# Add parse of "settings" file for back to book message...
$TheSettingsFile = "..\\..\\Languages\\$Language\\HTML\\Main\\Settings.htm" ;
$ReadFile = $TheSettingsFile ;
open (READFILE, "$ReadFile") || die "file $ReadFile cannot be found. ($!)\n";
@ALLTEXT = <READFILE>;
close (READFILE);
$ALLTEXT = join ("",@ALLTEXT) ;
foreach $MessTransEntry (@MessTransEntries)
{
  @MessTransLine = split(/#/,$MessTransEntry);
  $MessGrep = $MessTransLine[0];
  $MessChange = $MessTransLine[$TLN];
  if ($ALLTEXT =~ $MessGrep)
  {
    $ALLTEXT =~ s/$MessGrep/$MessChange/g;
    if ($TRACING eq "ON") {
      print "$MessTransLine[0] to $MessTransLine[$TLN]\n";
    } else { print "."; }
  }
}
$WriteFile = $TheSettingsFile ;
if ($TRACING eq "ON") {
  print "Creating File $WriteFile...\n" ;
} else { print "."; }
open (WRITEFILE, ">$WriteFile") || die "file $WriteFile kan niet worden aangemaakt, ($!)\n";
print WRITEFILE $ALLTEXT ;
close (WRITEFILE);



# Add parse of "editing" file for back to book message...
$TheEditingFile = "..\\..\\Languages\\$Language\\HTML\\Main\\Editing.htm" ;
$ReadFile = $TheEditingFile ;
open (READFILE, "$ReadFile") || die "file $ReadFile cannot be found. ($!)\n";
@ALLTEXT = <READFILE>;
close (READFILE);
$ALLTEXT = join ("",@ALLTEXT) ;
foreach $MessTransEntry (@MessTransEntries)
{
  @MessTransLine = split(/#/,$MessTransEntry);
  $MessGrep = $MessTransLine[0];
  $MessChange = $MessTransLine[$TLN];
  if ($ALLTEXT =~ $MessGrep)
  {
    $ALLTEXT =~ s/$MessGrep/$MessChange/g;
    if ($TRACING eq "ON") {
      print "$MessTransLine[0] to $MessTransLine[$TLN]\n";
    } else { print "."; }
  }
}

# add the pages to edit
$ALLTEXT =~ s/<<<CHAPTEREDITPAGES>>>/$CHAPTEREDITPAGES/;

#choose text style
$ALLTEXT =~ s/<<<CHARSET>>>/$CHARSET/;
$ALLTEXT =~ s/<<<FONTFAMILY>>>/$FONTFAMILY/g;
$ALLTEXT =~ s/<<<LANGUAGE>>>/$LA/g;
$ALLTEXT =~ s/<<<BASEHTMLFILEPART>>>/$FILEBASE/g;
print "replacing <<<BASEHTMLFILEPART>>> by ".$FILEBASE."\n";
$ALLTEXT =~ s/<<<MAINGROUP>>>/$MainGroup/g;
$ALLTEXT =~ s/<<<GROUP>>>/$Group/g;
$ALLTEXT =~ s/<<<LONGLANG>>>/$Language/g;

$WriteFile = $TheEditingFile ;
if ($TRACING eq "ON") {
  print "Creating File $WriteFile...\n" ;
} else { print "."; }
open (WRITEFILE, ">$WriteFile") || die "file $WriteFile kan niet worden aangemaakt, ($!)\n";
print WRITEFILE $ALLTEXT ;
close (WRITEFILE);


# init vars
$ChapterNames = ":stored_chapternames:";
$ChapterPages = ":stored_chapterpages:";
$ChapterLastPages = ":stored_chapterlastpages:";
$ChapterWords = ":stored_chapterwords:";
$ChapterUniqueWords = ":stored_chapteruniquewords:";
$ChapterNewWords = ":stored_chapternewwords:";
$ChapterNewPercentage = ":stored_chapternewpercentage:";	#this is the key to the curriculum!!!

#GENERATE CHAPTERS' STATUS LIST
$ChapterNumber = 1;
foreach $ChapterName(@ChapterLongNames) {
   if ($ChapterNumber == 1) {
      #$ChapterName = $ChapterName." (Tutorial)";
      $ChapterName = $ChapterName;
   }
   $ChapterFirstPage = $ChapterFirstPages[$ChapterNumber-1];
   # push (@ChapterCounters,$ChapterCounter."\t".$CounterListChapterName."(".$counter.")<BR>");
   $CHAPTERPROGRESSLINES = $CHAPTERPROGRESSLINES."<FIELDSET style=\"width: 50%; border: none; padding: 1px;\"><A class=ExtraText href=\"DUMMY\" ".$CHAPTERLINKS[$ChapterNumber-1]."><IMG src=\"..\\Media\\ChapterStatus<<<CHAPTERSTATUS".$ChapterNumber.">>>.gif\" align=\"middle\" width=\"18px\" alt='Chapter is still <<<CHAPTERSTATUS".$ChapterNumber.">>>' style='position: relative; border: 0pt solid white' \/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<FONT COLOR=\"\#0000FF\">".$ChapterName."<\/FONT><\/A></FIELDSET><FIELDSET class=ExtraText style=\"width: 12%; border: none; padding: 1px;\"><<<CHAPTERWORDS".$ChapterNumber.">>></FIELDSET><FIELDSET class=ExtraText style=\"width: 12%; border: none; padding: 1px;\"><<<CHAPTERUNIQUEWORDS".$ChapterNumber.">>></FIELDSET><FIELDSET class=ExtraText style=\"width: 10%; border: none; padding: 1px;\"><<<CHAPTERNEWWORDS".$ChapterNumber.">>></FIELDSET><FIELDSET class=ExtraText style=\"width: 15%; border: none; padding: 1px;\"><<<CHAPTERNEWPERCENTAGE".$ChapterNumber.">>></FIELDSET><BR>\n\n";

   $Locked = "Locked";
   $Unlocked = "Unlocked";
   $Finished = "Complete";
   if ($FilenameLanguage eq "Dutch" )
   {
      $Locked = "Gesloten";
      $Unlocked = "Open";
      $Finished = "Compleet";
   }
   `copy ..\\Base\\Media\\Main\\ChapterStatusLocked.gif ..\\Base\\Media\\Main\\ChapterStatus$Locked.gif`;
   `copy ..\\Base\\Media\\Main\\ChapterStatusUnlocked.gif ..\\Base\\Media\\Main\\ChapterStatus$Unlocked.gif`;
   `copy ..\\Base\\Media\\Main\\ChapterStatusComplete.gif ..\\Base\\Media\\Main\\ChapterStatus$Finished.gif`;

   if ($DEMOWANTED eq "FALSE") {
      $ChapterNewPercentageTemp = (($ALLNEWWORDSPERCHAPTER[$ChapterNumber-1]/$ChapterWordCounters[$ChapterNumber-1])*100);
   } else {
      print "Trying to divide ".$ALLNEWWORDSPERCHAPTER[$ChapterNumber-1]." by ".$DemoChapterWordCounters[$ChapterNumber]."!\n";
      if ($ALLNEWWORDSPERCHAPTER[$ChapterNumber-1] > 0) {
        $ChapterNewPercentageTemp = (($ALLNEWWORDSPERCHAPTER[$ChapterNumber-1]/$DemoChapterWordCounters[$ChapterNumber])*100);
      } else {
        print "Division by zero!!!!!!!!!!!!!!!!!!!!!\n";
      }
   }   
   $ChapterNewPercentageTemp = $ChapterNewPercentageTemp."Dummy";
   ($ChapterNewPercentageFirstPart,$Dummy) = split(/\./,$ChapterNewPercentageTemp) ;
   $ChapterNewPercentageFirstPart =~ s/Dummy//;
   $ChapterNewPercentage[$ChapterNumber-1] = $ChapterNewPercentageFirstPart;

   # make chapter info strings for later splitting:
   $ChapterNames = $ChapterNames.$ChapterName.":stored_chapternames:";
   $ChapterPages = $ChapterPages.$ChapterFirstPage.":stored_chapterpages:";
   $ChapterLastPages = $ChapterLastPages.$ChapterLastPages[$ChapterNumber-1].":stored_chapterlastpages:";
   if ($DEMOWANTED eq "FALSE") {
      $ChapterWords = $ChapterWords.$ChapterWordCounters[$ChapterNumber-1].":stored_chapterwords:";
   } else {
      $ChapterWords = $ChapterWords.$DemoChapterWordCounters[$ChapterNumber].":stored_chapterwords:";
   }
   $ChapterUniqueWords = $ChapterUniqueWords.$ALLUNIQUEWORDSPERCHAPTER[$ChapterNumber-1].":stored_chapteruniquewords:";
   $ChapterNewWords = $ChapterNewWords.$ALLNEWWORDSPERCHAPTER[$ChapterNumber-1].":stored_chapternewwords:";
   $ChapterNewPercentage = $ChapterNewPercentage.$ChapterNewPercentage[$ChapterNumber-1].":stored_chapternewpercentage:";

   $ChapterNumber = $ChapterNumber + 1;
}
$ChapterInformationStrings = "<REMOVETHISBULLSHIT><".$ChapterNames."><BR><".$ChapterPages."><BR><".$ChapterLastPages."><BR><".$ChapterWords."><BR><".$ChapterUniqueWords."><BR><".$ChapterNewWords."><BR><".$ChapterNewPercentage."><REMOVETHISBULLSHIT>";

#print "ChapterInformationStrings:\n$ChapterInformationStrings\n";
#`pause`;

$TOTALBOOKNAME = "<<<TOTALBOOKNAME>>>";
$TOTALBOOKWORDS = "<<<TOTALBOOKWORDS>>>";
$TOTALBOOKUNIQUEWORDS = "<<<TOTALBOOKUNIQUEWORDS>>>";
$TOTALBOOKNEWWORDS = "<<<TOTALBOOKNEWWORDS>>>";
$TOTALBOOKPERCENTAGE = "<<<TOTALBOOKNEWWORDSPERCENTAGE>>>";
$ChapterNumber = $ChapterNumber - 1;
$CHAPTERPROGRESSLINES = $CHAPTERPROGRESSLINES."<FIELDSET style=\"width: 50%; border: none; padding: 1px;\"><A class=ExtraText href=\"DUMMY\"><IMG src=\"..\\Media\\ChapterStatus<<<CHAPTERSTATUS".$ChapterNumber.">>>.gif\" align=\"middle\" width=\"18px\" alt='<<<Book Total Info>>>' style='position: relative; border: 0pt solid white' \/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<B><<<Totals>>><\/B><\/A></FIELDSET><FIELDSET class=ExtraText style=\"width: 12%; border: none; padding: 1px;\">".$TOTALBOOKWORDS."</FIELDSET><FIELDSET class=ExtraText style=\"width: 12%; border: none; padding: 1px;\">".$TOTALBOOKUNIQUEWORDS."</FIELDSET><FIELDSET class=ExtraText style=\"width: 10%; border: none; padding: 1px;\">".$TOTALBOOKNEWWORDS."</FIELDSET><FIELDSET class=ExtraText style=\"width: 15%; border: none; padding: 1px;\">".$TOTALBOOKPERCENTAGE." (<<<Ave>>>)</FIELDSET><BR>\n\n";

#PROGRESS PAGE
# Add progress page (also with total number of unique words)
$TheProgressFile = "..\\..\\Languages\\$Language\\HTML\\Main\\Progress".$FilenameLanguage.".htm" ;
$ReadFile = $TheProgressFile ;
open (READFILE, "$ReadFile") || die "file $ReadFile cannot be found. ($!)\n";
@ALLTEXT = <READFILE>;
close (READFILE);
$ALLTEXT = join ("",@ALLTEXT) ;
#vervang <<<CHAPTERPROGRESSLINES>>> door alle options
$ALLTEXT =~ s/<<<CHAPTERPROGRESSLINES>>>/$CHAPTERPROGRESSLINES/;

#vervang <<<CHAPTERINFORMATION>>> door de chapterinformation strings
$ALLTEXT =~ s/<<<CHAPTERINFORMATION>>>/$ChapterInformationStrings/;

foreach $MessTransEntry (@MessTransEntries)
{
  @MessTransLine = split(/#/,$MessTransEntry);
  $MessGrep = $MessTransLine[0];
  $MessChange = $MessTransLine[$TLN];
  if ($ALLTEXT =~ $MessGrep)
  {
    $ALLTEXT =~ s/$MessGrep/$MessChange/g;
    if ($TRACING eq "ON") {
      print "$MessTransLine[0] to $MessTransLine[$TLN]\n";
    } else { print "."; }
  }
}
#writefile
$WriteFile = $TheProgressFile ;
if ($TRACING eq "ON") {
  print "Creating File $WriteFile...\n" ;
} else { print "."; }
open (WRITEFILE, ">$WriteFile") || die "file $WriteFile kan niet worden aangemaakt, ($!)\n";
print WRITEFILE $ALLTEXT ;
close (WRITEFILE);


#UNIQUEWORDLIST
$WriteFile = "..\\..\\Languages\\$Language\\HTML\\Main\\UniqueWordsFile.htm";
if ($TRACING eq "ON") {
  print "Creating File $WriteFile...\n" ;
} else { print "."; }
open (WRITEFILE, ">$WriteFile") || die "file $WriteFile kan niet worden aangemaakt, ($!)\n";
print WRITEFILE $ALLNEWWORDS;
close (WRITEFILE);

#FINISHEDUNIQUEWORDLIST
$WriteFile = "..\\..\\Languages\\$Language\\HTML\\Main\\FinishedUniqueWordsFile.htm";
if ($TRACING eq "ON") {
  print "Creating File $WriteFile...\n" ;
} else { print "."; }
open (WRITEFILE, ">$WriteFile") || die "file $WriteFile kan niet worden aangemaakt, ($!)\n";
print WRITEFILE $ALLNEWWORDSNOCHAPTER;
close (WRITEFILE);

#CHAPTERDONE PAGE
# Add chapter done page (also with total number of unique words)
$TheChapterDoneFile = "..\\..\\Languages\\$Language\\HTML\\Main\\ChapterDone".$FilenameLanguage.".htm" ;
$ReadFile = $TheChapterDoneFile ;
open (READFILE, "$ReadFile") || die "file $ReadFile cannot be found. ($!)\n";
@ALLTEXT = <READFILE>;
close (READFILE);
$ALLTEXT = join ("",@ALLTEXT) ;
#vervang <<<CHAPTERPROGRESSLINES>>> door alle options
$ALLTEXT =~ s/<<<CHAPTERPROGRESSLINES>>>/$CHAPTERPROGRESSLINES/;
foreach $MessTransEntry (@MessTransEntries)
{
  @MessTransLine = split(/#/,$MessTransEntry);
  $MessGrep = $MessTransLine[0];
  $MessChange = $MessTransLine[$TLN];
  if ($ALLTEXT =~ $MessGrep)
  {
    $ALLTEXT =~ s/$MessGrep/$MessChange/g;
    if ($TRACING eq "ON") {
      print "$MessTransLine[0] to $MessTransLine[$TLN]\n";
    } else { print "."; }
  }
}
#write file
$WriteFile = $TheChapterDoneFile ;
if ($TRACING eq "ON") {
  print "Creating File $WriteFile...\n" ;
} else { print "."; }
open (WRITEFILE, ">$WriteFile") || die "file $WriteFile kan niet worden aangemaakt, ($!)\n";
print WRITEFILE $ALLTEXT ;
close (WRITEFILE);



#FINISHED PAGE
# Add chapter done page (also with total number of unique words)
$TheFinishedFile = "..\\..\\Languages\\$Language\\HTML\\Main\\Finished".$FilenameLanguage.".htm" ;
$ReadFile = $TheFinishedFile ;
open (READFILE, "$ReadFile") || die "file $ReadFile cannot be found. ($!)\n";
@ALLTEXT = <READFILE>;
close (READFILE);
$ALLTEXT = join ("",@ALLTEXT) ;
#vervang <<<CHAPTERPROGRESSLINES>>> door alle options
$ALLTEXT =~ s/<<<CHAPTERPROGRESSLINES>>>/$CHAPTERPROGRESSLINES/;
foreach $MessTransEntry (@MessTransEntries)
{
  @MessTransLine = split(/#/,$MessTransEntry);
  $MessGrep = $MessTransLine[0];
  $MessChange = $MessTransLine[$TLN];
  if ($ALLTEXT =~ $MessGrep)
  {
    $ALLTEXT =~ s/$MessGrep/$MessChange/g;
    if ($TRACING eq "ON") {
      print "$MessTransLine[0] to $MessTransLine[$TLN]\n";
    } else { print "."; }
  }
}
#write file
$WriteFile = $TheFinishedFile ;
if ($TRACING eq "ON") {
  print "Creating File $WriteFile...\n" ;
} else { print "."; }
open (WRITEFILE, ">$WriteFile") || die "file $WriteFile kan niet worden aangemaakt, ($!)\n";
print WRITEFILE $ALLTEXT ;
close (WRITEFILE);


exit 0;


