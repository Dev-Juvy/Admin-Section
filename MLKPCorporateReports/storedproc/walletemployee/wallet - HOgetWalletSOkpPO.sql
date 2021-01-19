DELIMITER $$

USE `kpmobile`$$

DROP PROCEDURE IF EXISTS `HOgetWalletSOkpPO`$$

CREATE DEFINER=`root`@`%` PROCEDURE `HOgetWalletSOkpPO`(IN accountCode VARCHAR(30),IN _datefrom VARCHAR(15),IN _dateto VARCHAR(15),IN prefix VARCHAR(5))
BEGIN
DECLARE _monthdate VARCHAR(4);
DECLARE _year VARCHAR(4);
DROP  TEMPORARY  TABLE IF EXISTS `kpmobiletransactions`.tmpwallettxn;
CREATE  TEMPORARY TABLE IF NOT EXISTS `kpmobiletransactions`.tmpwallettxn(flag VARCHAR(100),claimeddate VARCHAR(100),transdate VARCHAR(100),kptn VARCHAR(100),receivername VARCHAR(100),sendername VARCHAR(100),sobranch VARCHAR(100),
pobranch VARCHAR(100),partnername VARCHAR(100),principal VARCHAR(100),charge VARCHAR(100),commission VARCHAR(100),accountid VARCHAR(100),username VARCHAR(100),
fullname VARCHAR(100),operator VARCHAR(100),cancelreason VARCHAR(100),cancelleddate VARCHAR(100),oldkptn VARCHAR(100),cancelledbyoperator VARCHAR(100),
custid VARCHAR(100),controlno VARCHAR(100),branchcode VARCHAR(100),zonecode VARCHAR(100),senderwalletno VARCHAR(100),receiverwalletno VARCHAR(100));
#WHILE DATE(_datefrom) <= DATE(_dateto) DO
SET _monthdate = DATE_FORMAT(_datefrom,'%m%d');
SET _year = DATE_FORMAT(_datefrom,'%Y');
	
SET @n_query= CONCAT(/*'insert into `kpmobiletransactions`.tmpwallettxn(flag ,claimeddate,transdate ,kptn ,receivername ,sendername ,sobranch ,
pobranch ,partnername ,principal ,charge ,commission ,accountid ,username ,
fullname ,operator ,cancelreason ,cancelleddate ,oldkptn ,cancelledbyoperator ,
custid ,controlno ,branchcode ,zonecode, senderwalletno,receiverwalletno)'*/
'select flag ,if(claimeddate is null,''0000-00-00 00:00:00'',claimeddate) as claimeddate ,if(transdate is null,''0000-00-00 00:00:00'',transdate) as transdate ,kptn ,receivername ,sendername ,sobranch ,
pobranch ,partnername ,principal ,if(charge is null,0,charge) as charge ,commission ,accountid ,username ,
fullname ,operator ,cancelreason ,if(cancelleddate is null,''0000-00-00 00:00:00'',cancelleddate) as cancelleddate ,oldkptn ,cancelledbyoperator ,
custid ,controlno ,branchcode ,zonecode, senderwalletno,receiverwalletno from (SELECT 
IF(p.cancelleddate IS NOT NULL and p.cancelleddate<>''0000-00-00 00:00:00'' and p.cancelleddate<>'''' and p.cancelledreason=''Wrong Payout'' ,''**'',
if(p.cancelledreason in (''RETURN TO SENDER''),''*'','''')) AS flag, claimeddate, sodate AS transdate ,
if(cancelledreason=''Wrong Payout'',oldkptnno,kptnno) AS kptn ,receivername ,sendername ,sobranch ,
'''' AS  pobranch ,'''' AS partnername ,
CONVERT(AES_DECRYPT(principal,''mlinc1234''), DECIMAL(11,2)) as principal ,
CONVERT(AES_DECRYPT(servicecharge,''mlinc1234''), DECIMAL(11,2)) AS charge ,
0 AS commission ,senderid AS accountid ,'''' AS username ,
'''' AS fullname ,operatorid AS operator ,cancelledreason AS cancelreason ,cancelleddate ,oldkptnno as oldkptn ,cancelledbyoperatorid AS cancelledbyoperator ,
p.custid AS custid ,controlno ,p.branchcode ,p.zonecode,k.walletno AS senderwalletno ,'''' as receiverwalletno
FROM `kpmobiletransactions`.payout',_monthdate,' p
inner JOIN `kpmobile`.`mobileaccounts` k ON k.custid = p.custid
WHERE controlno  LIKE ''%mp%'' AND kptnno LIKE ''',prefix,'''  and (cancelledreason not in ('''',''Request for Change'',''Cancel Sendout'') or cancelledreason is null)
AND IF((SELECT username from `kpmobile`.mobileaccounts WHERE username=operatorid LIMIT 1) IS NOT NULL,0,1)
and receivername<>sendername
and controlno not like ''%op%'' AND YEAR(p.claimeddate)=',_year,' ORDER BY transdate ASC)x group by kptn;
');						
#SET _datefrom = DATE_ADD(_datefrom, INTERVAL 1 DAY);                 
PREPARE StrSQL FROM @n_query;
EXECUTE StrSQL;
#END WHILE;
/*
SET @sql3=CONCAT('select flag ,if(claimeddate is null,''0000-00-00 00:00:00'',claimeddate) as claimeddate ,if(transdate is null,''0000-00-00 00:00:00'',transdate) as transdate ,kptn ,receivername ,sendername ,sobranch ,
pobranch ,partnername ,principal ,if(charge is null,0,charge) as charge ,commission ,accountid ,username ,
fullname ,operator ,cancelreason ,if(cancelleddate is null,''0000-00-00 00:00:00'',cancelleddate) as cancelleddate ,oldkptn ,cancelledbyoperator ,
custid ,controlno ,branchcode ,zonecode, senderwalletno,receiverwalletno from `kpmobiletransactions`.tmpwallettxn; ');
PREPARE gtpo3 FROM @sql3;
EXECUTE gtpo3;*/
END$$

DELIMITER ;