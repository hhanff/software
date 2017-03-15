VERSION 5.00
Object = "{67397AA1-7FB1-11D0-B148-00A0C922E820}#6.0#0"; "MSADODC.OCX"
Object = "{CDE57A40-8B86-11D0-B3C6-00A0C90AEA82}#1.0#0"; "MSDATGRD.OCX"
Begin VB.Form Forumlar 
   AutoRedraw      =   -1  'True
   BorderStyle     =   1  'Fest Einfach
   Caption         =   "Formular"
   ClientHeight    =   3330
   ClientLeft      =   5055
   ClientTop       =   3585
   ClientWidth     =   8655
   LinkTopic       =   "Formular"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   3330
   ScaleWidth      =   8655
   Begin MSDataGridLib.DataGrid adoData 
      Bindings        =   "frmBeispiel2.frx":0000
      DragMode        =   1  'Automatisch
      Height          =   2895
      Left            =   3960
      TabIndex        =   3
      Top             =   120
      Width           =   4335
      _ExtentX        =   7646
      _ExtentY        =   5106
      _Version        =   393216
      HeadLines       =   1
      RowHeight       =   15
      BeginProperty HeadFont {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ColumnCount     =   2
      BeginProperty Column00 
         DataField       =   ""
         Caption         =   ""
         BeginProperty DataFormat {6D835690-900B-11D0-9484-00A0C91110ED} 
            Type            =   0
            Format          =   ""
            HaveTrueFalseNull=   0
            FirstDayOfWeek  =   0
            FirstWeekOfYear =   0
            LCID            =   1031
            SubFormatType   =   0
         EndProperty
      EndProperty
      BeginProperty Column01 
         DataField       =   ""
         Caption         =   ""
         BeginProperty DataFormat {6D835690-900B-11D0-9484-00A0C91110ED} 
            Type            =   0
            Format          =   ""
            HaveTrueFalseNull=   0
            FirstDayOfWeek  =   0
            FirstWeekOfYear =   0
            LCID            =   1031
            SubFormatType   =   0
         EndProperty
      EndProperty
      SplitCount      =   1
      BeginProperty Split0 
         BeginProperty Column00 
         EndProperty
         BeginProperty Column01 
         EndProperty
      EndProperty
   End
   Begin VB.PictureBox imgFlagge 
      AutoSize        =   -1  'True
      DataField       =   "Flagge"
      DataSource      =   "adoDaten"
      Height          =   615
      Left            =   3000
      ScaleHeight     =   555
      ScaleWidth      =   795
      TabIndex        =   4
      Top             =   120
      Width           =   855
   End
   Begin MSAdodcLib.Adodc adoDaten 
      Height          =   375
      Left            =   120
      Top             =   2640
      Width           =   3735
      _ExtentX        =   6588
      _ExtentY        =   661
      ConnectMode     =   0
      CursorLocation  =   3
      IsolationLevel  =   -1
      ConnectionTimeout=   15
      CommandTimeout  =   30
      CursorType      =   3
      LockType        =   3
      CommandType     =   8
      CursorOptions   =   0
      CacheSize       =   50
      MaxRecords      =   0
      BOFAction       =   0
      EOFAction       =   0
      ConnectStringType=   2
      Appearance      =   1
      BackColor       =   -2147483643
      ForeColor       =   -2147483640
      Orientation     =   0
      Enabled         =   -1
      Connect         =   "FILE NAME=C:\Programme\Gemeinsame Dateien\System\Ole DB\Data Links\Devisen.udl"
      OLEDBString     =   ""
      OLEDBFile       =   "C:\Programme\Gemeinsame Dateien\System\Ole DB\Data Links\Devisen.udl"
      DataSourceName  =   ""
      OtherAttributes =   ""
      UserName        =   ""
      Password        =   ""
      RecordSource    =   "Select * From Devisen"
      Caption         =   "Adodc1"
      BeginProperty Font {0BE35203-8F91-11CE-9DE3-00AA004BB851} 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      _Version        =   393216
   End
   Begin VB.Label lblKurs 
      Alignment       =   2  'Zentriert
      Caption         =   "Label3"
      DataField       =   "Kurs"
      DataSource      =   "adoDaten"
      Height          =   375
      Left            =   120
      TabIndex        =   2
      Top             =   1560
      Width           =   2415
   End
   Begin VB.Label lblISOKürzel 
      Alignment       =   2  'Zentriert
      Caption         =   "Label2"
      DataField       =   "ISO"
      DataSource      =   "adoDaten"
      Height          =   495
      Left            =   120
      TabIndex        =   1
      Top             =   840
      Width           =   2415
   End
   Begin VB.Label lblDevisenname 
      Alignment       =   2  'Zentriert
      Caption         =   "Label1"
      DataField       =   "Devisenname"
      DataSource      =   "adoDaten"
      Height          =   375
      Left            =   240
      TabIndex        =   0
      Top             =   240
      Width           =   2295
   End
End
Attribute VB_Name = "Forumlar"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub Label3_Click()

End Sub

Private Sub Drive1_Change()

End Sub

Private Sub lblKurs_Click()

End Sub
