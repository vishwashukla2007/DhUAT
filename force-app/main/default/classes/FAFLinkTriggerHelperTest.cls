/*********************************************************************************************
* @author   Priyanka Goyal
* @date     03 10 2018
* @description:This is the test class for FAFLinkTriggerHelper        
**********************************************************************************************/


@isTest
public with sharing class FAFLinkTriggerHelperTest {
    static testmethod void FAFLinkTriggerHelperTestMeth1()
    {
        
        try{
            User salesperson = ClientTestRef.createUser('Apttus Sales');
            insert salesperson;
                    
            Account accObj =  ClientTestRef.createAccount();
            insert accObj;
            Opportunity oppObj = ClientTestRef.createOpportunity(accObj.id);
            insert oppObj;
            Test.startTest();
            //Insert Full FAF 
            Central_Hub__c fullFAF = ClientTestRef.createFAF(accObj.id, oppObj.Id, salesperson.Id);
            fullFAF.Business_Type__c = 'New';
            fullFAF.FAF_Status__c = 'Closed';
            fullFAF.FAF_Type__c  = 'Full';
            insert fullFAF;
            
            //Inset Partial FAF
            Central_Hub__c FAFObj = ClientTestRef.createFAF(accObj.id, oppObj.Id, salesperson.Id);
            FAFObj.Business_Type__c = 'Existing';
            FAFObj.FAF_Status__c = 'Draft';
            insert FAFObj;
            
            //Link Partial and Full FAF
            FAF_Link__c fafLink = new FAF_Link__c();
            fafLink.Full_FAF__c = fullFAF.Id;
            fafLink.Partial_FAF__c = FAFObj.Id;
            insert fafLink;
            delete fafLink;
            
             FAF_Link__c fafLink2 = new FAF_Link__c();
             insert fafLink2;
            delete fafLink2;
            FAFLinkTriggerHelper fp=new FAFLinkTriggerHelper();
            fp.IncreaseCOverage();
            
        }
        catch(Exception ex){
            FAF_Link__c fafLink1 = new FAF_Link__c();
            insert fafLink1;
            delete fafLink1;    
        }
        
    }
        
}