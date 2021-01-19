Imports System.Collections.Generic
Imports System.Linq
Imports System.Web
Imports System.Data

''' <summary>
''' Summary description for Global
''' </summary>
Public NotInheritable Class [Class1]
    Private Sub New()
    End Sub


    Shared Emailornot As Boolean = False
   
#Region "Email Address"
    Public Shared Property Emailor() As String
        Get
            Return Emailornot
        End Get
        Set(ByVal value As String)
            Emailornot = value
        End Set
    End Property
#End Region

End Class
