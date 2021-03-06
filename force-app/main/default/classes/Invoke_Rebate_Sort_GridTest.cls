@isTest
public class Invoke_Rebate_Sort_GridTest {
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
        
        
        Rebate_Gtees_Specialty_Class_Carve_Outs__c carve=TestDataFactory.createGtees(roObj.Id,FAFObj.Id);
        carve.Year_Begin_Date__c=Date.ValueOf(System.Now());
        carve.Year_End_Date__c=Date.ValueOf(System.Now().adddays(1));
        carve.LOB2__c = 'ACT';
        
        insert carve;
        
        Rebate_Gtees_Specialty_Class_Carve_Outs__c carve1=TestDataFactory.createGtees(roObj.Id,FAFObj.Id);
        carve1.Year_Begin_Date__c=Date.ValueOf(System.Now());
        carve1.Year_End_Date__c=Date.ValueOf(System.Now().adddays(1));
        carve1.LOB2__c = 'ACT';
        carve1.Year__c='2';
        insert carve1;
        
        Rebate_Gtees_Specialty_Class_Carve_Outs__c carve2=TestDataFactory.createGtees(roObj.Id,FAFObj.Id);
        
        carve2.Year_Begin_Date__c=Date.ValueOf(System.Now());
        carve2.Year_End_Date__c=Date.ValueOf(System.Now().adddays(1));
        carve2.LOB2__c = 'ACT';
        carve2.Year__c='3';
        insert carve2;
         
        Rebate_Gtees_Specialty_Class_Carve_Outs__c carve3=TestDataFactory.createGtees(roObj.Id,FAFObj.Id);
        carve3.Drug_Therapy_Class_2__c='Additional Products';
        carve3.Year_Begin_Date__c=Date.ValueOf(System.Now());
        carve3.Year_End_Date__c=Date.ValueOf(System.Now().adddays(1));
        carve3.LOB2__c = 'ACT';
        carve3.Year__c='1';
        insert carve3;
        
       
        
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
        rg.Retail_30__c = 1;
        rg.Retail_90_1__c = 1;
        rg.Retail_90__c = 1;
        rg.Client_Owned_30_1__c = 1;
        rg.Client_Owned_30__c = 1;
        rg.Client_Owned_90_1__c = 1;
        rg.Client_Owned_90__c = 1;
        rg.Mail_1__c = 1;
        rg.Mail__c = 1;
        rg.Mchoice_1__c = 1;
        rg.Mchoice__c = 1;
        rg.Specialty_Retail_1__c = 1;
        rg.Specialty_Retail__c = 1;
        insert rg;
        
       
        
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
        insert rg2; 
        
        
        
        Rebate_Guarantees__c rg4 = new Rebate_Guarantees__c();
        rg4.Rebate_Operations__c = roObj.Id;
        rg4.FAF_ID__c =FAFObj.Id;
        rg4.Show_in_Specialty_Grid__c=true;
        rg4.Show_in_Non_Specialty_Grid__c=true;
        rg4.Year__c='5';
        rg4.LOB2__c = 'ACT';
        rg4.GSTP__C='HPGST';
        rg4.Plan_Design__c = '2 Tier Q';
        rg4.Specialty_Formulary__c ='Advanced Control Specialty Formulary';
        rg4.Non_Specialty_Formulary_2__c ='Comm Standard Control with PA';
        rg4.Template_Specialty_Grid_Name_Text__c= 'ACT' + '-' + 'CVS Health Advanced Control Specialty Formulary' + '-' + '2 TIER QUALIFYING';
        rg4.Template_Non_Specialty_Grid_Name_Text__c=  'ACT' + '-' + 'Comm Standard Control with PA' + '-' + '2 TIER QUALIFYING' + '-' + 'HPGST';
        rg4.Retail_30_1__c = 1;
        rg4.Retail_30__c = 1;
        rg4.Retail_90_1__c = 1;
        rg4.Retail_90__c = 1;
        rg4.Client_Owned_30_1__c = 1;
        rg4.Client_Owned_90_1__c = 1;
        rg4.Client_Owned_90__c = 1;
        rg4.Mail_1__c = 1;
        rg4.Mail__c = 1;
        rg4.Mchoice_1__c = 1;
        rg4.Mchoice__c = 1;
        rg4.Specialty_Retail_1__c = 1;
        rg4.Specialty_Retail__c = 1;
        insert rg4;   
        
        Rebate_Guarantees__c rg5 = new Rebate_Guarantees__c();
        rg5.Rebate_Operations__c = roObj.Id;
        rg5.FAF_ID__c =FAFObj.Id;
        rg5.Show_in_Specialty_Grid__c=true;
        rg5.Show_in_Non_Specialty_Grid__c=true;
        rg5.Year__c='All';
        rg5.LOB2__c = 'ACT';
        rg5.GSTP__C='HPGST';
        rg5.Plan_Design__c = '2 Tier Q';
        rg5.Specialty_Formulary__c ='Advanced Control Specialty Formulary';
        rg5.Non_Specialty_Formulary_2__c ='Comm Standard Control with PA';
        rg5.Template_Specialty_Grid_Name_Text__c= 'ACT' + '-' + 'CVS Health Advanced Control Specialty Formulary' + '-' + '2 TIER QUALIFYING';
        rg5.Template_Non_Specialty_Grid_Name_Text__c=  'ACT' + '-' + 'Comm Standard Control with PA' + '-' + '2 TIER QUALIFYING' + '-' + 'HPGST';
        rg5.Retail_30_1__c = 1;
        rg5.Retail_30__c = 1;
        rg5.Retail_90_1__c = 1;
        rg5.Retail_90__c = 1;
        rg5.Client_Owned_30_1__c = 1;
        rg5.Client_Owned_30__c = 1;
        rg5.Client_Owned_90_1__c = 1;
        rg5.Client_Owned_90__c = 1;
        rg5.Mail_1__c = 1;
        rg5.Mail__c = 1;
        rg5.Mchoice_1__c = 1;
        rg5.Mchoice__c = 1;
        rg5.Specialty_Retail_1__c = 1;
        rg5.Specialty_Retail__c = 1;
        insert rg5;
                
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
        
        
        Rebate_Gtees_Specialty_Class_Carve_Outs__c carve=TestDataFactory.createGtees(roObj.Id,FAFObj.Id);
        carve.Year_Begin_Date__c=Date.ValueOf(System.Now());
        carve.Year_End_Date__c=Date.ValueOf(System.Now().adddays(1));
        carve.LOB2__c = 'ACT';
        
        insert carve;
        
        Rebate_Gtees_Specialty_Class_Carve_Outs__c carve1=TestDataFactory.createGtees(roObj.Id,FAFObj.Id);
        carve1.Year_Begin_Date__c=Date.ValueOf(System.Now());
        carve1.Year_End_Date__c=Date.ValueOf(System.Now().adddays(1));
        carve1.LOB2__c = 'ACT';
        carve1.Year__c='2';
        insert carve1;
        
         Rebate_Gtees_Specialty_Class_Carve_Outs__c carve5=TestDataFactory.createGtees(roObj.Id,FAFObj.Id);
        carve5.Drug_Therapy_Class_2__c='Additional Products ';
        carve5.Year_Begin_Date__c=Date.ValueOf(System.Now());
        carve5.Year_End_Date__c=Date.ValueOf(System.Now().adddays(1));
        carve5.LOB2__c = 'ACT';
        carve5.Year__c='2';
        insert carve5;
        
        Rebate_Gtees_Specialty_Class_Carve_Outs__c carve6=TestDataFactory.createGtees(roObj.Id,FAFObj.Id);
        carve6.Drug_Therapy_Class_2__c='Additional Products ';
        carve6.Year_Begin_Date__c=Date.ValueOf(System.Now());
        carve6.Year_End_Date__c=Date.ValueOf(System.Now().adddays(1));
        carve6.LOB2__c = 'ACT';
        carve6.Year__c='All';
        insert carve6;
        
       List<Rebate_Guarantees__c> rgList = new List<Rebate_Guarantees__c>();
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
        rg.Retail_30__c = 1;
        rg.Retail_90_1__c = 1;
        rg.Retail_90__c = 1;
        rg.Client_Owned_30_1__c = 1;
        rg.Client_Owned_30__c = 1;
        rg.Client_Owned_90_1__c = 1;
        rg.Client_Owned_90__c = 1;
        rg.Mail_1__c = 1;
        rg.Mail__c = 1;
        rg.Mchoice_1__c = 1;
        rg.Mchoice__c = 1;
        rg.Specialty_Retail_1__c = 1;
        rg.Specialty_Retail__c = 1;
        rg.UniqueCheck__c=true;
        rg.PCD_Same_dollar_and_Percentage_Value__c = true;
        rg.Sorting_Number__c = 1.0;
        rg.Grid_Flag__c = true;
        insert rg;
       // rgList.add(rg);
        //insert rgList;    
            
            
       Rebate_Guarantees__c rg2 = new Rebate_Guarantees__c();
        rg2.Rebate_Operations__c = roObj.Id;
        rg2.FAF_ID__c =FAFObj.Id;
        rg2.Show_in_Specialty_Grid__c=false;
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
        rg2.Grid_Flag__c = true;
        rg2.Sorting_Number__c = 1.0;
        insert rg2; 

        //rgList.add(rg2);
        //insert rgList;    
            
        list<id> fafidsList = new List<ID>();
        for( Rebate_Operations__c c :rolist){
                  fafidsList.add(c.id);
        }
        Invoke_Rebate_Sort_Grid.Invoke_Rebate_Sort_Grid_Method(fafidsList);
            
        rg.Show_in_Non_Specialty_Grid__c = false;
        rg.Show_in_Specialty_Grid__c = true;
        rg.Grid_Flag__c = false;  
        rg.Non_Specialty_Formulary_2__c = null;
        Update rg;

        rg2.Show_in_Specialty_Grid__c= false;
        rg2.Show_in_Non_Specialty_Grid__c=true;
        rg2.Sorting_Number__c = 1.1;
        rg2.Non_Specialty_Formulary_2__c = null;
        rg2.Grid_Flag__c = false; 
        update rg2;
     //   Invoke_Rebate_Sort_Grid.Invoke_Rebate_Sort_Grid_Method(fafidsList);
        Test.stopTest();
     }
        
 } 
    
  
}