@isTest
        public class FAFCopyRequestTriggerHelperTest{
         //Method 1
                static testmethod void TestMethod1(){
                    User salesperson = ClientTestRef.createUser('Apttus Sales');
                    insert salesperson;
                     System.RunAs(salesperson)
                    {   
                            Test.StartTest(); 
                            PermissionSetAssignment psa = new PermissionSetAssignment(PermissionSetId =Label.iUMS_Permission_Set_ID, AssigneeId =userInfo.getUserID());
                       //   insert psa;
                            Account accObj =  ClientTestRef.createAccount();
                            insert accObj;
                            Opportunity oppObj = ClientTestRef.createOpportunity(accObj.id);
                            insert oppObj;
                            Central_Hub__c FAFObj = ClientTestRef.createFAF(accObj.id, oppObj.Id, salesperson.Id);
                            insert FAFObj;  
                            Central_Hub__c FAFObj1 = ClientTestRef.createFAF(accObj.id, oppObj.Id, salesperson.Id);
                            insert FAFObj1;                             
                            FAF_Copy_Request__c fafcopy=new FAF_Copy_Request__c();
                            fafcopy.FAF__c=FAFObj.id;
                            fafcopy.New_FAF__c=FAFObj1.id;
                            fafcopy.Account__c=accObj.id;
                            fafcopy.Opportunity__c=oppObj.id;
                            fafcopy.Platform_Specifics__c=true;
                            fafcopy.Legal_Information__c=true;
                            fafcopy.Client_Information__c=true;
                            insert fafcopy; 
                            fafcopy.Client_Information__c=false;
                            update fafcopy;
                            FAFCopyRequestTriggerHelper.Permissionsetaddition('In Progress');
                            FAFCopyRequestTriggerHelper.Permissionsetremoval('Completed');
                            Test.StopTest();
                    }
                }
        }