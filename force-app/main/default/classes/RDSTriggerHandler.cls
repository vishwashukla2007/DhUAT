public class RDSTriggerHandler {
    Public static Boolean firstcall=false;
    
    public static void handleBeforeDelete(List<Retiree_Drug_Subsidy__c> rdsList){
        
        List<Id> medCarePartdids = new List<Id>();
        for(Retiree_Drug_Subsidy__c rds : rdsList){
            if (rds.Additional_Service__c == False && rds.Fee_Services__r.Delete_PBM_Services__c == true) {
                rds.addError('Only Additional Services can be deleted');
            } 
                 
            if(rds.Medicare_Part_D_Fees_Schedule__c != null){
                medCarePartdids.add(rds.Medicare_Part_D_Fees_Schedule__c);
            }
        }
        deleteMedCarePartDSch(medCarePartdids);
    }
    
    public static void handleBeforeInsertUpdate(List<Retiree_Drug_Subsidy__c> rdsList, Map<Id,Retiree_Drug_Subsidy__c> rdsOldMap, Boolean isInsert){
        Profile prof = [Select Name From Profile where Id=:Userinfo.getProfileId()];
        Set<Id> fstIds = new Set<Id>();
        for(Retiree_Drug_Subsidy__c rds : rdsList){
            fstIds.add(rds.Fee_Service_Template__c);
        }
        Map<Id,Fee_Service_Template__c> mapfst =  new Map<Id,Fee_Service_Template__c>([select Id,Max_Amount__c,Template_Type__c from Fee_Service_Template__c where Id In:fstIds]);
        
        for(Retiree_Drug_Subsidy__c rds : rdsList){
            
            if(rds.Fee_Service_Template__c != null){
                Fee_Service_Template__c fst =  mapfst.get(rds.Fee_Service_Template__c);
                if(fst != null && (rds.Amount__c > fst.Max_Amount__c || rds.Amount__c < 0)){
                    rds.Error_Message__c = 'Amount must be between $0.00 and $'+ fst.Max_Amount__c;
                    rds.Status__c = 'Error' + ' Max Fee $' + fst.Max_Amount__c;
                    //rds.Election__c = false;
                }
                else{
                    rds.Error_Message__c = null;
                }
            }
            
            boolean isChanged = false;
            if(!isInsert){
                Retiree_Drug_Subsidy__c rdsOld = rdsOldMap.get(rds.Id);
                if(rdsOld.Election__c != rds.Election__c || rdsOld.Amount__c != rds.Amount__c
                   || rdsOld.Basis__c != rds.Basis__c || rdsOld.Service__c != rds.Service__c
                   || rdsOld.Service_Effective_Date__c != rds.Service_Effective_Date__c){
                       isChanged = true;
                   }
            }
            if(isChanged){
                rds.Service_Last_Modified_Date__c = System.now();
            }
            if(isInsert || rds.Election__c == false){
                if (rds.Error_Message__c == '' || rds.Error_Message__c ==null) {
                    rds.Status__c = null;
                    rds.Approved_Date__c = null;
                    rds.Service_Request_Date__c = null;
                }
            }
            else{
                Retiree_Drug_Subsidy__c rdsOld = rdsOldMap.get(rds.Id);
                if (rds.Error_Message__c == '' || rds.Error_Message__c ==null) {
                    if(rds.Election__c ==true && rds.Status__c!='Review' && isChanged && prof.Name != 'Apttus Underwriting' )
                    {
                        rds.Status__c = 'Pending';
                    }
                    if(rds.Election__c ==true && rds.Status__c!='Review' && rds.Status__c!='Approved' && prof.Name == 'Apttus Underwriting')
                    {
                        rds.Status__c = 'Review';
                        rds.Service_Request_Date__c = Datetime.now();
                    }
                }
            }
        }
    }
    
    @future
    public static void deleteMedCarePartDSch(List<Id> medCarePartdids){
        if(!medCarePartdids.isEmpty()){
            List<Medicare_Part_D_Fees_Schedule__c> medCarePartdFeeSchList = [SELECT Id FROM Medicare_Part_D_Fees_Schedule__c WHERE Id IN: medCarePartdids];
            if(medCarePartdFeeSchList != null && !medCarePartdFeeSchList.isEmpty()) delete medCarePartdFeeSchList;
        }
    }
}