@isTest
public class Invoke_GridDisplayNameNetworkPriTest {
  //Method 1
    static testmethod void Invoke_GridDisplayNameNetworkPriMethod1(){
        
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
        
            Grid_Display_Name_Setting__c gridDisp= new Grid_Display_Name_Setting__c();
            gridDisp.FAF__c =FAFObj.id;
            gridDisp.Object_Name__c='Network Pricing';
            insert gridDisp;
        
        Test.startTest();
        Network_Operations__c NetworkOps = new Network_Operations__c(
        client__c = 'No MAC with U&C',
        member__c = 'Lower of U&C or Copay - Standard Copay Logic On',
        Retail_90_Days_Supply_84__c = true,
        Days_Supply__c = 45,
        FAF_ID__c = FAFObj.Id);
        insert NetworkOps;
        
        List<Id> nOlist=new  List<Id>();
        Network_Pricing__c np1 = new Network_Pricing__c();
        np1.FAF_ID__c = FAFObj.Id;
        np1.FAF_Network_Ops__c = NetworkOps.Id;
        np1.Retail_Network_Ordinal__c = 'Primary';
        np1.Year__c = 'All';
        np1.LOB__c = 'ACT';
       //np1.FAF_ID__r.FAF_Status__c='Uploaded';
        np1.Network_Name__c = 'MC(84-90)CP';
        np1.Brand_Rate__c = 5;
        np1.Custom_Description__c='test';
        np1.Network_Type__c='Locked';
        insert np1;
        
        nOlist.add(NetworkOps.id);
        
        Invoke_GridDisplayNameNetworkPricing.UpdateGridName(nOlist); 
        Test.stopTest();
    } 
  }