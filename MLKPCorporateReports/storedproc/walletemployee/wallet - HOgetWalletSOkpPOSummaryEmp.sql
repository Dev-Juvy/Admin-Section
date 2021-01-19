DELIMITER $$

USE `kpmobile`$$

DROP PROCEDURE IF EXISTS `HOgetWalletSOkpPOSummaryEmp`$$

CREATE DEFINER=`root`@`%` PROCEDURE `HOgetWalletSOkpPOSummaryEmp`(IN db VARCHAR(100),IN _datefrom VARCHAR(15),IN _dateto VARCHAR(15),IN prefix VARCHAR(5))
BEGIN
DECLARE _monthdate VARCHAR(4);
DECLARE _year VARCHAR(4);
DROP  TEMPORARY  TABLE IF EXISTS tmpwallettxn;
CREATE  TEMPORARY TABLE kpmobile.tmpwallettxn(walletno VARCHAR(100),username VARCHAR(100),custid VARCHAR(100),customername VARCHAR(100),
principal VARCHAR(100),charge VARCHAR(100),txncount VARCHAR(100),adjprincipal VARCHAR(100),adjcharge VARCHAR(100),adjtxncount VARCHAR(100));
#WHILE DATE(_datefrom) <= DATE(_dateto) DO
SET _monthdate = DATE_FORMAT(_datefrom,'%m%d');
SET _year = DATE_FORMAT(_datefrom,'%Y');
SET @n_query= CONCAT(/*'INSERT INTO tmpwallettxn(walletno,username,custid,customername ,principal ,charge ,txncount ,adjprincipal ,adjcharge ,adjtxncount )'
*/'select walletno,username,custid,customername ,sum(principal) as principal ,sum(charge) as charge ,sum(txncount) as txncount ,
sum(adjprincipal) as adjprincipal ,sum(adjcharge) as adjcharge ,sum(adjtxncount) as adjtxncount from 
(SELECT walletno,username,custid,customername, sum(CONVERT(AES_DECRYPT(principal,''mlinc1234''), DECIMAL(11,2))) as principal,
SUM(IF(charge IS NULL,0,CONVERT(AES_DECRYPT(charge,''mlinc1234''), DECIMAL(11,2)))) as charge,count(kptnno) as txncount,0 as adjprincipal, 0 as adjcharge, 0 as adjtxncount
FROM 
(SELECT 
m.walletno,m.username as username, p.custid, 
if(CONCAT(m.firstname,'' '',m.middlename,'' '',m.lastname) is null,trim(p.sendername),CONCAT(m.lastname,'', '',m.firstname,'' '',m.middlename))   AS customername, 
principal,servicecharge as charge,kptnno,0 as adjprincipal, 0 as adjcharge, 0 as adjtxncount
FROM `kpmobiletransactions`.payout',_monthdate,' p
left join `kpmobile`.mobileaccounts m  ON CONCAT(m.lastname,'', '',m.firstname,'' '',m.middlename)=p.sendername
WHERE controlno  LIKE ''%mp%'' AND kptnno LIKE ''',prefix,'''  and (cancelledreason not in ('''',''Request for Change'',''Cancel Sendout'') or cancelledreason is null)
AND IF((SELECT username from `kpmobile`.mobileaccounts WHERE username=operatorid LIMIT 1) IS NOT NULL,0,1)
and receivername<>sendername
and controlno not like ''%op%'' AND YEAR(p.claimeddate)=',_year,' group by kptnno
)x group by  username,customername
union
SELECT 
m.walletno,m.username as username, p.custid,if(CONCAT(m.firstname,'' '',m.middlename,'' '',m.lastname) is null,trim(p.sendername),CONCAT(m.lastname,'', '',m.firstname,'' '',m.middlename))  AS customername, 
0 as principal,0 as charge,0 as txncount,sum(principal) as adjprincipal, SUM(IF(servicecharge IS NULL,0,servicecharge)) as adjcharge, count(kptnno) as adjtxncount
FROM `kpmobiletransactions`.payout',_monthdate,' p
inner join `kpmobile`.mobileaccounts m ON CONCAT(m.lastname,'', '',m.firstname,'' '',m.middlename)=p.sendername
WHERE controlno  LIKE ''%mp%'' AND kptnno LIKE ''',prefix,''' 
AND IF((SELECT username from `kpmobile`.mobileaccounts WHERE username=operatorid LIMIT 1) IS NOT NULL,0,1)
and receivername<>sendername
AND YEAR(p.claimeddate)=',_year,' and cancelledreason is not null and cancelledreason <> '''' and controlno not like ''%op%''
group by  m.username,CONCAT(m.lastname,'', '',m.firstname,'' '',m.middlename)
)x where custid is not null group by  custid
');						
#SET _datefrom = DATE_ADD(_datefrom, INTERVAL 1 DAY);                 
PREPARE StrSQL FROM @n_query;
EXECUTE StrSQL;
#END WHILE;
/*SET @sql3=CONCAT('select walletno,username,custid,customername ,sum(principal) as principal ,sum(if(charge is null,0,charge)) as charge ,sum(txncount) as txncount ,
sum(adjprincipal) as adjprincipal ,sum(adjcharge) as adjcharge ,sum(adjtxncount) as adjtxncount 
from tmpwallettxn where custid is not null group by custid;
');
PREPARE gtpo3 FROM @sql3;
EXECUTE gtpo3;*/
END$$

DELIMITER ;