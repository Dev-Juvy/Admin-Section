Imports Microsoft.VisualBasic

Public Class ClsReport
    'for postpage
    Public Uname As String = String.Empty
    Public Pword As String = String.Empty
    Public BUwallet As Integer = 0

    'report
    Public ID As Integer = -1
    Public ID2 As Integer = -1
    'billspayment 
    Public Control_No As String
    Public ControlNo As String
    Public DateTime As String
    Public Account_No As String
    Public Account_Name As String
    Public Amount_Paid As Decimal
    Public Charge As Decimal
    Public Cancellation_Charge As Decimal
    Public ML_Outlet As String
    Public MLZoneCode As String
    Public RemoteOperator As String
    Public RemoteOperatorId As String
    Public RemoteZodeCode As String
    Public Cancel_Reason As String
    Public partnername As String
    Public assbranch As String
    Public assoperator As String
    Public Assbranchname As String
    Public assFullName As String
    Public Operator_ID As String
    Public Payor As String
    Public Payor_Address As String
    Public Payor_ContactNo As String
    Public Address As String
    Public Contact_No As String
    Public Other_Details As String
    Public CancelledDate As String
    Public Currency As String
    Public SO_Date As String
    Public CancelCharge As String
    Public IRNO As String
    Public kptn As String
    Public oldkptn As String
    Public transdate As String
    Public Payment_To As String
    Public operatorname As String

    Public txtemail As String = String.Empty
    Public R_code As String
    Public A_Code As String
    Public Branch_Code As String
    Public Zone_Code As String

    ''Daily Sendout transaction

    'Public IDfromLogs As Integer
    'Public IDfromSendout As Integer
    'Public KPTNfromLogs As String
    'Public TransdatefromLogs As String
    'Public OLD_KPTN As String
    'Public Payor_Name As String
    'Public Cancellation_Charge As String
    'Public Payment_To As String
    'Public IR_NO As String
    'Public BranchCode As String
    'Public Payor_Address As String
    'Public Payor_ContactNo As String
    'Public Other_Charge As String
    'Public SO_Date As String
    ''----------------------------------
    'Public Branch_Name As String
    'Public Control_Series As String
    'Public ID As Integer = -1
    'Public Operator_Name As String
    'Public Sender_Name As String
    'Public Transaction_Date As String
    'Public Receiver_Name As String
    'Public KPTn As String
    'Public Receiver_Phone As String
    'Public CCREF_No As String
    'Public Amount As Decimal
    'Public Operator_ID As String
    'Public Charge As Decimal
    'Public Asst_Branch As String
    'Public Status As String
    'Public Reference_No As String
    'Public Currency As String
    'Public Forex As Decimal
    'Public Branch_Code As String
    'Public principalPHP As Decimal
    'Public principalUSD As Decimal
    'Public chargePHP As Decimal
    'Public chargeUSD As Decimal
    'Public PHPcount As String
    'Public USDcount As String
    'Public AdjprincipalPHP As Decimal
    'Public AdjprincipalUSD As Decimal
    'Public AdjchargePHP As Decimal
    'Public AdjchargeUSD As Decimal
    'Public AdjPHPcount As String
    'Public AdjUSDcount As String
    'Public CancelReason As String
    'Public OtherCharge As Decimal
    'Public OtherchargePHP As Decimal
    'Public OtherchargeUSD As Decimal
    'Public accountname As String
    'Public areaname As String
    'Public areacode As String
    'Public regionname As String
    'Public regioncode As String
    'Public R_code As String
    'Public A_Code As String

    ''Daily Payout
    'Public ClaimedDate As String
    'Public Timec As String
    'Public ZoneCode As String
    'Public txtemail As String = String.Empty

    ''Return to sender
    'Public CancelledDate As String
    'Public reason As String
    'Public Rbyoperator As String
    'Public RequestNo As String
    'Public DateRequest As String

    'Public pass As Boolean
    ''Daily User Variables
    'Public ID2 As Integer = -1


    ''BPR variables
    'Public DateTime As String
    'Public Control_No As String
    'Public Account_No As String
    'Public Account_Name As String
    'Public Amount_Paid As Decimal
    'Public Charge_ As Decimal
    'Public ML_Outlet As String
    'Public MLZoneCode As String
    'Public RemoteOperator As String
    'Public RemoteOperatorId As String
    'Public RemoteZodeCode As String
    'Public Cancel_Reason As String
    'Public ControlNo As String
    'Public partnername As String
    'Public assbranch As String
    'Public assoperator As String
    'Public Assbranchname As String
    'Public assFullName As String


    ''Public Operator_ID As String
    'Public Payor As String
    'Public Address As String
    'Public Contact_No As String
    'Public Other_Details As String

End Class
