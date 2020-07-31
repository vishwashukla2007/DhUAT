@isTest
public class Invoke_UpdateNetworkPricingTest {
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
         List<Network_Operations__c> npos=new List<Network_Operations__c>();
        Network_Operations__c NetworkOps = new Network_Operations__c(
        client__c = 'No MAC with U&C',
        member__c = 'Lower of U&C or Copay - Standard Copay Logic On',
        Retail_90_Days_Supply_84__c = true,
        Days_Supply__c = 45,
        FAF_ID__c = FAFObj.Id);
        
        npos.add(NetworkOps);
        insert npos;
        
       
        
        List<network_Pricing__c> nplist=new  List<network_Pricing__c>();
        Network_Pricing__c np1 = new Network_Pricing__c();
        np1.FAF_ID__c = FAFObj.Id;
        np1.FAF_Network_Ops__c = npos[0].Id;
        np1.Retail_Network_Ordinal__c = 'Primary';
        np1.Year__c = 'All';
        np1.LOB__c = 'ACT';
       //np1.FAF_ID__r.FAF_Status__c='Uploaded';
        np1.Network_Name__c = 'MC(84-90)CP';
        np1.Brand_Rate__c = 5;
        np1.Invokable_Update__c = true;
        insert np1;
        
        np1.Year__c='2';
        update np1;
        
        np1.Year__c='3';
        update np1;
        
        np1.Year__c='4';
        update np1;
        
        np1.Year__c='5';
        update np1;
        
         np1.Year__c='All';
        update np1;
        
        Retail_Network_Guarantees__c RNG=TestDataFactory.createretntwrkGuarnt(FAFObj.id,NP1.id);
       RNG.Type__c='BER';
       insert RNG;
       
       RNG.Type__c='SSG';
        update RNG;
       
       RNG.Type__c='MER';
       update RNG;
       
       RNG.Type__c='NED';
       update RNG;
       
       RNG.Type__c='GER';
       update RNG;
        
         list<id> fafidsList = new List<ID>();
           for( Network_Operations__c c :npos){
                  fafidsList.add(c.id);
           }
       
       
       
       
      Invoke_UpdateNetworkPricing.UpdateNetworkPricing(fafidsList); 
       
       
        
       
        Test.stopTest();
        
    } 
  
 
     static testmethod void TestMethod2(){
        
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
         List<Network_Operations__c> npos=new List<Network_Operations__c>();
        Network_Operations__c NetworkOps = new Network_Operations__c(
        client__c = 'No MAC with U&C',
        member__c = 'Lower of U&C or Copay - Standard Copay Logic On',
        Retail_90_Days_Supply_84__c = true,
        Days_Supply__c = 45,
        FAF_ID__c = FAFObj.Id);
        
        npos.add(NetworkOps);
        insert npos;
        
       
        
        List<network_Pricing__c> nplist=new  List<network_Pricing__c>();
        Network_Pricing__c np1 = new Network_Pricing__c();
        np1.FAF_ID__c = FAFObj.Id;
        np1.FAF_Network_Ops__c = npos[0].Id;
        np1.Retail_Network_Ordinal__c = 'Primary';
        np1.Year__c = 'All';
        np1.LOB__c = 'ACT';
       //np1.FAF_ID__r.FAF_Status__c='Uploaded';
        np1.Network_Name__c = 'Custom Secondary';
       np1.Template_Network_Name_Text__c = np1.Custom_Network_Description__c+np1.Network_Type__c ;
        np1.Brand_Rate__c = 5;
       // np1.Show_in_Grid__c=false;
        //np1.Specialty_Show_in_Grid__c=true;
        np1.Network_Type__c = 'locked';
         np1.Template_BER_Guarantee_Rate_Text__c=' ';
                 np1.Template_Brand_Rate_Text__c=' ';
                 np1.Template_Generic_Rate_Text__c=' ';
                 np1.Template_GER_Guarantee_Rate_Text__c=' ';
                 np1.Template_MER_Guarantee_Rate_Text__c=' ';
                 np1.Template_NED_Guarantee_Rate_Text__c=' ';
                 np1.Template_Non_MAC_Generic_Rate_Text__c=' ';
                 np1.Template_SSG_Guarantee_Rate_Text__c=' ';
                 np1.Template_Dispensing_Fee_Text__c= ' ';
                 np1.Template_OED_Guarantee_Rate_Text__c=' ';
                 np1.Template_Generic_OR_Mac_Text__c = ' ';
         
         np1.BER_Guarantee_Rate__c = 2.0;
         np1.Invokable_Update__c = false;
        insert np1;
        
        np1.Year__c='2';
        np1.Year_Begin_Date__c = clientINFO1[0].Year_2_Begin_Date__c;
          np1.Year_End_Date__c = clientINFO1[0].Year_2_End_Date__c;
         
        update np1;
        
        np1.Year__c='3';
         np1.Year_Begin_Date__c = clientINFO1[0].Year_3_Begin_Date__c;
              np1.Year_End_Date__c =clientINFO1[0].Year_3_End_Date__c;
        update np1;
        
        np1.Year__c='4';
         np1.Year_Begin_Date__c = clientINFO1[0].Year_4_Begin_Date__c;
              np1.Year_End_Date__c = clientINFO1[0].Year_4_End_Date__c;
        update np1;
        
        np1.Year__c='5';
         np1.Year_Begin_Date__c = clientINFO1[0].Year_5_Begin_Date__c;
              np1.Year_End_Date__c = clientINFO1[0].Year_5_End_Date__c;
        np1.Show_in_Grid__c=false;
        np1.Specialty_Show_in_Grid__c=false;
        update np1;
        
        np1.Year__c='All';
        update np1;
        
    
         list<id> fafidsList = new List<ID>();
           for( Network_Operations__c c :npos){
                  fafidsList.add(c.id);
           }
     
      Invoke_UpdateNetworkPricing.UpdateNetworkPricing(fafidsList); 
    
        Test.stopTest();
       
         
    } 
    
    
     static testmethod void TestMethod3(){
        
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
         List<Network_Operations__c> npos=new List<Network_Operations__c>();
        Network_Operations__c NetworkOps = new Network_Operations__c(
        client__c = 'No MAC with U&C',
        member__c = 'Lower of U&C or Copay - Standard Copay Logic On',
        Retail_90_Days_Supply_84__c = true,
        Days_Supply__c = 45,
        FAF_ID__c = FAFObj.Id);
        
        npos.add(NetworkOps);
        insert npos;
        
       
        
        List<network_Pricing__c> nplist=new  List<network_Pricing__c>();
        Network_Pricing__c np1 = new Network_Pricing__c();
        np1.FAF_ID__c = FAFObj.Id;
        np1.FAF_Network_Ops__c = npos[0].Id;
        np1.Retail_Network_Ordinal__c = 'Primary';
        np1.Year__c = 'All';
        np1.LOB__c = 'ACT';
       //np1.FAF_ID__r.FAF_Status__c='Uploaded';
        np1.Network_Name__c = 'Specialty';
         np1.Custom_Description__c='SPECIALTY AT RETAIL';
       np1.Template_Network_Name_Text__c = np1.Custom_Network_Description__c+np1.Network_Type__c ;
         
        np1.Brand_Rate__c = 5;
       // np1.Show_in_Grid__c=false;
        //np1.Specialty_Show_in_Grid__c=true;
        np1.Network_Type__c = 'locked';
         np1.Template_BER_Guarantee_Rate_Text__c=' ';
                 np1.Template_Brand_Rate_Text__c=' ';
                 np1.Template_Generic_Rate_Text__c=' ';
                 np1.Template_GER_Guarantee_Rate_Text__c=' ';
                 np1.Template_MER_Guarantee_Rate_Text__c=' ';
                 np1.Template_NED_Guarantee_Rate_Text__c=' ';
                 np1.Template_Non_MAC_Generic_Rate_Text__c=' ';
                 np1.Template_SSG_Guarantee_Rate_Text__c=' ';
                 np1.Template_Dispensing_Fee_Text__c= ' ';
                 np1.Template_OED_Guarantee_Rate_Text__c=' ';
                 np1.Template_Generic_OR_Mac_Text__c = ' ';
         
         np1.BER_Guarantee_Rate__c = 2.0;
         np1.Invokable_Update__c = false;
        insert np1;
        
        np1.Year__c='2';
        np1.Year_Begin_Date__c = clientINFO1[0].Year_2_Begin_Date__c;
          np1.Year_End_Date__c = clientINFO1[0].Year_2_End_Date__c;
          np1.Custom_Description__c='RETAIL NON SPECIALTY';
        update np1;
        
        np1.Year__c='3';
         np1.Year_Begin_Date__c = clientINFO1[0].Year_3_Begin_Date__c;
              np1.Year_End_Date__c =clientINFO1[0].Year_3_End_Date__c;
        update np1;
        
        np1.Year__c='4';
         np1.Year_Begin_Date__c = clientINFO1[0].Year_4_Begin_Date__c;
              np1.Year_End_Date__c = clientINFO1[0].Year_4_End_Date__c;
        update np1;
        
        np1.Year__c='5';
         np1.Year_Begin_Date__c = clientINFO1[0].Year_5_Begin_Date__c;
              np1.Year_End_Date__c = clientINFO1[0].Year_5_End_Date__c;
        np1.Show_in_Grid__c=false;
        np1.Specialty_Show_in_Grid__c=false;
        update np1;
        
        np1.Year__c='All';
        update np1;
        
    
         list<id> fafidsList = new List<ID>();
           for( Network_Operations__c c :npos){
                  fafidsList.add(c.id);
           }
     
      Invoke_UpdateNetworkPricing.UpdateNetworkPricing(fafidsList); 
    
        Test.stopTest();
       
         
    } 
  
}