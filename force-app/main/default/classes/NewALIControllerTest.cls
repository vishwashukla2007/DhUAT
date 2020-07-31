@isTest
         public class NewALIControllerTest {
         //Method 1
         /*
                static testmethod void TestMethod1(){
                    User salesperson = ClientTestRef.createUser('Apttus Sales');
                    insert salesperson;
                    Account accObj =  ClientTestRef.createAccount();
                    insert accObj;
                    Opportunity oppObj = ClientTestRef.createOpportunity(accObj.id);
                    insert oppObj;
                    Central_Hub__c FAFObj = ClientTestRef.createFAF(accObj.id, oppObj.Id, salesperson.Id);
                    insert FAFObj;
                    FAFObj.FAF_Status__c='Uploaded';
                    FAFObj.Manual_LOB_ID__c='1';
                    FAFObj.Manual_Task_ID__c='1';
                    FAFObj.Manual_Offer_ID__c='1';
                    
                    Update FAFObj;
                            Apttus__APTS_Agreement__c agr=new Apttus__APTS_Agreement__c();
                            agr.Apttus__Account__c=accObj.id;
                            agr.Opportunity__c=oppObj.id;
                            insert agr;
                            
                            Apttus__AgreementLineItem__c agrline=new Apttus__AgreementLineItem__c();
                            agrline.Apttus__AgreementId__c=agr.id;
                            agrline.PCD_FAF__c=FAFObj.id;
                            agrline.Apttus_CMConfig__LineNumber__c=0;
                            agrline.Apttus_CMConfig__ItemSequence__c=0;
                            insert agrline;
                        Test.StartTest();
                        
                           Apexpages.StandardController stdController = new Apexpages.StandardController(agrline);
                        NewALIController newali=new NewALIController(stdController);
                        PageReference pageRef = page.ALIEdit_New;  
                         pageRef.getParameters().put('id',agrline.id); 
                            test.setCurrentPage(pageRef); 
                         
                        newali.PageRedirect();
                        
                        Test.StopTest();
                        
                }
                */
        }