Imports Microsoft.VisualBasic
Imports MySql.Data.MySqlClient

Public Class ClsCon
    Protected constring As String = String.Empty
    Protected Con As MySqlConnection = Nothing
    Public Function OpenCon(ByVal Constring As String) As Boolean
        Try

            If Constring = "KPFileUploadA" Then
                Constring = ConfigurationManager.ConnectionStrings("KPFileUploadA").ConnectionString
            ElseIf Constring = "KPFileUpload" Then
                Constring = ConfigurationManager.ConnectionStrings("KPFileUpload").ConnectionString
            ElseIf Constring = "KPBillsPaymentA" Then
                Constring = ConfigurationManager.ConnectionStrings("KPBillsPaymentA").ConnectionString
            ElseIf Constring = "KPBillsPayment" Then
                Constring = ConfigurationManager.ConnectionStrings("KPBillsPayment").ConnectionString
            ElseIf Constring = "KPAPIA" Then
                Constring = ConfigurationManager.ConnectionStrings("KPAPIA").ConnectionString
            ElseIf Constring = "KPAPI" Then
                Constring = ConfigurationManager.ConnectionStrings("KPAPI").ConnectionString
            ElseIf Constring = "KPAPINEW" Then
                Constring = ConfigurationManager.ConnectionStrings("KPAPINEW").ConnectionString
            ElseIf Constring = "KPAPINEWA" Then
                Constring = ConfigurationManager.ConnectionStrings("KPAPINEWA").ConnectionString
            ElseIf Constring = "KPWSCA" Then
                Constring = ConfigurationManager.ConnectionStrings("KPWSCA").ConnectionString
            ElseIf Constring = "KPWSC" Then
                Constring = ConfigurationManager.ConnectionStrings("KPWSC").ConnectionString
            ElseIf Constring = "KPUsersA" Then
                Constring = ConfigurationManager.ConnectionStrings("KPUsersA").ConnectionString
            ElseIf Constring = "KPUsers" Then
                Constring = ConfigurationManager.ConnectionStrings("KPUsers").ConnectionString
                'ElseIf Constring = "KPDomesticNew" Then
                '    Constring = ConfigurationManager.ConnectionStrings("KPDomesticNew").ConnectionString
            ElseIf Constring = "KPMLExpressA" Then
                Constring = ConfigurationManager.ConnectionStrings("KPMLExpressA").ConnectionString
            ElseIf Constring = "KPMLExpress" Then
                Constring = ConfigurationManager.ConnectionStrings("KPMLExpress").ConnectionString
            ElseIf Constring = "KPMLWallet" Then
                Constring = ConfigurationManager.ConnectionStrings("KPMLWallet").ConnectionString
            ElseIf Constring = "KPMLWalletEmp" Then
                Constring = ConfigurationManager.ConnectionStrings("KPMLWalletEmp").ConnectionString
            ElseIf Constring = "KPGLOBAL" Then
                Constring = ConfigurationManager.ConnectionStrings("KPGLOBAL").ConnectionString
            ElseIf Constring = "KPBillspayGlobal" Then
                Constring = ConfigurationManager.ConnectionStrings("KPBillspayGlobal").ConnectionString
            ElseIf Constring = "MLOnline" Then
                Constring = ConfigurationManager.ConnectionStrings("MLOnline").ConnectionString
            ElseIf Constring = "MLEload" Then
                Constring = ConfigurationManager.ConnectionStrings("MLEload").ConnectionString
            ElseIf Constring = "KPGLOBALCloud" Then
                Constring = ConfigurationManager.ConnectionStrings("KPGLOBALCloud").ConnectionString
            ElseIf Constring = "DomesticCloud" Then
                Constring = ConfigurationManager.ConnectionStrings("DomesticCloud").ConnectionString
            ElseIf Constring = "MLEpay" Then
                Constring = ConfigurationManager.ConnectionStrings("MLEpay").ConnectionString
            ElseIf Constring = "AUB" Then
                Constring = ConfigurationManager.ConnectionStrings("AUB").ConnectionString
            ElseIf Constring = "RuralNet" Then
                Constring = ConfigurationManager.ConnectionStrings("RuralNet").ConnectionString
            ElseIf Constring = "KP8DomesticB" Then
                Constring = ConfigurationManager.ConnectionStrings("KP8DomesticB").ConnectionString
            ElseIf Constring = "WesternUnion" Then
                Constring = ConfigurationManager.ConnectionStrings("WesternUnion").ConnectionString
            ElseIf Constring = "KPWalletSplitB" Then
                Constring = ConfigurationManager.ConnectionStrings("KPWalletSplitB").ConnectionString
            ElseIf Constring = "KPWallet-BillspayDB" Then
                Constring = ConfigurationManager.ConnectionStrings("KPWallet-BillspayDB").ConnectionString
            End If
            Con = New MySqlConnection(Constring)
            Con.Open()
            Return True
        Catch ex As Exception
            Return False
            Throw New Exception(ex.ToString())
        End Try
    End Function

    Public Function CloseCon() As Boolean
        Try
            Con.Close()
            Return True
        Catch ex As Exception
            Return False
            Throw New Exception(ex.ToString())
        End Try
    End Function

    Public Function GetCon() As MySqlConnection
        Return Con
    End Function

    Function getconn() As Object
        Throw New NotImplementedException
    End Function

    Sub Close()
        Throw New NotImplementedException
    End Sub

End Class
