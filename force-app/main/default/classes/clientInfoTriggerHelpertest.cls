@isTest
public with sharing class clientInfoTriggerHelpertest{
    @isTest(seeAllData=true)
    static void clientInfoTriggerHelpertestMeth1()
    {
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
            
             CAG__c cag = new CAG__c();
                cag.CAG_ID__c = 'CAG1234567890789TEST';
                cag.Record_Type__c='A';
                cag.Status__c='A';
                
                insert cag;
                               
            List<Client_Information__c> clientInfolist=new List<Client_Information__c>();
            List<Client_Information__c> clientInfolist1=new List<Client_Information__c>();
            Map<id,Client_Information__c> oldmap = new Map<id,Client_Information__c>();
                        
            Client_Information__c clientInfo = TestDataFactory.createClientInfo(FAFObj.id);
            clientInfo.Pricing_Effective_Date__c = System.Today();
            clientInfo.Contract_End_Date__c = System.Today();
            insert clientInfo;
            
            Billing_Operations__c billOps = TestDataFactoryForBilling.createBillOps(FAFObj.id);
            insert billOps;
            Broker_TPA_Name_Support__c brokerName = TestDataFactoryForBilling.createBrokersupport();
            insert brokerName;
            Billing_Broker_TPA_Payments__c btpa = TestDataFactoryForBilling.createBrokerTPA(FAFObj.id, billOps.id, brokerName.id);
            btpa.Effective_Date__c = System.Today();
            insert btpa;
            Contractual_Payments__c bop = TestDataFactory.createBillOthrPaymnts(FAFObj.id, billOps.id);
            bop.Expiration__c = System.Today();
            insert bop;
            clientInfo.Pricing_Effective_Date__c = System.Today().addDays(7);
            clientInfo.Contract_End_Date__c = System.Today().addDays(7);
            //update clientInfo;
            clientInfolist1.add(clientInfo);
            test.starttest();
            
            Platform_Specifics__c platSpec = new Platform_Specifics__c();
            platSpec.FAF_ID__c = FAFObj.id;
            platSpec.FAF_Client_Information__c= clientInfo.id;
            platSpec.Platform__c = 'RBU';
            platSpec.LOB__c = 'MEDI';
            platSpec.Level_1_Record_ID__c = cag.Id;
            platSpec.Instruction__c = 'Include';
            platSpec.EffectiveDate__c = System.Today();
          //  insert platSpec;
                        
            List <Platform_Specifics__c> platSpecList = new List<Platform_Specifics__c>();
            platSpecList=  [Select Id,FAF_ID__c,EffectiveDate__c,FAF_Client_Information__c  from Platform_Specifics__c];
            
            clientInfolist = [Select Id,FAF_ID__c,Pricing_Effective_Date__c,Contract_End_Date__c from Client_Information__c];   
            oldMap = new Map<id,Client_Information__c>([Select Id,FAF_ID__c,Pricing_Effective_Date__c,Contract_End_Date__c from Client_Information__c]);   
            
            clientInfoTriggerHelper.checkCountOnBeforeInsert(clientInfolist);
            clientInfoTriggerHelper.updatePlatformSpefics(clientInfolist,oldmap);
            clientInfoTriggerHelper.clientInfoPricingEffectiveDateCheck(clientInfolist1,oldmap);
            clientInfoTriggerHelper.clientInfoContractEndDateCheck(clientInfolist1,oldmap);
            
            Field_History_Tracking__c fht=new Field_History_Tracking__c();
            fht.Client_Information__c=true;
            delete clientInfo;
            
            test.stoptest();
        }
    }
    
    static testmethod void clientInfoTriggerHelpertestMeth2()
    {
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
             
            CAG__c cag = new CAG__c();
                cag.CAG_ID__c = 'CAG1234567890789TEST';
                cag.Record_Type__c='A';
                cag.Status__c='A';
                
                insert cag;
                               
            List<Client_Information__c> clientInfolist=new List<Client_Information__c>();
            Map<id,Client_Information__c> oldmap = new Map<id,Client_Information__c>();
                        
            Client_Information__c clientInfo = TestDataFactory.createClientInfo(FAFObj.id);
            clientInfo.Pricing_Effective_Date__c = System.Today();
            
            clientInfo.FAF_ID__c= FAFObj.id;
            insert clientInfo;
            
            Platform_Specifics__c platSpec = new Platform_Specifics__c();
            platSpec.FAF_ID__c = FAFObj.id;
            platSpec.FAF_Client_Information__c= clientInfo.id;
            platSpec.Platform__c = 'RBU';
            platSpec.Level_1_Record_ID__c = cag.Id;
            platSpec.LOB__c = 'MEDI';
            platSpec.Instruction__c = 'Include';
            platSpec.EffectiveDate__c = System.Today();
           // insert platSpec;
            
            Platform_Specifics__c platSpec1 = new Platform_Specifics__c();
            platSpec1.FAF_ID__c = FAFObj.id;
            platSpec1.FAF_Client_Information__c= clientInfo.id;
            platSpec1.Platform__c = 'RxCLAIM';
            platSpec1.LOB__c = 'MEDI';
            platSpec1.Instruction__c = 'Include';
            platSpec1.Level_1_Record_ID__c = cag.Id;
            platSpec1.EffectiveDate__c = System.Today();
           // insert platSpec1;
            
            //clientInfo.Pricing_Effective_Date__c = System.Today()+1;
            //update clientInfo; 
            clientInfolist = [Select Id,FAF_ID__c,Pricing_Effective_Date__c from Client_Information__c];  
            clientInfo.Pricing_Effective_Date__c = System.today()+1;
            
            //oldMap = new Map<id,Client_Information__c>([Select Id,FAF_ID__c,Pricing_Effective_Date__c from Client_Information__c]);   
            oldMap.put(clientInfolist[0].id, clientInfo);
            system.debug('========clientInfolist======'+clientInfolist);
            system.debug('========oldMap======'+oldMap);
            //List <Platform_Specifics__c> platSpecList = new List<Platform_Specifics__c>();
            //platSpecList=  [Select Id,FAF_ID__c,EffectiveDate__c,FAF_Client_Information__c from Platform_Specifics__c];
            
            test.starttest();
            //clientInfoTriggerHelper.checkCountOnBeforeInsert(clientInfolist);
            clientInfoTriggerHelper.updatePlatformSpefics(clientInfolist,oldMap);
            test.stoptest();
        }
    }
}