// In a separate class so that it can be used elsewhere
Global class ApttusFAFMchoiceEmailHelper{
    
    @InvocableMethod
    public static void sendFAFMchoiceEmail(List<Id> ApprovalRequestIds) { 
        
        // Step 0: Create a master list to hold the emails we'll send
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        
        for (Apttus_Approval__Approval_Request__c aar : [Select id,
                                                         Send_Email_To_Address__c,
                                                         Send_Email_CC_Address__c,
                                                         Queue_Users__c,
                                                         Related_FAF__r.Name,
                                                         Related_FAF__r.LOB2__c,
                                                         Related_FAF__r.Account_Name__r.Name,
                                                         Apttus_Approval__Object_Type__c,
                                                         Apttus_Approval__Object_Id__c,
                                                         Apttus_Approval__Approval_Status__c,
                                                         Apttus_Approval__Date__c,
                                                         CreatedDate,
                                                         Apttus_Approval__Assigned_To_Name__c,
                                                         Apttus_Approval__PrevAssignedToName__c,
                                                         Apttus_Approval__Request_Comments__c,
                                                         Apttus_Approval__Approver_Comments__c,
                                                         Apttus_Approval__Initial_Submitter__r.Name,
                                                         Apttus_Approval__Step_Name__c,
                                                         Related_FAF__c,
                                                         Related_FAF__r.Opportunity_Name__r.Name,
                                                         TAT_Due_Date__c,
                                                         Related_FAF__r.Client_Name__c,
                                                         Related_FAF__r.Client_Type__c,
                                                         Related_FAF__r.Client_Subtype__c,
                                                         Related_FAF__r.Business_Type__c,
                                                         Related_FAF__r.FAF_Type__c,
                                                         Related_FAF__r.LOB_Subtype__c,
                                                         Related_FAF__r.LOB_Descriptor__r.Name,
                                                         Related_FAF__r.Salesperson__r.Name,
                                                         Related_FAF__r.Underwriter__r.Name,
                                                         Related_FAF__r.Underwriter_Manager__r.Name,
                                                         Related_Client_Information__r.Master_Client_Name__r.Name,
                                                         Related_Client_Information__r.Pricing_Effective_Date__c,
                                                         Related_FAF__r.Client_Information_Count_Text__c,
                                                         Related_FAF__r.Legal_Information_Count_Text__c,
                                                         Related_FAF__r.Guarantee_Information_Count_Text__c,
                                                         Related_FAF__r.Clinical_Operations_Count_Text__c,
                                                         Related_FAF__r.Specialty_Operations_Count_Text__c,
                                                         Related_FAF__r.Rebate_Operations_Count_Text__c,
                                                         Related_FAF__r.Billing_Operations_Count_Text__c,
                                                         Related_FAF__r.Mail_Operations_Count_Text__c,
                                                         Related_FAF__r.Network_Operations_Count_Text__c,
                                                         Related_FAF__r.Last_Date_Client_Info__c,
                                                         Related_FAF__r.Last_Date_Legal_Info__c,
                                                         Related_FAF__r.Last_Date_Network_Ops__c,
                                                         Related_FAF__r.Last_Date_Mail_Ops__c,
                                                         Related_FAF__r.Last_Date_Billing_Ops__c,
                                                         Related_FAF__r.Last_Date_Rebate_Ops__c,
                                                         Related_FAF__r.Last_Date_Specialty_Ops__c,
                                                         Related_FAF__r.Last_Date_Clinical_Ops__c,
                                                         Related_FAF__r.Last_Date_Guarantee_Info__c,
                                                         Related_FAF__r.FAF_Last_Updated_On__c
                                                        
                                                         from Apttus_Approval__Approval_Request__c where id IN :ApprovalRequestIds]) {    
                                                             if ((aar.Send_Email_To_Address__c != null || aar.Queue_Users__c != null) && aar.Related_FAF__r.Name != null) {
                                                                 
                                                                System.debug('::Inside If::');
                                                                String[] SendEmailToAddress = new String[] {};
                                                                    //String[] SendAdd = aar.Send_Email_To_Address__c;
                                                                
                                                                if (aar.Queue_Users__c != null)
                                                                {   
                                                                    for (String Toemail : aar.Queue_Users__c.split(',')) {
                                                                        String toTrimmed = Toemail.trim();
                                                                        if (toTrimmed.length() > 0) 
                                                                        SendEmailToAddress.add(toTrimmed);
                                                                    }
                                                                }
                                                                else
                                                                {
                                                                    for (String Toemail : aar.Send_Email_To_Address__c.split(',')) {
                                                                        String toTrimmed = Toemail.trim();
                                                                        if (toTrimmed.length() > 0) 
                                                                        SendEmailToAddress.add(toTrimmed);
                                                                    }
                                                                }
                                                                
                                                                String[] SendEmailCCAddress = new String[] {};
                                                                if (aar.Send_Email_CC_Address__c != null) {
                                                                    for (String CCemail : aar.Send_Email_CC_Address__c.split(',')) {
                                                                        String CCtrimmed = CCemail.trim();
                                                                        if (CCtrimmed.length() > 0) 
                                                                        SendEmailCCAddress.add(CCtrimmed);
                                                                    } 
                                                                }                           
                                                                
                                                                // Step 1: Create a new Email
                                                                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

                                                                // Step 2: Set list of people who should get the email
                                                                /*List<String> sendTo = new List<String>();
                                                                sendTo.add(aar.Send_Email_To_Address__c);*/
                                                                mail.setToAddresses(SendEmailToAddress);

                                                                // Step 3: Set who the email is sent from
                                                                boolean bDefault=true;
                                                                string orgemail = Label.OrgEmailAddr;
                                                                if (orgemail != null)
                                                                {
                                                                    OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where DisplayName = :orgemail];                        
                                                                    if (owea.size() > 0) { 
                                                                        mail.setOrgWideEmailAddressId(owea.get(0).Id);
                                                                        bDefault=false;
                                                                    }
                                                                }
                                                                
                                                                if (bDefault) {
                                                                    mail.setReplyTo(Label.ApttusEmailServiceAddress);
                                                                    mail.setSenderDisplayName('CVS Official');
                                                                }                                                                

                                                                // (Optional) Set list of people who should be CC'ed
                                                               /*List<String> ccTo = new List<String>();
                                                                ccTo.add(aar.Send_Email_CC_Address__c);*/
                                                                if (aar.Send_Email_CC_Address__c != null) 
                                                                    mail.setCcAddresses(SendEmailCCAddress);
                                                                 
                                                                 // Step 4. Set email contents - you can use variables!
                                                                 String emallSubject = ''+aar.Related_FAF__r.Client_Subtype__c+' MCHOICE LOA REQUEST: '+aar.Related_FAF__r.Account_Name__r.Name+', '+aar.Related_FAF__r.Name+', '+aar.Related_FAF__r.LOB2__c+'';
                                                                 mail.setSubject(emallSubject);
                                                                 String body = ' <html> <body> ';
                                                                 
                                                                 body +='A Maintenance Choice (MC) – Letter of Agreement (LOA) for '+aar.Related_FAF__r.Client_Subtype__c+ ' FAF# '+aar.Related_FAF__r.Name+' has been requested by '+aar.Apttus_Approval__Initial_Submitter__r.Name+' at&nbsp';
                                                                  if(aar.CreatedDate != null)              
//                                                                     body += ''+aar.Related_FAF__r.FAF_Last_Updated_On__c.format()+'.'+'<br/><br/>';                
                                                                     body += ''+aar.CreatedDate.format()+'.'+'<br/><br/>';                
                                                                     
                                                                  else 
                                                                     body +='<br/><br/>';             
                                                                 
                                                                 body += 'SAAS please provide the following information to the Legal team for accurate MCHOICE LOA creation: <br/>'; 
                                                                 body += 'Full legal name of the '+aar.Related_FAF__r.Client_Subtype__c+': <REQUIRED>                <br/>';
                                                                 body += 'Is TPA Liable or TPA Non-Liable?: <REQUIRED> (Only for TPA add this additional line)                  <br/>';
                                                                 body += 'Full legal name of participating account/group: <REQUIRED>                 <br/>';
                                                                 body += 'Is the participating group/account ERISA or NON-ERISA?: <REQUIRED>                  <br/>';
                                                                 body += 'If the participating group/account NON-ERISA, then approval of '+Label.MCHOICE_LOA_Approver+' Thao Pham to offer MCHOICE is required.                <br/>';
                                                                 body += 'Requested Effective Date: <REQUIRED>                 <br/><br/>';
                                                                 body += 'OPTIONAL: Contact name and address of '+aar.Related_FAF__r.Client_Subtype__c+' if Legal is to insert information into LOA. Otherwise, SAAS is REQUIRED to insert in LOA.            <br/><br/>';
                                                                 body += 'OPTIONAL: Contact name and address of participating account/group if Legal is to insert information into LOA. Otherwise, SAAS is REQUIRED to insert in LOA.                  <br/><br/>';
                                                                  
                                                                 body += 'FAF DESCRIPTION'+'<br/><br/>';
                                                              
                                                                 if(aar.Related_FAF__r.Account_Name__r !=null){
                                                                      body += 'Account Name: '+aar.Related_FAF__r.Account_Name__r.Name+'<br/>';
                                                                 }
                                                                 else{
                                                                     body +=  'Account Name: <br/>';
                                                                 }        
                                                                 
                                                                 if(aar.Related_FAF__r.Opportunity_Name__r !=null){
                                                                      body += 'Opportunity Name: '+aar.Related_FAF__r.Opportunity_Name__r.Name+'<br/>';
                                                                 }
                                                                 else{
                                                                     body +=  'Opportunity Name: <br/>';
                                                                 }         
                                                                 
                                                                 if(aar.Related_FAF__r.Client_Name__c !=null){
                                                                      body += 'Client Name: '+aar.Related_FAF__r.Client_Name__c+'<br/>';
                                                                 }
                                                                 else{
                                                                     body += 'Client Name: <br/>';
                                                                 }         
                                                                 
                                                                 if(aar.Related_FAF__r.Client_Type__c !=null){
                                                                      body += 'Client Type: '+aar.Related_FAF__r.Client_Type__c+'<br/>';
                                                                 }
                                                                 else{
                                                                     body += 'Client Type: <br/>';
                                                                 }
                                                                     
                                                                 
                                                                 if(aar.Related_FAF__r.Client_Subtype__c !=null){
                                                                      body += 'Client Subtype: '+aar.Related_FAF__r.Client_Subtype__c+'<br/>';
                                                                 }
                                                                 else{
                                                                     body +=  'Client Subtype: <br/>';
                                                                 }         
                                                                 
                                                                 if(aar.Related_FAF__r.Business_Type__c !=null){
                                                                      body += 'Business Type: '+aar.Related_FAF__r.Business_Type__c+'<br/>';
                                                                 }
                                                                 else{
                                                                     body +=  'Business Type:  <br/>';
                                                                 }         
                                                                 
                                                                 if(aar.Related_FAF__r.FAF_Type__c !=null){
                                                                      body += 'FAF Type: '+aar.Related_FAF__r.FAF_Type__c+'<br/>';
                                                                 }
                                                                 else{
                                                                     body +=  'FAF Type:  <br/>';
                                                                 }
                                                                         
                                                                
                                                                 if(aar.Related_FAF__r.LOB2__c !=null){
                                                                      body += 'LOB: '+aar.Related_FAF__r.LOB2__c+'<br/>';
                                                                 }
                                                                 else{
                                                                     body +=  'LOB:  <br/>';
                                                                 }          
                                                                 
                                                                 if(aar.Related_FAF__r.LOB_Subtype__c !=null){ 
                                                                      body += 'LOB Subtype: '+aar.Related_FAF__r.LOB_Subtype__c+'<br/>';
                                                                 }
                                                                 else{
                                                                     body +=  'LOB Subtype:  <br/>';
                                                                 }         
                                                                 if(aar.Related_FAF__r.LOB_Descriptor__r.Name !=null){
                                                                      body += 'LOB Descriptor: '+aar.Related_FAF__r.LOB_Descriptor__r.Name+'<br/>';
                                                                 }
                                                                 else{
                                                                     body += 'LOB Descriptor: <br/>';
                                                                 }    
                                                                 
                                                                 if(aar.Related_FAF__r.Salesperson__r !=null){
                                                                      body += 'Salesperson: '+aar.Related_FAF__r.Salesperson__r.Name+'<br/>';
                                                                 }
                                                                 else{
                                                                     body +=  'Salesperson:  <br/>';
                                                                 }        
                                                                 
                                                                 if(aar.Related_FAF__r.Underwriter__r !=null){
                                                                      body += 'Underwriter: '+aar.Related_FAF__r.Underwriter__r.Name+'<br/>';
                                                                 }
                                                                 else{
                                                                     body +=  'Underwriter:  <br/>';
                                                                 }      
                                                                
                if(aar.Related_FAF__r.Underwriter_Manager__r.Name !=null){
                    body += 'Underwriter Manager: '+aar.Related_FAF__r.Underwriter_Manager__r.Name+'<br/>'; 
                }
                else{
                    body += 'Underwriter\'s Manager: <br/>';
                }     
                
                if(aar.Related_Client_Information__r.Pricing_Effective_Date__c != null){                
                    body += 'Pricing Effective Date: '+aar.Related_Client_Information__r.Pricing_Effective_Date__c.format()+'<br/>';
                }
                else{
                    body += 'Pricing Effective Date: <br/>';
                }   
                
                //body += 'Pricing Effective Date     : '+aar.Related_Client_Information__r.Pricing_Effective_Date__c+'<br/>';
                body += 'Master Client Name: '+(aar.Related_Client_Information__r.Master_Client_Name__r.Name != null ? aar.Related_Client_Information__r.Master_Client_Name__r.Name : '') +'<br/>';
                
                if(aar.Related_FAF__r.FAF_Last_Updated_On__c != null){                
                    body += 'FAF Last Updated On: '+aar.Related_FAF__r.FAF_Last_Updated_On__c.format()+'<br/>';
                }
                else{
                    body += 'FAF Last Updated On: <br/>';
                }               
                
                body += '<br/><br/>'; 
                                                                 
                body += 'FAF COMPONENTS';
                body += '<br/><br/>';                               
                
                //String Last_Date_Client_Info = string.valueOfGmt(aar.Related_FAF__r.Last_Date_Client_Info__c) != null ? string.valueOfGmt(aar.Related_FAF__r.Last_Date_Client_Info__c) : '';
                
                body += 'Client Information: '+aar.Related_FAF__r.Client_Information_Count_Text__c+'<br/>';
                if(aar.Related_FAF__r.Last_Date_Client_Info__c != null){
                    body += 'Last Modified: '+aar.Related_FAF__r.Last_Date_Client_Info__c.format();
                }
                else{
                    body += 'Last Modified: ';
                }
                    
                body += '<br/><br/>'; 
                
                //String Last_Date_Legal_Info = string.valueOfGmt(aar.Related_FAF__r.Last_Date_Legal_Info__c) != null ? string.valueOf(aar.Related_FAF__r.Last_Date_Legal_Info__c) : '';
                
                body += 'Legal Information: '+aar.Related_FAF__r.Legal_Information_Count_Text__c+'<br/>';
                if(aar.Related_FAF__r.Last_Date_Legal_Info__c != null){
                    body += 'Last Modified: '+aar.Related_FAF__r.Last_Date_Legal_Info__c.format();
                }
                else{
                    body += 'Last Modified: ';
                }
                body += '<br/><br/>';

                //String Last_Date_Network_Ops = string.valueOfGmt(aar.Related_FAF__r.Last_Date_Network_Ops__c) != null ? string.valueOfGmt(aar.Related_FAF__r.Last_Date_Network_Ops__c) : '';
                
                body += 'Network Operations: '+aar.Related_FAF__r.Network_Operations_Count_Text__c+'<br/>';
                
                if(aar.Related_FAF__r.Last_Date_Network_Ops__c != null){
                    body += 'Last Modified: '+aar.Related_FAF__r.Last_Date_Network_Ops__c.format();
                }
                else{
                    body += 'Last Modified: ';
                }               
                body += '<br/><br/>';                                               
                
                //String Last_Date_Mail_Ops = string.valueOfGmt(aar.Related_FAF__r.Last_Date_Mail_Ops__c) != null ? string.valueOfGmt(aar.Related_FAF__r.Last_Date_Mail_Ops__c) : '';
                                
                body += 'Mail Operations:  '+aar.Related_FAF__r.Mail_Operations_Count_Text__c+'<br/>';
                
                if(aar.Related_FAF__r.Last_Date_Mail_Ops__c != null){
                    body += 'Last Modified: '+aar.Related_FAF__r.Last_Date_Mail_Ops__c.format();
                }
                else{
                    body += 'Last Modified:';
                }
                                
                body += '<br/><br/>';
                
                //String Last_Date_Billing_Ops = string.valueOfGmt(aar.Related_FAF__r.Last_Date_Billing_Ops__c) != null ? string.valueOfGmt(aar.Related_FAF__r.Last_Date_Billing_Ops__c) : '';

                body += 'Billing Operations: '+aar.Related_FAF__r.Billing_Operations_Count_Text__c+'<br/>';
                
                if(aar.Related_FAF__r.Last_Date_Billing_Ops__c != null){                
                    body += 'Last Modified: '+aar.Related_FAF__r.Last_Date_Billing_Ops__c.format();
                }
                else{
                    body += 'Last Modified:';
                }                
                
                body += '<br/><br/>';  

                //String Last_Date_Rebate_Ops = string.valueOfGmt(aar.Related_FAF__r.Last_Date_Rebate_Ops__c) != null ? string.valueOfGmt(aar.Related_FAF__r.Last_Date_Rebate_Ops__c) : '';
                
                body += 'Rebate Operations: '+aar.Related_FAF__r.Rebate_Operations_Count_Text__c+'<br/>';
                if(aar.Related_FAF__r.Last_Date_Rebate_Ops__c != null){                
                    body += 'Last Modified: '+aar.Related_FAF__r.Last_Date_Rebate_Ops__c.format();
                }
                else{
                    body += 'Last Modified:';
                }                

                //body += 'Last Modified: '+Last_Date_Rebate_Ops;
                body += '<br/><br/>';
                
                //String Last_Date_Specialty_Ops = string.valueOfGmt(aar.Related_FAF__r.Last_Date_Specialty_Ops__c) != null ? string.valueOfGmt(aar.Related_FAF__r.Last_Date_Specialty_Ops__c) : '';

                body += 'Specialty Operations: '+aar.Related_FAF__r.Specialty_Operations_Count_Text__c+'<br/>';
                if(aar.Related_FAF__r.Last_Date_Specialty_Ops__c != null){                
                    body += 'Last Modified: '+aar.Related_FAF__r.Last_Date_Specialty_Ops__c.format();
                }
                else{
                    body += 'Last Modified:';
                }
                body += '<br/><br/>';

                //String Last_Date_Clinical_Ops = string.valueOfGmt(aar.Related_FAF__r.Last_Date_Clinical_Ops__c) != null ? string.valueOfGmt(aar.Related_FAF__r.Last_Date_Clinical_Ops__c) : '';
                
                body += 'Clinical Operations: '+aar.Related_FAF__r.Clinical_Operations_Count_Text__c+'<br/>';
                if(aar.Related_FAF__r.Last_Date_Clinical_Ops__c != null){                
                    body += 'Last Modified: '+aar.Related_FAF__r.Last_Date_Clinical_Ops__c.format();
                }
                else{
                    body += 'Last Modified:';
                }                               
                body += '<br/><br/>';  

                //String Last_Date_Guarantee_Info = string.valueOfGmt(aar.Related_FAF__r.Last_Date_Guarantee_Info__c) != null ? string.valueOfGmt(aar.Related_FAF__r.Last_Date_Guarantee_Info__c) : '';
                
                body += 'Guarantee Information: '+aar.Related_FAF__r.Guarantee_Information_Count_Text__c+'<br/>';
                if(aar.Related_FAF__r.Last_Date_Guarantee_Info__c != null){                
                    body += 'Last Modified: '+aar.Related_FAF__r.Last_Date_Guarantee_Info__c.format();
                }
                else{
                    body += 'Last Modified:';
                }
                body += '<br/><br/>';               
                
                body += '</body></html>';                
                
                mail.setHtmlBody(body);  

                // Step 5. Add your email to the master list
                mails.add(mail);
            }
        }   

        try {
            // Step 6: Send all emails in the master list
            Messaging.sendEmail(mails);
        System.debug('::after email sent::');
        } catch (Exception e) {
            System.debug(e.getMessage());
        }       

    }

}