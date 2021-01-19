Imports Microsoft.VisualBasic
Imports iTextSharp.text.pdf
Imports System.IO


Public Class PDFMerge

    Public pdffile As New List(Of String)()

    Public Function MergePDF(ByVal newfile As String) As String
        Try
            Dim oPdfDoc As New iTextSharp.text.Document()
            Dim oPdfWriter As PdfWriter = PdfWriter.GetInstance(oPdfDoc, New FileStream(newfile, FileMode.Create))

            oPdfDoc.Open()

            For Each filename As String In pdffile
                AddPdf(filename, oPdfDoc, oPdfWriter)
            Next

            oPdfDoc.Close()
            oPdfWriter.Close()
        Catch ex As Exception
        End Try
        Return Nothing
    End Function
    Sub AddPdf(ByVal sInFilePath As String, ByRef oPdfDoc As iTextSharp.text.Document, ByRef oPdfWriter As PdfWriter)


        Dim oDirectContent As iTextSharp.text.pdf.PdfContentByte = oPdfWriter.DirectContent
        Dim oPdfReader As iTextSharp.text.pdf.PdfReader = New iTextSharp.text.pdf.PdfReader(sInFilePath)
        Dim iNumberOfPages As Integer = oPdfReader.NumberOfPages
        Dim iPage As Integer = 0

        Do While (iPage < iNumberOfPages)
            iPage += 1

            Dim iRotation As Integer = oPdfReader.GetPageRotation(iPage)
            Dim oPdfImportedPage As iTextSharp.text.pdf.PdfImportedPage = oPdfWriter.GetImportedPage(oPdfReader, iPage)

            oPdfDoc.SetPageSize(oPdfReader.GetPageSizeWithRotation(iPage))
            oPdfDoc.NewPage()

            If (iRotation = 90) Or (iRotation = 270) Then
                oDirectContent.AddTemplate(oPdfImportedPage, 0, -1.0F, 1.0F, 0, 0, oPdfReader.GetPageSizeWithRotation(iPage).Height)
            Else
                oDirectContent.AddTemplate(oPdfImportedPage, 1.0F, 0, 0, 1.0F, 0, 0)
            End If
            'End If
        Loop

    End Sub
End Class
