VERSION 5.00
Begin VB.Form frmHaupt 
   BorderStyle     =   3  'Fester Dialog
   Caption         =   "Euro Umrechner"
   ClientHeight    =   3705
   ClientLeft      =   4680
   ClientTop       =   3960
   ClientWidth     =   9570
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   3705
   ScaleWidth      =   9570
   ShowInTaskbar   =   0   'False
   Begin VB.ListBox lstDevisen 
      Height          =   2595
      Left            =   4800
      TabIndex        =   4
      Top             =   120
      Width           =   4575
   End
   Begin VB.CheckBox chkAbschneiden 
      Caption         =   "Nur 2 Stellen anzeigen und formatiert ausgeben"
      Height          =   375
      Left            =   240
      TabIndex        =   3
      Top             =   1680
      Width           =   3615
   End
   Begin VB.CommandButton cmdUmrechnen 
      Caption         =   "DM-Betrag &Umrechnen"
      Height          =   495
      Left            =   120
      TabIndex        =   1
      Top             =   960
      Width           =   4335
   End
   Begin VB.TextBox txtEingabe 
      Height          =   615
      Left            =   120
      TabIndex        =   0
      Top             =   120
      Width           =   4335
   End
   Begin VB.Label lblAktuellerKurs 
      BorderStyle     =   1  'Fest Einfach
      Height          =   615
      Left            =   4800
      TabIndex        =   5
      Top             =   2880
      Width           =   4575
   End
   Begin VB.Label lblAusgabe 
      BorderStyle     =   1  'Fest Einfach
      Height          =   615
      Left            =   120
      TabIndex        =   2
      Top             =   2880
      Width           =   4335
   End
End
Attribute VB_Name = "frmHaupt"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
Private Kurs As Currency
Const UmrechnungskursEuro As Single = 0.52
Private Sub Form_Load()
DevisenEinlesen
End Sub
Private Sub lstDevisen_Click()
    
    Kurs = CCur(Left(lstDevisen.Text, InStr(lstDevisen.Text, vbTab) - 1))

    
    
    lblAktuellerKurs.Caption = Kurs
End Sub

Private Sub cmdUmrechnen_Click()
    Dim Ergebnis As Currency, DMBetrag As Double
    If IsNumeric(txtEingabe.Text) = True Then
        DMBetrag = txtEingabe.Text
        If Kurs = 0 Then
            lblAusgabe.Caption = "Bitte Kurs auswählen"
            Exit Sub
        End If
        Ergebnis = DMBetrag / Kurs
        lblAusgabe.Caption = Ergebnis
        Exit Sub
        
        If chkAbschneiden.Value = 1 Then
            lblAusgabe.Caption = FormatCurrency(Ergebnis, 2) & " Euro"
        Else
            lblAusgabe.Caption = FormatCurrency(Ergebnis, 10)
        End If
    Else
        lblAusgabe.Caption = "ERROR"
    End If
End Sub

Private Sub Combo1_Change()

End Sub




Private Sub txtEingabe_KeyPress(KeyAscii As Integer)
Select Case KeyAscii
    Case Asc("0") To Asc("9")
    Case Asc(","), Asc(".")
        If InStr(txtEingabe.Text, ",") <> 0 Then
            KeyAscii = 0
        Else
            KeyAscii = Asc(",")
        End If
    Case Asc(vbBack)
    Case Else
        KeyAscii = 0
End Select
End Sub

Sub DevisenEinlesen()

    With lstDevisen
        .AddItem "4,8485" & vbTab & vbTab & "Franken" & vbTab & vbTab & vbTab & "BEF"
        .AddItem "26,2530" & vbTab & vbTab & "Franken" & vbTab & vbTab & vbTab & "DKK"
        .AddItem "2,9545" & vbTab & vbTab & "Franken" & vbTab & vbTab & vbTab & "GBP"
        .AddItem "32,8520" & vbTab & vbTab & "Franken" & vbTab & vbTab & vbTab & "FIM"
        .AddItem "29,8250" & vbTab & vbTab & "Franken" & vbTab & vbTab & vbTab & "FRF"
    End With
End Sub
