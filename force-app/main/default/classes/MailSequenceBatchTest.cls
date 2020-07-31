@isTest
public class MailSequenceBatchTest {
     Static testmethod void MailSequenceBatch(){
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
        
        Test.startTest();
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
        mp.Sequence_Number__c = 1;
        insert mp;
            
        Mail_Sequence_Setting__c  mss = new Mail_Sequence_Setting__c();
        mss.LOB__c = 'STD';
        mss.Sequence_Number__c = 1;
        mss.FAF_ID__c = FAFObj.id;
        mss.Mail_Operation_ID__c = moObj.Id;
        insert mss;
        
        Mail_Sequence_Setting__c  mss1 = new Mail_Sequence_Setting__c();
        mss1.LOB__c = 'RET';
        mss1.Sequence_Number__c = mp.Sequence_Number__c;
        mss1.FAF_ID__c = FAFObj.id;
        mss1.Mail_Operation_ID__c = moObj.Id;
        insert mss1;
         
        Delete mss1;
        
        set<id> fafidsList = new set<ID>();
        for( Mail_Operations__c c :mplist){
                  fafidsList.add(c.id);
        }
        try{
          // MailSequenceBatch msBatch = new MailSequenceBatch(fafidsList); 
         //  Database.executeBatch(msBatch);
        }catch(Exception e){}
        
        Test.stopTest();  
        
    }

}