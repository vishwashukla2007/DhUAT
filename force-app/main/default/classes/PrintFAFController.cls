/* =================================================================================
 * @Class Name        : PrintFAFController
 * @author            : Anudeep Dale
 * @created date      : 10/10/2018
 * @Purpose           : Print FAF functionality
=======================================================================================*/
public without sharing class PrintFAFController { 

    public id recordID=null;
    
    /******Visualforce page variables*********/
    public Boolean FAFInstructions{get;set;}
    public Boolean FAFLinks{get;set;}
    public Boolean ClientInformation{get;set;}
    public Boolean LegalInformation{get;set;}
    public Boolean PlatformSpecifics{get;set;}
    public Boolean NetworkOperations{get;set;}
    public Boolean MailOperations{get;set;}
    public Boolean SpecialtyOperations{get;set;}
    public Boolean BillingOperations{get;set;}
    public Boolean RebateOperations{get;set;}
    public Boolean ClinicalOperations{get;set;}
    public Boolean GuaranteeInformation{get;set;}
    
    /*******Check Box varibale**************/
    
    public boolean fafiBool{ get; set; }
    public boolean faflinkBool{ get; set; } 
    public boolean billBool{ get; set; }
    public boolean rebatBool{ get; set; }
    public boolean guarBool{ get; set; }
    public boolean specBool{ get; set; }
    public boolean mailBool{ get; set; }
    public boolean cilnicalBool{ get; set; }
    public boolean clientBool{ get; set; }
    public boolean networkBool{ get; set; }
    public boolean plaformBool{ get; set; }
    public boolean legalInfoBool{ get; set; } 
    public boolean PSThresholdBool{ get; set; }
    
    /*Variable to Disable Submit Button incase Read Access of FAF*/ 
    public boolean disableBool{ get; set; }
    //Global Variables
    private final Central_Hub__c faf;
    //public Boolean showPopup = false;
    //End of Global Variables
    
    // Standard Controller Constructor
    public PrintFAFController(ApexPages.StandardController controller) 
    {
        recordId =ApexPages.currentPage().getParameters().get('Id');
         if(!test.isRunningTest())
        controller.addFields(new String[]{'User_Access_Specialty__c',
                                          'User_Access_Mail__c',
                                          'User_Access_Billing__c',
                                          'User_Access_Network__c',
                                          'User_Access_Rebate__c',
                                          'User_Access_Clinical__c',
                                          'User_Access_Guarantee__c',
                                          'User_Access_ClientInfo__c',
                                          'User_Access_Legal__c'
      });
        
        this.faf =(Central_Hub__c) controller.getrecord();
        enableObjectschk();
        system.debug('---fafiBool----'+fafiBool);
        system.debug('---faflinkBool----'+faflinkBool);
        system.debug('---billBool----'+billBool);
        system.debug('---networkBool----'+networkBool);
        system.debug('---specBool----'+specBool);
        system.debug('---mailBool----'+mailBool);
        system.debug('---rebatBool----'+rebatBool);
        system.debug('---guarBool----'+guarBool);
        system.debug('---cilnicalBool----'+cilnicalBool); 
        system.debug('---clientBool----'+clientBool);  
        system.debug('---plaformBool----'+plaformBool);
        system.debug('---legalInfoBool----'+legalInfoBool);                                                                                                  
    }
    // End of Standard Controller Constructor 
    /* =================================================================================
     * @Method Name       : enableObjectschk
     * @author            : Anudeep Dale
     * @created date      : 10/17/2018
     * @Purpose           : Print FAF functionality
    =======================================================================================*/
    public void enableObjectschk(){
         
        disableBool=false;
        PlatformSpecifics=false;
        PSThresholdBool=false;
        GuaranteeInformation=false;
        ClinicalOperations=false;
        RebateOperations=false;
        SpecialtyOperations=false;
        FAFLinks=false;
        MailOperations=false;
        NetworkOperations=false;
        LegalInformation=false;
        ClientInformation=false;
        BillingOperations=false;
        FAFInstructions=false;
        
        List<FAF_Instructions__c> fafInstructObj=[Select ID from  FAF_Instructions__c  where FAF_ID__c=:recordId limit 1];
        if(fafInstructObj.size()>0){
          fafiBool=true;
          FAFInstructions=true;
        }
        else{
            fafiBool=false;
        }
        List<FAF_Link__c> faflinkObje=[Select ID from  FAF_Link__c where Partial_FAF__c=:recordId  or FULL_FAF__c=:recordId];
        if(faflinkObje.size()>0){
          faflinkBool=true;
          FAFLinks=true;
        }
        else{
        faflinkBool=false;
        }        
        List<Billing_Operations__c> billchkObj=[Select ID from Billing_Operations__c  where FAF_ID__c=:recordId limit 1];
        if(billchkObj.size()>0){
            billBool=faf.User_Access_Billing__c;      
            BillingOperations=faf.User_Access_Billing__c;       
        }
        else{
            billBool=false;
        }
        
        List<Network_Operations__c> networkchkObj=[Select ID from Network_Operations__c  where FAF_ID__c=:recordId limit 1];
        if(networkchkObj.size()>0){
           networkBool=faf.User_Access_Network__c;
            NetworkOperations=faf.User_Access_Network__c;          
        }
        else{
            networkBool=false;
        }
        List<Specialty_Operations__c> specObj=[Select ID from Specialty_Operations__c  where FAF_ID__c=:recordId limit 1];
        if(specObj.size()>0){
          specBool=faf.User_Access_Specialty__c;
         SpecialtyOperations=faf.User_Access_Specialty__c;          
        }
        else{
            specBool=false;
        }
        List<Mail_Operations__c> mailpos=[Select ID from Mail_Operations__c  where FAF_ID__c=:recordId limit 1];
        if(mailpos.size()>0){
          mailBool=faf.User_Access_Mail__c;
          MailOperations=faf.User_Access_Mail__c;        
        }
        else{
            mailBool=false;
        }
        List<Rebate_Operations__c> rebteObjs=[Select ID from Rebate_Operations__c  where FAF_ID__c=:recordId limit 1];
        if(rebteObjs.size()>0){
          rebatBool=faf.User_Access_Rebate__c;
          RebateOperations=faf.User_Access_Rebate__c;         
        }
        else{
            rebatBool=false;
        }
        List<Guarantees_Information__c> guarObjs=[Select ID from Guarantees_Information__c  where FAF_ID__c=:recordId limit 1];
        if(guarObjs.size()>0){
          guarBool=faf.User_Access_Guarantee__c;
          GuaranteeInformation=faf.User_Access_Guarantee__c;         
          }
        else{
            guarBool=false;
        }
        List<Clinical_Operations__c> clicnicObj=[Select ID from Clinical_Operations__c  where FAF_ID__c=:recordId limit 1];
        if(clicnicObj.size()>0){
          cilnicalBool=faf.User_Access_Clinical__c;
          ClinicalOperations=faf.User_Access_Clinical__c;        
        }
        else{
            cilnicalBool=false;
        }
        List<Client_Information__c> fafObj=[Select ID, Platform_Specifics_Count__c from  Client_Information__c  where FAF_ID__c=:recordId limit 1];
        if(fafObj.size()>0){
           clientBool=faf.User_Access_ClientInfo__c;
           ClientInformation=faf.User_Access_ClientInfo__c;
         Integer Threshold =  Integer.valueOf(Label.Print_Platform_Specific_Threshold);
         for (Client_Information__c ci : fafObj) { 
             if (ci.Platform_Specifics_Count__c > Threshold)
                 PSThresholdBool=true;
         }        
        }
        else{
        clientBool=false;
        }
        
        List<Platform_Specifics__c  > platformObje=[Select ID from  Platform_Specifics__c where FAF_ID__c=:recordId limit 1];        
        if(platformObje.size()>0){
          plaformBool=faf.User_Access_ClientInfo__c;
          if (PSThresholdBool)
              plaformBool=false;    
          PlatformSpecifics= faf.User_Access_ClientInfo__c;
        }
        else{
            plaformBool=false;
            PSThresholdBool=false;
        }
        
        List<Legal_Information__c> legalInfoObje=[Select ID from  Legal_Information__c where FAF_ID__c=:recordId limit 1];
        if(legalInfoObje.size()>0){
          legalInfoBool=faf.User_Access_Legal__c;
          LegalInformation=faf.User_Access_Legal__c;        
        }
        else{
            legalInfoBool=false;
        }

        
 //Logic to Identify Read access and provide Message incase Read Access of FAF
 /* 
 user u =[select id ,profile.Id from user where id=:Userinfo.getUserId()];     
 List<Central_Hub__Share> fafShare = [select id,UserOrGroupId,ParentId from Central_Hub__Share where ParentId = :recordId and UserOrGroupId = :u.Id and
                                     (AccessLevel = 'Edit' or AccessLevel = 'All')];
 if(fafShare.size() == 0 && u.profile.Id ==Label.Apttus_sales_Profile){
    fafiBool=true;
    FAFInstructions=false;
    faflinkBool=true;
    FAFLinks=false;
    billBool=true;      
    BillingOperations=false;  
    networkBool=true;
    NetworkOperations=false;
    specBool=true;
    SpecialtyOperations=false;
    mailBool=true;
    MailOperations=false;
    rebatBool=true;
    RebateOperations=false;
    guarBool=true;
    GuaranteeInformation=false;
    cilnicalBool=true;
    ClinicalOperations=false;
    clientBool=true;
    ClientInformation=false;
    plaformBool=true;
    PlatformSpecifics=false;
    legalInfoBool=true;
    LegalInformation=false;
    disableBool=true;
    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Error: You do not have the authorization to Print this FAF. Please contact the Salesperson specified on the FAF for printing it');
    ApexPages.addMessage(myMsg);
       
   }     
*/   
          
        
    }   
    
    // Method Called on to Update FAF
    
    public PageReference PrintFAF()
    {
     
 //       if(faf.Print_Template__c == null){
 //          ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Please Select Print Template.');
 //           ApexPages.addMessage(myMsg);
 //           return null;            
 //       }
 //       else
          {
            try
            {
//Logic to check FAF Access level for User and then create Temorary Manual Sharing Record if No or Read Access for Sales/Operation user. Needed for Print FAF
             //Functionality.
             XAE_Manual_Share__c cs = XAE_Manual_Share__c.getInstance();
             Boolean Manshare= cs.Share__c;
             user u =[select id ,profile.Id from user where id=:Userinfo.getUserId()];     
             List<Central_Hub__Share> fafShare = [select id,UserOrGroupId,ParentId,AccessLevel from Central_Hub__Share where ParentId = :recordId and UserOrGroupId = :u.Id];
             If ((u.profile.Id ==Label.Apttus_sales_Profile || u.profile.Id ==Label.Apttus_Operations_Profile_Id) && Manshare == true)
             {
                 if(fafShare.size() > 0 ){
                      for (Central_Hub__Share fafs : fafShare )
                       {
                         if (fafs.AccessLevel == 'All') {
                          List<Central_Hub_Share_Modify__c> Sharemdt = [select FAFShareId__c,FAFId__c,Old_Accesslevel__c,New_Accesslevel__c,UserOrGroupId__c from Central_Hub_Share_Modify__c where FAFShareId__c = :fafs.Id];
                          if(Sharemdt.size() == 0 ){
                          Central_Hub_Share_Modify__c sharenewmdt = new Central_Hub_Share_Modify__c();
                          sharenewmdt.FAFId__c= fafs.ParentId;
                          sharenewmdt.FAFShareId__c= fafs.Id;
                          sharenewmdt.New_AccessLevel__c = 'All';
                          sharenewmdt.Old_AccessLevel__c = 'All';
                          sharenewmdt.UserOrGroupId__c = fafs.UserOrGroupId;
                          Insert sharenewmdt;
                      }}
                      if (fafs.AccessLevel == 'Edit') {
                          List<Central_Hub_Share_Modify__c> Sharemdt = [select FAFShareId__c,FAFId__c,Old_Accesslevel__c,New_Accesslevel__c,UserOrGroupId__c from Central_Hub_Share_Modify__c where FAFShareId__c = :fafs.Id];
                          if(Sharemdt.size() == 0 ){
                          Central_Hub_Share_Modify__c sharenewmdt = new Central_Hub_Share_Modify__c();
                          sharenewmdt.FAFId__c= fafs.ParentId;
                          sharenewmdt.FAFShareId__c= fafs.Id;
                          sharenewmdt.New_AccessLevel__c = 'Edit';
                          sharenewmdt.Old_AccessLevel__c = 'Edit';
                          sharenewmdt.UserOrGroupId__c = fafs.UserOrGroupId;
                          Insert sharenewmdt;
                      }}
                                              }
                 }
                  
                 if(fafShare.size() == 0 ){
                     Central_Hub__Share fafsharenew = new Central_Hub__Share(); 
                     fafsharenew.ParentId= faf.Id;
                     fafsharenew.AccessLevel = 'Edit';
                     fafsharenew.Rowcause = 'Manual';
                     fafsharenew.UserOrGroupId = u.Id;
                     Insert fafsharenew;
                }
                 for (Central_Hub__Share fafs : fafShare )
                 {
                 
                     if(fafs.AccessLevel == 'Read' && u.profile.Id ==Label.Apttus_sales_Profile){ 
                         fafs.AccessLevel = 'Edit';
                         Update fafs;
                         List<Central_Hub_Share_Modify__c> fafSharemdt = [select FAFShareId__c,FAFId__c,Old_Accesslevel__c,New_Accesslevel__c,UserOrGroupId__c from Central_Hub_Share_Modify__c where FAFShareId__c = :fafs.Id];
                         if(fafSharemdt.size() == 0 ){
                           Central_Hub_Share_Modify__c fafsharenewmdt = new Central_Hub_Share_Modify__c();
                                 fafsharenewmdt.FAFId__c= fafs.ParentId;
                                 fafsharenewmdt.FAFShareId__c= fafs.Id;
                                 fafsharenewmdt.New_AccessLevel__c = 'Edit';
                                 fafsharenewmdt.Old_AccessLevel__c = 'Read';
                                 fafsharenewmdt.UserOrGroupId__c = fafs.UserOrGroupId;
                                 Insert fafsharenewmdt;
                                                  }
                        }
            
                  }
            }
                 
                List<FAF_Link__c> faflinkList = [select Full_FAF__c,Partial_FAF__c from FAF_Link__c where Partial_FAF__c = : faf.id ];
                 system.debug('--faflinkList---'+faflinkList.size());
                
                 List<FAF_Print_Link__c> printLinkToInsert = new List<FAF_Print_Link__c>();

                 list<faf_print_link__c> printlinklist = [select id from faf_print_link__c where faf_related__c =: faf.id or FAF_ID__c =: faf.id];
                 system.debug('---printlinklist to delete----'+printlinklist.size());
                 delete printlinklist;
                 
                if(faflinkList.size()>0){
                 for(FAF_Link__c faflink: faflinkList ){ 
                    FAF_Print_Link__c printLink = new FAF_Print_Link__c();
                    printLink.FAF_ID__c = faflink.Partial_FAF__c ;
                    printLink.FAF_Related__c = faflink.Full_FAF__c;
                    printLinkToInsert.add(printLink);
                  } 
                   system.debug('---printLinkToInsert--'+printLinkToInsert.size());
                    insert printLinkToInsert;
                        
                }
                
                List<FAF_Print__c> PrintToInsert = new List<FAF_Print__c>();                           
                FAF_Print__c printFAF = new FAF_Print__c();
                printFAF.FAF_Print_Billing_Ops__c = BillingOperations;
                printFAF.FAF_Print_Client_Info__c = ClientInformation;
                printFAF.FAF_Print_Clinical_Ops__c = ClinicalOperations;
                printFAF.FAF_Print_Guarantee_Info__c = GuaranteeInformation;
                printFAF.FAF_Print_Instructions__c = FAFInstructions;
                printFAF.FAF_Print_Legal__c = LegalInformation;
                printFAF.FAF_Print_Links__c = FAFLinks;
                printFAF.FAF_Print_Mail_Ops__c = MailOperations;
                printFAF.FAF_Print_Network_Ops__c = NetworkOperations;
                printFAF.FAF_Print_Platform_Specifics__c = PlatformSpecifics;
                printFAF.FAF_Print_Rebate_Ops__c = RebateOperations;
                printFAF.FAF_Print_Specialty_Ops__c = SpecialtyOperations;
                printFAF.FAF__c= faf.id;
                printFAF.Status__c = 'Submitted';  
                
                PrintToInsert.add(printFAF);
                insert PrintToInsert; 
                List<user> UpdateUser = new List<user>();
                List<user> ulist =[select id,User_Access_Clinical__c,User_Access_Specialty__c,User_Access_Rebate__c,User_Access_Platform_Specifics__c,User_Access_Network__c,User_Access_Mail__c,User_Access_Links__c,User_Access_Billing__c,User_Access_Client_Info__c,User_Access_Guarantee__c,User_Access_Instructions__c,User_Access_Legal__c from user where id=:Userinfo.getUserId()];                             
                for (user urec : ulist) {
                    urec.User_Access_Billing__c = BillingOperations;
                    urec.User_Access_Client_Info__c = ClientInformation;
                    urec.User_Access_Clinical__c = ClinicalOperations;
                    urec.User_Access_Guarantee__c = GuaranteeInformation;
                    urec.User_Access_Instructions__c = FAFInstructions;
                    urec.User_Access_Legal__c = LegalInformation;
                    urec.User_Access_Links__c = FAFLinks;
                    urec.User_Access_Mail__c = MailOperations;
                    urec.User_Access_Network__c = NetworkOperations;
                    urec.User_Access_Platform_Specifics__c = PlatformSpecifics;
                    urec.User_Access_Rebate__c = RebateOperations;
                    urec.User_Access_Specialty__c = SpecialtyOperations;               
                    UpdateUser.add(urec);
                }
                update UpdateUser ;                                                                   

                List<Id> PrintIds = new List<Id>();
                List<FAF_Print__c> pp = [SELECT id from FAF_Print__c where faf__c =: faf.id order by CreatedDate desc limit 1];
                if (pp.size() > 0) {
                    for (FAF_Print__c np: pp) {
                        PrintIds.add(np.id);
                    }               
                    if (Label.FAF_Print_Background != 'TRUE')  
                        WordDocToPDFGenerator.convertWordToPDF(PrintIds);
                }                                                       
                return new PageReference('/'+recordId);       
            }
            catch(Exception e)
            {
               /*Logic to Display Error Message during update of FAF*/ 
               ApexPages.addMessages(e);  
               return null;
            } 
        }       
    } 
    /* =================================================================================
     * @Method Name       : Cancel
     * @author            : Anudeep Dale
     * @created date      : 10/17/2018
     * @Purpose           : Print FAF functionality
    =======================================================================================*/   
    public PageReference Cancel(){
      return new PageReference('/'+recordId);
    }   
}