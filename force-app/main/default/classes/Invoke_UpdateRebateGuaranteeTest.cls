@isTest
public class Invoke_UpdateRebateGuaranteeTest {
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
        insert rg;
        
        Rebate_Guarantees__c rg1 = new Rebate_Guarantees__c();
        rg1.Rebate_Operations__c = roObj.Id;
        rg1.FAF_ID__c =FAFObj.Id;
        rg1.Show_in_Specialty_Grid__c=true;
        rg1.Show_in_Non_Specialty_Grid__c=true;
        rg1.Year__c='2';
        Insert rg1;
        
        Rebate_Guarantees__c rg2 = new Rebate_Guarantees__c();
        rg2.Rebate_Operations__c = roObj.Id;
        rg2.FAF_ID__c =FAFObj.Id;
        rg2.Show_in_Specialty_Grid__c=true;
        rg2.Show_in_Non_Specialty_Grid__c=true;
        rg2.Year__c='3';
        insert rg2; 
        
        Rebate_Guarantees__c rg3 = new Rebate_Guarantees__c();
        rg3.Rebate_Operations__c = roObj.Id;
        rg3.FAF_ID__c =FAFObj.Id;
        rg3.Show_in_Specialty_Grid__c=true;
        rg3.Show_in_Non_Specialty_Grid__c=true;  
        rg3.Year__c='4';
        insert rg3;
        
        Rebate_Guarantees__c rg4 = new Rebate_Guarantees__c();
        rg4.Rebate_Operations__c = roObj.Id;
        rg4.FAF_ID__c =FAFObj.Id;
        rg4.Show_in_Specialty_Grid__c=true;
        rg4.Show_in_Non_Specialty_Grid__c=true;
        rg4.Year__c='5';
        rg4.GSTP__c = 'HPGST';
        insert rg4;   
        
        Rebate_Guarantees__c rg5 = new Rebate_Guarantees__c();
        rg5.Rebate_Operations__c = roObj.Id;
        rg5.FAF_ID__c =FAFObj.Id;
        rg5.Show_in_Specialty_Grid__c=true;
        rg5.Show_in_Non_Specialty_Grid__c=true;
        rg5.Year__c='All';
        rg5.GSTP__c = 'HPGST';
        insert rg5;
       
     /* rg5.Modeled_Non_Specialty_PlanDesign__c = '';
        rg5.Modeled_Non_Specialty_Plan_Dup_Check__c = '';
        rg5.Modeled_Specialty_PlanDesign__c = '';
         Update rg5;*/
               
        list<id> fafidsList = new List<ID>();
        for( Rebate_Operations__c c :rolist){
                  fafidsList.add(c.id);
        }
            
             
     Rebate_Gtees_Specialty_Class_Carve_Outs__c  carve=TestDataFactory.createGtees(roObj.Id,FAFObj.Id);
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
        
        Invoke_UpdateRebateGuarantee.UpdateRebateGuarantee(fafidsList); 
        Test.stopTest();
     }
    } 
  
}