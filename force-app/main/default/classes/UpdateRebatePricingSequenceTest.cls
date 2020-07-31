@isTest
public class UpdateRebatePricingSequenceTest {
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
            FAFObj.FAF_Copy_In_Progress__c = true;
            FAFObj.Data_Loading__c = false;
            FAFObj.Source_Copy_FAF_Status__c = 'Draft';
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
            list<Rebate_Guarantees__c> RebateGurList = new List<Rebate_Guarantees__c>();
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
            rg.Retail_30_1__c = 1;
            rg.Retail_30__c = 1;
            rg.Retail_90_1__c = 1;
            rg.Retail_90__c = 1;
            rg.Client_Owned_30_1__c = 1;
            rg.Specialty__c=8;
            rg.Specialty_1__c=8;
            rg.Client_Owned_30__c = 1;
            rg.Client_Owned_90_1__c = 1;
            rg.Client_Owned_90__c = 1;
            rg.Mail_1__c = 1;
            rg.Mail__c = 1;
            rg.Mchoice_1__c = 1;
            rg.Mchoice__c = 1;
            rg.Specialty_Retail_1__c = 1;
            rg.Specialty_Retail__c = 1;
            RebateGurList.add(rg);
            
            Rebate_Guarantees__c rg2 = new Rebate_Guarantees__c();
            rg2.Rebate_Operations__c = roObj.Id;
            rg2.FAF_ID__c =FAFObj.Id;
            rg2.Show_in_Specialty_Grid__c=true;
            rg2.Show_in_Non_Specialty_Grid__c=true;
            rg2.Year__c='2';
            rg2.LOB2__c = 'ACT';
            rg2.GSTP__C='HPGST';
            rg2.Plan_Design__c = '2 Tier Q';
            rg2.Specialty_Formulary__c ='Advanced Control Specialty Formulary';
            rg2.Non_Specialty_Formulary_2__c ='Comm Standard Control with PA';
            rg2.Template_Specialty_Grid_Name_Text__c= 'ACT' + '-' + 'CVS Health Advanced Control Specialty Formulary' + '-' + '2 TIER QUALIFYING';
            rg2.Template_Non_Specialty_Grid_Name_Text__c=  'ACT' + '-' + 'Comm Standard Control with PA' + '-' + '2 TIER QUALIFYING' + '-' + 'HPGST';
            rg2.Retail_30__c = 1;
            rg2.Retail_90__c = 1;
            rg2.Client_Owned_30__c = 1;
            rg2.Mail_1__c = 1;
            rg2.Mail__c = 1;
            rg2.Mchoice_1__c = 1;
            rg2.Mchoice__c = 1;
            rg2.Specialty_Retail_1__c = 1;
            rg2.Specialty_Retail__c = 1;
            rg2.Specialty__c=8;
            rg2.Specialty_1__c=8;
            RebateGurList.add(rg2);
            
            Rebate_Guarantees__c rg3 = new Rebate_Guarantees__c();
            rg3.Rebate_Operations__c = roObj.Id;
            rg3.FAF_ID__c =FAFObj.Id;
            rg3.Show_in_Specialty_Grid__c=true;
            rg3.Show_in_Non_Specialty_Grid__c=true;
            rg3.Year__c='2';
            rg3.LOB2__c = 'ACT';
            rg3.GSTP__C='HPGST';
            rg3.Plan_Design__c = '2 Tier Q';
            rg3.Specialty_Formulary__c ='Advanced Control Specialty Formulary';
            rg3.Non_Specialty_Formulary_2__c ='Comm Standard Control with PA';
            rg3.Template_Specialty_Grid_Name_Text__c= 'ACT' + '-' + 'CVS Health Advanced Control Specialty Formulary' + '-' + '2 TIER QUALIFYING';
            rg3.Template_Non_Specialty_Grid_Name_Text__c=  'ACT' + '-' + 'Comm Standard Control with PA' + '-' + '2 TIER QUALIFYING' + '-' + 'HPGST';
            rg3.Retail_30__c = 1;
            rg3.Retail_90__c = 1;
            rg3.Client_Owned_30__c = 1;
            rg3.Mail_1__c = 1;
            rg3.Mail__c = 1;
            rg3.Mchoice_1__c = 1;
            rg3.Mchoice__c = 1;
            rg3.Specialty_Retail_1__c = 1;
            rg3.Specialty_Retail__c = 1;
            rg3.Specialty__c=8;
            rg3.Specialty_1__c=8;
            RebateGurList.add(rg3);
            
            insert RebateGurList;
            
            Rebate_Guarantee_Denorm__c rebateDenor=TestDataFactory.createRebateDenorm(FAFObj.id);
            insert rebateDenor;
            
            list<id> fafidsList = new List<ID>();
            for(Rebate_Operations__c c :rolist){
                fafidsList.add(c.id);
            }
            rg.Sequence_Number__c = 1;
            rg2.Sequence_Number__c = 2;
            rg3.Sequence_Number__c = 3;
            update rg;
            //update rg2;
            Invoke_Template_Rebate_Denorm.Template_Rebate_Denorm(fafidsList); 
            
            list<id> opidList = new List<ID>();
            opidList.add(rg.Rebate_Operations__c);
            
            
            UpdateRebatePricingSequence.updateSequence(opidList);
            List<Rebate_Guarantee_Denorm__c> rebateDenor1= [select id, Rebate_Operations__r.Agreement_Line_Item__c from Rebate_Guarantee_Denorm__c 
                                                      where Rebate_Operations__c IN :opidList Order By Sequence_Number__c asc];
            Apttus_GridObjectdataSequence.updateRGSeq( rebateDenor1[0].Id,  rebateDenor1[0].Rebate_Operations__r.Agreement_Line_Item__c, '3');
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
            FAFObj.FAF_Copy_In_Progress__c = true;
            FAFObj.Data_Loading__c = false;
            FAFObj.Source_Copy_FAF_Status__c = 'Draft';
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
            list<Rebate_Guarantees__c> RebateGurList = new List<Rebate_Guarantees__c>();
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
            rg.Retail_30_1__c = 1;
            rg.Retail_30__c = 1;
            rg.Retail_90_1__c = 1;
            rg.Retail_90__c = 1;
            rg.Client_Owned_30_1__c = 1;
            rg.Specialty__c=8;
            rg.Specialty_1__c=8;
            rg.Client_Owned_30__c = 1;
            rg.Client_Owned_90_1__c = 1;
            rg.Client_Owned_90__c = 1;
            rg.Mail_1__c = 1;
            rg.Mail__c = 1;
            rg.Mchoice_1__c = 1;
            rg.Mchoice__c = 1;
            rg.Specialty_Retail_1__c = 1;
            rg.Specialty_Retail__c = 1;
            RebateGurList.add(rg);
            
            Rebate_Guarantees__c rg2 = new Rebate_Guarantees__c();
            rg2.Rebate_Operations__c = roObj.Id;
            rg2.FAF_ID__c =FAFObj.Id;
            rg2.Show_in_Specialty_Grid__c=true;
            rg2.Show_in_Non_Specialty_Grid__c=true;
            rg2.Year__c='2';
            rg2.LOB2__c = 'ACT';
            rg2.GSTP__C='HPGST';
            rg2.Plan_Design__c = '2 Tier Q';
            rg2.Specialty_Formulary__c ='Advanced Control Specialty Formulary';
            rg2.Non_Specialty_Formulary_2__c ='Comm Standard Control with PA';
            rg2.Template_Specialty_Grid_Name_Text__c= 'ACT' + '-' + 'CVS Health Advanced Control Specialty Formulary' + '-' + '2 TIER QUALIFYING';
            rg2.Template_Non_Specialty_Grid_Name_Text__c=  'ACT' + '-' + 'Comm Standard Control with PA' + '-' + '2 TIER QUALIFYING' + '-' + 'HPGST';
            rg2.Retail_30__c = 1;
            rg2.Retail_90__c = 1;
            rg2.Client_Owned_30__c = 1;
            rg2.Mail_1__c = 1;
            rg2.Mail__c = 1;
            rg2.Mchoice_1__c = 1;
            rg2.Mchoice__c = 1;
            rg2.Specialty_Retail_1__c = 1;
            rg2.Specialty_Retail__c = 1;
            rg2.Specialty__c=8;
            rg2.Specialty_1__c=8;
            RebateGurList.add(rg2);
            
            Rebate_Guarantees__c rg3 = new Rebate_Guarantees__c();
            rg3.Rebate_Operations__c = roObj.Id;
            rg3.FAF_ID__c =FAFObj.Id;
            rg3.Show_in_Specialty_Grid__c=true;
            rg3.Show_in_Non_Specialty_Grid__c=true;
            rg3.Year__c='2';
            rg3.LOB2__c = 'ACT';
            rg3.GSTP__C='HPGST';
            rg3.Plan_Design__c = '2 Tier Q';
            rg3.Specialty_Formulary__c ='Advanced Control Specialty Formulary';
            rg3.Non_Specialty_Formulary_2__c ='Comm Standard Control with PA';
            rg3.Template_Specialty_Grid_Name_Text__c= 'ACT' + '-' + 'CVS Health Advanced Control Specialty Formulary' + '-' + '2 TIER QUALIFYING';
            rg3.Template_Non_Specialty_Grid_Name_Text__c=  'ACT' + '-' + 'Comm Standard Control with PA' + '-' + '2 TIER QUALIFYING' + '-' + 'HPGST';
            rg3.Retail_30__c = 1;
            rg3.Retail_90__c = 1;
            rg3.Client_Owned_30__c = 1;
            rg3.Mail_1__c = 1;
            rg3.Mail__c = 1;
            rg3.Mchoice_1__c = 1;
            rg3.Mchoice__c = 1;
            rg3.Specialty_Retail_1__c = 1;
            rg3.Specialty_Retail__c = 1;
            rg3.Specialty__c=8;
            rg3.Specialty_1__c=8;
            RebateGurList.add(rg3);
            
            insert RebateGurList;
            
            Rebate_Guarantee_Denorm__c rebateDenor=TestDataFactory.createRebateDenorm(FAFObj.id);
            insert rebateDenor;
            
            list<id> fafidsList = new List<ID>();
            for(Rebate_Operations__c c :rolist){
                fafidsList.add(c.id);
            }
            rg.Sequence_Number__c = 1;
            rg2.Sequence_Number__c = 2;
            rg3.Sequence_Number__c = 3;
            update rg;
            //update rg2;
            Invoke_Template_Rebate_Denorm.Template_Rebate_Denorm(fafidsList); 
            
            list<id> opidList = new List<ID>();
            opidList.add(rg.Rebate_Operations__c);
            
            
            UpdateRebatePricingSequence.updateSequence(opidList);
            List<Rebate_Guarantee_Denorm__c> rebateDenor1= [select id, Rebate_Operations__r.Agreement_Line_Item__c from Rebate_Guarantee_Denorm__c 
                                                      where Rebate_Operations__c IN :opidList Order By Sequence_Number__c desc];
            Apttus_GridObjectdataSequence.updateRGSeq( rebateDenor1[0].Id,  rebateDenor1[0].Rebate_Operations__r.Agreement_Line_Item__c, '1');
            Test.stopTest();
        }
    }
        
}