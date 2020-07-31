global class FAFEditPageController {
    
  Public Boolean showerrorBool{get;set;}
  Public Boolean isPriv{get;set;}
  public Central_Hub__c fafInfo{get;set;}
  public string fafId{get;set;}
  public Boolean PlatSpecFlag{get;set;}
  public Boolean dispRevoke{get;set;}
  public Boolean PlatSpecFlag1{get;set;}
  public Boolean ROPWarning{get;set;}
  public string ROPWarningErr{get;set;}
  public Boolean BAWarning{get;set;}
  public string BAWarningErr{get;set;}
  Public List<Platform_Specifics__c> platSpecList;
  Public List<Platform_Specifics__c> platSpecList1;
    public FAFEditPageController(ApexPages.StandardController controller) {
            
            PlatSpecFlag = false;
            PlatSpecFlag1 = false;
            dispRevoke= true;
            platSpecList = new List<Platform_Specifics__c>();
            platSpecList1 = new List<Platform_Specifics__c>();
            showerrorBool = false;
            fafId = ApexPages.currentPage().getParameters().get('id'); 
            Id oppId = ApexPages.currentPage().getParameters().get(label.FAFOpportunityLabel);// Get Parent Opp record Id from URL
            if(fafId == null){   
                if(oppId == null){
                    showerrorBool = true;
                   
                }
                fafInfo = new Central_Hub__c();
                isPriv = false;
            }
            else{
               /*****W-000540 start*******/
                   List<Central_Hub__c> Temp= new List<Central_Hub__c>();
                    Temp =[select id,(select id,Year__c,LOB__c,Admin_Fee_Type__c  from Billing_Admin_Fees__r where Admin_Fee_Type__c IN ('RTMD PEPM','RTMD Per All Claims','RTMD PMPM')),
                            (select id from Rebate_Operations__r where Rebate_RTMD__c=true) 
                           from Central_Hub__c where Client_Subtype__c IN ('Coalition Master','TPA Master','Health Plan Master') and id=:fafId];
                           
                    if(!Temp.isEmpty() && temp[0].Billing_Admin_Fees__r!=null && !temp[0].Billing_Admin_Fees__r.isEmpty()&& temp[0].Rebate_Operations__r!=null && temp[0].Rebate_Operations__r.isEmpty()){
                        BAWarning=true;
                        BAWarningErr='Billing Administrative Fees: '+temp[0].Billing_Admin_Fees__r[0].Year__c+', '+ temp[0].Billing_Admin_Fees__r[0].LOB__c+', '+ temp[0].Billing_Admin_Fees__r[0].Admin_Fee_Type__c+ ' - The Rebate RTMD? Flag on Rebate Operations is expected to be to set to True, when there is at least one RTMD Admin Fee Type value populated on Billing Administrative Fees records.';

                    }
                    if(!Temp.isEmpty() && temp[0].Billing_Admin_Fees__r!=null && temp[0].Billing_Admin_Fees__r.isEmpty() && temp[0].Rebate_Operations__r!=null && !temp[0].Rebate_Operations__r.isEmpty()){
                        ROPWarning=true;
                        ROPWarningErr='Rebate Operations - At least one RTMD Admin Fee Type value is expected on Billing Administrative Fees records when Rebate RTMD? flag on Rebate Operations is set to True.';

                    }
               /*****W-000540 End******/
                isPriv = false; 
                 Id userProfileID = userinfo.getProfileId();
                 Id salesProfileID = [select id from Profile where name= 'Apttus Sales'].id;
                 Id uwProfileID = [select id from Profile where name= 'Apttus Underwriting'].id;
                 Id operationProfileID = [select id from Profile where name= 'Apttus Operations'].id;
                 Central_Hub__c fafObj= [select id,FAF_Status__c,Salesperson__c,Underwriter__c from Central_Hub__c where id =: fafId];
                  if((userProfileID == salesProfileID) || (userProfileID == operationProfileID)){
                    isPriv=true;
                 }
                 if((UserInfo.getUserId() == fafObj.Salesperson__c) && (userProfileID == salesProfileID ) ){
                    isPriv=false;
                 }
                 //if (fafObj.FAF_Status__c == 'Implemented' && UserInfo.getUserId() != fafObj.Underwriter__c){
                 if (fafObj.FAF_Status__c == 'Implemented' && (userProfileID != uwProfileID )){
                     dispRevoke = false;    
                 }
            List<User>  man1 = [Select Id from User where ManagerId = :UserInfo.getUserId()];
            if (man1.size() > 0 )
            {
             for(User man1item : man1)
             {
              List<Central_Hub__c> salesman1 = [select Salesperson__c from Central_Hub__c where Id = : fafId and Salesperson__c = :man1item.Id];
              if (salesman1.size() > 0 )
              {
                  isPriv=false;
              }
             }  
            }
            
            List<User>  man2level = [Select Name from User where Id = :UserInfo.getUserId()];
            if (man2level.size() > 0 )
            {
            for(User man2levelitem : man2level)
            {
            List<User>  man2 = [Select Id from User where Manager_Level_2__c = :man2levelitem.Name];
            if (man2.size() > 0 )
            {
             for(User man2item : man2)
             {
              List<Central_Hub__c> salesman2 = [select Salesperson__c from Central_Hub__c where Id = : fafId and Salesperson__c = :man2item.Id];
              if (salesman2.size() > 0 )
              {
                    isPriv=false;
              }
             }  
            }
            }}
               
            List<User>  man3level = [Select Name from User where Id = :UserInfo.getUserId()];
            if (man3level.size() > 0 )
            {
            for(User man3levelitem : man2level)
            {
            List<User>  man3 = [Select Id from User where Manager_Level_3__c = :man3levelitem.Name];
            if (man3.size() > 0 )
            {
             for(User man3item : man3)
             {
              List<Central_Hub__c> salesman3 = [select Salesperson__c from Central_Hub__c where Id = : fafId and Salesperson__c = :man3item.Id];
              if (salesman3.size() > 0 )
              {
                     isPriv=false;
   
              }
             }  
            }
            }}
               
            List<User>  man4level = [Select Name from User where Id = :UserInfo.getUserId()];
            if (man4level.size() > 0 )
            {
            for(User man4levelitem : man4level)
            {
            List<User>  man4 = [Select Id from User where Manager_Level_4__c = :man4levelitem.Name];
            if (man4.size() > 0 )
            {
             for(User man4item : man4)
             {
              List<Central_Hub__c> salesman4 = [select Salesperson__c from Central_Hub__c where Id = : fafId and Salesperson__c = :man4item.Id];
              if (salesman4.size() > 0 )
              {
                    isPriv=false;
              }
             }  
            }
            }}   
               
           List<User>  man5level = [Select Name from User where Id = :UserInfo.getUserId()];
            if (man5level.size() > 0 )
            {
            for(User man5levelitem : man5level)
            {
            List<User>  man5 = [Select Id from User where Manager_Level_5__c = :man5levelitem.Name];
            if (man5.size() > 0 )
            {
             for(User man5item : man5)
             {
              List<Central_Hub__c> salesman5 = [select Salesperson__c from Central_Hub__c where Id = : fafId and Salesperson__c = :man5item.Id];
              if (salesman5.size() > 0 )
              {
                  isPriv=false;
              }
             }  
            }
            }}                 
            
            List<User>  man6level = [Select Name from User where Id = :UserInfo.getUserId()];
            if (man6level.size() > 0 )
            {
            for(User man6levelitem : man6level)
            {
            List<User>  man6 = [Select Id from User where Manager_Level_6__c = :man6levelitem.Name];
            if (man6.size() > 0 )
            {
             for(User man6item : man6)
             {
              List<Central_Hub__c> salesman6 = [select Salesperson__c from Central_Hub__c where Id = : fafId and Salesperson__c = :man6item.Id];
              if (salesman6.size() > 0 )
              {
                  isPriv=false;
              }
             }  
            }
            }}         
            
           List<User>  man7level = [Select Name from User where Id = :UserInfo.getUserId()];
            if (man7level.size() > 0 )
            {
            for(User man7levelitem : man7level)
            {
            List<User>  man7 = [Select Id from User where Manager_Level_7__c = :man7levelitem.Name];
            if (man7.size() > 0 )
            {
             for(User man7item : man7)
             {
              List<Central_Hub__c> salesman7 = [select Salesperson__c from Central_Hub__c where Id = : fafId and Salesperson__c = :man7item.Id];
              if (salesman7.size() > 0 )
              {
                  isPriv=false;
              }
             }  
            }
            }}    
            
                DescribeSObjectResult fafInfoDescribeResult = Central_Hub__c.getSObjectType().getDescribe();
                List<String> fafInfoFieldNames = new List<String>( fafInfoDescribeResult.fields.getMap().keySet());
                String fafInfoQuery = ' SELECT '  + String.join( fafInfoFieldNames, ',' ) 
                                 +',CreatedBy.Name FROM '   + fafInfoDescribeResult.getName() +' WHERE '     +' Id = \''+fafId+'\''; 
            
                fafInfo = Database.query(fafInfoQuery);
                
                 if(!string.isBlank(fafId)){
                    platSpecList = [select id,FAF_ID__c from
                     Platform_Specifics__c where FAF_ID__c =:fafId];           
                 }
        if(platSpecList.isempty() && (fafInfo.Client_Subtype__c == 'Coalition Master' 
                                        || fafInfo.Client_Subtype__c == 'Health Plan Master'
                                        || fafInfo.Client_Subtype__c == 'TPA Master' 
                                        || fafInfo.Client_Subtype__c == 'Coalition Member'
                                        || fafInfo.Client_Subtype__c == 'TPA Member')){
          //W-000555 Changes
          PlatSpecFlag = true;
        }
        /*
        if(!platSpecList.isempty() && (fafInfo.Client_Subtype__c == 'Coalition Master' || fafInfo.Client_Subtype__c == 'Health Plan Master' || 
        fafInfo.Client_Subtype__c == 'TPA Master' ) && fafInfo.Pricing_Effective_Date__c != null ){
                    platSpecList1 = [select id,EffectiveDate__c,FAF_ID__c from Platform_Specifics__c where FAF_ID__c =:fafId
          AND EffectiveDate__c != null AND EffectiveDate__c > :fafInfo.Pricing_Effective_Date__c ];          
                    if(platSpecList1.size()>0)
                        PlatSpecFlag1 = true;
        }*/        
        
            }                       
    }
    public pageReference PeerReviewedContinue(){
        
        if((fafInfo.FAF_Status__c == 'Sales Approved' || fafInfo.FAF_Status__c == 'Implemented') && fafInfo.Peer_Reviewed__c == true){
            

            fafInfo.Peer_Reviewed__c = false;
            fafInfo.Peer_Reviewed_By__c = null;
            fafInfo.Reviewed_On__c = null;
            fafInfo.Approved_By_Sales__c = false;
            fafInfo.Sales_Approver__c = null;
            fafInfo.Approved_On__c = null;
//            fafInfo.FAF_Status__c = 'Draft';
           try{
                update fafInfo;
               return new pageReference('/'+fafId);
           }Catch(Exception e){}
            
        }
        return null;
        
    }
    public pageReference PeerReviewedCancel(){
        fafInfo.Peer_Reviewed__c = false;
        
        try{
           // update fafInfo;
               return new pageReference('/'+fafId);
           }Catch(Exception e){} 
        return null;
    }
    public pageReference ApprovedBySalesContinue(){
        
        if((fafInfo.FAF_Status__c == 'Sales Approved' || fafInfo.FAF_Status__c == 'Implemented') && fafInfo.Approved_By_Sales__c == true){
            
         fafInfo.Peer_Reviewed__c = false;
            fafInfo.Peer_Reviewed_By__c = null;
            fafInfo.Reviewed_On__c = null;
            fafInfo.Approved_By_Sales__c = false;
            fafInfo.Sales_Approver__c = null;
            fafInfo.Approved_On__c = null;
//            fafInfo.FAF_Status__c = 'Draft';
           try{
            update fafInfo;
               return new pageReference('/'+fafId);
           }Catch(Exception e){
               
           }
        }
        return null;

    }
    public pageReference ApprovedBySalesCancel(){
        fafInfo.Approved_By_Sales__c = false;
        
        try{
           // update fafInfo;
               return new pageReference('/'+fafId);
           }Catch(Exception e){} 
        return null;
    }   
   
    
    /*public pageReference Save(){
        try{
            if(fafId == null || fafId == ''){
                insert fafInfo;
                return new pageReference('/'+fafInfo.Id+'?refresh=true');
            }else{
                update fafInfo;
                return new pageReference('/'+fafInfo.Id+'?refresh=true');
            }
                   // upsert fafInfo;
                    //fafId=fafInfo.Id;
                   // return new pageReference('/'+fafInfo.Id+'&test=1');
                    PageReference acctPage = new ApexPages.StandardController(fafInfo).view();
        acctPage.setRedirect(true);
        return acctPage;
            
            //return null;
        }
        catch(System.DmlException e){ 
            for(integer i =0; i < e.getNumDml(); i++){
                
                ApexPages.Message msg = new apexPages.Message(Apexpages.Severity.ERROR, e.getdmlMessage(i));
                ApexPages.addMessage(msg);
            }
            return null;
        }       
    }
    public pageReference cancel(){
        return new pageReference('/'+fafId);
    } */  
    
    /*public pageReference Save(){
        upsert fafInfo;
        fafId=fafInfo.Id;
        return null;
    }*/

    
    @RemoteAction
    global static string calculateRebateEffectiveDate(String businessType,String fafId){
        
        List<Client_Information__c> fafClientInfo = [Select Rebate_Effective_Date__c, 
                                                                Pricing_Effective_Date__c,
                                                                FAF_ID__r.Business_Type__c
                                                                    from 
                                                                    Client_Information__c
                                                                    Where
                                                                    FAF_ID__c =: fafId];
                                        //newFaf.values()[0].addError('the error is' + fafClientInfo[0].FAF_ID__r.Business_Type__c);
        //List<Client_Information__c> fafClientInfoToUpdate = new List<Client_Information__c>();
        //for(Client_Information__c fafClientInfoRec : fafClientInfo){
        if(fafClientInfo.size() > 0){
            if(businessType == 'New' || businessType == 'Add On'){
                fafClientInfo[0].Rebate_Effective_Date__c = fafClientInfo[0].Pricing_Effective_Date__c;
                //newFaf.values()[0].addError('the error is' + fafClientInfo);
            }
            else if(businessType == 'Existing' && fafClientInfo[0].Pricing_Effective_Date__c <> null){
                Date quaterStartDate;
                if(fafClientInfo[0].Pricing_Effective_Date__c.Month() <= 3){
                     quaterStartDate = Date.newInstance(fafClientInfo[0].Pricing_Effective_Date__c.Year(), 1,1);   
                }
                else if(fafClientInfo[0].Pricing_Effective_Date__c.Month() <= 6){ 
                    quaterStartDate = Date.newInstance(fafClientInfo[0].Pricing_Effective_Date__c.Year(), 4,1);
                }
                else if(fafClientInfo[0].Pricing_Effective_Date__c.Month() <= 9){
                    quaterStartDate = Date.newInstance(fafClientInfo[0].Pricing_Effective_Date__c.Year(), 7,1);   
                }
                else{ 
                    quaterStartDate = Date.newInstance(fafClientInfo[0].Pricing_Effective_Date__c.Year(), 10,1);
                }
                
                if(fafClientInfo[0].Pricing_Effective_Date__c == quaterStartDate){
                    fafClientInfo[0].Rebate_Effective_Date__c = quaterStartDate;
                }
                else{
                    fafClientInfo[0].Rebate_Effective_Date__c =  quaterStartDate.AddMonths(3);
                }
                //newFaf.values()[0].addError('the error is' +  fafClientInfoRec.Rebate_Effective_Date__c);
            }
            else if(fafClientInfo[0].Pricing_Effective_Date__c == null){
                fafClientInfo[0].Rebate_Effective_Date__c = null;
            }
            //fafClientInfoToUpdate.add(fafClientInfoRec);
            if(fafClientInfo[0].Rebate_Effective_Date__c != null){
                //return String.valueOf(fafClientInfo[0].Rebate_Effective_Date__c);
                return fafClientInfo[0].Rebate_Effective_Date__c.month() + '/' + fafClientInfo[0].Rebate_Effective_Date__c.day() + '/' + fafClientInfo[0].Rebate_Effective_Date__c.year();
            }
            else{
                return 'Rebate Effective Date Not Defined';
            }
        }
        return 'Rebate Effective Date Not Defined';
    }   

}