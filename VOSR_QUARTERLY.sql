--A1

	SELECT ENTITY_INST.ID_INST_NMLS,
	  TRIM(LPAD((REPLACE(ENTITY_INST.IRS_EIN,'-','')),9,'0')) "IRS_EIN",
	  UPPER(ENTITY_INST.ENTITY_NME) "ENTITY_NME",
	  UPPER(ENTITY_INST.ADR_1) "ADR_1",
	  UPPER(ENTITY_INST.ADR_2) "ADR_2",
	  UPPER(ENTITY_INST.ADR_CITY) "ADR_CITY",
	  UPPER(ENTITY_INST.ADR_STATE) "ADR_STATE",
	  UPPER(ENTITY_INST.ADR_COUNTRY) "ADR_COUNTRY",
	  ENTITY_INST.ADR_ZIP,
	  ENTITY_INST.BUS_PHONE,
	  ENTITY_INST.BUS_FAX,
	  WEB_LIC.LICENSEID,
	  WEB_LIC.LICENSETYPECODE,
	  LOWER(WEB_LIC.WEB_ADDRESS) "WEB_ADDRESS",
	  WEB_LIC.BD_REGULATORY_NO "DFS_NO"
	FROM
	  (SELECT WEB_LIC.COMPANYID,
	    WEB_LIC.LICENSEID,
	    WEB_LIC.LICENSETYPECODE,
	    WEB_LIC.WEB_ADDRESS,
	    BD.BD_REGULATORY_NO
	  FROM
	    (SELECT *
	    FROM VIEW_DIST_SERVICER_LIC "LIC"
	    LEFT JOIN
	      (SELECT *
	      FROM ENTITY_WEB_ADDRESS
	      WHERE ID_INST_NMLS NOT IN
	        (SELECT ID_INST_NMLS
	        FROM ENTITY_WEB_ADDRESS
	        GROUP BY ID_INST_NMLS
	        HAVING COUNT(ID_INST_NMLS) > 1
	        )
	      ) "WEB"
	    ON LIC.COMPANYID = WEB.ID_INST_NMLS
	    ) "WEB_LIC"
	  LEFT JOIN BD_LICENSE_INFO "BD"
	  ON BD.NMLS_LICENSE_ID = WEB_LIC.LICENSEID
	  ) "WEB_LIC"
	LEFT JOIN ENTITY_INST
	ON WEB_LIC.COMPANYID = ENTITY_INST.ID_INST_NMLS

--A2
  
	SELECT * FROM ALIS_ANR_ENT_DIR_OWNER
		WHERE INSTR(TITLE, 'VICE') = 0 AND
		INSTR(TITLE, 'FORMER PRESIDENT') = 0 AND
		INSTR(TITLE, 'DIVISION PRESIDENT') = 0 AND
		INSTR(TITLE, 'DIVISION') = 0 AND
		INSTR(TITLE, 'V. PRESIDENT') = 0 AND
		INSTR(TITLE, 'CO-PRESIDENT') = 0 AND
		INSTR(TITLE, 'PRESIDENT - MORTGAGE OPERATIONS') = 0 AND
		INSTR(TITLE, 'PRESIDENT') > 0;
    
--A2 1  --VOSR_A2_QUARTERLY DOES NOT EXIST

SELECT * FROM ALIS_ANR_ENT_DIR_OWNER
  		WHERE 	(INSTR(TITLE, 'CEO') > 0 OR INSTR(TITLE, 'CHIEF EXECUTIVE OFFICER') > 0)
  			 	AND ID_INST_NMLS NOT IN (SELECT ID_INST_NMLS FROM VOSR_A2_QUARTERLY);

--A2 2 --VOSR_A2_QUARTERLY DOES NOT EXIST

SELECT * FROM ALIS_ANR_ENT_DIR_OWNER
WHERE 	(INSTR(TITLE,'CFO') > 0 OR INSTR(TITLE, 'CHIEF FINANCIAL OFFICER') > 0)
AND ID_INST_NMLS NOT IN (SELECT ID_INST_NMLS FROM VOSR_A2_QUARTERLY);

--A2 3 
	SELECT * FROM VIEW_SVCR_OWNERS_IND
  		WHERE 	(INSTR(TITLE, 'COO') > 0 OR INSTR(TITLE, 'CHIEF OPERATING OFFICER') > 0)
  			  	AND ID_INST_NMLS NOT IN (SELECT ID_INST_NMLS FROM VOSR_A2_QUARTERLY);
            
--A2 4

SELECT * FROM VIEW_SVCR_OWNERS_IND
  		WHERE 	(INSTR(TITLE, 'CSO') > 0 OR INSTR(TITLE, 'CHIEF STRATEGY OFFICER') > 0)
  			  	AND ID_INST_NMLS NOT IN (SELECT ID_INST_NMLS FROM VOSR_A2_QUARTERLY);

--A2 5

SELECT * FROM VIEW_SVCR_OWNERS_IND
  		WHERE 	(INSTR(TITLE, 'CMO') > 0 OR INSTR(TITLE, 'CHIEF MORTGAGE OFFICER') > 0)
  			  	AND ID_INST_NMLS NOT IN (SELECT ID_INST_NMLS FROM VOSR_A2_QUARTERLY);
            
--A3 1

SELECT ID_INST_NMLS, NME_FIRST, NME_LAST, TITLE, EMAIL, ADR_1, ADR_2, ADR_CITY, ADR_STATE, ADR_ZIP, PHONE, FAX
  	FROM
	    (SELECT ID_INST_NMLS,
	      UPPER(FIRST_NAME) "NME_FIRST",
	      UPPER(LAST_NAME) "NME_LAST",
	      UPPER(TITLE) "TITLE",
	      LOWER(EMAIL) "EMAIL",
	      UPPER(STREET_1) "ADR_1",
	      UPPER(STREET_2) "ADR_2",
	      UPPER(CITY) "ADR_CITY",
	      UPPER(STATE) "ADR_STATE",
	      POSTAL_CODE "ADR_ZIP",
	      PHONE,
	      FAX
	    FROM ENTITY_CONTACT_EMPLOYEE
	    WHERE upper(PRIMARY_COMPANY_CONTACT) = 'TRUE'
	    AND DTE_TERMINATED           IS NULL
	    )
  	UNION
	    (SELECT ID_INST_NMLS,
	      UPPER(NME_FIRST) "NME_FIRST",
	      UPPER(NME_LAST) "NME_LAST",
	      UPPER(TITLE) "TITLE",
	      LOWER(EMAIL) "EMAIL",
	      UPPER(ADR_1) "ADR_1",
	      UPPER(ADR_2) "ADR_2",
	      UPPER(ADR_CITY) "ADR_CITY",
	      UPPER(ADR_STATE) "ADR_STATE",
	      ADR_ZIP,
	      PHONE,
	      FAX
	    FROM ENTITY_CONTACT
	    WHERE ID_INST_NMLS NOT IN
	      (SELECT ID_INST_NMLS
	      FROM ENTITY_CONTACT_EMPLOYEE
	      WHERE upper(PRIMARY_COMPANY_CONTACT) = 'TRUE'
	      AND DTE_TERMINATED IS NULL));

---B1

	SELECT DISTINCT(ID_INST_NMLS),
    UPPER(BUS_NME) "BUS_NME"
  	FROM ENTITY_OTHER_BUS_NME;

--B2

SELECT DISTINCT(ID_INST_NMLS) "ID_INST_NMLS",
    	ADR_1,
    	ADR_2,
	    ADR_CITY,
	    ADR_STATE,
	    ADR_ZIP,
	    PHONE,
	    BRANCHMANAGERNAME
  	FROM
	    (SELECT B.ID_INST_NMLS,
	      UPPER(B.MAIN_ADR_1) "ADR_1",
	      UPPER(B.MAIN_ADR_2) "ADR_2",
	      UPPER(B.MAIN_ADR_CITY) "ADR_CITY",
	      UPPER(B.MAIN_ADR_STATE) "ADR_STATE",
	      B.MAIN_ADR_ZIP "ADR_ZIP",
	      B.PHN_BUSINESS "PHONE",
	      UPPER(M.FULL_NAME) "BRANCHMANAGERNAME"
	    FROM VIEW_BRANCH_ALL_SERVICERS B
	    LEFT OUTER JOIN VIEW_BRANCH_ALL_SERVICERS_MGR M
	    ON M.BRANCH_NMLS = B.BRANCH_NMLS
	    WHERE M.ENDDATE IS NULL);
      

--B3

	SELECT A.ID_INST_NMLS, B.LEGAL_STATUS
  		FROM VOSR_A1_QUARTERLY A JOIN ENTITY_OTHER_BUS_TYPE B ON A.ID_INST_NMLS = B.ID_INST_NMLS;
      

--C1

			SELECT ID_INST_NMLS, UPPER(NME_LEGAL) "LEGAL_NAME", UPPER(TITLE) "TITLE", PCT_OWNERSHIP
	    	FROM ENTITY_DIR_OWNER
	    	WHERE OWNER_TYPE = 'COMPANY' AND DTE_TERMINATED IS NULL AND PCT_OWNERSHIP != 0
    	UNION
    		SELECT ID_INST_NMLS, UPPER(NME_LEGAL), UPPER(STATUS), PCT_OWNERSHIP
		    FROM ENTITY_INDIR_OWNER
		    WHERE OWNER_TYPE = 'COMPANY' AND DTE_TERMINATED IS NULL AND PCT_OWNERSHIP != 0;
        
--C2

		  SELECT ID_INST_NMLS,
		  ID_INDIVIDUAL_NMLS,
		  KEY_INDIVIDUAL,
  		  UPPER(TITLE) "TITLE",
  		  PCT_OWNERSHIP,
  		  UPPER(NME_FIRST) "NME_FIRST",
		  UPPER(NME_MIDDLE) "NME_MIDDLE",
		  UPPER(NME_LAST) "NME_LAST",
		  UPPER(ADR_1) "ADR_1",
		  UPPER(ADR_2) "ADR_2",
		  UPPER(ADR_CITY) "ADR_CITY" ,
		  UPPER(ADR_STATE) "ADR_STATE",
		  ADR_ZIP,
		  PHN_HOME
		FROM ENTITY_DIR_OWNER LEFT OUTER JOIN
  				(SELECT I.KEY_INDIVIDUAL,
    					I.ID_INDIVIDUAL_NMLS,
    					I.NME_FIRST,
    					I.NME_MIDDLE,
    					I.NME_LAST,
    					I.PHN_HOME,
    					R.ADR_1,
    					R.ADR_2,
    					R.ADR_CITY,
    					R.ADR_STATE,
    					R.ADR_ZIP
  				FROM
    				(SELECT KEY_INDIVIDUAL,
      					ADR_1,
      					ADR_2,
      					ADR_CITY,
      					ADR_STATE,
      					ADR_ZIP
    				FROM INDV_RESIDENTIAL_HIST
    				WHERE KEY_INDIVIDUAL IN
      					(SELECT KEY_INDIVIDUAL
      					FROM INDV_RESIDENTIAL_HIST
      					WHERE UPPER(FLG_CURRENT) = 'TRUE'
      					AND DTE_TO IS NULL
      					GROUP BY KEY_INDIVIDUAL
      					HAVING COUNT(KEY_INDIVIDUAL) = 1)
    					AND UPPER(FLG_CURRENT) = 'TRUE'
    					AND DTE_TO IS NULL) R LEFT OUTER JOIN INDIVIDUAL I ON I.KEY_INDIVIDUAL = R.KEY_INDIVIDUAL ) D ON D.ID_INDIVIDUAL_NMLS = KEY_SUBJECT_ID
		WHERE PCT_OWNERSHIP > 0
		AND OWNER_TYPE = 'INDIVIDUAL'
		AND DTE_TERMINATED IS NULL
		AND ID_INST_NMLS IN
				(SELECT ID_INST_NMLS FROM VOSR_A1_QUARTERLY)
		
		UNION

		SELECT ID_INST_NMLS,
		  ID_INDIVIDUAL_NMLS,
		  KEY_INDIVIDUAL,
  		  UPPER(STATUS) "TITLE",
  		  PCT_OWNERSHIP,
  		  UPPER(NME_FIRST) "NME_FIRST",
		  UPPER(NME_MIDDLE) "NME_MIDDLE",
		  UPPER(NME_LAST) "NME_LAST",
		  UPPER(ADR_1) "ADR_1",
		  UPPER(ADR_2) "ADR_2",
		  UPPER(ADR_CITY) "ADR_CITY" ,
		  UPPER(ADR_STATE) "ADR_STATE",
		  ADR_ZIP,
		  PHN_HOME
		FROM ENTITY_INDIR_OWNER LEFT OUTER JOIN
  				(SELECT I.KEY_INDIVIDUAL,
    				I.ID_INDIVIDUAL_NMLS,
				    I.NME_FIRST,
				    I.NME_MIDDLE,
				    I.NME_LAST,
				    I.PHN_HOME,
				    R.ADR_1,
				    R.ADR_2,
				    R.ADR_CITY,
				    R.ADR_STATE,
				    R.ADR_ZIP
  				FROM
    				(SELECT KEY_INDIVIDUAL,
      					  ADR_1,
					      ADR_2,
					      ADR_CITY,
					      ADR_STATE,
					      ADR_ZIP
    				FROM INDV_RESIDENTIAL_HIST
    				WHERE KEY_INDIVIDUAL IN
      						(SELECT KEY_INDIVIDUAL
      						FROM INDV_RESIDENTIAL_HIST
      						WHERE UPPER(FLG_CURRENT) = 'TRUE'
      						AND DTE_TO IS NULL
      						GROUP BY KEY_INDIVIDUAL
      						HAVING COUNT(KEY_INDIVIDUAL) = 1)
    					AND UPPER(FLG_CURRENT) = 'TRUE'
    					AND DTE_TO IS NULL) R LEFT OUTER JOIN INDIVIDUAL I ON I.KEY_INDIVIDUAL = R.KEY_INDIVIDUAL ) D ON D.ID_INDIVIDUAL_NMLS = KEY_SUBJECT_ID
				WHERE PCT_OWNERSHIP > 0
				AND OWNER_TYPE = 'INDIVIDUAL'
				AND DTE_TERMINATED IS NULL
				AND ID_INST_NMLS IN
  					(SELECT ID_INST_NMLS FROM VOSR_A1_QUARTERLY);

--D1

	SELECT *
		FROM
		  (SELECT B.ID_INST_NMLS,
		    B.KEY_INDIVIDUAL,
		    B.NME_FIRST,
		    B.NME_MIDDLE,
		    B.NME_LAST,
		    B.TITLE,
		    B.PHN_HOME,
		    UPPER(R.ADR_1) "ADR_1",
		    UPPER(R.ADR_2) "ADR_2",
		    UPPER(R.ADR_CITY) "ADR_CITY",
		    R.ADR_STATE,
		    R.ADR_ZIP
		  FROM
		    (SELECT KEY_INDIVIDUAL,
		      ID_INST_NMLS,
		      UPPER(NME_FIRST) "NME_FIRST",
		      UPPER(NME_MIDDLE) "NME_MIDDLE",
		      UPPER(NME_LAST) "NME_LAST",
		      UPPER(TITLE) "TITLE",
		      PHN_HOME
		    FROM
		      (SELECT ID_INST_NMLS,
		        KEY_SUBJECT_ID,
		        initcap(NME_LEGAL) "NME_LEGAL",
		        TITLE
		      FROM ENTITY_DIR_OWNER
		      WHERE OWNER_TYPE    = 'INDIVIDUAL'
		      AND FLG_ACTIVE      = 'YES'
		      AND DTE_TERMINATED IS NULL
		      AND ID_INST_NMLS   IN
		        (SELECT id_inst_nmls FROM VOSR_A1_QUARTERLY
		        )
		      UNION
		      SELECT ID_INST_NMLS,
		        KEY_SUBJECT_ID,
		        NME_LEGAL,
		        STATUS
		      FROM ENTITY_INDIR_OWNER
		      WHERE OWNER_TYPE    = 'INDIVIDUAL'
		      AND FLG_ACTIVE      = 'YES'
		      AND DTE_TERMINATED IS NULL
		      AND ID_INST_NMLS   IN
		        (SELECT ID_INST_NMLS FROM VOSR_A1_QUARTERLY
		        )
		      ) A
		    LEFT JOIN INDIVIDUAL
		    ON ID_INDIVIDUAL_NMLS = A.KEY_SUBJECT_ID
		    ) B
		  LEFT JOIN INDV_RESIDENTIAL_HIST R
		  ON R.KEY_INDIVIDUAL = B.KEY_INDIVIDUAL
		  WHERE R.FLG_CURRENT = 'true'
		  )
		WHERE upper(title) LIKE '%DIRECTOR%' ;
    
    
--D2

SELECT DISTINCT(OFFICEID) "ID_INST_NMLS",
		  NME_FIRST,
		  NME_MIDDLE,
		  NME_LAST,
		  ADR_1,
		  ADR_2,
		  ADR_CITY,
		  ADR_STATE,
		  ADR_ZIP,
		  PHN_HOME,
		  upper(title) "TITLE"
		FROM RELAT_MU2_RELATIONSHIPS
		LEFT OUTER JOIN VOSR_C2_QUARTERLY
		ON INDIVIDUALID             = ID_INDIVIDUAL_NMLS
		WHERE (RELATIONSHIPTYPECODE = 'CONTROL_PERSON'
		AND OFFICEID IN (SELECT ID_INST_NMLS FROM VOSR_A1_QUARTERLY)
		AND ENDDATE                IS NULL)
		AND (UPPER(TITLE) LIKE '%CAO%'
		OR UPPER(TITLE) LIKE '%CAA%'
		OR UPPER(TITLE) LIKE '%CCO%'
		OR UPPER(TITLE) LIKE '%CDO%'
		OR UPPER(TITLE) LIKE '%CEO%'
		OR UPPER(TITLE) LIKE '%CCO%'
		OR UPPER(TITLE) LIKE '%CFO%'
		OR UPPER(TITLE) LIKE '%CISO%'
		OR UPPER(TITLE) LIKE '%CIO%'
		OR UPPER(TITLE) LIKE '%CITO%'
		OR UPPER(TITLE) LIKE '%CMO%'
		OR UPPER(TITLE) LIKE '%CPO%'
		OR UPPER(TITLE) LIKE '%CRO%'
		OR UPPER(TITLE) LIKE '%CSO%'
		OR UPPER(TITLE) LIKE '%CUO%'
		OR UPPER(TITLE) LIKE '%COO%'
		OR UPPER(TITLE) LIKE '%OFFICER%'
		OR UPPER(TITLE) LIKE '%DIRECTOR%'
		);
    

--E1

	SELECT ENTITY_JURISDICTION.ID_INST_NMLS,
		  UPPER(NME_FIRST) "NME_FIRST",
		  UPPER(NME_MIDDLE) "NME_MIDDLE",
		  UPPER(NME_LAST) "NME_LAST",
		  UPPER(TITLE) "TITLE",
		  EMP_TYPE_CODE,
		  JUR_STATE
		FROM (ENTITY_JURISDICTION
		LEFT JOIN ENTITY_QUA_INDIVIDUAL
		ON KEY_QUA_IND_ID = KEY_FROM_CONTACT)
		LEFT OUTER JOIN INDIVIDUAL
		ON KEY_SUBJECT_ID   = INDIVIDUAL.ID_INDIVIDUAL_NMLS
		WHERE EMP_TYPE_CODE = 'QUALIFIER'
		AND JUR_STATE       = 'NY'
		AND DTE_TERMINATED IS NULL
		AND ENTITY_JURISDICTION.ID_INST_NMLS IN (SELECT ID_INST_NMLS FROM VOSR_A1_QUARTERLY);
    

