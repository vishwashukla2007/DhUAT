public  without  sharing class FAFTriggerAccessHelper {
    /*  added by Preetham Padala
* accountUserAccessOnFAF  will create  or delete the faf record visibilty based on account ,salesperson and faf status
* 
* if we change the account then it will delete the record from Central_Hub__Share  for related team member
* and it will create access record for new account team member.
* 
* when we update the salesperson then old salesperson  record will delete form Central_Hub__Share and, will create new.
* 
* Once we update the FAF status as 'Deleted' then it will delete the all the access from Central_Hub__Share.
* 
* if we change the FAf Status from 'Deleted' to any  it wil create the access rcord for the account tem member and for salesperson if they exist 
* */
    // Method Started 
    public static void accountUserAccessOnFAF(List<Central_Hub__c> FAFList, MAP<Id, Central_Hub__c> fafOldMap)
    {
        set<String>AccountRoleList= new set<String>();
        AccountRoleList.add('Medicare Account Executive');
        AccountRoleList.add('Account Executive');
        AccountRoleList.add('Medicare Sales Executive');
        AccountRoleList.add('Strategic Account Executive');
        AccountRoleList.add('Strategic Account Executive 1');
        AccountRoleList.add('Strategic Account Executive 2');
        AccountRoleList.add('Strategic Account Executive 3');
        AccountRoleList.add('Strategic Account Executive 4');
        AccountRoleList.add('Strategic Sales Executive');
        AccountRoleList.add('Strategic Sales Executive 2');
        AccountRoleList.add('Strategic Sales Executive 3');
        AccountRoleList.add('Medicare Sales Director');
        AccountRoleList.add('Strategic Account Director');
        set<id>salespersonToManagerIdoldSet= new set<id>();
        Map<Id,Id> accountMapIdNew = new  Map<Id,Id>();
        Map<Id,String> clientSubtypeRoleList = new  Map<Id,String>();
        Map<Id,String> clientSubtypeRoleMapSalesPerson = new  Map<Id,String>();
        set<id> cntrlHubSetId = new set<id>(); 
        set<id>acteamId= new set<id>();
        set<id> cntrlHubOLDACCId = new set<id>(); 
        set<id> cntrlHubSharePersonSetId = new set<id>();
        List<Central_Hub__Share>insertCntrHubshareList= new List<Central_Hub__Share>();
        Map<id,id>salesPersonManagerMapIdNew=new Map<id,id>();
        Map<id,id>salesPersonMapIdNew=new Map<id,id>();
        Map<id,id>salesPersonMapIdOld= new  Map<id,id>();
        
        if(Trigger.isAfter && Trigger.isInsert){  
            
            system.debug('Coming insdide aftr isert ');
            for(Central_Hub__c cntrlHub:FAFList){   // when new FAF insert with account Name
                if(cntrlHub.Account_Name__c!= null){
                    accountMapIdNew.put(cntrlHub.Account_Name__c,cntrlHub.id); 
                    if(cntrlHub.Client_Subtype__c!=null){
                        clientSubtypeRoleList.put(cntrlHub.Account_Name__c,cntrlHub.Client_Subtype__c);
                    }
                }
                if(cntrlHub.Salesperson__c!= null){ // when new FAF insert with salesperson Name
                    salesPersonMapIdNew.put(cntrlHub.id,cntrlHub.Salesperson__c);
                    salesPersonManagerMapIdNew.put(cntrlHub.Salesperson__c,cntrlHub.id);
                    if(cntrlHub.Client_Subtype__c!=null){
                        clientSubtypeRoleMapSalesPerson.put(cntrlHub.Salesperson__c,cntrlHub.Client_Subtype__c);
                    }
                }
               
            }   
        }else if(Trigger.isAfter && Trigger.isUpdate){
            for(Central_Hub__c cntrlHub:FAFList){
                boolean isDeletedFaf=false;
                if(cntrlHub.FAF_Status__c =='Deleted'){
                    isDeletedFaf=true;
                }
                
                Central_Hub__c oldCntrlHub = (Central_Hub__c)trigger.oldMap.get(cntrlHub.id) ;
                // when we update faf record status as Deleted then it should delete the record from central hub share object 
                if(cntrlHub.FAF_Status__c!=null && cntrlHub.FAF_Status__c=='Deleted' && cntrlHub.FAF_Status__c!= oldCntrlHub.FAF_Status__c){ 
                    cntrlHubSetId.add(cntrlHub.id);
                }
                // when we change  faf record status from deleted  then it should create  the visiblity record for account team member and salesperson  on  central share hub object 
                if(cntrlHub.FAF_Status__c!=null && oldCntrlHub.FAF_Status__c=='Deleted' && cntrlHub.FAF_Status__c!= oldCntrlHub.FAF_Status__c){ 
                    if(cntrlHub.Salesperson__c!=null){
                        salesPersonMapIdNew.put(cntrlHub.id,cntrlHub.Salesperson__c);// for salesperson
                        salesPersonManagerMapIdNew.put(cntrlHub.Salesperson__c,cntrlHub.id);
                    }
                    if(cntrlHub.Account_Name__c!=null){
                        if(cntrlHub.Client_Subtype__c!=null){
                            clientSubtypeRoleList.put(cntrlHub.Account_Name__c,cntrlHub.Client_Subtype__c);
                        }
                            accountMapIdNew.put(cntrlHub.Account_Name__c,cntrlHub.id); 
                    }
                }
                
                    if(!isDeletedFaf){

                            //1 if new account and old account both are not null and both are different 
                            if(cntrlHub.Account_Name__c!=null && oldCntrlHub.Account_Name__c!=null && cntrlHub.Account_Name__c!= oldCntrlHub.Account_Name__c){ // when existing  FAF update  with new account Name
                                accountMapIdNew.put(cntrlHub.Account_Name__c,cntrlHub.id);
                                if(cntrlHub.Client_Subtype__c!=null){
                                    clientSubtypeRoleList.put(cntrlHub.Account_Name__c,cntrlHub.Client_Subtype__c);
                                }
                                cntrlHubSetId.add(cntrlHub.id);
                                cntrlHubOLDACCId.add(oldCntrlHub.Account_Name__c);
                                if(cntrlHub.Salesperson__c!=null)
                                    cntrlHubSharePersonSetId.add(cntrlHub.Salesperson__c);
                            }
                            //2 if new account is not null and old account is null 
                            if(cntrlHub.Account_Name__c!=null &&  oldCntrlHub.Account_Name__c==null ){ // when existing  FAF update  with new account Name
                                accountMapIdNew.put(cntrlHub.Account_Name__c,cntrlHub.id);
                                if(cntrlHub.Client_Subtype__c!=null){
                                    clientSubtypeRoleList.put(cntrlHub.Account_Name__c,cntrlHub.Client_Subtype__c);
                                }
                            }
                            //3 if new account  is null and old account is not null
                            if(cntrlHub.Account_Name__c==null && oldCntrlHub.Account_Name__c!=null ){
                                cntrlHubSetId.add(cntrlHub.id);
                                cntrlHubOLDACCId.add(oldCntrlHub.Account_Name__c);
                                if(cntrlHub.Salesperson__c!=null)
                                    cntrlHubSharePersonSetId.add(cntrlHub.Salesperson__c);
                            }
                            //1 if new salesperson added  in place of old salesperson 
                            if(cntrlHub.Salesperson__c!=null && oldCntrlHub.Salesperson__c!=null && cntrlHub.Salesperson__c!= oldCntrlHub.Salesperson__c ){ 
                                 
                                 salesPersonMapIdNew.put(cntrlHub.id,cntrlHub.Salesperson__c);
                                 salesPersonManagerMapIdNew.put(cntrlHub.Salesperson__c,cntrlHub.id);
                                 salesPersonMapIdOld.put(oldCntrlHub.id,oldCntrlHub.Salesperson__c);
                                
                                if(cntrlHub.Client_Subtype__c!=null){
                                    clientSubtypeRoleMapSalesPerson.put(cntrlHub.Salesperson__c,cntrlHub.Client_Subtype__c);
                                }
                                
                            }
                            //2 if new salesperson added but there is no old salesperson 
                            if(cntrlHub.Salesperson__c!=null && oldCntrlHub.Salesperson__c==null ){
                                salesPersonMapIdNew.put(cntrlHub.id,cntrlHub.Salesperson__c);
                                salesPersonManagerMapIdNew.put(cntrlHub.Salesperson__c,cntrlHub.id);
                                
                                if(cntrlHub.Client_Subtype__c!=null){
                                    clientSubtypeRoleMapSalesPerson.put(cntrlHub.Salesperson__c,cntrlHub.Client_Subtype__c);
                                }
                            }
                            //3 deleted the old salesperson from faf record and there is no new salesperson  
                            if(cntrlHub.Salesperson__c==null && oldCntrlHub.Salesperson__c!=null ){ 
                                
                                salesPersonMapIdOld.put(oldCntrlHub.id,oldCntrlHub.Salesperson__c);
                                
                            }
                }
            }
            
            
            if(cntrlHubSetId!=null && cntrlHubSetId.size()>0){ // if old account record is present 
                // mentioned the condtion RowCause !='Owner' and RowCause !='Rule' because we cant delete the row which is having rowcause ='owner or rule it throws    DML Exception
                List<Central_Hub__Share>deleteCntrlShareHub=[Select Id,ParentId,UserOrGroupId ,RowCause From Central_Hub__Share where RowCause !='Owner' and RowCause !='Rule' /* and RowCause != :Label.FAF_Salesperson */and ParentId In:cntrlHubSetId  and UserOrGroupId Not In:cntrlHubSharePersonSetId];
                if(deleteCntrlShareHub!=null && deleteCntrlShareHub.size()>0){  // null check if deleteCntrlShareHub is not null 
                    
                    try{
                        delete deleteCntrlShareHub;// deleting old account team user access on faf but not the salesperson  related to the faf 
                    }catch(Exception e){
                        system.debug('Exception '+e.getMessage() +' at line '+ e.getLineNumber());
                    }
                }
            }
            
            if(salesPersonMapIdOld!=null && salesPersonMapIdOld.size()>0){ 
                Map<string,id>salesmanagerNameMapold= new Map<string,id>();
                List<User>SalespersonManagerListold=[select id,Manager.Name,Manager_Level_2__c,Manager_Level_3__c,Manager_Level_4__c,Manager_Level_5__c,Manager_Level_6__c,Manager_Level_7__c from User where id in:salesPersonMapIdOld.values()];
                
                for(user uobj :SalespersonManagerListold){
                    salespersonToManagerIdoldSet.add(uobj.id);
                    salesmanagerNameMapold.put(uobj.Manager.Name,uobj.id);
                    salesmanagerNameMapold.put(uobj.Manager_Level_2__c,uobj.id);
                    salesmanagerNameMapold.put(uobj.Manager_Level_3__c,uobj.id);
                    salesmanagerNameMapold.put(uobj.Manager_Level_4__c,uobj.id);
                    salesmanagerNameMapold.put(uobj.Manager_Level_5__c,uobj.id);
                    salesmanagerNameMapold.put(uobj.Manager_Level_6__c,uobj.id);
                    salesmanagerNameMapold.put(uobj.Manager_Level_7__c,uobj.id);
                    
                }
                
                
                for(user uobj :[select id,name from user where name in:salesmanagerNameMapold.keyset() and isactive=true]){
                    salespersonToManagerIdoldSet.add(uobj.id);
                    
                }
                
                
                // if old Salesperson record is present 
                // mentioned the condtion RowCause !='Owner' and RowCause !='Rule' because we cant delete the row which is having rowcause ='owner or rule it throws    DML Exception
                List<Central_Hub__Share>deleteCntrlShareHubsalesperon=[Select Id,ParentId,UserOrGroupId ,RowCause From Central_Hub__Share where RowCause !='Owner' and RowCause !='Rule' and RowCause = :Label.FAF_Salesperson and ParentId In:salesPersonMapIdOld.keySet()  and UserOrGroupId In :salespersonToManagerIdoldSet];
                if(deleteCntrlShareHubsalesperon!=null && deleteCntrlShareHubsalesperon.size()>0){  // null check if deleteCntrlShareHub is not null 
                    
                    try{
                        delete deleteCntrlShareHubsalesperon;// deleting old salesperson user access on faf
                    }catch(Exception e){
                        system.debug('Exception '+e.getMessage() +' at line '+ e.getLineNumber());
                    }
                }
            }
        }
        
        Map<string,id>salesmanagerNameMap= new Map<string,id>();
        List<User>SalespersonManagerList=[select id,Manager.Name,Manager_Level_2__c,Manager_Level_3__c,Manager_Level_4__c,Manager_Level_5__c,Manager_Level_6__c,Manager_Level_7__c from User where id in:salesPersonMapIdNew.values() and isactive=true];
        for(user uobj :SalespersonManagerList){
            
            salesmanagerNameMap.put(uobj.Manager.Name,uobj.id);
            salesmanagerNameMap.put(uobj.Manager_Level_2__c,uobj.id);
            salesmanagerNameMap.put(uobj.Manager_Level_3__c,uobj.id);
            salesmanagerNameMap.put(uobj.Manager_Level_4__c,uobj.id);
            salesmanagerNameMap.put(uobj.Manager_Level_5__c,uobj.id);
            salesmanagerNameMap.put(uobj.Manager_Level_6__c,uobj.id);
            salesmanagerNameMap.put(uobj.Manager_Level_7__c,uobj.id);
            
        }
        Map<id,set<id>>salespersonToManagerIdMap= new Map<id,set<id>>();
        
        for(user uobj :[select id,name from user where name in:salesmanagerNameMap.keyset() and isactive=true]){
            if(salesmanagerNameMap.containsKey(uobj.name)){
                id spid=salesmanagerNameMap.get(uobj.name);
                if(salespersonToManagerIdMap.containsKey(spid)){
                    Set<id> managerIdSet=salespersonToManagerIdMap.get(spid);
                    managerIdSet.add(uobj.id);
                    salespersonToManagerIdMap.put(spid,managerIdSet);
                }else{
                    Set<id> managerIdSet= new Set<id> ();
                    managerIdSet.add(uobj.id);
                    salespersonToManagerIdMap.put(spid,managerIdSet);
                }
            }
        }
        
        for(id cntrlHubid :salesPersonMapIdNew.keySet()){
            
            Central_Hub__Share cntrHubShare= new Central_Hub__Share(); // creating record for each account salesperson  
            String  clientSubtype=clientSubtypeRoleMapSalesPerson.get(salesPersonMapIdNew.get(cntrlHubid));
            
            cntrHubShare.AccessLevel='Edit'; 
            
            cntrHubShare.ParentId=cntrlHubid; 
            cntrHubShare.RowCause =Label.FAF_Salesperson;
            cntrHubShare.UserOrGroupId=salesPersonMapIdNew.get(cntrlHubid);
            insertCntrHubshareList.add(cntrHubShare);
            if(salespersonToManagerIdMap.containsKey(salesPersonMapIdNew.get(cntrlHubid))){
                for(id managerId:salespersonToManagerIdMap.get(salesPersonMapIdNew.get(cntrlHubid))){
                    acteamId.add(managerId);// using set to check permission set is added to team member or not
                    Central_Hub__Share cntrHubShare1= new Central_Hub__Share(); // creating record for each account salesperson  
                    if(clientSubtype=='Coalition Master' || clientSubtype=='Health Plan Master'|| clientSubtype=='TPA Master'){
                        cntrHubShare1.AccessLevel='Edit'; 
                        
                    }else{
                        cntrHubShare1.AccessLevel='Read';  
                    }
                    
                    cntrHubShare1.ParentId=cntrlHubid; 
                    cntrHubShare1.RowCause =Label.FAF_Salesperson;
                    cntrHubShare1.UserOrGroupId=managerId;
                    insertCntrHubshareList.add(cntrHubShare1);
                }
            }
            // adding the salesperson central hub share record into common list 
            
        }
        
        
        for(AccountTeamMember actm : [Select UserId,AccountId,Account.OwnerId ,TeamMemberRole  from AccountTeamMember where AccountId In :cntrlHubOLDACCId]){
            salespersonToManagerIdoldSet.add(actm.UserId);
        }
        
        for(AccountTeamMember actm : [Select UserId,AccountId,Account.OwnerId ,TeamMemberRole  from AccountTeamMember where AccountId In :accountMapIdNew.keySet()]){
            
            Central_Hub__Share cntrHubShare= new Central_Hub__Share(); // creating record for each account team member for related account 
            
            String  clientSubtype=clientSubtypeRoleList.get(actm.AccountId);
            if(AccountRoleList.contains(actm.TeamMemberRole)){
                if(clientSubtype=='Coalition Master' || clientSubtype=='Health Plan Master'|| clientSubtype=='TPA Master'){
                    acteamId.add(actm.UserId);// using set to check permission set is added to team member or not
                    cntrHubShare.AccessLevel='Edit'; 
                }     else{
                    cntrHubShare.AccessLevel='Read';  
                }                          
            }else{
                cntrHubShare.AccessLevel='Read';  
            }
            
            cntrHubShare.ParentId=accountMapIdNew.get(actm.AccountId);
            cntrHubShare.RowCause ='Manual';
            cntrHubShare.UserOrGroupId=actm.UserId;
         insertCntrHubshareList.add(cntrHubShare); // adding the account team member  central hub share record into common list 
            
        }
        system.debug('@@@@@@'+insertCntrHubshareList);
        if(insertCntrHubshareList!=null && insertCntrHubshareList.size()>0){
            try{
                insert insertCntrHubshareList;  // inserting new  account team member and salesperson  access on faf
            }catch(Exception e){
                system.debug('Exception '+e.getMessage() +' at line '+ e.getLineNumber());
            }
        }
        
        
        
        if(salesPersonMapIdNew.size()>0 || acteamId.size()>0 ){
            set<id>salesPersonMapIdNewSet= new set<id>();
            salesPersonMapIdNewSet.addAll(salesPersonMapIdNew.values());
            salesPersonMapIdNewSet.addAll(acteamId);// passing into future mthod to upsert the E-apttus sales permission set 
            insertUserWithPermission(salesPersonMapIdNewSet);
        }
        if(salesPersonMapIdOld.size()>0 || salespersonToManagerIdoldSet.size()>0){
            List<id>salesPersonMapIdoldSet= new List<id>();
            salesPersonMapIdoldSet.addAll(salesPersonMapIdOld.values());
            salesPersonMapIdoldSet.addAll(salespersonToManagerIdoldSet);
            
            deleteUserWithPermission(salesPersonMapIdoldSet);
        }
        
    }
    /* assign "E- Apttus Sales Id" permission set to salesperson if not added and salesperson is added to faF
* handling this in future method to avoid mixed dml exception added by Preetham Padala
*/ 
    
    @future
    public static void insertUserWithPermission(set<id>salesPersonMapIdNew) {
        
        set<id>Salespersonadded= new set<id>();
        
        List<PermissionSetAssignment> permissionAssignToUpdate = new  List<PermissionSetAssignment> ();
        List<PermissionSetAssignment> permissionAssign=[SELECT Id, PermissionSet.Name,PermissionSet.Id,AssigneeId,Assignee.Name FROM PermissionSetAssignment where PermissionSet.id=:Label.Apttus_Sales_Permissionset  and AssigneeId in: salesPersonMapIdNew];
        for(PermissionSetAssignment pa:permissionAssign){
            Salespersonadded.add(pa.AssigneeId);
        }
        for(id salespId:salesPersonMapIdNew){
            if(!Salespersonadded.contains(salespId)){
                PermissionSetAssignment  psa = new PermissionSetAssignment (PermissionSetId = Label.Apttus_Sales_Permissionset , AssigneeId = salespId);
                permissionAssignToUpdate.add(psa);
            }
        }
        if (permissionAssignToUpdate.size()>0){
            upsert permissionAssignToUpdate;// adding permission set if its not there for user 
        } 
        
        
        
    }
    /* delete "E- Apttus Sales Id" permission set to salesperson if removed from faf 
* handling this in future method to avoid mixed dml exception added by Preetham Padala
*/ 
    
    @future
    public static void deleteUserWithPermission(List<id>salesPersonMapIdOld) {
        Set<id>existinguser=new set<id>();
        Set<id>existinguserDelete=new set<id>();
        
        List<Central_Hub__Share>fAFList=[select id,UserOrGroupId from Central_Hub__Share where UserOrGroupId In:salesPersonMapIdOld ];
        for(Central_Hub__Share ceobj:fAFList){
            existinguser.add(ceobj.UserOrGroupId);
        }
        for(id userid:salesPersonMapIdOld){
            if(!existinguser.contains(userid)){
                existinguserDelete.add(userid);
            }
        }
        
        if(existinguserDelete.size()>0){
            
            List<PermissionSetAssignment> permissionAssign=[SELECT Id, PermissionSet.Name,PermissionSet.Id,AssigneeId,Assignee.Name FROM PermissionSetAssignment where PermissionSet.id=:Label.Apttus_Sales_Permissionset  and AssigneeId in: existinguserDelete];
            
            if (permissionAssign.size()>0){
                delete  permissionAssign;
            } 
            
            
        }
    }
    // Method Ended accountUserAccessOnFAF and (Related Sub-Method) by Preetham Padala 
    
    
    /**
    * @Author - Sindhu
    * @Description - Method will share the FAF record with the Sales Person on copy FAF
    **/
    public static void shareFAFRecord(Central_Hub__c faf){ 

        Set<String> AccountRoleList = new Set<String>();
        AccountRoleList.add('Medicare Account Executive');
        AccountRoleList.add('Account Executive');
        AccountRoleList.add('Medicare Sales Executive');
        AccountRoleList.add('Strategic Account Executive');
        AccountRoleList.add('Strategic Account Executive 1');
        AccountRoleList.add('Strategic Account Executive 2');
        AccountRoleList.add('Strategic Account Executive 3');
        AccountRoleList.add('Strategic Account Executive 4');
        AccountRoleList.add('Strategic Sales Executive');
        AccountRoleList.add('Strategic Sales Executive 2');
        AccountRoleList.add('Strategic Sales Executive 3');
        AccountRoleList.add('Medicare Sales Director');
        AccountRoleList.add('Strategic Account Director');
        
        Set<Id> salesPersonMapIdNewSet = new Set<Id>();
        List<Central_Hub__Share> insertCntrHubShareList = new List<Central_Hub__Share>();
        Central_Hub__Share cntrHubShare = new Central_Hub__Share();
        String clientSubtype = faf.Client_Subtype__c;
      
        if(faf.Salesperson__c!=null){
          User SalespersonManagerUser = [SELECT Id, isActive, Manager.Name, Manager_Level_2__c, Manager_Level_3__c, Manager_Level_4__c, Manager_Level_5__c,             
                                                  Manager_Level_6__c, Manager_Level_7__c FROM User WHERE Id=:faf.Salesperson__c ];
          if(SalespersonManagerUser.isActive==true){
            Map<String, Id> salesmanagerNameMap = new Map<String, Id>();
            Map<Id, Set<Id>> salespersonToManagerIdMap = new Map<Id, Set<Id>>();
                   
            cntrHubShare.AccessLevel = 'Edit'; 
            cntrHubShare.ParentId = faf.Id; 
            cntrHubShare.RowCause = Label.FAF_Salesperson;
            cntrHubShare.UserOrGroupId = faf.Salesperson__c;
            insertCntrHubShareList.add(cntrHubShare);
            
            salesPersonMapIdNewSet.add(faf.Salesperson__c);
            
            
            salesmanagerNameMap.put(SalespersonManagerUser.Manager.Name, SalespersonManagerUser.id);
            salesmanagerNameMap.put(SalespersonManagerUser.Manager_Level_2__c, SalespersonManagerUser.id);
            salesmanagerNameMap.put(SalespersonManagerUser.Manager_Level_3__c, SalespersonManagerUser.id);
            salesmanagerNameMap.put(SalespersonManagerUser.Manager_Level_4__c, SalespersonManagerUser.id);
            salesmanagerNameMap.put(SalespersonManagerUser.Manager_Level_5__c, SalespersonManagerUser.id);
            salesmanagerNameMap.put(SalespersonManagerUser.Manager_Level_6__c, SalespersonManagerUser.id);
            salesmanagerNameMap.put(SalespersonManagerUser.Manager_Level_7__c, SalespersonManagerUser.id);          
            
            for(user uobj :[SELECT Id, Name FROM User WHERE Name IN:salesmanagerNameMap.keySet() and isActive=true]){
                if(salesmanagerNameMap.containsKey(uobj.Name)){
                    Set<Id> managerIdSet;
                    Id spid = salesmanagerNameMap.get(uobj.name);
                    if(salespersonToManagerIdMap.containsKey(spid)){
                        managerIdSet = salespersonToManagerIdMap.get(spid);
                    }else{
                        managerIdSet = new Set<Id>();
                    }
                    managerIdSet.add(uobj.id);
                    salespersonToManagerIdMap.put(spid, managerIdSet);                  
                }               
            }
            
            if(salespersonToManagerIdMap.containsKey(faf.Salesperson__c)){
                for(Id managerId:salespersonToManagerIdMap.get(faf.Salesperson__c)){
                    salesPersonMapIdNewSet.add(managerId);// using set to check permission set is added to team member or not
                    Central_Hub__Share cntrHubShare1 = new Central_Hub__Share(); // creating record for each account salesperson  
                    if(clientSubtype=='Coalition Master' || clientSubtype=='Health Plan Master'|| clientSubtype=='TPA Master'){
                        cntrHubShare1.AccessLevel = 'Edit'; 
                    }else{
                        cntrHubShare1.AccessLevel = 'Edit';  
                    }
                    
                    cntrHubShare1.ParentId = faf.Id; 
                    cntrHubShare1.RowCause = Label.FAF_Salesperson;
                    cntrHubShare1.UserOrGroupId = managerId;
                    insertCntrHubshareList.add(cntrHubShare1);
                }
            }       
          }
        }
            if(faf.Account_Name__c!=null) {
                for(AccountTeamMember actm:[SELECT Id,User.IsActive, UserId, AccountId, Account.OwnerId, TeamMemberRole 
                                            FROM AccountTeamMember WHERE AccountId=:faf.Account_Name__c AND User.isActive=true]){
                    Central_Hub__Share cntrHubShare1 = new Central_Hub__Share(); // creating record for each account team member for related account 
                    if(AccountRoleList.contains(actm.TeamMemberRole)){
                        if(clientSubtype=='Coalition Master' || clientSubtype=='Health Plan Master'|| clientSubtype=='TPA Master'){
                            salesPersonMapIdNewSet.add(actm.UserId);// using set to check permission set is added to team member or not
                            cntrHubShare1.AccessLevel='Edit'; 
                        }else{
                            cntrHubShare1.AccessLevel='Read';  
                        }                          
                    }else{
                        cntrHubShare1.AccessLevel='Read';  
                    }

                    cntrHubShare1.ParentId=faf.Id;
                    cntrHubShare1.RowCause ='Manual';
                    cntrHubShare1.UserOrGroupId=actm.UserId;
                    System.debug('cntrHubShare1'+cntrHubShare1);
                    insertCntrHubshareList.add(cntrHubShare1); // adding the account team member  central hub share record into common list 
                }
            }
            
            if(!insertCntrHubShareList.isEmpty()) {
                insert insertCntrHubShareList;
            } 
            
            if(!salesPersonMapIdNewSet.isEmpty()){
                insertUserWithPermission(salesPersonMapIdNewSet); // passing into future method to upsert the E-apttus sales permission set 
            }                      
                 
    }
}