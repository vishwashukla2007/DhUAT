@isTest
public class EditPlatFormSpecificControllerTest1 {

    private static CAG__c createCAG2(){
            
        CAG__c cag = new CAG__c();
        cag.CAG_ID__c = '1234567890567CAGTEST';
        cag.Record_Type__c='A';
        cag.Status__c='A';
        cag.Non_Validated_CAG__c = true;
        
        insert cag;
        cag = [Select Id, Name, CAG_ID__c ,Record_Type__c, Status__c, Non_Validated_Cag__c from CAG__c where id=:cag.id ];
        return cag;
    }
      private static CAG__c createCAG(){
            
        CAG__c cag = new CAG__c();
        cag.CAG_ID__c = '1234567890567CAGTESTC1';
        cag.Record_Type__c='C';
        cag.Status__c='A';
        cag.Non_Validated_CAG__c = true;
        
        insert cag;
        cag = [Select Id, Name, CAG_ID__c ,Record_Type__c, Status__c, Non_Validated_Cag__c from CAG__c where id=:cag.id ];
        return cag;
    }
       private static CAG__c createCAG3(){
            
        CAG__c cag = new CAG__c();
        cag.CAG_ID__c = '1234567890567CAGGROUP';
        cag.Record_Type__c='G';
        cag.Status__c='A';
        cag.Non_Validated_CAG__c = true;
        
        insert cag;
        cag = [Select Id, Name, CAG_ID__c ,Record_Type__c, Status__c, Non_Validated_Cag__c from CAG__c where id=:cag.id ];
        return cag;
    }
     private static CAG__c createCAG12(){
            
        CAG__c cag = new CAG__c();
        cag.CAG_ID__c = '1234567890567CAGTESTA1';
        cag.Record_Type__c='A';
        cag.Status__c='A';
        cag.Non_Validated_CAG__c = true;
        
        insert cag;
        cag = [Select Id, Name, CAG_ID__c ,Record_Type__c, Status__c, Non_Validated_Cag__c from CAG__c where id=:cag.id ];
        return cag;
    }
      private static CAG__c createCAG11(){
            
        CAG__c cag = new CAG__c();
        cag.CAG_ID__c = '1234567890567CAGTESTC1';
        cag.Record_Type__c='C';
        cag.Status__c='A';
        cag.Non_Validated_CAG__c = true;
        
        insert cag;
        cag = [Select Id, Name, CAG_ID__c ,Record_Type__c, Status__c, Non_Validated_Cag__c from CAG__c where id=:cag.id ];
        return cag;
    }
       private static CAG__c createCAG13(){
            
        CAG__c cag = new CAG__c();
        cag.CAG_ID__c = '1234567890567CAGGROUPG1';
        cag.Record_Type__c='G';
        cag.Status__c='A';
        
        
        cag.Non_Validated_CAG__c = true;
        
        insert cag;
        cag = [Select Id, Name, CAG_ID__c ,Record_Type__c, Status__c, Non_Validated_Cag__c from CAG__c where id=:cag.id ];
        return cag;
    }
    private static Platform_Specifics__c createPlatformSpecific(){
    
         Account acc = TestDataFactory.createAccount();
        acc.Account_Level__c ='SuperClient';
        acc.iUMS_Client_Subtype__c = 'Health Plan Master';
        insert acc;
        
        Opportunity opp = TestDataFactory.createOpportunity(acc.Id);
        Insert opp;
        
        User u  = TestDataFactory.createUser('System Administrator');
        //Insert u;
        
        
        
        Central_Hub__c FAF = TestDataFactory.createFAF(acc.Id,opp.Id, u.Id);
        Insert FAF;

        CAG__c cag = new CAG__c();
        cag.CAG_ID__c = 'CAG1234567890789TEST';
        cag.Record_Type__c='A';
        cag.Status__c='A';
        
        insert cag;
        
        Client_Information__c csInfo = new Client_Information__c();
        csInfo.FAF_ID__c = faf.Id;
        date firstDate = system.today().toStartOfMonth();
        csInfo.Pricing_Effective_Date__c = firstDate ;
        insert csInfo;
        Date dt =System.today();
        String dtformat=dt.format();
        
        
        
        Platform_Specifics__c platForm = new Platform_Specifics__c();
        platForm.FAF_Client_Information__c =  csInfo.Id;
        platForm.Level_1_Record_ID__c = cag.Id;
        platForm.Termed__c = false;
        platForm.DifferentGSTPFormularyEffectiveDates__c = false;
      //  platForm.EffectiveDate__c = dt;
        //platForm.Rebate_Operations__c = rebOpsObj.id;
        platForm.FAF_ID__c = faf.id; 
      //  insert platForm;
        return platForm;
    }
    @isTest
    public static void retrieveTeamMembersTest(){
        Platform_Specifics__c ps = createPlatformSpecific();
        System.currentPageReference().getParameters().put('retURL', 'retURL');
        System.currentPageReference().getParameters().put('cInfoId', ps.FAF_Client_Information__c);
        
        ApexPages.StandardController sc = new ApexPages.StandardController(ps);
        EditPlatFormSpecificController editplatFrom = new EditPlatFormSpecificController(sc);
        
        editplatFrom.recordId =null;
        editplatFrom.loadRecord();
        editplatFrom.doCancel();
        //editplatFrom.platformSpecific =ps;
        editplatFrom.onchangePlatform();
        Date dt =System.today();
        
        String dtformat=dt.format();
        
        Date gstpdt =System.today().adddays(-1);
        String gstpdtformat=gstpdt .format();
        
        Date sftpdt =System.today().adddays(-1);
        String sftpdtformat=sftpdt.format();
        
        Date nfstpdt =System.today().adddays(-1);
        String nfstpdtformat=nfstpdt.format();
        
        //String dateString=String.valueOf(dtformat.addDays(15));
        System.currentPageReference().getParameters().put('gstpEffectiveDate3', gstpdtformat);
        System.currentPageReference().getParameters().put('effetiveDate3', dtformat);
        editplatFrom.gstpEffectiveDateCheck();
        
        System.currentPageReference().getParameters().put('nsfEffectiveDate2', nfstpdtformat);
        System.currentPageReference().getParameters().put('effetiveDate2', dtformat);
        editplatFrom.nsfEffectiveDateCheck();
        
        System.currentPageReference().getParameters().put('sfEffectiveDate1', sftpdtformat);
        System.currentPageReference().getParameters().put('effetiveDate1', dtformat);
        editplatFrom.sfEffectiveDateCheck();
        
        System.currentPageReference().getParameters().put('gstpEffectiveDate', dtformat);
        System.currentPageReference().getParameters().put('gstpEndDate', gstpdtformat);
        editplatFrom.gstpEndDateCheck();
        
        System.currentPageReference().getParameters().put('nsfEffectiveDate', dtformat);
        System.currentPageReference().getParameters().put('nsfEndDate', nfstpdtformat);
        editplatFrom.nsfEndDateCheck();
        
        System.currentPageReference().getParameters().put('sfEffectiveDate', dtformat);
        System.currentPageReference().getParameters().put('sfEndDate', gstpdtformat);
        editplatFrom.sfEndDateCheck();
        
        System.currentPageReference().getParameters().put('gstpFormularyFlag', 'True');
        editplatFrom.gstpFormularyDatesCheck();
        System.currentPageReference().getParameters().put('gstpFormularyFlag', 'false');
        editplatFrom.gstpFormularyDatesCheck();
        
        System.currentPageReference().getParameters().put('terminateDate', dtformat);
        editplatFrom.checkTerminateDate();
        
        System.currentPageReference().getParameters().put('termFlag', 'True');
        editplatFrom.terminatedDateCheck();
        System.currentPageReference().getParameters().put('termFlag', 'false');
        editplatFrom.terminatedDateCheck();
        
        System.currentPageReference().getParameters().put('effectiveDate', dtformat);
        editplatFrom.checkEffectiveDate();

        editplatFrom.checkLevel3();
        System.currentPageReference().getParameters().put('level3ID', createCAG3().Name);
        editplatFrom.checkLevel3();
        
        editplatFrom.checkLevel2();
        System.currentPageReference().getParameters().put('level2ID', createCAG2().Name);
        editplatFrom.checkLevel2();

        editplatFrom.checkLevel1();
        System.currentPageReference().getParameters().put('level1ID', createCAG().Name);
        editplatFrom.checkLevel1();
        
        editplatFrom.doSave();
    }
    
    @isTest
    public static void retrieveTeamMembersTest1(){
        Platform_Specifics__c ps = createPlatformSpecific();
        ps.DifferentGSTPFormularyEffectiveDates__c= true;
        ps.EffectiveDate__c = null;
        
       
        Rebate_Operations__c rebOpsObj = TestDataFactory.createRebOps(ps.FAF_ID__c);
        rebOpsObj.Non_Specialty_Formulary_Option__c = 'Comm Standard Control';
        rebOpsObj.GSTP_Option__c = 'Choice';
        rebOpsObj.Specialty_Formulary_Option__c = 'Comm Standard Control';
        insert rebOpsObj;
        
        Rebate_Guarantees__c rebateGuarantees = TestDataFactory.createRebateGuarantee(ps.FAF_ID__c,rebOpsObj.id);
            rebateGuarantees.Non_Specialty_Formulary_2__c = 'Comm Standard Control';
            rebateGuarantees.GSTP__c = 'Value Formulary Incentivized';
            rebateGuarantees.Specialty_Formulary__c = 'Value Formulary Incentivized';
            
            insert rebateGuarantees;
       
        Specialty_Operations__c specOpsObj = TestDataFactory.createSpeciality(ps.FAF_ID__c);
            specOpsObj.Pharmacy_Benefit__c ='Open';
            insert specOpsObj;
        ps.Specialty_Operations__c = specOpsObj.id;
        
         List<Specialty_Pricing__c> specPricingList = new List<Specialty_Pricing__c>();
            Specialty_Pricing__c specPricingObj = TestDataFactory.createspecPricingObject(ps.FAF_ID__c,specOpsObj.id);
            //insert specPricingObj;
            Specialty_Pricing__c specPricingObj1 = TestDataFactory.createspecPricingObject(ps.FAF_ID__c,specOpsObj.id);
            specPricingObj1.Year__c = '2';
            specPricingObj1.LOB__c = 'ACT';
            specPricingList.add(specPricingObj);
            specPricingList.add(specPricingObj1);
            
          
            insert specPricingList;
       
        ps.Rebate_Operations__c = rebOpsObj.id;
        // ps.Specialty_Operations__c = specOpsObj.id;
          ps.Rebate_Operations__c = rebOpsObj.id;
       Test.startTest();
        System.currentPageReference().getParameters().put('cInfoId', ps.FAF_Client_Information__c);
        
        ApexPages.StandardController sc = new ApexPages.StandardController(ps);
        EditPlatFormSpecificController editplatFrom = new EditPlatFormSpecificController(sc);
        
        editplatFrom.recordId =null;
        editplatFrom.loadRecord();
        editplatFrom.doCancel();
        //editplatFrom.platformSpecific =ps;
        editplatFrom.onchangePlatform();
        Date dt =System.today();
        String dtformat=dt.format();
        //String dateString=String.valueOf(dtformat.addDays(15));
        System.currentPageReference().getParameters().put('gstpEffectiveDate3', dtformat);
        System.currentPageReference().getParameters().put('effetiveDate3', dtformat);
        editplatFrom.gstpEffectiveDateCheck();
        
        System.currentPageReference().getParameters().put('nsfEffectiveDate2', dtformat);
        System.currentPageReference().getParameters().put('effetiveDate2', dtformat);
        editplatFrom.nsfEffectiveDateCheck();
        
        System.currentPageReference().getParameters().put('sfEffectiveDate1', dtformat);
        System.currentPageReference().getParameters().put('effetiveDate1', dtformat);
        editplatFrom.sfEffectiveDateCheck();
        
        System.currentPageReference().getParameters().put('gstpEffectiveDate', dtformat);
        System.currentPageReference().getParameters().put('gstpEndDate', dtformat);
        editplatFrom.gstpEndDateCheck();
        
        System.currentPageReference().getParameters().put('nsfEffectiveDate', dtformat);
        System.currentPageReference().getParameters().put('nsfEndDate', dtformat);
        editplatFrom.nsfEndDateCheck();
        
        System.currentPageReference().getParameters().put('sfEffectiveDate', dtformat);
        System.currentPageReference().getParameters().put('sfEndDate', dtformat);
        editplatFrom.sfEndDateCheck();
        
        System.currentPageReference().getParameters().put('gstpFormularyFlag', 'True');
        editplatFrom.gstpFormularyDatesCheck();
        System.currentPageReference().getParameters().put('gstpFormularyFlag', 'false');
        editplatFrom.gstpFormularyDatesCheck();
        
        System.currentPageReference().getParameters().put('terminateDate', dtformat);
        editplatFrom.checkTerminateDate();
        
        System.currentPageReference().getParameters().put('termFlag', 'True');
        editplatFrom.terminatedDateCheck();
        System.currentPageReference().getParameters().put('termFlag', 'false');
        editplatFrom.terminatedDateCheck();
        
        System.currentPageReference().getParameters().put('effectiveDate', dtformat);
        editplatFrom.checkEffectiveDate();
        
        System.currentPageReference().getParameters().put('level3ID', createCAG13().Name);
        editplatFrom.checkLevel3();
        
        System.currentPageReference().getParameters().put('level2ID', createCAG12().Name);
        editplatFrom.checkLevel2();
        
        System.currentPageReference().getParameters().put('level1ID', createCAG11().Name);
        editplatFrom.checkLevel1();
        
        editplatFrom.doSave();
        Test.stopTest();
    }
    
    @isTest
    public static void retrieveTeamMembersTest5(){
        Platform_Specifics__c ps = createPlatformSpecific();
        System.currentPageReference().getParameters().put('retURL', 'retURL');
        System.currentPageReference().getParameters().put('cInfoId', ps.FAF_Client_Information__c);
        
        ApexPages.StandardController sc = new ApexPages.StandardController(ps);
        EditPlatFormSpecificController editplatFrom = new EditPlatFormSpecificController(sc);
        
        editplatFrom.recordId =null;
        editplatFrom.loadRecord();
        editplatFrom.doCancel();
        //editplatFrom.platformSpecific =ps;
        editplatFrom.onchangePlatform();
        Date dt =System.today();
        
        String dtformat=dt.format();
        
        Date gstpdt =System.today().adddays(-1);
        String gstpdtformat=gstpdt .format();
        
        Date sftpdt =System.today().adddays(-1);
        String sftpdtformat=sftpdt.format();
        
        Date nfstpdt =System.today().adddays(-1);
        String nfstpdtformat=nfstpdt.format();
        
        //String dateString=String.valueOf(dtformat.addDays(15));
        System.currentPageReference().getParameters().put('gstpEffectiveDate3', gstpdtformat);
        System.currentPageReference().getParameters().put('effetiveDate3', '');
        editplatFrom.gstpEffectiveDateCheck();
        
        System.currentPageReference().getParameters().put('nsfEffectiveDate2', nfstpdtformat);
        System.currentPageReference().getParameters().put('effetiveDate2', '');
        editplatFrom.nsfEffectiveDateCheck();
        
        System.currentPageReference().getParameters().put('sfEffectiveDate1', sftpdtformat);
        System.currentPageReference().getParameters().put('effetiveDate1', '');
        editplatFrom.sfEffectiveDateCheck();
        
        System.currentPageReference().getParameters().put('gstpEffectiveDate', dtformat);
        System.currentPageReference().getParameters().put('gstpEndDate', '');
        editplatFrom.gstpEndDateCheck();
        
        System.currentPageReference().getParameters().put('nsfEffectiveDate', dtformat);
        System.currentPageReference().getParameters().put('nsfEndDate', '');
        editplatFrom.nsfEndDateCheck();
        
        System.currentPageReference().getParameters().put('sfEffectiveDate', dtformat);
        System.currentPageReference().getParameters().put('sfEndDate', '');
        editplatFrom.sfEndDateCheck();
        
        System.currentPageReference().getParameters().put('gstpFormularyFlag', 'True');
        editplatFrom.gstpFormularyDatesCheck();
        System.currentPageReference().getParameters().put('gstpFormularyFlag', 'false');
        editplatFrom.gstpFormularyDatesCheck();
        
        System.currentPageReference().getParameters().put('terminateDate', dtformat);
        editplatFrom.checkTerminateDate();
        
        System.currentPageReference().getParameters().put('termFlag', 'True');
        editplatFrom.terminatedDateCheck();
        System.currentPageReference().getParameters().put('termFlag', 'false');
        editplatFrom.terminatedDateCheck();
        
        System.currentPageReference().getParameters().put('effectiveDate', dtformat);
        editplatFrom.checkEffectiveDate();

        editplatFrom.checkLevel3();
        System.currentPageReference().getParameters().put('level3ID', createCAG3().Name);
        editplatFrom.checkLevel3();
        
        editplatFrom.checkLevel2();
        System.currentPageReference().getParameters().put('level2ID', createCAG2().Name);
        editplatFrom.checkLevel2();

        editplatFrom.checkLevel1();
        System.currentPageReference().getParameters().put('level1ID', createCAG().Name);
        editplatFrom.checkLevel1();
        
        editplatFrom.doSave();
    }
    
    @isTest
    public static void retrieveTeamMembersTest6(){
        Platform_Specifics__c ps = createPlatformSpecific();
        System.currentPageReference().getParameters().put('retURL', 'retURL');
        System.currentPageReference().getParameters().put('cInfoId', ps.FAF_Client_Information__c);
        
        ApexPages.StandardController sc = new ApexPages.StandardController(ps);
        EditPlatFormSpecificController editplatFrom = new EditPlatFormSpecificController(sc);
        
        editplatFrom.recordId =null;
        editplatFrom.loadRecord();
        editplatFrom.doCancel();
        //editplatFrom.platformSpecific =ps;
        editplatFrom.onchangePlatform();
        Date dt =System.today();
        
        String dtformat=dt.format();
        
        Date gstpdt =System.today().adddays(-1);
        String gstpdtformat=gstpdt .format();
        
        Date sftpdt =System.today().adddays(-1);
        String sftpdtformat=sftpdt.format();
        
        Date nfstpdt =System.today().adddays(-1);
        String nfstpdtformat=nfstpdt.format();
        
        //String dateString=String.valueOf(dtformat.addDays(15));
        System.currentPageReference().getParameters().put('gstpEffectiveDate3', '');
        System.currentPageReference().getParameters().put('effetiveDate3', '');
        editplatFrom.gstpEffectiveDateCheck();
        
        System.currentPageReference().getParameters().put('nsfEffectiveDate2', '');
        System.currentPageReference().getParameters().put('effetiveDate2', '');
        editplatFrom.nsfEffectiveDateCheck();
        
        System.currentPageReference().getParameters().put('sfEffectiveDate1', '');
        System.currentPageReference().getParameters().put('effetiveDate1', '');
        editplatFrom.sfEffectiveDateCheck();
        
        System.currentPageReference().getParameters().put('gstpEffectiveDate', '');
        System.currentPageReference().getParameters().put('gstpEndDate', dtformat);
        editplatFrom.gstpEndDateCheck();
        
        System.currentPageReference().getParameters().put('nsfEffectiveDate', '');
        System.currentPageReference().getParameters().put('nsfEndDate', dtformat);
        editplatFrom.nsfEndDateCheck();
        
        System.currentPageReference().getParameters().put('sfEffectiveDate', '');
        System.currentPageReference().getParameters().put('sfEndDate', dtformat);
        editplatFrom.sfEndDateCheck();
        
        System.currentPageReference().getParameters().put('gstpFormularyFlag', 'True');
        editplatFrom.gstpFormularyDatesCheck();
        System.currentPageReference().getParameters().put('gstpFormularyFlag', 'false');
        editplatFrom.gstpFormularyDatesCheck();
        
        System.currentPageReference().getParameters().put('terminateDate', dtformat);
        editplatFrom.checkTerminateDate();
        
        System.currentPageReference().getParameters().put('termFlag', 'True');
        editplatFrom.terminatedDateCheck();
        System.currentPageReference().getParameters().put('termFlag', 'false');
        editplatFrom.terminatedDateCheck();
        
        System.currentPageReference().getParameters().put('effectiveDate', dtformat);
        editplatFrom.checkEffectiveDate();

        editplatFrom.checkLevel3();
        System.currentPageReference().getParameters().put('level3ID', createCAG3().Name);
        editplatFrom.checkLevel3();
        
        editplatFrom.checkLevel2();
        System.currentPageReference().getParameters().put('level2ID', createCAG2().Name);
        editplatFrom.checkLevel2();

        editplatFrom.checkLevel1();
        System.currentPageReference().getParameters().put('level1ID', createCAG().Name);
        editplatFrom.checkLevel1();
        
        editplatFrom.doSave();
    }
}