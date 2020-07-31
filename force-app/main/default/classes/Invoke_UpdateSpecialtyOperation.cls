/* =================================================================================
 * @Class Name        : Invoke_UpdateSpecialtyOperation
 * @author            : Mohit Srivastava(Accenture)
 * @created date      : 07/12/2019
 * @Purpose           : Invoke_UpdateSpecialtyPricing
=======================================================================================*/
global class Invoke_UpdateSpecialtyOperation{
/*=================================================================================
 * @Method Name       : UpdateSpecialtyOps
 * @author            : Mohit Srivastava(Accenture)
 * @created date      : 07/12/2019
 * @Last modified by  : Mohit Srivastava(Accenture)
 * @Purpose           : UpdateSpecialtyOps
=======================================================================================*/
@InvocableMethod
global static void UpdateSpecialtyOps(List<id> objId)
{
                if(DeepCloneUtility.OFF_INVOCABLE_CLASS){
                    DeepCloneUtility.OFF_TRIGGERS_PROCBUILDER=false;
                    Set<id> ids=new set<id>();
                    Set<id> FAFids=new set<id>();
                    Set<String> yearstr=new Set<String>();
                    String newString=' ';
                    String SpecDrugLevel =' ';
                    Boolean SpecDrugLvl = false;
                    String Exclusions;
                     String ExclusionsCustom;
                    Boolean ExcludeClass=false;
                    List<String> finalString=new List<String>();
                    List<String> multiString=new List<String>(); 
                    List<Specialty_Operations__c> updateSpecialty=new List<Specialty_Operations__c>();
                    PCD_FAF_Status__mdt FAFStatus = [SELECT Value__c FROM PCD_FAF_Status__mdt LIMIT 1]; 
                    List<string> FAFStat = new List<string>();
                    for(string s: FAFStatus.Value__c.split(',')){
                        FAFStat.add(s);
                    }                                                                                             
                    List<Specialty_Operations__c> Scope =[SELECT ID,FAF_ID__c,Specialty_Operation_Show_in_grid__c,Select_Specialty_Exclusion__c,Selected_Drug_Therapy_Name__c,
                                                          Custom_Specialty_Therapy_Name__c,Exclude_Specialty_Class__c,Invokable_Update__c,Specialty_Legacy_Drug_Level_Pharmacy__c,Specialty_Legacy_Drug_Level_exist__c
                                                          FROM Specialty_Operations__c where FAF_ID__r.FAF_Status__c IN:FAFStat and ID IN:objId];
                                                       
                    List<Specialty_Pricing__c> Dlp = [SELECT ID,Pharmacy_Benefit_Open__c,Pharmacy_Benefit__c FROM Specialty_Pricing__c WHERE Specialty_Operations__c IN:objId AND Pharmacy_Benefit__c = 'Open'];                                   
                    for(Specialty_Operations__c sops:Scope){
                        if(sops.Exclude_Specialty_Class__c==true){
                           ExcludeClass=true;
                        }
                           newString = sops.Select_Specialty_Exclusion__c;
                        }
           
                    for(Specialty_Pricing__c sdl:Dlp){      
                        if(SpecDrugLevel ==' '){
                           SpecDrugLevel ='Product level pricing with a default rate of:' + '\n';
                        }
                           SpecDrugLvl = true;
                           SpecDrugLevel += sdl.Pharmacy_Benefit_Open__c + '\n';
                        }
                String cRLabel=System.Label.Custom_Specialty_Grid_label_Align_Right;
                String cLeftBeforeLabel=System.Label.Custom_Specialty_Grid_label_Align_Left_Before;                
                String cLeftLabel=System.Label.Custom_Specialty_Grid_label_Align_Left;
                if(newString!=null){
                            multiString = newString.split(';');
                                    for(integer i =0; i<multiString.Size(); i++){
                                        System.debug('@Comparing@'+multiString[i]);                                    
                                        if(Exclusions!=null){
                                        
                                        if(cLeftBeforeLabel.contains(multiString[i]+',')){
                                             System.debug('@cLeftBeforeLabel@'+multiString[i]);                                             
                                             Exclusions='\n'+Exclusions;
                                        }                                        
                                   
                                        Exclusions+=multiString[i]+'\n';
                                        ExclusionsCustom+=multiString[i]+Label.Custom_Specialty_Grid_label+'\n';
                                              
                                        }
                                        else{
                                        System.debug('@@@@@@@@@'+Exclusions);
                                          Exclusions =multiString[i]+'\n';
                                          ExclusionsCustom=multiString[i]+Label.Custom_Specialty_Grid_label+'\n';
                                        }
                                        if(cLeftLabel.contains(multiString[i]+',')){
                                             System.debug('@cLeftLabel@'+multiString[i]);                                            
                                             Exclusions+='\n';
                                         }
                                        if(cRLabel.contains(multiString[i]+',')){
                                             System.debug('@cRLabel@'+multiString[i]);                                                                                     
                                             ExclusionsCustom+='\n';
                                         }                                    
                                        
                                    }
                                     
                    }
                           for(Specialty_Operations__c sops:Scope){
                            sops.Specialty_Legacy_Drug_Level_Pharmacy__c = SpecDrugLevel;
                            sops.Specialty_Legacy_Drug_Level_exist__c = SpecDrugLvl;
                            sops.Custom_Specialty_Therapy_Name__c =Exclusions;
                            sops.Selected_Drug_Therapy_Name__c=ExclusionsCustom;
                            sops.Invokable_Update__c=true;
                            if(Exclusions!=null &&ExclusionsCustom!=null &&sops.Exclude_Specialty_Class__c==true){
                            sops.Specialty_Operation_Show_in_grid__c=true;
                            }
                            else{
                            sops.Specialty_Operation_Show_in_grid__c=false;
                            }
                            updateSpecialty.add(sops);
                        } 
                     if(!updateSpecialty.isEmpty()){
                       update updateSpecialty;
                    }
                    //DeepCloneUtility.OFF_INVOCABLE_CLASS = false;
            }
                   
                   
                
            } 
 }