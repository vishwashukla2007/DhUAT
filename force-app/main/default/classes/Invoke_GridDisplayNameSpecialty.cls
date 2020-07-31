/* =================================================================================
 * @Class Name        : Invoke_GridDisplayNameSpecialty
 * @author            : Mohit Srivastava(Accenture)
 * @created date      : 05/7/2020
 * @Purpose           : Populate Grid Name in display grid setting
=======================================================================================*/
global class Invoke_GridDisplayNameSpecialty{
    /*=================================================================================
     * @Method Name       : Invoke_GridDisplayNameSpecialty
     * @author            : Mohit Srivastava(Accenture)
     * @created date      : 05/7/2020
     * @Last modified by  : Mohit Srivastava(Accenture)
     * @Purpose           : Populate Grid Name in display grid setting
    =======================================================================================*/
    @InvocableMethod
    global static void UpdateGridName(List<id> objId){
            List<Grid_Display_Name_Setting__c> Griddisplaylist=new List<Grid_Display_Name_Setting__c>();
             PCD_FAF_Status__mdt FAFStatus = [SELECT Value__c FROM PCD_FAF_Status__mdt LIMIT 1]; 
            List<string> FAFStat = new List<string>();
            Set<string> SpecialtyName=new Set<string>();
            Set<ID> fafid = new Set<ID>();
            for(string s: FAFStatus.Value__c.split(','))
            {
                FAFStat.add(s);
            }                                                       
            List<Specialty_Pricing__c> Rgee =[SELECT ID,Pharmacy_Benefit__c,FAF_ID__c,Custom_Description__c
                                            FROM Specialty_Pricing__c WHERE FAF_ID__r.FAF_Status__c IN:FAFStat AND Specialty_Operations__c IN:objId];
                                            
             System.debug('List size--->'+Rgee.size());
             if(!Rgee.isEmpty()){
                    for(Specialty_Pricing__c  SpecObj :Rgee){
                            if((SpecObj.Custom_Description__c!=null ||SpecObj.Custom_Description__c!='') &&!SpecialtyName.contains(SpecObj.Pharmacy_Benefit__c)){
                            fafid.add(SpecObj.FAF_ID__c);
                            Grid_Display_Name_Setting__c gdrObj=new  Grid_Display_Name_Setting__c();
                            gdrObj.FAF__c=SpecObj.FAF_ID__c;
                            gdrObj.Specialty_Grid_Name__c=SpecObj.Custom_Description__c;
                            gdrObj.Object_Name__c='Specialty Pricing';
                            gdrObj.Pharmacy_Benefit_Type__c=SpecObj.Pharmacy_Benefit__c;
                            Griddisplaylist.add(gdrObj);
                            SpecialtyName.add(SpecObj.Pharmacy_Benefit__c);
                            }
                        
                    }
                    
                    
                }
             List<Grid_Display_Name_Setting__c> gridList=[Select id,FAF__c from Grid_Display_Name_Setting__c where FAF__c IN:fafid and Object_Name__c='Specialty Pricing'];
              if(!gridList.isEmpty()){
                    delete gridList;
               }
              
              if(!Griddisplaylist.isEmpty()){
                        insert Griddisplaylist;
               }
       
    }
}