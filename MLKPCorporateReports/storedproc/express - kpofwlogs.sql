

USE `kpOFWLogs`;

/* Function  structure for function  `GetAgentName` */

DROP FUNCTION IF EXISTS `GetAgentName` ;
DELIMITER $$

CREATE  FUNCTION `GetAgentName`( operatorid VARCHAR(60) ) RETURNS VARCHAR(1) CHARSET latin1
    DETERMINISTIC
BEGIN
IF operatorid="QUIJ7030695" THEN
	RETURN 0;
ELSE
	RETURN(
		SELECT 1 FROM (SELECT 1 FROM `kpOFW`.`OFWaccounts` WHERE username=operatorid
		UNION SELECT 1 FROM `kpOFW`.`SubOFWaccounts` WHERE username=operatorid )X LIMIT 1
	);
END IF;
END $$
DELIMITER ;

/* Procedure structure for procedure `MLExpress` */

DROP PROCEDURE IF EXISTS  `MLExpress` ;

DELIMITER $$

CREATE  PROCEDURE `MLExpress`(IN _db VARCHAR(15),IN _month VARCHAR(5),IN _date VARCHAR(4),IN _year VARCHAR(4),IN _branchcode VARCHAR(3),IN _zonecode VARCHAR(1),IN _type VARCHAR(15), IN _per VARCHAR(15))
BEGIN
    IF _type='SENDOUT' THEN
	IF _per='DAILY' THEN
		SET @SQLStmt = CONCAT('
		SELECT 
		s.controlno AS oldcontrolno,
		IF(s1.controlno IS NULL,s.controlno,s1.controlno) AS controlno,s.oldkptnno AS soOldkptn,
		IF(s1.kptnno IS NULL,s.kptnno,s1.kptnno) AS kptnno,s1.oldkptnno,
		IF(s1.cancelleddate IS NULL,s.transdate,c.cancelleddate) AS cancelleddate,
		IF(c.canceldetails=''Request For Change'',DATE_FORMAT(c.cancelleddate,''%r''),DATE_FORMAT(s.transdate,''%r'')) AS cancelledtime,
		s.transdate AS sodate,DATE_FORMAT(s.transdate,''%r'') AS sotime,c.canceldetails,
		s.receivername AS oldreceivername,IF(s1.receivername IS NULL,s.receivername,s1.receivername) AS receivername,
		s.sendername AS oldsendername,IF(s1.sendername IS NULL,s.sendername,s1.sendername) AS sendername,c.cancelreason,
		s.principal,s.charge,c.chargeto,s.othercharge,s.OperatorID,
		s.CancelledByBranchCode,s.CancelledByOperatorID,s.CancelledByZoneCode,s.RemoteBranch,s.RemoteZoneCode,s.branchcode,s.zonecode,
		s.ReceiverContactNo,s.SenderContactNo,s.custId,	s.TableOriginated
		FROM ',_db,'.`sendout` s
		LEFT JOIN ',_db,'.socancel c ON c.transdate=s.transdate
		LEFT JOIN ',_db,'.sendout s1 ON s1.oldkptnno=c.kptnno 
		WHERE if((SELECT `GetAgentName`(s.OperatorID))=''1'',0,1) and
		s.kptnno LIKE ''%mlx%'' AND YEAR(s.transdate)=',_year,' AND DATE_FORMAT(s.transdate,''%d'')=',_date,' AND s.oldkptnno IS NULL 
		AND (c.canceldetails NOT IN (''Cancel Sendout'') OR c.canceldetails IS NULL)
		AND IF(s.isremote=1,s.remotebranch,s.branchcode)=',_branchcode,' AND IF(s.isremote=1,s.remotezonecode,s.zonecode)=',_zonecode,' 
		ORDER BY s.transdate ASC');
	ELSE
		SET @SQLStmt = CONCAT('
		SELECT 
		oldcontrolno,controlno,soOldkptn,kptnno,oldkptnno,cancelleddate,cancelledtime,sodate,sotime,canceldetails,
		oldreceivername,receivername,oldsendername,sendername,cancelreason,
		COUNT(kptnno) AS transcount,
		SUM(principal) AS principal,
		SUM(charge) AS charge,
		chargeto,
		sum(othercharge) as cancelledcustcharge,
		OperatorID,CancelledByBranchCode,CancelledByOperatorID,CancelledByZoneCode,
		RemoteBranch,RemoteZoneCode,branchcode,zonecode,ReceiverContactNo,SenderContactNo,custId,TableOriginated,a,b
		FROM(
		SELECT 
			s.controlno AS oldcontrolno,
			IF(s1.controlno IS NULL,s.controlno,s1.controlno) AS controlno,s.oldkptnno AS soOldkptn,
			IF(s1.kptnno IS NULL,s.kptnno,s1.kptnno) AS kptnno,s1.oldkptnno,
			IF(s1.cancelleddate IS NULL,s.transdate,c.cancelleddate) AS cancelleddate,
			IF(c.canceldetails=''Request For Change'',DATE_FORMAT(c.cancelleddate,''%r''),DATE_FORMAT(s.transdate,''%r'')) AS cancelledtime,
			s.transdate AS sodate,DATE_FORMAT(s.transdate,''%r'') AS sotime,c.canceldetails,
			s.receivername AS oldreceivername,IF(s1.receivername IS NULL,s.receivername,s1.receivername) AS receivername,
			s.sendername AS oldsendername,IF(s1.sendername IS NULL,s.sendername,s1.sendername) AS sendername,c.cancelreason,
			s.principal,s.charge,c.chargeto,s.othercharge,s.OperatorID,
			s.CancelledByBranchCode,s.CancelledByOperatorID,s.CancelledByZoneCode,s.RemoteBranch,s.RemoteZoneCode,s.branchcode,s.zonecode,
			s.ReceiverContactNo,s.SenderContactNo,s.custId,	s.TableOriginated,
		(
		SELECT controlno AS a FROM ',_db,'.`sendout` s
		WHERE   if((SELECT `GetAgentName`(s.OperatorID))=''1'',0,1) and
			IF(IsRemote=1,Remotebranch,branchcode)=',_branchcode,' AND 
			IF(isremote=1,remotezonecode,zonecode)=',_zonecode,' 
			AND DATE_FORMAT(s.transdate,''%d'')=',_date,'
			ORDER BY controlno ASC LIMIT 1
		) AS a,
		(
		SELECT controlno AS a FROM ',_db,'.`sendout` s
		WHERE   if((SELECT `GetAgentName`(s.OperatorID))=''1'',0,1) and
			IF(IsRemote=1,Remotebranch,branchcode)=',_branchcode,' AND 
			IF(isremote=1,remotezonecode,zonecode)=',_zonecode,' 
			AND DATE_FORMAT(s.transdate,''%d'')=',_date,'
			ORDER BY controlno DESC LIMIT 1
		) AS b
			FROM ',_db,'.`sendout` s
			LEFT JOIN ',_db,'.socancel c ON c.transdate=s.transdate
			LEFT JOIN ',_db,'.sendout s1 ON s1.oldkptnno=c.kptnno 
			WHERE if((SELECT `GetAgentName`(s.OperatorID))=''1'',0,1) and
			s.kptnno LIKE ''%mlx%'' AND YEAR(s.transdate)=',_year,' AND DATE_FORMAT(s.transdate,''%d'')=',_date,' AND s.oldkptnno IS NULL 
			AND (c.canceldetails NOT IN (''Cancel Sendout'') OR c.canceldetails IS NULL)
			AND IF(s.isremote=1,s.remotebranch,s.branchcode)=',_branchcode,' AND IF(s.isremote=1,s.remotezonecode,s.zonecode)=',_zonecode,' 
			ORDER BY s.transdate ASC
		)X GROUP BY DATE(sodate) ORDER BY sodate ASC
		');
	END IF;
   ELSEIF _type='RFCsendoutSub' THEN
	IF _per='DAILY' THEN
		SET @SQLStmt = CONCAT('
		SELECT 
		s.controlno AS oldcontrolno,
		IF(s1.controlno IS NULL,s.controlno,s1.controlno) AS controlno,s.oldkptnno AS soOldkptn,
		IF(s1.kptnno IS NULL,s.kptnno,s1.kptnno) AS kptnno,s1.oldkptnno,
		IF(s1.cancelleddate IS NULL,s.transdate,c.cancelleddate) AS cancelleddate,
		IF(c.canceldetails=''Request For Change'',DATE_FORMAT(c.cancelleddate,''%r''),DATE_FORMAT(s.transdate,''%r'')) AS cancelledtime,
		s.transdate AS sodate,DATE_FORMAT(s.transdate,''%r'') AS sotime,c.canceldetails,
		s.receivername AS oldreceivername,IF(s1.receivername IS NULL,s.receivername,s1.receivername) AS receivername,
		s.sendername AS oldsendername,IF(s1.sendername IS NULL,s.sendername,s1.sendername) AS sendername,c.cancelreason,
		s.principal,s.charge,c.chargeto,s.othercharge,s.OperatorID,
		s.CancelledByBranchCode,s.CancelledByOperatorID,s.CancelledByZoneCode,s.RemoteBranch,s.RemoteZoneCode,s.branchcode,s.zonecode,
		s.ReceiverContactNo,s.SenderContactNo,s.custId,	s.TableOriginated
		FROM ',_db,'.`sendout` s
		LEFT JOIN ',_db,'.socancel c ON c.transdate=s.transdate
		LEFT JOIN ',_db,'.sendout s1 ON s1.oldkptnno=c.kptnno 
		WHERE if((SELECT `GetAgentName`(s.OperatorID))=''1'',0,1) and
		s.kptnno LIKE ''%mlx%'' AND YEAR(s.transdate)=',_year,' AND DATE_FORMAT(s.transdate,''%d'')=',_date,' AND s.oldkptnno IS NULL 
		AND (c.canceldetails NOT IN (''Cancel Sendout'') OR c.canceldetails IS NULL) and s1.OLDKPTNNo is not null
		AND IF(s.isremote=1,s.remotebranch,s.branchcode)=',_branchcode,' AND IF(s.isremote=1,s.remotezonecode,s.zonecode)=',_zonecode,' 
		ORDER BY s.transdate ASC');
	END IF;
   ELSEIF _type='RFC' THEN
	IF _per='DAILY' THEN
		SET @SQLStmt = CONCAT('
		SELECT 
		s.controlno AS oldcontrolno,
		IF(s1.controlno IS NULL,s.controlno,s1.controlno) AS controlno,s.oldkptnno AS soOldkptn,
		IF(s1.kptnno IS NULL,s.kptnno,s1.kptnno) AS kptnno,s1.oldkptnno,c.cancelleddate,
		IF(c.canceldetails=''Request For Change'',DATE_FORMAT(c.cancelleddate,''%r''),DATE_FORMAT(s.transdate,''%r'')) AS cancelledtime,
		s.transdate AS sodate,DATE_FORMAT(s.transdate,''%r'') AS sotime,c.canceldetails,
		s.receivername AS oldreceivername,s1.receivername,
		s.sendername AS oldsendername,s1.sendername,c.cancelreason,
		s.principal,s.charge,c.chargeto,s.othercharge,s.OperatorID,
		s.CancelledByBranchCode,s.CancelledByOperatorID,s.CancelledByZoneCode,s.RemoteBranch,s.RemoteZoneCode,s.branchcode,s.zonecode,
		s.ReceiverContactNo,s.SenderContactNo,s.custId,	s.TableOriginated
		FROM ',_db,'.sendout s
		INNER JOIN ',_db,'.socancel c ON c.kptnno=s.kptnno
		INNER JOIN ',_db,'.sendout s1 ON s1.oldkptnno=c.kptnno
		WHERE if((SELECT `GetAgentName`(s.OperatorID))=''1'',0,1) and YEAR(c.cancelleddate)=',_year,' AND c.canceldetails NOT IN (''Cancel Sendout'')
		AND DATE_FORMAT(c.cancelleddate,''%d'')=',_date,' 
		AND IF(s.isremote=1,s.remotebranch,s.branchcode)=',_branchcode,' AND IF(s.isremote=1,s.remotezonecode,s.zonecode)=',_zonecode,'
		ORDER BY s.transdate ASC');
	ELSE
		SET @SQLStmt = CONCAT('
		SELECT
		oldcontrolno,controlno,soOldkptn,kptnno,oldkptnno,cancelleddate,cancelledtime,COUNT(kptnno) AS transcount,
		sodate,sotime,canceldetails,oldreceivername,receivername,oldsendername,sendername,cancelreason,
		sum(principal) as principal,sum(charge) as charge,chargeto,sum(othercharge) as cancelledcustcharge,OperatorID,
		CancelledByBranchCode,CancelledByOperatorID,
		CancelledByZoneCode,RemoteBranch,RemoteZoneCode,branchcode,zonecode,
		ReceiverContactNo,SenderContactNo,custId,TableOriginated,a,b
		FROM
		(SELECT 
		s.controlno AS oldcontrolno,
		IF(s1.controlno IS NULL,s.controlno,s1.controlno) AS controlno,s.oldkptnno AS soOldkptn,
		IF(s1.kptnno IS NULL,s.kptnno,s1.kptnno) AS kptnno,s1.oldkptnno,c.cancelleddate,
		IF(c.canceldetails=''Request FOR CHANGE'',DATE_FORMAT(c.cancelleddate,''%r''),DATE_FORMAT(s.transdate,''%r'')) AS cancelledtime,
		s.transdate AS sodate,DATE_FORMAT(s.transdate,''%r'') AS sotime,c.canceldetails,
		s.receivername AS oldreceivername,s1.receivername,
		s.sendername AS oldsendername,s1.sendername,c.cancelreason,
		s.principal,s.charge,c.chargeto,s.othercharge,s.OperatorID,
		s.CancelledByBranchCode,s.CancelledByOperatorID,s.CancelledByZoneCode,s.RemoteBranch,s.RemoteZoneCode,s.branchcode,s.zonecode,
		s.ReceiverContactNo,s.SenderContactNo,s.custId,	s.TableOriginated,
		(
		SELECT 	IF(s1.controlno IS NULL,s.controlno,s1.controlno) AS a 
		FROM ',_db,'.sendout s
		INNER JOIN ',_db,'.socancel c ON c.kptnno=s.kptnno
		INNER JOIN ',_db,'.sendout s1 ON s1.oldkptnno=c.kptnno
		WHERE if((SELECT `GetAgentName`(s.OperatorID))=''1'',0,1) and
			YEAR(c.cancelleddate)=',_year,' AND c.canceldetails NOT IN (''Cancel Sendout'')
			AND DATE_FORMAT(c.cancelleddate,''%d'')=',_date,' 
			AND IF(s.isremote=1,s.remotebranch,s.branchcode)=',_branchcode,' AND IF(s.isremote=1,s.remotezonecode,s.zonecode)=',_zonecode,'
			ORDER BY IF(s1.controlno IS NULL,s.controlno,s1.controlno) ASC LIMIT 1
		) AS a,
		(
		SELECT 	IF(s1.controlno IS NULL,s.controlno,s1.controlno) AS a 
		FROM ',_db,'.sendout s
		INNER JOIN ',_db,'.socancel c ON c.kptnno=s.kptnno
		INNER JOIN ',_db,'.sendout s1 ON s1.oldkptnno=c.kptnno
		WHERE if((SELECT `GetAgentName`(s.OperatorID))=''1'',0,1) and
			YEAR(c.cancelleddate)=',_year,' AND c.canceldetails NOT IN (''Cancel Sendout'')
			AND DATE_FORMAT(c.cancelleddate,''%d'')=',_date,' 
			AND IF(s.isremote=1,s.remotebranch,s.branchcode)=',_branchcode,' AND IF(s.isremote=1,s.remotezonecode,s.zonecode)=',_zonecode,'
			ORDER BY IF(s1.controlno IS NULL,s.controlno,s1.controlno) DESC LIMIT 1
		) AS b
		FROM ',_db,'.sendout s
		INNER JOIN ',_db,'.socancel c ON c.kptnno=s.kptnno
		INNER JOIN ',_db,'.sendout s1 ON s1.oldkptnno=c.kptnno
		WHERE if((SELECT `GetAgentName`(s.OperatorID))=''1'',0,1) and YEAR(c.cancelleddate)=',_year,' AND c.canceldetails NOT IN (''Cancel Sendout'')
		AND DATE_FORMAT(c.cancelleddate,''%d'')=',_date,' 
		AND IF(s.isremote=1,s.remotebranch,s.branchcode)=',_branchcode,' AND IF(s.isremote=1,s.remotezonecode,s.zonecode)=',_zonecode,'
		ORDER BY s.transdate ASC)
		X GROUP BY DATE(cancelleddate) ORDER BY cancelleddate ASC
		');		
	END IF;
   ELSEIF _type='CS' THEN
	IF _per='DAILY' THEN
		SET @SQLStmt = CONCAT('
		SELECT 
		controlno,kptnno,oldkptnno,cancelleddate,
		DATE_FORMAT(cancelleddate,''%r'') AS cancelledtime,
		transdate AS sodate,DATE_FORMAT(transdate,''%r'') AS sotime,canceldetails,
		receivername,sendername,cancelreason,
		principal,charge,chargeto,othercharge,OperatorID,
		CancelledByBranchCode,CancelledByOperatorID,CancelledByZoneCode,RemoteBranch,RemoteZoneCode,branchcode,zonecode,
		ReceiverContactNo,SenderContactNo,custId,TableOriginated
		FROM ',_db,'.socancel 
		WHERE if((SELECT `GetAgentName`(OperatorID))=''1'',0,1) and YEAR(cancelleddate)=',_year,' AND canceldetails IN (''Cancel Sendout'')
		AND DATE_FORMAT(cancelleddate,''%d'')=',_date,' 
		AND IF(isremote=1,remotebranch,branchcode)=',_branchcode,' AND IF(isremote=1,remotezonecode,zonecode)=',_zonecode,'
		ORDER BY cancelleddate ASC');
	ELSE
		SET @SQLStmt = CONCAT('
		SELECT
		controlno,kptnno,COUNT(kptnno) AS transcount,oldkptnno,cancelleddate,cancelledtime,
		sodate,sotime,canceldetails,receivername,sendername,cancelreason,
		SUM(principal) AS principal,SUM(charge) AS charge,chargeto,SUM(othercharge) AS cancelledcustcharge,OperatorID,
		CancelledByBranchCode,CancelledByOperatorID,CancelledByZoneCode,RemoteBranch,RemoteZoneCode,branchcode,zonecode,
		ReceiverContactNo,SenderContactNo,custId,TableOriginated,a,b
		FROM
		(SELECT 
		controlno,kptnno,oldkptnno,cancelleddate,
		DATE_FORMAT(cancelleddate,''%r'') AS cancelledtime,
		transdate AS sodate,DATE_FORMAT(transdate,''%r'') AS sotime,canceldetails,
		receivername,sendername,cancelreason,
		principal,charge,chargeto,othercharge,OperatorID,
		CancelledByBranchCode,CancelledByOperatorID,CancelledByZoneCode,RemoteBranch,RemoteZoneCode,branchcode,zonecode,
		ReceiverContactNo,SenderContactNo,custId,TableOriginated,
		(
		SELECT controlno AS a FROM ',_db,'.`socancel` s
		WHERE if((SELECT `GetAgentName`(s.OperatorID))=''1'',0,1) and
			YEAR(cancelleddate)=',_year,' AND canceldetails IN (''Cancel Sendout'')
			AND DATE_FORMAT(cancelleddate,''%d'')=',_date,' 
			AND IF(isremote=1,remotebranch,branchcode)=',_branchcode,' AND IF(isremote=1,remotezonecode,zonecode)=',_zonecode,'
			ORDER BY controlno ASC LIMIT 1
		) AS a,
		(
		SELECT controlno AS a FROM ',_db,'.`socancel` s
		WHERE if((SELECT `GetAgentName`(s.OperatorID))=''1'',0,1) and
			YEAR(cancelleddate)=',_year,' AND canceldetails IN (''Cancel Sendout'')
			AND DATE_FORMAT(cancelleddate,''%d'')=',_date,' 
			AND IF(isremote=1,remotebranch,branchcode)=',_branchcode,' AND IF(isremote=1,remotezonecode,zonecode)=',_zonecode,'
			ORDER BY controlno DESC LIMIT 1
		) AS b
		FROM ',_db,'.socancel 
		WHERE if((SELECT `GetAgentName`(OperatorID))=''1'',0,1) and YEAR(cancelleddate)=',_year,' AND canceldetails IN (''Cancel Sendout'')
		AND DATE_FORMAT(cancelleddate,''%d'')=',_date,' 
		AND IF(isremote=1,remotebranch,branchcode)=',_branchcode,' AND IF(isremote=1,remotezonecode,zonecode)=',_zonecode,'
		ORDER BY cancelleddate ASC)
		X GROUP BY DATE(cancelleddate) ORDER BY cancelleddate ASC
		');
	END IF;
   ELSEIF _type='PAYOUT' THEN
        IF _per='DAILY' THEN
	       SET @SQLStmt = CONCAT('
	        SELECT 
		controlno,kptnno,claimeddate,claimedtime,cancelleddate,principal,charge,cancelledempcharge,cancelledcustcharge,sodate,
		OperatorID,SenderName,receivername,
		branchcode,zonecode,oldkptnno,NewKPTNNo,CancelledReason,CancelledType,Reason,			
		CancelledByBranchCode,CancelledByOperatorID,RemoteBranch,RemoteZoneCode,SOBranch,SOControlNo,SOOperator,ReceiverContactNo,
		SenderContactNo,custId,isremote,TableOriginated,
		IF(cancelleddate IS NULL OR cancelleddate LIKE ''0000-00-00 00:00:00'',''not'',''cancel'') AS flag FROM (
		SELECT 
		s.controlno,s.kptnno,	
		s.claimeddate,DATE_FORMAT(s.claimeddate,''%r'') AS claimedtime,
		(SELECT p.cancelleddate FROM ',_db,'.`pocancel` p WHERE p.kptnno=s.kptnno LIMIT 1) AS cancelleddate,
		s.principal,
		IF(s.ServiceCharge IS NULL,0,s.ServiceCharge) AS charge,
		IF(s.cancelledempcharge IS NULL,0,s.cancelledempcharge) AS cancelledempcharge,
		IF(s.cancelledcustcharge IS NULL,0,s.cancelledcustcharge) AS cancelledcustcharge,
		if(length(s.kptnno)=21,(DATE_FORMAT(CONCAT(SUBSTRING(s.kptnno,20,2),SUBSTRING(s.kptnno,18,2),SUBSTRING(s.kptnno,7,2)),''%m/%d/%Y'')),
		if(LENGTH(s.kptnno)=20,(DATE_FORMAT(CONCAT(SUBSTRING(s.kptnno,19,2),SUBSTRING(s.kptnno,17,2),SUBSTRING(s.kptnno,7,2)),''%m/%d/%Y'')),
		DATE_FORMAT(CONCAT(SUBSTRING(s.kptnno,17,6),SUBSTRING(s.kptnno,4,2)),''%m/%d/%Y'')))  AS sodate,
		s.OperatorID,
		if(SenderName is null, CONCAT(s.SenderlName, '', '' ,s.SenderfName, '' '', s.SendermName),s.SenderName) as sendername,
		if(receivername is null, CONCAT(s.receiverlname, '', '' ,s.receiverfname, '' '', s.receivermname),s.receivername) as receivername,
		s.branchcode,s.zonecode,s.oldkptnno,s.NewKPTNNo,s.CancelledReason,s.CancelledType,s.Reason,			
		s.CancelledByBranchCode,s.CancelledByOperatorID,s.RemoteBranch,s.RemoteZoneCode,
		s.SOBranch,s.SOControlNo,s.SOOperator,s.ReceiverContactNo,s.SenderContactNo,s.custId,s.isremote,s.TableOriginated
		FROM ',_db,'.`payout` s
		WHERE if((SELECT `GetAgentName`(s.OperatorID))=''1'',0,1) and
		s.kptnno LIKE ''%mlx%'' AND YEAR(s.claimeddate)=',_year,' AND DATE_FORMAT(s.claimeddate,''%d'')=',_date,' 
		and if(IF(s.isremote=1,s.remotebranch,s.branchcode)=001 or IF(s.isremote=1,s.remotebranch,s.branchcode)=002,s.branchcode,
		IF(s.isremote=1,s.remotebranch,s.branchcode))=',_branchcode,'
		and if( IF(s.isremote=1,s.remotebranch,s.branchcode)=001 or IF(s.isremote=1,s.remotebranch,s.branchcode)=002,s.zonecode,
		IF(s.isremote=1,s.remotezonecode,s.zonecode))=',_zonecode,' 
		)X GROUP BY kptnno		
		ORDER BY claimeddate ASC;
		');
	ELSE
	        SET @SQLStmt = CONCAT('
		SELECT 
		controlno,kptnno,claimeddate,claimedtime,cancelleddate,
		COUNT(kptnno) AS transcount,
		SUM(principal) AS principal,
		SUM(charge) AS charge,
		SUM(cancelledempcharge) AS cancelledempcharge,
		SUM(cancelledcustcharge) AS cancelledcustcharge,
		sodate,OperatorID,SenderName,receivername,
		branchcode,zonecode,oldkptnno,NewKPTNNo,CancelledReason,CancelledType,Reason,			
		CancelledByBranchCode,CancelledByOperatorID,RemoteBranch,RemoteZoneCode,SOBranch,SOControlNo,SOOperator,ReceiverContactNo,
		SenderContactNo,custId,isremote,TableOriginated,a,b,
		IF(cancelleddate IS NULL OR cancelleddate LIKE ''0000-00-00 00:00:00'',''not'',''cancel'') AS flag FROM 
		(SELECT 
			s.controlno,s.kptnno,		
			s.claimeddate,DATE_FORMAT(s.claimeddate,''%r'') AS claimedtime,
			(SELECT p.cancelleddate FROM ',_db,'.`pocancel` p WHERE p.kptnno=s.kptnno LIMIT 1) AS cancelleddate,
			s.principal,
			IF(s.ServiceCharge IS NULL,0,s.ServiceCharge) AS charge,
			IF(s.cancelledempcharge IS NULL,0,s.cancelledempcharge) AS cancelledempcharge,
			IF(s.cancelledcustcharge IS NULL,0,s.cancelledcustcharge) AS cancelledcustcharge,
			if(length(s.kptnno)=21,(DATE_FORMAT(CONCAT(SUBSTRING(s.kptnno,20,2),SUBSTRING(s.kptnno,18,2),SUBSTRING(s.kptnno,7,2)),''%m/%d/%Y'')),
			if(LENGTH(s.kptnno)=20,(DATE_FORMAT(CONCAT(SUBSTRING(s.kptnno,19,2),SUBSTRING(s.kptnno,17,2),SUBSTRING(s.kptnno,7,2)),''%m/%d/%Y'')),
			DATE_FORMAT(CONCAT(SUBSTRING(s.kptnno,17,6),SUBSTRING(s.kptnno,4,2)),''%m/%d/%Y'')))  AS sodate,
			s.OperatorID,
			if(SenderName is null, CONCAT(s.SenderlName, '', '' ,s.SenderfName, '' '', s.SendermName),s.SenderName) as sendername,
			if(receivername is null, CONCAT(s.receiverlname, '', '' ,s.receiverfname, '' '', s.receivermname),s.receivername) as receivername,
			s.branchcode,s.zonecode,s.oldkptnno,s.NewKPTNNo,s.CancelledReason,s.CancelledType,s.Reason,			
			s.CancelledByBranchCode,s.CancelledByOperatorID,s.RemoteBranch,s.RemoteZoneCode,
			s.SOBranch,s.SOControlNo,s.SOOperator,s.ReceiverContactNo,s.SenderContactNo,s.custId,s.isremote,s.TableOriginated,
		(
		SELECT controlno AS a FROM ',_db,'.`payout` s
		WHERE if((SELECT `GetAgentName`(s.OperatorID))=''1'',0,1) 
			AND IF(IF(isremote=1,remotebranch,branchcode)=001 OR IF(isremote=1,remotebranch,branchcode)=002,branchcode,
			IF(isremote=1,remotebranch,branchcode))=',_branchcode,'
			AND IF( IF(isremote=1,remotebranch,branchcode)=001 OR IF(isremote=1,remotebranch,branchcode)=002,zonecode,
			IF(isremote=1,remotezonecode,zonecode))=',_zonecode,'  
			AND DATE_FORMAT(s.claimeddate,''%d'')=',_date,'
			ORDER BY controlno ASC LIMIT 1
		) AS a,
		(
		SELECT controlno AS a FROM ',_db,'.`payout` s
		WHERE if((SELECT `GetAgentName`(s.OperatorID))=''1'',0,1)
			AND IF(IF(isremote=1,remotebranch,branchcode)=001 OR IF(isremote=1,remotebranch,branchcode)=002,branchcode,
			IF(isremote=1,remotebranch,branchcode))=',_branchcode,'
			AND IF( IF(isremote=1,remotebranch,branchcode)=001 OR IF(isremote=1,remotebranch,branchcode)=002,zonecode,
			IF(isremote=1,remotezonecode,zonecode))=',_zonecode,'  

			AND DATE_FORMAT(s.claimeddate,''%d'')=',_date,'
			ORDER BY controlno DESC LIMIT 1
		) AS b
			FROM ',_db,'.`payout` s
			WHERE if((SELECT `GetAgentName`(s.OperatorID))=''1'',0,1) and
			s.kptnno LIKE ''%mlx%'' AND YEAR(s.claimeddate)=',_year,' AND DATE_FORMAT(s.claimeddate,''%d'')=',_date,' 
			AND IF(IF(isremote=1,remotebranch,branchcode)=001 OR IF(isremote=1,remotebranch,branchcode)=002,branchcode,
			IF(isremote=1,remotebranch,branchcode))=',_branchcode,'
			AND IF( IF(isremote=1,remotebranch,branchcode)=001 OR IF(isremote=1,remotebranch,branchcode)=002,zonecode,
			IF(isremote=1,remotezonecode,zonecode))=',_zonecode,' GROUP BY s.kptnno		
			ORDER BY s.claimeddate ASC
		)X GROUP BY DATE(claimeddate) ORDER BY claimeddate ASC
		');
	END IF;
   ELSEIF _type='CP' THEN
	IF _per='DAILY' THEN
		SET @SQLStmt = CONCAT('
		SELECT 
		controlno,kptnno,
		DATE_FORMAT(cancelleddate,''%r'') AS cancelledtime,
		cancelleddate,principal,
		IF(servicecharge IS NULL,0,servicecharge) AS charge,
		if(CancelledEmpCharge is null,0,CancelledEmpCharge) as CancelledEmpCharge,
		if(CancelledCustCharge is null,0,CancelledCustCharge) as CancelledCustCharge,
		if(length(kptnno)=21,(DATE_FORMAT(CONCAT(SUBSTRING(kptnno,20,2),SUBSTRING(kptnno,18,2),SUBSTRING(kptnno,7,2)),''%m/%d/%Y'')),
		if(LENGTH(kptnno)=20,(DATE_FORMAT(CONCAT(SUBSTRING(kptnno,19,2),SUBSTRING(kptnno,17,2),SUBSTRING(kptnno,7,2)),''%m/%d/%Y'')),
		DATE_FORMAT(CONCAT(SUBSTRING(kptnno,17,6),SUBSTRING(kptnno,4,2)),''%m/%d/%Y'')))  AS sodate,
		OperatorID,
		IF(sendername IS NULL, CONCAT(senderlname, '', '' ,senderfname, '' '', sendermname),sendername) AS sendername,
		IF(receivername IS NULL, CONCAT(receiverlname, '', '' ,receiverfname, '' '', receivermname),receivername) AS receivername,
		branchcode,zonecode,oldkptnno,cancelledreason,CancelledType,reason,
		CancelledByBranchCode,CancelledByOperatorID,RemoteBranch,RemoteZoneCode,
		ReceiverContactNo,SenderContactNo,custId,isremote,TableOriginated,
		(IF ((claimeddate = ''0000-00-00 00:00:00''),(SELECT claimeddate FROM  ',_db,'.payout WHERE kptnno=p.kptnno limit 1),claimeddate)) AS podate
		FROM ',_db,'.pocancel  p
		WHERE if((SELECT `GetAgentName`(OperatorID))=''1'',0,1) and YEAR(cancelleddate)=',_year,' 
		AND DATE_FORMAT(cancelleddate,''%d'')=',_date,' 
		AND IF(IF(isremote=1,remotebranch,branchcode)=001 OR IF(isremote=1,remotebranch,branchcode)=002,branchcode,
		IF(isremote=1,remotebranch,branchcode))=',_branchcode,'
		AND IF( IF(isremote=1,remotebranch,branchcode)=001 OR IF(isremote=1,remotebranch,branchcode)=002,zonecode,
		IF(isremote=1,remotezonecode,zonecode))=',_zonecode,' 
		group by kptnno ORDER BY cancelleddate ASC');
	ELSE
		SET @SQLStmt = CONCAT('
		SELECT 
		controlno,kptnno,cancelledtime,cancelleddate,
		COUNT(kptnno) AS transcount,
		SUM(principal) AS principal,
		SUM(charge) AS charge,
		SUM(cancelledempcharge) AS cancelledempcharge,
		SUM(cancelledcustcharge) AS cancelledcustcharge,
		sodate,OperatorID,SenderName,receivername,
		branchcode,zonecode,oldkptnno,CancelledReason,CancelledType,Reason,			
		CancelledByBranchCode,CancelledByOperatorID,RemoteBranch,RemoteZoneCode,
		ReceiverContactNo,SenderContactNo,custId,isremote,TableOriginated,podate,a,b from
		(SELECT 
		controlno,kptnno,
		DATE_FORMAT(cancelleddate,''%r'') AS cancelledtime,
		cancelleddate,principal,
		IF(servicecharge IS NULL,0,servicecharge) AS charge,
		IF(CancelledEmpCharge IS NULL,0,CancelledEmpCharge) as CancelledEmpCharge,
		IF(CancelledCustCharge IS NULL,0,CancelledCustCharge) as CancelledCustCharge,
		if(length(kptnno)=21,(DATE_FORMAT(CONCAT(SUBSTRING(kptnno,20,2),SUBSTRING(kptnno,18,2),SUBSTRING(kptnno,7,2)),''%m/%d/%Y'')),
		if(LENGTH(kptnno)=20,(DATE_FORMAT(CONCAT(SUBSTRING(kptnno,19,2),SUBSTRING(kptnno,17,2),SUBSTRING(kptnno,7,2)),''%m/%d/%Y'')),
		DATE_FORMAT(CONCAT(SUBSTRING(kptnno,17,6),SUBSTRING(kptnno,4,2)),''%m/%d/%Y'')))  AS sodate,
		OperatorID,
		IF(sendername IS NULL, CONCAT(senderlname, '', '' ,senderfname, '' '', sendermname),sendername) AS sendername,
		IF(receivername IS NULL, CONCAT(receiverlname, '', '' ,receiverfname, '' '', receivermname),receivername) AS receivername,
		branchcode,zonecode,oldkptnno,cancelledreason,CancelledType,reason,
		CancelledByBranchCode,CancelledByOperatorID,RemoteBranch,RemoteZoneCode,
		ReceiverContactNo,SenderContactNo,custId,isremote,TableOriginated,
		(IF ((claimeddate = ''0000-00-00 00:00:00''),(SELECT claimeddate FROM  ',_db,'.payout WHERE kptnno=p.kptnno LIMIT 1),claimeddate)) AS podate,
		(SELECT controlno AS a FROM ',_db,'.pocancel  pc
		WHERE if((SELECT `GetAgentName`(pc.OperatorID))=''1'',0,1) 
			AND IF(IF(isremote=1,remotebranch,branchcode)=001 OR IF(isremote=1,remotebranch,branchcode)=002,branchcode,
			IF(isremote=1,remotebranch,branchcode))=',_branchcode,'
			AND IF( IF(isremote=1,remotebranch,branchcode)=001 OR IF(isremote=1,remotebranch,branchcode)=002,zonecode,
			IF(isremote=1,remotezonecode,zonecode))=',_zonecode,' 
			AND DATE_FORMAT(pc.cancelleddate,''%d'')=',_date,'
			ORDER BY controlno ASC LIMIT 1
		) AS a,
		(SELECT controlno AS a FROM ',_db,'.pocancel  pc
		WHERE if((SELECT `GetAgentName`(pc.OperatorID))=''1'',0,1) 
			AND IF(IF(isremote=1,remotebranch,branchcode)=001 OR IF(isremote=1,remotebranch,branchcode)=002,branchcode,
			IF(isremote=1,remotebranch,branchcode))=',_branchcode,'
			AND IF( IF(isremote=1,remotebranch,branchcode)=001 OR IF(isremote=1,remotebranch,branchcode)=002,zonecode,
			IF(isremote=1,remotezonecode,zonecode))=',_zonecode,' 
			AND DATE_FORMAT(pc.cancelleddate,''%d'')=',_date,'
			ORDER BY controlno DESC LIMIT 1
		) AS b
		FROM ',_db,'.pocancel  p
		WHERE if((SELECT `GetAgentName`(p.OperatorID))=''1'',0,1) and YEAR(cancelleddate)=',_year,' 
		AND DATE_FORMAT(cancelleddate,''%d'')=',_date,' 
		AND IF(IF(isremote=1,remotebranch,branchcode)=001 OR IF(isremote=1,remotebranch,branchcode)=002,branchcode,
		IF(isremote=1,remotebranch,branchcode))=',_branchcode,'
		AND IF( IF(isremote=1,remotebranch,branchcode)=001 OR IF(isremote=1,remotebranch,branchcode)=002,zonecode,
		IF(isremote=1,remotezonecode,zonecode))=',_zonecode,' GROUP BY kptnno ORDER BY cancelleddate ASC
		)X GROUP BY DATE(cancelleddate) ORDER BY cancelleddate ASC
		');
	END IF;
   END IF;
PREPARE Stmt FROM @SQLStmt;
EXECUTE Stmt;
DEALLOCATE PREPARE Stmt;
END $$
DELIMITER ;

/* Procedure structure for procedure `MLExpressEmp` */

DROP PROCEDURE IF EXISTS  `MLExpressEmp` ;

DELIMITER $$

CREATE  PROCEDURE `MLExpressEmp`(IN _db VARCHAR(15),IN _month VARCHAR(5),IN _date VARCHAR(4),IN _year VARCHAR(4),IN _branchcode VARCHAR(3),IN _zonecode VARCHAR(1),IN _type VARCHAR(15), IN _per VARCHAR(15), IN _by VARCHAR(50))
BEGIN
    IF _type='PAYOUT' THEN
        IF _per='DAILY' THEN
	       SET @SQLStmt = CONCAT('
	        SELECT 
		controlno,kptnno,claimeddate,claimedtime,cancelleddate,principal,charge,cancelledempcharge,cancelledcustcharge,sodate,
		OperatorID,SenderName,receivername,
		branchcode,zonecode,oldkptnno,NewKPTNNo,CancelledReason,CancelledType,Reason,			
		CancelledByBranchCode,CancelledByOperatorID,RemoteBranch,RemoteZoneCode,SOBranch,SOControlNo,SOOperator,ReceiverContactNo,
		SenderContactNo,custId,isremote,TableOriginated,
		IF(cancelleddate IS NULL OR cancelleddate LIKE ''0000-00-00 00:00:00'',''not'',''cancel'') AS flag FROM (
		SELECT 
		s.controlno,s.kptnno,		
		s.claimeddate,DATE_FORMAT(s.claimeddate,''%r'') AS claimedtime,
		(SELECT p.cancelleddate FROM ',_db,'.`pocancel` p WHERE p.kptnno=s.kptnno LIMIT 1) AS cancelleddate,
		s.principal,
		IF(s.ServiceCharge IS NULL,0,s.ServiceCharge) AS charge,
		IF(s.cancelledempcharge IS NULL,0,s.cancelledempcharge) AS cancelledempcharge,
		IF(s.cancelledcustcharge IS NULL,0,s.cancelledcustcharge) AS cancelledcustcharge,
		if(length(s.kptnno)=21,(DATE_FORMAT(CONCAT(SUBSTRING(s.kptnno,20,2),SUBSTRING(s.kptnno,18,2),SUBSTRING(s.kptnno,7,2)),''%m/%d/%Y'')),
		if(LENGTH(s.kptnno)=20,(DATE_FORMAT(CONCAT(SUBSTRING(s.kptnno,19,2),SUBSTRING(s.kptnno,17,2),SUBSTRING(s.kptnno,7,2)),''%m/%d/%Y'')),
		DATE_FORMAT(CONCAT(SUBSTRING(s.kptnno,17,6),SUBSTRING(s.kptnno,4,2)),''%m/%d/%Y'')))  AS sodate,
		s.OperatorID,
		if(SenderName is null, CONCAT(s.SenderlName, '', '' ,s.SenderfName, '' '', s.SendermName),s.SenderName) as sendername,
		if(receivername is null, CONCAT(s.receiverlname, '', '' ,s.receiverfname, '' '', s.receivermname),s.receivername) as receivername,
		s.branchcode,s.zonecode,s.oldkptnno,s.NewKPTNNo,s.CancelledReason,s.CancelledType,s.Reason,			
		s.CancelledByBranchCode,s.CancelledByOperatorID,s.RemoteBranch,s.RemoteZoneCode,
		s.SOBranch,s.SOControlNo,s.SOOperator,s.ReceiverContactNo,s.SenderContactNo,s.custId,s.isremote,s.TableOriginated
		FROM ',_db,'.`payout` s
		WHERE if((SELECT `GetAgentName`(s.OperatorID))=''1'',0,1) and 
		s.kptnno LIKE ''%mlx%'' AND YEAR(s.claimeddate)=',_year,' AND DATE_FORMAT(s.claimeddate,''%d'')=',_date,' AND IF(s.isremote=1,s.remoteOperatorID,s.OperatorID)=''',_by,'''
		AND IF(IF(s.isremote=1,s.remotebranch,s.branchcode)=001 OR IF(s.isremote=1,s.remotebranch,s.branchcode)=002,s.branchcode,
		IF(s.isremote=1,s.remotebranch,s.branchcode))=',_branchcode,'
		AND IF( IF(s.isremote=1,s.remotebranch,s.branchcode)=001 OR IF(s.isremote=1,s.remotebranch,s.branchcode)=002,s.zonecode,
		IF(s.isremote=1,s.remotezonecode,s.zonecode))=',_zonecode,' 
		)X GROUP BY kptnno		
		ORDER BY claimeddate ASC;
		');
	ELSE
	        SET @SQLStmt = CONCAT('
		SELECT 
		controlno,kptnno,claimeddate,claimedtime,cancelleddate,
		COUNT(kptnno) AS transcount,
		SUM(principal) AS principal,
		SUM(charge) AS charge,
		SUM(cancelledempcharge) AS cancelledempcharge,
		SUM(cancelledcustcharge) AS cancelledcustcharge,
		sodate,OperatorID,SenderName,receivername,
		branchcode,zonecode,oldkptnno,NewKPTNNo,CancelledReason,CancelledType,Reason,			
		CancelledByBranchCode,CancelledByOperatorID,RemoteBranch,RemoteZoneCode,SOBranch,SOControlNo,SOOperator,ReceiverContactNo,
		SenderContactNo,custId,isremote,TableOriginated,a,b,
		IF(cancelleddate IS NULL OR cancelleddate LIKE ''0000-00-00 00:00:00'',''not'',''cancel'') AS flag FROM 
		(SELECT 
			s.controlno,s.kptnno,		
			s.claimeddate,DATE_FORMAT(s.claimeddate,''%r'') AS claimedtime,
			(SELECT p.cancelleddate FROM ',_db,'.`pocancel` p WHERE p.kptnno=s.kptnno LIMIT 1) AS cancelleddate,
			s.principal,
			IF(s.ServiceCharge IS NULL,0,s.ServiceCharge) AS charge,
			IF(s.cancelledempcharge IS NULL,0,s.cancelledempcharge) AS cancelledempcharge,
			IF(s.cancelledcustcharge IS NULL,0,s.cancelledcustcharge) AS cancelledcustcharge,
			if(length(s.kptnno)=21,(DATE_FORMAT(CONCAT(SUBSTRING(s.kptnno,20,2),SUBSTRING(s.kptnno,18,2),SUBSTRING(s.kptnno,7,2)),''%m/%d/%Y'')),
			if(LENGTH(s.kptnno)=20,(DATE_FORMAT(CONCAT(SUBSTRING(s.kptnno,19,2),SUBSTRING(s.kptnno,17,2),SUBSTRING(s.kptnno,7,2)),''%m/%d/%Y'')),
			DATE_FORMAT(CONCAT(SUBSTRING(s.kptnno,17,6),SUBSTRING(s.kptnno,4,2)),''%m/%d/%Y'')))  AS sodate,
			s.OperatorID,
			if(SenderName is null, CONCAT(s.SenderlName, '', '' ,s.SenderfName, '' '', s.SendermName),s.SenderName) as sendername,
			if(receivername is null, CONCAT(s.receiverlname, '', '' ,s.receiverfname, '' '', s.receivermname),s.receivername) as receivername,
			s.branchcode,s.zonecode,s.oldkptnno,s.NewKPTNNo,s.CancelledReason,s.CancelledType,s.Reason,			
			s.CancelledByBranchCode,s.CancelledByOperatorID,s.RemoteBranch,s.RemoteZoneCode,
			s.SOBranch,s.SOControlNo,s.SOOperator,s.ReceiverContactNo,s.SenderContactNo,s.custId,s.isremote,s.TableOriginated,
		(
		SELECT controlno AS a FROM ',_db,'.`payout` s
		WHERE if((SELECT `GetAgentName`(s.OperatorID))=''1'',0,1) 
			AND IF(IF(isremote=1,remotebranch,branchcode)=001 OR IF(isremote=1,remotebranch,branchcode)=002,branchcode,
			IF(isremote=1,remotebranch,branchcode))=',_branchcode,'
			AND IF( IF(isremote=1,remotebranch,branchcode)=001 OR IF(isremote=1,remotebranch,branchcode)=002,zonecode,
			IF(isremote=1,remotezonecode,zonecode))=',_zonecode,' 
			AND DATE_FORMAT(s.claimeddate,''%d'')=',_date,'
			ORDER BY s.claimeddate ASC LIMIT 1
		) AS a,
		(
		SELECT controlno AS a FROM ',_db,'.`payout` s
		WHERE if((SELECT `GetAgentName`(s.OperatorID))=''1'',0,1) 
			AND IF(IF(isremote=1,remotebranch,branchcode)=001 OR IF(isremote=1,remotebranch,branchcode)=002,branchcode,
			IF(isremote=1,remotebranch,branchcode))=',_branchcode,'
			AND IF( IF(isremote=1,remotebranch,branchcode)=001 OR IF(isremote=1,remotebranch,branchcode)=002,zonecode,
			IF(isremote=1,remotezonecode,zonecode))=',_zonecode,' 
			AND DATE_FORMAT(s.claimeddate,''%d'')=',_date,'
			ORDER BY s.claimeddate DESC LIMIT 1
		) AS b
			FROM ',_db,'.`payout` s
			WHERE if((SELECT `GetAgentName`(s.OperatorID))=''1'',0,1) and 
			s.kptnno LIKE ''%mlx%'' AND YEAR(s.claimeddate)=',_year,' AND DATE_FORMAT(s.claimeddate,''%d'')=',_date,' AND IF(s.isremote=1,s.remoteOperatorID,s.OperatorID)=''',_by,'''
			AND IF(IF(s.isremote=1,s.remotebranch,s.branchcode)=001 OR IF(s.isremote=1,s.remotebranch,s.branchcode)=002,s.branchcode,
			IF(s.isremote=1,s.remotebranch,s.branchcode))=',_branchcode,'
			AND IF( IF(s.isremote=1,s.remotebranch,s.branchcode)=001 OR IF(s.isremote=1,s.remotebranch,s.branchcode)=002,s.zonecode,
			IF(s.isremote=1,s.remotezonecode,s.zonecode))=',_zonecode,' 
			GROUP BY s.kptnno		
			ORDER BY s.claimeddate ASC
		)X GROUP BY DATE(claimeddate) ORDER BY claimeddate ASC
		');
	END IF;
   ELSEIF _type='CP' THEN
	IF _per='DAILY' THEN
		SET @SQLStmt = CONCAT('
		SELECT 
		controlno,kptnno,
		DATE_FORMAT(cancelleddate,''%r'') AS cancelledtime,
		cancelleddate,principal,
		IF(servicecharge IS NULL,0,servicecharge) AS charge,
		if(CancelledEmpCharge is null,0,CancelledEmpCharge) as CancelledEmpCharge,
		if(CancelledCustCharge is null,0,CancelledCustCharge) as CancelledCustCharge,
		if(length(kptnno)=21,(DATE_FORMAT(CONCAT(SUBSTRING(kptnno,20,2),SUBSTRING(kptnno,18,2),SUBSTRING(kptnno,7,2)),''%m/%d/%Y'')),
		if(LENGTH(kptnno)=20,(DATE_FORMAT(CONCAT(SUBSTRING(kptnno,19,2),SUBSTRING(kptnno,17,2),SUBSTRING(kptnno,7,2)),''%m/%d/%Y'')),
		DATE_FORMAT(CONCAT(SUBSTRING(kptnno,17,6),SUBSTRING(kptnno,4,2)),''%m/%d/%Y'')))  AS sodate,
		OperatorID,
		IF(sendername IS NULL, CONCAT(senderlname, '', '' ,senderfname, '' '', sendermname),sendername) AS sendername,
		IF(receivername IS NULL, CONCAT(receiverlname, '', '' ,receiverfname, '' '', receivermname),receivername) AS receivername,
		branchcode,zonecode,oldkptnno,cancelledreason,CancelledType,reason,
		CancelledByBranchCode,CancelledByOperatorID,RemoteBranch,RemoteZoneCode,
		ReceiverContactNo,SenderContactNo,custId,isremote,TableOriginated,
		(IF ((claimeddate = ''0000-00-00 00:00:00''),(SELECT claimeddate FROM  ',_db,'.payout WHERE kptnno=p.kptnno limit 1),claimeddate)) AS podate
		FROM ',_db,'.pocancel  p
		WHERE if((SELECT `GetAgentName`(OperatorID))=''1'',0,1) and  YEAR(cancelleddate)=',_year,' 
		AND DATE_FORMAT(cancelleddate,''%d'')=',_date,' AND IF(isremote=1,remoteOperatorID,OperatorID)=''',_by,'''
		AND IF(IF(isremote=1,remotebranch,branchcode)=001 OR IF(isremote=1,remotebranch,branchcode)=002,branchcode,
		IF(isremote=1,remotebranch,branchcode))=',_branchcode,'
		AND IF( IF(isremote=1,remotebranch,branchcode)=001 OR IF(isremote=1,remotebranch,branchcode)=002,zonecode,
		IF(isremote=1,remotezonecode,zonecode))=',_zonecode,' 
		group by kptnno ORDER BY cancelleddate ASC');
	ELSE
		SET @SQLStmt = CONCAT('
		SELECT 
		controlno,kptnno,cancelledtime,cancelleddate,
		COUNT(kptnno) AS transcount,
		SUM(principal) AS principal,
		SUM(charge) AS charge,
		SUM(cancelledempcharge) AS cancelledempcharge,
		SUM(cancelledcustcharge) AS cancelledcustcharge,
		sodate,OperatorID,SenderName,receivername,
		branchcode,zonecode,oldkptnno,CancelledReason,CancelledType,Reason,			
		CancelledByBranchCode,CancelledByOperatorID,RemoteBranch,RemoteZoneCode,
		ReceiverContactNo,SenderContactNo,custId,isremote,TableOriginated,podate,a,b from
		(SELECT 
		controlno,kptnno,
		DATE_FORMAT(cancelleddate,''%r'') AS cancelledtime,
		cancelleddate,principal,
		IF(servicecharge IS NULL,0,servicecharge) AS charge,
		IF(CancelledEmpCharge IS NULL,0,CancelledEmpCharge) as CancelledEmpCharge,
		IF(CancelledCustCharge IS NULL,0,CancelledCustCharge) as CancelledCustCharge,
		if(length(kptnno)=21,(DATE_FORMAT(CONCAT(SUBSTRING(kptnno,20,2),SUBSTRING(kptnno,18,2),SUBSTRING(kptnno,7,2)),''%m/%d/%Y'')),
		if(LENGTH(kptnno)=20,(DATE_FORMAT(CONCAT(SUBSTRING(kptnno,19,2),SUBSTRING(kptnno,17,2),SUBSTRING(kptnno,7,2)),''%m/%d/%Y'')),
		DATE_FORMAT(CONCAT(SUBSTRING(kptnno,17,6),SUBSTRING(kptnno,4,2)),''%m/%d/%Y''))) AS sodate,
		OperatorID,
		IF(sendername IS NULL, CONCAT(senderlname, '', '' ,senderfname, '' '', sendermname),sendername) AS sendername,
		IF(receivername IS NULL, CONCAT(receiverlname, '', '' ,receiverfname, '' '', receivermname),receivername) AS receivername,
		branchcode,zonecode,oldkptnno,cancelledreason,CancelledType,reason,
		CancelledByBranchCode,CancelledByOperatorID,RemoteBranch,RemoteZoneCode,
		ReceiverContactNo,SenderContactNo,custId,isremote,TableOriginated,
		(IF ((claimeddate = ''0000-00-00 00:00:00''),(SELECT claimeddate FROM  ',_db,'.payout WHERE kptnno=p.kptnno LIMIT 1),claimeddate)) AS podate,
		(SELECT controlno AS a FROM ',_db,'.pocancel  pc
		WHERE if((SELECT `GetAgentName`(pc.OperatorID))=''1'',0,1) 
			AND IF(IF(isremote=1,remotebranch,branchcode)=001 OR IF(isremote=1,remotebranch,branchcode)=002,branchcode,
			IF(isremote=1,remotebranch,branchcode))=',_branchcode,'
			AND IF( IF(isremote=1,remotebranch,branchcode)=001 OR IF(isremote=1,remotebranch,branchcode)=002,zonecode,
			IF(isremote=1,remotezonecode,zonecode))=',_zonecode,' 
			AND DATE_FORMAT(pc.cancelleddate,''%d'')=',_date,'
			ORDER BY pc.cancelleddate ASC LIMIT 1
		) AS a,
		(SELECT controlno AS a FROM ',_db,'.pocancel  pc
		WHERE if((SELECT `GetAgentName`(pc.OperatorID))=''1'',0,1) 
			AND IF(IF(isremote=1,remotebranch,branchcode)=001 OR IF(isremote=1,remotebranch,branchcode)=002,branchcode,
			IF(isremote=1,remotebranch,branchcode))=',_branchcode,'
			AND IF( IF(isremote=1,remotebranch,branchcode)=001 OR IF(isremote=1,remotebranch,branchcode)=002,zonecode,
			IF(isremote=1,remotezonecode,zonecode))=',_zonecode,' 
			AND DATE_FORMAT(pc.cancelleddate,''%d'')=',_date,'
			ORDER BY pc.cancelleddate DESC LIMIT 1
		) AS b
		FROM ',_db,'.pocancel  p
		WHERE if((SELECT `GetAgentName`(OperatorID))=''1'',0,1) and  YEAR(cancelleddate)=',_year,' 
		AND DATE_FORMAT(cancelleddate,''%d'')=',_date,' AND IF(isremote=1,remoteOperatorID,OperatorID)=''',_by,'''
		AND IF(IF(isremote=1,remotebranch,branchcode)=001 OR IF(isremote=1,remotebranch,branchcode)=002,branchcode,
		IF(isremote=1,remotebranch,branchcode))=',_branchcode,'
		AND IF( IF(isremote=1,remotebranch,branchcode)=001 OR IF(isremote=1,remotebranch,branchcode)=002,zonecode,
		IF(isremote=1,remotezonecode,zonecode))=',_zonecode,' 
		GROUP BY kptnno ORDER BY cancelleddate ASC
		)X GROUP BY DATE(cancelleddate) ORDER BY cancelleddate ASC
		');
	END IF;	
   END IF;
PREPARE Stmt FROM @SQLStmt;
EXECUTE Stmt;
DEALLOCATE PREPARE Stmt;
END $$
DELIMITER ;