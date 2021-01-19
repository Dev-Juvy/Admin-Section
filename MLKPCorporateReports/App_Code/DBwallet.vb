Imports System
Imports System.Collections.Generic
Imports System.Linq
Imports System.Web
Imports MySql.Data.MySqlClient
Imports log4net

Public Class DBwallet
    Private connection As MySqlConnection
    Private pool As Boolean = False
    Private path As String
    Private Shared ReadOnly kplog As ILog = LogManager.GetLogger(GetType(DBwallet))

    Public Sub New(ByVal Serv As String, ByVal DB As String, ByVal UID As String, ByVal Password As String, ByVal pooling As String, ByVal maxcon As Int32, ByVal mincon As Int32, ByVal tout As Int32)
        Initialize(Serv, DB, UID, Password, pooling, maxcon, mincon, tout)
    End Sub

    Sub New()
        ' TODO: Complete member initialization 
    End Sub

    Private Sub Initialize(ByVal Serv As String, ByVal DB As String, ByVal UID As String, ByVal Password As String, ByVal pooling As String, ByVal maxcon As Int32, ByVal mincon As Int32, ByVal tout As Int32)
        Try

            If pooling.Equals("1") Then
                pool = True
            End If

            Dim myconstring As String = "server = " & Serv & "; database = " & DB & "; uid = " & UID & ";password= " & Password & "; pooling=" & pool & ";min pool size=" & mincon & ";max pool size=" & maxcon & "; Connection Lifetime=0 ;Command Timeout=28800; connection timeout=" & tout & ";Allow Zero Datetime=true"
            connection = New MySqlConnection(myconstring)
        Catch ex As Exception
            kplog.Fatal("Unable to connect", ex)
            Throw New Exception(ex.Message)
        End Try
    End Sub

    'Public Sub Path() As String

    '    Return Path

    'End Sub

    Public Function OpenConnection() As Boolean
        Try
            connection.Open()
            Return True
        Catch __unusedMySqlException1__ As MySqlException
            Return False
        End Try
        Return False
    End Function

    Public Function CloseConnection() As Boolean
        Try
            connection.Close()
            Return True
        Catch __unusedMySqlException1__ As MySqlException
            Return False
        End Try
    End Function

    Public Sub Insert()
    End Sub

    Public Sub Update()
    End Sub

    Public Sub sDelete()
    End Sub

    Public Function getConnection() As MySqlConnection
        Return connection
    End Function

    Public Sub dispose()
        connection.Dispose()
    End Sub

    Public Sub Backup()
    End Sub

    Public Sub Restore()
    End Sub
End Class
