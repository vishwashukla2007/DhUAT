public with sharing class ErrorLogHelper {
    @AuraEnabled(cacheable=true)
    public static boolean InsertErrors(List<Error_Log__c> errorList) {
        boolean isSuccess = true;
        Database.SaveResult[] errInsertList = Database.insert(errorList, false);
		List<Message__c> errMessageList = [Select Id from Message__c  ORDER BY Name ASC LIMIT 1];
        List<Error_Log__c> errlogList = new List<Error_Log__c>();
        for (Database.SaveResult sr : errInsertList) {
            if (!sr.isSuccess()){
                // Operation failed, so get all errors                
                for(Database.Error err : sr.getErrors()) {
                    Error_Log__c errLogRec = new Error_Log__c();
                    errLogRec.Code_Name__c = 'ErrorLogHelper';
                    errLogRec.Code_Section__c = 'InsertErrors';
                    errLogRec.Message_Number__c = errMessageList[0].id;
                    errLogRec.Record_Id__c = errorList[0].Record_Id__c;
                    errLogRec.System_Generated_Error__c = err.getMessage();
                    errlogList.add(errLogRec);
                }
                if(isSuccess)
                    isSuccess = false;
               
            }
        }
        insert errlogList;
        return isSuccess;
    }

    @AuraEnabled(cacheable=true)
    public static map<string, list<Message__c>> getErrorMessages(List<string> messageTitleList) {
        List<Message__c> errMessageList = [Select 	Message_Code__c,Message__c,Message_Title__c, Message_Type__c from Message__c where Message_Code__c in: messageTitleList];
        map<string, list<Message__c>> errMessagesReturn = new map<string, list<Message__c>>();
        for(Message__c errMessage : errMessageList){
            if(!errMessagesReturn.containsKey(errMessage.Message_Code__c)){
                errMessagesReturn.put(errMessage.Message__c, new  list<Message__c>{errMessage});
            }
            else{
                List<Message__c> errMessageval = errMessagesReturn.get(errMessage.Message_Code__c);
                errMessageval.add(errMessage);
            }
            
        }
        return errMessagesReturn;
    }
}