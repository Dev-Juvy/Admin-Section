Imports System.Net.ServicePointManager
Imports System.Security.Cryptography.X509Certificates
Imports System.Net.Security
Partial Class controls_email

    Inherits System.Web.UI.UserControl
    Dim pass As New ClsReport
    Public Property EmailOpen() As AjaxControlToolkit.ModalPopupExtender
        Get
            Return ModalPopupExtender1
        End Get
        Set(ByVal value As AjaxControlToolkit.ModalPopupExtender)
            ModalPopupExtender1 = value
        End Set
    End Property
    Protected Sub Button2_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles Button2.Click

        Dim txt As New ClsReport
        If TxtEmailAddress.Text <> String.Empty Then
            txt.txtemail = TxtEmailAddress.Text

            Session("emailaddress") = TxtEmailAddress.Text
            Class1.Emailor = True
            Exit Sub
        End If
    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

    End Sub

    Protected Sub Button3_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles Button3.Click

        Class1.Emailor = False
        Session("emailaddress") = String.Empty
        Me.Dispose()
    End Sub
End Class
