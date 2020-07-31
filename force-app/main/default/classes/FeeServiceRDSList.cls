public class FeeServiceRDSList {
    
    @AuraEnabled
    public static DataWrapper getFeeservicechildlist( String RecordId,string srchKey,string recordLimit, String recordOffset) {
        DataWrapper wrap = new DataWrapper();
        try{
            string typeStr = 'PBM';
            string fields = ' Id, Name,Approved_Date__c,Link__c,Status__c,Basis__c,Service_Effective_Date__c,Section_Limited__c,Notes__c,Basis2__c,Section__c,Service_Description__c,Amount__c,Election__c,Additional_Service__c,Service__c,Changed__c,Last_Date_Modified__c,Service_Description2__c,Service_Last_Modified_Date__c,Error_Message__c ';
            string condition = 'FROM Retiree_Drug_Subsidy__c where Fee_Services__c = :RecordId';
            
            if(String.isNotBlank(srchKey))
            {
                String searchString = '%' + srchKey + '%';                
                condition +=' And (name like \''+searchString+'\' or Section__c like \''+searchString+'\' or Service__c like \''+searchString+'\' or Basis2__c like \''+searchString+'\' )';
            }            
            wrap.totalRecords = database.countQuery('select count()'+condition);
            string query = 'Select '+fields+condition;
            query += ' LIMIT '+recordLimit+' Offset '+recordOffset; 
            system.debug('query=='+query);
            wrap.listRDSServices =  database.query(query);
            system.debug(RecordId +' :  size : '+ wrap.listRDSServices.size());
            wrap.message = 'PBMServices records are loaded';
            wrap.success = true;
            Profile prof = [Select Name From Profile where Id=:Userinfo.getProfileId()];
            wrap.profileName = prof.Name;
        }
        catch(Exception e){
            wrap.message = e.getMessage();
            wrap.success = false;
        }
        return wrap;
    }
    
    @AuraEnabled    
    public static void updateRDSServiceReview(List<Retiree_Drug_Subsidy__c> updatedRDSServiceList)
    {
        try{
            for(Retiree_Drug_Subsidy__c rds : updatedRDSServiceList)
            {
                rds.Service_Request_Date__c = Datetime.now();
                rds.Status__c = 'Review';
            }
            update updatedRDSServiceList;
        }
        catch (Exception e) {        
            throw new AuraHandledException(e.getMessage());    
        } 
    }
    
    @AuraEnabled    
    public static void updateRDSService(List<Retiree_Drug_Subsidy__c> updatedRDSServiceList,boolean approve)
    {
        try{
            if(approve)
            {
                for(Retiree_Drug_Subsidy__c rds : updatedRDSServiceList)
                {
                    rds.Approved_Date__c = Datetime.now();
                    rds.Status__c = 'Approved';
                }
            }
            update updatedRDSServiceList;
        }
        catch (Exception e) {        
            throw new AuraHandledException(e.getMessage());    
        } 
    }  
    // wrapper class
    public class DataWrapper{
        @AuraEnabled
        public Integer totalRecords = 0;
        @AuraEnabled
        public List<Retiree_Drug_Subsidy__c> listRDSServices = new List<Retiree_Drug_Subsidy__c>();
        @AuraEnabled
        public String message;
        @AuraEnabled
        public Boolean success;
        @AuraEnabled
        public String profileName;
    }
}