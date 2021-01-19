DELIMITER $$

USE `kpmobile`$$

DROP PROCEDURE IF EXISTS `HOgetwalletTransHis`$$

CREATE DEFINER=`root`@`%` PROCEDURE `HOgetwalletTransHis`(IN walletid VARCHAR(30),IN _datefrom VARCHAR(15),IN _dateto VARCHAR(15))
BEGIN
DECLARE _monthdate VARCHAR(4);
DECLARE _year VARCHAR(4);
DECLARE _table VARCHAR(10);
DECLARE _date VARCHAR(20);
DECLARE tmin VARCHAR(20);
DECLARE tmax VARCHAR(20);
DECLARE _min VARCHAR(20);
DROP  TEMPORARY  TABLE IF EXISTS `kpmobile`.tmpwallettxn;
CREATE  TEMPORARY TABLE `kpmobile`.tmpwallettxn(walletno VARCHAR(100),transdate VARCHAR(100),transtype VARCHAR(100),transnum VARCHAR(5),kptn VARCHAR(100),
principal VARCHAR(100),charge VARCHAR(100),receivername VARCHAR(100),branchname VARCHAR(100),balance VARCHAR(100));
SET _table = CAST(SUBSTRING(walletid,5,10) AS SIGNED );
SET _min = CAST((_table / 100) AS SIGNED ) * 100;
SET tmin = _min + 1;
SET tmax = _min + 100;
WHILE DATE(_datefrom) <= DATE(_dateto) DO
SET _monthdate = DATE_FORMAT(_datefrom,'%m%d');
SET _year = DATE_FORMAT(_datefrom,'%Y');
SET _date = DATE(_datefrom);
		
SET @n_query= CONCAT('insert into `kpmobile`.tmpwallettxn(walletno,transdate,transtype,transnum,kptn,principal,charge,balance)'
'SELECT walletno, txndate AS transdate,
IF(kptn LIKE ''%bpw%'',''BillspaySendout'',
   IF(kptn LIKE ''%mwe%'',''E-load'',
      IF(transtype = ''1'',''Sendout'',
         IF(transtype = ''2'',''Payout'',
            IF(transtype = ''4'',''Load'',kptn))))) AS transtype,
            transtype AS transnum,
 kptn, principal, charge, runningbalance AS balance
 FROM `wallet',tmin,'_',tmax,'`.`walletno',_table,'` WHERE DATE(txndate) = ''',_date,'''
');													
SET _datefrom = DATE_ADD(_datefrom, INTERVAL 1 DAY);                
PREPARE StrSQL FROM @n_query;
EXECUTE StrSQL;
END WHILE;
SET @sql3=CONCAT('select  walletno,transdate,transtype,transnum,kptn,principal,charge,balance
from `kpmobile`.tmpwallettxn; ');
PREPARE gtpo3 FROM @sql3;
EXECUTE gtpo3;
END$$

DELIMITER ;