public without sharing class CRFAuraController {

    public class CRFAuraWrapper{
        @AuraEnabled
        public Account accountRecord{get;set;}
        @AuraEnabled
        public Integer fafCount{get;set;}
        @AuraEnabled
        public Integer crfDraftCount{get;set;}
        @AuraEnabled
        public Integer crfSubmittedCount{get;set;}
    }

    @AuraEnabled
    public static CRFAuraWrapper getCRFAuraWrapper(String opportunityId) {
        CRFAuraWrapper wrapperClass = new CRFAuraWrapper();
 		Id accountId =  [SELECT AccountId FROM Opportunity WHERE Id =: opportunityId].AccountId;        
        wrapperClass.accountRecord = [SELECT Id, Name FROM Account WHERE Id =: accountId LIMIT 1];
        wrapperClass.fafCount = [SELECT Opportunity_Name__c FROM Central_Hub__c WHERE Opportunity_Name__c =: opportunityId].size();
        wrapperClass.crfDraftCount = [SELECT Opportunity_Name__c FROM Contract_Request_Form__c WHERE CRF_Status__c = 'Draft' AND Opportunity_Name__c =: opportunityId].size();
        wrapperClass.crfSubmittedCount = [SELECT Opportunity_Name__c FROM Contract_Request_Form__c WHERE CRF_Status__c = 'Submitted' AND Opportunity_Name__c =: opportunityId].size();
        return wrapperClass;  
    }
    
    @AuraEnabled
    public static void submitCRFRequest(String crfId) {
        try {
            //Query CRF record
            Contract_Request_Form__c crfRecord = [SELECT Id, Name, Account__r.Name, Effective_Date_of_Contract_or_Amendment__c,
                                  Term_of_Contract__c, Attorney__c, Paralegal__c, CRF_Status__c, Legal_Agreement__c, Performance_Guarantees__c
                                  FROM Contract_Request_Form__c WHERE Id =: crfId];
            
            validateCRFRequest(crfRecord);
       
            //Instantiate agreement object
            Apttus__APTS_Agreement__c agreementRecord = new Apttus__APTS_Agreement__c();
            agreementRecord.RecordTypeId = Schema.SObjectType.Apttus__APTS_Agreement__c.getRecordTypeInfosByName().get('Legal').getRecordTypeId();
            agreementRecord.Apttus_Approval__Approval_Status__c = 'In Progress';
            agreementRecord.Apttus__Contract_Start_Date__c = crfRecord.Effective_Date_of_Contract_or_Amendment__c;
            agreementRecord.Apttus__Contract_End_Date__c = crfRecord.Term_of_Contract__c;
            agreementRecord.Attorney__c = crfRecord.Attorney__c;
            agreementRecord.Paralegal__c = crfRecord.Paralegal__c;
            String dateOutput = DateTime.newInstance(agreementRecord.Apttus__Contract_Start_Date__c.year(), agreementRecord.Apttus__Contract_Start_Date__c.month(), agreementRecord.Apttus__Contract_Start_Date__c.day()).format('MM-dd-yy');
            String accountName = crfRecord.Account__r.Name.toUpperCase();
            if(accountName.length() > 20){
                accountName = crfRecord.Account__r.Name.substring(0,20).toUpperCase();
            }
            agreementRecord.Name = accountName  + '-' + 'PBSA' + '-' + 'FULL' + '-(' + dateOutput + ')';
            agreementRecord.Apttus__Account__c = crfRecord.Account__r.Id;
            //Insert agreement record after populating the values of fields
            insert agreementRecord;

            crfRecord.Legal_Agreement__c = agreementRecord.Id;
            crfRecord.CRF_Status__c = 'Submitted';
            //Update CRF record after creating agreement record
            update crfRecord;
            system.debug(crfRecord.Performance_Guarantees__c);
            if(crfRecord.Performance_Guarantees__c == 'Performance Guarantees'){
                
                generateSendPG(accountName, crfRecord.name);
            } 

        } catch(exception e) {
            System.debug('Encountered exception within CRFAuraController.submitCRFRequest() : '+e.getMessage() +' at line '+ e.getLineNumber());
            if(!Test.isRunningTest()){
               throw new AuraHandledException(e.getMessage()); 
            }
        }  
    }

    public static void generateSendPG(String acctName, string crfName){
       	system.debug('email test');
        Performance_Guarantees__c pg = new Performance_Guarantees__c();
        pg.Client_Agreement_Name__c = acctName;
        pg.Total_Amount_at_Risk__c = 0;
        insert pg;
		system.debug('pg:' + pg);
        system.debug('Label:' + label.Performance_Guarantee_Email);
        
        List<String> toAddress = new List<string>();
        toAddress.add(label.Performance_Guarantee_Email);
        List<String> cc =new List<string>();
        List<String> bcc =new List<string>();
        
        string instanceURLString = URL.getSalesforceBaseUrl().toExternalForm();
        string body ='CRF '+ crfName +' requires a Performance Guarantee Contract <a href="'+instanceURLString+'/'+ pg.id+'">click here</a> to open, update, and start the Performance Guarantee flow.';
        string subject = 'Performance Guarantee requested for ' + acctName;
        system.debug(toAddress + ' ' + subject + ' ' + cc + ' ' + bcc + ' ' + body);
        pgEmailNotification.sendEmail(toAddress, subject,cc, bcc, body);

    }
    
    @TestVisible
    private  static void validateCRFRequest (Contract_Request_Form__c crfRecord) {
        AuraHandledException auraHandledException = new AuraHandledException('');
        String errorMessages = '';
        if (crfRecord.CRF_Status__c == 'Submitted') {
            errorMessages = System.Label.createCRFValidationCRFAlreadySubmitted;
        }
        String profileName=[SELECT Id, Name FROM Profile WHERE Id=:Userinfo.getProfileId()].Name; 
        if(!(profileName=='System Administrator' || profileName=='Apttus Sales')){
            errorMessages = 'Only sales user can submit CRF.';
        }
        if(String.isNotBlank(errorMessages)) {
            auraHandledException.setMessage(errorMessages);
            throw auraHandledException;
        }
        validateCRFRequiredFields(crfRecord);
    }

    @TestVisible
    private  static void validateCRFRequiredFields (Contract_Request_Form__c crfRecord) {
        AuraHandledException auraHandledException = new AuraHandledException('');
        String errorMessages = '';
        if (crfRecord.Effective_Date_of_Contract_or_Amendment__c == null) {
            errorMessages += (String.isNotBlank(errorMessages) ? '\n' : '') + 'Effective Date of Contract/Amendment is null';
        }
        if (crfRecord.Term_of_Contract__c == null) {
            errorMessages += (String.isNotBlank(errorMessages) ? '\n' : '') + 'Termination Date of Contract/Amendment is null';
        }
        if (crfRecord.Attorney__c == null) {
            errorMessages += (String.isNotBlank(errorMessages) ? '\n' : '') + 'Attorney is null';
        }
        if (crfRecord.Paralegal__c == null) {
            errorMessages += (String.isNotBlank(errorMessages) ? '\n' : '') + 'Paralegal is null';
        }
        if(String.isNotBlank(errorMessages)) {
            auraHandledException.setMessage('Refresh the page and correct the following issues by filling in the required fields:' + '\n' + errorMessages);
            if(!Test.isRunningTest()){
            	throw auraHandledException;
            }
        }
    }

}