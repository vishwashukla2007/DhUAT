@isTest
public class Apttus_GridObjectdataSequenceTest {

      Static testmethod void updateMPSeqTest(){
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
          
        Apttus__APTS_Agreement__c agr=new Apttus__APTS_Agreement__c();
        agr.Apttus__Account__c=accObj.id;
        agr.Opportunity__c=oppObj.id;
        insert agr;
            
         Apttus__AgreementLineItem__c agrline=new Apttus__AgreementLineItem__c();
         agrline.Apttus__AgreementId__c=agr.id;
         agrline.PCD_FAF__c=FAFObj.id;
         agrline.Apttus_CMConfig__LineNumber__c=0;
         agrline.Apttus_CMConfig__ItemSequence__c=0;
         insert agrline;  
        
        //List<Mail_Operations__c> mplist=new List<Mail_Operations__c>();
        Mail_Operations__c moObj = new Mail_Operations__c( 
                                        Client__c = 'MAC Prevails then Discount',
                                        Member__c = 'Lower of Discount or Copay - Standard Copay Logic Off',
                                        FAF_ID__c = FAFObj.Id
                                    );
        //mplist.add(moObj);
        insert moObj; 
        
        Mail_Pricing__c mp = new Mail_Pricing__c();
        mp.FAF_Mail_Operations__c = moObj.Id;
        mp.FAF_ID__c =FAFObj.Id;
        mp.Year__c = '1';
        mp.Sequence_Number__c = 1;
        mp.LOB__c = 'STD';
        mp.Agreement_Line_Item__c = agrline.id;
        insert  mp;
         
        Mail_Pricing__c mp2 = new Mail_Pricing__c();
        mp2.FAF_Mail_Operations__c = moObj.Id;
        mp2.FAF_ID__c =FAFObj.Id;
        mp2.Year__c = '2';
        mp2.Sequence_Number__c = 2;
        mp2.LOB__c = 'ACT';
        mp2.Agreement_Line_Item__c = agrline.id;  
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
        Mail_Sequence_Setting__c  mss2 = new Mail_Sequence_Setting__c();
        mss2.LOB__c = mp2.LOB__c;
        mss2.Sequence_Number__c =  mp2.Sequence_Number__c;
        mss2.FAF_ID__c = FAFObj.id;
        mss2.Mail_Operation_ID__c = fafidsList[0];
        insert mss2;  
        Mail_Pricing__c mailPc = [Select id, Sequence_Number__c, Agreement_Line_Item__r.name, LOB__c, FAF_ID__r.name, 
                                  FAF_Mail_Operations__c, FAF_Mail_Operations__r.name, FAF_Mail_Operations__r.Mail_Max_Sequence__c, FAF_Mail_Operations__r.Mail_Min_Sequence__c  
                                  from Mail_Pricing__c where id=:String.valueOf(mp.id)]; 
        /*System.assertNotEquals(null, mailPc.Agreement_Line_Item__r.name);
        System.assertNotEquals(null, mailPc.FAF_Mail_Operations__r.name);
        System.assertNotEquals(null, mailPc.FAF_Mail_Operations__r.Mail_Max_Sequence__c);
        System.assertNotEquals(null, mailPc.FAF_Mail_Operations__r.Mail_Min_Sequence__c); */
        System.debug('@@@@@@ '+ mailPc.FAF_Mail_Operations__r.Mail_Max_Sequence__c + ' '+ mailPc.FAF_Mail_Operations__r.Mail_Min_Sequence__c);  
        Test.startTest();
        Apttus_gridObjectDataSequence.updateMPSeq(String.valueOf(mp.id), null, null, '2', false);
        Apttus_gridObjectDataSequence.updateMPSeq(String.valueOf(mp.id), null, null, '1', false);  
        Test.stopTest();
   
     }
}