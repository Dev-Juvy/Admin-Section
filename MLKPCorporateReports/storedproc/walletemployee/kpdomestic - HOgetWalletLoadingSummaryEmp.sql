DELIMITER $$

USE `kpdomestic`$$

DROP PROCEDURE IF EXISTS `HOgetWalletLoadingSummaryEmp`$$

CREATE DEFINER=`root`@`%` PROCEDURE `HOgetWalletLoadingSummaryEmp`(IN db VARCHAR(100),IN _datefrom VARCHAR(15),IN _dateto VARCHAR(15),IN prefix VARCHAR(5))
BEGIN
DECLARE _monthdate VARCHAR(4);
DECLARE _year VARCHAR(4);
DROP  TEMPORARY  TABLE IF EXISTS tmploadingtxn;
CREATE  TEMPORARY  TABLE tmploadingtxn(walletno VARCHAR(100),username VARCHAR(100),custid VARCHAR(100),customername VARCHAR(100),principal VARCHAR(100),charge VARCHAR(100),txncount VARCHAR(100));
WHILE DATE(_datefrom) <= DATE(_dateto) DO
SET _monthdate = DATE_FORMAT(_datefrom,'%m%d');
SET _year = DATE_FORMAT(_datefrom,'%Y');
SET @n_query= CONCAT('INSERT INTO tmploadingtxn(walletno,username,custid,customername ,principal ,charge ,txncount )'
'SELECT 
'''' as walletno,'''' as username, custid, sendername as customername, sum(principal) as principal,
SUM(IF(servicecharge IS NULL,0,servicecharge)) as charge,count(kptnno) as txncount
FROM `kpdomestic`.payout',_monthdate,' p
WHERE kptnno LIKE ''',prefix,''' and controlno like ''%lp%'' and year(p.claimeddate)=',_year,' 
group by custid
');						
SET _datefrom = DATE_ADD(_datefrom, INTERVAL 1 DAY);                 
PREPARE StrSQL FROM @n_query;
EXECUTE StrSQL;
END WHILE;
SET @sql3=CONCAT('select walletno,username,custid,customername ,sum(principal) as principal ,sum(charge) as charge ,sum(txncount) as txncount 
from tmploadingtxn where custid is not null group by custid;
');
PREPARE gtpo3 FROM @sql3;
EXECUTE gtpo3;
END$$

DELIMITER ;