@isTest
public class Invoke_GridDisplayNameRebateTest {
  //Method 1
    static testmethod void Invoke_GridDisplayNameRebateTest1(){
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
        List<id> rolist=new List<id>();
        Rebate_Operations__c roObj = new Rebate_Operations__c( 
                                        Guaranteed_Net_Cost_Gnc_Guarantee__c = 'No',
                                        Specialty_Rebates__c = 'Do Not Pass to Client',
                                        Rebate_Contract_Type__c = 'Group Purchase Organization (GPO)',
                                        Rebate_Offering_Type__c ='Guarantee Only',
                                        FAF_ID__c = FAFObj.Id
                                    );
        insert roObj;
        rolist.add(roObj.id);
         Grid_Display_Name_Setting__c gridDisp= new Grid_Display_Name_Setting__c();
            gridDisp.FAF__c =FAFObj.id;
            gridDisp.Object_Name__c='Rebate Guarantees';
            insert gridDisp;
        
        Rebate_Guarantees__c rg = new Rebate_Guarantees__c();
        rg.Rebate_Operations__c = roObj.Id;
        rg.FAF_ID__c =FAFObj.Id;
        rg.Show_in_Specialty_Grid__c=true;
        rg.Show_in_Non_Specialty_Grid__c=true;
        rg.Year__c='1';
        rg.Custom_Description__c='Test';
        rg.Non_Specialty_Formulary_2__c='Comm Advanced Control';
        rg.Plan_Design__c='2 Tier Q';
        rg.Specialty_Formulary__c='Advanced Control Specialty Formulary';
        rg.GSTP__c='Custom';
        rg.Specialty_Display_Name__c='Test';
        rg.Grid_Flag__c=true;
        insert rg;
        
        
        
        Invoke_GridDisplayNameRebate.UpdateGridName(roList);
        Test.stopTest();
        }
    }
}