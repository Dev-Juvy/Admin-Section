DELIMITER $$

USE `kpmobile`$$

DROP PROCEDURE IF EXISTS `HOgetExpressDomestic`$$

CREATE DEFINER=`root`@`%` PROCEDURE `HOgetExpressDomestic`(IN walletno VARCHAR(50),IN _datefrom VARCHAR(15),IN _dateto VARCHAR(15) )
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


DROP  TEMPORARY  TABLE IF EXISTS tmpwallettxn;
CREATE  TEMPORARY TABLE tmpwallettxn(walletno VARCHAR(100),username VARCHAR(100),custid VARCHAR(100),customername VARCHAR(100),
principal VARCHAR(100),charge VARCHAR(100),txncount VARCHAR(100),commission VARCHAR(100));

WHILE DATE(_datefrom) <= DATE(_dateto) DO
SET _date = DATE_FORMAT(_datefrom,'%Y-%m-%d'); 
	
SET @n_query= CONCAT('insert into tmpwallettxn(walletno,username,custid,customername ,principal ,charge ,commission,txncount )'
'select walletno,username,custid,customername ,principal ,charge ,commission,txncount  from ( 
SELECT
kptn,custid,walletno,username,customername,
1 AS txncount, SUM(principal) AS principal,SUM(charge) AS  charge, SUM(commission) AS commission
FROM (
SELECT kptn,'''' as custid,walletno,'''' AS username, ''''  AS customername,
1 AS txncount,  if(transtype=2,principal,0) as principal,if(transtype=2,charge,0) as  charge, 0 as commission
 FROM `wallet',tmin,'_',tmax,'`.`walletno',_table,'` p  
WHERE   date(txndate) = ''',_date,''' and  transtype=2 
and (SUBSTRING(kptn,1,3) in (''MCD'',''MLR'') or SUBSTRING(kptn,1,3) REGEXP ''^[0-9]+$'')
union
 SELECT kptn, '''' as custid,walletno,'''' AS username, ''''  AS customername,
0 AS txncount, 0 as principal,0 as  charge, if(transtype=8,principal,0) as commission
 FROM `wallet',tmin,'_',tmax,'`.`walletno',_table,'` p  
WHERE   date(txndate) = ''',_date,''' and  transtype=8
and (SUBSTRING(kptn,1,3) in (''MCD'',''MLR'') or SUBSTRING(kptn,1,3) REGEXP ''^[0-9]+$'')
)x group by kptn)x
; ');						
SET _datefrom = DATE_ADD(_datefrom, INTERVAL 1 DAY);                 
PREPARE StrSQL FROM @n_query;
EXECUTE StrSQL;
END WHILE;

SET @sql3=CONCAT('select walletno,username,custid,customername ,sum(principal) as principal ,sum(charge) as charge,
sum(commission) as commission ,sum(txncount) as txncount 
from tmpwallettxn 
 group by walletno; ');
PREPARE gtpo3 FROM @sql3;
EXECUTE gtpo3;



END$$

DELIMITER ;