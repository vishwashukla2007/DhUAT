@isTest
public class Apttus_Specialty_GuaranteeTest {
  
      static testmethod void SpecialtyGuaranteeNewEditClassTestMeth1()
    {
        string fieldName = Label.SpecialtyOpsLabel;
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
                        Central_Hub__c FAFObj1 = TestDataFactory.createFAF(accObj.id, oppObj.Id, useObjNew.id);
            insert FAFObj1;
            Specialty_Operations__c specOpsObj = TestDataFactory.createSpeciality(FAFObj.id);
            insert specOpsObj;
            Specialty_Operations__c specOpsObj1 = TestDataFactory.createSpeciality(FAFObj1.id);
            //specOpsObj1.Pharmacy_Benefit__c = ConstantsUtil.const_None;
            //Open
            specOpsObj1.Pharmacy_Benefit__c = ConstantsUtil.const_None;

            insert specOpsObj1;
            Specialty_Pricing__c specpricObj = TestDataFactory.createspecPricingObject(FAFObj.id, specOpsObj.id);
                        specpricObj.Pharmacy_Benefit__c='None';

            insert specpricObj;
            
            Specialty_Pricing__c specpricObj1 = TestDataFactory.createspecPricingObject(FAFObj.id, specOpsObj.id);
            specpricObj1.Pharmacy_Benefit__c = 'Preferred';
            specpricObj1.Year__c ='1';
            insert specpricObj1;
            Specialty_Pricing__c specpricObj2 = TestDataFactory.createspecPricingObject(FAFObj1.id, specOpsObj1.id);
            specpricObj2.Year__c ='3';
            specpricObj2.LOB__c ='WC';
            specpricObj2.Price_List__c = specpricObj1.Price_List__c;
            specpricObj2.Specialty_Operations__c = specpricObj1.Specialty_Operations__c;
            specpricObj2.Pharmacy_Benefit__c = 'Preferred';
            insert specpricObj2;
            
            Specialty_Pricing__c specpricObj3 = TestDataFactory.createspecPricingObject(FAFObj1.id, specOpsObj1.id);
            specpricObj3.Year__c ='3';
            specpricObj3.LOB__c ='WC';
            specpricObj3.Pharmacy_Benefit__c = 'None';
            insert specpricObj3;
            Specialty_Guarantee__c specGuaranObj = TestDataFactory.createspecGuarnt(FAFObj.id, specpricObj.id);
            insert specGuaranObj;
            
            List<Id> specialityPrricingIdList =new List<Id>();
            List<Specialty_Pricing__c> specialityList =new List<Specialty_Pricing__c>();
            specialityPrricingIdList.add(specpricObj.Id);
            specialityList.add(specpricObj);
            
            List<Specialty_Guarantee__c> specialityGurList =new List<Specialty_Guarantee__c>();
            specialityGurList.add(specGuaranObj);
            
            test.starttest();
                        Apttus_Specialty_Operation.beforeDelSpecialtyRecord(specialityPrricingIdList);

            Apttus_Specialty_Operation.avoidAccessForSalesUser();
            Apttus_Specialty_Guarantee.getSpecialtyguarantee(specpricObj.id);
            Apttus_Specialty_Operation.getSpecialtypricing(specOpsObj.id);
            try{
            Apttus_Specialty_Operation.deleteSelectedRecords(specialityList);
            }
            catch(Exception e) {
            system.debug(e);
            }
            Apttus_Specialty_Operation.checkDelete(specpricObj1.Id);
            Apttus_Specialty_Operation.checkDelete(specpricObj3.Id);
            Apttus_Specialty_Operation.ModelErrorMessage mm= new Apttus_Specialty_Operation.ModelErrorMessage(null,null);
                        Apttus_Specialty_Operation.deleteSpecialtyPricingRecord(specpricObj2.id);


            Apttus_Specialty_Guarantee.deleteSelectedRecords(specGuaranObj.Id, specialityGurList);
            test.stoptest();
        }
    }
    
    

}