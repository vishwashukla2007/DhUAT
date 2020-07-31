public with sharing class PCD_Extract_Question_Answer {
  
  
@AuraEnabled
public static List<PCD_Question_Answer__c> Extract_Question_Answer(String recordId) {
List<PCD_Question_Answer__c> pcdqs = new List<PCD_Question_Answer__c>();
List<Id> Ids = new List<Id>();
Ids.add(recordId);
pcdqs = [Select Id,Are_there_Any_Changes__c from PCD_Question_Answer__c where Id IN: Ids];
return pcdqs;
}

@AuraEnabled        
public static List<String> getPickListValuesIntoList(){
List<String> pickListValuesList = new List<String>();
Schema.DescribeFieldResult fieldResult = PCD_Question_Answer__c.Are_there_Any_Changes__c.getDescribe();
List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
for( Schema.PicklistEntry pickListVal : ple)
{
  pickListValuesList.add(pickListVal.getLabel());
}     
  return pickListValuesList;
 }
}