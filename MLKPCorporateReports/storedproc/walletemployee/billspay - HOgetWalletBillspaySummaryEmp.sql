DELIMITER $$

USE `kpbillspayment`$$

DROP PROCEDURE IF EXISTS `HOgetWalletBillspaySummaryEmp`$$

CREATE DEFINER=`root`@`%` PROCEDURE `HOgetWalletBillspaySummaryEmp`(IN db VARCHAR(100),IN _datefrom VARCHAR(15),IN _dateto VARCHAR(15))
BEGIN
DECLARE _monthdate VARCHAR(4);
DECLARE _year VARCHAR(4);
DROP  TEMPORARY  TABLE IF EXISTS kpbillspayment.tmpwallettxn;
CREATE  TEMPORARY TABLE kpbillspayment.tmpwallettxn(walletno VARCHAR(100),username VARCHAR(100),custid VARCHAR(100),customername VARCHAR(100),
principal VARCHAR(100),charge VARCHAR(100),txncount VARCHAR(100),adjprincipal VARCHAR(100),adjcharge VARCHAR(100),adjtxncount VARCHAR(100));
WHILE DATE(_datefrom) <= DATE(_dateto) DO
SET _monthdate = DATE_FORMAT(_datefrom,'%m%d');
SET _year = DATE_FORMAT(_datefrom,'%Y');
	
SET @n_query= CONCAT('insert into kpbillspayment.tmpwallettxn(walletno,username,custid,customername ,principal ,charge ,txncount ,adjprincipal ,adjcharge ,adjtxncount )'
'select walletno,username,custid,customername ,sum(principal) as principal ,sum(charge) as charge ,sum(txncount) as txncount ,
sum(adjprincipal) as adjprincipal ,sum(adjcharge) as adjcharge ,sum(adjtxncount) as adjtxncount from (
SELECT '''' as walletno,operatorid as username,'''' as custid,CONCAT(accountlname,'', '',accountfname,'' '',accountmname) AS customername ,
SUM(amountpaid) AS principal ,SUM(customercharge + partnercharge) AS charge ,
COUNT(kptnno) AS txncount, 0 as adjprincipal, 0 as adjcharge, 0 as adjtxncount
FROM `kpbillspayment`. sendout',_monthdate,'  
WHERE kptnno LIKE ''%bpm%''  and year(transdate)=',_year,' 
group by operatorid,CONCAT(accountlname,'', '',accountfname,'' '',accountmname)
union all
SELECT '''' as walletno,operatorid as username,'''' as custid,CONCAT(accountlname,'', '',accountfname,'' '',accountmname) AS customername ,
0 AS principal ,0 AS charge ,0 AS txncount, 
SUM(amountpaid) as adjprincipal, SUM(customercharge + partnercharge) as adjcharge, COUNT(kptnno) as adjtxncount
FROM `kpbillspayment`. sendout',_monthdate,'  
WHERE kptnno LIKE ''%bpm%''  and year(transdate)=',_year,' and cancelreason is not null and cancelreason <> ''''
group by operatorid,CONCAT(accountlname,'', '',accountfname,'' '',accountmname)
)x where customername is not null group by username,customername; 
');						
SET _datefrom = DATE_ADD(_datefrom, INTERVAL 1 DAY);                 
PREPARE StrSQL FROM @n_query;
EXECUTE StrSQL;
END WHILE;
SET @sql3=CONCAT('select walletno,username,custid,customername ,sum(principal) as principal ,sum(charge) as charge ,sum(txncount) as txncount ,
sum(adjprincipal) as adjprincipal ,sum(adjcharge) as adjcharge ,sum(adjtxncount) as adjtxncount 
from kpbillspayment.tmpwallettxn 
where customername is not null group by username,customername; ');
PREPARE gtpo3 FROM @sql3;
EXECUTE gtpo3;
END$$

DELIMITER ;