DELIMITER $$

USE `kppartners`$$

DROP PROCEDURE IF EXISTS `HOgetdailypayoutFUExpress`$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `HOgetdailypayoutFUExpress`(IN potable VARCHAR(4),IN _year VARCHAR(10) ,IN accountCode VARCHAR(30), IN zcode VARCHAR(5),IN rcode VARCHAR(5),IN acode VARCHAR(5),IN bcode VARCHAR(5),IN _role VARCHAR(50), IN oldzcode VARCHAR(5) )
BEGIN
IF _role = "NOTIAD" THEN #NOT IAD USER
	SET @SQLStmt = CONCAT(' select 
		controlno,kptn,referenceno,sendername,receivername,DATE_FORMAT(transdate,''%Y-%m-%d %r'') AS transdate,
		DATE_FORMAT(cancelleddate,''%Y-%m-%d %r'') AS cancelleddate,DATE_FORMAT(cancelleddate,''%r'') AS TIME,
		if(Receiver_Phone is null,'''',Receiver_Phone) as Receiver_Phone,
		if(operator is null,operatorid,operator) as Operator,currency,if(cancelreason is null,'''',cancelreason) as cancelreason,
		branchcode,principal,if(charge is null,0,charge) as charge,adjprincipal,adjCharge,
		socancelprincipal,socancelcharge,if(flag is null,'''',flag) as flag,if(branchname is null,'''',branchname) as branchname,
		if(commission is null,0,commission) as commission,zonecode,operatorid, partnername
		from(
SELECT 
DISTINCT IF(oldkptn IS NULL,p.kptn,oldkptn) AS kptn,
IF(p.cancelleddate IS NOT NULL AND p.cancelleddate<>''0000-00-00 00:00:00'' AND p.cancelleddate<>'''' ,''**'','''') AS flag, 
                        p.claimeddate AS cancelleddate,
			reason AS cancelreason,
			controlno,
			p.sendername AS sendername,
			(SELECT so.transdate FROM `kppartnerstransactions`.`corporatesendouts` so WHERE so.kptn=IF(p.oldkptn IS NULL,p.kptn,p.oldkptn) LIMIT 1) AS transdate,
			(SELECT DATE_FORMAT(so.transdate,''%H:%i:%S'') FROM `kppartnerstransactions`.`corporatesendouts` so WHERE so.kptn=IF(p.oldkptn IS NULL,p.kptn,p.oldkptn) LIMIT 1) AS TIME,
			(SELECT so.transdate FROM `kppartnerstransactions`.`corporatesendouts` so WHERE so.kptn=IF(p.oldkptn IS NULL,p.kptn,p.oldkptn) LIMIT 1) AS sodate,
			p.receivername AS receivername,
			oldkptn,''-'' AS Receiver_Phone,
			IF(oldkptn IS NULL,p.referenceno,oldkptn) AS referenceno,
			p.Currency,
			principal,(servicecharge + CancelledCustCharge + CancelledEmpCharge) AS servicecharge,
			(SELECT so.chargeamount FROM `kppartnerstransactions`.`corporatesendouts` so WHERE so.kptn=IF(p.oldkptn IS NULL,p.kptn,p.oldkptn) LIMIT 1) AS charge,
			principal AS socancelprincipal,
			(SELECT so.chargeamount FROM `kppartnerstransactions`.`corporatesendouts` so WHERE so.kptn=IF(p.oldkptn IS NULL,p.kptn,p.oldkptn) LIMIT 1) AS socancelcharge,
			IF(p.cancelleddate IS NOT NULL AND p.cancelleddate<>''0000-00-00 00:00:00'' AND p.cancelleddate<>'''' AND DATE(p.cancelleddate)=DATE(p.claimeddate),principal * -1,0) AS  adjprincipal,
			IF(p.cancelleddate IS NOT NULL AND p.cancelleddate<>''0000-00-00 00:00:00'' AND p.cancelleddate<>'''' AND DATE(p.cancelleddate)=DATE(p.claimeddate),
			(SELECT so.chargeamount FROM `kppartnerstransactions`.`corporatesendouts` so WHERE so.kptn=IF(p.oldkptn IS NULL,p.kptn,p.oldkptn) LIMIT 1) * -1,0) AS  adjcharge,
			p.branchcode,(SELECT b.branchname FROM kpusers.branches b WHERE b.branchcode=p.branchcode AND b.zonecode=IF(p.isremote=1,p.remotezonecode,p.zonecode) LIMIT 1) AS branchname,
(
IF (
(SELECT CONCAT(pu.lastname,'', '',pu.firstname,'' '',pu.middlename) FROM `kpadminpartners`.`partnersusers` pu WHERE pu.userid=IF(p.isremote,p.remoteoperatorid,p.operatorid) LIMIT 1) IS NULL,
IF( (SELECT bu.fullname FROM kpusers.sysuseraccounts ss LEFT JOIN  kpusers.branchusers bu ON bu.resourceid=ss.resourceid WHERE ss.userlogin= IF(p.isremote,p.remoteoperatorid,p.operatorid)  LIMIT 1) IS NULL,
    (SELECT bu.fullname FROM kpusers.adminsysuseraccounts ss LEFT JOIN  kpusers.adminbranchusers bu ON bu.resourceid=ss.resourceid WHERE ss.userlogin=IF(p.isremote,p.remoteoperatorid,p.operatorid)  LIMIT 1),
    (SELECT bu.fullname FROM kpusers.sysuseraccounts ss LEFT JOIN  kpusers.branchusers bu ON bu.resourceid=ss.resourceid WHERE ss.userlogin=IF(p.isremote,p.remoteoperatorid,p.operatorid)  LIMIT 1)),
(SELECT CONCAT(pu.lastname,'', '',pu.firstname,'' '',pu.middlename) FROM `kpadminpartners`.`partnersusers` pu WHERE pu.userid=IF(p.isremote,p.remoteoperatorid,p.operatorid) LIMIT 1)
)
) AS Operator,
IF(pocom.commission IS NULL,0,pocom.commission) AS commission,IF(p.isremote,p.remoteoperatorid,p.operatorid) AS operatorid,
IF(p.isremote=1,p.remotezonecode,p.zonecode) AS zonecode,ac.accountname as partnername
FROM kppartners.payout',potable,'  p
INNER JOIN kppartners.potxnref sf ON sf.accountcode=p.accountcode AND sf.referenceno=p.referenceno
	INNER JOIN `kpadminpartners`.`accountlist` ac ON ac.accountid = p.accountcode
LEFT JOIN `kpadminpartners`.`PayoutCommission` pocom ON pocom.accountid=p.accountcode AND pocom.kptn=p.kptn AND pocom.isactive=1
WHERE IF(p.isremote,p.remoteoperatorid,p.operatorid) = ''',accountCode,''' and  sf.transactiontype IN (''2'',''4'')
AND YEAR(p.claimeddate)=',_year,' 
UNION
(
SELECT 
DISTINCT cs.kptn,IF(cs.cancelreason=''RETURN TO SENDER'',''*'','''') AS flag, 
                        IF(cs.transdate IS NULL OR cs.transdate='''',so.transdate,cs.transdate) AS cancelleddate,
			IF(cs.cancelreason IS NULL,''newkptnno'',cs.cancelreason) AS cancelreason,
			cs.controlno,
			CONCAT(cs.senderlname,'', '',cs.senderfname,'' '',cs.sendermname) AS sendername,
			so.transdate,DATE_FORMAT(so.transdate,''%H:%i:%S'') AS TIME,
			CONCAT(',_year,',''-'',SUBSTRING(so.oldkptn,16,2),''-'',SUBSTRING(so.oldkptn,8,2)) AS sodate,
			CONCAT(cs.receiverlname,'', '',cs.receiverfname,'' '',cs.receivermname) AS receivername,
			so.oldkptn,''-'' AS Receiver_Phone,IF(cs.referenceno IS NULL OR cs.referenceno='''',cs.kptn,cs.referenceno) AS referenceno,so.Currency,
			so.principal,0 AS servicecharge,so.chargeamount AS charge,
			so.principal AS socancelprincipal,
			so.chargeamount AS socancelcharge,
			0 AS adjprincipal,
			0 AS adjcharge,
			cs.cancbybranchcode AS branchcode,
			(SELECT b.branchname FROM kpusers.branches b WHERE b.branchcode=so.branchcode AND b.zonecode=IF(cs.isremotecanc=1,cs.cancbyremotezonecode,cs.cancbyzonecode) LIMIT 1) AS branchname,
(
IF (
(SELECT CONCAT(pu.lastname,'', '',pu.firstname,'' '',pu.middlename) FROM `kpadminpartners`.`partnersusers` pu WHERE pu.userid=IF(cs.isremotecanc=1,cs.cancbyremoteoperatorid,cs.cancbyoperatorid) LIMIT 1) IS NULL,
IF( (SELECT bu.fullname FROM kpusers.sysuseraccounts ss LEFT JOIN  kpusers.branchusers bu ON bu.resourceid=ss.resourceid WHERE ss.userlogin=IF(cs.isremotecanc=1,cs.cancbyremoteoperatorid,cs.cancbyoperatorid)  LIMIT 1) IS NULL,
			(SELECT bu.fullname FROM kpusers.adminsysuseraccounts ss LEFT JOIN  kpusers.adminbranchusers bu ON bu.resourceid=ss.resourceid WHERE ss.userlogin=IF(cs.isremotecanc=1,cs.cancbyremoteoperatorid,cs.cancbyoperatorid) LIMIT 1),
			(SELECT bu.fullname FROM kpusers.sysuseraccounts ss LEFT JOIN  kpusers.branchusers bu ON bu.resourceid=ss.resourceid WHERE ss.userlogin=IF(cs.isremotecanc=1,cs.cancbyremoteoperatorid,cs.cancbyoperatorid) LIMIT 1)),
(SELECT CONCAT(pu.lastname,'', '',pu.firstname,'' '',pu.middlename) FROM `kpadminpartners`.`partnersusers` pu WHERE pu.userid=IF(cs.isremotecanc=1,cs.cancbyremoteoperatorid,cs.cancbyoperatorid) LIMIT 1) 
)
) AS Operator,IF(pocom.commission IS NULL,0,pocom.commission) AS commission,
IF(cs.isremotecanc=1,cs.cancbyremoteoperatorid,cs.cancbyoperatorid) AS operatorid,
IF(cs.isremotecanc=1,cs.cancbyremotezonecode,cs.cancbyzonecode) AS zonecode,ac.accountname as partnername
FROM `kppartnerstransactions`.`corporatecancelledSO` cs
INNER JOIN `kppartnerstransactions`.`corporatesendouts` so ON so.kptn=cs.kptn AND so.accountid=cs.accountid
INNER JOIN kppartners.sotxnref sf ON sf.accountcode=cs.accountid AND sf.referenceno=IF(cs.referenceno='''',cs.kptn,cs.referenceno)
INNER JOIN `kpadminpartners`.`accountlist` ac ON ac.accountid = cs.accountid
LEFT JOIN `kpadminpartners`.`PayoutCommission` pocom ON pocom.accountid=cs.accountid AND pocom.kptn=cs.kptn AND pocom.isactive=1
WHERE YEAR(cs.transdate)=',_year,'  AND DATE_FORMAT(cs.transdate,''%m%d'')=',potable,' AND cs.cancelreason IN (''RETURN TO SENDER'') 
AND IF(cs.isremotecanc=1,cs.cancbyremoteoperatorid,cs.cancbyoperatorid) = ''',accountCode,''' and  sf.transactiontype IN (''2'',''4'')
) )x
');
ELSEIF _role = "IAD" THEN #IAD USER
	IF accountCode = "" THEN #NO SPECIFIC PARTNER - FOR SUMMARY REPORT
		IF bcode<>"" AND acode<>"" AND rcode<>"" THEN # BY BRANCH
			SET @SQLStmt= CONCAT('select 
		controlno,kptn,referenceno,sendername,receivername,DATE_FORMAT(transdate,''%Y-%m-%d %r'') AS transdate,
		DATE_FORMAT(cancelleddate,''%Y-%m-%d %r'') AS cancelleddate,DATE_FORMAT(cancelleddate,''%r'') AS TIME,
		if(Receiver_Phone is null,'''',Receiver_Phone) as Receiver_Phone,
		if(operator is null,operatorid,operator) as Operator,currency,if(cancelreason is null,'''',cancelreason) as cancelreason,
		branchcode,principal,if(charge is null,0,charge) as charge,adjprincipal,adjCharge,
		socancelprincipal,socancelcharge,if(flag is null,'''',flag) as flag,if(branchname is null,'''',branchname) as branchname,
		if(commission is null,0,commission) as commission,zonecode,operatorid,partnername
		from(
				SELECT 
				DISTINCT IF(oldkptn IS NULL,p.kptn,oldkptn) AS kptn,
				IF(p.cancelleddate IS NOT NULL AND p.cancelleddate<>''0000-00-00 00:00:00'' AND p.cancelleddate<>'''' ,''**'','''') AS flag, 
				p.claimeddate AS cancelleddate,
				reason AS cancelreason,
				controlno,
				p.sendername AS sendername,
				(SELECT so.transdate FROM `kppartnerstransactions`.`corporatesendouts` so WHERE so.kptn=IF(p.oldkptn IS NULL,p.kptn,p.oldkptn) LIMIT 1) AS transdate,
				(SELECT DATE_FORMAT(so.transdate,''%H:%i:%S'') FROM `kppartnerstransactions`.`corporatesendouts` so WHERE so.kptn=IF(p.oldkptn IS NULL,p.kptn,p.oldkptn) LIMIT 1) AS TIME,
				(SELECT so.transdate FROM `kppartnerstransactions`.`corporatesendouts` so WHERE so.kptn=IF(p.oldkptn IS NULL,p.kptn,p.oldkptn) LIMIT 1) AS sodate,
				p.receivername AS receivername,
				oldkptn,''-'' AS Receiver_Phone,
				IF(oldkptn IS NULL,p.referenceno,oldkptn) AS referenceno,
				p.Currency,
				principal,(servicecharge + CancelledCustCharge + CancelledEmpCharge) AS servicecharge,
				(SELECT so.chargeamount FROM `kppartnerstransactions`.`corporatesendouts` so WHERE so.kptn=IF(p.oldkptn IS NULL,p.kptn,p.oldkptn) LIMIT 1) AS charge,
				principal AS socancelprincipal,
				(SELECT so.chargeamount FROM `kppartnerstransactions`.`corporatesendouts` so WHERE so.kptn=IF(p.oldkptn IS NULL,p.kptn,p.oldkptn) LIMIT 1) AS socancelcharge,
				IF(p.cancelleddate IS NOT NULL AND p.cancelleddate<>''0000-00-00 00:00:00'' AND p.cancelleddate<>''''  AND DATE(p.cancelleddate)=DATE(p.claimeddate),principal * -1,0) AS  adjprincipal,
				IF(p.cancelleddate IS NOT NULL AND p.cancelleddate<>''0000-00-00 00:00:00'' AND p.cancelleddate<>''''  AND DATE(p.cancelleddate)=DATE(p.claimeddate),
				(SELECT so.chargeamount FROM `kppartnerstransactions`.`corporatesendouts` so WHERE so.kptn=IF(p.oldkptn IS NULL,p.kptn,p.oldkptn) LIMIT 1) * -1,0) AS  adjcharge,
				p.branchcode,(SELECT b.branchname FROM kpusers.branches b WHERE b.branchcode=p.branchcode AND b.zonecode=IF(p.isremote=1,p.remotezonecode,p.zonecode) LIMIT 1) AS branchname,
				(
				IF (
				(SELECT CONCAT(pu.lastname,'', '',pu.firstname,'' '',pu.middlename) FROM `kpadminpartners`.`partnersusers` pu WHERE pu.userid=IF(p.isremote,p.remoteoperatorid,p.operatorid) LIMIT 1) IS NULL,
				IF( (SELECT bu.fullname FROM kpusers.sysuseraccounts ss LEFT JOIN  kpusers.branchusers bu ON bu.resourceid=ss.resourceid WHERE ss.userlogin= IF(p.isremote,p.remoteoperatorid,p.operatorid)  LIMIT 1) IS NULL,
				    (SELECT bu.fullname FROM kpusers.adminsysuseraccounts ss LEFT JOIN  kpusers.adminbranchusers bu ON bu.resourceid=ss.resourceid WHERE ss.userlogin=IF(p.isremote,p.remoteoperatorid,p.operatorid)  LIMIT 1),
				    (SELECT bu.fullname FROM kpusers.sysuseraccounts ss LEFT JOIN  kpusers.branchusers bu ON bu.resourceid=ss.resourceid WHERE ss.userlogin=IF(p.isremote,p.remoteoperatorid,p.operatorid)  LIMIT 1)),
				(SELECT CONCAT(pu.lastname,'', '',pu.firstname,'' '',pu.middlename) FROM `kpadminpartners`.`partnersusers` pu WHERE pu.userid=IF(p.isremote,p.remoteoperatorid,p.operatorid) LIMIT 1)
				)
				) AS Operator,IF(pocom.commission IS NULL,0,pocom.commission) AS commission,ac.accountname as partnername,
				IF(p.isremote,p.remoteoperatorid,p.operatorid) AS operatorid,IF(p.isremote=1,p.remotezonecode,p.zonecode) AS zonecode
				FROM kppartners.payout',potable,' p
				INNER JOIN kppartners.potxnref sf ON sf.accountcode=p.accountcode AND sf.referenceno=p.referenceno
				INNER JOIN kpusers.branches b ON b.branchcode=',bcode,' AND b.zonecode=',zcode,'  AND b.oldzonecode=',oldzcode,'
				INNER JOIN `kpadminpartners`.`accountlist` ac ON ac.accountid = p.accountcode
				LEFT JOIN `kpadminpartners`.`PayoutCommission` pocom ON pocom.accountid=p.accountcode AND pocom.kptn=p.kptn AND pocom.isactive=1
				WHERE  YEAR(p.claimeddate)=',_year,' AND p.reason NOT IN (''Change Details'') and  sf.transactiontype IN (''2'',''4'')
				#AND IF (p.isremote,p.remoteoperatorid,p.operatorid) = ''',accountCode,'''
				AND (IF(p.isremote=1,p.remotezonecode,p.zonecode)=',zcode,' or IF(p.isremote=1,p.remotezonecode,p.zonecode)=',oldzcode,') AND IF(p.isremote=1,p.remotebranch,p.branchcode)=',bcode,' 
				UNION
				(SELECT 
				DISTINCT cs.kptn,IF(cs.cancelreason=''RETURN TO SENDER'',''*'','''') AS flag, 
				IF(cs.transdate IS NULL OR cs.transdate='''',so.transdate,cs.transdate) AS cancelleddate,
				IF(cs.cancelreason IS NULL,''newkptnno'',cs.cancelreason) AS cancelreason,
				cs.controlno,
				CONCAT(cs.senderlname,'', '',cs.senderfname,'' '',cs.sendermname) AS sendername,
				so.transdate,DATE_FORMAT(so.transdate,''%H:%i:%S'') AS TIME,
				CONCAT(',_year,',''-'',SUBSTRING(so.oldkptn,16,2),''-'',SUBSTRING(so.oldkptn,8,2)) AS sodate,
				CONCAT(cs.receiverlname,'', '',cs.receiverfname,'' '',cs.receivermname) AS receivername,
				so.oldkptn,''-'' AS Receiver_Phone,IF(cs.referenceno IS NULL OR cs.referenceno='''',cs.kptn,cs.referenceno) AS referenceno,so.Currency,
				so.principal,0 AS servicecharge,so.chargeamount AS charge,
				so.principal AS socancelprincipal,
				so.chargeamount AS socancelcharge,
				0 AS adjprincipal,
				0 AS adjcharge,
				cs.cancbybranchcode AS branchcode,
				b.branchname,
				(
				IF (
				(SELECT CONCAT(pu.lastname,'', '',pu.firstname,'' '',pu.middlename) FROM `kpadminpartners`.`partnersusers` pu WHERE pu.userid=IF(cs.isremotecanc=1,cs.cancbyremoteoperatorid,cs.cancbyoperatorid) LIMIT 1) IS NULL,
				IF( (SELECT bu.fullname FROM kpusers.sysuseraccounts ss LEFT JOIN  kpusers.branchusers bu ON bu.resourceid=ss.resourceid WHERE ss.userlogin=IF(cs.isremotecanc=1,cs.cancbyremoteoperatorid,cs.cancbyoperatorid)  LIMIT 1) IS NULL,
				    (SELECT bu.fullname FROM kpusers.adminsysuseraccounts ss LEFT JOIN  kpusers.adminbranchusers bu ON bu.resourceid=ss.resourceid WHERE ss.userlogin=IF(cs.isremotecanc=1,cs.cancbyremoteoperatorid,cs.cancbyoperatorid) LIMIT 1),
				    (SELECT bu.fullname FROM kpusers.sysuseraccounts ss LEFT JOIN  kpusers.branchusers bu ON bu.resourceid=ss.resourceid WHERE ss.userlogin=IF(cs.isremotecanc=1,cs.cancbyremoteoperatorid,cs.cancbyoperatorid) LIMIT 1)),
				(SELECT CONCAT(pu.lastname,'', '',pu.firstname,'' '',pu.middlename) FROM `kpadminpartners`.`partnersusers` pu WHERE pu.userid=IF(cs.isremotecanc=1,cs.cancbyremoteoperatorid,cs.cancbyoperatorid) LIMIT 1) 
				)
				) AS Operator,IF(pocom.commission IS NULL,0,pocom.commission) AS commission,ac.accountname as partnername,IF(cs.isremotecanc=1,cs.cancbyremoteoperatorid,cs.cancbyoperatorid) AS operatorid,IF(cs.isremotecanc=1,cs.cancbyremotezonecode,cs.cancbyzonecode) AS zonecode
				FROM `kppartnerstransactions`.`corporatecancelledSO` cs
				INNER JOIN `kppartnerstransactions`.`corporatesendouts` so ON so.kptn=cs.kptn AND so.accountid=cs.accountid
				INNER JOIN kpusers.branches b ON b.branchcode=',bcode,' AND b.zonecode=',zcode,'  AND b.oldzonecode=',oldzcode,'
				INNER JOIN kppartners.sotxnref sf ON sf.accountcode=cs.accountid AND sf.referenceno=IF(cs.referenceno='''',cs.kptn,cs.referenceno)
				INNER JOIN `kpadminpartners`.`accountlist` ac ON ac.accountid = cs.accountid
				LEFT JOIN `kpadminpartners`.`PayoutCommission` pocom ON pocom.accountid=cs.accountid AND pocom.kptn=cs.kptn AND pocom.isactive=1
				WHERE  YEAR(cs.transdate)=',_year,' and  sf.transactiontype IN (''2'',''4'')
				#AND IF(cs.isremotecanc=1,cs.cancbyremoteoperatorid,cs.cancbyoperatorid) = ''',accountCode,''' 
				AND (IF(cs.isremotecanc=1,cs.cancbyremotezonecode,cs.cancbyzonecode)=',zcode,' or IF(cs.isremotecanc=1,cs.cancbyremotezonecode,cs.cancbyzonecode)=',oldzcode,') AND IF(cs.isremotecanc=1,cs.cancbyremotebranchcode,cs.cancbybranchcode)=',bcode,' 
				AND DATE_FORMAT(cs.transdate,''%m%d'')=',potable,' AND cs.cancelreason IN (''RETURN TO SENDER'') 
				)
				)x
			');
		END IF ;
	ELSEIF accountCode <> "" THEN #WITH SPECIFIC PARTNER 
		IF bcode<>"" AND acode<>"" AND rcode<>"" THEN #BY BRANCH
			SET @SQLStmt= CONCAT('select 
		controlno,kptn,referenceno,sendername,receivername,DATE_FORMAT(transdate,''%Y-%m-%d %r'') AS transdate,
		DATE_FORMAT(cancelleddate,''%Y-%m-%d %r'') AS cancelleddate,DATE_FORMAT(cancelleddate,''%r'') AS TIME,
		if(Receiver_Phone is null,'''',Receiver_Phone) as Receiver_Phone,
		if(operator is null,operatorid,operator) as Operator,currency,if(cancelreason is null,'''',cancelreason) as cancelreason,
		branchcode,principal,if(charge is null,0,charge) as charge,adjprincipal,adjCharge,
		socancelprincipal,socancelcharge,if(flag is null,'''',flag) as flag,if(branchname is null,'''',branchname) as branchname,
		if(commission is null,0,commission) as commission,zonecode,operatorid, partnername
		from(
				SELECT 
				DISTINCT IF(oldkptn IS NULL,p.kptn,oldkptn) AS kptn,
				IF(p.cancelleddate IS NOT NULL AND p.cancelleddate<>''0000-00-00 00:00:00'' AND p.cancelleddate<>'''' ,''**'','''') AS flag, 
				p.claimeddate AS cancelleddate,
				reason AS cancelreason,
				controlno,
				p.sendername AS sendername,
				(SELECT so.transdate FROM `kppartnerstransactions`.`corporatesendouts` so WHERE so.kptn=IF(p.oldkptn IS NULL,p.kptn,p.oldkptn) LIMIT 1) AS transdate,
				(SELECT DATE_FORMAT(so.transdate,''%H:%i:%S'') FROM `kppartnerstransactions`.`corporatesendouts` so WHERE so.kptn=IF(p.oldkptn IS NULL,p.kptn,p.oldkptn) LIMIT 1) AS TIME,
				(SELECT so.transdate FROM `kppartnerstransactions`.`corporatesendouts` so WHERE so.kptn=IF(p.oldkptn IS NULL,p.kptn,p.oldkptn) LIMIT 1) AS sodate,
				p.receivername AS receivername,
				oldkptn,''-'' AS Receiver_Phone,
				IF(oldkptn IS NULL,p.referenceno,oldkptn) AS referenceno,
				p.Currency,
				principal,(servicecharge + CancelledCustCharge + CancelledEmpCharge) AS servicecharge,
				(SELECT so.chargeamount FROM `kppartnerstransactions`.`corporatesendouts` so WHERE so.kptn=IF(p.oldkptn IS NULL,p.kptn,p.oldkptn) LIMIT 1) AS charge,
				principal AS socancelprincipal,
				(SELECT so.chargeamount FROM `kppartnerstransactions`.`corporatesendouts` so WHERE so.kptn=IF(p.oldkptn IS NULL,p.kptn,p.oldkptn) LIMIT 1) AS socancelcharge,
				IF(p.cancelleddate IS NOT NULL AND p.cancelleddate<>''0000-00-00 00:00:00'' AND p.cancelleddate<>''''  AND DATE(p.cancelleddate)=DATE(p.claimeddate),principal * -1,0) AS  adjprincipal,
				IF(p.cancelleddate IS NOT NULL AND p.cancelleddate<>''0000-00-00 00:00:00'' AND p.cancelleddate<>''''  AND DATE(p.cancelleddate)=DATE(p.claimeddate),
				(SELECT so.chargeamount FROM `kppartnerstransactions`.`corporatesendouts` so WHERE so.kptn=IF(p.oldkptn IS NULL,p.kptn,p.oldkptn) LIMIT 1) * -1,0) AS  adjcharge,
				p.branchcode,(SELECT b.branchname FROM kpusers.branches b WHERE b.branchcode=p.branchcode AND b.zonecode=IF(p.isremote=1,p.remotezonecode,p.zonecode) LIMIT 1) AS branchname,
				(
				IF (
				(SELECT CONCAT(pu.lastname,'', '',pu.firstname,'' '',pu.middlename) FROM `kpadminpartners`.`partnersusers` pu WHERE pu.userid=IF(p.isremote,p.remoteoperatorid,p.operatorid) LIMIT 1) IS NULL,
				IF( (SELECT bu.fullname FROM kpusers.sysuseraccounts ss LEFT JOIN  kpusers.branchusers bu ON bu.resourceid=ss.resourceid WHERE ss.userlogin= IF(p.isremote,p.remoteoperatorid,p.operatorid)  LIMIT 1) IS NULL,
				    (SELECT bu.fullname FROM kpusers.adminsysuseraccounts ss LEFT JOIN  kpusers.adminbranchusers bu ON bu.resourceid=ss.resourceid WHERE ss.userlogin=IF(p.isremote,p.remoteoperatorid,p.operatorid)  LIMIT 1),
				    (SELECT bu.fullname FROM kpusers.sysuseraccounts ss LEFT JOIN  kpusers.branchusers bu ON bu.resourceid=ss.resourceid WHERE ss.userlogin=IF(p.isremote,p.remoteoperatorid,p.operatorid)  LIMIT 1)),
				(SELECT CONCAT(pu.lastname,'', '',pu.firstname,'' '',pu.middlename) FROM `kpadminpartners`.`partnersusers` pu WHERE pu.userid=IF(p.isremote,p.remoteoperatorid,p.operatorid) LIMIT 1)
				)
				) AS Operator,IF(pocom.commission IS NULL,0,pocom.commission) AS commission,
				IF(p.isremote,p.remoteoperatorid,p.operatorid) AS operatorid,IF(p.isremote=1,p.remotezonecode,p.zonecode) AS zonecode,ac.accountname as partnername
				FROM kppartners.payout',potable,' p
				INNER JOIN kppartners.potxnref sf ON sf.accountcode=p.accountcode AND sf.referenceno=p.referenceno
				INNER JOIN kpusers.branches b ON b.branchcode=',bcode,' AND b.zonecode=',zcode,'  AND b.oldzonecode=',oldzcode,'
				INNER JOIN `kpadminpartners`.`accountlist` ac ON ac.accountid = p.accountcode
				LEFT JOIN `kpadminpartners`.`PayoutCommission` pocom ON pocom.accountid=p.accountcode AND pocom.kptn=p.kptn AND pocom.isactive=1
				WHERE  YEAR(p.claimeddate)=',_year,' AND p.reason NOT IN (''Change Details'')
				AND IF (p.isremote,p.remoteoperatorid,p.operatorid) = ''',accountCode,''' and  sf.transactiontype IN (''2'',''4'')
				AND (IF(p.isremote=1,p.remotezonecode,p.zonecode)=',zcode,' or IF(p.isremote=1,p.remotezonecode,p.zonecode)=',oldzcode,') AND IF(p.isremote=1,p.remotebranch,p.branchcode)=',bcode,' 
				UNION
				(SELECT 
				DISTINCT cs.kptn,IF(cs.cancelreason=''RETURN TO SENDER'',''*'','''') AS flag, 
				IF(cs.transdate IS NULL OR cs.transdate='''',so.transdate,cs.transdate) AS cancelleddate,
				IF(cs.cancelreason IS NULL,''newkptnno'',cs.cancelreason) AS cancelreason,
				cs.controlno,
				CONCAT(cs.senderlname,'', '',cs.senderfname,'' '',cs.sendermname) AS sendername,
				so.transdate,DATE_FORMAT(so.transdate,''%H:%i:%S'') AS TIME,
				CONCAT(',_year,',''-'',SUBSTRING(so.oldkptn,16,2),''-'',SUBSTRING(so.oldkptn,8,2)) AS sodate,
				CONCAT(cs.receiverlname,'', '',cs.receiverfname,'' '',cs.receivermname) AS receivername,
				so.oldkptn,''-'' AS Receiver_Phone,IF(cs.referenceno IS NULL OR cs.referenceno='''',cs.kptn,cs.referenceno) AS referenceno,so.Currency,
				so.principal,0 AS servicecharge,so.chargeamount AS charge,
				so.principal AS socancelprincipal,
				so.chargeamount AS socancelcharge,
				0 AS adjprincipal,
				0 AS adjcharge,
				cs.cancbybranchcode AS branchcode,
				b.branchname,
				(
				IF (
				(SELECT CONCAT(pu.lastname,'', '',pu.firstname,'' '',pu.middlename) FROM `kpadminpartners`.`partnersusers` pu WHERE pu.userid=IF(cs.isremotecanc=1,cs.cancbyremoteoperatorid,cs.cancbyoperatorid) LIMIT 1) IS NULL,
				IF( (SELECT bu.fullname FROM kpusers.sysuseraccounts ss LEFT JOIN  kpusers.branchusers bu ON bu.resourceid=ss.resourceid WHERE ss.userlogin=IF(cs.isremotecanc=1,cs.cancbyremoteoperatorid,cs.cancbyoperatorid)  LIMIT 1) IS NULL,
				    (SELECT bu.fullname FROM kpusers.adminsysuseraccounts ss LEFT JOIN  kpusers.adminbranchusers bu ON bu.resourceid=ss.resourceid WHERE ss.userlogin=IF(cs.isremotecanc=1,cs.cancbyremoteoperatorid,cs.cancbyoperatorid) LIMIT 1),
				    (SELECT bu.fullname FROM kpusers.sysuseraccounts ss LEFT JOIN  kpusers.branchusers bu ON bu.resourceid=ss.resourceid WHERE ss.userlogin=IF(cs.isremotecanc=1,cs.cancbyremoteoperatorid,cs.cancbyoperatorid) LIMIT 1)),
				(SELECT CONCAT(pu.lastname,'', '',pu.firstname,'' '',pu.middlename) FROM `kpadminpartners`.`partnersusers` pu WHERE pu.userid=IF(cs.isremotecanc=1,cs.cancbyremoteoperatorid,cs.cancbyoperatorid) LIMIT 1) 
				)
				) AS Operator,IF(pocom.commission IS NULL,0,pocom.commission) AS commission,
				IF(cs.isremotecanc=1,cs.cancbyremoteoperatorid,cs.cancbyoperatorid) AS operatorid,
				IF(cs.isremotecanc=1,cs.cancbyremotezonecode,cs.cancbyzonecode) AS zonecode,ac.accountname as partnername
				FROM `kppartnerstransactions`.`corporatecancelledSO` cs
				INNER JOIN `kppartnerstransactions`.`corporatesendouts` so ON so.kptn=cs.kptn AND so.accountid=cs.accountid
				INNER JOIN kpusers.branches b ON b.branchcode=',bcode,' AND b.zonecode=',zcode,'  AND b.oldzonecode=',oldzcode,'
				INNER JOIN kppartners.sotxnref sf ON sf.accountcode=cs.accountid AND sf.referenceno=IF(cs.referenceno='''',cs.kptn,cs.referenceno)
				INNER JOIN `kpadminpartners`.`accountlist` ac ON ac.accountid = cs.accountid
				LEFT JOIN `kpadminpartners`.`PayoutCommission` pocom ON pocom.accountid=cs.accountid AND pocom.kptn=cs.kptn AND pocom.isactive=1
				WHERE  YEAR(cs.transdate)=',_year,' and  sf.transactiontype IN (''2'',''4'')
				AND IF(cs.isremotecanc=1,cs.cancbyremoteoperatorid,cs.cancbyoperatorid) = ''',accountCode,'''
				AND (IF(cs.isremotecanc=1,cs.cancbyremotezonecode,cs.cancbyzonecode)=',zcode,' or IF(cs.isremotecanc=1,cs.cancbyremotezonecode,cs.cancbyzonecode)=',oldzcode,') AND IF(cs.isremotecanc=1,cs.cancbyremotebranchcode,cs.cancbybranchcode)=',bcode,' 
				AND DATE_FORMAT(cs.transdate,''%m%d'')=',potable,' AND cs.cancelreason IN (''RETURN TO SENDER'') 
				)
				)x
			');
			ELSEIF bcode="" AND acode<>"" AND rcode<>"" THEN #BY AREA
			SET @SQLStmt= CONCAT('select 
		controlno,kptn,referenceno,sendername,receivername,DATE_FORMAT(transdate,''%Y-%m-%d %r'') AS transdate,
		DATE_FORMAT(cancelleddate,''%Y-%m-%d %r'') AS cancelleddate,DATE_FORMAT(cancelleddate,''%r'') AS TIME,
		if(Receiver_Phone is null,'''',Receiver_Phone) as Receiver_Phone,
		if(operator is null,operatorid,operator) as Operator,currency,if(cancelreason is null,'''',cancelreason) as cancelreason,
		branchcode,principal,if(charge is null,0,charge) as charge,adjprincipal,adjCharge,
		socancelprincipal,socancelcharge,if(flag is null,'''',flag) as flag,if(branchname is null,'''',branchname) as branchname,
		if(commission is null,0,commission) as commission,zonecode,operatorid,partnername
		from(
				SELECT 
				DISTINCT IF(oldkptn IS NULL,p.kptn,oldkptn) AS kptn,
				IF(p.cancelleddate IS NOT NULL AND p.cancelleddate<>''0000-00-00 00:00:00'' AND p.cancelleddate<>'''' ,''**'','''') AS flag, 
				p.claimeddate AS cancelleddate,
				reason AS cancelreason,
				controlno,
				p.sendername AS sendername,
				(SELECT so.transdate FROM `kppartnerstransactions`.`corporatesendouts` so WHERE so.kptn=IF(p.oldkptn IS NULL,p.kptn,p.oldkptn) LIMIT 1) AS transdate,
				(SELECT DATE_FORMAT(so.transdate,''%H:%i:%S'') FROM `kppartnerstransactions`.`corporatesendouts` so WHERE so.kptn=IF(p.oldkptn IS NULL,p.kptn,p.oldkptn) LIMIT 1) AS TIME,
				(SELECT so.transdate FROM `kppartnerstransactions`.`corporatesendouts` so WHERE so.kptn=IF(p.oldkptn IS NULL,p.kptn,p.oldkptn) LIMIT 1) AS sodate,
				p.receivername AS receivername,
				oldkptn,''-'' AS Receiver_Phone,
				IF(oldkptn IS NULL,p.referenceno,oldkptn) AS referenceno,
				p.Currency,
				principal,(servicecharge + CancelledCustCharge + CancelledEmpCharge) AS servicecharge,
				(SELECT so.chargeamount FROM `kppartnerstransactions`.`corporatesendouts` so WHERE so.kptn=IF(p.oldkptn IS NULL,p.kptn,p.oldkptn) LIMIT 1) AS charge,
				principal AS socancelprincipal,
				(SELECT so.chargeamount FROM `kppartnerstransactions`.`corporatesendouts` so WHERE so.kptn=IF(p.oldkptn IS NULL,p.kptn,p.oldkptn) LIMIT 1) AS socancelcharge,
				IF(p.cancelleddate IS NOT NULL AND p.cancelleddate<>''0000-00-00 00:00:00'' AND p.cancelleddate<>''''  AND DATE(p.cancelleddate)=DATE(p.claimeddate),principal * -1,0) AS  adjprincipal,
				IF(p.cancelleddate IS NOT NULL AND p.cancelleddate<>''0000-00-00 00:00:00'' AND p.cancelleddate<>''''  AND DATE(p.cancelleddate)=DATE(p.claimeddate),
				(SELECT so.chargeamount FROM `kppartnerstransactions`.`corporatesendouts` so WHERE so.kptn=IF(p.oldkptn IS NULL,p.kptn,p.oldkptn) LIMIT 1) * -1,0) AS  adjcharge,
				p.branchcode,(SELECT b.branchname FROM kpusers.branches b WHERE b.branchcode=p.branchcode AND b.zonecode=IF(p.isremote=1,p.remotezonecode,p.zonecode) LIMIT 1) AS branchname,
				(
				IF (
				(SELECT CONCAT(pu.lastname,'', '',pu.firstname,'' '',pu.middlename) FROM `kpadminpartners`.`partnersusers` pu WHERE pu.userid=IF(p.isremote,p.remoteoperatorid,p.operatorid) LIMIT 1) IS NULL,
				IF( (SELECT bu.fullname FROM kpusers.sysuseraccounts ss LEFT JOIN  kpusers.branchusers bu ON bu.resourceid=ss.resourceid WHERE ss.userlogin= IF(p.isremote,p.remoteoperatorid,p.operatorid)  LIMIT 1) IS NULL,
				    (SELECT bu.fullname FROM kpusers.adminsysuseraccounts ss LEFT JOIN  kpusers.adminbranchusers bu ON bu.resourceid=ss.resourceid WHERE ss.userlogin=IF(p.isremote,p.remoteoperatorid,p.operatorid)  LIMIT 1),
				    (SELECT bu.fullname FROM kpusers.sysuseraccounts ss LEFT JOIN  kpusers.branchusers bu ON bu.resourceid=ss.resourceid WHERE ss.userlogin=IF(p.isremote,p.remoteoperatorid,p.operatorid)  LIMIT 1)),
				(SELECT CONCAT(pu.lastname,'', '',pu.firstname,'' '',pu.middlename) FROM `kpadminpartners`.`partnersusers` pu WHERE pu.userid=IF(p.isremote,p.remoteoperatorid,p.operatorid) LIMIT 1)
				)
				) AS Operator,IF(pocom.commission IS NULL,0,pocom.commission) AS commission,
				IF(p.isremote,p.remoteoperatorid,p.operatorid) AS operatorid,IF(p.isremote=1,p.remotezonecode,p.zonecode) AS zonecode,ac.accountname as partnername
				FROM kppartners.payout',potable,' p
				INNER JOIN kppartners.potxnref sf ON sf.accountcode=p.accountcode AND sf.referenceno=p.referenceno
				INNER JOIN kpusers.branches b on b.branchcode=if(p.isremote=1,p.remotebranch,p.branchcode) AND b.zonecode=',zcode,'  AND b.oldzonecode=',oldzcode,' and b.areacode=''',acode,''' and b.regioncode=',rcode,'
				INNER JOIN `kpadminpartners`.`accountlist` ac ON ac.accountid = p.accountcode
				LEFT JOIN `kpadminpartners`.`PayoutCommission` pocom ON pocom.accountid=p.accountcode AND pocom.kptn=p.kptn AND pocom.isactive=1
				WHERE  YEAR(p.claimeddate)=',_year,' AND p.reason NOT IN (''Change Details'')
				AND IF (p.isremote,p.remoteoperatorid,p.operatorid) = ''',accountCode,'''
				AND (IF(p.isremote=1,p.remotezonecode,p.zonecode)=',zcode,' or IF(p.isremote=1,p.remotezonecode,p.zonecode)=',oldzcode,') and  sf.transactiontype IN (''2'',''4'')
				UNION
				(SELECT 
				DISTINCT cs.kptn,IF(cs.cancelreason=''RETURN TO SENDER'',''*'','''') AS flag, 
				IF(cs.transdate IS NULL OR cs.transdate='''',so.transdate,cs.transdate) AS cancelleddate,
				IF(cs.cancelreason IS NULL,''newkptnno'',cs.cancelreason) AS cancelreason,
				cs.controlno,
				CONCAT(cs.senderlname,'', '',cs.senderfname,'' '',cs.sendermname) AS sendername,
				so.transdate,DATE_FORMAT(so.transdate,''%H:%i:%S'') AS TIME,
				CONCAT(',_year,',''-'',SUBSTRING(so.oldkptn,16,2),''-'',SUBSTRING(so.oldkptn,8,2)) AS sodate,
				CONCAT(cs.receiverlname,'', '',cs.receiverfname,'' '',cs.receivermname) AS receivername,
				so.oldkptn,''-'' AS Receiver_Phone,IF(cs.referenceno IS NULL OR cs.referenceno='''',cs.kptn,cs.referenceno) AS referenceno,so.Currency,
				so.principal,0 AS servicecharge,so.chargeamount AS charge,
				so.principal AS socancelprincipal,
				so.chargeamount AS socancelcharge,
				0 AS adjprincipal,
				0 AS adjcharge,
				cs.cancbybranchcode AS branchcode,
				b.branchname,
				(
				IF (
				(SELECT CONCAT(pu.lastname,'', '',pu.firstname,'' '',pu.middlename) FROM `kpadminpartners`.`partnersusers` pu WHERE pu.userid=IF(cs.isremotecanc=1,cs.cancbyremoteoperatorid,cs.cancbyoperatorid) LIMIT 1) IS NULL,
				IF( (SELECT bu.fullname FROM kpusers.sysuseraccounts ss LEFT JOIN  kpusers.branchusers bu ON bu.resourceid=ss.resourceid WHERE ss.userlogin=IF(cs.isremotecanc=1,cs.cancbyremoteoperatorid,cs.cancbyoperatorid)  LIMIT 1) IS NULL,
				    (SELECT bu.fullname FROM kpusers.adminsysuseraccounts ss LEFT JOIN  kpusers.adminbranchusers bu ON bu.resourceid=ss.resourceid WHERE ss.userlogin=IF(cs.isremotecanc=1,cs.cancbyremoteoperatorid,cs.cancbyoperatorid) LIMIT 1),
				    (SELECT bu.fullname FROM kpusers.sysuseraccounts ss LEFT JOIN  kpusers.branchusers bu ON bu.resourceid=ss.resourceid WHERE ss.userlogin=IF(cs.isremotecanc=1,cs.cancbyremoteoperatorid,cs.cancbyoperatorid) LIMIT 1)),
				(SELECT CONCAT(pu.lastname,'', '',pu.firstname,'' '',pu.middlename) FROM `kpadminpartners`.`partnersusers` pu WHERE pu.userid=IF(cs.isremotecanc=1,cs.cancbyremoteoperatorid,cs.cancbyoperatorid) LIMIT 1) 
				)
				) AS Operator,IF(pocom.commission IS NULL,0,pocom.commission) AS commission,
				IF(cs.isremotecanc=1,cs.cancbyremoteoperatorid,cs.cancbyoperatorid) AS operatorid,
				IF(cs.isremotecanc=1,cs.cancbyremotezonecode,cs.cancbyzonecode) AS zonecode,ac.accountname as partnername
				FROM `kppartnerstransactions`.`corporatecancelledSO` cs
				INNER JOIN `kppartnerstransactions`.`corporatesendouts` so ON so.kptn=cs.kptn AND so.accountid=cs.accountid
				INNER JOIN kpusers.branches b on b.branchcode=if(cs.isremotecanc=1,cs.cancbyremotebranchcode,cs.cancbybranchcode) AND b.zonecode=',zcode,'  AND b.oldzonecode=',oldzcode,' and b.areacode=''',acode,''' and b.regioncode=',rcode,'
				INNER JOIN kppartners.sotxnref sf ON sf.accountcode=cs.accountid AND sf.referenceno=IF(cs.referenceno='''',cs.kptn,cs.referenceno)
				INNER JOIN `kpadminpartners`.`accountlist` ac ON ac.accountid = cs.accountid
				LEFT JOIN `kpadminpartners`.`PayoutCommission` pocom ON pocom.accountid=cs.accountid AND pocom.kptn=cs.kptn AND pocom.isactive=1
				WHERE  YEAR(cs.transdate)=',_year,' and  sf.transactiontype IN (''2'',''4'')
				AND IF(cs.isremotecanc=1,cs.cancbyremoteoperatorid,cs.cancbyoperatorid) = ''',accountCode,'''
				AND (IF(cs.isremotecanc=1,cs.cancbyremotezonecode,cs.cancbyzonecode)=',zcode,' or IF(cs.isremotecanc=1,cs.cancbyremotezonecode,cs.cancbyzonecode)=',oldzcode,') 
				AND DATE_FORMAT(cs.transdate,''%m%d'')=',potable,' AND cs.cancelreason IN (''RETURN TO SENDER'') 
				)
				)x
			');
			ELSEIF bcode="" AND acode="" AND rcode<>"" THEN #BY REGION
			SET @SQLStmt= CONCAT('select 
		controlno,kptn,referenceno,sendername,receivername,DATE_FORMAT(transdate,''%Y-%m-%d %r'') AS transdate,
		DATE_FORMAT(cancelleddate,''%Y-%m-%d %r'') AS cancelleddate,DATE_FORMAT(cancelleddate,''%r'') AS TIME,
		if(Receiver_Phone is null,'''',Receiver_Phone) as Receiver_Phone,
		if(operator is null,operatorid,operator) as Operator,currency,if(cancelreason is null,'''',cancelreason) as cancelreason,
		branchcode,principal,if(charge is null,0,charge) as charge,adjprincipal,adjCharge,
		socancelprincipal,socancelcharge,if(flag is null,'''',flag) as flag,if(branchname is null,'''',branchname) as branchname,
		if(commission is null,0,commission) as commission,zonecode,operatorid, partnername
		from(
				SELECT 
				DISTINCT IF(oldkptn IS NULL,p.kptn,oldkptn) AS kptn,
				IF(p.cancelleddate IS NOT NULL AND p.cancelleddate<>''0000-00-00 00:00:00'' AND p.cancelleddate<>'''' ,''**'','''') AS flag, 
				p.claimeddate AS cancelleddate,
				reason AS cancelreason,
				controlno,
				p.sendername AS sendername,
				(SELECT so.transdate FROM `kppartnerstransactions`.`corporatesendouts` so WHERE so.kptn=IF(p.oldkptn IS NULL,p.kptn,p.oldkptn) LIMIT 1) AS transdate,
				(SELECT DATE_FORMAT(so.transdate,''%H:%i:%S'') FROM `kppartnerstransactions`.`corporatesendouts` so WHERE so.kptn=IF(p.oldkptn IS NULL,p.kptn,p.oldkptn) LIMIT 1) AS TIME,
				(SELECT so.transdate FROM `kppartnerstransactions`.`corporatesendouts` so WHERE so.kptn=IF(p.oldkptn IS NULL,p.kptn,p.oldkptn) LIMIT 1) AS sodate,
				p.receivername AS receivername,
				oldkptn,''-'' AS Receiver_Phone,
				IF(oldkptn IS NULL,p.referenceno,oldkptn) AS referenceno,
				p.Currency,
				principal,(servicecharge + CancelledCustCharge + CancelledEmpCharge) AS servicecharge,
				(SELECT so.chargeamount FROM `kppartnerstransactions`.`corporatesendouts` so WHERE so.kptn=IF(p.oldkptn IS NULL,p.kptn,p.oldkptn) LIMIT 1) AS charge,
				principal AS socancelprincipal,
				(SELECT so.chargeamount FROM `kppartnerstransactions`.`corporatesendouts` so WHERE so.kptn=IF(p.oldkptn IS NULL,p.kptn,p.oldkptn) LIMIT 1) AS socancelcharge,
				IF(p.cancelleddate IS NOT NULL AND p.cancelleddate<>''0000-00-00 00:00:00'' AND p.cancelleddate<>''''  AND DATE(p.cancelleddate)=DATE(p.claimeddate),principal * -1,0) AS  adjprincipal,
				IF(p.cancelleddate IS NOT NULL AND p.cancelleddate<>''0000-00-00 00:00:00'' AND p.cancelleddate<>''''  AND DATE(p.cancelleddate)=DATE(p.claimeddate),
				(SELECT so.chargeamount FROM `kppartnerstransactions`.`corporatesendouts` so WHERE so.kptn=IF(p.oldkptn IS NULL,p.kptn,p.oldkptn) LIMIT 1) * -1,0) AS  adjcharge,
				p.branchcode,(SELECT b.branchname FROM kpusers.branches b WHERE b.branchcode=p.branchcode AND b.zonecode=IF(p.isremote=1,p.remotezonecode,p.zonecode) LIMIT 1) AS branchname,
				(
				IF (
				(SELECT CONCAT(pu.lastname,'', '',pu.firstname,'' '',pu.middlename) FROM `kpadminpartners`.`partnersusers` pu WHERE pu.userid=IF(p.isremote,p.remoteoperatorid,p.operatorid) LIMIT 1) IS NULL,
				IF( (SELECT bu.fullname FROM kpusers.sysuseraccounts ss LEFT JOIN  kpusers.branchusers bu ON bu.resourceid=ss.resourceid WHERE ss.userlogin= IF(p.isremote,p.remoteoperatorid,p.operatorid)  LIMIT 1) IS NULL,
				    (SELECT bu.fullname FROM kpusers.adminsysuseraccounts ss LEFT JOIN  kpusers.adminbranchusers bu ON bu.resourceid=ss.resourceid WHERE ss.userlogin=IF(p.isremote,p.remoteoperatorid,p.operatorid)  LIMIT 1),
				    (SELECT bu.fullname FROM kpusers.sysuseraccounts ss LEFT JOIN  kpusers.branchusers bu ON bu.resourceid=ss.resourceid WHERE ss.userlogin=IF(p.isremote,p.remoteoperatorid,p.operatorid)  LIMIT 1)),
				(SELECT CONCAT(pu.lastname,'', '',pu.firstname,'' '',pu.middlename) FROM `kpadminpartners`.`partnersusers` pu WHERE pu.userid=IF(p.isremote,p.remoteoperatorid,p.operatorid) LIMIT 1)
				)
				) AS Operator,IF(pocom.commission IS NULL,0,pocom.commission) AS commission,
				IF(p.isremote,p.remoteoperatorid,p.operatorid) AS operatorid,IF(p.isremote=1,p.remotezonecode,p.zonecode) AS zonecode,ac.accountname as partnernamee
				FROM kppartners.payout',potable,' p
				INNER JOIN kppartners.potxnref sf ON sf.accountcode=p.accountcode AND sf.referenceno=p.referenceno
				INNER JOIN kpusers.branches b on b.branchcode=if(p.isremote=1,p.remotebranch,p.branchcode) AND b.zonecode=',zcode,'  AND b.oldzonecode=',oldzcode,'  and b.regioncode=',rcode,'
				INNER JOIN `kpadminpartners`.`accountlist` ac ON ac.accountid = p.accountcode
				LEFT JOIN `kpadminpartners`.`PayoutCommission` pocom ON pocom.accountid=p.accountcode AND pocom.kptn=p.kptn AND pocom.isactive=1
				WHERE  YEAR(p.claimeddate)=',_year,' AND p.reason NOT IN (''Change Details'')
				AND IF (p.isremote,p.remoteoperatorid,p.operatorid) = ''',accountCode,'''
				AND (IF(p.isremote=1,p.remotezonecode,p.zonecode)=',zcode,' or IF(p.isremote=1,p.remotezonecode,p.zonecode)=',oldzcode,') and  sf.transactiontype IN (''2'',''4'')
				UNION
				(SELECT 
				DISTINCT cs.kptn,IF(cs.cancelreason=''RETURN TO SENDER'',''*'','''') AS flag, 
				IF(cs.transdate IS NULL OR cs.transdate='''',so.transdate,cs.transdate) AS cancelleddate,
				IF(cs.cancelreason IS NULL,''newkptnno'',cs.cancelreason) AS cancelreason,
				cs.controlno,
				CONCAT(cs.senderlname,'', '',cs.senderfname,'' '',cs.sendermname) AS sendername,
				so.transdate,DATE_FORMAT(so.transdate,''%H:%i:%S'') AS TIME,
				CONCAT(',_year,',''-'',SUBSTRING(so.oldkptn,16,2),''-'',SUBSTRING(so.oldkptn,8,2)) AS sodate,
				CONCAT(cs.receiverlname,'', '',cs.receiverfname,'' '',cs.receivermname) AS receivername,
				so.oldkptn,''-'' AS Receiver_Phone,IF(cs.referenceno IS NULL OR cs.referenceno='''',cs.kptn,cs.referenceno) AS referenceno,so.Currency,
				so.principal,0 AS servicecharge,so.chargeamount AS charge,
				so.principal AS socancelprincipal,
				so.chargeamount AS socancelcharge,
				0 AS adjprincipal,
				0 AS adjcharge,
				cs.cancbybranchcode AS branchcode,
				b.branchname,
				(
				IF (
				(SELECT CONCAT(pu.lastname,'', '',pu.firstname,'' '',pu.middlename) FROM `kpadminpartners`.`partnersusers` pu WHERE pu.userid=IF(cs.isremotecanc=1,cs.cancbyremoteoperatorid,cs.cancbyoperatorid) LIMIT 1) IS NULL,
				IF( (SELECT bu.fullname FROM kpusers.sysuseraccounts ss LEFT JOIN  kpusers.branchusers bu ON bu.resourceid=ss.resourceid WHERE ss.userlogin=IF(cs.isremotecanc=1,cs.cancbyremoteoperatorid,cs.cancbyoperatorid)  LIMIT 1) IS NULL,
				    (SELECT bu.fullname FROM kpusers.adminsysuseraccounts ss LEFT JOIN  kpusers.adminbranchusers bu ON bu.resourceid=ss.resourceid WHERE ss.userlogin=IF(cs.isremotecanc=1,cs.cancbyremoteoperatorid,cs.cancbyoperatorid) LIMIT 1),
				    (SELECT bu.fullname FROM kpusers.sysuseraccounts ss LEFT JOIN  kpusers.branchusers bu ON bu.resourceid=ss.resourceid WHERE ss.userlogin=IF(cs.isremotecanc=1,cs.cancbyremoteoperatorid,cs.cancbyoperatorid) LIMIT 1)),
				(SELECT CONCAT(pu.lastname,'', '',pu.firstname,'' '',pu.middlename) FROM `kpadminpartners`.`partnersusers` pu WHERE pu.userid=IF(cs.isremotecanc=1,cs.cancbyremoteoperatorid,cs.cancbyoperatorid) LIMIT 1) 
				)
				) AS Operator,IF(pocom.commission IS NULL,0,pocom.commission) AS commission,
				IF(cs.isremotecanc=1,cs.cancbyremoteoperatorid,cs.cancbyoperatorid) AS operatorid,
				IF(cs.isremotecanc=1,cs.cancbyremotezonecode,cs.cancbyzonecode) AS zonecode,ac.accountname as partnername
				FROM `kppartnerstransactions`.`corporatecancelledSO` cs
				INNER JOIN `kppartnerstransactions`.`corporatesendouts` so ON so.kptn=cs.kptn AND so.accountid=cs.accountid
				INNER JOIN kpusers.branches b on b.branchcode=if(cs.isremotecanc=1,cs.cancbyremotebranchcode,cs.cancbybranchcode) AND b.zonecode=',zcode,'  AND b.oldzonecode=',oldzcode,'  and b.regioncode=',rcode,'
				INNER JOIN kppartners.sotxnref sf ON sf.accountcode=cs.accountid AND sf.referenceno=IF(cs.referenceno='''',cs.kptn,cs.referenceno)
				INNER JOIN `kpadminpartners`.`accountlist` ac ON ac.accountid = cs.accountid
				LEFT JOIN `kpadminpartners`.`PayoutCommission` pocom ON pocom.accountid=cs.accountid AND pocom.kptn=cs.kptn AND pocom.isactive=1
				WHERE  YEAR(cs.transdate)=',_year,' and  sf.transactiontype IN (''2'',''4'')
				AND IF(cs.isremotecanc=1,cs.cancbyremoteoperatorid,cs.cancbyoperatorid) = ''',accountCode,'''
				AND (IF(cs.isremotecanc=1,cs.cancbyremotezonecode,cs.cancbyzonecode)=',zcode,' or IF(cs.isremotecanc=1,cs.cancbyremotezonecode,cs.cancbyzonecode)=',oldzcode,') 
				AND DATE_FORMAT(cs.transdate,''%m%d'')=',potable,' AND cs.cancelreason IN (''RETURN TO SENDER'') 
				)
				)x
			');
		END IF ;
	END IF;	
END IF;
PREPARE Stmt FROM @SQLStmt;
EXECUTE Stmt;
DEALLOCATE PREPARE Stmt;
END$$

DELIMITER ;