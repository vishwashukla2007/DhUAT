@isTest
public class UpdateSpecialtyPricingSequence_1Test {
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
            
            list<Specialty_Pricing__c> RebateGurList = new List<Specialty_Pricing__c>();
            
            Apttus__APTS_Agreement__c agr=new Apttus__APTS_Agreement__c();
            agr.Apttus__Account__c=accObj.id;
            agr.Opportunity__c=oppObj.id;
            agr.Status_In_Progress__c='Setup Pricing';
            agr.PCD_Status__c='Setup Pricing';
            insert agr;
            
            Apttus__AgreementLineItem__c agrline=new Apttus__AgreementLineItem__c();
            agrline.Apttus__AgreementId__c=agr.id;
            agrline.PCD_FAF__c=FAFObj.id;
            agrline.Async_Mode__c=false;
            agrline.Component_Error__c='';
            agrline.Apttus_CMConfig__LineNumber__c=0;
            agrline.Apttus_CMConfig__ItemSequence__c=0;
            agrline.LOB_Description__c='';
            insert agrline;
            List<Specialty_Operations__c> rolist=new List<Specialty_Operations__c>();
            
             Specialty_Operations__c SpecOpsObj = TestDataFactory.createSpeciality(FAFObj.id);
             specOpsObj.Agreement__c=agr.id;
             specOpsObj.Agreement_Line_Item__c =agrline.Id;
             insert SpecOpsObj;
             

            Specialty_Pricing__c SpecPricObj = TestDataFactory.createspecPricingObject(FAFObj.id,SpecOpsObj.id);
            specpricObj.Agreement__c=agr.id;
            specpricObj.Agreement_Line_Item__c=agrline.Id;
            insert SpecPricObj;
            
            Specialty_Pricing__c SpecPricObj1 = TestDataFactory.createspecPricingObject(FAFObj.id,SpecOpsObj.id);
            specpricObj1.Agreement__c=agr.id;
            specpricObj1.Agreement_Line_Item__c=agrline.Id;
            insert SpecPricObj1;
            
            list<id> fafidsList = new List<ID>();
            fafidsList.add(SpecOpsObj.id);
            
            SpecPricObj.Sequence_Number__c = 1;
            SpecPricObj1.Sequence_Number__c = 2;
            update SpecPricObj;
            update SpecPricObj1;
            
            UpdateSpecialtyPricingSequence_1.updateSequence(fafidsList); 
            
            /*list<id> opidList = new List<ID>();
            opidList.add(rg.Rebate_Operations__c);*/
            
            Apttus_GridObjectdataSequence.updateSpecSeq(SpecPricObj.Id,SpecPricObj.Specialty_Operations__r.Agreement_Line_Item__c, '2');
            Test.stopTest();
        }
        
    }
}