DELIMITER $$

USE `kpOFW`$$

DROP PROCEDURE IF EXISTS `HOcorporate_MLExpress2`$$

CREATE DEFINER=`root`@`%` PROCEDURE `HOcorporate_MLExpress2`()
BEGIN
	SET @query= CONCAT('
	select fullname,username,accountno,custid from 
	(SELECT concat(lastname,'', '',firstname,'' '',middlename) as fullname,username,accountno,custid
	 from `kpOFW`.`OFWaccounts` where isactive=1 and isagent=1
	 ) 
	x group by accountno order by fullname asc
	#group by username order by fullname asc
	');
		
	PREPARE StrSQL FROM @query;
	EXECUTE StrSQL;
	DEALLOCATE PREPARE StrSQL;
 END$$

DELIMITER ;