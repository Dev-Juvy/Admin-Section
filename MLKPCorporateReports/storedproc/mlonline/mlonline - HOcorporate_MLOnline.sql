DELIMITER $$

USE `ecommercetransactions`$$

DROP PROCEDURE IF EXISTS `HOcorporate_MLOnline`$$

CREATE DEFINER=`root`@`%` PROCEDURE `HOcorporate_MLOnline`()
BEGIN
	SET @query= CONCAT('
	SELECT merchantname ,id FROM `ecommercemerchants`.`merchantlist`   GROUP BY merchantname;
	');
		
	PREPARE StrSQL FROM @query;
	EXECUTE StrSQL;
	DEALLOCATE PREPARE StrSQL;
 END$$

DELIMITER ;