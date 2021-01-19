<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Login.aspx.vb" Inherits="Login" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
    <head runat="server">
        <link href="../CSS/style.css" rel="stylesheet" type="text/css" />
        <title>Login Page</title>
    </head>
    <body>
        <form id="form1" runat="server">
            <div id="outerDiv">
                <div id="header"></div>
            </div>
            <div id="menuDiv">
                <div id="menuHolder"></div>
            </div>
            <div id="content2">
                <asp:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server"></asp:ToolkitScriptManager>
                <br /><br /><br />
                <div align="center">
                    <div align="center">
                        <table style="width: 50%;">
                            <tr>
                                <td style="text-align: right; font-family: Arial; font-size: 12px; font-color: #F8FBEF;">&nbsp;</td>
                                <td style="text-align: left" width="120px"><asp:UpdatePanel ID="UpdatePanel1" runat="server"></asp:UpdatePanel></td>
                            </tr>
                            <tr>
                                <td style="text-align: right; font-family: Arial; font-size: 12px;">&nbsp;</td>
                                <td style="text-align: left"><asp:UpdatePanel ID="UpdatePanel2" runat="server"></asp:UpdatePanel></td>
                            </tr>
                            <tr>
                                <td width="100px"> &nbsp;</td>
                                <td style="text-align: left"> &nbsp;</td>
                            </tr>
                        </table>
                    </div>
                    <div align="center">Access Denied</div>
                </div>
                <br /><br /><br /><br /><br /><br /><br /><br />
            </div>
            <div id="footerDiv">
                <div id="labelFooter">
                    <div id="leftLabelf">M.Lhuillier Philippines Inc.</div>
                    <div id="RightLabelf">All Rights Reserved.</div>
                </div>
            </div>
        </form>
    </body>
</html>
