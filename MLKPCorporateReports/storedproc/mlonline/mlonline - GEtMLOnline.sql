DELIMITER $$

USE `ecommercemerchants`$$

DROP PROCEDURE IF EXISTS `GEtMLOnline`$$

CREATE DEFINER=`root`@`%` PROCEDURE `GEtMLOnline`(IN db VARCHAR(10),IN _day VARCHAR(10),IN _year VARCHAR(10),IN Mname VARCHAR(20) )
BEGIN
	SET @query= CONCAT('
	SELECT orderid AS order_number,orderdetail AS description,price AS amount 
	FROM `ecommercetransactions',_year,'`.ecommercetransactions',db,'
	WHERE YEAR(transdate) = ',_year,' AND merchantname = ''',Mname,'''
	');
		
	PREPARE StrSQL FROM @query;
	EXECUTE StrSQL;
	DEALLOCATE PREPARE StrSQL;
 END$$

DELIMITER ;