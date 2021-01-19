DELIMITER $$

USE `kpmobile`$$

DROP PROCEDURE IF EXISTS `HOgetExpressLoading`$$

CREATE DEFINER=`root`@`%` PROCEDURE `HOgetExpressLoading`(IN walletno VARCHAR(50),IN _datefrom VARCHAR(15),IN _dateto VARCHAR(15) )
BEGIN	
DECLARE tmin VARCHAR(20);
DECLARE tmax VARCHAR(20);
DECLARE _min VARCHAR(20);
DECLARE _table VARCHAR(10);
DECLARE _date VARCHAR(15);

SET _table = CAST(SUBSTRING(walletno,5,10) AS SIGNED );
SET _min = CAST((_table / 100) AS SIGNED ) * 100;
SET tmin = _min + 1;
SET tmax = _min + 100;


DROP  TEMPORARY  TABLE IF EXISTS kpmobile.tmpwalletload;
CREATE  TEMPORARY  TABLE kpmobile.tmpwalletload(walletno VARCHAR(100),username VARCHAR(100),custid VARCHAR(100),customername VARCHAR(100),principal VARCHAR(100),charge VARCHAR(100),txncount VARCHAR(100));

WHILE DATE(_datefrom) <= DATE(_dateto) DO
SET _date = DATE_FORMAT(_datefrom,'%Y-%m-%d'); 
	
SET @n_query= CONCAT('INSERT INTO kpmobile.tmpwalletload(walletno,username,custid,customername ,principal ,charge ,txncount  )'
'select walletno,username,custid,customername ,principal ,charge ,txncount  from ( 
SELECT
custid,walletno,username,customername, count(kptn) AS txncount, SUM(principal) AS principal,SUM(charge) AS  charge
FROM (
SELECT kptn,'''' as custid,walletno,'''' AS username, ''''  AS customername,   principal, charge 
 FROM `wallet',tmin,'_',tmax,'`.`walletno',_table,'` p  
WHERE   date(txndate) = ''',_date,''' and  transtype=4  and kptn like ''%mlw%'' )x)x
; ');						
SET _datefrom = DATE_ADD(_datefrom, INTERVAL 1 DAY);                 
PREPARE StrSQL FROM @n_query;
EXECUTE StrSQL;
END WHILE;

SET @sql3=CONCAT('select walletno,username,custid,customername ,sum(principal) as principal ,sum(charge) as charge, sum(txncount) as txncount 
from kpmobile.tmpwalletload  group by walletno; ');
PREPARE gtpo3 FROM @sql3;
EXECUTE gtpo3;



END$$

DELIMITER ;