public without sharing class pbmRequestWrapper {
     
    @AuraEnabled
    public static wrapperClass getFAF(id FAFId){
        // create a wrapper class object and set the wrapper class @AuraEnabled properties and return it to the lightning component.
        wrapperClass returnwrapperClass = new  wrapperClass ();
                
        //Collect FAF and child objects
        map<id,Central_Hub__c> fafMap = new map<id,Central_Hub__c>([SELECT id, Name, Client_Name__c,Account_Name__r.iUMS_Client_Subtype__c,
                                        Account_Name__r.ERISA_NON_ERISA__c, Account_Name__r.Business_Unit__c, Segment__c,Account_Name__r.Market_Segment__c,
                                        LastModifiedBy.Name,LastModifiedDate, Master_Agreement__c, FAF_Status__c,
                                        (SELECT Contract_Effective_Date__c, Contract_End_Date__c, Master_Client_Name__c, Pricing_Effective_Date__c FROM Client_Info__r LIMIT 1),
                                        (SELECT Adjudicate_at_Actual_Package_Size__c FROM Mail_Ops__r LIMIT 1),
                                        (SELECT Pass_MAF__c, Specialty_Rebates__c, Vaccine_Exclusion_Option__c, 
                                        Rebate_RTMD__c, Rebate_Contract_Type__c, Rebate_Offering_Type__c, X340B__c, 
                                        Compound__c, Paper__c, COB__c, Vaccine__c, LDD__c, ZBD__c, Select_Specialty_PDPD_Therapy_Class_es__c, 
                                        Rebate_Effective_Date__c, Non_Specialty_Formulary_Option__c, Specialty_Formulary_Option__c 
                                        FROM Rebate_Operations__r LIMIT 1),
                                        (SELECT Performance_Guarantee__c, PG_At_Risk_Dollar_Amount__c FROM Guarantee_Info__r LIMIT 1),
                                        (SELECT id FROM FAF_Network_Ops__r LIMIT 1),
                                        (SELECT Days_Written_Notice_Before_Termination__c,Frequency_1__c, Term_Without_Cause__c FROM Legal__r LIMIT 1),
                                        (SELECT id, Pharmacy_Benefit__c FROM Specialty_Ops__r LIMIT 1),
                                        (SELECT id FROM Clinical_Ops__r LIMIT 1),
                                        (SELECT id FROM PBMRequest__r LIMIT 1),
                                        (SELECT Pharmacy_Audit_Retention__c, Client_Share__c, CVS_Share__c, Claim_Billing__c, 
                                        Admin_Fee_Billing__c, Billing_Claim_Payment_Terms__c, Billing_Admin_Payment_Terms__c,
                                        Additional_Admin_Fee_Payment_Term_Info__c, Additional_Claim_Payment_Term_Info__c FROM Billing_Ops__r LIMIT 1)
                                        FROM Central_Hub__c WHERE id =: FAFId]);   
                        
        if(fafMap.size() > 0){
        	returnwrapperClass.FAFName = fafMap.get(FAFId).Name;
            returnwrapperClass.masterAgreementId = fafMap.get(FAFId).Master_Agreement__c;
            returnwrapperClass.FAFStatus = fafMap.get(FAFId).FAF_Status__c;
            list<PBMRequest__c> pbmReq = fafMap.get(FAFId).PBMRequest__r;
            returnwrapperClass.pbmRequestId = pbmReq.size() > 0 ? pbmReq[0].id : null;            
        }                                    
        return returnwrapperClass;    
    }
    
    @AuraEnabled
    public static wrapperClass getRequestInfo(id pbmRequestId){        
        wrapperClass returnwrapperClass = new  wrapperClass ();
        
        map<id,PBMRequest__c> requestMap = new map<id,PBMRequest__c>([SELECT id, FAF__r.Master_Agreement__c                                       
                                        FROM PBMRequest__c WHERE id =: pbmRequestId]);           
        if(requestMap.size() > 0){        	
            returnwrapperClass.masterAgreementId = requestMap.get(pbmRequestId).FAF__r.Master_Agreement__c;            
        }                                 
        return returnwrapperClass;    
    }
    
    @AuraEnabled(cacheable=true)
    public static List<User> getUserByGroup(string userGroup) {
         return [select id, FirstName,LastName, Email from user WHERE IsActive = true AND user_grouping__c =:userGroup];
    }
    
    @AuraEnabled(cacheable=true)
    public static wrapperClass submitRequest(id FAFId){
        wrapperClass returnwrapperClass = new  wrapperClass ();
        boolean wrapisValidRequest = true;
        string wrapinvalidMessage = 'test invalid message';
        
        //Collect FAF and child objects
        map<id,Central_Hub__c> fafMap = new map<id,Central_Hub__c>([SELECT id, Name, Client_Name__c,Account_Name__r.iUMS_Client_Subtype__c,
                                                                    Account_Name__r.ERISA_NON_ERISA__c, Account_Name__r.Business_Unit__c, Segment__c,Account_Name__r.Market_Segment__c,
                                                                    LastModifiedBy.Name,LastModifiedDate, Master_Agreement__c,
                                                                    (SELECT Contract_Effective_Date__c, Contract_End_Date__c, Master_Client_Name__c, Pricing_Effective_Date__c FROM Client_Info__r LIMIT 1),
                                                                    (SELECT Adjudicate_at_Actual_Package_Size__c FROM Mail_Ops__r LIMIT 1),
                                                                    (SELECT Pass_MAF__c, Specialty_Rebates__c, Vaccine_Exclusion_Option__c, 
                                                                     Rebate_RTMD__c, Rebate_Contract_Type__c, Rebate_Offering_Type__c, X340B__c, 
                                                                     Compound__c, Paper__c, COB__c, Vaccine__c, LDD__c, ZBD__c, Select_Specialty_PDPD_Therapy_Class_es__c, 
                                                                     Rebate_Effective_Date__c, Non_Specialty_Formulary_Option__c, Specialty_Formulary_Option__c 
                                                                     FROM Rebate_Operations__r LIMIT 1),
                                                                    (SELECT Performance_Guarantee__c FROM Guarantee_Info__r LIMIT 1),
                                                                    (SELECT id FROM FAF_Network_Ops__r LIMIT 1),
                                                                    (SELECT Days_Written_Notice_Before_Termination__c,Frequency_1__c, Term_Without_Cause__c FROM Legal__r LIMIT 1),
                                                                    (SELECT id, Pharmacy_Benefit__c FROM Specialty_Ops__r LIMIT 1),
                                                                    (SELECT id FROM Clinical_Ops__r LIMIT 1),
                                                                    (SELECT id FROM PBMRequest__r LIMIT 1),
                                                                    (SELECT Pharmacy_Audit_Retention__c, Client_Share__c, CVS_Share__c, Claim_Billing__c, 
                                                                     Admin_Fee_Billing__c, Billing_Claim_Payment_Terms__c, Billing_Admin_Payment_Terms__c,
                                                                     Additional_Admin_Fee_Payment_Term_Info__c, Additional_Claim_Payment_Term_Info__c FROM Billing_Ops__r LIMIT 1)
                                                                    FROM Central_Hub__c WHERE id =: FAFId]);
        
        if(fafMap.size() > 0){
            if(fafMap.get(FAFId).Account_Name__r.iUMS_Client_Subtype__c == null){
                wrapisValidRequest = false;
                wrapinvalidMessage = 'Account iUMS Client Subtype should not be blank when submitting PBM request';
            }
            if(fafMap.get(FAFId).Account_Name__r.ERISA_NON_ERISA__c == null){
                wrapisValidRequest = false;
                wrapinvalidMessage = 'Account ERISA/NON-ERISA should not be blank when submitting PBM request';
            }
            
            list<Client_Information__c> clientInfo = fafMap.get(FAFId).Client_Info__r;
            if(clientInfo.size() > 0){
                if(clientInfo[0].Master_Client_Name__c == null){
                    wrapisValidRequest = false;
                    wrapinvalidMessage = 'Client Info. Master Client should not be blank when submitting PBM request';
                }
                if(clientInfo[0].Contract_Effective_Date__c == null){
					wrapisValidRequest = false;
					wrapinvalidMessage = 'Client Info. Contract Effective Date should not be blank when submitting PBM request';                    
                }
                if(clientInfo[0].Contract_End_Date__c == null){
                    wrapisValidRequest = false;
                    wrapinvalidMessage = 'Client Info. Contract End Date should not be blank when submitting PBM request';
                }                
            }else{
                wrapisValidRequest = false;
                wrapinvalidMessage = 'FAF Client Information is required when submitting PBM request';
            }
            list<Billing_Operations__c> billingOps = fafMap.get(FAFId).Billing_Ops__r;
            if(billingOps.size() > 0){
                if(billingOps[0].Claim_Billing__c == null){
                    wrapisValidRequest = false;
                    wrapinvalidMessage = 'Billing Operations Claim Billing should not be blank when submitting PBM request';
                }
                if(billingOps[0].Admin_Fee_Billing__c == null){
					wrapisValidRequest = false;
					wrapinvalidMessage = 'Billing Operations Admin Fee Billing should not be blank when submitting PBM request';                    
                }          
            }else{
                wrapisValidRequest = false;
                wrapinvalidMessage = 'FAF Billing Operations is required when submitting PBM request';
            }
            
            list<Rebate_Operations__c> rebatesOps = fafMap.get(FAFId).Rebate_Operations__r;
            if(rebatesOps.size() > 0){
                if(rebatesOps[0].Non_Specialty_Formulary_Option__c == null){
                    wrapisValidRequest = false;
                    wrapinvalidMessage = 'Rebate Operations Non Specialty Formulary Option should not be blank when submitting PBM request';
                }
                if(rebatesOps[0].Specialty_Formulary_Option__c == null){
					wrapisValidRequest = false;
					wrapinvalidMessage = 'Rebate Operations Specialty Formulary Option should not be blank when submitting PBM request';                    
                }          
            }else{
                wrapisValidRequest = false;
                wrapinvalidMessage = 'FAF Rebate Operations is required when submitting PBM request';
            }
            
        }
        
        returnwrapperClass.isValidRequest = wrapisValidRequest;
        returnwrapperClass.invalidMessage = wrapinvalidMessage;
        returnwrapperClass.FAFId = FAFId;
        return returnwrapperClass; 
    }
    
    @AuraEnabled
    public static wrapperClass syncStatus(id pbmReqId){
        wrapperClass returnwrapperClass = new  wrapperClass ();
        PBMRequest__c pbmReq = [SELECT FAF__c, Request_Submitted__c FROM PBMRequest__c WHERE id =:pbmReqId LIMIT 1];        
        if(pbmReq != null){
            returnwrapperClass.pbmRequestStatus = pbmReq.Request_Submitted__c;
            returnwrapperClass.requestStatusHasChange = false;
            Central_Hub__c fafrec = [SELECT Master_Agreement__c FROM Central_Hub__c WHERE id =:pbmReq.FAF__c LIMIT 1];
            if(fafrec != null){
                if(fafrec.Master_Agreement__c == null && pbmReq.Request_Submitted__c == true){
                    pbmReq.Request_Submitted__c = false;
                	update pbmReq;
                    returnwrapperClass.pbmRequestStatus = false;
                    returnwrapperClass.requestStatusHasChange = true;
                }
            }          
        }        
        return returnwrapperClass; 
    }
    
    @AuraEnabled
    public static wrapperClass createAgreement(id FAFId, id AttorneyId, id ParalegalId){
        wrapperClass returnwrapperClass = new  wrapperClass ();
        
        //Collect FAF and child objects
        map<id,Central_Hub__c> fafMap = new map<id,Central_Hub__c>([SELECT id, Name, Client_Name__c,Account_Name__r.iUMS_Client_Subtype__c,
                                                                    Account_Name__r.ERISA_NON_ERISA__c, Account_Name__r.Business_Unit__c, Segment__c,Account_Name__r.Market_Segment__c,
                                                                    LastModifiedBy.Name,LastModifiedDate, Master_Agreement__c,
                                                                    (SELECT Contract_Effective_Date__c, Contract_End_Date__c, Master_Client_Name__c,Master_Client_Name__r.Name, Pricing_Effective_Date__c FROM Client_Info__r LIMIT 1),
                                                                    (SELECT Adjudicate_at_Actual_Package_Size__c FROM Mail_Ops__r LIMIT 1),
                                                                    (SELECT Pass_MAF__c, Specialty_Rebates__c, Vaccine_Exclusion_Option__c, 
                                                                     Rebate_RTMD__c, Rebate_Contract_Type__c, Rebate_Offering_Type__c, X340B__c, 
                                                                     Compound__c, Paper__c, COB__c, Vaccine__c, LDD__c, ZBD__c, Select_Specialty_PDPD_Therapy_Class_es__c, 
                                                                     Rebate_Effective_Date__c, Non_Specialty_Formulary_Option__c, Specialty_Formulary_Option__c 
                                                                     FROM Rebate_Operations__r LIMIT 1),
                                                                    (SELECT Performance_Guarantee__c, PG_At_Risk_Dollar_Amount__c FROM Guarantee_Info__r LIMIT 1),
                                                                    (SELECT id FROM FAF_Network_Ops__r LIMIT 1),
                                                                    (SELECT Days_Written_Notice_Before_Termination__c,Frequency_1__c, Term_Without_Cause__c FROM Legal__r LIMIT 1),
                                                                    (SELECT id, Pharmacy_Benefit__c FROM Specialty_Ops__r LIMIT 1),
                                                                    (SELECT id FROM Clinical_Ops__r LIMIT 1),
                                                                    (SELECT id, Clinical_Solution__c FROM Clinical_Solutions__r),
                                                                    (SELECT id, Type__c FROM Medicare_Part_D_Fee_Schedules__r WHERE Type__c IN ('Subsidy') LIMIT 1),
                                                                    (SELECT id, Network_Name__c FROM Network_Pricing__r WHERE Network_Name__c IN ('MC(84-90)CP','MC(84-90)CVS') LIMIT 1),
                                                                    (SELECT id, Vaccine_Services__c, Preventive_Care_Drug_Program__c, Existing_Client_Contract_Type__c, Agreement__c FROM PBMRequest__r LIMIT 1),
                                                                    (SELECT Pharmacy_Audit_Retention__c, Client_Share__c, CVS_Share__c, Claim_Billing__c, 
                                                                     Admin_Fee_Billing__c, Billing_Claim_Payment_Terms__c, Billing_Admin_Payment_Terms__c,
                                                                     Additional_Admin_Fee_Payment_Term_Info__c, Additional_Claim_Payment_Term_Info__c FROM Billing_Ops__r LIMIT 1)
                                                                    FROM Central_Hub__c WHERE id =: FAFId]);
        
        if(fafMap.size() > 0){
            date contractStartdate = null;
            date contractEnddate = null;
            Id agreementId = null;
            Id acctId = null;
            String acctName = null;
            list<Client_Information__c> clientInfo = fafMap.get(FAFId).Client_Info__r;
            if(clientInfo.size() > 0){
                
                contractStartdate = clientInfo[0].Pricing_Effective_Date__c != null ? clientInfo[0].Pricing_Effective_Date__c : clientInfo[0].Contract_Effective_Date__c;
                
                contractEnddate = clientInfo[0].Contract_End_Date__c;
                acctId = clientInfo[0].Master_Client_Name__c;
                acctName = clientInfo[0].Master_Client_Name__c != null ? clientInfo[0].Master_Client_Name__r.Name.toUpperCase() : null;
            }
            
            Apttus__APTS_Agreement__c createAg = new Apttus__APTS_Agreement__c();
            createAg.Apttus_Approval__Approval_Status__c = 'In Progress';
            createAg.Apttus__Contract_Start_Date__c = contractStartdate;
            createAg.Apttus__Contract_End_Date__c = contractEnddate;
            createAg.Attorney__c = AttorneyId;
            createAg.Paralegal__c = ParalegalId;
            createAg.Name = 'LEGAL AGREEMENT INITIAL DEFAULT NAME';
            createAg.PBM_FAF__c = FAFId;
            createAg.RecordTypeId = Schema.SObjectType.Apttus__APTS_Agreement__c.getRecordTypeInfosByName().get('Legal').getRecordTypeId();
            
            //string dateOutput;
            string dateOutput = contractStartdate != null ? DateTime.newInstance(contractStartdate.year(), contractStartdate.month(), contractStartdate.day()).format('MM-dd-yy') : null;                                    
            createAg.Name = acctName  + '-' + 'PBSA' + '-' + 'FULL' + '-(' + dateOutput + ')';            
            createAg.Apttus__Account__c = acctId;
            insert createAg;
            
            Central_Hub__c updFAF =  fafMap.get(FAFId);
            updFAF.Master_Agreement__c = createAg.id;
            update updFAF;
            
            //Create Agreement Extension
            PBS_Agreement_Extension__c createAgEx = new PBS_Agreement_Extension__c();
            createAgEx.Agreement__c = createAg.id;
            createAgEx.ERISA_NON_ERISA__c = fafMap.get(FAFId).Account_Name__r.ERISA_NON_ERISA__c;
            createAgEx.iUMS_Client_Subtype__c = fafMap.get(FAFId).Account_Name__r.iUMS_Client_Subtype__c;
            createAgEx.Segment__c = fafMap.get(FAFId).Account_Name__r.Market_Segment__c;
            createAgEx.FAF_ID__c = FAFId;
            //Get values from Billing Operations
            list<Billing_Operations__c> billingOps = fafMap.get(FAFId).Billing_Ops__r;
            if(billingOps.size() > 0){
                createAgEx.Admin_Fee_Billing__c = billingOps[0].Admin_Fee_Billing__c;
                createAgEx.Billing_Admin_Payment_Terms__c = billingOps[0].Billing_Admin_Payment_Terms__c;
                createAgEx.Billing_Claim_Payment_Terms__c = billingOps[0].Billing_Claim_Payment_Terms__c;
                createAgEx.Claim_Billing__c = billingOps[0].Claim_Billing__c;
                createAgEx.CVS_Share__c = billingOps[0].CVS_Share__c;
                createAgEx.Pharmacy_Audit_Retention__c = billingOps[0].Pharmacy_Audit_Retention__c;
                createAgEx.Client_Share__c = billingOps[0].Client_Share__c;
                createAgEx.Additional_Claim_Payment_Term_Info__c = billingOps[0].Additional_Claim_Payment_Term_Info__c;
                createAgEx.Additional_Admin_Fee_Payment_Term_Info__c = billingOps[0].Additional_Admin_Fee_Payment_Term_Info__c;
            }
            
            //Get value from Legal Information
            list<Legal_Information__c> legalInfo = fafMap.get(FAFId).Legal__r;
            if(legalInfo.size() > 0){
                createAgEx.Days_Written_Notice_Before_Termination__c = legalInfo[0].Days_Written_Notice_Before_Termination__c;
                createAgEx.Frequency_1__c = legalInfo[0].Frequency_1__c;
                createAgEx.Term_Without_Cause__c = legalInfo[0].Term_Without_Cause__c;                
            }
            
            //Get value from Performance Guarantee
            list<Guarantees_Information__c> guarantInfo = fafMap.get(FAFId).Guarantee_Info__r;
            if(guarantInfo.size() > 0){
                createAgEx.Performance_Guarantee__c = guarantInfo[0].Performance_Guarantee__c;                     
            }
            
            //Get value from Rebate Operations
            list<Rebate_Operations__c> rebateOps = fafMap.get(FAFId).Rebate_Operations__r;
            if(rebateOps.size() > 0){
                createAgEx.Rebate_Contract_Type__c = rebateOps[0].Rebate_Contract_Type__c;
                createAgEx.Specialty_Rebates__c = rebateOps[0].Specialty_Rebates__c;
                createAgEx.Pass_MAF__c = rebateOps[0].Pass_MAF__c;
                createAgEx.Rebate_RTMD__c = rebateOps[0].Rebate_RTMD__c;
                createAgEx.Rebate_Offering_Type__c = rebateOps[0].Rebate_Offering_Type__c;
                createAgEx.Vaccine_Exclusion_Option__c = rebateOps[0].Vaccine_Exclusion_Option__c;
                createAgEx.Specialty_Formulary_Option__c = rebateOps[0].Specialty_Formulary_Option__c;
                createAgEx.Non_Specialty_Formulary_Option__c = rebateOps[0].Non_Specialty_Formulary_Option__c;
            }
            
            //Get value from Specialty Operations
            list<Specialty_Operations__c> specialOps = fafMap.get(FAFId).Specialty_Ops__r;
            if(specialOps.size() > 0){
                createAgEx.Pharmacy_Benefit__c = specialOps[0].Pharmacy_Benefit__c;                
            }
            
            //Get value from PBM request
            list<PBMRequest__c> pbmRequest = fafMap.get(FAFId).PBMRequest__r;
            if(pbmRequest.size() > 0){
                pbmRequest[0].Agreement__c = createAg.id;
                createAgEx.Vaccine_service__c = pbmRequest[0].Vaccine_Services__c;
				createAgEx.Preventive_Care_Drug_Program__c = pbmRequest[0].Preventive_Care_Drug_Program__c;
                if(pbmRequest[0].Existing_Client_Contract_Type__c != null){
                   createAgEx.Market_Check__c =  pbmRequest[0].Existing_Client_Contract_Type__c.contains('Market Check'); 
                }                
            }
            update pbmRequest;
            
            //Get value from Mail Operations
            list<Mail_Operations__c> mailOps = fafMap.get(FAFId).Mail_Ops__r;
            if(mailOps.size() > 0){
                createAgEx.Adjudicate_at_Actual_Package_Size__c = mailOps[0].Adjudicate_at_Actual_Package_Size__c;				            
            }
            
            //Get value from Medical part D schedule where type = 'Subsidy'
            list<Medicare_Part_D_Fees_Schedule__c> medcareSub = fafMap.get(FAFId).Medicare_Part_D_Fee_Schedules__r;
            if(medcareSub.size() > 0){
                createAgEx.Medicare_Subsidy__c = true;				            
            }
            
            //Get value from Network pricing where Name = Maintenance choice
            list<Network_Pricing__c> netPricing = fafMap.get(FAFId).Network_Pricing__r;
            if(netPricing.size() > 0){
                createAgEx.Maintenance_choice__c = true;				            
            }
            
            //Get value from Clinical Solutions (Appeals, Transform Diabetic care program and Extracare Healthcard)
            list<Clinical_Solutions__c> clinicalSol = fafMap.get(FAFId).Clinical_Solutions__r;
            if(clinicalSol.size() > 0){
                for(Clinical_Solutions__c eachClinicalSol : clinicalSol){
                    if(eachClinicalSol.Clinical_Solution__c == '1st Level Appeals' || eachClinicalSol.Clinical_Solution__c == '2nd Level Appeals' || eachClinicalSol.Clinical_Solution__c == 'Urgent 1st Level Appeals with an IRO'){
                        createAgEx.Appeals__c = true;
                    }else if(eachClinicalSol.Clinical_Solution__c == 'Transform Diabetes Care (PEMPM Meter Fee)' || eachClinicalSol.Clinical_Solution__c == 'Transform Diabetes Care (PMPM Clinical Fee)' ){
                        createAgEx.Transform_Diabetic_care_program__c = true;
                    }else if(eachClinicalSol.Clinical_Solution__c == 'ExtraCare Health Card'){
                        createAgEx.Extracare_Healthcard__c = true;
                    }
                }              			            
            }
            insert createAgEx;
            
            createAg.Agreement_Extension__c = createAgEx.id;
            update createAg;
            
            OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where DisplayName = 'CVS Official (Do Not Reply)'];
            
            list<Guarantees_Information__c> guaranteeInfo = fafMap.get(FAFId).Guarantee_Info__r;
            if(guaranteeInfo.size() > 0){
                if(guaranteeInfo[0].Performance_Guarantee__c){
                	Performance_Guarantees__c createPG = new Performance_Guarantees__c();
                    createPG.Agreement__c = createAg.id;
                    createPG.Client_Agreement_Name__c = acctName;
                    createPG.FAF__c = FAFId;            
                    createPG.Total_Amount_at_Risk__c = guaranteeInfo[0].PG_At_Risk_Dollar_Amount__c;
                    insert createPG;
                    
                    createAg.Performance_Guarantees__c = createPG.id;
                    update createAg;
                    
                    //Send PG Notification
                    List<String> toAddress = new List<string>();
        			toAddress.add(label.Performance_Guarantee_Email);        	
                    List<String> cc =new List<string>();
                    cc.add(UserInfo.getUserEmail());
        			List<String> bcc =new List<string>();
                    String pgLink = '<a href="' + URL.getSalesforceBaseUrl().toExternalForm() + '/' + createPG.id + '">' + 'click here' + '</a>';
                    string body ='FAF '+ fafMap.get(FAFId).Name +' requires a Performance Guarantee Contract ' + pgLink + ' to open, update, and start the Performance Guarantee flow.';                   
                    body += '<br/>';
                    body += '<br/>';
                    body += 'Thanks';
                    body += '<br/>';
                    body +=  System.Label.changeDashboardEmailThanks;
                    body += '<br/>';
                    body += '----------------------------------';
                    body += '<br/>';
                    body += 'Do not reply to this email';
        			string subject = 'Performance Guarantee requested for ' + createPG.Client_Agreement_Name__c;
                    Messaging.SingleEmailMessage mailPG = new Messaging.SingleEmailMessage();
					                    
                    mailPG.setToAddresses(toAddress);                    
                    mailPG.setSubject(subject);
                    mailPG.setHtmlBody(body);
                    if(bcc.size() > 0){
                        mailPG.setBccAddresses(bcc);
                    }
                    if(cc.size() > 0){
                        mailPG.setCcAddresses(cc);
                    }
                    if (owea.size() > 0 ) {
                        mailPG.setOrgWideEmailAddressId(owea[0].Id);
                    }
                    Messaging.sendEmail(new Messaging.Singleemailmessage [] {mailPG});
                }                                
            }
            
            list<PBMRequest__c> pbmReq = fafMap.get(FAFId).PBMRequest__r;
            if(pbmReq.size() > 0){
                pbmReq[0].Request_Submitted__c = true;                
            }
            update pbmReq;
            
            
            //Collect Agreement and Agreemenent extension record
            map<id,Apttus__APTS_Agreement__c> agreeMap = new map<id,Apttus__APTS_Agreement__c>([SELECT Id, PBM_FAF__c, PBM_FAF__r.Name,
                                                                                                Paralegal__r.Name, Attorney__r.Name, Name,  Attorney__r.Email, Paralegal__r.Email, Owner.Email,
                                                                                                FAF_Data_Sync__c, Master_Document_Generation_Date__c,CreatedBy.Name, Apttus__Account__r.Name,                                     
                                                                                                (SELECT id,Pass_MAF__c,Client_Name__c,Segment__c, Adjudicate_at_Actual_Package_Size__c,
                                                                                                 Admin_Fee_Billing__c, Claim_Billing__c, Billing_Admin_Payment_Terms__c,
                                                                                                 Additional_Admin_Fee_Payment_Term_Info__c, Billing_Claim_Payment_Terms__c,
                                                                                                 Additional_Claim_Payment_Term_Info__c, Rebate_RTMD__c, CVS_Share__c,
                                                                                                 Days_Written_Notice_Before_Termination__c, ERISA_NON_ERISA__c, Performance_Guarantee__c,
                                                                                                 Appeals__c, Maintenance_choice__c, Medicare_Subsidy__c, Transform_Diabetic_care_program__c,
                                                                                                 Extracare_Healthcard__c, Frequency_1__c, Pharmacy_Audit_Retention__c, Pharmacy_Benefit__c,
                                                                                                 Rebate_Contract_Type__c, Specialty_Rebates__c,
                                                                                                 Term_Without_Cause__c FROM PBS_Agreement_Extensions__r LIMIT 1)                                      
                                                                                                FROM Apttus__APTS_Agreement__c WHERE Id =:createAg.id]);
            
            //Sending of Email            
            //Create Email body parameters Parameters
            String paralegal = agreeMap.get(createAg.id).Paralegal__r.Name;
            String atty = agreeMap.get(createAg.id).Attorney__r.Name;            
            String agLink = '<a href="' + URL.getSalesforceBaseUrl().toExternalForm() + '/' + createAg.id + '">' + 'link' + '</a>';
            String Param1 = 'Hi <b>' + atty + '/' + paralegal + '</b> :';            
            String Param2 = agreeMap.get(createAg.id).CreatedBy.Name + ' has requested a new PBSA for ' + agreeMap.get(createAg.id).Apttus__Account__r.Name + '. Please review the details in this ' + agLink + '.';            
            String body='';
            body += '<html><body>';
            body += '<p>' + param1 + '</p>';          
            body += '<p>' + param2 + '</p>';
            body += '<br/>';
            body += '<br/>';
            body += '<br/>';
            body += 'Thanks';
            body += '<br/>';
            body +=  System.Label.changeDashboardEmailThanks;
            body += '<br/>';
            body += '----------------------------------';
            body += '<br/>';
            body += 'Do not reply to this email';
                        
            list<String> email = new list<String>();
            if(agreeMap.get(createAg.id).Attorney__r.Email != null){
                email.add(agreeMap.get(createAg.id).Attorney__r.Email);
            }
            
            if(agreeMap.get(createAg.id).Paralegal__r.Email != null){
                email.add(agreeMap.get(createAg.id).Paralegal__r.Email);
            }
            if(agreeMap.get(createAg.id).Owner.Email != null){
                email.add(agreeMap.get(createAg.id).Owner.Email);
            }
            if(email.IsEmpty()){
                email.add('Karen.Kohl@CVSHealth.com');
            }
                        
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            if (owea.size() > 0 ) {
                mail.setOrgWideEmailAddressId(owea.get(0).Id);
            }
            mail.setToAddresses(email);
            
            String[] ccAddresses = new String[] {UserInfo.getUserEmail(),'ryan.francis.m.roque@accenture.com'};
                mail.setccAddresses(ccAddresses);                    
            
            mail.setSubject(agreeMap.get(createAg.id).Apttus__Account__r.Name + ' New PBSA request');
            mail.setHtmlBody(body);
            Messaging.sendEmail(new Messaging.Singleemailmessage [] {mail});                
            returnwrapperClass.successRequest = 'Success ' + createAg.id;
        }                
        return returnwrapperClass; 
    }
            
    public class wrapperClass{
        @AuraEnabled public String FAFName {get;set;}
        @AuraEnabled public Id FAFId {get;set;}
        @AuraEnabled public String FAFStatus {get;set;}
        @AuraEnabled public String pbmRequestId {get;set;}
        @AuraEnabled public Boolean pbmRequestStatus {get;set;}
        @AuraEnabled public Boolean requestStatusHasChange {get;set;}
        @AuraEnabled public String masterAgreementId {get;set;}
        @AuraEnabled public Boolean isValidRequest {get;set;}
        @AuraEnabled public String invalidMessage {get;set;}
		@AuraEnabled public String successRequest {get;set;}          
    }
    
}