public without sharing class ContractRequestFormHelper {

    public static void validateContractRequestForm(List<Contract_Request_Form__c> crfList) {
        try {
            System.debug('crfList: ' + crfList);
            Set<Id> opportunityIds = new Set<Id>();
            for(Contract_Request_Form__c crfRecord : crfList) {
                opportunityIds.add(crfRecord.Opportunity_Name__c);
            }
            Map<Id, Contract_Request_Form__c> existingCrfRecordMap = new Map<Id, Contract_Request_Form__c>(); 
            for(Contract_Request_Form__c crfRecord : [SELECT Id, Opportunity_Name__c, CRF_Status__c 
                                                        FROM Contract_Request_Form__c 
                                                        WHERE Opportunity_Name__c =: opportunityIds]) {
                if (!existingCrfRecordMap.containsKey(crfRecord.Opportunity_Name__c)) {
                    existingCrfRecordMap.put(crfRecord.Opportunity_Name__c, crfRecord);
                }                                            
            }
            System.debug('existingCrfRecordMap: ' + existingCrfRecordMap);
            for(Contract_Request_Form__c crfRecord : crfList) {
                if (existingCrfRecordMap.containsKey(crfRecord.Opportunity_Name__c)) {
                    Contract_Request_Form__c existingCrfRecord = existingCrfRecordMap.get(crfRecord.Opportunity_Name__c);
                    if (existingCrfRecord.CRF_Status__c == 'Draft') {
                        crfRecord.addError(System.Label.createCRFValidationCRFAlreadyCreated);
                    }else if(existingCrfRecord.CRF_Status__c == 'Submitted') {
                        crfRecord.addError(System.Label.createCRFValidationCRFAlreadySubmitted);
                    }
                }  
            }
        } catch(exception e){crfList[0].addError(e.getDmlMessage(0)); }
    }

}