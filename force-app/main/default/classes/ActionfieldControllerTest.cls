@isTest
public class ActionfieldControllerTest{
    
    static testmethod void validateNewClientInformation(){
        
        User salesperson = ClientTestRef.createUser('Apttus Sales');
        
        insert salesperson;
       // User  man3level = [Select Name,ManagerId, Manager_Level_2__c, Manager_Level_3__c, Manager_Level_4__c, Manager_Level_5__c from User where Id = :userInfo.getUserId()];
         salesperson.Manager_Level_2__c = userInfo.getUserName();
         salesperson.Manager_Level_3__c = userInfo.getUserName();
         salesperson.Manager_Level_4__c = userInfo.getUserName();
         salesperson.Manager_Level_5__c = userInfo.getUserName();
         salesperson.ManagerId = userInfo.getUserId();
         update salesperson;
        Account accObj =  ClientTestRef.createAccount();
        insert accObj;
        accObj.iUMS_Client_Subtype__c = 'Health Plan Master';
        update accObj;
        Opportunity oppObj = ClientTestRef.createOpportunity(accObj.id);
        insert oppObj;
        Central_Hub__c FAFObj = ClientTestRef.createFAF(accObj.id, oppObj.Id, salesperson.Id);
        FAFObj.Business_Type__c = 'New';
        insert FAFObj;
        Rebate_Operations__c rebOpsObj = ClientTestRef.createRebOps(FAFObj.id);
        insert rebOpsObj;
        Test.startTest();
        Client_Information__c clientInfo = TestDataFactory.createClientInfo(FAFObj.id);
        //Client_Information__c clientInfo = [select id, FAF_Id__c from Client_Information__c where FAF_Id__c =: FAFObj.Id limit 1];
        clientInfo.Pricing_Effective_Date__c = System.Today();
        
        insert clientInfo;
        FAFObj.FAF_Status__c = 'Closed';
        FAFObj.Business_Type__c = 'Existing';
        update FAFObj;
        Billing_Operations__c billOpsObj = TestDataFactory.createBillOps(FAFObj.id);
        insert billOpsObj;
        Billing_Administrative_Fees__c billAdmObj = TestDataFactory.createBillAdminFees(FAFObj.id,billOpsObj.id);
        billAdmObj.year__c = '5';
        insert billAdmObj;
        
        
        ApexPages.currentPage().getParameters().put('id', clientInfo.Id);
        ApexPages.StandardController clientInfoSC = new ApexPages.StandardController(clientInfo);
        ActionfieldController newClientInfo1 = new ActionfieldController(clientInfoSC);
        newClientInfo1.Actionvisible();
        Test.stopTest();
        
    } 
   
    
    static testmethod void validateNewClientInformation9(){
        
        User salesperson = ClientTestRef.createUser('Apttus Sales');
        insert salesperson;
       // User  man3level = [Select Name,ManagerId, Manager_Level_2__c, Manager_Level_3__c, Manager_Level_4__c, Manager_Level_5__c from User where Id = :userInfo.getUserId()];
         salesperson.Manager_Level_2__c = userInfo.getUserName();
         salesperson.Manager_Level_3__c = userInfo.getUserName();
         salesperson.Manager_Level_4__c = userInfo.getUserName();
          salesperson.Manager_Level_5__c = userInfo.getUserName();
        //  salesperson.ManagerId = userInfo.getUserId();
          update salesperson;
        Account accObj =  ClientTestRef.createAccount();
        insert accObj;
        accObj.iUMS_Client_Subtype__c = 'Health Plan Master';
        update accObj;
        Opportunity oppObj = ClientTestRef.createOpportunity(accObj.id);
        insert oppObj;
        Central_Hub__c FAFObj = ClientTestRef.createFAF(accObj.id, oppObj.Id, salesperson.Id);
        FAFObj.Business_Type__c = 'New';
        insert FAFObj;
        Rebate_Operations__c rebOpsObj = ClientTestRef.createRebOps(FAFObj.id);
        insert rebOpsObj;
        Test.startTest();
        Client_Information__c clientInfo = TestDataFactory.createClientInfo(FAFObj.id);
        //Client_Information__c clientInfo = [select id, FAF_Id__c from Client_Information__c where FAF_Id__c =: FAFObj.Id limit 1];
        clientInfo.Pricing_Effective_Date__c = System.Today();
        
        insert clientInfo;
        FAFObj.FAF_Status__c = 'Closed';
        FAFObj.Business_Type__c = 'Existing';
        update FAFObj;
        Billing_Operations__c billOpsObj = TestDataFactory.createBillOps(FAFObj.id);
        insert billOpsObj;
        Billing_Administrative_Fees__c billAdmObj = TestDataFactory.createBillAdminFees(FAFObj.id,billOpsObj.id);
        billAdmObj.year__c = '5';
        insert billAdmObj;
        
        
        ApexPages.currentPage().getParameters().put('id', clientInfo.Id);
       ApexPages.StandardController clientInfoSC = new ApexPages.StandardController(clientInfo);
       
        ActionfieldController newClientInfo1 = new ActionfieldController(clientInfoSC);
        newClientInfo1.Actionvisible();
        Test.stopTest();
    } 
      static testmethod void EditButtonTest2(){
        User testuser = [Select Id, Name from User where id =: userInfo.getUserId()];
        User salesperson = ClientTestRef.createUser('Apttus Sales');
        insert salesperson;
        salesperson.Manager_Level_2__c = testuser.Name;
        update salesperson;
        Account accObj =  ClientTestRef.createAccount();
        accObj.iUMS_Client_Subtype__c = 'Health Plan Master';
        insert accObj;
        Opportunity oppObj = ClientTestRef.createOpportunity(accObj.id);
        insert oppObj;
        Central_Hub__c FAFObj = ClientTestRef.createFAF(accObj.id, oppObj.Id, salesperson.Id);
        FAFObj.Business_Type__c = 'New';
        insert FAFObj;
        Rebate_Operations__c rebOpsObj = ClientTestRef.createRebOps(FAFObj.id);
        insert rebOpsObj;
        Client_Information__c clientInfo = TestDataFactory.createClientInfo(FAFObj.id);
        insert clientInfo;
        Test.startTest();
        ApexPages.currentPage().getParameters().put('id', clientInfo.Id);
        ApexPages.StandardController clientInfoSC = new ApexPages.StandardController(clientInfo);
      //  clientInfomationDetails newClientInfo = new clientInfomationDetails(clientInfoSC);
        ActionfieldController newClientInfo1 = new ActionfieldController(clientInfoSC);
        newClientInfo1.Actionvisible();
      //  ClientInfoEditButton.createapproval(clientInfo.id);
      //  ClientInfoEditButton.getAccessForSalesUser1();
      //  ClientInfoEditButton.getAccountSubtype1(FAFObj.id);
        Test.stopTest();
    
    }
    static testmethod void EditButtonTest3(){
        User testuser = [Select Id, Name from User where id =: userInfo.getUserId()];
        User salesperson = ClientTestRef.createUser('Apttus Sales');
        insert salesperson;
        salesperson.Manager_Level_3__c = testuser.Name;
        update salesperson;
        Account accObj =  ClientTestRef.createAccount();
           accObj.iUMS_Client_Subtype__c = 'Health Plan Master';
        insert accObj;
        Opportunity oppObj = ClientTestRef.createOpportunity(accObj.id);
        insert oppObj;
        Central_Hub__c FAFObj = ClientTestRef.createFAF(accObj.id, oppObj.Id, salesperson.Id);
        FAFObj.Business_Type__c = 'New';
        insert FAFObj;
        Rebate_Operations__c rebOpsObj = ClientTestRef.createRebOps(FAFObj.id);
        insert rebOpsObj;
        Client_Information__c clientInfo = TestDataFactory.createClientInfo(FAFObj.id);
        insert clientInfo;
        Test.startTest();
        ApexPages.currentPage().getParameters().put('id', clientInfo.Id);
        ApexPages.StandardController clientInfoSC = new ApexPages.StandardController(clientInfo);
     //   clientInfomationDetails newClientInfo = new clientInfomationDetails(clientInfoSC);
        ActionfieldController newClientInfo1 = new ActionfieldController(clientInfoSC);
        newClientInfo1.Actionvisible();
       // ClientInfoEditButton.createapproval(clientInfo.id);
      //  ClientInfoEditButton.getAccessForSalesUser1();
      //  ClientInfoEditButton.getAccountSubtype1(FAFObj.id);
        Test.stopTest();
    
    }
    static testmethod void EditButtonTest4(){
        User testuser = [Select Id, Name from User where id =: userInfo.getUserId()];
        User salesperson = ClientTestRef.createUser('Apttus Sales');
        insert salesperson;
        salesperson.Manager_Level_4__c = testuser.Name;
        update salesperson;
        Account accObj =  ClientTestRef.createAccount();
           accObj.iUMS_Client_Subtype__c = 'Health Plan Master';
        insert accObj;
        Opportunity oppObj = ClientTestRef.createOpportunity(accObj.id);
        insert oppObj;
        Central_Hub__c FAFObj = ClientTestRef.createFAF(accObj.id, oppObj.Id, salesperson.Id);
        FAFObj.Business_Type__c = 'New';
        insert FAFObj;
        Rebate_Operations__c rebOpsObj = ClientTestRef.createRebOps(FAFObj.id);
        insert rebOpsObj;
        Client_Information__c clientInfo = TestDataFactory.createClientInfo(FAFObj.id);
        insert clientInfo;
        Test.startTest();
        ApexPages.currentPage().getParameters().put('id', clientInfo.Id);
        ApexPages.StandardController clientInfoSC = new ApexPages.StandardController(clientInfo);
       // clientInfomationDetails newClientInfo = new clientInfomationDetails(clientInfoSC);
        ActionfieldController newClientInfo1 = new ActionfieldController(clientInfoSC);
        newClientInfo1.Actionvisible();
       // ClientInfoEditButton.createapproval(clientInfo.id);
       // ClientInfoEditButton.getAccessForSalesUser1();
       // ClientInfoEditButton.getAccountSubtype1(FAFObj.id);
        Test.stopTest();
    
    }
    static testmethod void EditButtonTest5(){
        User testuser = [Select Id, Name from User where id =: userInfo.getUserId()];
        User salesperson = ClientTestRef.createUser('Apttus Sales');
        insert salesperson;
        salesperson.Manager_Level_5__c = testuser.Name;
        update salesperson;
        Account accObj =  ClientTestRef.createAccount();
           accObj.iUMS_Client_Subtype__c = 'Health Plan Master';
        insert accObj;
        Opportunity oppObj = ClientTestRef.createOpportunity(accObj.id);
        insert oppObj;
        Central_Hub__c FAFObj = ClientTestRef.createFAF(accObj.id, oppObj.Id, salesperson.Id);
        FAFObj.Business_Type__c = 'New';
        insert FAFObj;
        Rebate_Operations__c rebOpsObj = ClientTestRef.createRebOps(FAFObj.id);
        insert rebOpsObj;
        Client_Information__c clientInfo = TestDataFactory.createClientInfo(FAFObj.id);
        insert clientInfo;
        Test.startTest();
        ApexPages.currentPage().getParameters().put('id', clientInfo.Id);
        ApexPages.StandardController clientInfoSC = new ApexPages.StandardController(clientInfo);
      //  clientInfomationDetails newClientInfo = new clientInfomationDetails(clientInfoSC);
        ActionfieldController newClientInfo1 = new ActionfieldController(clientInfoSC);
        newClientInfo1.Actionvisible();
     //   ClientInfoEditButton.createapproval(clientInfo.id);
      //  ClientInfoEditButton.getAccessForSalesUser1();
      //  ClientInfoEditButton.getAccountSubtype1(FAFObj.id);
        Test.stopTest();
    
    }
    static testmethod void EditButtonTest6(){
        User testuser = [Select Id, Name from User where id =: userInfo.getUserId()];
        User salesperson = ClientTestRef.createUser('Apttus Sales');
        insert salesperson;
        salesperson.Manager_Level_6__c = testuser.Name;
        update salesperson;
        Account accObj =  ClientTestRef.createAccount();
           accObj.iUMS_Client_Subtype__c = 'Health Plan Master';
        insert accObj;
        Opportunity oppObj = ClientTestRef.createOpportunity(accObj.id);
        insert oppObj;
        Central_Hub__c FAFObj = ClientTestRef.createFAF(accObj.id, oppObj.Id, salesperson.Id);
        FAFObj.Business_Type__c = 'New';
        insert FAFObj;
        Rebate_Operations__c rebOpsObj = ClientTestRef.createRebOps(FAFObj.id);
        insert rebOpsObj;
        Client_Information__c clientInfo = TestDataFactory.createClientInfo(FAFObj.id);
        insert clientInfo;
        Test.startTest();
        ApexPages.currentPage().getParameters().put('id', clientInfo.Id);
        ApexPages.StandardController clientInfoSC = new ApexPages.StandardController(clientInfo);
      //  clientInfomationDetails newClientInfo = new clientInfomationDetails(clientInfoSC);
        ActionfieldController newClientInfo1 = new ActionfieldController(clientInfoSC);
        newClientInfo1.Actionvisible();
      //  ClientInfoEditButton.createapproval(clientInfo.id);
      ///  ClientInfoEditButton.getAccessForSalesUser1();
       // ClientInfoEditButton.getAccountSubtype1(FAFObj.id);
        Test.stopTest();
    
    }
    static testmethod void EditButtonTest7(){
        User testuser = [Select Id, Name from User where id =: userInfo.getUserId()];
        User salesperson = ClientTestRef.createUser('Apttus Sales');
        insert salesperson;
        salesperson.Manager_Level_7__c = testuser.Name;
        update salesperson;
        Account accObj =  ClientTestRef.createAccount();
           accObj.iUMS_Client_Subtype__c = 'Health Plan Master';
        insert accObj;
        Opportunity oppObj = ClientTestRef.createOpportunity(accObj.id);
        insert oppObj;
        Central_Hub__c FAFObj = ClientTestRef.createFAF(accObj.id, oppObj.Id, salesperson.Id);
        FAFObj.Business_Type__c = 'New';
        insert FAFObj;
        Rebate_Operations__c rebOpsObj = ClientTestRef.createRebOps(FAFObj.id);
        insert rebOpsObj;
        Client_Information__c clientInfo = TestDataFactory.createClientInfo(FAFObj.id);
        insert clientInfo;
        Test.startTest();
        ApexPages.currentPage().getParameters().put('id', clientInfo.Id);
        ApexPages.StandardController clientInfoSC = new ApexPages.StandardController(clientInfo);
      //  clientInfomationDetails newClientInfo = new clientInfomationDetails(clientInfoSC);
        ActionfieldController newClientInfo1 = new ActionfieldController(clientInfoSC);
        newClientInfo1.Actionvisible();
      //  ClientInfoEditButton.createapproval(clientInfo.id);
       // ClientInfoEditButton.getAccessForSalesUser1();
      //  ClientInfoEditButton.getAccountSubtype1(FAFObj.id);
        Test.stopTest();
    
    }
 }