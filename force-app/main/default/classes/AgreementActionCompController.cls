public without sharing class AgreementActionCompController {
    @AuraEnabled
    public static Performance_Guarantees__c getPGInformation(string id){
        Performance_Guarantees__c pgData = [Select id, Name, Status__c, Primary_Approver__c,Submitted_For_Approval_By__c, Client_Agreement_Name__c,FAF__r.Opportunity_Name__r.id from Performance_Guarantees__c where ID =: id];
        return pgData;
    }
    @AuraEnabled
    public static Boolean generateDocument(Performance_Guarantees__c pgData){
        try
        {
        String sessionId = UserInfo.getSessionId(); 
        PageReference reportPage = Page.currentUserInfoCtrl;
         // Get the content of the VF page
        if(!test.isRunningTest()){
            String vfContent = reportPage.getContent().toString();
            System.debug('vfContent '+vfContent);
            // Find the position of Start_Of_Session_Id and End_Of_Session_Id
            Integer startP = vfContent.indexOf('Start_Of_Session_Id') + 'Start_Of_Session_Id'.length(),
            endP = vfContent.indexOf('End_Of_Session_Id');
            // Get the Session Id
            sessionId = vfContent.substring(startP, endP);  
        }
        else{
            sessionId = 'session Id';
        }
        Apttus__APTS_Template__c tpl = [Select Id,Next_Template__c, Apttus__IsActive__c,Apttus__BusinessObject__c from Apttus__APTS_Template__c where Apttus__IsActive__c = True and Name=:Label.Performance_Guarantees ];    
        String sObjectType = tpl.Apttus__BusinessObject__c;    
        String pLevel = 'Full Access';  
        String docFormat = 'DOC';
        Boolean isDraft = false;
        String fileName = 'PG_'+ pgData.Client_Agreement_Name__c +'_' + string.valueOf(date.today());
        //String serverUrl = Label.PCD_Generation_URL; 
        String serverUrl =  System.Url.getSalesforceBaseUrl().toExternalForm() + Label.Print_Merge_Service + UserInfo.getOrganizationId();
        ID sObjectId = pgData.Id;
        //ID docId2 = Apttus.MergeWebService.submitGenerateCustomDoc(tpl.Id, sObjectId,sObjectType,pLevel,docFormat,isDraft,sessionId,serverUrl);     
        if(!test.isRunningTest()){
            ID docId2 = Apttus.MergeWebService.generateCustomDoc2(tpl.Id, sObjectId,sObjectType,pLevel,docFormat, fileName,isDraft,sessionId,serverUrl);    
        }
        else{
            blob b = blob.valueof('TEST');
            Attachment a = new Attachment();
            a.body = b;
            a.name = 'test.pdf';
            a.parentid = pgData.Id;
            insert a;
        }
        
        
      
        //generateCustomDoc(Id templateId, Id sObjectId, String sObjectType, String pLevel, String docFormat, Boolean isDraft, String sessionId, String serverUrl)
        //generateCustomDoc2(Id templateId, Id sObjectId, String sObjectType, String pLevel, String docFormat, String outputFileName, Boolean isDraft, String sessionId, String serverUrl)
        return true; 
        }
       catch(exception e){
           throw new AuraHandledException(e.getMessage());
        }
    }
}