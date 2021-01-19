<%@ Control Language="VB" AutoEventWireup="false" CodeFile="email.ascx.vb" Inherits="controls_email" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<div style="display: none">
    <asp:Button ID="Button1" runat="server" Text="Button" />
    <asp:ModalPopupExtender ID="ModalPopupExtender1" runat="server" TargetControlID="Button1"
        PopupControlID="Panel1" BackgroundCssClass="modalbackground">
    </asp:ModalPopupExtender>
</div>
<asp:Panel ID="Panel1" runat="server" Width="298px" Height="219px" BackColor="GhostWhite"
    BorderStyle="solid" BorderWidth="5px" BorderColor="ControlDarkDark" style="display:none;">
    <h3>
        <asp:Label ID="labelEmail" runat="server" Text="Please enter email Address"></asp:Label>
    </h3>
    <div style="margin-top: 20px; margin-left: 10px">
        <asp:TextBox ID="TxtEmailAddress" runat="server" Width="263px"></asp:TextBox>
        <br />
        <asp:Label ID="emaillbl" runat="server" Font-Names="Calibri" Font-Size="9pt" ForeColor="Red"
            Text="Note: Click Cancel if you dont want to email it"></asp:Label>
    </div>
    <div style="margin-top: 20px; margin-left: 100px;">
        <h3>
            <asp:Label ID="emaillbl0" runat="server" Font-Names="Calibri" Font-Size="9pt" ForeColor="Red"
                Text="Do you want to email it?"></asp:Label>
        </h3>
        <asp:Button ID="Button2" runat="server" Text="OK" />
        <asp:Button ID="Button3" runat="server" Text="Cancel" />
    </div>
</asp:Panel>
