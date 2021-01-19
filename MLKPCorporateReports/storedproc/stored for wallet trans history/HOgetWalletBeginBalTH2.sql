DELIMITER $$

USE `kpmobile`$$

DROP PROCEDURE IF EXISTS `HOgetWalletBeginBalTH2`$$

CREATE DEFINER=`root`@`%` PROCEDURE `HOgetWalletBeginBalTH2`(IN walletno VARCHAR(50),IN _datefrom VARCHAR(15))
BEGIN	

DECLARE tmin VARCHAR(20);
DECLARE tmax VARCHAR(20);
DECLARE _min VARCHAR(20);
DECLARE _table VARCHAR(10);
SET _table = CAST(SUBSTRING(walletno,5,10) AS SIGNED );
SET _min = CAST((_table / 100) AS SIGNED ) * 100;
SET tmin = _min + 1;
SET tmax = _min + 100;
#SET _datefrom = DATE_SUB(_datefrom, INTERVAL 1 DAY);  

SET @n_query= CONCAT('SELECT walletno, txndate AS transdate,
 runningbalance AS beginningbalance
 FROM `wallet',tmin,'_',tmax,'`.`walletno',_table,'` WHERE DATE(txndate) < ''',_datefrom,'''
 ORDER BY transdate DESC LIMIT 1 ;
');	 
PREPARE StrSQL FROM @n_query;
EXECUTE StrSQL;
END$$

DELIMITER ;