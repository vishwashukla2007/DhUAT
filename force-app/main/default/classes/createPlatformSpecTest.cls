@isTest
public class createPlatformSpecTest
    {
      static testmethod void CreatePSRTest()
      {
        User useObj = CAGTestClassRecords.createUser('Apttus Underwriting');
        insert useObj;
		System.runAs(useObj){
			Account accObj =  CAGTestClassRecords.createAccount();
        	insert accObj;
			Opportunity oppObj = CAGTestClassRecords.createOpportunity(accObj.id);
       	    insert oppObj;
			Central_Hub__c FAFObj = CAGTestClassRecords.createFAF(accObj.id, oppObj.Id, useObj.id);
        	insert FAFObj;
			//Client_Information__c ClientObj = CAGTestClassRecords.createClientInfo(FAFObj.id, accObj.id, oppObj.Id);
        	//insert ClientObj;
			CAG__c CAGObjC = CAGTestClassRecords.createCAGC(accObj.id);
       		insert CAGObjC;
			CAG__c CAGObjA = CAGTestClassRecords.createCAGA(accObj.id);
        	insert CAGObjA;
			CAG__c CAGObjG = CAGTestClassRecords.createCAGG(accObj.id);
        	insert CAGObjG;
            CAG__c CAGObjInG = CAGTestClassRecords.createCAGInG(accObj.id);
        	insert CAGObjInG;
            //String Clintinfoid = ClientObj.id;
            List<id> CagIds = new List<Id> {CAGObjC.id };
            List<id> CagIdAs = new List<Id> {CAGObjA.id};
            List<id> CagIdGs = new List<Id> {CAGObjG.id};
            List<id> CagIdInGs = new List<Id> {CAGObjInG.id};
	
		test.starttest();
            sdgController.createPlatformSpec(CagIds,FAFObj.Client_Info__c,FAFObj.Name);
            sdgController.createPlatformSpec(CagIdAs,FAFObj.Client_Info__c,FAFObj.Name);
            sdgController.createPlatformSpec(CagIdGs,FAFObj.Client_Info__c,FAFObj.Name);
            sdgController.createPlatformSpec(CagIdInGs,FAFObj.Client_Info__c,FAFObj.Name);
        test.stoptest();
	}
      }
   }