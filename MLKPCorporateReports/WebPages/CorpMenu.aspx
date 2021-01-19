<%@ Page Language="VB" Async ="true"  MasterPageFile="~/MasterPage/MasterPage.master" AutoEventWireup="false"
    CodeFile="CorpMenu.aspx.vb" Inherits="WebPages_CorpMenu" Title="Main Menu Page" %>

<%@ Import Namespace="System.Windows.Forms" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<%@ Register TagPrefix="UserControl" TagName="email" Src="~/controls/email.ascx" %>
<%@ Register TagPrefix="UserControl" TagName="NoToPu" Src="~/controls/Notice.ascx" %>
<%@ Register Assembly="CrystalDecisions.Web, Version=10.5.3700.0, Culture=neutral, PublicKeyToken=692fbea5521e1304"
    Namespace="CrystalDecisions.Web" TagPrefix="CR" %>
<%--naka tago na diri sa maincontent--%>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="Server">
    <div style="height: 200px">
        <table style="border-style: solid; border-color: Black; border-width: 1px;">
            <tr>
                <td colspan="2" style="height: 25px">
                    <asp:Label ID="lblreportname" runat="server" Text="Report Name" Visible="true"></asp:Label>
                </td>
            </tr>
            <tr>
                <td colspan="2" style="height: 20px">
                </td>
            </tr>
            <tr>
                <td colspan="2" style="height: 32px">
                    <asp:Label ID="Label10" runat="server" Text=" Specify from the provided parameter(s) below to narrow down your search."
                        Font-Names="Calibri" Font-Size="9pt"></asp:Label>
                </td>
            </tr>
            <tr>
                <td style="width: 255px; height: 30px;">
                    <asp:Label ID="lblFormat" runat="server" Style="font-family: 'Segoe UI'; font-size: 10pt" visible="true"
                        Text="File Format"></asp:Label>
                </td>
                <td style="width: 422px; height: 30px;">
                    <asp:RadioButtonList ID="rb" runat="server" RepeatDirection="Horizontal" Font-Size="Small" Visible="true">
                        <asp:ListItem Value="excelF">Excel File</asp:ListItem>
                        <asp:ListItem Value="PDFF">PDF File</asp:ListItem>
                    </asp:RadioButtonList>
                    <UserControl:email ID="emailaddress" runat="server" />
                     <UserControl:NoToPu ID="notice_public" runat="server" />
                </td>
            </tr>

            <tr>
                <td style="width: 200px">
                    <asp:Label ID="Label11" runat="server" Text="Wallet Number :" Font-Names="Segoe UI"  
                        Font-Size="10pt"  AutoPostBack="True"   ></asp:Label>
                </td>
                <td style="width: 422px">
                    <asp:UpdatePanel ID="UpdatePanel27" runat="server">
                        <ContentTemplate>
                            <asp:TextBox ID="SrchBox" runat="server" MaxLength="14" Width="166px" placeholder="-Input Here-"></asp:TextBox>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </td>
            </tr>

            <tr>
                <td style="width: 255px">
                    <asp:Label ID="Label1" runat="server" Text="Partner Account :" Font-Names="Segoe UI"
                        Font-Size="10pt"></asp:Label>
                </td>
                <td style="width: 422px">
                    <asp:UpdatePanel ID="UpdatePanel4" runat="server">
                        <ContentTemplate>
                            <asp:DropDownList ID="drpPartnerAccountlist" runat="server" AutoPostBack="True" 
                                Width="389px" Font-Names="Segoe UI" Font-Size="10pt" Height="22px" 
                                Visible="true" Enabled="true">
                                <asp:ListItem Value="0">-Select-</asp:ListItem>
                            </asp:DropDownList>
                            <asp:DropDownList ID="drppartnerid" runat="server" AutoPostBack="True" 
                                Enabled="False" Height="16px" Style="margin-left: 0px" Visible="False" 
                                Width="28px">
                            </asp:DropDownList>
                            <asp:DropDownList ID="drpaccountno" runat="server" AutoPostBack="True" 
                                Enabled="False" Height="16px" Style="margin-left: 0px" Visible="False" 
                                Width="28px">
                            </asp:DropDownList>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </td>
            </tr>
            <tr>
                <td style="width: 255px">
                    <asp:UpdatePanel ID="UpdatePanel26" runat="server">
                        <ContentTemplate>
                            <asp:Label ID="lblspecify" runat="server" Font-Names="Segoe UI" 
                                Font-Size="10pt" Text="Specify Account :" Visible="False"></asp:Label>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </td>
                <td style="width: 422px">
                    <asp:UpdatePanel ID="UpdatePanel11" runat="server">
                        <ContentTemplate>
                            <asp:DropDownList ID="drpglobe" runat="server" AutoPostBack="True" 
                                Width="334px" Height="22px" Font-Names="Segoe UI" Font-Size="10pt"
                                visible="false" Enabled="false">
                            </asp:DropDownList>
                            <asp:DropDownList ID="drpsubpartnerid" runat="server" AutoPostBack="True" 
                                Enabled="false" Height="16px" Style="margin-left: 0px" Visible="false" 
                                Width="64px">
                            </asp:DropDownList>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </td>
            </tr>        
           <tr>
                <td style="width: 255px">
                    <asp:UpdatePanel ID="UpdatePanel12" runat="server">
                        <ContentTemplate>
                            <asp:Label ID="lbldepartment" runat="server" Font-Names="Segoe UI" 
                                Font-Size="10pt" Text="Select Department :" Visible="False"></asp:Label>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </td>
                <td style="width: 422px">
                    <asp:UpdatePanel ID="UpdatePanel13" runat="server">
                        <ContentTemplate>
                            <asp:DropDownList ID="drpdepartment" runat="server" AutoPostBack="True" 
                                Width="334px" Height="22px" Font-Names="Segoe UI" Font-Size="10pt"
                                visible="false" Enabled="false">
                            </asp:DropDownList>
                            <asp:DropDownList ID="drpdepartmentid" runat="server" AutoPostBack="True" 
                                Enabled="false" Height="16px" Style="margin-left: 0px" Visible="false" 
                                Width="32px">
                            </asp:DropDownList>
                            <asp:DropDownList ID="drpdepartmenttin" runat="server" AutoPostBack="True" 
                                Enabled="false" Height="16px" Style="margin-left: 0px" Visible="false" 
                                Width="32px">
                            </asp:DropDownList>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </td>
            </tr>
            <tr>
                <td style="width: 255px">
                    <asp:UpdatePanel ID="UpdatePanel14" runat="server">
                        <ContentTemplate>
                            <asp:Label ID="lblterminal" runat="server" Font-Names="Segoe UI" 
                                Font-Size="10pt" Text="Select Terminal :" Visible="False"></asp:Label>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </td>
                <td style="width: 422px">
                    <asp:UpdatePanel ID="UpdatePanel15" runat="server">
                        <ContentTemplate>
                            <asp:DropDownList ID="drpterminal" runat="server" AutoPostBack="True" 
                                Width="334px" Height="22px" Font-Names="Segoe UI" Font-Size="10pt"
                                visible="false" Enabled="false">
                            </asp:DropDownList>
                            <asp:DropDownList ID="drpterminalid" runat="server" AutoPostBack="True" 
                                Enabled="false" Height="16px" Style="margin-left: 0px" Visible="false" 
                                Width="32px">
                            </asp:DropDownList>
                            <asp:DropDownList ID="drpterminaltin" runat="server" AutoPostBack="True" 
                                Enabled="false" Height="16px" Style="margin-left: 0px" Visible="false" 
                                Width="32px">
                            </asp:DropDownList>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </td>
            </tr>
            <tr>
                <td style="width: 255px">
                    <asp:Label ID="lblregion" runat="server" Text="Region :" Font-Names="Segoe UI" Font-Size="10pt" Visible="false"></asp:Label>
                </td>
                <td style="width: 422px">
                   
                     <asp:UpdatePanel ID="UpdatePanel23" runat="server">
                         <ContentTemplate>
                             <asp:DropDownList ID="drpRegion" runat="server" AutoPostBack="true" 
                                 Enabled="false" Visible="false" Height="22px"  Font-Names="Segoe UI" Font-Size="10pt"
                                 onselectedindexchanged="drpregion_SelectedIndexChanged" 
                                 Style="margin-left: 0px" Width="334px">
                                 <asp:ListItem>-Select-</asp:ListItem>
                             </asp:DropDownList>
                             <asp:DropDownList ID="drpRegionCode" runat="server" AutoPostBack="True" 
                                 Enabled="False" Height="16px" Style="margin-left: 0px" Visible="False" 
                                 Width="64px">
                             </asp:DropDownList>
                         </ContentTemplate>
                     </asp:UpdatePanel>
                                     
                </td>
            </tr>
            <tr>
                <td style="width: 255px">
                   
                    <asp:Label ID="lblarea" runat="server" Text="Area :" Font-Names="Segoe UI" Font-Size="10pt" Visible="false"></asp:Label>
                </td>
                <td style="width: 422px">
                    <asp:UpdatePanel ID="UpdatePanel24" runat="server">
                        <ContentTemplate>
                            <asp:DropDownList ID="drpArea" runat="server" AutoPostBack="True" 
                            onselectedindexchanged="drpArea_SelectedIndexChanged" Font-Names="Segoe UI" Font-Size="10pt"
                                Enabled="False" Visible="false" Style="margin-bottom: 2px; margin-left: 0px;" Width="334px" Height="22px">
                                <asp:ListItem>-Select-</asp:ListItem>
                            </asp:DropDownList>
                            <asp:DropDownList ID="drpAreaCode" runat="server" AutoPostBack="True" 
                                Enabled="False" Height="16px" Style="margin-left: 0px" Visible="False" 
                                Width="66px">
                            </asp:DropDownList>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </td>
            </tr>
            <tr>
                <td style="width: 255px">
                    <asp:Label ID="lblbranch" runat="server" visible="false" Text="Branch :" Font-Names="Segoe UI" Font-Size="10pt"></asp:Label>
                </td>
                <td style="width: 422px">
                    <asp:UpdatePanel ID="UpdatePanel25" runat="server">
                        <ContentTemplate>
                            <asp:DropDownList ID="drpBranchName" runat="server" Visible="false"  
    AutoPostBack="True" Enabled="False" Font-Names="Segoe UI" Font-Size="10pt"
                        Style="margin-left: 0px" Width="334px" Height="22px">
                                <asp:ListItem>-Select-</asp:ListItem>
                            </asp:DropDownList>
                            <asp:DropDownList ID="drpBranchCode" runat="server" AutoPostBack="True" 
                                Enabled="False" Height="16px" Style="margin-left: 0px" Visible="False" 
                                Width="66px">
                            </asp:DropDownList>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </td>
            </tr>
   <%--<asp:ListItem Enabled="False" Value="75">Western union Refund Report</asp:ListItem>--%>
            <tr>
                <td style="width: 255px">
                    <asp:UpdatePanel runat="server">
                        <ContentTemplate>

                            <asp:Label ID="lblbiller" runat="server" Font-Names="Segoe UI" Font-Size="10pt" Text="Sub Biller :" Visible="False"></asp:Label>

                        </ContentTemplate>
                    </asp:UpdatePanel>
                </td>
                <td>
                    <asp:UpdatePanel ID="billerPanel" runat="server">
                        <ContentTemplate>

                            <asp:DropDownList ID="drpbiller" runat="server" AutoPostBack="True" Height="22px" Width="334px" Enabled="False" Font-Names="Segoe UI" Font-Size="10pt" Visible="False">
                                <asp:ListItem>-Select-</asp:ListItem>
                            </asp:DropDownList>
                            <asp:DropDownList ID="drpbiller2" runat="server" Height="16px" Width="66px" AutoPostBack="True" Visible="False">
                                <asp:ListItem></asp:ListItem>
                            </asp:DropDownList>
                        </ContentTemplate>
                    </asp:UpdatePanel>

                </td>
            </tr>
            <tr>
                <td style="width: 255px">
                    <asp:Label ID="Label2" runat="server" Text="Transaction Type :" Font-Names="Segoe UI"
                        Font-Size="10pt"></asp:Label>
                    <asp:Label ID="Label5" runat="server" Text="*" Font-Bold="True" Font-Names="Segoe UI"
                        Font-Size="10pt" ForeColor="Red"></asp:Label>
                </td>
                <td style="width: 422px">
                    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                        <ContentTemplate>
                            <asp:DropDownList ID="drpTransactionTypelist" onchange="ttypechange(this)" runat="server" AutoPostBack="True" Visible="true" Enabled="true"
                                Width="334px" Style="height: 22px" Font-Names="Segoe UI" Font-Size="10pt">
                                <asp:ListItem Value="0" >-Select-</asp:ListItem>
                                <asp:ListItem Value="1" Enabled="false">Sendout</asp:ListItem>
                                <asp:ListItem Value="2" Enabled="false">Claimed</asp:ListItem>
                                <asp:ListItem Value="3" Enabled="false">Unclaimed</asp:ListItem>
                                <asp:ListItem Value="4" Enabled="false">Return to Sender</asp:ListItem>
                                <asp:ListItem Value="5" Enabled="false">Cancel Sendout</asp:ListItem>
                                <asp:ListItem Value="6" Enabled="false">Amendments</asp:ListItem>
                                <asp:ListItem Value="7" Enabled="false">Payout Summary</asp:ListItem>
                                <asp:ListItem Value="8" Enabled="false">Cancelled Payout</asp:ListItem>
                                 <asp:ListItem Value="9" Enabled="false">Change Details</asp:ListItem>
                                <asp:ListItem Enabled="False" Value="10">ML Express Payout</asp:ListItem>
                                <asp:ListItem Enabled="False" Value="11">ML Wallet Loading Express</asp:ListItem>
                                <asp:ListItem Enabled="False" Value="12">Transaction History</asp:ListItem>
                                <asp:ListItem Enabled="False" Value="13">Profit Share - Receive Payout (Branch to SM)</asp:ListItem>
                                <asp:ListItem Enabled="False" Value="14">Profit Share - Send Payout (SM to Branch)</asp:ListItem>
                                <asp:ListItem Enabled="False" Value="15">Profit Share - Send Payout (SM to SM)</asp:ListItem>
                                <asp:ListItem Enabled="False" Value="16">Sales Journal Report</asp:ListItem>
                                <asp:ListItem Enabled="False" Value="17">Terminal Transaction Summary Report</asp:ListItem>
                                <asp:ListItem Enabled="False" Value="18">Terminal Reading Report</asp:ListItem>
                                <asp:ListItem Enabled="False" Value="19">Daily Service Fee Report</asp:ListItem>
                                <asp:ListItem Enabled="False" Value="20">SM Detailed Transaction Report (Send)</asp:ListItem>
                                <asp:ListItem Enabled="False" Value="21">SM-ML Detailed Transaction Report (Receive)</asp:ListItem>
                                <asp:ListItem Enabled="False" Value="22">SM Summary Transaction Report (Send)</asp:ListItem>
                                <asp:ListItem Enabled="False" Value="23">SM-ML Summary Transaction Report (Receive)</asp:ListItem>
                                <asp:ListItem Enabled="False" Value="24">SM Profit Share (Send)</asp:ListItem>
                                <asp:ListItem Enabled="False" Value="25">SM Profit Share (Receive)</asp:ListItem>
                                <asp:ListItem Enabled="False" Value="26">MLKP from SM Branches (Send)</asp:ListItem>
                                <asp:ListItem Enabled="False" Value="27">MLKP Payout at SM Branches</asp:ListItem>
                                <asp:ListItem Enabled="False" Value="28">POS Monthly Report</asp:ListItem>
                            	<asp:ListItem Enabled="False" Value="29">ML Express Post Audit</asp:ListItem>
                            	<asp:ListItem Enabled="False" Value="30">SM Summary Report</asp:ListItem>
                            	<asp:ListItem Enabled="False" Value="31">Electronic journal</asp:ListItem>
                            	<asp:ListItem Enabled="False" Value="32">X-Reading Report</asp:ListItem>
                            	<asp:ListItem Enabled="False" Value="33">OR Register Report</asp:ListItem>
                            	<asp:ListItem Enabled="False" Value="34">Transaction Logs</asp:ListItem>
                            	<asp:ListItem Enabled="False" Value="35">ML Wallet Loading Report</asp:ListItem>
                            	<asp:ListItem Enabled="False" Value="36">ML Wallet Sendout to KP Payout</asp:ListItem>
                            	<asp:ListItem Enabled="False" Value="37">ML Wallet Send Cashout Report</asp:ListItem>
                            	<asp:ListItem Enabled="False" Value="38">ML Wallet To Billspayment Transaction Report</asp:ListItem>
                            	<asp:ListItem Enabled="False" Value="39">ML Wallet Customer Balanced Report</asp:ListItem>
                            	<asp:ListItem Enabled="False" Value="40">Sales Report Per Merchant</asp:ListItem>
                            	<asp:ListItem Enabled="False" Value="41">ML Wallet Eload Report</asp:ListItem>
                            	<asp:ListItem Enabled="False" Value="42">ML Wallet KP Sendout</asp:ListItem>
                            	<asp:ListItem Enabled="False" Value="43">ML Wallet Transaction Report</asp:ListItem>
                                <asp:ListItem Enabled="False" Value="44">ML Wallet Customer List Report</asp:ListItem>
                                <asp:ListItem Enabled="False" Value="45">ML Wallet Claimed Cashout Report</asp:ListItem>
                                <asp:ListItem Enabled="False" Value="46">ML Wallet Payment - Sendout Summary</asp:ListItem>
                                <asp:ListItem Enabled="False" Value="47">ML Wallet Payment - Payout Summary</asp:ListItem>
                                <asp:ListItem Enabled="False" Value="48">ML Wallet Express Payment - Sendout </asp:ListItem>
                                <asp:ListItem Enabled="False" Value="49">ML Wallet Express Payment - Payout </asp:ListItem>
                            	<asp:ListItem Enabled="False" Value="50">Z-Reading Report</asp:ListItem>
                            	<asp:ListItem Enabled="False" Value="51">AR Register Report</asp:ListItem>
							    <asp:ListItem Enabled="False" Value="52">ML Wallet Payment - Sendout</asp:ListItem>
                                <asp:ListItem Enabled="False" Value="53">ML Wallet Payment - Payout</asp:ListItem>
                                <asp:ListItem Enabled="False" Value="54">AR Cancelled Register Report</asp:ListItem>
                                <asp:ListItem Enabled="False" Value="55">Wallet Transaction History</asp:ListItem>
                                <asp:ListItem Enabled="False" Value="56">ML Shop Transaction Report</asp:ListItem>
                                <asp:ListItem Enabled="False" Value="57">Sendout Billspayment Reports</asp:ListItem>
                                <asp:ListItem Enabled="False" Value="58">ML Express Summary Reports</asp:ListItem>
                                <asp:ListItem Enabled="False" Value="59">ML Express E-Load Reports</asp:ListItem>
                                <asp:ListItem Enabled="False" Value="60">ML Wallet Corporate Payout</asp:ListItem>
                                <asp:ListItem Enabled="False" Value="61">ML Express Wallet Payout</asp:ListItem>
                                <asp:ListItem Enabled="False" Value="62">ML Wallet Registration Report</asp:ListItem>
                                <asp:ListItem Enabled="False" Value="63">ML Wallet Account Status Report</asp:ListItem>
                                <asp:ListItem Enabled="False" Value="64">ML Wallet Transfer from Bank Transaction Report</asp:ListItem>
                                <asp:ListItem Enabled="False" Value="65">BatchUpload Transaction Report</asp:ListItem>
                                <asp:ListItem Enabled="False" Value="66">walwal</asp:ListItem>
                                <asp:ListItem Enabled="False" Value="67">ML Domestic Sendout to Wallet Payout</asp:ListItem>
                                <asp:ListItem Enabled="False" Value="68">ML Wallet Return to Sender</asp:ListItem>
                                <asp:ListItem Enabled="False" Value="69">ML GLobal Sendout to Wallet Payout</asp:ListItem>
                                <asp:ListItem Enabled="False" Value="70">Daily Settlement Report per Bank</asp:ListItem>
                                <asp:ListItem Enabled="False" Value="71">Weekly Statement of Account</asp:ListItem>
                                <asp:ListItem Enabled="False" Value="72">Monthly Statement of Account</asp:ListItem>
                                <asp:ListItem Enabled="False" Value="73">Weekly Summary Report</asp:ListItem>
                                <asp:ListItem Enabled="False" Value="74">Monthly Summary Report</asp:ListItem>
                                <asp:ListItem Enabled="False" Value="75">Refund Report</asp:ListItem>
                                <asp:ListItem Enabled="False" Value="76">ML Express Cancelled Billspayment Report</asp:ListItem>
                                <asp:ListItem Enabled="False" Value="77">ML Wallet Cancelled Billspayment Report</asp:ListItem>
                                <asp:ListItem Enabled="False" Value="78">ML Wallet Users Transaction Summary Report</asp:ListItem>
                                <asp:ListItem Enabled="False" Value="79">ML Wallet Users Ending Balance Summary Report</asp:ListItem>
                                <asp:ListItem Enabled="False" Value="80">ML Wallet BatchUpload</asp:ListItem>
                                <asp:ListItem Enabled="False" Value="81">Transaction Report</asp:ListItem>
                                <asp:ListItem Enabled="False" Value="82">Abstract of collection report</asp:ListItem>
                                <asp:ListItem Enabled="False" Value="83">Payment Report</asp:ListItem>
                                <asp:ListItem Enabled="False" Value="84">ML Wallet Loading Adjustment Report</asp:ListItem>
                                <asp:ListItem Enabled="False" Value="85">All Partners Volume of Transaction</asp:ListItem>
                                <asp:ListItem Enabled="False" Value="86">ML Wallet: My Extra Credit ka Promo (Smart & TNT)</asp:ListItem>
                                <asp:ListItem Enabled="False" Value="87">ML Wallet Billspayment Force Committed Txn(Manual)</asp:ListItem>
                                <asp:ListItem Enabled="False" Value="88">ML Wallet Billspayment Force Committed Txn(Auto)</asp:ListItem>
                            </asp:DropDownList>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </td>
            </tr>
      <tr>
   
      <td style="height: 27px; width: 255px;">
                 
                <asp:UpdatePanel ID="UpdatePanel29" runat="server">
                    <ContentTemplate>
                        <asp:Label ID="lblpo" runat="server" Text="PO Number :" Visible="False"  Font-Names="Segoe UI" Font-Size="10pt"></asp:Label>
                    </ContentTemplate>
                </asp:UpdatePanel>
                 
                </td>
             <td style="width: 422px; height: 27px;">
                   
                 <asp:UpdatePanel ID="UpdatePanel28" runat="server">
                     <ContentTemplate>
                         <asp:TextBox ID="TextBox1" runat="server" Visible="False" Width="331px" 
                             style="margin-left: 0px"></asp:TextBox>
                     </ContentTemplate>
                 </asp:UpdatePanel>
                   
                </td>
              
      </tr>

            <tr>
                <td style="height: 27px; width: 255px;">
                    <asp:Label ID="lblperiod" runat="server" Text="Period :" Font-Names="Segoe UI" Font-Size="10pt" Visible="true"></asp:Label>
                    <asp:Label ID="lblperiodreq" runat="server" Text="*" Font-Bold="True" Font-Names="Segoe UI" Visible="true"
                        Font-Size="10pt" ForeColor="Red"></asp:Label>
                </td>
                <td style="width: 422px; height: 27px;">
                    <asp:UpdatePanel ID="UpdatePanel2" runat="server">
                        <ContentTemplate>
                            <asp:DropDownList ID="drpPeriod" runat="server" AutoPostBack="True" Width="123px" Visible="true" Enabled="true"
                                Style="height: 22px" Height="33px" Font-Names="Segoe UI" Font-Size="10pt" >
                                <asp:ListItem Value="0" >-Select-</asp:ListItem>
                                <asp:ListItem Value="1" >Daily</asp:ListItem>
                                <asp:ListItem Value="2" >Monthly</asp:ListItem>
                                <asp:ListItem Value="3" >Date Range</asp:ListItem>
                            </asp:DropDownList>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </td>
            </tr>
            

            <tr>
                <td style="height: 27px; width: 255px;">
                    <asp:UpdatePanel ID="UpdatePanel22" runat="server">
                        <ContentTemplate>
                            <asp:Label ID="lbldate" runat="server" Text="Date:" Font-Size="10pt" Visible="false" ></asp:Label>
                            <asp:Label ID="lbldatereq" runat="server" ForeColor="Red" Text="*" Visible="false"></asp:Label>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </td>
                <td style="height: 27px; width: 422px">
                    <asp:UpdatePanel ID="UpdatePanel3" runat="server">
                        <ContentTemplate>
                            <asp:DropDownList ID="drpMonth" runat="server" AutoPostBack="True" Width="120px" Visible="false" Enabled="true"
                                Style="height: 22px" Font-Names="Segoe UI" Font-Size="10pt">
                                <asp:ListItem Value="0">-Select Month-</asp:ListItem>
                                <asp:ListItem Value="1">JANUARY</asp:ListItem>
                                <asp:ListItem Value="2">FEBRUARY</asp:ListItem>
                                <asp:ListItem Value="3">MARCH</asp:ListItem>
                                <asp:ListItem Value="4">APRIL</asp:ListItem>
                                <asp:ListItem Value="5">MAY</asp:ListItem>
                                <asp:ListItem Value="6">JUNE</asp:ListItem>
                                <asp:ListItem Value="7">JULY</asp:ListItem>
                                <asp:ListItem Value="8">AUGUST</asp:ListItem>
                                <asp:ListItem Value="9">SEPTEMBER</asp:ListItem>
                                <asp:ListItem Value="10">OCTOBER</asp:ListItem>
                                <asp:ListItem Value="11">NOVEMBER</asp:ListItem>
                                <asp:ListItem Value="12">DECEMBER</asp:ListItem>
                            </asp:DropDownList>
                            <asp:DropDownList ID="drpYear" runat="server"  Visible="false" Enabled="true"
                                Width="120px" Height="22px" Font-Names="Segoe UI" Font-Size="10pt">
                                <asp:ListItem>-Select Year-</asp:ListItem>
                                <asp:ListItem>2013</asp:ListItem>
                                <asp:ListItem>2014</asp:ListItem>
                                <asp:ListItem>2015</asp:ListItem>
                                <asp:ListItem>2016</asp:ListItem>
                                <asp:ListItem>2017</asp:ListItem>
                                <asp:ListItem>2018</asp:ListItem>
                                <asp:ListItem>2019</asp:ListItem>
                                <asp:ListItem>2020</asp:ListItem>
                                <asp:ListItem>2021</asp:ListItem>
                                <asp:ListItem>2022</asp:ListItem>
                                <asp:ListItem>2023</asp:ListItem>
                                <asp:ListItem>2024</asp:ListItem>
                                <asp:ListItem>2025</asp:ListItem>
                                <asp:ListItem>2026</asp:ListItem>
                            </asp:DropDownList>
                            <asp:TextBox ID="txtDate" runat="server" Width="120px" onchange="txtdatechange(this)" AutoPostBack="True" Font-Names="Segoe UI" Font-Size="10pt" Visible="false" Enabled="false" ></asp:TextBox>
                            <asp:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtDate"
                                PopupPosition="BottomRight" Format="yyyy-MM-dd">
                            </asp:CalendarExtender>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </td>
            </tr>
            <tr>
                <td style="height: 27px; width: 255px;">
                    <asp:UpdatePanel ID="UpdatePanel8" runat="server">
                        <ContentTemplate>
                            <asp:Label ID="lbldateFrom" runat="server" Text="Date From:" Font-Size="10pt" Visible="false"></asp:Label>
                            <asp:Label ID="lbldatefromreq" runat="server" ForeColor="Red" Text="*" Visible="false"></asp:Label>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </td>
                <td style="height: 27px; width: 422px">
                    <asp:UpdatePanel ID="UpdatePanel9" runat="server">
                        <ContentTemplate>
                            <asp:TextBox ID="txtdateFrom" runat="server" Width="120px" Font-Names="Segoe UI" Visible="false" Enabled="true"
                                Font-Size="10pt"></asp:TextBox>
                            <asp:CalendarExtender ID="txtdateFrom_CalendarExtender" runat="server" Enabled="True"
                                TargetControlID="txtdateFrom" Format="yyyy-MM-dd">
                            </asp:CalendarExtender>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </td>
            </tr>
            <tr>
                <td style="height: 27px; width: 255px;">
                    <asp:UpdatePanel ID="UpdatePanel7" runat="server">
                        <ContentTemplate>
                            <asp:Label ID="lbldateto" runat="server" Text="Date To:" Font-Size="10pt" Visible="false"></asp:Label>
                            <asp:Label ID="lbldatetoreq" runat="server" ForeColor="Red" Text="*" Visible="false"></asp:Label>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </td>
                <td style="height: 27px; width: 422px">
                    <asp:UpdatePanel ID="UpdatePanel10" runat="server">
                        <ContentTemplate>
                            <asp:TextBox ID="txtdateTo" runat="server" Width="120px" Font-Names="Segoe UI" Font-Size="10pt" Visible="false" Enabled="true"></asp:TextBox>
                            <asp:CalendarExtender ID="txtdateTo_CalendarExtender" runat="server" Enabled="True"
                                TargetControlID="txtdateTo" Format="yyyy-MM-dd">
                            </asp:CalendarExtender>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </td>
            </tr>
            <tr align="center">
                <td colspan="2" style="height: 50px">
                    <asp:UpdatePanel ID="UpdatePanel6" runat="server">
                    </asp:UpdatePanel>
                    <asp:ModalPopupExtender ID="UpdatePanel6_ModalPopupExtender" runat="server" DynamicServicePath=""
                        Enabled="True" TargetControlID="UpdatePanel6" PopupControlID="pnlPopupContainer"
                        Y="55" CancelControlID="btnOkay" BehaviorID="UpdatePanel6_ModalPopupExtender"
                        BackgroundCssClass="ModalStyle">
                    </asp:ModalPopupExtender>
                    <asp:Button  ID="btngenerate"  runat="server" Text="Generate" Font-Bold="True" Font-Names="Segoe UI" Font-Size="10pt" Width="124px" height="25px"/>
                </td>
            </tr>
            <tr>
                <td colspan="2">
                    <div>
                        <asp:UpdatePanel ID="UpdatePanel5" runat="server">
                            <ContentTemplate>
                                <asp:Label ID="lable8" runat="server" Text="message" ForeColor="Red" Font-Size="12px"
                                    Visible="false"></asp:Label>
                            </ContentTemplate>
                        </asp:UpdatePanel>
                    </div>
                </td>
            </tr>
        </table>
    </div>
    <asp:HiddenField runat="server" ID="hfModalVisible" />
    <asp:Panel runat="server" ID="pnlPopupContainer" CssClass="drag" Style="display: none;">
        <div class="gridContainer">
            <div class="closeContainer">
                <div class="closeButton">
                    <asp:Button ID="btnOkay" runat="server" Text="OK" CssClass="buttons" />
                </div>
            </div>
            <asp:UpdatePanel ID="UpdatePanel20" runat="server" UpdateMode="Conditional">
                <ContentTemplate>
                    <h3>
                        MLKP : Message</h3>
                    <asp:Panel ID="Panel1" runat="server" DefaultButton="btnOkay">
                        <p align="center">
                            <asp:Label ID="lblMessage" runat="server" Text="lblMessage" Font-Italic="False" Style="text-align: left;
                                font-family: Arial" ForeColor="Red"></asp:Label>
                                <br />
                                <asp:Label ID="Label9" runat="server" Font-Italic="False" Style="text-align: left;
                                font-family: Arial" ForeColor="Red"></asp:Label>
                                <br /> <br /> <br />

                                 <asp:Label ID="Label8" runat="server" Font-Italic="False" Style="text-align: left;
                                font-family: Arial" ForeColor="Red"></asp:Label>
                        </p>
                    </asp:Panel>
                </ContentTemplate>
            </asp:UpdatePanel>
        </div>
    </asp:Panel>
    <div>
    <input id="inpHide" type="hidden" runat="server" />
    </div>       
</asp:Content>
