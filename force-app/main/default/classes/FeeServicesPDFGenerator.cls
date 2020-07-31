Global with sharing class FeeServicesPDFGenerator {
    
    @InvocableMethod             
    public static void FeeServicesPDFGenerator(List<Id> FeeService) {                               
        for (Fee_Services__c fp: [Select id, Template_Default__c,Output_Format__c from Fee_Services__c where id in : FeeService]) {              
            String templateName =  fp.Template_Default__c; 
            String sFormat = fp.Output_Format__c;                        
            ID templateId;
            while (templateName != null){
                boolean found = false;                          
                for (Apttus__APTS_Template__c tpl: [Select Next_Template__c, Apttus__IsActive__c, Apttus__BusinessObject__c from Apttus__APTS_Template__c where Apttus__IsActive__c = True and Name = : templateName]) {                                  
                    templateId =  tpl.Id;
                    templateName = null;  
                    system.debug('::templateId::'+templateId);                       
                    ID sObjectId = fp.Id;                
                    system.debug('::sObjectId::'+sObjectId);
                    String sObjectType = tpl.Apttus__BusinessObject__c;               
                    String pLevel = 'Full Access';
                    String docFormat = 'DOCX'; 
                    if (sFormat == 'PDF')   
                         docFormat = 'PDF';
                         
                    Boolean isDraft = false;                    
                    String sessionId = UserInfo.getSessionId(); 

                    PageReference reportPage = Page.currentUserInfoCtrl;
                    String vfContent = reportPage.getContent().toString();
                    Integer startP = vfContent.indexOf('Start_Of_Session_Id') + 'Start_Of_Session_Id'.length(),
                    endP = vfContent.indexOf('End_Of_Session_Id');
                    sessionId = vfContent.substring(startP, endP);  
                                  
                    String serverUrl = System.Url.getSalesforceBaseUrl().toExternalForm() + Label.Print_Merge_Service + UserInfo.getOrganizationId();
                    try{ 
                    if(!Test.isRunningTest()) { 
                        ID docId2 = Apttus.MergeWebService.submitGenerateCustomDoc(tpl.id, sObjectId,sObjectType,pLevel,docFormat,isDraft,sessionId,serverUrl);
                        system.debug('::docId2::'+docId2);
//                        fp.Async_Merge_Call__c = docId2;
                        update fp;                     
    
                    }
                    }Catch(Exception e){
                        system.debug('::docId2::'+e.getMessage());
                    }
                    if (tpl.Next_Template__c != null) 
                        templateName = tpl.Next_Template__r.Name;
                    found = true;
                }
                if (!found)
                    templateName = null;                                                                     
            }
        }           
    }
}