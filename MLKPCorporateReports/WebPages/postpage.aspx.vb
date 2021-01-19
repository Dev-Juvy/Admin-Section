﻿Imports MySql.Data.MySqlClient
Imports System.Data

Partial Class WebPages_postpage
    Inherits System.Web.UI.Page

    Dim CCon As New ClsCon
    Dim UserInfo As New UserInfo
    Dim cmd As MySqlCommand = New MySqlCommand
    Dim dr As MySqlDataReader = Nothing
    Dim usrnfo As New ClsReport
    Dim deCrypt As New AESEncrypt.AESEncryption

    Dim str As String = String.Empty
    Dim strsub As String = String.Empty
    Dim type As String = String.Empty
    Dim _pass As String = String.Empty
    Dim accountID As String = String.Empty
    Dim accountname As String = String.Empty
    Dim accounttype As String = String.Empty
    Dim errorcon As String = String.Empty
    Dim walletID As String = String.Empty
    Dim divcode As String = String.Empty
    Dim zcode As String = String.Empty

    Dim _flagDomestic As Boolean = False
    Dim _flagBillspay As Boolean = False
    Dim _flagAPI As Boolean = False
    Dim _flagWSC As Boolean = False
    Dim _flagFileUpload As Boolean = False
    Dim _flagExpress As Boolean = False
    Dim _flagSpecialPartner As Boolean = False
    Dim _flagBatchUpload As Boolean = False
    Dim _flagExclusive As Boolean = False
    Dim _flagExclusive2 As Boolean = False
    Dim _HOBatchUpload As Boolean = False
    Dim _paSPecialugUser As Boolean = False



    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Session.Clear()
        clearSession()
        Dim username As String = Request.QueryString("user")
        Dim password As String = Replace(Request.QueryString("pass"), "%", "+")
        Dim batchupload As Integer = Request.QueryString("batchupload")

        'password = Replace(Request.QueryString("pass"), " ", "+")

        Dim usrnfo As New ClsReport
        'username = "IGOT13069380"
        'password = "TQUcK+XWfY7y6t2MhstZ3rtiCXGpIC0cphL8581zbPI=" '17197551
        'batchupload = "1"

        'username = "BATU030203856" '
        'password = "030203856"u

        'FSD
        'username = "NAQU10052678" '
        'password = "hellyeah"

        'SECCOM
        'username = "DELA2009016104" '
        'password = "2009016104"

        'username = "BATU030203856"
        'password = "030203856"

        'username = "PERA940050556"
        'password = "940050556"

        'username = "CELE140738529"
        'password = "140738529"

        'IAD 2
        'username = "CAHI19910002"
        'password = "19910002"

        'IAD 1
        'username = "CARA94008455"
        'password = "94008455"

        'SECCOM
        'username = "DELA2009016103"
        'password = "2009016103"

        'SECCOM
        'username = "ANTI1407298702"
        'password = "14072987"

        'username = "SUYC150961870"
        'password = "123456"

        'username = "SAGA150962119" 'RCM1274
        'password = "15096211ML2"

        'username = "BONGCAWEL" 'RCM1274
        'password = "M654321"

        'username = "BALA150961953" 'RCM1274
        'password = "6idM4ShcHR5tTZw82LRlSsbksPlNgos6YcTG6fIgPFk="

        'DOMESTIC
        'CAD USERS
        'zonecode = 1
        'username = "MARA14073878" 'RCM1274
        'password = "ZywW+WyEfLfjvd3WOLerKoQ0DhYZ7rbvJy0+btZ7cYI="
        'zonecode = 2
        'username = "NUNE080390182" '080390182
        'password = "w5KdutbUaEF8luJkn+QnVBeEUMZ+Y/Y4yTYKm0j7Rk8="
        'zonecode=5
        'username = "NUNE080390183" '080390183
        'password = "/4lYO2GvmBpvw3kcvN61xeEhpI2E9mecV1erMcp2nCs="
        'zonecode=6
        '_username = "NUNE080390184" '080390184
        'password = "eRTCj/p4MuEjrjSYamNhUPVSM6z0BWUz6jB+GIcyLHA="
        'FSD USERS
        'zonecode=1
        ' username = "NUNE0803901810" '0803901810
        'password = "EKauFi8v6TPbvCPCgIuM+s46cE4GXRatgOKKgoYXfEE="
        'zonecode=2
        '_username = "NUNE0803901820" '0803901820
        'password = "CQcl5tCwoDTikEsiinadDRFtuBIQIkL/JXFdPymiNTE="
        'zonecode=5
        '_username = "NUNE0803901830" '0803901830
        'password = "ZWkZKSSHsrORtC/r8dxvwuyvC56B0ho891ZgEyAOZQI="
        'zonecode=6
        '_username = "NUNE0803901840" '0803901840
        'password = "MDtfbqW99xHpyJUNJ2FfIQ3BVKljG+znxrCfzq/+FlI="
        'IAD USERS
        'zonecode = 1
        'username = "SUYC150961877" '94015138
        'password = "o3Wqz+PPrdygUBWGVE75mI6e4HgMzH6QSSXIisXNRn8="
        'zonecode=2
        'username = "MONT19930014" '19930014
        'password = "r1HVeMCMw5CPtg0R90KFwtebBVcRcU0EhYSZbukwWOM="
        'zonecode=5
        '_username = "MONT940042980" '940042980
        'password = "WoFrz0vz+Q2IxBAIs/pMIk3W3839WpYmiuSuL8us+5E="
        'zonecode=6
        '_username = "TANJ1105545602" '1105545602
        'password = "1FoK7EUAjTiyJhX7bvRPN/UXsuB1o0qC+ThEeZrk9Lw="

        'API and WSC
        'username = "AGUIRREANA"
        'password = "YQ+sMf+nGzBgU2WOtUa5sv6z7D8Q612drL2Wmz/Lha4="

        'WSC and FileUpload
        'username = "ARCHIE"
        'password = "WlEVi5ftvAuJnboYXvw1lw4wp3mx5UCd7SvH7MNg5Rw="

        'API()
        ' username = "ACOSTAAR"
        'username = "DAISYR"
        ' password = "1234567"

        'WSC
        'username = "TESTING"
        'password = "UekuPuo38lV4uFj6VAThpbmB5oAwtYnhEMpQWhM3NHI="
        'username = "WABINAAM"
        'password = "8kKuhJ2vtMoBtfiVU7tjXA0qOcgADo//ILSbw64FaxU="

        '----------------------------------------------------------------------
        'SM USERS
        'main account=================
        'KP-SMHO
        'username = "DAISYBRANCH"
        'password = "aeVG+ttN0luLrmjxOCcnMZg4xjOgNJzjc4Jsf1UKuB4="
        'username = "BONGCAWEL"
        'password = "123456"
        'username = "RURALNETUSER"
        'password = "rur4LN3t!nc"

        'username = "LARI1194910"
        'password = "ZdSjeQRy8W/3BJMs6aQJQd44PyL73Gn4YxKews7Lfec="

        'username = "ROSA94003233"
        'password = "94003233"

        '-----------------------------------------------------------------------------
        'seccom
        'username = "LARI1194910"
        'password = "1194910"
        'seccom lncr
        'username = "PUYA0502532501"
        'password = "oxUOlPtdyQP4S7W889ImhHRFUTTZMWI6lTuwnxlBZ/M="
        'seccom vismin
        'username = "PIAS090456915"
        'password = "akOphG48xU1/7Yop8LyHKyclRCYnXDnxBnbV/38Uw0k="

        'PSP
        'username = "AMPOLY"
        'password = "z5J5UD31Yl+/SpJiiMQbtZCzE+V9SqBhffrfow4WTtM="
        'username = "LACSONL"
        'password = "5jCoDz8I3CMoxYRSVONTIq2zEqbCyjb3Czoz9GSAQ5w="

        'BILLSPAYMENT
        'username = "LERONJO"
        'password = "KAODIBrx6TbhY2Lu5slBSuBPO9WZbmk0zi9Um2Sogi0="

        'BATCHUPLOAD
        'username = "AbbyGail21"
        'password = "abby21"

        'username = "jadedev"
        'password = "123456"

        'HRMD
        'username = "BATU030203856"
        'password = "fezVsEO+VJhOHnPrV9yTOog6xrPoNQKekl7WOnIfdR4="

        'HR only
        ' username = "ESCA1564999999"
        'password = "wziPVeH1tBGykRXmBAcntbiCiRw4h2Kg2/mwgUsbIrQ="

        'for ending users KP-CAD
        'username = "PERA94005055"
        'password = "94005055"

        'HO BATSAPLOD
        'username = "CORD94017845"
        'password = "MNfZ+ivjm+Y65lCPuknBY4kQrc/WTnHFCKqS9V9sznc="

        'Billspayment BATELC
        'username = "ESCO1234566"
        'password = "MLINC1234"

        'username = "CINCOT"
        'password = "1234567"

        'username = "TCIN18096969"
        'password = "18096969"

        'FD users only
        'username = "COND06027577"
        'password = "06027577"


        'MIS billspay user
        'username = "ABADMA"
        'password = "123456"

        If Not username = String.Empty And Not password = String.Empty And batchupload = 0 Then
            Try
                Session("username") = username
                Session("password") = deCrypt.AESDecrypt(password, "kWuYDGElyQDpGKM9")

            Catch ex As Exception
                Session("password") = password
            End Try
            CheckUser()
        ElseIf Not username = String.Empty And Not password = String.Empty And batchupload = 1 Then
            Try
                Session("username") = username
                'Session("password") = deCrypt.AESDecrypt(password, "kWuYDGElyQDpGKM9")
		Session("password") = password
                Session("batchupload") = batchupload

            Catch ex As Exception
                Session("password") = password
            End Try
            CheckUser()
        Else
            Response.Redirect("Denied.aspx")
        End If
    End Sub

    Private Sub CheckUser()
        If Session("username") <> String.Empty And Session("password") <> String.Empty And Session("batchupload") = 1 Then
            usrnfo.Uname = Session("username")
            usrnfo.Pword = Session("password")
            usrnfo.BUwallet = Session("batchupload")
        Else
            usrnfo.Uname = Session("username")
            usrnfo.Pword = Session("password")

        End If

        If Session("batchupload") = 1 Then
            _HOBatchUpload = BatchUploadHO(usrnfo.Uname, usrnfo.Pword, usrnfo.BUwallet)
        Else
            _flagDomestic = DomesticLogin(usrnfo.Uname, usrnfo.Pword)
            _flagBillspay = BillspayLogin(usrnfo.Uname, usrnfo.Pword)
            _flagAPI = APILogin(usrnfo.Uname, usrnfo.Pword)
            _flagWSC = WSCLogin(usrnfo.Uname, usrnfo.Pword)
            _flagFileUpload = FileUploadLogin(usrnfo.Uname, usrnfo.Pword)
            '_flagExpress = ExpressLogin(usrnfo.Uname, usrnfo.Pword)
            _flagSpecialPartner = SpecialPArtnerLogin(usrnfo.Uname, usrnfo.Pword)
            _flagBatchUpload = BatchUploadLogin(usrnfo.Uname, usrnfo.Pword)
            _flagExclusive = ExclusiveLogin(usrnfo.Uname, usrnfo.Pword)
            _flagExclusive2 = Exclusive2Login(usrnfo.Uname, usrnfo.Pword)
            _paSPecialugUser = paSPECIALogin(usrnfo.Uname, usrnfo.Pword)

        End If
        If _HOBatchUpload = True Then
            Session("ReportName") = "BatchUploadHO"
            getAccountname(accountID, "BatchUploadHO")
        End If
        If accounttype = "HOBU" Then
            Session("ReportName") = "BatchUploadHO"
            Response.Redirect("CorpMenu.aspx?RptType=13")
        End If
        If _paSPecialugUser = True Then
            If UserInfo.UserFullname <> String.Empty Then
                If Session("roles") = "KP-WALLETDIV" Then
                    Session("ReportName") = "Billspayment"
                    Response.Redirect("CorpMenu.aspx?RptType=2")
                End If
            End If
        End If

        If _flagDomestic = True Then
            If UserInfo.UserFullname <> String.Empty Then
                If Session("roles") = "CAD-DIVMAN" Then
                    Session("ReportName") = "WSC"
                    Response.Redirect("CorpMenu.aspx?RptType=6")
                Else
                    Session("ReportName") = "Domestic"
                    Response.Redirect("MainForm.aspx")
                End If
            End If
        ElseIf _flagExclusive2 = True And UserInfo.JobRole = "KP-PAYROLL" Then
            Session("roles") = "KP-PAYROLL"
            Session("ReportName") = "Domestic"
            Response.Redirect("MainForm.aspx")
        ElseIf _flagExclusive = True And UserInfo.JobRole = "KP-HRMDPAYROLL" Then
            Session("roles") = "KP-HRMDPayroll"
            Session("ReportName") = "Domestic"
            Response.Redirect("MainForm.aspx")


            Call INSERT_TO_ACCESSLOGS_Login()
        ElseIf _flagExpress = True Then
            Session("ReportName") = "MLExpress"
            getAccountname(accountID, "MLExpress")

        ElseIf accountID <> String.Empty Then
            Dim a As String = accountID.Substring(0, 5)
            If _flagBillspay = True And a = "MLBPP" Then
                Session("ReportName") = "Billspayment"
                getAccountname(accountID, "Billspay")
            ElseIf _flagAPI = True Or _flagWSC = True Then
                If _flagAPI = True And _flagWSC = False Then
                    Session("ReportName") = "API"
                    getAccountname(accountID, "API")
                ElseIf _flagWSC = True And _flagAPI = False Then
                    Session("ReportName") = "WSC"
                    getAccountname(accountID, "WSC")
                ElseIf _flagAPI = True And _flagWSC = True Then
                    Session("ReportName") = "WSC"
                    getAccountname(accountID, "WSC")

                End If
            ElseIf _flagFileUpload = True Then
                Session("ReportName") = "Fileupload"
                getAccountname(accountID, "FileUpload")
            ElseIf _flagSpecialPartner = True Then
                Session("ReportName") = "SpecialPartner"
                getAccountname(accountID, "RuralNet")
            ElseIf _flagBatchUpload = True Then
                Session("ReportName") = "BatchUpload"
                getAccountname(accountID, "BatchUpload")
            End If
            If accounttype = "WBU" Then
                Session("ReportName") = "BatchUpload"
                Response.Redirect("CorpMenu.aspx?RptType=11")
            End If
            Call INSERT_TO_ACCESSLOGS_Login()
            If accounttype = "MLCIP" Or accounttype = "MLCDP" Then
                Response.Redirect("CorpMenu.aspx?RptType=1")
            ElseIf accounttype = "MLBPP" Then
                Session("ReportName") = "Billspayment"
                Response.Redirect("CorpMenu.aspx?RptType=2")
            ElseIf accounttype = "MLPSP" Then
                If Session("PartnerName") = Nothing Then
                    Session("ReportName") = "Payment Solution"
                    Response.Redirect("CorpMenu.aspx?RptType=3")
                Else
                    Session("ReportName") = "Fileupload"
                    Response.Redirect("CorpMenu.aspx?RptType=4")
                End If
            ElseIf accounttype = "MLDP" Then
                Session("ReportName") = "SpecialPartner"
                Response.Redirect("CorpMenu.aspx?RptType=9")
            Else
                Response.Redirect("CorpMenu.aspx?RptType=6")
            End If
        Else
            Response.Redirect("Denied.aspx")
        End If
        If cmd.Connection.State = ConnectionState.Closed Then
            Response.Write(String.Format("<script language='javascript'>window.alert('Unable to connect {0}  Server! Please Contact Admin Support!');window.location='Denied.aspx';</script>", Session("ReportName")))
        Else
            Response.Redirect("Denied.aspx")
        End If
    End Sub

    Private Function DomesticLogin(ByVal _username As String, ByVal _password As String) As Boolean
        Try
            CCon.OpenCon("KPUsers")
            errorcon = "Domestic"
            Using CCon.GetCon()
                str = String.Format("call kpusers.getLogin('{0}','P');", _username)
                cmd = New MySqlCommand(str, CCon.GetCon())
                dr = cmd.ExecuteReader

                If dr.HasRows <> Nothing Then
                    While dr.Read
                        type = dr.Item("type").ToString.Trim()
                        UserInfo.Stype = dr.Item("type").ToString.Trim()
                        'If (type = "FA") Then
                        '    Try
                        '        _pass = deCrypt.AESDecrypt(dr.Item("UserPass").ToString.Trim(), "kWuYDGElyQDpGKM9")
                        '    Catch ex As Exception
                        '        _pass = dr.Item("UserPass").ToString.Trim()
                        '    End Try
                        'Else
                        '    _pass = deCrypt.AESDecrypt(dr.Item("UserPass").ToString.Trim(), "kWuYDGElyQDpGKM9")
                        'End If
                        Try
                            _pass = deCrypt.AESDecrypt(dr.Item("UserPass").ToString.Trim(), "kWuYDGElyQDpGKM9")
                        Catch ex As Exception
                            _pass = dr.Item("UserPass").ToString.Trim()
                        End Try
                        If _pass <> _password Or dr.Item("allow").ToString.Trim() = 0 Then
                            Response.Redirect("Denied.aspx")
                        Else
                            UserInfo.UserFullname = dr.Item("Fullname").ToString.Trim()
                            UserInfo.Username = dr.Item("Username").ToString.Trim()
                            UserInfo.OldPass = dr.Item("UserPass").ToString.Trim()
                            UserInfo.JobRole = dr.Item("JobRole").ToString.Trim()
                            UserInfo.RegionName = dr.Item("Region").ToString.Trim()
                            UserInfo.ResourceID = dr.Item("resourceid").ToString.Trim()
                            UserInfo.ZoneCode = dr.Item("ZoneCode").ToString.Trim()
                            UserInfo.RegionCode = If(IsDBNull(dr.Item("regioncode").ToString()), "1", dr.Item("regioncode").ToString.Trim())
                            UserInfo.Stype = type
                            UserInfo.FirstName = dr.Item("firstname").ToString.Trim()
                            UserInfo.LastName = dr.Item("lastname").ToString.Trim()

                            Session("UserFullname") = UserInfo.UserFullname.ToUpper()
                            Session("UserName") = UserInfo.Username
                            Session("UserPass") = UserInfo.OldPass
                            Session("roles") = UserInfo.JobRole
                            Session("zcode") = UserInfo.ZoneCode
                            Session("res_id") = UserInfo.ResourceID
                            Session("UserInfo") = UserInfo
                            Session("stype") = UserInfo.Stype
                            Session("rname") = UserInfo.RegionName
                            Session("rcode") = UserInfo.RegionCode
                            Session("firstname") = UserInfo.FirstName
                            Session("lastname") = UserInfo.LastName
                        End If
                        Return True
                    End While
                    dr.Close()
                End If
            End Using
        Catch ex As Exception
            Return False
        End Try
        Return False
    End Function
    Private Function paSPECIALogin(ByVal _username As String, ByVal _password As String) As Boolean
        Try
            CCon.OpenCon("KPUsers")
            errorcon = "Domestic"
            Using CCon.GetCon()
                str = String.Format("call kpusers.getLogin('{0}','J');", _username)
                cmd = New MySqlCommand(str, CCon.GetCon())
                dr = cmd.ExecuteReader

                If dr.HasRows <> Nothing Then
                    While dr.Read
                        type = dr.Item("type").ToString.Trim()
                        UserInfo.Stype = dr.Item("type").ToString.Trim()
                        'If (type = "FA") Then
                        '    Try
                        '        _pass = deCrypt.AESDecrypt(dr.Item("UserPass").ToString.Trim(), "kWuYDGElyQDpGKM9")
                        '    Catch ex As Exception
                        '        _pass = dr.Item("UserPass").ToString.Trim()
                        '    End Try
                        'Else
                        '    _pass = deCrypt.AESDecrypt(dr.Item("UserPass").ToString.Trim(), "kWuYDGElyQDpGKM9")
                        'End If
                        Try
                            _pass = deCrypt.AESDecrypt(dr.Item("UserPass").ToString.Trim(), "kWuYDGElyQDpGKM9")
                        Catch ex As Exception
                            _pass = dr.Item("UserPass").ToString.Trim()
                        End Try
                        If _pass <> _password Or dr.Item("allow").ToString.Trim() = 0 Then
                            Response.Redirect("Denied.aspx")
                        Else
                            accountID = dr.Item("resourceid").ToString.Trim()
                            UserInfo.UserFullname = dr.Item("Fullname").ToString.Trim()
                            UserInfo.Username = dr.Item("Username").ToString.Trim()
                            UserInfo.OldPass = dr.Item("UserPass").ToString.Trim()
                            UserInfo.JobRole = dr.Item("JobRole").ToString.Trim()
                            UserInfo.RegionName = dr.Item("Region").ToString.Trim()
                            UserInfo.ResourceID = dr.Item("resourceid").ToString.Trim()
                            UserInfo.ZoneCode = dr.Item("ZoneCode").ToString.Trim()
                            UserInfo.RegionCode = If(IsDBNull(dr.Item("regioncode").ToString()), "1", dr.Item("regioncode").ToString.Trim())
                            UserInfo.Stype = type
                            UserInfo.FirstName = dr.Item("firstname").ToString.Trim()
                            UserInfo.LastName = dr.Item("lastname").ToString.Trim()

                            Session("PartnerID") = "KP-WALLETDIV"
                            Session("UserFullname") = UserInfo.UserFullname.ToUpper()
                            Session("UserName") = UserInfo.Username
                            Session("UserPass") = UserInfo.OldPass
                            Session("roles") = UserInfo.JobRole
                            Session("zcode") = UserInfo.ZoneCode
                            Session("res_id") = UserInfo.ResourceID
                            Session("UserInfo") = UserInfo
                            Session("stype") = UserInfo.Stype
                            Session("rname") = UserInfo.RegionName
                            Session("rcode") = UserInfo.RegionCode
                            Session("firstname") = UserInfo.FirstName
                            Session("lastname") = UserInfo.LastName
                        End If
                        Return True
                    End While
                    dr.Close()
                End If
            End Using
        Catch ex As Exception
            Return False
        End Try
        Return False
    End Function
    Private Function ExclusiveLogin(ByVal _username As String, ByVal _password As String) As Boolean
        Try
            CCon.OpenCon("KPUsers")
            errorcon = "Domestic"
            Using CCon.GetCon()
                str = String.Format("call kpusers.getLogin('{0}','Z');", _username)
                cmd = New MySqlCommand(str, CCon.GetCon())
                dr = cmd.ExecuteReader

                If dr.HasRows <> Nothing Then
                    While dr.Read
                        type = dr.Item("type").ToString.Trim()
                        UserInfo.Stype = dr.Item("type").ToString.Trim()
                        'If (type = "FA") Then
                        '    Try
                        '        _pass = deCrypt.AESDecrypt(dr.Item("UserPass").ToString.Trim(), "kWuYDGElyQDpGKM9")
                        '    Catch ex As Exception
                        '        _pass = dr.Item("UserPass").ToString.Trim()
                        '    End Try
                        'Else
                        '    _pass = deCrypt.AESDecrypt(dr.Item("UserPass").ToString.Trim(), "kWuYDGElyQDpGKM9")
                        'End If
                        Try
                            _pass = deCrypt.AESDecrypt(dr.Item("UserPass").ToString.Trim(), "kWuYDGElyQDpGKM9")
                        Catch ex As Exception
                            _pass = dr.Item("UserPass").ToString.Trim()
                        End Try
                        If _pass <> _password Or dr.Item("allow").ToString.Trim() = 0 Then
                            Response.Redirect("Denied.aspx")
                        Else
                            accountID = dr.Item("resourceid").ToString.Trim()
                            UserInfo.UserFullname = dr.Item("Fullname").ToString.Trim()
                            UserInfo.Username = dr.Item("Username").ToString.Trim()
                            UserInfo.OldPass = dr.Item("UserPass").ToString.Trim()
                            UserInfo.JobRole = dr.Item("JobRole").ToString.Trim()
                            UserInfo.RegionName = dr.Item("Region").ToString.Trim()
                            UserInfo.ResourceID = dr.Item("resourceid").ToString.Trim()
                            UserInfo.ZoneCode = dr.Item("ZoneCode").ToString.Trim()
                            UserInfo.RegionCode = If(IsDBNull(dr.Item("regioncode").ToString()), "1", dr.Item("regioncode").ToString.Trim())
                            UserInfo.Stype = type
                            UserInfo.FirstName = dr.Item("firstname").ToString.Trim()
                            UserInfo.LastName = dr.Item("lastname").ToString.Trim()

                            Session("PartnerID") = accountID
                            Session("UserFullname") = UserInfo.UserFullname.ToUpper()
                            Session("UserName") = UserInfo.Username
                            Session("UserPass") = UserInfo.OldPass
                            Session("roles") = UserInfo.JobRole
                            Session("zcode") = UserInfo.ZoneCode
                            Session("res_id") = UserInfo.ResourceID
                            Session("UserInfo") = UserInfo
                            Session("stype") = UserInfo.Stype
                            Session("rname") = UserInfo.RegionName
                            Session("rcode") = UserInfo.RegionCode
                            Session("firstname") = UserInfo.FirstName
                            Session("lastname") = UserInfo.LastName
                        End If
                        Return True
                    End While
                    dr.Close()
                End If
            End Using
        Catch ex As Exception
            Return False
        End Try
        Return False
    End Function
    Private Function Exclusive2Login(ByVal _username As String, ByVal _password As String) As Boolean
        Try
            CCon.OpenCon("KPUsers")
            errorcon = "Domestic"
            Using CCon.GetCon()
                str = String.Format("call kpusers.getLogin('{0}','Z');", _username)
                cmd = New MySqlCommand(str, CCon.GetCon())
                dr = cmd.ExecuteReader

                If dr.HasRows <> Nothing Then
                    While dr.Read
                        type = dr.Item("type").ToString.Trim()
                        UserInfo.Stype = dr.Item("type").ToString.Trim()
                        'If (type = "FA") Then
                        '    Try
                        '        _pass = deCrypt.AESDecrypt(dr.Item("UserPass").ToString.Trim(), "kWuYDGElyQDpGKM9")
                        '    Catch ex As Exception
                        '        _pass = dr.Item("UserPass").ToString.Trim()
                        '    End Try
                        'Else
                        '    _pass = deCrypt.AESDecrypt(dr.Item("UserPass").ToString.Trim(), "kWuYDGElyQDpGKM9")
                        'End If
                        Try
                            _pass = deCrypt.AESDecrypt(dr.Item("UserPass").ToString.Trim(), "kWuYDGElyQDpGKM9")
                        Catch ex As Exception
                            _pass = dr.Item("UserPass").ToString.Trim()
                        End Try
                        If _pass <> _password Or dr.Item("allow").ToString.Trim() = 0 Then
                            Response.Redirect("Denied.aspx")
                        Else
                            accountID = dr.Item("resourceid").ToString.Trim()
                            UserInfo.UserFullname = dr.Item("Fullname").ToString.Trim()
                            UserInfo.Username = dr.Item("Username").ToString.Trim()
                            UserInfo.OldPass = dr.Item("UserPass").ToString.Trim()
                            UserInfo.JobRole = dr.Item("JobRole").ToString.Trim()
                            UserInfo.RegionName = dr.Item("Region").ToString.Trim()
                            UserInfo.ResourceID = dr.Item("resourceid").ToString.Trim()
                            UserInfo.ZoneCode = dr.Item("ZoneCode").ToString.Trim()
                            UserInfo.RegionCode = If(IsDBNull(dr.Item("regioncode").ToString()), "1", dr.Item("regioncode").ToString.Trim())
                            UserInfo.Stype = type
                            UserInfo.FirstName = dr.Item("firstname").ToString.Trim()
                            UserInfo.LastName = dr.Item("lastname").ToString.Trim()

                            Session("PartnerID") = accountID
                            Session("UserFullname") = UserInfo.UserFullname.ToUpper()
                            Session("UserName") = UserInfo.Username
                            Session("UserPass") = UserInfo.OldPass
                            Session("roles") = UserInfo.JobRole
                            Session("zcode") = UserInfo.ZoneCode
                            Session("res_id") = UserInfo.ResourceID
                            Session("UserInfo") = UserInfo
                            Session("stype") = UserInfo.Stype
                            Session("rname") = UserInfo.RegionName
                            Session("rcode") = UserInfo.RegionCode
                            Session("firstname") = UserInfo.FirstName
                            Session("lastname") = UserInfo.LastName
                        End If
                        Return True
                    End While
                    dr.Close()
                End If
            End Using
        Catch ex As Exception
            Return False
        End Try
        Return False
    End Function
    Private Function APILogin(ByVal _username As String, ByVal _password As String) As Boolean
        Dim again As Int16 = 0
        Try
            str = String.Format("SELECT trim(p.userid) as userid,trim(p.password) as password,trim(p.accountid) as accountid,trim(CONCAT(p.Firstname,' ',p.Lastname)) AS Fullname,trim(a.integrationtype) as integrationtype,trim(p.RoleID) as RoleID FROM kpadminpartners.partnersusers p INNER JOIN kpadminpartners.accountintegration a ON a.accountid=p.accountid WHERE userid = '{0}' AND password = '{1}' and p.isActive=1 AND SUBSTRING(p.accountid,1,5)!='MLBPP' AND a.integrationtype IN ('1') ", _username, _password)
            CCon.OpenCon("KPAPI")
newapicon:
            cmd = New MySqlCommand(str, CCon.GetCon())
            dr = cmd.ExecuteReader
            If dr.HasRows = False And again = 0 Then
                dr.Close()
                again = 1
                CCon.OpenCon("KPAPINEW")
                GoTo newapicon
            End If
            While dr.Read
                accountID = dr.Item("accountid").ToString.Trim()
                UserInfo.UserFullname = dr.Item("Fullname").ToString.Trim()
                UserInfo.Username = dr.Item("userid").ToString.Trim()
                UserInfo.OldPass = dr.Item("password").ToString.Trim()
                UserInfo.JobRole = dr.Item("RoleID").ToString.Trim()

                Session("UserFullname") = UserInfo.UserFullname.ToUpper()
                Session("UserName") = UserInfo.Username
                Session("UserPass") = UserInfo.OldPass
                Session("PartnerID") = accountID
                Session("Roles") = UserInfo.JobRole
                Session("UserInfo") = UserInfo
                Return True
            End While
            dr.Close()
        Catch ex As Exception
            Return False
        End Try
        Return False
    End Function
    Private Function WSCLogin(ByVal _username As String, ByVal _password As String) As Boolean
        Try
            Dim issub As Boolean = False
            CCon.OpenCon("KPWSC")
            str = String.Format("SELECT trim(p.userid) as userid,trim(p.password) as password,trim(p.accountid) as accountid,trim(CONCAT(p.Firstname,' ',p.Lastname)) AS Fullname,trim(a.integrationtype) as integrationtype,trim(p.RoleID) as RoleID FROM kpadminpartners.partnersusers p INNER JOIN kpadminpartners.accountintegration a ON a.accountid=p.accountid WHERE p.userid = '{0}' AND p.password = '{1}' and p.isActive=1 AND SUBSTRING(p.accountid,1,5)!='MLBPP' AND a.integrationtype IN ('3') ", _username, _password)
            cmd = New MySqlCommand(str, CCon.GetCon())
            dr = cmd.ExecuteReader
            If (dr.HasRows = False) Then
                dr.Close()
                strsub = String.Format("SELECT p.userid,p.password,p.subterminalid,p.superviselocationid,p.subaccountid AS accountid,CONCAT(p.Firstname,' ',p.Lastname) AS Fullname,a.integrationtype,p.RoleID FROM kpadminpartners.wssubpartnersusers p INNER JOIN kpadminpartners.accountintegration a ON a.accountid=p.subaccountid WHERE p.userid = '{0}' AND p.password = '{1}' and p.isActive=1 AND SUBSTRING(p.subaccountid,1,5)!='MLBPP' AND a.integrationtype IN ('3') ", _username, _password)
                cmd = New MySqlCommand(strsub, CCon.GetCon())
                dr = cmd.ExecuteReader
                issub = True
            End If
            While dr.Read
                accountID = dr.Item("accountid").ToString.Trim()
                UserInfo.UserFullname = dr.Item("Fullname").ToString.Trim()
                UserInfo.Username = dr.Item("userid").ToString.Trim()
                UserInfo.OldPass = dr.Item("password").ToString.Trim()
                UserInfo.JobRole = dr.Item("RoleID").ToString.Trim()
                Session("UserFullname") = UserInfo.UserFullname.ToUpper()
                Session("UserName") = UserInfo.Username
                Session("UserPass") = UserInfo.OldPass
                Session("PartnerID") = accountID
                Session("Roles") = UserInfo.JobRole
                Session("UserInfo") = UserInfo
                If issub = True Then
                    UserInfo.terminalid = dr.Item("subterminalid").ToString.Trim()
                    UserInfo.sublocationid = dr.Item("superviselocationid").ToString.Trim()
                    Session("subterminalid") = UserInfo.terminalid
                    Session("superviselocationid") = UserInfo.sublocationid
                End If
                Return True
            End While
            dr.Close()
        Catch ex As Exception
            Return False
        End Try
        Return False
    End Function
    Private Function BillspayLogin(ByVal _username As String, ByVal _password As String) As Boolean
        Try
            CCon.OpenCon("KPBillsPayment")
            str = String.Format("SELECT userid,password,accountid,concat(Firstname,' ',Lastname) AS Fullname,RoleID FROM kpadminpartners.partnersusers WHERE userid = '{0}' AND password = '{1}' and isActive=1  AND SUBSTRING(accountid,1,5)='MLBPP'", _username, _password)
            cmd = New MySqlCommand(str, CCon.GetCon())
            dr = cmd.ExecuteReader
            While dr.Read
                accountID = dr.Item("accountid").ToString.Trim()
                UserInfo.UserFullname = dr.Item("Fullname").ToString.Trim()
                UserInfo.Username = dr.Item("userid").ToString.Trim()
                UserInfo.OldPass = dr.Item("password").ToString.Trim()
                UserInfo.JobRole = dr.Item("RoleID").ToString.Trim()

                Session("UserFullname") = UserInfo.UserFullname.ToUpper()
                Session("UserName") = UserInfo.Username
                Session("UserPass") = UserInfo.OldPass
                Session("PartnerID") = accountID
                Session("Roles") = UserInfo.JobRole
                Session("UserInfo") = UserInfo
                Return True
            End While
            dr.Close()
        Catch ex As Exception
            Return False
        End Try
        Return False
    End Function
    Private Function FileUploadLogin(ByVal _username As String, ByVal _password As String) As Boolean
        Try
            CCon.OpenCon("KPFileUpload")
            str = String.Format("SELECT trim(p.userid) as userid,trim(p.password) as password,trim(p.accountid) as accountid,trim(CONCAT(p.Firstname,' ',p.Lastname)) AS Fullname,trim(a.integrationtype) as integrationtype,trim(p.RoleID) as RoleID FROM kpadminpartners.partnersusers p INNER JOIN kpadminpartners.accountintegration a ON a.accountid=p.accountid WHERE userid = '{0}' AND password = '{1}' and p.isActive=1 AND SUBSTRING(p.accountid,1,5)!='MLBPP' AND a.integrationtype IN ('2','4') ", _username, _password)
            cmd = New MySqlCommand(str, CCon.GetCon())
            dr = cmd.ExecuteReader
            While dr.Read
                accountID = dr.Item("accountid").ToString.Trim()
                UserInfo.UserFullname = dr.Item("Fullname").ToString.Trim()
                UserInfo.Username = dr.Item("userid").ToString.Trim()
                UserInfo.OldPass = dr.Item("password").ToString.Trim()
                UserInfo.JobRole = dr.Item("RoleID").ToString.Trim()

                Session("UserFullname") = UserInfo.UserFullname.ToUpper()
                Session("UserName") = UserInfo.Username
                Session("UserPass") = UserInfo.OldPass
                Session("PartnerID") = accountID
                Session("Roles") = UserInfo.JobRole
                Session("UserInfo") = UserInfo
                Return True
            End While
            dr.Close()
        Catch ex As Exception
            Return False
        End Try
        Return False
    End Function

    Private Function SpecialPArtnerLogin(ByVal _username As String, ByVal _password As String) As Boolean
        Try
            CCon.OpenCon("RuralNet")
            str = String.Format("SELECT accountid,userid,accesskey AS PASSWORD,userid AS fullname,'KP-TELLER' AS roleid FROM `kpadminpartners`.`accountcredential` WHERE userid='{0}' AND accesskey='{1}' ", _username, _password)
            cmd = New MySqlCommand(str, CCon.GetCon())
            dr = cmd.ExecuteReader
            While dr.Read
                accountID = dr.Item("accountid").ToString.Trim()
                UserInfo.UserFullname = dr.Item("Fullname").ToString.Trim()
                UserInfo.Username = dr.Item("userid").ToString.Trim()
                UserInfo.OldPass = dr.Item("password").ToString.Trim()
                UserInfo.JobRole = dr.Item("RoleID").ToString.Trim()

                Session("UserFullname") = UserInfo.UserFullname.ToUpper()
                Session("UserName") = UserInfo.Username
                Session("UserPass") = UserInfo.OldPass
                Session("PartnerID") = accountID
                Session("Roles") = UserInfo.JobRole
                Session("UserInfo") = UserInfo
                Return True
            End While
            dr.Close()
        Catch ex As Exception
            Return False
        End Try
        Return False
    End Function

    'Private Function ExpressLogin(ByVal _username As String, ByVal _password As String) As Boolean
    '    Try
    '        CCon.OpenCon("KPMLExpress")
    '        'str = "SELECT p.userid,p.password,p.accountid,CONCAT(p.Firstname,' ',p.Lastname) AS Fullname,a.integrationtype,p.RoleID FROM kpadminpartners.partnersusers p INNER JOIN kpadminpartners.accountintegration a ON a.accountid=p.accountid WHERE userid = '" & _username & "' AND password = '" & _password & "' and p.isActive=1 AND SUBSTRING(p.accountid,1,5)!='MLBPP' AND a.integrationtype IN ('2','4') "
    '        'cmd = New MySqlCommand(str, CCon.GetCon())
    '        'dr = cmd.ExecuteReader
    '        'While dr.Read
    '        '    accountID = dr.Item("accountid").ToString
    '        '    UserInfo.UserFullname = dr.Item("Fullname")
    '        '    UserInfo.Username = dr.Item("userid")
    '        '    UserInfo.OldPass = dr.Item("password")
    '        '    UserInfo.JobRole = dr.Item("RoleID")

    '        '    Session("UserFullname") = UserInfo.UserFullname.ToUpper()
    '        '    Session("UserName") = UserInfo.Username
    '        '    Session("UserPass") = UserInfo.OldPass
    '        '    Session("PartnerID") = accountID
    '        '    Session("Roles") = UserInfo.JobRole
    '        '    Session("UserInfo") = UserInfo
    '        '    Return True
    '        'End While
    '        'dr.Close()
    '    Catch ex As Exception
    '        Return False
    '    End Try
    '    Return False
    'End Function
    Private Function BatchUploadLogin(ByVal _username As String, ByVal _password As String) As Boolean
        Try
            CCon.OpenCon("KPMLWallet")
            str = String.Format("select a.username,a.custid,a.password,concat(m.firstname,' ',m.middlename,' ',m.lastname) as fullname,m.walletno from `kpmobile`.`mobilelogin` a inner join `kpmobile`.`mobileaccounts` m on m.walletno = a.walletno where a.username='{0}' and a.password = '{1}' ", _username, _password)
            cmd = New MySqlCommand(str, CCon.GetCon())
            dr = cmd.ExecuteReader
            While dr.Read
                accounttype = "WBU"
                accountID = dr.Item("walletno").ToString.Trim()
                walletID = dr.Item("walletno").ToString.Trim()
                UserInfo.UserFullname = dr.Item("Fullname").ToString.Trim()
                UserInfo.Username = dr.Item("username").ToString.Trim()
                UserInfo.OldPass = dr.Item("password").ToString.Trim()
                Session("UserFullname") = UserInfo.UserFullname.ToUpper()
                Session("UserName") = UserInfo.Username
                Session("UserPass") = UserInfo.OldPass
                Session("PartnerID") = accountID
                Session("UserInfo") = UserInfo
                Return True
            End While
            dr.Close()
        Catch ex As Exception
            Return False
        End Try
        Return False
    End Function
    Private Function BatchUploadHO(ByVal _username As String, ByVal _password As String, walletnum As String) As Boolean
        Try
            CCon.OpenCon("KPMLWallet")
            str = String.Format(" SELECT operatorid as username,userpassword as password ,walletno,fullname,roleid as JobRole, divcode,a.zonecode as zcode FROM `kpmobile`.`walletbatchuploadusers` w " +
                                " INNER JOIN kpusers.adminsysuseraccounts a ON a.userlogin = w.operatorid" +
                                " INNER JOIN kpusers.`adminbranchusers` b ON b.resourceid = a.resourceid " +
                                " WHERE a.isactive = 1 AND userlogin = '{0}'; ", _username)
            cmd = New MySqlCommand(str, CCon.GetCon())
            dr = cmd.ExecuteReader
            While dr.Read
                accounttype = "HOBU"
                accountID = dr.Item("walletno").ToString.Trim()
                walletID = dr.Item("walletno").ToString.Trim()
                UserInfo.UserFullname = dr.Item("Fullname").ToString.Trim()
                UserInfo.Username = dr.Item("username").ToString.Trim()
                UserInfo.OldPass = dr.Item("password").ToString.Trim()
                UserInfo.JobRole = dr.Item("JobRole").ToString.Trim()
                divcode = dr.Item("divcode").ToString.Trim()
                zcode = dr.Item("zcode").ToString.Trim()
                Session("UserFullname") = UserInfo.UserFullname.ToUpper()
                Session("UserName") = UserInfo.Username
                Session("UserPass") = UserInfo.OldPass
                Session("PartnerID") = accountID
                Session("UserInfo") = UserInfo
                Session("roles") = UserInfo.JobRole
                Session("divcode") = divcode
                Session("zcode") = zcode
                Return True
            End While
            dr.Close()
        Catch ex As Exception
            Return False
        End Try
        Return False
    End Function

    Private Sub getAccountname(ByVal accountid As String, ByVal _type As String)
        Try
            If _type = "Billspay" Then
                CCon.OpenCon("KPBillsPayment")
            ElseIf _type = "API" Then
                CCon.OpenCon("KPAPI")
            ElseIf _type = "WSC" Then
                CCon.OpenCon("KPWSC")
            ElseIf _type = "FileUpload" Then
                CCon.OpenCon("KPFileUpload")
            ElseIf _type = "MLExpress" Then
                CCon.OpenCon("KPMLExpress")
            ElseIf _type = "RuralNet" Then
                CCon.OpenCon("RuralNet")
            ElseIf _type = "BatchUpload" Then
                CCon.OpenCon("KPMLWallet")
            ElseIf _type = "HRMD" Then
                CCon.OpenCon("KPUsers")
            ElseIf _type = "BatchUploadHO" Then
                CCon.OpenCon("KPMLWallet")
            End If


            Dim again As Int16 = 0
newapicon:
            If again = 1 And _type = "API" Then
                CCon.OpenCon("KPAPINEW")
            End If
            If _type = "BatchUpload" Then
                str = String.Format("SELECT username as accountname, walletno, 'WBU' as accounttype FROM `kpmobile`.`mobileaccounts` WHERE walletno = '{0}' ", accountid.Trim)
            ElseIf _type = "BatchUploadHO" Then
                str = String.Format("SELECT username as accountname, walletno, 'HOBU' as accounttype FROM `kpmobile`.`mobileaccounts` WHERE walletno = '{0}' ", accountid.Trim)
            Else
                str = String.Format("SELECT trim(accountname) as accountname,trim(accounttype) as accounttype FROM kpadminpartners.accountlist WHERE accountid = '{0}'", accountid.Trim)
            End If
            Using CCon.GetCon()
                cmd = New MySqlCommand(str, CCon.GetCon())
                dr = cmd.ExecuteReader
                While dr.Read
                    accountname = dr.Item("accountname").ToString.Trim()
                    accounttype = dr.Item("accounttype").ToString.Trim()
                    Session("PartnerName") = accountname
                    Session("PartnerType") = accounttype
                    again = 1
                End While
                dr.Close()
            End Using
            If again = 0 And _type = "API" Then
                again = 1
                GoTo newapicon
            End If
        Catch ex As Exception
            Response.Redirect("Denied.aspx")
        End Try
    End Sub


    Public Sub INSERT_TO_ACCESSLOGS_Login()
        Dim reportname As String = Session("ReportName")
        Const flagging As String = "1"
        Try
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
                'ElseIf reportname = "BatchUpload" Then
                '    CCon.OpenCon("KPMLWallet")
            End If
            Dim usrnfo As New ClsReport
            Using CCon.GetCon()
                str = String.Format("call kpusers.accesslogs('{0}','{1}','{2}');", UserInfo.Username, reportname, flagging)
                cmd = New MySqlCommand(str, CCon.GetCon())
                If cmd.Connection.State = ConnectionState.Closed Then
                    Response.Write(String.Format("<script language='javascript'>window.alert('Unable to connect {0}  Server! Please Contact Admin Support!');window.location='Denied.aspx';</script>", reportname))
                Else
                    dr = cmd.ExecuteReader
                    CCon.CloseCon()
                    cmd.Dispose()
                    dr.Close()
                End If
            End Using
        Catch ex As Exception
            Response.Redirect("Denied.aspx")
        End Try
    End Sub
    
    Public Sub clearSession()
        Session("username") = Nothing
        Session("password") = Nothing
        Session("ReportName") = Nothing
        Session("PartnerName") = Nothing
        Session("PartnerID") = Nothing
        Session("UserFullname") = Nothing
        Session("UserName") = Nothing
        Session("UserPass") = Nothing
        Session("roles") = Nothing
        Session("stype") = Nothing
        Session("rname") = Nothing
        Session("rcode") = Nothing
        Session("zcode") = Nothing
        Session("res_id") = Nothing
        Session("UserInfo") = Nothing
        Session("stype") = Nothing
        Session("PartnerType") = Nothing
        Session("walletno") = Nothing
    End Sub
    'Public Function EncryptPassword(ByVal txtPassword As String) As String
    '    Dim passBytes As Byte() = System.Text.Encoding.Unicode.GetBytes(txtPassword)
    '    Dim encryptPassword__1 As String = Convert.ToBase64String(passBytes)
    '    Return encryptPassword__1
    'End Function
    'Public Function DecryptPassword(ByVal encryptedPassword As String) As String
    '    Dim passByteData As Byte() = Convert.FromBase64String(encryptedPassword)
    '    Dim originalPassword As String = System.Text.Encoding.Unicode.GetString(passByteData)
    '    Return originalPassword
    'End Function
End Class
