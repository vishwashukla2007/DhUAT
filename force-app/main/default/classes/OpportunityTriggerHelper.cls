public class OpportunityTriggerHelper {
    /*********************************************************************************************
* @Class Name      : OpportunityTriggerHelper
* @author   Preetham Padala
* @Created date     09/11/2018
* @description:This is the helper class for OpportunityTrigger providing faf access and E-apttus sales Permission to  to Oppty winner and Med D sales lead         
**********************************************************************************************/
    // deleting  sales person visibility to faf 
    public static void deleteSalespersonAccessOnFaf(List<Opportunity> oppList)
    {
        set<String>oppidSet= new set<String>(); 
         List<central_Hub__share> deletelist= new List<central_Hub__share>(); 
         List<central_Hub__share> updatelist= new List<central_Hub__share>(); 
         String Booleancheck = '0';
        set<String>oldOppSalespersonNameSet= new set<String>();
        
        for(Opportunity opp:oppList){
            if(opp.Oppty_Winner__c!= null){
                oldOppSalespersonNameSet.add(opp.Oppty_Winner__c);
                oppidSet.add(opp.id);
            }
            if(opp.Med_D_Sales_Lead__c!=null){
                oldOppSalespersonNameSet.add(opp.Med_D_Sales_Lead__c);
                oppidSet.add(opp.id);
            }

        }
        Map<id,User>olduserMap=New Map<id,User>([select id ,name from User where Name In:oldOppSalespersonNameSet]);
        
        Map<id,Central_Hub__c>oldfafMap=new  Map<id,Central_Hub__c>([select id ,name,Salesperson__c,Account_Name__c from Central_Hub__c where  Opportunity_Name__c in :oppidSet]);
        
        if(oldfafMap!=null && oldfafMap.size()>0){ 
            List<Central_Hub__c> CntrlShareHub=[Select Id,Account_Name__c from Central_Hub__c where Id in :oldfafMap.keySet()];
            
            // mentioned the condtion RowCause !='Owner' and RowCause !='Rule' because we cant delete the row which is having rowcause ='owner or rule it throws    DML Exception
           List<Central_Hub__Share>deleteCntrlShareHub=[Select Id,ParentId,UserOrGroupId ,RowCause From Central_Hub__Share where RowCause !='Owner' and RowCause !='Rule' and RowCause != :Label.FAF_Salesperson and ParentId In:oldfafMap.keySet()  and UserOrGroupId  In:olduserMap.keySet()];

           Id accountName = CntrlShareHub[0].Account_Name__c;
           Map<Id, Id> shareUserGroupMap = new Map<Id, Id>();
           Map<Id, List<AccountTeamMember>> userAccTeamMap = new Map<Id, List<AccountTeamMember>>();
           
           if(deleteCntrlShareHub!=null && deleteCntrlShareHub.size()>0){
                for(Central_Hub__Share share:deleteCntrlShareHub){                      
                    shareUserGroupMap.put(share.Id, share.UserOrGroupId);
                }
            }
            
            if(!shareUserGroupMap.isEmpty()) {
                List<AccountTeamMember> accountTeamList =[select Id,UserId, AccountId from AccountTeamMember 
                                                          where AccountId=:accountName and UserId =:shareUserGroupMap.values()];
                
                for(AccountTeamMember accTeam:accountTeamList) {
                    List<AccountTeamMember> accNewTeam  = userAccTeamMap.get(accTeam.UserId);
                    if(accNewTeam==null) {
                        accNewTeam = new List<AccountTeamMember>();
                    }
                    accNewTeam.add(accTeam);
                    userAccTeamMap.put(accTeam.UserId, accNewTeam);
                }
            }
            
            if(deleteCntrlShareHub!=null && deleteCntrlShareHub.size()>0){  // null check if deleteCntrlShareHub is not null 
                for(Central_Hub__Share share:deleteCntrlShareHub){
                    if (CntrlShareHub[0].Account_Name__c!=null){
                        List<AccountTeamMember> accountteam = userAccTeamMap.get(share.UserOrGroupId);
                        if(accountteam!=null && accountteam.size()>0 && deleteCntrlShareHub.size()>0){  // null check if accountteam is not null
                            Booleancheck = '1';
                            share.AccessLevel='Read';
                            updatelist.add(share);
                        } else {
                            deletelist.add(share);
                            Booleancheck = '1';
                        }                                               
                    } else if (deleteCntrlShareHub.size()>0){ 
                        deletelist.add(share);
                        Booleancheck = '1';
                    }
                }
            } // for loop
            
          if (deletelist.size()>0)
              { 
                delete deletelist;
              }
            if (updatelist.size()>0)
              { 
                 update updatelist;  
              }          
        List<id>deletepermissionset= new List<id>();
        deletepermissionset.addAll(olduserMap.keySet());
        if(deletepermissionset.size()>0 && Booleancheck == '1'){
            deleteUserWithPermission(deletepermissionset);
        }           
        }// old fapmap
    }
    // providing sales person visibility and E-apttus sales Permission to faf based on Opportunity winner Or Med D sales Lead 
    public static void salespersonAccessOnFaf(List<Opportunity> oppList, MAP<Id, Opportunity> oppOldMap)
    {
        List<Central_Hub__Share>insertCntrHubshareList= new List<Central_Hub__Share>();
        set<String>oppidSet= new set<String>();
        List<central_Hub__share> deletelist= new List<central_Hub__share>(); 
        List<central_Hub__share> updatelist= new List<central_Hub__share>(); 
        String Booleancheck = '0';
        Map<Id,String>oppWinneridMap= new  Map<Id,String>();
        set<String>oppSalespersonNameSet= new set<String>();
        set<String>oldOppSalespersonNameSet= new set<String>();
        set<id>acteamId= new set<id>();
        if(Trigger.isAfter && Trigger.isInsert){  
            for(Opportunity opp:oppList){
                if(opp.Oppty_Winner__c!= null){
                    oppSalespersonNameSet.add(opp.Oppty_Winner__c);
                    oppidSet.add(opp.id);
                    oppWinneridMap.put(opp.id,opp.Oppty_Winner__c);
                }
                if(opp.Med_D_Sales_Lead__c!=null){
                    oppSalespersonNameSet.add(opp.Med_D_Sales_Lead__c);
                    oppidSet.add(opp.id);
                    oppWinneridMap.put(opp.id,opp.Med_D_Sales_Lead__c);
                }
                
            }
            
            
        }else if(Trigger.isAfter && Trigger.isUpdate){
            for(Opportunity opp:oppList){
                if(opp.Oppty_Winner__c!= null && opp.Oppty_Winner__c!=oppOldMap.get(opp.id).Oppty_Winner__c && oppOldMap.get(opp.id).Oppty_Winner__c!=null){
                    oppSalespersonNameSet.add(opp.Oppty_Winner__c);
                    oppidSet.add(opp.id);
                    oppWinneridMap.put(opp.id,opp.Oppty_Winner__c);
                    oldOppSalespersonNameSet.add(oppOldMap.get(opp.id).Oppty_Winner__c);
                }
                if(opp.Oppty_Winner__c!= null && oppOldMap.get(opp.id).Oppty_Winner__c==null){
                    oppSalespersonNameSet.add(opp.Oppty_Winner__c);
                    oppidSet.add(opp.id);
                    oppWinneridMap.put(opp.id,opp.Oppty_Winner__c);
                    
                }
                system.debug('coming in out');
                if(opp.Oppty_Winner__c== null && oppOldMap.get(opp.id).Oppty_Winner__c!=opp.Med_D_Sales_Lead__c&& oppOldMap.get(opp.id).Oppty_Winner__c!=null ){
                    system.debug('coming in if');
                    oldOppSalespersonNameSet.add(oppOldMap.get(opp.id).Oppty_Winner__c);
                    oppidSet.add(opp.id); 
                }
                if(opp.Med_D_Sales_Lead__c!= null && opp.Med_D_Sales_Lead__c!=oppOldMap.get(opp.id).Med_D_Sales_Lead__c && oppOldMap.get(opp.id).Med_D_Sales_Lead__c!=null ){
                    oppSalespersonNameSet.add(opp.Med_D_Sales_Lead__c);
                    oppidSet.add(opp.id);
                    oppWinneridMap.put(opp.id,opp.Med_D_Sales_Lead__c);
                    oldOppSalespersonNameSet.add(oppOldMap.get(opp.id).Med_D_Sales_Lead__c);
                }
                if(opp.Med_D_Sales_Lead__c!= null && oppOldMap.get(opp.id).Med_D_Sales_Lead__c==null){
                    oppSalespersonNameSet.add(opp.Med_D_Sales_Lead__c);
                    oppidSet.add(opp.id); 
                    oppWinneridMap.put(opp.id,opp.Med_D_Sales_Lead__c);
                }
                if(opp.Med_D_Sales_Lead__c== null && oppOldMap.get(opp.id).Med_D_Sales_Lead__c!=opp.Oppty_Winner__c && oppOldMap.get(opp.id).Med_D_Sales_Lead__c!=null ){
                    oldOppSalespersonNameSet.add(oppOldMap.get(opp.id).Med_D_Sales_Lead__c);
                    oppidSet.add(opp.id); 
                }
            }
        }
        
        
        
        Map<String,id>olduserMap=new Map<String,id>();
        Map<string,id>salesmanagerNameMapold= new Map<string,id>();
        List<User>SalespersonManagerListold=[select id,Name,Manager.Name,Manager_Level_2__c,Manager_Level_3__c,Manager_Level_4__c,Manager_Level_5__c,Manager_Level_6__c,Manager_Level_7__c from User where Name in:oldOppSalespersonNameSet];
        set<id>salespersonToManagerIdoldSet=new set<id>();
        for(user uobj :SalespersonManagerListold){
            salespersonToManagerIdoldSet.add(uobj.id);
            olduserMap.put(uobj.Manager.Name,uobj.id);
            olduserMap.put(uobj.Manager_Level_2__c,uobj.id);
            olduserMap.put(uobj.Manager_Level_3__c,uobj.id);
            olduserMap.put(uobj.Manager_Level_4__c,uobj.id);
            olduserMap.put(uobj.Manager_Level_5__c,uobj.id);
            olduserMap.put(uobj.Manager_Level_6__c,uobj.id);
            olduserMap.put(uobj.Manager_Level_7__c,uobj.id);
            
        }
        
        
        for(user uobj :[select id,name from user where name in:olduserMap.keyset() and isactive=true]){
            salespersonToManagerIdoldSet.add(uobj.id);
            
        } 
        
       Map<id,Central_Hub__c>oldfafMap=new  Map<id,Central_Hub__c>([select id ,name,Salesperson__c from Central_Hub__c where Opportunity_Name__c in :oppidSet]);
        List<Central_Hub__c>CntrlShareHub=[Select Id,Account_Name__c from Central_Hub__c where Id in :oldfafMap.keySet()];
        if(oldfafMap!=null && oldfafMap.size()>0){ 
            // mentioned the condtion RowCause !='Owner' and RowCause !='Rule' because we cant delete the row which is having rowcause ='owner or rule it throws    DML Exception
           List<Central_Hub__Share>deleteCntrlShareHub=[Select Id,ParentId,UserOrGroupId ,RowCause From Central_Hub__Share where RowCause !='Owner' and RowCause !='Rule' and RowCause != :Label.FAF_Salesperson and ParentId In:oldfafMap.keySet()  and UserOrGroupId  In:salespersonToManagerIdoldSet];
           Id accountName = CntrlShareHub[0].Account_Name__c;
           Map<Id, Id> shareUserGroupMap = new Map<Id, Id>();
           Map<Id, List<AccountTeamMember>> userAccTeamMap = new Map<Id, List<AccountTeamMember>>();
           
           if(deleteCntrlShareHub!=null && deleteCntrlShareHub.size()>0){
                for(Central_Hub__Share share:deleteCntrlShareHub){                      
                    shareUserGroupMap.put(share.Id, share.UserOrGroupId);
                }
            }
            
            if(!shareUserGroupMap.isEmpty()) {
                List<AccountTeamMember> accountTeamList =[select Id,UserId, AccountId from AccountTeamMember 
                                                          where AccountId=:accountName and UserId =:shareUserGroupMap.values()];
                
                for(AccountTeamMember accTeam:accountTeamList) {
                    List<AccountTeamMember> accNewTeam  = userAccTeamMap.get(accTeam.UserId);
                    if(accNewTeam==null) {
                        accNewTeam = new List<AccountTeamMember>();
                    }
                    accNewTeam.add(accTeam);
                    userAccTeamMap.put(accTeam.UserId, accNewTeam);
                }
            }
            
            if(deleteCntrlShareHub!=null && deleteCntrlShareHub.size()>0){  // null check if deleteCntrlShareHub is not null 
                for(Central_Hub__Share share:deleteCntrlShareHub){
                    if (CntrlShareHub[0].Account_Name__c!=null){
                        List<AccountTeamMember> accountteam = userAccTeamMap.get(share.UserOrGroupId);
                        if(accountteam!=null && accountteam.size()>0 && deleteCntrlShareHub.size()>0){  // null check if accountteam is not null
                            Booleancheck = '1';
                            share.AccessLevel='Read';
                            updatelist.add(share);
                        } else {
                            deletelist.add(share);
                            Booleancheck = '1';
                        }                                               
                    } else if (deleteCntrlShareHub.size()>0){ 
                        deletelist.add(share);
                        Booleancheck = '1';
                    }
                }
            } // for loop
          if (deletelist.size()>0)
              { 
                delete deletelist;
              }
            if (updatelist.size()>0)
              { 
                 update updatelist;  
              }          
        List<id>deletepermissionset= new List<id>();
        deletepermissionset.addAll(salespersonToManagerIdoldSet);
        if(deletepermissionset.size()>0 && Booleancheck == '1'){
            deleteUserWithPermission(deletepermissionset);
        }           
        }// old fapmap
        
        
        
        
        
        
        set<String>clntSuTypeList= new set<String>();
        clntSuTypeList.add('Coalition Master');
        clntSuTypeList.add('Health Plan Master');
        clntSuTypeList.add('TPA Master');
        
        Map<String,Id>userNameIdMap= new Map<String,Id>();
        List<User>SalespersonManagerList=[select id,Name,Manager.Name,Manager_Level_2__c,Manager_Level_3__c,Manager_Level_4__c,Manager_Level_5__c,Manager_Level_6__c,Manager_Level_7__c from User where Name in:oppSalespersonNameSet];
        for(user uobj :SalespersonManagerList){
            userNameIdMap.put(uobj.Name,uobj.id);
            userNameIdMap.put(uobj.Manager.Name,uobj.id);
            userNameIdMap.put(uobj.Manager_Level_2__c,uobj.id);
            userNameIdMap.put(uobj.Manager_Level_3__c,uobj.id);
            userNameIdMap.put(uobj.Manager_Level_4__c,uobj.id);
            userNameIdMap.put(uobj.Manager_Level_5__c,uobj.id);
            userNameIdMap.put(uobj.Manager_Level_6__c,uobj.id);
            userNameIdMap.put(uobj.Manager_Level_7__c,uobj.id);
            
        }   
        Map<id,set<id>>salespersonToManagerIdMap= new Map<id,set<id>>();
        
        for(user uobj :[select id,name from user where name in:userNameIdMap.keyset() and isactive=true]){
            if(userNameIdMap.containsKey(uobj.name)){
                id spid=userNameIdMap.get(uobj.name);
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
        
        
        
        
        List<Central_Hub__c>fafList=[select id ,Client_Subtype__c,name,Opportunity_Name__c,Salesperson__c from Central_Hub__c where  Opportunity_Name__c in :oppidSet and FAF_Status__c NOT IN ('Deleted')];
        
        for (Central_Hub__c faf:fafList){
            
            if(oppWinneridMap.containsKey(faf.Opportunity_Name__c)){
                String oppWinnerOrMedDName=oppWinneridMap.get(faf.Opportunity_Name__c);
                if(userNameIdMap.containsKey(oppWinnerOrMedDName)){
                    Central_Hub__Share cntrHubShare= new Central_Hub__Share(); // creating record for each account salesperson  
                    if(clntSuTypeList.contains(faf.Client_Subtype__c)){
                        cntrHubShare.AccessLevel='Edit'; acteamId.add(userNameIdMap.get(oppWinnerOrMedDName));
                    }else{
                        cntrHubShare.AccessLevel='Read';
                    } 
                    cntrHubShare.ParentId=faf.id; 
                    cntrHubShare.RowCause ='Manual';
                    cntrHubShare.UserOrGroupId=userNameIdMap.get(oppWinnerOrMedDName);
                   
                    insertCntrHubshareList.add(cntrHubShare);
                    if(salespersonToManagerIdMap.containsKey(userNameIdMap.get(oppWinnerOrMedDName))){
                        for(id managerId:salespersonToManagerIdMap.get(userNameIdMap.get(oppWinnerOrMedDName))){
                            Central_Hub__Share cntrHubShare1= new Central_Hub__Share(); // creating record for each account salesperson  
                            if(clntSuTypeList.contains(faf.Client_Subtype__c)){
                                cntrHubShare1.AccessLevel='Edit';   acteamId.add(managerId);// using set to check permission set is added to team member or not
                            }else{
                                cntrHubShare1.AccessLevel='Read';  
                            }
                            
                            cntrHubShare1.ParentId=faf.id; 
                            cntrHubShare1.RowCause ='Manual';
                            cntrHubShare1.UserOrGroupId=managerId;
                            insertCntrHubshareList.add(cntrHubShare1);
                        }
                    }
                    
                    
                    
                    // adding the salesperson central share hub record into common list 
                }
            }
            
            
        }
        if(insertCntrHubshareList!=null && insertCntrHubshareList.size()>0){
            try{
                Database.insert(insertCntrHubshareList,false);  // inserting new  and Oppty winner and med d sales lead  access on faf
            }catch(Exception e){
                system.debug('Exception '+e.getMessage() +' at line '+ e.getLineNumber());
            }
        }
        
        
        if(acteamId.size()>0){
               system.debug('@@@@@@acteamId'+acteamId);
            insertUserWithPermission(acteamId);// calling future method to upsert Permision set
        }
        
        List<id>deletepermissionset= new List<id>();

        deletepermissionset.addAll(salespersonToManagerIdoldSet);
          system.debug('@@@@@@deletepermissionset'+deletepermissionset);
        if(deletepermissionset.size()>0){
            deleteUserWithPermission(deletepermissionset);// calling future method to delete Permision set if sales person is not havng other faf visibility
        }
        
        
    }
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
        
        if(existinguserDelete.size()>0 || Test.isRunningTest()){
            
            List<PermissionSetAssignment> permissionAssign=[SELECT Id, PermissionSet.Name,PermissionSet.Id,AssigneeId,Assignee.Name FROM PermissionSetAssignment where PermissionSet.id=:Label.Apttus_Sales_Permissionset  and AssigneeId in: existinguserDelete];
            
            if (permissionAssign.size()>0){
                delete  permissionAssign;
            } 
            
            
        }
    }
}