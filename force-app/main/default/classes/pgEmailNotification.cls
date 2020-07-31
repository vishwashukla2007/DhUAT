public without sharing class pgEmailNotification {
    @InvocableMethod
    public static void pgEmail(List<string> Id){
        List<String> toAddress = new List<string>();
        toAddress.add(label.Performance_Guarantee_Email);
        List<String> cc =new List<string>();
        List<String> bcc =new List<string>();
        list<Performance_Guarantees__c> pgRec = [select id, Client_Agreement_Name__c, FAF__r.Name from Performance_Guarantees__c where id=:Id[0] limit 1];
        string instanceURLString = URL.getSalesforceBaseUrl().toExternalForm();
        string body ='FAF '+ pgRec[0].FAF__r.Name +' requires a Performance Guarantee Contract <a href="'+instanceURLString+'/'+pgRec[0].id+'">click here</a> to open, update, and start the Performance Guarantee flow.';
        string subject = 'Performance Guarantee requested for ' + pgRec[0].Client_Agreement_Name__c;
        sendEmail(toAddress, subject,cc, bcc, body);

       
    }
    public static void sendEmail(List<String> toAddress, String subject, List<String> cc, List<String> bcc, string body){
        try{
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                list<OrgWideEmailAddress> owea = [select Id from OrgWideEmailAddress where DisplayName = 'CVS Official (Do Not Reply)'];
                mail.setToAddresses(toAddress);
                mail.setCcAddresses(cc);
                mail.setSubject(subject);
                mail.setHtmlBody(body);
                if(bcc.size() > 0){
                    mail.setBccAddresses(bcc);
                }
                if(cc.size() > 0){
                    mail.setCcAddresses(cc);
                }
                if (owea.size() > 0 ) {
                    mail.setOrgWideEmailAddressId(owea[0].Id);
                }
                mail.setSaveAsActivity(false);
                
                List<Messaging.SingleEmailMessage> email = new List<Messaging.SingleEmailMessage>();
                email.add(mail);
                Messaging.sendEmail(email);
        }
        		
        catch(Exception err)
        {
            System.debug(err);
        }
    }
    
}