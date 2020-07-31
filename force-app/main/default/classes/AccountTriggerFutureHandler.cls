public class AccountTriggerFutureHandler{
    //static variable to identify updates are coming from future calss
    public static boolean ExecutingAccountFutureUpdates=false;
    
    //method to check if the market segment is updated on account or not. If the market segment is updated then update the corresponding FAFs.
    public static void futureFAFupdates(map<id,account> newMap,map<id,account> oldMap){
        set<id> accids=new set<id>();
        for(account a:newMap.values()){
            if(a.Market_Segment__c!=oldMap.get(a.id).Market_Segment__c){
                accids.add(a.id);
            }
        }
        if(!accids.isEmpty()){
            if(system.isFuture() || system.isBatch()){
                ExecuteFafUpdates(accids);
            }
            else{
                FutureExecuteFafUpdates(accids);
            }
        }
    }
    
    @future
    public static void FutureExecuteFafUpdates(set<id> accids){
        ExecuteFafUpdates(accids);
    }
    
    public static void ExecuteFafUpdates(set<id> accids){
        try{
            list<Central_Hub__c> FAFList=new List<Central_Hub__c>();
            FAFList=[select id,Segment__c,Account_Name__r.Market_Segment__c from Central_Hub__c where Account_Name__c IN: accids];
            if(!FAFList.isEmpty()){
                for(Central_Hub__c f:FAFList){
                    f.Segment__c=f.Account_Name__r.Market_Segment__c;
                }
                ExecutingAccountFutureUpdates=true;
                database.update(FAFList,false);
           }
          }catch(exception e){}
    }
    /*=================================================================================================================================
     * @Method Name       : AccessToAccountOwner
     * @author            : Accenture
     * @Last modified by  : Accenture
     * @Last modified date: 30/03/2020
     * @Purpose           : Method to insert faf share record when an account owner is changed and delete faf share record for previous 
     account owner.
    ===================================================================================================================================*/ 
    
    public static void AccessToAccountOwner(Map<Id,Account> trNewMap, Map<Id, Account> oldMap){
            Set<Id> accId = new Set<Id>(); //set to store account ids for which ownerid is changed
            Map<ID,Account> newMap= new Map<Id,Account>(); // map to store account id as key and account as values for which ownerid is changed.
            for(Account acc: trNewMap.values()){
                if(acc.OwnerId!=oldMap.get(acc.id).OwnerId){
                    accId.add(acc.id);
                    newMap.put(acc.id, acc);
                }
            }

            
            if(!accId.isEmpty()){
                String jsonNewMap = JSON.serialize(newMap);
                String jsonOldMap = JSON.serialize(oldMap);
                FAFAccessToAccountOwner(jsonNewMap, jsonOldMap);
                assignPermissionSetToAccOwner(jsonNewMap, jsonOldMap);
            }
    }
 

    @future
    public static void FAFAccessToAccountOwner(String strNewMap, String strOldMap){
            
            Map<Id,Account> newMap= (Map<Id,Account>) JSON.deserialize(strNewMap, Map<Id,Account>.class);
            Map<Id,Account> oldMap= (Map<Id,Account>) JSON.deserialize(strOldMap, Map<Id,Account>.class);
            
            
            Map<string, User> userMap = new Map<string, User>();   // user Map where name as a key and Id as the value
            Map<string, User> userIdMap = new Map<string, User>();   // user Map where name as a key and Id as the value
            Set<Id>tempSet = new Set<Id>();
            Set<Id>FAFIDSet = new Set<Id>();
            set<ID> AccountOwnerID=new set<ID>();
            set<ID> AccountUser=new set<ID>();
            set<Id> oldAccOwnerId= new set<Id>();
            Map<Id,String> oldOwnerManager1= new Map<Id, String>();// maps to store managers to be deleted
            Map<Id,String> oldOwnerManager2= new Map<Id, String>();
            Map<Id,String> oldOwnerManager3= new Map<Id, String>();
            Map<Id,String> oldOwnerManager4= new Map<Id, String>();
            Map<Id,String> oldOwnerManager5= new Map<Id, String>();
            Map<Id,String> oldOwnerManager6= new Map<Id, String>();
            Map<Id,String> oldOwnerManager7= new Map<Id, String>();
            
           // Map<id, AccountTeamMember> accTeamMap = new Map<id, AccountTeamMember>([select UserId, AccountId from AccountTeamMember where AccountId IN: newMap.keyset()]);
            Map<id, AccountTeamMember> accTeamMap = new Map<id, AccountTeamMember>();
            List<AccountTeamMember> accteam =[select id, UserId, AccountId from AccountTeamMember where AccountId IN: newMap.keyset()];
            if(!accteam.isEmpty()){
            for(AccountTeamMember acc:accteam ){
                accTeamMap.put(acc.UserId, acc);
            }
            }
            //System.debug('accTeamMap     '+accTeamMap );
            set<id> teamUserId= new set<id>(); //set to store id of users to be deleted
            //Integer count=0;
           // System.debug('**** Account ***** '+newMap.values());
            //list to hold faf share record
             List<central_Hub__share> insertFAFShareList = new List<central_Hub__share>(); 
            //to store accesslevel 
            String Access='';
            Set<Id>AccountIdSetMaster = new Set<Id>();   //For storing the Account Id
            Set<Id>AccountIdSetNonMaster = new Set<Id>();
            
            //to get access level based on iums_client_subtype__c
            for(Account acc: newMap.values()){
                
                if(!string.isBlank(acc.iUMS_Client_Subtype__c)){
                    if(acc.iUMS_Client_Subtype__c.contains(ConstantsUtil.Master)&&  !string.isBlank(acc.iUMS_Client_Subtype__c)){
                        AccountIdSetMaster.add(acc.id);    //Adding AccountId in the AccountIdSetMaster
                    }
                    else if(!acc.iUMS_Client_Subtype__c.contains(ConstantsUtil.Master)){
                        AccountIdSetNonMaster.add(acc.id);
                    }
                }else if(string.isBlank(acc.iUMS_Client_Subtype__c)){
                        AccountIdSetNonMaster.add(acc.id);    //Adding AccountId in the AccountIdSetNonMaster
               }
                
            }
            if(!AccountIdSetMaster.isempty()){
                 Access=ConstantsUtil.Edit;
            }
            else
            if(!AccountIdSetNonMaster.isEmpty()){
                Access= ConstantsUtil.Read;
            }
                        
            //get all managers level from users..
            for(User use: [select id,profile.Id, Name, ManagerId, Manager.Name, Manager_Level_2__c, Manager_Level_3__c, Manager_Level_4__c, Manager_Level_5__c, Manager_Level_6__c, Manager_Level_7__c, IsActive from User]){
                if(use.profile.Id==Label.Apttus_sales_Profile){
                   userMap.put(use.Name, use);
                   oldOwnerManager1.put(use.id,use.Manager.Name);
                   oldOwnerManager2.put(use.id,use.Manager_Level_2__c);
                   oldOwnerManager3.put(use.id,use.Manager_Level_3__c);
                   oldOwnerManager4.put(use.id,use.Manager_Level_4__c);
                   oldOwnerManager5.put(use.id,use.Manager_Level_5__c);
                   oldOwnerManager6.put(use.id,use.Manager_Level_6__c);
                   oldOwnerManager7.put(use.id,use.Manager_Level_7__c);
               
                }
            }
            //query faf to get id
            Set<Central_Hub__c> centralHubid = new Set<Central_Hub__c>([Select Id from Central_Hub__c Where Account_Name__C IN: newMap.keyset() and FAF_Status__c NOT IN ('Deleted')]);
                        
            for(Account acc: newMap.values()){
                   if(accTeamMap.get(acc.ownerid)==null){
                   AccountUser.add(acc.ownerid);
                  }
            }
            
            if(!AccountUser.isEmpty()){
             for(User useAccOBj: [select id,profile.id, Name, ManagerId,Manager.Name, Manager_Level_2__c, Manager_Level_3__c, Manager_Level_4__c, Manager_Level_5__c, Manager_Level_6__c,
                           Manager_Level_7__c, IsActive from User where ID IN:AccountUser]){
                if(useAccOBj.profile.Id==Label.Apttus_sales_Profile){
                    AccountOwnerID.add(useAccOBj.ID);
                    
                    if(userMap.get(useAccOBj.Manager.Name)!=null){
                        AccountOwnerID.add(userMap.get(useAccOBj.Manager.Name).id);
                    }
                    if(userMap.get(useAccOBj.Manager_Level_2__c)!=null){
                        AccountOwnerID.add(userMap.get(useAccOBj.Manager_Level_2__c).id);
                    }
                    if(userMap.get(useAccOBj.Manager_Level_3__c)!=null){
                        AccountOwnerID.add(userMap.get(useAccOBj.Manager_Level_3__c).id);
                    }
                    if(userMap.get(useAccOBj.Manager_Level_4__c)!=null){
                        AccountOwnerID.add(userMap.get(useAccOBj.Manager_Level_4__c).id);
                    }
                    if(userMap.get(useAccOBj.Manager_Level_5__c)!=null){  
                        AccountOwnerID.add(userMap.get(useAccOBj.Manager_Level_5__c).id);
                    }
                    if(userMap.get(useAccOBj.Manager_Level_6__c)!=null){    
                        AccountOwnerID.add(userMap.get(useAccOBj.Manager_Level_6__c).id);
                    }
                    if(userMap.get(useAccOBj.Manager_Level_7__c)!=null){
                        AccountOwnerID.add(userMap.get(useAccOBj.Manager_Level_7__c).id);
                    } 
                    
                }
            }
            }
            //insert the faf share record for account.
            if(!centralHubid.isEmpty()){
                for(Central_Hub__c fafid:centralHubid){
                    if(!AccountOwnerID.isEmpty()){
                        for(ID ids:AccountOwnerID){
                            //if(accTeamMap.get(ids)==null){
                                central_Hub__share centHubShare= new central_Hub__share();
                                centHubShare.ParentId=fafid.id;
                                centHubShare.RowCause=Schema.central_Hub__share.RowCause.Account_Owner__c;
                                centHubShare.AccessLevel=Access;
                                centHubShare.UserOrGroupId=ids;
                                insertFAFShareList.add(centHubShare);
                            //}
                        }
                    }
                    FAFIDSet.add(fafid.id);
                }  
            }
                
            
            //iterate over newmap values to get all the previous owners in a set to be deleted from faf share...
            for(Account acc: newMap.values()){
                if(acc.OwnerId!=oldMap.get(acc.id).OwnerId){ 
                    teamUserId.add(oldMap.get(acc.id).OwnerId);
                    
                     if(userMap.get(oldOwnerManager1.get(oldMap.get(acc.id).OwnerId))!=null){
                         teamUserId.add(userMap.get(oldOwnerManager1.get(oldMap.get(acc.id).OwnerId)).Id);
                     }
                     if(userMap.get(oldOwnerManager2.get(oldMap.get(acc.id).OwnerId))!=null){
                         teamUserId.add(userMap.get(oldOwnerManager2.get(oldMap.get(acc.id).OwnerId)).Id);
                     }
                     if(userMap.get(oldOwnerManager3.get(oldMap.get(acc.id).OwnerId))!=null){    
                         teamUserId.add(userMap.get(oldOwnerManager3.get(oldMap.get(acc.id).OwnerId)).Id);
                     }
                     if(userMap.get(oldOwnerManager4.get(oldMap.get(acc.id).OwnerId))!=null){
                         teamUserId.add(userMap.get(oldOwnerManager4.get(oldMap.get(acc.id).OwnerId)).Id);
                     }
                     if(userMap.get(oldOwnerManager5.get(oldMap.get(acc.id).OwnerId))!=null){
                         teamUserId.add(userMap.get(oldOwnerManager5.get(oldMap.get(acc.id).OwnerId)).Id);
                     }
                     if(userMap.get(oldOwnerManager6.get(oldMap.get(acc.id).OwnerId))!=null){
                         teamUserId.add(userMap.get(oldOwnerManager6.get(oldMap.get(acc.id).OwnerId)).Id);
                     }
                     if(userMap.get(oldOwnerManager7.get(oldMap.get(acc.id).OwnerId))!=null){
                         teamUserId.add(userMap.get(oldOwnerManager7.get(oldMap.get(acc.id).OwnerId)).Id);
                     }
                    
                }
            }
            
            //query to get all the user ids to be deleted
            if(!teamUserId.isEmpty() && !FAFIDSet.isEmpty()){
            List<central_Hub__share> FafSharelist= [select id, UserOrGroupId, ParentId, RowCause, AccessLevel from central_Hub__share where UserOrGroupId in:teamUserId AND ParentId IN :FAFIDSet AND RowCause =: Schema.central_Hub__share.RowCause.Account_Owner__c];
            try{
            if(!FafSharelist.isEmpty()){
                 delete FafSharelist;
            }
            }catch(Exception e){}
    }
            
             //insert insertFAFShareList
             try{
             if(!insertFAFShareList.isEmpty()){
                insert insertFAFShareList;
              }
              }catch(Exception e){}
            
    }   
    
    //method to insert permissionset for sales user
    @future
    public static void assignPermissionSetToAccOwner(String strNewMap, String strOldMap){
        
        Map<Id,Account> newMap= (Map<Id,Account>) JSON.deserialize(strNewMap, Map<Id,Account>.class);
        Map<Id,Account> oldMap= (Map<Id,Account>) JSON.deserialize(strOldMap, Map<Id,Account>.class);
        Map<string, User> userMap = new Map<string, User>();   
        
        set<id>Salespersonadded= new set<id>();
            set<ID> AccountOwnerID=new set<ID>();
            Map<id, AccountTeamMember> accTeamMap = new Map<id, AccountTeamMember>();
            List<AccountTeamMember> accteam =[select id, UserId, AccountId from AccountTeamMember where AccountId IN: newMap.keyset()];
            
            set<ID> AccountUser=new set<ID>();
            
            for(User use: [select id,profile.Id, Name, ManagerId, Manager.Name, Manager_Level_2__c, Manager_Level_3__c, Manager_Level_4__c, Manager_Level_5__c, Manager_Level_6__c, Manager_Level_7__c, IsActive from User]){
                if(use.profile.Id==Label.Apttus_sales_Profile){
                   userMap.put(use.Name, use);
                }
            }
            if(!accteam.isEmpty()){
                for(AccountTeamMember acc:accteam ){
                    accTeamMap.put(acc.UserId, acc);
                }
            }
            //System.debug('accTeamMap     '+accTeamMap );
            
             for(Account acc: newMap.values()){
                
                if(accTeamMap.get(acc.ownerid)==null){
                   AccountUser.add(acc.ownerid);
                   
                }
            }
            if(!AccountUser.isEmpty()){
            for(User useAccOBj: [select id,profile.id, Name, ManagerId,Manager.Name, Manager_Level_2__c, Manager_Level_3__c, Manager_Level_4__c, Manager_Level_5__c, Manager_Level_6__c,
                           Manager_Level_7__c, IsActive from User where ID IN:AccountUser]){
                if(useAccOBj.profile.Id==Label.Apttus_sales_Profile){
                    AccountOwnerID.add(useAccOBj.ID);
                    
                    if(userMap.get(useAccOBj.Manager.Name)!=null){
                        AccountOwnerID.add(userMap.get(useAccOBj.Manager.Name).id);
                        
                    }
                    if(userMap.get(useAccOBj.Manager_Level_2__c)!=null){
                        AccountOwnerID.add(userMap.get(useAccOBj.Manager_Level_2__c).id);
                    }
                    if(userMap.get(useAccOBj.Manager_Level_3__c)!=null){
                        AccountOwnerID.add(userMap.get(useAccOBj.Manager_Level_3__c).id);
                    }
                    if(userMap.get(useAccOBj.Manager_Level_4__c)!=null){
                        AccountOwnerID.add(userMap.get(useAccOBj.Manager_Level_4__c).id);
                    }
                    if(userMap.get(useAccOBj.Manager_Level_5__c)!=null){  
                        AccountOwnerID.add(userMap.get(useAccOBj.Manager_Level_5__c).id);
                    }
                    if(userMap.get(useAccOBj.Manager_Level_6__c)!=null){    
                        AccountOwnerID.add(userMap.get(useAccOBj.Manager_Level_6__c).id);
                    }
                    if(userMap.get(useAccOBj.Manager_Level_7__c)!=null){
                        AccountOwnerID.add(userMap.get(useAccOBj.Manager_Level_7__c).id);
                    } 
                    
                }
            }
            }
        
        
        List<PermissionSetAssignment> permissionAssignToUpdate = new  List<PermissionSetAssignment> ();
        if(!AccountOwnerID.isEmpty()){
        List<PermissionSetAssignment> permissionAssign=[SELECT Id, PermissionSet.Name,PermissionSet.Id,AssigneeId,Assignee.Name FROM PermissionSetAssignment where PermissionSet.id=:Label.Apttus_Sales_Permissionset  and AssigneeId in: AccountOwnerID];
        for(PermissionSetAssignment pa:permissionAssign){
            Salespersonadded.add(pa.AssigneeId);
        }
        for(id salespId:AccountOwnerID){
            if(!Salespersonadded.isEmpty()){
                if(!Salespersonadded.contains(salespId)){
                    PermissionSetAssignment  psa = new PermissionSetAssignment (PermissionSetId = Label.Apttus_Sales_Permissionset , AssigneeId = salespId);
                    permissionAssignToUpdate.add(psa);
                }
            }
        }
        }
        try{
        if (permissionAssignToUpdate.size()>0){
             upsert permissionAssignToUpdate;// adding permission set if its not there for user 
        } 
        }catch(Exception e){}
    }
}