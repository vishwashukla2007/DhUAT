@isTest
        public class TriggersDisableEnableTest{
         //Method 1
                static testmethod void TestMethod1(){
                    User salesperson = ClientTestRef.createUser('Apttus Sales');
                    insert salesperson;
                     System.RunAs(salesperson)
                    {   
                            Test.StartTest(); 
                            PermissionSetAssignment psa = new PermissionSetAssignment(PermissionSetId =Label.iUMS_Permission_Set_ID, AssigneeId =userInfo.getUserID());
                  //        insert psa;
                            Account accObj =  ClientTestRef.createAccount();
                            insert accObj;
                            Opportunity oppObj = ClientTestRef.createOpportunity(accObj.id);
                            insert oppObj;
                            Central_Hub__c FAFObj = ClientTestRef.createFAF(accObj.id, oppObj.Id, salesperson.Id);
                            insert FAFObj;  
                            Central_Hub__c FAFObj1 = ClientTestRef.createFAF(accObj.id, oppObj.Id, salesperson.Id);
                            insert FAFObj1;   
                            TriggersDisable.TriggersDisable();
                            TriggersEnable.TriggersEnable();
                            Test.stopTest();
                      }
                  }
                  
            }