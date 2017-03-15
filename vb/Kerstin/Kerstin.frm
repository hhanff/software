VERSION 5.00
Begin VB.Form frmMemory 
   BorderStyle     =   1  'Fest Einfach
   Caption         =   "Kerstin's Proggi"
   ClientHeight    =   12540
   ClientLeft      =   45
   ClientTop       =   345
   ClientWidth     =   11595
   ForeColor       =   &H80000006&
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   12540
   ScaleWidth      =   11595
   StartUpPosition =   3  'Windows-Standard
   Begin VB.CommandButton cmdFocus 
      Height          =   195
      Left            =   11760
      TabIndex        =   22
      TabStop         =   0   'False
      Top             =   0
      Width           =   135
   End
   Begin VB.CommandButton cmd20 
      Caption         =   "20"
      Height          =   1815
      Left            =   8760
      TabIndex        =   19
      Top             =   8880
      Width           =   2535
   End
   Begin VB.CommandButton cmd19 
      Caption         =   "19"
      Height          =   1815
      Left            =   6000
      TabIndex        =   18
      Top             =   8880
      Width           =   2535
   End
   Begin VB.CommandButton cmd18 
      Caption         =   "18"
      Height          =   1815
      Left            =   3120
      TabIndex        =   17
      Top             =   8880
      Width           =   2535
   End
   Begin VB.CommandButton cmd17 
      Caption         =   "17"
      Height          =   1815
      Left            =   240
      TabIndex        =   16
      Top             =   8880
      Width           =   2535
   End
   Begin VB.CommandButton cmd16 
      Caption         =   "16"
      Height          =   1815
      Left            =   8760
      TabIndex        =   15
      Top             =   6720
      Width           =   2535
   End
   Begin VB.CommandButton cmd15 
      Caption         =   "15"
      Height          =   1815
      Left            =   6000
      TabIndex        =   14
      Top             =   6720
      Width           =   2535
   End
   Begin VB.CommandButton cmd14 
      Caption         =   "14"
      Height          =   1815
      Left            =   3120
      TabIndex        =   13
      Top             =   6720
      Width           =   2535
   End
   Begin VB.CommandButton cmd13 
      Caption         =   "13"
      Height          =   1815
      Left            =   240
      TabIndex        =   12
      Top             =   6720
      Width           =   2535
   End
   Begin VB.CommandButton cmd12 
      Caption         =   "12"
      Height          =   1815
      Left            =   8760
      TabIndex        =   11
      Top             =   4560
      Width           =   2535
   End
   Begin VB.CommandButton cmd11 
      Caption         =   "11"
      Height          =   1815
      Left            =   6000
      TabIndex        =   10
      Top             =   4560
      Width           =   2535
   End
   Begin VB.CommandButton cmd10 
      Caption         =   "10"
      Height          =   1815
      Left            =   3120
      TabIndex        =   9
      Top             =   4560
      Width           =   2535
   End
   Begin VB.CommandButton cmd09 
      Caption         =   "9"
      Height          =   1815
      Left            =   240
      Picture         =   "Kerstin.frx":0000
      TabIndex        =   8
      Top             =   4560
      Width           =   2535
   End
   Begin VB.CommandButton cmd08 
      Caption         =   "8"
      Height          =   1815
      Left            =   8760
      TabIndex        =   7
      Top             =   2400
      Width           =   2535
   End
   Begin VB.CommandButton cmd07 
      Caption         =   "7"
      Height          =   1815
      Left            =   6000
      TabIndex        =   6
      Top             =   2400
      Width           =   2535
   End
   Begin VB.CommandButton cmdNewGame 
      Caption         =   "&Neues Spiel"
      Height          =   615
      Left            =   240
      TabIndex        =   20
      Top             =   10920
      Width           =   11055
   End
   Begin VB.CommandButton cmd06 
      Caption         =   "6"
      Height          =   1815
      Left            =   3120
      TabIndex        =   5
      Top             =   2400
      Width           =   2535
   End
   Begin VB.CommandButton cmd05 
      Caption         =   "5"
      Height          =   1815
      Left            =   240
      TabIndex        =   4
      Top             =   2400
      Width           =   2535
   End
   Begin VB.CommandButton cmd03 
      Caption         =   "3"
      Height          =   1815
      Left            =   6000
      TabIndex        =   2
      Top             =   240
      Width           =   2535
   End
   Begin VB.CommandButton cmd04 
      Caption         =   "4"
      Height          =   1815
      Left            =   8760
      TabIndex        =   3
      Top             =   240
      Width           =   2535
   End
   Begin VB.CommandButton cmd02 
      Caption         =   "2"
      Height          =   1815
      Left            =   3120
      TabIndex        =   1
      Top             =   240
      Width           =   2535
   End
   Begin VB.CommandButton cmd01 
      Caption         =   "1"
      Height          =   1815
      Left            =   240
      TabIndex        =   0
      Top             =   240
      Width           =   2535
   End
   Begin VB.Label lblDebug2 
      Height          =   855
      Left            =   1560
      TabIndex        =   23
      Top             =   11520
      Visible         =   0   'False
      Width           =   1095
   End
   Begin VB.Label lblDebug1 
      Height          =   615
      Left            =   240
      TabIndex        =   21
      Top             =   11640
      Visible         =   0   'False
      Width           =   975
   End
   Begin VB.Image imgKH20 
      Height          =   1815
      Left            =   8760
      Picture         =   "Kerstin.frx":C337
      Stretch         =   -1  'True
      Top             =   8880
      Width           =   2535
   End
   Begin VB.Image imgKH19 
      Height          =   1815
      Left            =   6000
      Picture         =   "Kerstin.frx":FECD
      Stretch         =   -1  'True
      Top             =   8880
      Width           =   2535
   End
   Begin VB.Image imgKH18 
      Height          =   1815
      Left            =   3120
      Picture         =   "Kerstin.frx":13A63
      Stretch         =   -1  'True
      Top             =   8880
      Width           =   2535
   End
   Begin VB.Image imgKH17 
      Height          =   1815
      Left            =   240
      Picture         =   "Kerstin.frx":E5DEF
      Stretch         =   -1  'True
      Top             =   8880
      Width           =   2535
   End
   Begin VB.Image imgKH16 
      Height          =   1815
      Left            =   8760
      Picture         =   "Kerstin.frx":1B817B
      Stretch         =   -1  'True
      Top             =   6720
      Width           =   2535
   End
   Begin VB.Image imgKH15 
      Height          =   1815
      Left            =   6000
      Picture         =   "Kerstin.frx":1C0F31
      Stretch         =   -1  'True
      Top             =   6720
      Width           =   2535
   End
   Begin VB.Image imgKH14 
      Height          =   1815
      Left            =   3120
      Picture         =   "Kerstin.frx":1C9CE7
      Stretch         =   -1  'True
      Top             =   6720
      Width           =   2535
   End
   Begin VB.Image imgKH13 
      Height          =   1815
      Left            =   240
      Picture         =   "Kerstin.frx":1D0DFF
      Stretch         =   -1  'True
      Top             =   6720
      Width           =   2535
   End
   Begin VB.Image imgKH12 
      Height          =   1815
      Left            =   8760
      Picture         =   "Kerstin.frx":1D7F17
      Stretch         =   -1  'True
      Top             =   4560
      Width           =   2535
   End
   Begin VB.Image imgKH11 
      Height          =   1815
      Left            =   6000
      Picture         =   "Kerstin.frx":1DFCE5
      Stretch         =   -1  'True
      Top             =   4560
      Width           =   2535
   End
   Begin VB.Image imgKH10 
      Height          =   1815
      Left            =   3120
      Picture         =   "Kerstin.frx":1E7AB3
      Stretch         =   -1  'True
      Top             =   4560
      Width           =   2535
   End
   Begin VB.Image imgKH9 
      Height          =   1815
      Left            =   240
      Picture         =   "Kerstin.frx":1F3DEA
      Stretch         =   -1  'True
      Top             =   4560
      Width           =   2535
   End
   Begin VB.Image imgKH8 
      Appearance      =   0  '2D
      Height          =   1815
      Left            =   8760
      Picture         =   "Kerstin.frx":2C6176
      Stretch         =   -1  'True
      Top             =   2400
      Width           =   2535
   End
   Begin VB.Image imgKH7 
      Height          =   1815
      Left            =   6000
      Picture         =   "Kerstin.frx":2E05B2
      Stretch         =   -1  'True
      Top             =   2400
      Width           =   2535
   End
   Begin VB.Image imgKH6 
      Height          =   1815
      Left            =   3120
      Picture         =   "Kerstin.frx":2FA9EE
      Stretch         =   -1  'True
      Top             =   2400
      Width           =   2535
   End
   Begin VB.Image imgKH5 
      Height          =   1815
      Left            =   240
      Picture         =   "Kerstin.frx":35CC32
      Stretch         =   -1  'True
      Top             =   2400
      Width           =   2535
   End
   Begin VB.Image imgKH4 
      Height          =   1770
      Left            =   8760
      Picture         =   "Kerstin.frx":3BEE76
      Stretch         =   -1  'True
      Top             =   240
      Width           =   2535
   End
   Begin VB.Image imgKH3 
      Height          =   1770
      Left            =   6000
      Picture         =   "Kerstin.frx":3C55F9
      Stretch         =   -1  'True
      Top             =   240
      Width           =   2535
   End
   Begin VB.Image imgKH2 
      Height          =   1815
      Left            =   3120
      Picture         =   "Kerstin.frx":3CBD7C
      Stretch         =   -1  'True
      Top             =   240
      Width           =   2520
   End
   Begin VB.Image imgKH1 
      Appearance      =   0  '2D
      Enabled         =   0   'False
      Height          =   1815
      Left            =   240
      Picture         =   "Kerstin.frx":3CC86A
      Stretch         =   -1  'True
      Top             =   240
      Width           =   2520
   End
End
Attribute VB_Name = "frmMemory"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
Dim Timer_Value As Integer
Dim old_value As Integer

Const left1 As Integer = 240
Const left2 As Integer = 3120
Const left3 As Integer = 6000
Const left4 As Integer = 8760

Const top1 As Integer = 240
Const top2 As Integer = 2400
Const top3 As Integer = 4560
Const top4 As Integer = 6720
Const top5 As Integer = 8880

Dim Pair_01, Pair_03, Pair_05, Pair_07, Pair_09, Pair_11, Pair_13, Pair_15, Pair_17, Pair_19, Pair_False As Boolean

Private Sub cmd01_Click()
  cmdFocus.SetFocus
  If Pair_False = True Then
    MakeImgsInvisible
    CheckIfVisible
    Pair_False = False
  End If
  cmd01.Visible = False
  If cmd02.Visible = False Then   ' Invisible
    Pair_01 = True
  ElseIf (((cmd03.Visible = False Or cmd04.Visible = False) And Pair_03 = False) Or ((cmd05.Visible = False Or cmd06.Visible = False) And Pair_05 = False) Or ((cmd07.Visible = False Or cmd08.Visible = False) And Pair_07 = False) Or ((cmd09.Visible = False Or cmd10.Visible = False) And Pair_09 = False) Or ((cmd11.Visible = False Or cmd12.Visible = False) And Pair_11 = False) Or ((cmd13.Visible = False Or cmd14.Visible = False) And Pair_13 = False) Or ((cmd15.Visible = False Or cmd16.Visible = False) And Pair_15 = False) Or ((cmd17.Visible = False Or cmd18.Visible = False) And Pair_17 = False) Or ((cmd19.Visible = False Or cmd20.Visible = False) And Pair_19 = False)) Then
    Pair_False = True
  Else
  End If
    
End Sub

Private Sub cmd02_Click()
  cmdFocus.SetFocus
  If Pair_False = True Then
    MakeImgsInvisible
    CheckIfVisible
    Pair_False = False
  End If
  cmd02.Visible = False
  If cmd01.Visible = False Then ' Invisible
    Pair_01 = True
  ElseIf (((cmd03.Visible = False Or cmd04.Visible = False) And Pair_03 = False) Or ((cmd05.Visible = False Or cmd06.Visible = False) And Pair_05 = False) Or ((cmd07.Visible = False Or cmd08.Visible = False) And Pair_07 = False) Or ((cmd09.Visible = False Or cmd10.Visible = False) And Pair_09 = False) Or ((cmd11.Visible = False Or cmd12.Visible = False) And Pair_11 = False) Or ((cmd13.Visible = False Or cmd14.Visible = False) And Pair_13 = False) Or ((cmd15.Visible = False Or cmd16.Visible = False) And Pair_15 = False) Or ((cmd17.Visible = False Or cmd18.Visible = False) And Pair_17 = False) Or ((cmd19.Visible = False Or cmd20.Visible = False) And Pair_19 = False)) Then
    Pair_False = True
  Else
  End If
  
  
End Sub

Private Sub cmd03_Click()
  cmdFocus.SetFocus
  If Pair_False = True Then
    MakeImgsInvisible
    CheckIfVisible
    Pair_False = False
  End If
  cmd03.Visible = False
  If cmd04.Visible = False Then ' Invisible
    Pair_03 = True
  ElseIf (((cmd01.Visible = False Or cmd02.Visible = False) And Pair_01 = False) Or ((cmd05.Visible = False Or cmd06.Visible = False) And Pair_05 = False) Or ((cmd07.Visible = False Or cmd08.Visible = False) And Pair_07 = False) Or ((cmd09.Visible = False Or cmd10.Visible = False) And Pair_09 = False) Or ((cmd11.Visible = False Or cmd12.Visible = False) And Pair_11 = False) Or ((cmd13.Visible = False Or cmd14.Visible = False) And Pair_13 = False) Or ((cmd15.Visible = False Or cmd16.Visible = False) And Pair_15 = False) Or ((cmd17.Visible = False Or cmd18.Visible = False) And Pair_17 = False) Or ((cmd19.Visible = False Or cmd20.Visible = False) And Pair_19 = False)) Then
    Pair_False = True
  Else
  End If
 
End Sub

Private Sub cmd04_Click()
  cmdFocus.SetFocus
  If Pair_False = True Then
    MakeImgsInvisible
    CheckIfVisible
    Pair_False = False
  End If
  cmd04.Visible = False
  If cmd03.Visible = False Then ' Invisible
    Pair_03 = True
  ElseIf (((cmd01.Visible = False Or cmd02.Visible = False) And Pair_01 = False) Or ((cmd05.Visible = False Or cmd06.Visible = False) And Pair_05 = False) Or ((cmd07.Visible = False Or cmd08.Visible = False) And Pair_07 = False) Or ((cmd09.Visible = False Or cmd10.Visible = False) And Pair_09 = False) Or ((cmd11.Visible = False Or cmd12.Visible = False) And Pair_11 = False) Or ((cmd13.Visible = False Or cmd14.Visible = False) And Pair_13 = False) Or ((cmd15.Visible = False Or cmd16.Visible = False) And Pair_15 = False) Or ((cmd17.Visible = False Or cmd18.Visible = False) And Pair_17 = False) Or ((cmd19.Visible = False Or cmd20.Visible = False) And Pair_19 = False)) Then
    Pair_False = True
  Else
  End If
 
End Sub
Private Sub cmd05_Click()
  cmdFocus.SetFocus
  If Pair_False = True Then
    MakeImgsInvisible
    CheckIfVisible
    Pair_False = False
  End If
  cmd05.Visible = False
  If cmd06.Visible = False Then ' Invisible
    Pair_05 = True
  ElseIf (((cmd01.Visible = False Or cmd02.Visible = False) And Pair_01 = False) Or ((cmd03.Visible = False Or cmd04.Visible = False) And Pair_03 = False) Or ((cmd07.Visible = False Or cmd08.Visible = False) And Pair_07 = False) Or ((cmd09.Visible = False Or cmd10.Visible = False) And Pair_09 = False) Or ((cmd11.Visible = False Or cmd12.Visible = False) And Pair_11 = False) Or ((cmd13.Visible = False Or cmd14.Visible = False) And Pair_13 = False) Or ((cmd15.Visible = False Or cmd16.Visible = False) And Pair_15 = False) Or ((cmd17.Visible = False Or cmd18.Visible = False) And Pair_17 = False) Or ((cmd19.Visible = False Or cmd20.Visible = False) And Pair_19 = False)) Then
    Pair_False = True
  Else
  End If
 
End Sub

Private Sub cmd06_Click()
  cmdFocus.SetFocus
  If Pair_False = True Then
    MakeImgsInvisible
    CheckIfVisible
    Pair_False = False
  End If
  cmd06.Visible = False
  If cmd05.Visible = False Then ' Invisible
    Pair_05 = True
  ElseIf (((cmd01.Visible = False Or cmd02.Visible = False) And Pair_01 = False) Or ((cmd03.Visible = False Or cmd04.Visible = False) And Pair_03 = False) Or ((cmd07.Visible = False Or cmd08.Visible = False) And Pair_07 = False) Or ((cmd09.Visible = False Or cmd10.Visible = False) And Pair_09 = False) Or ((cmd11.Visible = False Or cmd12.Visible = False) And Pair_11 = False) Or ((cmd13.Visible = False Or cmd14.Visible = False) And Pair_13 = False) Or ((cmd15.Visible = False Or cmd16.Visible = False) And Pair_15 = False) Or ((cmd17.Visible = False Or cmd18.Visible = False) And Pair_17 = False) Or ((cmd19.Visible = False Or cmd20.Visible = False) And Pair_19 = False)) Then
    Pair_False = True
  Else
  End If
End Sub

Private Sub cmd07_Click()
  cmdFocus.SetFocus
  If Pair_False = True Then
    MakeImgsInvisible
    CheckIfVisible
    Pair_False = False
  End If
  cmd07.Visible = False
  If cmd08.Visible = False Then ' Invisible
    Pair_07 = True
  ElseIf (((cmd01.Visible = False Or cmd02.Visible = False) And Pair_01 = False) Or ((cmd03.Visible = False Or cmd04.Visible = False) And Pair_03 = False) Or ((cmd05.Visible = False Or cmd06.Visible = False) And Pair_05 = False) Or ((cmd09.Visible = False Or cmd10.Visible = False) And Pair_09 = False) Or ((cmd11.Visible = False Or cmd12.Visible = False) And Pair_11 = False) Or ((cmd13.Visible = False Or cmd14.Visible = False) And Pair_13 = False) Or ((cmd15.Visible = False Or cmd16.Visible = False) And Pair_15 = False) Or ((cmd17.Visible = False Or cmd18.Visible = False) And Pair_17 = False) Or ((cmd19.Visible = False Or cmd20.Visible = False) And Pair_19 = False)) Then
    Pair_False = True
  Else
  End If
End Sub

Private Sub cmd08_Click()
  cmdFocus.SetFocus
  If Pair_False = True Then
    MakeImgsInvisible
    CheckIfVisible
    Pair_False = False
  End If
  cmd08.Visible = False
  If cmd07.Visible = False Then ' Invisible
    Pair_07 = True
  ElseIf (((cmd01.Visible = False Or cmd02.Visible = False) And Pair_01 = False) Or ((cmd03.Visible = False Or cmd04.Visible = False) And Pair_03 = False) Or ((cmd05.Visible = False Or cmd06.Visible = False) And Pair_05 = False) Or ((cmd09.Visible = False Or cmd10.Visible = False) And Pair_09 = False) Or ((cmd11.Visible = False Or cmd12.Visible = False) And Pair_11 = False) Or ((cmd13.Visible = False Or cmd14.Visible = False) And Pair_13 = False) Or ((cmd15.Visible = False Or cmd16.Visible = False) And Pair_15 = False) Or ((cmd17.Visible = False Or cmd18.Visible = False) And Pair_17 = False) Or ((cmd19.Visible = False Or cmd20.Visible = False) And Pair_19 = False)) Then
    Pair_False = True
  Else
  End If
End Sub


Private Sub cmd09_Click()
  cmdFocus.SetFocus
  If Pair_False = True Then
    MakeImgsInvisible
    CheckIfVisible
    Pair_False = False
  End If
  cmd09.Visible = False
  If cmd10.Visible = False Then ' Invisible
    Pair_09 = True
  ElseIf (((cmd01.Visible = False Or cmd02.Visible = False) And Pair_01 = False) Or ((cmd03.Visible = False Or cmd04.Visible = False) And Pair_03 = False) Or ((cmd05.Visible = False Or cmd06.Visible = False) And Pair_05 = False) Or ((cmd07.Visible = False Or cmd08.Visible = False) And Pair_07 = False) Or ((cmd11.Visible = False Or cmd12.Visible = False) And Pair_11 = False) Or ((cmd13.Visible = False Or cmd14.Visible = False) And Pair_13 = False) Or ((cmd15.Visible = False Or cmd16.Visible = False) And Pair_15 = False) Or ((cmd17.Visible = False Or cmd18.Visible = False) And Pair_17 = False) Or ((cmd19.Visible = False Or cmd20.Visible = False) And Pair_19 = False)) Then
    Pair_False = True
  Else
  End If
End Sub


Private Sub cmd10_Click()
  cmdFocus.SetFocus
  If Pair_False = True Then
    MakeImgsInvisible
    CheckIfVisible
    Pair_False = False
  End If
  cmd10.Visible = False
  If cmd09.Visible = False Then ' Invisible
    Pair_09 = True
  ElseIf (((cmd01.Visible = False Or cmd02.Visible = False) And Pair_01 = False) Or ((cmd03.Visible = False Or cmd04.Visible = False) And Pair_03 = False) Or ((cmd05.Visible = False Or cmd06.Visible = False) And Pair_05 = False) Or ((cmd07.Visible = False Or cmd08.Visible = False) And Pair_07 = False) Or ((cmd11.Visible = False Or cmd12.Visible = False) And Pair_11 = False) Or ((cmd13.Visible = False Or cmd14.Visible = False) And Pair_13 = False) Or ((cmd15.Visible = False Or cmd16.Visible = False) And Pair_15 = False) Or ((cmd17.Visible = False Or cmd18.Visible = False) And Pair_17 = False) Or ((cmd19.Visible = False Or cmd20.Visible = False) And Pair_19 = False)) Then
    Pair_False = True
  Else
  End If
End Sub


Private Sub cmd11_Click()
  cmdFocus.SetFocus
  If Pair_False = True Then
    MakeImgsInvisible
    CheckIfVisible
    Pair_False = False
  End If
  cmd11.Visible = False
  If cmd12.Visible = False Then ' Invisible
    Pair_11 = True
  ElseIf (((cmd01.Visible = False Or cmd02.Visible = False) And Pair_01 = False) Or ((cmd03.Visible = False Or cmd04.Visible = False) And Pair_03 = False) Or ((cmd05.Visible = False Or cmd06.Visible = False) And Pair_05 = False) Or ((cmd07.Visible = False Or cmd08.Visible = False) And Pair_07 = False) Or ((cmd09.Visible = False Or cmd10.Visible = False) And Pair_09 = False) Or ((cmd13.Visible = False Or cmd14.Visible = False) And Pair_13 = False) Or ((cmd15.Visible = False Or cmd16.Visible = False) And Pair_15 = False) Or ((cmd17.Visible = False Or cmd18.Visible = False) And Pair_17 = False) Or ((cmd19.Visible = False Or cmd20.Visible = False) And Pair_19 = False)) Then
    Pair_False = True
  Else
  End If
End Sub


Private Sub cmd12_Click()
  cmdFocus.SetFocus
  If Pair_False = True Then
    MakeImgsInvisible
    CheckIfVisible
    Pair_False = False
  End If
  cmd12.Visible = False
  If cmd11.Visible = False Then ' Invisible
    Pair_11 = True
  ElseIf (((cmd01.Visible = False Or cmd02.Visible = False) And Pair_01 = False) Or ((cmd03.Visible = False Or cmd04.Visible = False) And Pair_03 = False) Or ((cmd05.Visible = False Or cmd06.Visible = False) And Pair_05 = False) Or ((cmd07.Visible = False Or cmd08.Visible = False) And Pair_07 = False) Or ((cmd09.Visible = False Or cmd10.Visible = False) And Pair_09 = False) Or ((cmd13.Visible = False Or cmd14.Visible = False) And Pair_13 = False) Or ((cmd15.Visible = False Or cmd16.Visible = False) And Pair_15 = False) Or ((cmd17.Visible = False Or cmd18.Visible = False) And Pair_17 = False) Or ((cmd19.Visible = False Or cmd20.Visible = False) And Pair_19 = False)) Then
    Pair_False = True
  Else
  End If
End Sub


Private Sub cmd13_Click()
  cmdFocus.SetFocus
  If Pair_False = True Then
    MakeImgsInvisible
    CheckIfVisible
    Pair_False = False
  End If
  cmd13.Visible = False
  If cmd14.Visible = False Then ' Invisible
    Pair_13 = True
  ElseIf (((cmd01.Visible = False Or cmd02.Visible = False) And Pair_01 = False) Or ((cmd03.Visible = False Or cmd04.Visible = False) And Pair_03 = False) Or ((cmd05.Visible = False Or cmd06.Visible = False) And Pair_05 = False) Or ((cmd07.Visible = False Or cmd08.Visible = False) And Pair_07 = False) Or ((cmd09.Visible = False Or cmd10.Visible = False) And Pair_09 = False) Or ((cmd11.Visible = False Or cmd12.Visible = False) And Pair_11 = False) Or ((cmd15.Visible = False Or cmd16.Visible = False) And Pair_15 = False) Or ((cmd17.Visible = False Or cmd18.Visible = False) And Pair_17 = False) Or ((cmd19.Visible = False Or cmd20.Visible = False) And Pair_19 = False)) Then
    Pair_False = True
  Else
  End If
End Sub


Private Sub cmd14_Click()
  cmdFocus.SetFocus
  If Pair_False = True Then
    MakeImgsInvisible
    CheckIfVisible
    Pair_False = False
  End If
  cmd14.Visible = False
  If cmd13.Visible = False Then ' Invisible
    Pair_13 = True
  ElseIf (((cmd01.Visible = False Or cmd02.Visible = False) And Pair_01 = False) Or ((cmd03.Visible = False Or cmd04.Visible = False) And Pair_03 = False) Or ((cmd05.Visible = False Or cmd06.Visible = False) And Pair_05 = False) Or ((cmd07.Visible = False Or cmd08.Visible = False) And Pair_07 = False) Or ((cmd09.Visible = False Or cmd10.Visible = False) And Pair_09 = False) Or ((cmd11.Visible = False Or cmd12.Visible = False) And Pair_11 = False) Or ((cmd15.Visible = False Or cmd16.Visible = False) And Pair_15 = False) Or ((cmd17.Visible = False Or cmd18.Visible = False) And Pair_17 = False) Or ((cmd19.Visible = False Or cmd20.Visible = False) And Pair_19 = False)) Then
    Pair_False = True
  Else
  End If
End Sub


Private Sub cmd15_Click()
  cmdFocus.SetFocus
  If Pair_False = True Then
    MakeImgsInvisible
    CheckIfVisible
    Pair_False = False
  End If
  cmd15.Visible = False
  If cmd16.Visible = False Then ' Invisible
    Pair_15 = True
  ElseIf (((cmd01.Visible = False Or cmd02.Visible = False) And Pair_01 = False) Or ((cmd03.Visible = False Or cmd04.Visible = False) And Pair_03 = False) Or ((cmd05.Visible = False Or cmd06.Visible = False) And Pair_05 = False) Or ((cmd07.Visible = False Or cmd08.Visible = False) And Pair_07 = False) Or ((cmd09.Visible = False Or cmd10.Visible = False) And Pair_09 = False) Or ((cmd11.Visible = False Or cmd12.Visible = False) And Pair_11 = False) Or ((cmd13.Visible = False Or cmd14.Visible = False) And Pair_13 = False) Or ((cmd17.Visible = False Or cmd18.Visible = False) And Pair_17 = False) Or ((cmd19.Visible = False Or cmd20.Visible = False) And Pair_19 = False)) Then
    Pair_False = True
  Else
  End If
End Sub


Private Sub cmd16_Click()
  cmdFocus.SetFocus
  If Pair_False = True Then
    MakeImgsInvisible
    CheckIfVisible
    Pair_False = False
  End If
  cmd16.Visible = False
  If cmd15.Visible = False Then ' Invisible
    Pair_15 = True
  ElseIf (((cmd01.Visible = False Or cmd02.Visible = False) And Pair_01 = False) Or ((cmd03.Visible = False Or cmd04.Visible = False) And Pair_03 = False) Or ((cmd05.Visible = False Or cmd06.Visible = False) And Pair_05 = False) Or ((cmd07.Visible = False Or cmd08.Visible = False) And Pair_07 = False) Or ((cmd09.Visible = False Or cmd10.Visible = False) And Pair_09 = False) Or ((cmd11.Visible = False Or cmd12.Visible = False) And Pair_11 = False) Or ((cmd13.Visible = False Or cmd14.Visible = False) And Pair_13 = False) Or ((cmd17.Visible = False Or cmd18.Visible = False) And Pair_17 = False) Or ((cmd19.Visible = False Or cmd20.Visible = False) And Pair_19 = False)) Then
    Pair_False = True
  Else
  End If
End Sub


Private Sub cmd17_Click()
  cmdFocus.SetFocus
  If Pair_False = True Then
    MakeImgsInvisible
    CheckIfVisible
    Pair_False = False
  End If
  cmd17.Visible = False
  If cmd18.Visible = False Then ' Invisible
    Pair_17 = True
  ElseIf (((cmd01.Visible = False Or cmd02.Visible = False) And Pair_01 = False) Or ((cmd03.Visible = False Or cmd04.Visible = False) And Pair_03 = False) Or ((cmd05.Visible = False Or cmd06.Visible = False) And Pair_05 = False) Or ((cmd07.Visible = False Or cmd08.Visible = False) And Pair_07 = False) Or ((cmd09.Visible = False Or cmd10.Visible = False) And Pair_09 = False) Or ((cmd11.Visible = False Or cmd12.Visible = False) And Pair_11 = False) Or ((cmd13.Visible = False Or cmd14.Visible = False) And Pair_13 = False) Or ((cmd15.Visible = False Or cmd16.Visible = False) And Pair_15 = False) Or ((cmd19.Visible = False Or cmd20.Visible = False) And Pair_19 = False)) Then
    Pair_False = True
  Else
  End If
End Sub


Private Sub cmd18_Click()
  cmdFocus.SetFocus
  If Pair_False = True Then
    MakeImgsInvisible
    CheckIfVisible
    Pair_False = False
  End If
  cmd18.Visible = False
  If cmd17.Visible = False Then ' Invisible
    Pair_17 = True
  ElseIf (((cmd01.Visible = False Or cmd02.Visible = False) And Pair_01 = False) Or ((cmd03.Visible = False Or cmd04.Visible = False) And Pair_03 = False) Or ((cmd05.Visible = False Or cmd06.Visible = False) And Pair_05 = False) Or ((cmd07.Visible = False Or cmd08.Visible = False) And Pair_07 = False) Or ((cmd09.Visible = False Or cmd10.Visible = False) And Pair_09 = False) Or ((cmd11.Visible = False Or cmd12.Visible = False) And Pair_11 = False) Or ((cmd13.Visible = False Or cmd14.Visible = False) And Pair_13 = False) Or ((cmd15.Visible = False Or cmd16.Visible = False) And Pair_15 = False) Or ((cmd19.Visible = False Or cmd20.Visible = False) And Pair_19 = False)) Then
    Pair_False = True
  Else
  End If
End Sub


Private Sub cmd19_Click()
  cmdFocus.SetFocus
  If Pair_False = True Then
    MakeImgsInvisible
    CheckIfVisible
    Pair_False = False
  End If
  cmd19.Visible = False
  If cmd20.Visible = False Then ' Invisible
    Pair_19 = True
  ElseIf (((cmd01.Visible = False Or cmd02.Visible = False) And Pair_01 = False) Or ((cmd03.Visible = False Or cmd04.Visible = False) And Pair_03 = False) Or ((cmd05.Visible = False Or cmd06.Visible = False) And Pair_05 = False) Or ((cmd07.Visible = False Or cmd08.Visible = False) And Pair_07 = False) Or ((cmd09.Visible = False Or cmd10.Visible = False) And Pair_09 = False) Or ((cmd11.Visible = False Or cmd12.Visible = False) And Pair_11 = False) Or ((cmd13.Visible = False Or cmd14.Visible = False) And Pair_13 = False) Or ((cmd15.Visible = False Or cmd16.Visible = False) And Pair_15 = False) Or ((cmd17.Visible = False Or cmd18.Visible = False) And Pair_17 = False)) Then
    Pair_False = True
  Else
  End If
End Sub


Private Sub cmd20_Click()
  cmdFocus.SetFocus
  If Pair_False = True Then
    MakeImgsInvisible
    CheckIfVisible
    Pair_False = False
  End If
  cmd20.Visible = False
  If cmd19.Visible = False Then ' Invisible
    Pair_19 = True
  ElseIf (((cmd01.Visible = False Or cmd02.Visible = False) And Pair_01 = False) Or ((cmd03.Visible = False Or cmd04.Visible = False) And Pair_03 = False) Or ((cmd05.Visible = False Or cmd06.Visible = False) And Pair_05 = False) Or ((cmd07.Visible = False Or cmd08.Visible = False) And Pair_07 = False) Or ((cmd09.Visible = False Or cmd10.Visible = False) And Pair_09 = False) Or ((cmd11.Visible = False Or cmd12.Visible = False) And Pair_11 = False) Or ((cmd13.Visible = False Or cmd14.Visible = False) And Pair_13 = False) Or ((cmd15.Visible = False Or cmd16.Visible = False) And Pair_15 = False) Or ((cmd17.Visible = False Or cmd18.Visible = False) And Pair_17 = False)) Then
    Pair_False = True
  Else
  End If
End Sub


Public Function MakeImgsInvisible()

    cmd01.Visible = True
    cmd02.Visible = True
    cmd03.Visible = True
    cmd04.Visible = True
    cmd05.Visible = True
    cmd06.Visible = True
    cmd07.Visible = True
    cmd08.Visible = True
    cmd09.Visible = True
    cmd10.Visible = True
    cmd11.Visible = True
    cmd12.Visible = True
    cmd13.Visible = True
    cmd14.Visible = True
    cmd15.Visible = True
    cmd16.Visible = True
    cmd17.Visible = True
    cmd18.Visible = True
    cmd19.Visible = True
    cmd20.Visible = True

End Function

Public Function CheckIfVisible()
    If Pair_01 = True Then
      cmd01.Visible = False
      cmd02.Visible = False
    End If
    If Pair_03 = True Then
      cmd03.Visible = False
      cmd04.Visible = False
    End If
    If Pair_05 = True Then
      cmd05.Visible = False
      cmd06.Visible = False
    End If
    If Pair_07 = True Then
      cmd07.Visible = False
      cmd08.Visible = False
    End If
    If Pair_09 = True Then
      cmd09.Visible = False
      cmd10.Visible = False
    End If
    If Pair_11 = True Then
      cmd11.Visible = False
      cmd12.Visible = False
    End If
    If Pair_13 = True Then
      cmd13.Visible = False
      cmd14.Visible = False
    End If
    If Pair_15 = True Then
      cmd15.Visible = False
      cmd16.Visible = False
    End If
    If Pair_17 = True Then
      cmd17.Visible = False
      cmd18.Visible = False
    End If
    If Pair_19 = True Then
      cmd19.Visible = False
      cmd20.Visible = False
    End If

End Function


Private Sub cmdNewGame_Click()
  Form_Load
  End Sub

Private Sub Command1_Click()

End Sub

Private Sub Form_Load()
    mixPictures
    imgKH1.Picture = LoadPicture(".\pic\KH01.jpg")
    imgKH2.Picture = LoadPicture(".\pic\KH01.jpg")
    imgKH3.Picture = LoadPicture(".\pic\KH02.jpg")
    imgKH4.Picture = LoadPicture(".\pic\KH02.jpg")
    imgKH5.Picture = LoadPicture(".\pic\KH03.jpg")
    imgKH6.Picture = LoadPicture(".\pic\KH03.jpg")
    imgKH7.Picture = LoadPicture(".\pic\KH04.jpg")
    imgKH8.Picture = LoadPicture(".\pic\KH04.jpg")
    imgKH9.Picture = LoadPicture(".\pic\KH05.jpg")
    imgKH10.Picture = LoadPicture(".\pic\KH05.jpg")
    imgKH11.Picture = LoadPicture(".\pic\KH06.jpg")
    imgKH12.Picture = LoadPicture(".\pic\KH06.jpg")
    imgKH13.Picture = LoadPicture(".\pic\KH07.jpg")
    imgKH14.Picture = LoadPicture(".\pic\KH07.jpg")
    imgKH15.Picture = LoadPicture(".\pic\KH08.jpg")
    imgKH16.Picture = LoadPicture(".\pic\KH08.jpg")
    imgKH17.Picture = LoadPicture(".\pic\KH09.jpg")
    imgKH18.Picture = LoadPicture(".\pic\KH09.jpg")
    imgKH19.Picture = LoadPicture(".\pic\KH10.jpg")
    imgKH20.Picture = LoadPicture(".\pic\KH10.jpg")
    
    Pair_01 = False
    Pair_03 = False
    Pair_05 = False
    Pair_07 = False
    Pair_09 = False
    Pair_11 = False
    Pair_13 = False
    Pair_15 = False
    Pair_17 = False
    Pair_19 = False
    Pair_False = False
    cmd01.Visible = True
    cmd02.Visible = True
    cmd03.Visible = True
    cmd04.Visible = True
    cmd05.Visible = True
    cmd06.Visible = True
    cmd07.Visible = True
    cmd08.Visible = True
    cmd09.Visible = True
    cmd10.Visible = True
    cmd11.Visible = True
    cmd12.Visible = True
    cmd13.Visible = True
    cmd14.Visible = True
    cmd15.Visible = True
    cmd16.Visible = True
    cmd17.Visible = True
    cmd18.Visible = True
    cmd19.Visible = True
    cmd20.Visible = True

    cmd01.Caption = ""
    cmd02.Caption = ""
    cmd03.Caption = ""
    cmd04.Caption = ""
    cmd05.Caption = ""
    cmd06.Caption = ""
    cmd07.Caption = ""
    cmd08.Caption = ""
    cmd09.Caption = ""
    cmd10.Caption = ""
    cmd11.Caption = ""
    cmd12.Caption = ""
    cmd13.Caption = ""
    cmd14.Caption = ""
    cmd15.Caption = ""
    cmd16.Caption = ""
    cmd17.Caption = ""
    cmd18.Caption = ""
    cmd19.Caption = ""
    cmd20.Caption = ""

End Sub

Private Sub mixPictures()
    cmd01.Visible = True
    cmd02.Visible = True
    cmd03.Visible = True
    cmd04.Visible = True
    cmd05.Visible = True
    cmd06.Visible = True
    cmd07.Visible = True
    cmd08.Visible = True
    cmd09.Visible = True
    cmd10.Visible = True
    cmd11.Visible = True
    cmd12.Visible = True
    cmd13.Visible = True
    cmd14.Visible = True
    cmd15.Visible = True
    cmd16.Visible = True
    cmd17.Visible = True
    cmd18.Visible = True
    cmd19.Visible = True
    cmd20.Visible = True


  ' Initialize the random-number generator.
  Randomize
  ' Generate random value between 1 and 6.
  Dim value As Integer
  value = CInt(Int((6 * Rnd()) + 1))
  'lblDebug2.Caption = old_value
  While value = old_value
    value = CInt(Int((6 * Rnd()) + 1))
  Wend
  
  old_value = value
      
  'lblDebug1.Caption = value

  If value = 1 Then
    imgKH1.Top = top1
    imgKH1.Left = left1
    cmd01.Top = top1
    cmd01.Left = left1
    
    imgKH2.Top = top1
    imgKH2.Left = left2
    cmd02.Top = top1
    cmd02.Left = left2
    
    imgKH3.Top = top1
    imgKH3.Left = left3
    cmd03.Top = top1
    cmd03.Left = left3
    
    imgKH4.Top = top1
    imgKH4.Left = left4
    cmd04.Top = top1
    cmd04.Left = left4
    
    imgKH5.Top = top2
    imgKH5.Left = left1
    cmd05.Top = top2
    cmd05.Left = left1
    
    imgKH6.Top = top2
    imgKH6.Left = left2
    cmd06.Top = top2
    cmd06.Left = left2
    
    imgKH7.Top = top2
    imgKH7.Left = left3
    cmd07.Top = top2
    cmd07.Left = left3
    
    imgKH8.Top = top2
    imgKH8.Left = left4
    cmd08.Top = top2
    cmd08.Left = left4
    
    imgKH9.Top = top3
    imgKH9.Left = left1
    cmd09.Top = top3
    cmd09.Left = left1
    
    imgKH10.Top = top3
    imgKH10.Left = left2
    cmd10.Top = top3
    cmd10.Left = left2
    
    imgKH11.Top = top3
    imgKH11.Left = left3
    cmd11.Top = top3
    cmd11.Left = left3
    
    imgKH12.Top = top3
    imgKH12.Left = left4
    cmd12.Top = top3
    cmd12.Left = left4
    
    imgKH13.Top = top4
    imgKH13.Left = left1
    cmd13.Top = top4
    cmd13.Left = left1
    
    imgKH14.Top = top4
    imgKH14.Left = left2
    cmd14.Top = top4
    cmd14.Left = left2

    imgKH15.Top = top4
    imgKH15.Left = left3
    cmd15.Top = top4
    cmd15.Left = left3
    
    imgKH16.Top = top4
    imgKH16.Left = left4
    cmd16.Top = top4
    cmd16.Left = left4
    
    imgKH17.Top = top5
    imgKH17.Left = left1
    cmd17.Top = top5
    cmd17.Left = left1
    
    imgKH18.Top = top5
    imgKH18.Left = left2
    cmd18.Top = top5
    cmd18.Left = left2
    
    imgKH19.Top = top5
    imgKH19.Left = left3
    cmd19.Top = top5
    cmd19.Left = left3
    
    imgKH20.Top = top5
    imgKH20.Left = left4
    cmd20.Top = top5
    cmd20.Left = left4
    
  ElseIf (value = 2) Then
  
    imgKH1.Top = top1 '
    imgKH1.Left = left3
    cmd01.Top = top1
    cmd01.Left = left3
    
    imgKH2.Top = top2  '
    imgKH2.Left = left2
    cmd02.Top = top2
    cmd02.Left = left2
    
    imgKH3.Top = top1 '
    imgKH3.Left = left1
    cmd03.Top = top1
    cmd03.Left = left1
    
    imgKH4.Top = top5 '
    imgKH4.Left = left3
    cmd04.Top = top5
    cmd04.Left = left3
    
    imgKH5.Top = top3 '
    imgKH5.Left = left4
    cmd05.Top = top3
    cmd05.Left = left4
    
    imgKH6.Top = top1  '
    imgKH6.Left = left2
    cmd06.Top = top1
    cmd06.Left = left2
    
    imgKH7.Top = top5  '
    imgKH7.Left = left4
    cmd07.Top = top5
    cmd07.Left = left4
    
    imgKH8.Top = top2
    imgKH8.Left = left4
    cmd08.Top = top2
    cmd08.Left = left4
    
    imgKH9.Top = top5 '
    imgKH9.Left = left1
    cmd09.Top = top5
    cmd09.Left = left1
    
    imgKH10.Top = top4  '
    imgKH10.Left = left2
    cmd10.Top = top4
    cmd10.Left = left2
    
    imgKH11.Top = top4 '
    imgKH11.Left = left3
    cmd11.Top = top4
    cmd11.Left = left3
    
    imgKH12.Top = top2 '
    imgKH12.Left = left1
    cmd12.Top = top2
    cmd12.Left = left1
    
    imgKH13.Top = top5 '
    imgKH13.Left = left2
    cmd13.Top = top5
    cmd13.Left = left2
    
    imgKH14.Top = top3 '
    imgKH14.Left = left2
    cmd14.Top = top3
    cmd14.Left = left2

    imgKH15.Top = top3 '
    imgKH15.Left = left3
    cmd15.Top = top3
    cmd15.Left = left3
    
    imgKH16.Top = top4
    imgKH16.Left = left4
    cmd16.Top = top4
    cmd16.Left = left4
    
    imgKH17.Top = top3 '
    imgKH17.Left = left1
    cmd17.Top = top3
    cmd17.Left = left1
    
    imgKH18.Top = top4 '
    imgKH18.Left = left1
    cmd18.Top = top4
    cmd18.Left = left1
    
    imgKH19.Top = top1 '
    imgKH19.Left = left4
    cmd19.Top = top1
    cmd19.Left = left4
    
    imgKH20.Top = top2 '
    imgKH20.Left = left3
    cmd20.Top = top2
    cmd20.Left = left3
    
    
  ElseIf (value = 3) Then
  
    imgKH1.Top = top2 '
    imgKH1.Left = left3
    cmd01.Top = top2
    cmd01.Left = left3
    
    imgKH2.Top = top4 '
    imgKH2.Left = left3
    cmd02.Top = top4
    cmd02.Left = left3
    
    imgKH3.Top = top5 '
    imgKH3.Left = left1
    cmd03.Top = top5
    cmd03.Left = left1
    
    imgKH4.Top = top5
    imgKH4.Left = left3
    cmd04.Top = top5
    cmd04.Left = left3
    
    imgKH5.Top = top4 '
    imgKH5.Left = left2
    cmd05.Top = top4
    cmd05.Left = left2
    
    imgKH6.Top = top1 '
    imgKH6.Left = left2
    cmd06.Top = top1
    cmd06.Left = left2
    
    imgKH7.Top = top2 '
    imgKH7.Left = left1
    cmd07.Top = top2
    cmd07.Left = left1
    
    imgKH8.Top = top1 '
    imgKH8.Left = left4
    cmd08.Top = top1
    cmd08.Left = left4
    
    imgKH9.Top = top1 '
    imgKH9.Left = left1
    cmd09.Top = top1
    cmd09.Left = left1
    
    imgKH10.Top = top3 '
    imgKH10.Left = left4
    cmd10.Top = top3
    cmd10.Left = left4
    
    imgKH11.Top = top2 '
    imgKH11.Left = left2
    cmd11.Top = top2
    cmd11.Left = left2
    
    imgKH12.Top = top5 '
    imgKH12.Left = left4
    cmd12.Top = top5
    cmd12.Left = left4
    
    imgKH13.Top = top4 '
    imgKH13.Left = left1
    cmd13.Top = top4
    cmd13.Left = left1
    
    imgKH14.Top = top4 '
    imgKH14.Left = left4
    cmd14.Top = top4
    cmd14.Left = left4

    imgKH15.Top = top3 '
    imgKH15.Left = left1
    cmd15.Top = top3
    cmd15.Left = left1
    
    imgKH16.Top = top3 '
    imgKH16.Left = left2
    cmd16.Top = top3
    cmd16.Left = left2
    
    imgKH17.Top = top3 '
    imgKH17.Left = left3
    cmd17.Top = top3
    cmd17.Left = left3
    
    imgKH18.Top = top5 '
    imgKH18.Left = left2
    cmd18.Top = top5
    cmd18.Left = left2
    
    imgKH19.Top = top2 '
    imgKH19.Left = left4
    cmd19.Top = top2
    cmd19.Left = left4
    
    imgKH20.Top = top1 '
    imgKH20.Left = left3
    cmd20.Top = top1
    cmd20.Left = left3
    
  ElseIf (value = 4) Then
  
    imgKH1.Top = top3 '
    imgKH1.Left = left4
    cmd01.Top = top3
    cmd01.Left = left4
    
    imgKH2.Top = top5 '
    imgKH2.Left = left1
    cmd02.Top = top5
    cmd02.Left = left1
    
    imgKH3.Top = top5 '
    imgKH3.Left = left2
    cmd03.Top = top5
    cmd03.Left = left2
    
    imgKH4.Top = top4 '
    imgKH4.Left = left4
    cmd04.Top = top4
    cmd04.Left = left4
    
    imgKH5.Top = top2 '
    imgKH5.Left = left3
    cmd05.Top = top2
    cmd05.Left = left3
    
    imgKH6.Top = top4 '
    imgKH6.Left = left1
    cmd06.Top = top4
    cmd06.Left = left1
    
    imgKH7.Top = top3 '
    imgKH7.Left = left3
    cmd07.Top = top3
    cmd07.Left = left3
    
    imgKH8.Top = top1 '
    imgKH8.Left = left3
    cmd08.Top = top1
    cmd08.Left = left3
    
    imgKH9.Top = top2 '
    imgKH9.Left = left2
    cmd09.Top = top2
    cmd09.Left = left2
    
    imgKH10.Top = top1 '
    imgKH10.Left = left4
    cmd10.Top = top1
    cmd10.Left = left4
    
    imgKH11.Top = top3 '
    imgKH11.Left = left1
    cmd11.Top = top3
    cmd11.Left = left1
    
    imgKH12.Top = top2
    imgKH12.Left = left1
    cmd12.Top = top2
    cmd12.Left = left1
    
    imgKH13.Top = top1 '
    imgKH13.Left = left1
    cmd13.Top = top1
    cmd13.Left = left1
    
    imgKH14.Top = top1 '
    imgKH14.Left = left2
    cmd14.Top = top1
    cmd14.Left = left2

    imgKH15.Top = top5 '
    imgKH15.Left = left4
    cmd15.Top = top5
    cmd15.Left = left4
    
    imgKH16.Top = top5 '
    imgKH16.Left = left3
    cmd16.Top = top5
    cmd16.Left = left3
    
    imgKH17.Top = top4 '
    imgKH17.Left = left3
    cmd17.Top = top4
    cmd17.Left = left3
    
    imgKH18.Top = top3
    imgKH18.Left = left2
    cmd18.Top = top3
    cmd18.Left = left2
    
    imgKH19.Top = top4 '
    imgKH19.Left = left2
    cmd19.Top = top4
    cmd19.Left = left2
    
    imgKH20.Top = top2 '
    imgKH20.Left = left4
    cmd20.Top = top2
    cmd20.Left = left4
    
  ElseIf (value = 5) Then
  
    imgKH1.Top = top2
    imgKH1.Left = left2
    cmd01.Top = top2
    cmd01.Left = left2
    
    imgKH2.Top = top2
    imgKH2.Left = left3
    cmd02.Top = top2
    cmd02.Left = left3
    
    imgKH3.Top = top3
    imgKH3.Left = left4
    cmd03.Top = top3
    cmd03.Left = left4
    
    imgKH4.Top = top4 '
    imgKH4.Left = left1
    cmd04.Top = top4
    cmd04.Left = left1
    
    imgKH5.Top = top1 '
    imgKH5.Left = left1
    cmd05.Top = top1
    cmd05.Left = left1
    
    imgKH6.Top = top5 '
    imgKH6.Left = left4
    cmd06.Top = top5
    cmd06.Left = left4
    
    imgKH7.Top = top1 '
    imgKH7.Left = left2
    cmd07.Top = top1
    cmd07.Left = left2
    
    imgKH8.Top = top5 '
    imgKH8.Left = left1
    cmd08.Top = top5
    cmd08.Left = left1
    
    imgKH9.Top = top2 '
    imgKH9.Left = left4
    cmd09.Top = top2
    cmd09.Left = left4
    
    imgKH10.Top = top2 '
    imgKH10.Left = left1
    cmd10.Top = top2
    cmd10.Left = left1
    
    imgKH11.Top = top1 '
    imgKH11.Left = left4
    cmd11.Top = top1
    cmd11.Left = left4
    
    imgKH12.Top = top4 '
    imgKH12.Left = left2
    cmd12.Top = top4
    cmd12.Left = left2
    
    imgKH13.Top = top3 '
    imgKH13.Left = left2
    cmd13.Top = top3
    cmd13.Left = left2
    
    imgKH14.Top = top5 '
    imgKH14.Left = left2
    cmd14.Top = top5
    cmd14.Left = left2

    imgKH15.Top = top1 '
    imgKH15.Left = left3
    cmd15.Top = top1
    cmd15.Left = left3
    
    imgKH16.Top = top3 '
    imgKH16.Left = left1
    cmd16.Top = top3
    cmd16.Left = left1
    
    imgKH17.Top = top4 '
    imgKH17.Left = left4
    cmd17.Top = top4
    cmd17.Left = left4
    
    imgKH18.Top = top5 '
    imgKH18.Left = left3
    cmd18.Top = top5
    cmd18.Left = left3
    
    imgKH19.Top = top4 '
    imgKH19.Left = left3
    cmd19.Top = top4
    cmd19.Left = left3
    
    imgKH20.Top = top3 '
    imgKH20.Left = left3
    cmd20.Top = top3
    cmd20.Left = left3
    
  ElseIf (value = 6) Then
  
    imgKH1.Top = top3
    imgKH1.Left = left4
    cmd01.Top = top3
    cmd01.Left = left4
    
    imgKH2.Top = top5
    imgKH2.Left = left3
    cmd02.Top = top5
    cmd02.Left = left3
    
    imgKH3.Top = top2
    imgKH3.Left = left3
    cmd03.Top = top2
    cmd03.Left = left3
    
    imgKH4.Top = top2
    imgKH4.Left = left2
    cmd04.Top = top2
    cmd04.Left = left2
    
    imgKH5.Top = top1
    imgKH5.Left = left1
    cmd05.Top = top1
    cmd05.Left = left1
    
    imgKH6.Top = top2
    imgKH6.Left = left4
    cmd06.Top = top2
    cmd06.Left = left4
    
    imgKH7.Top = top4
    imgKH7.Left = left3
    cmd07.Top = top4
    cmd07.Left = left3
    
    imgKH8.Top = top1
    imgKH8.Left = left2
    cmd08.Top = top1
    cmd08.Left = left2
    
    imgKH9.Top = top5
    imgKH9.Left = left4
    cmd09.Top = top5
    cmd09.Left = left4
    
    imgKH10.Top = top2
    imgKH10.Left = left1
    cmd10.Top = top2
    cmd10.Left = left1
    
    imgKH11.Top = top5
    imgKH11.Left = left1
    cmd11.Top = top5
    cmd11.Left = left1
    
    imgKH12.Top = top4
    imgKH12.Left = left2
    cmd12.Top = top4
    cmd12.Left = left2
    
    imgKH13.Top = top3
    imgKH13.Left = left3
    cmd13.Top = top3
    cmd13.Left = left3
    
    imgKH14.Top = top4
    imgKH14.Left = left4
    cmd14.Top = top4
    cmd14.Left = left4

    imgKH15.Top = top5
    imgKH15.Left = left2
    cmd15.Top = top5
    cmd15.Left = left2
    
    imgKH16.Top = top3
    imgKH16.Left = left2
    cmd16.Top = top3
    cmd16.Left = left2
    
    imgKH17.Top = top1
    imgKH17.Left = left4
    cmd17.Top = top1
    cmd17.Left = left4
    
    imgKH18.Top = top1
    imgKH18.Left = left3
    cmd18.Top = top1
    cmd18.Left = left3
    
    imgKH19.Top = top3
    imgKH19.Left = left1
    cmd19.Top = top3
    cmd19.Left = left1
    
    imgKH20.Top = top4
    imgKH20.Left = left1
    cmd20.Top = top4
    cmd20.Left = left1
    
    
    End If
    
 
End Sub


