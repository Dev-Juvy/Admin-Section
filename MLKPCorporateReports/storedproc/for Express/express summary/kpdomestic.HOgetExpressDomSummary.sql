DELIMITER $$

USE `kpdomestic`$$

DROP PROCEDURE IF EXISTS `HOgetExpressDomSummary`$$

CREATE DEFINER=`root`@`%` PROCEDURE `HOgetExpressDomSummary`( IN _datefrom VARCHAR(15),IN _dateto VARCHAR(15))
BEGIN
DECLARE _monthdate VARCHAR(4);
DECLARE _year VARCHAR(4);
DROP  TEMPORARY  TABLE IF EXISTS tmpwallettxn;
CREATE  TEMPORARY TABLE tmpwallettxn(walletno VARCHAR(100),username VARCHAR(100),custid VARCHAR(100),customername VARCHAR(100),
principal VARCHAR(100),charge VARCHAR(100),txncount VARCHAR(100),commission VARCHAR(100));
WHILE DATE(_datefrom) <= DATE(_dateto) DO
SET _monthdate = DATE_FORMAT(_datefrom,'%m%d');
SET _year = DATE_FORMAT(_datefrom,'%Y');
	
SET @n_query= CONCAT('insert into tmpwallettxn(walletno,username,custid,customername ,principal ,charge ,commission,txncount )'
' SELECT custid,'''' AS walletno,p.operatorid AS username, ''''  AS customername,
1 AS txncount,  principal,0 AS charge,c.commission
FROM `kpdomestic`.payout',_monthdate,' p 
INNER JOIN `kpforms`.`PayoutCommission` c  ON c.kptn = p.kptnno and p.controlno like ''%op%''
WHERE   year(claimeddate) = ',_year,' 
#GROUP BY username
#)x  group by username; 
; ');						
SET _datefrom = DATE_ADD(_datefrom, INTERVAL 1 DAY);                 
PREPARE StrSQL FROM @n_query;
EXECUTE StrSQL;
END WHILE;
SET @sql3=CONCAT('select walletno,username,custid,customername ,sum(principal) as principal ,sum(charge) as charge,
sum(commission) as commission ,sum(txncount) as txncount 
from tmpwallettxn 
 group by username; ');
PREPARE gtpo3 FROM @sql3;
EXECUTE gtpo3;
END$$

DELIMITER ;