/* =================================================================================
 * @Class Name        : Invoke_GridDisplayNameMail
 * @author            : Mohit Srivastava(Accenture)
 * @created date      : 06/21/2020
 * @Purpose           : Populate Grid Name in display grid setting
=======================================================================================*/
global class Invoke_GridDisplayNameMail{
    /*=================================================================================
     * @Method Name       : Invoke_GridDisplayNameMail
     * @author            : Mohit Srivastava(Accenture)
     * @created date      : 06/21/2020
     * @Last modified by  : Mohit Srivastava(Accenture)
     * @Purpose           : Populate Grid Name in display grid setting
    =======================================================================================*/
    @InvocableMethod
    global static void UpdateGridName(List<id> objId){
            List<Grid_Display_Name_Setting__c> Griddisplaylist=new List<Grid_Display_Name_Setting__c>();
             PCD_FAF_Status__mdt FAFStatus = [SELECT Value__c FROM PCD_FAF_Status__mdt LIMIT 1]; 
            List<string> FAFStat = new List<string>();
            Set<ID> fafid = new Set<ID>();
            Set<String> LOBSet = new Set<String>();
            for(string s: FAFStatus.Value__c.split(','))
            {
                FAFStat.add(s);
            }                                                       
            List<Mail_Pricing__c> Rgee =[SELECT Id,Show_in_Grid__c,FAF_ID__c,FAF_ID__r.LOB2__c,LOB__c,
                                         Year_Begin_Date__c,Custom_Description__c,Year_End_Date__c,Generic_Rate__c,
                                         Brand_Rate__c,BER_Guarantee_Rate__c,Year__c,FAF_Mail_Operations__c from Mail_Pricing__c  where FAF_Mail_Operations__c IN:objId];
                                            
            
             if(!Rgee.isEmpty()){
                    for(Mail_Pricing__c  SpecObj :Rgee){
                            if((SpecObj.Custom_Description__c!=null ||SpecObj.Custom_Description__c!='')&& !LOBSet.contains(SpecObj.LOB__c)){
                            fafid.add(SpecObj.FAF_ID__c);
                            Grid_Display_Name_Setting__c gdrObj=new  Grid_Display_Name_Setting__c();
                            gdrObj.FAF__c=SpecObj.FAF_ID__c;
                            gdrObj.Mail_Grid_Display_Name__c=SpecObj.Custom_Description__c;
                            gdrObj.Object_Name__c='Mail Pricing';
                            gdrObj.Mail_LOB__c=SpecObj.LOB__c;
                            Griddisplaylist.add(gdrObj);
                            LOBSet.add(SpecObj.LOB__c);
                            }
                        
                    }
                    
                    
                }
             List<Grid_Display_Name_Setting__c> gridList=[Select id,FAF__c from Grid_Display_Name_Setting__c where FAF__c IN:fafid and Object_Name__c='Mail Pricing'];
              if(!gridList.isEmpty()){
                    delete gridList;
               }
              
              if(!Griddisplaylist.isEmpty()){
                        insert Griddisplaylist;
               }
       
    }
}