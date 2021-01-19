Imports System.Net.ServicePointManager
Imports System.Security.Cryptography.X509Certificates
Imports System.Net.Security
Partial Class controls_Notice
    Inherits System.Web.UI.UserControl
    Public Property NOticepub() As AjaxControlToolkit.ModalPopupExtender
        Get
            Return ModalPopupExtender1
        End Get
        Set(ByVal value As AjaxControlToolkit.ModalPopupExtender)
            ModalPopupExtender1 = value
        End Set
    End Property
    Protected Sub Button2_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles Button2.Click
        Exit Sub
    End Sub
End Class
