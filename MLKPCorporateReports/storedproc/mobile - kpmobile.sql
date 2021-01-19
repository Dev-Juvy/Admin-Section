

USE `kpmobile`;

/* Function  structure for function  `express_receiver` */

DROP FUNCTION IF EXISTS `express_receiver` ;
DELIMITER $$

CREATE  FUNCTION `express_receiver`( sender_custid VARCHAR(60),sender_walletno VARCHAR(60)) RETURNS VARCHAR(60) CHARSET latin1
    DETERMINISTIC
RETURN(SELECT CONCAT(firstname, ' ', middlename, ' ', lastname) FROM `kpmobile`.`mobileaccounts` WHERE custid=sender_custid AND walletno=sender_walletno) $$
DELIMITER ;

/* Procedure structure for procedure `getExpressWalletLoading` */

DROP PROCEDURE IF EXISTS  `getExpressWalletLoading` ;

DELIMITER $$

CREATE  PROCEDURE `getExpressWalletLoading`(IN agentname VARCHAR(100), IN walletdb VARCHAR(50),IN _datefrom VARCHAR(25),IN _dateto VARCHAR(25),IN _flag VARCHAR(3))
BEGIN
SET @sql=CONCAT('SELECT 
''',agentname,''' AS AgentName,
walletno AS AccountNo,txndate AS Transdate,KPTN,principal AS LoadAmount,
IF((SELECT `kpmobile`.express_receiver(sendereceiverno,walletno)) IS NULL, '''',(SELECT express_receiver(sendereceiverno,walletno)) ) AS Operator, 
IF((SELECT `kpmobile`.express_receiver(sendereceiverno,walletno)) IS NULL, '''',
(SELECT bcodetopup FROM `kpmobile`.`mobileaccounts` WHERE custid=sendereceiverno LIMIT 1 )) AS Branch, sendereceiverno AS operatorid,
IF((SELECT `kpmobile`.express_receiver(sendereceiverno,walletno)) IS NULL, '''',
(SELECT zcodeTopUp FROM `kpmobile`.`mobileaccounts` WHERE custid=sendereceiverno LIMIT 1 )) AS zcode
FROM ',walletdb,' WHERE transtype IN (''2'',''4'') and kptn like ''%mlw%''
and  if(''',_flag,'''=''1'',date(txndate)=''',_datefrom,''',if(''',_flag,'''=''2'',DATE_FORMAT(txndate,''%m%Y'')=''',_datefrom,''',DATE(txndate) BETWEEN ''',_datefrom,''' AND ''',_dateto,'''))  
ORDER BY transdate ASC
;');
PREPARE gtpo FROM @sql;
EXECUTE gtpo;
END $$
DELIMITER ;