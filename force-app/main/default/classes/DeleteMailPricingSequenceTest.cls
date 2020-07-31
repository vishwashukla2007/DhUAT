/* =================================================================================
* @Class Name        : DeleteMailPricingSequenceTest
* @author            : Parvathi Chunduri (parvathi.chunduri@cvshealth.com)
* @created date      : 02/18/2020
* @Purpose           : Test coverage for DeleteMailPricingSequence
=======================================================================================*/
@isTest
public class DeleteMailPricingSequenceTest {
    
     Static testmethod void DeleteMailPricing(){
         User salesperson = ClientTestRef.createUser('Apttus Sales');
        insert salesperson;
                
        Account accObj =  ClientTestRef.createAccount();
        insert accObj;
        Opportunity oppObj = ClientTestRef.createOpportunity(accObj.id);
        insert oppObj;
        Central_Hub__c FAFObj = ClientTestRef.createFAF(accObj.id, oppObj.Id, salesperson.Id);
        insert FAFObj;
        FAFObj.FAF_Status__c='Uploaded';
        Update FAFObj;
        
        Client_Information__c clientInfo2 = TestDataFactory.createClientInfo(FAFObj.id);
        insert clientInfo2;      
        
        List<Mail_Operations__c> mplist=new List<Mail_Operations__c>();
        Mail_Operations__c moObj = new Mail_Operations__c( 
                                        Client__c = 'MAC Prevails then Discount',
                                        Member__c = 'Lower of Discount or Copay - Standard Copay Logic Off',
                                        FAF_ID__c = FAFObj.Id
                                    );
        mplist.add(moObj);
        insert mplist; 
        
        Mail_Pricing__c mp = new Mail_Pricing__c();
        mp.FAF_Mail_Operations__c = moObj.Id;
        mp.FAF_ID__c =FAFObj.Id;
        mp.Year__c = '1';
        mp.Sequence_Number__c = 1;
        mp.LOB__c = 'STD';
        insert  mp;
            
        mp.Sequence_Number__c = 2;
        Update mp;
         
        mp.Sequence_Number__c = 3;
        Update mp;
         
        Mail_Pricing__c mp2 = new Mail_Pricing__c();
        mp2.FAF_Mail_Operations__c = moObj.Id;
        mp2.FAF_ID__c =FAFObj.Id;
        mp2.Year__c = '2';
        mp2.Sequence_Number__c = 4;
        mp2.LOB__c = 'STD';
        insert  mp2;
         
         List<String> fafidsList = new List<String>();
        for( Mail_Operations__c c :[select name from Mail_Operations__c]){
                  fafidsList.add(c.name);
        } 
        Mail_Sequence_Setting__c  mss = new Mail_Sequence_Setting__c();
        mss.LOB__c = mp.LOB__c;
        mss.Sequence_Number__c =  mp.Sequence_Number__c;
        mss.FAF_ID__c = FAFObj.id;
        mss.Mail_Operation_ID__c = fafidsList[0];
        insert mss;
        
        Test.startTest();
        DeleteMailPricingSequence.deleteSequence(fafidsList);
        Test.stopTest();  
        DeleteMailPricingSequence.deleteSequence(fafidsList);
   
     }

}