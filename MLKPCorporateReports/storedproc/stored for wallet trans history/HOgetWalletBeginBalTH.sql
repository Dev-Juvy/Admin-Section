DELIMITER $$

USE `kpmobile`$$

DROP PROCEDURE IF EXISTS `HOgetWalletBeginBalTH`$$

CREATE DEFINER=`root`@`%` PROCEDURE `HOgetWalletBeginBalTH`(IN walletno VARCHAR(50))
BEGIN	
SET @n_query= CONCAT('select walletno,username,custid,trim(customername) as customername,sum(beginningbal) AS beginningbal  
from (SELECT walletno,username,custid,CONCAT(lastname,'', '',firstname,'' '',middlename) AS customername,balance AS beginningbal  
FROM `kpmobile`.`mobileaccounts` where username<>'''' and username is not null )x where customername is not null
AND walletno = ',walletno,' group by username,customername order by customername asc;
');	 
PREPARE StrSQL FROM @n_query;
EXECUTE StrSQL;
END$$

DELIMITER ;