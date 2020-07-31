public without sharing class pbmRequestHelper {
    
	public static void compareAgreementExtVspbmReq(Map<id,PBMRequest__c> pbmReqNewMap, Map<id,PBMRequest__c> pbmReqOldMap){
		set<id> agreementIds = new set<id>();
        for(PBMRequest__c eachPBMReq : pbmReqNewMap.values()){
            agreementIds.add(eachPBMReq.Agreement__c);
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
                                                                                            Paralegal__r.Name, Attorney__r.Name, Name,  Attorney__r.Email, Paralegal__r.Email, Owner.Email,
                                                                                            FAF_Data_Sync__c, Master_Document_Generation_Date__c, Legal_Doc_data_sync__c,                                       
                                                                                            (SELECT id,Pass_MAF__c,Client_Name__c,Segment__c, Adjudicate_at_Actual_Package_Size__c,
                                                                                             Admin_Fee_Billing__c, Claim_Billing__c, Billing_Admin_Payment_Terms__c,
                                                                                             Additional_Admin_Fee_Payment_Term_Info__c, Billing_Claim_Payment_Terms__c,
                                                                                             Additional_Claim_Payment_Term_Info__c, Rebate_RTMD__c, CVS_Share__c,
                                                                                             Days_Written_Notice_Before_Termination__c, ERISA_NON_ERISA__c, Performance_Guarantee__c,
                                                                                             Appeals__c, Maintenance_choice__c, Medicare_Subsidy__c, Transform_Diabetic_care_program__c,
                                                                                             Extracare_Healthcard__c, Frequency_1__c, Pharmacy_Audit_Retention__c, Pharmacy_Benefit__c,
                                                                                             Rebate_Contract_Type__c, Specialty_Rebates__c,
                                                                                             Term_Without_Cause__c,Vaccine_service__c FROM PBS_Agreement_Extensions__r LIMIT 1)                                      
                                                                                            FROM Apttus__APTS_Agreement__c WHERE Id =:agreementIds]);

		list<Apttus__APTS_Agreement__c> agList = new list<Apttus__APTS_Agreement__c>();
		boolean updateAttyParalegal;        
        for(PBMRequest__c eachPBMReq : pbmReqNewMap.values()){
            updateAttyParalegal = false;
            if (eachPBMReq.Paralegal__c != pbmReqOldMap.get(eachPBMReq.id).Paralegal__c) {
                agreeMap.get(eachPBMReq.Agreement__c).Paralegal__c = eachPBMReq.Paralegal__c;
                updateAttyParalegal = true;
            }
            if (eachPBMReq.Attorney__c != pbmReqOldMap.get(eachPBMReq.id).Attorney__c) {
                agreeMap.get(eachPBMReq.Agreement__c).Attorney__c = eachPBMReq.Attorney__c;
                updateAttyParalegal = true;
            }
            if(updateAttyParalegal){
                agList.add(agreeMap.get(eachPBMReq.Agreement__c));
            }
            if(agreeMap.get(eachPBMReq.Agreement__c).Master_Document_Generation_Date__c != null){
                boolean doCompare = false;
                for(string eachField : fieldsMap.keyset()){                   
                    if (eachPBMReq.get(fieldsMap.get(eachField).FAF_Field_API__c) != pbmReqOldMap.get(eachPBMReq.id).get(fieldsMap.get(eachField).FAF_Field_API__c)) {
                        doCompare = true;
                    }                                                
                }
                if(doCompare){
                	changeDashboardWrapper.wrapperClass2 processCompare = changeDashboardWrapper.compareAgreementExtVspbmReq(eachPBMReq.Agreement__c, true, false);    
                }                
            }else{
            	//Do Sync Agreement extension.....
            	PBS_Agreement_Extension__c agreeExt = new PBS_Agreement_Extension__c();
                if(eachPBMReq.Agreement__c != null){
                    agreeExt = agreeMap.get(eachPBMReq.Agreement__c).PBS_Agreement_Extensions__r.size() > 0 ? agreeMap.get(eachPBMReq.Agreement__c).PBS_Agreement_Extensions__r : null;                                         
                }             	
                for(string eachField : fieldsMap.keyset()){                   
                    if (eachPBMReq.get(fieldsMap.get(eachField).FAF_Field_API__c) != pbmReqOldMap.get(eachPBMReq.id).get(fieldsMap.get(eachField).FAF_Field_API__c)) {
                        if(fieldsMap.get(eachField).Field_Type__c == 'Checkbox'){
                            agreeExt.put(fieldsMap.get(eachField).AgreementExt_Field_API__c,Boolean.valueOf(eachPBMReq.get(fieldsMap.get(eachField).FAF_Field_API__c)));                          
                        }else{
                            agreeExt.put(fieldsMap.get(eachField).AgreementExt_Field_API__c,eachPBMReq.get(fieldsMap.get(eachField).FAF_Field_API__c));  
                        }
                    }                                                
                }
                if(eachPBMReq.Agreement__c != null && agreeExt != null){
                    update agreeExt;
                }
            }            
        }
        
        //if(agList.size() > 0){
        //    update agList;
        //}
    }
           
}