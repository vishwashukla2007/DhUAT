public class clientInfomationDetails{
    public ApexPages.StandardController con;
    Public Map<string, string> yearValMap;
    Public Boolean popupBool{get; set;}
    Public Boolean isInValid{get; set;}
    Public Boolean isPriv{get; set;}
    Public String popupActionValue{get; set;}
    Public Boolean valueChangeBool{get; set;}
    public set<String> yearUpdateBlankSet;
    Public List<Billing_Administrative_Fees__C>billingAdminList;
    Public List<Billing_Ancillary_Fee__c>billingAncillaryList;
    Public List<Contractual_Payments__c>billingOtherPaymentsList;
    Public List<Billing_Broker_TPA_Payments__c  >billingTPAList;
    //Public List<Medicare_Part_D_Fees_Schedule__c>medicarePartDList;
    Public List<Rebate_Guarantees__c>rebateGuaranteesList;
    Public List<Rebate_Gtees_Specialty_Class_Carve_Outs__c>gteesCarveOutsList;
    Public List<Specialty_Pricing__c>specialtyPricingList;
    Public List<Specialty_Drug_Level_Pricing__c>specialtyDrugLevelList;
    Public List<Specialty_Legacy_Drug_Level_pricing__c>specialtyLegacyDrugLevelList;
    Public List<Gnc_Guarantee__c>aspGuaranteeList;
    Public List<Trend_Guarantee__c  >trendGuaranteeList;
    Public List<Clinical_Solutions__c>clinicalSolutionsList;
    Public List<Mail_Pricing__c>mailPricingList;
    Public List<Network_Pricing__c>networkPricingList;
    public clientInfomationDetails(ApexPages.StandardController controller) {
      
        recordId = ApexPages.currentPage().getParameters().get('id');
        hidePricingEffective = false;
        hideClientName = false;
        showEscalatingPrice = false;
        if(recordId == null || recordId == ''){
           clientInfo = new Client_Information__c();
        }   
        else{
            DescribeSObjectResult clientInfoDescribeResult = Client_Information__c.getSObjectType().getDescribe();
            List<String> clientInfoFieldNames = new List<String>( clientInfoDescribeResult.fields.getMap().keySet());
            String clientInfoQuery = ' SELECT '  + String.join( clientInfoFieldNames, ',' ) 
                             +',CreatedBy.Name,FAF_ID__r.Client_Subtype__c FROM '   + clientInfoDescribeResult.getName() +' WHERE '     +' Id = \''+recordId+'\''; 
        
            clientInfo = Database.query(clientInfoQuery);
            yearValMap = new Map<string, string>{'year1Val'=>clientInfo.Year_1__c, 'year2Val'=>clientInfo.Year_2__c, 'year3Val'=>clientInfo.Year_3__c, 'year4Val'=>clientInfo.Year_4__c, 'year5Val'=>clientInfo.Year_5__c};
            yearUpdateBlankSet = new set<String>();
            system.debug('======yearValMap====='+yearValMap);
            if(!clientInfo.Escalating_Pricing__c){
                dispEscalatingPrice = false;
            }
            else{
                dispEscalatingPrice = true;
            }
            hidePricingEffectiveMethod();
            //rebateEffectiveDate();
            Id userProfileID = userinfo.getProfileId();
            Id salesProfileID = [select id from Profile where name= 'Apttus Sales'].id;
            Id operationProfileID = [select id from Profile where name= 'Apttus Operations'].id;
            if (operationProfileID == userProfileID)
            {
            isPriv = true;
            }
            if((clientInfo.FAF_ID__r.Client_Subtype__c == 'Coalition Member' || clientInfo.FAF_ID__r.Client_Subtype__c == 'Health Plan Member' || clientInfo.FAF_ID__r.Client_Subtype__c == 'TPA Member' || clientInfo.FAF_ID__r.Client_Subtype__c == 'Stand-alone'|| clientInfo.FAF_ID__r.Client_Subtype__c == '==Null') && salesProfileID == userProfileID ) {
                isInValid = true;
                isPriv = false;
                }else{
                     isInValid = false;
                     
                     if ((salesProfileID == userProfileID)&& (clientInfo.FAF_ID__r.Client_Subtype__c == Label.Subtype_Health_Plan_Master  || clientInfo.FAF_ID__r.Client_Subtype__c == Label.Subtype_Coalition_Master  || clientInfo.FAF_ID__r.Client_Subtype__c == Label.Subtype_TPA_Master) || test.isRunningTest())
                     {
                           isPriv = true;
                           user u =[select id ,Name, profile.Id from user where id=:Userinfo.getUserId()];
                           Client_Information__c clientInfor = [select Client_Subtype__c,FAF_ID__r.Account_Name__c,FAF_ID__r.Id,FAF_ID__r.Opportunity_Name__c,FAF_ID__r.Oppty_Winner_Formula__c,FAF_ID__r.Med_D_Sales_Lead_Formula__c,FAF_ID__r.Account_Name__r.iUMS_Client_Subtype__c from Client_Information__c where id=: clientInfo.Id];
                           if (clientInfor.FAF_ID__r.Med_D_Sales_Lead_Formula__c == u.Name || clientInfor.FAF_ID__r.Oppty_Winner_Formula__c == u.Name)
                              {
                                  isPriv = false;
                              }   

                           List<Central_Hub__c> sales = [select Salesperson__c from Central_Hub__c where Id = :clientInfor.FAF_ID__r.Id];
                           if(sales.size() > 0 )   
                             {
                             for(Central_Hub__c salesitem : sales)
                              {
                              if (salesitem.Salesperson__c == u.Id)
                              {
                                  isPriv = false;  
                              }
                              }   
                             }  
                        List<User>  man1 = [Select Id from User where ManagerId = :u.Id];
                        if (man1.size() > 0 )
                        {
                        for(User man1item : man1)
                        {
                        List<Central_Hub__c> salesman1 = [select Salesperson__c from Central_Hub__c where Id = :clientInfor.FAF_ID__r.Id and Salesperson__c = :man1item.Id];
                        if (salesman1.size() > 0 )
                        {
                         isPriv = false;
                        }
                        }  
                        }
            
                        List<User>  man2level = [Select Name from User where Id = :u.Id];
                        if (man2level.size() > 0 )
                        {
                        for(User man2levelitem : man2level)
                        {
                        List<User>  man2 = [Select Id from User where Manager_Level_2__c = :man2levelitem.Name];
                        if (man2.size() > 0 )
                        {
                        for(User man2item : man2)
                        {
                        List<Central_Hub__c> salesman2 = [select Salesperson__c from Central_Hub__c where Id = :clientInfor.FAF_ID__r.Id and Salesperson__c = :man2item.Id];
                        if (salesman2.size() > 0 )
                        {
                         isPriv = false;
                        }
                        }  
                        }
                        }}
               
            List<User>  man3level = [Select Name from User where Id = :u.Id];
            if (man3level.size() > 0 )
            {
            for(User man3levelitem : man2level)
            {
            List<User>  man3 = [Select Id from User where Manager_Level_3__c = :man3levelitem.Name];
            if (man3.size() > 0 )
            {
             for(User man3item : man3)
             {
              List<Central_Hub__c> salesman3 = [select Salesperson__c from Central_Hub__c where Id = :clientInfor.FAF_ID__r.Id and Salesperson__c = :man3item.Id];
              if (salesman3.size() > 0 )
              {
                  isPriv = false; 
              }
             }  
            }
            }}
               
            List<User>  man4level = [Select Name from User where Id = :u.Id];
            if (man4level.size() > 0 )
            {
            for(User man4levelitem : man4level)
            {
            List<User>  man4 = [Select Id from User where Manager_Level_4__c = :man4levelitem.Name];
            if (man4.size() > 0 )
            {
             for(User man4item : man4)
             {
              List<Central_Hub__c> salesman4 = [select Salesperson__c from Central_Hub__c where Id = :clientInfor.FAF_ID__r.Id and Salesperson__c = :man4item.Id];
              if (salesman4.size() > 0 )
              {
                  isPriv = false;
              }
             }  
            }
            }}   
               
           List<User>  man5level = [Select Name from User where Id = :u.Id];
            if (man5level.size() > 0 )
            {
            for(User man5levelitem : man5level)
            {
            List<User>  man5 = [Select Id from User where Manager_Level_5__c = :man5levelitem.Name];
            if (man5.size() > 0 )
            {
             for(User man5item : man5)
             {
              List<Central_Hub__c> salesman5 = [select Salesperson__c from Central_Hub__c where Id = :clientInfor.FAF_ID__r.Id and Salesperson__c = :man5item.Id];
              if (salesman5.size() > 0 )
              {
                  isPriv = false;
              }
             }  
            }
            }}                 
            
            List<User>  man6level = [Select Name from User where Id = :u.Id];
            if (man6level.size() > 0 )
            {
            for(User man6levelitem : man6level)
            {
            List<User>  man6 = [Select Id from User where Manager_Level_6__c = :man6levelitem.Name];
            if (man6.size() > 0 )
            {
             for(User man6item : man6)
             {
              List<Central_Hub__c> salesman6 = [select Salesperson__c from Central_Hub__c where Id = :clientInfor.FAF_ID__r.Id and Salesperson__c = :man6item.Id];
              if (salesman6.size() > 0 )
              {
                  isPriv = false;
              }
             }  
            }
            }}         
            
           List<User>  man7level = [Select Name from User where Id = :u.Id];
            if (man7level.size() > 0 )
            {
            for(User man7levelitem : man7level)
            {
            List<User>  man7 = [Select Id from User where Manager_Level_7__c = :man7levelitem.Name];
            if (man7.size() > 0 )
            {
             for(User man7item : man7)
             {
              List<Central_Hub__c> salesman7 = [select Salesperson__c from Central_Hub__c where Id = :clientInfor.FAF_ID__r.Id and Salesperson__c = :man7item.Id];
              if (salesman7.size() > 0 )
              {
                  isPriv = false;
              }
             }  
            }
            }}             

            list<AccountTeamMember> atm = [SELECT AccountAccessLevel,AccountId,CaseAccessLevel,ContactAccessLevel,CreatedById,CreatedDate,TeamMemberRole,Title,UserId FROM AccountTeamMember where AccountId = :clientInfor.FAF_ID__r.Account_Name__c and
                                    UserId = :u.id];
            if(atm.size() > 0 ){
            for(AccountTeamMember atmItem : atm)
            {
                List<PlatformSpecific_Roles__mdt> psrmdt = [select Label  from PlatformSpecific_Roles__mdt where Label  = :atmItem.TeamMemberRole];
                 if(psrmdt.size() > 0 )       
                 {
                  isPriv = false;          
                 }
            }  }
                    
                    
                    
            }
                     
           }
            
        }   
    }
    public string recordId{get;set;}
    public Client_Information__c clientInfo{get;set;}    
    public Boolean hidePricingEffective{get;set;}
    public Boolean hideClientName{get;set;}
    public void hidePricingEffectiveMethod(){
        Central_Hub__c  faf = new Central_Hub__c();
        if(clientInfo.FAF_ID__c <> null){
            faf = [select id, Business_Type__c, FAF_Status__c, Client_Subtype__c from Central_Hub__c where id =: clientInfo.FAF_ID__c];
            if(faf.Client_Subtype__c == 'Health Plan Member' || faf.Client_Subtype__c == 'Coalition Member' || faf.Client_Subtype__c == 'TPA Member'){
                hideClientName = true;
           }
              if(faf.FAF_Status__c == 'Implemented'){
              hidePricingEffective = true;
            } 
            else{
                clientInfo.Pricing_Effective_Date__c = null;
                clientInfo.Rebate_Effective_Date__c = null;
            } 
        }
    }
    public void rebateEffectiveDate(){
        Central_Hub__c  faf = new Central_Hub__c();
        if(clientInfo.FAF_ID__c <> null){
            faf = [select id, Business_Type__c, FAF_Status__c from Central_Hub__c where id =: clientInfo.FAF_ID__c];
        }
        if(faf.Business_Type__c == 'New' || faf.Business_Type__c == 'Add On') {
           clientInfo.Rebate_Effective_Date__c = clientInfo.Pricing_Effective_Date__c;
        }
        else if(faf.Business_Type__c == 'Existing' && clientInfo.Pricing_Effective_Date__c <> null){
            Date quaterStartDate;
            if(clientInfo.Pricing_Effective_Date__c.Month() <= 3) quaterStartDate = Date.newInstance(clientInfo.Pricing_Effective_Date__c.Year(), 1,1);
            else if(clientInfo.Pricing_Effective_Date__c.Month() <= 6) quaterStartDate = Date.newInstance(clientInfo.Pricing_Effective_Date__c.Year(), 4,1);
            else if(clientInfo.Pricing_Effective_Date__c.Month() <= 9) quaterStartDate = Date.newInstance(clientInfo.Pricing_Effective_Date__c.Year(), 7,1);
            else quaterStartDate = Date.newInstance(clientInfo.Pricing_Effective_Date__c.Year(), 10,1);
            System.debug(clientInfo.Pricing_Effective_Date__c+'******** Effective Date ********'+clientInfo.Pricing_Effective_Date__c);
            System.debug('******** Quater Start Date ********'+quaterStartDate);
            if(clientInfo.Pricing_Effective_Date__c == quaterStartDate)
               clientInfo.Rebate_Effective_Date__c = quaterStartDate;
            else 
               clientInfo.Rebate_Effective_Date__c =  quaterStartDate.AddMonths(3);
        }
        else if(clientInfo.Pricing_Effective_Date__c == null){
            clientInfo.Rebate_Effective_Date__c = null;
    } 
        
}
    public boolean showEscalatingPrice{get;set;}
    
    
    
    /*****
    public pageReference save(){
        try{
           string errorMessage = '';
           if((clientInfo.Year_1__c == null && clientInfo.Year_2__c == '2') 
               || (clientInfo.Year_3__c == '3' && (clientInfo.Year_1__c == null || clientInfo.Year_2__c == null)) 
               || (clientInfo.Year_4__c == '4' && (clientInfo.Year_1__c == null || clientInfo.Year_2__c == null || clientInfo.Year_3__c == null)) 
               || (clientInfo.Year_5__c == '5' && (clientInfo.Year_1__c ==  null || clientInfo.Year_2__c == null || clientInfo.Year_3__c == null || clientInfo.Year_4__c == null))){
              errorMessage +='You must enter Escalating Pricing Years in chronological order without skipping a previous year.<br/><br/>';
           }
           if(clientInfo.Year_1_End_Date__c <= clientInfo.Year_1_Begin_Date__c || clientInfo.Year_2_End_Date__c <= clientInfo.Year_2_Begin_Date__c || clientInfo.Year_3_End_Date__c <= clientInfo.Year_3_Begin_Date__c || clientInfo.Year_4_End_Date__c <= clientInfo.Year_4_Begin_Date__c || clientInfo.Year_5_End_Date__c <= clientInfo.Year_5_Begin_Date__c){
              errorMessage +='For an Escalating Pricing Year the ‘End Date’ cannot be on or before the ‘Begin Date’.<br/><br/>';
           }
           if(((clientInfo.Year_1__c == '1') && (( clientInfo.Year_1_Begin_Date__c == null) || ( clientInfo.Year_1_End_Date__c ==null))) ||
                (( clientInfo.Year_2__c == '2') && (( clientInfo.Year_2_Begin_Date__c == null) || ( clientInfo.Year_2_End_Date__c ==null))) ||
                (( clientInfo.Year_3__c == '3') && (( clientInfo.Year_3_Begin_Date__c == null) || ( clientInfo.Year_3_End_Date__c ==null))) ||
                (( clientInfo.Year_4__c == '4') && (( clientInfo.Year_4_Begin_Date__c == null) || ( clientInfo.Year_4_End_Date__c ==null))) ||
                ((clientInfo.Year_5__c == '5') && (( clientInfo.Year_5_Begin_Date__c == null) || ( clientInfo.Year_5_End_Date__c ==null))) ){
              errorMessage +='Escalating Pricing ‘Begin Date’ and ‘End Date’ is required when the corresponding ‘Year’ is populated.<br/><br/>';
           }
           if((clientInfo.Year_2_Begin_Date__c <= clientInfo.Year_1_End_Date__c )|| ( clientInfo.Year_3_Begin_Date__c <= clientInfo.Year_1_End_Date__c ) || ( clientInfo.Year_3_Begin_Date__c <= clientInfo.Year_2_End_Date__c ) ||
                ( clientInfo.Year_4_Begin_Date__c <= clientInfo.Year_1_End_Date__c ) || ( clientInfo.Year_4_Begin_Date__c <= clientInfo.Year_2_End_Date__c ) || ( clientInfo.Year_4_Begin_Date__c <= clientInfo.Year_3_End_Date__c ) || 
                ( clientInfo.Year_5_Begin_Date__c <= clientInfo.Year_1_End_Date__c ) || ( clientInfo.Year_5_Begin_Date__c <= clientInfo.Year_2_End_Date__c ) || ( clientInfo.Year_5_Begin_Date__c <= clientInfo.Year_3_End_Date__c ) || 
                ( clientInfo.Year_5_Begin_Date__c <= clientInfo.Year_4_End_Date__c )){
               errorMessage +='Escalating Pricing Year time frame cannot overlap.<br/><br/>';
           }
           if(clientInfo.Year_2_Begin_Date__c.daysBetween(clientInfo.Year_1_End_Date__c) > 1 || clientInfo.Year_3_Begin_Date__c.daysBetween(clientInfo.Year_2_End_Date__c) > 1 || clientInfo.Year_4_Begin_Date__c.daysBetween(clientInfo.Year_3_End_Date__c) > 1 || clientInfo.Year_5_Begin_Date__c.daysBetween(clientInfo.Year_4_End_Date__c) > 1){
               errorMessage +='Escalating Pricing Year time frames need to be in chronological order without any gaps.<br/><br/>';
           }
           if((clientInfo.Year_1__c == '1' && (clientInfo.Year_1_Begin_Date__c == null || clientInfo.Year_1_End_Date__c == null))
              || (clientInfo.Year_2__c == '2' && (clientInfo.Year_2_Begin_Date__c == null || clientInfo.Year_2_End_Date__c == null))
              || (clientInfo.Year_3__c == '3' && (clientInfo.Year_3_Begin_Date__c == null || clientInfo.Year_3_End_Date__c == null))
              || (clientInfo.Year_4__c == '4' && (clientInfo.Year_4_Begin_Date__c == null || clientInfo.Year_4_End_Date__c == null))
              || (clientInfo.Year_5__c == '5' && (clientInfo.Year_5_Begin_Date__c == null || clientInfo.Year_5_End_Date__c == null)))
           {
               errorMessage +='Escalating Pricing ‘Begin Date’ and ‘End Date’ is required when the corresponding ‘Year’ is populated.<br/><br/>';
           }
           if(clientInfo.Escalating_Pricing__c && (clientInfo.Year_1_Begin_Date__c == null || clientInfo.Year_1_End_Date__c == null || clientInfo.Year_2_Begin_Date__c == null || clientInfo.Year_2_End_Date__c == null || clientInfo.Year_1__c == null || clientInfo.Year_2__c == null)){
               errorMessage +='At least two Escalating Pricing information records are required. If you do not wish to include Escalating Pricing information, uncheck the ‘Escalating Pricing’ checkbox.<br/><br/>';
           }
           
           if(errorMessage <> '' && errorMessage <> null){
               ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, errorMessage));
               return null;
           }
           else{
           **/
   
    public pageReference save1(){
  
           try{
               popupBool = false;
               valueChangeBool = false;
               if(recordId == null || recordId == ''){
                   insert clientInfo;
                   return new pageReference('/'+clientInfo.Id);
               }else{
                    
                    //Database.SaveResult result = Database.update(clientInfo,true);
                    //system.debug('=====result.isSuccess()===='+result.isSuccess());
                    //popupBool = result.isSuccess();
                    //if(popupBool){
                        if(yearValMap.get('year1Val') != clientInfo.year_1__c && String.isBlank(clientInfo.year_1__c)){
                            yearUpdateBlankSet.add(ConstantsUtil.ONE);
                            yearUpdateBlankSet.add(ConstantsUtil.TWO);
                            yearUpdateBlankSet.add(ConstantsUtil.THREE);
                            yearUpdateBlankSet.add(ConstantsUtil.FOUR);
                            yearUpdateBlankSet.add(ConstantsUtil.FIVE);
                            valueChangeBool = true;
                        }
                        if(yearValMap.get('year2Val') != clientInfo.year_2__c && String.isBlank(clientInfo.year_2__c)){
                            yearUpdateBlankSet.add(ConstantsUtil.TWO);
                            yearUpdateBlankSet.add(ConstantsUtil.THREE);
                            yearUpdateBlankSet.add(ConstantsUtil.FOUR);
                            yearUpdateBlankSet.add(ConstantsUtil.FIVE);
                            valueChangeBool = true;
                        }
                        if(yearValMap.get('year3Val') != clientInfo.year_3__c && String.isBlank(clientInfo.year_3__c)){
                            yearUpdateBlankSet.add(ConstantsUtil.THREE);
                            yearUpdateBlankSet.add(ConstantsUtil.FOUR);
                            yearUpdateBlankSet.add(ConstantsUtil.FIVE);
                            valueChangeBool = true;
                        }
                        if(yearValMap.get('year4Val') != clientInfo.year_4__c && String.isBlank(clientInfo.year_4__c)){
                            yearUpdateBlankSet.add(ConstantsUtil.FOUR);
                            yearUpdateBlankSet.add(ConstantsUtil.FIVE);
                            valueChangeBool = true;
                        }
                        if(yearValMap.get('year5Val') != clientInfo.year_5__c && String.isBlank(clientInfo.year_5__c)){
                            yearUpdateBlankSet.add(ConstantsUtil.FIVE);
                            valueChangeBool = true;
                        }
                        if(valueChangeBool){
  
                            billingAdminList = [select id from Billing_Administrative_Fees__C where Faf_Id__c =: clientInfo.Faf_Id__c and year__c in: yearUpdateBlankSet];
                            system.debug('==========billingAdminList======='+billingAdminList);
                            billingAncillaryList = [select id from Billing_Ancillary_Fee__c where Faf_Id__c =: clientInfo.Faf_Id__c and year__c in: yearUpdateBlankSet];
                            system.debug('==========billingAncillaryList======='+billingAncillaryList);
                            billingOtherPaymentsList = [select id from Contractual_Payments__c where Faf_Id__c =: clientInfo.Faf_Id__c and Years__c in: yearUpdateBlankSet];
                            system.debug('==========billingOtherPaymentsList======='+billingOtherPaymentsList);
                            billingTPAList = [select id from Billing_Broker_TPA_Payments__c where Faf_Id__c =: clientInfo.Faf_Id__c and year__c in: yearUpdateBlankSet];
                            system.debug('==========billingTPAList======='+billingTPAList);
                            //medicarePartDList = [select id from Medicare_Part_D_Fees_Schedule__c where Faf_Id__c =: clientInfo.Faf_Id__c and year__c in: yearUpdateBlankSet];
                            //system.debug('==========medicarePartDList======='+medicarePartDList);
                            rebateGuaranteesList = [select id from Rebate_Guarantees__c where Faf_Id__c =: clientInfo.Faf_Id__c and year__c in: yearUpdateBlankSet];
                            system.debug('==========rebateGuaranteesList======='+rebateGuaranteesList);
                            gteesCarveOutsList = [select id from Rebate_Gtees_Specialty_Class_Carve_Outs__c where Faf_Id__c =: clientInfo.Faf_Id__c and year__c in: yearUpdateBlankSet];
                            system.debug('==========gteesCarveOutsList======='+gteesCarveOutsList);
                            specialtyPricingList = [select id from Specialty_Pricing__c where Faf_Id__c =: clientInfo.Faf_Id__c and year__c in: yearUpdateBlankSet];
                            system.debug('==========specialtyPricingList======='+specialtyPricingList);
                            specialtyDrugLevelList = [select id from Specialty_Drug_Level_Pricing__c where Faf_Id__c =: clientInfo.Faf_Id__c and year__c in: yearUpdateBlankSet];
                            system.debug('==========specialtyDrugLevelList======='+specialtyDrugLevelList);
                            specialtyLegacyDrugLevelList = [select id from Specialty_Legacy_Drug_Level_pricing__c where Faf_Id__c =: clientInfo.Faf_Id__c and year__c in: yearUpdateBlankSet];
                            system.debug('==========specialtyLegacyDrugLevelList======='+specialtyLegacyDrugLevelList);
                            aspGuaranteeList = [select id from Gnc_Guarantee__c where Faf_Id__c =: clientInfo.Faf_Id__c and year__c in: yearUpdateBlankSet];
                            system.debug('==========aspGuaranteeList======='+aspGuaranteeList);
                            trendGuaranteeList = [select id from Trend_Guarantee__c where Faf_Id__c =: clientInfo.Faf_Id__c and year__c in: yearUpdateBlankSet];
                            system.debug('==========trendGuaranteeList======='+trendGuaranteeList);
                            clinicalSolutionsList = [select id from Clinical_Solutions__c where Faf_Id__c =: clientInfo.Faf_Id__c and year__c in: yearUpdateBlankSet];
                            system.debug('==========clinicalSolutionsList======='+clinicalSolutionsList);
                            mailPricingList = [select id from Mail_Pricing__c where Faf_Id__c =: clientInfo.Faf_Id__c and year__c in: yearUpdateBlankSet];
                            system.debug('==========mailPricingList======='+mailPricingList);
                            networkPricingList = [select id from Network_Pricing__c where Faf_Id__c =: clientInfo.Faf_Id__c and year__c in: yearUpdateBlankSet];
                            system.debug('==========networkPricingList======='+networkPricingList);
                            
                            if(billingAdminList.isEmpty() && billingAncillaryList.isEmpty() && billingOtherPaymentsList.isEmpty() && billingTPAList.isEmpty() && rebateGuaranteesList.isEmpty() && gteesCarveOutsList.isEmpty() && specialtyPricingList.isEmpty() && specialtyDrugLevelList.isEmpty() && specialtyLegacyDrugLevelList.isEmpty() && aspGuaranteeList.isEmpty() && trendGuaranteeList.isEmpty() && clinicalSolutionsList.isEmpty() && mailPricingList.isEmpty() && networkPricingList.isEmpty()){
                                valueChangeBool = false;
                            }
                        }
               }
               system.debug('==========yearUpdateBlankSet========'+yearUpdateBlankSet);
               if(!valueChangeBool){
                   clientInfo.Last_Modified_Date__c = datetime.Now();
                   update clientInfo;
                   return new pageReference('/'+clientInfo.Id);
               }
               //return new pageReference('/'+clientInfo.Id);
               return null;
            
        }
        
        catch(System.DmlException e){ 
           for(integer i =0; i < e.getNumDml(); i++){
               System.debug('************'+e.getDmlMessage(i));
               ApexPages.Message msg = new apexPages.Message(Apexpages.Severity.ERROR, e.getdmlMessage(i));
               ApexPages.addMessage(msg);
           }
           return null;
         }       
    }
    public pageReference cancel(){
        return new pageReference('/'+recordId);
    }


    public boolean displayPopUp1 {get;set;}
    public  boolean dispEscalatingPrice {get;set;}
    public boolean clearEscaltingPrices = false;
    public void escalatingPriceSelected(){
        if(!clientInfo.Escalating_Pricing__c){
            displayPopUp1 = true;
            //dispEscalatingPrice 
        }
        else{
            displayPopUp1 = false;
            dispEscalatingPrice = true;
        }
    }
    

    public void yesDeleteEscaltingPrice(){
         System.debug('***** Clear Info ******');
        
         clientInfo.Year_1__c= null;
         clientInfo.Year_1_Begin_Date__c = null;
         clientInfo.Year_1_End_Date__c = null;
         clientInfo.Year_2__c= null;
         clientInfo.Year_2_Begin_Date__c= null;
         clientInfo.Year_2_End_Date__c= null;
         clientInfo.Year_3__c= null;
         clientInfo.Year_3_Begin_Date__c = null;
         clientInfo.Year_3_End_Date__c = null;
         clientInfo.Year_4__c= null;
         clientInfo.Year_4_Begin_Date__c= null;
         clientInfo.Year_4_End_Date__c= null;
         clientInfo.Year_5__c= null;
         clientInfo.Year_5_Begin_Date__c= null;
         clientInfo.Year_5_End_Date__c= null;
         //clientInfo.Additional_Client_Info__c = 'added';
         dispEscalatingPrice = false;
         displayPopUp1 = false;
         System.debug('***** YEAR 1 ******'+clientInfo.Year_1__c);
    }
    
    public void cancelPopUp(){
        clientInfo.Escalating_Pricing__c = true;
        dispEscalatingPrice = true;
        system.debug('the uncheck value is' + clientInfo.Escalating_Pricing__c);
        displayPopUp1 = false;
    }

    public pageReference deleteRecordsAction(){
        try{
        if(popupActionValue == 'Continue'){
            update clientInfo;
            if(billingAdminList.size() > 0){
                delete billingAdminList;
            }
            if(billingAncillaryList.size() > 0){
                delete billingAncillaryList;
            }
            if(billingOtherPaymentsList.size() > 0){
                delete billingOtherPaymentsList;
            }
            if(billingTPAList.size() > 0){
                delete billingTPAList;
            }          
            if(rebateGuaranteesList.size() > 0){
                delete rebateGuaranteesList;
            }
            if(gteesCarveOutsList.size() > 0){
                delete gteesCarveOutsList;
            }
            if(specialtyPricingList.size() > 0){
                delete specialtyPricingList;
            }
            if(specialtyDrugLevelList.size() > 0){
                delete specialtyDrugLevelList;
            }
            if(specialtyLegacyDrugLevelList.size() > 0){
                delete specialtyLegacyDrugLevelList;
            }
             if(aspGuaranteeList.size() > 0){
                delete aspGuaranteeList;
            }  
            if(trendGuaranteeList.size() > 0){
                delete trendGuaranteeList;
            }
            if(clinicalSolutionsList.size() > 0){
                delete clinicalSolutionsList;
            }
            if(mailPricingList.size() > 0){
                delete mailPricingList;
            }
            if(networkPricingList.size() > 0){
                delete networkPricingList;
            }
            return new pageReference('/'+clientInfo.Id);
        }
        }catch(System.DmlException e){ 
           for(integer i =0; i < e.getNumDml(); i++){
               System.debug('************'+e.getDmlMessage(i));
               ApexPages.Message msg = new apexPages.Message(Apexpages.Severity.ERROR, e.getdmlMessage(i));
               ApexPages.addMessage(msg);
           }
           return null;
        }   
        
        return null;
    }
  
}