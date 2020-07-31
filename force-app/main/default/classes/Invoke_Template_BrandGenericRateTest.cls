@isTest
public class Invoke_Template_BrandGenericRateTest{
  //Method 1
    static testmethod void TestMethod1(){
        
        User salesperson = ClientTestRef.createUser('Apttus Sales');
        insert salesperson;
                
        Account accObj =  ClientTestRef.createAccount();
        insert accObj;
        Opportunity oppObj = ClientTestRef.createOpportunity(accObj.id);
        insert oppObj;
        
       PCD_FAF_Status__mdt FAFStatus = [SELECT Value__c FROM PCD_FAF_Status__mdt LIMIT 1]; 
        List<string> FAFStat = new List<string>();
        for(string s: FAFStatus.Value__c.split(','))
           {
             FAFStat.add(s);
          }        
        List<Central_Hub__c> fablist=new List<Central_Hub__c>();
        Central_Hub__c FAFObj = ClientTestRef.createFAF(accObj.id, oppObj.Id, salesperson.Id);
        insert FAFObj;
        //FAFObj.FAF_Status__c='Uploaded';
        FAFObj.FAF_Status__c=FAFStat[0];
       //  FAFObj.LOB2__c = 'EGWP';
        Update FAFObj;
        fablist.add(FAFObj);
        
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
        np1.LOB__c = 'ACT';
       // np1.Network_Name__c = 'Med D - IHS';
        np1.Brand_Rate__c = 5;
        np1.Show_in_Grid__c=true;
        np1.Template_Network_Name_Text__c='test';
      
      
       //added by Par
       np1.Network_Name__c = 'MC(84-90)CP';
       np1.Specialty_Show_in_Grid__c =true;
       np1.Generic_Basis__c='MAC Modeled & Non-MAC';     
       np1.OED_Guarantee_Rate__c = 5;
       np1.MER_Guarantee_Rate__c =5;
       np1.Brand_Basis__c='Baked-Preferred & Non-Preferred';
       //np1.Brand_Basis__c='Standard Brand Discount';
       np1.Template_Preferred_Brand_Rate_Text__c = ' ';     
       np1.Template_Non_Preferred_Brand_Rate_Text__c  = ' ';
       np1.Template_Preferred_Display__c=false;
       np1.Template_Brand_Rate_Text__c = '';
       np1.Template_Brand_Display__c = false;
       np1.Template_Generic_Display__c =true;
       np1.Template_Generic_Rate_Text__c ='test';
       np1.Template_OED_Guarantee_Rate_Text__c = ' ';
       np1.Template_OED_Display__c= true;
       np1.Template_GER_Guarantee_Rate_Text__c = ' ';
       np1.Template_GER_Display__c = true;  
       np1.Template_Non_MAC_Generic_Rate_Text__c ='Mac' + '\n' + 'Non – MAC:' + '\n';
       np1.MER_Guarantee_Rate__c=8.0;
       np1.NED_Guarantee_Rate__c=8.0;
       np1.GER_Guarantee_Rate__c=8.0;
       np1.BER_Guarantee_Rate__c=8.0;
       np1.SSG_Guarantee_Rate__c=8.0;
       np1.Template_MER_Guarantee_Rate_Text__c = ' ';
       np1.Template_MER_Display__c = false; 
       np1.Template_NED_Guarantee_Rate_Text__c = ' ';
       np1.Template_NED_Display__c = false;  
       np1.Template_Generic_OR_Mac_Text__c = ' ';
       np1.Template_NonMacGeneric_Display__c = true;
       np1.Template_SSG_Guarantee_Rate_Text__c = 'test'; 
       np1.SSG_Display__c = true; 
       //np1.Template_Brand_Rate__c = 2.0;
      // np1.Template_Generic_Rate__c = 8.0;
        
       
       insert np1;
        
        np1.Year__c='2';
        update np1;
        
        np1.Year__c='3';
        update np1;
        
        np1.Year__c='4';
        update np1;
        
        np1.Year__c='5';
        update np1;
        
        // np1.Year__c='All';
        ///update np1;
       
        
         Network_Pricing__c np2 = new Network_Pricing__c();
        np2.FAF_ID__c = FAFObj.Id;
        np2.FAF_Network_Ops__c = npos[0].Id;
        np2.Retail_Network_Ordinal__c = 'Primary';
        np2.LOB__c = 'ACT';
        np2.Specialty_Show_in_Grid__c =false;
        np2.Show_in_Grid__c=false;
       // np2.Brand_Basis__c = 'Pass_Through'+'Testing';
       
        insert np2;
        
        Retail_Network_Guarantees__c RNG=TestDataFactory.createretntwrkGuarnt(FAFObj.id,NP1.id);
       RNG.Type__c='BER';
       RNG.SSG__c = 'No';
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
           for(Network_Operations__c  c :npos){
                  fafidsList.add(c.id);
           }
        Invoke_Template_BrandGenericRate.Template_BrandGenericRate(fafidsList); 
        Invoke_Template_BERGuaranteeRate.Template_BERGuaranteeRate(fafidsList); 
        //Invoke_Template_BrandGenericRate_All.UpdateNetworkPricingBrandRate_All(fafidsList); 
        Test.stopTest();
        
    } 
    static testmethod void TestMethod2(){
        
        User salesperson = ClientTestRef.createUser('Apttus Sales');
        insert salesperson;
                
        Account accObj =  ClientTestRef.createAccount();
        insert accObj;
        Opportunity oppObj = ClientTestRef.createOpportunity(accObj.id);
        insert oppObj;
        
       PCD_FAF_Status__mdt FAFStatus = [SELECT Value__c FROM PCD_FAF_Status__mdt LIMIT 1]; 
        List<string> FAFStat = new List<string>();
        for(string s: FAFStatus.Value__c.split(','))
           {
             FAFStat.add(s);
          }        
        List<Central_Hub__c> fablist=new List<Central_Hub__c>();
        Central_Hub__c FAFObj = ClientTestRef.createFAF(accObj.id, oppObj.Id, salesperson.Id);
        insert FAFObj;
        //FAFObj.FAF_Status__c='Uploaded';
        FAFObj.FAF_Status__c=FAFStat[0];
        //FAFObj.LOB2__c = 'EGFI';
        Update FAFObj;
        fablist.add(FAFObj);
        
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
        np1.LOB__c = 'ACT';
        np1.Network_Name__c = 'MC(84-90)CP';
        np1.Brand_Rate__c = 5;
        np1.Show_in_Grid__c=true;
        np1.Network_Name_for_Grid__c='test';
        np1.Template_Network_Name_Text__c='test';
       //added by Par
        np1.Generic_Basis__c='MAC Modeled & Non-MAC';
        np1.Specialty_Show_in_Grid__c =true;
        np1.OED_Guarantee_Rate__c = 5;
       // np1.MER_Guarantee_Rate__c =5;
       //np1.Brand_Basis__c='Baked-Preferred & Non-Preferred';
       np1.Brand_Basis__c='Standard Brand Discount';
       np1.Template_Non_MAC_Generic_Rate_Text__c = 'test';
       np1.Template_BER_Guarantee_Rate_Text__c = '';
       np1.MER_Guarantee_Rate__c=8.0;
       np1.NED_Guarantee_Rate__c=8.0;
       np1.GER_Guarantee_Rate__c=8.0;
       np1.BER_Guarantee_Rate__c=8.0;
       np1.SSG_Guarantee_Rate__c=8.0;
       np1.Template_Preferred_Brand_Rate_Text__c = ' ';     
       np1.Template_Non_Preferred_Brand_Rate_Text__c  = ' ';
       np1.Template_Preferred_Display__c=false;
       np1.Template_Brand_Rate_Text__c = '';
       np1.Template_Brand_Display__c = false;
       np1.Template_Generic_Display__c =true;
       np1.Template_Non_MAC_Generic_Display__c = false;
       np1.Template_Generic_Rate_Text__c ='test';
       np1.Template_OED_Guarantee_Rate_Text__c = ' ';
       np1.Template_OED_Display__c=false;
       np1.Template_GER_Guarantee_Rate_Text__c = ' ';
       np1.Template_GER_Display__c = false;  
       np1.SSG_Display__c =true;
              
       insert np1;
        
       np1.Year__c='All';
       update np1;
       
        Network_Pricing__c np2 = new Network_Pricing__c();
         np2.FAF_ID__c = FAFObj.Id;
         np2.FAF_Network_Ops__c = npos[0].Id;
         np2.Retail_Network_Ordinal__c = 'Primary';
         np2.LOB__c = 'ACT';
         np2.Specialty_Show_in_Grid__c =false;
         np2.Show_in_Grid__c=false;
         np2.Invokable_Update__c=true;
         np2.Batch_Update__c=false;
         np2.Template_Generic_Display__c = false;
         np2.Show_in_Grid__c = false;
         np2.Specialty_Show_in_Grid__c = false;
         np2.SSG_Display__c =false;
         insert np2;
        
     
        
      Retail_Network_Guarantees__c RNG=TestDataFactory.createretntwrkGuarnt(FAFObj.id,NP1.id);
       RNG.Type__c='BER';
       RNG.SSG__c = 'No';
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
           for(Network_Operations__c  c :npos){
                  fafidsList.add(c.id);
           }
       
        Invoke_Template_BrandGenericRate_All.UpdateNetworkPricingBrandRate_All(fafidsList); 
        Invoke_Template_BERGuaranteeRate_All.Template_BERGuaranteeRate_All(fafidsList); 
        Test.stopTest();
        
    } 
  
 //Method 3
    static testmethod void TestMethod3(){
        
        User salesperson = ClientTestRef.createUser('Apttus Sales');
        insert salesperson;
                
        Account accObj =  ClientTestRef.createAccount();
        insert accObj;
        Opportunity oppObj = ClientTestRef.createOpportunity(accObj.id);
        insert oppObj;
        
       PCD_FAF_Status__mdt FAFStatus = [SELECT Value__c FROM PCD_FAF_Status__mdt LIMIT 1]; 
        List<string> FAFStat = new List<string>();
        for(string s: FAFStatus.Value__c.split(','))
           {
             FAFStat.add(s);
          }        
        List<Central_Hub__c> fablist=new List<Central_Hub__c>();
        Central_Hub__c FAFObj = ClientTestRef.createFAF(accObj.id, oppObj.Id, salesperson.Id);
        FAFObj.LOB2__c='EGWP';
        insert FAFObj;
        //FAFObj.FAF_Status__c='Uploaded';
        FAFObj.FAF_Status__c=FAFStat[0];
       //  FAFObj.LOB2__c = 'EGWP';
        Update FAFObj;
        fablist.add(FAFObj);
        
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
        np1.LOB__c = 'ACT';
       // np1.Network_Name__c = 'Med D - IHS';
        np1.Brand_Rate__c = 5;
        np1.Show_in_Grid__c=true;
        np1.Template_Network_Name_Text__c='test';
      
      
       //added by Par
       np1.Brand_Dispensing_Fee__c = 2.3;
       np1.Network_Name__c = 'Med D - TER';
       //np1.Network_Name__c = 'MC(84-90)CP';
       np1.Specialty_Show_in_Grid__c = true;
       np1.Generic_Basis__c='Pass-Through';     
       np1.OED_Guarantee_Rate__c = 5;
       np1.MER_Guarantee_Rate__c =5;
       //np1.Brand_Basis__c='Baked-Preferred & Non-Preferred';
       np1.Brand_Basis__c='Standard Brand Discount';
       np1.Template_Preferred_Brand_Rate_Text__c = ' ';     
       np1.Template_Non_Preferred_Brand_Rate_Text__c  = ' ';
       np1.Template_Preferred_Display__c=false;
       np1.Template_Brand_Rate_Text__c = '';
       np1.Template_Brand_Display__c = false;
       np1.Template_Generic_Display__c =true;
       np1.Template_Generic_Rate_Text__c ='test';
       np1.Template_OED_Guarantee_Rate_Text__c = ' ';
       np1.Template_OED_Display__c= true;
       np1.Template_GER_Guarantee_Rate_Text__c = ' ';
       np1.Template_GER_Display__c = true;  
       np1.Template_Non_MAC_Generic_Rate_Text__c ='Mac' + '\n' + 'Non – MAC:' + '\n';
       np1.MER_Guarantee_Rate__c=8.0;
       np1.NED_Guarantee_Rate__c=8.0;
       np1.GER_Guarantee_Rate__c=8.0;
       np1.BER_Guarantee_Rate__c=8.0;
       np1.SSG_Guarantee_Rate__c=8.0;
       np1.Template_MER_Guarantee_Rate_Text__c = ' ';
       np1.Template_MER_Display__c = false; 
       np1.Template_NED_Guarantee_Rate_Text__c = ' ';
       np1.Template_NED_Display__c = false;  
       np1.Template_Generic_OR_Mac_Text__c = ' ';
       np1.Template_NonMacGeneric_Display__c = true;
       np1.Template_SSG_Guarantee_Rate_Text__c = 'test'; 
       np1.SSG_Display__c = true; 
       
        
       
       insert np1;
        
        np1.Year__c='2';
        update np1;
        
        np1.Year__c='3';
        update np1;
        
        np1.Year__c='4';
        update np1;
        
        np1.Year__c='5';
        update np1;
        
        //np1.Year__c='All';
        //update np1;
       
        
        Network_Pricing__c np2 = new Network_Pricing__c();
        np2.FAF_ID__c = FAFObj.Id;
        np2.FAF_Network_Ops__c = npos[0].Id;
        np2.Retail_Network_Ordinal__c = 'Primary';
        np2.LOB__c = 'ACT';
        np2.Specialty_Show_in_Grid__c =false;
        np2.Show_in_Grid__c=false;
     
        insert np2;
        
        Retail_Network_Guarantees__c RNG=TestDataFactory.createretntwrkGuarnt(FAFObj.id,NP1.id);
       RNG.Type__c='BER';
       RNG.SSG__c = 'No';
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
           for(Network_Operations__c  c :npos){
                  fafidsList.add(c.id);
           }
        Invoke_Template_BrandGenericRate.Template_BrandGenericRate(fafidsList); 
        Invoke_Template_BERGuaranteeRate.Template_BERGuaranteeRate(fafidsList); 
        //Invoke_Template_BrandGenericRate_All.UpdateNetworkPricingBrandRate_All(fafidsList); 
        Test.stopTest();
        
    } 
//Method 4
    static testmethod void TestMethod4(){
        
        User salesperson = ClientTestRef.createUser('Apttus Sales');
        insert salesperson;
                
        Account accObj =  ClientTestRef.createAccount();
        insert accObj;
        Opportunity oppObj = ClientTestRef.createOpportunity(accObj.id);
        insert oppObj;
        
       PCD_FAF_Status__mdt FAFStatus = [SELECT Value__c FROM PCD_FAF_Status__mdt LIMIT 1]; 
        List<string> FAFStat = new List<string>();
        for(string s: FAFStatus.Value__c.split(','))
           {
             FAFStat.add(s);
          }        
        List<Central_Hub__c> fablist=new List<Central_Hub__c>();
        Central_Hub__c FAFObj = ClientTestRef.createFAF(accObj.id, oppObj.Id, salesperson.Id);
        FAFObj.LOB2__c='EGWP';
        insert FAFObj;
        FAFObj.FAF_Status__c='Uploaded';
        FAFObj.FAF_Status__c=FAFStat[0];
       //  FAFObj.LOB2__c = 'EGWP';
        Update FAFObj;
        fablist.add(FAFObj);
        
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
        np1.Retail_Network_Ordinal__c = 'Tertiary';
        np1.LOB__c = 'ACT';
       // np1.Network_Name__c = 'Med D - IHS';
        np1.Brand_Rate__c = 5;
        np1.Generic_Rate__c  = 5;
        np1.Show_in_Grid__c=true;
        np1.Template_Network_Name_Text__c='test';
      
      
       //added by Par
       np1.Brand_Dispensing_Fee__c = 2.3;
       np1.Network_Name__c = 'Med D - IHS';
       //np1.Network_Name__c = 'MC(84-90)CP';
       np1.Specialty_Show_in_Grid__c =true;
       np1.Generic_Basis__c='Pass-Through';     
       np1.OED_Guarantee_Rate__c = 5;
       np1.MER_Guarantee_Rate__c =5;
       np1.Brand_Basis__c='Baked-Preferred & Non-Preferred';
       //np1.Brand_Basis__c='Standard Brand Discount';
       np1.Template_Preferred_Brand_Rate_Text__c = ' ';     
       np1.Template_Non_Preferred_Brand_Rate_Text__c  = ' ';
       np1.Template_Preferred_Display__c=false;
       np1.Template_Brand_Rate_Text__c = '';
       np1.Template_Brand_Display__c = false;
       np1.Template_Generic_Display__c =true;
       np1.Template_Generic_Rate_Text__c ='test';
       np1.Template_OED_Guarantee_Rate_Text__c = ' ';
       np1.Template_OED_Display__c= true;
       np1.Template_GER_Guarantee_Rate_Text__c = ' ';
       np1.Template_GER_Display__c = true;  
       np1.Template_Non_MAC_Generic_Rate_Text__c ='Mac' + '\n' + 'Non – MAC:' + '\n';
       np1.MER_Guarantee_Rate__c=8.0;
       np1.NED_Guarantee_Rate__c=8.0;
       np1.GER_Guarantee_Rate__c=8.0;
       np1.BER_Guarantee_Rate__c=8.0;
       np1.SSG_Guarantee_Rate__c=8.0;
       np1.Template_MER_Guarantee_Rate_Text__c = ' ';
       np1.Template_MER_Display__c = false; 
       np1.Template_NED_Guarantee_Rate_Text__c = ' ';
       np1.Template_NED_Display__c = false;  
       np1.Template_Generic_OR_Mac_Text__c = ' ';
       np1.Template_NonMacGeneric_Display__c = true;
       np1.Template_SSG_Guarantee_Rate_Text__c = 'test';
       np1.Network_Name_for_Grid__c='test'; 
       np1.SSG_Display__c = true;     
       
       insert np1;
        /*
        np1.Year__c='2';
        update np1;
        
        np1.Year__c='3';
        update np1;
        
        np1.Year__c='4';
        update np1;
        
        np1.Year__c='5';
        update np1;
        */
        np1.Year__c='All';
        update np1;
       
        
        Network_Pricing__c np2 = new Network_Pricing__c();
        np2.FAF_ID__c = FAFObj.Id;
        np2.FAF_Network_Ops__c = npos[0].Id;
        np2.Retail_Network_Ordinal__c = 'Primary';
        np2.LOB__c = 'ACT';
        np2.Specialty_Show_in_Grid__c =false;
        np2.Show_in_Grid__c=false;
        np2.Generic_Basis__c='MAC Modeled & Non-MAC';
        np2.Network_Name_for_Grid__c = 'test';
        np2.Template_Network_Name_Text__c='test';
        //np2.Template_Generic_Rate__c = 8.0;
        np2.Year__c='All';
              
        insert np2;
        
       Retail_Network_Guarantees__c RNG=TestDataFactory.createretntwrkGuarnt(FAFObj.id,NP1.id);
       RNG.Type__c='BER';
       RNG.SSG__c = 'No';
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
           for(Network_Operations__c  c :npos){
                  fafidsList.add(c.id);
           }
   
        Invoke_Template_BrandGenericRate_All.UpdateNetworkPricingBrandRate_All(fafidsList); 
        Invoke_Template_BERGuaranteeRate_All.Template_BERGuaranteeRate_All(fafidsList); 
        Test.stopTest();
        
    } 
    
  
}