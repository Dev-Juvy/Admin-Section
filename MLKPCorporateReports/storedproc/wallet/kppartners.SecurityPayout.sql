DELIMITER $$

USE `kppartners`$$

DROP PROCEDURE IF EXISTS `SecurityPayout`$$

CREATE DEFINER=`root`@`%` PROCEDURE `SecurityPayout`(IN potable VARCHAR(20),IN _year VARCHAR(5))
BEGIN 
DECLARE _monthdate VARCHAR(4);
SET potable = DATE_FORMAT(_monthdate,'%m%d');
	SET @n_query= CONCAT('SELECT DISTINCT DATE_FORMAT(claimeddate,''%Y-%m-%d %r'') AS claimeddate,
 d.senderName,
 a.accountname,
 d.controlno,
 referenceno,
 d.receivername,
 b.kptnno,
 d.principal   
 FROM `kppartners`.payout',_monthdate,' d
 INNER JOIN `kpadminpartners`.`accountlist` a ON a.accountid = d.accountcode
 INNER JOIN `kpadminpartnerslog`.`transactionslogs` b ON b.accountcode = d.accountcode
 WHERE kptnno LIKE ''%MLV%'' AND YEAR(claimeddate)=',_year,'');
		
		
		
	PREPARE n_StrSQL FROM @n_query;
	EXECUTE n_StrSQL;
	DEALLOCATE PREPARE n_StrSQL;
    END$$

DELIMITER ;