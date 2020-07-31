@isTest
public class Invoke_PCD_WarningTest{
  //Method 1
    static testmethod void TestMethod1(){
        
        User salesperson = ClientTestRef.createUser('Apttus Sales');
        insert salesperson;
                
        Account accObj =  ClientTestRef.createAccount();
        insert accObj;
        
        Opportunity oppObj = ClientTestRef.createOpportunity(accObj.id);
        insert oppObj;
        
        
        
        Task__c tk=new Task__c();
        tk.Account__c=accObj.id;
        tk.Opportunity__c=oppObj.id;
        insert tk;
        
        Offer__c offr=new Offer__c();
        //offr.Account__c=accObj.id;
        offr.iUMSTask__c=tk.id;
        //offr.Agreement__c=agr.id;
        //offr.PCD__c=agr.id;
        insert offr;
        
        Apttus__APTS_Agreement__c agr=new Apttus__APTS_Agreement__c();
        agr.Name='PCD';
        agr.Offer__c=offr.id; 
        insert agr;
        
          
        LOB__c lb=new LOB__c();
        lb.Client_Pricing_Offer__c=offr.id;
        lb.Agreement__c=agr.id;
        //lb.FAF__c=FAFObj.id;
        insert lb;
        
        PCD_FAF_Status__mdt FAFStatus = [SELECT Value__c FROM PCD_FAF_Status__mdt LIMIT 1]; 
        List<string> FAFStat = new List<string>();
        for(string s: FAFStatus.Value__c.split(',')){
             FAFStat.add(s);
        }        
        List<Central_Hub__c> fablist=new List<Central_Hub__c>();
        Central_Hub__c FAFObj = ClientTestRef.createFAF(accObj.id, oppObj.Id, salesperson.Id);
        insert FAFObj;
        FAFObj.FAF_Status__c=FAFStat[0];
        FAFObj.LOB_ID__c=lb.id;
        FAFObj.Agreement__c=agr.id;
        FAFObj.PCD_Warning__c='test';
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
        np1.Template_Network_Name_Text__c='test';
         np1.Generic_Basis__c='MAC Modeled & Non-MAC';
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
          list<id> offeridsList = new List<ID>();
          offeridsList.add(offr.id);
          
           for(Central_Hub__c  c :fablist){
                  fafidsList.add(c.id);
           }
       Invoke_PCD_Warning.Invoke_PCD_Warning_Update(fafidsList); 
       Invoke_PCD_Warning_Offer.Invoke_PCD_Warning_Update_Offer(offeridsList);
       Invoke_Update_FAF.Invoke_Update_FAF_Update(fafidsList); 
       Invoke_Update_FAF.Invoke_Update_FAF_Update_Async(fafidsList);
        Test.stopTest();
        
    } 
    
}