/*********************************************************************************************
* @author:     Sridevi
* @date:       11/19/2018
* @description:This is the testclass for the class AttachmentTriggerHandler    
 **********************************************************************************************/
@isTest
public class AttachmentTriggerHandlerTest {

    static testmethod void AttachMethod() {

        Profile p = [SELECT Id FROM Profile WHERE Name = 'Apttus Underwriting'];
        UserRole role = [select id, name from userrole where name = 'Apttus Underwriting'];
        User u = new User(Alias = 'standt', Email = 'standarduser1212@testorg.com', EmailEncodingKey = 'UTF-8', LastName = 'Testing', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', ProfileId = p.Id, userroleid = role.id, TimeZoneSidKey = 'America/Los_Angeles', UserName = 'standarduser2121@testorg.com', Market_Segment__c = 'Employer', ManagerId = userInfo.getuserId());

        User salesperson = ClientTestRef.createUser('Apttus Sales');
        insert salesperson;
        Account accObj = ClientTestRef.createAccount();
        insert accObj;
        Opportunity oppObj = ClientTestRef.createOpportunity(accObj.id);
        insert oppObj;
        Central_Hub__c FAFObj = ClientTestRef.createFAF(accObj.id, oppObj.Id, u.Id);
        FAFObj.Business_Type__c = 'New';
        FAFObj.FAF_Print_Header__c = 'New';
        insert FAFObj;

        Apttus__APTS_Template__c temp = new Apttus__APTS_Template__c();
        temp.Name = 'Test Template';
        temp.Apttus__Type__c = 'FAF';
        temp.Apttus__IsActive__c = true;
        temp.Apttus__ReferenceId__c = '0837d320-b63e-4924-ba63-7661a0f8f9d3';
        insert temp;
        
        Apttus__APTS_Agreement__c agr=new Apttus__APTS_Agreement__c();
            agr.Apttus__Account__c=accObj.id;
            agr.Opportunity__c=oppObj.id;
            agr.Status_In_Progress__c='Setup Pricing';
            agr.PCD_Status__c='Setup Pricing';
            insert agr;
        
         Apttus__DocumentVersion__c Docversion=new Apttus__DocumentVersion__c();
            Docversion.Name = 'Generate Agreement';
            Docversion.Apttus__Title__c = 'Test';
            Docversion.Apttus__AgreementId__c = agr.id;
            Docversion.Apttus__LatestVersion__c ='0';
            Docversion.Apttus__ReferenceId__c = temp.Id;
            Docversion.Apttus__TemplateId__c = temp.Id;
            insert Docversion;
                              

           test.starttest();
        
            List < Attachment > attList = new List < Attachment > ();
            Attachment att = new Attachment();
            att.Name = 'PCD-Template_Att';  
            att.body = Blob.valueof('Test');
            att.parentId = FAFObj.Id;
            attList.add(att);
        
         /* Attachment att2 = new Attachment();
            att2.Name = 'PCD-Template_Att';
            att2.body = Blob.valueof('Test');
            att2.parentId = agr.Id;
            att1.add(att2);
         */
        
          AttachmentTriggerHandler.onafterInsert(attList);
          insert attList;
          AttachmentTriggerHandler.onBeforeInsert(attList);
           
       
          Apttus__DocumentVersionDetail__c adDetailObj=new Apttus__DocumentVersionDetail__c();
             adDetailObj.Agreement__c = agr.id;
             adDetailObj.LOB_Detail__c='STD';
             adDetailObj.Name='66.0.0';
             //adDetailObj.Apttus__ContentId__c =;    
             adDetailObj.Apttus__Title__c='PCD - NTN USA Corporation_Original_2020-02-10.docx';
             adDetailObj.Apttus__DocumentVersionId__c=Docversion.id;
             adDetailObj.Apttus__VersionMajor__c=66;
             adDetailObj.Apttus__VersionMinor__c=0;
             adDetailObj.Apttus__VersionRevision__c=0;
             //adDetailObj.Agreement_Line_Item__c=agrline.id;
             adDetailObj.Apttus__DocumentInfo__c = 'Draft' ;
             adDetailObj.Apttus__Action2__c='Generate Agreement';
             adDetailObj.Apttus__FileType__c='docx';
             insert adDetailObj;
        
        AttachmentTriggerHandler.onafterInsert(attList);

        AttachmentTriggerHandler.callApttusservice(att.id, 'Test', 'Test', userinfo.getsessionId(), 'www.test.com', 'Test', 'Test');
        // AttachmentTriggerHandler.callApttusservice(att.id,'Test','Test','test','www.test.com','www.test.com', 'Test', 'Test');
        test.stopTest();
    }

    static testmethod void AttachMethod1() {

        Profile p = [SELECT Id FROM Profile WHERE Name = 'Apttus Sales'];
        UserRole role = [select id, name from userrole where name = 'Apttus Sales Read Only'];
        User u = new User(Alias = 'standt', Email = 'standarduser1212@testorg.com', EmailEncodingKey = 'UTF-8', LastName = 'Testing', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', ProfileId = p.Id, userroleid = role.id, TimeZoneSidKey = 'America/Los_Angeles', UserName = 'standarduser2121@testorg.com', Market_Segment__c = 'Employer', ManagerId = userInfo.getuserId());
        system.runAs(u) {
            // User salesperson = ClientTestRef.createUser('Apttus Sales');
            // insert salesperson;
            Account accObj = ClientTestRef.createAccount();
            insert accObj;
            Opportunity oppObj = ClientTestRef.createOpportunity(accObj.id);
            insert oppObj;
            Central_Hub__c FAFObj = ClientTestRef.createFAF(accObj.id, oppObj.Id, u.Id);
            FAFObj.Business_Type__c = 'New';
            FAFObj.FAF_Print_Header__c = 'New';
            insert FAFObj;
            
         /*  Central_Hub__Share Centralhub1 = new Central_Hub__Share();
           Centralhub1.UserOrGroupId = Userinfo.getUserId();
           Centralhub1.ParentId = FAFObj.id;
           Centralhub1.AccessLevel = 'All';
           insert Centralhub1;
            Centralhub1.AccessLevel = 'All';
            Update Centralhub1;
         */
            
            Central_Hub_Share_Modify__c Centralhub = new Central_Hub_Share_Modify__c();
            Centralhub.FAFShareId__c = FAFObj.id;
            Centralhub.FAFId__c = FAFObj.id;
            Centralhub.Old_AccessLevel__c = 'All';
            Centralhub.New_Accesslevel__c = 'All';
            Centralhub.UserOrGroupId__c = u.id;
            insert Centralhub;
            
            test.starttest();
            XAE_Manual_Share__c cs = XAE_Manual_Share__c.getInstance();
            // Boolean Manshare= cs.Share__c;
            Attachment att = new Attachment();
            List < Attachment > attList = new List < Attachment > ();
            att.Name = 'TestAtt';
            att.body = Blob.valueof('Test');
            att.parentId = FAFObj.Id;
            attList.add(att);
            //            AttachmentTriggerHandler.onafterInsert(att1);
            insert attList;
            AttachmentTriggerHandler.onbeforeInsert(attList);
            AttachmentTriggerHandler.onafterInsert(attList);

            AttachmentTriggerHandler.callApttusservice(att.id, 'Test', 'Test', userinfo.getsessionId(), 'www.test.com', u.id, FAFObj.Id);
            // AttachmentTriggerHandler.callApttusservice(att.id,'Test','Test','test','www.test.com','www.test.com', 'Test', 'Test');
            test.stopTest();
        }
    }

    static testmethod void upsertAgreementAttachment() {
        Profile p = [SELECT Id FROM Profile WHERE Name = 'Apttus Underwriting'];
        UserRole role = [select id, name from userrole where name = 'Apttus Underwriting'];
        User u = new User(Alias = 'standt', Email = 'standarduser1212@testorg.com', EmailEncodingKey = 'UTF-8', LastName = 'Testing', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', ProfileId = p.Id, userroleid = role.id, TimeZoneSidKey = 'America/Los_Angeles', UserName = 'standarduser2121@testorg.com', Market_Segment__c = 'Employer', ManagerId = userInfo.getuserId());

        User salesperson = ClientTestRef.createUser('Apttus Sales');
        insert salesperson;
        Account accObj = ClientTestRef.createAccount();
        insert accObj;
        Opportunity oppObj = ClientTestRef.createOpportunity(accObj.id);
        insert oppObj;
        Central_Hub__c fafObj = ClientTestRef.createFAF(accObj.id, oppObj.Id, u.Id);
        fafObj.Business_Type__c = 'New';
        fafObj.FAF_Print_Header__c = 'New';
        insert fafObj;
        
        Apttus__APTS_Template__c temp2 = new Apttus__APTS_Template__c();
        temp2.Name = 'Test Template';
        temp2.Apttus__Type__c = 'FAF';
        temp2.Apttus__IsActive__c = true;
        temp2.Apttus__ReferenceId__c = '0837d320-b63e-4924-ba63-7661a0f8f9d3';
        insert temp2;

        iUMS_Task_Setup__c iTSobj = new iUMS_Task_Setup__c();
        iTSobj.Status__c = 'Draft';
        iTSobj.Task_Id__c = '16402';
        iTSobj.PBM_Offer__c = 1;
        iTSobj.SRX_Offer__c = 1;
        insert iTSobj;

        Attachment att = new Attachment();
        List < Attachment > attList = new List < Attachment > ();
        att.Name = 'Test Template_Att';
        att.body = Blob.valueof('Test');
        att.parentId = iTSobj.Id;
        attList.add(att);
        insert attList;
        Test.startTest();
        System.debug('attList::::::::::'+attList);
        if(attList!=null && attList.size()>0){
            //AttachmentTriggerHandler.upsertAgreementAttachment(attList); 
        }
        Test.stopTest();
    }
    
    static testmethod void UpdateDocumentVersion() {
        Profile p = [SELECT Id FROM Profile WHERE Name = 'Apttus Underwriting'];
        UserRole role = [select id, name from userrole where name = 'Apttus Underwriting'];
        User u = new User(Alias = 'standt', Email = 'standarduser1212@testorg.com', EmailEncodingKey = 'UTF-8', LastName = 'Testing', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', ProfileId = p.Id, userroleid = role.id, TimeZoneSidKey = 'America/Los_Angeles', UserName = 'standarduser2121@testorg.com', Market_Segment__c = 'Employer', ManagerId = userInfo.getuserId());

        User salesperson = ClientTestRef.createUser('Apttus Sales');
        insert salesperson;
        Account accObj = ClientTestRef.createAccount();
        insert accObj;
        Opportunity oppObj = ClientTestRef.createOpportunity(accObj.id);
        insert oppObj;
        Central_Hub__c fafObj = ClientTestRef.createFAF(accObj.id, oppObj.Id, u.Id);
        fafObj.Business_Type__c = 'New';
        fafObj.FAF_Print_Header__c = 'New';
        insert fafObj;
        
        Apttus__APTS_Agreement__c agr=new Apttus__APTS_Agreement__c();
            agr.Apttus__Account__c=accObj.id;
            agr.Opportunity__c=oppObj.id;
            agr.Status_In_Progress__c='Setup Pricing';
            agr.PCD_Status__c='Setup Pricing';
            insert agr;
                    
            Apttus__AgreementLineItem__c agrline=new Apttus__AgreementLineItem__c();
            agrline.Apttus__AgreementId__c=agr.id;
            agrline.PCD_FAF__c=FAFObj.id;
            agrline.Apttus_CMConfig__LineNumber__c=0;
            agrline.Apttus_CMConfig__ItemSequence__c=0;
            agrline.LOB_Description__c='';
            insert agrline;
            
            agr.Primary_Agreement_Line_Item__c=agrline.id;
            update agr;
            
           Apttus__APTS_Template__c temp = new Apttus__APTS_Template__c();
           temp.Name = 'Client Facing PCD';
           temp.Apttus__Type__c = 'FAF';
           temp.Apttus__IsActive__c = true;
           temp.Apttus__ReferenceId__c = '0837d320-b63e-4924-ba63-7661a0f8f9d3';
           insert temp;
        
            Apttus__DocumentVersion__c Docversion=new Apttus__DocumentVersion__c();
            Docversion.Name = 'Generate Agreement';
            Docversion.Apttus__Title__c = 'Test';
            Docversion.Apttus__AgreementId__c = agr.id;
            Docversion.Apttus__LatestVersion__c ='0';
            Docversion.Apttus__ReferenceId__c = temp.Id;
            Docversion.Apttus__TemplateId__c = temp.Id;
            insert Docversion;
             
                          
             Apttus__DocumentVersionDetail__c adDetailObj=new Apttus__DocumentVersionDetail__c();
             adDetailObj.Agreement__c=agr.id;
             adDetailObj.LOB_Detail__c='STD';
             adDetailObj.Name='66.0.0';
             adDetailObj.Apttus__ContentId__c = '';    
             adDetailObj.Apttus__Title__c='PCD - NTN USA Corporation_Original_2020-02-10.docx';
             adDetailObj.Apttus__DocumentVersionId__c=Docversion.id;
             adDetailObj.Apttus__VersionMajor__c=66;
             adDetailObj.Apttus__VersionMinor__c=0;
             adDetailObj.Apttus__VersionRevision__c=0;
             adDetailObj.Agreement_Line_Item__c=agrline.id;
             adDetailObj.Apttus__DocumentInfo__c = 'Draft' ;
             adDetailObj.Apttus__Action2__c='Generate Agreement';
             adDetailObj.Apttus__FileType__c='docx';
             adDetailObj.Agreement_Line_Item__c = agr.Primary_Agreement_Line_Item__c;
             insert adDetailObj;
        
          Test.startTest();  
          List<Attachment> attList = new List<Attachment>();
          if(adDetailObj!=null){
             Attachment att= new Attachment();
             att.Name='Attachment';
             att.ContentType='Attachment';
             att.parentId = agr.Id;
            // att.ParentId=Docversion.id;
             att.Name = adDetailObj.Apttus__Title__c;
             att.body = Blob.valueof('Test');
             attList.add(att);
             insert attList;
         }
         
            adDetailObj.Agreement_Line_Item__c = agr.Primary_Agreement_Line_Item__c;
            try{
            Update adDetailObj;  
            }catch(Exception ex){}
        
          AttachmentTriggerHandler.PCDDocbeforeInsert(attList);
          adDetailObj.Agreement__c = Null;
          AttachmentTriggerHandler.PCDDocbeforeInsert(attList);
          Docversion.Apttus__AgreementId__c = null;
          update Docversion;
          AttachmentTriggerHandler.PCDDocbeforeInsert(attList);
        
          Test.StopTest();
             
    }
  

}