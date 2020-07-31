Global with sharing class ApprovalSubmit{
    
    @InvocableMethod             
    public static void ApprovalSubmit(List<Id> FAFList) {                               
        for (Central_Hub__c faf: [Select id from Central_Hub__c where id in : FAFList]) {  
        
                Boolean bRequire= Apttus_Approval.ApprovalsWebService.isApprovalRequired('Central_Hub__c',faf.Id);
                if (bRequire) {       
                    Boolean ok = Apttus_Approval.ApprovalsWebService.previewApprovals('Central_Hub__c',faf.Id);
                }
            }
    }
     
    }