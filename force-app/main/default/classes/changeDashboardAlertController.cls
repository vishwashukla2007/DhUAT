public class changeDashboardAlertController {
	@AuraEnabled // server side action should be auraEnabled
    public static id runJob(String myIdParam) {
        Id batchJobId = null;
        if(myIdParam != null){
            list<Apttus__APTS_Agreement__c> getRec = [SELECT id FROM Apttus__APTS_Agreement__c 
                                            WHERE id =: myIdParam AND RecordType.Name = 'Legal' 
                                            AND PBM_FAF__c != null 
                                            AND FAF_Data_Sync__c = true   
                                            AND Apttus__Status_Category__c IN ('Request','In Authoring','In Signatures','In Filing','In Effect')];
        	if(getRec.size() > 0){
            	batchJobId = Database.executeBatch(new changeDashboardAlertBatch(myIdParam,true), 1);
        	}
        }else{
            batchJobId = Database.executeBatch(new changeDashboardAlertBatch(myIdParam,true), 1);
        }
        
        return batchJobId ;
    }
}