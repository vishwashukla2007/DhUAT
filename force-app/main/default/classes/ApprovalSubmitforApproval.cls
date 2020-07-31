Global with sharing class ApprovalSubmitforApproval{
    
    @InvocableMethod             
    public static void ApprovalSubmitforApproval(List<Id> ApprovalList) {                               
        for (Apttus_Approval__Approval_Request__c ap: [Select id, Assigned_User__c,Auto_Approval_Counter__c,Auto_Approval__c,Related_FAF__c,Related_Account_LOB__c,Related_Account__c,Apttus_Approval__Object_Type__c,Apttus_Approval__Assigned_To_Id__c,Apttus_Approval__ObjectRefId__c
            from Apttus_Approval__Approval_Request__c where id in : ApprovalList]) {            

                Boolean bRequire= Apttus_Approval.ApprovalsWebService.isApprovalRequired(ap.Apttus_Approval__Object_Type__c,ap.Related_FAF__c);
                if (bRequire) {                        
                    Boolean ok = Apttus_Approval.ApprovalsWebService.submitforApprovals(ap.Apttus_Approval__Object_Type__c,ap.Related_FAF__c);
                }
                else
                {
// Put some code here to re-queue WM_Q_Controller
                    Decimal iCnt;
                    iCnt = ap.Auto_Approval_Counter__c;
                    ap.Auto_Approval_Counter__c = iCnt - 1;
                    ap.Auto_Approval__c = false;
                    upsert ap;            
                }
            }
    }
}