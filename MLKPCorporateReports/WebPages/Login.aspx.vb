Imports DAL
Imports UserInfo

Imports MySql.Data.MySqlClient
Partial Class Login
    Inherits System.Web.UI.Page
    Dim Correct As Boolean
    Dim CCon As New ClsCon
    Dim UserInfo As New UserInfo
    Dim accountname As String = String.Empty
    Dim accounttype As String = String.Empty
    Dim accountID As String = String.Empty

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
    End Sub
End Class
