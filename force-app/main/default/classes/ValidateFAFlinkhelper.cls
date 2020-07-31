public without sharing class ValidateFAFlinkhelper { 
public static void validateLinkFAF(List<Central_Hub__c> FAFList) {
        
        Set<ID> fafIds = new Set<ID>();  
        Set<ID> fafIdFulls = new Set<ID>();  
        Map<id,Integer> partialCountMap = new Map<id,Integer>(); 
        Map<id,Integer> fullCountMap = new Map<id,Integer>(); 
        List<FAF_Link__c> allRecofFaf = new List<FAF_Link__c>();
        /**
        Changes for W-000497 Salesforce Backlog FAF Linking not required for Partial FAF 
        which belong to TPA or Coalition Master/Member clients :Mohit Srivastava
        **/
        for(Central_Hub__c faf: FAFList){        
            if(faf.FAF_Type__c == 'Partial' &&  faf.FAF_Status__c == 'Implemented'
                 && faf.Client_Subtype__c!= system.label.ClientType_TPA_Member && faf.Client_Subtype__c!=system.label.ClientType_TPA_Master
                        && faf.Client_Subtype__c!=system.label.ClientType_Coalition_Member
                            && faf.Client_Subtype__c!=system.label.ClientType_Coalition_Master
                            && faf.Client_Subtype__c!=system.label.ClientType_Health_Plan_Member
                           && faf.Client_Subtype__c!=system.label.ClientType_Health_Plan_Master)
            { 
                fafIds.add(faf.id);                  
            }
        } 
        
        list<FAF_Link__c>  fafLinkList = [select id,Full_FAF__c,Partial_FAF__c from FAF_Link__c where Full_FAF__c in: fafIds and Partial_FAF__r.Faf_type__c LIKE 'Full%'];
        list<FAF_Link__c>  fafLinkFullList = [select id,Full_FAF__c,Partial_FAF__c from FAF_Link__c where Partial_FAF__c in: fafIds and Full_FAF__r.Faf_type__c LIKE 'Full%']; 
       
        for(FAF_Link__c fLink: fafLinkList ){
            partialCountMap.put(fLink.Full_FAF__c,1);        
        } 
        for(FAF_Link__c fLink: fafLinkFullList ){
            partialCountMap.put(fLink.Partial_FAF__c,1);        
        }           
        /**
        Changes for W-000497 Salesforce Backlog FAF Linking not required for Partial FAF 
        which belong to TPA or Coalition Master/Member clients :Mohit Srivastava
        **/
        for(Central_Hub__c faf: FAFList){
            if(faf.FAF_Type__c == 'Partial' &&  faf.FAF_Status__c == 'Implemented'
                    && faf.Client_Subtype__c!=system.label.ClientType_TPA_Member && faf.Client_Subtype__c!=system.label.ClientType_TPA_Master
                        && faf.Client_Subtype__c!=system.label.ClientType_Coalition_Member
                            && faf.Client_Subtype__c!=system.label.ClientType_Coalition_Master
                               && faf.Client_Subtype__c!=system.label.ClientType_Health_Plan_Member
                                && faf.Client_Subtype__c!=system.label.ClientType_Health_Plan_Master)
                                 {
                                if(partialCountMap.keyset().contains(faf.Id)){
                                     //do nothing
                                }else{
                                    if(!Test.isRunningTest()){
                                   /* List<Central_Hub__c> updatedList = new List<Central_Hub__c>();
                                    List<Central_Hub__c> fafupdate = [Select Id, Error_Message__c from Central_Hub__c];
                                    for(Central_Hub__c ch:fafupdate){
                                         ch.Error_Message__c= ch.Error_Message__c + 'The current Partial FAF needs to be linked to an existing Full FAF.';
                                          updatedList.add(ch);
                                                                    }
                                    update updatedList;
                                     faf.Error_Message__c = 'The current Partial FAF needs to be linked to an existing Full FAF.';
                                     update faf; */
                                    faf.addError('The current Partial FAF needs to be linked to an existing Full FAF.');
                                    }
                                }
            }
        }          
    }

}