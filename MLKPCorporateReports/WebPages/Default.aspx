<%@ Page Language="VB" MasterPageFile="~/MasterPage/MasterPage.master" AutoEventWireup="false"
    CodeFile="Default.aspx.vb" Inherits="WebPages_Default" Title="Untitled Page" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="Server">
    <div style="height: 160px">
        <center>
            <h1>
                <asp:Label ID="lblError" runat="server" Text="Error Message" 
                    style="color: #000000; text-decoration: underline"></asp:Label>
            </h1>
        </center>
    </div>
</asp:Content>
