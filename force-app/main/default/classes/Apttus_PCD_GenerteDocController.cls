public class Apttus_PCD_GenerteDocController {
    
   /* @AuraEnabled
    public static List < Apttus__APTS_Template__c > getTemplates() {
        
        return [select id,Name,Apttus__Agreement_Types__c,Apttus__Guidance__c, Apttus__Category__c, Apttus__Subcategory__c from Apttus__APTS_Template__c where Apttus__Agreement_Types__c='PCD' ];
        
    }*/
    
    //Get Template Records with type PCD
    @AuraEnabled
    public static List < Apttus__APTS_Template__c > getTemplates(String pageSize, String pageNumber){
        Integer psize = Integer.valueOf(pageSize);
        Integer pnumber = Integer.valueOf(pageNumber)-1;
         
        List<Apttus__APTS_Template__c> templateList = [select id,Name,Apttus__Agreement_Types__c,Apttus__Guidance__c, Apttus__Category__c, Apttus__Subcategory__c from Apttus__APTS_Template__c 
                                 where Apttus__Agreement_Types__c='PCD' LIMIT :psize OFFSET :(psize*pnumber)];
        return templateList;
    }
    
    
    @AuraEnabled
    public static String createDocVersionRecord(List<id> selectedRowList, String selectedfiletype, String agreementid){
        try
        {
        List<Apttus__APTS_Template__c> SelectedTempList =[select id,Name,Apttus__Agreement_Types__c,Apttus__Guidance__c, Apttus__Category__c, Apttus__Subcategory__c from Apttus__APTS_Template__c 
                                 where id IN :selectedRowList];
        List<Apttus__DocumentVersion__c> DocVerObj = [select id,name from Apttus__DocumentVersion__c where Apttus__AgreementId__c = :agreementid ];
       
        if (DocVerObj != null)
        {
        List<Apttus__DocumentVersionDetail__c> DocVersionDetilObj = [select id,Agreement__c,LOB_Detail__c,Name,Apttus__Title__c,Apttus__DocumentVersionId__c,
                                                               Apttus__VersionMajor__c,Apttus__VersionMinor__c,Apttus__VersionRevision__c
                                                               from Apttus__DocumentVersionDetail__c where Apttus__DocumentVersionId__c= :DocVerObj[0].Id
                                                               order by Apttus__VersionMajor__c,Apttus__VersionMinor__c,Apttus__VersionRevision__c desc
                                                               Limit 1];
       
            
        Apttus__DocumentVersionDetail__c Docversiondtlobj = new Apttus__DocumentVersionDetail__c();
        Docversiondtlobj.Name = '';
        Docversiondtlobj.Agreement__c = agreementid;
        Docversiondtlobj.Apttus__Title__c= '';
        Docversiondtlobj.Apttus__DocumentVersionId__c=DocVerObj[0].Id;
        Docversiondtlobj.Apttus__Action2__c = 'Generate Agreement';
        Docversiondtlobj.Apttus__FileType__c = selectedfiletype;
        Database.SaveResult result = Database.insert(Docversiondtlobj, false);
        }
          
        
        
       return 'success';
        }
       catch(exception e){
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    @AuraEnabled  
    public static void mergedocument(String agrid, String filetype){
        try
        {
        String sessionId = UserInfo.getSessionId(); 
        PageReference reportPage = Page.currentUserInfoCtrl;
         // Get the content of the VF page
         String vfContent = reportPage.getContent().toString();
         System.debug('vfContent '+vfContent);
         // Find the position of Start_Of_Session_Id and End_Of_Session_Id
         Integer startP = vfContent.indexOf('Start_Of_Session_Id') + 'Start_Of_Session_Id'.length(),
         endP = vfContent.indexOf('End_Of_Session_Id');
         // Get the Session Id
         sessionId = vfContent.substring(startP, endP);   
        Apttus__APTS_Template__c tpl = [Select Id,Next_Template__c, Apttus__IsActive__c,Apttus__BusinessObject__c from Apttus__APTS_Template__c where Apttus__IsActive__c = True and Name= :Label.PCD_Template_Name ];    
        String sObjectType = tpl.Apttus__BusinessObject__c;    
        String pLevel = 'Full Access';  
        String docFormat;
        Boolean isDraft;
        if (filetype == 'docx')
        {
         docFormat = 'DOC';
         isDraft = false;
        }
        else
        {
         docFormat = 'PDF';
         isDraft = false;
        }
        //String serverUrl = Label.PCD_Generation_URL; 
        String serverUrl =  System.Url.getSalesforceBaseUrl().toExternalForm() + Label.Print_Merge_Service + UserInfo.getOrganizationId();
        ID sObjectId = agrid;
        //ID docId2 = Apttus.MergeWebService.submitGenerateCustomDoc(tpl.Id, sObjectId,sObjectType,pLevel,docFormat,isDraft,sessionId,serverUrl);     
        ID docId2 = Apttus.MergeWebService.generateDoc2(tpl.Id, sObjectId,pLevel,docFormat,isDraft,sessionId,serverUrl);    
            
        }
       catch(exception e){
            throw new AuraHandledException(e.getMessage());
        }
    }
}