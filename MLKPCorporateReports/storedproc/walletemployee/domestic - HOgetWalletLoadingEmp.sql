DELIMITER $$

USE `kpdomestic`$$

DROP PROCEDURE IF EXISTS `HOgetWalletLoadingEmp`$$

CREATE DEFINER=`root`@`%` PROCEDURE `HOgetWalletLoadingEmp`(IN accountCode VARCHAR(30),IN _datefrom VARCHAR(15),IN _dateto VARCHAR(15),IN prefix VARCHAR(5))
BEGIN
DECLARE _monthdate VARCHAR(4);
DECLARE _year VARCHAR(4);
DROP  TEMPORARY  TABLE IF EXISTS `kpdomestic`.tmpwallettxn;
CREATE  TEMPORARY TABLE `kpdomestic`.tmpwallettxn(flag VARCHAR(100),transdate VARCHAR(100),kptn VARCHAR(100),receivername VARCHAR(100),sendername VARCHAR(100),sobranch VARCHAR(100),
pobranch VARCHAR(100),partnername VARCHAR(100),principal VARCHAR(100),charge VARCHAR(100),commission VARCHAR(100),accountid VARCHAR(100),username VARCHAR(100),
fullname VARCHAR(100),operator VARCHAR(100),cancelreason VARCHAR(100),cancelleddate VARCHAR(100),oldkptn VARCHAR(100),cancelledbyoperator VARCHAR(100),
custid VARCHAR(100),controlno VARCHAR(100),branchcode VARCHAR(100),zonecode VARCHAR(100));
#WHILE DATE(_datefrom) <= DATE(_dateto) DO
SET _monthdate = DATE_FORMAT(_datefrom,'%m%d');
SET _year = DATE_FORMAT(_datefrom,'%Y');
	
SET @n_query= CONCAT(/*'insert into `kpdomestic`.tmpwallettxn(flag ,transdate ,kptn ,receivername ,sendername ,sobranch ,
pobranch ,partnername ,principal ,charge ,commission ,accountid ,username ,
fullname ,operator ,cancelreason ,cancelleddate ,oldkptn ,cancelledbyoperator ,
custid ,controlno ,branchcode ,zonecode )'*/
'SELECT 
'''' AS flag ,claimeddate as transdate ,kptnno as kptn ,receivername ,sendername ,sobranch ,
b.branchname as  pobranch ,'''' as partnername ,principal ,servicecharge as charge ,0 as commission ,senderid as accountid ,'''' as username ,
'''' as fullname ,operatorid as operator ,cancelledreason as cancelreason ,cancelleddate ,'''' as oldkptn ,cancelledbyoperatorid as cancelledbyoperator ,
custid ,controlno ,p.branchcode ,p.zonecode 
FROM `kpdomestic`.payout',_monthdate,' p
inner join kpusers.branches b on b.branchcode=p.branchcode and b.zonecode=p.zonecode
WHERE kptnno LIKE ''',prefix,''' and controlno like ''%lp%'' and year(p.claimeddate)=',_year,' ORDER BY transdate ASC;
');						
#SET _datefrom = DATE_ADD(_datefrom, INTERVAL 1 DAY);                 
PREPARE StrSQL FROM @n_query;
EXECUTE StrSQL;
#END WHILE;
/*SET @sql3=CONCAT('select flag ,if(transdate is null,''0000-00-00 00:00:00'',transdate) as transdate ,kptn ,receivername ,sendername ,sobranch ,
pobranch ,partnername ,principal ,charge ,commission ,accountid ,username ,
fullname ,operator ,cancelreason ,if(cancelleddate is null,''0000-00-00 00:00:00'',cancelleddate) as cancelleddate ,oldkptn ,cancelledbyoperator ,
custid ,controlno ,branchcode ,zonecode from `kpdomestic`.tmpwallettxn; ');
PREPARE gtpo3 FROM @sql3;
EXECUTE gtpo3;*/
END$$

DELIMITER ;