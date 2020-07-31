public class ApttusFAFReleaseTPAMaster {

    @InvocableMethod
    public static void sendEmail(List<Id> ApprovalRequestIds) { 
        
        // Step 0: Create a master list to hold the emails we'll send
 //       List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        
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
             Related_FAF__r.Platform_Specifics_Details__c,
             Related_FAF__r.TestField__c,
             Related_FAF__r.FAF_Released_Date__c,
             Related_FAF__r.Last_Modified__c,
             Related_FAF__r.Delete_NetworkOps__c,
             Related_FAF__r.Delete_BillingOps_Date__c,
             Related_FAF__r.Delete_ClinicalOps_Date__c,
             Related_FAF__r.Delete_GuaranteeInfo_Date__c,
             Related_FAF__r.Delete_MailOps_Date__c,
             Related_FAF__r.Delete_RebateOps_Date__c,
             Related_FAF__r.Delete_SpecialtyOps_Date__c
            
             from Apttus_Approval__Approval_Request__c where id IN :ApprovalRequestIds]) {
             
             //US-65 Query for latest TPA FROM. Added by **Sneha Inturi**
             List<TPA_Form__c> TFlist=new List<TPA_Form__c>();
             TFlist=[select id,if_yes_provide_tier_information_for_Mai__c,X90_Day_Network__c,Additional_Notes__c,C_A_G__c,Client_Code__c,Client_Info_ID__c,CLIENT_NAME__c,EFFECTIVE_DATE__c,
                 GOVCLP_Network_VA_Claims_1_90_day_supp__c,If_client_has_a_custom_network_please_li__c,If_CVSHealth_will_not_process_government__c,Maintenance_Choice_Network1__c,
                 MDCAID_Network_Government_Paper_Claims__c,Network_Name__c,PLAN_ID__c,Pricing_Tiers__c from TPA_Form__c where Client_Info_ID__c =:aar.Related_Client_Information__c order by LastModifieddate desc limit 1];
             TPA_Form__c TF=new TPA_Form__c();
             if(TFlist.size()>0){
                 TF=TFlist.get(0);
             }
                         
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
                 String emallSubject = ''+aar.Related_FAF__r.Client_Subtype__c+' ADD: '+aar.Related_FAF__r.Account_Name__r.Name+', '+aar.Related_FAF__r.Name+', '+aar.Related_FAF__r.LOB2__c+'';                                                                                
                 mail.setSubject(emallSubject);
                 if (body == null) {                 
                 body = ' <html> <body> ';                                                                
                 body += '<br/><br/>';  

                 body +=''+aar.Related_FAF__r.Client_Subtype__c+' FAF# '+aar.Related_FAF__r.Name+' has been updated by SAAS and released for implementation by '+aar.Related_FAF__r.Last_Modified__c+' at ';
                 //body += ''+aar.Related_FAF__r.FAF_Released_Date__c.format()+'<br/><br/>';
                
//                if(aar.Related_FAF__r.FAF_Released_Date__c != null)                
//                    body += ''+aar.Related_FAF__r.FAF_Released_Date__c.format()+'.'+'<br/><br/>';                
//                else
                    body += ''+System.now().format() +'.'+ '<br/><br/>';                            
       //                           
                 body += 'Please review the Fee Authorization Form for "Implementation" by <a href="'+Label.FAF_Release+''+aar.Related_FAF__c+'">clicking this link</a>.';
                 body += '<br/><br/>';
                 
                 body += 'The FAF Client Information - Platform Specifics section of this Master FAF has been updated with following additions:';
                 body += '<br/><br/>';               
//                 body += ''+aar.Related_FAF__r.Platform_Specifics_Details__c+'<br/><br/>';
                 body += ''+aar.Related_FAF__r.TestField__c+'<br/><br/>'; 
                                   
                 //US-65 TPA FROM values are configured to emil template. Modified by **Sneha Inturi**
                 body +='***THE FOLLOWING NIF FORM SECTION MUST BE COMPLETED ON ALL REQUESTS AND DUPLICATED FOR EACH CLIENT*** <br/><br/>';
                 body +='&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<b><font size="4">TPA NIF REQUEST FORM </font></b> <br/><br/>';
                 body +='**PLEASE NOTE-INCORRECT OR IMPROPERLY COMPLETED FORMS WILL AFFECT TAT ON NIF REQUESTS** <br/><br/>';
                 body +='**PLEASE COMPLETE ALL SECTIONS FOR PROPER PRICING IMPLEMENTATION** <br/><br/>';
                 string ef=(TF!=null && TF.EFFECTIVE_DATE__c!=null)?TF.EFFECTIVE_DATE__c.format():' ';
                 body +='EFFECTIVE DATE: '+ ef+'<br/>';
                 string CN=(TF!=null && TF.CLIENT_NAME__c!=null)?TF.CLIENT_NAME__c:' ';
                 body +='CLIENT NAME: '+CN+'<br/>';
                 string CC=(TF!=null && TF.Client_Code__c!=null)?TF.Client_Code__c:' ';
                 body +='Client Code: '+CC+'<br/>';
                 string CAG=(TF!=null && TF.C_A_G__c!=null)?TF.C_A_G__c:' ';                              
                 body +='C/A/G: '+CAG+'<br/>';
                 string PID=(TF!=null && TF.PLAN_ID__c!=null)?TF.PLAN_ID__c:' '; 
                 body +='PLAN ID (required if applicable – please note if plan is Base or X-Ref): '+PID+'<br/><br/>';
                 body +='<b>Please provide the following information with every request:</b> <br/><br/>';
                 string MCN=(TF!=null && TF.Maintenance_Choice_Network1__c!=null)?TF.Maintenance_Choice_Network1__c:' '; 
                 body +='Maintenance Choice Network: '+MCN+'<br/>';
                 string X90=(TF!=null && TF.X90_Day_Network__c!=null)?TF.X90_Day_Network__c:' '; 
                 string NN=(TF!=null && TF.Network_Name__c!=null)?TF.Network_Name__c:' ';
                 body +='90 Day Network: '+X90+'    <I>  *If yes, specify which network:</I> '+NN+'<br/>';  
                 string MGP=(TF!=null && TF.MDCAID_Network_Government_Paper_Claims__c!=null)?TF.MDCAID_Network_Government_Paper_Claims__c:' ';
                 body +='- MDCAID Network (Government Paper Claims): '+MGP+'<br/>';
                 string GVP=(TF!=null && TF.GOVCLP_Network_VA_Claims_1_90_day_supp__c!=null)?TF.GOVCLP_Network_VA_Claims_1_90_day_supp__c:' ';
                 body +='- GOVCLP Network (VA Claims 1-90 day supply): '+GVP+'<br/><br/>';
                 string CW=(TF!=null && TF.If_CVSHealth_will_not_process_government__c!=null)?TF.If_CVSHealth_will_not_process_government__c:' ';
                 body +='If CVSHealth will not process government claims, you <u>MUST</u> provide the payer’s name and address: '+CW+'<br/>';
                 string IC=(TF!=null && TF.If_client_has_a_custom_network_please_li__c!=null)?TF.If_client_has_a_custom_network_please_li__c:' ';
                 body +='If Client has a custom network please list network ID: '+IC+'<br/><br/>';
                 body +='<i>** NOTE:  If a Custom Network must be created; be advised that it takes 30 days or more to credential a provider and get them into our system.** Please reach out to Pharmacy Network Operations for more information regarding custom networks.</i> <br/> <br/> ';
                 string PT=(TF!=null && TF.Pricing_Tiers__c!=null)?TF.Pricing_Tiers__c:' ';
                 string TF1=(TF!=null && TF.if_yes_provide_tier_information_for_Mai__c!=null)?TF.if_yes_provide_tier_information_for_Mai__c:' ';
                 body +='Pricing Tiers: '+PT+'    <i>  *If yes, provide Tier information for Mail and Retail:</i> ' +TF1+'<br/>';
                 body += '<font size="2">Example: Reinvested rebate FAF may have 2TNQ, 2TQ, 3TQ  price options </font>                         <br/> <br/>';
                 string AC=(TF!=null && TF.Additional_Notes__c!=null)?TF.Additional_Notes__c:' ';
                 body +='ADDITIONAL NOTES: Please provide any other applicable information: '+AC+'<br/>';
                 body +='<font size="2">Example: If your client has the option of selecting Flat or MAC pricing from their FAF you must include Flat/MAC information for Mail and Retail.</font><br/><br/>';
                 body +='SERVICE LEVEL AGREEMENTS: The TAT listed below assumes client MAC has been finalized (or no update is needed), and the NIF request form is complete and accurate and barring unforeseen client complexity. <br/><br/>';
                 body +='Once these conditions have been met: <br/>';
                 body +='- Standard TAT (Feb-Sep): 5 to 10 business days <br/>';
                 body +='- Welcome Season TAT’s will be sent separately as part of the Welcome Season communication each year <br/><br/>';
                 body +='*****************************************END NIF FORM SECTION*****************************************  <br/><br/>';                                                                             
                 //
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
                    body += 'Underwriter\'s Manager: '+aar.Related_FAF__r.Underwriter_Manager__r.Name+'<br/>'; 
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
        //          body += 'FAF Last Updated On: '+aar.Related_FAF__r.FAF_Last_Updated_On__c.format()+'<br/>';
                    body += '<a href="'+Label.Transaction_Logs_Search_Link+'">FAF Last Updated On:</a> '+aar.Related_FAF__r.FAF_Last_Updated_On__c.format()+'<br/>';
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
                // Step 5. Add your email to the master list
                mails.add(mail);
                iTotalAdd++;
                totalEmails--;
                iCntAPI--;
                System.debug('::after email add::' + ' Buffer=' + iCntAPI + ' TotalAdd='+iTotalAdd + 'Remaining=' + totalEmails);                    

        }   

            try {
                // Step 6: Send all emails in the master list 
                if (totalEmails == 0) {
                    Messaging.sendEmail(mails);
                    System.debug('::sendEmail after Send Remaining=' + totalEmails+ ' TotalAdd=' + iTotalAdd );
//                    if (totalEmails == 0 || bProcessQueue == false) 
//                        return;
                }
            } catch (Exception e) {
                System.debug('::Error sendEmail::' +e.getMessage());
            }
            
            }
        } 
        } 

}