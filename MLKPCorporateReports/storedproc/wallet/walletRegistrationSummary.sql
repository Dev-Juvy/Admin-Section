DELIMITER $$

USE `kpmobile`$$

DROP PROCEDURE IF EXISTS `walletRegistrationSummary`$$

CREATE DEFINER=`root`@`%` PROCEDURE `walletRegistrationSummary`(IN frmYear VARCHAR(5), IN toYear VARCHAR(5))
BEGIN
SET @sql=CONCAT('SELECT COUNT(*) AS ttlCount, YEAR(DTCreated) AS _dateyear, MONTH(DTCreated) AS  _datemonth 
FROM `kpmobile`.`mobileaccounts` 
WHERE YEAR(DTCreated) BETWEEN ',frmYear,' AND ',toYear,' GROUP BY _datemonth,_dateyear
ORDER BY _dateyear,_datemonth
');
PREPARE gtpo FROM @sql;
EXECUTE gtpo;
END$$

DELIMITER ;