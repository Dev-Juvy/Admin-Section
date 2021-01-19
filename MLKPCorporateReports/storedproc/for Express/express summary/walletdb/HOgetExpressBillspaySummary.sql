DELIMITER $$

USE `KPPartnersExpress`$$

DROP PROCEDURE IF EXISTS `HOgetExpressBillspaySummary`$$

CREATE DEFINER=`root`@`%` PROCEDURE `HOgetExpressBillspaySummary`(IN db VARCHAR(100),IN _datefrom VARCHAR(15),IN _dateto VARCHAR(15))
BEGIN
DECLARE _monthdate VARCHAR(4);
DECLARE _year VARCHAR(4);
DROP  TEMPORARY  TABLE IF EXISTS KPPartnersExpress.tmpwallettxn;
CREATE  TEMPORARY TABLE KPPartnersExpress.tmpwallettxn(walletno VARCHAR(100),username VARCHAR(100),custid VARCHAR(100),customername VARCHAR(100),
principal VARCHAR(100),charge VARCHAR(100),txncount VARCHAR(100),commission VARCHAR(100));
WHILE DATE(_datefrom) <= DATE(_dateto) DO
SET _monthdate = DATE_FORMAT(_datefrom,'%m%d');
SET _year = DATE_FORMAT(_datefrom,'%Y');
	
SET @n_query= CONCAT('insert into KPPartnersExpress.tmpwallettxn(walletno,username,custid,customername ,principal ,charge ,commission,txncount )'
'select walletno,username,custid,customername ,sum(principal) as principal ,sum(charge) as charge ,sum(commission) as commission,sum(txncount) as txncount from (
SELECT '''' AS custid, bp.walletno as walletno,bp.operator AS username,'''' AS customername,
COUNT(bp.kptn) AS txncount,SUM(bp.amount) AS principal,SUM(bp.customercharge) AS charge,sum(commission) as commission
FROM `KPPartnersExpress`.`billspayhistory` bp
Where date(sendoutdate) = ''',_datefrom,'''
GROUP BY bp.walletno )x  group by username; 
; ');						
SET _datefrom = DATE_ADD(_datefrom, INTERVAL 1 DAY);                 
PREPARE StrSQL FROM @n_query;
EXECUTE StrSQL;
END WHILE;
SET @sql3=CONCAT('select walletno,username,custid,customername ,sum(principal) as principal ,sum(charge) as charge,sum(commission) as commission ,sum(txncount) as txncount 
from KPPartnersExpress.tmpwallettxn 
 group by username; ');
PREPARE gtpo3 FROM @sql3;
EXECUTE gtpo3;
END$$

DELIMITER ;