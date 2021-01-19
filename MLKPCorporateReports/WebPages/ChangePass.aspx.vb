Imports MySql.Data.MySqlClient

Partial Class WebPages_ChangePass
    Inherits System.Web.UI.Page
    Dim CCon As New ClsCon
    Dim deCrypt As New AESEncrypt.AESEncryption
    Dim cmd As MySqlCommand = Nothing
    Dim cmd1 As MySqlCommand = Nothing
    Dim cmd2 As MySqlCommand = Nothing
    Dim cmdUpdate As MySqlCommand = Nothing
    Dim cmdUpdate1 As MySqlCommand = Nothing
    Dim cmdUpdate2 As MySqlCommand = Nothing
    Dim drSysUser As MySqlDataReader = Nothing
    Dim drAdminSysUser As MySqlDataReader = Nothing
    Dim drPartnerUser As MySqlDataReader = Nothing

    Dim oldpass As String = String.Empty
    Dim partnerName As String = String.Empty
    Dim oldpasswordc As String = String.Empty
    Dim reportname As String = String.Empty
    Dim accountid As String = String.Empty
    Dim flagging As String = String.Empty
    Dim chkpartneruser As String = String.Empty
    Dim chkadminsysuser As String = String.Empty
    Dim chksysuser As String = String.Empty
    Dim existPartner As Integer = 0
    Dim existSys As Integer = 0
    Dim existAdminSys As Integer = 0
    Dim updatesys As String = String.Empty
    Dim updateadminsys As String = String.Empty
    Dim updatepartner As String = String.Empty

    Dim passwordnew As String = String.Empty

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        txtUserName.Text = Session("UserName")
        oldpass = Session("UserPass")
        partnerName = Session("PartnerName")
        accountid = Session("PartnerID")
        reportname = Session("Reportname")
        If txtUserName.Text = String.Empty Then
            Response.Redirect("Denied.aspx")
        End If
        getconnections()
    End Sub
    Protected Sub BtnChange_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles BtnChange.Click
        If (Trim(txtConfirmPass.Text).Length < 6 Or Trim(txtPassword.Text).Length < 6 Or Trim(txtNewPassword.Text).Length < 6) Then
            lblmessageChange.Visible = True
            getmessage("Please Enter Atleast 6 Character for your new password!")
            Exit Sub
        Else
            Try
                oldpasswordc = deCrypt.AESDecrypt(oldpass, "kWuYDGElyQDpGKM9")
            Catch ex As Exception
                checknewpass(oldpass)
            End Try
            checknewpass(oldpasswordc)
        End If

    End Sub

    Private Sub checknewpass(ByVal oldpass As String)
        If txtNewPassword.Text = String.Empty And txtConfirmPass.Text = String.Empty Then
            lblmessageChange.Visible = True
            getmessage("Please enter your new password!")
            Exit Sub
        ElseIf txtPassword.Text.Trim <> oldpass Then
            lblmessageChange.Visible = True
            getmessage("Old password didn't match!")
            Exit Sub
        ElseIf txtNewPassword.Text <> txtConfirmPass.Text Or txtConfirmPass.Text <> txtNewPassword.Text Then
            lblmessageChange.Visible = True
            getmessage("New Password and Confirm Password didn't match!")
            Exit Sub
        ElseIf txtConfirmPass.Text = txtPassword.Text Then
            lblmessageChange.Visible = True
            getmessage("Please enter your new password!")
            Exit Sub
        End If

        Dim again As Int16 = 0
        getconnections()
newcon:
        Using CCon.GetCon()
            Try
                If reportname = "Domestic" Then 'DOMESTIC
                    chksysuser = String.Format("SELECT EXISTS(SELECT 1 FROM kpusers.sysuseraccounts WHERE userlogin ='{0}' AND isactive =1 LIMIT 1) as SysExist;", txtUserName.Text.Trim)
                    cmd1 = New MySqlCommand(chksysuser, CCon.GetCon())
                    drSysUser = cmd1.ExecuteReader
                    If drSysUser.HasRows <> Nothing Then
                        While drSysUser.Read
                            existSys = drSysUser.Item("SysExist")
                        End While
                        drSysUser.Close()
                    End If
                    chkadminsysuser = String.Format("SELECT EXISTS(SELECT 1 FROM kpusers.adminsysuseraccounts WHERE userlogin ='{0}' AND isactive =1 LIMIT 1) as AdminSysExist;", txtUserName.Text.Trim)
                    cmd2 = New MySqlCommand(chkadminsysuser, CCon.GetCon())
                    drAdminSysUser = cmd2.ExecuteReader
                    If drAdminSysUser.HasRows <> Nothing Then
                        While drAdminSysUser.Read
                            existAdminSys = drAdminSysUser.Item("AdminSysExist")
                        End While
                        drAdminSysUser.Close()
                    End If
                    If existSys = 1 And existAdminSys = 1 Then
                        If existSys = 1 Then
                            passwordnew = txtConfirmPass.Text.Trim
                            updatesys = String.Format("Update kpusers.sysuseraccounts set userpassword ='{0}' where UserLogin='{1}';", passwordnew, txtUserName.Text.Trim)
                        End If
                        If existAdminSys = 1 Then
                            passwordnew = deCrypt.AESEncrypt(txtConfirmPass.Text.Trim, "kWuYDGElyQDpGKM9")
                            updateadminsys = String.Format("Update kpusers.adminsysuseraccounts set userpassword='{0}' Where UserLogin='{1}';", passwordnew, txtUserName.Text.Trim)
                        End If
                        Using CCon.GetCon()
                            Try
                                cmdUpdate1 = New MySqlCommand(updatesys, CCon.GetCon())
                                cmdUpdate1.ExecuteNonQuery()
                                cmdUpdate2 = New MySqlCommand(updateadminsys, CCon.GetCon())
                                cmdUpdate2.ExecuteNonQuery()
                            Catch ex As Exception
                                Throw New Exception(ex.ToString)
                            End Try
                        End Using
                    ElseIf existSys = 1 Then
                        passwordnew = txtConfirmPass.Text.Trim
                        updatesys = String.Format("Update kpusers.sysuseraccounts set userpassword ='{0}' where UserLogin='{1}';", passwordnew, txtUserName.Text.Trim)
                        Using CCon.GetCon()
                            Try
                                cmdUpdate1 = New MySqlCommand(updatesys, CCon.GetCon())
                                cmdUpdate1.ExecuteNonQuery()
                            Catch ex As Exception
                                Throw New Exception(ex.ToString)
                            End Try
                        End Using
                    ElseIf existAdminSys = 1 Then
                        passwordnew = deCrypt.AESEncrypt(txtConfirmPass.Text.Trim, "kWuYDGElyQDpGKM9")
                        updateadminsys = String.Format("Update kpusers.adminsysuseraccounts set userpassword='{0}' Where UserLogin='{1}';", passwordnew, txtUserName.Text.Trim)
                        Using CCon.GetCon()
                            Try
                                cmdUpdate2 = New MySqlCommand(updateadminsys, CCon.GetCon())
                                cmdUpdate2.ExecuteNonQuery()
                            Catch ex As Exception
                                Throw New Exception(ex.ToString)
                            End Try
                        End Using
                    End If
                Else 'PARTNERS 
                    chkpartneruser = String.Format("SELECT EXISTS(SELECT 1 FROM kpadminpartners.partnersusers WHERE UserID ='{0}' and isactive=1 and accountid = '{1}' LIMIT 1) as SysExist;", txtUserName.Text.Trim, accountid)
                    cmd = New MySqlCommand(chkpartneruser, CCon.GetCon())
                    drPartnerUser = cmd.ExecuteReader
                    If drPartnerUser.HasRows <> Nothing Then
                        While drPartnerUser.Read
                            existPartner = drPartnerUser.Item("SysExist")
                        End While
                        drPartnerUser.Close()
                        If existPartner = 1 Then
                            updatepartner = String.Format("Update kpadminpartners.partnersusers set Password='{0}' Where UserID='{1}' and accountid = '{2}';", txtConfirmPass.Text.Trim, txtUserName.Text.Trim, accountid)
                            Using CCon.GetCon()
                                Try
                                    cmdUpdate = New MySqlCommand(updatepartner, CCon.GetCon())
                                    cmdUpdate.ExecuteNonQuery()
                                    Call INSERT_TO_ACCESSLOGS_changepass()
                                    Response.Write("<script language=javascript>alert('" & "Successfully Changed." & "')</script>")
                                    Response.Write("<script language=javascript>window.location = 'https://reports.mlhuillier1.com'</script>")
                                Catch ex As Exception
                                    Throw New Exception(ex.ToString)
                                End Try
                            End Using
                        ElseIf reportname = "API" And again = 0 Then
                            drPartnerUser.Close()
                            CCon.CloseCon()
                            CCon.OpenCon("KPAPINEWA")
                            again = 1
                            GoTo newcon
                        End If
                    End If
                End If
                'Response.Write("<script language=javascript>window.location = '192.168.12.105/reports/login.aspx'</script>")
                'Response.Write("<script language=javascript>window.location = 'http://localhost:2556/MLKPCorporateReports/WebPages/postpage.aspx'</script>")
            Catch ex As Exception
                Throw New Exception(ex.ToString)
            End Try
        End Using
    End Sub

    'CONNECTIONS
    Protected Sub getconnections()
        flagging = "3"
        If reportname = "Domestic" Then 'Domestic User
            CCon.OpenCon("KPUsersA")
        ElseIf reportname = "API" Then 'Partners User
            CCon.OpenCon("KPAPIA")
        ElseIf reportname = "WSC" Then 'Partners User
            CCon.OpenCon("KPWSCA")
        ElseIf reportname = "Billspayment" Then 'Bills Payment User
            CCon.OpenCon("KPBillsPaymentA")
        ElseIf reportname = "Payment Solution" Or reportname = "Fileupload" Then 'Payment Solution and FileUpload User
            CCon.OpenCon("KPFileUploadA")
        End If
    End Sub
    Protected Sub BtnCancel_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles BtnCancel.Click
        Response.Redirect("MainForm.aspx")
    End Sub
    Public Sub INSERT_TO_ACCESSLOGS_changepass()
        Dim strUser As String = String.Empty
        Dim cmd As MySqlCommand = Nothing
        Dim dr As MySqlDataReader = Nothing
        getconnections()
        Using CCon.GetCon()
            strUser = "call kpusers.accesslogs('" & txtUserName.Text & "','" & reportname & "','" & flagging & "');"
            cmd = New MySqlCommand(strUser, CCon.GetCon())
            dr = cmd.ExecuteReader
        End Using
        CCon.CloseCon()
        cmd.Dispose()
        dr.Close()
    End Sub
    Public Sub getmessage(msg As String)
        lblmessageChange.Text = msg
    End Sub
End Class
