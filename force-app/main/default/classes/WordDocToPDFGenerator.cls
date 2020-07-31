/*
// In a separate class so that it can be used elsewhere
Created By  : Anudeep Dale
Purpose     : It will read the Print_Template__c field on the FAF object based this it will generate ConvertedDocId

*/

Global with sharing class WordDocToPDFGenerator {
    
    @InvocableMethod             
    public static void convertWordToPDF(List<Id> printFAF) {                               
        for (FAF_Print__c fp: [Select id, Template__c, FAF__c from FAF_Print__c where id in : printFAF]) {              
            ID templateId =  fp.Template__c;             
            
             for (Client_Information__c ci: [Select Platform_Specifics_Count__c from Client_Information__c where FAF_ID__c = : fp.FAF__c limit 1]) {
                 Integer Threshold =  Integer.valueOf(Label.Print_Platform_Specific_Threshold);                
                 if (ci.Platform_Specifics_Count__c > Threshold) {
                     templateId = Label.Print_Template_Exclude_PS;                 
                 }                  
            }

            while (templateId  != null){
                boolean found = false;                          
                for (Apttus__APTS_Template__c tpl: [Select Next_Template__c, Apttus__IsActive__c, Apttus__BusinessObject__c from Apttus__APTS_Template__c where Apttus__IsActive__c = True and Id = : templateId]) {                                  
                    system.debug('::templateId::'+templateId);
                    ID sObjectId = fp.FAF__c;                
                    system.debug('::sObjectId::'+sObjectId);
                    String sObjectType = tpl.Apttus__BusinessObject__c;               
                    String pLevel = 'Full Access';
                    String docFormat = Label.Print_Document_Type;
                    if (docFormat == null || Test.isRunningTest())
                         docFormat = 'PDF';
                    Boolean isDraft = false;
                    String sessionId = UserInfo.getSessionId(); 
                    String serverUrl = System.Url.getSalesforceBaseUrl().toExternalForm() + Label.Print_Merge_Service + UserInfo.getOrganizationId();
                    try{ 
                    if(!Test.isRunningTest()) { 
                        ID docId2 = Apttus.MergeWebService.submitGenerateCustomDoc(tpl.id, sObjectId,sObjectType,pLevel,docFormat,isDraft,sessionId,serverUrl);
                        templateId = null;
                        system.debug('::docId2::'+docId2);
                        fp.Async_Merge_Call__c = docId2;
                        update fp;                     
    
                    }
                    }Catch(Exception e){
                        system.debug('::docId2::'+e.getMessage());
                    }
                    templateId = tpl.Next_Template__c;
                    found = true;
                }
                if (!found)
                    templateId = null;                                                                     
            }
        }           
    }
}