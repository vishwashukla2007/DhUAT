@isTest
public class Invoke_GridDisplayNameSpecialtyTest{
    
    static testMethod void Invoke_GridDisplayNameSpecialty1(){
        User useObj = TestDataFactory.createUser('Apttus Underwriting');
        insert useObj;
        
        User useObjNew = TestDataFactory.createUser('Apttus Sales');
        insert useObjNew;
        
        System.runAs(useObj){
            Account accObj =  TestDataFactory.createAccount();
            insert accObj;
            
            Opportunity oppObj = TestDataFactory.createOpportunity(accObj.id);
            insert oppObj;
            
            Central_Hub__c FAFObj = TestDataFactory.createFAF(accObj.id, oppObj.Id, useObjNew.id);
            insert FAFObj;
            
            Client_Information__c cInfo = TestDataFactory.createClientInfo(FAFObj.id);
            cInfo.Escalating_Pricing__c = true;
            cInfo.Year_1__c = '1';
            cInfo.Year_1_Begin_Date__c = System.today();
            cInfo.Year_1_End_Date__c = System.today()+10;
            cInfo.Year_2__c = '2';
            cInfo.Year_2_Begin_Date__c = cInfo.Year_1_End_Date__c+1;
            cInfo.Year_2_End_Date__c = cInfo.Year_1_End_Date__c+10;        
            cInfo.Year_3__c = '3';
            cInfo.Year_3_Begin_Date__c = cInfo.Year_2_End_Date__c+1;
            cInfo.Year_3_End_Date__c = cInfo.Year_2_End_Date__c+10;        
            cInfo.Year_4__c = '4';
            cInfo.Year_4_Begin_Date__c = cInfo.Year_3_End_Date__c+1;
            cInfo.Year_4_End_Date__c = cInfo.Year_3_End_Date__c+10;        
            cInfo.Year_5__c = '5';
            cInfo.Year_5_Begin_Date__c = cInfo.Year_4_End_Date__c+1;
            cInfo.Year_5_End_Date__c = cInfo.Year_4_End_Date__c+10;        
            insert cInfo; 
            
            Grid_Display_Name_Setting__c gridDisp= new Grid_Display_Name_Setting__c();
            gridDisp.FAF__c =FAFObj.id;
            gridDisp.Object_Name__c='Specialty Pricing';
            insert gridDisp;
            
            test.startTest();
            Specialty_Operations__c specOpsObj = TestDataFactory.createSpeciality(FAFObj.id);
            insert specOpsObj;
            
            Specialty_Pricing__c specpricObj = TestDataFactory.createspecPricingObject(FAFObj.id, specOpsObj.id);
            specpricObj.Pharmacy_Benefit__c='Preferred';
            specpricObj.Custom_Description__c='Test';
            insert specpricObj;
            
            List<id> specOpsList= new List<id>();
            specOpsList.add(specOpsObj.id);
            
            Invoke_GridDisplayNameSpecialty.UpdateGridName(specOpsList);
            
            test.stopTest();
        }
    }
}