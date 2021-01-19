<%@ Control Language="VB" AutoEventWireup="false" CodeFile="Notice.ascx.vb" Inherits="controls_Notice" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<div style="display: none">
    <asp:Button ID="Button1" runat="server" Text="Button" />
    <asp:ModalPopupExtender ID="ModalPopupExtender1" runat="server" TargetControlID="Button1"
        PopupControlID="Panel1" BackgroundCssClass="modalbackground">
    </asp:ModalPopupExtender>
</div>
<asp:Panel ID="Panel1" runat="server" Width="298px" Height="219px" BackColor="GhostWhite"
    BorderStyle="solid" BorderWidth="5px" BorderColor="ControlDarkDark" style="display:none;">
    <div style="margin-top: 20px; margin-left: 10px; height: 104px;">
        <h3>
            Notice to report user:</h3>
        <h3>
            <asp:Label ID="emaillbl0" runat="server" Font-Names="Calibri" Font-Size="9pt" 
                ForeColor="Red" 
                Text="This reports are not final and is subject to further adjustment and Reconciliation "></asp:Label>
            &nbsp;</h3>
        <h3>
            <asp:Label ID="emaillbl1" runat="server" Font-Names="Calibri" Font-Size="9pt" 
                ForeColor="Red" 
                Text="For Your Proper Guidance "></asp:Label>
            &nbsp;</h3>
        <p>
            &nbsp;</p>
        <p align="center">
            <asp:Button ID="Button2" runat="server" Text="OK" />
        </p>
    </div>
</asp:Panel>

