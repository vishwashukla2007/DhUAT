/******************************************************************************************************************************
* Name        - PegaIpiWaSOAPcall
* Description - Integration call from SFDC to PEGA using WSDL class pegarulesSoapWAserviceSer
* TestClass - PegaIpiWaSOAPcallTest,TestPegarulesSoapMockImpl

* Modification Log :
* ---------------------------------------------------------------------------
* Developer                              Date                   Description
* ---------------------------------------------------------------------------
* Sai Sivamgula                        09/10/2018               Created

*******************************************************************************************************************************/
Global Class PegaIpiWaSOAPcall{
    
    @FUTURE(callOut = true)
    webservice static void callPegaWAIPI(String IPIwaID){
        String ecsId = null;
        try {
        
        IPI_WA_Tasks__c IPIWATasks = [Select Id,FAF_ID__c,Task_Case_ID__c,Task_ID__c,Work_Assignment_Case_ID__c,Work_Assignment_ID__c from IPI_WA_Tasks__c where id =: IPIwaID limit 1];
        if (IPIWATasks != null){
                string CompPercent = '100';
                string FAFid = IPIWATasks.FAF_ID__c;
                string TCaseID =  IPIWATasks.Task_Case_ID__c;
                string TID =  IPIWATasks.Task_ID__c;
                string WACaseId=  IPIWATasks.Work_Assignment_Case_ID__c;
                string WAId=  IPIWATasks.Work_Assignment_ID__c ;
                Messaging.SingleEmailMessage mail=new Messaging.SingleEmailMessage();
                mail.setTargetObjectId(UserInfo.getUserid());
                mail.setSaveAsActivity(false);
                mail.setSenderDisplayName('No Reply');
        
                pegarulesSoapWAserviceSer.Responses_element[] res = new pegarulesSoapWAserviceSer.Responses_element[]{};
                pegarulesSoapWAserviceSer.Responses_element res1 = new pegarulesSoapWAserviceSer.Responses_element();
                
                pegarulesSoapWAserviceSer.ServicesPortSOAP eCS = new pegarulesSoapWAserviceSer.ServicesPortSOAP();
                //eCS.endpoint_x = 'https://cvs-16.pegacloud.com:443/prweb/PRSOAPServlet/SOAP/WorkAssignmentService/Services';
                Org_Constants__c og = Org_Constants__c.getInstance('Pega_IPI'); 
                eCS.endpoint_x = (UserInfo.getOrganizationId() == '00DA0000000JK7rMAG')? og.Prod_Value__c : og.Non_Prod_Value__c; //need to update org id
                
                res = eCS.WorkAssignmentService(CompPercent,FAFid,TCaseID,TID,WACaseId,WAId);
                System.Debug('Webservice called');
                System.Debug('res'+res);
                res1 = res[0];
                System.Debug('res1'+res1.ResponseMessage);
                
                if (res1.ResponseMessage != 'Success' || res1.ResponseMessage != 'success'){
                 string body = 'PEGA IPI call failed for record : <B>'+IPIwaID+'.</B> Repsonse code from PEGA : <B>'+res1.ResponseCode+'.</B>Repsonse message from PEGA : <B>'+res1.ResponseMessage;
                 body += '<BR/><BR/>*****SalesForce Auto-Generated Message.*****';
                 
                 mail.setSubject('PEGA IPI-WA call failed for record '+IPIwaID+'Error from Apttus salesforce Org: ' + UserInfo.getOrganizationID());
                 mail.setHtmlBody(Body);
                 Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail }); 
                
                }
        }        
        }catch (exception e){
         
         // Email in case of failure 
         String body2 = e.getmessage();
         body2 += '<BR/><BR/>*****SalesForce Auto-Generated Message.*****';
         Messaging.SingleEmailMessage mail2=new Messaging.SingleEmailMessage();
         mail2.setTargetObjectId(UserInfo.getUserid());
         mail2.setSaveAsActivity(false);
         mail2.setSenderDisplayName('No Reply');
         mail2.setSubject('PEGA IPI-WA call Exception occured for record '+IPIwaID+'Error from Apttus salesforce Org: ' + UserInfo.getOrganizationID());
         mail2.setPlainTextBody(body2);
         Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail2 }); 
                
        }        
        //return ecsId;    
    }
}