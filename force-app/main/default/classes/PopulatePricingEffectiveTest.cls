/* =================================================================================
 * @Class Name        : PopulatePricingEffectiveTest
 * @author            : Ayush Jain(Accenture)
 * @created date      : 01/04/2019
 * @Purpose           : PopulatePricingEffectiveTest
=======================================================================================*/
@isTest
private class PopulatePricingEffectiveTest{
@TestSetup
static void setup()
{
    // insert user
        User useObj = TestDataFactory.createUser('Apttus Underwriting');
        insert useObj;  
        User useObjNew = TestDataFactory.createUser('Apttus Sales');
        insert useObjNew;
        System.runAs(useObj)
        {
    // insert Account Record
            Account accObj =  TestDataFactory.createAccount();
            insert accObj;
    // insert opportunity Record   
            Opportunity oppObj = TestDataFactory.createOpportunity(accObj.id);
            insert oppObj;
    //Insert CAC Record
            CAG__c Cag= TestDataFactory.createCAG('A','RXCLAIM');
            insert Cag;
    // inset FAF Record     
            Central_Hub__c FAFObj = TestDataFactory.createFAF(accObj.id, oppObj.Id, useObjNew.id);
            insert FAFObj;
            Central_Hub__c FAFObj1 = TestDataFactory.createFAF(accObj.id, oppObj.Id, useObjNew.id);
            insert FAFObj1; 
    //insert Billing Operations Record 
            Billing_Operations__c  bilingOp= TestDataFactory.createBillOps(FAFObj.ID);
            insert bilingOp;
            Billing_Operations__c  bilingOp1= TestDataFactory.createBillOps(FAFObj1.ID);
            insert bilingOp1;
    //insert Network Operations Record  
            Network_Operations__c opera= TestDataFactory.createNetworkOperation(FAFObj.ID);
            insert opera;
            Network_Operations__c opera1= TestDataFactory.createNetworkOperation(FAFObj1.ID);
            insert opera1;
    //insert Mail Operations Record  
            Mail_Operations__c Mail= TestDataFactory.createMailOperation(FAFObj.ID);
            insert mail;  
            Mail_Operations__c Mail1= TestDataFactory.createMailOperation(FAFObj1.ID);
            insert mail1; 
    //insert Client Information Record   
            Client_Information__c Clientinfo=TestDataFactory.createClientInfo(FAFObj.id);
            insert Clientinfo;
    //Insert Platform Specifics Record   
            Platform_Specifics__c ps = TestDataFactory.createPlatFormSpecificManagement();
            ps.FAF_Client_Information__c = Clientinfo.Id;
            ps.FAF_ID__c=FAFObj.id;
            Ps.Level_1_Record_ID__c= Cag.Id;
      //      insert ps; 
    //Update FAF Record
            FAFObj.Approved_By_Sales__c=True;
            FAFObj.FAF_Status__c='Implemented';
            FAFObj.Peer_Reviewer__c=useObj.id;
            FAFObj.Peer_Reviewed__c=True;
           update FAFObj;
            FAFObj1.Approved_By_Sales__c=True;
            FAFObj1.FAF_Status__c='Implemented';
            FAFObj1.Peer_Reviewer__c=useObj.id;
            FAFObj1.Peer_Reviewed__c=True;
           update FAFObj1;        
           }
}
/*=================================================================================
 * @Method Name       : doTest
 * @author            : Ayush Jain(Accenture)
 * @created date      : 01/04/2019
 * @Last modified by  : Ayush Jain(Accenture)
 * @Purpose           : Test class
=======================================================================================*/
    
    private static testMethod void doTest() {
    //start test
           Test.startTest();
           Account accObj=[select id,name from Account where name=:'testAccount---Anthem'];
           Opportunity oppObj=[select id from Opportunity];
           Client_Information__c Clientinfo= [select id from Client_Information__c];
           list<Central_Hub__c> fafList = [select id from Central_Hub__c where Account_Name__c=:accObj.id];
           list<id> fafidsList = new List<ID>();
           for( central_hub__c c :fafList ){
           fafidsList.add(c.id);
           }
    //        Platform_Specifics__c  ps =[select id from Platform_Specifics__c];
            CAG__c Cag = [select id from CAG__c];
    //Insert Pricing Effective Date
            Clientinfo.Pricing_Effective_Date__c=Date.newInstance(2019, 2, 9);
            update Clientinfo;
    //Insert Effective Date    
       //     ps.EffectiveDate__c= null;
       //     update ps;
            PopulatePricingEffective.populateEffectiveDate(fafidsList);
            System.assertEquals(Date.newInstance(2019, 2, 9),Clientinfo.Pricing_Effective_Date__c);
         //   System.assertEquals(null,ps.EffectiveDate__c);
            //end test
            Test.stopTest();
        }
}