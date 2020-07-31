@isTest
        public class iUMSTaskTriggerHelperTest{
         //Method 1
                static testmethod void TestMethod1(){
                    User underwriter = ClientTestRef.createUser('Apttus Underwriting');
                    insert underwriter;
                    System.RunAs(underwriter)
                    {   
                            Test.StartTest();
                            iUMS_Task_Setup__c obj=new iUMS_Task_Setup__c();
                            obj.Status__c='Draft';
                            obj.Task_Id__c= '16402';
                            obj.PBM_Offer__c= 1;
                            obj.SRX_Offer__c= 1;
                            insert obj;
                            iUMS_Task_Setup__c obj2=new iUMS_Task_Setup__c(); 
                            obj2.Id= obj.Id;                          
                            obj2.PBM_Offer__c= 2;
                            update obj2;                           
                            iUMSTaskTriggerHelper.Permissionsetaddition('Ready to Load');
                            iUMSTaskTriggerHelper.Permissionsetremoval('Complete');
                            Test.StopTest();
                    }
                }
           }