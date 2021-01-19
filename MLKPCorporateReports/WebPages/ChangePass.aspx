<%@ Page Language="VB" AutoEventWireup="false" CodeFile="ChangePass.aspx.vb" Inherits="WebPages_ChangePass" %>
<%@ Register assembly="AjaxControlToolkit" namespace="AjaxControlToolkit" tagprefix="asp" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
    <head id="Head1" runat="server">
        <link href="../CSS/style.css" rel="stylesheet" type="text/css" />
        <title>Change Password</title>
    </head>
    <body>
        <form id="form1" runat="server">   
            <div id="outerDiv"> <div id="header"></div>	 </div>
	        <div id="menuDiv"><div id="menuHolder"></div></div>
            <div id="content2">
                <asp:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server"> </asp:ToolkitScriptManager>
                <br /> <br />  <br />
                <div align="center">
                    <div align="center" >        
                        <table style="width:60%;">
                            <tr>
                                <td colspan="2" align="center" style="font-family: Arial; font-size: 12px; color:Red;">
                                    <asp:Label ID="Label1" runat="server" Text="Note for security reasons: After changing your password this page will redirect to Log-In page!"></asp:Label>                 
                                </td>
                            </tr>
                            <tr>
                                <td style="text-align: right; font-family: Arial; font-size: 12px; font-color:#F8FBEF;"><b>Username:</b></td>
                                <td style="text-align: left" width="120px">
                                    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                                        <ContentTemplate>
                                            <asp:TextBox ID="txtUserName" runat="server" style="font-family: Arial; font-size: 15px" CssClass="txtUppercase" MaxLength="15" AutoPostBack="True" Height="20px" Width="164px" Enabled="False"></asp:TextBox>
                                            <asp:FilteredTextBoxExtender ID="txtUserName_FilteredTextBoxExtender" runat="server" Enabled="True" FilterType="Numbers, UppercaseLetters, LowercaseLetters" TargetControlID="txtUserName"></asp:FilteredTextBoxExtender>
                                        </ContentTemplate> 
                                    </asp:UpdatePanel> 
                                </td>
                            </tr>
                            <tr>
                                <td style="text-align: right; font-family: Arial; font-size: 12px;"> <b>Current Password:</b></td>
                                <td style="text-align: left">
                                    <asp:UpdatePanel ID="UpdatePanel2" runat="server">
                                        <ContentTemplate>
                                            <asp:TextBox ID="txtPassword" TextMode ="Password"  runat="server"  style="font-family: Arial; font-size: 15px" TabIndex="1" MaxLength="20"  Height="20px" Width="163px"></asp:TextBox>
                                        </ContentTemplate> 
                                    </asp:UpdatePanel> 
                                </td>
                            </tr>
                            <tr>
                                <td style="text-align: right; font-family: Arial; font-size: 12px;"> <b>New Password:</b></td>
                                <td style="text-align: left">
                                    <asp:UpdatePanel ID="UpdatePanel3" runat="server">
                                        <ContentTemplate>
                                            <asp:TextBox ID="txtNewPassword" TextMode ="Password"  runat="server"  style="font-family: Arial; font-size: 15px" TabIndex="1" MaxLength="20"  Height="20px" Width="163px"></asp:TextBox>
                                        </ContentTemplate> 
                                    </asp:UpdatePanel> 
                                </td>
                            </tr>
                            <tr>
                                <td style="text-align: right; font-family: Arial; font-size: 12px;"> <b>Confirm New Password:</b></td>
                                <td style="text-align: left">
                                    <asp:UpdatePanel ID="UpdatePanel4" runat="server">
                                        <ContentTemplate>
                                            <asp:TextBox ID="txtConfirmPass" TextMode ="Password"  runat="server"  style="font-family: Arial; font-size: 15px" TabIndex="1" MaxLength="20"  Height="20px" Width="163px"></asp:TextBox>
                                        </ContentTemplate> 
                                    </asp:UpdatePanel> 
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2" align="center" style="font-family: Arial; font-size: 12px; color:Red;">
                                    <asp:Label ID="lblmessageChange" runat="server" Text="Label" Visible="false"></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td width="100px"> &nbsp;</td>
                                <td style="text-align: left">
                                    <asp:Button ID="BtnChange" runat="server" Text="Change"  style="font-family: Arial; font-size: 12px; height: 25px;" Height="36px"  Width="83px" />
                                    <asp:Button ID="BtnCancel" runat="server" Text="Cancel"  style="font-family: Arial; font-size: 12px; height: 25px;" Height="36px"   Width="83px" />
                                </td>
                            </tr>                                                
                        </table>
                    </div>
                    <div align="center">        
                        <asp:Label ID="lblErrorMsg" runat="server" Font-Italic="True"  Font-Names="Arial" Font-Size="12px" ForeColor="Red"></asp:Label>
                    </div>
                </div>
                <br /> <br /> <br /> <br /> <br /> <br /> <br />  <br />
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
