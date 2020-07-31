public class PBMServiceTriggerHandler {
    Public static Boolean firstcall=false;
    
    public static void handleBeforeDelete(List<PBM_Services__c> pbmList){
        List<Id> lookupRecIds = new List<Id>();        
        for(PBM_Services__c pbm : pbmList){
            
            //            List<Id> lookupRecIds = new List<Id>();        
            if (pbm.Additional_Service__c == False && pbm.Delete_PBM_Services__c == true) 
            { 
                pbm.addError('Only Additional Services can be deleted');
            }
            if(pbm.Lookup_RecId__c != null){
                lookupRecIds.add(pbm.Lookup_RecId__c);
            }
            //            deleteLookupRecords(lookupRecIds);
        }
        deleteLookupRecords(lookupRecIds);
    }
    
    @future
    public static void deleteLookupRecords(List<Id> lookupRecIds){
        if(!lookupRecIds.isEmpty()){
            List<Billing_Other_Fees__c> bofList = [SELECT Id FROM Billing_Other_Fees__c WHERE Id IN: lookupRecIds];
            List<Clinical_Solutions__c> csList = [SELECT Id FROM Clinical_Solutions__c WHERE Id IN: lookupRecIds];
            List<Billing_Ancillary_Fee__c> bafList = [SELECT Id FROM Billing_Ancillary_Fee__c WHERE Id IN: lookupRecIds];
            
            if(bafList != null && !bafList.isEmpty())delete bafList;
            if(bofList != null && !bofList.isEmpty())delete bofList;
            if(csList != null && !csList.isEmpty())delete csList;
        }
    }
    
    public static void handleBeforeInsertUpdate(List<PBM_Services__c> pbmList, Map<Id,PBM_Services__c> pbmOldMap, Boolean isInsert){
        Profile prof = [Select Name From Profile where Id=:Userinfo.getProfileId()];
        Set<Id> fstIds = new Set<Id>();
        for(PBM_Services__c pbm : pbmList){
            fstIds.add(pbm.Fee_Service_Template__c);
        }
        Map<Id,Fee_Service_Template__c> mapfst =  new Map<Id,Fee_Service_Template__c>([select Id,Max_Amount__c,Template_Type__c from Fee_Service_Template__c where Id In:fstIds]);
        for(PBM_Services__c pbm : pbmList){
            
            if(pbm.Fee_Service_Template__c != null){
                Fee_Service_Template__c fst =  mapfst.get(pbm.Fee_Service_Template__c);
                if(fst != null && (pbm.Amount__c > fst.Max_Amount__c || pbm.Amount__c < 0)){
                    pbm.Error_Message__c = 'Amount must be between $0.00 and $'+ fst.Max_Amount__c;
                    pbm.Status__c = 'Error' + ' Max Fee $' + fst.Max_Amount__c;
                    //pbm.Election__c = false;
                }
                else{
                    pbm.Error_Message__c = null;
                }
            }
            
            boolean isChanged = false;
            if(!isInsert){
                PBM_Services__c pbmOld = pbmOldMap.get(pbm.Id);
                if(pbmOld.Election__c != pbm.Election__c || pbmOld.Amount__c != pbm.Amount__c
                   || pbmOld.Basis__c != pbm.Basis__c || pbmOld.Service__c != pbm.Service__c
                   || pbmOld.Service_Effective_Date__c != pbm.Service_Effective_Date__c){
                       isChanged = true;
                   }
            }
            if(isChanged){
                pbm.Service_Last_Modified_Date__c = System.now();
            }
            if((isInsert || pbm.Election__c == false)){
                if (pbm.Error_Message__c == '' || pbm.Error_Message__c ==null) {
                    pbm.Status__c = null;
                    pbm.Approved_Date__c = null;
                    pbm.Service_Request_Date__c=null;
                }
            }
            else{
                PBM_Services__c pbmOld = pbmOldMap.get(pbm.Id);
                if (pbm.Error_Message__c == '' || pbm.Error_Message__c ==null) {
                    if(pbm.Election__c ==true && pbm.Status__c!='Review' && isChanged && prof.Name != 'Apttus Underwriting')
                    {
                        pbm.Status__c = 'Pending';
                    }
                    if(pbm.Election__c ==true && pbm.Status__c!='Review' && pbm.Status__c!='Approved' && prof.Name == 'Apttus Underwriting')
                    {
                        pbm.Status__c = 'Review';
                        pbm.Service_Request_Date__c = Datetime.now();
                    }
                }
            }
        }
    }
}