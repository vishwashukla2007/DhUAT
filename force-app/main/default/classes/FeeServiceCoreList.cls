public class FeeServiceCoreList {
    
    @AuraEnabled
    public static DataWrapper getFeeserviceCorelist( String RecordId,string srchKey,string recordLimit, String recordOffset) {
        DataWrapper wrap = new DataWrapper();
        try{
            //string typeStr = 'PBM';
            string fields = ' Id, Name,Fee_Services__c,Section__c,Sequence__c, Service__c,Service_Description2__c';
            string condition = '  FROM PBM_Core_Services__c Where Fee_Services__c = :RecordId';
            
            if(String.isNotBlank(srchKey))
            {
                String searchString = '%' + srchKey + '%';                
                //condition +=' And (name like \''+searchString+'\' or Section__c like \''+searchString+'\' or Service__c like \''+searchString+'\' or Basis2__c like \''+searchString+'\' )';
            	condition +=' And (Section__c like \''+searchString+'\' or Service__c like \''+searchString+'\')';
            }            
            wrap.totalRecords = database.countQuery('select count()'+condition);
            string query = 'Select '+fields+condition;
            query += ' LIMIT '+recordLimit+' Offset '+recordOffset; 
            system.debug('query=='+query);
            wrap.listCoreServices =  database.query(query);
            system.debug(RecordId +' :  size : '+ wrap.listCoreServices.size());
            wrap.message = 'CoreServices records are loaded';
            wrap.success = true;
            //Profile prof = [Select Name From Profile where Id=:Userinfo.getProfileId()];
            //wrap.profileName = prof.Name;
        }
        catch(Exception e){
            wrap.message = e.getMessage();
            wrap.success = false;
        }
        return wrap;
    }
    
    // wrapper class
    public class DataWrapper{
        @AuraEnabled
        public Integer totalRecords = 0;
        @AuraEnabled
        public List<PBM_Core_Services__c> listCoreServices = new List<PBM_Core_Services__c>();
        @AuraEnabled
        public String message;
        @AuraEnabled
        public Boolean success;
        //@AuraEnabled
        //public String profileName;
    }
}