DELIMITER $$

USE `ELoadTransactions`$$

DROP PROCEDURE IF EXISTS `HOgetWalletEloadEmp`$$

CREATE DEFINER=`root`@`%` PROCEDURE `HOgetWalletEloadEmp`(IN accountCode VARCHAR(30),IN _datefrom VARCHAR(15),IN _dateto VARCHAR(15))
BEGIN
DECLARE _month VARCHAR(2);
DECLARE _day VARCHAR(2);
DECLARE _year VARCHAR(4);
DROP  TEMPORARY  TABLE IF EXISTS `ELoadTransactions`.tmpwallettxn;
CREATE  TEMPORARY TABLE `ELoadTransactions`.tmpwallettxn(flag VARCHAR(100),transdate VARCHAR(100),kptn VARCHAR(100),
receivername VARCHAR(100),sendername VARCHAR(100),network VARCHAR(100),sobranch VARCHAR(100),
pobranch VARCHAR(100),partnername VARCHAR(100),principal VARCHAR(100),charge VARCHAR(100),commission VARCHAR(100),accountid VARCHAR(100),username VARCHAR(100),
fullname VARCHAR(100),operator VARCHAR(100),cancelreason VARCHAR(100),cancelleddate VARCHAR(100),oldkptn VARCHAR(100),cancelledbyoperator VARCHAR(100),
custid VARCHAR(100),controlno VARCHAR(100),branchcode VARCHAR(100),zonecode VARCHAR(100) );
WHILE DATE(_datefrom) <= DATE(_dateto) DO
SET _month = DATE_FORMAT(_datefrom,'%m');
SET _day = DATE_FORMAT(_datefrom,'%d');
SET _year = DATE_FORMAT(_datefrom,'%Y');
		
SET @n_query= CONCAT('insert into `ELoadTransactions`.tmpwallettxn(flag,transdate,kptn,receivername,sendername,network,sobranch,pobranch,partnername,principal,charge,commission,accountid,
username,fullname,operator,cancelreason,cancelleddate,oldkptn,cancelledbyoperator,custid,controlno,branchcode,zonecode )'
'SELECT 
'''' AS flag,
s.transdate,transno AS kptn,mobileno AS receivername,s.operator AS sendername,n.network,
'''' AS sobranch,'''' AS pobranch,'''' AS partnername,
amount AS principal,0 AS charge,(amount* (nm.`MarginPercent`*0.01)) AS commission,
''''AS accountid,'''' AS username, '''' AS fullname,operator,'''' AS cancelreason,
''0000-00-00 00:00:00'' AS cancelleddate,'''' AS oldkptn,'''' AS cancelledbyoperator,'''' AS custid,'''' AS controlno,branchcode,zonecode
FROM `ELoadTransactions`.`TransLog',_month,'` s   
INNER JOIN `ELoadAdmin`.`NetworkInfo` n ON n.networkid = s.networkid  
INNER JOIN `ELoadAdmin`.`NetworkMargin` nm ON nm.networkid = s.networkid  
WHERE YEAR(s.transdate)=',_year,' and day(s.transdate)=',_day,' and transno like ''%mwe%'' ORDER BY transdate ASC;
');													
SET _datefrom = DATE_ADD(_datefrom, INTERVAL 1 DAY);                
PREPARE StrSQL FROM @n_query;
EXECUTE StrSQL;
END WHILE;
SET @sql3=CONCAT('select flag,if(transdate is null,''0000-00-00 00:00:00'',transdate) as transdate,kptn,receivername,sendername,network,sobranch,pobranch,partnername,principal,charge,commission,accountid,
username,fullname,operator,cancelreason,if(cancelleddate is null,''0000-00-00 00:00:00'',cancelleddate) as cancelleddate,oldkptn,cancelledbyoperator,custid,controlno,branchcode,zonecode 
from `ELoadTransactions`.tmpwallettxn; ');
PREPARE gtpo3 FROM @sql3;
EXECUTE gtpo3;
END$$

DELIMITER ;