@isTest
public class PCD_GridObjectdataTest{
    static testMethod void PCD_GridObjectdataTest1(){
        User useObj = TestDataFactory.createUser('Apttus Underwriting');
        insert useObj;
        
        User useObjNew = TestDataFactory.createUser('Apttus Sales');
        insert useObjNew;
        
        System.runAs(useObj){
            Account accObj =  TestDataFactory.createAccount();
            insert accObj;
            
            Opportunity oppObj = TestDataFactory.createOpportunity(accObj.id);
            insert oppObj;
            
            
            Central_Hub__c FAFObj = TestDataFactory.createFAF(accObj.id, oppObj.Id, useObjNew.id);
            insert FAFObj;
            
            
            test.startTest();
            
            Apttus__APTS_Agreement__c agr=new Apttus__APTS_Agreement__c();
            agr.Apttus__Account__c=accObj.id;
            agr.Opportunity__c=oppObj.id;
            agr.Status_In_Progress__c='';
            agr.PCD_Status__c='';
                      
            insert agr;
            
            Apttus__AgreementLineItem__c agrline=new Apttus__AgreementLineItem__c();
            agrline.Apttus__AgreementId__c=agr.id;
            agrline.PCD_FAF__c=FAFObj.id;
            agrline.Apttus_CMConfig__LineNumber__c=0;
            agrline.Apttus_CMConfig__ItemSequence__c=0;
            agrline.LOB_Description__c='';
         
            insert agrline;
            
            agr.Primary_Agreement_Line_Item__c=agrline.id;
            agr.Status_In_Progress__c='Setup Pricing';
            agr.PCD_Status__c='Setup Pricing';
            update agr;
            
            Task__c task= new Task__c();
            //task.Owner=useObjNew.id;
            task.Account__c=accObj.id;
            task.Agreement__c=agr.id;
            task.FAF_ID__c=FAFObj.id;
            insert task;
            
            Offer__c offer= new Offer__c();
            //offer.Account__c=accObj.id;
            offer.PCD__c=agr.id;
            offer.Alert_Message__c='';
            //offer.Name='abc';
            offer.OfferCategory__c='Renewal';
            offer.OfferDescriptor__c='';
            //Offer_Revenue_PCD__c,
            //OfferTotalRevenue__c,PCD_Offer_link__c,
            offer.iUMSTask__c=task.id;
            offer.LaunchPB__c =false;
            offer.Alert_Acknowledgement__c =false;
            insert offer;
            
            task.Offer__c=offer.id;
            update task;
            
            agr.Offer__c=offer.id;
            update agr;
            
            LOB__c lob= new LOB__c();
            lob.Client_Pricing_Offer__c=offer.id;
            lob.Agreement__c=agr.id;
            lob.Agreement_Line_Item__c=agrline.id;
            lob.FAF__c=FAFObj.id;
            lob.Lob__c='ACT';
            lob.LobBusinessType__c='New';
            lob.LobDescriptor__c='';
            lob.LobId__c='123';
            insert lob;
            
            agrline.LOB_ID__c=lob.id;
            update agrline;
            
            Apttus__APTS_Template__c aptemp=new Apttus__APTS_Template__c();
             aptemp.Name='Client Facing PCD';
             aptemp.Apttus__Type__c='Agreement'; 
             //aptemp.Next_Template__c='';
             aptemp.Apttus__IsActive__c=true;
             aptemp.Apttus__BusinessObject__c='Apttus__APTS_Agreement__c';
             insert aptemp;
            
            Apttus__DocumentVersion__c Docversion=new Apttus__DocumentVersion__c();
             Docversion.Name = 'Generate Agreement';
             Docversion.Apttus__AgreementId__c = agr.id;
             Docversion.Apttus__LatestVersion__c ='0';
             Docversion.Apttus__ReferenceId__c = aptemp.Id;
             Docversion.Apttus__TemplateId__c = aptemp.Id;
             Docversion.Apttus__Title__c = 'filename';
             insert Docversion;
             
             
             
             Apttus__DocumentVersionDetail__c adDetailObj=new Apttus__DocumentVersionDetail__c();
             adDetailObj.Agreement__c=agr.id;
             adDetailObj.LOB_Detail__c='STD';
             adDetailObj.Name='66.0.0';
             adDetailObj.Apttus__Title__c='PCD - NTN USA Corporation_Original_2020-02-10.docx';
             adDetailObj.Apttus__DocumentVersionId__c=Docversion.id;
             adDetailObj.Apttus__VersionMajor__c=66;
             adDetailObj.Apttus__VersionMinor__c=0;
             adDetailObj.Apttus__VersionRevision__c=0;
             adDetailObj.Agreement_Line_Item__c=agrline.id;
             adDetailObj.Apttus__DocumentInfo__c = 'Draft' ;
             adDetailObj.Apttus__Action2__c='Generate Agreement';
             adDetailObj.Apttus__FileType__c='docx';
             adDetailObj.Apttus__ContentId__c='';
             adDetailObj.Apttus__IsTransient__c  = true;
             insert adDetailObj;
             
             Attachment attach= new Attachment();
             attach.Name='Attachment';
             attach.ContentType='Attachment';
             attach.ParentId=Docversion.id;
             
            try{
          //PCD_GridObjectdata.get_Attachment(adDetailObj.id);    
          //PCD_GridObjectdata.updatepriali(agr.id, String.valueOf(agrline.LOBSequence__c));     
            PCD_GridObjectdata.get_Offer(accObj.id);
            PCD_GridObjectdata.get_LOB(offer.id);
            PCD_GridObjectdata.update_priali(agr.id, agrline.id);
            PCD_GridObjectdata.update_prialigen(agr.id, agrline.id);
            PCD_GridObjectdata.get_lineofbusiness(offer.id);
            PCD_GridObjectdata.get_DocVersionDetail(agrline.id);
            PCD_GridObjectdata.get_pcd(offer.id);
            
            PCD_GridObjectdata.get_Attachment(adDetailObj.id);  
            PCD_GridObjectdata.updatepriali(agr.id, String.valueOf(agrline.LOBSequence__c));
            // cover exception
            //PCD_GridObjectdata.get_offer(null);
             }
             catch(Exception ex){}
             try{
                 PCD_GridObjectdata.get_worddoc(agrline.id);
                 PCD_GridObjectdata.get_createpcd(offer.id);
             }catch(Exception e){}
            test.stopTest();
        }
    }
    
    static testMethod void PCD_GridObjectdataTest2(){
        User useObj = TestDataFactory.createUser('Apttus Underwriting');
        insert useObj;
        
        User useObjNew = TestDataFactory.createUser('Apttus Sales');
        insert useObjNew;
        
        System.runAs(useObj){
            Account accObj =  TestDataFactory.createAccount();
            insert accObj;
            
            Opportunity oppObj = TestDataFactory.createOpportunity(accObj.id);
            insert oppObj;
            
            
            Central_Hub__c FAFObj = TestDataFactory.createFAF(accObj.id, oppObj.Id, useObjNew.id);
            insert FAFObj;
            
            
            test.startTest();
            
            Apttus__APTS_Agreement__c agr=new Apttus__APTS_Agreement__c();
            agr.Apttus__Account__c=accObj.id;
            agr.Opportunity__c=oppObj.id;
          //  agr.Status_In_Progress__c='Generate Document';
           // agr.PCD_Status__c='Generate Document';   
             agr.Status_In_Progress__c='Setup Pricing';
             agr.PCD_Status__c='Setup Pricing';          
            insert agr;
            
            Apttus__AgreementLineItem__c agrline=new Apttus__AgreementLineItem__c();
            agrline.Apttus__AgreementId__c=agr.id;
            agrline.PCD_FAF__c=FAFObj.id;
            agrline.Apttus_CMConfig__LineNumber__c=0;
            agrline.Apttus_CMConfig__ItemSequence__c=0;
            agrline.LOB_Description__c='';
         //  agrline.lobsequence__c  = 0;
            insert agrline;
            
            agr.Primary_Agreement_Line_Item__c=agrline.id;
            update agr;
            
            Task__c task= new Task__c();
            //task.Owner=useObjNew.id;
            task.Account__c=accObj.id;
            task.Agreement__c=agr.id;
            task.FAF_ID__c=FAFObj.id;
            insert task;
            
            Offer__c offer= new Offer__c();
            //offer.Account__c=accObj.id;
            offer.PCD__c=agr.id;
            offer.Alert_Message__c='';
            //offer.Name='abc';
            offer.OfferCategory__c='Renewal';
            offer.OfferDescriptor__c='';
            //Offer_Revenue_PCD__c,
            //OfferTotalRevenue__c,PCD_Offer_link__c,
            offer.iUMSTask__c=task.id;
            offer.LaunchPB__c =false;
            offer.Alert_Acknowledgement__c =false;
            insert offer;
            
            task.Offer__c=offer.id;
            update task;
            
            agr.Offer__c=offer.id;
            update agr;
            
            LOB__c lob= new LOB__c();
            lob.Client_Pricing_Offer__c=offer.id;
            lob.Agreement__c=agr.id;
            lob.Agreement_Line_Item__c=agrline.id;
            lob.FAF__c=FAFObj.id;
            lob.Lob__c='ACT';
            lob.LobBusinessType__c='New';
            lob.LobDescriptor__c='';
            lob.LobId__c='';
            insert lob;
            
            agrline.LOB_ID__c=lob.id;
            update agrline;
            
            Apttus__APTS_Template__c aptemp=new Apttus__APTS_Template__c();
             aptemp.Name='Client Facing PCD';
             aptemp.Apttus__Type__c='Agreement'; 
             //aptemp.Next_Template__c='';
             aptemp.Apttus__IsActive__c=true;
             aptemp.Apttus__BusinessObject__c='Apttus__APTS_Agreement__c';
             insert aptemp;
            
            Apttus__DocumentVersion__c Docversion=new Apttus__DocumentVersion__c();
             Docversion.Name = 'Generate Agreement';
             Docversion.Apttus__AgreementId__c = agr.id;
             Docversion.Apttus__LatestVersion__c ='0';
             Docversion.Apttus__ReferenceId__c = aptemp.Id;
             Docversion.Apttus__TemplateId__c = aptemp.Id;
             Docversion.Apttus__Title__c = 'filename';
             insert Docversion;
             
             
             
             Apttus__DocumentVersionDetail__c adDetailObj=new Apttus__DocumentVersionDetail__c();
             adDetailObj.Agreement__c=agr.id;
             adDetailObj.LOB_Detail__c='STD';
             adDetailObj.Name='66.0.0';
             adDetailObj.Apttus__Title__c='PCD - NTN USA Corporation_Original_2020-02-10.docx';
             adDetailObj.Apttus__DocumentVersionId__c=Docversion.id;
             adDetailObj.Apttus__VersionMajor__c=66;
             adDetailObj.Apttus__VersionMinor__c=0;
             adDetailObj.Apttus__VersionRevision__c=0;
             adDetailObj.Agreement_Line_Item__c=agrline.id;
             adDetailObj.Apttus__DocumentInfo__c = 'Draft' ;
             adDetailObj.Apttus__Action2__c='Generate Agreement';
             adDetailObj.Apttus__FileType__c='';
             insert adDetailObj;
             
             Attachment attach= new Attachment();
             attach.Name='Attachment';
             attach.ContentType='Attachment';
             attach.ParentId=Docversion.id;
             try{           
            PCD_GridObjectdata.get_Offer(accObj.id);
            PCD_GridObjectdata.get_LOB(offer.id);
            PCD_GridObjectdata.update_priali(agr.id, agrline.id);
            PCD_GridObjectdata.update_prialigen(agr.id, agrline.id);
            PCD_GridObjectdata.get_lineofbusiness(offer.id);
            PCD_GridObjectdata.get_DocVersionDetail(agrline.id);
            
            PCD_GridObjectdata.get_pcd(offer.id);
            PCD_GridObjectdata.updatepriali(agr.id,lob.id);
            
            PCD_GridObjectdata.get_Attachment(Docversion.id);
            
             }
             catch(Exception ex){}
             try{
                 PCD_GridObjectdata.get_worddoc(agrline.id);
                 PCD_GridObjectdata.get_createpcd(offer.id);
             }catch(Exception e){}
             
            test.stopTest();
        }
    }   
    
    //method to cover the negative scenarios
        static testMethod void PCD_GridObjectdataNegativeTest(){
        User useObj = TestDataFactory.createUser('Apttus Underwriting');
        insert useObj;
        
        User useObjNew = TestDataFactory.createUser('Apttus Sales');
        insert useObjNew;
        
        System.runAs(useObj){
            Account accObj =  TestDataFactory.createAccount();
            insert accObj;
            
            Opportunity oppObj = TestDataFactory.createOpportunity(accObj.id);
            insert oppObj;
            
            
            Central_Hub__c FAFObj = TestDataFactory.createFAF(accObj.id, oppObj.Id, useObjNew.id);
            insert FAFObj;
            
            
            test.startTest();
            
           /* Apttus__APTS_Agreement__c agr=new Apttus__APTS_Agreement__c();
            agr.Apttus__Account__c=accObj.id;
            agr.Opportunity__c=oppObj.id;
            //agr.Status_In_Progress__c='Setup Pricing';
            //agr.PCD_Status__c='Setup Pricing';           
            try{
                insert agr;
            }catch(Exception ex){}
            
            Apttus__AgreementLineItem__c agrline=new Apttus__AgreementLineItem__c();
           // agrline.Apttus__AgreementId__c=agr.id;
            //agrline.PCD_FAF__c=FAFObj.id;
            //agrline.Apttus_CMConfig__LineNumber__c=0;
            //agrline.Apttus_CMConfig__ItemSequence__c=0;
            //agrline.LOB_Description__c='';
            try{
                insert agrline;
            }catch(Exception e){}
            
            
            Task__c task= new Task__c();
            //task.Owner=useObjNew.id;
            task.Account__c=accObj.id;
            task.Agreement__c=agr.id;
            //task.FAF_ID__c=FAFObj.id;
            try{
            insert task;
            }catch(Exception e){}
            
            Offer__c offer= new Offer__c();
            //offer.Account__c=accObj.id;
            offer.PCD__c=agr.id;
            offer.Alert_Message__c='';
            //offer.Name='abc';
            offer.OfferCategory__c='Renewal';
            offer.OfferDescriptor__c='';
            //offer.Offer_Revenue_PCD__c;
            //offer.OfferTotalRevenue__c;
            //offer.PCD_Offer_link__c,
            offer.iUMSTask__c=task.id;
            offer.LaunchPB__c =false;
            offer.Alert_Acknowledgement__c =false;
            
            try{
                insert offer;
            }catch(Exception e){}
            
            task.Offer__c=offer.id;
            //update task;
            
            //agr.Offer__c=offer.id;
            //update agr;
            
            LOB__c lob= new LOB__c();
            lob.Client_Pricing_Offer__c=offer.id;
            lob.Agreement__c=agr.id;
            lob.Agreement_Line_Item__c=agrline.id;
            //lob.FAF__c=FAFObj.id;
            lob.Lob__c='ACT';
            lob.LobBusinessType__c='New';
            lob.LobDescriptor__c='';
            lob.LobId__c='';
            try{
                insert lob;
            }catch(Exception e){}

            agrline.LOB_ID__c=lob.id;
            //update agrline;
            
            Apttus__APTS_Template__c aptemp=new Apttus__APTS_Template__c();
             aptemp.Name='Client Facing PCD';
             aptemp.Apttus__Type__c='Agreement'; 
             //aptemp.Next_Template__c='';
             aptemp.Apttus__IsActive__c=true;
             aptemp.Apttus__BusinessObject__c='Apttus__APTS_Agreement__c';
             try{
                 insert aptemp;
             }catch(Exception e){}
             
            Apttus__DocumentVersion__c Docversion=new Apttus__DocumentVersion__c();
             Docversion.Name = 'Generate Agreement';
             Docversion.Apttus__AgreementId__c = agr.id;
             Docversion.Apttus__LatestVersion__c ='0';
             Docversion.Apttus__ReferenceId__c = aptemp.Id;
             Docversion.Apttus__TemplateId__c = aptemp.Id;
             Docversion.Apttus__Title__c = 'filename';
             try{
                 insert Docversion;
             }catch(Exception e){}
             
             
             Apttus__DocumentVersionDetail__c adDetailObj=new Apttus__DocumentVersionDetail__c();
             adDetailObj.Agreement__c=agr.id;
             adDetailObj.LOB_Detail__c='STD';
             adDetailObj.Name='66.0.0';
             adDetailObj.Apttus__Title__c='PCD - NTN USA Corporation_Original_2020-02-10.docx';
             adDetailObj.Apttus__DocumentVersionId__c=Docversion.id;
             adDetailObj.Apttus__VersionMajor__c=66;
             adDetailObj.Apttus__VersionMinor__c=0;
             adDetailObj.Apttus__VersionRevision__c=0;
             //adDetailObj.Agreement_Line_Item__c=agrline.id;
             adDetailObj.Apttus__DocumentInfo__c = 'Draft' ;
             adDetailObj.Apttus__Action2__c='Generate Agreement';
             adDetailObj.Apttus__FileType__c='';
             try{
                 insert adDetailObj;
             }catch(Exception e){}
             
             Attachment attach= new Attachment();
             attach.Name='Attachment';
             attach.ContentType='Attachment';
             attach.ParentId=Docversion.id;
             
            // PCD_GridObjectdata.get_worddoc(agrline.id);
             //PCD_GridObjectdata.update_priali(agrline.id, agrline.id);
             //PCD_GridObjectdata.update_prialigen(agr.id, agrline.id);
           
*/         try{           
            PCD_GridObjectdata.get_Offer('');
            }catch(Exception ex){}
            try{
            PCD_GridObjectdata.get_LOB('');
            }catch(Exception ex){}
            try{
            PCD_GridObjectdata.update_priali('','');
            }catch(Exception ex){}
            try{
            PCD_GridObjectdata.update_prialigen('','');
            }catch(Exception ex){}
            try{
            PCD_GridObjectdata.get_lineofbusiness('');
            }catch(Exception ex){}
            try{
            PCD_GridObjectdata.get_DocVersionDetail('');
            }catch(Exception ex){}
            try{
            PCD_GridObjectdata.get_worddoc('');
            }catch(Exception ex){}
            try{
            PCD_GridObjectdata.get_pcd('');
            }catch(Exception ex){}
            /*
            try{
            PCD_GridObjectdata.get_Attachment(Docversion.id);
            }catch(Exception ex){}
           //PCD_GridObjectdata.updatepriali(agr.id,lob.id);
            try{
            PCD_GridObjectdata.get_createpcd(offer.id);
             }
             catch(Exception ex){}
            */
            test.stopTest();
        }
    } 
    
}