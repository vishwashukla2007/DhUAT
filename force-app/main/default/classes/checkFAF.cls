global class checkFAF {
    @InvocableMethod
   public static list<list<string>> getFAF(list<list<string>> fafid) {
      
       //Create ApexFlow return outputVar
        list<list<string>> collectFieldsOutputVar= new list<list<string>>();
       //Collect Fields
       list<string> collectFields_list = new list<string>();
       /*
       //Extract FAF id
       list<string> processFAFlist = new list<string>();
       processFAFlist = fafid[0];
       
       //Query related Objects from FAF
       list<Central_Hub__c> fafRecList = [SELECT id, Name, Client_Name__c,Account_Name__r.iUMS_Client_Subtype__c,
                                  Account_Name__r.ERISA_NON_ERISA__c, Account_Name__r.Business_Unit__c, Segment__c, Account_Name__r.Market_Segment__c,
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
                                  FROM Central_Hub__c WHERE id IN : processFAFlist LIMIT 1];
       
       
       set<id> mailOpsIds = new set<id>();
       set<id> netOpsIds = new set<id>();
       set<id> specOpsIds = new set<id>();
       
       for(Central_Hub__c fafrec : fafRecList){          
           //FAF 
           //(Id, Client Name, Market Segment)
           collectFields_list.add('FAF_ID__c' + '-' + fafrec.Id);
           if(fafrec.Client_Name__c==null){
               collectFields_list.add('Client_Name__c' + '-' + 'Empty');
           }else{
               collectFields_list.add('Client_Name__c' + '-' + fafrec.Client_Name__c);
           }
        
           
           if(fafrec.Account_Name__r.Market_Segment__c==null){
               collectFields_list.add('Segment__c' + '-' + 'Empty');
           }else{
               collectFields_list.add('Segment__c' + '-' + fafrec.Account_Name__r.Market_Segment__c);
           }
           
           //Clinical Solutions
           if(fafrec.Clinical_Ops__r.size()>0){
               list<Clinical_Solutions__c> clinicSol = [SELECT id, Clinical_Solution__c FROM Clinical_Solutions__c WHERE
                                                 Clinical_Operations__c IN: fafrec.Clinical_Ops__r AND Clinical_Solution__c
                                                  IN ('1st Level Appeals','2nd Level Appeals','Urgent 1st Level Appeals with an IRO', 'Transform Diabetes Care (PEMPM Meter Fee)', 'Transform Diabetes Care (PMPM Clinical Fee)','ExtraCare Health Card') LIMIT 1];
               if(clinicSol.size()>0){
                   collectFields_list.add('Clinical_Solution__c' + '-' + clinicSol[0].Clinical_Solution__c);
               }
               //Populate Appeals
               list<Clinical_Solutions__c> clinicSolAppeal = [SELECT id, Clinical_Solution__c FROM Clinical_Solutions__c WHERE
                                                 Clinical_Operations__c IN: fafrec.Clinical_Ops__r AND Clinical_Solution__c
                                                  IN ('1st Level Appeals','2nd Level Appeals','Urgent 1st Level Appeals with an IRO') LIMIT 1];
               if(clinicSolAppeal.size()>0){
                   collectFields_list.add('Appeals__c' + '-' + true);
               }
               //Populate Transform Diabetic care program
               list<Clinical_Solutions__c> clinicSolTransform = [SELECT id, Clinical_Solution__c FROM Clinical_Solutions__c WHERE
                                                 Clinical_Operations__c IN: fafrec.Clinical_Ops__r AND Clinical_Solution__c
                                                  IN ('Transform Diabetes Care (PEMPM Meter Fee)', 'Transform Diabetes Care (PMPM Clinical Fee)') LIMIT 1];
               if(clinicSolTransform.size()>0){
                   collectFields_list.add('Transform_Diabetic_care_program__c' + '-' + true);
               }
               //Populate Extracare Healthcard
               list<Clinical_Solutions__c> clinicSolExtraCare = [SELECT id, Clinical_Solution__c FROM Clinical_Solutions__c WHERE
                                                 Clinical_Operations__c IN: fafrec.Clinical_Ops__r AND Clinical_Solution__c
                                                  IN ('ExtraCare Health Card') LIMIT 1];
               if(clinicSolExtraCare.size()>0){
                   collectFields_list.add('Extracare_Healthcard__c' + '-' + true);
               } 
           }
           
                      
           //FAF > Client Information 
           //(Contract Effective Date, Contract End Date)
           for(Client_Information__c clientInfoRec : fafrec.Client_Info__r){
               if(clientInfoRec.Contract_Effective_Date__c==null){
                   collectFields_list.add('Contract_Effective_Date__c' + '-' + 'Empty');
               }else{
                   collectFields_list.add('Contract_Effective_Date__c' + '-' + clientInfoRec.Contract_Effective_Date__c);
               }
               
               if(clientInfoRec.Contract_End_Date__c==null){
                   collectFields_list.add('Contract_End_Date__c' + '-' + 'Empty');
               }else{
                   collectFields_list.add('Contract_End_Date__c' + '-' + clientInfoRec.Contract_End_Date__c);
               }
               if(clientInfoRec.Master_Client_Name__c==null){
                   collectFields_list.add('Master_Client_Name__c' + '-' + 'Empty');
               }else{
                   collectFields_list.add('Master_Client_Name__c' + '-' + clientInfoRec.Master_Client_Name__c);
               }
               
               //if(clientInfoRec.Pricing_Effective_Date__c==null){
               //    collectFields_list.add('Pricing_Effective_Date__c' + '-' + 'Empty');
               //}else{
               //    collectFields_list.add('Pricing_Effective_Date__c' + '-' + clientInfoRec.Pricing_Effective_Date__c);
               //}
           }
           
           //FAF > Mail Operations 
           //(Adjudicate at Actual Package Size?)
           for(Mail_Operations__c getFieldVal : fafrec.Mail_Ops__r){
               collectFields_list.add('Adjudicate_at_Actual_Package_Size__c' + '-' + getFieldVal.Adjudicate_at_Actual_Package_Size__c);
               mailOpsIds.add(getFieldVal.id);
           }
           
            //FAF > Network Operations 
           for(Network_Operations__c getFieldVal : fafrec.FAF_Network_Ops__r){
               netOpsIds.add(getFieldVal.id);
           }
           
           //FAF < Account 
           //(iUMS Client Subtype, ERISA/Non-ERISA, Business Unit)
           if(fafrec.Account_Name__r.iUMS_Client_Subtype__c==null){
               collectFields_list.add('iUMS_Client_Subtype__c' + '-' + 'Empty');
           }else{
               collectFields_list.add('iUMS_Client_Subtype__c' + '-' + fafrec.Account_Name__r.iUMS_Client_Subtype__c);
           }
           if(fafrec.Account_Name__r.ERISA_NON_ERISA__c==null){
               collectFields_list.add('ERISA_NON_ERISA__c' + '-' + 'Empty');
           }else{
               collectFields_list.add('ERISA_NON_ERISA__c' + '-' + fafrec.Account_Name__r.ERISA_NON_ERISA__c.toUppercase());
           }
                    
           //FAF > Rebate Operations
           //(Pass MAF?, Specialty Rebates?, Vaccine Exclusion Option, Rebate Contract Type, 
           //Rebate Offering Type, 340B Rebate, Compound Rebate, Paper Rebate, COB Rebate, Vaccine Rebate, 
           //LDD Rebate, ZBD Rebate, Select Specialty PDPD Therapy Class(es), Rebate Effective Date)
           for(Rebate_Operations__c getFieldVal : fafrec.Rebate_Operations__r){
               collectFields_list.add('Pass_MAF__c' + '-' + getFieldVal.Pass_MAF__c);
               collectFields_list.add('Rebate_RTMD__c' + '-' + getFieldVal.Rebate_RTMD__c);
               collectFields_list.add('Vaccine_Exclusion_Option__c' + '-' + getFieldVal.Vaccine_Exclusion_Option__c);
               collectFields_list.add('Rebate_Contract_Type__c' + '-' + getFieldVal.Rebate_Contract_Type__c);
               collectFields_list.add('Rebate_Offering_Type__c' + '-' + getFieldVal.Rebate_Offering_Type__c);
               //collectFields_list.add('Compound_Rebate__c' + '-' + getFieldVal.Compound__c);
               //collectFields_list.add('Paper_Rebate__c' + '-' + getFieldVal.Paper__c);
               //collectFields_list.add('ZBD_Rebate__c' + '-' + getFieldVal.ZBD__c);
               //collectFields_list.add('Select_Specialty_PDPD_Therapy_Class_es__c' + '-' + getFieldVal.Select_Specialty_PDPD_Therapy_Class_es__c);
               //collectFields_list.add('Non_Specialty_Formulary_Option__c' + '-' + getFieldVal.Non_Specialty_Formulary_Option__c);
               //collectFields_list.add('Specialty_Formulary_Option__c' + '-' + getFieldVal.Specialty_Formulary_Option__c);
               if(getFieldVal.Specialty_Rebates__c==null){
                   collectFields_list.add('Specialty_Rebates__c' + '-' + 'Empty');
               }else{
                   collectFields_list.add('Specialty_Rebates__c' + '-' + getFieldVal.Specialty_Rebates__c);
               }
               //if(getFieldVal.Rebate_Effective_Date__c==null){
               //    collectFields_list.add('Rebate_Effective_Date__c' + '-' + 'Empty');
               //}else{
               //    collectFields_list.add('Rebate_Effective_Date__c' + '-' + getFieldVal.Rebate_Effective_Date__c);
               //}
               if(getFieldVal.Non_Specialty_Formulary_Option__c==null){
                   collectFields_list.add('Non_Specialty_Formulary_Option__c' + '-' + 'Empty');
               }else{
                   collectFields_list.add('Non_Specialty_Formulary_Option__c' + '-' + getFieldVal.Non_Specialty_Formulary_Option__c);
               }
               if(getFieldVal.Specialty_Formulary_Option__c==null){
                   collectFields_list.add('Specialty_Formulary_Option__c' + '-' + 'Empty');
               }else{
                   collectFields_list.add('Specialty_Formulary_Option__c' + '-' + getFieldVal.Specialty_Formulary_Option__c);
               }
           }
           
           //FAF > Billing Operations
           //(Pharmacy Audit Retention, Client Share, CVS Share, Claim 
           //Billing, Admin Fee Billing, Billing Claim Payment Terms, Billing Admin Terms,
           //Additional Admin Fee Payment Term Info, Additional Claim Payment Term Info)
           set<id> billingOpsIds = new set<id>(); 
           for(Billing_Operations__c getFieldVal : fafrec.Billing_Ops__r){
               billingOpsIds.add(getFieldVal.id);
               if(getFieldVal.Pharmacy_Audit_Retention__c==null){
                  collectFields_list.add('Pharmacy_Audit_Retention__c' + '-' + 'Empty');  
               }else{
                   collectFields_list.add('Pharmacy_Audit_Retention__c' + '-' + getFieldVal.Pharmacy_Audit_Retention__c); 
               }
               
               if(getFieldVal.Pharmacy_Audit_Retention__c==null){
                   if(getFieldVal.Client_Share__c==null){
                       collectFields_list.add('Client_Share__c' + '-' + 'Empty');
                   }else{
                       collectFields_list.add('Client_Share__c' + '-' + getFieldVal.Client_Share__c); 
                       collectFields_list.add('CVS_Share__c' + '-' + getFieldVal.CVS_Share__c); 
                   }
               }else{
                   collectFields_list.add('Client_Share__c' + '-' + getFieldVal.Client_Share__c); 
                   collectFields_list.add('CVS_Share__c' + '-' + getFieldVal.CVS_Share__c); 
               }
               
               if(getFieldVal.Claim_Billing__c==null){
                  collectFields_list.add('Claim_Billing__c' + '-' + 'Empty');  
               }else{
                   collectFields_list.add('Claim_Billing__c' + '-' + getFieldVal.Claim_Billing__c); 
               }
               
               if(getFieldVal.Admin_Fee_Billing__c==null){
                  collectFields_list.add('Admin_Fee_Billing__c' + '-' + 'Empty');  
               }else{
                   collectFields_list.add('Admin_Fee_Billing__c' + '-' + getFieldVal.Admin_Fee_Billing__c); 
               }
               
               collectFields_list.add('Billing_Claim_Payment_Terms__c' + '-' + getFieldVal.Billing_Claim_Payment_Terms__c);
               collectFields_list.add('Billing_Admin_Payment_Terms__c' + '-' + getFieldVal.Billing_Admin_Payment_Terms__c);
               collectFields_list.add('Additional_Admin_Fee_Payment_Term_Info__c' + '-' + getFieldVal.Additional_Admin_Fee_Payment_Term_Info__c);
               collectFields_list.add('Additional_Claim_Payment_Term_Info__c' + '-' + getFieldVal.Additional_Claim_Payment_Term_Info__c);
           }
           
           //FAF > Billing Operation > Medicare Part D Fees Schedule
           if(billingOpsIds.size() > 0){
               list<Medicare_Part_D_Fees_Schedule__c> medicarePart = [SELECT id, Type__c FROM Medicare_Part_D_Fees_Schedule__c
                                                                     WHERE Type__c IN ('Subsidy') AND Billing_Operations__c IN :billingOpsIds LIMIT 1];
               for(Medicare_Part_D_Fees_Schedule__c getFieldVal : medicarePart){
                   collectFields_list.add('Medicare_Subsidy__c' + '-' + true);
               }
           }
           
           //FAF > Guarantee Information
           //(Performance Guarantee?)
           for(Guarantees_Information__c getFieldVal : fafrec.Guarantee_Info__r){
               if(getFieldVal.Performance_Guarantee__c==null){
                   collectFields_list.add('Performance_Guarantee__c' + '-' + 'Empty');
               }else{
                   collectFields_list.add('Performance_Guarantee__c' + '-' + getFieldVal.Performance_Guarantee__c);
               }
           }
           
           //FAF > Legal Information
           //(Days Written Notice Before Termination)
           for(Legal_Information__c getFieldVal : fafrec.Legal__r){ 
               collectFields_list.add('Days_Written_Notice_Before_Termination__c' + '-' + getFieldVal.Days_Written_Notice_Before_Termination__c);
               collectFields_list.add('Frequency_1__c' + '-' + getFieldVal.Frequency_1__c);
               collectFields_list.add('Term_Without_Cause__c' + '-' + getFieldVal.Term_Without_Cause__c);
           }
           
           //FAF > Specialty Operations
           //(Pharmacy Benefit)
           for(Specialty_Operations__c getFieldVal : fafrec.Specialty_Ops__r){
               specOpsIds.add(getFieldVal.id);
               collectFields_list.add('Pharmacy_Benefit__c' + '-' + getFieldVal.Pharmacy_Benefit__c);
           }
       }
       
       //Query related Objects
       ////FAF > Mail Operations 
       set<id> mailPricingIds = new set<id>();
       if(mailOpsIds.size() >0){          
           list<Mail_Operations__c> mailOpsRecList = [SELECT id, 
                                                      (SELECT id FROM FAF_Mail_Pricing__r LIMIT 1)
                                                      FROM Mail_Operations__c WHERE id IN : mailOpsIds LIMIT 1];
                      
           for(Mail_Operations__c parentVal : mailOpsRecList){
               //FAF > Mail Operations > Mail Pricing >
               for(Mail_Pricing__c getFieldVal : parentVal.FAF_Mail_Pricing__r){
                    mailPricingIds.add(getFieldVal.id);
               }  
           }         
       }
       
       //Query related Objects
       ////FAF > Mail Operations > Mail Pricing > Mail Guarantees
       //(Vaccine Option - Mail, 340B Mail, Compound Mail, Paper Mail, COB Mail, Vaccine Mail, 
       //LDD Mail, ZBD Mail, SSG Mail)
       if(mailPricingIds.size() >0){          
           list<Mail_Pricing__c> mailPriceList = [SELECT id, 
                                                      (SELECT id, Vaccine_Inclusion_Option__c, X340B__c, Compound__c, 
                                                       Paper__c, COB__c, Vaccine__c, LDD__c, ZBD__c, SSG__c 
                                                       FROM Mail_Guarantee__r LIMIT 1)
                                                      FROM Mail_Pricing__c WHERE id IN : mailPricingIds LIMIT 1];
                      
           for(Mail_Pricing__c parentVal : mailPriceList){
               for(Mail_Guarantees__c getFieldVal : parentVal.Mail_Guarantee__r){
                   //collectFields_list.add('Mail_Guarantees_Vaccine_Option__c' + '-' + getFieldVal.Vaccine_Inclusion_Option__c);
                   //collectFields_list.add('Paper_Mail__c' + '-' + getFieldVal.Paper__c);
                   //collectFields_list.add('ZBD_Mail__c' + '-' + getFieldVal.ZBD__c);
                   //collectFields_list.add('SSG_Mail__c' + '-' + getFieldVal.SSG__c);
               }  
           }         
       }
             
       //Query related Objects
       ////FAF > Network Operations 
       set<id> netPricingIds = new set<id>();
       if(netOpsIds.size() >0){          
           list<Network_Operations__c> netOpsRecList = [SELECT id, 
                                                      (SELECT id FROM FAF_Network_Pricing__r LIMIT 1)
                                                      FROM Network_Operations__c WHERE id IN : netOpsIds LIMIT 1];
           for(Network_Operations__c parentVal : netOpsRecList){
               //FAF > Network Operations > Network Pricing >
               //===Network Operation===
               //(Method Network, Member)
               
               for(Network_Pricing__c getFieldVal : parentVal.FAF_Network_Pricing__r){
                    netPricingIds.add(getFieldVal.id);
               }  
           }
           
           //Populate Maintenance Choice
           list<Network_Operations__c> netOpsRecListMaintenance = [SELECT id,  
                                                      (SELECT Network_Name__c FROM FAF_Network_Pricing__r
                                                      WHERE Network_Name__c IN ('MC(84-90)CP','MC(84-90)CVS') LIMIT 1)
                                                      FROM Network_Operations__c WHERE id IN : netOpsIds LIMIT 1];
           for(Network_Operations__c parentValMaintenance : netOpsRecListMaintenance){
               for(Network_Pricing__c getFieldValMaintenance : parentValMaintenance.FAF_Network_Pricing__r){
                    collectFields_list.add('Maintenance_choice__c' + '-' + true);
               }  
           }
       }

       //Query related Objects
       ////FAF > Network Operations > Network Pricing > Retail Network Guarantees
       //===Network Pricing===
       //(SSG Exclusion List, SSG Exclusivity Period, Network Name, Network Type, Generic Basis)
       //===Retail Network Guarantees===
       //(Vaccine Option -Network, 340B Network, Compound Network, Paper Network, COB Network, Vaccine 
       //Network, LDD Network, ZBD Network, U&C Network, SSG Network, Type Network, Rate Network)
       if(netPricingIds.size() >0){          
           list<Network_Pricing__c> netPriceList = [SELECT id, SSG_Exclusion_List__c, SSG_Exclusivity_Period__c, Network_Name__c,
                                                      (SELECT id,Vaccine_Inclusion_Option__c, X340B__c, 
                                                       Compound__c, Paper__c, COB__c, Vaccine__c, LDD__c, ZBD__c, U_C__c, 
                                                       SSG__c, Type__c, Rate__c FROM FAF_Retail_Network_Guarantees__r LIMIT 1)
                                                       FROM Network_Pricing__c WHERE id IN : netPricingIds LIMIT 1];
           
            
           for(Network_Pricing__c parentVal : netPriceList){
               //collectFields_list.add('Network_Name__c' + '-' + parentVal.Network_Name__c);
               for(Retail_Network_Guarantees__c getFieldVal : parentVal.FAF_Retail_Network_Guarantees__r){
                   //collectFields_list.add('Retail_Network_Guarantees_Vaccine_Option__c' + '-' + getFieldVal.Vaccine_Inclusion_Option__c);
                   //collectFields_list.add('Compound_Network__c' + '-' + getFieldVal.Compound__c);
                   //collectFields_list.add('Paper_Network__c' + '-' + getFieldVal.Paper__c);
                   //collectFields_list.add('ZBD_Network__c' + '-' + getFieldVal.ZBD__c);
                   //collectFields_list.add('SSG_Network__c' + '-' + getFieldVal.SSG__c);
                   //collectFields_list.add('Type_Network__c' + '-' + getFieldVal.Type__c);
               }  
           }
       }
       
       //Query related Objects
       ////FAF > Specialty Operations 
       set<id> specPricingIds = new set<id>();
       if(specOpsIds.size() >0){          
           list<Specialty_Operations__c> specOpsRecList = [SELECT id, 
                                                      (SELECT id FROM Specialty_Pricing__r LIMIT 1)
                                                      FROM Specialty_Operations__c WHERE id IN : specOpsIds LIMIT 1];
           
            
           for(Specialty_Operations__c parentVal : specOpsRecList){
               //FAF > Specialty Operations > Specialty Pricing >
               for(Specialty_Pricing__c getFieldVal : parentVal.Specialty_Pricing__r){
                    specPricingIds.add(getFieldVal.id);
               }  
           }         
       }
       
       //Query related Objects
       ////FAF > Specialty Operations > Specialty Pricing > Specialty Guarantees
       //(340B Specialty, Compound Specialty, Paper Specialty, COB Specialty, Vaccine Specialty, 
       //LDD Specialty, ZBD Specialty, SSG Specialty)
       if(specPricingIds.size() >0){          
           list<Specialty_Pricing__c> specPriceList = [SELECT id, 
                                                      (SELECT X340B__c, Compound__c, Paper__c, COB__c, Vaccine__c,
                                                       LDD__c, ZBD__c, SSG__c FROM Specialty_Gaurentees__r LIMIT 1)
                                                      FROM Specialty_Pricing__c WHERE id IN : specPricingIds LIMIT 1];
           
            
           for(Specialty_Pricing__c parentVal : specPriceList){
               for(Specialty_Guarantee__c getFieldVal : parentVal.Specialty_Gaurentees__r){
                   //collectFields_list.add('Compound_Specialty__c' + '-' + getFieldVal.Compound__c);
                   //collectFields_list.add('Paper_Specialty__c' + '-' + getFieldVal.Paper__c);
                   //collectFields_list.add('ZBD_Specialty__c' + '-' + getFieldVal.ZBD__c);
                   //collectFields_list.add('SSG_Specialty__c' + '-' + getFieldVal.SSG__c);
               }  
           }         
       }
       */
       //Populate return output var
       collectFieldsOutputVar.add(collectFields_list);      
       system.debug(collectFieldsOutputVar);   
       return collectFieldsOutputVar;
       
   }
}