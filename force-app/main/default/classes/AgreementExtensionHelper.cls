public without sharing class AgreementExtensionHelper {
    public static void updateAgreementExt(list<PBS_Agreement_Extension__c> AgreementExtList, Boolean IsAfter, Boolean IsBefore, Boolean IsUpdate, Boolean IsInsert, Map<id,PBS_Agreement_Extension__c> oldAgreementExtMap){
        
        set<id> fafIds = new set<id>();
        for(PBS_Agreement_Extension__c eachEx : AgreementExtList){
            fafIds.add(eachEx.FAF_ID__c);
        }
        
       
        //Collect FAF and child objects
        map<id,Central_Hub__c> fafMap = new map<id,Central_Hub__c>([SELECT id, Name, Client_Name__c,Account_Name__r.iUMS_Client_Subtype__c,
                                                                    Account_Name__r.ERISA_NON_ERISA__c, Account_Name__r.Business_Unit__c, Segment__c,
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
                                                                     Additional_Admin_Fee_Payment_Term_Info__c, Additional_Claim_Payment_Term_Info__c FROM Billing_Ops__r LIMIT 1),
                                                                     (SELECT id, Type__c FROM Billing_Other_Payments__r WHERE Type__c = 'Audit Allowance' LIMIT 1)
                                                                    FROM Central_Hub__c WHERE id IN : fafIds]);
        
        for(PBS_Agreement_Extension__c updateEx : AgreementExtList){
            
            //system.assertequals(fafMap.get(updateEx.FAF_ID__c).Billing_Ops__r.size(),999);
            //Populate Rebate Definition
            if(updateEx.Pass_MAF__c){
                if(updateEx.Specialty_Rebates__c == 'Pass to Client'){
                    updateEx.Rebate_definition__c = 'MAF-TRUE, PASS TO CLIENT';
                }else{
                    updateEx.Rebate_definition__c = 'MAF-TRUE, DO NOT PASS TO CLIENT';
                }
            }else{
                if(updateEx.Specialty_Rebates__c == 'Pass to Client'){
                    updateEx.Rebate_definition__c = 'MAF-FALSE, PASS TO CLIENT';
                }else{
                    updateEx.Rebate_definition__c = 'MAF-FALSE, DO NOT PASS TO CLIENT';
                }
            }
            //Populate Claim Audit
            //new field will be created for POS rebate type that is a dropdown saying Type 1, 
            //Type 2 or Type 3 if RTMD = ‘true’. The value of new field will be copied in future, 
            //for now set value as Type 1
            if(IsBefore && IsInsert){
                if(updateEx.Rebate_RTMD__c){
                    updateEx.Claim_Audit__c = 'Type 1';  
                }else{
                    updateEx.Claim_Audit__c = 'No POS';
                }
            }else{
                 if(updateEx.Rebate_RTMD__c && updateEx.Claim_Audit__c == 'No POS'){
                     updateEx.Claim_Audit__c = 'Type 1';
                 }else if(!updateEx.Rebate_RTMD__c){
                     updateEx.Claim_Audit__c = 'No POS';
                 }
            }
            
            
            //Populate Vaccine Service
            //if(updateEx.Vaccine_Exclusion_Option__c == 'Program Vaccines' || updateEx.Mail_Guarantees_Vaccine_Option__c == 'Program Vaccines' || updateEx.Retail_Network_Guarantees_Vaccine_Option__c == 'Program Vaccines'){
              //updateEx.Vaccine_service__c = true;
            //}
            
            //Populate Pharmacy Audit programs
            if(updateEx.Pharmacy_Audit_Retention__c == 'Base (80/20)' || updateEx.Pharmacy_Audit_Retention__c == 'Base (100/0)' || updateEx.Pharmacy_Audit_Retention__c == 'Base (Custom)'){
                updateEx.Pharmacy_Audit_programs__c = 'Standard';
            }else if(updateEx.Pharmacy_Audit_Retention__c == 'Premier (75/25)' || updateEx.Pharmacy_Audit_Retention__c == 'Premier (Custom)'){
                updateEx.Pharmacy_Audit_programs__c = 'Premier';
            }
            
            
            if(IsBefore && IsUpdate){
                if(updateEx.Pharmacy_Audit_Retention__c != oldAgreementExtMap.get(updateEx.id).Pharmacy_Audit_Retention__c){
                    List<Billing_Operations__c> fafrec = fafMap.get(updateEx.FAF_ID__c).getSObjects('Billing_Ops__r');
                    if(fafrec.size()>0){
                        updateEx.CVS_Share__c = fafrec[0].CVS_Share__c;
                        updateEx.Client_Share__c = fafrec[0].Client_Share__c;
                        //fafrec[0].get(fieldsMap.get(eachField).FAF_Field_API__c)
                    }
                }
            }
            
            //updateEx.CVS_Share__c = fafrec[0].CVS_Share__c;
            //updateEx.Client_Share__c = fafrec[0].Client_Share__c;
            
            //Populate Audit CVS Share and Client Share in word
            String[] to_25 = new string[]{ 'zero', 'one',  'two', 'three', 'four',  'five',  'six',  
            'seven', 'eight', 'nine', 'ten',  'eleven', 'twelve', 'thirteen',  
            'fourteen', 'fifteen', 'sixteen', 'seventeen', 'eighteen', 'nineteen', 'twenty',
            'twenty one','twenty two','twenty three','twenty four', 'twenty five'};  
            updateEx.Audit_CVS_Share__c = updateEx.CVS_Share__c;
            integer CVSint = 0;
            if(updateEx.CVS_Share__c != null && updateEx.CVS_Share__c != 0 && integer.valueof(updateEx.CVS_Share__c) < 26){
                CVSint = integer.valueof(updateEx.CVS_Share__c);
                updateEx.CVS_Share_in_word__c = to_25[CVSint] + ' percent ' + '(' + CVSint + '%' + ')';
            }else{
                updateEx.CVS_Share_in_word__c = '';
            }
            integer ClientShareint = 0;
            if(updateEx.Client_Share__c != null && updateEx.Client_Share__c != 0 && integer.valueof(updateEx.Client_Share__c) < 26){
                ClientShareint = integer.valueof(updateEx.Client_Share__c);
                updateEx.Client_Share_in_word__c = to_25[ClientShareint] + ' percent ' + '(' + ClientShareint + '%' + ')';
            }else{
                updateEx.Client_Share_in_word__c = '';
            }
            
            //Populate Additional Admin Fee Payment Term Info/Additional Claim Payment Term Info
            if(updateEx.Billing_Admin_Payment_Terms__c != 'Non-Standard'){
                updateEx.Additional_Admin_Fee_Payment_Term_Info__c = '';
            }
            if(updateEx.Billing_Claim_Payment_Terms__c != 'Non-Standard'){
                updateEx.Additional_Claim_Payment_Term_Info__c = '';
            }

            //Populate Audit Credit
            if(IsBefore && IsInsert){
                if(updateEx.FAF_ID__c != null){
                    List<Contractual_Payments__c> fafrec = fafMap.get(updateEx.FAF_ID__c).getSObjects('Billing_Other_Payments__r');
                    if(fafrec!=null && !fafrec.isEmpty()){
                        updateEx.Audit_Credit__c = true;
                    }
                }
            }
            
            //Populate Exhibits
            //if(IsBefore && IsInsert){
                //FAF > Guarantee Info > Performance Guarantee
                If(updateEx.Performance_Guarantee__c){
                    updateEx.Exhibit_D__c = true;
                }else{
                    updateEx.Exhibit_D__c = false;
                }
                //if one of the records has following values in FAF > Clinical Operations > Clinical solutions > Clinical solution field
                //"1st Level Appeals"
                //"2nd Level Appeals"
                //"Urgent 1st Level Appeals with an IRO"
                If(updateEx.Appeals__c){
                    updateEx.Exhibit_E__c = true;
                }else{
                    updateEx.Exhibit_E__c = false;
                }
                //Loop through the object FAF > Network Operations > Network_Pricing__c for the given FAF ID
                //IF any one of the records have  Network_Name__c have values ‘MC(84-90)CP’, ‘MC(84-90)CVS’
                If(updateEx.Maintenance_choice__c){
                    updateEx.Exhibit_F__c = true;
                }else{
                    updateEx.Exhibit_F__c = false;
                }
                
                //Loop through the object FAF > Billing operations > Medicare_Part_D_Fees_Schedule__c for the given FAF ID
                //IF any one of the records have type__c = ‘subsidy’ 
                If(updateEx.Medicare_Subsidy__c){
                    updateEx.Exhibit_G__c = true;
                }else{
                    updateEx.Exhibit_G__c = false;
                }
                
                // From Request PBM contract screen flow
                If(updateEx.Preventive_Care_Drug_Program__c){
                    updateEx.Exhibit_H__c = true;
                }else{
                    updateEx.Exhibit_H__c = false;
                }
                
                // From Request PBM contract screen flow
                If(updateEx.Vaccine_service__c){
                    updateEx.Exhibit_I__c = true;
                }else{
                    updateEx.Exhibit_I__c = false;
                }    
                //if one the records has following values from FAF > Clinical Operation > Clinical solution > clinical solutions field
                //"Transform Diabetes Care (PEMPM Meter Fee)" 
                //"Transform Diabetes Care (PMPM Clinical Fee)"

                If(updateEx.Transform_Diabetic_care_program__c){
                    updateEx.Exhibit_J__c = true;
                }else{
                    updateEx.Exhibit_J__c = false;
                } 
                    
            //}
            
            
            
            //Populate Exhibit Letter
            Integer charCode = 67;
            List<Integer> chars = new List<Integer>{charCode};            
            If(updateEx.Exhibit_D__c){
                charCode = charCode + 1;
                chars = new List<Integer>{charCode};
                updateEx.Performance_Guarantees_Exhibit__c = String.fromCharArray(chars);
            }else{
                updateEx.Performance_Guarantees_Exhibit__c = '';
            }
            
            If(updateEx.Exhibit_E__c){
                charCode = charCode + 1;
                chars = new List<Integer>{charCode};
                updateEx.Appeals_Exhibit__c = String.fromCharArray(chars);
            }else{
                updateEx.Appeals_Exhibit__c = '';
            }
            
            If(updateEx.Exhibit_F__c){
                charCode = charCode + 1;
                chars = new List<Integer>{charCode};
                updateEx.Maintenance_Choice_Program_Exhibit__c = String.fromCharArray(chars);
            }else{
                updateEx.Maintenance_Choice_Program_Exhibit__c = '';
            }
            
             
            If(updateEx.Exhibit_G__c){
                charCode = charCode + 1;
                chars = new List<Integer>{charCode};
                updateEx.Medicare_Part_D_Subsidy_Exhibit__c = String.fromCharArray(chars);
            }else{
                updateEx.Medicare_Part_D_Subsidy_Exhibit__c = '';
            }
            
            // From Request PBM contract screen flow
            If(updateEx.Exhibit_H__c){
                charCode = charCode + 1;
                chars = new List<Integer>{charCode};
                updateEx.Preventive_Care_Drugs_Exhibit__c = String.fromCharArray(chars);
            }else{
                updateEx.Preventive_Care_Drugs_Exhibit__c = '';
            }
            
            If(updateEx.Exhibit_I__c){
                charCode = charCode + 1;
                chars = new List<Integer>{charCode};
                updateEx.Vaccine_Program_Terms_and_Conditions_Exh__c = String.fromCharArray(chars);
            }else{
                updateEx.Vaccine_Program_Terms_and_Conditions_Exh__c = '';
            }    
            
            If(updateEx.Exhibit_J__c){
                charCode = charCode + 1;
                chars = new List<Integer>{charCode};
                updateEx.Transform_Diabetes_Care_Program_Exhibit__c = String.fromCharArray(chars);
            }else{
                updateEx.Transform_Diabetes_Care_Program_Exhibit__c = '';
            }
        }
    }

    public static void populateAgreementSFSJunctionObject(Map<id,sObject> newRecordsMap/*, Map<id,sObject> oldRecordsMap*/){
        
        Map<id,PBS_Agreement_Extension__c> fafMap = new Map<id,PBS_Agreement_Extension__c> ();
        //Map<id,id> fafMap = new Map<id,id> ();
        list<Agreement_extension_SFS_Junction__c> agreementExtSFSJuncList = new list<Agreement_extension_SFS_Junction__c>();
        system.debug(newRecordsMap);
        //system.debug(oldRecordsMap);
            for(Id rec  : newRecordsMap.keySet()){
                //PBS_Agreement_Extension__c oldAgreementExt = (PBS_Agreement_Extension__c)oldRecordsMap.get(rec);
                //system.debug('old record' + oldAgreementExt);                
                //if(oldAgreementExt.Agreement__c == null){                    
                    PBS_Agreement_Extension__c newAgreementExt = (PBS_Agreement_Extension__c)newRecordsMap.get(rec);
                    if(newAgreementExt.FAF_ID__c != null /*&& oldAgreementExt.FAF_ID__c !=null*/){
                        fafMap.put(newAgreementExt.FAF_ID__c, newAgreementExt);
                    }
                //}
            }
        // for(PBS_Agreement_Extension__c agreementExtRec : AgreementExtList){
        //     system.debug(agreementExtRec);
        //     if(agreementExtRec.FAF_ID__c != null && agreementExtRec.Agreement__c !=null){
        //         fafMap.put(agreementExtRec.FAF_ID__c, agreementExtRec);
        //     }
        // }
        if(!fafMap.keySet().isEmpty()){
            for(Specialty_Drug_Level_Pricing__c productRateRec : [Select Id, Rate__c, FAF_ID__c, Pharmacy_Benefit__c, MAC__c from Specialty_Drug_Level_Pricing__c where FAF_ID__c in: fafMap.keySet()]){
                if(fafMap.containsKey(productRateRec.FAF_ID__c)){
                    Agreement_extension_SFS_Junction__c agreementExtSFSJuncRec = new Agreement_extension_SFS_Junction__c();
                    agreementExtSFSJuncRec.Agreement__c = fafMap.get(productRateRec.FAF_ID__c).Agreement__c;
                    agreementExtSFSJuncRec.Agreement_Extension__c = fafMap.get(productRateRec.FAF_ID__c).Id;
                    agreementExtSFSJuncRec.Specialty_Drug_Level_Pricing__c = productRateRec.id;
                    if(productRateRec.Pharmacy_Benefit__c == label.Exclusive_Retail_Lockout){
                        if(productRateRec.MAC__c){
                            agreementExtSFSJuncRec.AWP_Discount_Exclusive_1__c = label.MAC;
                        }
                        else{
                            agreementExtSFSJuncRec.AWP_Discount_Exclusive_1__c = String.valueOf(productRateRec.Rate__c);
                        }
                    }
                        agreementExtSFSJuncList.add(agreementExtSFSJuncRec);
                }
               
            }
        }
       

        if(!agreementExtSFSJuncList.isEmpty())
            insert agreementExtSFSJuncList;
    }

    public static void populateAgreementExtSFSFields(list<PBS_Agreement_Extension__c> AgreementExtList){
        set<id> fafSet = new set<id> ();
        //Map<id,set<string>> fafPharmacyBenefit = new Map<id,set<string>>();
        Map<id,string> fafPharmacyBenefitMap = new Map<id,string>();
        //Map<id,set<string>> fafSFSSubType = new Map<id,set<string>>();
        Map<id,string> fafSFSSubTypeMap = new Map<id,string>();
        Map<id,list<Specialty_Drug_Level_Pricing__c>> fafSpecDrugMap = new Map<id,list<Specialty_Drug_Level_Pricing__c>>();
        set<id> exclusionFAF = new set<id>();

        Schema.DescribeFieldResult fieldResult = PBS_Agreement_Extension__c.SFS_Pharmacy_Benefit__c.getDescribe();
        List<Schema.PicklistEntry> sfsPharmBenValues = fieldResult.getPicklistValues();
        for(PBS_Agreement_Extension__c agreementExtRec : AgreementExtList){
            if(agreementExtRec.FAF_ID__c != null){
                fafSet.add(agreementExtRec.FAF_ID__c);
            }
        }
        if(!fafSet.isEmpty()){
            for(Specialty_Drug_Level_Pricing__c specialityDrugRec : [Select Id, Rate__c, FAF_ID__c, Pharmacy_Benefit__c from Specialty_Drug_Level_Pricing__c where FAF_ID__c in: fafSet]){
                //set<string> pharmacyBenSet = new set<string>();
                
                list<Specialty_Drug_Level_Pricing__c> specDrugList = new list<Specialty_Drug_Level_Pricing__c>();
                if(!fafPharmacyBenefitMap.containsKey(specialityDrugRec.FAF_ID__c)){
                    if(specialityDrugRec.Pharmacy_Benefit__c == label.Exclusive_Retail_Lockout){
                        exclusionFAF.add(specialityDrugRec.FAF_ID__c);
                        fafPharmacyBenefitMap.put(specialityDrugRec.FAF_ID__c, sfsPharmBenValues[0].getValue());
                    }
                    else if(specialityDrugRec.Pharmacy_Benefit__c == sfsPharmBenValues[1].getValue()){
                        fafPharmacyBenefitMap.put(specialityDrugRec.FAF_ID__c, sfsPharmBenValues[1].getValue());
                    }
                    else{
                        
                    }
                }

                // if(specialityDrugRec.Pharmacy_Benefit__c == label.Exclusive_Retail_Lockout){
                //     exclusionFAF.add(specialityDrugRec.FAF_ID__c);
                //     if(!fafPharmacyBenefit.containsKey(specialityDrugRec.FAF_ID__c)){
                //         pharmacyBenSet.add(sfsPharmBenValues[0].getValue());
                //         fafPharmacyBenefit.put(specialityDrugRec.FAF_ID__c, pharmacyBenSet);
                //     }
                //     else{
                //         pharmacyBenSet = fafPharmacyBenefit.get(specialityDrugRec.FAF_ID__c);
                //         pharmacyBenSet.add(sfsPharmBenValues[0].getValue());
                //         fafPharmacyBenefit.put(specialityDrugRec.FAF_ID__c, pharmacyBenSet);   
                //     }
                // }
                // else if(specialityDrugRec.Pharmacy_Benefit__c == sfsPharmBenValues[1].getValue()){
                //     if(!fafPharmacyBenefit.containsKey(specialityDrugRec.FAF_ID__c)){
                //         pharmacyBenSet.add(specialityDrugRec.Pharmacy_Benefit__c);
                //         fafPharmacyBenefit.put(specialityDrugRec.FAF_ID__c, pharmacyBenSet);
                //     }
                //     else{
                //         pharmacyBenSet = fafPharmacyBenefit.get(specialityDrugRec.FAF_ID__c);
                //         pharmacyBenSet.add(specialityDrugRec.Pharmacy_Benefit__c);
                //         fafPharmacyBenefit.put(specialityDrugRec.FAF_ID__c, pharmacyBenSet);   
                //     }
                // }
                // else{

                // }
               
                if(!fafSpecDrugMap.containsKey(specialityDrugRec.FAF_ID__c)){
                    specDrugList.add(specialityDrugRec);
                    fafSpecDrugMap.put(specialityDrugRec.FAF_ID__c, specDrugList);
                }
                else{
                    specDrugList = fafSpecDrugMap.get(specialityDrugRec.FAF_ID__c);
                    specDrugList.add(specialityDrugRec);
                    fafSpecDrugMap.put(specialityDrugRec.FAF_ID__c, specDrugList);   
                }
               
            }
        }
    
       
        if(!exclusionFAF.isEmpty()){
            for(Specialty_Guarantee__c specGuaranteeRec : [Select Id, Subtype__c, Type__c, FAF_ID__c from Specialty_Guarantee__c where FAF_ID__c in: exclusionFAF]){
                string subtype = '';
                if(!fafSFSSubTypeMap.containsKey(specGuaranteeRec.FAF_ID__c)){
                    // fafSFSSubType.put(specGuaranteeRec.FAF_ID__c, new set<string>());

                    if(specGuaranteeRec.Type__c == label.OED){
                        if(specGuaranteeRec.Subtype__c == label.Flat)
                            subtype = label.Adjucated_OED;
                        else
                            subtype = label.Reconciled_OED;
                    }
                    else if(specGuaranteeRec.Type__c == label.GER || specGuaranteeRec.Type__c == label.BER){
                        subtype =label.GER_OR_BER;
                    }
                    else{
                        subtype = label.MER;
                    }
                    fafSFSSubTypeMap.put(specGuaranteeRec.FAF_ID__c, subtype);
                }
                   
                // set<string> sfsSubtypeSet = fafSFSSubType.get(specGuaranteeRec.FAF_ID__c);
                // if(specGuaranteeRec.Type__c == label.OED){
                //     if(specGuaranteeRec.Subtype__c == label.OED){
                //         sfsSubtypeSet.add(label.Adjucated_OED);
                //     }
                //     else{
                //         sfsSubtypeSet.add(label.Reconciled_OED);
                //     }
                // }
                // else if(specGuaranteeRec.Type__c == label.GER || specGuaranteeRec.Type__c == label.BER){
                //     sfsSubtypeSet.add(label.GER_OR_BER);
                // }
                // else{
                //     sfsSubtypeSet.add(label.MER);
                // }
                // fafSFSSubType.put(specGuaranteeRec.FAF_ID__c, sfsSubtypeSet);
            }
         
        }
        for(PBS_Agreement_Extension__c agreementExtRec : AgreementExtList){
            if(agreementExtRec.FAF_ID__c != null){
                if(fafSpecDrugMap.containsKey(agreementExtRec.FAF_ID__c)){
                    agreementExtRec.SFS_Included__c = !fafSpecDrugMap.get(agreementExtRec.FAF_ID__c).isEmpty();
                    if(!fafSpecDrugMap.get(agreementExtRec.FAF_ID__c).isEmpty()){
                    // if(fafPharmacyBenefit.containsKey(agreementExtRec.FAF_ID__c)){
                        if(fafPharmacyBenefitMap.containsKey(agreementExtRec.FAF_ID__c)){
                            agreementExtRec.SFS_Pharmacy_Benefit__c = fafPharmacyBenefitMap.get(agreementExtRec.FAF_ID__c);
                            //agreementExtRec.SFS_Pharmacy_Benefit__c = String.join(new List<String>(fafPharmacyBenefit.get(agreementExtRec.FAF_ID__c)), ';');
                        }
                            
                       //if(fafSFSSubType.containsKey(agreementExtRec.FAF_ID__c)){
                        if(fafSFSSubTypeMap.containsKey(agreementExtRec.FAF_ID__c)){
                            //agreementExtRec.SFS_Type__c = String.join(new List<String>(fafSFSSubType.get(agreementExtRec.FAF_ID__c)), ';');
                            agreementExtRec.SFS_Type__c = fafSFSSubTypeMap.get(agreementExtRec.FAF_ID__c);

                        }
                    }
                }
                else
                    agreementExtRec.SFS_Included__c =false;
              
            }
        }
    }
}