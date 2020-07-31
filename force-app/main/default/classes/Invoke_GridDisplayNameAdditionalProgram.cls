/* =================================================================================
 * @Class Name        : Invoke_GridDisplayNameAdditionalProgram
 * @author            : Mohit Srivastava(Accenture)
 * @created date      : 06/1/2020
 * @Purpose           : Populate Grid Name in display grid setting
=======================================================================================*/
global class Invoke_GridDisplayNameAdditionalProgram{
    /*=================================================================================
     * @Method Name       : Invoke_GridDisplayNameAdditionalProgram
     * @author            : Mohit Srivastava(Accenture)
     * @created date      : 06/1/2020
     * @Last modified by  : Mohit Srivastava(Accenture)
     * @Purpose           : Populate Grid Name in display grid setting
    =======================================================================================*/
    @InvocableMethod
    global static void UpdateGridName(List<id> objId){
            List<Grid_Display_Name_Setting__c> Griddisplaylist=new List<Grid_Display_Name_Setting__c>();
             PCD_FAF_Status__mdt FAFStatus = [SELECT Value__c FROM PCD_FAF_Status__mdt LIMIT 1]; 
            List<string> FAFStat = new List<string>();
            Set<ID> fafid = new Set<ID>();
            Set<String> ClinicalOps = new Set<String>();
            for(string s: FAFStatus.Value__c.split(','))
            {
                FAFStat.add(s);
            }                                                       
            List<Clinical_Solutions__c> Rgee =[SELECT ID,Clinical_Solution_Unique_Comb__c,FAF_ID__c,Custom_Description__c
                                            FROM Clinical_Solutions__c WHERE FAF_ID__r.FAF_Status__c IN:FAFStat AND Clinical_Operations__c IN:objId];
                                            
             System.debug('List size--->'+Rgee.size());
             if(!Rgee.isEmpty()){
                    for(Clinical_Solutions__c  SpecObj :Rgee){
                            if((SpecObj.Custom_Description__c!=null ||SpecObj.Custom_Description__c!='')&& !ClinicalOps.contains(SpecObj.Clinical_Solution_Unique_Comb__c)){
                            fafid.add(SpecObj.FAF_ID__c);
                            Grid_Display_Name_Setting__c gdrObj=new  Grid_Display_Name_Setting__c();
                            gdrObj.FAF__c=SpecObj.FAF_ID__c;
                            gdrObj.Additional_Program_Grid_Name__c=SpecObj.Custom_Description__c;
                            gdrObj.Object_Name__c='Clinical Solution';
                            gdrObj.Additional_Program_Combination__c=SpecObj.Clinical_Solution_Unique_Comb__c;
                            Griddisplaylist.add(gdrObj);
                            ClinicalOps.add(SpecObj.Clinical_Solution_Unique_Comb__c);
                            }
                        
                    }
                    
                    
                }
             List<Grid_Display_Name_Setting__c> gridList=[Select id,FAF__c from Grid_Display_Name_Setting__c where FAF__c IN:fafid and Object_Name__c='Clinical Solution'];
              if(!gridList.isEmpty()){
                    delete gridList;
               }
              
              if(!Griddisplaylist.isEmpty()){
                        insert Griddisplaylist;
               }
       
    }
}