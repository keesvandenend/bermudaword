VERSION 5.00
Object = "{EAB22AC0-30C1-11CF-A7EB-0000C05BAE0B}#1.1#0"; "shdocvw.dll"
Begin VB.Form Form1 
   Caption         =   "Loading"
   ClientHeight    =   10035
   ClientLeft      =   255
   ClientTop       =   645
   ClientWidth     =   11400
   Icon            =   "HypLern.frx":0000
   LinkTopic       =   "Form1"
   ScaleHeight     =   10035
   ScaleWidth      =   11400
   Begin VB.Timer timTimer 
      Interval        =   1
      Left            =   7320
      Top             =   6120
   End
   Begin SHDocVwCtl.WebBrowser brwWebBrowser 
      Height          =   9945
      Left            =   0
      TabIndex        =   0
      Top             =   0
      Width           =   14760
      ExtentX         =   26035
      ExtentY         =   17542
      ViewMode        =   1
      Offline         =   0
      Silent          =   0
      RegisterAsBrowser=   0
      RegisterAsDropTarget=   0
      AutoArrange     =   0   'False
      NoClientEdge    =   0   'False
      AlignLeft       =   0   'False
      NoWebView       =   0   'False
      HideFileNames   =   0   'False
      SingleClick     =   0   'False
      SingleSelection =   0   'False
      NoFolders       =   0   'False
      Transparent     =   0   'False
      ViewID          =   "{0057D0E0-3573-11CF-AE69-08002B2E1262}"
      Location        =   ""
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
  
Public ApplicationTitle As String
Public CourseTitle As String
Public StartingAddress As Variant
Public BasicStartingAddress As Variant
Public ForwardedAddress As Variant
Public DataFileAddress As Variant
Public Modus As String
Public AutoSave As String
Public TimerModus As String
Public EditMode As String
Public Contents As String
Public PrePath As String
Public OldURL As Variant
Public AncientURL As Variant
Public AncientFrame As Variant
Public HomePath As String
Public LanguageHomePath As String
Public StoryPath As String
Public LanguagePath As String
Public Taal As String
Public CourseLanguage As String
Public FilesToDelete As Variant
Public CourseChapters As Long
Public CourseWords As Long
Public CourseUnique As String
Public CourseNew As Long
Public CoursePercentage As Long
Public Groups As String
Public Group As String
Public ConfigValues As String
Public VariableValues As String
Public SelectedOptionValues As String
Public ParseContents As String
Public IndexContents As String
Public StringToSort As String
Public Part As String
Public MainFlag As Boolean
Public LastMain As String
Public Floppie As String
Public TestFile As String
Public WordList As String
Public WordListAll As String
Public WordListAllAZ As String
Public WordListAllDT As String
Public WordListAllFQ As String
Public WordListAllTQ As String
Public HyplernWordListAll As String
Public HyplernWordListTst As String
Public WordListStart As String
Public WordListEnd As String
Public WorkDir As String
Public WordListAddress As String
Public WordListAddressAZ As String
Public WordListAddressDT As String
Public WordListAddressFQ As String
Public WordListAddressTQ As String
Public WordListFile As String
Public WordListFileAZ As String
Public WordListFileDT As String
Public WordListFileFQ As String
Public WordListFileTQ As String
Public MyFinishedBooks As String
Public IncrementFactor As Long
Public IncrementFactorString As String
Public IntervalMargin As Long
Public RetentionFactor As Long
Public RetentionFactorString As String
Public IncrementSeconds As Long
Public ChapterTestFactor As Long
Public AverFreq As Long
Public AverFreqTop As Long
Public NoNeFiMyWo As String
Public TeCuMyWo As Long
Public TeCuChap As String
Public TeCuPage As String
Public AlsoHiFreq As String
Public KeepTested As String
Public DebugFlag As String
Public DebugFile As String
Public ConfigBase As String
Public PermCustomCodes As String
Public UpdateRequests As String
Public CurrentURL As String
Public FinalContents As String
Public UpdateRequestContents As String
Public SecurityStatus As Boolean
Public SecSpace As String
Public SecSerial As String
Public Manucode As String
Public SecManu As String
Public SecurityWarningMessage As String
Public SecurityErrorMessage As String
Public BermudaWordMessageString As String
Public SaveURL As String
Public SaveGetFileList As String
Public WindowWidthDifference As String
Public WindowHeightDifference As String
Public WindowLayout As String
Public WindowWidth As String
Public WindowHeight As String
Public LoadingScreen As Boolean
Public StartingScreen As Boolean
Public ExitStartingScreen As Boolean
Public LayoutConfig As Boolean
Public TempString As String
Public TimeString As String
Public DataAll As String
Public StickAll As String
Public PrimaryCode As String
Public MainStringOfArray As String
Public StringToEnter As String
Public SortDivider As String
Public SecurityURL As String
Public SecurityKey As String
Public SecurityOutput As Variant
Public FirstTimeConfig As String
Public RandomSecKey As String
Public ConfigLogKey As String
Public SecFileSize As String
Public NoEncryption As String

Dim FileIndexNumber
Dim SavedFileIndexNumber
Dim GetFileList
Dim URLFlags As Long
Dim DataFileContents(999)
Dim SRSRemArray(99)
Dim ExecutableArray
Dim PathArray
Dim ParseContentArray
Dim ParseTemplateArray(99)
Dim IndexContentArray
Dim FileIndexArray(99999)
Dim CTLFlag As Boolean
Dim FirstNav As Boolean
Dim StartUp As Boolean
Dim LoadedAboutBlank As Boolean
Dim StartUpTwo As Boolean

Private Sub Form_Load()
    Dim ContentArray, DividingChar, DividingBR, DividingRet, ConfigFile, ParsingAddress
    Dim ParseLine
    Dim lenParseLine
    Dim ParseArray
    Dim ParseType, ParseLink, ParseBase, ParseChange, ParseAllow
    Dim ParseTemplate
    Dim T, D, I, NV
    Dim DS As String
    Dim IndexAddress
    Dim VolumeName As String
    Dim PhysicalAddress As String
    Dim TempArray
    Dim TempArrayToo
    Dim TempArrayTree
    Dim TempArrayFore
    Dim TempArrayFyve
    Dim TempString As String
    Dim TempStringToo As String
    Dim TempStringTree As String
    Dim TempStringFore As String
    Dim TempStringFyve As String
    Dim TempNumber
    Dim TempNumberToo
    Dim TempNumberTree
    Dim TempNumberFore
    Dim TempNumberFyve
    Dim DebugPath As String
    Dim WordListArray
    Dim NumberOfIndexLines
    Dim DataFileNumber
    Dim ConfigValuesArray
    Dim ConfigValueLine
    Dim ConfigValue
    Dim VariableValuesArray
    Dim NumberOfVariableValues
    Dim VariableValuesLineArray
    Dim lenSpace, lenSerial, lenManu
    Dim UnformattedSerialNum
    Dim SpaceNum, SerialNum
    Dim ManuString
    Dim RevManuString
    Dim SortedManuString
    Dim RevSortedManuString
    Dim ManufacturersCode
    Dim SpaceString, SerialString
    Dim SpaceStrCount, SerialStrCount, ManuStrCount
    Dim ExtractedCharacter, TotalExtractedCharacters
    Dim SpaceCode As String
    Dim SerialCode As String
    Dim InitPath, InitDriveObject, InitDrive
    Dim SystemRoot As String
    Dim SystemDisk As String
    Dim SystemUser As String
    Dim DiskRoot As String
    Dim CurrentPath As String
    Dim LengthCurrentPath
    Dim Executable As String
    Dim DomboString
    Dim lenPrimaryCodeTemp
    Dim lenPrimaryCodeTempStr
    Dim StringSpaceStrCount
    Dim StringSerialStrCount
    Dim SecurityOutput As Variant
    Dim SafetyCounter
    Dim Pokkie


    Randomize
    ExitStartingScreen = True
    PrimaryCode = "<<<ENCRYPTIONKEY0>>>"
    <<<NOENCRYPTION>>>

    CTLFlag = False
    DividingBR = "<BR>"
    DividingRet = Chr(10)
    SecurityStatus = True
    CurrentPath = CurDir()
    LengthCurrentPath = Len(CurrentPath)
    LengthCurrentPath = LengthCurrentPath - 1
    DiskRoot = Mid(CurrentPath, 1, 1)
    SystemRoot = Environ("systemroot")
    SystemUser = Environ("username")
    SystemDisk = Mid(SystemRoot, 1, 1)
    Executable = App.EXEName

    If (Executable = "HypLern") Then
        HomePath = "..\Config"
    Else
        Executable = Executable + "(dummycopy)"
        ExecutableArray = Split(Executable, "(")
        Executable = ExecutableArray(0)
        'now we got rid of any ( caused by downloading too many files so we can get through initial loading
        ExecutableArray = Split(Executable, "-")
        LanguagePath = ExecutableArray(0)
        StoryPath = ExecutableArray(1)
        HomePath = SystemDisk + ":" + Environ("homepath") + "\BermudaWord" + "\" + LanguagePath + "\" + StoryPath
        LanguageHomePath = SystemDisk + ":" + Environ("homepath") + "\BermudaWord" + "\" + LanguagePath
        On Error Resume Next
        MkDir SystemDisk + ":" + Environ("homepath") + "\BermudaWord" + "\" + LanguagePath
        On Error Resume Next
        MkDir SystemDisk + ":" + Environ("homepath") + "\BermudaWord"
        On Error Resume Next
        MkDir HomePath
    End If
    
    ' this shit will be removed by debug remove for production executables, the whole flag thing is useless
    DebugFlag = "ON"
    DebugFile = HomePath + "\HypLernDebug.txt"
    DebugEntry "0. Start Debugging with DebugFlag is " + DebugFlag + " and DebugPath is " + DebugFile, DebugFile, "write"
      
    ' debug executable name
    DebugEntry "   Executable is " + Executable + " and StoryPath is " + StoryPath
      
    Me.Caption = "Loading."
      
    lenPrimaryCodeTemp = Len(PrimaryCode)
    lenPrimaryCodeTempStr = CStr(lenPrimaryCodeTemp)
    DebugEntry "Length of Current PrimaryCode is " + lenPrimaryCodeTempStr
    
    ManuString = LanguagePath + StoryPath
    RevManuString = StrReverse(LanguagePath + StoryPath)
    SpaceString = StoryPath + LanguagePath
    SerialString = StrReverse(StoryPath + LanguagePath)
    lenSpace = Len(SpaceString)
    lenSerial = Len(SerialString)
    lenManu = Len(ManuString)
    TotalExtractedCharacters = ""
    ManuStrCount = 1
    Do While ManuStrCount < (lenManu + 1)
        ExtractedCharacter = Mid(RevManuString, ManuStrCount, 1)
        ExtractedCharacter = Replace(ExtractedCharacter, "0", "3")
        ExtractedCharacter = Replace(ExtractedCharacter, "9", "4")
        ExtractedCharacter = Replace(ExtractedCharacter, "A", "5")
        ExtractedCharacter = Replace(ExtractedCharacter, "B", "6")
        ExtractedCharacter = Replace(ExtractedCharacter, "C", "7")
        ExtractedCharacter = Replace(ExtractedCharacter, "D", "8")
        ExtractedCharacter = Replace(ExtractedCharacter, "E", "1")
        ExtractedCharacter = Replace(ExtractedCharacter, "F", "2")
        ExtractedCharacter = Replace(ExtractedCharacter, "G", "3")
        ExtractedCharacter = Replace(ExtractedCharacter, "H", "4")
        ExtractedCharacter = Replace(ExtractedCharacter, "I", "5")
        ExtractedCharacter = Replace(ExtractedCharacter, "J", "6")
        ExtractedCharacter = Replace(ExtractedCharacter, "K", "7")
        ExtractedCharacter = Replace(ExtractedCharacter, "L", "8")
        ExtractedCharacter = Replace(ExtractedCharacter, "M", "1")
        ExtractedCharacter = Replace(ExtractedCharacter, "N", "2")
        ExtractedCharacter = Replace(ExtractedCharacter, "O", "3")
        ExtractedCharacter = Replace(ExtractedCharacter, "P", "4")
        ExtractedCharacter = Replace(ExtractedCharacter, "Q", "5")
        ExtractedCharacter = Replace(ExtractedCharacter, "R", "6")
        ExtractedCharacter = Replace(ExtractedCharacter, "S", "7")
        ExtractedCharacter = Replace(ExtractedCharacter, "T", "8")
        ExtractedCharacter = Replace(ExtractedCharacter, "U", "1")
        ExtractedCharacter = Replace(ExtractedCharacter, "V", "2")
        ExtractedCharacter = Replace(ExtractedCharacter, "W", "3")
        ExtractedCharacter = Replace(ExtractedCharacter, "X", "4")
        ExtractedCharacter = Replace(ExtractedCharacter, "Y", "5")
        ExtractedCharacter = Replace(ExtractedCharacter, "Z", "6")
        ExtractedCharacter = Replace(ExtractedCharacter, "a", "7")
        ExtractedCharacter = Replace(ExtractedCharacter, "b", "8")
        ExtractedCharacter = Replace(ExtractedCharacter, "c", "1")
        ExtractedCharacter = Replace(ExtractedCharacter, "d", "2")
        ExtractedCharacter = Replace(ExtractedCharacter, "e", "3")
        ExtractedCharacter = Replace(ExtractedCharacter, "f", "4")
        ExtractedCharacter = Replace(ExtractedCharacter, "g", "5")
        ExtractedCharacter = Replace(ExtractedCharacter, "h", "6")
        ExtractedCharacter = Replace(ExtractedCharacter, "i", "7")
        ExtractedCharacter = Replace(ExtractedCharacter, "j", "8")
        ExtractedCharacter = Replace(ExtractedCharacter, "k", "1")
        ExtractedCharacter = Replace(ExtractedCharacter, "l", "2")
        ExtractedCharacter = Replace(ExtractedCharacter, "m", "3")
        ExtractedCharacter = Replace(ExtractedCharacter, "n", "4")
        ExtractedCharacter = Replace(ExtractedCharacter, "o", "5")
        ExtractedCharacter = Replace(ExtractedCharacter, "p", "6")
        ExtractedCharacter = Replace(ExtractedCharacter, "q", "7")
        ExtractedCharacter = Replace(ExtractedCharacter, "r", "8")
        ExtractedCharacter = Replace(ExtractedCharacter, "s", "1")
        ExtractedCharacter = Replace(ExtractedCharacter, "t", "2")
        ExtractedCharacter = Replace(ExtractedCharacter, "u", "3")
        ExtractedCharacter = Replace(ExtractedCharacter, "v", "4")
        ExtractedCharacter = Replace(ExtractedCharacter, "w", "5")
        ExtractedCharacter = Replace(ExtractedCharacter, "x", "6")
        ExtractedCharacter = Replace(ExtractedCharacter, "y", "7")
        ExtractedCharacter = Replace(ExtractedCharacter, "z", "8")
        If (ExtractedCharacter = 1 Or ExtractedCharacter = 2 Or ExtractedCharacter = 3 Or ExtractedCharacter = 4 Or ExtractedCharacter = 5 Or ExtractedCharacter = 6 Or ExtractedCharacter = 7 Or ExtractedCharacter = 8) Then
            TotalExtractedCharacters = TotalExtractedCharacters + Chr(ExtractedCharacter)
        End If
        ManuStrCount = ManuStrCount + 1
    Loop
    ManufacturersCode = TotalExtractedCharacters
    TotalExtractedCharacters = ""
    PrimaryCode = ManufacturersCode + PrimaryCode
    
    lenPrimaryCodeTemp = Len(PrimaryCode)
    lenPrimaryCodeTempStr = CStr(lenPrimaryCodeTemp)
    DebugEntry "Added Manu key. Length of Current PrimaryCode is " + lenPrimaryCodeTempStr
      
    SpaceStrCount = 1
    Do While SpaceStrCount < (lenSpace + 1)
        ExtractedCharacter = Mid(SpaceString, SpaceStrCount, 1)
        ExtractedCharacter = Replace(ExtractedCharacter, "0", "6")
        ExtractedCharacter = Replace(ExtractedCharacter, "9", "7")
        ExtractedCharacter = Replace(ExtractedCharacter, "A", "8")
        ExtractedCharacter = Replace(ExtractedCharacter, "B", "1")
        ExtractedCharacter = Replace(ExtractedCharacter, "C", "2")
        ExtractedCharacter = Replace(ExtractedCharacter, "D", "3")
        ExtractedCharacter = Replace(ExtractedCharacter, "E", "4")
        ExtractedCharacter = Replace(ExtractedCharacter, "F", "5")
        ExtractedCharacter = Replace(ExtractedCharacter, "G", "6")
        ExtractedCharacter = Replace(ExtractedCharacter, "H", "7")
        ExtractedCharacter = Replace(ExtractedCharacter, "I", "8")
        ExtractedCharacter = Replace(ExtractedCharacter, "J", "1")
        ExtractedCharacter = Replace(ExtractedCharacter, "K", "2")
        ExtractedCharacter = Replace(ExtractedCharacter, "L", "3")
        ExtractedCharacter = Replace(ExtractedCharacter, "M", "4")
        ExtractedCharacter = Replace(ExtractedCharacter, "N", "5")
        ExtractedCharacter = Replace(ExtractedCharacter, "O", "6")
        ExtractedCharacter = Replace(ExtractedCharacter, "P", "7")
        ExtractedCharacter = Replace(ExtractedCharacter, "Q", "8")
        ExtractedCharacter = Replace(ExtractedCharacter, "R", "1")
        ExtractedCharacter = Replace(ExtractedCharacter, "S", "2")
        ExtractedCharacter = Replace(ExtractedCharacter, "T", "3")
        ExtractedCharacter = Replace(ExtractedCharacter, "U", "4")
        ExtractedCharacter = Replace(ExtractedCharacter, "V", "5")
        ExtractedCharacter = Replace(ExtractedCharacter, "W", "6")
        ExtractedCharacter = Replace(ExtractedCharacter, "X", "7")
        ExtractedCharacter = Replace(ExtractedCharacter, "Y", "8")
        ExtractedCharacter = Replace(ExtractedCharacter, "Z", "1")
        ExtractedCharacter = Replace(ExtractedCharacter, "a", "2")
        ExtractedCharacter = Replace(ExtractedCharacter, "b", "3")
        ExtractedCharacter = Replace(ExtractedCharacter, "c", "4")
        ExtractedCharacter = Replace(ExtractedCharacter, "d", "5")
        ExtractedCharacter = Replace(ExtractedCharacter, "e", "6")
        ExtractedCharacter = Replace(ExtractedCharacter, "f", "7")
        ExtractedCharacter = Replace(ExtractedCharacter, "g", "8")
        ExtractedCharacter = Replace(ExtractedCharacter, "h", "1")
        ExtractedCharacter = Replace(ExtractedCharacter, "i", "2")
        ExtractedCharacter = Replace(ExtractedCharacter, "j", "3")
        ExtractedCharacter = Replace(ExtractedCharacter, "k", "4")
        ExtractedCharacter = Replace(ExtractedCharacter, "l", "5")
        ExtractedCharacter = Replace(ExtractedCharacter, "m", "6")
        ExtractedCharacter = Replace(ExtractedCharacter, "n", "7")
        ExtractedCharacter = Replace(ExtractedCharacter, "o", "8")
        ExtractedCharacter = Replace(ExtractedCharacter, "p", "1")
        ExtractedCharacter = Replace(ExtractedCharacter, "q", "2")
        ExtractedCharacter = Replace(ExtractedCharacter, "r", "3")
        ExtractedCharacter = Replace(ExtractedCharacter, "s", "4")
        ExtractedCharacter = Replace(ExtractedCharacter, "t", "5")
        ExtractedCharacter = Replace(ExtractedCharacter, "u", "6")
        ExtractedCharacter = Replace(ExtractedCharacter, "v", "7")
        ExtractedCharacter = Replace(ExtractedCharacter, "w", "8")
        ExtractedCharacter = Replace(ExtractedCharacter, "x", "1")
        ExtractedCharacter = Replace(ExtractedCharacter, "y", "2")
        ExtractedCharacter = Replace(ExtractedCharacter, "z", "3")
        If (ExtractedCharacter = 1 Or ExtractedCharacter = 2 Or ExtractedCharacter = 3 Or ExtractedCharacter = 4 Or ExtractedCharacter = 5 Or ExtractedCharacter = 6 Or ExtractedCharacter = 7 Or ExtractedCharacter = 8) Then
            TotalExtractedCharacters = TotalExtractedCharacters + Chr(ExtractedCharacter)
        End If
        SpaceStrCount = SpaceStrCount + 1
    Loop
    SpaceCode = TotalExtractedCharacters
    StringSpaceStrCount = CStr(SpaceStrCount)
    PrimaryCode = PrimaryCode + SpaceCode
      
    lenPrimaryCodeTemp = Len(PrimaryCode)
    lenPrimaryCodeTempStr = CStr(lenPrimaryCodeTemp)
      
    PrimaryCode = PrimaryCode + "<<<ENCRYPTIONKEY1>>>"
    lenPrimaryCodeTemp = Len(PrimaryCode)
    lenPrimaryCodeTempStr = CStr(lenPrimaryCodeTemp)
    DebugEntry "Added Space and Second key. Length of Current PrimaryCode is " + lenPrimaryCodeTempStr
  
    TotalExtractedCharacters = ""
    SerialStrCount = 1
    Do While SerialStrCount < (lenSerial + 1)
        ExtractedCharacter = Mid(SerialString, SerialStrCount, 1)
        ExtractedCharacter = Replace(ExtractedCharacter, "0", "1")
        ExtractedCharacter = Replace(ExtractedCharacter, "9", "2")
        ExtractedCharacter = Replace(ExtractedCharacter, "A", "3")
        ExtractedCharacter = Replace(ExtractedCharacter, "B", "4")
        ExtractedCharacter = Replace(ExtractedCharacter, "C", "5")
        ExtractedCharacter = Replace(ExtractedCharacter, "D", "6")
        ExtractedCharacter = Replace(ExtractedCharacter, "E", "7")
        ExtractedCharacter = Replace(ExtractedCharacter, "F", "8")
        ExtractedCharacter = Replace(ExtractedCharacter, "G", "1")
        ExtractedCharacter = Replace(ExtractedCharacter, "H", "2")
        ExtractedCharacter = Replace(ExtractedCharacter, "I", "3")
        ExtractedCharacter = Replace(ExtractedCharacter, "J", "4")
        ExtractedCharacter = Replace(ExtractedCharacter, "K", "5")
        ExtractedCharacter = Replace(ExtractedCharacter, "L", "6")
        ExtractedCharacter = Replace(ExtractedCharacter, "M", "7")
        ExtractedCharacter = Replace(ExtractedCharacter, "N", "8")
        ExtractedCharacter = Replace(ExtractedCharacter, "O", "1")
        ExtractedCharacter = Replace(ExtractedCharacter, "P", "2")
        ExtractedCharacter = Replace(ExtractedCharacter, "Q", "3")
        ExtractedCharacter = Replace(ExtractedCharacter, "R", "4")
        ExtractedCharacter = Replace(ExtractedCharacter, "S", "5")
        ExtractedCharacter = Replace(ExtractedCharacter, "T", "6")
        ExtractedCharacter = Replace(ExtractedCharacter, "U", "7")
        ExtractedCharacter = Replace(ExtractedCharacter, "V", "8")
        ExtractedCharacter = Replace(ExtractedCharacter, "W", "1")
        ExtractedCharacter = Replace(ExtractedCharacter, "X", "2")
        ExtractedCharacter = Replace(ExtractedCharacter, "Y", "3")
        ExtractedCharacter = Replace(ExtractedCharacter, "Z", "4")
        ExtractedCharacter = Replace(ExtractedCharacter, "a", "5")
        ExtractedCharacter = Replace(ExtractedCharacter, "b", "6")
        ExtractedCharacter = Replace(ExtractedCharacter, "c", "7")
        ExtractedCharacter = Replace(ExtractedCharacter, "d", "8")
        ExtractedCharacter = Replace(ExtractedCharacter, "e", "1")
        ExtractedCharacter = Replace(ExtractedCharacter, "f", "2")
        ExtractedCharacter = Replace(ExtractedCharacter, "g", "3")
        ExtractedCharacter = Replace(ExtractedCharacter, "h", "4")
        ExtractedCharacter = Replace(ExtractedCharacter, "i", "5")
        ExtractedCharacter = Replace(ExtractedCharacter, "j", "6")
        ExtractedCharacter = Replace(ExtractedCharacter, "k", "7")
        ExtractedCharacter = Replace(ExtractedCharacter, "l", "8")
        ExtractedCharacter = Replace(ExtractedCharacter, "m", "1")
        ExtractedCharacter = Replace(ExtractedCharacter, "n", "2")
        ExtractedCharacter = Replace(ExtractedCharacter, "o", "3")
        ExtractedCharacter = Replace(ExtractedCharacter, "p", "4")
        ExtractedCharacter = Replace(ExtractedCharacter, "q", "5")
        ExtractedCharacter = Replace(ExtractedCharacter, "r", "6")
        ExtractedCharacter = Replace(ExtractedCharacter, "s", "7")
        ExtractedCharacter = Replace(ExtractedCharacter, "t", "8")
        ExtractedCharacter = Replace(ExtractedCharacter, "u", "1")
        ExtractedCharacter = Replace(ExtractedCharacter, "v", "2")
        ExtractedCharacter = Replace(ExtractedCharacter, "w", "3")
        ExtractedCharacter = Replace(ExtractedCharacter, "x", "4")
        ExtractedCharacter = Replace(ExtractedCharacter, "y", "5")
        ExtractedCharacter = Replace(ExtractedCharacter, "z", "6")
        If (ExtractedCharacter = 1 Or ExtractedCharacter = 2 Or ExtractedCharacter = 3 Or ExtractedCharacter = 4 Or ExtractedCharacter = 5 Or ExtractedCharacter = 6 Or ExtractedCharacter = 7 Or ExtractedCharacter = 8) Then
            TotalExtractedCharacters = TotalExtractedCharacters + Chr(ExtractedCharacter)
        End If
        SerialStrCount = SerialStrCount + 1
    Loop
    StringSpaceStrCount = CStr(SpaceStrCount - 1)
    StringSerialStrCount = CStr(SerialStrCount - 1)
    SerialCode = TotalExtractedCharacters
      
    PrimaryCode = PrimaryCode + SerialCode
      
    lenPrimaryCodeTemp = Len(PrimaryCode)
    lenPrimaryCodeTempStr = CStr(lenPrimaryCodeTemp)
    DebugEntry "Added Serial key. Length of Current PrimaryCode is " + lenPrimaryCodeTempStr
       
    PrimaryCode = PrimaryCode + "<<<ENCRYPTIONKEY2>>>"
      
    lenPrimaryCodeTemp = Len(PrimaryCode)
    lenPrimaryCodeTempStr = CStr(lenPrimaryCodeTemp)
    DebugEntry "Added Third key. Length of Current PrimaryCode is " + lenPrimaryCodeTempStr
      
    TotalExtractedCharacters = ""
    ManuStrCount = 1
    Do While ManuStrCount < (lenManu + 1)
        ExtractedCharacter = Mid(ManuString, ManuStrCount, 1)
        ExtractedCharacter = Replace(ExtractedCharacter, "0", "5")
        ExtractedCharacter = Replace(ExtractedCharacter, "9", "6")
        ExtractedCharacter = Replace(ExtractedCharacter, "A", "7")
        ExtractedCharacter = Replace(ExtractedCharacter, "B", "8")
        ExtractedCharacter = Replace(ExtractedCharacter, "C", "1")
        ExtractedCharacter = Replace(ExtractedCharacter, "D", "2")
        ExtractedCharacter = Replace(ExtractedCharacter, "E", "3")
        ExtractedCharacter = Replace(ExtractedCharacter, "F", "4")
        ExtractedCharacter = Replace(ExtractedCharacter, "G", "5")
        ExtractedCharacter = Replace(ExtractedCharacter, "H", "6")
        ExtractedCharacter = Replace(ExtractedCharacter, "I", "7")
        ExtractedCharacter = Replace(ExtractedCharacter, "J", "8")
        ExtractedCharacter = Replace(ExtractedCharacter, "K", "1")
        ExtractedCharacter = Replace(ExtractedCharacter, "L", "2")
        ExtractedCharacter = Replace(ExtractedCharacter, "M", "3")
        ExtractedCharacter = Replace(ExtractedCharacter, "N", "4")
        ExtractedCharacter = Replace(ExtractedCharacter, "O", "5")
        ExtractedCharacter = Replace(ExtractedCharacter, "P", "6")
        ExtractedCharacter = Replace(ExtractedCharacter, "Q", "7")
        ExtractedCharacter = Replace(ExtractedCharacter, "R", "8")
        ExtractedCharacter = Replace(ExtractedCharacter, "S", "1")
        ExtractedCharacter = Replace(ExtractedCharacter, "T", "2")
        ExtractedCharacter = Replace(ExtractedCharacter, "U", "3")
        ExtractedCharacter = Replace(ExtractedCharacter, "V", "4")
        ExtractedCharacter = Replace(ExtractedCharacter, "W", "5")
        ExtractedCharacter = Replace(ExtractedCharacter, "X", "6")
        ExtractedCharacter = Replace(ExtractedCharacter, "Y", "7")
        ExtractedCharacter = Replace(ExtractedCharacter, "Z", "8")
        ExtractedCharacter = Replace(ExtractedCharacter, "a", "1")
        ExtractedCharacter = Replace(ExtractedCharacter, "b", "2")
        ExtractedCharacter = Replace(ExtractedCharacter, "c", "3")
        ExtractedCharacter = Replace(ExtractedCharacter, "d", "4")
        ExtractedCharacter = Replace(ExtractedCharacter, "e", "5")
        ExtractedCharacter = Replace(ExtractedCharacter, "f", "6")
        ExtractedCharacter = Replace(ExtractedCharacter, "g", "7")
        ExtractedCharacter = Replace(ExtractedCharacter, "h", "8")
        ExtractedCharacter = Replace(ExtractedCharacter, "i", "1")
        ExtractedCharacter = Replace(ExtractedCharacter, "j", "2")
        ExtractedCharacter = Replace(ExtractedCharacter, "k", "3")
        ExtractedCharacter = Replace(ExtractedCharacter, "l", "4")
        ExtractedCharacter = Replace(ExtractedCharacter, "m", "5")
        ExtractedCharacter = Replace(ExtractedCharacter, "n", "6")
        ExtractedCharacter = Replace(ExtractedCharacter, "o", "7")
        ExtractedCharacter = Replace(ExtractedCharacter, "p", "8")
        ExtractedCharacter = Replace(ExtractedCharacter, "q", "1")
        ExtractedCharacter = Replace(ExtractedCharacter, "r", "2")
        ExtractedCharacter = Replace(ExtractedCharacter, "s", "3")
        ExtractedCharacter = Replace(ExtractedCharacter, "t", "4")
        ExtractedCharacter = Replace(ExtractedCharacter, "u", "5")
        ExtractedCharacter = Replace(ExtractedCharacter, "v", "6")
        ExtractedCharacter = Replace(ExtractedCharacter, "w", "7")
        ExtractedCharacter = Replace(ExtractedCharacter, "x", "8")
        ExtractedCharacter = Replace(ExtractedCharacter, "y", "1")
        ExtractedCharacter = Replace(ExtractedCharacter, "z", "2")
        If (ExtractedCharacter = 1 Or ExtractedCharacter = 2 Or ExtractedCharacter = 3 Or ExtractedCharacter = 4 Or ExtractedCharacter = 5 Or ExtractedCharacter = 6 Or ExtractedCharacter = 7 Or ExtractedCharacter = 8) Then
            TotalExtractedCharacters = TotalExtractedCharacters + Chr(ExtractedCharacter)
        End If
        ManuStrCount = ManuStrCount + 1
    Loop
    ManufacturersCode = TotalExtractedCharacters
    TotalExtractedCharacters = ""
      
    PrimaryCode = PrimaryCode + ManufacturersCode
      
    lenPrimaryCodeTemp = Len(PrimaryCode)
    lenPrimaryCodeTempStr = CStr(lenPrimaryCodeTemp)
      
    PrimaryCode = PrimaryCode + "<<<ENCRYPTIONKEY3>>>"
      
    lenPrimaryCodeTemp = Len(PrimaryCode)
    lenPrimaryCodeTempStr = CStr(lenPrimaryCodeTemp)
    DebugEntry "Added fourth key. Length of Current PrimaryCode is " + lenPrimaryCodeTempStr

    SortedManuString = ManuString
    SimpleSort SortedManuString
    DebugEntry "SortedManuString is " + SortedManuString
    TotalExtractedCharacters = ""
    TempString = ""
    ManuStrCount = 1
    Do While ManuStrCount < (lenManu + 1)
        ExtractedCharacter = Mid(SortedManuString, ManuStrCount, 1)
        ExtractedCharacter = Replace(ExtractedCharacter, "0", "8")
        ExtractedCharacter = Replace(ExtractedCharacter, "9", "1")
        ExtractedCharacter = Replace(ExtractedCharacter, "A", "2")
        ExtractedCharacter = Replace(ExtractedCharacter, "B", "3")
        ExtractedCharacter = Replace(ExtractedCharacter, "C", "4")
        ExtractedCharacter = Replace(ExtractedCharacter, "D", "5")
        ExtractedCharacter = Replace(ExtractedCharacter, "E", "6")
        ExtractedCharacter = Replace(ExtractedCharacter, "F", "7")
        ExtractedCharacter = Replace(ExtractedCharacter, "G", "8")
        ExtractedCharacter = Replace(ExtractedCharacter, "H", "1")
        ExtractedCharacter = Replace(ExtractedCharacter, "I", "2")
        ExtractedCharacter = Replace(ExtractedCharacter, "J", "3")
        ExtractedCharacter = Replace(ExtractedCharacter, "K", "4")
        ExtractedCharacter = Replace(ExtractedCharacter, "L", "5")
        ExtractedCharacter = Replace(ExtractedCharacter, "M", "6")
        ExtractedCharacter = Replace(ExtractedCharacter, "N", "7")
        ExtractedCharacter = Replace(ExtractedCharacter, "O", "8")
        ExtractedCharacter = Replace(ExtractedCharacter, "P", "1")
        ExtractedCharacter = Replace(ExtractedCharacter, "Q", "2")
        ExtractedCharacter = Replace(ExtractedCharacter, "R", "3")
        ExtractedCharacter = Replace(ExtractedCharacter, "S", "4")
        ExtractedCharacter = Replace(ExtractedCharacter, "T", "5")
        ExtractedCharacter = Replace(ExtractedCharacter, "U", "6")
        ExtractedCharacter = Replace(ExtractedCharacter, "V", "7")
        ExtractedCharacter = Replace(ExtractedCharacter, "W", "8")
        ExtractedCharacter = Replace(ExtractedCharacter, "X", "1")
        ExtractedCharacter = Replace(ExtractedCharacter, "Y", "2")
        ExtractedCharacter = Replace(ExtractedCharacter, "Z", "3")
        ExtractedCharacter = Replace(ExtractedCharacter, "a", "4")
        ExtractedCharacter = Replace(ExtractedCharacter, "b", "5")
        ExtractedCharacter = Replace(ExtractedCharacter, "c", "6")
        ExtractedCharacter = Replace(ExtractedCharacter, "d", "7")
        ExtractedCharacter = Replace(ExtractedCharacter, "e", "8")
        ExtractedCharacter = Replace(ExtractedCharacter, "f", "1")
        ExtractedCharacter = Replace(ExtractedCharacter, "g", "2")
        ExtractedCharacter = Replace(ExtractedCharacter, "h", "3")
        ExtractedCharacter = Replace(ExtractedCharacter, "i", "4")
        ExtractedCharacter = Replace(ExtractedCharacter, "j", "5")
        ExtractedCharacter = Replace(ExtractedCharacter, "k", "6")
        ExtractedCharacter = Replace(ExtractedCharacter, "l", "7")
        ExtractedCharacter = Replace(ExtractedCharacter, "m", "8")
        ExtractedCharacter = Replace(ExtractedCharacter, "n", "1")
        ExtractedCharacter = Replace(ExtractedCharacter, "o", "2")
        ExtractedCharacter = Replace(ExtractedCharacter, "p", "3")
        ExtractedCharacter = Replace(ExtractedCharacter, "q", "4")
        ExtractedCharacter = Replace(ExtractedCharacter, "r", "5")
        ExtractedCharacter = Replace(ExtractedCharacter, "s", "6")
        ExtractedCharacter = Replace(ExtractedCharacter, "t", "7")
        ExtractedCharacter = Replace(ExtractedCharacter, "u", "8")
        ExtractedCharacter = Replace(ExtractedCharacter, "v", "1")
        ExtractedCharacter = Replace(ExtractedCharacter, "w", "2")
        ExtractedCharacter = Replace(ExtractedCharacter, "x", "3")
        ExtractedCharacter = Replace(ExtractedCharacter, "y", "4")
        ExtractedCharacter = Replace(ExtractedCharacter, "z", "5")
        If (ExtractedCharacter = 1 Or ExtractedCharacter = 2 Or ExtractedCharacter = 3 Or ExtractedCharacter = 4 Or ExtractedCharacter = 5 Or ExtractedCharacter = 6 Or ExtractedCharacter = 7 Or ExtractedCharacter = 8) Then
            TotalExtractedCharacters = TotalExtractedCharacters + Chr(ExtractedCharacter)
            TempString = TempString + CStr(ExtractedCharacter)
        End If
        ManuStrCount = ManuStrCount + 1
    Loop
    ManufacturersCode = TotalExtractedCharacters
    TotalExtractedCharacters = ""
    
    DebugEntry "Key Of SortedManuString is " + TempString
    
    PrimaryCode = PrimaryCode + ManufacturersCode
    
    PrimaryCode = PrimaryCode + "<<<ENCRYPTIONKEY4>>>"
      
    lenPrimaryCodeTemp = Len(PrimaryCode)
    lenPrimaryCodeTempStr = CStr(lenPrimaryCodeTemp)
    DebugEntry "Added fifth key. Length of Current PrimaryCode is " + lenPrimaryCodeTempStr

    RevSortedManuString = StrReverse(SortedManuString)
    DebugEntry "RevSortedManuString is " + RevSortedManuString
    TotalExtractedCharacters = ""
    TempString = ""
    ManuStrCount = 1
    Do While ManuStrCount < (lenManu + 1)
        ExtractedCharacter = Mid(RevSortedManuString, ManuStrCount, 1)
        ExtractedCharacter = Replace(ExtractedCharacter, "0", "4")
        ExtractedCharacter = Replace(ExtractedCharacter, "9", "5")
        ExtractedCharacter = Replace(ExtractedCharacter, "A", "6")
        ExtractedCharacter = Replace(ExtractedCharacter, "B", "7")
        ExtractedCharacter = Replace(ExtractedCharacter, "C", "8")
        ExtractedCharacter = Replace(ExtractedCharacter, "D", "1")
        ExtractedCharacter = Replace(ExtractedCharacter, "E", "2")
        ExtractedCharacter = Replace(ExtractedCharacter, "F", "3")
        ExtractedCharacter = Replace(ExtractedCharacter, "G", "4")
        ExtractedCharacter = Replace(ExtractedCharacter, "H", "5")
        ExtractedCharacter = Replace(ExtractedCharacter, "I", "6")
        ExtractedCharacter = Replace(ExtractedCharacter, "J", "7")
        ExtractedCharacter = Replace(ExtractedCharacter, "K", "8")
        ExtractedCharacter = Replace(ExtractedCharacter, "L", "1")
        ExtractedCharacter = Replace(ExtractedCharacter, "M", "2")
        ExtractedCharacter = Replace(ExtractedCharacter, "N", "3")
        ExtractedCharacter = Replace(ExtractedCharacter, "O", "4")
        ExtractedCharacter = Replace(ExtractedCharacter, "P", "5")
        ExtractedCharacter = Replace(ExtractedCharacter, "Q", "6")
        ExtractedCharacter = Replace(ExtractedCharacter, "R", "7")
        ExtractedCharacter = Replace(ExtractedCharacter, "S", "8")
        ExtractedCharacter = Replace(ExtractedCharacter, "T", "1")
        ExtractedCharacter = Replace(ExtractedCharacter, "U", "2")
        ExtractedCharacter = Replace(ExtractedCharacter, "V", "3")
        ExtractedCharacter = Replace(ExtractedCharacter, "W", "4")
        ExtractedCharacter = Replace(ExtractedCharacter, "X", "5")
        ExtractedCharacter = Replace(ExtractedCharacter, "Y", "6")
        ExtractedCharacter = Replace(ExtractedCharacter, "Z", "7")
        ExtractedCharacter = Replace(ExtractedCharacter, "a", "8")
        ExtractedCharacter = Replace(ExtractedCharacter, "b", "1")
        ExtractedCharacter = Replace(ExtractedCharacter, "c", "2")
        ExtractedCharacter = Replace(ExtractedCharacter, "d", "3")
        ExtractedCharacter = Replace(ExtractedCharacter, "e", "4")
        ExtractedCharacter = Replace(ExtractedCharacter, "f", "5")
        ExtractedCharacter = Replace(ExtractedCharacter, "g", "6")
        ExtractedCharacter = Replace(ExtractedCharacter, "h", "7")
        ExtractedCharacter = Replace(ExtractedCharacter, "i", "8")
        ExtractedCharacter = Replace(ExtractedCharacter, "j", "1")
        ExtractedCharacter = Replace(ExtractedCharacter, "k", "2")
        ExtractedCharacter = Replace(ExtractedCharacter, "l", "3")
        ExtractedCharacter = Replace(ExtractedCharacter, "m", "4")
        ExtractedCharacter = Replace(ExtractedCharacter, "n", "5")
        ExtractedCharacter = Replace(ExtractedCharacter, "o", "6")
        ExtractedCharacter = Replace(ExtractedCharacter, "p", "7")
        ExtractedCharacter = Replace(ExtractedCharacter, "q", "8")
        ExtractedCharacter = Replace(ExtractedCharacter, "r", "1")
        ExtractedCharacter = Replace(ExtractedCharacter, "s", "2")
        ExtractedCharacter = Replace(ExtractedCharacter, "t", "3")
        ExtractedCharacter = Replace(ExtractedCharacter, "u", "4")
        ExtractedCharacter = Replace(ExtractedCharacter, "v", "5")
        ExtractedCharacter = Replace(ExtractedCharacter, "w", "6")
        ExtractedCharacter = Replace(ExtractedCharacter, "x", "7")
        ExtractedCharacter = Replace(ExtractedCharacter, "y", "8")
        ExtractedCharacter = Replace(ExtractedCharacter, "z", "1")
        If (ExtractedCharacter = 1 Or ExtractedCharacter = 2 Or ExtractedCharacter = 3 Or ExtractedCharacter = 4 Or ExtractedCharacter = 5 Or ExtractedCharacter = 6 Or ExtractedCharacter = 7 Or ExtractedCharacter = 8) Then
            TotalExtractedCharacters = TotalExtractedCharacters + Chr(ExtractedCharacter)
            TempString = TempString + CStr(ExtractedCharacter)
        End If
        ManuStrCount = ManuStrCount + 1
    Loop
    ManufacturersCode = TotalExtractedCharacters
    TotalExtractedCharacters = ""
    
    DebugEntry "Key Of RevSortedManuString is " + TempString
    
    PrimaryCode = PrimaryCode + ManufacturersCode
    
    PrimaryCode = PrimaryCode + "<<<ENCRYPTIONKEY5>>>"
      
    lenPrimaryCodeTemp = Len(PrimaryCode)
    lenPrimaryCodeTempStr = CStr(lenPrimaryCodeTemp)
    DebugEntry "Added sixth key. Length of Current PrimaryCode is " + lenPrimaryCodeTempStr
    
    'NOW GETTING CONFIG FILE AND THEN INDEX FILE FROM HypLern0.dat
    
    DataFileAddress = "HypLern0.dat"
    ForwardedAddress = HomePath + "\HypLernConfig.htm"
    On Error Resume Next
    ReadWriteFile ForwardedAddress, "read", Contents
    If (Mid(Contents, 1, 1) = "") Then
        FirstTimeConfig = "YES"
        TempStringToo = ""
        TempNumber = 1
        Do While TempNumber < 17
          TempNumberToo = Int(Rnd * 15)
          TempString = CStr(TempNumberToo)
          TempString = Replace(TempString, "10", "A")
          TempString = Replace(TempString, "11", "B")
          TempString = Replace(TempString, "12", "C")
          TempString = Replace(TempString, "13", "D")
          TempString = Replace(TempString, "14", "E")
          TempString = Replace(TempString, "15", "F")
          TempStringToo = TempStringToo + CStr(TempString)
          TempNumber = TempNumber + 1
        Loop
        RandomSecKey = TempStringToo

        ForwardedAddress = "HypLernConfig.htm"
        DebugEntry "1a. Searching in " + DataFileAddress + " for " + ForwardedAddress
        ReadDataFile DataFileAddress, 0, ForwardedAddress, Contents
        DecryptFile Contents
        DebugEntry "CONFIG CONTENTS" + Chr(10) + "=======================================" + Contents
    Else
        DebugEntry "Existing Config file... Getting contents..."
        DebugEntry "CONFIG CONTENTS" + Chr(10) + "=======================================" + Contents
    End If
      
    ContentArray = Split(Contents, DividingBR)

    TempNumber = Round(Me.Width + 2000 - 2000)
    DebugEntry "WindowWith is actually " + CStr(TempNumber)

    PrePath = ContentArray(10)
    PrePath = DiskRoot + PrePath
    
    EditMode = ContentArray(9)
    EditMode = Mid(EditMode, 4, 4)
    DebugEntry "EditMode is " + EditMode
    
    TempArray = Split(PrePath, "\")
    TempNumber = UBound(TempArray) - 1
    TempNumberToo = TempNumber - 1
    TempString = TempArray(TempNumberToo)
    TempString = TempString + "-" + TempArray(TempNumber)
    Executable = App.EXEName
    If (TempString = Executable) Then
      'ok continue
    Else
      BermudaWordMessageString = "Executable filename has changed or Config file is corrupted. Please remove any (numbers) behind the filename if you downloaded multiple times."
      DebugEntry "We're doomed! Application file " + CStr(Executable) + " isn't equal to path " + TempString + " in config! Quit!"
      BermudaWordMessage
      On Error Resume Next
      End
    End If
      
    ApplicationTitle = ContentArray(11)
    CourseLanguage = ContentArray(12)
    Groups = ContentArray(13)
    TempArray = Split(Groups, ",")
    Group = TempArray(1)
    DebugEntry "CourseTitle, CourseLanguage and Group are " + ApplicationTitle + " " + CourseLanguage + " " + Group
        
    TempString = ContentArray(8)
    TempArray = Split(TempString, ",")
    CourseChapters = TempArray(0)
  
    PermCustomCodes = ContentArray(18)
  
  
    WordListFile = ContentArray(14)
    WordListFileAZ = WordListFile + "AZ.htm"
    WordListFileDT = WordListFile + "DT.htm"
    WordListFileFQ = WordListFile + "FQ.htm"
    WordListFileTQ = WordListFile + "TQ.htm"
      
    Taal = ContentArray(15)
    If (Taal = "Default") Then
        Taal = ""
    End If
      
    TestFile = "HypLernTest.htm"
      
    VariableValues = ContentArray(16)
  
    VariableValuesArray = Split(VariableValues, ",")
    NV = 0
    D = 0
    NumberOfVariableValues = UBound(VariableValuesArray)
    Do While NV < NumberOfVariableValues + 1
        VariableValuesLineArray = Split(VariableValuesArray(NV), "=")
        If (VariableValuesLineArray(0) = "<<<TOTALBOOKNAME>>>") Then
            CourseTitle = VariableValuesLineArray(1)
        End If
        If (VariableValuesLineArray(0) = "<<<TOTALBOOKWORDS>>>") Then
            CourseWords = VariableValuesLineArray(1)
        End If
        If (VariableValuesLineArray(0) = "<<<TOTALBOOKUNIQUEWORDS>>>") Then
            CourseUnique = VariableValuesLineArray(1)
        End If
        If (VariableValuesLineArray(0) = "<<<TOTALBOOKNEWWORDS>>>") Then
            CourseNew = VariableValuesLineArray(1)
        End If
        If (VariableValuesLineArray(0) = "<<<SRSINCRFAC>>>") Then
            IncrementFactor = VariableValuesLineArray(1)
        End If
        If (VariableValuesLineArray(0) = "<<<SRSINCRRAW>>>") Then
            IncrementSeconds = VariableValuesLineArray(1)
        End If
        If (VariableValuesLineArray(0) = "<<<SRSMARGN>>>") Then
            IntervalMargin = VariableValuesLineArray(1)
        End If
        If (VariableValuesLineArray(0) = "<<<RETENTIONFACTOR>>>") Then
            RetentionFactor = VariableValuesLineArray(1)
        End If
        If (VariableValuesLineArray(0) = "<<<CHAPTERTESTFACTOR>>>") Then
            ChapterTestFactor = VariableValuesLineArray(1)
        End If
        If (VariableValuesLineArray(0) = "<<<AVERFREQ>>>") Then
            AverFreq = VariableValuesLineArray(1)
        End If
        If (VariableValuesLineArray(0) = "<<<AVERFREQTOP>>>") Then
            AverFreqTop = VariableValuesLineArray(1)
        End If
        If (VariableValuesLineArray(0) = "<<<ALSOHIFREQNICE>>>") Then
            AlsoHiFreq = VariableValuesLineArray(1)
        End If
        If (VariableValuesLineArray(0) = "<<<NONEFIMYWONICE>>>") Then
            NoNeFiMyWo = VariableValuesLineArray(1)
        End If
        If (VariableValuesLineArray(0) = "<<<KEEPTESTEDNICE>>>") Then
            KeepTested = VariableValuesLineArray(1)
        End If
        If (VariableValuesLineArray(0) = "<<<TEACHERCURRENTMYWORDSNUMBER>>>") Then
            TeCuMyWo = VariableValuesLineArray(1)
        End If
        If (VariableValuesLineArray(0) = "<<<TEACHERCURRENTCHAPTERNUMBER>>>") Then
            TeCuChap = VariableValuesLineArray(1)
        End If
        ' changed TeCuPage to actual page (so can be in non-teachermode as well)
        'If (VariableValuesLineArray(0) = "<<<TEACHERCURRENTCHAPTERPAGE>>>") Then
        '    TeCuPage = VariableValuesLineArray(1)
        'End If
        If (VariableValuesLineArray(0) = "<<<MYFINISHEDBOOKS>>>") Then
            MyFinishedBooks = VariableValuesLineArray(1)
        End If
        If (RandomSecKey = "" And VariableValuesLineArray(0) = "<<<RANDOMSECKEY>>>") Then
            RandomSecKey = VariableValuesLineArray(1)
        End If
        Do While D < 30
            DS = CStr(D)
            If (VariableValuesLineArray(0) = "<<<SRSREM" + DS + ">>>") Then
                SRSRemArray(D) = VariableValuesLineArray(1)
            End If
            D = D + 1
        Loop
        D = 0
        NV = NV + 1
    Loop
    NV = 0
    
    TempArray = Split(PermCustomCodes, ",<<<NEXTPAGE>>>")
    TempString = TempArray(0)
    TeCuPage = Replace(TempString, "<<<PAGENUMBER>>>,", "")
      
    ConfigLogKey = ConfigLogKey + CStr(IncrementFactor) + "-" + CStr(IncrementSeconds) + "-" + CStr(RetentionFactor) + "-" + CStr(ChapterTestFactor) + "-" + CStr(AlsoHiFreq) + "-" + CStr(NoNeFiMyWo) + "-" + CStr(KeepTested) + "-" + CStr(AverFreq) + "-" + CStr(AverFreqTop) + "-" + CStr(TeCuMyWo) + "-" + CStr(TeCuChap) + "-" + CStr(TeCuPage)
      
    ConfigValues = ContentArray(17)
      
    D = 0
    Do While D < 16
        ConfigBase = ConfigBase + ContentArray(D) + DividingBR
        D = D + 1
    Loop
    
    Me.Caption = "Loading.."
    
    IndexAddress = "index.htm"
    DebugEntry "1b. Searching in " + DataFileAddress + " for " + IndexAddress
    ReadDataFile DataFileAddress, 0, IndexAddress, Contents
    DecryptFile Contents
    IndexContents = Contents
    DebugEntry "INDEX CONTENTS" + Chr(10) + "=======================================" + IndexContents
     
    Me.Caption = "Loading..."
      
    ParsingAddress = "Parse.htm"
    IndexContentArray = Split(IndexContents, "#" + ParsingAddress + "#")
    On Error Resume Next
    If (Len(IndexContentArray(1)) > 0) Then
        DataFileNumber = IndexContentArray(1)
        FileIndexNumber = IndexContentArray(2)
        DataFileAddress = "HypLern" + DataFileNumber + ".dat"
    Else
        SecurityError
    End If
      
    Me.Caption = "Loading...."

    DebugEntry "1c. Searching in " + DataFileAddress + " for Parse data"
    ReadDataFile DataFileAddress, DataFileNumber, ParsingAddress, Contents
    DecryptFile Contents
    ParseContents = Contents
    DebugEntry "PARSE TABLE" + Chr(10) + "==========================================" + ParseContents
      
    Me.Caption = "Loading....."
  
    ParseContentArray = Split(ParseContents, DividingRet + "SEC§")
    SecurityKey = "http://www.bermudaword.com/register/NOKEY"
    For Each ParseLine In ParseContentArray
        lenParseLine = Len(ParseLine)
        If (lenParseLine > 9) Then
            ParseArray = Split(ParseLine, "§")
            ParseType = ParseArray(0)
            ParseBase = ParseArray(1)
            ParseChange = ParseArray(2)
            If (ParseType = "NONE") Then
                If ParseBase = "GeheimeSleutel" Then
                    DebugEntry "Found SecurityKey in Parse"
                    SecurityKey = "http://www.bermudaword.com/register/" + ParseChange
                End If
            End If
        End If
    Next
    
    DebugEntry "SecurityKey is " + CStr(SecurityKey)
  
    Me.Caption = "Loading......"
  
    TotalExtractedCharacters = ""
    TempNumber = 1
    TempNumberToo = Len(SecurityKey) + 1
    Do While TempNumber < TempNumberToo
        ExtractedCharacter = Mid(SecurityKey, TempNumber, 1)
        ExtractedCharacter = Replace(ExtractedCharacter, "0", "7")
        ExtractedCharacter = Replace(ExtractedCharacter, "9", "8")
        ExtractedCharacter = Replace(ExtractedCharacter, "A", "1")
        ExtractedCharacter = Replace(ExtractedCharacter, "B", "2")
        ExtractedCharacter = Replace(ExtractedCharacter, "C", "3")
        ExtractedCharacter = Replace(ExtractedCharacter, "D", "4")
        ExtractedCharacter = Replace(ExtractedCharacter, "E", "5")
        ExtractedCharacter = Replace(ExtractedCharacter, "F", "6")
        ExtractedCharacter = Replace(ExtractedCharacter, "G", "7")
        ExtractedCharacter = Replace(ExtractedCharacter, "H", "8")
        ExtractedCharacter = Replace(ExtractedCharacter, "I", "1")
        ExtractedCharacter = Replace(ExtractedCharacter, "J", "2")
        ExtractedCharacter = Replace(ExtractedCharacter, "K", "3")
        ExtractedCharacter = Replace(ExtractedCharacter, "L", "4")
        ExtractedCharacter = Replace(ExtractedCharacter, "M", "5")
        ExtractedCharacter = Replace(ExtractedCharacter, "N", "6")
        ExtractedCharacter = Replace(ExtractedCharacter, "O", "7")
        ExtractedCharacter = Replace(ExtractedCharacter, "P", "8")
        ExtractedCharacter = Replace(ExtractedCharacter, "Q", "1")
        ExtractedCharacter = Replace(ExtractedCharacter, "R", "2")
        ExtractedCharacter = Replace(ExtractedCharacter, "S", "3")
        ExtractedCharacter = Replace(ExtractedCharacter, "T", "4")
        ExtractedCharacter = Replace(ExtractedCharacter, "U", "5")
        ExtractedCharacter = Replace(ExtractedCharacter, "V", "6")
        ExtractedCharacter = Replace(ExtractedCharacter, "W", "7")
        ExtractedCharacter = Replace(ExtractedCharacter, "X", "8")
        ExtractedCharacter = Replace(ExtractedCharacter, "Y", "1")
        ExtractedCharacter = Replace(ExtractedCharacter, "Z", "2")
        ExtractedCharacter = Replace(ExtractedCharacter, "a", "3")
        ExtractedCharacter = Replace(ExtractedCharacter, "b", "4")
        ExtractedCharacter = Replace(ExtractedCharacter, "c", "5")
        ExtractedCharacter = Replace(ExtractedCharacter, "d", "6")
        ExtractedCharacter = Replace(ExtractedCharacter, "e", "7")
        ExtractedCharacter = Replace(ExtractedCharacter, "f", "8")
        ExtractedCharacter = Replace(ExtractedCharacter, "g", "1")
        ExtractedCharacter = Replace(ExtractedCharacter, "h", "2")
        ExtractedCharacter = Replace(ExtractedCharacter, "i", "3")
        ExtractedCharacter = Replace(ExtractedCharacter, "j", "4")
        ExtractedCharacter = Replace(ExtractedCharacter, "k", "5")
        ExtractedCharacter = Replace(ExtractedCharacter, "l", "6")
        ExtractedCharacter = Replace(ExtractedCharacter, "m", "7")
        ExtractedCharacter = Replace(ExtractedCharacter, "n", "8")
        ExtractedCharacter = Replace(ExtractedCharacter, "o", "1")
        ExtractedCharacter = Replace(ExtractedCharacter, "p", "2")
        ExtractedCharacter = Replace(ExtractedCharacter, "q", "3")
        ExtractedCharacter = Replace(ExtractedCharacter, "r", "4")
        ExtractedCharacter = Replace(ExtractedCharacter, "s", "5")
        ExtractedCharacter = Replace(ExtractedCharacter, "t", "6")
        ExtractedCharacter = Replace(ExtractedCharacter, "u", "7")
        ExtractedCharacter = Replace(ExtractedCharacter, "v", "8")
        ExtractedCharacter = Replace(ExtractedCharacter, "w", "1")
        ExtractedCharacter = Replace(ExtractedCharacter, "x", "2")
        ExtractedCharacter = Replace(ExtractedCharacter, "y", "3")
        ExtractedCharacter = Replace(ExtractedCharacter, "z", "4")
        If (ExtractedCharacter = 1 Or ExtractedCharacter = 2 Or ExtractedCharacter = 3 Or ExtractedCharacter = 4 Or ExtractedCharacter = 5 Or ExtractedCharacter = 6 Or ExtractedCharacter = 7 Or ExtractedCharacter = 8) Then
            TotalExtractedCharacters = TotalExtractedCharacters + Chr(ExtractedCharacter)
        End If
        TempNumber = TempNumber + 1
    Loop
    TempStringToo = TotalExtractedCharacters
    TotalExtractedCharacters = ""
    PrimaryCode = PrimaryCode + TempStringToo
      
    TempNumberTree = Len(TempStringToo)
    DebugEntry "Added extra key of length " + CStr(TempNumberTree)
 
    StartingScreen = True
    If (FirstTimeConfig = "YES") Then
        StartingAddress = PrePath + "Config\Course" + CourseLanguage + "Start.htm"
    Else
        TempNumber = TeCuPage + 1
        BasicStartingAddress = PrePath + "Config\Course" + CourseLanguage + "Start.htm"
        StartingAddress = "about:blankGET§Course" + CourseLanguage + Group + "TextMain.htm<>" + CStr(TeCuPage) + "<>§Course" + CourseLanguage + Group + "Text" + CStr(TeCuPage) + ".htm<>Course" + CourseLanguage + Group + "Text" + CStr(TempNumber) + ".htm§<<<PAGETABLE>>><><<<PTWOTABLE>>>§NO"
    End If
    FirstNav = True
    StartUp = True
      
    Me.Show
    WindowWidthDifference = Me.Width - brwWebBrowser.Width
    TempNumber = Round(WindowWidthDifference - 2000 + 2000)
    DebugEntry "WindowWidthDifference is " + CStr(TempNumber)
    WindowHeightDifference = Me.Height - brwWebBrowser.Height
    Form_Resize
    ConfigValuesArray = Split(ConfigValues, ",")
    For Each ConfigValue In ConfigValuesArray
        ConfigValueLine = Split(ConfigValue, "=")
        If (ConfigValueLine(0) = "<<<LAYOUTEXTRA>>>") Then
            WindowLayout = ConfigValueLine(2)
        End If
        If (ConfigValueLine(0) = "<<<TABLEWIDTH>>>") Then
            WindowWidth = ConfigValueLine(2)
        End If
    Next
  
    If Len(StartingAddress) > 0 Then
        WindowHeight = 10000
        LayoutConfig = True
        brwWebBrowser.Navigate2 BasicStartingAddress
    End If
  
    On Error Resume Next
    ReadWriteFile HomePath + "\" + WordListFileAZ, "read", WordListAllAZ
    If (Mid(WordListAllAZ, 1, 1) = "") Then
        ReadWriteFile WordListFileAZ, "mread", WordListAllAZ
    Else
        If (FirstTimeConfig = "YES") Then
            TempArray = Split(WordListAllAZ, "<!--DIVCHAR--><ILP>")
            TempNumber = UBound(TempArray)
            If (TempNumber > 1) Then
                TempString = TempArray(1)
                TempArray = Split(TempString, "<BR></DIV></NOBR>" + Chr(10))
                'this is number of words of AZ file
                TempNumber = UBound(TempArray) + 1
            End If
        End If
    End If
     'first and last split
    IndexContentArray = Split(IndexContents, DividingRet)
    NumberOfIndexLines = UBound(IndexContentArray)
    TempString = CStr(NumberOfIndexLines)
    IndexContents = IndexContents + "#" + WordListFileAZ + "#X#" + WordListFileAZ + "#" + TempString + "#" + WordListFileAZ + "#" + DividingRet
    FileIndexArray(NumberOfIndexLines) = WordListAllAZ
      
    ReadWriteFile HomePath + "\" + WordListFileDT, "read", WordListAllDT
    If (Mid(WordListAllDT, 1, 1) = "") Then
        ReadWriteFile WordListFileDT, "mread", WordListAllDT
    Else
        If (FirstTimeConfig = "YES") Then
            TempArray = Split(WordListAllDT, "<!--DIVCHAR--><ILP>")
            TempNumberToo = UBound(TempArray)
            If (TempNumberToo > 1) Then
                TempString = TempArray(1)
                TempArray = Split(TempString, "<BR></DIV></NOBR>" + Chr(10))
                  'this is number of words
                TempNumberToo = UBound(TempArray) + 1
            End If
        End If
    End If
    NumberOfIndexLines = NumberOfIndexLines + 1
    TempString = CStr(NumberOfIndexLines)
    IndexContents = IndexContents + "#" + WordListFileDT + "#X#" + WordListFileDT + "#" + TempString + "#" + WordListFileDT + "#" + DividingRet
    FileIndexArray(NumberOfIndexLines) = WordListAllDT
      
    ReadWriteFile HomePath + "\" + WordListFileFQ, "read", WordListAllFQ
    If (Mid(WordListAllFQ, 1, 1) = "") Then
        ReadWriteFile WordListFileFQ, "mread", WordListAllFQ
    Else
        If (FirstTimeConfig = "YES") Then
            TempArray = Split(WordListAllFQ, "<!--DIVCHAR--><ILP>")
            TempNumberTree = UBound(TempArray)
            If (TempNumberTree > 1) Then
                TempString = TempArray(1)
                TempArray = Split(TempString, "<BR></DIV></NOBR>" + Chr(10))
                'this is number of words
                TempNumberTree = UBound(TempArray) + 1
            End If
        End If
    End If
    NumberOfIndexLines = NumberOfIndexLines + 1
    TempString = CStr(NumberOfIndexLines)
    IndexContents = IndexContents + "#" + WordListFileFQ + "#X#" + WordListFileFQ + "#" + TempString + "#" + WordListFileFQ + "#" + DividingRet
    FileIndexArray(NumberOfIndexLines) = WordListAllFQ
      
    ReadWriteFile HomePath + "\" + WordListFileTQ, "read", WordListAllTQ
    If (Mid(WordListAllTQ, 1, 1) = "") Then
        ReadWriteFile WordListFileTQ, "mread", WordListAllTQ
    Else
        If (FirstTimeConfig = "YES") Then
            TempArray = Split(WordListAllTQ, "<!--DIVCHAR--><ILP>")
            TempNumberFore = UBound(TempArray)
            If (TempNumberFore > 1) Then
                TempString = TempArray(1)
                TempArray = Split(TempString, "<BR></DIV></NOBR>" + Chr(10))
                'this is number of words
                TempNumberFore = UBound(TempArray) + 1
            End If
        End If
    End If
    NumberOfIndexLines = NumberOfIndexLines + 1
    TempString = CStr(NumberOfIndexLines)
    IndexContents = IndexContents + "#" + WordListFileTQ + "#X#" + WordListFileTQ + "#" + TempString + "#" + WordListFileTQ + "#" + DividingRet
    FileIndexArray(NumberOfIndexLines) = WordListAllTQ
   
    If (FirstTimeConfig = "YES" And (TempNumber = TempNumberToo And TempNumber = TempNumberTree And TempNumber = TempNumberFore)) Then
        DebugEntry "FirstTimeConfig but MyWords present, checking Number of MyWords in four files: " + CStr(TempNumber) + ", " + CStr(TempNumberToo) + ", " + CStr(TempNumberTree) + ", " + CStr(TempNumberFore) + "Numbers! Use that number onwards!"
        VariableValues = Replace(VariableValues, "<<<TEACHERCURRENTMYWORDSNUMBER>>>=" + CStr(TeCuMyWo), "<<<TEACHERCURRENTMYWORDSNUMBER>>>=" + CStr(TempNumber))
        'fixing any my words total number errors while we re at it
        TeCuMyWo = TempNumber
    End If
    
    If (TeCuChap <> 999) Then
        TempNumber = 1
        TempStringTree = ""
        NumberOfIndexLines = NumberOfIndexLines + 1
        Do While TempNumber < 1000
            TempString = ""
            DebugEntry "Looking for " + LanguageHomePath + "\" + CStr(TempNumber) + "-FinishedUniqueWordsFile.htm"
            ReadWriteFile LanguageHomePath + "\" + CStr(TempNumber) + "-FinishedUniqueWordsFile.htm", "read", TempString
            If (Mid(TempString, 1, 1) = "") Then
                If (TempNumber > 99) Then
                    'quit looking if no entry for this number (if you delete files holes can occur but after 99 books I do not give a flying f anymore)
                    TempNumber = 1000
                End If
            Else
                DebugEntry "Found Finished Book with number " + CStr(TempNumber)
                TempArray = Split(TempString, "<BR>")
                'Add Found Book title, Number of words, Unique words, New words and Percentage
                TempStringTree = TempStringTree + TempArray(1) + "<#FB7>"
                TempString = Replace(TempString, "<BR>" + TempArray(1) + "<BR>", "<BR>")
                FileIndexArray(NumberOfIndexLines) = FileIndexArray(NumberOfIndexLines) + TempString
            End If
            TempNumber = TempNumber + 1
        Loop
        ' If we found Finished Book(s), add index reference, if not subtract one from NumberOfIndexLines again
        DebugEntry "TempStringTree is " + TempStringTree
        If (TempStringTree <> "" And TempStringTree <> MyFinishedBooks) Then
            DebugEntry "FinishedBooks value changed, now: " + TempStringTree
            TempStringToo = CStr(NumberOfIndexLines)
            IndexContents = IndexContents + "#FinishedUniqueWordsFile.htm#X#FinishedUniqueWordsFile.htm#" + TempStringToo + "#FinishedUniqueWordsFile.htm#" + DividingRet
            VariableValues = Replace(VariableValues, "<<<MYFINISHEDBOOKS>>>=" + MyFinishedBooks + ",", "<<<MYFINISHEDBOOKS>>>=" + TempStringTree + ",")
            MyFinishedBooks = TempStringTree
            DebugEntry "MyFinishedBooks " + TempStringTree
            TempString = FileIndexArray(NumberOfIndexLines)
            TempString = Replace(TempString, "<BR><BR>", "<BR>")
            DebugEntry "All Finished Books Unique Words: " + TempString
            FileIndexArray(NumberOfIndexLines) = TempString
            ' If new books were finished after last config, we recalculate number of unique words for this book and its chapters
            IndexContentArray = Split(IndexContents, "#UniqueWordsFile.htm#")
            DataFileNumber = IndexContentArray(1)
            FileIndexNumber = IndexContentArray(2)
            If FileIndexArray(FileIndexNumber) = "" Then
                DataFileAddress = PrePath + "Data\HypLern" + DataFileNumber + ".dat"
                ReadDataFile DataFileAddress, DataFileNumber, "UniqueWordsFile.htm", TempStringToo
                DecryptFile TempStringToo
                FileIndexArray(FileIndexNumber) = TempStringToo
            Else
                TempStringToo = FileIndexArray(FileIndexNumber)
            End If
            DebugEntry "This Book's Unique Words: " + TempStringToo
            TempNumber = 0
            TempNumberTree = 0
            ParseLine = ""
            DebugEntry "Now Going To Recount For All This Book's " + CourseChapters + " Chapters"
            Do While TempNumber < CourseChapters
                TempNumber = TempNumber + 1
                TempNumberToo = 0
                TempArray = Split(TempStringToo, "<BR>(" + CStr(TempNumber) + ")")
                TempNumberFore = UBound(TempArray)
                DebugEntry "Nu voor Chapter " + CStr(TempNumber) + ", voor all UniqueWords (" + CStr(TempNumberFore) + ") check of Unique in vergelijking met Finished Books"
                TempNumberFyve = 0
                For Each ParseLine In TempArray
                    If (TempNumberFyve = 0 Or TempNumberFyve = TempNumberFore) Then
                        'skip first and last
                        DebugEntry "Skip First And Last"
                    Else
                        'split TempString, if anything
                        TempArrayToo = Split(TempString, "<BR>" + ParseLine + "<BR>")
                        If (UBound(TempArrayToo) > 0) Then
                            'this word already exists, no countie countie
                        Else
                            'this word does not exist in Finished book(s), count with the wind
                            DebugEntry "Chapter " + CStr(TempNumber) + ": Word " + CStr(ParseLine) + " is NEW"
                            TempNumberToo = TempNumberToo + 1
                        End If
                    End If
                    TempNumberFyve = TempNumberFyve + 1
                Next
                ' fill out new chapter new words value
                DebugEntry "Fill out new chapter new words value " + CStr(TempNumberToo)
                TempArrayTree = Split(VariableValues, "<<<CHAPTERNEWWORDS" + CStr(TempNumber) + ">>>=")
                TempStringTree = TempArrayTree(1)
                TempArrayTree = Split(TempStringTree, ",")
                TempStringTree = TempArrayTree(0)
                VariableValues = Replace(VariableValues, "<<<CHAPTERNEWWORDS" + CStr(TempNumber) + ">>>=" + TempStringTree + ",", "<<<CHAPTERNEWWORDS" + CStr(TempNumber) + ">>>=" + CStr(TempNumberToo) + ",")
                ' get existing chapter words value for percentage calculation
                DebugEntry "Get existing chapter words value"
                TempArrayFore = Split(VariableValues, "<<<CHAPTERWORDS" + CStr(TempNumber) + ">>>=")
                TempStringFore = TempArrayFore(1)
                TempArrayFore = Split(TempStringFore, ",")
                TempNumberFore = TempArrayFore(0)
                DebugEntry "Chapter Words value is " + CStr(TempNumberFore)
                ' recalcerlate percentage
                TempNumberFyve = Round((TempNumberToo / TempNumberFore) * 100)
                DebugEntry "New Percentage is " + CStr(TempNumberFyve)
                TempArrayFyve = Split(VariableValues, "<<<CHAPTERNEWPERCENTAGE" + CStr(TempNumber) + ">>>=")
                TempStringFyve = TempArrayFyve(1)
                TempArrayFyve = Split(TempStringFyve, ",")
                TempStringFyve = TempArrayFyve(0)
                VariableValues = Replace(VariableValues, "<<<CHAPTERNEWPERCENTAGE" + CStr(TempNumber) + ">>>=" + TempStringFyve + ",", "<<<CHAPTERNEWPERCENTAGE" + CStr(TempNumber) + ">>>=" + CStr(TempNumberFyve) + ",")
                ' recount total new words (ravaged after subtracting finished book ones)
                TempNumberTree = TempNumberTree + TempNumberToo
            Loop
            DebugEntry "Total Number Of New Words Remaining From Original New " + CStr(CourseNew) + " is " + CStr(TempNumberTree)
            CoursePercentage = Round((CourseNew / CourseWords) * 100)
            ConfigBase = Replace(ConfigBase, "CourseInformation:<BR>" + CStr(CourseChapters) + "," + CStr(CourseWords) + "," + CStr(CourseNew) + "<BR>", "CourseInformation:<BR>" + CStr(CourseChapters) + "," + CStr(CourseWords) + "," + CStr(TempNumberTree) + "<BR>")
            DebugEntry "Trying to replace " + "<<<TOTALBOOKNEWWORDS>>>=" + CStr(CourseNew) + ", with <<<TOTALBOOKNEWWORDS>>>=" + CStr(TempNumberTree) + ","
            VariableValues = Replace(VariableValues, "<<<TOTALBOOKNEWWORDS>>>=" + CStr(CourseNew) + ",", "<<<TOTALBOOKNEWWORDS>>>=" + CStr(TempNumberTree) + ",")
            CourseNew = TempNumberTree
            TempNumberFore = Round((CourseNew / CourseWords) * 100)
            DebugEntry "Trying to replace " + "<<<TOTALBOOKNEWWORDSPERCENTAGE>>>=" + CStr(CoursePercentage) + ", with <<<TOTALBOOKNEWWORDSPERCENTAGE>>>=" + CStr(TempNumberFore) + ","
            VariableValues = Replace(VariableValues, "<<<TOTALBOOKNEWWORDSPERCENTAGE>>>=" + CStr(CoursePercentage) + ",", "<<<TOTALBOOKNEWWORDSPERCENTAGE>>>=" + CStr(TempNumberFore) + ",")
            CoursePercentage = TempNumberFore
        Else
            DebugEntry "No New Finished Books"
            'If (TempStringTree <> MyFinishedBooks And TempStringTree = "") Then
            '    DebugEntry "No Finished Books At All Anymore"
            '    VariableValues = Replace(VariableValues, "<<<MYFINISHEDBOOKS>>>=" + MyFinishedBooks + ",", "<<<MYFINISHEDBOOKS>>>=<#FB8>,")
            '    MyFinishedBooks = TempStringTree
            'Else
            '    DebugEntry "Still No Finished Books"
            'End If
            'Later, if there is same amount of finished books, load the words here if you want to play
            NumberOfIndexLines = NumberOfIndexLines - 1
        End If
    End If
    
    ParseContentArray = Split(ParseContents, DividingRet + "TMP§")
    For Each ParseLine In ParseContentArray
        lenParseLine = Len(ParseLine)
        If (lenParseLine > 9) Then
            ParseArray = Split(ParseLine, "§")
            ParseType = ParseArray(0)
            ParseBase = ParseArray(1)
            ParseChange = ParseArray(2)
            If (ParseType = "NONE") Then
                ParsingAddress = ParseChange
                IndexContentArray = Split(IndexContents, "#" + ParsingAddress + "#")
                DataFileNumber = IndexContentArray(1)
                FileIndexNumber = IndexContentArray(2)
                ReadDataFile "HypLern" + DataFileNumber + ".dat", DataFileNumber, ParsingAddress, Contents
                DecryptFile Contents
                ParseTemplateArray(T) = ParseBase
                T = T + 1
                ParseTemplate = Contents
                ParseTemplateArray(T) = ParseTemplate
                T = T + 1
            End If
            If (ParseType = "KLIK") Then
                ParsingAddress = ParseChange
                IndexContentArray = Split(IndexContents, "#" + ParsingAddress + "#")
                DataFileNumber = IndexContentArray(1)
                FileIndexNumber = IndexContentArray(2)
                ReadDataFile "HypLern" + DataFileNumber + ".dat", DataFileNumber, ParsingAddress, Contents
                DecryptFile Contents
                ParseTemplateArray(T) = ParseBase
                T = T + 1
                ParseTemplate = Contents
                ParseTemplateArray(T) = ParseTemplate
                T = T + 1
                HyplernWordListAll = Contents
            End If
            If (ParseType = "TEST") Then
                ParsingAddress = ParseChange
                IndexContentArray = Split(IndexContents, "#" + ParsingAddress + "#")
                DataFileNumber = IndexContentArray(1)
                FileIndexNumber = IndexContentArray(2)
                ReadDataFile "HypLern" + DataFileNumber + ".dat", DataFileNumber, ParsingAddress, Contents
                DecryptFile Contents
                ParseTemplateArray(T) = ParseBase
                T = T + 1
                ParseTemplate = Contents
                ParseTemplateArray(T) = ParseTemplate
                T = T + 1
                HyplernWordListTst = Contents
            End If
        End If
    Next
     
    FinalContents = ""
    SecurityURL = SecurityKey + ".htm?a=" + RandomSecKey + "-" + ConfigLogKey
    DebugEntry "Going for SecurityURL " + CStr(SecurityURL)
    brwWebBrowser.Navigate2 SecurityURL
      
End Sub
  
  Sub DecryptFile(Contents)
     Dim N As Long
     Dim E As Long
     Dim PrimaryCodeArray, PrimaryCodeChars, PrimaryCodeLength, CodeChar, CodeCharAscii, PrimaryCodeCharsString
     Dim EncryptedCharsArray, EncryptedCharAscii, EncryptedChar, EncryptedChars, EncryptedCharsString, LenEncryptedChars
     Dim DecryptedChar As Variant
     Dim NextCharPlus As Boolean
     Dim NextTwoCharSkip As Boolean
     Dim NotEncryptedCharLen
     Dim UnEncryptedContents
     Dim DecryptedCharAscii
     Dim DecryptedCharsString
     Dim DecryptedChars(1999999)
     Dim TempString
     Dim PrimaryPlus, PrimaryNumb
     Dim EncryptedCharString, DecryptedCharTotal
     
     If (NoEncryption = "ON") Then
       ' skip decryption cuz it hasn't been encrypted
       TempString = "Empty"
       
     Else
     
       TimeString = CStr(Now)
  
       EncryptedChar = ""
       E = 0
       N = 0
       NextCharPlus = False
       LenEncryptedChars = Len(Contents)
       PrimaryCodeLength = Len(PrimaryCode)
       Do While E < (LenEncryptedChars)
          E = E + 1
          N = N + 1
          If (N > PrimaryCodeLength) Then
             N = 1
          End If
          EncryptedChar = Mid(Contents, E, 1)
          CodeChar = Mid(PrimaryCode, N, 1)
    
          CodeCharAscii = Asc(CodeChar)
          EncryptedCharAscii = Asc(EncryptedChar)
          
          If (EncryptedCharAscii = 1) Then
             EncryptedCharAscii = 12
          End If
          If (EncryptedCharAscii = 3) Then
             EncryptedCharAscii = 26
          End If
    
          If (EncryptedCharAscii = 2) Then
             NextCharPlus = True
             N = N - 1
          Else
             If (NextCharPlus = True) Then
                EncryptedCharAscii = EncryptedCharAscii + 100
                NextCharPlus = False
             End If
             DecryptedCharAscii = (300 + CodeCharAscii) - EncryptedCharAscii
             DecryptedChar = Chr(DecryptedCharAscii)
             DecryptedChars(E) = DecryptedChar
          End If
       Loop
    
       Contents = Join(DecryptedChars, "")
    
       TempString = TimeString + " -> " + CStr(Now)
     End If
     
  End Sub
  
  Sub ReadDataFile(DataFileAddress, Part, RequestedAddress, DataContents)
     Const ForReading = 1
     Dim lenRetstring As Long
     Dim retstring, recstring, ForwardedAddressFileName
     Dim LenContents, DividingChar
     Dim ReadChars
     Dim RecordedChars
     Dim R
     Dim ForwardedAddressArray
     Dim ForwardedAddressPart
     Dim DataFileAddressArray
     
     TempString = CStr(Part)
     TimeString = CStr(Now)
     retstring = " "
  
     R = 0
     ForwardedAddressArray = Split(RequestedAddress, "\")
     ForwardedAddressFileName = "<<<" + ForwardedAddressArray(UBound(ForwardedAddressArray)) + ">>>"
     DataFileAddressArray = Split(DataFileAddress, "\")
     DataFileAddress = DataFileAddressArray(UBound(DataFileAddressArray))
  
     If DataFileContents(Part) = "" Then
        retstring = StrConv(LoadResData(UCase(DataFileAddress), 2110), vbUnicode)
        DataFileContents(Part) = retstring
     Else
        retstring = DataFileContents(Part)
     End If
     
     ReadChars = Split(retstring, ForwardedAddressFileName)
     recstring = ReadChars(1)
     RecordedChars = Split(recstring, "<<<End_Of_File>>>")
     DataContents = RecordedChars(0)
     
     lenRetstring = Len(DataContents)
     If lenRetstring > 0 Then
        DataContents = Mid(DataContents, 3)
        LenContents = Len(DataContents)
        LenContents = LenContents - 2
        DataContents = Mid(DataContents, 1, LenContents)
     Else
        DataContents = "½"
     End If
     
     TempString = TimeString + " -> " + CStr(Now)
     DebugEntry TempString
     
  End Sub
  
  Sub ReadWriteFile(ForwardedAddress, Modus, Contents)
     Dim FileProcess, FileWrite, FileRead
     Const ForReading = 1
     Const ForWriting = 2
     Const ForAppending = 8
     Set FileProcess = CreateObject("Scripting.FileSystemObject")
     If Modus = "write" Then
        Set FileWrite = FileProcess.CreateTextFile(ForwardedAddress, True)
        On Error Resume Next
        FileWrite.WriteLine Contents
        FileWrite.Close
     End If
     If Modus = "add" Then
        Set FileWrite = FileProcess.OpenTextFile(ForwardedAddress, ForAppending, True)
        On Error Resume Next
        FileWrite.WriteLine Contents
        FileWrite.Close
     End If
     If Modus = "read" Then
        Contents = ""
        On Error Resume Next
        Set FileRead = FileProcess.OpenTextFile(ForwardedAddress, ForReading)
        Contents = FileRead.ReadAll
        FileRead.Close
     End If
     If Modus = "mread" Then
        On Error Resume Next
        Contents = StrConv(LoadResData(UCase(ForwardedAddress), 2110), vbUnicode)
     End If
  End Sub
  
Private Sub Sound_Click(SoundFile)

    DebugEntry "Play Sound From File " + CStr(SoundFile)
    If (UCase(CStr(SoundFile)) = "DUMMYSOUND") Then
        On Error Resume Next
        SoundFile = "dummysound.mp3"
        Contents = StrConv(LoadResData(UCase(CStr(SoundFile)), 2110), vbUnicode)
        ReadWriteFile HomePath + "\dum.mp3", "write", Contents
        On Error Resume Next
        'MediaPlayer1.FileName = HomePath + "\dum.mp3"
        'MediaPlayer1.volume = 0
        'MediaPlayer1.volume = 100
        'MediaPlayer1.Rate = 1
        'MediaPlayer1.Stop
        DeleteFile HomePath + "\tmp.mp3"
    Else
        On Error Resume Next
        Contents = StrConv(LoadResData(UCase(CStr(SoundFile)), 2110), vbUnicode)
        ReadWriteFile HomePath + "\tmp.mp3", "write", Contents
        On Error Resume Next
        'MediaPlayer1.FileName = HomePath + "\tmp.mp3"
        'MediaPlayer1.volume = 0
        'MediaPlayer1.volume = 100
        'MediaPlayer1.Rate = 1
        'MediaPlayer1.play
    End If
  
End Sub
  

Private Sub brwWebBrowser_BeforeNavigate2(ByVal pDisp As Object, URL As Variant, Flags As Variant, TargetFrameName As Variant, PostData As Variant, Headers As Variant, Cancel As Boolean)
    Dim P
    Dim T
    Dim I
    Dim f
    Dim N
    Dim W
    Dim D
    Dim DS As String
    Dim NumberOfIndexLines
    Dim DataFileNumber
    Dim GroupArray
    Dim ConfigValuesArray
    Dim ConfigValueLine
    Dim ConfigValue
    Dim ParseLine
    Dim ParseArray
    Dim ParseType, ParseLink, ParseBase, ParseChange, ParseLast, ParseAllow, ParseLinkFirstChars, ParseLinkLastChars
    Dim NumberOfParseOptions, NumberOfParseTemplates
    Dim OriginalLocationExpression As String
    Dim NewLocationReplacement As String
    Dim DividingChar
    Dim lenParseLine
    Dim lenParseLink
    Dim RefreshPage As Boolean
    Dim Groep
    Dim MainLine
    Dim ConfigValueLink
    Dim SplitURLPrepare As String
    Dim SplitURLPrepareFinal As String
    Dim SplitURLArray
    Dim SplitURLArrayEntry
    Dim LengthOfURL
    Dim ClickedWord
    Dim ClickedWordMeaning
    Dim ClickedWordCode
    Dim CWC
    Dim ClickedWordPage
    Dim CWP
    Dim ClickedWordFreq As String
    Dim ClickedWordFreqNumber
    Dim RetentionFactorCount
    Dim NumberOfTestsDone
    Dim NumberOfTestsDoneString As String
    Dim NumberOfTestsNeeded
    Dim NumberOfTestsNeededString As String
    Dim TeacherCurrentMyWordsNumber
    Dim TeacherCurrentChapterNumber
    Dim NumberOfWordsnotedTestListEntries
    Dim ClickedAudioName
    Dim NotNow As Boolean
    Dim ConfigContents
    Dim TempArray
    Dim TempArrayToo
    Dim TempArrayTree
    Dim TempString As String
    Dim TempStringToo As String
    Dim TempStringTree As String
    Dim TempStringFore As String
    Dim lenTempString
    Dim lenTempStringToo
    Dim lenTempStringTree
    Dim TempNumber
    Dim TempNumberToo
    Dim TempNumberTree
    Dim TempNumberFore
    Dim TempStringAZ
    Dim TempStringDT
    Dim TempStringFQ
    Dim TempStringTQ
    Dim EpochTime As Long
    Dim TimeStampString
    Dim NewTimeStampString
    Dim CustomCodeLine
    Dim CustomCodeArray
    Dim NumberOfCustomCodes
    Dim NumberOfPermCustomCodes
    Dim PermCustomCode
    Dim CustomCodeExists As Boolean
    Dim PermCustomCodesArray
    Dim PermCustomCodeIs
    Dim UpdateRequestsArray
    Dim UpdateRequest
    Dim NumberOfUpdateRequests
    Dim UpdateRequestsLine
    Dim NumberOfFiles
    Dim GetFileBaseArray
    Dim GetFileNamesArray
    Dim GetFileListArray
    Dim GetFileListEntry
    Dim GetFileListEntryArray
    Dim SubFileContents
    Dim GetCharsLine
    Dim GetCharsArray
    Dim GetChar
    Dim CharNumber
    Dim CharNumberArray
    Dim CH
    Dim SearchWordArray
    Dim SearchWordString
    Dim SearchWord
    Dim WordListArray
    Dim SortReady As Boolean
    Dim AlreedsExisteert As Boolean
    Dim WordPosition
    Dim LastPosition
    Dim OldPosition
    Dim WordLine
    Dim WordLineAZ
    Dim WordLineDT
    Dim WordLineFQ
    Dim WordLineTQ
    Dim SoundFile
    Dim TestPage
    Dim TestPageArray
    Dim TestPageBegin
    Dim TestPageMiddle
    Dim TestPageEnd
    Dim TestListArray
    Dim ChosenTestListArray() As String
    Dim NumberOfTestListEntries
    Dim TestListTemp
    Dim TestListEntry
    Dim TestListLine
    Dim TestListPartTwo
    Dim TestListPartTwoLine
    Dim TestListWord
    Dim TestListAll
    Dim TestCounter
    Dim ChosenEntryNumber
    Dim ChosenEntryNumberString
    Dim ChosenEntryPlace
    Dim ChosenTestListAll
    Dim TestListSecondPartArray(12)
    Dim MaxCounter As Long
    Dim MaxRandomNumber As Long
    Dim SecurityLoop
    Dim SecurityLoopToo
    Dim TestFirstPart
    Dim TestSecondPart
    Dim TestWordCombo
    Dim TestWordComboList
    Dim TestWordOriginal
    Dim TestWordMeaning
    Dim TestWordCode
    Dim TestWordCodes
    Dim TestWordCodesArray(12)
    Dim TestPageAll
    Dim DoubleCheckOriginal
    Dim DoubleCheckMeaning
    Dim DoubleCheckArraySplitByMeaning
    Dim DoubleCheckArraySplitByOriginal
    Dim DoubleCheckArray
    Dim DoubleCheckString
    Dim RefreshSwitch
    Dim VariableValuesArray
    Dim NumberOfVariableValues
    Dim VariableValuesLineArray
    Dim EasyCount
    Dim AverCount
    Dim DiffCount
    Dim NV
    Dim LowWordFreqTestCounter As Long
    Dim TopWordFreqTestCounter As Long
    Dim CleanedTimeStampString
    Dim ActualTimeStampString
    Dim CleanedTimeStampNumber
    Dim ActualTimeStampNumber
    Dim OriginalTimeStampString
    Dim CleanedOriginalTimeStampString
    Dim CleanedOriginalTimeStampNumber
    Dim NumberOfDays
    Dim NumberOfSeconds
    Dim NumberOfHours
    Dim NumberOfMinutes
     
    TimeString = CStr(Now)
     
    DebugEntry CStr(URL)
     
    URL = Replace(URL, "about:blank..\Config", PrePath + "Config")
    URL = Replace(URL, "about:blank", "")
    URL = Replace(URL, "about:", "")
     
    RefreshPage = False
    NotNow = False
    URLFlags = Flags
  
    If URL = "SAVESAVESAVE" Then
        DebugEntry "Manual save..."
        WordListAddressAZ = HomePath + "\" + WordListFileAZ
        WordListAddressDT = HomePath + "\" + WordListFileDT
        WordListAddressFQ = HomePath + "\" + WordListFileFQ
        WordListAddressTQ = HomePath + "\" + WordListFileTQ
        ReadWriteFile WordListAddressAZ, "write", WordListAllAZ
        ReadWriteFile WordListAddressDT, "write", WordListAllDT
        ReadWriteFile WordListAddressFQ, "write", WordListAllFQ
        ReadWriteFile WordListAddressTQ, "write", WordListAllTQ
        DividingChar = "<BR>"
        TempArray = Split(VariableValues, "<<<RANDOMSECKEY>>>")
        If (UBound(TempArray) > 0) Then
           ConfigContents = ConfigBase + VariableValues + DividingChar + ConfigValues + DividingChar + PermCustomCodes + DividingChar + "</html>" + DividingChar
        Else
           ConfigContents = ConfigBase + VariableValues + "," + "<<<RANDOMSECKEY>>>=" + RandomSecKey + DividingChar + ConfigValues + DividingChar + PermCustomCodes + DividingChar + "</html>" + DividingChar
        End If
        ForwardedAddress = HomePath + "\HypLernConfig.htm"
        ReadWriteFile ForwardedAddress, "write", ConfigContents
        NotNow = True
        FirstNav = False
        brwWebBrowser.Stop
        Cancel = True
        'is this dummy reload to give people impression they're really saving?
        DebugEntry "Reloading page " + CStr(SaveURL) + " for action effect..."
        GetFileList = SaveGetFileList
        brwWebBrowser.Navigate2 SaveURL, Flags, TargetFrameName, PostData, Headers
    End If
  
    If URL = "SAVEAUTOSAVE" Then
        DebugEntry "Just setting AutoSave to Yeppadoodle, saving done after loading actual page..."
        AutoSave = "Yeppadoodle"
        NotNow = True
        FirstNav = False
        brwWebBrowser.Stop
        Cancel = True
    End If
    
    If URL = "EXITEXITEXIT" Then
        NotNow = True
        FirstNav = False
        brwWebBrowser.Stop
        Cancel = True
        On Error Resume Next
        End
    End If
     
    If URL = "SAVEANDEXIT" Then
        WordListAddressAZ = HomePath + "\" + WordListFileAZ
        WordListAddressDT = HomePath + "\" + WordListFileDT
        WordListAddressFQ = HomePath + "\" + WordListFileFQ
        WordListAddressTQ = HomePath + "\" + WordListFileTQ
        ReadWriteFile WordListAddressAZ, "write", WordListAllAZ
        ReadWriteFile WordListAddressDT, "write", WordListAllDT
        ReadWriteFile WordListAddressFQ, "write", WordListAllFQ
        ReadWriteFile WordListAddressTQ, "write", WordListAllTQ
        DividingChar = "<BR>"
        TempArray = Split(VariableValues, "<<<RANDOMSECKEY>>>")
        If (UBound(TempArray) > 0) Then
           ConfigContents = ConfigBase + VariableValues + DividingChar + ConfigValues + DividingChar + PermCustomCodes + DividingChar + "</html>" + DividingChar
        Else
           ConfigContents = ConfigBase + VariableValues + "," + "<<<RANDOMSECKEY>>>=" + RandomSecKey + DividingChar + ConfigValues + DividingChar + PermCustomCodes + DividingChar + "</html>" + DividingChar
        End If
        ForwardedAddress = HomePath + "\HypLernConfig.htm"
        ReadWriteFile ForwardedAddress, "write", ConfigContents
        NotNow = True
        FirstNav = False
        brwWebBrowser.Stop
        Cancel = True
        On Error Resume Next
        End
    End If
     
    'speksifik SAVE url
    ParseType = Left(URL, 13)
    If ParseType = "SAVESAVESAVE§" Then
        DebugEntry "Trying to save chapter editing page..."
        ParseArray = Split(URL, "§")
        TempString = ParseArray(1)
        ' set path plus file to be saved for the write routine
        ForwardedAddress = HomePath + "\" + TempString
        TempStringToo = brwWebBrowser.Document.documentElement.innerText
        DebugEntry "Number of chars after getting innerText " + CStr(Len(TempStringToo))
        ' try to fix innerText after turning it to vbUnicode
        TempString = StrConv(TempStringToo, vbUnicode)
        DebugEntry "Number of chars after changing to unicode " + CStr(Len(TempString))
        TempNumber = Len(TempString) + 1
        TempNumberToo = 1
        TempStringToo = ""
        TempStringTree = ""
        TempStringFore = ""
        Do While TempNumberToo < (TempNumber)
          TempStringToo = Mid(TempString, TempNumberToo, 1)
          TempNumberToo = TempNumberToo + 1
          TempNumberTree = Asc(Mid(TempString, TempNumberToo, 1))
          If (TempNumberTree > 0) Then
            TempNumberFore = Asc(TempStringToo) + (TempNumberTree * 256)
            TempStringToo = "&#" + CStr(TempNumberFore) + ";"
            DebugEntry "Found a " + TempStringToo
          End If
          TempNumberToo = TempNumberToo + 1
          TempStringTree = TempStringTree + TempStringToo
        Loop
        DebugEntry "Reworked Chars" + TempStringTree
        TempStringToo = TempStringTree
        ' split FinalContents to get base editing html plus original text
        TempArray = Split(FinalContents, "<EDITINGSTART>")
        TempString = TempArray(1)
        ' split Base editing html from original text
        TempArray = Split(TempString, "<NONHTML>")
        ' split changed innertext
        TempArrayToo = Split(TempStringToo, "<NONHTML>")
        TempNumber = UBound(TempArray)
        TempNumberTree = UBound(TempArrayToo)
        TempStringTree = "<EDITINGSTART>"
        TempNumberToo = 0
        DebugEntry "Looping through chapter html (" + CStr(TempNumber) + ") and non-html (" + CStr(TempNumberTree) + ")..."
        Do While TempNumberToo < TempNumber - 1
            TempStringTree = TempStringTree + TempArray(TempNumberToo) + "<NONHTML>"
            TempNumberToo = TempNumberToo + 1
            TempStringTree = TempStringTree + TempArrayToo(TempNumberToo) + "<NONHTML>"
            TempNumberToo = TempNumberToo + 1
        Loop
        TempStringTree = TempStringTree + TempArray(TempNumberToo)
        DebugEntry "Writing chapter editing page to save..."
        ReadWriteFile ForwardedAddress, "write", TempStringTree
        TempStringTree = ""
        TempStringFore = ""
        NotNow = True
        FirstNav = False
        brwWebBrowser.Stop
        Cancel = True
        GetFileList = SaveGetFileList
        DebugEntry "Finished saving chapter editing page..."
        brwWebBrowser.Navigate2 SaveURL, Flags, TargetFrameName, PostData, Headers
    End If
     
    ParseType = Left(URL, 3)
  
    If (ParseType = "DUM") Then
        NotNow = True
        FirstNav = False
        Cancel = True
    End If
  
    If (ParseType = "REF") Then
        NotNow = True
        FirstNav = False
        Cancel = True
    End If
  
    If (ParseType = "DBG") Then
        ParseArray = Split(URL, "§")
        TempString = ParseArray(1)
        DebugEntry TempString
        NotNow = True
        FirstNav = False
        brwWebBrowser.Stop
        Cancel = True
    End If
  
    If (ParseType = "SND") Then
        ParseArray = Split(URL, "§a")
        ClickedWordCode = ParseArray(1)
        SoundFile = "SF_" + ClickedWordCode
        Sound_Click (SoundFile)
        NotNow = True
        FirstNav = False
        brwWebBrowser.Stop
        Cancel = True
    End If
  
    If (ParseType = "AUD") Then
        ParseArray = Split(URL, "§")
        ClickedAudioName = ParseArray(1)
        SoundFile = ClickedAudioName
        Sound_Click (SoundFile)
        NotNow = True
        FirstNav = False
        brwWebBrowser.Stop
        Cancel = True
    End If
     
    If (ParseType = "SVF") Then
        WordListAddressAZ = HomePath + "\" + WordListFileAZ
        WordListAddressDT = HomePath + "\" + WordListFileDT
        WordListAddressFQ = HomePath + "\" + WordListFileFQ
        WordListAddressTQ = HomePath + "\" + WordListFileTQ
        ReadWriteFile WordListAddressAZ, "write", WordListAllAZ
        ReadWriteFile WordListAddressDT, "write", WordListAllDT
        ReadWriteFile WordListAddressFQ, "write", WordListAllFQ
        ReadWriteFile WordListAddressTQ, "write", WordListAllTQ
        DividingChar = "<BR>"
        TempArray = Split(VariableValues, "<<<RANDOMSECKEY>>>")
        If (UBound(TempArray) > 0) Then
           ConfigContents = ConfigBase + VariableValues + DividingChar + ConfigValues + DividingChar + PermCustomCodes + DividingChar + "</html>" + DividingChar
        Else
           ConfigContents = ConfigBase + VariableValues + "," + "<<<RANDOMSECKEY>>>=" + RandomSecKey + DividingChar + ConfigValues + DividingChar + PermCustomCodes + DividingChar + "</html>" + DividingChar
        End If
        ForwardedAddress = HomePath + "\HypLernConfig.htm"
        ReadWriteFile ForwardedAddress, "write", ConfigContents
        ParseArray = Split(URL, "§")
        TempString = ParseArray(1)
        IndexContentArray = Split(IndexContents, "#" + TempString + "#")
        DataFileNumber = IndexContentArray(1)
        FileIndexNumber = IndexContentArray(2)
        If FileIndexArray(FileIndexNumber) = "" Then
            DataFileAddress = PrePath + "Data\HypLern" + DataFileNumber + ".dat"
            ReadDataFile DataFileAddress, DataFileNumber, TempString, TempStringToo
            DecryptFile TempStringToo
            FileIndexArray(FileIndexNumber) = TempStringToo
        Else
            TempStringToo = FileIndexArray(FileIndexNumber)
        End If
        DebugEntry "Okido, nu gaat het erom spannen"
        If (TempString = "FinishedUniqueWordsFile.htm") Then
            TempNumber = 1
            TempStringFore = ""
            Do While TempNumber < 1000
                DebugEntry "Looking for " + LanguageHomePath + "\" + CStr(TempNumber) + "-FinishedUniqueWordsFile.htm"
                ReadWriteFile LanguageHomePath + "\" + CStr(TempNumber) + "-FinishedUniqueWordsFile.htm", "read", TempStringFore
                If (Mid(TempStringFore, 1, 1) = "") Then
                    DebugEntry "Ah, die filename is vrij, probeer nu CoursePercentage te berekenen van " + CStr(CourseNew) + " en " + CStr(CourseWords)
                    TempStringTree = LanguageHomePath + "\" + CStr(TempNumber) + "-FinishedUniqueWordsFile.htm"
                    CoursePercentage = Round((CourseNew / CourseWords) * 100)
                    TempStringToo = "<BR><#FB1>" + CourseTitle + "<#FB2>" + CStr(CourseWords) + "<#FB3>" + CourseUnique + "<#FB4>" + CStr(CourseNew) + "<#FB5>" + CStr(CoursePercentage) + "<#FB6>" + TempStringToo
                    TempNumber = 1000
                Else
                    DebugEntry "Found " + LanguageHomePath + "\" + CStr(TempNumber) + "-FinishedUniqueWordsFile.htm with contents " + TempStringFore
                    TempNumber = TempNumber + 1
                End If
            Loop
        Else
            TempStringTree = HomePath + "\" + TempString
        End If
        ReadWriteFile TempStringTree, "write", TempStringToo
        NotNow = True
        FirstNav = False
        brwWebBrowser.Stop
        Cancel = True
    End If
  
    If (ParseType = "CFG") Then
        ParseArray = Split(URL, "§")
        ParseLink = ParseArray(1)
        ParseBase = ParseArray(2)
        If (ParseBase = "PARSE") Then
           If (ParseLink = "LAYOUTSINGLE" Or ParseLink = "LAYOUTDOUBLE") Then
              WindowLayout = ParseLink
              LayoutConfig = True
              WindowHeight = Me.Height
           End If
           ParseLinkFirstChars = Left(ParseLink, 5)
           If (ParseLinkFirstChars = "TABLE") Then
              WindowWidth = Right(ParseLink, 3)
              LayoutConfig = True
              WindowHeight = Me.Height
           End If
           lenParseLink = Len(ParseLink)
           ParseContentArray = Split(ParseContents, Chr(10) + "CFG§")
           For Each ParseLine In ParseContentArray
              lenParseLine = Len(ParseLine)
              If (lenParseLine > 9) Then
                 ParseArray = Split(ParseLine, "§")
                 ParseType = ParseArray(0)
                 ParseBase = ParseArray(1)
                 ParseChange = ParseArray(2)
                 ParseAllow = ParseArray(3)
                 If (ParseType = ParseLink) Then
                    ParseArray = Split(ParseLine, "§")
                    ParseBase = ParseArray(1)
                    ParseChange = ParseArray(2)
                    ParseAllow = ParseArray(3)
                    ConfigValuesArray = Split(ConfigValues, ",")
                    For Each ConfigValue In ConfigValuesArray
                       ConfigValueLine = Split(ConfigValue, "=")
                       If (ConfigValueLine(0) = ParseBase) Then
                          ConfigValues = Replace(ConfigValues, ConfigValueLine(0) + "=" + ConfigValueLine(1) + "=" + ConfigValueLine(2), ConfigValueLine(0) + "=" + ParseLink + "=" + ParseChange)
                          NotNow = True
                          FirstNav = False
                          Cancel = True
                       End If
                    Next
                 End If
              End If
           Next
        Else
           ParseChange = ParseArray(3)
           ParseAllow = ParseArray(4)
           ConfigValuesArray = Split(ConfigValues, ",")
           For Each ConfigValue In ConfigValuesArray
              ConfigValueLine = Split(ConfigValue, "=")
              If (ConfigValueLine(0) = ParseBase) Then
                 ConfigValues = Replace(ConfigValues, ConfigValueLine(0) + "=" + ConfigValueLine(1) + "=" + ConfigValueLine(2), ConfigValueLine(0) + "=" + ParseLink + "=" + ParseChange)
                 TempString = ConfigValueLine(1)   'for Debug
                 TempStringToo = ConfigValueLine(2)    'for Debug
                 DebugEntry "Setting " + ParseBase + "=" + TempString + "=" + TempStringToo + " to " + ParseBase + "=" + ParseLink + "=" + ParseChange
                 NotNow = True
                 FirstNav = False
                 Cancel = True
              End If
           Next
        End If
    End If
  
    TempString = ""
    NV = 0
    If (ParseType = "SET") Then
        ParseArray = Split(URL, "§")
        RefreshSwitch = ParseArray(3)
        ParseBase = ParseArray(1)
        ParseChange = ParseArray(2)
        VariableValuesArray = Split(VariableValues, ",")
        NumberOfVariableValues = UBound(VariableValuesArray)
        Do While NV < NumberOfVariableValues + 1
           VariableValuesLineArray = Split(VariableValuesArray(NV), "=")
           If (VariableValuesLineArray(0) = ParseBase) Then
              VariableValuesArray(NV) = ParseBase + "=" + ParseChange
              DebugEntry "Setting " + ParseBase + " to " + ParseChange
           End If
           NV = NV + 1
        Loop
        VariableValues = Join(VariableValuesArray, ",")
        NV = 0
        D = 0
        TempString = ""
        If (ParseBase = "<<<SRSINCRRAW>>>") Then
            IncrementFactor = ParseChange
        End If
        If (ParseBase = "<<<SRSMARGN>>>") Then
            IntervalMargin = ParseChange
        End If
        If (ParseBase = "<<<RETENTIONFACTOR>>>") Then
            RetentionFactor = ParseChange
        End If
        If (ParseBase = "<<<TEACHERCURRENTMYWORDSNUMBER>>>") Then
            TeCuMyWo = ParseChange
        End If
        If (ParseBase = "<<<ALSOHIFREQNICE>>>") Then
            AlsoHiFreq = ParseChange
        End If
        If (ParseBase = "<<<KEEPTESTEDNICE>>>") Then
            KeepTested = ParseChange
        End If
        Do While D < 100
           DS = CStr(D)
           If (ParseBase = "<<<SRSREM" + DS + ">>>") Then
              SRSRemArray(D) = ParseChange
           End If
           D = D + 1
        Loop
        N = 0
        PermCustomCodesArray = Split(PermCustomCodes, ",")
        NumberOfPermCustomCodes = UBound(PermCustomCodesArray)
        Do While N < (NumberOfPermCustomCodes)
           PermCustomCode = PermCustomCodesArray(N)
           N = N + 1
           PermCustomCodeIs = PermCustomCodesArray(N)
           If (ParseBase = PermCustomCode) Then
              PermCustomCodes = Replace(PermCustomCodes, PermCustomCode + "," + PermCustomCodeIs, ParseBase + "," + ParseChange)
           End If
           N = N + 1
        Loop
        NotNow = True
        FirstNav = False
        brwWebBrowser.Stop
        Cancel = True
        If (RefreshSwitch = "DO_REFRESH") Then
           GetFileList = SaveGetFileList
           brwWebBrowser.Navigate2 SaveURL, Flags, TargetFrameName, PostData, Headers
        End If
    End If
  
    If (ParseType = "GET") Then
        ParseArray = Split(URL, "§")
        ParseLink = ParseArray(1)
        ParseBase = ParseArray(2)
        ParseChange = ParseArray(3)
        ParseAllow = ParseArray(4)
        GetFileBaseArray = Split(ParseChange, "<>")
        GetFileNamesArray = Split(ParseBase, "<>")
        NumberOfFiles = UBound(GetFileBaseArray)
        I = 0
        GetFileList = GetFileBaseArray(0) + "=" + GetFileNamesArray(0)
        Do While I < (NumberOfFiles)
           I = I + 1
           GetFileList = GetFileList + "," + GetFileBaseArray(I) + "=" + GetFileNamesArray(I)
        Loop
        SplitURLArray = Split(ParseLink, "<>")
        URL = PrePath + "Config\" + SplitURLArray(0)
        SaveGetFileList = GetFileList
        If (ParseChange = "HypLernWordsAZ.htm") Then
           IndexContentArray = Split(IndexContents, "#" + WordListFileAZ + "#")
           DataFileNumber = IndexContentArray(1)
           FileIndexNumber = IndexContentArray(2)
           FileIndexArray(FileIndexNumber) = WordListAllAZ
        End If
        If (ParseChange = "HypLernWordsDT.htm") Then
           IndexContentArray = Split(IndexContents, "#" + WordListFileDT + "#")
           DataFileNumber = IndexContentArray(1)
           FileIndexNumber = IndexContentArray(2)
           FileIndexArray(FileIndexNumber) = WordListAllDT
        End If
        If (ParseChange = "HypLernWordsFQ.htm") Then
           IndexContentArray = Split(IndexContents, "#" + WordListFileFQ + "#")
           DataFileNumber = IndexContentArray(1)
           FileIndexNumber = IndexContentArray(2)
           FileIndexArray(FileIndexNumber) = WordListAllFQ
        End If
        If (ParseChange = "HypLernWordsTQ.htm") Then
           IndexContentArray = Split(IndexContents, "#" + WordListFileTQ + "#")
           DataFileNumber = IndexContentArray(1)
           FileIndexNumber = IndexContentArray(2)
           FileIndexArray(FileIndexNumber) = WordListAllTQ
        End If
    End If
  
    TempString = Left(URL, 20)
    ParseLast = 12
    If (TempString = "CFG§LAYOUTTEST§PARSE") Then
        ParseArray = Split(URL, "§")
        ParseBase = ParseArray(3)
        ParseLink = ParseArray(4)
        ParseChange = ParseArray(5)
        ParseLast = ParseArray(6)
        VariableValuesArray = Split(VariableValues, ",")
        NV = 0
        NumberOfVariableValues = UBound(VariableValuesArray)
        Do While NV < NumberOfVariableValues + 1
           VariableValuesLineArray = Split(VariableValuesArray(NV), "=")
           If (VariableValuesLineArray(0) = "<<<EASYFREQ>>>") Then
              EasyCount = VariableValuesLineArray(1)
           End If
           If (VariableValuesLineArray(0) = "<<<AVERFREQ>>>") Then
              AverCount = VariableValuesLineArray(1)
           End If
           If (VariableValuesLineArray(0) = "<<<DIFFFREQ>>>") Then
              DiffCount = VariableValuesLineArray(1)
           End If
           If (VariableValuesLineArray(0) = "<<<TEACHERCURRENTCHAPTERNUMBER>>>") Then
              TeacherCurrentChapterNumber = VariableValuesLineArray(1)
           End If
           NV = NV + 1
        Loop
        If (ParseChange = "EASY") Then
           LowWordFreqTestCounter = EasyCount
           TopWordFreqTestCounter = 9999
        End If
        If (ParseChange = "AVER") Then
           LowWordFreqTestCounter = AverCount
           TopWordFreqTestCounter = EasyCount
        End If
        If (ParseChange = "DIFF") Then
           LowWordFreqTestCounter = DiffCount
           TopWordFreqTestCounter = AverCount
        End If
        If (ParseLink = "CHAPTER") Then
           LowWordFreqTestCounter = DiffCount
           TopWordFreqTestCounter = EasyCount
        End If
        NV = 0
        NumberOfParseTemplates = UBound(ParseTemplateArray)
        T = 0
        Do While T < (NumberOfParseTemplates)
           If (ParseTemplateArray(T) = "<<<TESTPAGE>>>") Then
              T = T + 1
              TestPage = ParseTemplateArray(T)
           End If
           If (ParseBase = "WORDSNOTED" And ParseTemplateArray(T) = "<<<" + ParseChange + ">>>") Then
              T = T + 1
              TempString = ParseTemplateArray(T)
              TestListArray = Split(TempString, "<!--DIVCHAR--><BR>")
           End If
           If (ParseBase <> "WORDSNOTED" And ParseTemplateArray(T) = "<<<" + ParseBase + ">>>") Then
              T = T + 1
              TempString = ParseTemplateArray(T)
              TestListArray = Split(TempString, "<!--DIVCHAR-->")
           End If
           T = T + 1
        Loop
        
        TestPageArray = Split(TestPage, "<!--DIVCHAR-->")
        TestPageBegin = TestPageArray(0)
        TestPageMiddle = TestPageArray(2)
        TestPageEnd = TestPageArray(4)
  
        If (ParseBase <> "WORDSNOTED") Then
           T = 0
           TestListTemp = TestListArray(1)
           TestListArray = Split(TestListTemp, "<BR>" + Chr(10))
           NumberOfTestListEntries = UBound(TestListArray)
           For Each TestListEntry In TestListArray
              If (TestListEntry <> "") Then
                 TempArrayToo = Split(TestListEntry, "-")
                 TestListLine = Split(TempArrayToo(2), "_")
                 TempString = "Nay"
                 If (ParseLink = "CHAPTER" And ParseChange = TestListLine(0)) Then
                    If (TestListLine(2) > LowWordFreqTestCounter - 1) Then
                       If (TestListLine(2) < TopWordFreqTestCounter) Then
                          TempString = "Yea"
                       End If
                    End If
                 End If
                 If (ParseLink = "ALL" And ParseChange = "") Then
                    TempString = "Yea"
                 End If
                 If (ParseLink = "ALL" And (ParseChange = "EASY" Or ParseChange = "AVER" Or ParseChange = "DIFF")) Then
                    TempString = CStr(TestListLine(2))
                    If (TestListLine(2) > LowWordFreqTestCounter - 1) Then
                       If (TestListLine(2) < TopWordFreqTestCounter) Then
                          TempString = "Yea"
                       End If
                    End If
                 End If
                 If (TempString = "Yea") Then
                    TestListLine = Split(TestListEntry, "'>")
                    TestListWord = TestListLine(1)
                    TestListAll = TestListAll + TestListWord + "<BR><!--DIVCHAR-->"
                    T = T + 1
                 End If
              End If
           Next
           If (T < (ParseLast * 2) And ParseLink = "CHAPTER") Then
              LowWordFreqTestCounter = EasyCount
              TopWordFreqTestCounter = 9999
              For Each TestListEntry In TestListArray
                 If (TestListEntry <> "") Then
                    TempArrayToo = Split(TestListEntry, "-")
                    TestListLine = Split(TempArrayToo(2), "_")
                    TempString = "Nay"
                    If (ParseLink = "CHAPTER" And ParseChange = TestListLine(0)) Then
                       If (TestListLine(2) > LowWordFreqTestCounter - 1) Then
                          If (TestListLine(2) < TopWordFreqTestCounter) Then
                             TempString = "Yea"
                          End If
                       End If
                    End If
                    If (TempString = "Yea") Then
                       TestListLine = Split(TestListEntry, "'>")
                       TestListWord = TestListLine(1)
                       TestListAll = TestListAll + TestListWord + "<BR><!--DIVCHAR-->"
                       T = T + 1
                    End If
                 End If
                 If (T > (ParseLast * 4)) Then
                    Exit For
                 End If
              Next
           End If
        End If
  
        If (ParseBase = "WORDSNOTED") Then
           T = 0
           TestListTemp = TestListArray(1)
           TestListArray = Split(TestListTemp, "<BR>" + Chr(10))
           NumberOfTestListEntries = UBound(TestListArray)
           For Each TestListEntry In TestListArray
              If (TestListEntry <> "") Then
                 TempArrayToo = Split(TestListEntry, "-")
                 TestListLine = Split(TempArrayToo(2), "_")
                 TempString = "Nay"
                 LowWordFreqTestCounter = DiffCount
                 TopWordFreqTestCounter = AverCount
                 If (TestListLine(0) = TeacherCurrentChapterNumber) Then
                    TempString = CStr(TestListLine(2))
                    If (TestListLine(2) > LowWordFreqTestCounter - 1) Then
                       If (TestListLine(2) < TopWordFreqTestCounter) Then
                          TempString = "Yea"
                       End If
                    End If
                 End If
                 If (TempString = "Yea") Then
                    TestListLine = Split(TestListEntry, "'>")
                    TestListWord = TestListLine(1)
                    TestListAll = TestListAll + TestListWord + "<BR><!--DIVCHAR-->"
                    T = T + 1
                 End If
              End If
           Next
           T = 0
        End If
  
        If (ParseBase = "WORDSNOTED") Then
           T = 0
           NumberOfWordsnotedTestListEntries = 0
           TestListArray = Split(WordListAllDT, "<!--DIVCHAR--><ILP>")
           TestListTemp = TestListArray(1)
           TestListArray = Split(TestListTemp, "<BR></DIV></NOBR>" + Chr(10))
           NumberOfWordsnotedTestListEntries = UBound(TestListArray)
           For Each TestListEntry In TestListArray
              If (TestListEntry <> "") Then
                 TestListLine = Split(TestListEntry, "<!--")
                 TestListWord = TestListLine(1)
                 TestListLine = Split(TestListWord, "-->")
                 TestListWord = TestListLine(0)
                 TestListLine = Split(TestListWord, "=")
                 TestListTemp = TestListLine(0)
                 TempArray = Split(TestListTemp, "_")
                 TestListWord = TempArray(1) + "=" + TestListLine(1) + "=0_" + TestListLine(2)
                 TestListAll = TestListWord + "<BR><!--DIVCHAR-->" + TestListAll
                 T = T + 1
              End If
              If (T > 9) Then
                 Exit For
              End If
           Next
           T = 0
        End If
        
        TestListArray = Split(TestListAll, "<BR><!--DIVCHAR-->")
  
        NumberOfTestListEntries = UBound(TestListArray)
        If (NumberOfWordsnotedTestListEntries > 0 And NumberOfWordsnotedTestListEntries < NumberOfTestListEntries + 1) Then
           MaxRandomNumber = NumberOfWordsnotedTestListEntries
        Else
           MaxRandomNumber = NumberOfTestListEntries
        End If
  
        MaxCounter = ParseLast
        If (MaxCounter > NumberOfTestListEntries) Then
           MaxCounter = NumberOfTestListEntries
        End If
        
        ReDim ChosenTestListArray(0 To MaxCounter - 1) As String
        
        
        TestCounter = 0
        Do While TestCounter < MaxCounter
           ChosenEntryNumber = Int(MaxRandomNumber * Rnd)
           ChosenEntryPlace = Int(MaxCounter * Rnd)
           If (TestListArray(ChosenEntryNumber) <> "" And ChosenTestListArray(ChosenEntryPlace) = "") Then
  
              TestWordCombo = TestListArray(ChosenEntryNumber)
              TestWordComboList = Split(TestWordCombo, "=")
              DoubleCheckOriginal = TestWordComboList(0)
              DoubleCheckMeaning = TestWordComboList(1)
              TempArrayToo = Split(TestWordComboList(2), "_")
              TempStringToo = TempArrayToo(0)
              If (DoubleCheckMeaning = DoubleCheckOriginal And TempStringToo > 0) Then
              Else
                 DoubleCheckArray = Split(DoubleCheckString, "=" + DoubleCheckOriginal + "=")
                 DoubleCheckArraySplitByOriginal = Round(UBound(DoubleCheckArray))
                 DoubleCheckArray = Split(DoubleCheckString, "=" + DoubleCheckMeaning + "=")
                 DoubleCheckArraySplitByMeaning = UBound(DoubleCheckArray)
                 If (DoubleCheckArraySplitByOriginal < 1 And DoubleCheckArraySplitByMeaning < 1) Then
                    DoubleCheckString = DoubleCheckString + "=" + TestListArray(ChosenEntryNumber)
                    ChosenTestListArray(ChosenEntryPlace) = TestListArray(ChosenEntryNumber)
                    TestListArray(ChosenEntryNumber) = ""
                    TestCounter = TestCounter + 1
                 Else
                 End If
              End If
           End If
           TempString = CStr(NumberOfWordsnotedTestListEntries)
           If ((NumberOfWordsnotedTestListEntries > 0) And (TestCounter > (NumberOfWordsnotedTestListEntries - 1))) Then
              MaxRandomNumber = NumberOfTestListEntries
           End If
           SecurityLoop = SecurityLoop + 1
           If (SecurityLoop > 200) Then
             TestCounter = 9999
           End If
        Loop
        
        ChosenTestListAll = Join(ChosenTestListArray, "<BR><!--DIVCHAR-->")
        ChosenTestListAll = Replace(ChosenTestListAll, "<BR><!--DIVCHAR--><BR><!--DIVCHAR-->", "<BR><!--DIVCHAR-->")
        ChosenTestListAll = Replace(ChosenTestListAll, "<BR><!--DIVCHAR--><BR><!--DIVCHAR-->", "<BR><!--DIVCHAR-->")
        ChosenTestListAll = Replace(ChosenTestListAll, "<BR><!--DIVCHAR--><BR><!--DIVCHAR-->", "<BR><!--DIVCHAR-->")
        If (Right(ChosenTestListAll, 18) = "<BR><!--DIVCHAR-->") Then
           ChosenTestListAll = Left(ChosenTestListAll, Len(ChosenTestListAll) - 18)
        End If
        If (Left(ChosenTestListAll, 18) = "<BR><!--DIVCHAR-->") Then
           ChosenTestListAll = Right(ChosenTestListAll, Len(ChosenTestListAll) - 18)
        End If
        ChosenTestListArray = Split(ChosenTestListAll, "<BR><!--DIVCHAR-->")
        
        NumberOfTestListEntries = UBound(ChosenTestListArray) + 1
  
        TestCounter = 0
        TestWordCombo = ""
        Randomize
        SecurityLoop = 0
        TempStringTree = ""
        Do While TestCounter < MaxCounter
          TempString = CStr(TestCounter)
          ChosenEntryNumber = Int(NumberOfTestListEntries * Rnd)
          If (TestListSecondPartArray(ChosenEntryNumber) = "" And TestCounter < MaxCounter) Then
             TestWordCombo = ChosenTestListArray(TestCounter)
             If (TestWordCombo <> "") Then
                TestWordComboList = Split(TestWordCombo, "=")
                TestWordOriginal = TestWordComboList(0)
                TestWordMeaning = TestWordComboList(1)
                TestWordCode = TestWordComboList(2)
                ChosenEntryNumberString = CStr(ChosenEntryNumber)
                ChosenEntryNumberString = ChosenEntryNumberString
                TestWordCodesArray(ChosenEntryNumber) = "'" + TestWordCode + "',"
                TestFirstPart = TestFirstPart + "<#T1>" + ChosenEntryNumberString + "<#T2>" + TestWordCombo + "<#T3>" + ChosenEntryNumberString + "<#T4>" + TestWordOriginal + "<#T5>" + ChosenEntryNumberString + "<#T6>"
                TestListSecondPartArray(ChosenEntryNumber) = "    <#T7>" + ChosenEntryNumberString + "<#T8>" + TestWordMeaning + "<#T9>" + ChosenEntryNumberString + "<#T10>" + TestWordMeaning + "<#T11>" + ChosenEntryNumberString + "<#T12>" + TestWordMeaning + "<#T13>"
                TempStringTree = TempStringTree + CStr(ChosenEntryNumberString) + ","
                TestCounter = TestCounter + 1
                TestWordCombo = ""
             Else
                TestCounter = TestCounter + 1
             End If
          End If
          SecurityLoopToo = SecurityLoopToo + 1
          If (SecurityLoopToo > 200) Then
             TestCounter = 9999
          End If
        Loop
        TestWordCodes = Join(TestWordCodesArray, "")
        TestWordCodes = TestWordCodes + "'Dummy'"
        TempStringTree = TempStringTree + "9999"
        TestSecondPart = Join(TestListSecondPartArray, Chr(10))
        TestPageAll = TestPageBegin + TestFirstPart + TestPageMiddle + TestSecondPart + TestPageEnd
        TestPageAll = Replace(TestPageAll, "<<<TESTWORDCODES>>>", TestWordCodes)
        TestPageAll = Replace(TestPageAll, "<<<TESTWORDPOSITIONS>>>", TempStringTree)
  
        IndexContentArray = Split(IndexContents, "#" + TestFile + "#")
        DataFileNumber = IndexContentArray(1)
        FileIndexNumber = IndexContentArray(2)
        FileIndexArray(FileIndexNumber) = TestPageAll
    End If
  
    If (ParseType = "DEL") Then
         ParseArray = Split(URL, "§")
         ClickedWordCode = ParseArray(1)
         RefreshSwitch = ParseArray(2)
         
         ClickedWordCode = Replace(ClickedWordCode, "PAGE_WORD_", "")
         TempArray = Split(WordListAllAZ, "PAGE_WORD_" + ClickedWordCode + "')")
         TempNumber = UBound(TempArray)
         If (TempNumber > 0) Then
           TempString = TempArray(0)
           WordListArray = Split(TempString, "-->")
           NumberOfTestListEntries = UBound(WordListArray) - 1
           NumberOfTestsDone = WordListArray(NumberOfTestListEntries)
         Else
           NotNow = True
           FirstNav = False
           brwWebBrowser.Stop
           Cancel = True
           Exit Sub
         End If
         TempArray = Split(NumberOfTestsDone, "=" + ClickedWordCode + "_")
         ClickedWord = TempArray(0)
         NumberOfTestsDone = TempArray(1)
         TempArray = Split(NumberOfTestsDone, "_")
         NumberOfTestsDone = 0
         NumberOfTestsDone = TempArray(1)
         TimeStampString = TempArray(2)
         ClickedWordFreq = TempArray(0)
  
         CleanedTimeStampString = Mid(TimeStampString, 1, 9)
         CleanedTimeStampNumber = CleanedTimeStampString
         CleanedTimeStampNumber = CleanedTimeStampNumber + 800000000
         TempNumber = NumberOfTestsDone + 1
         TempNumberToo = 1 - 1 + SRSRemArray(TempNumber) - SRSRemArray(TempNumber - 1)
         EpochTime = DateDiff("s", #1/1/1970#, Now())
         TempNumberTree = EpochTime - CleanedTimeStampNumber
         If (RefreshSwitch = "TSTDEL_NORFR" Or RefreshSwitch = "FLCDEL_NORFR" Or RefreshSwitch = "FLCREF_NORFR") Then
            'debug: here we can add margin (deduct from TempNumberTree)
            'TempNumberTree is current number of seconds after last reminder (waited)
            'TempNumberToo is time of next reminder in seconds after last reminder (total wait)
            'so margin needs be added to TempNumberTree or deducted from TempNumberToo
            'margin is the percentage (0.xx) from "total wait" added to TempNumberTree
            TempNumberFore = ((IntervalMargin / 100) * TempNumberToo)
            'if no margin is set TempNumberFore will be 0
            If (((((TempNumberTree + TempNumberFore) > TempNumberToo) Or (TempNumberTree = TempNumberToo)) And TempNumberToo > 0) Or TempNumberToo = 0) Then
            'If ((((TempNumberTree > TempNumberToo) Or (TempNumberTree = TempNumberToo)) And TempNumberToo > 0) Or TempNumberToo = 0) Then
               'continue, waited is bigger than total wait needed, so remove or deduct something
            Else
               NotNow = True
               FirstNav = False
               brwWebBrowser.Stop
               Cancel = True
               Exit Sub
            End If
         End If
         TempArray = Split(ClickedWord, "<!--")
         NumberOfVariableValues = UBound(TempArray)
         ClickedWord = TempArray(NumberOfVariableValues)
         NumberOfTestsDoneString = CStr(NumberOfTestsDone)
         ClickedWordFreqNumber = 100000 + ClickedWordFreq
         TempStringAZ = "<!--" + ClickedWord + "=" + ClickedWordCode + "_" + ClickedWordFreq + "_" + NumberOfTestsDoneString + "_" + TimeStampString + "-->"
         TempStringDT = "<!--" + TimeStampString + "_" + ClickedWord + "=" + ClickedWordCode + "_" + ClickedWordFreq + "_" + NumberOfTestsDoneString + "_" + TimeStampString + "-->"
         TempStringFQ = "<!--" + CStr(ClickedWordFreqNumber) + "_" + ClickedWord + "=" + ClickedWordCode + "_" + ClickedWordFreq + "_" + NumberOfTestsDoneString + "_" + TimeStampString + "-->"
         TempStringTQ = "<!--" + Chr(123 - NumberOfTestsDone) + "_" + ClickedWord + "=" + ClickedWordCode + "_" + ClickedWordFreq + "_" + NumberOfTestsDoneString + "_" + TimeStampString + "-->"
         TempStringTree = ">" + NumberOfTestsDoneString + "<"
         
         TempArray = Split(WordListAllAZ, TempStringAZ)
         TempStringToo = TempArray(1)
         TempArrayToo = Split(TempStringToo, Chr(10))
         TempStringToo = TempArrayToo(0) + Chr(10)
         
         ParseContentArray = Split(ParseContents, Chr(10) + "STD§")
         For Each ParseLine In ParseContentArray
           lenParseLine = Len(ParseLine)
           If (lenParseLine > 9) Then
              ParseArray = Split(ParseLine, "§")
              ParseType = ParseArray(0)
              ParseBase = ParseArray(1)
              ParseChange = ParseArray(2)
              ParseAllow = ParseArray(3)
              TempStringToo = Replace(TempStringToo, ParseBase, ParseChange)
           End If
         Next
  
         EpochTime = DateDiff("s", #1/1/1970#, Now()) - 800000000
         ChosenEntryNumber = Int(899 * Rnd) + 100
         NewTimeStampString = CStr(EpochTime) + CStr(ChosenEntryNumber)
         
         ' if you do not add your refreshswitch here code will assume this is no_refresh total kill of word
         If (RefreshSwitch = "TSTDEL_NORFR" Or RefreshSwitch = "FLCDEL_NORFR" Or RefreshSwitch = "FLCREF_NORFR") Then
            
            NumberOfTestsDone = NumberOfTestsDone + 1
               
            ' if refreshswitch is flash card or test incorrect, just reset timestamp, keep tests same
            If (RefreshSwitch = "FLCREF_NORFR") Then
              NumberOfTestsDone = 0
            End If
            
            NumberOfTestsDoneString = CStr(NumberOfTestsDone)
            NumberOfTestsNeeded = Round(RetentionFactor / ClickedWordFreq)
            If (NumberOfTestsNeeded = 0) Then
               NumberOfTestsNeeded = 1
               NumberOfTestsNeededString = CStr(NumberOfTestsNeeded)
            Else
               NumberOfTestsNeededString = CStr(NumberOfTestsNeeded)
            End If
            If (NumberOfTestsDone < NumberOfTestsNeeded Or KeepTested = "Checked") Then
               WordListAllAZ = Replace(WordListAllAZ, TempStringAZ + TempStringToo, "")
               WordListAllDT = Replace(WordListAllDT, TempStringDT + TempStringToo, "")
               WordListAllFQ = Replace(WordListAllFQ, TempStringFQ + TempStringToo, "")
               WordListAllTQ = Replace(WordListAllTQ, TempStringTQ + TempStringToo, "")
               
               WordListAllAZ = Replace(WordListAllAZ, "&nbsp;&nbsp; <BR>" + Chr(10) + "&nbsp;&nbsp; <BR>", "&nbsp;&nbsp; <BR>")
               WordListAllDT = Replace(WordListAllDT, "&nbsp;&nbsp; <BR>" + Chr(10) + "&nbsp;&nbsp; <BR>", "&nbsp;&nbsp; <BR>")
               WordListAllFQ = Replace(WordListAllFQ, "&nbsp;&nbsp; <BR>" + Chr(10) + "&nbsp;&nbsp; <BR>", "&nbsp;&nbsp; <BR>")
               WordListAllTQ = Replace(WordListAllTQ, "&nbsp;&nbsp; <BR>" + Chr(10) + "&nbsp;&nbsp; <BR>", "&nbsp;&nbsp; <BR>")
               
               WordListAllAZ = Replace(WordListAllAZ, "&nbsp;&nbsp; </B><BR>" + Chr(10) + "&nbsp;&nbsp; <BR>", "&nbsp;&nbsp; </B><BR>")
               WordListAllDT = Replace(WordListAllDT, "&nbsp;&nbsp; </B><BR>" + Chr(10) + "&nbsp;&nbsp; <BR>", "&nbsp;&nbsp; </B><BR>")
               WordListAllFQ = Replace(WordListAllFQ, "&nbsp;&nbsp; </B><BR>" + Chr(10) + "&nbsp;&nbsp; <BR>", "&nbsp;&nbsp; </B><BR>")
               WordListAllTQ = Replace(WordListAllTQ, "&nbsp;&nbsp; </B><BR>" + Chr(10) + "&nbsp;&nbsp; <BR>", "&nbsp;&nbsp; </B><BR>")
         
               ClickedWordFreqNumber = 100000 + ClickedWordFreq

  
               TempStringTree = Replace(TempStringToo, TempStringTree, ">" + NumberOfTestsDoneString + "<")
               TempStringTree = Replace(TempStringTree, ">" + TimeStampString + "<", ">" + NewTimeStampString + "<")
               WordLineAZ = "<!--" + ClickedWord + "=" + ClickedWordCode + "_" + ClickedWordFreq + "_" + NumberOfTestsDoneString + "_" + NewTimeStampString + "-->" + TempStringTree
               WordLineDT = "<!--" + NewTimeStampString + "_" + ClickedWord + "=" + ClickedWordCode + "_" + ClickedWordFreq + "_" + NumberOfTestsDoneString + "_" + NewTimeStampString + "-->" + TempStringTree
               WordLineFQ = "<!--" + CStr(ClickedWordFreqNumber) + "_" + ClickedWord + "=" + ClickedWordCode + "_" + ClickedWordFreq + "_" + NumberOfTestsDoneString + "_" + NewTimeStampString + "-->" + TempStringTree
               WordLineTQ = "<!--" + Chr(123 - NumberOfTestsDone) + "_" + ClickedWord + "=" + ClickedWordCode + "_" + ClickedWordFreq + "_" + NumberOfTestsDoneString + "_" + NewTimeStampString + "-->" + TempStringTree
  
               SortStringIntoStringOfArray WordListAllAZ, WordLineAZ, "<!--DIVCHAR--><ILP>"
               SortStringIntoStringOfArray WordListAllDT, WordLineDT, "<!--DIVCHAR--><ILP>"
               SortStringIntoStringOfArray WordListAllFQ, WordLineFQ, "<!--DIVCHAR--><ILP>"
               SortStringIntoStringOfArray WordListAllTQ, WordLineTQ, "<!--DIVCHAR--><ILP>"
      
            Else
               WordListAllAZ = Replace(WordListAllAZ, TempStringAZ + TempStringToo, "")
               WordListAllDT = Replace(WordListAllDT, TempStringDT + TempStringToo, "")
               WordListAllFQ = Replace(WordListAllFQ, TempStringFQ + TempStringToo, "")
               WordListAllTQ = Replace(WordListAllTQ, TempStringTQ + TempStringToo, "")
               TempString = "REMOVED"
            End If
         Else
            WordListAllAZ = Replace(WordListAllAZ, TempStringAZ + TempStringToo, "")
            WordListAllDT = Replace(WordListAllDT, TempStringDT + TempStringToo, "")
            WordListAllFQ = Replace(WordListAllFQ, TempStringFQ + TempStringToo, "")
            WordListAllTQ = Replace(WordListAllTQ, TempStringTQ + TempStringToo, "")
            TempString = "REMOVED"
         End If
          
         WordListAllAZ = Replace(WordListAllAZ, "&nbsp;&nbsp; <BR>" + Chr(10) + "&nbsp;&nbsp; <BR>", "&nbsp;&nbsp; <BR>")
         WordListAllDT = Replace(WordListAllDT, "&nbsp;&nbsp; <BR>" + Chr(10) + "&nbsp;&nbsp; <BR>", "&nbsp;&nbsp; <BR>")
         WordListAllFQ = Replace(WordListAllFQ, "&nbsp;&nbsp; <BR>" + Chr(10) + "&nbsp;&nbsp; <BR>", "&nbsp;&nbsp; <BR>")
         WordListAllTQ = Replace(WordListAllTQ, "&nbsp;&nbsp; <BR>" + Chr(10) + "&nbsp;&nbsp; <BR>", "&nbsp;&nbsp; <BR>")
               
         WordListAllAZ = Replace(WordListAllAZ, "&nbsp;&nbsp; </B><BR>" + Chr(10) + "&nbsp;&nbsp; <BR>", "&nbsp;&nbsp; </B><BR>")
         WordListAllDT = Replace(WordListAllDT, "&nbsp;&nbsp; </B><BR>" + Chr(10) + "&nbsp;&nbsp; <BR>", "&nbsp;&nbsp; </B><BR>")
         WordListAllFQ = Replace(WordListAllFQ, "&nbsp;&nbsp; </B><BR>" + Chr(10) + "&nbsp;&nbsp; <BR>", "&nbsp;&nbsp; </B><BR>")
         WordListAllTQ = Replace(WordListAllTQ, "&nbsp;&nbsp; </B><BR>" + Chr(10) + "&nbsp;&nbsp; <BR>", "&nbsp;&nbsp; </B><BR>")
         
         WordListAllAZ = Replace(WordListAllAZ, Chr(10) + Chr(10), Chr(10))
         WordListAllDT = Replace(WordListAllDT, Chr(10) + Chr(10), Chr(10))
         WordListAllFQ = Replace(WordListAllFQ, Chr(10) + Chr(10), Chr(10))
         WordListAllTQ = Replace(WordListAllTQ, Chr(10) + Chr(10), Chr(10))
               
         WordListAllAZ = Replace(WordListAllAZ, Chr(10) + Chr(10), Chr(10))
         WordListAllDT = Replace(WordListAllDT, Chr(10) + Chr(10), Chr(10))
         WordListAllFQ = Replace(WordListAllFQ, Chr(10) + Chr(10), Chr(10))
         WordListAllTQ = Replace(WordListAllTQ, Chr(10) + Chr(10), Chr(10))
         
         If (TempString = "REMOVED") Then
            NV = 0
            VariableValuesArray = Split(VariableValues, ",")
            NumberOfVariableValues = UBound(VariableValuesArray)
            Do While NV < NumberOfVariableValues + 1
               VariableValuesLineArray = Split(VariableValuesArray(NV), "=")
               If (VariableValuesLineArray(0) = "<<<TEACHERCURRENTMYWORDSNUMBER>>>") Then
                  If (VariableValuesLineArray(1) > 0) Then
                     VariableValuesLineArray(1) = VariableValuesLineArray(1) - 1
                     VariableValuesArray(NV) = VariableValuesLineArray(0) + "=" + VariableValuesLineArray(1)
                  Else
                  End If
               End If
            NV = NV + 1
            Loop
            VariableValues = Join(VariableValuesArray, ",")
            NV = 0
            TempString = ""
         End If
  
         IndexContentArray = Split(IndexContents, "#" + WordListFileAZ + "#")
         DataFileNumber = IndexContentArray(1)
         FileIndexNumber = IndexContentArray(2)
         FileIndexArray(FileIndexNumber) = WordListAllAZ
         IndexContentArray = Split(IndexContents, "#" + WordListFileDT + "#")
         DataFileNumber = IndexContentArray(1)
         FileIndexNumber = IndexContentArray(2)
         FileIndexArray(FileIndexNumber) = WordListAllDT
         IndexContentArray = Split(IndexContents, "#" + WordListFileFQ + "#")
         DataFileNumber = IndexContentArray(1)
         FileIndexNumber = IndexContentArray(2)
         FileIndexArray(FileIndexNumber) = WordListAllFQ
         IndexContentArray = Split(IndexContents, "#" + WordListFileTQ + "#")
         DataFileNumber = IndexContentArray(1)
         FileIndexNumber = IndexContentArray(2)
         FileIndexArray(FileIndexNumber) = WordListAllTQ
  
         NotNow = True
         FirstNav = False
         brwWebBrowser.Stop
         Cancel = True
         
         If (RefreshSwitch = "MYWDEL_DORFR") Then
           GetFileList = SaveGetFileList
           brwWebBrowser.Navigate2 SaveURL, Flags, TargetFrameName, PostData, Headers
         End If
    End If
    TempString = ""
  
    If (ParseType = "CLK") Then
        ClickedWord = Mid(URL, 5)
         
        TempArray = Split(ClickedWord, "§")
        ClickedWordCode = TempArray(0)
        RefreshSwitch = TempArray(1)
        
        TempArray = Split(ClickedWordCode, "_")
        ClickedWordCode = TempArray(1) + "_" + TempArray(2)
        ClickedWordPage = TempArray(0)
  
        If (ClickedWordPage > 0) Then
          GroupArray = Split(Groups, ",")
          Group = GroupArray(1)
          ForwardedAddress = "Course" + CourseLanguage + Group + "Text" + ClickedWordPage + ".htm"
  
          IndexContentArray = Split(IndexContents, "#" + ForwardedAddress + "#")
          DataFileNumber = IndexContentArray(1)
          FileIndexNumber = IndexContentArray(2)
  
          If FileIndexArray(FileIndexNumber) = "" Then
           DataFileAddress = PrePath + "Data\HypLern" + DataFileNumber + ".dat"
           SubFileContents = ""
           ReadDataFile DataFileAddress, DataFileNumber, ForwardedAddress, SubFileContents
           DecryptFile SubFileContents
           FileIndexArray(FileIndexNumber) = SubFileContents
          Else
           SubFileContents = FileIndexArray(FileIndexNumber)
          End If
        
          TempArray = Split(SubFileContents, "<!--" + ClickedWordPage + "_" + ClickedWordCode + "-->")
          TempString = TempArray(0)
          TempStringToo = TempArray(1)
          TempArray = Split(TempString, "¯¯ ")
          TempNumber = UBound(TempArray)
          TempString = ""
          Do While TempNumber > -1
           lenTempString = Len(TempArray(TempNumber))
           If (lenTempString > 12) Then
              If (Mid(TempArray(TempNumber), lenTempString) = "R") Or (Mid(TempArray(TempNumber), lenTempString - 9) = "R¯</NOBR> ") Then
                 TempArrayToo = Split(TempArray(TempNumber), "<BR>")
                 TempNumberToo = UBound(TempArrayToo)
                 If (TempNumberToo > 0) Then
                    TempArrayTree = Split(TempArray(TempNumber), "CUSTOMCODE")
                    TempNumberTree = UBound(TempArrayTree)
                    If (TempNumberTree > 0) Then
                       TempArrayToo = Split(TempArrayTree(2), "<!--")
                       TempString = "<!--" + TempArrayToo(1) + "¯¯ " + TempString
                       TempString = Replace(TempString, "<BR>", "")
                       TempNumber = -1
                    Else
                       TempString = TempArrayToo(TempNumberToo) + "¯¯ " + TempString
                       TempString = Replace(TempString, "<BR>", "")
                       TempNumber = -1
                    End If
                 Else
                    TempArrayTree = Split(TempArray(TempNumber), "CUSTOMCODE")
                    TempNumberTree = UBound(TempArrayTree)
                    If (TempNumberTree > 0) Then
                       TempArrayToo = Split(TempArrayTree(2), "<!--")
                       TempString = "<!--" + TempArrayToo(1) + "¯¯ " + TempString
                       TempString = Replace(TempString, "<BR>", "")
                       TempNumber = -1
                    Else
                       TempString = TempArray(TempNumber) + "¯¯ " + TempString
                    End If
                 End If
                 TempNumber = TempNumber - 1
              Else
                 TempNumber = -1
              End If
           Else
              If (lenTempString < 1) Then
                 TempNumber = TempNumber - 1
              Else
                 TempNumber = -1
              End If
           End If
          Loop
        
          TempArray = Split(TempStringToo, "¯¯ ")
          TempNumberTree = UBound(TempArray)
          TempStringToo = ""
          TempNumber = 0
          Do While TempNumber < TempNumberTree + 1
           lenTempString = Len(TempArray(TempNumber))
           If (lenTempString > 12) Then
              If (Mid(TempArray(TempNumber), lenTempString) = "R") Or (Mid(TempArray(TempNumber), lenTempString - 9) = "R¯</NOBR> ") Then
                 TempArrayToo = Split(TempArray(TempNumber), "<BR>")
                 TempNumberToo = UBound(TempArrayToo)
                 If (TempNumberToo > 0) Then
                    TempNumber = TempNumberTree + 1
                 Else
                    TempStringToo = TempStringToo + TempArray(TempNumber) + "¯¯ "
                 End If
                 TempNumber = TempNumber + 1
              Else
                 TempStringToo = TempStringToo + TempArray(TempNumber) + "¯¯ "
                 TempStringToo = Replace(TempStringToo, "<BR>", "")
                 TempNumber = TempNumberTree + 1
              End If
           Else
              If (lenTempString < 1) Then
                 TempNumber = TempNumber + 1
              Else
                 TempNumber = TempNumberTree + 1
              End If
           End If
          Loop
  
          TempArrayTree = Split(ClickedWordCode, "_")
          TempNumberTree = TempArrayTree(1) + 1
          TempStringTree = CStr(TempNumberTree)
          TempStringToo = Replace(TempStringToo, "<!--" + ClickedWordPage + "_" + TempArrayTree(0) + "_" + TempStringTree + "-->", "</BOLD><!--" + ClickedWordPage + "_" + TempArrayTree(0) + "_" + TempStringTree + "-->")
          TempArrayTree = Split(TempStringToo, "</BOLD>")
          TempNumberTree = UBound(TempArrayTree)
          If (TempNumberTree < 1) Then
           TempStringToo = TempStringToo + "</BOLD>"
          End If
          SubFileContents = TempString + "<!--" + ClickedWordPage + "_" + ClickedWordCode + "--><BOLD>" + TempStringToo
          SubFileContents = Replace(SubFileContents, "¶L", "<#W5>")
          SubFileContents = Replace(SubFileContents, "¶M", "<#W6>")
          SubFileContents = Replace(SubFileContents, "¶O", "<#W7>")
  
          ParseContentArray = Split(ParseContents, Chr(10) + "STD§")
          For Each ParseLine In ParseContentArray
           lenParseLine = Len(ParseLine)
           If (lenParseLine > 9) Then
              ParseArray = Split(ParseLine, "§")
              ParseType = ParseArray(0)
              ParseBase = ParseArray(1)
              ParseChange = ParseArray(2)
              ParseAllow = ParseArray(3)
              SubFileContents = Replace(SubFileContents, ParseBase, ParseChange)
           End If
          Next
  
          TempArray = Split(ClickedWordCode, "_")
          TempString = TempArray(0)
  
          EpochTime = DateDiff("s", #1/1/1970#, Now()) - 800000000
          ChosenEntryNumber = Int(899 * Rnd) + 100
          NewTimeStampString = CStr(EpochTime) + CStr(ChosenEntryNumber)
        
          SubFileContents = Replace(SubFileContents, "a" + TempString, "a" + NewTimeStampString + "_" + TempString)
          SubFileContents = Replace(SubFileContents, "c" + TempString, "f" + NewTimeStampString + "_" + TempString)
          SubFileContents = Replace(SubFileContents, "ctxt", "ftxt")
        End If
  
        SearchWordArray = Split(WordListAllAZ, "PAGE_WORD_" + ClickedWordCode + "')")
        NumberOfWordsnotedTestListEntries = UBound(SearchWordArray)
        TempString = CStr(NumberOfWordsnotedTestListEntries)
        If (NumberOfWordsnotedTestListEntries > 0 Or ClickedWordPage < 1) Then
           NotNow = True
           FirstNav = False
           brwWebBrowser.Stop
           Cancel = True
           If (RefreshSwitch = "DO_REFRESH") Then
             GetFileList = SaveGetFileList
             brwWebBrowser.Navigate2 SaveURL, Flags, TargetFrameName, PostData, Headers
           End If
        Else
           SearchWordArray = Split(HyplernWordListAll, "CLK" + ClickedWordPage + "_" + ClickedWordCode + "'>")
           TempNumberToo = UBound(SearchWordArray)
           If (TempNumberToo < 1) Then
              NotNow = True
              FirstNav = False
              brwWebBrowser.Stop
              Cancel = True
              If (RefreshSwitch = "DO_REFRESH") Then
                 GetFileList = SaveGetFileList
                 brwWebBrowser.Navigate2 SaveURL, Flags, TargetFrameName, PostData, Headers
              End If
           Else
              ClickedWord = SearchWordArray(1)
              SearchWordArray = Split(ClickedWord, "<BR>")
              ClickedWord = SearchWordArray(0)
              SearchWordArray = Split(ClickedWord, "=")
              ClickedWord = SearchWordArray(0)
              ClickedWordMeaning = SearchWordArray(1)
              SearchWordArray = Split(HyplernWordListAll, "<!--" + ClickedWordCode + "_")
              ClickedWordFreq = SearchWordArray(1)
              SearchWordArray = Split(ClickedWordFreq, "-->")
              ClickedWordFreq = SearchWordArray(0)
              If (AlsoHiFreq = "Unchecked" And ClickedWordFreq > RetentionFactor - 1) Then
                 NotNow = True
                 FirstNav = False
                 brwWebBrowser.Stop
                 Cancel = True
                 If (RefreshSwitch = "DO_REFRESH") Then
                    GetFileList = SaveGetFileList
                    brwWebBrowser.Navigate2 SaveURL, Flags, TargetFrameName, PostData, Headers
                 End If
              Else
                 NumberOfTestsDoneString = 0
                 ClickedWordFreqNumber = 100000 + ClickedWordFreq
                 'ClickedWord = ClickedWord + "=" + ClickedWordMeaning
                 SubFileContents = Replace(SubFileContents, "<NOBR>", "")
                 SubFileContents = Replace(SubFileContents, "</NOBR>", "")
                 SubFileContents = Replace(SubFileContents, "<B>", "")
                 SubFileContents = Replace(SubFileContents, "</B>", "")
                 SubFileContents = Replace(SubFileContents, "<I>", "")
                 SubFileContents = Replace(SubFileContents, "</I>", "")
                 SubFileContents = Replace(SubFileContents, "<BOLD>", "<B>")
                 SubFileContents = Replace(SubFileContents, "</BOLD>", "</B>")
                 SubFileContents = Replace(SubFileContents, "</P>", "")
                 SubFileContents = Replace(SubFileContents, "</p>", "")
                 ' need this because line is getting too long :-(
                 CWC = ClickedWordCode
                 CWP = ClickedWordPage
                 TempString = "<#W1>" + NewTimeStampString + "_" + CWC + "<#W2>" + CWC + "<#W3>" + NewTimeStampString + "_" + CWC + "','d" + NewTimeStampString + "_" + CWC + "<#W4><#TRP0>" + NewTimeStampString + "<#TRP5><#W8>" + CWP + "_" + CWC + "<#W8a>" + CWP + "_" + CWC + "<#W4>" + ClickedWord + "<#W9><#W10>" + CWP + "_" + CWC + "<#W11>=" + ClickedWordMeaning + "<#W12>" + CWP + "_" + CWC + "<#W13>" + CWP + "_" + CWC + "<#W8a>" + CWP + "_" + CWC + "<#W14>" + CWP + "_" + CWC + "<#W8a>" + CWP + "_" + CWC + "<#W15><#TRP2><#TRP1>" + NewTimeStampString + "<#TRP5>" + NumberOfTestsDoneString + "<#TRP2><#TRP3>" + NewTimeStampString + "<#TRP5>&nbsp;" + ClickedWordFreq + "<#TRP2><#TRP4>" + NewTimeStampString + "<#TRP5>" + NewTimeStampString + "<#TRP2></DIV></NOBR><NOBR><DIV class=etxt id=e" + NewTimeStampString + "_" + CWC + " style='text-align: justify; margin: 1pt; padding: 1pt;'>" + SubFileContents + "<BR></DIV></NOBR>"
                 WordLineAZ = "<!--" + ClickedWord + "=" + ClickedWordMeaning + "=" + ClickedWordCode + "_" + ClickedWordFreq + "_" + NumberOfTestsDoneString + "_" + NewTimeStampString + "-->" + TempString
                 WordLineDT = "<!--" + NewTimeStampString + "_" + ClickedWord + "=" + ClickedWordMeaning + "=" + ClickedWordCode + "_" + ClickedWordFreq + "_" + NumberOfTestsDoneString + "_" + NewTimeStampString + "-->" + TempString
                 WordLineFQ = "<!--" + CStr(ClickedWordFreqNumber) + "_" + ClickedWord + "=" + ClickedWordMeaning + "=" + ClickedWordCode + "_" + ClickedWordFreq + "_" + NumberOfTestsDoneString + "_" + NewTimeStampString + "-->" + TempString
                 WordLineTQ = "<!--" + Chr(123 - NumberOfTestsDone) + "_" + ClickedWord + "=" + ClickedWordMeaning + "=" + ClickedWordCode + "_" + ClickedWordFreq + "_" + NumberOfTestsDoneString + "_" + NewTimeStampString + "-->" + TempString
                 
                 WordLineAZ = Replace(WordLineAZ, Chr(10), "")
                 WordLineDT = Replace(WordLineDT, Chr(10), "")
                 WordLineFQ = Replace(WordLineFQ, Chr(10), "")
                 WordLineTQ = Replace(WordLineTQ, Chr(10), "")
                 
                 For Each ParseLine In ParseContentArray
                    lenParseLine = Len(ParseLine)
                    If (lenParseLine > 9) Then
                       ParseArray = Split(ParseLine, "§")
                       ParseType = ParseArray(0)
                       ParseBase = ParseArray(1)
                       ParseChange = ParseArray(2)
                       ParseAllow = ParseArray(3)
                       WordLineAZ = Replace(WordLineAZ, ParseBase, ParseChange)
                       WordLineDT = Replace(WordLineDT, ParseBase, ParseChange)
                       WordLineFQ = Replace(WordLineFQ, ParseBase, ParseChange)
                       WordLineTQ = Replace(WordLineTQ, ParseBase, ParseChange)
                    End If
                 Next
     
                 SortStringIntoStringOfArray WordListAllAZ, WordLineAZ, "<!--DIVCHAR--><ILP>"
                 SortStringIntoStringOfArray WordListAllDT, WordLineDT, "<!--DIVCHAR--><ILP>"
                 SortStringIntoStringOfArray WordListAllFQ, WordLineFQ, "<!--DIVCHAR--><ILP>"
                 SortStringIntoStringOfArray WordListAllTQ, WordLineTQ, "<!--DIVCHAR--><ILP>"
      
                 If (AlreedsExisteert = False) Then
                    NV = 0
                    VariableValuesArray = Split(VariableValues, ",")
                    NumberOfVariableValues = UBound(VariableValuesArray)
                    Do While NV < NumberOfVariableValues + 1
                       VariableValuesLineArray = Split(VariableValuesArray(NV), "=")
                       If (VariableValuesLineArray(0) = "<<<TEACHERCURRENTMYWORDSNUMBER>>>") Then
                          VariableValuesLineArray(1) = VariableValuesLineArray(1) + 1
                          VariableValuesArray(NV) = VariableValuesLineArray(0) + "=" + VariableValuesLineArray(1)
                       End If
                       NV = NV + 1
                    Loop
                    VariableValues = Join(VariableValuesArray, ",")
                    NV = 0
                 End If
             
                 IndexContentArray = Split(IndexContents, "#" + WordListFileAZ + "#")
                 DataFileNumber = IndexContentArray(1)
                 FileIndexNumber = IndexContentArray(2)
                 FileIndexArray(FileIndexNumber) = WordListAllAZ
                 IndexContentArray = Split(IndexContents, "#" + WordListFileDT + "#")
                 DataFileNumber = IndexContentArray(1)
                 FileIndexNumber = IndexContentArray(2)
                 FileIndexArray(FileIndexNumber) = WordListAllDT
                 IndexContentArray = Split(IndexContents, "#" + WordListFileFQ + "#")
                 DataFileNumber = IndexContentArray(1)
                 FileIndexNumber = IndexContentArray(2)
                 FileIndexArray(FileIndexNumber) = WordListAllFQ
                 IndexContentArray = Split(IndexContents, "#" + WordListFileTQ + "#")
                 DataFileNumber = IndexContentArray(1)
                 FileIndexNumber = IndexContentArray(2)
                 FileIndexArray(FileIndexNumber) = WordListAllTQ
      
                 NotNow = True
                 FirstNav = False
                 brwWebBrowser.Stop
                 Cancel = True
             
                 If (RefreshSwitch = "DO_REFRESH") Then
                   GetFileList = SaveGetFileList
                   brwWebBrowser.Navigate2 SaveURL, Flags, TargetFrameName, PostData, Headers
                 End If
              End If
           End If
        End If
    End If
  
    If (RefreshPage = True) Then
        FirstNav = False
        RefreshPage = False
        brwWebBrowser.Navigate2 "about:blank", Flags, TargetFrameName, PostData, Headers
        Exit Sub
    End If
  
  
    If URL <> OldURL And StartUp <> True And NotNow <> True Then
        FirstNav = True
    End If
    OldURL = URL
    AncientFrame = TargetFrameName
     
    TempArray = Split(URL, "www.bermudaword.com/register")
    If (UBound(TempArray) > 0) Then
        FirstNav = False
    End If
     
    If (URL = "about:blank" Or URL = PrePath + "Config\blank.htm" Or URL = "") Then
        FirstNav = False
    End If
      
    If FirstNav = True Then
  
        FirstNav = False
        ForwardedAddress = URL
         
        DebugEntry "URL is " + CStr(ForwardedAddress)
         
        TempString = Replace(ForwardedAddress, PrePath + "Config\", "")
        IndexContentArray = Split(IndexContents, "#" + TempString + "#")
        DataFileNumber = IndexContentArray(1)
        FileIndexNumber = IndexContentArray(2)
            
        DebugEntry "Searching file"
        If FileIndexArray(FileIndexNumber) = "" Then
            DataFileAddress = PrePath + "Data\HypLern" + DataFileNumber + ".dat"
            ReadDataFile DataFileAddress, DataFileNumber, ForwardedAddress, Contents
            DecryptFile Contents
            FileIndexArray(FileIndexNumber) = Contents
        Else
            Contents = FileIndexArray(FileIndexNumber)
        End If
  
        DebugEntry "Replacing ConfigValues in Contents"
        ConfigValuesArray = Split(ConfigValues, ",")
        For Each ConfigValue In ConfigValuesArray
            ConfigValueLine = Split(ConfigValue, "=")
            Contents = Replace(Contents, ConfigValueLine(0), ConfigValueLine(2))
            Contents = Replace(Contents, "<option value='" + ConfigValueLine(1) + "'", "<option selected value='" + ConfigValueLine(1) + "'")
        Next
        
        DebugEntry "Replacing ParseValues in Contents"
        ParseContentArray = Split(ParseContents, Chr(10) + "STD§")
        For Each ParseLine In ParseContentArray
            lenParseLine = Len(ParseLine)
            If (lenParseLine > 9) Then
                ParseArray = Split(ParseLine, "§")
                ParseType = ParseArray(0)
                ParseBase = ParseArray(1)
                ParseChange = ParseArray(2)
                ParseAllow = ParseArray(3)
                Contents = Replace(Contents, ParseBase, ParseChange)
            End If
        Next
  
        GroupArray = Split(Groups, ",")
        
        DebugEntry "Getting Files from string"
        GetFileListArray = Split(GetFileList, ",")
        For Each GetFileListEntry In GetFileListArray
            GetFileListEntryArray = Split(GetFileListEntry, "=")
            ParseBase = GetFileListEntryArray(0)
            ParseChange = GetFileListEntryArray(1)
            If (ParseBase = "<<<PAGETABLE>>>" Or ParseBase = "<<<PTWOTABLE>>>") Then
               IndexContentArray = Split(IndexContents, "#" + ParseChange + "#")
               DataFileNumber = IndexContentArray(1)
               FileIndexNumber = IndexContentArray(2)
               SavedFileIndexNumber = FileIndexNumber
               If FileIndexArray(FileIndexNumber) = "" Then
                  DataFileAddress = PrePath + "Data\HypLern" + DataFileNumber + ".dat"
                  SubFileContents = ""
                  ReadDataFile DataFileAddress, DataFileNumber, ParseChange, SubFileContents
                  DecryptFile SubFileContents
                  FileIndexArray(FileIndexNumber) = SubFileContents
               Else
                  SubFileContents = FileIndexArray(FileIndexNumber)
               End If
            Else
               If ((ParseBase = "<<<PAGEEDIT>>>" Or ParseBase = "<<<EXTERNAL>>>") And EditMode = "EDIT") Then
                  ' save Contents as some Mushroom did not think before programming
                  'TempString = Contents
                  'ReadWriteFile HomePath + "\" + ParseChange, "read", TempStringFore
                  'SubFileContents = StrConv(TempStringFore, vbFromUnicode)
                  ReadWriteFile HomePath + "\" + ParseChange, "read", SubFileContents
                  'Contents = TempString
                  If (Mid(SubFileContents, 1, 1) = "") Then
                     IndexContentArray = Split(IndexContents, "#" + ParseChange + "#")
                     DataFileNumber = IndexContentArray(1)
                     FileIndexNumber = IndexContentArray(2)
                     SavedFileIndexNumber = FileIndexNumber
                     If FileIndexArray(FileIndexNumber) = "" Then
                        DataFileAddress = PrePath + "Data\HypLern" + DataFileNumber + ".dat"
                        SubFileContents = ""
                        ReadDataFile DataFileAddress, DataFileNumber, ParseChange, SubFileContents
                        DecryptFile SubFileContents
                        FileIndexArray(FileIndexNumber) = SubFileContents
                     Else
                        SubFileContents = FileIndexArray(FileIndexNumber)
                     End If
                  End If
               Else
                  IndexContentArray = Split(IndexContents, "#" + ParseChange + "#")
                  DataFileNumber = IndexContentArray(1)
                  FileIndexNumber = IndexContentArray(2)
                  SubFileContents = FileIndexArray(FileIndexNumber)
               End If
            End If
  
            'If (ParseBase = "<<<PAGEEDIT>>>") Then
            '  DebugEntry "Contents: " + Contents
            '  DebugEntry "SubFileContents: " + SubFileContents
            'End If
            
            Contents = Replace(Contents, ParseBase, SubFileContents)
            
            If (ParseBase = "<<<PAGETABLE>>>") Then
               CustomCodeLine = SubFileContents
               CustomCodeArray = Split(CustomCodeLine, "--CUSTOMCODE--")
               NumberOfCustomCodes = UBound(CustomCodeArray)
               If (NumberOfCustomCodes > 0) Then
                  CustomCodeLine = CustomCodeArray(1)
                  CustomCodeArray = Split(CustomCodeLine, ",")
                  NumberOfCustomCodes = UBound(CustomCodeArray)
                  T = 0
                  Do While T < (NumberOfCustomCodes)
                     ParseBase = CustomCodeArray(T)
                     T = T + 1
                     ParseChange = CustomCodeArray(T)
                     N = 0
                     PermCustomCodesArray = Split(PermCustomCodes, ",")
                     NumberOfPermCustomCodes = UBound(PermCustomCodesArray)
                     CustomCodeExists = False
                     Do While N < (NumberOfPermCustomCodes)
                        PermCustomCode = PermCustomCodesArray(N)
                        N = N + 1
                        PermCustomCodeIs = PermCustomCodesArray(N)
                        If (ParseBase = PermCustomCode) Then
                           CustomCodeExists = True
                           PermCustomCodes = Replace(PermCustomCodes, PermCustomCode + "," + PermCustomCodeIs, ParseBase + "," + ParseChange)
                        End If
                        N = N + 1
                     Loop
                     If (CustomCodeExists = False) Then
                        PermCustomCodes = PermCustomCodes + "," + ParseBase + "," + ParseChange
                     End If
                     T = T + 1
                  Loop
               End If
            End If
         Next
  
         NumberOfParseTemplates = UBound(ParseTemplateArray)
         T = 0
         Do While T < (NumberOfParseTemplates)
            ParseBase = ParseTemplateArray(T)
            T = T + 1
            ParseChange = ParseTemplateArray(T)
            Contents = Replace(Contents, ParseBase, ParseChange)
            T = T + 1
         Loop
  
  
         ConfigValuesArray = Split(ConfigValues, ",")
         For Each ConfigValue In ConfigValuesArray
            ConfigValueLine = Split(ConfigValue, "=")
            Contents = Replace(Contents, ConfigValueLine(0), ConfigValueLine(2))
            Contents = Replace(Contents, "<option value='" + ConfigValueLine(1) + "'", "<option selected value='" + ConfigValueLine(1) + "'")
         Next
  
         ParseContentArray = Split(ParseContents, Chr(10) + "STD§")
         For Each ParseLine In ParseContentArray
            lenParseLine = Len(ParseLine)
            If (lenParseLine > 9) Then
               ParseArray = Split(ParseLine, "§")
               ParseType = ParseArray(0)
               ParseBase = ParseArray(1)
               ParseChange = ParseArray(2)
               ParseAllow = ParseArray(3)
               Contents = Replace(Contents, ParseBase, ParseChange)
            End If
         Next
         
  
         ConfigValuesArray = Split(ConfigValues, ",")
         For Each ConfigValue In ConfigValuesArray
            ConfigValueLine = Split(ConfigValue, "=")
            Contents = Replace(Contents, ConfigValueLine(0), ConfigValueLine(2))
            Contents = Replace(Contents, "<option value='" + ConfigValueLine(1) + "'", "<option selected value='" + ConfigValueLine(1) + "'")
         Next
         
         Contents = Replace(Contents, "<<<VARIABLEVALUES>>>", VariableValues)
         VariableValuesArray = Split(VariableValues, ",")
         NV = 0
         NumberOfVariableValues = UBound(VariableValuesArray)
         Do While NV < NumberOfVariableValues + 1
            VariableValuesLineArray = Split(VariableValuesArray(NV), "=")
            Contents = Replace(Contents, VariableValuesLineArray(0), VariableValuesLineArray(1))
            NV = NV + 1
         Loop
         NV = 0
         
         Contents = Replace(Contents, "<<<VARIABLEVALUES>>>", VariableValues)
         VariableValuesArray = Split(VariableValues, ",")
         NV = 0
         NumberOfVariableValues = UBound(VariableValuesArray)
         Do While NV < NumberOfVariableValues + 1
            VariableValuesLineArray = Split(VariableValuesArray(NV), "=")
            Contents = Replace(Contents, VariableValuesLineArray(0), VariableValuesLineArray(1))
            NV = NV + 1
         Loop
         NV = 0
  
         Contents = Replace(Contents, "PARSEMENOT", "")
  
         N = 0
         PermCustomCodesArray = Split(PermCustomCodes, ",")
         NumberOfPermCustomCodes = UBound(PermCustomCodesArray)
         Do While N < (NumberOfPermCustomCodes)
            PermCustomCode = PermCustomCodesArray(N)
            N = N + 1
            PermCustomCodeIs = PermCustomCodesArray(N)
            Contents = Replace(Contents, PermCustomCode, PermCustomCodeIs)
            Contents = Replace(Contents, "<option value='" + PermCustomCodeIs + "'", "<option selected value='" + PermCustomCodeIs + "'")
            N = N + 1
         Loop
  
         ParseContentArray = Split(ParseContents, Chr(10) + "STD§")
         For Each ParseLine In ParseContentArray
            lenParseLine = Len(ParseLine)
            If (lenParseLine > 9) Then
               ParseArray = Split(ParseLine, "§")
               ParseType = ParseArray(0)
               ParseBase = ParseArray(1)
               ParseChange = ParseArray(2)
               ParseAllow = ParseArray(3)
               Contents = Replace(Contents, ParseBase, ParseChange)
            End If
         Next
  
         OriginalLocationExpression = "..\Media\"
         NewLocationReplacement = "res://" + LanguagePath + "-" + StoryPath + ".exe/"
         Contents = Replace(Contents, OriginalLocationExpression, NewLocationReplacement)
         
         DividingChar = "<BR>"
         ConfigContents = ConfigBase + ConfigValues + DividingChar + PermCustomCodes + DividingChar + "</html>" + DividingChar
  
         TestListArray = Split(Contents, "<!--DIVCHAR--><ILP>")
         TempNumber = UBound(TestListArray)
         If (TempNumber > 1) Then
            TestListTemp = TestListArray(1)
            TestListArray = Split(TestListTemp, "<BR></DIV></NOBR>" + Chr(10))
            EpochTime = DateDiff("s", #1/1/1970#, Now())
            For Each TestListEntry In TestListArray
               If (TestListEntry <> "") Then
                  TestListLine = Split(TestListEntry, "-->")
                  TestListWord = TestListLine(0)
                  TestListLine = Split(TestListWord, "_")
                  TimeStampString = TestListLine(UBound(TestListLine))
                  NumberOfTestsDone = TestListLine(UBound(TestListLine) - 1)
                  ClickedWordFreq = TestListLine(UBound(TestListLine) - 2)
                  NumberOfTestsNeeded = Round(RetentionFactor / ClickedWordFreq)
                  If (NumberOfTestsNeeded = 0) Then
                     NumberOfTestsNeeded = 1
                     NumberOfTestsNeededString = CStr(NumberOfTestsNeeded)
                  Else
                     NumberOfTestsNeededString = CStr(NumberOfTestsNeeded)
                  End If
                  CleanedTimeStampString = Mid(TimeStampString, 1, 9)
                  CleanedTimeStampNumber = CleanedTimeStampString
                  CleanedTimeStampNumber = CleanedTimeStampNumber + 800000000
  
                  TestListLine = Split(TestListEntry, "dtxt id=")
                  TestListWord = TestListLine(1)
                  TestListLine = Split(TestListWord, "_")
                  OriginalTimeStampString = TestListLine(0)
  
                  CleanedOriginalTimeStampString = Mid(OriginalTimeStampString, 2, 9)
                  CleanedOriginalTimeStampNumber = CleanedOriginalTimeStampString
                  CleanedOriginalTimeStampNumber = CleanedOriginalTimeStampNumber + 800000000
  
                  TempNumber = NumberOfTestsDone + 1
                  TempNumberToo = 1 - 1 + SRSRemArray(TempNumber) - SRSRemArray(TempNumber - 1)
                  TempNumberTree = EpochTime - CleanedTimeStampNumber
  
                  'debug: here we can add margin (deduct from TempNumberTree)
                  'TempNumberTree is current number of seconds after last reminder (waited)
                  'TempNumberToo is time of next reminder in seconds after last reminder (total wait)
                  'so margin needs be added to TempNumberTree or deducted from TempNumberToo
                  'margin is the percentage (0.xx) from "total wait" added to TempNumberTree
                  TempNumberFore = ((IntervalMargin / 100) * TempNumberToo)
  
                  If (TempNumberToo > 0 And TempNumberToo > TempNumberTree) Then
                     ActualTimeStampNumber = TempNumberToo - TempNumberTree
                  Else
                     ActualTimeStampNumber = EpochTime - CleanedTimeStampNumber
                  End If
  
                  If (((TempNumberTree > TempNumberToo) Or (TempNumberTree = TempNumberToo)) And TempNumberToo > 0) Then
                     TempStringToo = Mid(OriginalTimeStampString, 2)
                     Contents = Replace(Contents, "<<<URGENCYCOLOR" + TempStringToo + ">>>;'>&nbsp;" + ClickedWordFreq + "</FIELD", "red;'>&nbsp;" + NumberOfTestsNeededString + "</FIELD")
                     Contents = Replace(Contents, "<<<URGENCYCOLOR" + TempStringToo + ">>>", "red")
                     ActualTimeStampNumber = 0
                  Else
                     If (((((TempNumberTree + TempNumberFore) > TempNumberToo)) And TempNumberToo > 0)) Then
                       TempStringToo = Mid(OriginalTimeStampString, 2)
                       Contents = Replace(Contents, "<<<URGENCYCOLOR" + TempStringToo + ">>>;'>&nbsp;" + ClickedWordFreq + "</FIELD", "orange;'>&nbsp;" + NumberOfTestsNeededString + "</FIELD")
                       Contents = Replace(Contents, "<<<URGENCYCOLOR" + TempStringToo + ">>>", "orange")
                     Else
                       TempStringToo = Mid(OriginalTimeStampString, 2)
                       Contents = Replace(Contents, "<<<URGENCYCOLOR" + TempStringToo + ">>>;'>&nbsp;" + ClickedWordFreq + "</FIELD", "<<<URGENCYCOLOR" + TempStringToo + ">>>;'>&nbsp;" + NumberOfTestsNeededString + "</FIELD")
                     End If
                  End If
  
                  NumberOfDays = 0
                  NumberOfHours = 0
                  NumberOfMinutes = 0
                  NumberOfSeconds = 0
                  If (ActualTimeStampNumber > 86400) Then
                     NumberOfDays = Int(ActualTimeStampNumber / 86400)
                     NumberOfSeconds = ActualTimeStampNumber - (NumberOfDays * 86400)
                     If (NumberOfSeconds > 3600) Then
                        NumberOfHours = Int(NumberOfSeconds / 3600)
                        NumberOfSeconds = NumberOfSeconds - (NumberOfHours * 3600)
                        If (NumberOfSeconds > 60) Then
                           NumberOfMinutes = Int(NumberOfSeconds / 60)
                           NumberOfSeconds = NumberOfSeconds - (NumberOfMinutes * 60)
                        End If
                     Else
                        If (NumberOfSeconds > 60) Then
                           NumberOfMinutes = Int(NumberOfSeconds / 60)
                           NumberOfSeconds = NumberOfSeconds - (NumberOfMinutes * 60)
                        End If
                     End If
                  Else
                     If (ActualTimeStampNumber > 3600) Then
                        NumberOfHours = Int(ActualTimeStampNumber / 3600)
                        NumberOfSeconds = ActualTimeStampNumber - (NumberOfHours * 3600)
                        If (NumberOfSeconds > 60) Then
                           NumberOfMinutes = Int(NumberOfSeconds / 60)
                           NumberOfSeconds = NumberOfSeconds - (NumberOfMinutes * 60)
                        End If
                     Else
                        If (ActualTimeStampNumber > 60) Then
                           NumberOfMinutes = Int(ActualTimeStampNumber / 60)
                           NumberOfSeconds = ActualTimeStampNumber - (NumberOfMinutes * 60)
                        Else
                           NumberOfSeconds = ActualTimeStampNumber
                        End If
                     End If
                  End If
               End If
               If (NumberOfDays > 0) Then
                  Contents = Replace(Contents, ">" + TimeStampString + "<", ">" + CStr(NumberOfDays) + " days, " + CStr(NumberOfHours) + " hours, " + CStr(NumberOfMinutes) + " minutes, " + CStr(NumberOfSeconds) + " seconds<")
               Else
                  If (NumberOfHours > 0) Then
                     Contents = Replace(Contents, ">" + TimeStampString + "<", ">" + CStr(NumberOfHours) + " hours, " + CStr(NumberOfMinutes) + " minutes, " + CStr(NumberOfSeconds) + " seconds<")
                  Else
                     If (NumberOfMinutes > 0) Then
                        Contents = Replace(Contents, ">" + TimeStampString + "<", ">" + CStr(NumberOfMinutes) + " minutes, " + CStr(NumberOfSeconds) + " seconds<")
                     Else
                        Contents = Replace(Contents, ">" + TimeStampString + "<", ">" + CStr(NumberOfSeconds) + " seconds<")
                     End If
                  End If
               End If
            Next
        End If
  
        FinalContents = Contents
  
        If AutoSave = "Yeppadoodle" Then
            DebugEntry "Autosaving..."
            WordListAddressAZ = HomePath + "\" + WordListFileAZ
            WordListAddressDT = HomePath + "\" + WordListFileDT
            WordListAddressFQ = HomePath + "\" + WordListFileFQ
            WordListAddressTQ = HomePath + "\" + WordListFileTQ
            ReadWriteFile WordListAddressAZ, "write", WordListAllAZ
            ReadWriteFile WordListAddressDT, "write", WordListAllDT
            ReadWriteFile WordListAddressFQ, "write", WordListAllFQ
            ReadWriteFile WordListAddressTQ, "write", WordListAllTQ
            DividingChar = "<BR>"
            ConfigValues = Replace(ConfigValues, "<<<LAYOUTEXTRA>>>=LAYOUTSINGLE=LAYOUTSINGLE,", "<<<LAYOUTEXTRA>>>=LAYOUTDOUBLE=LAYOUTDOUBLE,")
            TempArray = Split(VariableValues, "<<<RANDOMSECKEY>>>")
            If (UBound(TempArray) > 0) Then
                ConfigContents = ConfigBase + VariableValues + DividingChar + ConfigValues + DividingChar + PermCustomCodes + DividingChar + "</html>" + DividingChar
            Else
                ConfigContents = ConfigBase + VariableValues + "," + "<<<RANDOMSECKEY>>>=" + RandomSecKey + DividingChar + ConfigValues + DividingChar + PermCustomCodes + DividingChar + "</html>" + DividingChar
            End If
            ForwardedAddress = HomePath + "\HypLernConfig.htm"
            ReadWriteFile ForwardedAddress, "write", ConfigContents
            NotNow = True
            FirstNav = False
            brwWebBrowser.Stop
            Cancel = True
            AutoSave = ""
            DebugEntry "End of Autosaving..."
        End If

        Contents = ""
        CTLFlag = False

        SaveURL = URL

        GetFileList = ("")

        Cancel = True
        brwWebBrowser.Navigate2 "about:blank", Flags, TargetFrameName, PostData, Headers

        TempString = TimeString + " -> " + CStr(Now)

    Else
 
        CTLFlag = False
        FirstNav = True
        RefreshPage = False
  
        TempString = TimeString + " -> " + CStr(Now)
    End If
End Sub
  
Sub SimpleSort(StringToSort)
    Dim LengthOfSortString
    Dim TempNumber
    Dim TempNumberToo
    Dim TempString

    LengthOfSortString = Len(StringToSort)
    DebugEntry "Trying to sort " + StringToSort + " of length " + CStr(LengthOfSortString)
    Dim HugeSortingArray(9999)
    Do While TempNumber < LengthOfSortString
        TempString = Mid(StringToSort, TempNumber + 1, 1)
        DebugEntry "Sorting Character " + TempString
        TempNumberToo = Asc(TempString)
        HugeSortingArray((TempNumberToo * LengthOfSortString) + TempNumber) = TempString
        TempNumber = TempNumber + 1
    Loop
    StringToSort = Join(HugeSortingArray, "")
    HugeSortingArray(9999) = ("")
     
End Sub

  Sub SortStringIntoStringOfArray(WordListAll, WordLine, SortDivider)
     Dim WordListArray
     Dim SortReady As Boolean
     Dim AlreedsExisteert As Boolean
     Dim WordPosition
     Dim LastPosition
     Dim OldPosition
     Dim W
     Dim lenTempString
     
     WordListArray = Split(WordListAll, SortDivider)
     WordList = WordListArray(1)
     If (WordList <> "") Then
        WordListArray = Split(WordList, Chr(10))
        LastPosition = Round(UBound(WordListArray))
        WordPosition = Round(UBound(WordListArray) / 2)
        W = 0
        SortReady = False
        AlreedsExisteert = False
        Do While SortReady = False
           W = W + 1
           TempString = WordPosition
           lenTempString = Len(WordListArray(WordPosition))
           If (lenTempString < 25) Then
           End If
           If (WordListArray(WordPosition) = WordLine) Then
              AlreedsExisteert = True
              SortReady = True
              Exit Do
           End If
           If (WordPosition = (UBound(WordListArray) - 1) Or WordPosition = 0) Then
              If (WordPosition = 0) Then
                 If (WordPosition = 0 And WordListArray(WordPosition) > WordLine) Then
                    SortReady = True
                    WordListAll = Replace(WordListAll, WordListArray(WordPosition) + Chr(10), WordLine + Chr(10) + WordListArray(WordPosition) + Chr(10))
                    Exit Do
                 End If
                 If (WordPosition = 0 And WordListArray(WordPosition) < WordLine) Then
                    SortReady = True
                    WordListAll = Replace(WordListAll, WordListArray(WordPosition) + Chr(10), WordListArray(WordPosition) + Chr(10) + WordLine + Chr(10))
                    Exit Do
                 End If
              End If
              If ((WordPosition = (UBound(WordListArray) - 1)) And (WordPosition > 0)) Then
                 If (WordPosition = (UBound(WordListArray) - 1) And WordListArray(WordPosition) < WordLine) Then
                    SortReady = True
                    WordListAll = Replace(WordListAll, WordListArray(WordPosition) + Chr(10), WordListArray(WordPosition) + Chr(10) + WordLine + Chr(10))
                    Exit Do
                 End If
                 If ((WordPosition = (UBound(WordListArray) - 1)) And (WordListArray(WordPosition) > WordLine) And (WordListArray(WordPosition - 1) < WordLine)) Then
                    SortReady = True
                    WordListAll = Replace(WordListAll, WordListArray(WordPosition) + Chr(10), WordLine + Chr(10) + WordListArray(WordPosition) + Chr(10))
                    Exit Do
                 End If
              End If
           Else
              If (WordListArray(WordPosition) < WordLine And WordListArray(WordPosition + 1) > WordLine) Then
                 SortReady = True
                 If (lenTempString < 25) Then
                    WordListAll = Replace(WordListAll, WordListArray(WordPosition + 1) + Chr(10), WordLine + Chr(10) + WordListArray(WordPosition + 1) + Chr(10))
                 Else
                    WordListAll = Replace(WordListAll, WordListArray(WordPosition) + Chr(10), WordListArray(WordPosition) + Chr(10) + WordLine + Chr(10))
                 End If
                 Exit Do
              End If
              If (WordListArray(WordPosition - 1) < WordLine And WordListArray(WordPosition) > WordLine) Then
                 SortReady = True
                 If (lenTempString < 25) Then
                    WordListAll = Replace(WordListAll, WordListArray(WordPosition) + Chr(10), WordLine + Chr(10) + WordListArray(WordPosition) + Chr(10))
                 Else
                    WordListAll = Replace(WordListAll, WordListArray(WordPosition - 1) + Chr(10), WordListArray(WordPosition - 1) + Chr(10) + WordLine + Chr(10))
                 End If
                 Exit Do
              End If
           End If
           If (WordListArray(WordPosition) > WordLine) Then
              If (WordPosition = 1) Then
                 LastPosition = WordPosition
                 WordPosition = 0
              Else
                 If (LastPosition > WordPosition) Then
                    OldPosition = WordPosition
                    WordPosition = Round(WordPosition - ((LastPosition - WordPosition) / 2))
                    If (WordPosition = LastPosition) Then
                      WordPosition = WordPosition - 1
                    End If
                    LastPosition = OldPosition
                 Else
                    OldPosition = WordPosition
                    WordPosition = Round((WordPosition + LastPosition) / 2)
                    If (WordPosition = LastPosition) Then
                      WordPosition = WordPosition - 1
                    End If
                    LastPosition = OldPosition
                 End If
              End If
           Else
              OldPosition = WordPosition
              If (LastPosition > WordPosition) Then
                 WordPosition = Round((LastPosition + WordPosition) / 2)
                 If (WordPosition = LastPosition) Then
                   WordPosition = WordPosition + 1
                 End If
                 LastPosition = OldPosition
                 If (WordPosition > (UBound(WordListArray) - 1)) Then
                    WordPosition = UBound(WordListArray) - 1
                 End If
              Else
                 WordPosition = Round(WordPosition + ((WordPosition - LastPosition) / 2))
                 If (WordPosition = LastPosition) Then
                   WordPosition = WordPosition + 1
                 End If
                 LastPosition = OldPosition
                 If (WordPosition > (UBound(WordListArray) - 1)) Then
                    WordPosition = UBound(WordListArray) - 1
                 End If
              End If
           End If
           If (W > (UBound(WordListArray) + UBound(WordListArray))) Then
              SortReady = True
              Exit Do
           End If
        Loop
     Else
        WordListAll = Replace(WordListAll, SortDivider + SortDivider, SortDivider + WordLine + Chr(10) + SortDivider)
     End If
  End Sub
  
Private Sub DebugEntry(TempString As String, Optional OtherDebugFile As String, Optional OtherModus As String, Optional Temporary As String)
    Dim TargetDebugFile
    Dim TargetModus                     'Debug

    If OtherModus = "" Then             'Debug
       TargetModus = "add"              'Debug
    End If                              'Debug
    
    If OtherDebugFile = "" Then
       TargetDebugFile = DebugFile
    End If                              'Debug
    
    ReadWriteFile OtherDebugFile + TargetDebugFile, OtherModus + TargetModus, TempString
    
End Sub                                 'Debug
  Sub CreateFolder(FolderToCreate)
      Dim fso
      Set fso = CreateObject("Scripting.FileSystemObject")
      
      fso.CreateFolder FolderToCreate
  
  End Sub
  Sub GetFileSize(FileToGetSize)
      Dim fso
      Dim f
      
      Set fso = CreateObject("Scripting.FileSystemObject")
      
      Set f = fso.GetFile(FileToGetSize)
      SecFileSize = f.Size
      
  End Sub
  Sub DeleteFile(FileToDelete)
     Dim fso
     Set fso = CreateObject("Scripting.FileSystemObject")
  
     On Error Resume Next
     fso.DeleteFile FileToDelete
  End Sub
  
  
  Private Sub brwWebBrowser_DownloadComplete()
      
      
      If StartUp = True Then
         StartUp = False
         StartUpTwo = True
      Else
         If StartUpTwo = True Then
            StartUpTwo = False
         End If
      End If
      
      Me.Caption = ApplicationTitle + " - " + LanguagePath + " - " + CourseTitle
  
      AncientURL = OldURL
      OldURL = "hopjesvla"
  
      
  End Sub
  
Private Sub Form_Resize()
    Dim TempString
    Dim TempArray
    Dim TempNumber
    Dim TempNumberToo
    
    On Error Resume Next
    If Me.WindowState = vbMinimized Then
        Exit Sub
    End If
    
    'TempNumber = Round(Me.Width + 2000 - 2000)
    'DebugEntry "WindowWith is actually " + CStr(TempNumber)
    
    'TempNumber = Round((Me.Width - 6380 - WindowWidthDifference) / 10)
    'DebugEntry "Window Width is now " + CStr(TempNumber)
    'If (TempNumber < 0) Then
    '   TempNumber = 1
    'End If

    'TempArray = Split(ConfigValues, "<<<DBLMARGINWIDTH>>>")
    'TempString = TempArray(1)
    'TempArray = Split(TempString, ",")
    'TempString = "<<<DBLMARGINWIDTH>>>" + TempArray(0) + ","
    'TempNumberToo = Round((TempNumber - 700) / 2)
    'If (TempNumberToo < 50) Then
    '    TempNumberToo = 50
    'End If
    'DebugEntry "Setting DBLMARGINWIDTH to " + CStr(TempNumberToo)
    
    'ConfigValues = Replace(ConfigValues, TempString, "<<<DBLMARGINWIDTH>>>=TABLEWIDTH400=" + CStr(TempNumberToo) + ",")

    'TempArray = Split(ConfigValues, "<<<TABLEWIDTH>>>")
    'TempString = TempArray(1)
    'TempArray = Split(TempString, ",")
    'TempString = "<<<TABLEWIDTH>>>" + TempArray(0) + ","
    'DebugEntry "Setting TABLEWIDTH to " + CStr(TempNumber)
    
    'ConfigValues = Replace(ConfigValues, TempString, "<<<TABLEWIDTH>>>=TABLEWIDTH400=" + CStr(TempNumber) + ",")
    
    brwWebBrowser.Width = Me.ScaleWidth
    brwWebBrowser.Height = Me.ScaleHeight
    
    'TempNumber = Round(Me.Height + 2000 - 2000)
    'DebugEntry "Window Height is now " + CStr(TempNumber)
    
  End Sub

Private Sub brwWebBrowser_DocumentComplete(ByVal pDisp As Object, URL As Variant)
    Dim FileToDelete As Variant
    Dim FilesToDeleteArray
    Dim TempString
    Dim TempNumber
    Dim UpdateRequestsArray
    Dim UpdateRequest As Variant
    Dim NumberOfUpdateRequests
    Dim TargetFrame
    Dim FinalContentsArray
    Dim NumberOfFinalContentEntries
    Dim T
    Dim WindowWidthTemp
    Dim WindowHeightTemp
    Dim ConfigValuesArray
    Dim ConfigValueLine
    Dim ConfigValue
    Dim TempArray
    Dim DividingChar
    Dim ConfigContents
  
    Dim NumberOfIndexLines, I, DataFileNumber
    
    If (LayoutConfig = True) Then
        On Error Resume Next
        ConfigValuesArray = Split(ConfigValues, ",")
        For Each ConfigValue In ConfigValuesArray
            ConfigValueLine = Split(ConfigValue, "=")
            If (ConfigValueLine(0) = "<<<LAYOUTEXTRA>>>") Then
                WindowLayout = ConfigValueLine(2)
            End If
            If (ConfigValueLine(0) = "<<<TABLEWIDTH>>>") Then
            WindowWidth = ConfigValueLine(2)
            End If
        Next
        'If (WindowLayout = "LAYOUTDOUBLE") Then
        '    WindowWidthTemp = WindowWidth
        '    If (WindowWidth > 500) Then
        '        WindowWidthTemp = 500
        '    End If
        '    If (WindowWidth < 300) Then
        '        WindowWidthTemp = 300
        '    End If
        '    Me.Width = 4880 + (WindowWidthTemp * (WindowWidthTemp / 25)) + WindowWidthDifference
        'End If
        'Me.Height = WindowHeight
        LayoutConfig = False
        If (StartingScreen = True) Then
            StartingScreen = False
            Me.Top = 200
            Me.Left = 200
        End If
    End If

    If (DebugFlag = "ON") Then                                                   'Debug
        If (SecurityURL <> "") Then                                              'Debug
            DebugEntry "We're here!"                                             'Debug
            If (FirstTimeConfig = "YES") Then                                    'Debug
                DividingChar = "<BR>"                                            'Debug
                TempArray = Split(VariableValues, "<<<RANDOMSECKEY>>>")          'Debug
                If (UBound(TempArray) < 1) Then                                  'Debug
                    ConfigContents = ConfigBase + VariableValues + "," + "<<<RANDOMSECKEY>>>=" + RandomSecKey + DividingChar + ConfigValues + DividingChar + PermCustomCodes + DividingChar + "</html>" + DividingChar      'Debug
                    ForwardedAddress = HomePath + "\HypLernConfig.htm"           'Debug
                    ReadWriteFile ForwardedAddress, "write", ConfigContents      'Debug
                End If                                                           'Debug
            End If                                                               'Debug
            DebugEntry "We're here 2!"                                           'Debug
            brwWebBrowser.Document.write "<html><body>&nbsp;</body></html>"      'Debug
            BermudaWordMessageString = "WARNING! This is a development version!" 'Debug
            SecurityURL = ""                                                     'Debug
            TempNumber = TeCuPage + 1                                            'Debug
            StartingAddress = "about:blankGET§Course" + CourseLanguage + Group + "TextMain.htm<>" + CStr(TeCuPage) + "<>§Course" + CourseLanguage + Group + "Text" + CStr(TeCuPage) + ".htm<>Course" + CourseLanguage + Group + "Text" + CStr(TempNumber) + ".htm§<<<PAGETABLE>>><><<<PTWOTABLE>>>§NO"  'Debug
            DebugEntry "We're here 3! Adres is " + CStr(StartingAddress)         'Debug
            BermudaWordMessage                                                   'Debug
            If Len(StartingAddress) > 0 Then                                     'Debug
                DebugEntry "We're here 4!"                                       'Debug
                WindowHeight = 11000                                             'Debug
                FirstNav = True                                                  'Debug
                StartingScreen = False                                           'Debug
                LayoutConfig = True                                              'Debug
                brwWebBrowser.Navigate2 StartingAddress                          'Debug
            End If                                                               'Debug
        Else                                                                     'Debug
            TempArray = Split(FinalContents, "Hide")                             'Debug
            If (UBound(TempArray) > 0) Then                                      'Debug
                brwWebBrowser.Document.write FinalContents                       'Debug
            Else                                                                 'Debug
                brwWebBrowser.Document.write "<html><body>Debug Version Loading...</body></html>" 'Debug
            End If                                                               'Debug
        End If                                                                   'Debug
        If (DebugFlag = "ON") Then                                               'Debug
            DebugEntry FinalContents                                             'Debug
        End If                                                                   'Debug
    Else                                                                         'Debug
        TempArray = Split(URL, "www.bermudaword.com/register")
        If (UBound(TempArray) > 0) Then
            SecurityOutput = brwWebBrowser.Document.body.outerHTML
            SecurityOutput = Replace(SecurityOutput, "###This Product Key Has Been Turned Off For " + RandomSecKey + "###", "###TOTALPRODUCTKILL###")
            SecurityOutput = Replace(SecurityOutput, "###This Product Key Has Been Turned Off###", "###TOTALPRODUCTKILL###")
            TempArray = Split(CStr(SecurityOutput), "###TOTALPRODUCTKILL###")
            If (UBound(TempArray) < 1) Then
                SecurityOutput = Replace(SecurityOutput, "###Turn Off Warning For " + RandomSecKey + "###", "###TURNOFFWARNING###")
                SecurityOutput = Replace(SecurityOutput, "###Turn Off Warning###", "###TURNOFFWARNING###")
                TempArray = Split(CStr(SecurityOutput), "###TURNOFFWARNING###")
                If (UBound(TempArray) < 1) Then
                    SecurityOutput = Replace(SecurityOutput, "###Bermuda Word Message For " + RandomSecKey + "###", "###BERMUDAWORDMESSAGE###")
                    SecurityOutput = Replace(SecurityOutput, "###Bermuda Word Message###", "###BERMUDAWORDMESSAGE###")
                    TempArray = Split(CStr(SecurityOutput), "###BERMUDAWORDMESSAGE###")
                    If (UBound(TempArray) < 1) Then
                        TempArray = Split(CStr(SecurityOutput), "###BERMUDAWORDBASE###")
                        If (UBound(TempArray) < 1) Then
                            If (FirstTimeConfig = "YES" And NoEncryption <> "ON") Then
                                brwWebBrowser.Document.write "<html><body>&nbsp;</body></html>"
                                SecurityWarningMessage = "For first time Logon, please have an online internet connection so the tool can Register!"
                                SecurityWarning
                                brwWebBrowser.Stop
                                On Error Resume Next
                                End
                            Else
                                SecurityURL = ""
                                brwWebBrowser.Document.write "<html><body>&nbsp;</body></html>"
                                SecurityWarningMessage = "Support us and buy our products at www.learn-to-read-foreign-languages.com, so we can make intelligent e-books in all languages!"
                                SecurityWarning
                                If Len(StartingAddress) > 0 Then
                                    WindowHeight = 11000
                                    FirstNav = True
                                    StartingScreen = False
                                    LayoutConfig = True
                                    brwWebBrowser.Navigate2 StartingAddress
                                End If
                            End If
                        Else
                            If (FirstTimeConfig = "YES") Then
                                DividingChar = "<BR>"
                                TempArray = Split(VariableValues, "<<<RANDOMSECKEY>>>")
                                If (UBound(TempArray) < 1) Then
                                    ConfigContents = ConfigBase + VariableValues + "," + "<<<RANDOMSECKEY>>>=" + RandomSecKey + DividingChar + ConfigValues + DividingChar + PermCustomCodes + DividingChar + "</html>" + DividingChar
                                    ForwardedAddress = HomePath + "\HypLernConfig.htm"
                                    ReadWriteFile ForwardedAddress, "write", ConfigContents
                                End If
                            End If
                            SecurityURL = ""
                            brwWebBrowser.Document.write "<html><body>&nbsp;</body></html>"
                            If Len(StartingAddress) > 0 Then
                                WindowHeight = 11000
                                FirstNav = True
                                StartingScreen = True
                                LayoutConfig = True
                                brwWebBrowser.Navigate2 StartingAddress
                            End If
                        End If
                    Else
                        If (FirstTimeConfig = "YES") Then
                            DividingChar = "<BR>"
                            TempArray = Split(VariableValues, "<<<RANDOMSECKEY>>>")
                            If (UBound(TempArray) < 1) Then
                                ConfigContents = ConfigBase + VariableValues + "," + "<<<RANDOMSECKEY>>>=" + RandomSecKey + DividingChar + ConfigValues + DividingChar + PermCustomCodes + DividingChar + "</html>" + DividingChar
                                ForwardedAddress = HomePath + "\HypLernConfig.htm"
                                ReadWriteFile ForwardedAddress, "write", ConfigContents
                            End If
                        End If
                        BermudaWordMessageString = TempArray(1)
                        BermudaWordMessage
                        SecurityURL = ""
                        If Len(StartingAddress) > 0 Then
                            WindowHeight = 11000
                            FirstNav = True
                            StartingScreen = True
                            LayoutConfig = True
                            brwWebBrowser.Navigate2 StartingAddress
                        End If
                    End If
                Else
                    If (FirstTimeConfig = "YES") Then
                        DividingChar = "<BR>"
                        TempArray = Split(VariableValues, "<<<RANDOMSECKEY>>>")
                        If (UBound(TempArray) < 1) Then
                            ConfigContents = ConfigBase + VariableValues + "," + "<<<RANDOMSECKEY>>>=" + RandomSecKey + DividingChar + ConfigValues + DividingChar + PermCustomCodes + DividingChar + "</html>" + DividingChar
                            ForwardedAddress = HomePath + "\HypLernConfig.htm"
                            ReadWriteFile ForwardedAddress, "write", ConfigContents
                        End If
                    End If
                    SecurityWarningMessage = TempArray(1)
                    SecurityWarning
                    SecurityURL = ""
                    If Len(StartingAddress) > 0 Then
                        WindowHeight = 11000
                        FirstNav = True
                        StartingScreen = True
                        LayoutConfig = True
                        brwWebBrowser.Navigate2 StartingAddress
                    End If
                End If
            Else
                SecurityErrorMessage = TempArray(1)
                TempArray = Split(CStr(SecurityOutput), "###There Is An Exception For " + RandomSecKey + "###")
                If (UBound(TempArray) < 1) Then
                    ForwardedAddress = HomePath + "\HypLernConfig.htm"
                    DeleteFile ForwardedAddress
                    SecurityError
                    FinalContents = ""
                    SecurityURL = SecurityKey + ".htm?a=" + RandomSecKey + "-" + ConfigLogKey
                    brwWebBrowser.Navigate2 SecurityURL
                Else
                    SecurityURL = ""
                    DividingChar = "<BR>"
                    TempArray = Split(VariableValues, "<<<RANDOMSECKEY>>>")
                    If (UBound(TempArray) < 1) Then
                        ConfigContents = ConfigBase + VariableValues + "," + "<<<RANDOMSECKEY>>>=" + RandomSecKey + DividingChar + ConfigValues + DividingChar + PermCustomCodes + DividingChar + "</html>" + DividingChar
                        ForwardedAddress = HomePath + "\HypLernConfig.htm"
                        ReadWriteFile ForwardedAddress, "write", ConfigContents
                    End If
                    brwWebBrowser.Document.write "<html><body>&nbsp;</body></html>"
                    If Len(StartingAddress) > 0 Then
                        WindowHeight = 11000
                        FirstNav = True
                        StartingScreen = True
                        LayoutConfig = True
                        brwWebBrowser.Navigate2 StartingAddress
                    End If
                End If
            End If
        Else
            If (FinalContents <> "") Then
                brwWebBrowser.Document.write FinalContents
            End If
        End If
    End If    'Debug

    timTimer.Enabled = True
  
  End Sub
Private Sub timTimer_Timer()
  
    Dim NumberOfIndexLines, I, DataFileNumber
  
        IndexContentArray = Split(IndexContents, Chr(10))
        NumberOfIndexLines = UBound(IndexContentArray)
  
        I = SavedFileIndexNumber + 1
        If (I < NumberOfIndexLines) Then
            TempString = IndexContentArray(I - 1)
            IndexContentArray = Split(TempString, "#")
            ForwardedAddress = IndexContentArray(1)
            DataFileNumber = IndexContentArray(2)
   
            If FileIndexArray(I) = "" Then
                DataFileAddress = PrePath + "Data\HypLern" + DataFileNumber + ".dat"
                ReadDataFile DataFileAddress, DataFileNumber, ForwardedAddress, Contents
                DecryptFile Contents
                FileIndexArray(I) = Contents
            End If
        End If
     
        IndexContentArray = Split(IndexContents, Chr(10))
        NumberOfIndexLines = UBound(IndexContentArray)
     
        I = SavedFileIndexNumber + 2
        If (I < NumberOfIndexLines) Then
            TempString = IndexContentArray(I - 1)
            IndexContentArray = Split(TempString, "#")
            ForwardedAddress = IndexContentArray(1)
            DataFileNumber = IndexContentArray(2)
  
            If FileIndexArray(I) = "" Then
                DataFileAddress = PrePath + "Data\HypLern" + DataFileNumber + ".dat"
                ReadDataFile DataFileAddress, DataFileNumber, ForwardedAddress, Contents
                DecryptFile Contents
                FileIndexArray(I) = Contents
            End If
        End If
  
        I = 9999999
        timTimer.Enabled = False

         
  End Sub
  
  Private Sub BermudaWordMessage()
      MsgBox BermudaWordMessageString, 0, "Bermuda Word Message"
  End Sub
  Private Sub SecurityWarning()
      MsgBox SecurityWarningMessage, 0, "Registry Warning"
  End Sub
  Private Sub SecurityError()
      Dim RandomSecKeyRaw
      Dim TempStringToo
      Dim TempNumber
      
      RandomSecKeyRaw = InputBox(SecurityErrorMessage, "Product Registration Screen")
      TempStringToo = ""
      TempNumber = 1
      Do While TempNumber < 17
          TempString = Mid(RandomSecKeyRaw, TempNumber, 1)
          TempString = Replace(TempString, "a", "A")
          TempString = Replace(TempString, "b", "B")
          TempString = Replace(TempString, "c", "C")
          TempString = Replace(TempString, "d", "D")
          TempString = Replace(TempString, "e", "E")
          TempString = Replace(TempString, "f", "F")
          If (TempString = "A" Or TempString = "B" Or TempString = "C" Or TempString = "D" Or TempString = "E" Or TempString = "F" Or TempString = "0" Or TempString = "1" Or TempString = "2" Or TempString = "3" Or TempString = "4" Or TempString = "5" Or TempString = "6" Or TempString = "7" Or TempString = "8" Or TempString = "9") Then
              TempStringToo = TempStringToo + TempString
          End If
          TempNumber = TempNumber + 1
      Loop
      RandomSecKey = TempStringToo
      If ((Len(RandomSecKey)) <> 16) Then
          On Error Resume Next
          End
      End If
  End Sub
  
