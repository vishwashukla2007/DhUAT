@isTest
private class PlatformSpecificManagementTest{
    @isTest
    public static void PlatformSpecificManagement_Test(){
    User u  = TestDataFactory.createUser('System Administrator');
     User useObjNew = TestDataFactory.createUser('Apttus Sales');
      insert useObjNew;
     useObjNew.ManagerId=Userinfo.getUserId();
     useObjNew.Manager_Level_2__c=Userinfo.getName();
    useObjNew.Manager_Level_3__c=Userinfo.getName();
     useObjNew.Manager_Level_4__c=Userinfo.getName();
     useObjNew.Manager_Level_5__c=Userinfo.getName();
     useObjNew.Manager_Level_6__c=Userinfo.getName();
     useObjNew.Manager_Level_7__c=Userinfo.getName();
                                                        
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
        
        CAG__c cag = new CAG__c();
        cag.CAG_ID__c = '1234567890567CAGTESTC1';
        cag.Record_Type__c='C';
        cag.Status__c='A';
        cag.Non_Validated_CAG__c = true;        
        insert cag;
        
        Rebate_Operations__c createRebOps=TestDataFactory.createRebOps(FAF.Id);
        insert createRebOps;
        createRebOps.Non_Specialty_Formulary_Option__c='Client Choice';
        createRebOps.GSTP_Option__c='Choice';
        createRebOps.Specialty_Formulary_Option__c='Client Choice';
        update createRebOps;
 
        Platform_Specifics__c ps = TestDataFactory.createPlatFormSpecificManagement();
        ps.FAF_Client_Information__c = ClientInformation.Id;
        ps.Rebate_Operations__c=createRebOps.id;
        ps.LOB__c='STD';
        //ps.CAG_ID__c='A'; 
        
        ps.Level_1_Record_ID__c = cag.Id;
        ps.Termed__c = false;
        ps.DifferentGSTPFormularyEffectiveDates__c = false;
        ps.FAF_ID__c = FAF.id; 
        ps.Platform__c ='CATS';
        ps.Instruction__c ='Exclude';
        ps.Level_1_ID_XAE__c ='L1ID';
        ps.DeleteRow__c=true;
        insert ps;
        
Test.startTest();
        
        PlatformSpecificManagement.isNewButtonVisible();
        PlatformSpecificManagement.isEditButtonVisible();
        PlatformSpecificManagement.isDeleteButtonVisible();
        PlatformSpecificManagement.isCagSearchNewButtonVisible();
        PlatformSpecificManagement.aura_getPlatformSpecificData(ClientInformation.Id,null);
        PlatformSpecificManagement.aura_GetClientInfo(ClientInformation.Id);
        PlatformSpecificManagement.GetFAFInfo(ClientInformation.Id);
        PlatformSpecificManagement.getAccessForSalesUser();
        PlatformSpecificManagement.getAccountSubtype(ClientInformation.Id);
        try{
        PlatformSpecificManagement.SavePlaformSpec(ps);
        }catch(Exception e){}
        
        Platform_Specifics__c newPlatformSpecific=TestDataFactory.createPlatFormSpecificManagement();
        newPlatformSpecific.FAF_Client_Information__c = ClientInformation.Id;
        newPlatformSpecific.LOB__c = 'ACT';
        //newPlatformSpecific.CAG_ID__c=cag.id;

        ApexPages.StandardController sc = new ApexPages.StandardController(newPlatformSpecific);
        PlatformSpecificManagement psManagement = new PlatformSpecificManagement(sc);
        psManagement.doAddNew();
        psManagement.doDelete();
        psManagement.doEdit();
        psManagement.doAddNew();
        psManagement.doCancel();
        psManagement.getActivePlatFormSpecifics();
        psManagement.doSave();
        //PlatformSpecificManagement.SavePlaformSpec(newPlatformSpecific);
        
        String psString= JSON.serialize(newPlatformSpecific);
        PlatformSpecificManagement.updatePS(psString);
        PlatformSpecificManagement.aura_doDelete(psString);
        
       // PlatformSpecificManagement.PlatformSpecificData psWrapper = new PlatformSpecificManagement.PlatformSpecificData();
       // psWrapper.isValidSave =false;
       
        ApexPages.StandardController sc1 = new ApexPages.StandardController(newPlatformSpecific);
        PlatformSpecificManagement psManagement1 = new PlatformSpecificManagement(sc1);
        PlatformSpecificManagement.aura_getPlatformSpecificData(ClientInformation.id,null);
        Test.stopTest();
        
    }   
        
    }
    ///
    ////
    //// Added by sonal sharma
    @isTest
    public static void PlatformSpecificManagementAccountOwner_Test(){
    User u  = TestDataFactory.createUser('System Administrator');
     User useObjNew = TestDataFactory.createUser('Apttus Sales');
     insert useObjNew;
     useObjNew.ManagerId=Userinfo.getUserId();
     useObjNew.Manager_Level_2__c=Userinfo.getName();
     update useObjNew;
     
     User useObjNew1 = TestDataFactory.createUser('Apttus Sales');
     insert useObjNew1;
     useObjNew1.ManagerId=Userinfo.getUserId();
     useObjNew1.Manager_Level_2__c=Userinfo.getName();
     useObjNew1.Manager_Level_3__c=Userinfo.getName();
     useObjNew1.Manager_Level_4__c=Userinfo.getName();
     useObjNew1.Manager_Level_5__c=Userinfo.getName();
     useObjNew1.Manager_Level_6__c=Userinfo.getName();
     useObjNew1.Manager_Level_7__c=Userinfo.getName();
     
     update useObjNew1;
        System.runAs(useObjNew){
        
        PermissionSet pss = [SELECT Id FROM PermissionSet WHERE Name ='E_Apttus_Sales'];
        PermissionSetAssignment psa = new PermissionSetAssignment();
        psa.AssigneeId = useObjNew.Id;
        psa.PermissionSetId = pss.Id;
        insert psa;
        
        PermissionSetAssignment psa1 = new PermissionSetAssignment();
        psa1.AssigneeId = useObjNew1.Id;
        psa1.PermissionSetId = pss.Id;
        insert psa1;
        
    
        Account acc = TestDataFactory.createAccount();
        acc.Account_Level__c ='SuperClient';
        acc.iUMS_Client_Subtype__c = 'Health Plan Master';
        insert acc;
        
        Opportunity opp = TestDataFactory.createOpportunity(acc.Id);
        Insert opp;
        acc.OwnerId=useObjNew1.id;
        update acc;
       
        
        Central_Hub__c FAF = TestDataFactory.createFAF(acc.Id,opp.Id,u.Id);
        //FAF.Salesperson__c=Userinfo.getUserId();
        FAF.Salesperson__c=useObjNew1.id;
        Insert FAF;
        
        Client_Information__c ClientInformation = TestDataFactory.createClientInfo(FAF.Id);
        Insert ClientInformation;
       
       CAG__c cag = new CAG__c();
        cag.CAG_ID__c = '1234567890567CAGTESTC1';
        cag.Record_Type__c='C';
        cag.Status__c='A';
        cag.Non_Validated_CAG__c = true;        
        insert cag;
        
        Rebate_Operations__c createRebOps=TestDataFactory.createRebOps(FAF.Id);
        insert createRebOps;
        createRebOps.Non_Specialty_Formulary_Option__c='Client Choice';
        createRebOps.GSTP_Option__c='Choice';
        createRebOps.Specialty_Formulary_Option__c='Client Choice';
        update createRebOps;
 
        Platform_Specifics__c ps = TestDataFactory.createPlatFormSpecificManagement();
        ps.FAF_Client_Information__c = ClientInformation.Id;
        ps.Rebate_Operations__c=createRebOps.id;
        ps.LOB__c='STD';
        ps.Level_1_Record_ID__c = cag.Id;
        ps.Termed__c = false;
        ps.DifferentGSTPFormularyEffectiveDates__c = false;
        ps.FAF_ID__c = FAF.id; 
        ps.Platform__c ='CATS';
        ps.Instruction__c ='Exclude';
        ps.Level_1_ID_XAE__c ='L1ID';
        ps.DeleteRow__c=true;
        insert ps;

        Test.startTest();
        
        PlatformSpecificManagement.isNewButtonVisible();
        PlatformSpecificManagement.isEditButtonVisible();
        PlatformSpecificManagement.isDeleteButtonVisible();
        PlatformSpecificManagement.isCagSearchNewButtonVisible();
        PlatformSpecificManagement.aura_getPlatformSpecificData(ClientInformation.Id,null);
        PlatformSpecificManagement.aura_GetClientInfo(ClientInformation.Id);
        PlatformSpecificManagement.GetFAFInfo(ClientInformation.Id);
        PlatformSpecificManagement.getAccessForSalesUser();
        PlatformSpecificManagement.getAccountSubtype(ClientInformation.Id);
        
        Platform_Specifics__c newPlatformSpecific=TestDataFactory.createPlatFormSpecificManagement();
        newPlatformSpecific.FAF_Client_Information__c = ClientInformation.Id;
        newPlatformSpecific.LOB__c = 'ACT';

        ApexPages.StandardController sc = new ApexPages.StandardController(newPlatformSpecific);
        PlatformSpecificManagement psManagement = new PlatformSpecificManagement(sc);
        psManagement.doAddNew();
        psManagement.doDelete();
        psManagement.doEdit();
        psManagement.doAddNew();
        psManagement.doCancel();
        psManagement.getActivePlatFormSpecifics();
        psManagement.doSave();

        //PlatformSpecificManagement.SavePlaformSpec(newPlatformSpecific);
        
        String psString= JSON.serialize(newPlatformSpecific);
        PlatformSpecificManagement.updatePS(psString);
        PlatformSpecificManagement.aura_doDelete(psString);
        
       // PlatformSpecificManagement.PlatformSpecificData psWrapper = new PlatformSpecificManagement.PlatformSpecificData();
       // psWrapper.isValidSave =false;
       
        ApexPages.StandardController sc1 = new ApexPages.StandardController(newPlatformSpecific);
        PlatformSpecificManagement psManagement1 = new PlatformSpecificManagement(sc1);
        PlatformSpecificManagement.aura_getPlatformSpecificData(ClientInformation.id,null);
        Test.stopTest();
        
    }   
        
    }
    
    //// Added by sonal sharma
    @isTest
    public static void PlatformSpecificManagementAccountOwner_Test2(){
    User u  = TestDataFactory.createUser('System Administrator');
     User useObjNew = TestDataFactory.createUser('Apttus Sales');
     insert useObjNew;
     useObjNew.ManagerId=Userinfo.getUserId();
     useObjNew.Manager_Level_2__c=Userinfo.getName();
     useObjNew.Manager_Level_3__c=Userinfo.getName();
     useObjNew.Manager_Level_4__c=Userinfo.getName();
     useObjNew.Manager_Level_5__c=Userinfo.getName();
     useObjNew.Manager_Level_6__c=Userinfo.getName();
     useObjNew.Manager_Level_7__c=Userinfo.getName();
     update useObjNew;
     
     User useObjNew1 = TestDataFactory.createUser('Apttus Sales');
     insert useObjNew1;
     useObjNew1.ManagerId=Userinfo.getUserId();
     useObjNew1.Manager_Level_2__c=Userinfo.getName();
     update useObjNew1;
        System.runAs(useObjNew){
        
        PermissionSet pss = [SELECT Id FROM PermissionSet WHERE Name ='E_Apttus_Sales'];
        PermissionSetAssignment psa = new PermissionSetAssignment();
        psa.AssigneeId = useObjNew.Id;
        psa.PermissionSetId = pss.Id;
        insert psa;
        
        PermissionSetAssignment psa1 = new PermissionSetAssignment();
        psa1.AssigneeId = useObjNew1.Id;
        psa1.PermissionSetId = pss.Id;
        insert psa1;
        
    
        Account acc = TestDataFactory.createAccount();
        acc.Account_Level__c ='SuperClient';
        acc.iUMS_Client_Subtype__c = 'Health Plan Master';
        insert acc;
        
        Opportunity opp = TestDataFactory.createOpportunity(acc.Id);
        Insert opp;
        acc.OwnerId=useObjNew1.id;
        update acc;
       
        
        Central_Hub__c FAF = TestDataFactory.createFAF(acc.Id,opp.Id,u.Id);
        FAF.Salesperson__c=Userinfo.getUserId();
        //FAF.Salesperson__c=useObjNew1.id;
        Insert FAF;
        
        Client_Information__c ClientInformation = TestDataFactory.createClientInfo(FAF.Id);
        Insert ClientInformation;
       
       CAG__c cag = new CAG__c();
        cag.CAG_ID__c = '1234567890567CAGTESTC1';
        cag.Record_Type__c='C';
        cag.Status__c='A';
        cag.Non_Validated_CAG__c = true;        
        insert cag;
        
        Rebate_Operations__c createRebOps=TestDataFactory.createRebOps(FAF.Id);
        insert createRebOps;
        createRebOps.Non_Specialty_Formulary_Option__c='Client Choice';
        createRebOps.GSTP_Option__c='Choice';
        createRebOps.Specialty_Formulary_Option__c='Client Choice';
        update createRebOps;
 
        Platform_Specifics__c ps = TestDataFactory.createPlatFormSpecificManagement();
        ps.FAF_Client_Information__c = ClientInformation.Id;
        ps.Rebate_Operations__c=createRebOps.id;
        ps.LOB__c='STD';
        ps.Level_1_Record_ID__c = cag.Id;
        ps.Termed__c = false;
        ps.DifferentGSTPFormularyEffectiveDates__c = false;
        ps.FAF_ID__c = FAF.id; 
        ps.Platform__c ='CATS';
        ps.Instruction__c ='Exclude';
        ps.Level_1_ID_XAE__c ='L1ID';
        ps.DeleteRow__c=true;
        insert ps;

        Test.startTest();
        
        PlatformSpecificManagement.isNewButtonVisible();
        PlatformSpecificManagement.isEditButtonVisible();
        PlatformSpecificManagement.isDeleteButtonVisible();
        PlatformSpecificManagement.isCagSearchNewButtonVisible();
        PlatformSpecificManagement.aura_getPlatformSpecificData(ClientInformation.Id,null);
        PlatformSpecificManagement.aura_GetClientInfo(ClientInformation.Id);
        PlatformSpecificManagement.GetFAFInfo(ClientInformation.Id);
        PlatformSpecificManagement.getAccessForSalesUser();
        PlatformSpecificManagement.getAccountSubtype(ClientInformation.Id);
        
        Platform_Specifics__c newPlatformSpecific=TestDataFactory.createPlatFormSpecificManagement();
        newPlatformSpecific.FAF_Client_Information__c = ClientInformation.Id;
        newPlatformSpecific.LOB__c = 'ACT';

        ApexPages.StandardController sc = new ApexPages.StandardController(newPlatformSpecific);
        PlatformSpecificManagement psManagement = new PlatformSpecificManagement(sc);
        psManagement.doAddNew();
        psManagement.doDelete();
        psManagement.doEdit();
        psManagement.doAddNew();
        psManagement.doCancel();
        psManagement.getActivePlatFormSpecifics();
        psManagement.doSave();
     //   PlatformSpecificManagement.SavePlaformSpec(newPlatformSpecific);
        
        String psString= JSON.serialize(newPlatformSpecific);
        PlatformSpecificManagement.updatePS(psString);
        PlatformSpecificManagement.aura_doDelete(psString);
        
       // PlatformSpecificManagement.PlatformSpecificData psWrapper = new PlatformSpecificManagement.PlatformSpecificData();
       // psWrapper.isValidSave =false;
       
        ApexPages.StandardController sc1 = new ApexPages.StandardController(newPlatformSpecific);
        PlatformSpecificManagement psManagement1 = new PlatformSpecificManagement(sc1);
        PlatformSpecificManagement.aura_getPlatformSpecificData(ClientInformation.id,null);
        Test.stopTest();
        
    }   
        
    }
    
      @isTest
    public static void PlatformSpecificManagement_Test_N(){ 
    /*User us  = TestDataFactory.createUser('System Administrator');
        insert us;*/
       //System.runAs(us){
        Account acc = TestDataFactory.createAccount();
        acc.Account_Level__c ='SuperClient';
        acc.iUMS_Client_Subtype__c = 'Health Plan Master';
        insert acc;
        
        Opportunity opp = TestDataFactory.createOpportunity(acc.Id);
        Insert opp;
        
        User u  = TestDataFactory.createUser('Apttus Sales');
        //Insert u;
                
        
        Central_Hub__c FAF = TestDataFactory.createFAF(acc.Id,opp.Id,u.id);
        Insert FAF;
        
        Client_Information__c ClientInformation = TestDataFactory.createClientInfo(FAF.Id);
        Insert ClientInformation;
        
        CAG__c cag = new CAG__c();
        cag.CAG_ID__c = '1234567890567CAGTESTC1';
        cag.Record_Type__c='C';
        cag.Status__c='A';
        cag.Non_Validated_CAG__c = true;        
        insert cag;
        
        Rebate_Operations__c createRebOps=TestDataFactory.createRebOps(FAF.Id);
        insert createRebOps;
        createRebOps.Non_Specialty_Formulary_Option__c='EGWP Gold';
        createRebOps.GSTP_Option__c='Custom';
        createRebOps.Specialty_Formulary_Option__c='Custom Formulary';
        update createRebOps;
 
        Platform_Specifics__c ps = TestDataFactory.createPlatFormSpecificManagement();
        ps.FAF_Client_Information__c = ClientInformation.Id;
        ps.Rebate_Operations__c=createRebOps.id;
        ps.Level_1_Record_ID__c = cag.Id;
        ps.Termed__c = false;
        ps.DifferentGSTPFormularyEffectiveDates__c = false;
        ps.FAF_ID__c = FAF.id; 
        ps.Platform__c ='CATS';
        ps.Instruction__c ='Exclude';
        ps.LOB__c = 'ACT';
        ps.DeleteRow__c=true;
        ps.Level_1_ID_XAE__c ='L1ID';
        insert ps;
        
        
        Test.startTest();
        
        PlatformSpecificManagement.isNewButtonVisible();
        PlatformSpecificManagement.isEditButtonVisible();
        PlatformSpecificManagement.isDeleteButtonVisible();
        PlatformSpecificManagement.isCagSearchNewButtonVisible();
        PlatformSpecificManagement.aura_getPlatformSpecificData(ClientInformation.Id,null);
        PlatformSpecificManagement.aura_GetClientInfo(ClientInformation.Id);
        PlatformSpecificManagement.GetFAFInfo(ClientInformation.Id);
        PlatformSpecificManagement.getAccessForSalesUser();
        PlatformSpecificManagement.getAccountSubtype(ClientInformation.Id);
        
        Platform_Specifics__c newPlatformSpecific=TestDataFactory.createPlatFormSpecificManagement();
        newPlatformSpecific.FAF_Client_Information__c = ClientInformation.Id;
        newPlatformSpecific.LOB__c = 'ACT';

        ApexPages.StandardController sc = new ApexPages.StandardController(newPlatformSpecific);
        PlatformSpecificManagement psManagement = new PlatformSpecificManagement(sc);
        psManagement.doAddNew();
        psManagement.doDelete();
        psManagement.doEdit();
        psManagement.doAddNew();
        psManagement.doCancel();
        psManagement.getActivePlatFormSpecifics();
        psManagement.doSave();
     //   PlatformSpecificManagement.SavePlaformSpec(newPlatformSpecific);
        
        String psString= JSON.serialize(newPlatformSpecific);
        PlatformSpecificManagement.updatePS(psString);
        PlatformSpecificManagement.aura_doDelete(psString);
        
       // PlatformSpecificManagement.PlatformSpecificData psWrapper = new PlatformSpecificManagement.PlatformSpecificData();
       // psWrapper.isValidSave =false;
       
        ApexPages.StandardController sc1 = new ApexPages.StandardController(newPlatformSpecific);
        PlatformSpecificManagement psManagement1 = new PlatformSpecificManagement(sc1);
        PlatformSpecificManagement.aura_getPlatformSpecificData(ClientInformation.id,null);
        Test.stopTest();
        
     //}   
        
    }
    
    
    @isTest
    public static void PlatformSpecificManagement_Test1(){
        Account acc = TestDataFactory.createAccount();
        acc.Account_Level__c ='SuperClient';
        insert acc;
        
        Opportunity opp = TestDataFactory.createOpportunity(acc.Id);
        Insert opp;
        
        User u  = TestDataFactory.createUser('System Administrator');
        //Insert u;
        
        CAG__c cag = new CAG__c();
        cag.Record_Type__c = 'c';
        cag.CAG_ID__c = '657657';
        insert cag;
        
        Central_Hub__c FAF = TestDataFactory.createFAF(acc.Id,opp.Id, u.Id);
        Insert FAF;
        Client_Information__c ClientInformation = TestDataFactory.createClientInfo(FAF.Id);
        ClientInformation.Pricing_Effective_Date__c = null;
        Insert ClientInformation;
        
        
        Rebate_Operations__c createRebOps=TestDataFactory.createRebOps(FAF.Id);
        insert createRebOps;
        createRebOps.Non_Specialty_Formulary_Option__c='EGWP Gold';
        update createRebOps;
        
        Platform_Specifics__c ps = TestDataFactory.createPlatFormSpecificManagement();
        ps.FAF_Client_Information__c = ClientInformation.Id;
        ps.Level_1_Record_ID__c = cag.id; 
        ps.Rebate_Operations__c = createRebOps.id;
        ps.LOB__c = 'ACT';
     //   insert ps;

        Test.startTest();
        
        PlatformSpecificManagement.isNewButtonVisible();
        PlatformSpecificManagement.isEditButtonVisible();
        PlatformSpecificManagement.isDeleteButtonVisible();
        PlatformSpecificManagement.isCagSearchNewButtonVisible();
        PlatformSpecificManagement.aura_getPlatformSpecificData(ClientInformation.Id,null);
        PlatformSpecificManagement.aura_GetClientInfo(ClientInformation.Id);
        PlatformSpecificManagement.GetFAFInfo(ClientInformation.Id);
        PlatformSpecificManagement.getAccessForSalesUser();
        PlatformSpecificManagement.getAccountSubtype(ClientInformation.Id);
        
        Platform_Specifics__c newPlatformSpecific=TestDataFactory.createPlatFormSpecificManagement();
        newPlatformSpecific.FAF_Client_Information__c = ClientInformation.Id;
        newPlatformSpecific.LOB__c = 'ACT';

        ApexPages.StandardController sc = new ApexPages.StandardController(newPlatformSpecific);
        PlatformSpecificManagement psManagement = new PlatformSpecificManagement(sc);
        psManagement.doAddNew();
        
        
        psManagement.platformSpecifics.get(0).isSelected = true; //make pItem for delete
        psManagement.doDelete();
        psManagement.doEdit();
        psManagement.doAddNew();
        psManagement.doCancel();
        psManagement.getActivePlatFormSpecifics();
        psManagement.doSave();
     //   PlatformSpecificManagement.SavePlaformSpec(newPlatformSpecific);
        
        String psString= JSON.serialize(newPlatformSpecific);
        PlatformSpecificManagement.updatePS(psString);
        PlatformSpecificManagement.aura_doDelete(psString);
        
       // PlatformSpecificManagement.PlatformSpecificData psWrapper = new PlatformSpecificManagement.PlatformSpecificData();
       // psWrapper.isValidSave =false;
       
        ApexPages.StandardController sc1 = new ApexPages.StandardController(newPlatformSpecific);
        PlatformSpecificManagement psManagement1 = new PlatformSpecificManagement(sc1);
        PlatformSpecificManagement.aura_getPlatformSpecificData(ClientInformation.id,null);
        Test.stopTest();
    }
    
    
    @isTest
    public static void PlatformSpecificManagement_Test2(){
        Account acc = TestDataFactory.createAccount();
        acc.Account_Level__c ='SuperClient';
        acc.iUMS_Client_Subtype__c = 'Health Plan Master';
        insert acc;
        
        Opportunity opp = TestDataFactory.createOpportunity(acc.Id);
        Insert opp;
        
        User u  = TestDataFactory.createUser('System Administrator');
        //Insert u;
        
        CAG__c cag = new CAG__c();
        cag.Record_Type__c = 'c';
        cag.CAG_ID__c = '657657';
        insert cag;
        
        Central_Hub__c FAF = TestDataFactory.createFAF(acc.Id,opp.Id, u.Id);
        Insert FAF;
        Client_Information__c ClientInformation = TestDataFactory.createClientInfo(FAF.Id);
        
        date firstDate = system.today().toStartOfMonth();
        ClientInformation.Pricing_Effective_Date__c = firstDate ;
        Insert ClientInformation;
                
        Rebate_Operations__c rebOpsObj = TestDataFactory.createRebOps(FAF.id);
        rebOpsObj.Non_Specialty_Formulary_Option__c = 'Client Choice';
        rebOpsObj.GSTP_Option__c = 'Choice';
        rebOpsObj.Specialty_Formulary_Option__c = 'Client Choice';
        insert rebOpsObj;
        
        Platform_Specifics__c ps = TestDataFactory.createPlatFormSpecificManagement();
        ps.FAF_Client_Information__c = ClientInformation.Id;
       // ps.Level_1_Record_ID__c = cag.id; 
        ps.Rebate_Operations__c = rebOpsObj.id;
   //     insert ps;

        Test.startTest();
        
        PlatformSpecificManagement.isNewButtonVisible();
        PlatformSpecificManagement.isEditButtonVisible();
        PlatformSpecificManagement.isDeleteButtonVisible();
        PlatformSpecificManagement.isCagSearchNewButtonVisible();
        PlatformSpecificManagement.aura_getPlatformSpecificData(ClientInformation.Id,null);
        PlatformSpecificManagement.aura_GetClientInfo(ClientInformation.Id);
        PlatformSpecificManagement.GetFAFInfo(ClientInformation.Id);
        PlatformSpecificManagement.getAccessForSalesUser();
        PlatformSpecificManagement.getAccountSubtype(ClientInformation.Id);
        
        Platform_Specifics__c newPlatformSpecific=TestDataFactory.createPlatFormSpecificManagement();
        newPlatformSpecific.FAF_Client_Information__c = ClientInformation.Id;
        //newPlatformSpecific.LOB__c = 'ACT';
        
        ApexPages.StandardController sc = new ApexPages.StandardController(newPlatformSpecific);
        PlatformSpecificManagement psManagement = new PlatformSpecificManagement(sc);
        psManagement.doAddNew();
        psManagement.doDelete();
        psManagement.doEdit();
        psManagement.doAddNew();
        psManagement.doCancel();
        psManagement.getActivePlatFormSpecifics();
        psManagement.doSave();
        PlatformSpecificManagement.SavePlaformSpec(newPlatformSpecific);
        
        String psString= JSON.serialize(newPlatformSpecific);
        PlatformSpecificManagement.updatePS(psString);
        PlatformSpecificManagement.aura_doDelete(psString);
        
       // PlatformSpecificManagement.PlatformSpecificData psWrapper = new PlatformSpecificManagement.PlatformSpecificData();
       // psWrapper.isValidSave =false;
       
        ApexPages.StandardController sc1 = new ApexPages.StandardController(newPlatformSpecific);
        PlatformSpecificManagement psManagement1 = new PlatformSpecificManagement(sc1);
        PlatformSpecificManagement.aura_getPlatformSpecificData(ClientInformation.id,null);
        Test.stopTest();        
    }
    
    
    @isTest
    public static void PlatformSpecificManagement_Test4(){
        Account acc = TestDataFactory.createAccount();
        acc.Account_Level__c ='SuperClient';
        insert acc;
        
        Opportunity opp = TestDataFactory.createOpportunity(acc.Id);
        Insert opp;
        
        User u  = TestDataFactory.createUser('System Administrator');
        //Insert u;
        
        CAG__c cag = new CAG__c();
        cag.Record_Type__c = 'C';
        cag.CAG_ID__c = '657657';
        insert cag;
        CAG__c cag1 = new CAG__c();
        cag1.Record_Type__c = 'A';
        cag1.CAG_ID__c = '6576578';
        insert cag1;
        CAG__c cag2 = new CAG__c();
        cag2.Record_Type__c = 'G';
        cag2.CAG_ID__c = '6576579';
        insert cag2;

        Central_Hub__c FAF = TestDataFactory.createFAF(acc.Id,opp.Id, u.Id);
        Insert FAF;
        Client_Information__c ClientInformation = TestDataFactory.createClientInfo(FAF.Id);
        ClientInformation.Pricing_Effective_Date__c = null;
        Insert ClientInformation;
        
        Rebate_Operations__c rebOpsObj = TestDataFactory.createRebOps(FAF.id);
        insert rebOpsObj;
        
        list<Platform_Specifics__c> pslist=new list<Platform_Specifics__c>();
        Platform_Specifics__c ps = TestDataFactory.createPlatFormSpecificManagement();
        ps.FAF_Client_Information__c = ClientInformation.Id;
        ps.Level_1_Record_ID__c = cag.id; 
        ps.Rebate_Operations__c = rebOpsObj.id; 
               
        Platform_Specifics__c ps3 = TestDataFactory.createPlatFormSpecificManagement();
        ps3.FAF_Client_Information__c = ClientInformation.Id;
        ps3.Level_1_Record_ID__c = cag.id;
        ps3.Level_2_Record_ID__c =  cag1.id;       
        ps3.Rebate_Operations__c = rebOpsObj.id; 
              
        Platform_Specifics__c ps2 = TestDataFactory.createPlatFormSpecificManagement();
        ps2.FAF_Client_Information__c = ClientInformation.Id;
        ps2.Level_1_Record_ID__c = cag.id; 
        ps2.Level_2_Record_ID__c =  cag1.id;
        ps2.Level_3_Record_ID__c =  cag2.id;               
        ps2.Rebate_Operations__c = rebOpsObj.id;
        
        pslist.add(ps);
        pslist.add(ps3);
        pslist.add(ps2);
        
     //   insert ps;
       // insert ps3;
      //  insert ps2;

        Test.startTest();
                
        PageReference pageRef = Page.PlatformSpecificManagement;//Observe how we set the Page here
        Test.setCurrentPage(pageRef);//Applying page context here
        ApexPages.currentPage().getParameters().put('ClientInfoId',ClientInformation.Id);
        
        ApexPages.StandardController sc = new ApexPages.StandardController(ps);
        PlatformSpecificManagement psManagement = new PlatformSpecificManagement(sc);
        psManagement.getActivePlatFormSpecifics();

        Platform_Specifics__c ps1 = new Platform_Specifics__c();//TestDataFactory.createPlatFormSpecificManagement();
        PlatformSpecificManagement.SavePlaformSpec(ps1);
        Test.stopTest();
    }
    
     @isTest
    public static void PlatformSpecificManagement_UpdatePS(){
        Account acc = TestDataFactory.createAccount();
        acc.Account_Level__c ='SuperClient';
        acc.iUMS_Client_Subtype__c = 'Health Plan Master';
        insert acc;
        
        Opportunity opp = TestDataFactory.createOpportunity(acc.Id);
        Insert opp;
        
        User u  = TestDataFactory.createUser('System Administrator');
        //Insert u;
        
        CAG__c cag = new CAG__c();
    //    cag.Record_Type__c = 'c';
        cag.CAG_ID__c = '657657';
        insert cag;
        
        Central_Hub__c FAF = TestDataFactory.createFAF(acc.Id,opp.Id, u.Id);
        Insert FAF;
        Client_Information__c ClientInformation = TestDataFactory.createClientInfo(FAF.Id);
        
        date firstDate = system.today().toStartOfMonth();
        ClientInformation.Pricing_Effective_Date__c = firstDate ;
        Insert ClientInformation;
                
        Rebate_Operations__c rebOpsObj = TestDataFactory.createRebOps(FAF.id);
        rebOpsObj.Non_Specialty_Formulary_Option__c = 'Client Choice';
        rebOpsObj.GSTP_Option__c = 'Choice';
        rebOpsObj.Specialty_Formulary_Option__c = 'Client Choice';
        insert rebOpsObj;
        
        Platform_Specifics__c ps = TestDataFactory.createPlatFormSpecificManagement();
        ps.FAF_Client_Information__c = ClientInformation.Id;
       // ps.Level_1_Record_ID__c = cag.id; 
        ps.Rebate_Operations__c = rebOpsObj.id;
     //   insert ps;

        Test.startTest();
                
        String psString= PlatformSpecificManagement.aura_getPlatformSpecificData(ClientInformation.Id,null);
        PlatformSpecificManagement.updatePS(psString);
        PlatformSpecificManagement.PlatformSpecificData data = (PlatformSpecificManagement.PlatformSpecificData)JSON.deserialize(psString, PlatformSpecificManagement.PlatformSpecificData.class);
    //    data.platformSpecifics.get(0).isSelected = true; // make selection for already saved delete process
        
        data.platformSpecifics.add(data.newPlatFormSpecificItem);
        data.platformSpecifics.add(data.newPlatFormSpecificItem);
        
        
        PlatformSpecificManagement.aura_doDelete(JSON.Serialize(data));
        Test.stopTest();        
    }
    
}