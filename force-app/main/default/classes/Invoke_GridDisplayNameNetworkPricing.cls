/* =================================================================================
 * @Class Name        : Invoke_UpdateGridDisplayNameNetworkPricing
 * @author            : Mohit Srivastava(Accenture)
 * @created date      : 05/7/2020
 * @Purpose           : Populate Grid Name in display grid setting
=======================================================================================*/
global class Invoke_GridDisplayNameNetworkPricing{



/*=================================================================================
 * @Method Name       : Invoke_UpdateGridDisplayNameNetworkPricing
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
        Set<ID> fafid = new Set<ID>();
        Set<String> NetworkName = new Set<String>();
        for(string s: FAFStatus.Value__c.split(','))
        {
            FAFStat.add(s);
        }                                                       
        List<Network_Pricing__c> Scope =[SELECT ID,Network_Name_Combination__c,Retail_Network_Ordinal__c,Custom_Description__c,FAF_Network_Ops__c,Template_BER_Guarantee_Rate__c,Network_Type__c, Show_in_Grid__c,Maintenance_Choice__c,FAF_ID__c ,
                                        Year_Begin_Date__c,Generic_Basis__c,Year_End_Date__c,Custom_Network_Description__c,MER_Guarantee_Rate__c,NED_Guarantee_Rate__c,GER_Guarantee_Rate__c,
                                        Network_Name__c,Network_Name_for_Grid__c,Invokable_Update__c,BER_Guarantee_Rate__c,SSG_Guarantee_Rate__c,Year__c,Template_Network_Name_Text__c,Template_Network_Name__c,Template_MCCP__c 
                                        FROM Network_Pricing__c where FAF_ID__r.FAF_Status__c IN:FAFStat and FAF_Network_Ops__c IN:objId];
         List<Network_Operations__c> networkOps=[select ID, FAF_ID__c from Network_Operations__c where id IN:objId];
         for(Network_Operations__c netObj:networkOps){
         fafid.add(netObj.FAF_ID__c);
         }
         if(!Scope.isEmpty()){
                for(Network_Pricing__c  netObj :scope){
                    if((netObj.Custom_Description__c!=null ||netObj.Custom_Description__c!='') && !NetworkName.contains(netObj.Network_Name_Combination__c)){
                    fafid.add(netObj.FAF_ID__c);
                    Grid_Display_Name_Setting__c gdrObj=new  Grid_Display_Name_Setting__c();
                    gdrObj.FAF__c=netObj.FAF_ID__c;
                    gdrObj.Grid_Display_Name__c=netObj.Custom_Description__c;
                    gdrObj.Network_Name__c=netObj.Network_Name__c;
                    gdrObj.Network_ordinal__c=netObj.Retail_Network_Ordinal__c;
                    gdrObj.Network_Type__c=netObj.Network_Type__c;
                    gdrObj.Object_Name__c='Network Pricing';
                    gdrObj.Network_Combination__c=netObj.Network_Name_Combination__c;
                    Griddisplaylist.add(gdrObj);
                    NetworkName.add(netObj.Network_Name_Combination__c);
                    }
                   
                }
          List<Grid_Display_Name_Setting__c> gridList=[Select id,FAF__c from Grid_Display_Name_Setting__c where FAF__c IN:fafid and Object_Name__c='Network Pricing'];
              if(!gridList.isEmpty()){
                    delete gridList;
               }
                if(!Griddisplaylist.isEmpty()){
                    insert Griddisplaylist;
                }
            }
    }
}