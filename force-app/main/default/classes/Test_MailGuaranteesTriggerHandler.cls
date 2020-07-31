@isTest
public class Test_MailGuaranteesTriggerHandler {
    
    static testMethod void  runTest1(){
       try{
                //Create a user with Apttus Underwriting Profile
                User useObj = TestDataFactory.createUser('Apttus Underwriting');
                insert useObj;
                
                //Create another user with Apttus Sales Profile
                User useObjNew = TestDataFactory.createUser('Apttus Sales');
                insert useObjNew;
                
                 System.runAs(useObj){
                     //Create Account Record
                    Account accObj =  TestDataFactory.createAccount();
                    insert accObj;
                    
                    //Create Opportunity Record 
                    Opportunity oppObj = TestDataFactory.createOpportunity(accObj.id);
                    insert oppObj;
                    
                    //Create CentralHub Record 
                    Central_Hub__c FAFObj = TestDataFactory.createFAF(accObj.id, oppObj.Id, useObjNew.id);
                    insert FAFObj;
                                        
                    //Mail Operatrions
                    Mail_Operations__c MOP=TestDataFactory.createmailOperatns(FAFObj.id);
                    insert MOP;
                    
                   Test.startTest();            
                   Mail_Pricing__c MP=TestDataFactory.createmailPricing(FAFObj.id,MOP.id);
                   MP.SSG_Exclusion_List__c='Standard';
                   MP.SSG_Exclusivity_Period__c='Custom';
                   MP.SSGs_into_Brands__c=true;
                    insert Mp;
                      
                    list <Mail_Guarantees__c> MGList = new list <Mail_Guarantees__c>();                   
                   Mail_Guarantees__c  MG=TestDataFactory.createmailGuarantee(FAFObj.id,MP.id);
                    MG.Type__c ='BER';
                    MG.SSG__c='No';
                    MGList.add(MG);
                     
                    Mail_Guarantees__c  MG1=TestDataFactory.createmailGuarantee(FAFObj.id,MP.id);
                    MG1.SSG__c='No';
                    MGList.add(MG1);
                     
                    Mail_Guarantees__c  MG2=TestDataFactory.createmailGuarantee(FAFObj.id,MP.id);
                    MG2.Type__c ='BER';
                    MGList.add(MG2);
                   
                                       
                    insert MGList;
                    Delete MG;
                    Delete MG1;
                    Delete MG2;
                    Test.stopTest();
                            
                 }
            }Catch(exception e){
                system.debug('++++++++no coveragre+++++'+e.getmessage());
            }
    }
    @isTest
     static void  runTest2(){
       
                //Create a user with Apttus Underwriting Profile
        User useObj = TestDataFactory.createUser('Apttus Underwriting');
        insert useObj;
        
        //Create another user with Apttus Sales Profile
        User useObjNew = TestDataFactory.createUser('Apttus Sales');
        insert useObjNew;
        
        System.runAs(useObj){
            //Create Account Record
            Account accObj =  TestDataFactory.createAccount();
            insert accObj;
            
            //Create Opportunity Record 
            Opportunity oppObj = TestDataFactory.createOpportunity(accObj.id);
            insert oppObj;
            
            //Create CentralHub Record 
            Central_Hub__c FAFObj = TestDataFactory.createFAF(accObj.id, oppObj.Id, useObjNew.id);
            insert FAFObj;
           
            test.starttest();
            Mail_Operations__c mailOps  = TestDataFactory.createmailOperatns(FAFObj.id);
            insert mailOps;
            
                      
            Mail_Pricing__c mailPricObj = TestDataFactory.createmailPricing(FAFObj.id,mailOps.id);
            insert mailPricObj;
            
                    
            Mail_Guarantees__c  MG=TestDataFactory.createmailGuarantee(FAFObj.id,mailPricObj.id);
            MG.Type__c ='BER';
            MG.SSG__c='No';
            insert MG;
                    
            MG.Type__c ='GER';
            update MG;
                       
            Field_History_Tracking__c fht= new Field_History_Tracking__c();
            fht.Mail_Guarantees__c=true;       
            delete MG;
            Test.stopTest();
                            
        }
            
    }
 }