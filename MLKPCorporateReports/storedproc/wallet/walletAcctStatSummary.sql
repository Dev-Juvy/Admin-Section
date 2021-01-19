DELIMITER $$

USE `kpmobile`$$

DROP PROCEDURE IF EXISTS `walletAcctStatSummary`$$

CREATE DEFINER=`root`@`%` PROCEDURE `walletAcctStatSummary`(IN frmYear VARCHAR(5), IN toYear VARCHAR(5))
BEGIN
SET @sql=CONCAT('SELECT  ttlCount ,TYPE, _dateyear, _datemonth FROM(
SELECT COUNT(*) AS ttlCount ,''active users'' AS ''type'' , YEAR(DTCreated) AS _dateyear, MONTH(DTCreated) AS  _datemonth 
FROM `kpmobile`.`mobileaccounts` 
WHERE YEAR(DTCreated) BETWEEN ',frmYear,' AND ',toYear,' AND isactive = ''1'' AND balance>0
GROUP BY _datemonth,_dateyear
UNION ALL 
SELECT COUNT(operatorid) AS ttlCount, ''active users w/ transactions'' AS ''type'', _dateyear, 
  _datemonth  
FROM(
SELECT DISTINCT operatorid, YEAR(transdate) AS _dateyear, 
MONTH(transdate) AS  _datemonth  
FROM `kpmobiletransactions`.`mobilesendouts` WHERE YEAR(transdate) BETWEEN ',frmYear,' AND ',toYear,'
)X GROUP BY _datemonth,_dateyear
 UNION ALL
SELECT COUNT(*) AS ttlCount, ''inactive users''  AS ''type'', YEAR(DTCreated) AS _dateyear, MONTH(DTCreated) AS  _datemonth 
FROM `kpmobile`.`mobileaccounts` a 
WHERE YEAR(DTCreated) BETWEEN ',frmYear,' AND ',toYear,'
 AND isactive = ''1'' AND balance = 0
 GROUP BY _datemonth,_dateyear
UNION ALL
SELECT COUNT(*) AS ttlCount ,''deactivated users'' AS ''type'',YEAR(DTCreated) AS _dateyear, MONTH(DTCreated) AS  _datemonth 
  FROM `kpmobile`.`mobileaccounts` 
WHERE YEAR(DTCreated) BETWEEN ',frmYear,' AND ',toYear,' AND isactive = ''0''
GROUP BY _datemonth,_dateyear
)X ORDER BY _dateyear,_datemonth
');
PREPARE gtpo FROM @sql;
EXECUTE gtpo;
END$$

DELIMITER ;