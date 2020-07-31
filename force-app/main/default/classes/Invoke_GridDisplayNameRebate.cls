/* =================================================================================
 * @Class Name        : Invoke_GridDisplayNameRebate
 * @author            : Mohit Srivastava(Accenture)
 * @created date      : 05/7/2020
 * @Purpose           : Populate Grid Name in display grid setting
=======================================================================================*/
global class Invoke_GridDisplayNameRebate{
    /*=================================================================================
     * @Method Name       : Invoke_GridDisplayNameRebate
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
              List<string> RebateKey = new List<string>();
            Set<ID> fafid = new Set<ID>();
            for(string s: FAFStatus.Value__c.split(','))
            {
                FAFStat.add(s);
            }                                                       
            List<Rebate_Guarantees__c> Rgee =[SELECT ID,Grid_Flag__c,Specialty_Key__c,Rebate_Key__c,GSTP__c,Non_Specialty_Formulary_2__c,Specialty_Formulary__c,FAF_ID__c,Custom_Description__c,Specialty_Display_Name__c,Plan_Design__c
                                            FROM Rebate_Guarantees__c WHERE FAF_ID__r.FAF_Status__c IN:FAFStat AND Rebate_Operations__c IN:objId];
                                            
             System.debug('List size--->'+Rgee.size());
             if(!Rgee.isEmpty()){
                    for(Rebate_Guarantees__c  RebateObj :Rgee){
                        if(RebateObj.Grid_Flag__c==true){
                            if((RebateObj.Custom_Description__c!=null ||RebateObj.Custom_Description__c!='' || RebateObj.Specialty_Display_Name__c!=null ||RebateObj.Specialty_Display_Name__c!='')&& !RebateKey.contains(RebateObj.Rebate_Key__c)){
                            fafid.add(RebateObj.FAF_ID__c);
                            Grid_Display_Name_Setting__c gdrObj=new  Grid_Display_Name_Setting__c();
                            gdrObj.FAF__c=RebateObj.FAF_ID__c;
                            gdrObj.Rebate_Non_Specialty_Grid_Name__c=RebateObj.Custom_Description__c;
                            gdrObj.Non_Specialty_Formulary__c=RebateObj.Non_Specialty_Formulary_2__c;
                            gdrObj.Specialty_Formulary_Name__c=RebateObj.Specialty_Formulary__c;
                            gdrObj.GSTP__c=RebateObj.GSTP__c;
                            gdrObj.Plan_Design__c=RebateObj.Plan_Design__c;
                            gdrObj.Rebate_Specialty_Grid_Name__c=RebateObj.Specialty_Display_Name__c;
                            gdrObj.Object_Name__c='Rebate Guarantees';
                            gdrObj.Specialty_Key__c=RebateObj.Specialty_Key__c;
                            Griddisplaylist.add(gdrObj);
                            RebateKey.add(RebateObj.Rebate_Key__c);
                            }
                        }
                    }
                    
                    
                }
             List<Grid_Display_Name_Setting__c> gridList=[Select id,FAF__c from Grid_Display_Name_Setting__c where FAF__c IN:fafid and Object_Name__c='Rebate Guarantees'];
              if(!gridList.isEmpty()){
                    delete gridList;
               }
              
              if(!Griddisplaylist.isEmpty()){
                        insert Griddisplaylist;
               }
       
    }
}