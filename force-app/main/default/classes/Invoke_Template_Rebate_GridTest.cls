@isTest
public class Invoke_Template_Rebate_GridTest {
  //Method 1
    static testmethod void TestMethod1(){
        User underwriter= ClientTestRef.createuwUser('Apttus Underwriting');
        insert underwriter;
        User salesperson= new User(
        ProfileId = [SELECT Id FROM Profile WHERE Name = 'Apttus Sales'].Id,
        LastName = 'lastsales',
        Email = 'abcsales1@test.com',
        Username = 'abcsales1@test.com' + System.currentTimeMillis(),
        CompanyName = 'TEST',
        Title = 'title',
        Alias = 'alias1',
        TimeZoneSidKey = 'America/Los_Angeles',
        EmailEncodingKey = 'UTF-8',
        LanguageLocaleKey = 'en_US',
        LocaleSidKey = 'en_US',
        Market_Segment__c = 'Anthem');

        System.RunAs(underwriter)
        {
        List<Rebate_Gtees_Specialty_Class_Carve_Outs__c> rglist=new List<Rebate_Gtees_Specialty_Class_Carve_Outs__c>(); 
         List<Rebate_Guarantees__c> rgObjList=new List<Rebate_Guarantees__c>();

         
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
        
      
        List<Rebate_Operations__c> rolist=new List<Rebate_Operations__c>();
        Rebate_Operations__c roObj = new Rebate_Operations__c( 
                                        Guaranteed_Net_Cost_Gnc_Guarantee__c = 'No',
                                        Specialty_Rebates__c = 'Do Not Pass to Client',
                                        Rebate_Contract_Type__c = 'Group Purchase Organization (GPO)',
                                        Rebate_Offering_Type__c ='Guarantee Only',
                                        Percentage_Guarantee__c = false,
                                        FAF_ID__c = FAFObj.Id
        );
        rolist.add(roObj);
        insert rolist; 
        
        Rebate_Guarantees__c rg = new Rebate_Guarantees__c();
        rg.Rebate_Operations__c = roObj.Id;
        rg.FAF_ID__c =FAFObj.Id;
        rg.Show_in_Specialty_Grid__c=true;
        rg.Show_in_Non_Specialty_Grid__c=true;
        rg.Year__c='1';
        rg.LOB2__c = 'ACT';
        rg.GSTP__C='HPGST';
        rg.Plan_Design__c = '2 Tier Q';
        rg.Specialty_Formulary__c ='Advanced Control Specialty Formulary';
        rg.Non_Specialty_Formulary_2__c ='Comm Standard Control with PA';
        rg.Template_Specialty_Grid_Name_Text__c= 'ACT' + '-' + 'CVS Health Advanced Control Specialty Formulary' + '-' + '2 TIER QUALIFYING';
        rg.Template_Non_Specialty_Grid_Name_Text__c=  'ACT' + '-' + 'Comm Standard Control with PA' + '-' + '2 TIER QUALIFYING' + '-' + 'HPGST';
        
        rg.Retail_30__c = 1;
        rg.Retail_90__c = 1;
        rg.Client_Owned_30__c = 1;
        rg.Client_Owned_90__c = 1;
        rg.Mail__c = 1;
        rg.Mchoice__c = 1;
        rg.Specialty_Retail__c = 1;
        rg.UniqueCheck__c=true;
        rg.PCD_Aggregate_Rate__c='1111111';
        rg.Template_ClientOwned_Display__c=true;
        rg.Template_Retail30_Display__c =true;   
        rg.Template_Retail90_Display__c=true;
        rg.Template_Rcurve_Display__c=true;
        rg.Template_Mail_Display__c=true;
        rg.Template_Mail_Display__c=true;

        rgObjList.add(rg);
        
        
        Rebate_Guarantees__c rg1 = new Rebate_Guarantees__c();
        rg1.Rebate_Operations__c = roObj.Id;
        rg1.FAF_ID__c =FAFObj.Id;
        rg1.Show_in_Specialty_Grid__c=true;
        rg1.Show_in_Non_Specialty_Grid__c=true;
        rg1.Year__c='2';
        rg1.LOB2__c = 'ACT';
        rg1.GSTP__C='HPGST';
        rg1.Plan_Design__c = '2 Tier Q';
        rg1.Specialty_Formulary__c ='Advanced Control Specialty Formulary';
        rg1.Non_Specialty_Formulary_2__c ='Comm Standard Control with PA';
        rg1.Template_Specialty_Grid_Name_Text__c= 'ACT' + '-' + 'CVS Health Advanced Control Specialty Formulary' + '-' + '2 TIER QUALIFYING';
        rg1.Template_Non_Specialty_Grid_Name_Text__c=  'ACT' + '-' + 'Comm Standard Control with PA' + '-' + '2 TIER QUALIFYING' + '-' + 'HPGST';
       
        rg1.Retail_30__c = 1;
        rg1.Retail_90__c = 1;
        rg1.Client_Owned_30__c = 1;
        rg1.Client_Owned_90__c = 1;
        rg1.Mail__c = 1;
        rg1.Mchoice__c = 1;
        rg1.Specialty_Retail__c = 1;
        rg1.PCD_Aggregate_Rate__c='2';
        rg1.Basis__c='All Rx';
        rg1.UniqueCheck__c=true;
        rg1.Template_ClientOwned_Display__c=true;
         rg1.Template_Retail30_Display__c =true;   
         rg1.Template_Retail90_Display__c=true;
         rg1.Template_Rcurve_Display__c=true;
         rg1.Template_Mail_Display__c=true;
         rg1.Template_Mail_Display__c=true;

       rgObjList.add(rg1);
        
        Rebate_Guarantees__c rg2 = new Rebate_Guarantees__c();
        rg2.Rebate_Operations__c = roObj.Id;
        rg2.FAF_ID__c =FAFObj.Id;
        rg2.Show_in_Specialty_Grid__c=true;
        rg2.Show_in_Non_Specialty_Grid__c=true;
        rg2.Year__c='3';
        rg2.LOB2__c = 'ACT';
        rg2.GSTP__C='HPGST';
        rg2.Plan_Design__c = '2 Tier Q';
        rg2.Specialty_Formulary__c ='Advanced Control Specialty Formulary';
        rg2.Non_Specialty_Formulary_2__c ='Comm Standard Control with PA';
        rg2.Template_Specialty_Grid_Name_Text__c= 'ACT' + '-' + 'CVS Health Advanced Control Specialty Formulary' + '-' + '2 TIER QUALIFYING';
        rg2.Template_Non_Specialty_Grid_Name_Text__c=  'ACT' + '-' + 'Comm Standard Control with PA' + '-' + '2 TIER QUALIFYING' + '-' + 'HPGST';
        rg2.Retail_30_1__c = 1;
        rg2.Retail_30__c = 1;
        rg2.Retail_90_1__c = 1;
        rg2.Retail_90__c = 1;
        rg2.Client_Owned_30_1__c = 1;
        rg2.Client_Owned_30__c = 1;
        rg2.Client_Owned_90_1__c = 1;
        rg2.Client_Owned_90__c = 1;
        rg2.Mail_1__c = 1;
        rg2.Mail__c = 1;
        rg2.Mchoice_1__c = 1;
        rg2.Mchoice__c = 1;
        rg2.Specialty_Retail_1__c = 1;
        rg2.Specialty_Retail__c = 1;
        rg2.PCD_Aggregate_Rate__c='2';
        rg2.Basis__c='All Rx';
        rg2.UniqueCheck__c=true;
         rg2.Template_ClientOwned_Display__c=true;
         rg2.Template_Retail30_Display__c =true;   
         rg2.Template_Retail90_Display__c=true;
         rg2.Template_Rcurve_Display__c=true;
         rg2.Template_Mail_Display__c=true;
         rg2.Template_Mail_Display__c=true;

        rgObjList.add(rg2);
      
       
        
       
         Rebate_Gtees_Specialty_Class_Carve_Outs__c RGCO = TestDataFactory.createGtees(roObj.id,FAFObj.id);
         RGCO.Year_Begin_Date__c=Date.valueOf(System.now());
         RGCO.Year_End_Date__c=Date.valueOf(System.now());
         
         Rebate_Gtees_Specialty_Class_Carve_Outs__c RGCO1 = TestDataFactory.createGtees(roObj.id,FAFObj.id);
         RGCO1.Year_Begin_Date__c=Date.valueOf(System.now());
         RGCO1.Year_End_Date__c=Date.valueOf(System.now());
         RGCO1.Year__c='2';
         
         Rebate_Gtees_Specialty_Class_Carve_Outs__c RGCO2 = TestDataFactory.createGtees(roObj.id,FAFObj.id);
         RGCO2.Year_Begin_Date__c=Date.valueOf(System.now());
         RGCO2.Year_End_Date__c=Date.valueOf(System.now());
         RGCO2.Year__c='3';
         
         Rebate_Gtees_Specialty_Class_Carve_Outs__c RGCO3 = TestDataFactory.createGtees(roObj.id,FAFObj.id);
         RGCO3.Year_Begin_Date__c=Date.valueOf(System.now());
         RGCO3.Year_End_Date__c=Date.valueOf(System.now());
         RGCO3.Year__c='4';
         
         Rebate_Gtees_Specialty_Class_Carve_Outs__c RGCO4 = TestDataFactory.createGtees(roObj.id,FAFObj.id);
         RGCO4.Year_Begin_Date__c=Date.valueOf(System.now());
         RGCO4.Year_End_Date__c=Date.valueOf(System.now());
         RGCO4.Year__c='5';
         
         Rebate_Gtees_Specialty_Class_Carve_Outs__c RGCO5= TestDataFactory.createGtees(roObj.id,FAFObj.id);
         RGCO5.Year_Begin_Date__c=Date.valueOf(System.now());
         RGCO5.Year_End_Date__c=Date.valueOf(System.now());
         RGCO5.Year__c='All';
         
         rglist.add(RGCO);
         rglist.add(RGCO1);
         rglist.add(RGCO2);
         rglist.add(RGCO3);
         rglist.add(RGCO4);
         rglist.add(RGCO5);
         
         insert rglist;
         insert rgObjList;
              
        list<id> fafidsList = new List<ID>();
        for( Rebate_Operations__c c :rolist){
                  fafidsList.add(c.id);
        }
        Invoke_Template_Rebate_Grid.Template_Rebate_Grid(fafidsList); 
        Test.stopTest();
     }
    } 
     static testmethod void TestMethod2(){
        User underwriter= ClientTestRef.createuwUser('Apttus Underwriting');
        insert underwriter;
        User salesperson= new User(
        ProfileId = [SELECT Id FROM Profile WHERE Name = 'Apttus Sales'].Id,
        LastName = 'lastsales',
        Email = 'abcsales1@test.com',
        Username = 'abcsales1@test.com' + System.currentTimeMillis(),
        CompanyName = 'TEST',
        Title = 'title',
        Alias = 'alias1',
        TimeZoneSidKey = 'America/Los_Angeles',
        EmailEncodingKey = 'UTF-8',
        LanguageLocaleKey = 'en_US',
        LocaleSidKey = 'en_US',
        Market_Segment__c = 'Anthem');

        System.RunAs(underwriter)
        {
        List<Rebate_Gtees_Specialty_Class_Carve_Outs__c> rglist=new List<Rebate_Gtees_Specialty_Class_Carve_Outs__c>(); 
         List<Rebate_Guarantees__c> rgObjList=new List<Rebate_Guarantees__c>();

         
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
        
      
        List<Rebate_Operations__c> rolist=new List<Rebate_Operations__c>();
        Rebate_Operations__c roObj = new Rebate_Operations__c( 
                                        Guaranteed_Net_Cost_Gnc_Guarantee__c = 'No',
                                        Specialty_Rebates__c = 'Do Not Pass to Client',
                                        Rebate_Contract_Type__c = 'Group Purchase Organization (GPO)',
                                        Rebate_Offering_Type__c ='Guarantee Only',
                                        Percentage_Guarantee__c = true,
                                        FAF_ID__c = FAFObj.Id
        );
        rolist.add(roObj);
        insert rolist; 
        
        Rebate_Guarantees__c rg = new Rebate_Guarantees__c();
        rg.Rebate_Operations__c = roObj.Id;
        rg.FAF_ID__c =FAFObj.Id;
        rg.Show_in_Specialty_Grid__c=true;
        rg.Show_in_Non_Specialty_Grid__c=true;
        rg.Year__c='1';
        rg.LOB2__c = 'ACT';
        rg.GSTP__C='HPGST';
        rg.Plan_Design__c = '2 Tier Q';
        rg.Specialty_Formulary__c ='Advanced Control Specialty Formulary';
        rg.Non_Specialty_Formulary_2__c ='Comm Standard Control with PA';
        rg.Template_Specialty_Grid_Name_Text__c= 'ACT' + '-' + 'CVS Health Advanced Control Specialty Formulary' + '-' + '2 TIER QUALIFYING';
        rg.Template_Non_Specialty_Grid_Name_Text__c=  'ACT' + '-' + 'Comm Standard Control with PA' + '-' + '2 TIER QUALIFYING' + '-' + 'HPGST';
        rg.Retail_30_1__c = 1;
        rg.Retail_90_1__c = 1;
        rg.Client_Owned_30_1__c = 1;
        rg.Client_Owned_90_1__c = 1;
        rg.Mail_1__c = 1;
        rg.PCD_Aggregate_Rate__c='1111111';
        rg.Mchoice_1__c = 1;
        rg.Specialty_Retail_1__c = 1;
        rg.UniqueCheck__c=true;
        rg.Template_ClientOwned_Display__c=true;
        rg.Template_Retail30_Display__c =true;   
        rg.Template_Retail90_Display__c=true;
        rg.Template_Rcurve_Display__c=true;
        rg.Template_Mail_Display__c=true;
        rg.Template_Mail_Display__c=true;
        rgObjList.add(rg);
        
        
        Rebate_Guarantees__c rg1 = new Rebate_Guarantees__c();
        rg1.Rebate_Operations__c = roObj.Id;
        rg1.FAF_ID__c =FAFObj.Id;
        rg1.Show_in_Specialty_Grid__c=true;
        rg1.Show_in_Non_Specialty_Grid__c=true;
        rg1.Year__c='2';
        rg1.LOB2__c = 'ACT';
        rg1.GSTP__C='HPGST';
        rg1.Plan_Design__c = '3 Tier Q';
        rg1.Specialty_Formulary__c ='Advanced Control Specialty Formulary';
        rg1.Non_Specialty_Formulary_2__c ='Comm Standard Control with PA';
        rg1.Template_Specialty_Grid_Name_Text__c= 'ACT' + '-' + 'CVS Health Advanced Control Specialty Formulary' + '-' + '2 TIER QUALIFYING';
        rg1.Template_Non_Specialty_Grid_Name_Text__c=  'ACT' + '-' + 'Comm Standard Control with PA' + '-' + '2 TIER QUALIFYING' + '-' + 'HPGST';
        rg1.Retail_30_1__c = 1;
        rg1.Retail_90_1__c = 1;
        rg1.Client_Owned_30_1__c = 1;
        rg1.Client_Owned_90_1__c = 1;
        rg1.Mail_1__c = 1;
        rg1.Mchoice_1__c = 1;
        rg1.Specialty_Retail_1__c = 1;
        rg1.PCD_Aggregate_Rate__c='1111111';
        rg1.Basis__c='All Rx';
        rg1.UniqueCheck__c=true;
         rg1.Template_ClientOwned_Display__c=true;
         rg1.Template_Retail30_Display__c =true;   
         rg1.Template_Retail90_Display__c=true;
         rg1.Template_Rcurve_Display__c=true;
         rg1.Template_Mail_Display__c=true;
         rg1.Template_Mail_Display__c=true;
          rgObjList.add(rg1);
         
         
        Rebate_Guarantees__c rg2 = new Rebate_Guarantees__c();
        rg2.Rebate_Operations__c = roObj.Id;
        rg2.FAF_ID__c =FAFObj.Id;
        rg2.Show_in_Specialty_Grid__c=true;
        rg2.Show_in_Non_Specialty_Grid__c=true;
        rg2.Year__c='2';
        rg2.LOB2__c = 'ACT';
        rg2.GSTP__C='HPGST';
        rg2.Plan_Design__c = '3 Tier Q';
        rg2.Specialty_Formulary__c ='Advanced Control Specialty Formulary';
        rg2.Non_Specialty_Formulary_2__c ='Comm Standard Control with PA';
        rg2.Template_Specialty_Grid_Name_Text__c= 'ACT' + '-' + 'CVS Health Advanced Control Specialty Formulary' + '-' + '2 TIER QUALIFYING';
        rg2.Template_Non_Specialty_Grid_Name_Text__c=  'ACT' + '-' + 'Comm Standard Control with PA' + '-' + '2 TIER QUALIFYING' + '-' + 'HPGST';
        rg2.Retail_30_1__c = 1;
        rg2.Client_Owned_30_1__c = 1;
        rg2.Mail_1__c = 1;
        rg2.Mchoice_1__c = 1;
        rg2.Specialty_Retail_1__c = 1;
        rg2.PCD_Aggregate_Rate__c='1111111';
        rg2.Basis__c='All Rx';
        rg2.Specialty__c=2;
        rg2.UniqueCheck__c=true;
         rg2.Template_ClientOwned_Display__c=true;
         rg2.Template_Retail30_Display__c =true;   
         rg2.Template_Retail90_Display__c=true;
         rg2.Template_Rcurve_Display__c=true;
         rg2.Template_Mail_Display__c=true;
         rg2.Template_Mail_Display__c=true;

        rgObjList.add(rg2);
        
         Rebate_Gtees_Specialty_Class_Carve_Outs__c RGCO = TestDataFactory.createGtees(roObj.id,FAFObj.id);
         RGCO.Year_Begin_Date__c=Date.valueOf(System.now());
         RGCO.Year_End_Date__c=Date.valueOf(System.now());
         
         Rebate_Gtees_Specialty_Class_Carve_Outs__c RGCO1 = TestDataFactory.createGtees(roObj.id,FAFObj.id);
         RGCO1.Year_Begin_Date__c=Date.valueOf(System.now());
         RGCO1.Year_End_Date__c=Date.valueOf(System.now());
         RGCO1.Year__c='2';
         
         Rebate_Gtees_Specialty_Class_Carve_Outs__c RGCO2 = TestDataFactory.createGtees(roObj.id,FAFObj.id);
         RGCO2.Year_Begin_Date__c=Date.valueOf(System.now());
         RGCO2.Year_End_Date__c=Date.valueOf(System.now());
         RGCO2.Year__c='3';
         
         Rebate_Gtees_Specialty_Class_Carve_Outs__c RGCO3 = TestDataFactory.createGtees(roObj.id,FAFObj.id);
         RGCO3.Year_Begin_Date__c=Date.valueOf(System.now());
         RGCO3.Year_End_Date__c=Date.valueOf(System.now());
         RGCO3.Year__c='4';
       
         
       
         
         rglist.add(RGCO);
         rglist.add(RGCO1);
         rglist.add(RGCO2);
         rglist.add(RGCO3);
         
         insert rglist;
         insert rgObjList;
              
        list<id> fafidsList = new List<ID>();
        for( Rebate_Operations__c c :rolist){
                  fafidsList.add(c.id);
        }
        Invoke_Template_Rebate_Grid.Template_Rebate_Grid(fafidsList); 
        Test.stopTest();
     }
    } 
  
  
}