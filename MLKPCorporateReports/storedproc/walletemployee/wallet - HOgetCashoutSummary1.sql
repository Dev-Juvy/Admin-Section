DELIMITER $$

USE `kpmobile`$$

DROP PROCEDURE IF EXISTS `HOgetCashoutSummary1`$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `HOgetCashoutSummary1`(IN db VARCHAR(100),IN _datefrom VARCHAR(15),IN _dateto VARCHAR(15),IN prefix VARCHAR(5))
BEGIN
DECLARE _monthdate VARCHAR(4);
DECLARE _year VARCHAR(4);
DROP  TEMPORARY  TABLE IF EXISTS `kpmobile`.tmpwallettxn;
CREATE  TEMPORARY TABLE `kpmobile`.tmpwallettxn(walletno VARCHAR(100),username VARCHAR(100),custid VARCHAR(100),customername VARCHAR(100),principal VARCHAR(100),charge VARCHAR(100),txncount VARCHAR(100));
#WHILE DATE(_datefrom) <= DATE(_dateto) DO
SET _monthdate = DATE_FORMAT(_datefrom,'%m%d');
SET _year = DATE_FORMAT(_datefrom,'%Y');
	
SET @n_query= CONCAT(/*'insert into `kpmobile`.tmpwallettxn(walletno,username,custid,customername ,principal ,charge ,txncount )'*/
'SELECT m.walletno,m.username,m.custid,CONCAT(m.lastname,'', '',m.firstname,'' '',m.middlename) AS customername ,
SUM(CONVERT(AES_DECRYPT(s.principal,''mlinc1234''), DECIMAL(11,2))) AS principal 
,SUM(CONVERT(AES_DECRYPT(s.charge,''mlinc1234''), DECIMAL(11,2))) AS charge ,
COUNT(s.kptnno) AS txncount
FROM `kpmobiletransactions`. sendout',_monthdate,' s   
inner JOIN `kpmobile`.`mobileaccounts` m ON m.username = s.operatorid
WHERE s.kptnno LIKE ''',prefix,''' and IF((SELECT kptn FROM `KPMobileExpress`.`MLExpressTransHistory` WHERE kptn=s.kptnno LIMIT 1) IS NOT NULL,0,1)  
and year(s.transdate)=',_year,'   #and if((receivername=sendername and AES_DECRYPT(charge,''mlinc1234'')=0),1,0) 
 and if((receivername=sendername),1,0) 
and if( (SELECT 1 as isexist FROM `kpmobile`.mobileaccounts m1 where CONCAT(m1.lastname,'', '',m1.firstname,'' '',m1.middlename)=s.receivername LIMIT 1) is null,0,1 )
group by m.username,CONCAT(m.firstname,'' '',m.middlename,'' '',m.lastname)
order by transdate asc;');						
#SET _datefrom = DATE_ADD(_datefrom, INTERVAL 1 DAY);                 
PREPARE StrSQL FROM @n_query;
EXECUTE StrSQL;
#END WHILE;
/*SET @sql3=CONCAT('select walletno,username,custid,customername ,sum(principal) as principal ,sum(charge) as charge ,sum(txncount) as txncount from `kpmobile`.tmpwallettxn 
where customername is not null group by username,customername; ');
PREPARE gtpo3 FROM @sql3;
EXECUTE gtpo3;*/
END$$

DELIMITER ;