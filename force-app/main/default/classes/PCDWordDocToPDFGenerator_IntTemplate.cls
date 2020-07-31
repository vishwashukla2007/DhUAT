/* =================================================================================
 * @Class Name        : PCDWordDocToPDFGenerator
 * @author            : Mohit Srivastava(Accenture)
 * @created date      : 09/12/2019
 * @Purpose           : Convert PCD agrementline item in to PDF
=======================================================================================*/
Global with sharing class PCDWordDocToPDFGenerator_IntTemplate {
     /*=================================================================================
 * @Method Name       : convertWordToPDF
 * @author            : Mohit Srivastava(Accenture)
 * @created date      : 09/12/2019
 * @Last modified by  : Mohit Srivastava(Accenture)
=======================================================================================*/
    @InvocableMethod             
    public static void convertWordToPDF_IntTemplate(List<Id> AgreementID) {
    /*
        set<ID> ids=new set<ID>();
        set<ID> lineids=new set<ID>();
        
        
            for(Id ides:AgreementID){
                ids.add(ides);
            }
            List<Apttus__AgreementLineItem__c> agreementLine=[Select ID,LOB_Detail__c from Apttus__AgreementLineItem__c where Apttus__AgreementId__c IN:ids];
            for(Apttus__AgreementLineItem__c agl:agreementLine){
                lineids.add(agl.id);
            }
            for(Apttus__APTS_Agreement__c fp: [Select id,Primary_Agreement_Line_Item__c from Apttus__APTS_Agreement__c where id IN:AgreementID]) {  
            String LastPCD=fp.Primary_Agreement_Line_Item__c;
                boolean found = false;                          
                for (Apttus__APTS_Template__c tpl: [Select Next_Template__c, Apttus__IsActive__c, Apttus__BusinessObject__c from Apttus__APTS_Template__c where Apttus__IsActive__c = True and Name=:Label.PCD_Template_Name]) {                                  
                    
                    for(id agid : ids){
                    ID sObjectId = fp.ID; //Agreement               
                    system.debug('::sObjectId::'+sObjectId);
                    String sObjectType = tpl.Apttus__BusinessObject__c;               
                    String pLevel = 'Full Access';
                    String docFormat = Label.PCD_Print_Document_Type;
                    if (docFormat == null || Test.isRunningTest())
                         docFormat = 'PDF';
                    Boolean isDraft = true;
                    String sessionId = UserInfo.getSessionId(); 
                    String serverUrl = System.Url.getSalesforceBaseUrl().toExternalForm() + Label.Print_Merge_Service + UserInfo.getOrganizationId();
                    system.debug('::OrgId::'+UserInfo.getOrganizationId());
                    system.debug('::url::'+serverUrl );
                    try{ 
                    if(!Test.isRunningTest()) { 
                        ID docId2 = Apttus.MergeWebService.submitGenerateCustomDoc(tpl.id, sObjectId,sObjectType,pLevel,docFormat,isDraft,sessionId,serverUrl);
                        update fp; 
                    }
                    }Catch(Exception e){
                        system.debug('::docId2::'+e.getMessage());
                    }
                    found = true;
                    }
                    //fp.Primary_Agreement_Line_Item__c=LastPCD;
                    //update fp;
                }
            }
            */
    }
}