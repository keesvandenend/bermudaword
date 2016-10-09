VERSION 5.00
Object = "{EAB22AC0-30C1-11CF-A7EB-0000C05BAE0B}#1.1#0"; "shdocvw.dll"
Object = "{22D6F304-B0F6-11D0-94AB-0080C74C7E95}#1.0#0"; "msdxm.ocx"
Begin VB.Form Form1 
   Caption         =   "Loading"
   ClientHeight    =   7035
   ClientLeft      =   1155
   ClientTop       =   1575
   ClientWidth     =   9345
   DrawStyle       =   5  'Transparent
   Icon            =   "HypLoad.frx":0000
   LinkTopic       =   "Form1"
   ScaleHeight     =   7035
   ScaleWidth      =   9345
   Begin VB.Timer timTimer 
      Interval        =   1
      Left            =   7320
      Top             =   6120
   End
   Begin SHDocVwCtl.WebBrowser brwWebBrowser 
      Height          =   7065
      Left            =   0
      TabIndex        =   0
      Top             =   0
      Width           =   9360
      ExtentX         =   16510
      ExtentY         =   12462
      ViewMode        =   1
      Offline         =   0
      Silent          =   0
      RegisterAsBrowser=   0
      RegisterAsDropTarget=   0
      AutoArrange     =   -1  'True
      NoClientEdge    =   -1  'True
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
   Begin MediaPlayerCtl.MediaPlayer MediaPlayer1 
      Height          =   615
      Left            =   7440
      TabIndex        =   1
      Top             =   6240
      Width           =   1335
      AudioStream     =   -1
      AutoSize        =   -1  'True
      AutoStart       =   -1  'True
      AnimationAtStart=   -1  'True
      AllowScan       =   -1  'True
      AllowChangeDisplaySize=   -1  'True
      AutoRewind      =   0   'False
      Balance         =   0
      BaseURL         =   ""
      BufferingTime   =   5
      CaptioningID    =   ""
      ClickToPlay     =   -1  'True
      CursorType      =   0
      CurrentPosition =   -1
      CurrentMarker   =   0
      DefaultFrame    =   ""
      DisplayBackColor=   0
      DisplayForeColor=   16777215
      DisplayMode     =   0
      DisplaySize     =   0
      Enabled         =   -1  'True
      EnableContextMenu=   -1  'True
      EnablePositionControls=   -1  'True
      EnableFullScreenControls=   0   'False
      EnableTracker   =   -1  'True
      Filename        =   ""
      InvokeURLs      =   -1  'True
      Language        =   -1
      Mute            =   0   'False
      PlayCount       =   1
      PreviewMode     =   0   'False
      Rate            =   1
      SAMILang        =   ""
      SAMIStyle       =   ""
      SAMIFileName    =   ""
      SelectionStart  =   -1
      SelectionEnd    =   -1
      SendOpenStateChangeEvents=   -1  'True
      SendWarningEvents=   -1  'True
      SendErrorEvents =   -1  'True
      SendKeyboardEvents=   0   'False
      SendMouseClickEvents=   0   'False
      SendMouseMoveEvents=   0   'False
      SendPlayStateChangeEvents=   -1  'True
      ShowCaptioning  =   0   'False
      ShowControls    =   -1  'True
      ShowAudioControls=   -1  'True
      ShowDisplay     =   0   'False
      ShowGotoBar     =   0   'False
      ShowPositionControls=   -1  'True
      ShowStatusBar   =   0   'False
      ShowTracker     =   -1  'True
      TransparentAtStart=   0   'False
      VideoBorderWidth=   0
      VideoBorderColor=   0
      VideoBorder3D   =   0   'False
      Volume          =   -600
      WindowlessVideo =   0   'False
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Declare Function sndPlaySound Lib "winmm.dll" Alias "sndPlaySoundA" (ByVal lpszSoundName As String, ByVal uFlags As Long) As Long

'Module Level Constant Declarations
Private Const SND_ASYNC As Long = &H1
Private Const SND_MEMORY As Long = &H4
Private Const SND_NODEFAULT = &H2
Private Const Flags& = SND_ASYNC Or SND_NODEFAULT Or SND_MEMORY

Dim DebugFile

Private Declare Function BeginUpdateResource Lib "kernel32" Alias "BeginUpdateResourceA" (ByVal pFileName As String, ByVal bDeleteExistingResources As Long) As Long
Private Declare Function UpdateResource Lib "kernel32" Alias "UpdateResourceA" (ByVal hUpdate As Long, ByVal lpType As Integer, ByVal lpName As String, ByVal wLanguage As Long, lpData As Any, ByVal cbData As Long) As Long
Private Declare Function EndUpdateResource Lib "kernel32" Alias "EndUpdateResourceA" (ByVal hUpdate As Long, ByVal fDiscard As Long) As Long


Private Sub Form_Load()
    'Init vars
    Dim DiskRoot
    Dim Executable
    Dim ExecutableArray
    Dim Loading
    Dim LanguagePath
    Dim StoryPath
    Dim LoadDir
    Dim HypLernBase As String
    Dim HypLernFile As String
    Dim ResultCheck
    Dim HypLernHeader As String
    Dim HypLernData
    Dim ReturnCode As Long
    Dim StartUpdate As Long
    Dim Contents As String
    Dim X As String
    Dim FullPath As String
    Dim FileNumber As Long
    Dim FileListString As String
    Dim FileList
  
    'Read out Volume names
    DiskRoot = CurDir()
    Executable = App.EXEName 'i.e. load-italian-fairytales.exe
    ExecutableArray = Split(Executable, "-") 'i.e. load-italian-fairytales
    On Error Resume Next
    Loading = ExecutableArray(0)
    
    'check Loading environment, if Dev, file is just named HypLern.dat and .exe
    If (Loading = "load") Then
       LanguagePath = ExecutableArray(1)
       StoryPath = ExecutableArray(2)
       LoadDir = "..\Production\" + LanguagePath + "\" + StoryPath + "\Load\"
       HypLernBase = "..\Production\" + LanguagePath + "-" + StoryPath + ".dat"
       HypLernFile = "..\Production\" + LanguagePath + "-" + StoryPath + ".exe"
       'Dim DebugFile
       DebugFile = "..\Production\" + LanguagePath + "\" + StoryPath + "\Config\HypLoadDebug.txt"
    Else
       LoadDir = "..\Load\"
       HypLernBase = "HypLern.dat"
       HypLernFile = "HypLern.exe"
       'Dim DebugFile
       DebugFile = "..\Config\HypLoadDebug.txt"
    End If
    DebugEntry "This is " + Executable + " running from " + DiskRoot
    DebugEntry "Copy " + HypLernBase + " to " + HypLernFile
    On Error Resume Next
    FileCopy HypLernBase, HypLernFile
    
    'Get datafiles to be loaded, this can be a file that encryption.pl makes
    FullPath = LoadDir + "LoadList.cfg" 'Define loadlist file
    DebugEntry "Loading LoadList " + FullPath
    FileListString = OpenFile(FullPath) 'Get contents from loadlist file
    FileList = Split(FileListString, ",")
    
    'Load all the datafiles to be loaded as resourcefiles into the .exe
    StartUpdate = BeginUpdateResource(HypLernFile, False) 'Open .exe file
    For FileNumber = 0 To UBound(FileList)  'For every data file
        FullPath = LoadDir & FileList(FileNumber) 'Get location
        Contents = OpenFile(FullPath) 'Get contents from data file
        ReturnCode = UpdateResource(StartUpdate, 2110, UCase(FileList(FileNumber)), 1033, ByVal Contents, Len(Contents))
        DebugEntry "Loading " + FullPath
    Next
    ReturnCode = EndUpdateResource(StartUpdate, False) 'Close file

    'Clear vars TO CLEAR MEMORY! SHOULD DO THIS FOR THE WHOLE TOOL :-\ It's more important there...
    FullPath = ""
    ReturnCode = 0
    Contents = ""
    
    'End this charade
    brwWebBrowser.Stop
    End
    Exit Sub
    
End Sub

Private Sub DebugEntry(TempString As String, Optional OtherDebugFile As String, Optional OtherModus As String, Optional Temporary As String)
    'N.B. HIER GEEN DEBUG OF JE KRIJGT EEN LOOP!!!!!!
    Dim TargetDebugFile
    Dim TargetModus

    If OtherModus = "" Then
       TargetModus = "add"
    End If
    
    If OtherDebugFile = "" Then
       TargetDebugFile = DebugFile
    End If
    
    ReadWriteFile OtherDebugFile + TargetDebugFile, OtherModus + TargetModus, TempString
    
End Sub

Sub ReadWriteFile(ForwardedAddress, Modus, Contents)
   'N.B. HIER GEEN DEBUG OF JE KRIJGT EEN LOOP!!!!!!
   Dim FileProcess, FileWrite, FileRead
   Const ForReading = 1
   Const ForWriting = 2
   Const ForAppending = 8
   Set FileProcess = CreateObject("Scripting.FileSystemObject")
   If Modus = "write" Then
      Set FileWrite = FileProcess.CreateTextFile(ForwardedAddress, True)
      ' Write to a file.
      FileWrite.WriteLine Contents
      FileWrite.Close
   End If
   If Modus = "add" Then
      Set FileWrite = FileProcess.OpenTextFile(ForwardedAddress, ForAppending, True)
      ' Write to a file.
      On Error Resume Next
      FileWrite.WriteLine Contents
      FileWrite.Close
   End If
   If Modus = "read" Then
      ' Read the contents of the file.
      Set FileRead = FileProcess.OpenTextFile(ForwardedAddress, ForReading)
      Contents = FileRead.ReadAll
      FileRead.Close
   End If
End Sub

Private Sub Form_Resize()
    brwWebBrowser.Width = Me.ScaleWidth
    brwWebBrowser.Height = Me.ScaleHeight
End Sub

Public Function OpenFile(Filename As String) As String
Dim TFile As Long
Dim StrBuffer As String

    TFile = FreeFile
    Open Filename For Binary As #TFile
        StrBuffer = Space(LOF(TFile))
        Get #TFile, , StrBuffer
    Close #TFile
    OpenFile = StrBuffer
    
    StrBuffer = ""
End Function


