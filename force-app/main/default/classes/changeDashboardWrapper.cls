public without sharing class changeDashboardWrapper {     
    @AuraEnabled
    public static wrapperClass compareAgreementAndFAF(Boolean IsBatchJob, id agreementId, list<Apttus__APTS_Agreement__c> agreeList, list<OrgWideEmailAddress> owea, boolean IsForceRun){
        // create a wrapper class object and set the wrapper class @AuraEnabled properties and return it to the lightning component.
        wrapperClass returnwrapperClass = new  wrapperClass ();
        Map<id, String> wrapper_errors_map = new Map<id, String>();
        List<fieldValueWrapper> wrapper_fieldValueList = new List<fieldValueWrapper>();
        Boolean wrapper_isSync = true;
        String wrapper_AgName = '';
        Integer wrapper_NoOfMismatch = 0;
        list<Apttus__APTS_Agreement__c> processAgreement = new list<Apttus__APTS_Agreement__c>();
        if(IsBatchJob){
            processAgreement = agreeList;
        }else{
            processAgreement = [SELECT Id, PBM_FAF__c FROM Apttus__APTS_Agreement__c WHERE id =:agreementId];
        }
        
        set<id> agreeIds = new set<id>();
        set<id> FAFIds = new set<id>();
        for(Apttus__APTS_Agreement__c execAgree : processAgreement){
            agreeIds.add(execAgree.id);
            FAFIds.add(execAgree.PBM_FAF__c);
        }
        
        //Collect fields from custom settings
        map<id,changeDashboardFields__c> fieldsMap = new map<id,changeDashboardFields__c>([SELECT Id, Name, AgreementExt_Field_API__c, 
                                                     FAF_Field_API__c,FAF_object_API_Name__c, Field_Label__c, Field_Type__c, FAF_Object_Relationship__c, FAF_Object_Name__c                                      
                                                     FROM changeDashboardFields__c WHERE Active__c = true AND FAF_object_API_Name__c != 'PBMRequest__c' ORDER BY FAF_Object_Name__c, Field_Label__c ASC]);
        
        //Collect Agreement and Agreemenent extension record
        map<id,Apttus__APTS_Agreement__c> agreeMap = new map<id,Apttus__APTS_Agreement__c>([SELECT Id, PBM_FAF__c, PBM_FAF__r.Name,
                                                     Paralegal__r.Name, Attorney__r.Name, Name,  Attorney__r.Email, Paralegal__r.Email, Owner.Email,
                                                     FAF_Data_Sync__c, Master_Document_Generation_Date__c,                                      
                                                     (SELECT id,Pass_MAF__c,Client_Name__c,Segment__c, Adjudicate_at_Actual_Package_Size__c,
                                                     Admin_Fee_Billing__c, Claim_Billing__c, Billing_Admin_Payment_Terms__c,
                                                     Additional_Admin_Fee_Payment_Term_Info__c, Billing_Claim_Payment_Terms__c,
                                                     Additional_Claim_Payment_Term_Info__c, Rebate_RTMD__c, CVS_Share__c,
                                                     Days_Written_Notice_Before_Termination__c, ERISA_NON_ERISA__c, Performance_Guarantee__c,
                                                     Appeals__c, Maintenance_choice__c, Medicare_Subsidy__c, Transform_Diabetic_care_program__c,
                                                     Extracare_Healthcard__c, Frequency_1__c, Pharmacy_Audit_Retention__c, Pharmacy_Benefit__c,
                                                     Rebate_Contract_Type__c, Specialty_Rebates__c,
                                                     Term_Without_Cause__c FROM PBS_Agreement_Extensions__r LIMIT 1)                                      
                                                     FROM Apttus__APTS_Agreement__c WHERE Id IN:agreeIds]);
                        
        //Collect FAF and child objects
        map<id,Central_Hub__c> fafMap = new map<id,Central_Hub__c>([SELECT id, Name, Client_Name__c,Account_Name__r.iUMS_Client_Subtype__c,
                                        Account_Name__r.ERISA_NON_ERISA__c, Account_Name__r.Business_Unit__c, Segment__c,Account_Name__r.Market_Segment__c,LastModifiedBy.Name,LastModifiedDate, 
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
                                        (SELECT Pharmacy_Audit_Retention__c, Client_Share__c, CVS_Share__c, Claim_Billing__c, 
                                        Admin_Fee_Billing__c, Billing_Claim_Payment_Terms__c, Billing_Admin_Payment_Terms__c,
                                        Additional_Admin_Fee_Payment_Term_Info__c, Additional_Claim_Payment_Term_Info__c FROM Billing_Ops__r LIMIT 1)
                                        FROM Central_Hub__c WHERE id IN : FAFIds]);   
                
        //Collect clinical solution appeals
        map<id,Clinical_Operations__c> clinicalOpsMap = new map<id,Clinical_Operations__c>([SELECT Id                                      
                                                        FROM Clinical_Operations__c WHERE FAF_ID__c IN : FAFIds]);       
        map<id,list<Clinical_Solutions__c>> clinicalSolAppealMap = new map<id, list<Clinical_Solutions__c>>();
        if(clinicalOpsMap.size() > 0){
            for(Clinical_Solutions__c clinicalSolList : [SELECT Id, Clinical_Solution__c, Clinical_Operations__c FROM Clinical_Solutions__c 
                                                        WHERE Clinical_Operations__c IN :clinicalOpsMap.keyset() AND Clinical_Solution__c IN ('1st Level Appeals','2nd Level Appeals','Urgent 1st Level Appeals with an IRO') LIMIT 1]){
                if(clinicalSolAppealMap.containskey(clinicalSolList.Clinical_Operations__c)){
                    clinicalSolAppealMap.get(clinicalSolList.Clinical_Operations__c).add(clinicalSolList);
                }else{
                    clinicalSolAppealMap.put(clinicalSolList.Clinical_Operations__c,new list<Clinical_Solutions__c>{clinicalSolList});
                }                                      
            }
        }
        
        //Collect clinical solution transform diabetic      
        map<id,list<Clinical_Solutions__c>> clinicalSolTrasDiabMap = new map<id, list<Clinical_Solutions__c>>();
        if(clinicalOpsMap.size() > 0){
            for(Clinical_Solutions__c clinicalSolList : [SELECT Id, Clinical_Solution__c, Clinical_Operations__c FROM Clinical_Solutions__c 
                                                        WHERE Clinical_Operations__c IN :clinicalOpsMap.keyset() AND Clinical_Solution__c IN ('Transform Diabetes Care (PEMPM Meter Fee)', 'Transform Diabetes Care (PMPM Clinical Fee)') LIMIT 1]){
                if(clinicalSolTrasDiabMap.containskey(clinicalSolList.Clinical_Operations__c)){
                    //clinicalSolTrasDiabMap.get(clinicalSolList.Clinical_Operations__c).add(clinicalSolList);
                }else{
                    clinicalSolTrasDiabMap.put(clinicalSolList.Clinical_Operations__c,new list<Clinical_Solutions__c>{clinicalSolList});
                }                                      
            }
        }
        
        //Collect clinical solution extracare healthcard      
        map<id,list<Clinical_Solutions__c>> clinicalSolExtraCareHealthMap = new map<id, list<Clinical_Solutions__c>>();
        if(clinicalOpsMap.size() > 0){
            for(Clinical_Solutions__c clinicalSolList : [SELECT Id, Clinical_Solution__c, Clinical_Operations__c FROM Clinical_Solutions__c 
                                                        WHERE Clinical_Operations__c IN :clinicalOpsMap.keyset() AND Clinical_Solution__c IN ('ExtraCare Health Card') LIMIT 1]){
                if(clinicalSolExtraCareHealthMap.containskey(clinicalSolList.Clinical_Operations__c)){
                    //clinicalSolExtraCareHealthMap.get(clinicalSolList.Clinical_Operations__c).add(clinicalSolList);
                }else{
                    clinicalSolExtraCareHealthMap.put(clinicalSolList.Clinical_Operations__c,new list<Clinical_Solutions__c>{clinicalSolList});
                }                                      
            }
        }
       
        //Collect network pricing maintenance choice
        map<id,Network_Operations__c> networkOpsMap = new map<id,Network_Operations__c>([SELECT Id                                      
                                                        FROM Network_Operations__c WHERE FAF_ID__c IN : FAFIds]); 
        map<id,list<Network_Pricing__c>> netPriceMaintChoiceMap = new map<id, list<Network_Pricing__c>>();
        if(networkOpsMap.size() > 0){
            for(Network_Pricing__c netPriceList : [SELECT Id, FAF_Network_Ops__c, Network_Name__c FROM Network_Pricing__c 
                                                         WHERE FAF_Network_Ops__c IN :networkOpsMap.keyset() AND Network_Name__c IN ('MC(84-90)CP','MC(84-90)CVS') LIMIT 1]){
                if(netPriceMaintChoiceMap.containskey(netPriceList.FAF_Network_Ops__c)){
                    //netPriceMaintChoiceMap.get(netPriceList.FAF_Network_Ops__c).add(netPriceList);
                }else{
                    netPriceMaintChoiceMap.put(netPriceList.FAF_Network_Ops__c,new list<Network_Pricing__c>{netPriceList});
                }                                      
            }
        }
        
        //Collect medicare subsidy
        map<id,Billing_Operations__c> billinOpsMap = new map<id,Billing_Operations__c>([SELECT Id                                      
                                                        FROM Billing_Operations__c WHERE FAF_ID__c IN : FAFIds]); 
        map<id,list<Medicare_Part_D_Fees_Schedule__c>> medSubsidyMap = new map<id, list<Medicare_Part_D_Fees_Schedule__c>>();
        if(billinOpsMap.size() > 0){
            for(Medicare_Part_D_Fees_Schedule__c medSubsidyList : [SELECT Id, Billing_Operations__c, Type__c FROM Medicare_Part_D_Fees_Schedule__c 
                                                         WHERE Billing_Operations__c IN :billinOpsMap.keyset() AND Type__c IN ('Subsidy') LIMIT 1]){
                if(medSubsidyMap.containskey(medSubsidyList.Billing_Operations__c)){
                    //medSubsidyMap.get(medSubsidyList.Billing_Operations__c).add(medSubsidyList);
                }else{
                    medSubsidyMap.put(medSubsidyList.Billing_Operations__c,new list<Medicare_Part_D_Fees_Schedule__c>{medSubsidyList});
                }                                      
            }
        }
        
        //Collect Specialy drug level pricing
        map<id,Specialty_Operations__c> specialOpsMap = new map<id,Specialty_Operations__c>([SELECT Id                                      
                                                        FROM Specialty_Operations__c WHERE FAF_ID__c IN : FAFIds]); 
        map<id,list<Specialty_Drug_Level_Pricing__c>> drugLevelPricingMap = new map<id, list<Specialty_Drug_Level_Pricing__c>>();
        if(specialOpsMap.size() > 0){
            for(Specialty_Drug_Level_Pricing__c drugLevelPricingList : [SELECT Id, Specialty_Operations__c, Pharmacy_Benefit__c, FAF_ID__c FROM Specialty_Drug_Level_Pricing__c 
                                                         WHERE Specialty_Operations__c IN :specialOpsMap.keyset()]){
                if(drugLevelPricingMap.containskey(drugLevelPricingList.Specialty_Operations__c)){
                    drugLevelPricingMap.get(drugLevelPricingList.Specialty_Operations__c).add(drugLevelPricingList);
                }else{
                    drugLevelPricingMap.put(drugLevelPricingList.Specialty_Operations__c,new list<Specialty_Drug_Level_Pricing__c>{drugLevelPricingList});
                }                                      
            }
        }
        
        //Collect Special Guarantee
        map<id,list<Specialty_Guarantee__c>> specialGuaranteeMap = new map<id, list<Specialty_Guarantee__c>>();
        for(Specialty_Guarantee__c specialGuaranteeList : [SELECT Id, FAF_ID__c, Type__c, Subtype__c FROM Specialty_Guarantee__c 
                                                         WHERE FAF_ID__c IN :FAFIds]){
            if(specialGuaranteeMap.containskey(specialGuaranteeList.FAF_ID__c)){
                specialGuaranteeMap.get(specialGuaranteeList.FAF_ID__c).add(specialGuaranteeList);
            }else{
                specialGuaranteeMap.put(specialGuaranteeList.FAF_ID__c,new list<Specialty_Guarantee__c>{specialGuaranteeList});
            }                                      
        }
        
        for(Apttus__APTS_Agreement__c eachAgree : agreeMap.values()){
            //Compare Agreement and FAF fields
            string fieldTR = '';
            string agValue;
            string fafValue;
            boolean fafDataSync = true;
            wrapper_AgName = agreeMap.get(eachAgree.id).Name;
            map<string, map<string,string>> changeField_map = new map<string, map<string,string>>();
            for(string eachField : fieldsMap.keyset()){
                //Get Agreement value
                agValue = '';
                PBS_Agreement_Extension__c agreeExt = agreeMap.get(eachAgree.id).PBS_Agreement_Extensions__r;
                if(agreeExt != null){
                    if(agreeExt.get(fieldsMap.get(eachField).AgreementExt_Field_API__c) == null || agreeExt.get(fieldsMap.get(eachField).AgreementExt_Field_API__c) == 'null'){
                        agValue = 'Blank';
                    }else{
                        agValue = string.valueOf(agreeExt.get(fieldsMap.get(eachField).AgreementExt_Field_API__c));
                    }
                }
                
                //Get FAF Value
                fafValue = '';
                if(fieldsMap.get(eachField).FAF_Object_Relationship__c=='FAF'){
                    fafValue = fafMap.get(eachAgree.PBM_FAF__c).Segment__c;
                }else if(fieldsMap.get(eachField).FAF_Object_Relationship__c=='Parent' ){
                    SObject fabObj = fafMap.get(eachAgree.PBM_FAF__c).getSobject(fieldsMap.get(eachField).FAF_object_API_Name__c);
                    if(fabObj != null){
                        fafValue = (String)fabObj.get(fieldsMap.get(eachField).FAF_Field_API__c);
                    }
                }else if(fieldsMap.get(eachField).FAF_Object_Relationship__c=='Child'){
                    if(fafMap.get(eachAgree.PBM_FAF__c).getSObjects(fieldsMap.get(eachField).FAF_object_API_Name__c) != null){
                        List<SObject> fafrec = fafMap.get(eachAgree.PBM_FAF__c).getSObjects(fieldsMap.get(eachField).FAF_object_API_Name__c);
                        if(fafrec.size()>0){
                            fafValue = fafrec[0].get(fieldsMap.get(eachField).FAF_Field_API__c) == null ? 'Blank' : string.valueOf(fafrec[0].get(fieldsMap.get(eachField).FAF_Field_API__c));        
                        }    
                    }else{
                        if(agValue=='Blank' || agValue=='False'){
                            agValue = '';
                        }
                    }
                }else if(fieldsMap.get(eachField).FAF_Object_Relationship__c=='Custom Logic'){
                    if(fieldsMap.get(eachField).Name =='Appeals'){
                        if(fafMap.get(eachAgree.PBM_FAF__c).getSObjects(fieldsMap.get(eachField).FAF_object_API_Name__c) != null){
                            List<SObject> fafrec = fafMap.get(eachAgree.PBM_FAF__c).getSObjects(fieldsMap.get(eachField).FAF_object_API_Name__c);
                            if(fafrec.size()>0){
                                id clinicalOpsId = string.valueOf(fafrec[0].get(fieldsMap.get(eachField).FAF_Field_API__c));
                                if(clinicalSolAppealMap.size() >0){
                                    fafValue = clinicalSolAppealMap.containskey(clinicalOpsId) ? 'true' : 'false';
                                }else{
                                    fafValue = 'false';
                                }
                            }    
                        }else{
                            if(agValue=='Blank' || agValue=='False'){
                                agValue = '';
                            }
                        }
                    }else if(fieldsMap.get(eachField).Name =='Maintenance choice'){
                        if(fafMap.get(eachAgree.PBM_FAF__c).getSObjects(fieldsMap.get(eachField).FAF_object_API_Name__c) != null){
                            List<SObject> fafrec = fafMap.get(eachAgree.PBM_FAF__c).getSObjects(fieldsMap.get(eachField).FAF_object_API_Name__c);
                            if(fafrec.size()>0){
                                id netOpsId = string.valueOf(fafrec[0].get(fieldsMap.get(eachField).FAF_Field_API__c));
                                if(netPriceMaintChoiceMap.size() > 0){
                                    fafValue = netPriceMaintChoiceMap.containskey(netOpsId) ? 'true' : 'false';
                                }else{
                                    fafValue = 'false';
                                }
                            }    
                        }else{
                            if(agValue=='Blank' || agValue=='False'){
                                agValue = '';
                            }
                        }                       
                    }else if(fieldsMap.get(eachField).Name =='Medicare Subsidy'){
                        if(fafMap.get(eachAgree.PBM_FAF__c).getSObjects(fieldsMap.get(eachField).FAF_object_API_Name__c) != null){
                            List<SObject> fafrec = fafMap.get(eachAgree.PBM_FAF__c).getSObjects(fieldsMap.get(eachField).FAF_object_API_Name__c);
                            if(fafrec.size()>0){
                                id billOpsId = string.valueOf(fafrec[0].get(fieldsMap.get(eachField).FAF_Field_API__c));
                                if(medSubsidyMap.size() > 0){
                                    fafValue = medSubsidyMap.containskey(billOpsId) ? 'true' : 'false';
                                }else{
                                    fafValue = 'false';
                                }
                            }    
                        }else{
                            if(agValue=='Blank' || agValue=='False'){
                                agValue = '';
                            }
                        } 
                    }else if(fieldsMap.get(eachField).Name =='Transform Diabetic care program'){
                        if(fafMap.get(eachAgree.PBM_FAF__c).getSObjects(fieldsMap.get(eachField).FAF_object_API_Name__c) != null){
                            List<SObject> fafrec = fafMap.get(eachAgree.PBM_FAF__c).getSObjects(fieldsMap.get(eachField).FAF_object_API_Name__c);
                            if(fafrec.size()>0){
                                id clinicalOpsId = string.valueOf(fafrec[0].get(fieldsMap.get(eachField).FAF_Field_API__c));
                                if(clinicalSolTrasDiabMap.size() > 0){
                                    fafValue = clinicalSolTrasDiabMap.containskey(clinicalOpsId) ? 'true' : 'false';
                                }else{
                                    fafValue = 'false';
                                }
                            }    
                        }else{
                            if(agValue=='Blank' || agValue=='False'){
                                agValue = '';
                            }
                        } 
                    }else if(fieldsMap.get(eachField).Name =='Extracare Healthcard'){
                        if(fafMap.get(eachAgree.PBM_FAF__c).getSObjects(fieldsMap.get(eachField).FAF_object_API_Name__c) != null){
                            List<SObject> fafrec = fafMap.get(eachAgree.PBM_FAF__c).getSObjects(fieldsMap.get(eachField).FAF_object_API_Name__c);
                            if(fafrec.size()>0){
                                id clinicalOpsId = string.valueOf(fafrec[0].get(fieldsMap.get(eachField).FAF_Field_API__c));
                                if(clinicalSolExtraCareHealthMap.size() > 0){
                                    fafValue = clinicalSolExtraCareHealthMap.containskey(clinicalOpsId) ? 'true' : 'false';
                                }else{
                                    fafValue = 'false';
                                }
                            }    
                        }else{
                            if(agValue=='Blank' || agValue=='False'){
                                agValue = '';
                            }
                        }
                    }
                    
                    /*
                    else if(fieldsMap.get(eachField).Name =='SFS Included?'){
                        /*if(fafMap.get(eachAgree.PBM_FAF__c).getSObjects(fieldsMap.get(eachField).FAF_object_API_Name__c) != null){
                            List<SObject> fafrec = fafMap.get(eachAgree.PBM_FAF__c).getSObjects(fieldsMap.get(eachField).FAF_object_API_Name__c);
                            if(fafrec.size()>0){
                                id specialOpsId = string.valueOf(fafrec[0].get(fieldsMap.get(eachField).FAF_Field_API__c));
                                if(drugLevelPricingMap.size() > 0){
                                    if(drugLevelPricingMap.containskey(specialOpsId)){
                                        fafValue = 'true';
                                    }else{
                                        fafValue = 'false';
                                    }  
                                }else{
                                    fafValue = 'false';
                                }
                            }    
                        }else{
                            if(agValue=='Blank' || agValue=='False'){
                                agValue = '';
                            }
                        }   
                    }else if(fieldsMap.get(eachField).Name =='SFS Pharmacy Benefit'){
                        List<SObject> fafrec = fafMap.get(eachAgree.PBM_FAF__c).getSObjects(fieldsMap.get(eachField).FAF_object_API_Name__c);
                        if(fafrec.size()>0){
                            id specialOpsId = string.valueOf(fafrec[0].get(fieldsMap.get(eachField).FAF_Field_API__c));
                            if(drugLevelPricingMap.size() > 0){
                                if(drugLevelPricingMap.containskey(specialOpsId)){
                                    for(Specialty_Drug_Level_Pricing__c eachDrug : drugLevelPricingMap.get(specialOpsId)){
                                        if(eachDrug.Pharmacy_Benefit__c == label.Exclusive_Retail_Lockout){
                                            fafValue = 'Exclusive';
                                            break;
                                        }
                                        if(eachDrug.Pharmacy_Benefit__c == 'Open'){
                                            fafValue = 'Open';
                                            break;
                                        }
                                    } 
                                }else{
                                    fafValue = '';
                                }  
                            }else{
                                fafValue = '';
                            }
                        }
                    }else if(fieldsMap.get(eachField).Name =='SFS Type'){
                        List<SObject> fafrec = fafMap.get(eachAgree.PBM_FAF__c).getSObjects(fieldsMap.get(eachField).FAF_object_API_Name__c);
                        string FAFid = '';
                        if(fafrec.size()>0){
                            id specialOpsId = string.valueOf(fafrec[0].get(fieldsMap.get(eachField).FAF_Field_API__c));
                            if(drugLevelPricingMap.size() > 0){
                                if(drugLevelPricingMap.containskey(specialOpsId)){
                                    for(Specialty_Drug_Level_Pricing__c eachDrug : drugLevelPricingMap.get(specialOpsId)){
                                        if(eachDrug.Pharmacy_Benefit__c == label.Exclusive_Retail_Lockout){
                                            fafValue = 'Exclusive';
                                            break;
                                        }
                                        if(eachDrug.Pharmacy_Benefit__c == 'Open'){
                                            fafValue = 'Open';
                                            break;
                                        }
                                    }
                                    if(fafValue == 'Exclusive'){
                                        if(specialGuaranteeMap.size() > 0){
                                            if(specialGuaranteeMap.containskey(FAFid)){
                                                for(Specialty_Guarantee__c eachSpecialGuarantee : specialGuaranteeMap.get(FAFid)){
                                                    if(eachSpecialGuarantee.Type__c == label.OED){
                                                        if(eachSpecialGuarantee.Subtype__c == label.Flat)
                                                            fafValue = label.Adjucated_OED;
                                                        else
                                                            fafValue = label.Reconciled_OED;
                                                    }
                                                    else if(eachSpecialGuarantee.Type__c == label.GER || eachSpecialGuarantee.Type__c == label.BER){
                                                        fafValue =label.GER_OR_BER;
                                                    }
                                                    else{
                                                        fafValue = label.MER;
                                                    }
                                                }    
                                            }
                                        }
                                    }else{
                                        fafValue = '';
                                    }
                                }else{
                                    fafValue = '';
                                }  
                            }else{
                                fafValue = '';
                            }
                    }
                    */
                }
                               
                //Compare Agreement and FAF value
                if(agValue!=fafValue){
                    fafDataSync = false;
                    wrapper_isSync = false;
                    map<string,string> eachChange = new map<string,string>();
                    eachChange.put(agValue,fafValue);
                    changeField_map.put(fieldsMap.get(eachField).Field_Label__c,eachChange);
                    wrapper_NoOfMismatch++;
                    if(!test.isRunningTest()){
                        wrapper_fieldValueList.add(new fieldValueWrapper(fieldsMap.get(eachField).Field_Label__c,fieldsMap.get(eachField).FAF_Object_Name__c, agValue, fafValue,false,false,fafMap.get(eachAgree.PBM_FAF__c).LastModifiedBy.Name,fafMap.get(eachAgree.PBM_FAF__c).LastModifiedDate));    
                    }else{
                        wrapper_fieldValueList.add(new fieldValueWrapper(fieldsMap.get(eachField).Field_Label__c,fieldsMap.get(eachField).FAF_Object_Name__c, agValue, fafValue,true,true,fafMap.get(eachAgree.PBM_FAF__c).LastModifiedBy.Name,fafMap.get(eachAgree.PBM_FAF__c).LastModifiedDate));    
                    }                    
                } 
            }
            
            //Validate update agreement and send email
            boolean sendEmail = false;
            boolean updateAgree = false;
            
            if(agreeMap.get(eachAgree.id).FAF_Data_Sync__c){
                if(!fafDataSync){
                    agreeMap.get(eachAgree.id).FAF_Data_Sync__c = false;
                    sendEmail = true;
                    updateAgree = true;
                }
            }else{
                if(fafDataSync){
                    agreeMap.get(eachAgree.id).FAF_Data_Sync__c = true;
                    updateAgree = true;
                }else{
                    sendEmail = true;
                }
            }    
                                    
            //Update Agreement data sync field
            if(updateAgree){
                try {
                    update agreeMap.get(eachAgree.id);
                    //Insert contract change summaries
                    if(IsBatchJob){
                        Contract_Change_Summary__c insertChangeSummary = new Contract_Change_Summary__c();
                        insertChangeSummary.FAF_ID__c = agreeMap.get(eachAgree.id).PBM_FAF__c;
                        insertChangeSummary.Agreement_ID__c = agreeMap.get(eachAgree.id).Id;
                        PBS_Agreement_Extension__c agreeExt = agreeMap.get(eachAgree.id).PBS_Agreement_Extensions__r;
                        if(agreeExt != null){
                            insertChangeSummary.Agreement_Extension_ID__c = agreeExt.id;
                        }
                        insertChangeSummary.Original_Doc_Generation_Date__c = agreeMap.get(eachAgree.id).Master_Document_Generation_Date__c;
                        insertChangeSummary.FAF_Fields_Used_In_Doc__c = fieldsMap.size();
                        insertChangeSummary.Change_Check_Date__c = system.now();
                        insertChangeSummary.Change_Indicator__c = false;
                        insertChangeSummary.Field_Values_Changed__c = changeField_map.size();
                        insert insertChangeSummary;
                        if(Test.isRunningTest()){
                            if(agreeMap.get(eachAgree.id).Name == 'test agreement for batch job test class'){
                                wrapper_errors_map.put(eachAgree.id,'Test batch job error for test class');    
                            }
                        }
                    }
                    
                } catch(DmlException e) {
                    wrapper_errors_map.put(eachAgree.id,e.getMessage());
                    sendEmail = false;
                }
            }
            
            
            //Check for Document Generation Date
            if(agreeMap.get(eachAgree.Id).Master_Document_Generation_Date__c == null){
                sendEmail = false;
            }
            
            if(IsBatchJob || IsForceRun){
            }else{
                sendEmail = false;
            }
            
            //Sending of Email
            if(sendEmail){
                //Create Email body parameters Parameters
                String paralegal = agreeMap.get(eachAgree.id).Paralegal__r.Name;
                String atty = agreeMap.get(eachAgree.id).Attorney__r.Name;
                string fafLink = '<a href="' + URL.getSalesforceBaseUrl().toExternalForm() + '/' + eachAgree.PBM_FAF__c + '">' + eachAgree.PBM_FAF__r.Name + '</a>';
                String agLink = '<a href="' + URL.getSalesforceBaseUrl().toExternalForm() + '/' + eachAgree.id + '">' + 'here' + '</a>';
                String Param1 = 'Hi <b>' + atty + '/' + paralegal + '</b> :';
                String docDate = eachAgree.Master_Document_Generation_Date__c.format('MM/dd/yyyy HH:mm:ss');
                String Param2 = 'The ' + '<strong>' + eachAgree.Name + '</strong>' + ' was generated on ' + '<strong>' + docDate + '</strong>' + '. ' + System.Label.changeDashboardEmailBody;
                String Param3 = 'Click ' + agLink + ' for the agreement record.'; 
                String body='';
                body += '<html><body>';
                body += '<p>' + param2 + '</p>';
                body += '<br/>';
                body += param3;
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
                if(agreeMap.get(eachAgree.id).Attorney__r.Email != null){
                    email.add(agreeMap.get(eachAgree.id).Attorney__r.Email);
                }
                
                if(agreeMap.get(eachAgree.id).Paralegal__r.Email != null){
                    email.add(agreeMap.get(eachAgree.id).Paralegal__r.Email);
                }
                if(agreeMap.get(eachAgree.id).Owner.Email != null){
                    email.add(agreeMap.get(eachAgree.id).Owner.Email);
                }
                if(email.IsEmpty()){
                    email.add('Karen.Kohl@CVSHealth.com');
                }
                                
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                if (owea.size() > 0 ) {
                    mail.setOrgWideEmailAddressId(owea.get(0).Id);
                }
                mail.setToAddresses(email);
                if(IsForceRun){
                    String[] ccAddresses = new String[] {UserInfo.getUserEmail(),'ryan.francis.m.roque@accenture.com'};
                    mail.setccAddresses(ccAddresses);                    
                }
                mail.setSubject(System.Label.changeDashboardEmailSubject + ' ' + agreeMap.get(eachAgree.id).Name);
                mail.setHtmlBody(body);
                Messaging.sendEmail(new Messaging.Singleemailmessage [] {mail});    
            }
             
        }
        
        if(!IsBatchJob && agreementId != null){
            changeDashboardWrapper.wrapperClass2 p1 = changeDashboardWrapper.viewReconcileHist2(agreementId, null);
            changeDashboardWrapper.wrapperClass2 p2 = changeDashboardWrapper.viewReconcileHist2(agreementId, 'printRecAg');
            changeDashboardWrapper.wrapperClass2 p3 = changeDashboardWrapper.viewReconcileHist2(agreementId, 'printRecDoc');
                        
            returnwrapperClass.fieldChangeLogList = p1.contractFieldChangeLogList;
            returnwrapperClass.recAgreeList = p2.contractFieldChangeLogList;
            returnwrapperClass.recDocuList = p3.contractFieldChangeLogList;
        }
                
        returnwrapperClass.fieldValueList = wrapper_fieldValueList;
        returnwrapperClass.errors_map = wrapper_errors_map;
        returnwrapperClass.isSync = wrapper_isSync;
        returnwrapperClass.AgName = wrapper_AgName;
        returnwrapperClass.NoOfMismatch = wrapper_NoOfMismatch;
        return returnwrapperClass;    
    }
    
    @AuraEnabled
    public static String reconcile(String fieldValParam, String AgreementId, Integer NoOfMismatch){
        //Collect fields from custom settings
        map<string,changeDashboardFields__c> fieldsMap = new map<string,changeDashboardFields__c>();
        for(changeDashboardFields__c eachFieldRec : [SELECT Id, Name, AgreementExt_Field_API__c, 
                                                     FAF_Field_API__c,FAF_object_API_Name__c, Field_Label__c, Field_Type__c, FAF_Object_Relationship__c, FAF_Object_Name__c                                      
                                                     FROM changeDashboardFields__c WHERE Active__c = true AND FAF_object_API_Name__c != 'PBMRequest__c' ORDER BY Field_Label__c ASC]){
                                                         fieldsMap.put(eachFieldRec.Field_Label__c,eachFieldRec);
                                                     }
            
        //Collect Agreement and Agreemenent extension record
        map<id,Apttus__APTS_Agreement__c> agreeMap = new map<id,Apttus__APTS_Agreement__c>([SELECT Id, PBM_FAF__c, PBM_FAF__r.Name,
                                                     Paralegal__r.Name, Attorney__r.Name, Name,  Attorney__r.Email, Paralegal__r.Email, 
                                                     FAF_Data_Sync__c, Master_Document_Generation_Date__c,                                      
                                                     (SELECT id FROM PBS_Agreement_Extensions__r LIMIT 1)                                      
                                                     FROM Apttus__APTS_Agreement__c WHERE Id =:AgreementId]);
        
        Contract_Change_Summary__c insertChangeSummary = new Contract_Change_Summary__c();
        insertChangeSummary.FAF_ID__c = agreeMap.get(AgreementId).PBM_FAF__c;
        insertChangeSummary.Agreement_ID__c = agreeMap.get(AgreementId).Id;
        PBS_Agreement_Extension__c agreeExt = agreeMap.get(AgreementId).PBS_Agreement_Extensions__r;
        if(agreeExt != null){
            insertChangeSummary.Agreement_Extension_ID__c = agreeExt.id;
        }
        insertChangeSummary.Original_Doc_Generation_Date__c = agreeMap.get(AgreementId).Master_Document_Generation_Date__c;
        insertChangeSummary.FAF_Fields_Used_In_Doc__c = fieldsMap.size();
        insertChangeSummary.Sync_Date__c = system.now();
        insertChangeSummary.Field_Values_Changed__c = NoOfMismatch;
        insert insertChangeSummary;
        
        String recfieldValue = AgreementId + '-';
        if(insertChangeSummary != null){
            List<fieldValueWrapper> fiedValList = (List<fieldValueWrapper>) JSON.deserialize(fieldValParam, List<fieldValueWrapper>.class);
            list<Contract_Field_Change_Log__c> insertFieldChangeLogList = new list<Contract_Field_Change_Log__c>(); 
            for(fieldValueWrapper eachFiedlVal : fiedValList){
                recfieldValue += eachFiedlVal.fieldlabel + '-';
                
                Contract_Field_Change_Log__c insertFieldChangeLog = new Contract_Field_Change_Log__c();
                insertFieldChangeLog.Agreement_Extension_Field_Name__c = eachFiedlVal.fieldlabel;
                insertFieldChangeLog.Agreement_Extension_Field_Value__c = eachFiedlVal.agreeValue;
                insertFieldChangeLog.Source_Data_Field_Value__c = eachFiedlVal.fafValue;
                insertFieldChangeLog.Reconcile_to_Agreement__c =  eachFiedlVal.recToAgree;
                insertFieldChangeLog.Reconcile_to_Document__c = eachFiedlVal.recToDoc;
                insertFieldChangeLog.Source_Data_Object_Name__c = eachFiedlVal.fafObject;
                if(eachFiedlVal.recToDoc){
                    insertFieldChangeLog.Reconcile_Unreconcile_Doc_By__c = UserInfo.getUserId();
                    insertFieldChangeLog.Reconcile_Unreconcile_Doc_Date__c = system.now();
                }
                insertFieldChangeLog.CC_Summary_ID__c = insertChangeSummary.Id;
                insertFieldChangeLog.Agreement__c = AgreementId;
                insertFieldChangeLog.FAF_Updated_By__c = eachFiedlVal.fafModifiedBy;
                insertFieldChangeLog.FAF_Update_Date__c = eachFiedlVal.fafModifiedDt;
                insertFieldChangeLogList.add(insertFieldChangeLog);
                if(eachFiedlVal.recToAgree){
                    if(fieldsMap.get(eachFiedlVal.fieldlabel).Field_Type__c == 'Checkbox'){
                        agreeExt.put(fieldsMap.get(eachFiedlVal.fieldlabel).AgreementExt_Field_API__c,Boolean.valueOf(eachFiedlVal.fafValue));  
                    }else if(fieldsMap.get(eachFiedlVal.fieldlabel).Field_Type__c == 'Percent'){
                        agreeExt.put(fieldsMap.get(eachFiedlVal.fieldlabel).AgreementExt_Field_API__c,Decimal.valueOf(eachFiedlVal.fafValue));
                    }else{
                        agreeExt.put(fieldsMap.get(eachFiedlVal.fieldlabel).AgreementExt_Field_API__c,eachFiedlVal.fafValue);  
                    }
                }
            }
            if(insertFieldChangeLogList.size()>0){
                insert insertFieldChangeLogList;
            }
            if(agreeExt != null){
                update agreeExt;
            }
        }
        return recfieldValue;
    }
            
    @AuraEnabled
    public static String updateReconcile2(String fieldValParam, id agreementId){
        List<fieldValueWrapper2> fiedValList2 = (List<fieldValueWrapper2>) JSON.deserialize(fieldValParam, List<fieldValueWrapper2>.class);    
        set<id> contFieldLogIds = new set<id>(); 
        for(fieldValueWrapper2 eachFiedlVal : fiedValList2){
            if(eachFiedlVal.fafObject2 != 'PBM Request'){
              contFieldLogIds.add(eachFiedlVal.fieldLogRecId);  
            }            
        }
        map<id,Contract_Field_Change_Log__c> contFieldChangeLogMap = new map<id,Contract_Field_Change_Log__c>([SELECT id, Reconcile_to_Document__c, 
                                                                                                               Reconcile_Unreconcile_Doc_By__c,
                                                                                                               Reconcile_Unreconcile_Doc_Date__c 
                                                                                                               FROM Contract_Field_Change_Log__c 
                                                                                                               WHERE id IN :contFieldLogIds]);
        
        list<Contract_Field_Change_Log__c> insertFieldChangeLogList = new list<Contract_Field_Change_Log__c>();
        list<Contract_Field_Change_Log__c> updateFieldChangeLogList = new list<Contract_Field_Change_Log__c>();
        if(contFieldChangeLogMap.size()> 0){
            for(fieldValueWrapper2 eachFiedlVal : fiedValList2){
                if(eachFiedlVal.fafObject2 != 'PBM Request'){
                    if(eachFiedlVal.recToDoc2 != contFieldChangeLogMap.get(eachFiedlVal.fieldLogRecId).Reconcile_to_Document__c){
                        contFieldChangeLogMap.get(eachFiedlVal.fieldLogRecId).Reconcile_to_Document__c = eachFiedlVal.recToDoc2;               
                        contFieldChangeLogMap.get(eachFiedlVal.fieldLogRecId).Reconcile_Unreconcile_Doc_By__c = UserInfo.getUserId();
                        contFieldChangeLogMap.get(eachFiedlVal.fieldLogRecId).Reconcile_Unreconcile_Doc_Date__c = system.now();
                        updateFieldChangeLogList.add(contFieldChangeLogMap.get(eachFiedlVal.fieldLogRecId));
                    }    
                }            
            }    
        }
        
        
        if(updateFieldChangeLogList.size()>0){
            update updateFieldChangeLogList;
        }
                
        boolean doInsertPBMReq = false;
        integer mismatchCount = 0;
        for(fieldValueWrapper2 eachFiedlVal : fiedValList2){
            if(eachFiedlVal.fafObject2 == 'PBM Request' && eachFiedlVal.recToDoc2){
                doInsertPBMReq = true;
                mismatchCount = mismatchCount + 1;
            }
        }
    
        //Collect fields from custom settings
        map<string,changeDashboardFields__c> fieldsMap = new map<string,changeDashboardFields__c>();
        for(changeDashboardFields__c eachFieldRec : [SELECT Id, Name, AgreementExt_Field_API__c, 
                                                     FAF_Field_API__c,FAF_object_API_Name__c, Field_Label__c, Field_Type__c, FAF_Object_Relationship__c, FAF_Object_Name__c                                      
                                                     FROM changeDashboardFields__c WHERE Active__c = true AND FAF_object_API_Name__c = 'PBMRequest__c' ORDER BY Field_Label__c ASC]){
                                                         fieldsMap.put(eachFieldRec.Field_Label__c,eachFieldRec);
                                                     }
        //Collect Agreement and Agreemenent extension record
        map<id,Apttus__APTS_Agreement__c> agreeMap = new map<id,Apttus__APTS_Agreement__c>([SELECT Id, PBM_FAF__c, PBM_FAF__r.Name,
                                                                                            Paralegal__r.Name, Attorney__r.Name, Name,  Attorney__r.Email, Paralegal__r.Email, 
                                                                                            FAF_Data_Sync__c, Master_Document_Generation_Date__c,                                      
                                                                                            (SELECT id, Vaccine_service__c FROM PBS_Agreement_Extensions__r LIMIT 1)                                      
                                                                                            FROM Apttus__APTS_Agreement__c WHERE Id =:agreementId]);
        
        
        PBS_Agreement_Extension__c agreeExt = agreeMap.get(agreementId).PBS_Agreement_Extensions__r;
                
        id changeSummaryId = null;
        if(doInsertPBMReq){
            Contract_Change_Summary__c insertChangeSummary = new Contract_Change_Summary__c();
            insertChangeSummary.FAF_ID__c = agreeMap.get(agreementId).PBM_FAF__c;
            insertChangeSummary.Agreement_ID__c = agreeMap.get(agreementId).Id;
            
            if(agreeExt != null){
                insertChangeSummary.Agreement_Extension_ID__c = agreeExt.id;
            }
            insertChangeSummary.Original_Doc_Generation_Date__c = agreeMap.get(agreementId).Master_Document_Generation_Date__c;
            insertChangeSummary.FAF_Fields_Used_In_Doc__c = fieldsMap.size();
            insertChangeSummary.Sync_Date__c = system.now();
            insertChangeSummary.Field_Values_Changed__c = mismatchCount;
            insert insertChangeSummary;
            changeSummaryId = insertChangeSummary.Id;
        }
            
        for(fieldValueWrapper2 eachFiedlVal : fiedValList2){
            if(eachFiedlVal.fafObject2 == 'PBM Request' && eachFiedlVal.recToDoc2){                
                Contract_Field_Change_Log__c insertFieldChangeLog = new Contract_Field_Change_Log__c();
                insertFieldChangeLog.Agreement_Extension_Field_Name__c = eachFiedlVal.fieldlabel2;
                insertFieldChangeLog.Agreement_Extension_Field_Value__c = eachFiedlVal.agreeValue2;
                insertFieldChangeLog.Source_Data_Field_Value__c = eachFiedlVal.fafValue2;
                insertFieldChangeLog.Reconcile_to_Agreement__c =  true;
                insertFieldChangeLog.Reconcile_to_Document__c = eachFiedlVal.recToDoc2;
                insertFieldChangeLog.Source_Data_Object_Name__c = eachFiedlVal.fafObject2;
                if(eachFiedlVal.recToDoc2){
                    insertFieldChangeLog.Reconcile_Unreconcile_Doc_By__c = UserInfo.getUserId();
                    insertFieldChangeLog.Reconcile_Unreconcile_Doc_Date__c = system.now();
                }
                insertFieldChangeLog.CC_Summary_ID__c = changeSummaryId;
                insertFieldChangeLog.Agreement__c = agreementId;
                insertFieldChangeLog.FAF_Updated_By__c = eachFiedlVal.fafModifiedBy2;
                insertFieldChangeLog.FAF_Update_Date__c = eachFiedlVal.fafModifiedDt2;
                insertFieldChangeLogList.add(insertFieldChangeLog);
                
                if(fieldsMap.get(eachFiedlVal.fieldlabel2).Field_Type__c == 'Checkbox'){
                    agreeExt.put(fieldsMap.get(eachFiedlVal.fieldlabel2).AgreementExt_Field_API__c,Boolean.valueOf(eachFiedlVal.fafValue2));  
                }else if(fieldsMap.get(eachFiedlVal.fieldlabel2).Field_Type__c == 'Percent'){
                    agreeExt.put(fieldsMap.get(eachFiedlVal.fieldlabel2).AgreementExt_Field_API__c,Decimal.valueOf(eachFiedlVal.fafValue2));
                }else{
                    agreeExt.put(fieldsMap.get(eachFiedlVal.fieldlabel2).AgreementExt_Field_API__c,eachFiedlVal.fafValue2);  
                }
        
            }            
        }
        
        if(insertFieldChangeLogList.size()>0){
            insert insertFieldChangeLogList;
        }
        
        if(agreeExt != null && doInsertPBMReq){
            update agreeExt;
        }            
        string recfieldValue = null;
        return recfieldValue;                    
    }
       
    @AuraEnabled
    public static wrapperClass2 viewReconcileHist2(id agreementId, string filter){
        list<Contract_Field_Change_Log__c> retfieldLogList = new list<Contract_Field_Change_Log__c>();
        wrapperClass2 returnwrapperClass2 = new  wrapperClass2 ();
        List<fieldValueWrapper2> wrapper_fieldValueList2 = new List<fieldValueWrapper2>();
        string query = 'SELECT Agreement_Extension_Field_Name__c, Agreement_Extension_Field_Value__c, Reconcile_to_Agreement__c, ';
              query += 'Reconcile_to_Document__c,CC_Summary_ID__c, Agreement__c,CreatedDate, CreatedBy.Name, Source_Data_Field_Value__c, ';
              query += 'Reconcile_Unreconcile_Doc_By__c,Reconcile_Unreconcile_Doc_Date__c, Reconcile_Unreconcile_Doc_By__r.Name, Source_Data_Object_Name__c,FAF_Updated_By__c,FAF_Update_Date__c ';
        if(filter=='printRecAg'){
            query += 'FROM Contract_Field_Change_Log__c WHERE Reconcile_to_Agreement__c = true AND Agreement__c =:agreementId ORDER BY Agreement_Extension_Field_Name__c,CreatedDate';
        }else if(filter=='printRecDoc'){
            query += 'FROM Contract_Field_Change_Log__c WHERE Reconcile_to_Document__c = true AND Agreement__c =:agreementId ORDER BY Agreement_Extension_Field_Name__c,CreatedDate';
        }else if(filter=='viewUpdtLegalDoc'){
            query += 'FROM Contract_Field_Change_Log__c WHERE Reconcile_to_Document__c = false AND Agreement__c =:agreementId ORDER BY Source_Data_Object_Name__c ASC, Agreement_Extension_Field_Name__c ASC, FAF_Update_Date__c DESC';            
        }else{
            query += 'FROM Contract_Field_Change_Log__c WHERE Agreement__c =:agreementId ORDER BY Source_Data_Object_Name__c ASC, Agreement_Extension_Field_Name__c ASC, CreatedDate DESC';
        }
        retfieldLogList = database.query(query);
        
        for(Contract_Field_Change_Log__c eachFieldLog : retfieldLogList){
            wrapper_fieldValueList2.add(new fieldValueWrapper2(eachFieldLog.Agreement_Extension_Field_Name__c,eachFieldLog.Source_Data_Object_Name__c, eachFieldLog.Source_Data_Field_Value__c, eachFieldLog.Agreement_Extension_Field_Value__c, false,false,eachFieldLog.FAF_Updated_By__c,eachFieldLog.FAF_Update_Date__c,eachFieldLog.Id));
        }
        
        changeDashboardWrapper.wrapperClass2 processCompare = changeDashboardWrapper.compareAgreementExtVspbmReq(agreementId, false, false);
        if(processCompare.fieldValueList2 != null){
            for(fieldValueWrapper2 eachFiedlVal : processCompare.fieldValueList2){
                wrapper_fieldValueList2.add(eachFiedlVal);
            }            
        }
    
        returnwrapperClass2.fieldValueList2 = wrapper_fieldValueList2;
        returnwrapperClass2.contractFieldChangeLogList = retfieldLogList;
        return returnwrapperClass2;        
    }
    
    
    @AuraEnabled
    public static boolean checkLegalDocSync(id agreementId){
        boolean docSync_yn;
        Apttus__APTS_Agreement__c checkAgDocSync = [SELECT id, FAF_Data_Sync__c, Legal_Doc_data_sync__c 
                                                    FROM Apttus__APTS_Agreement__c WHERE id =:agreementId LIMIT 1];
        docSync_yn = checkAgDocSync.Legal_Doc_data_sync__c;
        if(!checkAgDocSync.FAF_Data_Sync__c && checkAgDocSync.Legal_Doc_data_sync__c){         
            docSync_yn = false;
        }else if(checkAgDocSync.FAF_Data_Sync__c){
            list<Contract_Field_Change_Log__c> retfieldLogList = [SELECT id, Reconcile_to_Document__c 
                                                    FROM Contract_Field_Change_Log__c WHERE Agreement__c =:agreementId
                                                    AND Reconcile_to_Document__c = false LIMIT 1];                                    
            if(checkAgDocSync.Legal_Doc_data_sync__c && !retfieldLogList.isEmpty()){                
                docSync_yn = false;
            }else if(!checkAgDocSync.Legal_Doc_data_sync__c && retfieldLogList.isEmpty()){                                
                docSync_yn = true;                                
            }
        }
        if(checkAgDocSync.Legal_Doc_data_sync__c != docSync_yn){
            checkAgDocSync.Legal_Doc_data_sync__c = docSync_yn;
          update checkAgDocSync;    
        }        
        return docSync_yn;
    }
            
                
    @AuraEnabled
    public static wrapperClass2 compareAgreementExtVspbmReq(id agreementId, boolean sendEmail, boolean updateAgreement){
        wrapperClass2 returnwrapperClass2 = new  wrapperClass2 ();
        List<fieldValueWrapper2> wrapper_fieldValueList2 = new List<fieldValueWrapper2>();
                        
        //Collect fields from custom settings
        map<string,changeDashboardFields__c> fieldsMap2 = new map<string,changeDashboardFields__c>();
        for(changeDashboardFields__c eachFieldRec : [SELECT Id, Name, AgreementExt_Field_API__c, 
                                                     FAF_Field_API__c,FAF_object_API_Name__c, Field_Label__c, Field_Type__c, FAF_Object_Relationship__c, FAF_Object_Name__c                                      
                                                     FROM changeDashboardFields__c WHERE Active__c = true AND FAF_object_API_Name__c = 'PBMRequest__c' ORDER BY Field_Label__c ASC]){
                                                         fieldsMap2.put(eachFieldRec.Field_Label__c,eachFieldRec);
                                                     }
        
        //Collect Agreement and Agreemenent extension record
        map<id,Apttus__APTS_Agreement__c> agreeMap2 = new map<id,Apttus__APTS_Agreement__c>([SELECT Id, PBM_FAF__c, PBM_FAF__r.Name,
                                                                                            Paralegal__r.Name, Attorney__r.Name, Name,  Attorney__r.Email, Paralegal__r.Email, Owner.Email,
                                                                                            FAF_Data_Sync__c, Master_Document_Generation_Date__c, Legal_Doc_data_sync__c,                                       
                                                                                            (SELECT id,Pass_MAF__c,Client_Name__c,Segment__c, Adjudicate_at_Actual_Package_Size__c,
                                                                                             Admin_Fee_Billing__c, Claim_Billing__c, Billing_Admin_Payment_Terms__c,
                                                                                             Additional_Admin_Fee_Payment_Term_Info__c, Billing_Claim_Payment_Terms__c,
                                                                                             Additional_Claim_Payment_Term_Info__c, Rebate_RTMD__c, CVS_Share__c,
                                                                                             Days_Written_Notice_Before_Termination__c, ERISA_NON_ERISA__c, Performance_Guarantee__c,
                                                                                             Appeals__c, Maintenance_choice__c, Medicare_Subsidy__c, Transform_Diabetic_care_program__c,
                                                                                             Extracare_Healthcard__c, Frequency_1__c, Pharmacy_Audit_Retention__c, Pharmacy_Benefit__c,
                                                                                             Rebate_Contract_Type__c, Specialty_Rebates__c, Market_Check__c,
                                                                                             Term_Without_Cause__c,Vaccine_service__c, Preventive_Care_Drug_Program__c FROM PBS_Agreement_Extensions__r LIMIT 1)                                      
                                                                                            FROM Apttus__APTS_Agreement__c WHERE Id =:agreementId]);
        
        
        //Collect Agreement and Agreemenent extension record
        map<id,PBMRequest__c> pbmReqMap = new map<id,PBMRequest__c>([SELECT Id, Agreement__c, Agreement__r.Name, Vaccine_Services__c, LastModifiedBy.Name,LastModifiedDate, FAF__c, 
                                                                     FAF__r.Name, Name, Preventive_Care_Drug_Program__c, Market_Check__c                                                                                                       
                                                                     FROM PBMRequest__c WHERE Agreement__c =:agreementId LIMIT 1]);
                        
        for(PBMRequest__c eachPBMReq : pbmReqMap.values()){
            //Compare Agreement and FAF fields
            string fieldTR = '';
            string agExtValue;
            string pbmReqValue;
            boolean isSync = true;
            integer NoOfMismatch = 0;
            list<Apttus__APTS_Agreement__c> agreementList = new list<Apttus__APTS_Agreement__c>();            
            for(string eachField : fieldsMap2.keyset()){
                //Get Agreement Extension value
                agExtValue = '';
                PBS_Agreement_Extension__c agreeExt = agreeMap2.get(eachPBMReq.Agreement__c).PBS_Agreement_Extensions__r;
                if(agreeExt != null){
                    if(agreeExt.get(fieldsMap2.get(eachField).AgreementExt_Field_API__c) == null || agreeExt.get(fieldsMap2.get(eachField).AgreementExt_Field_API__c) == 'null'){
                        agExtValue = 'Blank';
                    }else{
                        agExtValue = string.valueOf(agreeExt.get(fieldsMap2.get(eachField).AgreementExt_Field_API__c));
                    }
                }
                
                //Get PBM Req Value
                pbmReqValue = pbmReqMap.get(eachPBMReq.id).get(fieldsMap2.get(eachField).FAF_Field_API__c) == null ? 'Blank' : string.valueOf(pbmReqMap.get(eachPBMReq.id).get(fieldsMap2.get(eachField).FAF_Field_API__c));
                                
                //Compare Agreement and FAF value
                if(agExtValue!=pbmReqValue){
                    isSync = false;
                    NoOfMismatch = NoOfMismatch + 1;                
                    fieldTR += '<tr>';
                    fieldTR += '<td align="center">' + fieldsMap2.get(eachField).Field_Label__c + '</td>';
                    fieldTR += '<td align="center">' + agExtValue + '</td>';
                    fieldTR += '<td align="center">' + pbmReqValue + '</td>';
                    fieldTR += '</tr>';
                    if(!test.isRunningTest()){
                        wrapper_fieldValueList2.add(new fieldValueWrapper2(fieldsMap2.get(eachField).Field_Label__c,fieldsMap2.get(eachField).FAF_Object_Name__c, pbmReqValue, agExtValue,false,false,pbmReqMap.get(eachPBMReq.id).LastModifiedBy.Name,pbmReqMap.get(eachPBMReq.id).LastModifiedDate,eachPBMReq.id));
                    }else{
                        wrapper_fieldValueList2.add(new fieldValueWrapper2(fieldsMap2.get(eachField).Field_Label__c,fieldsMap2.get(eachField).FAF_Object_Name__c, pbmReqValue, agExtValue,true,true,pbmReqMap.get(eachPBMReq.id).LastModifiedBy.Name,pbmReqMap.get(eachPBMReq.id).LastModifiedDate,eachPBMReq.id));
                    }                                                                    
                }                                
            }
            
            if(!isSync && updateAgreement){
                agreeMap2.get(eachPBMReq.Agreement__c).Legal_Doc_data_sync__c = false;                
              update agreeMap2.get(eachPBMReq.Agreement__c);            
            }
            
            if(!isSync && sendEmail){
                //Create Email body parameters Parameters
                String paralegal = agreeMap2.get(eachPBMReq.Agreement__c).Paralegal__r.Name;
                String atty = agreeMap2.get(eachPBMReq.Agreement__c).Attorney__r.Name;
                string agreementLink = '<a href="' + URL.getSalesforceBaseUrl().toExternalForm() + '/' + eachPBMReq.Agreement__c + '">' + eachPBMReq.Agreement__r.Name + '</a>';
                String pbmReqLink = '<a href="' + URL.getSalesforceBaseUrl().toExternalForm() + '/' + eachPBMReq.id + '">' + eachPBMReq.Name + '</a>';
                String Param1 = 'Hi <b>' + atty + '/' + paralegal + '</b> :';
                String docDate = agreeMap2.get(eachPBMReq.Agreement__c).Master_Document_Generation_Date__c.format('MM/dd/yyyy HH:mm:ss');
                String Param2 = 'The PBM Contract Request data for Agreement Record ' + agreementLink + ' has been changed, and any legal document generated is now not in synch with the PBM Contract Request data. Changes are noted below and also displayed in the Change Dashboard. Please click the Agreement Record link below to manually sync the data from within the Agreement Record. You will need to update the legal document.';                     
                String body='';
                body += '<html><body>';
                body += Param1;
                body += '<br/>';
                body += '<br/>';
                body += Param2;
                body += '<br/>';
                body += '<br/>';
                body += '<table border="1" width = "100%">';
                body += '<tr><th bgcolor="yellow">Field Label</th>';
                body += '<th bgcolor="yellow">Prior PBM Contract Request Value</th>';
                body += '<th bgcolor="yellow">New PBM Contract Request Value</th></tr>';
                body += '<tr><th bgcolor="yellow"></th>';
                body += '<th bgcolor="yellow">(' + agreementLink + ')</th>';
                body += '<th bgcolor="yellow">(' + pbmReqLink + ')</th></tr>';
                body += fieldTR;
                body += '</table>';
                body += '<br/>';
                body += '<br/>';
                body += '--- Please do not reply ---';
                body += '</body></html>';
                                
                list<String> email = new list<String>();
                if(agreeMap2.get(eachPBMReq.Agreement__c).Attorney__r.Email != null){
                    email.add(agreeMap2.get(eachPBMReq.Agreement__c).Attorney__r.Email);
                }
                
                if(agreeMap2.get(eachPBMReq.Agreement__c).Paralegal__r.Email != null){
                    email.add(agreeMap2.get(eachPBMReq.Agreement__c).Paralegal__r.Email);
                }
                if(email.IsEmpty()){
                    email.add('Karen.Kohl@CVSHealth.com');
                }
                                
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where DisplayName = 'CVS Official (Do Not Reply)'];
                if (owea.size() > 0 ) {
                    mail.setOrgWideEmailAddressId(owea.get(0).Id);
                }
                
                mail.setToAddresses(email);                
                String[] ccAddresses = new String[] {UserInfo.getUserEmail(),'ryan.francis.m.roque@accenture.com'};
                mail.setccAddresses(ccAddresses);                    
                
                mail.setSubject('PBM Request data modified for the Agreement ' + agreeMap2.get(eachPBMReq.Agreement__c).Name);
                mail.setHtmlBody(body);
                Messaging.sendEmail(new Messaging.Singleemailmessage [] {mail});
            }
        }
                    
        returnwrapperClass2.fieldValueList2 = wrapper_fieldValueList2;
        return returnwrapperClass2; 
    }   
    
    public class wrapperClass{
        @AuraEnabled public Map<id, String> errors_map{get;set;}
        @AuraEnabled public List<fieldValueWrapper> fieldValueList{get;set;}
        @AuraEnabled public Boolean isSync{get;set;}
        @AuraEnabled public String AgName{get;set;}
        @AuraEnabled public Integer NoOfMismatch{get;set;}
        @AuraEnabled public List<Contract_Field_Change_Log__c> fieldChangeLogList{get;set;}
        @AuraEnabled public List<Contract_Field_Change_Log__c> recAgreeList{get;set;}
        @AuraEnabled public List<Contract_Field_Change_Log__c> recDocuList{get;set;}
    }
    
    public class fieldValueWrapper {
        @AuraEnabled
        public String fieldlabel{get;set;}
        @AuraEnabled
        public String fafObject{get;set;}
        @AuraEnabled
        public String agreeValue{get;set;}
        @AuraEnabled
        public String fafValue{get;set;}
        @AuraEnabled
        public Boolean recToAgree{get;set;}
        @AuraEnabled
        public Boolean recToDoc{get;set;}
        @AuraEnabled
        public String fafModifiedBy{get;set;}
        @AuraEnabled
        public DateTime fafModifiedDt{get;set;}
        
        public fieldValueWrapper(String fieldlabelTemp,String fafObjectTemp, String agreeValueTemp, String fafValueTemp, Boolean recToAgreeTemp,Boolean recToDocTemp, String fafModifiedByTemp, DateTime fafModifiedDtTemp) {
            fieldlabel = fieldlabelTemp;
            fafObject = fafObjectTemp;
            agreeValue = agreeValueTemp;
            fafValue = fafValueTemp;
            recToAgree = recToAgreeTemp;
            recToDoc = recToDocTemp;
            fafModifiedBy = fafModifiedByTemp;
            fafModifiedDt = fafModifiedDtTemp;
        }    
    }
    
    public class wrapperClass2{        
        @AuraEnabled public List<fieldValueWrapper2> fieldValueList2{get;set;}
        @AuraEnabled public List<Contract_Field_Change_Log__c> contractFieldChangeLogList{get;set;}       
    }
    
    public class fieldValueWrapper2 {
        @AuraEnabled
        public String fieldlabel2{get;set;}
        @AuraEnabled
        public String fafObject2{get;set;}
        @AuraEnabled
        public String agreeValue2{get;set;}
        @AuraEnabled
        public String fafValue2{get;set;}
        @AuraEnabled
        public Boolean recToAgree2{get;set;}
        @AuraEnabled
        public Boolean recToDoc2{get;set;}
        @AuraEnabled
        public String fafModifiedBy2{get;set;}
        @AuraEnabled
        public DateTime fafModifiedDt2{get;set;}
        @AuraEnabled
        public id fieldLogRecId{get;set;}
        
        public fieldValueWrapper2(String fieldlabelTemp,String fafObjectTemp,  String fafValueTemp, String agreeValueTemp, Boolean recToAgreeTemp,Boolean recToDocTemp, String fafModifiedByTemp, DateTime fafModifiedDtTemp, id fieldLogRecIdTemp) {
            fieldlabel2 = fieldlabelTemp;
            fafObject2 = fafObjectTemp;
            agreeValue2 = agreeValueTemp;
            fafValue2 = fafValueTemp;
            recToAgree2 = recToAgreeTemp;
            recToDoc2 = recToDocTemp;
            fafModifiedBy2 = fafModifiedByTemp;
            fafModifiedDt2 = fafModifiedDtTemp;
            fieldLogRecId = fieldLogRecIdTemp;
        }    
    }
    
}