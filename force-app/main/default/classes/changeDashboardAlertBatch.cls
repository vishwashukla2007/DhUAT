global class changeDashboardAlertBatch implements database.batchable<sobject> , Database.Stateful {
	Public string soqlquery;
    Public id agreeId;
    Public string recTypeName = 'Legal';
    Public map<id,string> errors_map = new map<id,string>();
    Public Boolean PublicIsForceRun;
    Public Boolean PubIsBatchJob = true;
    Public list<string> statCategory = new list<string>{'Request','In Authoring','In Signatures','In Filing','In Effect'};
    Public OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where DisplayName = 'CVS Official (Do Not Reply)'];
 	Public changeDashboardAlertBatch (String AgreementId, Boolean IsForceRun){
        if(IsForceRun){
            PublicIsForceRun = IsForceRun;
            if(AgreementId != null){
                this.agreeId = AgreementId;
                this.soqlquery = 'SELECT Id, PBM_FAF__c FROM Apttus__APTS_Agreement__c WHERE Id =:agreeId';
            }else{
                this.soqlquery = 'SELECT Id, PBM_FAF__c FROM Apttus__APTS_Agreement__c WHERE PBM_FAF__c != null AND RecordType.Name =:recTypeName AND FAF_Data_Sync__c = true AND Apttus__Status_Category__c IN :statCategory';
            }
        }else{
            this.soqlquery = 'SELECT Id, PBM_FAF__c FROM Apttus__APTS_Agreement__c WHERE PBM_FAF__c != null AND RecordType.Name =:recTypeName AND FAF_Data_Sync__c = true AND Apttus__Status_Category__c IN :statCategory';
        }
 	}
    global database.querylocator start(database.batchableContext bc){
    	return database.getquerylocator(soqlquery);
 	}
    
    global void execute(database.batchablecontext bd, list<Apttus__APTS_Agreement__c> agreeList){  
        changeDashboardWrapper.wrapperClass b = changeDashboardWrapper.compareAgreementAndFAF(PubIsBatchJob, agreeId ,agreeList,owea, PublicIsForceRun);
        if(b.errors_map != null){
            if(b.errors_map.size()>0){
                for(id eachErr : b.errors_map.keySet()){
                    errors_map.put(eachErr,b.errors_map.get(eachErr));
                }
            } 
        }  
 	}
    
    Public void finish(database.batchableContext bc){
        if(errors_map.size()>0 && System.Label.changeDashboardAlertErrorRecipient != null){
            //Create Email body parameters Parameters
            List<String> errRec = System.Label.changeDashboardAlertErrorRecipient.split(';');
            
            string recIdLink = '';
            string ErrfieldTR = '';
            for(string eachRec : errors_map.keyset()){ 
                recIdLink = '<a href="' + URL.getSalesforceBaseUrl().toExternalForm() + '/' + eachRec + '">' + eachRec + '</a>';
                ErrfieldTR += '<tr>';
                ErrfieldTR += '<td align="center">' + recIdLink + '</td>';
                ErrfieldTR += '<td align="center">' + errors_map.get(eachRec) + '</td>';
                ErrfieldTR += '</tr>';  
            }
            
            string ErrParam1 = 'Hi - ';
            ErrParam1 += 'Below error/s occured during processing of CLM change dashboard Alert';
            
            String body='';
            body += '<html><body>';
            body += ErrParam1;
            body += '<br/>';
            body += '<br/>'; 
            body += '<table border="1" width = "100%">';
            body += '<tr><th bgcolor="yellow">Record Id</th>';
            body += '<th bgcolor="yellow">Error Message</th></tr>';
            body += ErrfieldTR;
            body += '</table>';
            body += '<br/>';
            body += '<br/>';
            body += '--- Please do not reply ---';
            body += '</body></html>';
            
                 
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            if (owea.size() > 0 ) {
                mail.setOrgWideEmailAddressId(owea.get(0).Id);
            }
            mail.setToAddresses(errRec);
            mail.setSubject('Errors occurred during batch process.');
            mail.setHtmlBody(body);
            Messaging.sendEmail(new Messaging.Singleemailmessage [] {mail});
        }
    }
}