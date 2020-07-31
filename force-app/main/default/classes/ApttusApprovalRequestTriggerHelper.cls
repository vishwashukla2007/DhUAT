Public with sharing class ApttusApprovalRequestTriggerHelper {

    
    public void RelatedFAF(List<Apttus_Approval__Approval_Request__c> aarList) {
        
        list<Id> RelatedFAFIds = new list<Id>();
        list<Id> RelatedPGIds = new list<Id>();
        
        for (Apttus_Approval__Approval_Request__c rqst: aarList) {
           
           If(rqst.Apttus_Approval__Object_Type__c == 'central_hub__c') {
            if (rqst.Apttus_Approval__Assigned_To_Id__c != null && rqst.Apttus_Approval__ObjectRefId__c != null && rqst.Related_FAF__c == null) {            
                 // we need to Assign FAF Id
                rqst.Related_FAF__c = rqst.Apttus_Approval__ObjectRefId__c;
                if (rqst.Apttus_Approval__Send_Email__c == true)
                    rqst.Assigned_User__c  = rqst.Apttus_Approval__Assigned_To_Id__c;
            }   

            if (rqst.Related_FAF__c != null ) {
                RelatedFAFIds.add(rqst.Related_FAF__c);
            }
          }else{
          
                 if(rqst.Apttus_Approval__Object_Type__c == 'Performance_Guarantees__c') {
                 for (Apttus_Approval__Approval_Request__c rqst1: aarList) {
            
                 if (rqst1.Apttus_Approval__Assigned_To_Id__c != null && rqst1.Apttus_Approval__ObjectRefId__c != null && rqst1.Related_Performance_Guarantees__c == null) {            
                 // we need to Assign PG Id
                rqst1.Related_Performance_Guarantees__c = rqst.Apttus_Approval__ObjectRefId__c;
                if (rqst.Apttus_Approval__Send_Email__c == true && rqst.Apttus_Approval__Assigned_To_Type__c != 'Queue')
                    rqst1.Assigned_User__c  = rqst.Apttus_Approval__Assigned_To_Id__c;
            }   
          
            }
        }
          
          }
            
            
        }
   
        if (RelatedFAFIds.size() > 0) {     
            map<Id,Central_Hub__c> RelatedFAFs = new map<Id,Central_Hub__c>([SELECT Id, TAT_Due_Date__c, Client_Info__c,Holidays__c FROM Central_Hub__c WHERE Id IN :RelatedFAFIds]);       
            
            for (Apttus_Approval__Approval_Request__c rqst: aarList) {
            
                if (rqst.Related_FAF__c != null && RelatedFAFs != null) {
                    Central_Hub__c RelatedFAF = RelatedFAFs.get(rqst.Related_FAF__c);
                    if (RelatedFAF != NULL){  //this record is guaranteed to exist. 
                    
                        if(RelatedFAF.TAT_Due_Date__c != null) {
                            // Here we are assigning Assign Due Date
                           rqst.TAT_Due_Date__c = RelatedFAF.TAT_Due_Date__c;
                           rqst.Turnaround_Time__c = rqst.TAT_Due_Date__c.format();
                        }
                        if(RelatedFAF.Client_Info__c != null) {
                            // Here we are assigning Client Info
                            rqst.Related_Client_Information__c = RelatedFAF.Client_Info__c;
                        } 
                    }
                }
                            
             }
        }        
        
    }



}