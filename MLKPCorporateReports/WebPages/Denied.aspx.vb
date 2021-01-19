Imports DAL
Imports UserInfo

Imports MySql.Data.MySqlClient
Partial Class Denied
    Inherits System.Web.UI.Page
    Dim Correct As Boolean
    Dim CCon As New ClsCon
    Dim UserInfo As New UserInfo
    Dim accountname As String = String.Empty
    Dim accounttype As String = String.Empty
    Dim accountID As String = String.Empty
End Class
