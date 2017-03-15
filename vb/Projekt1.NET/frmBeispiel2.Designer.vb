<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> Partial Class Forumlar
#Region "Vom Windows Form-Designer generierter Code "
	<System.Diagnostics.DebuggerNonUserCode()> Public Sub New()
		MyBase.New()
		'Dieser Aufruf ist für den Windows Form-Designer erforderlich.
		InitializeComponent()
		VB6_AddADODataBinding()
	End Sub
	'Das Formular überschreibt den Löschvorgang, um die Komponentenliste zu bereinigen.
	<System.Diagnostics.DebuggerNonUserCode()> Protected Overloads Overrides Sub Dispose(ByVal Disposing As Boolean)
		If Disposing Then
			VB6_RemoveADODataBinding()
			If Not components Is Nothing Then
				components.Dispose()
			End If
		End If
		MyBase.Dispose(Disposing)
	End Sub
	'Wird vom Windows Form-Designer benötigt.
	Private components As System.ComponentModel.IContainer
	Public ToolTip1 As System.Windows.Forms.ToolTip
	Private ADOBind_adoDaten As VB6.MBindingCollection
	Public WithEvents adoData As AxMSDataGridLib.AxDataGrid
	Public WithEvents imgFlagge As System.Windows.Forms.PictureBox
	Public WithEvents adoDaten As VB6.ADODC
	Public WithEvents lblKurs As System.Windows.Forms.Label
	Public WithEvents lblISOKürzel As System.Windows.Forms.Label
	Public WithEvents lblDevisenname As System.Windows.Forms.Label
	'Hinweis: Die folgende Prozedur ist für den Windows Form-Designer erforderlich.
	'Das Verändern mit dem Windows Form-Designer ist nicht möglich.
	'Das Bearbeiten mit dem Code-Editor ist nicht möglich.
	<System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
		Dim resources As System.Resources.ResourceManager = New System.Resources.ResourceManager(GetType(Forumlar))
		Me.components = New System.ComponentModel.Container()
		Me.ToolTip1 = New System.Windows.Forms.ToolTip(components)
		Me.adoData = New AxMSDataGridLib.AxDataGrid
		Me.imgFlagge = New System.Windows.Forms.PictureBox
		Me.adoDaten = New VB6.ADODC
		Me.lblKurs = New System.Windows.Forms.Label
		Me.lblISOKürzel = New System.Windows.Forms.Label
		Me.lblDevisenname = New System.Windows.Forms.Label
		Me.SuspendLayout()
		Me.ToolTip1.Active = True
		CType(Me.adoData, System.ComponentModel.ISupportInitialize).BeginInit()
		Me.StartPosition = System.Windows.Forms.FormStartPosition.Manual
		Me.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedSingle
		Me.Text = "Formular"
		Me.ClientSize = New System.Drawing.Size(577, 222)
		Me.Location = New System.Drawing.Point(337, 239)
		Me.MaximizeBox = False
		Me.MinimizeBox = False
		Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
		Me.BackColor = System.Drawing.SystemColors.Control
		Me.ControlBox = True
		Me.Enabled = True
		Me.KeyPreview = False
		Me.Cursor = System.Windows.Forms.Cursors.Default
		Me.RightToLeft = System.Windows.Forms.RightToLeft.No
		Me.ShowInTaskbar = True
		Me.HelpButton = False
		Me.WindowState = System.Windows.Forms.FormWindowState.Normal
		Me.Name = "Forumlar"
		adoData.OcxState = CType(resources.GetObject("adoData.OcxState"), System.Windows.Forms.AxHost.State)
		Me.adoData.Size = New System.Drawing.Size(289, 193)
		Me.adoData.Location = New System.Drawing.Point(264, 8)
		Me.adoData.TabIndex = 3
		Me.adoData.Name = "adoData"
		Me.imgFlagge.Size = New System.Drawing.Size(57, 41)
		Me.imgFlagge.Location = New System.Drawing.Point(200, 8)
		Me.imgFlagge.TabIndex = 4
		Me.imgFlagge.Dock = System.Windows.Forms.DockStyle.None
		Me.imgFlagge.BackColor = System.Drawing.SystemColors.Control
		Me.imgFlagge.CausesValidation = True
		Me.imgFlagge.Enabled = True
		Me.imgFlagge.ForeColor = System.Drawing.SystemColors.ControlText
		Me.imgFlagge.Cursor = System.Windows.Forms.Cursors.Default
		Me.imgFlagge.RightToLeft = System.Windows.Forms.RightToLeft.No
		Me.imgFlagge.TabStop = True
		Me.imgFlagge.Visible = True
		Me.imgFlagge.SizeMode = System.Windows.Forms.PictureBoxSizeMode.AutoSize
		Me.imgFlagge.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D
		Me.imgFlagge.Name = "imgFlagge"
		Me.adoDaten.Size = New System.Drawing.Size(249, 25)
		Me.adoDaten.Location = New System.Drawing.Point(8, 176)
		Me.adoDaten.CursorLocation = ADODB.CursorLocationEnum.adUseClient
		Me.adoDaten.ConnectionTimeout = 15
		Me.adoDaten.CommandTimeout = 30
		Me.adoDaten.CursorType = ADODB.CursorTypeEnum.adOpenStatic
		Me.adoDaten.LockType = ADODB.LockTypeEnum.adLockOptimistic
		Me.adoDaten.CommandType = ADODB.CommandTypeEnum.adCmdUnknown
		Me.adoDaten.CacheSize = 50
		Me.adoDaten.MaxRecords = 0
		Me.adoDaten.BOFAction = Microsoft.VisualBasic.Compatibility.VB6.ADODC.BOFActionEnum.adDoMoveFirst
		Me.adoDaten.EOFAction = Microsoft.VisualBasic.Compatibility.VB6.ADODC.EOFActionEnum.adDoMoveLast
		Me.adoDaten.BackColor = System.Drawing.SystemColors.Window
		Me.adoDaten.ForeColor = System.Drawing.SystemColors.WindowText
		Me.adoDaten.Orientation = Microsoft.VisualBasic.Compatibility.VB6.ADODC.OrientationEnum.adHorizontal
		Me.adoDaten.Enabled = True
		Me.adoDaten.UserName = ""
		Me.adoDaten.RecordSource = "Select * From Devisen"
		Me.adoDaten.Text = "Adodc1"
		Me.adoDaten.ConnectionString = ""
		Me.adoDaten.Name = "adoDaten"
		Me.lblKurs.TextAlign = System.Drawing.ContentAlignment.TopCenter
		Me.lblKurs.Text = "Label3"
		Me.lblKurs.Size = New System.Drawing.Size(161, 25)
		Me.lblKurs.Location = New System.Drawing.Point(8, 104)
		Me.lblKurs.TabIndex = 2
		Me.lblKurs.BackColor = System.Drawing.SystemColors.Control
		Me.lblKurs.Enabled = True
		Me.lblKurs.ForeColor = System.Drawing.SystemColors.ControlText
		Me.lblKurs.Cursor = System.Windows.Forms.Cursors.Default
		Me.lblKurs.RightToLeft = System.Windows.Forms.RightToLeft.No
		Me.lblKurs.UseMnemonic = True
		Me.lblKurs.Visible = True
		Me.lblKurs.AutoSize = False
		Me.lblKurs.BorderStyle = System.Windows.Forms.BorderStyle.None
		Me.lblKurs.Name = "lblKurs"
		Me.lblISOKürzel.TextAlign = System.Drawing.ContentAlignment.TopCenter
		Me.lblISOKürzel.Text = "Label2"
		Me.lblISOKürzel.Size = New System.Drawing.Size(161, 33)
		Me.lblISOKürzel.Location = New System.Drawing.Point(8, 56)
		Me.lblISOKürzel.TabIndex = 1
		Me.lblISOKürzel.BackColor = System.Drawing.SystemColors.Control
		Me.lblISOKürzel.Enabled = True
		Me.lblISOKürzel.ForeColor = System.Drawing.SystemColors.ControlText
		Me.lblISOKürzel.Cursor = System.Windows.Forms.Cursors.Default
		Me.lblISOKürzel.RightToLeft = System.Windows.Forms.RightToLeft.No
		Me.lblISOKürzel.UseMnemonic = True
		Me.lblISOKürzel.Visible = True
		Me.lblISOKürzel.AutoSize = False
		Me.lblISOKürzel.BorderStyle = System.Windows.Forms.BorderStyle.None
		Me.lblISOKürzel.Name = "lblISOKürzel"
		Me.lblDevisenname.TextAlign = System.Drawing.ContentAlignment.TopCenter
		Me.lblDevisenname.Text = "Label1"
		Me.lblDevisenname.Size = New System.Drawing.Size(153, 25)
		Me.lblDevisenname.Location = New System.Drawing.Point(16, 16)
		Me.lblDevisenname.TabIndex = 0
		Me.lblDevisenname.BackColor = System.Drawing.SystemColors.Control
		Me.lblDevisenname.Enabled = True
		Me.lblDevisenname.ForeColor = System.Drawing.SystemColors.ControlText
		Me.lblDevisenname.Cursor = System.Windows.Forms.Cursors.Default
		Me.lblDevisenname.RightToLeft = System.Windows.Forms.RightToLeft.No
		Me.lblDevisenname.UseMnemonic = True
		Me.lblDevisenname.Visible = True
		Me.lblDevisenname.AutoSize = False
		Me.lblDevisenname.BorderStyle = System.Windows.Forms.BorderStyle.None
		Me.lblDevisenname.Name = "lblDevisenname"
		Me.Controls.Add(adoData)
		Me.Controls.Add(imgFlagge)
		Me.Controls.Add(adoDaten)
		Me.Controls.Add(lblKurs)
		Me.Controls.Add(lblISOKürzel)
		Me.Controls.Add(lblDevisenname)
		CType(Me.adoData, System.ComponentModel.ISupportInitialize).EndInit()
		Me.ResumeLayout(False)
		Me.PerformLayout()
	End Sub
#End Region 
#Region "Upgrade Support"
	Public Sub VB6_AddADODataBinding()
		ADOBind_adoDaten = New VB6.MBindingCollection()
		ADOBind_adoDaten.DataSource = CType(adoDaten, msdatasrc.DataSource)
		ADOBind_adoDaten.Add(imgFlagge, "Image", "Flagge", Nothing, "imgFlagge")
		ADOBind_adoDaten.Add(lblKurs, "Text", "Kurs", Nothing, "lblKurs")
		ADOBind_adoDaten.Add(lblISOKürzel, "Text", "ISO", Nothing, "lblISOKürzel")
		ADOBind_adoDaten.Add(lblDevisenname, "Text", "Devisenname", Nothing, "lblDevisenname")
		adoData.DataSource = CType(adoDaten, msdatasrc.DataSource)
		ADOBind_adoDaten.UpdateMode = VB6.UpdateMode.vbUpdateWhenPropertyChanges
		ADOBind_adoDaten.UpdateControls()
	End Sub
	Public Sub VB6_RemoveADODataBinding()
		ADOBind_adoDaten.Clear()
		ADOBind_adoDaten.Dispose()
		ADOBind_adoDaten = Nothing
		adoData.DataSource = Nothing
	End Sub
#End Region 
End Class