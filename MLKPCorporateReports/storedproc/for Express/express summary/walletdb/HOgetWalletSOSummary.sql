DELIMITER $$

USE `kpmobile`$$

DROP PROCEDURE IF EXISTS `HOgetWalletSOSummary`$$

CREATE DEFINER=`root`@`%` PROCEDURE `HOgetWalletSOSummary`(IN accountCode VARCHAR(30),IN _datefrom VARCHAR(15),IN _dateto VARCHAR(15))
BEGIN
DECLARE _monthdate VARCHAR(4);
DECLARE _year VARCHAR(4);
DROP  TEMPORARY  TABLE IF EXISTS kpmobile.tmpwallettxn;
CREATE  TEMPORARY TABLE kpmobile.tmpwallettxn(walletno VARCHAR(100),username VARCHAR(100),custid VARCHAR(100),customername VARCHAR(100),
principal VARCHAR(100),charge VARCHAR(100),txncount VARCHAR(100),adjprincipal VARCHAR(100),adjcharge VARCHAR(100),adjtxncount VARCHAR(100));
WHILE DATE(_datefrom) <= DATE(_dateto) DO
SET _monthdate = DATE_FORMAT(_datefrom,'%m%d');
SET _year = DATE_FORMAT(_datefrom,'%Y');
	
SET @n_query= CONCAT('insert into kpmobile.tmpwallettxn(walletno,username,custid,customername ,principal ,charge ,txncount ,adjprincipal ,adjcharge ,adjtxncount )'
'select walletno,username,custid,customername ,sum(principal) as principal ,sum(charge) as charge ,sum(txncount) as txncount ,
sum(adjprincipal) as adjprincipal ,sum(adjcharge) as adjcharge ,sum(adjtxncount) as adjtxncount from 
(SELECT m.walletno,m.username,s.custid,if(CONCAT(m.firstname,'' '',m.middlename,'' '',m.lastname) is null,trim(s.sendername),CONCAT(m.lastname,'', '',m.firstname,'' '',m.middlename)) AS customername ,
SUM(principal) AS principal ,SUM(charge) AS charge ,
COUNT(kptnno) AS txncount, 0 as adjprincipal, 0 as adjcharge, 0 as adjtxncount
FROM `kpmobiletransactions`. sendout',_monthdate,' s   
inner JOIN `kpmobile`.`mobileaccounts` m ON m.username = s.operatorid
WHERE s.kptnno LIKE ''%mlw%'' and IF((SELECT kptn FROM `KPMobileExpress`.`MLExpressTransHistory` WHERE kptn=s.kptnno LIMIT 1) IS NOT NULL,0,1)  
and year(s.transdate)=',_year,' #and if(((charge<>0 and receivername=sendername) or receivername<>sendername),1,0) 
and if((receivername<>sendername and charge=(select charge from `kpforms`.`wallettowalletFixCharge` limit 1) ),1,0) 
and if( (SELECT 1 as isexist FROM `kpmobile`.mobileaccounts m1 where CONCAT(m1.lastname,'', '',m1.firstname,'' '',m1.middlename)=s.receivername LIMIT 1) is null,0,1 )
#and if( (SELECT 1 as isexist FROM `kpmobile`.mobileaccounts m2 
#where m2.username=(SELECT p.operatorid FROM `kptransactions`.payout p WHERE kptnno=s.kptnno limit 1)) is null,0,1)
group by m.custid,CONCAT(m.lastname,'', '',m.firstname,'' '',m.middlename)
union all 
SELECT m.walletno,m.username,s.custid,if(CONCAT(m.firstname,'' '',m.middlename,'' '',m.lastname) is null,trim(s.sendername),CONCAT(m.lastname,'', '',m.firstname,'' '',m.middlename)) AS customername ,
0 AS principal ,0 AS charge ,0 AS txncount, SUM(principal) as adjprincipal, SUM(charge) as adjcharge, COUNT(kptnno) as adjtxncount
FROM `kpmobiletransactions`. sendout',_monthdate,' s   
inner JOIN `kpmobile`.`mobileaccounts` m ON m.username = s.operatorid
WHERE s.kptnno LIKE ''%mlw%'' and IF((SELECT kptn FROM `KPMobileExpress`.`MLExpressTransHistory` WHERE kptn=s.kptnno LIMIT 1) IS NOT NULL,0,1)  
and year(s.transdate)=',_year,' and cancelreason  is not null and cancelreason <> '''' 
#and if(((charge<>0 and receivername=sendername) or receivername<>sendername),1,0) 
and if((receivername<>sendername and charge=(select charge from `kpforms`.`wallettowalletFixCharge` limit 1) ),1,0) 
and if( (SELECT 1 as isexist FROM `kpmobile`.mobileaccounts m1 where CONCAT(m1.lastname,'', '',m1.firstname,'' '',m1.middlename)=s.receivername LIMIT 1) is null,0,1 )
#and if( (SELECT 1 as isexist FROM `kpmobile`.mobileaccounts m2 
#where m2.username=(SELECT p.operatorid FROM `kptransactions`.payout p WHERE kptnno=s.kptnno limit 1)) is null,0,1)
group by m.custid,CONCAT(m.lastname,'', '',m.firstname,'' '',m.middlename)
)x where customername is not null group by custid,customername; 
;
');						
SET _datefrom = DATE_ADD(_datefrom, INTERVAL 1 DAY);                 
PREPARE StrSQL FROM @n_query;
EXECUTE StrSQL;
END WHILE;
SET @sql3=CONCAT('select walletno,username,custid,customername ,sum(principal) as principal ,sum(charge) as charge ,sum(txncount) as txncount ,
sum(adjprincipal) as adjprincipal ,sum(adjcharge) as adjcharge ,sum(adjtxncount) as adjtxncount 
from kpmobile.tmpwallettxn 
where customername is not null group by custid,customername; ');
PREPARE gtpo3 FROM @sql3;
EXECUTE gtpo3;
END$$

DELIMITER ;