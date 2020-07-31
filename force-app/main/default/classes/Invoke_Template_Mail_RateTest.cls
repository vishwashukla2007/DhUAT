@isTest
public class Invoke_Template_Mail_RateTest {
  //Method 1
    static testmethod void TestMethod1(){
        
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
        List<Client_Information__c> clientINFO1= new List<Client_Information__c>();
        List<Client_Information__c> clientINFO=[select id, year_1__c, year_2__c, year_3__c, year_4__c, year_5__c from
                                             Client_Information__c where FAF_ID__c =:FAFObj.id limit 1];
                                             
            for(Client_Information__c cl:clientINFO){
                
            cl.year_1__c='1';
            cl.Year_1_Begin_Date__c=Date.newInstance(2018,7, 1);
            cl.Year_1_End_Date__c=Date.newInstance(2018, 7,7 );
            
            cl.year_2__c='2';
            cl.Year_2_Begin_Date__c=Date.newInstance(2018,7, 8);
            cl.Year_2_End_Date__c=Date.newInstance(2018,7, 14);
            
            cl.year_3__c='3';
            cl.Year_3_Begin_Date__c=Date.newInstance(2018,7,15);
            cl.Year_3_End_Date__c=Date.newInstance(2018,7,21);
            
            cl.year_4__c='4';
            cl.Year_4_Begin_Date__c=Date.newInstance(2018,7,22);
            cl.Year_4_End_Date__c=Date.newInstance(2018,7,28);
            
            cl.year_5__c='5';
            cl.Year_5_Begin_Date__c=Date.newInstance(2018,7,29);
            cl.Year_5_End_Date__c=Date.newInstance(2018,8,4);
            clientINFO1.add(cl);
            }
            update clientINFO1;
        
        
        Test.startTest();
        List<Mail_Operations__c> mplist=new List<Mail_Operations__c>();
        Mail_Operations__c moObj = new Mail_Operations__c( 
                                        Client__c = 'MAC Prevails then Discount',
                                        Member__c = 'Lower of Discount or Copay - Standard Copay Logic Off',
                                        FAF_ID__c = FAFObj.Id
                                    );
         
        insert moObj; 
        
        Mail_Pricing__c mp = new Mail_Pricing__c();
        mp.FAF_Mail_Operations__c = moObj.Id;
        mp.FAF_ID__c =FAFObj.Id;
        mp.Show_in_Grid__c=true;
        mp.Generic_Basis__c='MAC Modeled & Non-MAC';
        mp.MER_Guarantee_Rate__c=85;
        mp.NED_Guarantee_Rate__c=85 ;
        mp.GER_Guarantee_Rate__c=85;
        mp.Invokable_Update__c=true;
        mp.BER_Guarantee_Rate__c=85;
        mp.SSG_Guarantee_Rate__c=85;
        mp.Year__c='1';
        mp.Brand_Rate__c = 200;
        mp.Generic_Rate__c = 200;
        mp.Preferred_Brand_Rate__c  = 200;
        mp.Non_Preferred_Brand_Rate__c = 200;
        mp.Non_MAC_Generic_Rate__c = 200;
        mp.Show_in_Grid__c=true;
        mp.LOB__c='CAP';
        insert mp;
        
        mp.Year__c='2';
        update mp;
        
        mp.Year__c='3';
        update mp;
        
        mp.Year__c='4';
        update mp;
        
        mp.Year__c='5';
        update mp;
        
        mp.Year__c='All';
        update mp;
        
        Mail_Guarantees__c mg = new Mail_Guarantees__c( Mail_Pricing__c = mp.Id, SSG__C = 'No' );
        insert mg;
        
        list<id> fafidsList = new List<ID>();
        fafidsList.add(moObj.id);
        system.debug('***moObj****'+fafidsList);
        Invoke_Template_Mail_Rate.Template_Mail_Rate(fafidsList); 
        Test.stopTest();
    } 
  
 
    
  
}