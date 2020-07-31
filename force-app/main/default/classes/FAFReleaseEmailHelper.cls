// In a separate class so that it can be used elsewhere
Global class FAFReleaseEmailHelper {
    
    @InvocableMethod
    public static void sendFAFReleaseEmail(List<Id> ApprovalRequestIds) { 
        
        // Step 0: Create a master list to hold the emails we'll send
//        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        
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
                                                         Related_FAF__r.FAF_Last_Updated_On__c,
                                                         Related_FAF__r.Delete_NetworkOps__c,
                                                         Related_FAF__r.Delete_BillingOps_Date__c,
                                                         Related_FAF__r.Delete_ClinicalOps_Date__c,
                                                         Related_FAF__r.Delete_GuaranteeInfo_Date__c,
                                                         Related_FAF__r.Delete_MailOps_Date__c,
                                                         Related_FAF__r.Delete_RebateOps_Date__c,
                                                         Related_FAF__r.Delete_SpecialtyOps_Date__c
                                                                                                               
                                                         from Apttus_Approval__Approval_Request__c where id IN :ApprovalRequestIds]) {
                                                         List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
                                                         Integer totalEmails = 1;
                                                         Integer iTotalAdd = 0;
                                                         String body = null;
                                                         ID OWEAID = null;
                                                         Boolean bProcessQueue=false;
                                                         String[] SendEmailToAddress2 = new String[] {};
                                                         string orgemail = Label.OrgEmailAddr;
                                                         if (orgemail != null)
                                                         {
                                                             OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where DisplayName = :orgemail];                        
                                                             if (owea.size() > 0) { 
                                                                 OWEAID = owea.get(0).Id;
                                                             }
                                                         }                                                         
                                                         if (aar.Queue_Users__c != null)
                                                         {
                                                            totalEmails = aar.Queue_Users__c.countMatches('@');
                                                            bProcessQueue = true;
                                                             for (String Toemail1 : aar.Queue_Users__c.split(',')) {
                                                                String toTrimmed1 = Toemail1.trim();
                                                                if (toTrimmed1.length() > 0)                                                                                                                                                                                                                         
                                                                    SendEmailToAddress2.add(toTrimmed1);                                                                       
                                                             }                                                                                                                          
                                                         }
                                                         else
                                                         {
                                                             String userName = UserInfo.getUserName();
                                                             User activeUser = [Select Email From User where Username = : userName limit 1];
                                                             SendEmailToAddress2.add(activeUser.Email);
                                                         }
                                                                                                                                                                    
                                                         if ((aar.Send_Email_To_Address__c != null || aar.Queue_Users__c != null) && aar.Related_FAF__r.Name != null && totalEmails > 0) {                                                                                                                            
                                                                System.debug('::Queue Users::'+aar.Queue_Users__c);
                                                                System.debug('::Total Emails::'+totalEmails);
                                                                Integer iCntAPI = Integer.valueOf(Label.MaxEmailAddresses); // API can only be called 10 times
                                                                List<User> ul = [select Id from User where Email IN :SendEmailToAddress2];                                                                 
                                                                System.debug('::Total Users::'+ ul.size()); 
                                                                totalEmails = ul.size();                                                               
                                                                for (User u: ul) {                                                               
                                                                String[] SendEmailToAddress = new String[] {};
                                                                ID SendEmailToAddressID = null;
                                                                boolean bUseId = false;
                                                                if (aar.Queue_Users__c != null)
                                                                {                                                                  
                                                                    SendEmailToAddressID = u.Id;
                                                                    System.debug('::SendEmailToAddress::'+SendEmailToAddressID );
                                                                    bUseId=True;                                                                    
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
                                                                if (bUseId) {
                                                                    mail.setTargetObjectId(SendEmailToAddressID);
                                                                    mail.saveAsActivity = false;
                                                                }
                                                                else                                                                                                                                  
                                                                    mail.setToAddresses(SendEmailToAddress);

                                                                // Step 3: Set who the email is sent from
                                                                boolean bDefault=true;
                                                                if (OWEAID != null) {
                                                                    mail.setOrgWideEmailAddressId(OWEAID );
                                                                }
                                                                else {
                                                                    mail.setReplyTo(Label.ApttusEmailServiceAddress);                                                                                                                                
                                                                    mail.setSenderDisplayName('CVS Official');
                                                                }

                                                                // (Optional) Set list of people who should be CC'ed
                                                               /*List<String> ccTo = new List<String>();
                                                                ccTo.add(aar.Send_Email_CC_Address__c);*/
                                                                if (aar.Send_Email_CC_Address__c != null) 
                                                                    mail.setCcAddresses(SendEmailCCAddress);
                                                                 
                                                                 // Step 4. Set email contents - you can use variables!
                                                                 String emallSubject = ''+aar.Apttus_Approval__Step_Name__c+': '+aar.Related_FAF__r.Account_Name__r.Name+', '+aar.Related_FAF__r.Name+', '+aar.Related_FAF__r.LOB2__c+'';
                                                                 mail.setSubject(emallSubject);
                                                                 if (body == null) {
                                                                 body = ' <html> <body> ';
                                                                 
                                                                 body +='Please review the Fee Authorization Form for \'Implementation\' by <a href="'+Label.FAF_Release+''+aar.Related_FAF__c+'">clicking this link</a>';
                                                                 body += '<br/><br/>';
                                                                 
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
                
                if(aar.Related_FAF__r.FAF_Last_Updated_On__c != null && aar.Apttus_Approval__Step_Name__c == 'FAF Re-release for \'Implementation\''){                
                    body += '<a href="'+Label.Transaction_Logs_Search_Link+'">FAF Last Updated On:</a> '+aar.Related_FAF__r.FAF_Last_Updated_On__c.format()+'<br/>';
                }
                else if(aar.Related_FAF__r.FAF_Last_Updated_On__c != null && aar.Apttus_Approval__Step_Name__c != 'FAF Re-release for \'Implementation\''){                
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
                else
                { 
                    if(aar.Related_FAF__r.Last_Date_Network_Ops__c == null && aar.Related_FAF__r.Delete_NetworkOps__c != null)
                        body += 'Last Modified: '+aar.Related_FAF__r.Delete_NetworkOps__c.format();                   
                    else
                        body += 'Last Modified: '; 
                }              
                body += '<br/><br/>';                                                 
                
                //String Last_Date_Mail_Ops = string.valueOfGmt(aar.Related_FAF__r.Last_Date_Mail_Ops__c) != null ? string.valueOfGmt(aar.Related_FAF__r.Last_Date_Mail_Ops__c) : '';
                                
                body += 'Mail Operations:  '+aar.Related_FAF__r.Mail_Operations_Count_Text__c+'<br/>';
                
                if(aar.Related_FAF__r.Last_Date_Mail_Ops__c != null){
                    body += 'Last Modified: '+aar.Related_FAF__r.Last_Date_Mail_Ops__c.format();
                }
                else
                { 
                    if(aar.Related_FAF__r.Last_Date_Mail_Ops__c == null && aar.Related_FAF__r.Delete_MailOps_Date__c != null)
                        body += 'Last Modified: '+aar.Related_FAF__r.Delete_MailOps_Date__c.format();                   
                    else
                        body += 'Last Modified: '; 
                }              
                                
                body += '<br/><br/>';
                
                //String Last_Date_Billing_Ops = string.valueOfGmt(aar.Related_FAF__r.Last_Date_Billing_Ops__c) != null ? string.valueOfGmt(aar.Related_FAF__r.Last_Date_Billing_Ops__c) : '';

                body += 'Billing Operations: '+aar.Related_FAF__r.Billing_Operations_Count_Text__c+'<br/>';
                
                if(aar.Related_FAF__r.Last_Date_Billing_Ops__c != null){                
                    body += 'Last Modified: '+aar.Related_FAF__r.Last_Date_Billing_Ops__c.format();
                }
                else
                { 
                    if(aar.Related_FAF__r.Last_Date_Billing_Ops__c == null && aar.Related_FAF__r.Delete_BillingOps_Date__c != null)
                        body += 'Last Modified: '+aar.Related_FAF__r.Delete_BillingOps_Date__c.format();                   
                    else
                        body += 'Last Modified: '; 
                }                             
                
                body += '<br/><br/>';  

                //String Last_Date_Rebate_Ops = string.valueOfGmt(aar.Related_FAF__r.Last_Date_Rebate_Ops__c) != null ? string.valueOfGmt(aar.Related_FAF__r.Last_Date_Rebate_Ops__c) : '';
                
                body += 'Rebate Operations: '+aar.Related_FAF__r.Rebate_Operations_Count_Text__c+'<br/>';
                if(aar.Related_FAF__r.Last_Date_Rebate_Ops__c != null){                
                    body += 'Last Modified: '+aar.Related_FAF__r.Last_Date_Rebate_Ops__c.format();
                }
                else
                { 
                    if(aar.Related_FAF__r.Last_Date_Rebate_Ops__c == null && aar.Related_FAF__r.Delete_RebateOps_Date__c != null)
                        body += 'Last Modified: '+aar.Related_FAF__r.Delete_RebateOps_Date__c.format();                   
                    else
                        body += 'Last Modified: '; 
                }                              

                //body += 'Last Modified: '+Last_Date_Rebate_Ops;
                body += '<br/><br/>';
                
                //String Last_Date_Specialty_Ops = string.valueOfGmt(aar.Related_FAF__r.Last_Date_Specialty_Ops__c) != null ? string.valueOfGmt(aar.Related_FAF__r.Last_Date_Specialty_Ops__c) : '';

                body += 'Specialty Operations: '+aar.Related_FAF__r.Specialty_Operations_Count_Text__c+'<br/>';
                if(aar.Related_FAF__r.Last_Date_Specialty_Ops__c != null){                
                    body += 'Last Modified: '+aar.Related_FAF__r.Last_Date_Specialty_Ops__c.format();
                }
                else
                { 
                    if(aar.Related_FAF__r.Last_Date_Specialty_Ops__c == null && aar.Related_FAF__r.Delete_SpecialtyOps_Date__c != null)
                        body += 'Last Modified: '+aar.Related_FAF__r.Delete_SpecialtyOps_Date__c.format();                   
                    else
                        body += 'Last Modified: '; 
                }              
                body += '<br/><br/>';

                //String Last_Date_Clinical_Ops = string.valueOfGmt(aar.Related_FAF__r.Last_Date_Clinical_Ops__c) != null ? string.valueOfGmt(aar.Related_FAF__r.Last_Date_Clinical_Ops__c) : '';
                
                body += 'Clinical Operations: '+aar.Related_FAF__r.Clinical_Operations_Count_Text__c+'<br/>';
                if(aar.Related_FAF__r.Last_Date_Clinical_Ops__c != null){                
                    body += 'Last Modified: '+aar.Related_FAF__r.Last_Date_Clinical_Ops__c.format();
                }
                else
                { 
                    if(aar.Related_FAF__r.Last_Date_Clinical_Ops__c == null && aar.Related_FAF__r.Delete_ClinicalOps_Date__c != null)
                        body += 'Last Modified: '+aar.Related_FAF__r.Delete_ClinicalOps_Date__c.format();                   
                    else
                        body += 'Last Modified: '; 
                }                                           
                body += '<br/><br/>';  

                //String Last_Date_Guarantee_Info = string.valueOfGmt(aar.Related_FAF__r.Last_Date_Guarantee_Info__c) != null ? string.valueOfGmt(aar.Related_FAF__r.Last_Date_Guarantee_Info__c) : '';
                
                body += 'Guarantee Information: '+aar.Related_FAF__r.Guarantee_Information_Count_Text__c+'<br/>';
                if(aar.Related_FAF__r.Last_Date_Guarantee_Info__c != null){                
                    body += 'Last Modified: '+aar.Related_FAF__r.Last_Date_Guarantee_Info__c.format();
                }
                else
                { 
                    if(aar.Related_FAF__r.Last_Date_Guarantee_Info__c == null && aar.Related_FAF__r.Delete_GuaranteeInfo_Date__c != null)
                        body += 'Last Modified: '+aar.Related_FAF__r.Delete_GuaranteeInfo_Date__c.format();                   
                    else
                        body += 'Last Modified: '; 
                }              
                body += '<br/><br/>';               
                
                body += '</body></html>';                
                }
                mail.setHtmlBody(body);  

                // Step 5. Add your email to the master list
                mails.add(mail);
                iTotalAdd++;
                totalEmails--;
                iCntAPI--;
                System.debug('::after email add::' + ' Buffer=' + iCntAPI + ' TotalAdd='+iTotalAdd + 'Remaining=' + totalEmails);                    
                        
            try {
                // Step 6: Send all emails in the master list 
                if (totalEmails == 0) {
                    Messaging.sendEmail(mails);
                    System.debug('::sendEmail after Send Remaining=' + totalEmails+ ' TotalAdd=' + iTotalAdd );
//                    if (totalEmails == 0 || bProcessQueue == false) 
//                        return;
//                    else {
//                        iCntAPI=Integer.valueOf(Label.MaxEmailAddresses);
//                        if (totalEmails < iCntAPI)
//                            iCntAPI = totalEmails;
//                    }
                }
            } catch (Exception e) {
                System.debug('::Error sendEmail::' +e.getMessage());
            }
            
            }
        } 
        }       

    }

}