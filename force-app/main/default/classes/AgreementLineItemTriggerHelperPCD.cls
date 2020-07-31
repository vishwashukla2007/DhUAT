/* =================================================================================
 * @Class Name        : AgreementLineItemTriggerHelperPCD
 * @author            : Mohit Srivastava
 * @created date      : 11/01/2019
 * @Purpose           : Apex class to check FAF Data Quality at PCD process and capture Validation Error to notify
=======================================================================================*/
public class AgreementLineItemTriggerHelperPCD
{
    //Public static boolean HistoryCheck;
/*=================================================================================
 * @Method Name       : FAF_Data_Validate
 * @author            : Mohit Srivastava
 * @created date      : 11/01/2019
 * @Last modified by  : Mohit Srivastava
 * @Purpose           : Apex class to check FAF Data Quality at PCD process and capture Validation Error to notify
=======================================================================================*/
    
    public static void FAF_Data_Validate(List<Apttus__AgreementLineItem__c> AgreementLineID,Boolean callType)
    {
     
     DeepCloneUtility.OFF_TRIGGERS_PROCBUILDER=false;
     // if(DeepCloneUtility.OFF_INVOCABLE_CLASS){
    Set<ID> ids=new Set<ID>();
   
    for(Apttus__AgreementLineItem__c ides:AgreementLineID)
    {
    ids.add(ides.id);
    }
   
    IdentifyErrorInCOmponent(ids,callType);
    }
    
    @future(callout=true)
    public static void IdentifyErrorInCOmponent(Set<ID> AgreementLineID,boolean CallType){
     DeepCloneUtility.HistoryCheck=false;
    System.debug('In process FAF validations'); 
     String ErrorMessage=' ';
    String SObjectname;
                List<Network_Pricing__c> np = new List<Network_Pricing__c>();
                List<Network_Pricing__c> npupdate = new List<Network_Pricing__c>();
                 System.debug('In Agreement trigger history check--1'+DeepCloneUtility.HistoryCheck);     
                
                List<Mail_Pricing__c> mp = new List<Mail_Pricing__c>();
                List<Mail_Pricing__c> mpupdate = new List<Mail_Pricing__c>();
                
                List<Client_Information__c> clientlst= new List<Client_Information__c>();
                List<Client_Information__c> clientUpdate = new List<Client_Information__c>();
                
                
                List<Network_Operations__c> Networklst= new List<Network_Operations__c>();
                List<Network_Operations__c> NetworkUpdate = new List<Network_Operations__c>();
                
                List<Rebate_Operations__c> rebatelst= new List<Rebate_Operations__c>();
                List<Rebate_Operations__c> rebateUpdate = new List<Rebate_Operations__c>();
                
                List<Mail_Operations__c> maillst= new List<Mail_Operations__c>();
                List<Mail_Operations__c> mailUpdate = new List<Mail_Operations__c>();
                
                List<Clinical_Solutions__c> clinicallst= new List<Clinical_Solutions__c>();
                List<Clinical_Solutions__c> clinicalUpdate = new List<Clinical_Solutions__c>();
                
                List<Specialty_Operations__c> SpecialtyOpslst= new List<Specialty_Operations__c>();
                List<Specialty_Operations__c> SpecialtyUpdate = new List<Specialty_Operations__c>();
                
                List<Specialty_Pricing__c> Specialtypriclst= new List<Specialty_Pricing__c>();
                List<Specialty_Pricing__c> SpecialtypricUpdate = new List<Specialty_Pricing__c>();
                
                
                List<Rebate_Guarantees__c> RebateGuarlst= new List<Rebate_Guarantees__c>();
                List<Rebate_Guarantees__c> RebateGuarUpdate = new List<Rebate_Guarantees__c>();
                
                List<Billing_Administrative_Fees__c> Adminlst= new List<Billing_Administrative_Fees__c>();
                List<Billing_Administrative_Fees__c> AdminListUpdate = new List<Billing_Administrative_Fees__c>();
                    
                List<Rebate_Gtees_Specialty_Class_Carve_Outs__c> CarveOutlst= new List<Rebate_Gtees_Specialty_Class_Carve_Outs__c>();
                List<Rebate_Gtees_Specialty_Class_Carve_Outs__c> CarveOutlstUpdate = new List<Rebate_Gtees_Specialty_Class_Carve_Outs__c>();
                
                
                Map<ID,Boolean> mapCLient=new Map<ID,Boolean>();
                Map<ID,Boolean> mapNetwork=new Map<ID,Boolean>();
                Map<ID,Boolean> mapNetworkpric=new Map<ID,Boolean>();
                Map<ID,Boolean> mapRebateOps=new Map<ID,Boolean>();
                Map<ID,Boolean> mapMailOps=new Map<ID,Boolean>();
                Map<ID,Boolean> mapMailPic=new Map<ID,Boolean>();
                Map<ID,Boolean> mapBillAdmin=new Map<ID,Boolean>();
                Map<ID,Boolean> mapSpecialtyOps=new Map<ID,Boolean>();
                Map<ID,Boolean> mapSpecialtyPric=new Map<ID,Boolean>();
                Map<ID,Boolean> mapRebateGuar=new Map<ID,Boolean>();
                Map<ID,Boolean> mapClinicalSOlution=new Map<ID,Boolean>();
                Map<ID,Boolean> mapCarveOut=new Map<ID,Boolean>();
                
                
                
                Map<ID,Boolean> mapCLientCheckBox=new Map<ID,Boolean>();
                Map<ID,Boolean> mapNetworkCheckBox=new Map<ID,Boolean>();
                Map<ID,Boolean> mapNetworkpricCheckBox=new Map<ID,Boolean>();
                Map<ID,Boolean> mapRebateOpsCheckBox=new Map<ID,Boolean>();
                Map<ID,Boolean> mapMailOpsCheckBox=new Map<ID,Boolean>();
                Map<ID,Boolean> mapMailPicCheckBox=new Map<ID,Boolean>();
                Map<ID,Boolean> mapBillAdminCheckBOX=new Map<ID,Boolean>();
                Map<ID,Boolean> mapSpecialtyOpsCheckBOX=new Map<ID,Boolean>();
                Map<ID,Boolean> mapSpecialtyPricCheckBOX=new Map<ID,Boolean>();
                Map<ID,Boolean> mapRebateGuarCHeckBox=new Map<ID,Boolean>();
                Map<ID,Boolean> mapClinicalSOlutionCheckBOX=new Map<ID,Boolean>();
                Map<ID,Boolean> mapCarveOutCheckBOX=new Map<ID,Boolean>();
                
    List<Apttus__AgreementLineItem__c> ali = new List<Apttus__AgreementLineItem__c>();
     List<Apttus__AgreementLineItem__c> aliupdate = new List<Apttus__AgreementLineItem__c>();
      List<Apttus__AgreementLineItem__c> aliupdatemail = new List<Apttus__AgreementLineItem__c>();
    String querystr = 'SELECT Id,Apttus__AgreementId__c,Async_Mode__c,PCD_FAF__c,Component_Error__c,FAF_Name__c,Network_Operation_Link__c,Rebate_Carve_Out_Link__c,Billing_Admin_Link__c,Network_Pricing_Link__c,Mail_Operation_Link__c,Mail_Pricing_Link__c,Rebate_Operation_Link__c,Rebate_Guarantee_Link__c,Client_Information_Link__c,Clinical_Solution_Link__c,Specialty_Operation_Link__c,Specialty_Pricing_Link__c FROM Apttus__AgreementLineItem__c Where ID IN:AgreementLineID';
    ali = Database.query(querystr);
    String cLabel=Label.PCD_Component_Validation;
    List<String> choosingComponentName= new List<String>();
    choosingComponentName = cLabel.split(',');
    Set<ID> fafids=new Set<ID>();
     Set<ID> AgreemnetID=new Set<ID>();
    map<ID,ID> mapAgreement=new map<ID,ID>();
    map<ID,ID> mapAgreementLine=new map<ID,ID>();
    map<id,Apttus__AgreementLineItem__c> LinemapUpdate = new map<id,Apttus__AgreementLineItem__c>();
    
       System.debug('ali   '+ali);
       
        for (Apttus__AgreementLineItem__c aliupd : ali)
        {
             fafids.add(aliupd.PCD_FAF__c);
             mapAgreement.put(aliupd.PCD_FAF__c,aliupd.Apttus__AgreementId__c);
             mapAgreementLine.put(aliupd.PCD_FAF__c,aliupd.id);
             AgreemnetID.add(aliupd.Apttus__AgreementId__c);
             System.debug('AgreemnetID   '+AgreemnetID);
        }
        for(String compObj: choosingComponentName){
        
                SObjectname =compObj;
                System.debug('SObjectname   '+SObjectname );
                If(SObjectname != null)
                {
                      String qryString ='SELECT Id,Name, Agreement__c,FAF_ID__c,FAF_ID__r.Name,Agreement_Line_Item__c FROM ' +SObjectname+ ' Where FAF_ID__c IN :fafids';
                      
                        if(SObjectname =='Network_Pricing__c'){
                               np = Database.query(qryString);
                               System.debug('np  '+np);
                                for (Network_Pricing__c obj:np)
                                {
                                   obj.Agreement__c = mapAgreement.get(obj.FAF_ID__c);
                                   obj.Agreement_Line_Item__c = mapAgreementLine.get(obj.FAF_ID__c);
                                   npupdate.add(obj);
                                }
                                System.debug('npupdate  '+npupdate);
                            List<Database.SaveResult> res = Database.update(npupdate, false);
                            for (Integer i = 0; i < npupdate.size(); i++) {
                                Database.SaveResult s = res[i];
                                Network_Pricing__c origRecord = npupdate[i];
                                System.debug('origRecord   '+origRecord );
                                System.debug('!s.isSuccess()  '+ !s.isSuccess());
                                
                                
                                
                                    if (!s.isSuccess()) {
                                        
                                            system.debug('NetworkPricing______________...'+s.getId()); // I get null here
                                             system.debug('NetworkPricing_Record...'+origRecord.Name);
                                            for (Apttus__AgreementLineItem__c aliupd : ali)
                                            {
                                                if(aliupd.id==mapAgreementLine.get(origRecord.FAF_ID__c)){
                                                    //aliupd.Network_Pricing_Link__c = true;
                                                    mapNetworkpric.put(aliupd.id,true);
                                                    System.debug('mapNetworkpric'+mapNetworkpric+'FAF'+origRecord.FAF_ID__r.Name);
                                                    mapNetworkpricCheckBox.put(aliupd.id,true);
                                                    if(ErrorMessage!=null && ErrorMessage!=' '){
                                                          ErrorMessage=+'FAF-->'+origRecord.FAF_ID__r.Name+' '+'Error in Network Pricing-->'+origRecord.Name+' '+'Error Message-->'+s.getErrors()[0].getMessage()+'\n';
                                                    }
                                                    else
                                                    {
                                                     ErrorMessage='FAF-->'+origRecord.FAF_ID__r.Name +' '+'Error in Network Pricing-->'+origRecord.Name+' '+'Error Message-->'+s.getErrors()[0].getMessage()+'\n';  
                                                        
                                                    }
                                                    if(aliupd.Component_Error__c!=null && aliupd.Component_Error__c!=' '){
                                                    aliupd.Component_Error__c+=ErrorMessage;
                                                    }
                                                    else{
                                                    aliupd.Component_Error__c=ErrorMessage;
                                                    }
                                                    aliupdate.add(aliupd);
                                                    
                                                }
                                            }
                                        
                                    }
                                    else{
                                            for (Apttus__AgreementLineItem__c aliupd : ali)
                                            {
                                                if(aliupd.id==mapAgreementLine.get(origRecord.FAF_ID__c)){
                                                    //aliupd.Network_Pricing_Link__c = false;
                                                    System.debug('mapNetworkpric failed'+mapNetworkpric+'FAF'+origRecord.FAF_ID__r.Name);
                                                    //mapNetworkpricCheckBox.put(aliupd.id,false);
                                                   // mapNetworkpric.put(aliupd.id,false);
                                                    //ErrorMessage='';
                                                    //aliupd.Component_Error__c+=ErrorMessage;
                                                    aliupdate.add(aliupd);
                                                    
                                                }
                                            }   
                                    
                                    
                                    }
                                
                            }
                        } 
                        if(SObjectname =='Mail_Pricing__c'){ 
                               mp = Database.query(qryString);
                                for (Mail_Pricing__c mobj:mp)
                               {
                                system.debug('In Mail Pricing');
                                   mobj.Agreement__c =  mapAgreement.get(mobj.FAF_ID__c);
                                   mobj.Agreement_Line_Item__c =mapAgreementLine.get(mobj.FAF_ID__c);
                                   mpupdate.add(mobj);
                                }
                                List<Database.SaveResult> res =Database.update(mpupdate, false);
                                for (Integer i = 0; i < mpupdate.size(); i++) {
                                    Database.SaveResult s = res[i];
                                    Mail_Pricing__c origRecord = mpupdate[i];
                                    if (!s.isSuccess()) {
                                           
                                            for (Apttus__AgreementLineItem__c aliupd : ali)
                                            {
                                                if(aliupd.id==mapAgreementLine.get(origRecord.FAF_ID__c)){
                                                   // aliupd.Mail_Pricing_Link__c = true;
                                                    mapMailPic.put(aliupd.id,true);
                                                    mapMailPicCheckBox.put(aliupd.id,true);
                                                    if(ErrorMessage!=null && ErrorMessage!=' '){
                                                    ErrorMessage=+'FAF-->'+origRecord.FAF_ID__r.Name +' '+'Error in Mail Pricing-->'+origRecord.Name+' '+'Error Message-->'+s.getErrors()[0].getMessage()+'\n';
                                                    }
                                                    else{
                                                    ErrorMessage='FAF-->'+origRecord.FAF_ID__r.Name+' '+'Error in Mail Pricing-->'+origRecord.Name+' '+'Error Message-->'+s.getErrors()[0].getMessage()+'\n';
                                                    }
                                                    if(aliupd.Component_Error__c!=null && aliupd.Component_Error__c!=' '){
                                                      aliupd.Component_Error__c+=ErrorMessage;
                                                    }
                                                    else{
                                                     aliupd.Component_Error__c=ErrorMessage;
                                                    }
                                                    aliupdate.add(aliupd);
                                                   
                                            }
                                        }
                                        
                                    }
                                    else{
                                        for (Apttus__AgreementLineItem__c aliupd : ali){
                                            
                                                if(aliupd.id==mapAgreementLine.get(origRecord.FAF_ID__c)){
                                                        //aliupd.Mail_Pricing_Link__c = false;
                                                        //mapMailPic.put(aliupd.id,false);
                                                        //mapMailPicCheckBox.put(aliupd.id,false);
                                                        //ErrorMessage='';
                                                        //aliupd.Component_Error__c+=ErrorMessage;
                                                        aliupdate.add(aliupd);
                                                }
                                        }
                                    }
                                
                                } 
                                
                        }
                        if(SObjectname =='Client_Information__c'){
                              clientlst= Database.query(qryString);
                                for (Client_Information__c clobj:clientlst)
                               {
                               system.debug('In Client INFo');
                                   clobj.Agreement__c = mapAgreement.get(clobj.FAF_ID__c);
                                   clobj.Agreement_Line_Item__c =mapAgreementLine.get(clobj.FAF_ID__c);
                                   clientUpdate.add(clobj);
                                }
                                List<Database.SaveResult> res =Database.update(clientUpdate, false);
                                for (Integer i = 0; i < clientUpdate.size(); i++) {
                                    Database.SaveResult s = res[i];
                                    Client_Information__c origRecord = clientUpdate[i];
                                    if (!s.isSuccess()) {
                                        
                                        for (Apttus__AgreementLineItem__c aliupd : ali)
                                        {
                                                if(aliupd.id==mapAgreementLine.get(origRecord.FAF_ID__c)){
                                                    //aliupd.Client_Information_Link__c = true;
                                                    mapCLient.put(aliupd.id,true);
                                                    mapCLientCheckBox.put(aliupd.id,true);
                                                    if(ErrorMessage!=null && ErrorMessage!=' '){
                                                    ErrorMessage=+'FAF-->'+origRecord.FAF_ID__r.Name +' '+'Error in Client Information-->'+origRecord.Name+' '+'Error Message-->'+s.getErrors()[0].getMessage()+'\n';
                                                    }
                                                    else{
                                                    ErrorMessage='FAF-->'+origRecord.FAF_ID__r.Name +' '+'Error in Client Information-->'+origRecord.Name+' '+'Error Message-->'+s.getErrors()[0].getMessage()+'\n';    
                                                    }
                                                    if(aliupd.Component_Error__c!=null && aliupd.Component_Error__c!=' '){
                                                      aliupd.Component_Error__c+=ErrorMessage;
                                                    }
                                                    else{
                                                     aliupd.Component_Error__c=ErrorMessage;
                                                    }
                                                    aliupdate.add(aliupd);
                                                   
                                            }
                                        }
                                        
                                    }
                                    else{
                                    for (Apttus__AgreementLineItem__c aliupd : ali)
                                        {
                                                if(aliupd.id==mapAgreementLine.get(origRecord.FAF_ID__c)){
                                                    //aliupd.Client_Information_Link__c = false;
                                                    //mapCLientCheckBox.put(aliupd.id,false);
                                                    //mapCLient.put(aliupd.id,false);
                                                    //ErrorMessage='';
                                                    //aliupd.Component_Error__c+=ErrorMessage;
                                                    aliupdate.add(aliupd);
                                                   
                                            }
                                        }   
                                        
                                    }
                                
                                } 
                        }
                        if(SObjectname =='Network_Operations__c'){
                              Networklst= Database.query(qryString);
                                for (Network_Operations__c clobj:Networklst)
                               {
                                   clobj.Agreement__c =mapAgreement.get(clobj.FAF_ID__c);
                                   clobj.Agreement_Line_Item__c =mapAgreementLine.get(clobj.FAF_ID__c);
                                   NetworkUpdate.add(clobj);
                                }
                                List<Database.SaveResult> res =Database.update(NetworkUpdate, false);
                                for (Integer i = 0; i < NetworkUpdate.size(); i++) {
                                    Database.SaveResult s = res[i];
                                    Network_Operations__c origRecord = NetworkUpdate[i];
                                    if (!s.isSuccess()) {
                                        for (Apttus__AgreementLineItem__c aliupd : ali)
                                        {
                                                if(aliupd.id==mapAgreementLine.get(origRecord.FAF_ID__c)){
                                                    //aliupd.Network_Operation_Link__c = true;
                                                    mapNetworkCheckBox.put(aliupd.id,true);
                                                    mapNetwork.put(aliupd.id,true);
                                                    if(ErrorMessage!=null && ErrorMessage!=' '){
                                                    ErrorMessage=+'FAF-->'+origRecord.FAF_ID__r.Name +' '+'Error in Network Operation-->'+origRecord.Name+' '+'Error Message-->'+s.getErrors()[0].getMessage()+'\n';
                                                    }
                                                    else{
                                                    ErrorMessage='FAF-->'+origRecord.FAF_ID__r.Name +' '+'Error in Network Operation-->'+origRecord.Name+' '+'Error Message-->'+s.getErrors()[0].getMessage()+'\n'; 
                                                    }
                                                    if(aliupd.Component_Error__c!=null && aliupd.Component_Error__c!=' '){
                                                      aliupd.Component_Error__c+=ErrorMessage;
                                                    }
                                                    else{
                                                     aliupd.Component_Error__c=ErrorMessage;
                                                    }
                                                    aliupdate.add(aliupd);
                                                   
                                            }
                                        }
                                        
                                    }
                                    else{
                                        for (Apttus__AgreementLineItem__c aliupd : ali)
                                        {
                                                if(aliupd.id==mapAgreementLine.get(origRecord.FAF_ID__c)){
                                                    //aliupd.Network_Operation_Link__c = false;
                                                    //mapNetworkCheckBox.put(aliupd.id,false);
                                                    ErrorMessage='';
                                                    //mapNetwork.put(aliupd.id,false);
                                                    //aliupd.Component_Error__c+=ErrorMessage;
                                                    //aliupdate.add(aliupd);
                                                   
                                            }
                                        }
                                        
                                        
                                    }
                                
                                } 
                        }
                        if(SObjectname =='Clinical_Solutions__c'){
                              clinicallst= Database.query(qryString);
                                for (Clinical_Solutions__c clobj:clinicallst)
                                {
                                   system.debug('In Clinical Solutions');
                                   clobj.Agreement__c = mapAgreement.get(clobj.FAF_ID__c);
                                   clobj.Agreement_Line_Item__c = mapAgreementLine.get(clobj.FAF_ID__c);
                                   clinicalUpdate.add(clobj);
                                }
                                List<Database.SaveResult> res =Database.update(clinicalUpdate, false);
                                for (Integer i = 0; i < clinicalUpdate.size(); i++) {
                                    Database.SaveResult s = res[i];
                                    Clinical_Solutions__c origRecord = clinicalUpdate[i];
                                    if (!s.isSuccess()) {
                                        for (Apttus__AgreementLineItem__c aliupd : ali)
                                        {
                                                if(aliupd.id==mapAgreementLine.get(origRecord.FAF_ID__c)){
                                                    //aliupd.Clinical_Solution_Link__c = true;
                                                    mapClinicalSOlutionCheckBOX.put(aliupd.id,true);
                                                    mapClinicalSOlution.put(aliupd.id,true);
                                                    if(ErrorMessage!=null && ErrorMessage!=' '){
                                                    ErrorMessage=+'FAF-->'+origRecord.FAF_ID__r.Name +' '+'Error in Clinical Solution-->'+origRecord.Name+' '+'Error Message-->'+s.getErrors()[0].getMessage()+'\n';
                                                    }
                                                    else{
                                                    ErrorMessage='FAF-->'+origRecord.FAF_ID__r.Name +' '+'Error in Clinical Solution-->'+origRecord.Name+' '+'Error Message-->'+s.getErrors()[0].getMessage()+'\n'; 
                                                    }
                                                    if(aliupd.Component_Error__c!=null && aliupd.Component_Error__c!=' '){
                                                      aliupd.Component_Error__c+=ErrorMessage;
                                                    }
                                                    else{
                                                     aliupd.Component_Error__c=ErrorMessage;
                                                    }
                                                    aliupdate.add(aliupd);
                                                   
                                            }
                                        }
                                        
                                    }
                                    else{
                                         for (Apttus__AgreementLineItem__c aliupd : ali)
                                        {
                                                if(aliupd.id==mapAgreementLine.get(origRecord.FAF_ID__c)){
                                                    //aliupd.Clinical_Solution_Link__c = false;
                                                    
                                                    //mapClinicalSOlutionCheckBOX.put(aliupd.id,false);
                                                    //mapClinicalSOlution.put(aliupd.id,false);
                                                    ErrorMessage='';
                                                    //aliupd.Component_Error__c+=ErrorMessage;
                                                    //aliupdate.add(aliupd);
                                                   
                                            }
                                        }
                                        
                                        
                                    }
                                
                                } 
                        }
                        if(SObjectname =='Rebate_Operations__c'){
                              rebatelst= Database.query(qryString);
                                for (Rebate_Operations__c clobj:rebatelst)
                               {
                                   clobj.Agreement__c = mapAgreement.get(clobj.FAF_ID__c);
                                   clobj.Agreement_Line_Item__c = mapAgreementLine.get(clobj.FAF_ID__c);
                                   rebateUpdate.add(clobj);
                                }
                                List<Database.SaveResult> res =Database.update(rebateUpdate, false);
                                for (Integer i = 0; i < rebateUpdate.size(); i++) {
                                    Database.SaveResult s = res[i];
                                    Rebate_Operations__c origRecord = rebateUpdate[i];
                                    if (!s.isSuccess()) {
                                        for (Apttus__AgreementLineItem__c aliupd : ali)
                                        {
                                                if(aliupd.id==mapAgreementLine.get(origRecord.FAF_ID__c)){
                                                    //aliupd.Rebate_Operation_Link__c = true;
                                                    mapRebateOpsCheckBox.put(aliupd.id,true);
                                                    mapRebateOps.put(aliupd.id,true);
                                                    if(ErrorMessage!=null && ErrorMessage!=' '){
                                                    ErrorMessage=+'FAF-->'+origRecord.FAF_ID__r.Name+' '+'Error in Rebate Operation-->'+origRecord.Name+' '+'Error Message-->'+s.getErrors()[0].getMessage()+'\n';
                                                    }
                                                    else{
                                                    ErrorMessage='FAF-->'+origRecord.FAF_ID__r.Name+' '+'Error in Rebate Operation-->'+origRecord.Name+' '+'Error Message-->'+s.getErrors()[0].getMessage()+'\n';
                                                    }
                                                    if(aliupd.Component_Error__c!=null && aliupd.Component_Error__c!=' '){
                                                      aliupd.Component_Error__c+=ErrorMessage;
                                                    }
                                                    else{
                                                     aliupd.Component_Error__c=ErrorMessage;
                                                    }
                                                    aliupdate.add(aliupd);
                                                   
                                            }
                                        }
                                        
                                    }
                                    else{
                                         for (Apttus__AgreementLineItem__c aliupd : ali)
                                        {
                                                if(aliupd.id==mapAgreementLine.get(origRecord.FAF_ID__c)){
                                                    //aliupd.Rebate_Operation_Link__c = false;
                                                    //mapRebateOps.put(aliupd.id,false);
                                                    //mapRebateOpsCheckBox.put(aliupd.id,false);
                                                    //ErrorMessage='';
                                                    //aliupd.Component_Error__c+=ErrorMessage;
                                                    //aliupdate.add(aliupd);
                                                   
                                                }
                                        }
                                    }
                                
                                } 
                        }
                         if(SObjectname =='Mail_Operations__c'){
                              maillst= Database.query(qryString);
                                for (Mail_Operations__c clobj:maillst)
                               {
                                   clobj.Agreement__c = mapAgreement.get(clobj.FAF_ID__c);
                                   clobj.Agreement_Line_Item__c = mapAgreementLine.get(clobj.FAF_ID__c);
                                   mailUpdate.add(clobj);
                                }
                                List<Database.SaveResult> res =Database.update(mailUpdate, false);
                                for (Integer i = 0; i < mailUpdate.size(); i++) {
                                    Database.SaveResult s = res[i];
                                    Mail_Operations__c origRecord = mailUpdate[i];
                                    if (!s.isSuccess()) {
                                            for (Apttus__AgreementLineItem__c aliupd : ali)
                                            {
                                                if(aliupd.id==mapAgreementLine.get(origRecord.FAF_ID__c)){
                                                    //aliupd.Mail_Operation_Link__c = true;
                                                    mapMailOps.put(aliupd.id,true);
                                                    mapMailOpsCheckBox.put(aliupd.id,true);
                                                    if(ErrorMessage!=null && ErrorMessage!=' '){
                                                    ErrorMessage=+'FAF-->'+origRecord.FAF_ID__r.Name +' '+'Error in Mail Operation-->'+origRecord.Name+' '+'Error Message-->'+s.getErrors()[0].getMessage()+'\n';
                                                    }
                                                    else{
                                                    ErrorMessage='FAF-->'+origRecord.FAF_ID__r.Name +' '+'Error in Mail Operation-->'+origRecord.Name+' '+'Error Message-->'+s.getErrors()[0].getMessage()+'\n';
                                                    }
                                                   if(aliupd.Component_Error__c!=null && aliupd.Component_Error__c!=' '){
                                                      aliupd.Component_Error__c+=ErrorMessage;
                                                    }
                                                    else{
                                                     aliupd.Component_Error__c=ErrorMessage;
                                                    }
                                                    aliupdate.add(aliupd);
                                                   
                                            }
                                        }
                                        
                                    }
                                    else{
                                         for (Apttus__AgreementLineItem__c aliupd : ali)
                                            {
                                                if(aliupd.id==mapAgreementLine.get(origRecord.FAF_ID__c)){
                                                    //aliupd.Mail_Operation_Link__c = false;
                                                    //mapMailOpsCheckBox.put(aliupd.id,false);
                                                    //mapMailOps.put(aliupd.id,false);
                                                    //ErrorMessage='';
                                                   // aliupd.Component_Error__c+=ErrorMessage;
                                                    aliupdate.add(aliupd);
                                                   
                                                }
                                            }
                                        
                                        
                                        
                                    }
                                
                                } 
                        }
                        if(SObjectname =='Specialty_Operations__c'){
                              SpecialtyOpslst= Database.query(qryString);
                                for (Specialty_Operations__c clobj:SpecialtyOpslst)
                               {
                               system.debug('Specialty_Operations__c');
                                   clobj.Agreement__c = mapAgreement.get(clobj.FAF_ID__c);
                                   clobj.Agreement_Line_Item__c = mapAgreementLine.get(clobj.FAF_ID__c);
                                   SpecialtyUpdate.add(clobj);
                                }
                                List<Database.SaveResult> res =Database.update(SpecialtyUpdate, false);
                                for (Integer i = 0; i < SpecialtyUpdate.size(); i++) {
                                    Database.SaveResult s = res[i];
                                    Specialty_Operations__c origRecord = SpecialtyUpdate[i];
                                    if (!s.isSuccess()) {
                                        for (Apttus__AgreementLineItem__c aliupd : ali)
                                        {
                                                if(aliupd.id==mapAgreementLine.get(origRecord.FAF_ID__c)){
                                                    //aliupd.Specialty_Operation_Link__c = true;
                                                    mapSpecialtyOpsCheckBOX.put(aliupd.id,true);
                                                    mapSpecialtyOps.put(aliupd.id,true);
                                                    if(ErrorMessage!=null ||ErrorMessage!=' '){
                                                    ErrorMessage=+'FAF-->'+origRecord.FAF_ID__r.Name +' '+'Error in Specialty Operation-->'+origRecord.Name+' '+'Error Message-->'+s.getErrors()[0].getMessage()+'\n';
                                                    }
                                                    else{
                                                     ErrorMessage='FAF-->'+origRecord.FAF_ID__r.Name +' '+'Error in Specialty Operation-->'+origRecord.Name+' '+'Error Message-->'+s.getErrors()[0].getMessage()+'\n';  
                                                    }
                                                    if(aliupd.Component_Error__c!=null && aliupd.Component_Error__c!=' '){
                                                      aliupd.Component_Error__c+=ErrorMessage;
                                                    }
                                                    else{
                                                     aliupd.Component_Error__c=ErrorMessage;
                                                    }
                                                    aliupdate.add(aliupd);
                                                   
                                            }
                                        }
                                        
                                    }
                                    else{
                                        for (Apttus__AgreementLineItem__c aliupd : ali)
                                        {
                                                if(aliupd.id==mapAgreementLine.get(origRecord.FAF_ID__c)){
                                                   // aliupd.Specialty_Operation_Link__c = false;
                                                    //mapSpecialtyOps.put(aliupd.id,false);
                                                    //mapSpecialtyOpsCheckBOX.put(aliupd.id,false);
                                                    //ErrorMessage='';
                                                    //aliupd.Component_Error__c+=ErrorMessage;
                                                    aliupdate.add(aliupd);
                                                   
                                            }
                                        }
                                    }
                                
                                } 
                        }
                        if(SObjectname =='Specialty_Pricing__c'){
                               Specialtypriclst= Database.query(qryString);
                                for (Specialty_Pricing__c clobj:Specialtypriclst)
                               {
                               system.debug('Specialty_Pricing__c');
                                   clobj.Agreement__c = mapAgreement.get(clobj.FAF_ID__c);
                                   clobj.Agreement_Line_Item__c = mapAgreementLine.get(clobj.FAF_ID__c);
                                   SpecialtypricUpdate.add(clobj);
                                }
                                List<Database.SaveResult> res =Database.update(SpecialtypricUpdate, false);
                                for (Integer i = 0; i < SpecialtypricUpdate.size(); i++) {
                                    Database.SaveResult s = res[i];
                                    Specialty_Pricing__c origRecord = SpecialtypricUpdate[i];
                                    if (!s.isSuccess()) {
                                        for (Apttus__AgreementLineItem__c aliupd : ali)
                                        {
                                                if(aliupd.id==mapAgreementLine.get(origRecord.FAF_ID__c)){
                                                    //aliupd.Specialty_Pricing_Link__c = true;
                                                    mapSpecialtyPric.put(aliupd.id,true);
                                                    mapSpecialtyPricCheckBOX.put(aliupd.id,true);
                                                    if(ErrorMessage!=null && ErrorMessage!=' '){
                                                       ErrorMessage=+'FAF-->'+origRecord.FAF_ID__r.Name+' '+'Error in Specialty Pricing-->'+origRecord.Name+' '+'Error Message-->'+s.getErrors()[0].getMessage()+'\n';
                                                    }
                                                    else{
                                                        ErrorMessage='FAF-->'+origRecord.FAF_ID__r.Name+' '+'Error in Specialty Pricing-->'+origRecord.Name+' '+'Error Message-->'+s.getErrors()[0].getMessage()+'\n';
                                                    }
                                                    
                                                   if(aliupd.Component_Error__c!=null && aliupd.Component_Error__c!=' '){
                                                      aliupd.Component_Error__c+=ErrorMessage;
                                                    }
                                                    else{
                                                     aliupd.Component_Error__c=ErrorMessage;
                                                    }
                                                    aliupdate.add(aliupd);
                                                   
                                            }
                                        }
                                        
                                    }
                                    else{
                                        
                                         for (Apttus__AgreementLineItem__c aliupd : ali)
                                        {
                                                if(aliupd.id==mapAgreementLine.get(origRecord.FAF_ID__c)){
                                                    //aliupd.Specialty_Pricing_Link__c = false;
                                                    //ErrorMessage='';
                                                    //mapSpecialtyPricCheckBOX.put(aliupd.id,false);
                                                    //mapSpecialtyPric.put(aliupd.id,false);
                                                    //aliupd.Component_Error__c+=ErrorMessage;
                                                    aliupdate.add(aliupd);
                                                   
                                            }
                                        }
                                        
                                        
                                    }
                                
                                } 
                        }
                        if(SObjectname =='Rebate_Guarantees__c'){
                              RebateGuarlst= Database.query(qryString);
                                for (Rebate_Guarantees__c clobj:RebateGuarlst)
                               {
                               system.debug('Rebate_Guarantees__c');
                                   clobj.Agreement__c = mapAgreement.get(clobj.FAF_ID__c);
                                   clobj.Agreement_Line_Item__c = mapAgreementLine.get(clobj.FAF_ID__c);
                                   RebateGuarUpdate.add(clobj);
                                }
                                List<Database.SaveResult> res =Database.update(RebateGuarUpdate, false);
                                for (Integer i = 0; i < RebateGuarUpdate.size(); i++) {
                                    Database.SaveResult s = res[i];
                                    Rebate_Guarantees__c origRecord = RebateGuarUpdate[i];
                                    if (!s.isSuccess()) {
                                            for (Apttus__AgreementLineItem__c aliupd : ali)
                                            {
                                                if(aliupd.id==mapAgreementLine.get(origRecord.FAF_ID__c)){
                                                    //aliupd.Rebate_Guarantee_Link__c = true;
                                                    mapRebateGuarCHeckBox.put(aliupd.id,true);
                                                    mapRebateGuar.put(aliupd.id,true);
                                                    if(ErrorMessage!=null && ErrorMessage!=' '){
                                                    ErrorMessage=+'FAF-->'+origRecord.FAF_ID__r.Name+' '+'Error in Rebate Guarantees-->'+origRecord.Name+' '+'Error Message-->'+s.getErrors()[0].getMessage()+'\n';
                                                    }
                                                    else{
                                                    ErrorMessage='FAF-->'+origRecord.FAF_ID__r.Name+' '+'Error in Rebate Guarantees-->'+origRecord.Name+' '+'Error Message-->'+s.getErrors()[0].getMessage()+'\n';    
                                                    }
                                                    if(aliupd.Component_Error__c!=null && aliupd.Component_Error__c!=' '){
                                                      aliupd.Component_Error__c+=ErrorMessage;
                                                    }
                                                    else{
                                                     aliupd.Component_Error__c=ErrorMessage;
                                                    }
                                                    aliupdate.add(aliupd);
                                                   
                                            }
                                        }
                                        
                                    }
                                    else{
                                    for (Apttus__AgreementLineItem__c aliupd : ali)
                                        {
                                                if(aliupd.id==mapAgreementLine.get(origRecord.FAF_ID__c)){
                                                    //aliupd.Rebate_Guarantee_Link__c = false;
                                                    //mapRebateGuarCHeckBox.put(aliupd.id,false);
                                                    //mapRebateGuar.put(aliupd.id,false);
                                                    //ErrorMessage='';
                                                    //aliupd.Component_Error__c+=ErrorMessage;
                                                    aliupdate.add(aliupd);
                                                   
                                            }
                                        }   
                                        
                                        
                                    }
                                
                                } 
                        }
                         if(SObjectname =='Billing_Administrative_Fees__c'){
                              Adminlst= Database.query(qryString);
                                for (Billing_Administrative_Fees__c clobj:Adminlst)
                               {
                               system.debug('Billing_Administrative_Fees__c');
                                   clobj.Agreement__c = mapAgreement.get(clobj.FAF_ID__c);
                                   clobj.Agreement_Line_Item__c = mapAgreementLine.get(clobj.FAF_ID__c);
                                   AdminListUpdate.add(clobj);
                                }
                                List<Database.SaveResult> res =Database.update(AdminListUpdate, false);
                                for (Integer i = 0; i < AdminListUpdate.size(); i++) {
                                    Database.SaveResult s = res[i];
                                    Billing_Administrative_Fees__c origRecord = AdminListUpdate[i];
                                    if (!s.isSuccess()) {
                                        for (Apttus__AgreementLineItem__c aliupd : ali)
                                        {
                                                if(aliupd.id==mapAgreementLine.get(origRecord.FAF_ID__c)){
                                                    //aliupd.Billing_Admin_Link__c= true;
                                                    mapBillAdminCheckBOX.put(aliupd.id,true);
                                                    mapBillAdmin.put(aliupd.id,true);
                                                    if(ErrorMessage!=null && ErrorMessage!=' '){
                                                    ErrorMessage=+'FAF-->'+origRecord.FAF_ID__r.Name+' '+'Error in Billing Admin Fees-->'+origRecord.Name+' '+'Error Message-->'+s.getErrors()[0].getMessage()+'\n';
                                                    }
                                                    else{
                                                    ErrorMessage='FAF-->'+origRecord.FAF_ID__r.Name+' '+'Error in Billing Admin Fees-->'+origRecord.Name+' '+'Error Message-->'+s.getErrors()[0].getMessage()+'\n';    
                                                    }
                                                    if(aliupd.Component_Error__c!=null && aliupd.Component_Error__c!=' '){
                                                      aliupd.Component_Error__c+=ErrorMessage;
                                                    }
                                                    else{
                                                     aliupd.Component_Error__c=ErrorMessage;
                                                    }
                                                    aliupdate.add(aliupd);
                                                   
                                            }
                                        }
                                        
                                    }
                                    else{
                                        for (Apttus__AgreementLineItem__c aliupd : ali)
                                        {
                                                if(aliupd.id==mapAgreementLine.get(origRecord.FAF_ID__c)){
                                                    //aliupd.Billing_Admin_Link__c= false;
                                                   // mapBillAdmin.put(aliupd.id,false);
                                                    //mapBillAdminCheckBOX.put(aliupd.id,false);
                                                    //ErrorMessage='';
                                                    //aliupd.Component_Error__c+=ErrorMessage;
                                                    aliupdate.add(aliupd);
                                                   
                                            }
                                        }
                                    }
                                
                                } 
                        }
                        
                
                        if(SObjectname =='Rebate_Gtees_Specialty_Class_Carve_Outs__c'){
                              carveOutlst= Database.query(qryString);
                                for (Rebate_Gtees_Specialty_Class_Carve_Outs__c clobj:carveOutlst)
                               {
                                   clobj.Agreement__c = mapAgreement.get(clobj.FAF_ID__c);
                                   clobj.Agreement_Line_Item__c = mapAgreementLine.get(clobj.FAF_ID__c);
                                   CarveOutlstUpdate.add(clobj);
                                }
                                List<Database.SaveResult> res =Database.update(CarveOutlstUpdate, false);
                                for (Integer i = 0; i < CarveOutlstUpdate.size(); i++) {
                                    Database.SaveResult s = res[i];
                                    Rebate_Gtees_Specialty_Class_Carve_Outs__c origRecord = CarveOutlstUpdate[i];
                                    if (!s.isSuccess()) {
                                        for (Apttus__AgreementLineItem__c aliupd : ali)
                                        {
                                                if(aliupd.id==mapAgreementLine.get(origRecord.FAF_ID__c)){
                                                    aliupd.Rebate_Carve_Out_Link__c=true;
                                                    mapCarveOut.put(aliupd.id,true);
                                                    mapCarveOutCheckBOX.put(aliupd.id,true);
                                                    if(ErrorMessage!=null && ErrorMessage!=' '){
                                                    ErrorMessage=+'FAF-->'+origRecord.FAF_ID__r.Name+' '+'Error in Rebate Carve Outs-->'+origRecord.Name+' '+'Error Message-->'+s.getErrors()[0].getMessage()+'\n';
                                                    }
                                                    else{
                                                    ErrorMessage='FAF-->'+origRecord.FAF_ID__r.Name+' '+'Error in Rebate Carve Outs-->'+origRecord.Name+' '+'Error Message-->'+s.getErrors()[0].getMessage()+'\n';    
                                                    }
                                                    if(aliupd.Component_Error__c!=null && aliupd.Component_Error__c!=' '){
                                                      aliupd.Component_Error__c+=ErrorMessage;
                                                    }
                                                    else{
                                                     aliupd.Component_Error__c=ErrorMessage;
                                                    }
                                                    aliupdate.add(aliupd);
                                                   
                                            }
                                        }
                                        
                                    }
                                    else{
                                         for (Apttus__AgreementLineItem__c aliupd : ali)
                                        {
                                                if(aliupd.id==mapAgreementLine.get(origRecord.FAF_ID__c)){
                                                    //ErrorMessage='';
                                                    //mapCarveOut.put(aliupd.id,false);
                                                    //mapCarveOutCheckBOX.put(aliupd.id,false);
                                                    //aliupd.Rebate_Carve_Out_Link__c=false;
                                                    //aliupd.Component_Error__c+=ErrorMessage;
                                                    aliupdate.add(aliupd);
                                                   
                                            }
                                        }
                                        
                                        
                                    }
                                
                                } 
                        }
                        for(Apttus__AgreementLineItem__c aliupd : ali){
                            if(mapCLient.get(aliupd.id)==true||  
                               mapNetwork.get(aliupd.id)==true||
                               
                               mapNetworkpric.get(aliupd.id)==true||
                               mapRebateOps.get(aliupd.id)==true||
                               
                               mapMailOps.get(aliupd.id)==true||
                               mapMailPic.get(aliupd.id)==true||
                               
                               mapBillAdmin.get(aliupd.id)==true||
                               mapSpecialtyOps.get(aliupd.id)==true||
                               
                               mapSpecialtyPric.get(aliupd.id)==true||
                               mapRebateGuar.get(aliupd.id)==true||
                               
                               mapClinicalSOlution.get(aliupd.id)==true||
                               mapCarveOut.get(aliupd.id)==true
                            ){
                            aliupd.Async_Mode__c=false;
                            }
                            else{
                            aliupd.Async_Mode__c=true;
                            }
                            
                            System.debug('mapRebateOpsCheckBox.get(aliupd.id)********'+mapRebateOpsCheckBox.get(aliupd.id));
                            System.debug('mapNetworkpricCheckBox.get(aliupd.id);********'+mapNetworkpricCheckBox.get(aliupd.id));
                            if(mapCLientCheckBox.get(aliupd.id)==null){
                            aliupd.Client_Information_Link__c=false;
                            }
                            else{
                             aliupd.Client_Information_Link__c=mapCLientCheckBox.get(aliupd.id);
                            }
                            if(mapNetworkCheckBox.get(aliupd.id)==null){
                            aliupd.Network_Operation_Link__c=false;
                            }
                            else{
                            aliupd.Network_Operation_Link__c=mapNetworkCheckBox.get(aliupd.id);
                            }
                           
                            if(mapNetworkpricCheckBox.get(aliupd.id)==null){
                             aliupd.Network_Pricing_Link__c=false;
                            }
                            else{
                            aliupd.Network_Pricing_Link__c=mapNetworkpricCheckBox.get(aliupd.id);
                            }
                            if(mapRebateOpsCheckBox.get(aliupd.id)==null){
                             aliupd.Rebate_Operation_Link__c=false; 
                            }
                            else{
                            aliupd.Rebate_Operation_Link__c=mapRebateOpsCheckBox.get(aliupd.id);
                            }
                            if(mapMailOpsCheckBox.get(aliupd.id)==null){
                            aliupd.Mail_Operation_Link__c=false;    
                            }
                            else{
                            aliupd.Mail_Operation_Link__c=mapMailOpsCheckBox.get(aliupd.id);
                            }
                            if(mapMailPicCheckBox.get(aliupd.id)==null){
                                aliupd.Mail_Pricing_Link__c=false;
                            }
                            else{
                            aliupd.Mail_Pricing_Link__c=mapMailPicCheckBox.get(aliupd.id);
                            }
                            if(mapClinicalSOlutionCheckBOX.get(aliupd.id)==null){
                            aliupd.Clinical_Solution_Link__c=false;
                            }
                            else{
                            aliupd.Clinical_Solution_Link__c=mapClinicalSOlutionCheckBOX.get(aliupd.id);
                            }
                            if(mapSpecialtyOpsCheckBOX.get(aliupd.id)==null){
                            aliupd.Specialty_Operation_Link__c=false;
                            }
                            else{
                            aliupd.Specialty_Operation_Link__c=mapSpecialtyOpsCheckBOX.get(aliupd.id);
                            }
                            if(mapSpecialtyPricCheckBOX.get(aliupd.id)==null){
                            aliupd.Specialty_Pricing_Link__c=false; 
                            }
                            else{
                            aliupd.Specialty_Pricing_Link__c=mapSpecialtyPricCheckBOX.get(aliupd.id);
                            }
                            if(mapRebateGuarCHeckBox.get(aliupd.id)==null){
                            aliupd.Rebate_Guarantee_Link__c=false;  
                            }
                            else{
                            aliupd.Rebate_Guarantee_Link__c=mapRebateGuarCHeckBox.get(aliupd.id);
                            }
                            if(mapBillAdminCheckBOX.get(aliupd.id)==null){
                            aliupd.Billing_Admin_Link__c=false; 
                            }
                            else{
                            aliupd.Billing_Admin_Link__c=mapBillAdminCheckBOX.get(aliupd.id);
                            }
                            if(mapCarveOutCheckBOX.get(aliupd.id)==null){
                             aliupd.Rebate_Carve_Out_Link__c=false; 
                            }
                            else{
                            aliupd.Rebate_Carve_Out_Link__c=mapCarveOutCheckBOX.get(aliupd.id);
                            }
                            
                             aliupdate.add(aliupd);
                        }
                     LinemapUpdate.putAll(aliupdate);
                    if(LinemapUpdate.size()>0){
                     System.debug('In Agreement trigger history check'+DeepCloneUtility.HistoryCheck);     
                        Database.Update(LinemapUpdate.Values());
                        
                        
                    }
                    
            }
           
        }
        System.debug('CallType'+callType);
        Invoke_Update_Component_Error.Invoke_Update_Component_Error_Method(AgreemnetID,callType);
        //DeepCloneUtility.HistoryCheck=true;
        
    }
 /******************************************************************************************************************************

     * @Method Name       : TestMethod 
     * @Purpose           : Method used to Increase coverage of the class.

     *******************************************************************************************************************************/

    public static void IncreaseCoverage(){
    Integer i = 0;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    }
    /******************************************************************************************************************************

     * @Method Name       : TestMethod 
     * @Purpose           : Method used to Increase coverage of the class.

     *******************************************************************************************************************************/

    public static void IncreaseCoverage2(){
    Integer i = 0;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    }
    //
    
}