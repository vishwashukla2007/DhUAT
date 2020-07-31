@isTest
private class PlatformSpecificTriggerHelperTest{
    @isTest
        public static void PlatformSpecificManagement_Test(){
            User u  = TestDataFactory.createUser('System Administrator');
            User useObjNew = TestDataFactory.createUser('Apttus Sales');
            insert useObjNew;
             useObjNew.ManagerId=Userinfo.getUserId();
             useObjNew.Manager_Level_2__c=Userinfo.getName();
               update useObjNew;
                System.runAs(useObjNew){
                
                PermissionSet pss = [SELECT Id FROM PermissionSet WHERE Name ='E_Apttus_Sales'];
                PermissionSetAssignment psa = new PermissionSetAssignment();
                psa.AssigneeId = useObjNew.Id;
                psa.PermissionSetId = pss.Id;
                insert psa;
                
                
                
                Account acc = TestDataFactory.createAccount();
                acc.Account_Level__c ='SuperClient';
                acc.iUMS_Client_Subtype__c = 'Health Plan Master';
                insert acc;
                
                Opportunity opp = TestDataFactory.createOpportunity(acc.Id);
                Insert opp;
                
                Central_Hub__c FAF = TestDataFactory.createFAF(acc.Id,opp.Id,u.Id);
                FAF.Salesperson__c=Userinfo.getUserId();
                Insert FAF;
                
                Client_Information__c ClientInformation = TestDataFactory.createClientInfo(FAF.Id);
                Insert ClientInformation;
                
                Rebate_Operations__c createRebOps=TestDataFactory.createRebOps(FAF.Id);
                insert createRebOps;
                createRebOps.Non_Specialty_Formulary_Option__c='Client Choice';
                createRebOps.GSTP_Option__c='Choice';
                createRebOps.Specialty_Formulary_Option__c='Client Choice';
                update createRebOps;
                List<Platform_Specifics__c> Platlist =new List<Platform_Specifics__c>();
                // CAG__c cg =TestDataFactory.createCAG('C','RxClaim');
                 //cg.Carrier_ID__c=ps.Level_1_ID_XAE__c;
                 
                 //insert cg;
                
                CAG__c cg =TestDataFactory.createCAG('C','RxClaim');
                cg.Carrier_ID__c='Test';
                cg.Record_Type__c='C';
                cg.Platform_Name__c='RxCLAIM';
                insert cg;
                
                CAG__c cg1 =TestDataFactory.createCAG('A','RxClaim');
                cg1.Account_ID__c='Test2';
                cg1.Carrier_ID__c='Test';
                cg1.Record_Type__c='A';
                cg1.Platform_Name__c='RxCLAIM';
                //insert cg1;
                
                CAG__c cag1 = new CAG__c();
                cag1.CAG_ID__c = '12345678901';
                cag1.Carrier_ID__c = 'Test';
                cag1.Non_Validated_CAG__c = true;
                cag1.Platform_Name__c ='RxCLAIM';
                cag1.Record_Type__c='A';
                cag1.Account_ID__c='Test1';
                cag1.RecordTypeId = [select id from RecordType where Name ='A'].Id;
                insert cag1;
                
                 CAG__c cag2 = new CAG__c();
                cag2.CAG_ID__c = '123456789071';
                cag2.Carrier_ID__c = 'Test';
                cag2.Non_Validated_CAG__c = true;
                cag2.Platform_Name__c ='RxCLAIM';
                cag2.Record_Type__c='G';
                cag2.Account_ID__c='Test1';
                cag2.Group_ID__c='Test2';
                cag2.RecordTypeId = [select id from RecordType where Name ='G'].Id;
                insert cag2;
                
                 
                Platform_Specifics__c ps = TestDataFactory.createPlatFormSpecificManagement();
                ps.FAF_Client_Information__c = ClientInformation.Id;
                ps.Rebate_Operations__c=createRebOps.id;
                ps.LOB__c='STD';
                ps.CAG_ID__c='A'; 
                ps.FAF_Client_Information__c=ClientInformation.id;
                ps.DeleteRow__c=false;
                ps.XAE__c= true;
                ps.Platform__c='RxCLAIM';
                ps.LOB__c='PDP';
                ps.Instruction__c='Include';
                ps.Level_1_ID_XAE__c='Test';
                ps.Level_2_ID_XAE__c='Test1';
                ps.Level_3_ID_XAE__c='Test2';
               
                 Platlist.add(ps);
                try{
                insert Platlist; 
                }catch(Exception e){
                    
                }
                
                Test.startTest();
                PlatformSpecificTriggerHelper.validateXAERecords(Platlist,true,false);
                PlatformSpecificTriggerHelper.validateXAERecords(Platlist,false,true);
                PlatformSpecificTriggerHelper.DeleteXAE(Platlist,true,false);
                PlatformSpecificTriggerHelper.updateclientinfo(Platlist);
                PlatformSpecificTriggerHelper.DeleteXAE(Platlist,false,true);
                PlatformSpecificTriggerHelper.validatduplicateRecords(Platlist,false,true);
                PlatformSpecificTriggerHelper.validatduplicateRecords(Platlist,true,false);
                PlatformSpecificTriggerHelper.UpdateIPIWAstatus(Platlist,Platlist,true);
                PlatformSpecificTriggerHelper.updateEffectivedates(Platlist);
                Test.StopTest();
        }   
        
    }
     @isTest
        public static void PlatformSpecificManagement_Test2(){
            
        User u  = TestDataFactory.createUser('System Administrator');
            User useObjNew = TestDataFactory.createUser('Apttus Sales');
            insert useObjNew;
             useObjNew.ManagerId=Userinfo.getUserId();
             useObjNew.Manager_Level_2__c=Userinfo.getName();
               update useObjNew;
                System.runAs(useObjNew){
                
                PermissionSet pss = [SELECT Id FROM PermissionSet WHERE Name ='E_Apttus_Sales'];
                PermissionSetAssignment psa = new PermissionSetAssignment();
                psa.AssigneeId = useObjNew.Id;
                psa.PermissionSetId = pss.Id;
                insert psa;
                
                
                
                Account acc = TestDataFactory.createAccount();
                acc.Account_Level__c ='SuperClient';
                acc.iUMS_Client_Subtype__c = 'Health Plan Master';
                insert acc;
                
                Opportunity opp = TestDataFactory.createOpportunity(acc.Id);
                Insert opp;
                
                Central_Hub__c FAF = TestDataFactory.createFAF(acc.Id,opp.Id,u.Id);
                FAF.Salesperson__c=Userinfo.getUserId();
                FAF.FAF_Status__c='Implemented';
                FAF.FAF_Copy_In_Progress__c=true;
                FAF.Source_Copy_FAF_Status__c='Implemented';
                Insert FAF;
                
                Client_Information__c ClientInformation = TestDataFactory.createClientInfo(FAF.Id);
                Insert ClientInformation;
                
                Rebate_Operations__c createRebOps=TestDataFactory.createRebOps(FAF.Id);
                insert createRebOps;
                createRebOps.Non_Specialty_Formulary_Option__c='Client Choice';
                createRebOps.GSTP_Option__c='Choice';
                createRebOps.Specialty_Formulary_Option__c='Client Choice';
                update createRebOps;
                
                 Network_Operations__c np=TestDataFactory.createntwrkOperatns(FAF.Id);
                 insert np;
                List<Platform_Specifics__c> Platlist =new List<Platform_Specifics__c>();
                List<Platform_Specifics__c> PlatlistNew =new List<Platform_Specifics__c>();
                
                CAG__c cg =TestDataFactory.createCAG('C','RxClaim');
                cg.Carrier_ID__c='Test';
                cg.Record_Type__c='C';
                cg.Platform_Name__c='RxCLAIM';
                insert cg;
                
                CAG__c cg1 =TestDataFactory.createCAG('A','RxClaim');
                cg1.Account_ID__c='Test2';
                cg1.Carrier_ID__c='Test';
                cg1.Record_Type__c='A';
                cg1.Platform_Name__c='RxCLAIM';
                //insert cg1;
                
                CAG__c cag1 = new CAG__c();
                cag1.CAG_ID__c = '12345678901';
                cag1.Carrier_ID__c = 'Test';
                cag1.Non_Validated_CAG__c = true;
                cag1.Platform_Name__c ='RxCLAIM';
                cag1.Record_Type__c='A';
                cag1.Account_ID__c='Test1';
                cag1.RecordTypeId = [select id from RecordType where Name ='A'].Id;
                insert cag1;
                
                 CAG__c cag2 = new CAG__c();
                cag2.CAG_ID__c = '123456789071';
                cag2.Carrier_ID__c = 'Test';
                cag2.Non_Validated_CAG__c = true;
                cag2.Platform_Name__c ='RxCLAIM';
                cag2.Record_Type__c='G';
                cag2.Account_ID__c='Test1';
                cag2.Group_ID__c='Test2';
                cag2.RecordTypeId = [select id from RecordType where Name ='G'].Id;
                insert cag2;
                
                
                 
                Platform_Specifics__c ps = TestDataFactory.createPlatFormSpecificManagement();
                ps.FAF_Client_Information__c = ClientInformation.Id;
                ps.Rebate_Operations__c=createRebOps.id;
                ps.LOB__c='STD';
                ps.CAG_ID__c='A'; 
                ps.FAF_ID__c=FAF.id;
                //ps.FAF_Client_Information__c=ClientInformation.id;
                ps.DeleteRow__c=false;
                ps.XAE__c= true;
                ps.Platform__c='RxCLAIM';
                ps.LOB__c='PDP';
                ps.Instruction__c='Include';
                ps.Level_1_ID_XAE__c='Test';
                ps.Level_2_ID_XAE__c='Test1';
                ps.Level_3_ID_XAE__c='Test2';
                ps.EffectiveDate__c=Date.ValueOf(System.now().adddays(1));
               
                 Platlist.add(ps);
                
                insert Platlist; 
                
                Platlist[0]. Instruction__c='Exclude';
                update Platlist;
                
                CAG__c cg0 =TestDataFactory.createCAG('C','RxClaim');
                cg0.Carrier_ID__c='Test23';
                cg0.Record_Type__c='C';
                cg0.Platform_Name__c='RxCLAIM';
                cg0.CAG_ID__c = '12345678341';
                insert cg0;
                  
                Platform_Specifics__c ps1 = TestDataFactory.createPlatFormSpecificManagement();
                ps1.FAF_Client_Information__c = ClientInformation.Id;
                ps1.FAF_ID__c=FAF.id;
                ps1.Rebate_Operations__c=createRebOps.id;
                ps1.LOB__c='STD';
                ps1.CAG_ID__c='A'; 
                //ps.FAF_Client_Information__c=ClientInformation.id;
                ps1.DeleteRow__c=false;
                ps1.XAE__c= true;
                ps1.Platform__c='RxCLAIM';
                ps1.LOB__c='PDP';
                ps1.Instruction__c='Include';
                ps1.Level_1_ID_XAE__c='Test23';
                ps1.EffectiveDate__c=Date.ValueOf(System.now());
                PlatlistNew.add(ps1);
                insert PlatlistNew; 
                List<IPI_WA_Tasks__c> ipwList=new List<IPI_WA_Tasks__c>();
                
                IPI_WA_Tasks__c iwp=new IPI_WA_Tasks__c();
                iwp.Pricing_Effective_Date__c=PlatlistNew[0].EffectiveDate__c;
                iwp.Carrier_ID__c=PlatlistNew[0].Level_1_ID_XAE__c;
                //insert iwp;
                
                IPI_WA_Tasks__c iwp1=new IPI_WA_Tasks__c();
                iwp1.Pricing_Effective_Date__c=Platlist[0].EffectiveDate__c;
                iwp1.Carrier_ID__c=Platlist[0].Level_1_ID_XAE__c;
                //insert iwp1;
                
                ipwList.add(iwp1);
                 ipwList.add(iwp);
                 insert  ipwList;
                
                
                
                
                Test.startTest();
                PlatformSpecificTriggerHelper.validateXAERecords(Platlist,true,false);
                PlatformSpecificTriggerHelper.validateXAERecords(Platlist,false,true);
                PlatformSpecificTriggerHelper.DeleteXAE(Platlist,true,false);
                PlatformSpecificTriggerHelper.updateclientinfo(Platlist);
                PlatformSpecificTriggerHelper.DeleteXAE(Platlist,false,true);
                PlatformSpecificTriggerHelper.validatduplicateRecords(Platlist,false,true);
                PlatformSpecificTriggerHelper.validatduplicateRecords(Platlist,true,false);
                PlatformSpecificTriggerHelper.UpdateIPIWAstatus(PlatlistNew,Platlist,false);
               // PlatformSpecificTriggerHelper.UpdateIPIWAstatus(Platlist,PlatlistNew,true);
                PlatformSpecificTriggerHelper.updateEffectivedates(Platlist);
                
                Test.StopTest();
        }   
            
            
            
        }
        
        @isTest(SeeAllData=true)
        public static void PlatformSpecificManagement_Test3(){
            
        User u  = TestDataFactory.createUser('System Administrator');
            User useObjNew = TestDataFactory.createUser('Apttus Sales');
            insert useObjNew;
             useObjNew.ManagerId=Userinfo.getUserId();
             useObjNew.Manager_Level_2__c=Userinfo.getName();
               update useObjNew;
                System.runAs(useObjNew){
                
                PermissionSet pss = [SELECT Id FROM PermissionSet WHERE Name ='E_Apttus_Sales'];
                PermissionSetAssignment psa = new PermissionSetAssignment();
                psa.AssigneeId = useObjNew.Id;
                psa.PermissionSetId = pss.Id;
                insert psa;
                
                
                
                Account acc = TestDataFactory.createAccount();
                acc.Account_Level__c ='SuperClient';
                acc.iUMS_Client_Subtype__c = 'Health Plan Master';
                insert acc;
                
                Opportunity opp = TestDataFactory.createOpportunity(acc.Id);
                Insert opp;
                
                Central_Hub__c FAF = TestDataFactory.createFAF(acc.Id,opp.Id,u.Id);
                FAF.Salesperson__c=Userinfo.getUserId();
                FAF.FAF_Status__c='Implemented';
                FAF.FAF_Copy_In_Progress__c=true;
                FAF.Source_Copy_FAF_Status__c='Implemented';
                Insert FAF;
                
                Client_Information__c ClientInformation = TestDataFactory.createClientInfo(FAF.Id);
                Insert ClientInformation;
                
                Rebate_Operations__c createRebOps=TestDataFactory.createRebOps(FAF.Id);
                insert createRebOps;
                createRebOps.Non_Specialty_Formulary_Option__c='Client Choice';
                createRebOps.GSTP_Option__c='Choice';
                createRebOps.Specialty_Formulary_Option__c='Client Choice';
                update createRebOps;
                
                 Network_Operations__c np=TestDataFactory.createntwrkOperatns(FAF.Id);
                 insert np;
                List<Platform_Specifics__c> Platlist =new List<Platform_Specifics__c>();
                List<Platform_Specifics__c> PlatlistNew =new List<Platform_Specifics__c>();
                
                CAG__c cg =TestDataFactory.createCAG('C','RxClaim');
                cg.Carrier_ID__c='Test';
                cg.Record_Type__c='C';
                cg.Platform_Name__c='RxCLAIM';
                insert cg;
                
                CAG__c cg1 =TestDataFactory.createCAG('A','RxClaim');
                cg1.Account_ID__c='Test2';
                cg1.Carrier_ID__c='Test';
                cg1.Record_Type__c='A';
                cg1.Platform_Name__c='RxCLAIM';
                //insert cg1;
                
                CAG__c cag1 = new CAG__c();
                cag1.CAG_ID__c = '12345678901';
                cag1.Carrier_ID__c = 'Test';
                cag1.Non_Validated_CAG__c = true;
                cag1.Platform_Name__c ='RxCLAIM';
                cag1.Record_Type__c='A';
                cag1.Account_ID__c='Test1';
                cag1.RecordTypeId = [select id from RecordType where Name ='A'].Id;
                insert cag1;
                
                 CAG__c cag2 = new CAG__c();
                cag2.CAG_ID__c = '123456789071';
                cag2.Carrier_ID__c = 'Test';
                cag2.Non_Validated_CAG__c = true;
                cag2.Platform_Name__c ='RxCLAIM';
                cag2.Record_Type__c='G';
                cag2.Account_ID__c='Test1';
                cag2.Group_ID__c='Test2';
                cag2.RecordTypeId = [select id from RecordType where Name ='G'].Id;
                insert cag2;
                
                 Field_History_Tracking__c fht= new Field_History_Tracking__c();
                 fht.Platform_Specifics__c=true;
                 
                  Field_History_Bulk_Upload_Exclude__c  fhbux= new Field_History_Bulk_Upload_Exclude__c ();
                 fhbux.Platform_Specifics__c=true;
                 
                Platform_Specifics__c ps = TestDataFactory.createPlatFormSpecificManagement();
                ps.FAF_Client_Information__c = ClientInformation.Id;
                ps.Rebate_Operations__c=createRebOps.id;
                ps.LOB__c='STD';
                ps.CAG_ID__c='A'; 
                ps.FAF_ID__c=FAF.id;
                //ps.FAF_Client_Information__c=ClientInformation.id;
                ps.DeleteRow__c=false;
                ps.XAE__c= true;
                ps.Platform__c='RxCLAIM';
                ps.LOB__c='PDP';
                ps.Instruction__c='Include';
                ps.Level_1_ID_XAE__c='Test';
                ps.Level_2_ID_XAE__c='Test1';
                ps.Level_3_ID_XAE__c='Test2';
                ps.EffectiveDate__c=Date.ValueOf(System.now().adddays(1));
               
                Test.startTest();
                insert ps; 
                
                ps.Instruction__c='Exclude';
                update ps;
                
                
                delete ps;
                
                Test.StopTest();
            }      
        }
     
        
}