/*********************************************************************************************
* @ClassName         : TestDataFactoryCLM
* @author            : Ryan Roque(Accenture)
* @created date      : 05/16/2020
* @Last modified by  : 
* @Last modified date: 
* @Purpose           : This class is use to create data for Test class for CLM        
**********************************************************************************************/
@isTest
public class TestDataFactoryCLM {
    //Create Account Record
    
    public static Account createAccount() {
        Account accObj = new Account();
        accObj.Name = 'testAccount---Anthem';
        accObj.Market_Segment__c = 'Anthem';
        accObj.status__c = 'Active';
        return accObj;
    }
    
    
    //Create Opportunity Record 
    public static Opportunity createOpportunity(Id accId) {
        Opportunity oppObj = new Opportunity();
        oppObj.name = 'testOpp';
        oppObj.AccountId = accId;
        oppObj.CloseDate = Date.today();
        oppObj.StageName='Proposal';
        return oppObj;
    }
    
    
        
    /* ================================================
* @Method Name : createPBMQuestions
* @author : John Paul Revilla
* @Purpose: used to create Test createPBMQuestions data
* @Parameters: NA
* @return: list of PBM_Questions__c 
* @created date:16/01/2020
================================================*/
    public static list<PBM_Questions__c> createPBMQuestions(){
        list<PBM_Questions__c> pbmQuestionList = New List<PBM_Questions__c>();
        PBM_Questions__c pbmQuestion = new PBM_Questions__c();
        
        pbmQuestion.Data_Type__c = 'Text';
        pbmQuestion.Active__c = true;
        pbmQuestion.Field_API__c = 'ERISA_NON_ERISA__c';
        pbmQuestion.Object_API__c = 'Account';
        pbmQuestion.Question__c='ERISA/NON-ERISA';
        pbmQuestion.Sort_Order__c = 1.1;
        pbmQuestion.Section_Header__c = 'Account Info.';
        pbmQuestion.Required__c = true;
        
        pbmQuestionList.add(pbmQuestion);
        pbmQuestion = new PBM_Questions__c();
        pbmQuestion.Data_Type__c = 'Date';
        pbmQuestion.Active__c = true;
        pbmQuestion.Field_API__c = 'Contract_End_Date__c';
        pbmQuestion.Object_API__c = 'Client_Information__c';
        pbmQuestion.Question__c='Contract End Date';
        pbmQuestion.Sort_Order__c = 4.1;
        pbmQuestion.Section_Header__c = 'Client Info.';
        
        pbmQuestionList.add(pbmQuestion);
        pbmQuestion = new PBM_Questions__c();
        pbmQuestion.Data_Type__c = 'Number';
        pbmQuestion.Active__c = true;
        pbmQuestion.Field_API__c = 'Client_Share__c';
        pbmQuestion.Object_API__c = 'Billing_Operations__c';
        pbmQuestion.Question__c='Client Share';
        pbmQuestion.Sort_Order__c = 2.1;
        pbmQuestion.Section_Header__c = 'Billing Operation Info.';
        
        pbmQuestionList.add(pbmQuestion);
        pbmQuestion = new PBM_Questions__c();
        pbmQuestion.Data_Type__c = 'Picklist';
        pbmQuestion.Active__c = true;
        pbmQuestion.Field_API__c = 'iUMS_Client_Subtype__c';
        pbmQuestion.Object_API__c = 'Account';
        pbmQuestion.Question__c='iUMS Client Subtype';
        pbmQuestion.Sort_Order__c = 1;
        pbmQuestion.Section_Header__c = 'Account Info.';
        pbmQuestionList.add(pbmQuestion);
        
        pbmQuestion = new PBM_Questions__c();
        pbmQuestion.Data_Type__c = 'Picklist';
        pbmQuestion.Active__c = true;
        pbmQuestion.Field_API__c = 'Pharmacy_Audit_Retention__c';
        pbmQuestion.Object_API__c = 'Billing_Operations__c';
        pbmQuestion.Question__c='Pharmacy Audit Retention';
        pbmQuestion.Sort_Order__c = 2.0;
        pbmQuestion.Section_Header__c = 'Billing Operation Info.';
        pbmQuestionList.add(pbmQuestion);
        
        pbmQuestion = new PBM_Questions__c();
        pbmQuestion.Data_Type__c = 'Text';
        pbmQuestion.Active__c = true;
        pbmQuestion.Field_API__c = 'Client_Name__c';
        pbmQuestion.Object_API__c = 'Central_Hub__c';
        pbmQuestion.Question__c='Client Name';
        pbmQuestion.Sort_Order__c = 3.0;
        pbmQuestion.Section_Header__c = 'FAF Info.';
        pbmQuestionList.add(pbmQuestion);
        
        pbmQuestion = new PBM_Questions__c();
        pbmQuestion.Data_Type__c = 'Picklist';
        pbmQuestion.Active__c = true;
        pbmQuestion.Field_API__c = 'Segment__c';
        pbmQuestion.Object_API__c = 'Central_Hub__c';
        pbmQuestion.Question__c='Market Segment';
        pbmQuestion.Sort_Order__c = 3.1;
        pbmQuestion.Section_Header__c = 'FAF Info.';
        pbmQuestionList.add(pbmQuestion);
        
        pbmQuestion = new PBM_Questions__c();
        pbmQuestion.Data_Type__c = 'Picklist';
        pbmQuestion.Active__c = true;
        pbmQuestion.Field_API__c = 'Specialty_Rebates__c';
        pbmQuestion.Object_API__c = 'Rebate_Operations__c';
        pbmQuestion.Question__c='Specialty Rebate';
        pbmQuestion.Sort_Order__c = 6.1;
        pbmQuestion.Section_Header__c = 'Rebate Operations Info.';
        pbmQuestionList.add(pbmQuestion);
        
        return pbmQuestionList;
    }
    /* ================================================
* @Method Name : createAgreementData
* @author : John Paul Revilla
* @Purpose: used to create Test Agreement data
* @Parameters: NA
* @return: list of Agreement 
* @created date:21/01/2020
================================================*/
    public static list<Apttus__APTS_Agreement__c> createAgreementData(){
        Account accObj = createAccount();
        insert accObj;
        Opportunity oppObj = createOpportunity(accObj.id);
        insert oppObj;
        
        list<Apttus__APTS_Agreement__c> agreementList = new List<Apttus__APTS_Agreement__c>();
        Apttus__APTS_Agreement__c aggreement=new Apttus__APTS_Agreement__c();
        aggreement.Apttus__Account__c=accObj.id;
        aggreement.Opportunity__c=oppObj.id;
        aggreement.RecordTypeId=Schema.SObjectType.Apttus__APTS_Agreement__c.getRecordTypeInfosByName().get('Legal').getRecordTypeId();
        aggreement.Apttus__Contract_Start_Date__c = system.today();
        agreementList.add(aggreement);
        
        return agreementList;
    }
    /* ================================================
* @Method Name : createiUMSTaskSetup
* @author : John Paul Revilla
* @Purpose: used to create Test iUMS Task Setup data
* @Parameters: NA
* @return: list of iUMS Task Setup 
* @created date:19/02/2020
================================================*/
    public static list<iUMS_Task_Setup__c> createiUMSTaskSetup(){
        List<iUMS_Task_Setup__c> iUmsTaskSetupList = new List<iUMS_Task_Setup__c>();
        Account accObj = createAccount();
        insert accObj;
        iUMS_Task_Setup__c iUmsTaskSetupRec = new iUMS_Task_Setup__c();
        iUmsTaskSetupRec.Task_Id__c = '1234';
        iUmsTaskSetupRec.SRX_Offer__c = 1234;
        iUmsTaskSetupRec.Account__c = accObj.Id;
        iUmsTaskSetupList.add(iUmsTaskSetupRec);
        iUmsTaskSetupRec = new iUMS_Task_Setup__c();
        iUmsTaskSetupRec.Task_Id__c = '12345';
        iUmsTaskSetupRec.SRX_Offer__c = 12345;
        iUmsTaskSetupList.add(iUmsTaskSetupRec);
        
        return iUmsTaskSetupList;
    }
    /* ================================================
* @Method Name : createContentDocumentLink
* @author : John Paul Revilla
* @Purpose: used to create Test Content Document Link data
* @Parameters: name1 = document name 1 , name2 = document name 2
* @return: map of string and Content Document Link <document name , documentlink>
* @created date:19/02/2020
================================================*/
    public static  List<ContentDocumentLink> createContentDocumentLink(string name1, string name2){
        Map<String, ContentVersion> contentVersionMap= new Map<String, ContentVersion>();
        ContentVersion content=new ContentVersion(); 
        content.Title=name1; 
        content.PathOnClient='/' + content.Title + '.jpg'; 
        Blob bodyBlob=Blob.valueOf('Unit Test ContentVersion Body'); 
        content.VersionData=bodyBlob; 
        content.origin = 'H';
        contentVersionMap.put(content.Title, content);
        
        content=new ContentVersion();  
        content.Title=name2; 
        content.PathOnClient='/' + content.Title + '.jpg'; 
        Blob bodyBlob1=Blob.valueOf('Unit Test Content123Version Body'); 
        content.VersionData=bodyBlob1;
        content.origin = 'H';
        contentVersionMap.put(content.Title, content);
        insert contentVersionMap.values();
        
        List<ContentDocumentLink> contentDocList = new List<ContentDocumentLink>();
        ContentDocumentLink contentlink=new ContentDocumentLink();
        contentlink.ShareType= 'v';
        contentlink.ContentDocumentId= contentVersionMap.get(name1).id;
        contentlink.Visibility = 'AllUsers'; 
        contentDocList.add(contentlink);
        
        contentlink = new ContentDocumentLink();
        contentlink.ShareType= 'v'; 
        contentlink.ContentDocumentId= contentVersionMap.get(name2).id;
        contentlink.Visibility = 'AllUsers'; 
        contentDocList.add(contentlink);
        return contentDocList;
        
    }
    /* ================================================
* @Method Name : createAgreementExtension
* @author : Symon Bucay
* @Purpose: used to create Test Agreement Extension data
* @Parameters: NA
* @return: PBS_Agreement_Extension__c object 
* @created date:23/01/2020
================================================*/
    public static PBS_Agreement_Extension__c createAgreementExtension(Id agreementId){
        PBS_Agreement_Extension__c result = new PBS_Agreement_Extension__c();
        result.Client_Name__c='ClientTest';
        result.Agreement__c=agreementId;
        return result;
    }
    
    /* ================================================
* @Method Name : createQuestionsAnswers
* @author : Symon Bucay
* @Purpose: used to create Test Questions Answers data
* @Parameters: NA
* @return: List of PBM_Questions_Answers__c
* @created date:23/01/2020
================================================*/
    public static List<PBM_Questions_Answers__c> createQuestionsAnswers(Id agreementId){
        List<PBM_Questions_Answers__c> result = New List<PBM_Questions_Answers__c>();
        List<PBM_Questions__c> pbmQuestions = createPBMQuestions();
        insert pbmQuestions;
        for (PBM_Questions__c question : pbmQuestions) {
            result.add(New PBM_Questions_Answers__c(PBM_Question__c=question.Id, Agreement__c=agreementId));
        }
        return result;
    }
    
    public static Contract_Request_Form__c createCRF(){
        Contract_Request_Form__c result = new Contract_Request_Form__c();
        result.Effective_Date_of_Contract_or_Amendment__c = system.today();
        result.Term_of_Contract__c = system.today();
        result.CRF_Status__c = 'Draft';
        return result;
    }
    
     public static PBMRequest__c createpbmRequest(){
        PBMRequest__c result = new PBMRequest__c();
        result.Request_Submitted__c = false;        
        return result;
    }
   
}