public class AccountTriggerHandler {

    Public Static void afterUpdate(Map<Id, Account> newMap, Map<Id, Account> oldMap){
      try {
        Set<String> iUMSClientSubtypeSet = new Set<String>{'Coalition Master','Health Plan Master','Stand-alone','TPA Master'};
        Set<Id> accIdsToClearValues = new Set<Id>();
        for(Account accRec : newMap.values()){
            if(accRec.iUMS_Client_Subtype__c != null){
                if(iUMSClientSubtypeSet.contains(accRec.iUMS_Client_Subtype__c) && accRec.iUMS_Client_Subtype__c != oldMap.get(accRec.Id).iUMS_Client_Subtype__c){
                    accIdsToClearValues.add(accRec.Id);
                }  
            }
            else{
                accIdsToClearValues.add(accRec.Id);
            }
        }
        if(!accIdsToClearValues.isEmpty()){
            List<Central_Hub__c> centralHubLst = [Select Id from Central_Hub__c Where Account_Name__C IN: accIdsToClearValues];
            if(!centralHubLst.isEmpty()){
                List<Client_Information__c> clientInfoLstToClearValues = [Select Id, Master_Client_Name__c from Client_Information__c where FAF_ID__c IN: centralHubLst];
                for(Client_Information__c CIRec : clientInfoLstToClearValues){
                    CIRec.Master_Client_Name__c = null;
                }
              if(!clientInfoLstToClearValues.isEmpty()){
                    List<Profile> PROFILE = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() LIMIT 1];
                    String ProfileId = PROFILE[0].Id;
                    Enable_Process_Builder__c pb = Enable_Process_Builder__c.getInstance(ProfileId);
                    Disable_Validation_AccountSubtype__c dv = Disable_Validation_AccountSubtype__c.getOrgDefaults();
                    pb.PB_FAF__c = false;
                    dv.Disable_Validation__c = true;
                    upsert pb;
                    upsert dv;
                    update clientInfoLstToClearValues;
                    pb.PB_FAF__c = true;
                    dv.Disable_Validation__c = false;
                    upsert pb;
                    upsert dv;
                }
            }
        }}
       catch (Exception e) {    
           Trigger.new[0].addError(e.getMessage());   
             
         }       
    }
 
   /*=================================================================================================================================
     * @Method Name       : fafShareWithAccountTeam
     * @author            : Accenture
     * @Last modified by  : Accenture
     * @Last modified date: 28/11/2018
     * @Purpose           : Method to get AccountId when iums Client Sub Type value changed
    ==================================================================================================================================*/
   Public Static void fafShareWithAccountTeam(Map<Id, Account> newMap, Map<Id, Account> oldMap){
        Set<Id>AccountIdSetMaster = new Set<Id>();   //For store the Account Id
        Set<Id>AccountIdSetNonMaster = new Set<Id>();
        for(Account acc: newMap.values()){
            //creating Account Id Set where updated value of iums client subtype contains Master but old value dont contain the same
            if(!string.isBlank(acc.iUMS_Client_Subtype__c) && string.isBlank(oldMap.get(acc.id).iUMS_Client_Subtype__c)){
                if(acc.iUMS_Client_Subtype__c.contains(ConstantsUtil.Master)){
                    AccountIdSetMaster.add(acc.id);    //Adding AccountId in the AccountIdSetMaster
                }
            }else if(string.isBlank(acc.iUMS_Client_Subtype__c) && !string.isBlank(oldMap.get(acc.id).iUMS_Client_Subtype__c)){
                if(oldMap.get(acc.id).iUMS_Client_Subtype__c.contains(ConstantsUtil.Master)){
                    AccountIdSetNonMaster.add(acc.id);    //Adding AccountId in the AccountIdSetNonMaster
                }
            }else if(!string.isBlank(acc.iUMS_Client_Subtype__c) && !string.isBlank(oldMap.get(acc.id).iUMS_Client_Subtype__c)){
                if((acc.iUMS_Client_Subtype__c != oldMap.get(acc.id).iUMS_Client_Subtype__c) && acc.iUMS_Client_Subtype__c.contains(ConstantsUtil.Master)
                && !oldMap.get(acc.id).iUMS_Client_Subtype__c.contains(ConstantsUtil.Master)){
                    AccountIdSetMaster.add(acc.id);    //Adding AccountId in the AccountIdSetMaster
                }else if((acc.iUMS_Client_Subtype__c != oldMap.get(acc.id).iUMS_Client_Subtype__c) && !acc.iUMS_Client_Subtype__c.contains(ConstantsUtil.Master)
                && oldMap.get(acc.id).iUMS_Client_Subtype__c.contains(ConstantsUtil.Master)){//creating Account Id Set where old value of iums client subtype contains Master but new value dont contain the same
                    AccountIdSetNonMaster.add(acc.id);    //Adding AccountId in the AccountIdSetNonMaster
                }
            }
        }
        if(!AccountIdSetMaster.isempty()){
            fetchAccountTeam(AccountIdSetMaster, ConstantsUtil.Edit);
        }
        if(!AccountIdSetNonMaster.isEmpty()){
            fetchAccountTeam(AccountIdSetNonMaster, ConstantsUtil.Read);
        }
    }
    
    /*=================================================================================================================================
     * @Method Name       : fetchAccountTeam
     * @author            : Accenture
     * @Last modified by  : Accenture
     * @Last modified date: 28/11/2018
     * @Purpose           : Method to create Map of Account Id and Associated AccountTeamMember user Id
    ================================================================================================================================*/
    Public Static void fetchAccountTeam(set<Id>AccountIdSet, String Access){   
        Map<id, set<Id>> accountTeamMemberMap = new Map<id, set<Id>>();
        Map<string, User> userMap = new Map<string, User>();   // user Map whaere name as a key and Id as the value
        Map<string, User> userIdMap = new Map<string, User>();   // user Map whaere name as a key and Id as the value
        Set<Id>tempSet = new Set<Id>();
        set<Id>removeOverlapping  = new Set<Id>();
        
        for(User use: [select id, Name, ManagerId, Manager_Level_2__c, Manager_Level_3__c, Manager_Level_4__c, Manager_Level_5__c, Manager_Level_6__c, Manager_Level_7__c, IsActive from User]){
            userMap.put(use.Name.toUppercase(), use);
            userIdMap.put(use.id, use);
        }
        
        //fetch all AccountTeamMemnber where updated value of iums client subtype contains Master but old value dont contain the same
        for(AccountTeamMember acm: [select UserId, AccountId from AccountTeamMember where AccountId in:AccountIdset]){
            tempSet = new Set<Id>();
            if(userIdMap.get(acm.UserId).isActive){
                if(accountTeamMemberMap.isEmpty()){       //checking Map accountTeamMemberMap is empty or not
                    tempSet.add(acm.UserId);
                    accountTeamMemberMap.put(acm.AccountId, tempSet);   // Taking Account Id as the key and AccountTeamMember Userid set as the value
                    removeOverlapping.add(acm.AccountId);
                }else{
                    if(removeOverlapping.contains(acm.AccountId)){     //Checking set contain this accountId as key or not
                        tempSet.addall(accountTeamMemberMap.get(acm.AccountId));
                        tempSet.add(acm.UserId);
                        accountTeamMemberMap.put(acm.AccountId, tempSet);  // Taking Account Id as the key and AccountTeamMember Userid set as the value
                    }else{
                        tempSet.add(acm.UserId);
                        accountTeamMemberMap.put(acm.AccountId, tempSet);  // Taking Account Id as the key and AccountTeamMember Userid set as the value
                    }
                    removeOverlapping.add(acm.AccountId);
                }
            }
        }
        system.debug('==========accountTeamMemberMap========'+accountTeamMemberMap);
        fetchFafRecodassociatedtoAccount(AccountIdSet, Access, accountTeamMemberMap, userMap, userIdMap);
    }
    
    /*=================================================================================================================================
     * @Method Name       : fetchFafRecodassociatedtoAccount
     * @author            : Accenture
     * @Last modified by  : Accenture
     * @Last modified date: 28/11/2018
     * @Purpose           : Method to find what all faf should be shared with the Account Team Member, med D sales Lead and oppoty Owner 
     (Method to create Map of Account Id and Associated Faf Record Id also creating two more map of FafId as a key, 
     Med D sales Lead Id as value and FafId as a key, oppty Owner Id as value)
    ================================================================================================================================*/    
    Public Static void fetchFafRecodassociatedtoAccount(set<Id>AccountIdSet, String Access, Map<id, set<Id>> accountTeamMemberMap, Map<string, User> userMap, Map<string, User> userIdMap){
        set<Id>fafId = new set<Id>();
        Map<id, set<Id>> fafAccountMap = new Map<id, set<Id>>(); // Map to associate Account Id and related Faf id
        Map<id, Set<Id>> fafIdOpportWinnerMap = new Map<id, Set<Id>>();  //Map to associate faf id and related oppotywinner Id
        Map<id, Set<Id>> fafIdOpportMedDMap = new Map<id, Set<Id>>();   //Map to associate faf id and related med d shles Lead
        Set<Id>tempSet = new Set<Id>();
        Set<Id>tempSet2 = new Set<Id>();
        set<Id>removeOverlapping  = new Set<Id>();
        String str;
        
        //fetch all FAF Record associated to the account where updated value of iums client subtype contains Master but old value dont contain the same
        for(central_Hub__c centHub: [select id, Account_Name__c, Med_D_Sales_Lead_Formula__c, Oppty_Winner_Formula__c from central_Hub__c where Account_Name__c in:AccountIdset]){
            tempSet = new Set<Id>();
            if(fafAccountMap.isEmpty()){       //checking Map fafAccountMap is empty or not
                tempSet.add(centHub.id);
                fafAccountMap.put(centHub.Account_Name__c, tempSet);    //adding value in map taking Account Id as the key and Fafid set as the value
                removeOverlapping.add(centHub.Account_Name__c);
            }else{
                if(removeOverlapping.contains(centHub.Account_Name__c)){     //Checking set contain this accountId as key or not
                    tempSet.addall(fafAccountMap.get(centHub.Account_Name__c));
                    tempSet.add(centHub.id);
                    fafAccountMap.put(centHub.Account_Name__c, tempSet);   //adding value in map taking Account Id as the key and Fafid set as the value
                }else{
                    tempSet.add(centHub.id);
                    fafAccountMap.put(centHub.Account_Name__c, tempSet);  //adding value in map taking Account Id as the key and Fafid set as the value
                }
                removeOverlapping.add(centHub.Account_Name__c);
            }
            tempSet2 = new set<Id>();
            if(!String.isBlank(centHub.Oppty_Winner_Formula__c)){
                if(userMAp.get(centHub.Oppty_Winner_Formula__c.toUppercase()) != null){
                    if(userMAp.get(centHub.Oppty_Winner_Formula__c.toUppercase()).isActive){  // For check the user in Oppty winner is Active or not
                        String strOptWin = centHub.Oppty_Winner_Formula__c.toUppercase();
                        tempSet2.add(userMAp.get(strOptWin).id);
                        if(!String.isBlank(userMAp.get(strOptWin).ManagerId)){
                            if(userIdMap.get(userMAp.get(strOptWin).ManagerId).IsActive){
                                tempSet2.add(userMAp.get(strOptWin).ManagerId);
                            }
                        }
                        if(!String.isBlank(userMAp.get(strOptWin).Manager_Level_2__c)){  // For check Manager_Level_2__c field is blank or not
                            if(userMAp.get(userMAp.get(strOptWin).Manager_Level_2__c.toUppercase()) != null){  //for check any user with this manager name is present in the system or not 
                                if(userMAp.get(userMAp.get(strOptWin).Manager_Level_2__c.toUppercase()).IsActive){ // for check manager 2 is Active or not
                                    tempSet2.add(userMAp.get(userMAp.get(strOptWin).Manager_Level_2__c.toUppercase()).id);
                                }
                            }
                        }
                        if(!String.isBlank(userMAp.get(strOptWin).Manager_Level_3__c)){  // For check Manager_Level_3__c field is blank or not
                            if(userMAp.get(userMAp.get(strOptWin).Manager_Level_3__c.toUppercase()) != null){  //for check any user with this manager name is present in the system or not 
                                if(userMAp.get(userMAp.get(strOptWin).Manager_Level_3__c.toUppercase()).IsActive){   //for check manager 3 is Active or not
                                    tempSet2.add(userMAp.get(userMAp.get(strOptWin).Manager_Level_3__c.toUppercase()).id);
                                }
                            }
                        }
                        if(!String.isBlank(userMAp.get(strOptWin).Manager_Level_4__c)){   // For check Manager_Level_4__c field is blank or not
                            if(userMAp.get(userMAp.get(strOptWin).Manager_Level_4__c.toUppercase()) != null){  //for check any user with this manager name is present in the system or not 
                                if(userMAp.get(userMAp.get(strOptWin).Manager_Level_4__c.toUppercase()).IsActive){   // for check manager 4 is Active or not
                                    tempSet2.add(userMAp.get(userMAp.get(strOptWin).Manager_Level_4__c.toUppercase()).id);
                                }
                            }
                        }
                        if(!String.isBlank(userMAp.get(strOptWin).Manager_Level_5__c)){    // For check Manager_Level_5__c field is blank or not
                            if(userMAp.get(userMAp.get(strOptWin).Manager_Level_5__c.toUppercase()) != null){  //for check any user with this manager name is present in the system or not 
                                if(userMAp.get(userMAp.get(strOptWin).Manager_Level_5__c.toUppercase()).IsActive){    // for check manager 5 is Active or not
                                    tempSet2.add(userMAp.get(userMAp.get(strOptWin).Manager_Level_5__c.toUppercase()).id);
                                }
                            }
                        }
                        if(!String.isBlank(userMAp.get(strOptWin).Manager_Level_6__c)){    // For check Manager_Level_6__c field is blank or not
                            if(userMAp.get(userMAp.get(strOptWin).Manager_Level_6__c.toUppercase()) != null){   //for check any user with this manager name is present in the system or not 
                                if(userMAp.get(userMAp.get(strOptWin).Manager_Level_6__c.toUppercase()).IsActive){    // for check manager 6 is Active or not
                                    tempSet2.add(userMAp.get(userMAp.get(strOptWin).Manager_Level_6__c.toUppercase()).id);
                                }
                            }
                        }
                        if(!String.isBlank(userMAp.get(strOptWin).Manager_Level_7__c)){    // For check Manager_Level_7__c field is blank or not
                            if(userMAp.get(userMAp.get(strOptWin).Manager_Level_7__c.toUppercase()) != null){  //for check any user with this manager name is present in the system or not 
                                if(userMAp.get(userMAp.get(strOptWin).Manager_Level_7__c.toUppercase()).IsActive){    // for check manager 7 is Active or not
                                    tempSet2.add(userMAp.get(userMAp.get(strOptWin).Manager_Level_7__c.toUppercase()).id); 
                                }
                            }
                        }
                        fafIdOpportWinnerMap.put(centHub.id, tempSet2);   //creating Map for fafId as a key and Oppty Winner and there manager set as value
                    }
                }
            } 
            tempSet2 = new set<Id>();
            if(!String.isBlank(centHub.Med_D_Sales_Lead_Formula__c)){
                if(userMAp.get(centHub.Med_D_Sales_Lead_Formula__c.toUppercase()) != null){
                    if(userMAp.get(centHub.Med_D_Sales_Lead_Formula__c.toUppercase()).isActive){
                        String strMedSaleLead = centHub.Med_D_Sales_Lead_Formula__c.toUppercase();
                        tempSet2.add(userMAp.get(strMedSaleLead).id);
                        if(!String.isBlank(userMAp.get(strMedSaleLead).ManagerId)){
                            if(userIdMap.get(userMAp.get(strMedSaleLead).ManagerId).IsActive){
                                tempSet2.add(userMAp.get(strMedSaleLead).ManagerId);
                            }
                        }
                        if(!String.isBlank(userMAp.get(strMedSaleLead).Manager_Level_2__c)){  // For check Manager_Level_2__c field is blank or not
                            if(userMAp.get(userMAp.get(strMedSaleLead).Manager_Level_2__c.toUppercase()) != null){  //for check any user with this manager name is present in the system or not 
                                if(userMAp.get(userMAp.get(strMedSaleLead).Manager_Level_2__c.toUppercase()).IsActive){ // for check manager 2 is Active or not
                                    tempSet2.add(userMAp.get(userMAp.get(strMedSaleLead).Manager_Level_2__c.toUppercase()).id);
                                }
                            }
                        }
                        if(!String.isBlank(userMAp.get(strMedSaleLead).Manager_Level_3__c)){  // For check Manager_Level_3__c field is blank or not
                            if(userMAp.get(userMAp.get(strMedSaleLead).Manager_Level_3__c.toUppercase()) != null){  //for check any user with this manager name is present in the system or not 
                                if(userMAp.get(userMAp.get(strMedSaleLead).Manager_Level_3__c.toUppercase()).IsActive){   // for check manager 3 is Active or not
                                    tempSet2.add(userMAp.get(userMAp.get(strMedSaleLead).Manager_Level_3__c.toUppercase()).id);
                                }
                            }
                        }
                        if(!String.isBlank(userMAp.get(strMedSaleLead).Manager_Level_4__c)){   // For check Manager_Level_4__c field is blank or not
                            if(userMAp.get(userMAp.get(strMedSaleLead).Manager_Level_4__c.toUppercase()) != null){  //for check any user with this manager name is present in the system or not 
                                if(userMAp.get(userMAp.get(strMedSaleLead).Manager_Level_4__c.toUppercase()).IsActive){   // for check manager 4 is Active or not
                                    tempSet2.add(userMAp.get(userMAp.get(strMedSaleLead).Manager_Level_4__c.toUppercase()).id);
                                }
                            }
                        }
                        if(!String.isBlank(userMAp.get(strMedSaleLead).Manager_Level_5__c)){    // For check Manager_Level_5__c field is blank or not
                            if(userMAp.get(userMAp.get(strMedSaleLead).Manager_Level_5__c.toUppercase()) != null){  //for check any user with this manager name is present in the system or not 
                                if(userMAp.get(userMAp.get(strMedSaleLead).Manager_Level_5__c.toUppercase()).IsActive){    // for check manager 5 is Active or not
                                    tempSet2.add(userMAp.get(userMAp.get(strMedSaleLead).Manager_Level_5__c.toUppercase()).id);
                                }
                            }
                        }
                        if(!String.isBlank(userMAp.get(strMedSaleLead).Manager_Level_6__c)){    // For check Manager_Level_6__c field is blank or not
                            if(userMAp.get(userMAp.get(strMedSaleLead).Manager_Level_6__c.toUppercase()) != null){   //for check any user with this manager name is present in the system or not 
                                if(userMAp.get(userMAp.get(strMedSaleLead).Manager_Level_6__c.toUppercase()).IsActive){    // for check manager 6 is Active or not
                                    tempSet2.add(userMAp.get(userMAp.get(strMedSaleLead).Manager_Level_6__c.toUppercase()).id);
                                }
                            }
                        }
                        if(!String.isBlank(userMAp.get(strMedSaleLead).Manager_Level_7__c)){    // For check Manager_Level_7__c field is blank or not
                            if(userMAp.get(userMAp.get(strMedSaleLead).Manager_Level_7__c.toUppercase()) != null){  //for check any user with this manager name is present in the system or not 
                                if(userMAp.get(userMAp.get(strMedSaleLead).Manager_Level_7__c.toUppercase()).IsActive){    // for check manager 7 is Active or not
                                    tempSet2.add(userMAp.get(userMAp.get(strMedSaleLead).Manager_Level_7__c.toUppercase()).id); 
                                }
                            }
                        }
                        fafIdOpportMedDMap.put(centHub.id, tempSet2);   //creating Map for fafId as a key and Med D sales Lead and there manager set as value
                    }
                }
            }
            fafId.add(centHub.id);   //Fetching FAF Id to query the Faf share object
        }
        system.debug('=========userMap========'+userMap);
        system.debug('=========fafIdOpportWinnerMap========'+fafIdOpportWinnerMap);
        system.debug('=========fafIdOpportMedDMap========'+fafIdOpportMedDMap);
        system.debug('=========fafAccountMap========'+fafAccountMap);
        if(fafAccountMap.isEmpty() || (accountTeamMemberMap.isEmpty() && fafIdOpportWinnerMap.isEmpty() && fafIdOpportMedDMap.isEmpty())){
            //do nothing
        }else{
            CreateFafWithAccTeamMemberMap(fafAccountMap, fafIdOpportWinnerMap, fafIdOpportMedDMap, accountTeamMemberMap, Access, fafId);
        }
        
    }
    
    /*=================================================================================================================================
     * @Method Name       : CreateFafWithAccTeamMemberMap
     * @author            : Accenture
     * @Last modified by  : Accenture
     * @Last modified date: 28/11/2018
     * @Purpose           : Method to identify what all combination of Faf and User should be share with faf share
    ================================================================================================================================*/ 
    Public Static void CreateFafWithAccTeamMemberMap(Map<id, set<Id>> fafAccountMap, Map<id, set<Id>> fafIdOpportWinnerMap, Map<id, set<Id>> fafIdOpportMedDMap, Map<id,    set<Id>> accountTeamMemberMap, String Access, set<Id>fafId){
        Map<id, set<Id>> fafRecUserMap = new Map<id, set<Id>>();  // map where faf Id is the key and set of Account team Member and Med d sales Lead and oppty Winner id as the value
        Set<Id>tempSet = new Set<Id>();
        Set<Id>tempSet2 = new Set<Id>();
        set<Id>removeOverlapping  = new Set<Id>();
        set<Id>removeOverlapping2  = new Set<Id>();
        //Iterating fafAccountMap and accountTeamMemberMap Map to make fafRecUserMap map where Faf id as the key and UserIdset(AccountteamMember userId) set as the value 
        for(Id tempId: fafAccountMap.keyset()){  //Iterating over the Account id 
            for(Id tempId2: fafAccountMap.get(tempId)){   //Iterating over the faf Id
                tempSet2 = new Set<Id>();
                if(!accountTeamMemberMap.isEmpty()){
                    for(Id tempId3: accountTeamMemberMap.get(tempId)){
                        tempSet = new Set<Id>();
                        if(fafRecUserMap.isEmpty()){       //checking Map fafAccountMap is empty or not
                            tempSet.add(tempId3);
                            fafRecUserMap.put(tempId2, tempSet);  // adding value in the where Faf id as the key and UserIdset(AccountteamMember userId) set
                            removeOverlapping.add(tempId2);
                        }else{
                            if(removeOverlapping.contains(tempId2)){     //Checking set contain this accountId as key or not
                                tempSet.addall(fafRecUserMap.get(tempId2));
                                tempSet.add(tempId3);
                                fafRecUserMap.put(tempId2, tempSet);  //adding value in the where Faf id as the key and UserIdset(AccountteamMember userId) set
                            }else{
                                tempSet.add(tempId3);
                                fafRecUserMap.put(tempId2, tempSet);  //adding value in the where Faf id as the key and UserIdset(AccountteamMember userId) set as the value
                            }
                            removeOverlapping.add(tempId2);
                        }
                    }
                }
                system.debug('======before=======fafRecUserMap========='+fafRecUserMap);
                system.debug('======before=======tempId2========='+tempId2);
                system.debug('======before=======fafIdOpportWinnerMap========='+fafIdOpportWinnerMap);
                system.debug('======before=======fafIdOpportMedDMap========='+fafIdOpportMedDMap);
                //for adding the value oppoty winner and med d sales Lead in the fafRecUserMap Map
                if(fafRecUserMap.isEmpty()){
                    if(fafIdOpportWinnerMap.get(tempId2) != null)
                        tempSet2.addall(fafIdOpportWinnerMap.get(tempId2));
                    if(fafIdOpportMedDMap.get(tempId2) != null)
                        tempSet2.addall(fafIdOpportMedDMap.get(tempId2));
                    fafRecUserMap.put(tempId2, tempSet2);
                    removeOverlapping.add(tempId2);
                }else{
                    if(removeOverlapping.contains(tempId2)){     //Checking set contain this accountId as key or not
                        tempSet2.addall(fafRecUserMap.get(tempId2));
                        if(fafIdOpportWinnerMap.get(tempId2) != null)   // checking map contain value for speciafic Faf Id
                            tempSet2.addall(fafIdOpportWinnerMap.get(tempId2));
                        if(fafIdOpportMedDMap.get(tempId2) != null)  // checking map contain value for speciafic Faf Id
                            tempSet2.addall(fafIdOpportMedDMap.get(tempId2));
                        fafRecUserMap.put(tempId2, tempSet2);  //adding  Med d sales Lead or Oppty Winner in the fafRecUserMap map
                    }else{
                        if(fafIdOpportWinnerMap.get(tempId2) != null)
                            tempSet2.addall(fafIdOpportWinnerMap.get(tempId2));
                        if(fafIdOpportMedDMap.get(tempId2) != null)
                            tempSet2.addall(fafIdOpportMedDMap.get(tempId2));
                        fafRecUserMap.put(tempId2, tempSet2);  //adding value in fafRecUserMap where Faf id as the key and UserIdset(AccountteamMember userId) set as the value
                    }
                    removeOverlapping.add(tempId2);
                }
            }
        }
        system.debug('==========fafRecUserMap========'+fafRecUserMap);
        fetchFafShareCreateMapwithUser(fafRecUserMap, Access, fafId);
    }
    
    /*=================================================================================================================================
     * @Method Name       : fetchFafShareCreateMapwithUser
     * @author            : Accenture
     * @Last modified by  : Accenture
     * @Last modified date: 28/11/2018
     * @Purpose           : Method to check what all combination of record(ParentId and UserId) are already present in the faf share 
    ===================================================================================================================================*/ 
    Public Static void fetchFafShareCreateMapwithUser(Map<id, set<Id>> fafRecUserMap, String Access, set<Id>fafId){    
        Map<id, set<Id>> fafUserMap = new Map<id, set<Id>>();  // Final Map which contain all the combinalion(ParentId and UserId) of related faf which are already present in the fafshare 
        Set<Id>tempSet = new Set<Id>();
        set<string>fafsharewithOwnerRowCause = new Set<string>();  // Set created to exclude the combination of userId and ParentId combination of RowCause Owner present in Faf share to insert or Update
        set<Id>removeOverlapping  = new Set<Id>();
        Map<string, string> fafIdUserIdComindMapAccess = new map<string, string>();  //to store the AccessLevel of Faf share
        Map<string, string> fafIdUserIdComindMapId = new map<string, string>();  //to store the Id of Faf share for Update
        //fetch all FAF share Record associated to the FafId set created above to check which all combination are already present in the Faf share record
        for(central_Hub__share centHub: [select id, UserOrGroupId, ParentId, RowCause, AccessLevel from central_Hub__share where ParentId in:fafId and RowCause in ('Manual' ,'Owner')]){ 
            tempSet = new Set<Id>();
            if(centHub.RowCause.equals(ConstantsUtil.Manual)){
                if(fafUserMap.isEmpty()){       //checking Map fafUserMap is empty or not
                    tempSet.add(centHub.UserOrGroupId);
                    fafUserMap.put(centHub.ParentId, tempSet);
                    removeOverlapping.add(centHub.ParentId);
                    
                }else{
                    if(removeOverlapping.contains(centHub.ParentId)){     //Checking Map contain this faf id as key or not
                        tempSet.addall(fafUserMap.get(centHub.ParentId));
                        tempSet.add(centHub.UserOrGroupId);
                        fafUserMap.put(centHub.ParentId, tempSet);
                    }else{
                        tempSet.add(centHub.UserOrGroupId);
                        fafUserMap.put(centHub.ParentId, tempSet);
                    }
                    removeOverlapping.add(centHub.ParentId);
                }
                fafIdUserIdComindMapAccess.put(string.valueOf(centHub.ParentId)+string.valueOf(centHub.UserOrGroupId), centHub.AccessLevel);
                fafIdUserIdComindMapId.put(string.valueOf(centHub.ParentId)+string.valueOf(centHub.UserOrGroupId), centHub.id);
            }else if(centHub.RowCause.equals(ConstantsUtil.Owner)){
                fafsharewithOwnerRowCause.add(string.valueOf(centHub.ParentId)+string.valueOf(centHub.UserOrGroupId));
            }
        }
        
        system.debug('==========fafRecUserMap========'+fafRecUserMap);
        system.debug('==========fafUserMap========'+fafUserMap);
        system.debug('==========fafIdUserIdComindMapAccess========'+fafIdUserIdComindMapAccess);
        system.debug('==========fafIdUserIdComindMapId========'+fafIdUserIdComindMapId);
        system.debug('==========fafsharewithOwnerRowCause========'+fafsharewithOwnerRowCause);
        insertUpdateCentralUbShare(fafRecUserMap, fafUserMap, fafIdUserIdComindMapAccess, fafIdUserIdComindMapId, fafsharewithOwnerRowCause, Access);  //calling method to insert or update the faf share record
    }
    
    /*=================================================================================================================================
     * @Method Name       : insertUpdateCentralUbShare
     * @author            : Accenture
     * @Last modified by  : Accenture
     * @Last modified date: 28/11/2018
     * @Purpose           : Method to check what all combination of recordwe need to insert or update and do the processing
    ===================================================================================================================================*/ 
    Public Static void insertUpdateCentralUbShare(Map<id,set<Id>>fafShareRec, Map<id,set<Id>>fafShareRecExisting, Map<string,string>fafIdUserIdComindMapAccess, Map<string,string>fafIdUserIdComindMapId, Set<string>fafsharewithOwnerRowCause, String Access){
        try{
            List<central_Hub__share> insertFAFShareList = new List<central_Hub__share>();  // List to hold the faf hsare record which we need to insert
            List<central_Hub__share> updateFAFShareList = new List<central_Hub__share>();  // List to hold the faf hsare record which we need to update
            central_Hub__share insertFAFShareObj = new central_Hub__share();
            central_Hub__share updateFAFShareObj = new central_Hub__share();
            if(!fafShareRec.isEmpty()){
                if(!fafShareRecExisting.isEmpty()){  //if some record were present in the query then the already present record we need to update with the required Access Level                    
                    for(Id fafId: fafShareRec.keyset()){
                        for(Id newaccountMemberId: fafShareRec.get(fafId)){
                            if(fafShareRecExisting.get(fafId) != null){
                                if(fafShareRecExisting.get(fafId).contains(newaccountMemberId)){  //if the record is already preset the we need to update
                                    if(!fafsharewithOwnerRowCause.contains(string.valueOf(fafId)+string.valueOf(newaccountMemberId))){
                                        if(fafIdUserIdComindMapAccess.get(string.valueOf(fafId)+string.valueOf(newaccountMemberId)) != Access){
                                            updateFAFShareObj = new  central_Hub__share();
                                            updateFAFShareObj.id = fafIdUserIdComindMapId.get(string.valueOf(fafId)+string.valueOf(newaccountMemberId));
                                            updateFAFShareObj.AccessLevel = Access;
                                            updateFAFShareList.add(updateFAFShareObj);
                                        }
                                    }
                                }else{  // else wee need to insert
                                    if(!fafsharewithOwnerRowCause.contains(string.valueOf(fafId)+string.valueOf(newaccountMemberId))){
                                        insertFAFShareObj = new central_Hub__share();
                                        insertFAFShareObj.AccessLevel = Access;
                                        insertFAFShareObj.ParentId = fafId;
                                        insertFAFShareObj.RowCause = ConstantsUtil.Manual;
                                        insertFAFShareObj.UserOrGroupId = newaccountMemberId;
                                        insertFAFShareList.add(insertFAFShareObj);
                                    }
                                }
                            }else{ // ele wee need to insert the record
                                if(!fafsharewithOwnerRowCause.contains(string.valueOf(fafId)+string.valueOf(newaccountMemberId))){
                                    insertFAFShareObj = new central_Hub__share();
                                    insertFAFShareObj.AccessLevel = Access;  
                                    insertFAFShareObj.ParentId = fafId;
                                    insertFAFShareObj.RowCause = ConstantsUtil.Manual;   // For inserting RowCause will be manual only 
                                    insertFAFShareObj.UserOrGroupId = newaccountMemberId;
                                    insertFAFShareList.add(insertFAFShareObj);
                                }
                            }
                        }
                    }
                }else{  //If no record related to the FAF is present in the faf share then we are going to insert all the record present in fafShareRec with Edit permission
                    for(Id fafId: fafShareRec.keyset()){
                        for(Id accountMemberId: fafShareRec.get(fafId)){ 
                            if(!fafsharewithOwnerRowCause.contains(string.valueOf(fafId)+string.valueOf(accountMemberId))){
                                insertFAFShareObj = new central_Hub__share();
                                insertFAFShareObj.AccessLevel = Access;
                                insertFAFShareObj.ParentId = fafId;
                                insertFAFShareObj.RowCause = ConstantsUtil.Manual;  // For inserting RowCause will be manual only 
                                insertFAFShareObj.UserOrGroupId = accountMemberId;
                                insertFAFShareList.add(insertFAFShareObj);
                            }
                        }
                    }
                }
            }
            system.debug('======================insertFAFShareList========'+insertFAFShareList);
            system.debug('======================updateFAFShareObj========'+updateFAFShareObj);
            if(!insertFAFShareList.isEmpty()){   // checking the size of the List
                insert insertFAFShareList;    // record need to Insert
            }
            if(!updateFAFShareList.isEmpty())   // checking the size of the List
                update updateFAFShareList;    // // record need to Update
        }catch(Exception e){
            Trigger.new[0].addError(e.getMessage());   
        }
    }
       
      
 }