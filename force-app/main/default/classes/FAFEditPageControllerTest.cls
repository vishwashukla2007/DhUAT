@isTest
public class FAFEditPageControllerTest {
    
    static testmethod void validateNewClientInformation(){
        
        User salesperson = ClientTestRef.createUser('Apttus Sales');
        insert salesperson;
        salesperson.Manager_Level_2__c = userInfo.getUserName();
        salesperson.Manager_Level_3__c = userInfo.getUserName();
        salesperson.Manager_Level_4__c = userInfo.getUserName();
        salesperson.Manager_Level_5__c = userInfo.getUserName();
        salesperson.ManagerId = userInfo.getUserId();
        update salesperson;
        UserRole role=[select id,name  from userrole where name='Apttus Underwriting'];
        Profile p = [SELECT Id FROM Profile WHERE Name='Apttus Underwriting']; 
        User u = new User(Alias = 'standt', Email='standarduser1212@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, userroleid=role.id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='standarduser2121@testorg.com',Market_Segment__c='Employer');        
        Account accObj =  TestDataFactory.createAccount();
        accObj.iUMS_Client_Subtype__c = 'Health Plan Master';
        insert accObj;
        
        Opportunity oppObj = ClientTestRef.createOpportunity(accObj.id);
        insert oppObj;
        
        Central_Hub__c FAFObj = ClientTestRef.createFAF(accObj.id, oppObj.Id, salesperson.Id);
      //  FAFObj.Business_Type__c = 'New';         
        insert FAFObj;
        
        CAG__c cag = new CAG__c();
        cag.Record_Type__c = 'c';
        cag.CAG_ID__c = '657657';
        insert cag;   
            FAFObj .Peer_Reviewer__c = u.id;
            FAFObj .Sales_Approver__c= u.id; 
          //  update FAFObj;
        Rebate_Operations__c rebOpsObj = ClientTestRef.createRebOps(FAFObj.id);
        insert rebOpsObj;
        Client_Information__c clientINFO = TestDataFactory.createClientInfo(FAFObj.id);        
        clientINFO.Pricing_Effective_Date__c = System.Today();
        insert clientINFO;      
        
        Platform_Specifics__c ps = TestDataFactory.createPlatFormSpecificManagement();
        ps.FAF_Client_Information__c = clientINFO.Id;
        ps.Level_1_Record_ID__c = cag.id; 
        ps.Rebate_Operations__c = rebOpsObj.id;
        ps.LOB__c = 'ACT';
        ps.FAF_ID__c = FAFObj.id;
        ps.EffectiveDate__c = system.Today().addDays(5);
      //  insert ps;   
        FAFObj.Peer_Reviewer__c = u.id;
        update FAFObj;
    
        FAFObj.FAF_Status__c = 'Draft';
        FAFObj.Client_Info__c = clientINFO.id;
        FAFObj.Peer_Reviewed__c = true;
        FAFObj.Peer_Reviewer__c = u.id;
        update FAFObj;
                
    ApexPages.currentPage().getParameters().put('id', FAFObj.Id);
    ApexPages.StandardController FAFSC = new ApexPages.StandardController(FAFObj);
    FAFEditPageController newFAF = new FAFEditPageController(FAFSC);
    FAFEditPageController.calculateRebateEffectiveDate('New',FAFObj.id);
    newFAF.PeerReviewedContinue();
    newFAF.PeerReviewedCancel();
    newFAF.ApprovedBySalesContinue();
    newFAF.ApprovedBySalesCancel();
    }   
    static testmethod void validateApprovedBySalesContinue(){
        
         User testuser = [Select Id, Name from User where id =: userInfo.getUserId()];
         User salesperson = ClientTestRef.createUser('Apttus Sales');
          insert salesperson;
         salesperson.Manager_Level_2__c = testuser.Name;
        update salesperson;
                UserRole role=[select id,name  from userrole where name='Apttus Underwriting'];
        Profile p = [SELECT Id FROM Profile WHERE Name='Apttus Underwriting']; 
        User u1 = new User(Alias = 'standt', Email='standarduser1212@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, userroleid=role.id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='standarduser2121@testorg.com',Market_Segment__c='Employer');        
                
        Account accObj =  ClientTestRef.createAccount();
        insert accObj;
        Opportunity oppObj = ClientTestRef.createOpportunity(accObj.id);
        insert oppObj;
        Central_Hub__c FAFObj = ClientTestRef.createFAF(accObj.id, oppObj.Id, salesperson.Id);
      //  FAFObj.Business_Type__c = 'New';         
        insert FAFObj;
         Rebate_Operations__c rebOpsObj = ClientTestRef.createRebOps(FAFObj.id);
        insert rebOpsObj;
        Client_Information__c clientINFO= TestDataFactory.createClientInfo(FAFObj.id);
        //Client_Information__c clientInfo = [select id, FAF_Id__c from Client_Information__c where FAF_Id__c =: FAFObj.Id limit 1];
        clientINFO.Pricing_Effective_Date__c = System.Today();
        insert clientINFO;
        FAFObj.Peer_Reviewer__c  = u1.id;
        update FAFObj;
        FAFObj.FAF_Status__c = 'Draft';
       // FAFObj.Approved_By_Sales__c = true;
        FAFObj.Sales_Approver__c = UserInfo.getUserId();
        FAFObj.Approved_On__c = system.now();        
        FAFObj.Peer_Reviewed__c = true;
        FAFObj.Peer_Reviewer__c = u1.id;
        update FAFObj;
      //  clientInfo.Rebate_Effective_Date__c =  System.Today();
                
    ApexPages.currentPage().getParameters().put('id', FAFObj.Id);
    ApexPages.StandardController FAFSC = new ApexPages.StandardController(FAFObj);
    FAFEditPageController newFAF = new FAFEditPageController(FAFSC);
    FAFEditPageController.calculateRebateEffectiveDate('New',FAFObj.id);
    //newFAF.PeerReviewedContinue();
    //newFAF.PeerReviewedCancel();
    newFAF.ApprovedBySalesContinue();
    newFAF.ApprovedBySalesCancel();
    }    
    static testmethod void validateNewClientInformation1(){
        
        User salesperson = ClientTestRef.createUser('Apttus Sales');
        insert salesperson;
         User testuser = [Select Id, Name from User where id =: userInfo.getUserId()];
        
        salesperson.Manager_Level_3__c = testuser.Name;
        update salesperson;
                
        Account accObj =  ClientTestRef.createAccount();
        insert accObj;
        Opportunity oppObj = ClientTestRef.createOpportunity(accObj.id);
        insert oppObj;
        Central_Hub__c FAFObj = ClientTestRef.createFAF(accObj.id, oppObj.Id, salesperson.Id);
        FAFObj.Business_Type__c = 'Existing';
        insert FAFObj;
        
        Client_Information__c clientInfo= TestDataFactory.createClientInfo(FAFObj.id);
        //Client_Information__c clientInfo = [select id, FAF_Id__c from Client_Information__c where FAF_Id__c =: FAFObj.Id limit 1];
        clientInfo.Pricing_Effective_Date__c = Date.newInstance(2018, 5, 10);
        insert clientInfo;
       
        ApexPages.currentPage().getParameters().put('id', FAFObj.Id);
        ApexPages.StandardController FAFSC = new ApexPages.StandardController(FAFObj);
        FAFEditPageController newFAF = new FAFEditPageController(FAFSC);
       FAFEditPageController.calculateRebateEffectiveDate('Existing',FAFObj.id);
        
    } 
     static testmethod void validateNewClientInformation2(){
        
        User salesperson = ClientTestRef.createUser('Apttus Sales');
        insert salesperson;
                 User testuser = [Select Id, Name from User where id =: userInfo.getUserId()];
        
        salesperson.Manager_Level_4__c = testuser.Name;
        update salesperson;
        Account accObj =  ClientTestRef.createAccount();
        insert accObj;
        Opportunity oppObj = ClientTestRef.createOpportunity(accObj.id);
        insert oppObj;
        Central_Hub__c FAFObj = ClientTestRef.createFAF(accObj.id, oppObj.Id, salesperson.Id);
        FAFObj.Business_Type__c = 'Existing';
        insert FAFObj;
        Client_Information__c clientInfo= TestDataFactory.createClientInfo(FAFObj.id);
        //Client_Information__c clientInfo = [select id, FAF_Id__c from Client_Information__c where FAF_Id__c =: FAFObj.Id limit 1];
        clientInfo.Pricing_Effective_Date__c = Date.newInstance(2018, 2, 10);
        insert clientInfo;
      
        ApexPages.currentPage().getParameters().put('id', FAFObj.Id);
        ApexPages.StandardController FAFSC = new ApexPages.StandardController(FAFObj);
        FAFEditPageController newFAF = new FAFEditPageController(FAFSC);
       FAFEditPageController.calculateRebateEffectiveDate('Existing',FAFObj.id);
    } 
    static testmethod void validateNewClientInformation3(){
        
        User salesperson = ClientTestRef.createUser('Apttus Sales');
        insert salesperson;
         User testuser = [Select Id, Name from User where id =: userInfo.getUserId()];
        
        salesperson.Manager_Level_5__c = testuser.Name;
        update salesperson;
                
        Account accObj =  ClientTestRef.createAccount();
        insert accObj;
        Opportunity oppObj = ClientTestRef.createOpportunity(accObj.id);
        insert oppObj;
        Central_Hub__c FAFObj = ClientTestRef.createFAF(accObj.id, oppObj.Id, salesperson.Id);
        FAFObj.Business_Type__c = 'Existing';
        insert FAFObj;
        Client_Information__c clientInfo= TestDataFactory.createClientInfo(FAFObj.id);
        //Client_Information__c clientInfo = [select id, FAF_Id__c from Client_Information__c where FAF_Id__c =: FAFObj.Id limit 1];
        clientInfo.Pricing_Effective_Date__c = Date.newInstance(2018, 8, 10);
        insert clientInfo;
      
        ApexPages.currentPage().getParameters().put('id', FAFObj.Id);
        ApexPages.StandardController FAFSC = new ApexPages.StandardController(FAFObj);
        FAFEditPageController newFAF = new FAFEditPageController(FAFSC);
       FAFEditPageController.calculateRebateEffectiveDate('Existing',FAFObj.id);
    } 
    static testmethod void validateNewClientInformation4(){
        
        User salesperson = ClientTestRef.createUser('Apttus Sales');
        insert salesperson;
                 User testuser = [Select Id, Name from User where id =: userInfo.getUserId()];
        
        salesperson.Manager_Level_6__c = testuser.Name;
        update salesperson;
        Account accObj =  ClientTestRef.createAccount();
        insert accObj;
        Opportunity oppObj = ClientTestRef.createOpportunity(accObj.id);
        insert oppObj;
        Central_Hub__c FAFObj = ClientTestRef.createFAF(accObj.id, oppObj.Id, salesperson.Id);
        FAFObj.Business_Type__c = 'Existing';
        insert FAFObj;
        Client_Information__c clientInfo= TestDataFactory.createClientInfo(FAFObj.id);
        //Client_Information__c clientInfo = [select id, FAF_Id__c from Client_Information__c where FAF_Id__c =: FAFObj.Id limit 1];
        clientInfo.Pricing_Effective_Date__c = Date.newInstance(2018, 11, 10);
        insert clientInfo;
      
        ApexPages.currentPage().getParameters().put('id', FAFObj.Id);
        ApexPages.StandardController FAFSC = new ApexPages.StandardController(FAFObj);
        FAFEditPageController newFAF = new FAFEditPageController(FAFSC);
       FAFEditPageController.calculateRebateEffectiveDate('Existing',FAFObj.id);
    } 
    static testmethod void validateNewClientInformation5(){
        
        User salesperson = ClientTestRef.createUser('Apttus Sales');
        insert salesperson;
         User testuser = [Select Id, Name from User where id =: userInfo.getUserId()];
        
        salesperson.Manager_Level_7__c = testuser.Name;
        update salesperson;
                
        Account accObj =  ClientTestRef.createAccount();
        insert accObj;
        Opportunity oppObj = ClientTestRef.createOpportunity(accObj.id);
        insert oppObj;
        Central_Hub__c FAFObj = ClientTestRef.createFAF(accObj.id, oppObj.Id, salesperson.Id);
        FAFObj.Business_Type__c = 'Existing';        
        insert FAFObj;
        Client_Information__c clientInfo= TestDataFactory.createClientInfo(FAFObj.id);
        //Client_Information__c clientInfo = [select id, FAF_Id__c from Client_Information__c where FAF_Id__c =: FAFObj.Id limit 1];
        clientInfo.Pricing_Effective_Date__c = Date.newInstance(2018, 1, 1);
        insert clientInfo;
      
        ApexPages.currentPage().getParameters().put('id', FAFObj.Id);
        ApexPages.StandardController FAFSC = new ApexPages.StandardController(FAFObj);
        FAFEditPageController newFAF = new FAFEditPageController(FAFSC);
       FAFEditPageController.calculateRebateEffectiveDate('Existing',FAFObj.id);
    } 
     static testmethod void validateNewClientInformation6(){
        
        User salesperson = ClientTestRef.createUser('Apttus Sales');
        insert salesperson;
                
        Account accObj =  ClientTestRef.createAccount();
        insert accObj;
        Opportunity oppObj = ClientTestRef.createOpportunity(accObj.id);
        insert oppObj;
        Central_Hub__c FAFObj = ClientTestRef.createFAF(accObj.id, oppObj.Id, salesperson.Id);
        FAFObj.FAF_Status__c = 'Draft';
        insert FAFObj;
        Client_Information__c clientInfo= TestDataFactory.createClientInfo(FAFObj.id);
        //Client_Information__c clientInfo = [select id, FAF_Id__c from Client_Information__c where FAF_Id__c =: FAFObj.Id limit 1];
        clientInfo.Pricing_Effective_Date__c = null;
        insert clientInfo;
      
        ApexPages.currentPage().getParameters().put('id', FAFObj.Id);
        ApexPages.StandardController FAFSC = new ApexPages.StandardController(FAFObj);
        FAFEditPageController newFAF = new FAFEditPageController(FAFSC);
       FAFEditPageController.calculateRebateEffectiveDate('none',FAFObj.id);
    } 
}