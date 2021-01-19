DELIMITER $$

USE `kpOFWLogs`$$

DROP PROCEDURE IF EXISTS `HOgetExpressSOSummary`$$

CREATE DEFINER=`root`@`%` PROCEDURE `HOgetExpressSOSummary`(IN db VARCHAR(100),IN _datefrom VARCHAR(15),IN _dateto VARCHAR(15))
BEGIN
DECLARE _monthdate VARCHAR(4);
DECLARE _year VARCHAR(4);
DROP  TEMPORARY  TABLE IF EXISTS tmpwallettxn;
CREATE  TEMPORARY TABLE `kpOFWLogs`.tmpwallettxn(walletno VARCHAR(100),username VARCHAR(100),custid VARCHAR(100),customername VARCHAR(100),
principal VARCHAR(100),charge VARCHAR(100),txncount VARCHAR(100) ,commission VARCHAR(100));
WHILE DATE(_datefrom) <= DATE(_dateto) DO
SET _monthdate = DATE_FORMAT(_datefrom,'%m%d');
SET _year = DATE_FORMAT(_datefrom,'%Y');
SET @n_query= CONCAT('INSERT INTO tmpwallettxn(walletno,username,custid,customername ,principal ,charge ,txncount,commission )'
'select walletno,username,custid,customername ,sum(principal) as principal ,sum(charge) as charge ,sum(txncount) as txncount,sum(commission) as commission 
 from 
(SELECT 
IF(m.accountno IS NULL,m2.accountno,m.accountno) AS walletno,operatorid AS username, '''' AS custid, 
IF(m.fullname IS NULL,m2.fullname,m.fullname)   AS customername, 
SUM(principal) AS principal,SUM(chargeamount) AS charge,SUM(commission) AS commission,COUNT(kptn) AS txncount
FROM `kpOFWLogs`.`MLExpressSendouts` p
LEFT JOIN `kpOFW`.`OFWaccounts` m  ON m.username = p.operatorid
LEFT JOIN `kpOFW`.`SubOFWaccounts` m2  ON m2.username = p.operatorid
WHERE  date(transdate) = ''',_datefrom,'''
GROUP BY username)x group by username;
');						
SET _datefrom = DATE_ADD(_datefrom, INTERVAL 1 DAY);                 
PREPARE StrSQL FROM @n_query;
EXECUTE StrSQL;
END WHILE;
SET @sql3=CONCAT('select walletno,username,custid,customername ,sum(principal) as principal ,sum(if(charge is null,0,charge)) as charge ,sum(txncount) as txncount ,commission
from tmpwallettxn group by username;
');
PREPARE gtpo3 FROM @sql3;
EXECUTE gtpo3;
END$$

DELIMITER ;