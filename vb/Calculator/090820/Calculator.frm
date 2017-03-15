VERSION 5.00
Begin VB.Form frmMain 
   BorderStyle     =   1  'Fest Einfach
   Caption         =   "Calculator"
   ClientHeight    =   4095
   ClientLeft      =   45
   ClientTop       =   345
   ClientWidth     =   11475
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   4095
   ScaleWidth      =   11475
   StartUpPosition =   3  'Windows-Standard
   Begin VB.CommandButton cmdClear 
      Caption         =   "Clear"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   13.5
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   2655
      Left            =   4440
      TabIndex        =   17
      Top             =   1200
      Width           =   855
   End
   Begin VB.CommandButton cmdEnter 
      Caption         =   "="
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   13.5
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   3615
      Left            =   10440
      TabIndex        =   16
      Top             =   240
      Width           =   975
   End
   Begin VB.CommandButton cmdDivide 
      Caption         =   "/"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   13.5
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   735
      Left            =   9240
      TabIndex        =   15
      Top             =   3120
      Width           =   975
   End
   Begin VB.CommandButton cmdMultiply 
      Caption         =   "*"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   13.5
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   735
      Left            =   9240
      TabIndex        =   14
      Top             =   2160
      Width           =   975
   End
   Begin VB.CommandButton cmdMinus 
      Caption         =   "-"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   13.5
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   735
      Left            =   9240
      TabIndex        =   13
      Top             =   1200
      Width           =   975
   End
   Begin VB.CommandButton cmdPlus 
      Caption         =   "+"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   13.5
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   735
      Left            =   9240
      TabIndex        =   12
      Top             =   240
      Width           =   975
   End
   Begin VB.CommandButton cmdDot 
      Caption         =   ","
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   13.5
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   735
      Left            =   8040
      TabIndex        =   11
      Top             =   3120
      Width           =   975
   End
   Begin VB.CommandButton cmdNull 
      Caption         =   "0"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   13.5
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   735
      Left            =   5640
      TabIndex        =   10
      Top             =   3120
      Width           =   2175
   End
   Begin VB.CommandButton cmdNine 
      Caption         =   "9"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   13.5
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   735
      Left            =   8040
      TabIndex        =   9
      Top             =   240
      Width           =   975
   End
   Begin VB.CommandButton cmdEight 
      Caption         =   "8"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   13.5
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   735
      Left            =   6840
      TabIndex        =   8
      Top             =   240
      Width           =   975
   End
   Begin VB.CommandButton cmdSeven 
      Caption         =   "7"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   13.5
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   735
      Left            =   5640
      TabIndex        =   7
      Top             =   240
      Width           =   975
   End
   Begin VB.CommandButton cmdSix 
      Caption         =   "6"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   13.5
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   735
      Left            =   8040
      TabIndex        =   6
      Top             =   1200
      Width           =   975
   End
   Begin VB.CommandButton cmdFive 
      Caption         =   "5"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   13.5
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   735
      Left            =   6840
      TabIndex        =   5
      Top             =   1200
      Width           =   975
   End
   Begin VB.CommandButton cmdFour 
      Caption         =   "4"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   13.5
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   735
      Left            =   5640
      TabIndex        =   4
      Top             =   1200
      Width           =   975
   End
   Begin VB.CommandButton cmdThree 
      Caption         =   "3"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   13.5
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   735
      Left            =   8040
      TabIndex        =   3
      Top             =   2160
      Width           =   975
   End
   Begin VB.CommandButton cmdTwo 
      Caption         =   "2"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   13.5
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   735
      Left            =   6840
      TabIndex        =   2
      Top             =   2160
      Width           =   975
   End
   Begin VB.CommandButton cmdOne 
      Caption         =   "1"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   13.5
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   735
      Left            =   5640
      TabIndex        =   1
      Top             =   2160
      Width           =   975
   End
   Begin VB.Label lblOutput 
      BackColor       =   &H00FFFFFF&
      BeginProperty DataFormat 
         Type            =   1
         Format          =   "0"
         HaveTrueFalseNull=   0
         FirstDayOfWeek  =   0
         FirstWeekOfYear =   0
         LCID            =   1031
         SubFormatType   =   1
      EndProperty
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   13.5
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   735
      Left            =   240
      TabIndex        =   0
      Top             =   240
      Width           =   5055
   End
End
Attribute VB_Name = "frmMain"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
' No support for comma separated numbers
' Only basic opperations supported
' No possibility to temporarily store solutions
' Variables are strings and not integers
' No possibility to enter values by Keyboard
Private var1 As String
Private var2 As String
Private var3 As String
Private Plus As String
Private Minus As String
Private Multiply As String
Private Divide As String
Private Comma As String
Private Equals As String


Private Sub Form_Load()
lblOutput.Caption = "0"
var1 = ""
var2 = ""
var3 = ""
Plus = "False"
Minus = "False"
Multiply = "False"
Divide = "False"
Comma = "False"
Equals = "False"
End Sub

Private Sub cmdDot_Click()
  If Plus = "False" And Minus = "False" And Multiply = "False" And Divide = "False" And var3 = "" Then
    var1 = var1 & "."
    lblOutput.Caption = var1
  ElseIf var3 <> "" Then
    var1 = var3
    var2 = var2 & "."
    lblOutput.Caption = var2
  Else
    var2 = var2 & "."
    lblOutput.Caption = var2
  End If

End Sub

Private Sub cmdNull_Click()
  If Plus = "False" And Minus = "False" And Multiply = "False" And Divide = "False" And var3 = "" Then
    var1 = var1 & "0"
    lblOutput.Caption = var1
  ElseIf var3 <> "" Then
    var1 = var3
    var2 = var2 & "0"
    lblOutput.Caption = var2
  Else
    var2 = var2 & "0"
    lblOutput.Caption = var2
  End If
End Sub

Private Sub cmdOne_Click()
  If Plus = "False" And Minus = "False" And Multiply = "False" And Divide = "False" And var3 = "" Then
    var1 = var1 & "1"
    lblOutput.Caption = var1
  ElseIf var3 <> "" Then
    var1 = var3
    var2 = var2 & "1"
    lblOutput.Caption = var2
  Else
    var2 = var2 & "1"
    lblOutput.Caption = var2
  End If
    
End Sub

Private Sub cmdTwo_Click()
  If Plus = "False" And Minus = "False" And Multiply = "False" And Divide = "False" And var3 = "" Then
    var1 = var1 & "2"
    lblOutput.Caption = var1
  ElseIf var3 <> "" Then
    var1 = var3
    var2 = var2 & "2"
    lblOutput.Caption = var2
  Else
    var2 = var2 & "2"
    lblOutput.Caption = var2
  End If
    
End Sub

Private Sub cmdThree_Click()
  If Plus = "False" And Minus = "False" And Multiply = "False" And Divide = "False" And var3 = "" Then
    var1 = var1 & "3"
    lblOutput.Caption = var1
  ElseIf var3 <> "" Then
    var1 = var3
    var2 = var2 & "3"
    lblOutput.Caption = var2
  Else
    var2 = var2 & "3"
    lblOutput.Caption = var2
  End If
    
End Sub

Private Sub cmdFour_Click()
  If Plus = "False" And Minus = "False" And Multiply = "False" And Divide = "False" And var3 = "" Then
    var1 = var1 & "4"
    lblOutput.Caption = var1
  ElseIf var3 <> "" Then
    var1 = var3
    var2 = var2 & "4"
    lblOutput.Caption = var2
  Else
    var2 = var2 & "4"
    lblOutput.Caption = var2
  End If
    
End Sub

Private Sub cmdFive_Click()
  If Plus = "False" And Minus = "False" And Multiply = "False" And Divide = "False" And var3 = "" Then
    var1 = var1 & "5"
    lblOutput.Caption = var1
  ElseIf var3 <> "" Then
    var1 = var3
    var2 = var2 & "5"
    lblOutput.Caption = var2
  Else
    var2 = var2 & "5"
    lblOutput.Caption = var2
  End If
    
End Sub

Private Sub cmdSix_Click()
  If Plus = "False" And Minus = "False" And Multiply = "False" And Divide = "False" And var3 = "" Then
    var1 = var1 & "6"
    lblOutput.Caption = var1
  ElseIf var3 <> "" Then
    var1 = var3
    var2 = var2 & "6"
    lblOutput.Caption = var2
  Else
    var2 = var2 & "6"
    lblOutput.Caption = var2
  End If
    
End Sub

Private Sub cmdSeven_Click()
  If Plus = "False" And Minus = "False" And Multiply = "False" And Divide = "False" And var3 = "" Then
    var1 = var1 & "7"
    lblOutput.Caption = var1
  ElseIf var3 <> "" Then
    var1 = var3
    var2 = var2 & "7"
    lblOutput.Caption = var2
  Else
    var2 = var2 & "7"
    lblOutput.Caption = var2
  End If
    
End Sub

Private Sub cmdEight_Click()
  If Plus = "False" And Minus = "False" And Multiply = "False" And Divide = "False" And var3 = "" Then
    var1 = var1 & "8"
    lblOutput.Caption = var1
  ElseIf var3 <> "" Then
    var1 = var3
    var2 = var2 & "8"
    lblOutput.Caption = var2
  Else
    var2 = var2 & "8"
    lblOutput.Caption = var2
  End If
    
End Sub

Private Sub cmdNine_Click()
  If Plus = "False" And Minus = "False" And Multiply = "False" And Divide = "False" And var3 = "" Then
    var1 = var1 & "9"
    lblOutput.Caption = var1
  ElseIf var3 <> "" Then
    var1 = var3
    var2 = var2 & "9"
    lblOutput.Caption = var2
  Else
    var2 = var2 & "9"
    lblOutput.Caption = var2
  End If
    
End Sub

Private Sub cmdPlus_Click()
  Plus = "True"
End Sub

Private Sub cmdMinus_Click()
  Minus = "True"
End Sub

Private Sub cmdMultiply_Click()
  Multiply = "True"
End Sub

Private Sub cmdDivide_Click()
  Divide = "True"
End Sub

Private Sub cmdEnter_Click()
  If Plus = "True" Then
    lblOutput.Caption = CStr(CDbl(Val(var1)) + CDbl(Val(var2)))
  ElseIf Minus = "True" Then
    lblOutput.Caption = CStr(CDbl(Val(var1)) - CDbl(Val(var2)))
  ElseIf Multiply = "True" Then
    lblOutput.Caption = CStr(CDbl(Val(var1)) * CDbl(Val(var2)))
  ElseIf Divide = "True" Then
    lblOutput.Caption = CStr(CDbl(Val(var1)) / CDbl(Val(var2)))
  End If
  
  var3 = lblOutput.Caption
  var2 = ""
  Plus = "False"
  Minus = "False"
  Multiply = "False"
  Divide = "False"
  Comma = "False"
  Equals = "False"
  
  


End Sub

Private Sub cmdClear_Click()
  Form_Load
End Sub

