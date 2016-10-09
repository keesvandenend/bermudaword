#!./perl
#!perl
######################################################################
# Name: EncryptCourse.pl
# Synopsis: Encrypt All HTML Files for A $Language Course
#
# Usage: EncryptCourse.pl <Language> [<Group>,All] -t <Original_Title> -v <Translated_Title> -prod <Drive> [-noenc]
#
#        <Language>            Fill in the Language, currently:
#                              Russian, Georgian, Swedish, Spanish, Hungarian, Polish, Indonesian, French, German, Dutch, English, Portuguese, Greek, Urdu and Italian
#        [<Group>,All]         Fill in the books/chapters for above language
#                              to handle !!WARNING - Option 'All' DOES NOT WORK!!!
#        -t <Original_Title>   Add original title (otherwise Group name is used)
#        -v <Translated_Title> Add translation of original title
#        -tln <lang> <group>   Targetlanguage and Group (if any other than English) where Group corresponds to Book folder
#        -prod <Drive>         Define USB Stick Drive, on which data shall be put
#                              and from which security details will be taken for the also encrypted security code in parse file
#        -RedoAudio            Redoes Audio even if already exists
#        -noenc                The OpAsc default becomes None (no encryption at all)
#        -demo                 Create demo product (has other .exe title and production paths
#        -debug [override]     We remove debug from VB code, but with this arg we leave it in place
#                              WARNING: '-debug override' creates normal product but with debug on
#                              This will also let you start up the tool without the security check
#        -diconly              Quit, we only ran FormatHTMLTexts.pl script, don't want to actually make an e-book
#        -reload <productkey>  This reloads the product(s) with key <productkey> provided it's
#         | ALL                still in /Digital and not uploaded already or ALL those in /Digital
#        -quick <files>        only does file, comma separated list, for example -quick JavaMap.htm,StyleMap.htm
#        -trace                debugging of this script
#        -editable             Editmode is on so VB code knows it is allowed to edit
######################################################################
#
# Author        : A.W.Th. van den End
#                       
# Date          : 13-03-2001  Make e-book .exe
#                 09-05-2003  Add production
#                 22-06-2007  Add config possibilities (testing and teacher mode)
#                 10-08-2013  Add more config possibilities (spaced repetition)
#                 07-08-2014  Extra encryption keys
#                 03-03-2015  Make product downloadable (load all in one big exe file)
#                 12-09-2015  Cleaner version 3.0 of Tool including Spaced Repetition
#                 01-12-2015  Enable reloading of .exe for easier product refresh
#                 projected   add lesson based system and some bug fixes
#                             all in all this is version 4.0
#
# *All Copyrights for this script by A.W.Th. van den End
# *All Copyrights for this script by Ittolaja Inc. acquired from Bermuda Word ICT BV
######################################################################

# if website = 'On', quit
if ("@ARGV" =~ "-website") {
  print "Built website, quit...\n";
  exit 0;
}

# if pdf = 'On', or app was made, quit
if ("@ARGV" =~ "-pdf") {
  print "Built pdf's, quit..\n";
  exit 0;
}
if ("@ARGV" =~ "-app") {
  print "Built App, quit..\n";
  exit 0;
}

# Print Help
$AA = "@ARGV"; #Get AllArguments
print "Arguments: $AA\n";
if ($AA =~ " -h " || $AA =~ " -H " || $AA =~ / -h$/ || $AA =~ / -H$/ || $AA =~ " \/h " || $AA =~ / \/H$/ || $AA =~ "-help" || $AA =~ "\/help" || $AA =~ "-Help" || $AA =~ "\/Help" || $AA =~ "-HELP" || $AA =~ "\/HELP")
{
  #There is a sign of distress, let's show the help:
  print "################################################################################################################################\n";
  print "# Name: EncryptCourse.pl                                                                                                       #\n";
  print "# Synopsis: Encrypt All HTML Files for A $Language Course                                                                      #\n";
  print "#                                                                                                                              #\n";
  print "# Usage: EncryptCourse.pl <Language> [<Group>,All] -t <Original_Title> -v <Translated_Title> -prod <Drive> -e <EncryptionKey>  #\n";
  print "#                                                                                                                              #\n";
  print "#        <Language>            Fill in the Language, currently:                                                                #\n";
  print "#                              Russian, Swedish, Spanish, French, German, Hungarian, Italian                                   #\n";
  print "#                              Dutch, English, Portuguese, Polish, Greek, Georgian, Urdu                                       #\n";
  print "#                              and Indonesian                                                                                  #\n";
  print "#        [<Group>,All]         Fill in the books/chapters for above language                                                   #\n";
  print "#                              to handle !!WARNING - Option 'All' DOES NOT WORK!!!                                             #\n";
  print "#        -t <Original_Title>   Add original title (otherwise Group name is used)                                               #\n";
  print "#        -v <Translated_Title> Add translation of original title                                                               #\n";
  print "#        -tln <lang> <group>   Targetlanguage and Group (if any other than English) where Group corresponds to Book folder     #\n";
  print "#        -prod <Drive>         Define USB Stick Drive, on which data shall be put                                              #\n";
  print "#                              and from which security details will be taken for parse file                                    #\n";
  print "#        -RedoAudio            Redoes Audio even if already exists                                                             #\n";
  print "#        -noenc                The OpAsc default becomes None (no encryption at all)                             #\n";
  print "#        -demo                 Create demo product (has other .exe title and production paths                                  #\n";
  print "#        -debug [override]     We remove debug from VB code, but with this arg we leave it in place                            #\n";
  print "#                              WARNING: '-debug override' creates normal product but with debug on                             #\n";
  print "#                              This will also let you start up the tool without the security check                             #\n";
  print "#        -diconly              Quit, we only ran FormatHTMLTexts.pl script, don't want to actually make an e-book              #\n";
  print "#        -reload <productkey>  This reloads the product(s) with key <productkey> provided it's                                 #\n";
  print "#         | ALL                still in /Digital and not uploaded already or ALL those in /Digital                             #\n";
  print "#        -quick <files>        only does file, comma separated list, for example -quick JavaMap.htm,StyleMap.htm               #\n";
  print "#        -trace                debugging of this script                                                                        #\n";
  print "#        -editable             Editmode is on so VB code knows it is allowed to edit                                           #\n";
  print "################################################################################################################################\n";
  exit 0;
}

######################################################################
# VARIABELEN EN SETTINGS/ARGUMENTS
$Encryption = "OpAsc";
$configfile = "HypLernConfig.htm";
$wordlistfile = "HypLernWords";
$Indexfile = "index.htm" ;
$Part = 0 ;
$PartLength = "0" ;
$Language = $ARGV[0] ;
$Group = $ARGV[1] ;
$ShortTitle = $Group;
$TestGrepArguments = "@ARGV";

if ($Language ne "Urdu" && $Language ne "Georgian" && $Language ne "Hungarian" && $Language ne "Russian" && $Language ne "French" && $Language ne "Spanish"  && $Language ne "Swedish" && $Language ne "Italian" && $Language ne "Portuguese" && $Language ne "Dutch" && $Language ne "English" && $Language ne "Greek" && $Language ne "German" && $Language ne "Polish" && $Language ne "Indonesian")
{
  print "!   The first argument given should be\n" ;
  print "!   the Language of the course or e-books\n" ;
  print "!   that you want to format;\n" ;
  print "!   $Language is not supported.\n" ;
  print "!   Currently only Russian, Georgian, Hungarian, French, Italian, Spanish, Swedish, English, Dutch, Portuguese, Greek, German, Polish, Urdu or Indonesian are possible.\n" ;
  exit 0 ;
}

# Turn tracing on
if ($TestGrepArguments =~ "-trace") {
  $TRACING = "ON";
}

# Turn editing on in tool
  if ($TestGrepArguments =~ "-editable") {
  $EDITMODE = "EDIT";
} else {
  $EDITMODE = "TEMP";
}

# Get Language To
if ($TestGrepArguments !~ "-tln")
{
   if ($TRACING eq "ON") {
     print "No Translation for Language given, default will be English\n";
   } else { print ".";}
   $ProdLanguage = $Language;
   $ProdGroup = $Group;
}
else
{
   $NrOfArg = 0;
   foreach $ARGUMENT (@ARGV)
   {
      if ($ARGUMENT eq "-tln")
      {
         $ProdLanguage = $ARGV[$NrOfArg+1];
         $ProdGroup = $ARGV[$NrOfArg+2];
      }
      $NrOfArg = $NrOfArg + 1;      
   }
}



# Check if Nomake
if ($TestGrepArguments =~ "-nomake")
{
   print "Creating an e-book not needed now, that was skipped with -nomake argument... Quitting\n";
   exit 0;
}

# Check if Diconly
if ($TestGrepArguments =~ "-diconly")
{
   print "Creating an e-book not needed now, Make bat was only started to create dictionary... Quitting\n";
   exit 0;
}

# Check if Demo
if ($TestGrepArguments =~ "-demo")
{
   if ($TRACING eq "ON") {
     print "This is a demo, make folder as suchpflrt\n";
   } else { print ".";}
   $DEMOWANTED = "YES";
   $ProdGroup = $ProdGroup."Demo";
   $ProdGroup =~ s/ //g;
   $ProdGroup =~ s/\-//g;
}

# Get REAL Language To (sigh) now tln is used as Directory name version of the subject language :-(
if ($TestGrepArguments !~ "-trans")
{
   print "No Translation for Language given, default will be English (is empty)\n";
   $TransLanguage = "";
}
else
{
   $NrOfArg = 0;
   foreach $ARGUMENT (@ARGV)
   {
      if ($ARGUMENT eq "-trans")
      {
         $TransLanguage = $ARGV[$NrOfArg+1];
      }
      $NrOfArg = $NrOfArg + 1;      
   }
}

if ($TransLanguage eq "") {
  # English
  $SecurityErrorMessage = "Security Error, not original E-book, illegal copy.\n\n";
  $SecurityErrorMessage = $SecurityErrorMessage."You have to run this program on the original Bermuda Word USB Stick.\n\n";
  $SecurityErrorMessage = $SecurityErrorMessage."If this program does run on an original stick, please email info\@bermudaword.com.\n\n";
}
if ($TransLanguage eq "Dutch") {
  $SecurityErrorMessage = "Security Error, niet origineel E-book, illegale kopie.\n\n";
  $SecurityErrorMessage = $SecurityErrorMessage."Dit programma dient alleen te worden gestart op de originele Bermuda Word USB Stick.\n\n";
  $SecurityErrorMessage = $SecurityErrorMessage."Als het programma draait op een originele USB stick, mail alstublieft info\@bermudaword.com.\n\n";
}


# Wat een schatjes
$DEBUG="NO";
if ($TestGrepArguments =~ "-debug")
{
   if ($TRACING eq "ON") {
     print "Production path debug for this case\n";
   } else { print ".";}
   $DEBUG="ON";
   $LEAVEDEBUGON="YES";
   $NrOfArg = 0;
   foreach $ARGUMENT (@ARGV)
   {
      if ($ARGUMENT eq "-debug")
      {
         $Override = $ARGV[$NrOfArg+1];
         if ($Override eq "override") {
            $DEBUG="NO";		#no special debug product but regular product
            $LEAVEDEBUGON="YES";	# with debug still on
         }
      }
      $NrOfArg = $NrOfArg + 1;      
   }
}

# Hm ook een optie zonder debug en zonder encryption
if ($TestGrepArguments =~ "-noenc")
{
   print "Alert! Unencrypted version created!";
   $Encryption = "None";
   $NOENC = "ON";
}

# Jezus wat slecht geprogrammeerd :-)
if ($TestGrepArguments =~ "-quick")
{
   if ($TRACING eq "ON") {
     print "Need quick turnaround\n";
   } else { print ".";}
   $QUICK="ON";
   $NrOfArg = 0;
   foreach $ARGUMENT (@ARGV)
   {
      if ($ARGUMENT eq "-quick" && $ARGV[$NrOfArg+1] !~ m/^\-/)
      {
         $QUICKFILES = $ARGV[$NrOfArg+1];
      }
      $NrOfArg = $NrOfArg + 1;      
   }
}

# get base path (if working from other disk)
$basepath = `cd`;
chop $basepath;
$basepath =~ s/\\Tool\\Perl//;
($dummy,$TOOLEDITPATH) = split(":",$basepath);
if ($TRACING eq "ON") {
  print "Path using for Development version: <root>:".$TOOLEDITPATH."\\Production\\$ProdLanguage\\$ProdGroup\\"."\n";
} else { print ".";}

# Get chapter info from progress page
$ReadFile = "..\\..\\Languages\\$Language\\HTML\\Main\\Progress$TransLanguage.htm" ;
open (READFILE, "$ReadFile") || die "file $ReadFile cannot be found. ($!)\n";
@ALLTEXT = <READFILE>;
close (READFILE);
$ALLTEXT = join ("",@ALLTEXT) ;

@ChapterNames = split(/\:stored\_chapternames\:/,$ALLTEXT);
# remove first and last element from ChapterNames array
shift @ChapterNames;
pop @ChapterNames;
$LengthChapterNamesArray = @ChapterNames;
@ChapterPages = split(/\:stored\_chapterpages\:/,$ALLTEXT);
shift @ChapterPages;
pop @ChapterPages;
@ChapterLastPages = split(/\:stored\_chapterlastpages\:/,$ALLTEXT);
shift @ChapterLastPages;
pop @ChapterLastPages;
$FirstChapterLastPage = $ChapterLastPages[0];
$LastChapterLastPage = $ChapterLastPages[$LengthChapterNamesArray];
@ChapterWords = split(/\:stored\_chapterwords\:/,$ALLTEXT);
@ChapterUniqueWords = split(/\:stored\_chapteruniquewords\:/,$ALLTEXT);
@ChapterNewWords = split(/\:stored\_chapternewwords\:/,$ALLTEXT);
@ChapterNewPercentage = split(/\:stored\_chapternewpercentage\:/,$ALLTEXT);

($ALLTEXTPARTONE,$BULLSHIT,$ALLTEXTPARTTWO) = split("<REMOVETHISBULLSHIT>",$ALLTEXT);
$ALLTEXT = $ALLTEXTPARTONE.$ALLTEXTPARTTWO;

#rewrite progress without the bullshit which messes up the layout
$WriteFile = "..\\..\\Languages\\$Language\\HTML\\Main\\Progress$TransLanguage.htm" ;
open (WRITEFILE, ">$WriteFile") || die "file $WriteFile cannot be found. ($!)\n";
print WRITEFILE $ALLTEXT;
close WRITEFILE;



#open menu file

# CREATE UBERFRAME
$UberFrameBaseFile = "..\\..\\Languages\\$Language\\HTML\\$Group\\Course".$Language.$Group."TextMenu.htm" ;
$ReadFile = $UberFrameBaseFile ;
open (READFILE, "$ReadFile") || die "file $ReadFile cannot be found. ($!)\n";
@ALLTEXT = <READFILE>;
close (READFILE);
$ALLTEXT = join ("",@ALLTEXT) ;

# Also change number of lines in Chapter menu for neatness:
$LengthChapterNamesArrayPlusOne = $LengthChapterNamesArray + 1;

# ADD SOMETHING FOR TEST CHAPTERS!!! LIKE BELOW PLUS FOUR (EASY MEDIUM DIFF AND TOTAL)
$LengthChapterNamesArrayPlusFive = $LengthChapterNamesArray + 5;

$ALLTEXT =~ s/<<<NUMBEROFCHAPTERS>>>/$LengthChapterNamesArrayPlusOne/g;
$ALLTEXT =~ s/<<<NUMBEROFTESTOPTIONS>>>/$LengthChapterNamesArrayPlusFive/g;
$WriteFile = "..\\..\\Languages\\$Language\\HTML\\$Group\\Course".$Language.$Group."TextMenu.htm" ;
open (WRITEFILE, ">$WriteFile") || die "file $WriteFile cannot be found. ($!)\n";
print WRITEFILE $ALLTEXT;
close WRITEFILE;


#open small menu file

# CREATE UBERFRAME
$UberFrameBaseFile = "..\\..\\Languages\\$Language\\HTML\\$Group\\Course".$Language.$Group."TextMainSmallMenu.htm" ;
$ReadFile = $UberFrameBaseFile ;
open (READFILE, "$ReadFile") || die "file $ReadFile cannot be found. ($!)\n";
@ALLTEXT = <READFILE>;
close (READFILE);
$ALLTEXT = join ("",@ALLTEXT) ;

# ADD SOMETHING FOR TEST CHAPTERS!!! LIKE BELOW PLUS FOUR (EASY MEDIUM DIFF AND TOTAL)
$LengthChapterNamesArrayPlusFive = $LengthChapterNamesArray + 5;

$ALLTEXT =~ s/<<<NUMBEROFTESTOPTIONS>>>/$LengthChapterNamesArrayPlusFive/g;
$WriteFile = "..\\..\\Languages\\$Language\\HTML\\$Group\\Course".$Language.$Group."TextMainSmallMenu.htm" ;
open (WRITEFILE, ">$WriteFile") || die "file $WriteFile cannot be found. ($!)\n";
print WRITEFILE $ALLTEXT;
close WRITEFILE;



# See if $RedoAudio eq "YES"
if ($TestGrepArguments =~ m/RedoAudio/i)
{
  $RedoAudio = "YES";
}

# Check if there is a Don't Pause argument
if ($TestGrepArguments =~ "-nopause")
{
	$PAUSENEEDED = "FALSE";
}
else
{
	$PAUSENEEDED = "TRUE";
}



# Get Original Title
if ($TestGrepArguments !~ "-t")
{
   print "No title given, title will be Group $Group\n";
   $TitleOrg = $Group;
}
else
{
   $NrOfArg = 0;
   foreach $ARGUMENT (@ARGV)
   {
      if ($ARGUMENT eq "-t")
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
if ($TestGrepArguments !~ "-v")
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
      if ($ARGUMENT eq "-v")
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

if ($Language eq "")
{
  print "Please Do Enter A Language!\n";
  exit 0;
}

if ($Group eq "")
{
  print "Please Do Enter A Group or 'All'!\n";
  exit 0;
}

if ($TestGrepArguments =~ "-prod" && $TestGrepArguments !~ "-debug")
{
   $NrOfArg = 0;
   foreach $ARGUMENT (@ARGV)
   {
      if ($ARGUMENT eq "-prod")
      {

         $PRODDRIVE = $ARGV[$NrOfArg+1];
         $PRODDRIVE =~ s/://g;
         $LENPRODDRIVE = length $PRODDRIVE;
         $PRODDRIVE = uc($PRODDRIVE);
         if ($LENPRODDRIVE ne 1)
         {
            $PRODDRIVE = "";
         }
         else
         {
            $TEMPPROD = $PRODDRIVE;
            $PRODDRIVE =~ s/^([A-Z])/CORRECT/g;
            if ($PRODDRIVE eq "CORRECT")
            {
               $PRODDRIVE = $TEMPPROD;
            }
            else
            {
               $PRODDRIVE = "";
            }             
         }
      }
      $NrOfArg = $NrOfArg + 1;      
   }
   if ($PRODDRIVE eq "")
   {
     if ($TRACING eq "ON") {
       print "No (correct) prod drive entered, TOPROD argument will be ignored...\n";
     } else { print ".";}
     $TOPROD = "no";
   }
   else
   {
     $TOPROD = "yes";
     if ($TRACING eq "ON") {
       print "TOPROD is $PRODDRIVE\n";
     } else { print ".";}
   }
}
else
{
  if ($TRACING eq "ON") {
    print "No (correct) prod drive entered, TOPROD argument will be ignored...\n";
  } else { print ".";}
  $TOPROD = "no";
}


# executable name, this defines where executable gets its stuff as well
$EXECNAME = $ProdLanguage."-".$ProdGroup;

$ExistingSecurityKeyHex = "";

if ($TestGrepArguments =~ "-reload") {

   # find second argument
   $NrOfArg = 0;
   foreach $ARGUMENT (@ARGV)
   {
      if ($ARGUMENT eq "-reload" && $ARGV[$NrOfArg+1] !~ m/^\-/)
      {
         $ExistingSecurityKeyHex = $ARGV[$NrOfArg+1];
         if ($TRACING eq "ON") {
           print "Reloading all existing products in //Digital//<ProdLanguage>//<ProdLanguage>-<ProdGroup>-*...\n";
         } else { print ".";}
      }
      $NrOfArg = $NrOfArg + 1;      
   }
   
   # use existing GeheimeSleutel found in the /Digital path or do all if ALL
   if ($ExistingSecurityKeyHex eq "ALL" || $ExistingSecurityKeyHex eq "") {
      $ExistingSecurityKeyHex = "ALL";
      # find all products named /Digital/<ProductLanguage>-<ProductGroup>-*
      @DirOutput = `dir /B /AD ..\\..\\Digital\\$ProdLanguage\\$ProdLanguage-$ProdGroup-*` ;
      if ($TRACING eq "ON") {
        print "DirOutput is @DirOutput\n";
      } else { print ".";}
      foreach $UniqueProduct(@DirOutput) {
         chop $UniqueProduct ;
         ($Messystuff,$Moremessystuff,$UniqueProductKey) = split(/\-/,$UniqueProduct);
         if ($TRACING eq "ON") {
           print "Push UniqueProductKey $UniqueProductKey\n";
         } else { print ".";}
         push (@SecurityKeyHexes,$UniqueProductKey) ;
      } 
        
   } else {
   
      # add fix here using the three letter codes generated same way as in FormatHTMLTexts.pl
      if ($ExistingSecurityKeyHex eq "") {
         push (@SecurityKeyHexes,"NEW");
         print "Argument -reload used but no key given...\n";
         exit 1;
      } else {
         # we'll use ExistingSecurityKeyHex already set (not ALL)
         push (@SecurityKeyHexes,$ExistingSecurityKeyHex) ;
      }
   }
} else {

   # no reload so create new key, we'll just push NEW
   push (@SecurityKeyHexes,"NEW");

   # if NEW, create encryption keys <<<ENCRYPTIONKEY0 to 3>>> and put them into an array for later use
   # if reloading existing product, get key from file in that directory...
   if ($TRACING eq "ON") {
     print "Now putting 6 random encryption keys of XXX numbers each into the slots in .fmt...\n";
   } else { print ".";}
   for ($EKY = 0; $EKY < 6; $EKY++) {
      $ENCRYPTIONKEY = "";
      $ENCRYPTIONKEYNICE = "";
      $ENCRYPTIONKEYVB = "";
      # per encryption key, generate a key of XXX characters
      for ($ENU = 0; $ENU < 150; $ENU++)  {
         $x = 1 + int(rand(8));
         $ENCRYPTIONKEY = $ENCRYPTIONKEY.chr($x);
         $ENCRYPTIONKEYNICE = $ENCRYPTIONKEYNICE."chr($x) . ";
         $ENCRYPTIONKEYVB = $ENCRYPTIONKEYVB."Chr($x) + ";
         if ($x == 9) { print "Help! wrong keychar...\n"; exit }
      }
      if ($TRACING eq "ON") {
        print "ENCRYPTIONKEY $EKY is $ENCRYPTIONKEYNICE\n";
      } else { print ".";}
      $ENCRYPTIONKEYNICE =~ s/ \. $//;
      $EncryptionKeysNice[$EKY] = $ENCRYPTIONKEYNICE;
      $EncryptionKeys[$EKY] = $ENCRYPTIONKEY;
      $ENCRYPTIONKEYVB =~ s/ \+ $//;
      if ($TRACING eq "ON") {
        print "ENCRYPTIONKEYVB $EKY is $ENCRYPTIONKEYVB\n";
      } else { print ".";}
      $EncryptionKeysVB[$EKY] = $ENCRYPTIONKEYVB;
   }

   @Contents = ("") ;
   $file = "..\\..\\Languages\\$Language\\HTML\\Main\\parse.htm";
   open (SERIALANDDISKKEYS, "$file") || die "file $file is niet te vinden. ($!)\n" ;
   @Contents = <SERIALANDDISKKEYS> ;
   foreach $ContentsLine (@Contents) {
     if ($ContentsLine =~ "SecManu") {
       @SecManuKeyArray = split(/\§/,$ContentsLine);
       $SecManuKeyNumeric = $SecManuKeyArray[3];
       $RevSecManuKeyNumeric = reverse $SecManuKeyNumeric;
       $RevSecManuKeyNumeric =~ s/0/3/g;
       $RevSecManuKeyNumeric =~ s/9/4/g;
       $RevSecManuKeyNumeric =~ s/A/5/g;
       $RevSecManuKeyNumeric =~ s/B/6/g;
       $RevSecManuKeyNumeric =~ s/C/7/g;
       $RevSecManuKeyNumeric =~ s/D/8/g;
       $RevSecManuKeyNumeric =~ s/E/1/g;
       $RevSecManuKeyNumeric =~ s/F/2/g;
       $RevSecManuKeyNumeric =~ s/G/3/g;
       $RevSecManuKeyNumeric =~ s/H/4/g;
       $RevSecManuKeyNumeric =~ s/I/5/g;
       $RevSecManuKeyNumeric =~ s/J/6/g;
       $RevSecManuKeyNumeric =~ s/K/7/g;
       $RevSecManuKeyNumeric =~ s/L/8/g;
       $RevSecManuKeyNumeric =~ s/M/1/g;
       $RevSecManuKeyNumeric =~ s/N/2/g;
       $RevSecManuKeyNumeric =~ s/O/3/g;
       $RevSecManuKeyNumeric =~ s/P/4/g;
       $RevSecManuKeyNumeric =~ s/Q/5/g;
       $RevSecManuKeyNumeric =~ s/R/6/g;
       $RevSecManuKeyNumeric =~ s/S/7/g;
       $RevSecManuKeyNumeric =~ s/T/8/g;
       $RevSecManuKeyNumeric =~ s/U/1/g;
       $RevSecManuKeyNumeric =~ s/V/2/g;
       $RevSecManuKeyNumeric =~ s/W/3/g;
       $RevSecManuKeyNumeric =~ s/X/4/g;
       $RevSecManuKeyNumeric =~ s/Y/5/g;
       $RevSecManuKeyNumeric =~ s/Z/6/g;
       $RevSecManuKeyNumeric =~ s/a/7/g;
       $RevSecManuKeyNumeric =~ s/b/8/g;
       $RevSecManuKeyNumeric =~ s/c/1/g;
       $RevSecManuKeyNumeric =~ s/d/2/g;
       $RevSecManuKeyNumeric =~ s/e/3/g;
       $RevSecManuKeyNumeric =~ s/f/4/g;
       $RevSecManuKeyNumeric =~ s/g/5/g;
       $RevSecManuKeyNumeric =~ s/h/6/g;
       $RevSecManuKeyNumeric =~ s/i/7/g;
       $RevSecManuKeyNumeric =~ s/j/8/g;
       $RevSecManuKeyNumeric =~ s/k/1/g;
       $RevSecManuKeyNumeric =~ s/l/2/g;
       $RevSecManuKeyNumeric =~ s/m/3/g;
       $RevSecManuKeyNumeric =~ s/n/4/g;
       $RevSecManuKeyNumeric =~ s/o/5/g;
       $RevSecManuKeyNumeric =~ s/p/6/g;
       $RevSecManuKeyNumeric =~ s/q/7/g;
       $RevSecManuKeyNumeric =~ s/r/8/g;
       $RevSecManuKeyNumeric =~ s/s/1/g;
       $RevSecManuKeyNumeric =~ s/t/2/g;
       $RevSecManuKeyNumeric =~ s/u/3/g;
       $RevSecManuKeyNumeric =~ s/v/4/g;
       $RevSecManuKeyNumeric =~ s/w/5/g;
       $RevSecManuKeyNumeric =~ s/x/6/g;
       $RevSecManuKeyNumeric =~ s/y/7/g;
       $RevSecManuKeyNumeric =~ s/z/8/g;
       @RevSecManuKeyNumericArray = split (//,$RevSecManuKeyNumeric);
       foreach $CharacterNumberInside(@RevSecManuKeyNumericArray) {
         if ($CharacterNumberInside =~ m/[1-8]/) {
           $RevSecManuKeyNice = $RevSecManuKeyNice."chr($CharacterNumberInside) . ";
           $RevSecManuKey = $RevSecManuKey.chr($CharacterNumberInside);
         }
       }
     }
     if ($ContentsLine =~ "SecSpace") {
       @SecSpaceKeyArray = split(/\§/,$ContentsLine);
       $SecSpaceKeyNumeric = $SecSpaceKeyArray[3];
       $SecSpaceKeyNumeric =~ s/0/6/g;
       $SecSpaceKeyNumeric =~ s/9/7/g;
       $SecSpaceKeyNumeric =~ s/A/8/g;
       $SecSpaceKeyNumeric =~ s/B/1/g;
       $SecSpaceKeyNumeric =~ s/C/2/g;
       $SecSpaceKeyNumeric =~ s/D/3/g;
       $SecSpaceKeyNumeric =~ s/E/4/g;
       $SecSpaceKeyNumeric =~ s/F/5/g;
       $SecSpaceKeyNumeric =~ s/G/6/g;
       $SecSpaceKeyNumeric =~ s/H/7/g;
       $SecSpaceKeyNumeric =~ s/I/8/g;
       $SecSpaceKeyNumeric =~ s/J/1/g;
       $SecSpaceKeyNumeric =~ s/K/2/g;
       $SecSpaceKeyNumeric =~ s/L/3/g;
       $SecSpaceKeyNumeric =~ s/M/4/g;
       $SecSpaceKeyNumeric =~ s/N/5/g;
       $SecSpaceKeyNumeric =~ s/O/6/g;
       $SecSpaceKeyNumeric =~ s/P/7/g;
       $SecSpaceKeyNumeric =~ s/Q/8/g;
       $SecSpaceKeyNumeric =~ s/R/1/g;
       $SecSpaceKeyNumeric =~ s/S/2/g;
       $SecSpaceKeyNumeric =~ s/T/3/g;
       $SecSpaceKeyNumeric =~ s/U/4/g;
       $SecSpaceKeyNumeric =~ s/V/5/g;
       $SecSpaceKeyNumeric =~ s/W/6/g;
       $SecSpaceKeyNumeric =~ s/X/7/g;
       $SecSpaceKeyNumeric =~ s/Y/8/g;
       $SecSpaceKeyNumeric =~ s/Z/1/g;
       $SecSpaceKeyNumeric =~ s/a/2/g;
       $SecSpaceKeyNumeric =~ s/b/3/g;
       $SecSpaceKeyNumeric =~ s/c/4/g;
       $SecSpaceKeyNumeric =~ s/d/5/g;
       $SecSpaceKeyNumeric =~ s/e/6/g;
       $SecSpaceKeyNumeric =~ s/f/7/g;
       $SecSpaceKeyNumeric =~ s/g/8/g;
       $SecSpaceKeyNumeric =~ s/h/1/g;
       $SecSpaceKeyNumeric =~ s/i/2/g;
       $SecSpaceKeyNumeric =~ s/j/3/g;
       $SecSpaceKeyNumeric =~ s/k/4/g;
       $SecSpaceKeyNumeric =~ s/l/5/g;
       $SecSpaceKeyNumeric =~ s/m/6/g;
       $SecSpaceKeyNumeric =~ s/n/7/g;
       $SecSpaceKeyNumeric =~ s/o/8/g;
       $SecSpaceKeyNumeric =~ s/p/1/g;
       $SecSpaceKeyNumeric =~ s/q/2/g;
       $SecSpaceKeyNumeric =~ s/r/3/g;
       $SecSpaceKeyNumeric =~ s/s/4/g;
       $SecSpaceKeyNumeric =~ s/t/5/g;
       $SecSpaceKeyNumeric =~ s/u/6/g;
       $SecSpaceKeyNumeric =~ s/v/7/g;
       $SecSpaceKeyNumeric =~ s/w/8/g;
       $SecSpaceKeyNumeric =~ s/x/1/g;
       $SecSpaceKeyNumeric =~ s/y/2/g;
       $SecSpaceKeyNumeric =~ s/z/3/g;
       @SecSpaceKeyNumericArray = split (//,$SecSpaceKeyNumeric);
       foreach $CharacterNumberInside(@SecSpaceKeyNumericArray) {
         if ($CharacterNumberInside =~ m/[1-8]/) {
           $SecSpaceKeyNice = $SecSpaceKeyNice."chr($CharacterNumberInside) . ";
           $SecSpaceKey = $SecSpaceKey.chr($CharacterNumberInside);
         }
       }
     }
     if ($ContentsLine =~ "SecSerial") {
       @SecSerialKeyArray = split(/\§/,$ContentsLine);
       $SecSerialKeyNumeric = $SecSerialKeyArray[3];
       $SecSerialKeyNumeric =~ s/0/1/g;
       $SecSerialKeyNumeric =~ s/9/2/g;
       $SecSerialKeyNumeric =~ s/A/3/g;
       $SecSerialKeyNumeric =~ s/B/4/g;
       $SecSerialKeyNumeric =~ s/C/5/g;
       $SecSerialKeyNumeric =~ s/D/6/g;
       $SecSerialKeyNumeric =~ s/E/7/g;
       $SecSerialKeyNumeric =~ s/F/8/g;
       $SecSerialKeyNumeric =~ s/G/1/g;
       $SecSerialKeyNumeric =~ s/H/2/g;
       $SecSerialKeyNumeric =~ s/I/3/g;
       $SecSerialKeyNumeric =~ s/J/4/g;
       $SecSerialKeyNumeric =~ s/K/5/g;
       $SecSerialKeyNumeric =~ s/L/6/g;
       $SecSerialKeyNumeric =~ s/M/7/g;
       $SecSerialKeyNumeric =~ s/N/8/g;
       $SecSerialKeyNumeric =~ s/O/1/g;
       $SecSerialKeyNumeric =~ s/P/2/g;
       $SecSerialKeyNumeric =~ s/Q/3/g;
       $SecSerialKeyNumeric =~ s/R/4/g;
       $SecSerialKeyNumeric =~ s/S/5/g;
       $SecSerialKeyNumeric =~ s/T/6/g;
       $SecSerialKeyNumeric =~ s/U/7/g;
       $SecSerialKeyNumeric =~ s/V/8/g;
       $SecSerialKeyNumeric =~ s/W/1/g;
       $SecSerialKeyNumeric =~ s/X/2/g;
       $SecSerialKeyNumeric =~ s/Y/3/g;
       $SecSerialKeyNumeric =~ s/Z/4/g;
       $SecSerialKeyNumeric =~ s/a/5/g;
       $SecSerialKeyNumeric =~ s/b/6/g;
       $SecSerialKeyNumeric =~ s/c/7/g;
       $SecSerialKeyNumeric =~ s/d/8/g;
       $SecSerialKeyNumeric =~ s/e/1/g;
       $SecSerialKeyNumeric =~ s/f/2/g;
       $SecSerialKeyNumeric =~ s/g/3/g;
       $SecSerialKeyNumeric =~ s/h/4/g;
       $SecSerialKeyNumeric =~ s/i/5/g;
       $SecSerialKeyNumeric =~ s/j/6/g;
       $SecSerialKeyNumeric =~ s/k/7/g;
       $SecSerialKeyNumeric =~ s/l/8/g;
       $SecSerialKeyNumeric =~ s/m/1/g;
       $SecSerialKeyNumeric =~ s/n/2/g;
       $SecSerialKeyNumeric =~ s/o/3/g;
       $SecSerialKeyNumeric =~ s/p/4/g;
       $SecSerialKeyNumeric =~ s/q/5/g;
       $SecSerialKeyNumeric =~ s/r/6/g;
       $SecSerialKeyNumeric =~ s/s/7/g;
       $SecSerialKeyNumeric =~ s/t/8/g;
       $SecSerialKeyNumeric =~ s/u/1/g;
       $SecSerialKeyNumeric =~ s/v/2/g;
       $SecSerialKeyNumeric =~ s/w/3/g;
       $SecSerialKeyNumeric =~ s/x/4/g;
       $SecSerialKeyNumeric =~ s/y/5/g;
       $SecSerialKeyNumeric =~ s/z/6/g;
       @SecSerialKeyNumericArray = split (//,$SecSerialKeyNumeric);
       foreach $CharacterNumberInside(@SecSerialKeyNumericArray) {
         if ($CharacterNumberInside =~ m/[1-8]/) {
           $SecSerialKeyNice = $SecSerialKeyNice."chr($CharacterNumberInside) . ";
           $SecSerialKey = $SecSerialKey.chr($CharacterNumberInside);
         }
       }
     }
     if ($ContentsLine =~ "SecManu") {
       @SecManuKeyArray = split(/\§/,$ContentsLine);
       $SecManuKeyNumeric = $SecManuKeyArray[3];
       $SecManuKeyNumeric =~ s/0/5/g;
       $SecManuKeyNumeric =~ s/9/6/g;
       $SecManuKeyNumeric =~ s/A/7/g;
       $SecManuKeyNumeric =~ s/B/8/g;
       $SecManuKeyNumeric =~ s/C/1/g;
       $SecManuKeyNumeric =~ s/D/2/g;
       $SecManuKeyNumeric =~ s/E/3/g;
       $SecManuKeyNumeric =~ s/F/4/g;
       $SecManuKeyNumeric =~ s/G/5/g;
       $SecManuKeyNumeric =~ s/H/6/g;
       $SecManuKeyNumeric =~ s/I/7/g;
       $SecManuKeyNumeric =~ s/J/8/g;
       $SecManuKeyNumeric =~ s/K/1/g;
       $SecManuKeyNumeric =~ s/L/2/g;
       $SecManuKeyNumeric =~ s/M/3/g;
       $SecManuKeyNumeric =~ s/N/4/g;
       $SecManuKeyNumeric =~ s/O/5/g;
       $SecManuKeyNumeric =~ s/P/6/g;
       $SecManuKeyNumeric =~ s/Q/7/g;
       $SecManuKeyNumeric =~ s/R/8/g;
       $SecManuKeyNumeric =~ s/S/1/g;
       $SecManuKeyNumeric =~ s/T/2/g;
       $SecManuKeyNumeric =~ s/U/3/g;
       $SecManuKeyNumeric =~ s/V/4/g;
       $SecManuKeyNumeric =~ s/W/5/g;
       $SecManuKeyNumeric =~ s/X/6/g;
       $SecManuKeyNumeric =~ s/Y/7/g;
       $SecManuKeyNumeric =~ s/Z/8/g;
       $SecManuKeyNumeric =~ s/a/1/g;
       $SecManuKeyNumeric =~ s/b/2/g;
       $SecManuKeyNumeric =~ s/c/3/g;
       $SecManuKeyNumeric =~ s/d/4/g;
       $SecManuKeyNumeric =~ s/e/5/g;
       $SecManuKeyNumeric =~ s/f/6/g;
       $SecManuKeyNumeric =~ s/g/7/g;
       $SecManuKeyNumeric =~ s/h/8/g;
       $SecManuKeyNumeric =~ s/i/1/g;
       $SecManuKeyNumeric =~ s/j/2/g;
       $SecManuKeyNumeric =~ s/k/3/g;
       $SecManuKeyNumeric =~ s/l/4/g;
       $SecManuKeyNumeric =~ s/m/5/g;
       $SecManuKeyNumeric =~ s/n/6/g;
       $SecManuKeyNumeric =~ s/o/7/g;
       $SecManuKeyNumeric =~ s/p/8/g;
       $SecManuKeyNumeric =~ s/q/1/g;
       $SecManuKeyNumeric =~ s/r/2/g;
       $SecManuKeyNumeric =~ s/s/3/g;
       $SecManuKeyNumeric =~ s/t/4/g;
       $SecManuKeyNumeric =~ s/u/5/g;
       $SecManuKeyNumeric =~ s/v/6/g;
       $SecManuKeyNumeric =~ s/w/7/g;
       $SecManuKeyNumeric =~ s/x/8/g;
       $SecManuKeyNumeric =~ s/y/1/g;
       $SecManuKeyNumeric =~ s/z/2/g;
       @SecManuKeyNumericArray = split (//,$SecManuKeyNumeric);
       foreach $CharacterNumberInside(@SecManuKeyNumericArray) {
         if ($CharacterNumberInside =~ m/[1-8]/) {
           $SecManuKeyNice = $SecManuKeyNice."chr($CharacterNumberInside) . ";
           $SecManuKey = $SecManuKey.chr($CharacterNumberInside);
         }
       }
     }
     if ($ContentsLine =~ "SecManu") {
       @SecManuKeyArray = split(/\§/,$ContentsLine);
       $PreSortedSecManuKey = $SecManuKeyArray[3];
       @PreSortedSecManuKeyArray = split(//,$PreSortedSecManuKey);
       @SortedSecManuKeyArray = sort (@PreSortedSecManuKeyArray);
       $SecManuKeyNumeric = join("",@SortedSecManuKeyArray);
       $SecManuKeyNumeric =~ s/0/8/g;
       $SecManuKeyNumeric =~ s/9/1/g;
       $SecManuKeyNumeric =~ s/A/2/g;
       $SecManuKeyNumeric =~ s/B/3/g;
       $SecManuKeyNumeric =~ s/C/4/g;
       $SecManuKeyNumeric =~ s/D/5/g;
       $SecManuKeyNumeric =~ s/E/6/g;
       $SecManuKeyNumeric =~ s/F/7/g;
       $SecManuKeyNumeric =~ s/G/8/g;
       $SecManuKeyNumeric =~ s/H/1/g;
       $SecManuKeyNumeric =~ s/I/2/g;
       $SecManuKeyNumeric =~ s/J/3/g;
       $SecManuKeyNumeric =~ s/K/4/g;
       $SecManuKeyNumeric =~ s/L/5/g;
       $SecManuKeyNumeric =~ s/M/6/g;
       $SecManuKeyNumeric =~ s/N/7/g;
       $SecManuKeyNumeric =~ s/O/8/g;
       $SecManuKeyNumeric =~ s/P/1/g;
       $SecManuKeyNumeric =~ s/Q/2/g;
       $SecManuKeyNumeric =~ s/R/3/g;
       $SecManuKeyNumeric =~ s/S/4/g;
       $SecManuKeyNumeric =~ s/T/5/g;
       $SecManuKeyNumeric =~ s/U/6/g;
       $SecManuKeyNumeric =~ s/V/7/g;
       $SecManuKeyNumeric =~ s/W/8/g;
       $SecManuKeyNumeric =~ s/X/1/g;
       $SecManuKeyNumeric =~ s/Y/2/g;
       $SecManuKeyNumeric =~ s/Z/3/g;
       $SecManuKeyNumeric =~ s/a/4/g;
       $SecManuKeyNumeric =~ s/b/5/g;
       $SecManuKeyNumeric =~ s/c/6/g;
       $SecManuKeyNumeric =~ s/d/7/g;
       $SecManuKeyNumeric =~ s/e/8/g;
       $SecManuKeyNumeric =~ s/f/1/g;
       $SecManuKeyNumeric =~ s/g/2/g;
       $SecManuKeyNumeric =~ s/h/3/g;
       $SecManuKeyNumeric =~ s/i/4/g;
       $SecManuKeyNumeric =~ s/j/5/g;
       $SecManuKeyNumeric =~ s/k/6/g;
       $SecManuKeyNumeric =~ s/l/7/g;
       $SecManuKeyNumeric =~ s/m/8/g;
       $SecManuKeyNumeric =~ s/n/1/g;
       $SecManuKeyNumeric =~ s/o/2/g;
       $SecManuKeyNumeric =~ s/p/3/g;
       $SecManuKeyNumeric =~ s/q/4/g;
       $SecManuKeyNumeric =~ s/r/5/g;
       $SecManuKeyNumeric =~ s/s/6/g;
       $SecManuKeyNumeric =~ s/t/7/g;
       $SecManuKeyNumeric =~ s/u/8/g;
       $SecManuKeyNumeric =~ s/v/1/g;
       $SecManuKeyNumeric =~ s/w/2/g;
       $SecManuKeyNumeric =~ s/x/3/g;
       $SecManuKeyNumeric =~ s/y/4/g;
       $SecManuKeyNumeric =~ s/z/5/g;
       @SortedSecManuKeyNumericArray = split (//,$SecManuKeyNumeric);
       foreach $CharacterNumberInside(@SortedSecManuKeyNumericArray) {
         if ($CharacterNumberInside =~ m/[1-8]/) {
           $SortedSecManuKeyNice = $SortedSecManuKeyNice."chr($CharacterNumberInside) . ";
           $SortedSecManuKey = $SortedSecManuKey.chr($CharacterNumberInside);
         }
       }
     }
     if ($ContentsLine =~ "SecManu") {
       @RevSortedSecManuKeyArray = reverse (@SortedSecManuKeyArray);
       $SecManuKeyNumeric = join("",@RevSortedSecManuKeyArray);
       $SecManuKeyNumeric =~ s/0/4/g;
       $SecManuKeyNumeric =~ s/9/5/g;
       $SecManuKeyNumeric =~ s/A/6/g;
       $SecManuKeyNumeric =~ s/B/7/g;
       $SecManuKeyNumeric =~ s/C/8/g;
       $SecManuKeyNumeric =~ s/D/1/g;
       $SecManuKeyNumeric =~ s/E/2/g;
       $SecManuKeyNumeric =~ s/F/3/g;
       $SecManuKeyNumeric =~ s/G/4/g;
       $SecManuKeyNumeric =~ s/H/5/g;
       $SecManuKeyNumeric =~ s/I/6/g;
       $SecManuKeyNumeric =~ s/J/7/g;
       $SecManuKeyNumeric =~ s/K/8/g;
       $SecManuKeyNumeric =~ s/L/1/g;
       $SecManuKeyNumeric =~ s/M/2/g;
       $SecManuKeyNumeric =~ s/N/3/g;
       $SecManuKeyNumeric =~ s/O/4/g;
       $SecManuKeyNumeric =~ s/P/5/g;
       $SecManuKeyNumeric =~ s/Q/6/g;
       $SecManuKeyNumeric =~ s/R/7/g;
       $SecManuKeyNumeric =~ s/S/8/g;
       $SecManuKeyNumeric =~ s/T/1/g;
       $SecManuKeyNumeric =~ s/U/2/g;
       $SecManuKeyNumeric =~ s/V/3/g;
       $SecManuKeyNumeric =~ s/W/4/g;
       $SecManuKeyNumeric =~ s/X/5/g;
       $SecManuKeyNumeric =~ s/Y/6/g;
       $SecManuKeyNumeric =~ s/Z/7/g;
       $SecManuKeyNumeric =~ s/a/8/g;
       $SecManuKeyNumeric =~ s/b/1/g;
       $SecManuKeyNumeric =~ s/c/2/g;
       $SecManuKeyNumeric =~ s/d/3/g;
       $SecManuKeyNumeric =~ s/e/4/g;
       $SecManuKeyNumeric =~ s/f/5/g;
       $SecManuKeyNumeric =~ s/g/6/g;
       $SecManuKeyNumeric =~ s/h/7/g;
       $SecManuKeyNumeric =~ s/i/8/g;
       $SecManuKeyNumeric =~ s/j/1/g;
       $SecManuKeyNumeric =~ s/k/2/g;
       $SecManuKeyNumeric =~ s/l/3/g;
       $SecManuKeyNumeric =~ s/m/4/g;
       $SecManuKeyNumeric =~ s/n/5/g;
       $SecManuKeyNumeric =~ s/o/6/g;
       $SecManuKeyNumeric =~ s/p/7/g;
       $SecManuKeyNumeric =~ s/q/8/g;
       $SecManuKeyNumeric =~ s/r/1/g;
       $SecManuKeyNumeric =~ s/s/2/g;
       $SecManuKeyNumeric =~ s/t/3/g;
       $SecManuKeyNumeric =~ s/u/4/g;
       $SecManuKeyNumeric =~ s/v/5/g;
       $SecManuKeyNumeric =~ s/w/6/g;
       $SecManuKeyNumeric =~ s/x/7/g;
       $SecManuKeyNumeric =~ s/y/8/g;
       $SecManuKeyNumeric =~ s/z/1/g;
       @RevSortedSecManuKeyNumericArray = split (//,$SecManuKeyNumeric);
       foreach $CharacterNumberInside(@RevSortedSecManuKeyNumericArray) {
         if ($CharacterNumberInside =~ m/[1-8]/) {
           $RevSortedSecManuKeyNice = $RevSortedSecManuKeyNice."chr($CharacterNumberInside) . ";
           $RevSortedSecManuKey = $RevSortedSecManuKey.chr($CharacterNumberInside);
         }
       }
     }
     if ($ContentsLine =~ "GeheimeSleutel") {
       @SecurityKeyArray = split(/\§/,$ContentsLine);
       $SecurityKeyHex = $SecurityKeyArray[3];
       $SecurityKeyHexPlus = "http://www.bermudaword.com/register/".$SecurityKeyArray[3];
       $SecurityKeyNumeric = $SecurityKeyHexPlus;
       $SecurityKeyNumeric =~ s/0/7/g;
       $SecurityKeyNumeric =~ s/9/8/g;
       $SecurityKeyNumeric =~ s/A/1/g;
       $SecurityKeyNumeric =~ s/B/2/g;
       $SecurityKeyNumeric =~ s/C/3/g;
       $SecurityKeyNumeric =~ s/D/4/g;
       $SecurityKeyNumeric =~ s/E/5/g;
       $SecurityKeyNumeric =~ s/F/6/g;
       $SecurityKeyNumeric =~ s/G/7/g;
       $SecurityKeyNumeric =~ s/H/8/g;
       $SecurityKeyNumeric =~ s/I/1/g;
       $SecurityKeyNumeric =~ s/J/2/g;
       $SecurityKeyNumeric =~ s/K/3/g;
       $SecurityKeyNumeric =~ s/L/4/g;
       $SecurityKeyNumeric =~ s/M/5/g;
       $SecurityKeyNumeric =~ s/N/6/g;
       $SecurityKeyNumeric =~ s/O/7/g;
       $SecurityKeyNumeric =~ s/P/8/g;
       $SecurityKeyNumeric =~ s/Q/1/g;
       $SecurityKeyNumeric =~ s/R/2/g;
       $SecurityKeyNumeric =~ s/S/3/g;
       $SecurityKeyNumeric =~ s/T/4/g;
       $SecurityKeyNumeric =~ s/U/5/g;
       $SecurityKeyNumeric =~ s/V/6/g;
       $SecurityKeyNumeric =~ s/W/7/g;
       $SecurityKeyNumeric =~ s/X/8/g;
       $SecurityKeyNumeric =~ s/Y/1/g;
       $SecurityKeyNumeric =~ s/Z/2/g;
       $SecurityKeyNumeric =~ s/a/3/g;
       $SecurityKeyNumeric =~ s/b/4/g;
       $SecurityKeyNumeric =~ s/c/5/g;
       $SecurityKeyNumeric =~ s/d/6/g;
       $SecurityKeyNumeric =~ s/e/7/g;
       $SecurityKeyNumeric =~ s/f/8/g;
       $SecurityKeyNumeric =~ s/g/1/g;
       $SecurityKeyNumeric =~ s/h/2/g;
       $SecurityKeyNumeric =~ s/i/3/g;
       $SecurityKeyNumeric =~ s/j/4/g;
       $SecurityKeyNumeric =~ s/k/5/g;
       $SecurityKeyNumeric =~ s/l/6/g;
       $SecurityKeyNumeric =~ s/m/7/g;
       $SecurityKeyNumeric =~ s/n/8/g;
       $SecurityKeyNumeric =~ s/o/1/g;
       $SecurityKeyNumeric =~ s/p/2/g;
       $SecurityKeyNumeric =~ s/q/3/g;
       $SecurityKeyNumeric =~ s/r/4/g;
       $SecurityKeyNumeric =~ s/s/5/g;
       $SecurityKeyNumeric =~ s/t/6/g;
       $SecurityKeyNumeric =~ s/u/7/g;
       $SecurityKeyNumeric =~ s/v/8/g;
       $SecurityKeyNumeric =~ s/w/1/g;
       $SecurityKeyNumeric =~ s/x/2/g;
       $SecurityKeyNumeric =~ s/y/3/g;
       $SecurityKeyNumeric =~ s/z/4/g;
       $SecurityKeyNumeric =~ s/\///g;
       $SecurityKeyNumeric =~ s/\.//g;
       $SecurityKeyNumeric =~ s/\://g;
       $SecurityKeyNumeric =~ s/\-//g;
       @SecurityKeyNumericArray = split (//,$SecurityKeyNumeric);
       foreach $CharacterNumberInside(@SecurityKeyNumericArray) {
         if ($CharacterNumberInside =~ m/[1-8]/) {
           $SecurityKeyNice = $SecurityKeyNice."chr($CharacterNumberInside) . ";
           $SecurityKey = $SecurityKey.chr($CharacterNumberInside);
         }
       }
     }
   }
   close (SERIALANDDISKKEYS) ;
   
   #Add RevSecManuKey before EncryptionKey (so in principle there's no key in the executable that can decrypt first part of file)
   $EncryptionKey = $RevSecManuKey.$EncryptionKeys[0];
   $EncryptionKeyNice = $RevSecManuKeyNice." . ".$EncryptionKeysNice[0];
   
   # get length of Encryptionkey   
   $LengthEncryptionKey = length $EncryptionKey;
   if ($TRACING eq "ON") {
     print "Defined base Encryption key. Length now: ".$LengthEncryptionKey."\n";
   } else { print ".";}
   
   # add Space value to key
   $EncryptionKey = $EncryptionKey.$SecSpaceKey;
   $EncryptionKeyNice = $EncryptionKeyNice." . ".$SecSpaceKeyNice;
   
   $LengthEncryptionKey = length $EncryptionKey;
   if ($TRACING eq "ON") {
     print "Added Space. Encryption key length now: ".$LengthEncryptionKey."\n";
   } else { print ".";}
   
   # add random value to key just to make it more difficult
   $EncryptionKey = $EncryptionKey.$EncryptionKeys[1]; #more
   $EncryptionKeyNice = $EncryptionKeyNice." . ".$EncryptionKeysNice[1];
   
   $LengthEncryptionKey = length $EncryptionKey;
   if ($TRACING eq "ON") {
     print "Added more random numbers. Encryption key length now: ".$LengthEncryptionKey."\n";
   } else { print ".";}
   
   # add serial value to key
   $EncryptionKey = $EncryptionKey.$SecSerialKey;
   $EncryptionKeyNice = $EncryptionKeyNice." . ".$SecSerialKeyNice;
   
   $LengthEncryptionKey = length $EncryptionKey;
   if ($TRACING eq "ON") {
     print "Added Serial. Encryption key length now: ".$LengthEncryptionKey."\n";
   } else { print ".";}
      
   # add random value to key just to make it more difficult
   $EncryptionKey = $EncryptionKey.$EncryptionKeys[2];
   $EncryptionKeyNice = $EncryptionKeyNice." . ".$EncryptionKeysNice[2];
   
   $LengthEncryptionKey = length $EncryptionKey;
   if ($TRACING eq "ON") {
     print "Added more random numbers. Encryption key length now: ".$LengthEncryptionKey."\n";
   } else { print ".";}
   
   # if manual code is there, add it to make it more difficult (just 1 if none)
   $EncryptionKey = $EncryptionKey.$SecManuKey;
   $EncryptionKeyNice = $EncryptionKeyNice." . ".$SecManuKeyNice;
   
   $LengthEncryptionKey = length $EncryptionKey;
   if ($TRACING eq "ON") {
     print "Added Manufacturers code. Encryption key length now: ".$LengthEncryptionKey."\n";
   } else { print ".";}
      
   # fourth batch of encryption key number
   $EncryptionKey = $EncryptionKey.$EncryptionKeys[3];
   $EncryptionKeyNice = $EncryptionKeyNice." . ".$EncryptionKeysNice[3];

   $LengthEncryptionKey = length $EncryptionKey ;
   if ($TRACING eq "ON") {
     print "Added more random numbers. Encryption key length now: ".$LengthEncryptionKey."\n";
   } else { print ".";}
   
   # add sorted manual key
   $EncryptionKey = $EncryptionKey.$SortedSecManuKey;
   $EncryptionKeyNice = $EncryptionKeyNice." . ".$SortedSecManuKeyNice;
   
   $LengthEncryptionKey = length $EncryptionKey;
   if ($TRACING eq "ON") {
     print "Added sorted Manufacturers code. ".$SortedSecManuKeyNice.". Encryption key length now: ".$LengthEncryptionKey."\n";
   } else { print ".";}

   # add fifth batch of encryption key number
   $EncryptionKey = $EncryptionKey.$EncryptionKeys[4];
   $EncryptionKeyNice = $EncryptionKeyNice." . ".$EncryptionKeysNice[4];

   $LengthEncryptionKey = length $EncryptionKey ;
   if ($TRACING eq "ON") {
     print "Added more random numbers. Encryption key length now: ".$LengthEncryptionKey."\n";
   } else { print ".";}
   
   # add reverse sorted manual key
   $EncryptionKey = $EncryptionKey.$RevSortedSecManuKey;
   $EncryptionKeyNice = $EncryptionKeyNice." . ".$RevSortedSecManuKeyNice;
   
   $LengthEncryptionKey = length $EncryptionKey;
   if ($TRACING eq "ON") {
     print "Added revsorted Manufacturers code. ".$RevSortedSecManuKeyNice.". Encryption key length now: ".$LengthEncryptionKey."\n";
   } else { print ".";}

   # add sixth batch of encryption key number
   $EncryptionKey = $EncryptionKey.$EncryptionKeys[5];
   $EncryptionKeyNice = $EncryptionKeyNice." . ".$EncryptionKeysNice[5];

   $LengthEncryptionKey = length $EncryptionKey ;
   if ($TRACING eq "ON") {
     print "Added more random numbers. Encryption key length now: ".$LengthEncryptionKey."\n";

     print "Encryption: $EncryptionKeyNice\n" ;
     print "EncLength: $LengthEncryptionKey\n" ;
   } else { print ".";}
   
   # NOW ADD VERSION WITH SECURITY KEY!!!
   
   $EncryptionKeyExtended = $EncryptionKey.$SecurityKey ;
   $LengthSecurityKeyNumeric = length $SecurityKeyNumeric ;
   if ($TRACING eq "ON") {
     print "Added extended version with added SecurityKey ".$SecurityKeyNumeric." and length ".$LengthSecurityKeyNumeric."...\n";
   } else { print ".";}

   # turn encryption key into ascii number array
   open (ENCKEYFILE,">EncKeyFile.txt");
   @EncryptionKeySplit = split(//,$EncryptionKey);
   foreach $EncryptionKeyPart(@EncryptionKeySplit)
   {
      $EncryptionKeyPartCode = ord $EncryptionKeyPart;
      @EncryptionKey = push (@EncryptionKey,$EncryptionKeyPartCode);
      print ENCKEYFILE "$EncryptionKeyPart=Chr(".$EncryptionKeyPartCode.")+";
   }

   #For now, drop key in file, will be taken out to use for encrypt, and if new to put in exe
   close ENCKEYFILE;
   
   # Put EncryptionKey in a file to add to /Digital/<ProdLanguage>-<ProdGroup>-<UniqueKey>/ path
   # so we can use it if reloading a product...
   $EncryptionKeyPlusSecurityKeySeparated = $EncryptionKey."###".$SecurityKey;
   $lengthEncryptionKeyPlusSecurityKeySeparated = length $EncryptionKeyPlusSecurityKeySeparated;
   if ($TRACING eq "ON") {
     print "Creating EncryptionKey.txt file with key of length ".$lengthEncryptionKeyPlusSecurityKeySeparated."\n";
   } else { print ".";}
   open (ENCKEYFILE,">EncryptionKey.txt");
   print ENCKEYFILE $EncryptionKeyPlusSecurityKeySeparated;
   close ENCKEYFILE;
   ### HERE WE MIGHT EXPERIENCE ISSUES BECAUSE WE'RE THROWING UGLY CHARS IN TXT FILE

}



#################################################################################
# CHECK IF PRODUCTION DIRECTORY FOR LANGUAGE AND GROUP ALREADY EXIST, SKIP IF QUICK
# IF QUICK WE ASSUME ALL IS IN PLACE
if ($QUICK ne "ON") {
  if (-e "..\\..\\Production\\$ProdLanguage")
  {
    #kont in you
  }
  else
  {
    `mkdir ..\\..\\Production\\$ProdLanguage`;
  }
  if (-e "..\\..\\Production\\$ProdLanguage\\$ProdGroup")
  {
    #kont in you
  }
  else
  {
    `mkdir "..\\..\\Production\\$ProdLanguage\\$ProdGroup"`;
  }
  if (-e "..\\..\\Production\\$ProdLanguage\\$ProdGroup\\Config")
  {
    #kont in you
  }
  else
  {
    `mkdir "..\\..\\Production\\$ProdLanguage\\$ProdGroup\\Config"`;
  } 
  if (-e "..\\..\\Production\\$ProdLanguage\\$ProdGroup\\Data")
  {
    #kont in you
  }
  else
  {
    `mkdir "..\\..\\Production\\$ProdLanguage\\$ProdGroup\\Data"`;
  }
  if (-e "..\\..\\Production\\$ProdLanguage\\$ProdGroup\\Media")
  {
    #kont in you
    `del /Q "..\\..\\Production\\$ProdLanguage\\$ProdGroup\\Media\\*"`;
  }
  else
  {
    `mkdir "..\\..\\Production\\$ProdLanguage\\$ProdGroup\\Media"`;
  }
  if (-e "..\\..\\Production\\$ProdLanguage\\$ProdGroup\\System")
  {
    #kont in you, clean LUSB.exe out of there
    `del /Q "..\\..\\Production\\$ProdLanguage\\$ProdGroup\\System\\LUSB.exe"`;
  }
  else
  {
    `mkdir "..\\..\\Production\\$ProdLanguage\\$ProdGroup\\System"`;
  }
}


##############################################################################
# Create Config file (the same for every unique key)
#
# VB config extraction can't handle empty values, put "Default" in Taal if empty
$FileNameLanguage = $TransLanguage;
if ($TransLanguage eq "")        { $TLN = 1; $TransLanguage = "Default"; $FilenameLanguage = ""; }
if ($TransLanguage eq "Dutch")   { $TLN = 2; $FilenameLanguage = "Dutch"; }
if ($TransLanguage eq "French")  { $TLN = 3; $FilenameLanguage = "French"; }
if ($TransLanguage eq "German")  { $TLN = 4; $FilenameLanguage = "German"; }
if ($TransLanguage eq "Spanish") { $TLN = 5; $FilenameLanguage = "Spanish"; }
if ($TransLanguage eq "Portuguese") {$TLN=6; $FilenameLanguage = "Portuguese"; }
### !!! $FilenameLanguage WORDT NIET MEER GEBRUIKT, DELETE!!!!!!!!

#translate help, information and messaging, get contents of Messages.htm for use in Config file
$MessagingTranslationFile = "..\\Base\\Parse\\Main\\Messages.htm" ;
open (MESSTRANS, "<$MessagingTranslationFile") || die "file $MessagingTranslationFile kan niet worden gevonden, ($!)\n";
@MessTransEntries = <MESSTRANS>;
close MESSTRANS;


###################################################################################
# GET SOME DATA
# read total and unique word count from "Info" file...
$TheInfoFile = "..\\..\\Languages\\$Language\\HTML\\Main\\Info.htm" ;
$ReadFile = $TheInfoFile ;
open (READFILE, "$ReadFile") || die "file $ReadFile cannot be found. ($!)\n";
@ALLTEXT = <READFILE>;
close (READFILE);
$ALLTEXT = join ("",@ALLTEXT) ;
($GEEUW,$TotalWordCount,$GAAP) = split(/<<<TOTALWORDS>>>/,$ALLTEXT) ;
($GEEUW,$UniqueWords,$GAAP) = split(/<<<UNIQUEWORDS>>>/,$ALLTEXT);

$PercentageRaw = ($UniqueWords/$TotalWordCount)*100;
($Percentage,$Dummy) = split(/\.|\,/,$PercentageRaw);
$TOTALBOOKNAME = $TitleOrg;
$TOTALBOOKWORDS = $TotalWordCount;
$TOTALBOOKUNIQUEWORDS = $UniqueWords;
$TOTALBOOKNEWWORDS = $UniqueWords;
$TOTALBOOKPERCENTAGE = $Percentage;


###################################################################################
# CREATE CONFIG FILE
$DivChar = "<BR>";
if ($TRACING eq "ON") {
  print "Creating config file...\n";
} else { print "."; }
# ff de config aanpassen
@Contents = ();
$Contents[0] = "<html>".$DivChar;
$Contents[1] = "<!-- THIS IS THE CONFIGURATION FILE FOR $Language".$DivChar;
$Contents[2] = "$ProdLanguage - $TitleOrg".$DivChar;
$Contents[3] = "$ProdLanguage - $Title".$DivChar;
$Contents[4] = "PLEASE DON'T COPY OR EDIT THIS AS THE PROGRAM MIGHT NOT WORK IF YOU DO".$DivChar;
$Contents[5] = "Empty".$DivChar;
$Contents[6] = "Empty".$DivChar;
$Contents[7] = "CourseInformation:".$DivChar;
$Contents[8] = "$LengthChapterNamesArray,$TotalWordCount,$UniqueWords".$DivChar;
$Contents[9] = "$DEBUG,$EDITMODE".$DivChar;
$Contents[10] = ":".$TOOLEDITPATH."\\Production\\$ProdLanguage\\$ProdGroup\\".$DivChar;
$Contents[11] = "Bermuda Word".$DivChar;
$Contents[12] = "$Language".$DivChar;
$Contents[13] = "Main,".$Group.$DivChar;
$Contents[14] = "HypLernWords".$DivChar;
$Contents[15] = "$TransLanguage".$DivChar;
$Contents[16] = "<<<TOTALBOOKNAME>>>=$TOTALBOOKNAME,";
$Contents[16] = $Contents[16]."<<<TOTALBOOKWORDS>>>=$TOTALBOOKWORDS,";
$Contents[16] = $Contents[16]."<<<TOTALBOOKUNIQUEWORDS>>>=$TOTALBOOKUNIQUEWORDS,";
$Contents[16] = $Contents[16]."<<<TOTALBOOKNEWWORDS>>>=$TOTALBOOKNEWWORDS,";
$Contents[16] = $Contents[16]."<<<TOTALBOOKNEWWORDSPERCENTAGE>>>=$TOTALBOOKPERCENTAGE,";
$Contents[16] = $Contents[16]."<<<LEARNERTYPEVALUE>>>=<<<Average>>>,";
$Contents[16] = $Contents[16]."<<<LEARNERPACEVALUE>>>=<<<Between Fast And Optimal>>>,";
$Contents[16] = $Contents[16]."<<<RETENTIONFACTOR>>>=12,";
$Contents[16] = $Contents[16]."<<<CHAPTERTESTFACTOR>>>=3,";
$Contents[16] = $Contents[16]."<<<EASYFREQ>>>=6,";
$Contents[16] = $Contents[16]."<<<AVERFREQTOP>>>=5,";
$Contents[16] = $Contents[16]."<<<AVERFREQ>>>=3,";
$Contents[16] = $Contents[16]."<<<DIFFFREQTOP>>>=2,";
$Contents[16] = $Contents[16]."<<<DIFFFREQ>>>=1,";
$Contents[16] = $Contents[16]."<<<SRSINCR>>>=<<<Equally Spaced>>>,";
$Contents[16] = $Contents[16]."<<<AgeOrNextReminder>>>=<<<NextReminder>>>,";
$Contents[16] = $Contents[16]."<<<SRSINCRFAC>>>=1,";
$Contents[16] = $Contents[16]."<<<SRSINCRRAW>>>=86400,";
$Contents[16] = $Contents[16]."<<<SRSFMIN>>>=1440,";
$Contents[16] = $Contents[16]."<<<SRSFHRS>>>=24,";
$Contents[16] = $Contents[16]."<<<SRSFDYS>>>=1,";
$Contents[16] = $Contents[16]."<<<SRSUNIT>>>=<<<days>>>,";
$Contents[16] = $Contents[16]."<<<SRSMARGN>>>=10,";
$Contents[16] = $Contents[16]."<<<COMMA>>>=&#44;,";
$Contents[16] = $Contents[16]."<<<SRSMISD>>>=1,";
$Contents[16] = $Contents[16]."<<<SRSMISDNICE>>>=1,";
$Contents[16] = $Contents[16]."<<<SRSTSER>>>=1,";
$Contents[16] = $Contents[16]."<<<SRSTSERNICE>>>=1,";
$Contents[16] = $Contents[16]."<<<SRSSCHED>>>=1<<<COMMA>>> 2<<<COMMA>>> 3<<<COMMA>>> etc. <<<days>>> <<<after>>> <<<first>>> '<<<meet>>>',";
$Contents[16] = $Contents[16]."<<<SRSREM0>>>=0,";
$Contents[16] = $Contents[16]."<<<SRSREM1>>>=86400,";
$Contents[16] = $Contents[16]."<<<SRSREM2>>>=172800,";
$Contents[16] = $Contents[16]."<<<SRSREM3>>>=259200,";
$Contents[16] = $Contents[16]."<<<SRSREM4>>>=345600,";
$Contents[16] = $Contents[16]."<<<SRSREM5>>>=432000,";
$Contents[16] = $Contents[16]."<<<SRSREM6>>>=518400,";
$Contents[16] = $Contents[16]."<<<SRSREM7>>>=604800,";
$Contents[16] = $Contents[16]."<<<SRSREM8>>>=691200,";
$Contents[16] = $Contents[16]."<<<SRSREM9>>>=777600,";
$Contents[16] = $Contents[16]."<<<SRSREM10>>>=864000,";
$Contents[16] = $Contents[16]."<<<SRSREM11>>>=950400,";
$Contents[16] = $Contents[16]."<<<SRSREM12>>>=1036800,";
$Contents[16] = $Contents[16]."<<<SRSREM13>>>=1123200,";
$Contents[16] = $Contents[16]."<<<SRSREM14>>>=1209600,";
$Contents[16] = $Contents[16]."<<<SRSREM15>>>=1296000,";
$Contents[16] = $Contents[16]."<<<SRSREM16>>>=1382400,";
$Contents[16] = $Contents[16]."<<<SRSREM17>>>=1468800,";
$Contents[16] = $Contents[16]."<<<SRSREM18>>>=1555200,";
$Contents[16] = $Contents[16]."<<<SRSREM19>>>=1641600,";
$Contents[16] = $Contents[16]."<<<SRSREM20>>>=1728000,";
$Contents[16] = $Contents[16]."<<<SRSREM21>>>=1814400,";
$Contents[16] = $Contents[16]."<<<DURATION>>>=12 days,";
$Contents[16] = $Contents[16]."<<<NONEFIMYWONICE>>>=Unchecked,";
$Contents[16] = $Contents[16]."<<<ALSOHIFREQNICE>>>=Unchecked,";
$Contents[16] = $Contents[16]."<<<KEEPTESTEDNICE>>>=Unchecked,";
$Contents[16] = $Contents[16]."<<<MYWOFLCARDNICE>>>=Unchecked,";
$Contents[16] = $Contents[16]."<<<AUTOSAVINGNICE>>>=Unchecked,";
$Contents[16] = $Contents[16]."(((Whole Book)))=<<<Whole Book>>>,";
$Contents[16] = $Contents[16]."(((Easy Level)))=<<<Easy Level>>>,";
$Contents[16] = $Contents[16]."(((Average Level)))=<<<Average Level>>>,";
$Contents[16] = $Contents[16]."(((Difficult Level)))=<<<Difficult Level>>>,";
$Contents[16] = $Contents[16]."(((My Words)))=<<<My Words>>>,";
$ChapterNumber = 1;
foreach $ChapterName (@ChapterNames) {
  $Contents[16] = $Contents[16]."<<<CHAPTERNAME".$ChapterNumber.">>>=".$ChapterName.",";
  if ($ChapterNumber == 1) {
     $FirstChapterName = $ChapterName;
     $Contents[16] = $Contents[16]."<<<CHAPTERSTATUS".$ChapterNumber.">>>=<<<Unlocked>>>,";
  } else {
     $Contents[16] = $Contents[16]."<<<CHAPTERSTATUS".$ChapterNumber.">>>=<<<Locked>>>,";
  }
  $Contents[16] = $Contents[16]."<<<CHAPTERWORDS".$ChapterNumber.">>>=".$ChapterWords[$ChapterNumber].",";
  $Contents[16] = $Contents[16]."<<<CHAPTERUNIQUEWORDS".$ChapterNumber.">>>=".$ChapterUniqueWords[$ChapterNumber].",";
  $Contents[16] = $Contents[16]."<<<CHAPTERNEWWORDS".$ChapterNumber.">>>=".$ChapterNewWords[$ChapterNumber].",";
  $Contents[16] = $Contents[16]."<<<CHAPTERNEWPERCENTAGE".$ChapterNumber.">>>=".$ChapterNewPercentage[$ChapterNumber].",";
  if ($TRACING eq "ON") {
    print "Adding ChapterName ".$ChapterName." to configfile...\n";
  } else { print ".";}
  #`pause`;
  $ChapterNumber = $ChapterNumber + 1;
}
$Contents[16] = $Contents[16]."<<<THISTESTTITLE>>>=1,";
$Contents[16] = $Contents[16]."<<<THISTESTNUMBER>>>=1,";
$Contents[16] = $Contents[16]."<<<TEACHERCURRENTMYWORDSNUMBER>>>=0,";
$Contents[16] = $Contents[16]."<<<NEWCHAPTERDONE>>>=No,";
$Contents[16] = $Contents[16]."<<<TEACHERLASTCHAPTERLASTPAGE>>>=".$LastChapterLastPage.",";
$Contents[16] = $Contents[16]."<<<TEACHERFINISHEDCHAPTERNUMBER>>>=0,";
$Contents[16] = $Contents[16]."<<<TEACHERCURRENTCHAPTERNUMBER>>>=1,";
$Contents[16] = $Contents[16]."<<<TEACHERCURRENTCHAPTERPROGRESSPIC>>>=0,";
$Contents[16] = $Contents[16]."<<<TEACHERCURRENTCHAPTERPAGE>>>=1,";
$Contents[16] = $Contents[16]."<<<TEACHERCURRENTCHAPTERLASTPAGE>>>=".$FirstChapterLastPage.",";
$Contents[16] = $Contents[16]."<<<TEACHERCURRENTCHAPTERTESTCOUNTER>>>=1,";
$Contents[16] = $Contents[16]."<<<TEACHERMODEWARNING>>>=<<<TeacherModeWarning>>>,";
$Contents[16] = $Contents[16]."<<<TeacherModeWarning>>>=<<<TeacherModeWarningBlah>>>,";
$Contents[16] = $Contents[16]."<<<MYFINISHEDBOOKS>>>=<#FB8>,";
$Contents[16] = $Contents[16]."<<<MYWORDSORDER>>>=<<<SORTORDERAZ>>>,";
$Contents[16] = $Contents[16]."<<<SORTORDERAZ>>>=AZ,";
$Contents[16] = $Contents[16]."<<<SORTORDERDT>>>=DT,";
$Contents[16] = $Contents[16]."<<<SORTORDERFQ>>>=FQ,";
$Contents[16] = $Contents[16]."<<<SORTORDERTQ>>>=TQ".$DivChar;
$Contents[17] = "<<<THEME>>>=LAYOUTBOOK=Books,";
$Contents[17] = $Contents[17]."<<<FONTFAMILY>>>=TIMESNEWROMAN=Times New Roman,";
$Contents[17] = $Contents[17]."<<<FONTSIZE>>>=FONTSIZE14=14,";
$Contents[17] = $Contents[17]."<<<LINEHEIGHT>>>=FONTSIZE14=18,";
$Contents[17] = $Contents[17]."<<<COLORSCHEMEBG>>>=PAGECOLORCODEWHITE=White.jpg,";
$Contents[17] = $Contents[17]."<<<COLORSCHEMETL>>>=TOOLCOLORCODEWHITE=White.jpg,";
$Contents[17] = $Contents[17]."<<<LAYOUTEXTRA>>>=LAYOUTDOUBLE=LAYOUTDOUBLE,";
$Contents[17] = $Contents[17]."<<<MARGINWIDTH>>>=LAYOUTDOUBLE=<<<DBLMARGINWIDTH>>>,";
$Contents[17] = $Contents[17]."<<<CELLWIDTH>>>=LAYOUTDOUBLE=<<<DBLCELLWIDTH>>>,";
$Contents[17] = $Contents[17]."<<<TABLEWIDTH>>>=TABLEWIDTH400=1000,";
$Contents[17] = $Contents[17]."<<<SINMARGINWIDTH>>>=TABLEWIDTH400=100,";
$Contents[17] = $Contents[17]."<<<SINCELLWIDTH>>>=TABLEWIDTH400=1200,";
$Contents[17] = $Contents[17]."<<<DBLMARGINWIDTH>>>=TABLEWIDTH400=100,";
$Contents[17] = $Contents[17]."<<<DBLCELLWIDTH>>>=TABLEWIDTH400=500,";
$Contents[17] = $Contents[17]."<<<MIDEDGE>>>=LAYOUTDOUBLE=<<<MIDEDGEDOUBLE>>>,";
$Contents[17] = $Contents[17]."<<<SAVEDLAYOUT>>>=SAVEDLAYOUT=LAYOUTDOUBLE,";
$Contents[17] = $Contents[17]."<<<SAVEDURL>>>=SAVEDURL=DUMMY,";
$Contents[17] = $Contents[17]."<<<MENUVISIBILITYSTATE>>>=MENUVISIBILITYSTATE=,";
$Contents[17] = $Contents[17]."<<<TEACHERMODECURRENT>>>=TEACHERMODEOFF=OFF,";
$Contents[17] = $Contents[17]."<<<TEACHERMODEOPPOSITE>>>=TEACHERMODEOFF=ON,";
$Contents[17] = $Contents[17]."<<<TEACHERMODEHELPCURRENT>>>=TEACHERMODEHELPOFF=OFF,";
$Contents[17] = $Contents[17]."<<<TEACHERMODEHELPOPPOSITE>>>=TEACHERMODEHELPOFF=ON,";
$Contents[17] = $Contents[17]."<<<TEACHERPERMISSION>>>=TEACHERTEMPPERMISSIONOFF=NO,";
$Contents[17] = $Contents[17]."<<<TEACHERHELPPERMISSION>>>=TEACHERHELPTEMPPERMISSIONOFF=NO,";
$Contents[17] = $Contents[17]."<<<BACKCOLOR>>>=BCTRANSP=transparent,";
$Contents[17] = $Contents[17]."<<<TOOLCOLOR>>>=TLTRANSP=transparent,";
$Contents[17] = $Contents[17]."<<<FONTCOLOR>>>=TX000000=000000".$DivChar;
$Contents[18] = "<<<PAGENUMBER>>>,1,<<<NEXTPAGE>>>,2".$DivChar;
$Contents[19] = "</html>".$DivChar;

# NOG LANGS MESSAGE PARSE HALEN VOORDAT JE CONFIG OPSLAAT!!!
if ($TRACING eq "ON") {
  print "To internationalise information, help and other messaging, change all occurrences of:\n";
} else { print ".";}
foreach $MessTransEntry (@MessTransEntries)
{
  @MessTransLine = split(/#/,$MessTransEntry);
  $MessGrep = $MessTransLine[0];
  $MessChange = $MessTransLine[$TLN];
  if ($Contents[16] =~ $MessGrep)
  {
    $Contents[16] =~ s/$MessGrep/$MessChange/g;
    if ($TRACING eq "ON") {
      print "$MessTransLine[0] to $MessTransLine[$TLN]\n";
    } else { print ".";}
  }
}
$Contents[16] =~ s/\(\(\(/\<\<\</g;
$Contents[16] =~ s/\)\)\)/\>\>\>/g;

# ff de config aanpassen op de compu in de userdir
#open (CONFIGFILE, ">..\\..\\Tool\\Config\\$configfile") || die "configfile ..\\..\\Tool\\Config\\$configfile is niet te maken. ($!)\n" ;
#print CONFIGFILE "@Contents" ;
#close (CONFIGFILE) ;

$ConfigContents = join("",@Contents) ;
if ($TRACING eq "ON") {
  print $ConfigContents;
} else { print ".";}

### END OF CREATING CONFIG FILE

if ($TRACING eq "ON") {
  print "Foreach sleutel in @SecurityKeyHexes...\n";
} else { print ".";}
foreach $SLEUTELT (@SecurityKeyHexes) {

   # check if we have a NEW key or are using an old one
   if ($SLEUTELT ne "NEW") {
   
      # change GeheimeSleutel in parse.htm to the one that we re-use (cause it's in the reloaded exe)
      
      # first find old securitykeyhex
      $file = "..\\..\\Languages\\$Language\\HTML\\Main\\parse.htm";
      open (SERIALANDDISKKEYS, "$file") || die "file $file is niet te vinden. ($!)\n" ;
      @Contents = <SERIALANDDISKKEYS> ;
      foreach $ContentsLine (@Contents) {
         if ($ContentsLine =~ "GeheimeSleutel") {
            @SecurityKeyArray = split(/\§/,$ContentsLine);
            $SecurityKeyHex = $SecurityKeyArray[3];
         }
      }
      close (SERIALANDDISKKEYS) ;
      

      $NewContents = join("",@Contents);
      $NewContents =~ s/$SecurityKeyHex/$SLEUTELT/g;

      # overwrite parse file with new code so VB has same key
      $file = "..\\..\\Languages\\$Language\\HTML\\Main\\parse.htm";
      open (SERIALANDDISKKEYS, ">$file") || die "file $file is niet te vinden. ($!)\n" ;
      print SERIALANDDISKKEYS $NewContents ;
      close (SERIALANDDISKKEYS) ;

      # use new sleutel
      $SecurityKeyHex = $SLEUTELT;
      
      if ($TRACING eq "ON") {
        print "Use sleutel $SecurityKeyHex\n";
      } else { print ".";}

   }


   # Delete old .dat and project files PER PRODUCT ROLLED OUT IN THIS SCRIPT SESSION, unless QUICK
   `del /Q ..\\Data\\hyplern*.dat` ; # if QUICK is on, only those Data files are created and copied to prod later on, that have changed
   if ($QUICK ne "ON") {
     `del /F /Q ..\\Media\\*.*` ;
   } else {
     # if QUICK is ON, find out which files we will have to change
     if ($QUICKFILES ne "") {
       $QuickPartList = "###";
       # find the corresponding dat files
       open (INDEXFILE, "<../../Languages/$Language/HTML/Main/$Indexfile") || die "Indexfile ../../Languages/$Language/HTML/index.htm kan niet worden geopend, ($!)\n";
       $INDEXFILE = <INDEXFILE>;
       close INDEXFILE ;
       @QUICKFILES = split(/\,/,$QUICKFILES);
       foreach $QUICKFILE (@QUICKFILES) {
         # Search here
         ($Junk,$Part,$MoreJunk) = split(/"\#".$Filename."\#"/, $QUICKFILE) ;
         if ($TRACING eq "ON") {
           print "Create part list of hyplern$part.dat files to change\n";
         } else { print ".";}
         $QuickPartList = $QuickPartList.$Part."###";
       }
       if ($TRACING eq "ON") {
         print "Part list is $QuickPartList\n";
       } else { print ".";}
     }
   }
   # is dit hendypendy in geval van Quick???
   `del /Q ..\\..\\Languages\\$Language\\HTML\\Main\\index.htm` ;    #Don't worry, creating new one on the go

   ##################################################################################
   #IF NO TO_PROD (prod) ARGUMENT (SO WE USE PRODUCTION ON DISK), and if QUICK ne ON
   if ($QUICK ne "ON") {
     # leave it, we wanna be quick plus this is copied over anyway
     if ($TOPROD ne "yes")
     {
        `del /Q ..\\..\\Production\\$ProdLanguage\\$ProdGroup\\Data\\HypLern*.dat` ;
     }
     `del /Q ..\\..\\Production\\$ProdLanguage\\$ProdGroup\\Media\\*.*` ;
     `del /Q ..\\..\\Production\\$ProdLanguage\\$ProdGroup\\Config\\*.*` ;
   } else {
     if ($QUICKFILES ne "") {
        # ehh del specific file?
     }
   }

   #######################################################################################
   # CREATE GROUP LIST TO WORK WITH (Main and Group)
   @Groups = ();
   push (@Groups, Main) ;
   push (@Groups, $Group) ;

   if ($PAUSENEEDED eq "TRUE")
   {
     print "---Press Any Key---\n\n";
     `pause`;
   }
   else
   {
      print "\n";
   }

   # get existing key if this is a reload
   if ($SLEUTELT ne "NEW") {
     open (KEYFILE, "../../Digital/$ProdLanguage/$ProdLanguage-$ProdGroup-$SecurityKeyHex/EncryptionKey.txt") || die "EncryptionKey file ../../Digital/$ProdLanguage/$ProdLanguage-$ProdGroup-$SecurityKeyHex/EncryptionKey.txt kan niet worden gevonden, ($!)\n";
     $EncryptionKeyRaw = <KEYFILE>;
     ($EncryptionKey,$Extension) = split("\#\#\#",$EncryptionKeyRaw);
     $EncryptionKeyExtended = $EncryptionKey.$Extension;
     close KEYFILE ;
     $LengthEncryptionKey = length $EncryptionKey ;
     $LengthEncryptionKeyExtended = length $EncryptionKeyExtended;
     if ($TRACING eq "ON") {
       print "Reloading product, using existing key.\n";
       print "Encryption key length now: ".$LengthEncryptionKey."\n";
       print "Extended Encryption key: ".$LengthEncryptionKeyExtended."\n";
     } else { print ".";}
   }

   $Filenumber = 0;
   ########################################################################################
   # CREATE DATA FILES AND ENCRYPT WITH CURRENT KEY FOR CURRENT UNIQUE PRODUCT
   # Grab all .htm files in the $Group dir (where sources reside)
   foreach $Group(@Groups)
   {
      @DirOutput = `dir /B ..\\..\\Languages\\$Language\\HTML\\$Group\\*.htm` ;
      sort(@DirOutput);
      foreach $Filename(@DirOutput)
      {
         $Filenumber = $Filenumber + 1;
         chop $Filename ;

         if ( $Filename eq "index.htm" )
         {
            #skip
            next ;
         }

         if ($PartLength > 70000)
         {
            $Part = $Part + 1 ;
            $PartLength = 0 ;
            if ( $QUICK ne "ON" || ($QUICK eq "ON" && $QUICKFILES eq "" && ( $Filename =~ "htm" || $Part < 100 ) ) || ($QUICK eq "ON" && $QUICKFILES ne "" && $QuickPartList =~ "\#\#\#".$Part."\#\#\#" ) ) {
              if ($TRACING eq "ON") {
                print "\nCreating New Storage File - HypLern$Part.dat .........\n\n" ;
              } else { print ".";}
            }
         }

         # Record Filename In Indexfile     
         open (INDEXFILE, ">>../../Languages/$Language/HTML/Main/$Indexfile") || die "Indexfile ../../Languages/$Language/HTML/index.htm kan niet worden aangemaakt, ($!)\n";
         print INDEXFILE "\#".$Filename."\#".$Part."\#".$Filename."\#".$Filenumber."\#".$Filename."\#\n" ;
         close INDEXFILE ;
      
         # Open Datfile $Part unless QUICK
         if ( $QUICK ne "ON" || ($QUICK eq "ON" && $QUICKFILES eq "" && ( $Filename =~ "htm" || $Part < 100 ) ) || ($QUICK eq "ON" && $QUICKFILES ne "" && $QuickPartList =~ "\#\#\#".$Part."\#\#\#" ) ) {
           open (DATFILE, ">>../Data/HypLern$Part.dat") || die "file ../Data/HypLern$Part.dat kan niet worden aangemaakt, ($!)\n";
           if ($PartLength == 0) {
           	print DATFILE "ï»¿";
           }
           print DATFILE "\n<<<$Filename>>>\n" ;
         }
      
         # Define filename
         $file = "../../Languages/$Language/HTML/$Group/$Filename" ;
         if ( $QUICK ne "ON" || ($QUICK eq "ON" && $QUICKFILES eq "" && ( $Filename =~ "htm" || $Part < 100 ) ) || ($QUICK eq "ON" && $QUICKFILES ne "" && $QuickPartList =~ "\#\#\#".$Part."\#\#\#" ) ) {
           if ($TRACING eq "ON") {
             print("file is nu : $file\n") ;
           } else { print ".";}
         }

         # Retrieve Data from filename
         @Contents = ("") ;
         open (FILE, "$file") || die "file $file is niet te vinden. ($!)\n" ;
         @Contents = <FILE> ;
         close (FILE) ;

         # Prepare To Encrypt Data
         $Contents = join ("",@Contents) ;

         # ENCRYPTION METHOD CHOICE
         # No Encryption
         if ($Encryption eq "None")
         {
            @EncryptedChars = @ContentsToEncrypt;
         }

         if ( $QUICK ne "ON" || ($QUICK eq "ON" && $QUICKFILES eq "" && ( $Filename =~ "htm" || $Part < 100 ) ) || ($QUICK eq "ON" && $QUICKFILES ne "" && $QuickPartList =~ "\#\#\#".$Part."\#\#\#" ) ) {

           if ($Encryption eq "OpAsc")
           {
             # if file is parse.htm or index.htm, use $EncryptionKey, else use $EncryptionKeyExtended (the extended part is taken from parse, and parse address taken from index, that's why)
             if ($file =~ "\/Parse.htm" || $file =~ "\/index.htm") {
               if ($TRACING eq "ON") {
                 print "Using standard encryptionkey for Parse and index!\n";
               } else { print ".";}
               $EncryptionKeyUsed = $EncryptionKey;           #basekey
             } else {
               if ($TRACING eq "ON") {
                 print "Using extended encryptionkey for $file\n";
               } else { print ".";}
               $EncryptionKeyUsed = $EncryptionKeyExtended;   #basekey with geheime sleutel
             }
             # run function
             EncryptPageAscey($EncryptionKeyUsed,$Contents);
           }
         }
      
         $EncryptedChars = $Contents ;
      
         #$LengthOfContents = length($Contents);
         #print "Length of contents of this file is: ".$LengthOfContents."\n";
         #  unless QUICK
         if ( $QUICK ne "ON" || ($QUICK eq "ON" && $QUICKFILES eq "" && ( $Filename =~ "htm" || $Part < 100 ) ) || ($QUICK eq "ON" && $QUICKFILES ne "" && $QuickPartList =~ "\#\#\#".$Part."\#\#\#" ) ) {
           print DATFILE "$EncryptedChars" ;
           print DATFILE "\n<<<End_Of_File>>>\n\n\n" ;
           close (DATFILE);
         }
      
         # Record Size of Added Data (to be able to keep to a maximum file size for the data)
         $LengthFile = length ($EncryptedChars) ;
         $PartLength = $PartLength + $LengthFile ;
         #print "Length of datafile is: ".$PartLength."\n";
      }
   }


   $LastDataFile = "HypLern99.dat" ;

   # if QUICK is not ON
   if ($QUICK ne "ON") {
     `copy ..\\..\\Languages\\$Language\\Audio\\$Group\\Data\\*.dat ..\\Data`;
   } else {
     if ($QUICKFILES ne "") {
     	# check if there's an audiofile to do, probably supply a code like "audioch1p2 as when you change a soundfile you know which number you changed..."
        #`copy ..\\..\\Languages\\$Language\\Audio\\$Group\\Data
     }
   }



   ############################################################################
   # ADD (ENCRYPTED) CONFIG FILE TO ENCRYPTED DATA
   $Filename = "HypLernConfig.htm" ;
   $MainGroup = "Main" ;

   # Add config file entry to indexfile
   $Filenumber = $Filenumber + 1;
   open (INDEXFILE, ">>../../Languages/$Language/HTML/$MainGroup/$Indexfile") || die "Indexfile ../../Languages/$Language/HTML/index.htm kan niet worden aangemaakt, ($!)\n";
   print INDEXFILE "\#".$Filename."\#0\#".$Filename."\#".$Filenumber."\#".$Filename."\#\n" ;
   close INDEXFILE ;

   # Open Datfile '0' to add the config file...
   open (DATFILE, ">>../Data/HypLern0.dat") || die "file ../Data/HypLern0.dat kan niet worden aangemaakt, ($!)\n";
   if ($TRACING eq "ON") {
     print "\nAdding $Filename to Storage File - HypLern0.dat .........\n\n" ;
   } else { print ".";}
   print DATFILE "<<<$Filename>>>\n" ;

   # Prepare Encryption
   $Contents = $ConfigContents ;

   # ENCRYPTION METHOD CHOICE
   # No Encryption
   if ($Encryption eq "None")
   {
      @EncryptedChars = @ContentsToEncrypt;
   }

   if ($Encryption eq "OpAsc") {
     if ($TRACING eq "ON") {
       print "Using standard encryptionkey for Config file!\n";
     } else { print ".";}
     $EncryptionKeyUsed = $EncryptionKey;

     # run function
     EncryptPageAscey($EncryptionKeyUsed,$Contents);
   }

   # Add Encrypted Data
   $EncryptedChars = $Contents ;
   print DATFILE "$EncryptedChars" ;
   print DATFILE "\n<<<End_Of_File>>>\n" ;
   close (DATFILE);
   # END OF ADDING CONFIG TO ENCRYPTED DATA
   ############################################################################



   ############################################################################
   # MOVED THIS PART AFTER CONFIGURATION
   # SO CONFIG COULD BE ADDED TO DATAFILE0 AND INDEX AS WELL
   # ADD (ENCRYPTED) INDEX FILE TO ENCRYPTED DATA
   $Filename = "index.htm" ;
   $MainGroup = "Main" ;

   # Add last entry to indexfile, namely index.htm :-)
   $Filenumber = $Filenumber + 1;
   open (INDEXFILE, ">>../../Languages/$Language/HTML/$MainGroup/$Indexfile") || die "Indexfile ../../Languages/$Language/HTML/index.htm kan niet worden aangemaakt, ($!)\n";
   print INDEXFILE "\#".$Filename."\#0\#".$Filename."\#".$Filenumber."\#".$Filename."\#\n" ;
   close INDEXFILE ;

   # Open Datfile '0' to add the index file...
   open (DATFILE, ">>../Data/HypLern0.dat") || die "file ../Data/HypLern0.dat kan niet worden aangemaakt, ($!)\n";
   if ($TRACING eq "ON") {
     print "\nAdding index.htm to Storage File - HypLern0.dat .........\n\n" ;
   } else { print ".";}
   print DATFILE "<<<$Filename>>>\n" ;

   # Define index filename      
   $file = "../../Languages/$Language/HTML/$MainGroup/$Filename" ;
   if ($TRACING eq "ON") {
     print("file is nu : $file\n") ;
   } else { print ".";}

   # Open index filename and retrieve contents
   @Contents = ("") ;
   open (FILE, "$file") || die "file $file is niet te vinden. ($!)\n" ;
   @Contents = <FILE> ;
   close (FILE) ;

   # Prepare Encryption
   $Contents = join ("",@Contents) ;

   # ENCRYPTION METHOD CHOICE
   # No Encryption
   if ($Encryption eq "None")
   {
      @EncryptedChars = @ContentsToEncrypt;
   }

   if ($Encryption eq "OpAsc")
   {
      # if file is parse.htm or index.htm, use $EncryptionKey, else use $EncryptionKeyExtended
      if ($file =~ "\/Parse.htm" || $file =~ "\/index.htm") {
        if ($TRACING eq "ON") {
          print "Using standard encryptionkey for Parse and index!\n";
        } else { print ".";}
        $EncryptionKeyUsed = $EncryptionKey;
      } else {
        if ($TRACING eq "ON") {
          print "Using extended encryptionkey for $file\n";
        } else { print ".";}
        $EncryptionKeyUsed = $EncryptionKeyExtended;
      }
      # run function
      EncryptPageAscey($EncryptionKeyUsed,$Contents);
   }

   # Add Encrypted Data
   $EncryptedChars = $Contents ;
   print DATFILE "$EncryptedChars" ;
   print DATFILE "\n<<<End_Of_File>>>\n" ;
   close (DATFILE);
   # END OF ADDING INDEX FILE (LAST FILE TO ADD AS IT IS THE INDEX ITSELF)
   #################################################################################



   ##################################################################################
   # COPY ALL FROM TOOL GENERATION DIRECTORIES TO PRODUCTION
   # de basis HypLernWords file is altijd hetzelfde, de geparsde versie halen we uit Main
   if ($QUICK ne "ON") {
     if ($TRACING eq "ON") {
       print "Copying files from ..\\..\\Languages\\$Language\\HTML\\Main to ..\\Config...\n";
     } else { print ".";}
     `copy ..\\..\\Languages\\$Language\\HTML\\Main\\HypLernWords.htm ..\\Config\\HypLernWordsAZ.htm` ;
     `copy ..\\..\\Languages\\$Language\\HTML\\Main\\HypLernWords.htm ..\\Config\\HypLernWordsDT.htm` ;
     `copy ..\\..\\Languages\\$Language\\HTML\\Main\\HypLernWords.htm ..\\Config\\HypLernWordsFQ.htm` ;
     `copy ..\\..\\Languages\\$Language\\HTML\\Main\\HypLernWords.htm ..\\Config\\HypLernWordsTQ.htm` ;
     if ($TRACING eq "ON") {
       print "Copying files from ..\\Base\\Media\\Main to ..\\Media...\n";
     } else { print ".";}
     `copy ..\\Base\\Media\\Main\\*.* ..\\Media\\*.*` ;
     if ($TRACING eq "ON") {
       print "Copying files from ..\\Base\\Media\\$Language to ..\\Media...\n";
     } else { print ".";}
     `copy ..\\Base\\Media\\$Language\\*.bmp ..\\Media\\*.*` ;
     `copy ..\\Base\\Media\\$Language\\*.jpg ..\\Media\\*.*` ;
     `copy ..\\Base\\Media\\$Language\\*.gif ..\\Media\\*.*` ;
     if ($TRACING eq "ON") {
       print "Copying files from ..\\Base\\Media\\$Language\\$Group to ..\\Media...\n";
     } else { print ".";}
     `copy ..\\Base\\Media\\$Language\\$Group\\*.bmp ..\\Media\\*.*` ;
     `copy ..\\Base\\Media\\$Language\\$Group\\*.jpg ..\\Media\\*.*` ;
     `copy ..\\Base\\Media\\$Language\\$Group\\*.gif ..\\Media\\*.*` ;
   }
   

   # only copy to production path on disk if TOPROD (which means TO USB STICK) is NOT on, otherwise encryption key for production is not right
   if ($TOPROD ne "yes") {
     if ($QUICK ne "ON") {
       if ($TRACING eq "ON") {
         print "Copying MEDIA files from ..\\Media to ..\\..\\Production\\$ProdLanguage\\$ProdGroup\\Media...\n";
       } else { print ".";}
       `copy ..\\Media\\*.* "..\\..\\Production\\$ProdLanguage\\$ProdGroup\\Media\\*.*"` ;
       if ($TRACING eq "ON") {
         print "Copying WORD files from ..\\..\\Languages\\$Language\\HTML\\Main to ..\\..\\Production\\$ProdLanguage\\$ProdGroup\\Config...\n";
       } else { print ".";}
       `copy ..\\..\\Languages\\$Language\\HTML\\Main\\HypLernWords.htm "..\\..\\Production\\$ProdLanguage\\$ProdGroup\\Config\\HypLernWordsAZ.htm"` ;
       `copy ..\\..\\Languages\\$Language\\HTML\\Main\\HypLernWords.htm "..\\..\\Production\\$ProdLanguage\\$ProdGroup\\Config\\HypLernWordsDT.htm"` ;
       `copy ..\\..\\Languages\\$Language\\HTML\\Main\\HypLernWords.htm "..\\..\\Production\\$ProdLanguage\\$ProdGroup\\Config\\HypLernWordsFQ.htm"` ;
       `copy ..\\..\\Languages\\$Language\\HTML\\Main\\HypLernWords.htm "..\\..\\Production\\$ProdLanguage\\$ProdGroup\\Config\\HypLernWordsTQ.htm"` ;
       if ($TRACING eq "ON") {
         print "Copying AUDIO files from ..\\Data to ..\\..\\Production\\$ProdLanguage\\$ProdGroup\\Data...\n";
       } else { print ".";}
       `copy ..\\..\\Languages\\$Language\\Audio\\$Group\\Data\\*.* "..\\..\\Production\\$ProdLanguage\\$ProdGroup\\Data\\*.*"` ;
       if ($TRACING eq "ON") {
         print "Copying DATA files from ..\\Data to ..\\..\\Production\\$ProdLanguage\\$ProdGroup\\Data...\n";
       } else { print ".";}
       `copy ..\\Data\\*.* "..\\..\\Production\\$ProdLanguage\\$ProdGroup\\Data\\*.*"` ;
     } else {
       if ($QUICKFILES eq "") {
       	 if ($TRACING eq "ON") {
           print "Be quick, only copying changed DATA files from ..\\Data to ..\\..\\Production\\$ProdLanguage\\$ProdGroup\\Data...\n";
         } else { print ".";}
        `copy ..\\Data\\*.* "..\\..\\Production\\$ProdLanguage\\$ProdGroup\\Data\\*.*"` ;
       } else {
       	 # only copy those dat files that have changed
       }
     }
   }


   ### THIS BIT ONLY ON VB DEV ENVIRONMENT SO IF REFRESH IS ON ON ON
   if ($SLEUTELT eq "NEW") {
	# backup .fmt file 
	$Output = `copy ..\\VB\\HypLern.frm ..\\VB\\HypLern.original 2>&1` ;
	if ($? != 0) {
		print "Backup of .frm file goes wrong, quitting... $Output\n" ;
		exit;
	}

	# delete .frm.new file
	if ($TRACING eq "ON") {
	  print "Deleting HypLern.frm.new...\n";
	} else { print ".";}
	$Output = `del ..\\VB\\HypLern.frm.new 2>&1` ;
	if ($? != 0) {
		print "Delete of .frm.new file goes wrong, quitting... $Output\n" ;
		exit;
	}

	$ReadFile = "..\\VB\\HypLern.frm";
	open (READFILE, "$ReadFile") || die "file $ReadFile cannot be found. ($!)\n";
	@FORMATFILECNTENTS = <READFILE>;
	close (READFILE);
	foreach $FORMATFILECNTENTSLINE (@FORMATFILECNTENTS) {
		if ( ( $FORMATFILECNTENTSLINE !~ "Debug" && $FORMATFILECNTENTSLINE !~ " '" ) || $FORMATFILECNTENTSLINE =~ "<<<CONFIGCONTENTS>>>" || $LEAVEDEBUGON eq "YES") {
			push(@FORMATFILECNTENTSREDONE,$FORMATFILECNTENTSLINE);
		}
	}
	$FORMATFILECNTENTS = "@FORMATFILECNTENTSREDONE";

	# REPLACING (DEFAULT) CONFIG STRING WITH $ConfigContents value
	if ($TRACING eq "ON") {
	  print "Now replacing \"<<<CONFIGCONTENTS>>>\" with\n";
	  print "$ConfigContents\n";
	} else { print ".";}
	$FORMATFILECNTENTS =~ s/\'<<<CONFIGCONTENTS>>>/$ConfigContents/;
	
	# IF ENCRYPTION IS OFF, CREATE SPECIAL VARIABLE FOR THIS	
	if ($NOENC eq "ON") {
	  $FORMATFILECNTENTS =~ s/<<<NOENCRYPTION>>>/NoEncryption \= \"ON\"/;
	} else {
	  $FORMATFILECNTENTS =~ s/<<<NOENCRYPTION>>>//;
	}

	foreach $FLINE (@FORMATFILECNTENTSREDONE) {
  		if ($FLINE =~ "Dim " || $FLINE =~ "Public " || $FLINE =~ "Private ") {
    			if ($FLINE =~ "Dim " || $FLINE =~ "Public ") {
      				($MUDDY,$FLINESTRINGRAW) = split(/Dim|Public/,$FLINE);
				if ($FLINESTRINGRAW =~ m/\(/i) {
					($FLINESTRING,$MUDDY) = split(/\(/,$FLINESTRINGRAW);
				} else {
					$FLINESTRING = $FLINESTRINGRAW;
				}
				push (@FLINESTRINGS,$FLINESTRING);
			}
			if ($FLINE =~ "Private ") {
				($MUDDY,$FLINESTRING,$MUDDY) = split (/\(|\)/,$FLINE);
				push (@FLINESTRINGS,$FLINESTRING);
			}
		}
	}
	foreach $FLINESTRINGLINE (@FLINESTRINGS) {
		if ($FLINESTRINGLINE =~ ",") {
			@FLINESTRINGLINEPARTS = split(/\,/,$FLINESTRINGLINE);
			foreach $FLINESTRINGLINEPART (@FLINESTRINGLINEPARTS) {
				if ($FLINESTRINGLINEPART =~ "As") {
					($FLINESTRINGLINEPARTBIT,$MUDDY) = split(/As/,$FLINESTRINGLINEPART);
					push (@FLINES,$FLINESTRINGLINEPARTBIT);
				} else {
					push (@FLINES,$FLINESTRINGLINEPART);
				}
			}
		} else {
			if ($FLINESTRINGLINE =~ m/ As /i) {
				($FLINESTRINGLINEPARTBIT,$MUDDY) = split(/\ As\ /,$FLINESTRINGLINE);
				push (@FLINES,$FLINESTRINGLINEPARTBIT);
			} else {
				push (@FLINES,$FLINESTRINGLINE);
			}
		}
	}
	foreach $FLINE (@FLINES) {
		$FLINE =~ s/^ //g;
		$FLINE =~ s/ $//g;
		$FLINE =~ s/^ //g;
		$FLINE =~ s/ $//g;
		$FLINE =~ s/^ //g;
		$FLINE =~ s/ $//g;
		$FLINE =~ s/^ //g;
		$FLINE =~ s/ $//g;
		if ($FLINE =~ " ") {
			($MUDDY,$FLINERAW) = split(/\ /,$FLINE);
			$FLINE = $FLINERAW;
		}
		$FLINE =~ s/\n//g;
		$lengthFLINE = length $FLINE;
		if ($lengthFLINE > 3) {
			$NEARFINALFLINES[$lengthFLINE] = $NEARFINALFLINES[$lengthFLINE].",".$FLINE;
		}
	}
	foreach $NEARFINALFLINE (@NEARFINALFLINES) {
		$NEARFINALFLINE =~ s/ //g ;
		$NEARFINALFLINE =~ s/^,//g ;
		$NEARFINALFLINE =~ s/\n//g ;
		$FINALFLINES = $NEARFINALFLINE.",".$FINALFLINES ;
	}
	$FINALFLINES =~ s/,$// ;
	@FINALFLINES = split(/\,/,$FINALFLINES) ;
	foreach $FINALFLINE (@FINALFLINES) {
		if ($FINALFLINES ne "" && $FINALFLINES ne " ") {
			$EncryptedVar = "";
			$ENU = "";
			# per variable, generate a unique key of 8 characters
			for ($ENU = 0; $ENU < 9; $ENU++)  {
				$x = 65 + int(rand(58));
				if ($x > 90 && $x < 97) {
					# ignore
					$ENU = $ENU - 1 ;
				} else {
					$EncryptedVar = $EncryptedVar.chr($x);
				}
			}
			if ($AllEncryptedVars =~ $EncryptedVar) {
				print "Uh oh, EncryptedVar already existed, that can corrupt program, quit!\n";
				exit;
			}
			$AllEncryptedVars = $AllEncryptedVars."#".$EncryptedVar."#";
			if ($LEAVEDEBUGON ne "YES") {
				if ($TRACING eq "ON") {
				  print "Replacing (encrypting) $FINALFLINE variable in code by $EncryptedVar...\n" ;
				} else { print ".";}
				$FORMATFILECNTENTS =~ s/$FINALFLINE/$EncryptedVar/g;
			}
		}
	}

        if ($TRACING eq "ON") {
	  print "Now putting the 4 random encryption keys of XXX numbers each into the slots in .frm...\n";
	} else { print ".";}
	for ($EKY = 0; $EKY < 6; $EKY++) {
		# per encryption key, replace in .fmt file
		if ($TRACING eq "ON") {
		  print "Now replacing \"<<<ENCRYPTIONKEY$EKY>>>\"...\n";
		} else { print ".";}
		$EncryptionKeyVB = $EncryptionKeysVB[$EKY];
		$FORMATFILECNTENTS =~ s/\"<<<ENCRYPTIONKEY$EKY>>>\"/$EncryptionKeyVB/;
		$FORMATFILECNTENTS =~ s/\-<<<ENCRYPTIONKEY$EKY>>>\-/$EncryptionKeyVB/;
	}

	#print $FORMATFILECNTENTS;
	

	$WriteFile = "..\\VB\\HypLern.frm.new";
	open (FORMATFILE, ">$WriteFile") || die "formatfile $WriteFile is niet te maken. ($!)\n" ;
	print FORMATFILE $FORMATFILECNTENTS ;
	close (FORMATFILE) ;

	# overwrite .frm file 
	if ($TRACING eq "ON") {
	  print "Overwrite .frm file with .frm.new file\n";
	} else { print ".";}
	$Output = `copy ..\\VB\\HypLern.frm.new ..\\VB\\HypLern.frm 2>&1` ;
	if ($? != 0) {
		if ($TRACING eq "ON") {
		  print "Overwrite of .frm file goes wrong, quitting... $Output\n" ;
		  print "Don't forget to put the original .frm back! Wait I'll do it for you:\n";
		} else { print ".";}
		# put original .frm file back
		$Output = `copy ..\\VB\\HypLern.original ..\\VB\\HypLern.frm 2>&1` ;
		if ($? != 0) {
			print "Putting original .frm file back, something went wrong, get it from last version backup! Quitting... $Output\n" ;
			exit;
		}
		exit;
	}

	#$Output = `type ..\\VB\\HypLern.frm`;
	#print $Output;

	# compile HypLern.exe
	if ($TRACING eq "ON") {
	  print "Now compiling VB format file into .exe file...\n";
	} else { print ".";}
	if (-e "C:\\Program Files\\Microsoft Visual Studio\\VB98\\VB6.exe") {
          $Output = `"C:\\Program Files\\Microsoft Visual Studio\\VB98\\VB6" \/MAKE ..\\VB\\HypLern.vbp` ;
          if ($? != 0) {
            if ($TRACING eq "ON") {
              print "Compiling VB code into Unique exe file... Something went wrong: $Output\n";
              print "Trying again! Hope you solved the problem!\n";
            } else { print ".";}
            $Output = `"C:\\Program Files\\Microsoft Visual Studio\\VB98\\VB6" \/MAKE ..\\VB\\HypLern.vbp` ;
            if ($? != 0) {
              if ($TRACING eq "ON") {
                print "Compiling VB code into Unique exe file... Something went wrong: $Output\n";
                print "Don't forget to put the original .frm back! Wait I'll do it for you:\n";
              } else { print ".";}
              # put original .frm file back
              $Output = `copy ..\\VB\\HypLern.original ..\\VB\\HypLern.frm 2>&1` ;
              if ($? != 0) {
                print "Putting original .frm file back, something went wrong, get it from last version backup! Quitting... $Output\n" ;
                exit;
              }
              exit;
            }
          }
        }
        if (-e "C:\\Program Files (x86)\\Microsoft Visual Studio\\VB98\\VB6.exe") { 
          $Output = `"C:\\Program Files (x86)\\Microsoft Visual Studio\\VB98\\VB6" \/MAKE ..\\VB\\HypLern.vbp` ;
          if ($? != 0) {
            if ($TRACING eq "ON") {
              print "Compiling VB code into Unique exe file... Something went wrong: $Output\n";
              print "Trying again! Hope you solved the problem!\n";
            } else { print ".";}
            $Output = `"C:\\Program Files (x86)\\Microsoft Visual Studio\\VB98\\VB6" \/MAKE ..\\VB\\HypLern.vbp` ;
            if ($? != 0) {
              if ($TRACING eq "ON") {
                print "Compiling VB code into Unique exe file... Something went wrong: $Output\n";
                print "Don't forget to put the original .frm back! Wait I'll do it for you:\n";
              } else { print ".";}
              # put original .frm file back
              $Output = `copy ..\\VB\\HypLern.original ..\\VB\\HypLern.frm 2>&1` ;
              if ($? != 0) {
                print "Putting original .frm file back, something went wrong, get it from last version backup! Quitting... $Output\n" ;
                exit;
              }
              exit;
            }
          }
        }

	# put original .frm file back
	if ($TRACING eq "ON") {
	  print "Now putting original format file back...\n";
	} else { print ".";}
	$Output = `copy ..\\VB\\HypLern.original ..\\VB\\HypLern.frm 2>&1` ;
	if ($? != 0) {
		print "Putting original .frm file back, something went wrong, get it from last version backup! Quitting... $Output\n" ;
		exit;
	}
	
	# store new keyed .exe
	print "copy HypLern.exe to \\Production\\$EXECNAME.exe\n";
	$Uitstop = `copy ..\\Base\\System\\HypLern.exe ..\\..\\Production\\$ProdLanguage\\$ProdGroup\\System\\$EXECNAME.exe` ;
	if ($? != 0) {
		if ($TRACING eq "ON") {
		  print "Er ging iets mis wijl koppieende Base\\System\\HypLern.exe naar ..\\..\\Production\\$ProdLanguage\\$ProdGroup\\System\\$EXECNAME.exe!\n$Uitstop\n";
		} else { print ".";}
	}
	
	# END OF REFRESH EXE WITH NEW KEY
   } else {
	# USE EXISTING EMPTY .EXE FROM \\Digital\\$ProdLanguage\\$ProdLanguage-$ProdGroup-$SLEUTELT
	if ($TRACING eq "ON") {
	  print "Copy ..\\..\\Digital\\$ProdLanguage\\$ProdLanguage-$ProdGroup-$SLEUTELT\\hyplern.exe to ..\\..\\Production\\$ProdLanguage\\$ProdGroup\\System\\$EXECNAME.exe\n";
	} else { print ".";}
	`copy ..\\..\\Digital\\$ProdLanguage\\$ProdLanguage-$ProdGroup-$SLEUTELT\\hyplern.exe ..\\..\\Production\\$ProdLanguage\\$ProdGroup\\System\\$EXECNAME.exe` ;
   }


   # initiate Load path
   #if (-e "..\\Load")
   #{
   #   `del /F /Q ..\\Load\\*.*` ;
   #}
   #else
   #{
   #   `mkdir ..\\Load` ;
   #}
   `del ..\\..\\Production\\$ProdLanguage\\$ProdGroup\\Load\\LoadList.cfg` ;
   if ($QUICK ne "ON") {
     if (-e "..\\..\\Production\\$ProdLanguage\\$ProdGroup\\Load")
     {
       `del /F /Q ..\\..\\Production\\$ProdLanguage\\$ProdGroup\\Load\\*.*` ;
     }
     else
     {
       `mkdir ..\\..\\Production\\$ProdLanguage\\$ProdGroup\\Load` ;
     }
   }

   # create loadlist: all contents of "..\\..\\Production\\$ProdLanguage\\$ProdGroup\\*" paths except for Load itself of course
   @GeulaLijst = `cd ..\\..\\Production\\$ProdLanguage\\$ProdGroup\\ && dir /S /A-D /B Config Data Media System` ;
   foreach $Geul (@GeulaLijst) {
      chop $Geul ;
      # only copy if QUICK is not on, and if QUICK is ON, specific data files only
      if ($QUICK ne "ON" || $Geul =~ m/\.exe/) {
      	if ($TRACING eq "ON") {
          print "File to load is $Geul\n" ;
        } else { print ".";}
        `copy $Geul ..\\..\\Production\\$ProdLanguage\\$ProdGroup\\Load`;
      } else {
        if ($QUICKFILES eq "") {
          # only copy over the refreshed data files and htm, no media (pics, audio) which should already be there
          if ($Geul =~ m/HypLern\d\d.dat/ || $Geul =~ m/HypLern\d.dat/) {
            if ($TRACING eq "ON") {
              print "Quick, only copying file $Geul to loadpath ..\\..\\Production\\$ProdLanguage\\$ProdGroup\\Load\n" ;
            } else { print ".";}
            `copy $Geul ..\\..\\Production\\$ProdLanguage\\$ProdGroup\\Load`;
          }
        } else {
          # find the specific file to copy over (you should have them already
        }
      }
      @Geulsplijt = split(/\\/,$Geul) ;
      $Geulbult = $Geulsplijt[@Geulsplijt-1] ;
      if ($Geulbult !~ ".exe" && $Geulbult !~ "LoadList") { #avoid taking yourself in
         $LoadString = $LoadString.",".$Geulbult ;
      }
   }
   $LoadString =~ s/^,//;
   open (LOADFILE, ">..\\..\\Production\\$ProdLanguage\\$ProdGroup\\Load\\LoadList.cfg") ;
   print LOADFILE "$LoadString" ;
   close (LOADFILE) ;
   #`copy ..\\Load\\LoadList.cfg ..\\..\\Production\\$ProdLanguage\\$ProdGroup\\Load\\LoadList.cfg`;

   if ($TRACING eq "ON") {
     print "copy HypLoad.exe to load-$EXECNAME.exe\n";
   } else { print ".";}
   $Uitstop = `copy ..\\Base\\System\\hypload.exe "..\\..\\Production\\load-$EXECNAME.exe"` ;
   if ($? != 0) {
      if ($TRACING eq "ON") {
        print "Er ging iets mis wijl koppieende hypload.exe naar load-$EXECNAME.exe!\n$Uitstop\n";
      } else { print ".";}
   }

   # changed this to copy \\Production\\$ProdLanguage\\$ProdGroup\\System\\$EXECNAME.exe to \\Production\\$EXECNAME.exe
   if ($TRACING eq "ON") {
     print "copy HypLern.exe to \\Production\\$EXECNAME.exe\n";
   } else { print ".";}
   $Uitstop = `copy ..\\..\\Production\\$ProdLanguage\\$ProdGroup\\System\\$EXECNAME.exe ..\\..\\Production\\$EXECNAME.exe` ;
   if ($? != 0) {
     if ($TRACING eq "ON") {
       print "Er ging iets mis wijl koppieende ..\\..\\Production\\$ProdLanguage\\$ProdGroup\\System\\$EXECNAME.exe naar Production\\$EXECNAME.exe!\n$Uitstop\n";
     } else { print ".";}
   }

   if ($TRACING eq "ON") {
     print "move $EXECNAME.exe to $EXECNAME.dat\n";
   } else { print ".";}
   $Uitstop = `move "..\\..\\Production\\$EXECNAME.exe" "..\\..\\Production\\$EXECNAME.dat"` ;
   if ($? != 0) {
     if ($TRACING eq "ON") {
       print "Er ging iets mis wijl movende $EXECNAME.exe naar $EXECNAME.dat!\n$Uitstop\n";
     } else { print ".";}
   }

   if ($TRACING eq "ON") {
     print "now run load-$EXECNAME.exe in production\n";
   } else { print ".";}
   $Uitstop = `cd ..\\..\\Production && load-$EXECNAME.exe`;
   if ($? != 0) {
     if ($TRACING eq "ON") {
       print "Er ging iets mis wijl runnende load-$EXECNAME.exe!\n$Uitstop\n";
     } else { print ".";}
   }

   if ($TRACING eq "ON") {
     print "now delete load-$EXECNAME.exe in production\n";
   } else { print ".";}
   $Uitstop = `cd ..\\..\\Production && del load-$EXECNAME.exe`;
   if ($? != 0) {
     if ($TRACING eq "ON") {
       print "Er ging iets mis wijl deletende load-$EXECNAME.exe!\n$Uitstop\n";
     } else { print ".";}
   }

   if ($TRACING eq "ON") {
     print "now delete $EXECNAME.dat in production\n";
   } else { print "."; }
   $Uitstop = `cd ..\\..\\Production && del $EXECNAME.dat`;
   if ($? != 0) {
     if ($TRACING eq "ON") {
       print "Er ging iets mis wijl deletende $EXECNAME.dat!\n$Uitstop\n";
     } else { print ".";}
   }

   if ($DEBUG ne "ON" && $NOENC ne "ON") {
     if ($TRACING eq "ON") {
       print "move $EXECNAME.exe to Digital\\$ProdLanguage-$ProdGroup-$SecurityKeyHex\\$EXECNAME.exe\n";
     } else { print ".";}
     # copy base htm files and key used and base hyplern.exe only if first time this key is used
     if ($SLEUTELT eq "NEW") {
       `mkdir ..\\..\\Digital\\$ProdLanguage`;
       `mkdir ..\\..\\Digital\\$ProdLanguage\\$ProdLanguage-$ProdGroup-$SecurityKeyHex`;
       `copy ..\\..\\Production\\$ProdLanguage\\$ProdGroup\\System\\$EXECNAME.exe ..\\..\\Digital\\$ProdLanguage\\$ProdLanguage-$ProdGroup-$SecurityKeyHex\\hyplern.exe`;
       `copy ..\\..\\Tool\\Base\\Digital\\kill.htm ..\\..\\Digital\\$ProdLanguage\\$ProdLanguage-$ProdGroup-$SecurityKeyHex\\kill-$SecurityKeyHex.htm`;
       `copy ..\\..\\Tool\\Base\\Digital\\warning.htm ..\\..\\Digital\\$ProdLanguage\\$ProdLanguage-$ProdGroup-$SecurityKeyHex\\warning-$SecurityKeyHex.htm`;
       `copy ..\\..\\Tool\\Base\\Digital\\message.htm ..\\..\\Digital\\$ProdLanguage\\$ProdLanguage-$ProdGroup-$SecurityKeyHex\\message-$SecurityKeyHex.htm`;
       `copy ..\\..\\Tool\\Base\\Digital\\base.htm ..\\..\\Digital\\$ProdLanguage\\$ProdLanguage-$ProdGroup-$SecurityKeyHex\\base-$SecurityKeyHex.htm`;
       `copy EncryptionKey.txt ..\\..\\Digital\\$ProdLanguage\\$ProdLanguage-$ProdGroup-$SecurityKeyHex\\EncryptionKey.txt`;
       `copy ..\\..\\Tool\\Base\\Digital\\base.htm ..\\..\\Digital\\$ProdLanguage\\$SecurityKeyHex.htm`;
     }
     $Uitstop = `move "..\\..\\Production\\$EXECNAME.exe" "..\\..\\Digital\\$ProdLanguage\\$ProdLanguage-$ProdGroup-$SecurityKeyHex\\$EXECNAME.exe"` ;
     if ($? != 0) {
        print "Er ging iets mis wijl movende $EXECNAME.exe naar Digital\\$ProdLanguage\\$ProdLanguage-$ProdGroup-$SecurityKeyHex\\$EXECNAME.exe!\n$Uitstop\n";
     }
   } else {
     if ($DEBUG eq "ON") {
       if ($TRACING eq "ON") {
         print "move $EXECNAME.exe to Digital\\Debugging\\$EXECNAME.exe\n";
       } else { print ".";}
       if (!-e "..\\..\\Digital\\Debugging") { `mkdir ..\\..\\Digital\\Debugging`; }
       $Uitstop = `move "..\\..\\Production\\$EXECNAME.exe" "..\\..\\Digital\\Debugging\\$EXECNAME.exe"` ;
       if ($? != 0) {
         print "Er ging iets mis wijl movende $EXECNAME.exe naar Digital\\Debugging\\$EXECNAME.exe!\n$Uitstop\n";
       }
     } else {
       if ($NOENC eq "ON") {
         if ($TRACING eq "ON") {
           print "move $EXECNAME.exe to Digital\\Unencrypted\\$EXECNAME.exe\n";
         } else { print ".";}
         if (!-e "..\\..\\Digital\\Unencrypted") { `mkdir ..\\..\\Digital\\Unencrypted`; }
         $Uitstop = `move "..\\..\\Production\\$EXECNAME.exe" "..\\..\\Digital\\Unencrypted\\$EXECNAME.exe"` ;
         if ($? != 0) {
           print "Er ging iets mis wijl movende $EXECNAME.exe naar Digital\\Unencrypted\\$EXECNAME.exe!\n$Uitstop\n";
         }
       } else {
         print "EEeeeehhh nothing happened, no file moved nowhere, wutt???\n";
       }
     }
   }
}
exit 0;

sub dec2bin {
    my $str = unpack("B32", pack("N", shift));
    $str =~ s/^0+(?=\d)//;   # otherwise you'll get leading zeros
    return $str;
}

sub bin2dec {
    return unpack("N", pack("B32", substr("0" x 32 . shift, -32)));
}

sub EncryptPageAscey($EncryptionKeyUsed,$Contents)
{
   open (TEMPENCFILE,">>TempEncFile");
   @EncryptedChars = ("") ;
   @UnEncryptedChars = ("") ;
   $EncryptedChars = "" ;
   @ContentsToEncrypt = split (//,$Contents ) ;
   
   #debug: show data going INTO encryption process
   #open (DEBUGFILE, ">Debug\\debugfilein.$Filename") || die "debugfile Debug\debugfilein.$Filename is niet te maken. ($!)\n" ;
   #print DEBUGFILE "@Contents" ;
   #close (DEBUGFILE) ;
   # Encrypting using character ascii numbers, adding ascii of key)...
   $KeyN = -1;
   $CountNonEncryptedChars = 0;
   @EncryptionKeyChars = split(//,$EncryptionKeyUsed);
   $CharNull = chr(2);
   $CharOne = chr(1);
   foreach $ContentsChar (@ContentsToEncrypt)
   {
      $ContentsCharAscii = ord $ContentsChar ;

      #print "on minus one or just pushed, so shift to next keypart of key!";
      $KeyN = $KeyN + 1;
      if ($KeyN > length($EncryptionKeyUsed) - 1)
      {
         $KeyN = 0;
      }
         
      $EncryptionKeyAscii = ord ($EncryptionKeyChars[$KeyN]);

      $EncryptedCharAscii = (300 + $EncryptionKeyAscii) - $ContentsCharAscii ;

      if ($EncryptedCharAscii > 255)
      {
         #print "print NullChar to file\n" ;
         #$EncryptedChars = $EncryptedChars.$CharNull;
         print TEMPENCFILE "$CharNull";
         $EncryptedCharAscii = $EncryptedCharAscii - 100;

      }
         
      if ($EncryptedCharAscii == 12)
      {
         $EncryptedCharAscii = 1;
      }
      if ($EncryptedCharAscii == 26)
      {
         $EncryptedCharAscii = 3;
      }
         
      $EncryptedChar = chr $EncryptedCharAscii ;
      #$EncryptedChars = $EncryptedChars.$EncryptedChar;
      print TEMPENCFILE "$EncryptedChar";
   }
   close TEMPENCFILE;
   
   #read from TEMPENCFILE
   open (TEMPENCFILE,"<TempEncFile");
   $EncryptedChars = <TEMPENCFILE>;
   $Contents = $EncryptedChars ;
   close TEMPENCFILE;
   `del TempEncFile`;
   #$LengthOfKontents = length($Contents);
   #print "LengthOfEncryptedData: ".$LengthOfKontents."\n";
   
   #debug: show data coming OUT of encryption process
   #open (DEBUGFILE, ">Debug\\debugfileout.$Filename") || die "debugfile Debug\\debugfileout.$Filename is niet te maken. ($!)\n" ;
   #print DEBUGFILE "$Contents" ;
   #close (DEBUGFILE) ;
   
   return ($Contents);
}