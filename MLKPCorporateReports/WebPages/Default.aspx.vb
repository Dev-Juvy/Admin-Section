
Partial Class WebPages_Default
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        lblError.Text = Request.QueryString("String")
    End Sub
End Class
