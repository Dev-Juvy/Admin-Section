Imports Microsoft.VisualBasic
Imports System.Runtime.InteropServices

Public Class ini
    Public path As String

    <DllImport("kernel32", CallingConvention:=CallingConvention.StdCall)>
    Private Shared Function GetPrivateProfileString(ByVal IpApplicationName As String, ByVal IpKeyName As String, _
ByVal IpDefault As String, ByVal IPReturnedString As System.Text.StringBuilder, _
ByVal nsize As Integer, ByVal IpFileName As String) As Integer
    End Function


    Public Sub Inifile(ByVal INIPath As String)
        path = INIPath
    End Sub



    Public Function iniDataRead(ByVal sectionReadString As String, ByVal keyReadString As String) As String
        'Read data from an ini file
        Dim temp As StringBuilder = New StringBuilder(255)
        Dim resultLength As Long
        resultLength = GetPrivateProfileString(sectionReadString, keyReadString, "", temp, 255, path)
        Return temp.ToString()
    End Function
End Class
