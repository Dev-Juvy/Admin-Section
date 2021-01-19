DELIMITER $$

USE `KPPartnersExpress`$$

DROP PROCEDURE IF EXISTS `HOgetExpressEload`$$

CREATE DEFINER=`root`@`%` PROCEDURE `HOgetExpressEload`(IN walletno VARCHAR(100),IN _datefrom VARCHAR(15),IN _dateto VARCHAR(15))
BEGIN
DECLARE _monthdate VARCHAR(4);
DECLARE _year VARCHAR(4);
DROP  TEMPORARY  TABLE IF EXISTS KPPartnersExpress.tmpwallettxn;
CREATE  TEMPORARY TABLE KPPartnersExpress.tmpwallettxn(transdate VARCHAR(100),operator VARCHAR(100),walletno VARCHAR(100),mobileno VARCHAR(100),
network VARCHAR(100),notrans VARCHAR(100),principal VARCHAR(100),charge VARCHAR(100),fee VARCHAR(100),commission VARCHAR(100),kptn VARCHAR(100));
WHILE DATE(_datefrom) <= DATE(_dateto) DO
SET _monthdate = DATE_FORMAT(_datefrom,'%m%d');
SET _year = DATE_FORMAT(_datefrom,'%Y');
	
SET @n_query= CONCAT('insert into KPPartnersExpress.tmpwallettxn(transdate,operator,walletno,mobileno ,network ,notrans ,principal,charge,fee,
 commission,kptn)'
'SELECT DATE(transdate) AS transdate,operator,walletno,mobileno,network,1 AS notrans,amount AS principal,0 AS charge,
0 AS fee,commission,kptn FROM `KPPartnersExpress`.`eloadhistory` 
WHERE operator = ''',walletno,''' AND DATE(transdate) = ''',_datefrom,''' 
; ');						
SET _datefrom = DATE_ADD(_datefrom, INTERVAL 1 DAY);                 
PREPARE StrSQL FROM @n_query;
EXECUTE StrSQL;
END WHILE;
SET @sql3=CONCAT('SELECT transdate,operator,walletno,mobileno,network,notrans, principal, charge,
fee,commission,kptn from KPPartnersExpress.tmpwallettxn 
; ');
PREPARE gtpo3 FROM @sql3;
EXECUTE gtpo3;
END$$

DELIMITER ;