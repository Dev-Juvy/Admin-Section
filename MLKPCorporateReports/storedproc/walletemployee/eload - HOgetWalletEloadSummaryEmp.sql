DELIMITER $$

USE `ELoadTransactions`$$

DROP PROCEDURE IF EXISTS `HOgetWalletEloadSummaryEmp`$$

CREATE DEFINER=`root`@`%` PROCEDURE `HOgetWalletEloadSummaryEmp`(IN accountCode VARCHAR(30),IN _datefrom VARCHAR(15),IN _dateto VARCHAR(15))
BEGIN
DECLARE _month VARCHAR(2);
DECLARE _day VARCHAR(2);
DECLARE _year VARCHAR(4);
DROP  TEMPORARY  TABLE IF EXISTS `ELoadTransactions`.tmpwallettxn;
CREATE  TEMPORARY TABLE `ELoadTransactions`.tmpwallettxn(walletno VARCHAR(100),username VARCHAR(100),custid VARCHAR(100),customername VARCHAR(100),
principal VARCHAR(100),charge VARCHAR(100),txncount VARCHAR(100));
WHILE DATE(_datefrom) <= DATE(_dateto) DO
SET _month = DATE_FORMAT(_datefrom,'%m');
SET _day = DATE_FORMAT(_datefrom,'%d');
SET _year = DATE_FORMAT(_datefrom,'%Y');
		
SET @n_query= CONCAT('insert into `ELoadTransactions`.tmpwallettxn(walletno,username,custid,customername ,principal ,charge ,txncount )'
'SELECT 
'''' as walletno,operator as username,'''' as custid,'''' as customername ,sum(amount) as principal ,
0 as charge ,count(transno) as txncount 
FROM `ELoadTransactions`.`TransLog',_month,'` s   
INNER JOIN `ELoadAdmin`.`NetworkMargin` nm ON nm.networkid = s.networkid  
WHERE YEAR(s.transdate)=',_year,' and day(s.transdate)=',_day,' and transno like ''%mwe%'' 
group by operator;
');													
SET _datefrom = DATE_ADD(_datefrom, INTERVAL 1 DAY);                
PREPARE StrSQL FROM @n_query;
EXECUTE StrSQL;
END WHILE;
SET @sql3=CONCAT('select walletno,username,custid,customername ,sum(principal) as principal ,sum(charge) as charge ,sum(txncount) as txncount
from ELoadTransactions.tmpwallettxn 
where customername is not null group by username,customername; ');
PREPARE gtpo3 FROM @sql3;
EXECUTE gtpo3;
END$$

DELIMITER ;