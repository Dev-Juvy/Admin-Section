Imports MySql.Data.MySqlClient
Imports System.IO

Partial Class MasterPage
    Inherits System.Web.UI.MasterPage
    Dim Con As New ClsCon
    Dim insertresourceid As String

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Dim FilePath As String = Request.QueryString("path")
        Dim FileName As String = Request.QueryString("file")

        Dim SourcePath As String = Request.QueryString("sourcepath")
        Dim TargetPath As String = Request.QueryString("targetpath")
        Dim File As String = Request.QueryString("file")
        Dim tpc As String = ConfigurationManager.AppSettings("tpc")

        CheckSessionTimeout()
        lblUserfullname.Text = Session("UserFullname")
        insertresourceid = Session("UserName")

        If lblUserfullname.Text = "" Or lblUserfullname.Text = String.Empty Then
            Response.Redirect("Login.aspx")
        End If

        subtype10.Visible = False
        type10.Visible = False

        lbldate.Text = DateTime.Now.ToLongDateString()
        Dim partnerName As String = Session("PartnerName")
        If partnerName = Nothing Then


            Label8.Visible = True
            If Session("roles") = "CAD-DIVMAN" Then
                type1.Visible = False
                type2.Visible = False
                type3.Visible = False
                type4.Visible = False
                type5.Visible = False
                type6.Visible = False
                type7.Visible = False
                type8.Visible = False
                type9.Visible = False
                type10.Visible = False
                type11.Visible = False
                type12.Visible = False
                Label8.Visible = False
                Label9.Visible = False
                Label10.Visible = False
                Label12.Visible = False
                type13.Visible = False
            ElseIf Session("roles") = "KP-WALLETDIV" Then
                type1.Visible = False
                type2.Visible = False
                type3.Visible = False
                type4.Visible = False
                type5.Visible = False
                type6.Visible = False
                type7.Visible = False
                type8.Visible = False
                type9.Visible = False
                type10.Visible = False
                type11.Visible = False
                type12.Visible = False
                Label8.Visible = False
                Label9.Visible = False
                Label10.Visible = False
                Label12.Visible = False
                type13.Visible = False
            ElseIf Session("roles") = "KP-HRMDPayroll" Or Session("roles") = "KP-PAYROLL" Then
                type1.Visible = False
                type2.Visible = False
                type3.Visible = False
                type4.Visible = False
                type5.Visible = False
                type6.Visible = False
                type7.Visible = True
                type8.Visible = False
                type10.Visible = True
                type9.Visible = False
                type11.Visible = False
                type12.Visible = False
                Label8.Visible = False
                Label9.Visible = False
                Label10.Visible = False
                Label12.Visible = False
                Label14.Visible = False
                Label16.Visible = False
                'Label7.Visible = True
                Label8.Enabled = False
                Label11.Enabled = True
                Label13.Enabled = False
                type13.Visible = False
            ElseIf Session("roles") = "KP-FD" And Session("batchupload") = 1 Then
                Label8.Visible = True
                type1.Visible = False
                type2.Visible = False
                type3.Visible = False
                type4.Visible = False
                type5.Visible = False
                type6.Visible = False
                type7.Visible = False
                type8.Visible = False
                Label8.Visible = False
                type9.Visible = False
                type10.Visible = False
                type11.Visible = False
                type12.Visible = False
                Label9.Visible = False
                Label10.Visible = False
                Label12.Visible = False
                type13.Visible = True
            ElseIf Session("roles") <> "KP-IAD" Then
                type9.Visible = True
                type12.Visible = False
                type13.Visible = False
                If Session("roles") = "KP-CAD" Then
                    type10.Visible = True
                    type11.Visible = False
                    type12.Visible = True 'SETTLEMENT & COLLECTION
                    'type10.Visible = False 'wallet employee if true
                    type13.Visible = False
                End If
            ElseIf Session("roles") <> "KP-CAD" Then
                type7.Visible = False
                type8.Visible = False
                type11.Visible = False
                Label10.Visible = False
                Label12.Visible = False
                type12.Visible = False
                type13.Visible = False
                If Session("roles") = "KP-SECCOM" Then
                    type7.Visible = True
                    type9.Visible = False
                    type10.Visible = False
                    type11.Visible = False
                    type12.Visible = False
                    Label11.Visible = True
                    Label10.Visible = True
                    type13.Visible = False

                ElseIf Session("roles") = "KP-IAD" Then
                    Label10.Visible = True 'for iad fix
                    Label14.Visible = False 'for iad fix
                    'Label11.Visible = True
                    'subtype10.Visible = False 'wallet employee if true
                    subtype10.Visible = True
                    type10.Visible = False 'for iad fix
                    type7.Visible = True 'for iad fix
                    Label2.Visible = False 'for iad fix
                    type10.Visible = True 'for iad fix
                    type8.Visible = True 'for iad fix
                    type8.Disabled = True
                    type12.Visible = False
                    type11.Visible = False
                    type13.Visible = False

                    'type11.Visible = False
                End If
            End If
        Else
            Dim issm = False
            Dim smaccountid As String = ConfigurationManager.AppSettings("smaccountid")
            Try
                Dim issub As Boolean = False
                Dim CCon As New ClsCon
                CCon.OpenCon("KPWSC")
                Dim str As String = String.Format("SELECT mainaccountid from kpadminpartners.wssubagents where subaccountid='{0}' limit 1", Session("PartnerID"))
                Dim cmd As MySqlCommand = New MySqlCommand(str, CCon.GetCon())
                Dim dr As MySqlDataReader = cmd.ExecuteReader
                If dr.Read Then
                    issm = True
                End If
                dr.Close()
                CCon.CloseCon()
            Catch ex As Exception
            End Try

            Label8.Visible = True
            If Session("ReportName") = "Billspayment" Then

                If Session("PartnerID") = tpc And Session("UserName") = "CINCOT" Then
                    type1.Visible = False
                    type2.Visible = True
                    type3.Visible = False
                    type4.Visible = False
                    type5.Visible = False
                    type6.Visible = False
                    type7.Visible = True
                    type8.Visible = False
                    type9.Visible = False
                    type10.Visible = False
                    type11.Visible = False
                    type12.Visible = False
                    Label10.Visible = False
                    Label12.Visible = False
                    type13.Visible = False
                Else
                    type1.Visible = False
                    type2.Visible = True
                    type3.Visible = False
                    type4.Visible = False
                    type5.Visible = False
                    type6.Visible = False
                    type7.Visible = False
                    type8.Visible = False
                    type9.Visible = False
                    type10.Visible = False
                    type11.Visible = False
                    type12.Visible = False
                    Label10.Visible = False
                    Label12.Visible = False
                    type13.Visible = False
                End If

            ElseIf Session("ReportName") = "SpecialPartner" Then
                type1.Visible = False
                type2.Visible = False
                type3.Visible = False
                type4.Visible = False
                type5.Visible = False
                type6.Visible = False
                type7.Visible = False
                type8.Visible = False
                type9.Visible = True
                type10.Visible = False
                type11.Visible = False
                type12.Visible = False
                Label10.Visible = False
                Label12.Visible = False
                type13.Visible = False
            ElseIf Session("ReportName") = "WSC" And (issm = True Or Session("PartnerID") = smaccountid) Then
                type1.Visible = False
                type2.Visible = False
                type3.Visible = False
                type4.Visible = False
                type5.Visible = False
                type6.Visible = False
                type7.Visible = False
                type8.Visible = False
                Label8.Visible = False
                type9.Visible = False
                type10.Visible = False
                type11.Visible = False
                type12.Visible = False
                Label9.Visible = False
                Label10.Visible = False
                Label12.Visible = False
                type13.Visible = False
            ElseIf Session("ReportName") = "BatchUpload" Then
                Label8.Visible = True
                type1.Visible = False
                type2.Visible = False
                type3.Visible = False
                type4.Visible = False
                type5.Visible = False
                type6.Visible = False
                type7.Visible = False
                type8.Visible = False
                Label8.Visible = False
                type9.Visible = False
                type10.Visible = False
                type11.Visible = True
                type12.Visible = False
                Label9.Visible = False
                Label10.Visible = False
                Label12.Visible = False
                type13.Visible = False
            ElseIf Session("ReportName") = "BatchUploadHO" And Session("batchupload") = 1 Then
                Label8.Visible = True
                type1.Visible = False
                type2.Visible = False
                type3.Visible = False
                type4.Visible = False
                type5.Visible = False
                type6.Visible = False
                type7.Visible = False
                type8.Visible = False
                Label8.Visible = False
                type9.Visible = False
                type10.Visible = False
                type11.Visible = False
                type12.Visible = False
                Label9.Visible = False
                Label10.Visible = False
                Label12.Visible = False
                type13.Visible = True
            Else
                type2.Visible = False
                type3.Visible = False
                type5.Visible = False
                type7.Visible = False
                type8.Visible = False
                type9.Visible = False
                type10.Visible = False
                type11.Visible = False
                type12.Visible = False
                Label10.Visible = False
                Label12.Visible = False
                type13.Visible = False
            End If
        End If
        If FilePath <> String.Empty And FileName <> String.Empty Then
            'Process.Start("C:\Corporate\HoCorporate\Corporate_20191120.log")
            'Try
            '    Dim file = New System.IO.FileInfo("C:\Corporate\HoCorporate\" + ReadFile)
            '    Response.Clear()
            '    Response.AddHeader("Content-Disposition", "attachment; filename=" & ReadFile)
            '    Response.AddHeader("Content-Length", file.Length.ToString(CultureInfo.InvariantCulture))
            '    Response.ContentType = "application/octet-stream"
            '    Response.WriteFile(file.FullName)
            '    Response.[End]()
            'Catch ex As Exception
            'End Try
            Try
                Dim stream As Stream = Nothing
                'Dim FileLocation As String = HttpContext.Current.Request.QueryString("C:\Corporate\HoCorporate\" + ReadFile)
                Dim FileLocation As String = FilePath + FileName
                stream = New FileStream(FileLocation, FileMode.Open, FileAccess.Read, FileShare.ReadWrite)
                Dim bytesToRead As Long = stream.Length
                HttpContext.Current.Response.ContentType = "application/octet-stream"
                HttpContext.Current.Response.AddHeader("Content-Disposition", "attachment;filename=" & Path.GetFileName(FileLocation))
                While bytesToRead > 0

                    If HttpContext.Current.Response.IsClientConnected Then
                        Dim buffer As Byte() = New Byte(9999) {}
                        Dim length As Integer = stream.Read(buffer, 0, 10000)
                        HttpContext.Current.Response.OutputStream.Write(buffer, 0, length)
                        HttpContext.Current.Response.Flush()
                        bytesToRead = bytesToRead - length
                    Else
                        bytesToRead = -1
                    End If
                End While
                HttpContext.Current.Response.End()
            Catch ex As Exception
            End Try
        End If
        If SourcePath <> String.Empty And TargetPath <> String.Empty And File <> String.Empty Then
            Try
                Dim sourceFile As String = System.IO.Path.Combine(SourcePath, File)
                Dim destFile As String = System.IO.Path.Combine(TargetPath, File)
                System.IO.File.Copy(sourceFile, destFile, True)
            Catch ex As Exception
            End Try
        End If
    End Sub
    Public Sub INSERT_TO_ACCESSLOGS_Logout()
        Dim strUser As String = String.Empty
        Dim cmd As MySqlCommand
        Dim dr As MySqlDataReader
        Dim reportname As String = Session("ReportName")
        Const flagging As String = "2"
        Try
            If reportname = "Domestic" Then 'Domestic User
                Con.OpenCon("KPUsersA")
            ElseIf reportname = "API" Then 'Partners User
                Con.OpenCon("KPAPIA")
            ElseIf reportname = "WSC" Then 'Partners User
                Con.OpenCon("KPWSCA")
            ElseIf reportname = "Billspayment" Then 'Bills Payment User
                Con.OpenCon("KPBillsPaymentA")
            ElseIf reportname = "Payment Solution" Or reportname = "FileUpload" Then 'Payment Solution and FileUpload User
                Con.OpenCon("KPFileUploadA")
            ElseIf reportname = "BatchUpload" Then
                Con.OpenCon("KPMLWallet")
            End If

            Using Con.GetCon()
                strUser = String.Format("call kpusers.accesslogs('{0}','{1}','{2}');", insertresourceid, reportname, flagging)
                cmd = New MySqlCommand(strUser, Con.GetCon())
                dr = cmd.ExecuteReader
            End Using
            Con.CloseCon()
            cmd.Dispose()
            dr.Close()
        Catch ex As Exception
            Response.Redirect("Login.aspx")
        End Try

    End Sub
    Protected Sub btnLogout_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnLogout.Click
        Call INSERT_TO_ACCESSLOGS_Logout()
        Session.Clear()
        Response.Redirect("Login.aspx")
    End Sub
    Private Sub CheckSessionTimeout()
        Dim int_MilliSecondsTimeReminder As Integer = (Me.Session.Timeout * 60000) - 5 * 60000
        Dim int_MilliSecondsTimeOut As Integer = (Me.Session.Timeout * 60000) - 5
        Const msgSession As String = "Warning: Within next 5 minutes, if you do not do anything MLKP Web Reports will redirect to the login page."
        Dim str_Script As String = vbCr & vbLf & "            var myTimeReminder, myTimeOut; " & vbCr & vbLf & "            clearTimeout(myTimeReminder); " & vbCr & vbLf & "            clearTimeout(myTimeOut); " & "var sessionTimeReminder = " & int_MilliSecondsTimeReminder.ToString() & "; " & "var sessionTimeout = " & int_MilliSecondsTimeOut.ToString() & ";" & "function doReminder(){ alert('" & msgSession & "'); }" & "function doRedirect(){ window.location.href='../WebPages/Login.aspx'; }" & vbCr & vbLf & "            myTimeReminder=setTimeout('doReminder()', sessionTimeReminder); " & vbCr & vbLf & "            myTimeOut=setTimeout('doRedirect()', sessionTimeout); "
        ScriptManager.RegisterClientScriptBlock(Me.Page, Me.[GetType](), "CheckSessionOut", str_Script, True)
    End Sub
    Protected Sub btncpass_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btncpass.Click
        Response.Redirect("ChangePass.aspx")
    End Sub
End Class

