/* =================================================================================
* @Class Name        : UserTriggerHelper
* @author            : Abhishek Tiwari(Accenture)
* @created date      : 16/07/2018
* @Last modified by  : Abhishek Tiwari(Accenture)
* @Last modified date: 25/07/2018
* @Purpose           : Helper class of User trigger 
=======================================================================================*/

public with sharing class UserTriggerHelper{
    
    //Method will use to manage Public group Assignment on User Creation
    public static void updatePublicGrpOnInsert(List<User>userList, Boolean isInsertBool, Boolean isUpdateBool, Map<Id,User>userOldMap, Map<Id,User>userNewMap){
        try{
            Set<string>tempSet;
            Set<string>marketSegmentSet = new Set<string>();    //For store the value of Market Segment in a set
            List<GroupMember>groupMemberList = new List<GroupMember>();    //List use to Insert Public Group Member
            GroupMember groupMemberObj;
            Map<String, ID>groupMarketSegmentRelMap = new Map<String, ID>();   //Map used to Assign the Market Segment with Group Id
            string profileString = Label.ApttusUnderwritingProfileLabel;
            Profile prof = [select id, name from Profile where name=: profileString];  // Query the Profile Id for Apttus Underwriting
            
            //Query the Custom Metadata Type
            List<UserMarketSegPublicGrp__mdt> userMrkSegList = [select id, DeveloperName, PublicGroupName__c from UserMarketSegPublicGrp__mdt];
            MAP<string, string>userMarSegPbGrpMap = new Map<string, string>();   //Map use to store Custom metaData type Info
            MAP<string, string>userPbGrpMarSegMap = new Map<string, string>();   //Map use to store Custom metaData type Info
            for(UserMarketSegPublicGrp__mdt cs: userMrkSegList){
                userMarSegPbGrpMap.put(cs.DeveloperName, cs.PublicGroupName__c);  //Assign value in the map from Custom MetaData Type
                userPbGrpMarSegMap.put(cs.PublicGroupName__c, cs.DeveloperName);  //Assign value in the map from Custom MetaData Type
            }
            
            for(String key: userNewMap.keySet()){
                if(userNewMap.get(key).isActive && !(String.isBlank(userNewMap.get(key).Market_Segment__c)) && prof.id.equals(userNewMap.get(key).profileid)){ //Check user is Active and Profie is same as Apttus Underwriting
                    tempSet = new Set<string>();
                    for(String str: userNewMap.get(key).Market_Segment__c.split(ConstantsUtil.SEMICOLONSTRSTR)){      //Split the value of Multiselect Picklist
                        if(str.equals(ConstantsUtil.AETNA) || str.equals(ConstantsUtil.ANTHEM)){
                            if((str.equals(ConstantsUtil.AETNA) && userNewMap.get(key).Aetna_NDA__c) || str.equals(ConstantsUtil.ANTHEM) && userNewMap.get(key).Anthem_NDA__c){  //condition to check Aetna_NDA__c or Anthem_NDA__c chdeck box is checked 
                                tempSet.add(str.remove(ConstantsUtil.SPACESTR));
                                marketSegmentSet.add(userMarSegPbGrpMap.get(str.remove(ConstantsUtil.SPACESTR)));
                            }
                        }else{
                            tempSet.add(str.remove(ConstantsUtil.SPACESTR));
                            marketSegmentSet.add(userMarSegPbGrpMap.get(str.remove(ConstantsUtil.SPACESTR)));
                        }
                    }
                }
            }
            
            if(!marketSegmentSet.isEmpty()){
                List<Group>publicGrpList = [SELECT Id, Developername  FROM Group where Developername in: marketSegmentSet];   //Query the Group info Present in the Org
                if(!publicGrpList.isEmpty()){   //check the List is empty or not
                    for(Group grp: publicGrpList){
                        groupMarketSegmentRelMap.put(userPbGrpMarSegMap.get(grp.Developername), grp.id);   //Assign the Market Segment with Group Id and create a Map
                    }
                    List<GroupMember>grpMembList = [SELECT Id, GroupId, UserOrGroupId FROM GroupMember where GroupId in: publicGrpList];  //Query the Group Memmber
                }
                for(String key: userNewMap.keySet()){
                    
                    //Check user is Active and Profie is same as Apttus Underwriting and market Segment is Not Blank
                    if(userNewMap.get(key).isActive && !(String.isBlank(userNewMap.get(key).Market_Segment__c)) && prof.id.equals(userNewMap.get(key).profileid)){ 
                        for(String str: userNewMap.get(key).Market_Segment__c.split(ConstantsUtil.SEMICOLONSTRSTR)){
                            if(str.equals(ConstantsUtil.AETNA) || str.equals(ConstantsUtil.ANTHEM)){
                                
                                //condition to check Aetna_NDA__c or Anthem_NDA__c chdeck box is checked 
                                if((str.equals(ConstantsUtil.AETNA) && userNewMap.get(key).Aetna_NDA__c) || str.equals(ConstantsUtil.ANTHEM) && userNewMap.get(key).Anthem_NDA__c){
                                    groupMemberObj = new GroupMember();
                                    groupMemberObj.UserOrGroupId = key;
                                    groupMemberObj.GroupId = groupMarketSegmentRelMap.get(str.remove(ConstantsUtil.SPACESTR)); 
                                    groupMemberList.add(groupMemberObj);
                                }
                            }else{
                                groupMemberObj = new GroupMember();groupMemberObj.UserOrGroupId = key;
                                
                                groupMemberObj.GroupId = groupMarketSegmentRelMap.get(str.remove(ConstantsUtil.SPACESTR));groupMemberList.add(groupMemberObj);
                                
                            }
                        }
                    }
                }
                if(!groupMemberList.isEmpty()){
                    insert groupMemberList;  //Insert GroupMember
                }
            }
        }catch(Exception excp){  ApexPages.addMessages(excp);
        }
    }
    
    //Method will use to manage Public group Assignment on User Updation
    public static void updatePublicGrpOnUpdate(List<User>userList, Boolean isInsertBool, Boolean isUpdateBool, Map<Id,User>userOldMap, Map<Id,User>userNewMap){
        try{
            Set<Id> grpMemberDel = new Set<Id>();     //Group Member set used to store the id of rec need to Del
            Set<string>tempSet;
            List<GroupMember> grpMemberDelList = new List<GroupMember>();    //List used to Delete the Public Group Member
            Set<string>marketSegmentSet = new Set<string>();                 //For store the value of Market Segment in a set
            List<GroupMember>groupMemberList = new List<GroupMember>();      //List use to Insert Public Group Member
            GroupMember groupMemberObj;
            Map<String, ID>groupMarketSegmentRelMap = new Map<String, ID>();     //Map used to Assign the Market Segment with Group Id
            
            //Query the Custom Metadata Type
            List<UserMarketSegPublicGrp__mdt> userMrkSegList = [select id, DeveloperName, PublicGroupName__c from UserMarketSegPublicGrp__mdt];
            MAP<string, string>userMarSegPbGrpMap = new Map<string, string>();     //Map use to store Custom metaData type Info
            MAP<string, string>userPbGrpMarSegMap = new Map<string, string>();     //Map use to store Custom metaData type Info
            for(UserMarketSegPublicGrp__mdt cs: userMrkSegList){
                userMarSegPbGrpMap.put(cs.DeveloperName, cs.PublicGroupName__c);     //Assign value in the map from Custom MetaData Type
                userPbGrpMarSegMap.put(cs.PublicGroupName__c, cs.DeveloperName);     //Assign value in the map from Custom MetaData Type
            }
            string profileString = Label.ApttusUnderwritingProfileLabel; 
            Profile prof = [select id, name from Profile where name=: profileString];     //Query Profile from Apttus Underwriting
            for(String key: userNewMap.keySet()){
                
                //check when we need to add the groupMemver id in Delete List
                if(((userNewMap.get(key).isActive != userOldMap.get(key).isActive) && !(userNewMap.get(key).isActive) && (prof.id.equals(userNewMap.get(key).profileid))) ||
                   (userNewMap.get(key).profileid != userOldMap.get(key).profileid && prof.id != userNewMap.get(key).profileid && (prof.id.equals(userNewMap.get(key).profileid))) || (string.isBlank(userNewMap.get(key).Market_Segment__c) && prof.id.equals(userNewMap.get(key).profileid)) || ((userNewMap.get(key).profileid != userOldMap.get(key).profileid) && (prof.id.equals(userOldMap.get(key).profileid)))){
                       grpMemberDel.add(key);
                   }else if(((userNewMap.get(key).isActive != userOldMap.get(key).isActive) && userNewMap.get(key).isActive && (prof.id.equals(userNewMap.get(key).profileid))) ||
                            ((userNewMap.get(key).isActive == userOldMap.get(key).isActive) && userNewMap.get(key).isActive &&
                             (userNewMap.get(key).Market_Segment__c != userOldMap.get(key).Market_Segment__c) && (prof.id.equals(userNewMap.get(key).profileid))) || (userNewMap.get(key).isActive && ((userNewMap.get(key).Aetna_NDA__c != userOldMap.get(key).Aetna_NDA__c) || (userNewMap.get(key).Anthem_NDA__c != userOldMap.get(key).Anthem_NDA__c)) && (prof.id.equals(userNewMap.get(key).profileid))) || ((userNewMap.get(key).profileid != userOldMap.get(key).profileid) && (prof.id.equals(userNewMap.get(key).profileid)))){ ////check when we need to add the groupMemver id in Insert List
                                 
                                 tempSet = new Set<string>();
                                 for(String str: userNewMap.get(key).Market_Segment__c.split(ConstantsUtil.SEMICOLONSTRSTR)){
                                     if(str.equals(ConstantsUtil.AETNA) || str.equals(ConstantsUtil.ANTHEM)){
                                         
                                         //Check user is Active and Profie is same as Apttus Underwriting or market Segment is Not Blank
                                         if((str.equals(ConstantsUtil.AETNA) && userNewMap.get(key).Aetna_NDA__c) || str.equals(ConstantsUtil.ANTHEM) && userNewMap.get(key).Anthem_NDA__c){
                                             tempSet.add(str.remove(ConstantsUtil.SPACESTR));
                                             marketSegmentSet.add(userMarSegPbGrpMap.get(str.remove(ConstantsUtil.SPACESTR)));
                                         }
                                     }else{
                                         tempSet.add(str.remove(ConstantsUtil.SPACESTR));
                                         marketSegmentSet.add(userMarSegPbGrpMap.get(str.remove(ConstantsUtil.SPACESTR)));
                                     }
                                 }
                                 grpMemberDel.add(key);
                             }
            }
            if(!marketSegmentSet.isEmpty()){  //check marketSegmentSet is empty or not
                List<Group>publicGrpList = [SELECT Id, Developername  FROM Group where Developername in: marketSegmentSet];   //Query the Group info Present in the Org
                if(!publicGrpList.isEmpty()){
                    for(Group grp: publicGrpList){
                        groupMarketSegmentRelMap.put(userPbGrpMarSegMap.get(grp.Developername), grp.id);    //Assign the Market Segment with Group Id and create a Map
                    }
                    List<GroupMember>grpMembList = [SELECT Id, GroupId, UserOrGroupId FROM GroupMember where GroupId in: publicGrpList];
                }
                for(String key: userNewMap.keySet()){
                    if(userNewMap.get(key).isActive && !(String.isBlank(userNewMap.get(key).Market_Segment__c)) && prof.id.equals(userNewMap.get(key).profileid)){
                        for(String str: userNewMap.get(key).Market_Segment__c.split(ConstantsUtil.SEMICOLONSTRSTR)){
                            if(str.equals(ConstantsUtil.AETNA) || str.equals(ConstantsUtil.ANTHEM)){
                                
                                //Check user is Active and Profie is same as Apttus Underwriting or market Segment is Not Blank
                                if((str.equals(ConstantsUtil.AETNA) && userNewMap.get(key).Aetna_NDA__c) || str.equals(ConstantsUtil.ANTHEM) && userNewMap.get(key).Anthem_NDA__c){
                                    groupMemberObj = new GroupMember();
                                    groupMemberObj.UserOrGroupId = key;
                                    groupMemberObj.GroupId = groupMarketSegmentRelMap.get(str.remove(ConstantsUtil.SPACESTR));
                                    groupMemberList.add(groupMemberObj);
                                }
                            }else{
                                if( groupMarketSegmentRelMap.get(str.remove(ConstantsUtil.SPACESTR))!=null){
                                groupMemberObj = new GroupMember();   groupMemberObj.UserOrGroupId = key;
                                groupMemberObj.GroupId = groupMarketSegmentRelMap.get(str.remove(ConstantsUtil.SPACESTR));
                                groupMemberList.add(groupMemberObj);
                                }
                            }
                        }
                    }
                }
            }
            if(!grpMemberDel.isEmpty()){
                grpMemberDelList  = [select id, UserOrGroupId from GroupMember where UserOrGroupId in:grpMemberDel];
                if(!grpMemberDelList.isEmpty()){
                    delete grpMemberDelList;  //Delete Group Member
                }
            }
            if(!groupMemberList.isEmpty()){
                insert groupMemberList;      //Insert Group Member
            }
        }catch(Exception excp){ ApexPages.addMessages(excp);
        }
    }
    
    
    
    
    //Method will use to add user to Permission set based on custom setting dynamically 
    //Added by Preetham Padala
    public static void addUserTOPermissionSetInsert(List<User>userList){
        try{
            List<Apttus_Ops_Permission_Set_Assignment__c> userOperaionAreaList = [select id,name,Permission_Set_ID__c,Permission_Set_Name__c from Apttus_Ops_Permission_Set_Assignment__c];
            MAP<string, string>userOperationAreaMap = new Map<string, string>();   //Map use to store Custom metaData type Info
            for(Apttus_Ops_Permission_Set_Assignment__c cs: userOperaionAreaList){
                userOperationAreaMap.put(cs.name, cs.Permission_Set_ID__c);  //Assign value in the map from Custom Settings 
                
            }
            List<PermissionSetAssignment> permissionSetList = new List<PermissionSetAssignment>();
            for(User uObj: userList){
                if(uObj.IsActive && uobj.ProfileId==Label.Apttus_Operations_Profile_Id && uObj.Operational_Area__c!=null ||Test.isRunningTest() ){
                    if(userOperationAreaMap.containsKey(uObj.Operational_Area__c)){
                        PermissionSetAssignment psa = new PermissionSetAssignment (PermissionSetId =userOperationAreaMap.get(uObj.Operational_Area__c) , AssigneeId = uObj.Id);
                        permissionSetList.add(psa);
                    }
                    
                }   
            }
            if(permissionSetList.size()>0){
                upsert permissionSetList;
            }
        }catch(Exception ex){
            system.debug('exception '+ex.getMessage() +' at line '+ex.getLineNumber());
        }
    }
    
    //Method will use to add user to Permission set and Queue  based on custom setting dynamically 
    //Added by Preetham Padala
    public static void addUserTOPermissionSetUpdate(List<User>userList,Map<Id,User>userOldMap){
        try{
            List<GroupMember> GMlist = new List<GroupMember>();
            List<Apttus_Ops_Permission_Set_Assignment__c> userOperaionAreaList = [select id,Queue_IDs__c,name,Permission_Set_ID__c,Permission_Set_Name__c from Apttus_Ops_Permission_Set_Assignment__c];
            MAP<string, string>userOperaionAreaMap = new Map<string, string>();   //Map use to store Custom metaData type Info
            MAP<string, string>userOperaionAreaQueueMap = new Map<string, string>();   //Map use to store Custom metaData type Info
            for(Apttus_Ops_Permission_Set_Assignment__c cs: userOperaionAreaList){
                userOperaionAreaMap.put(cs.name, cs.Permission_Set_ID__c);  //Assign value in the map from Custom Settings 
                if(cs.Queue_IDs__c!=null){
                    userOperaionAreaQueueMap.put(cs.name,cs.Queue_IDs__c);
                }
                
            }
            Map<id,id>deletepermissionSet= new map<id,id>();
            Map<id,id>deletequeue= new map<id,id>();
            
            List<id>deletepermissionList= new List<id>();
            List<PermissionSetAssignment> permissionSetList = new List<PermissionSetAssignment>();
            for(User uObj: userList){
                if(uObj.ProfileId==Label.Apttus_Operations_Profile_Id || userOldMap.get(uObj.id).ProfileId==Label.Apttus_Operations_Profile_Id){
                    if(( uObj.IsActive!=userOldMap.get(uObj.id).IsActive)|| ( uObj.Operational_Area__c!=userOldMap.get(uObj.id).Operational_Area__c)  || ( uObj.ProfileId!=userOldMap.get(uObj.id).ProfileId)){
                        if(uObj.IsActive && uobj.ProfileId==Label.Apttus_Operations_Profile_Id && uObj.Operational_Area__c!=null ){
                            if(userOperaionAreaMap.containsKey(uObj.Operational_Area__c)){
                                PermissionSetAssignment psa = new PermissionSetAssignment (PermissionSetId =userOperaionAreaMap.get(uObj.Operational_Area__c) , AssigneeId = uObj.Id);
                                permissionSetList.add(psa);
                            }
                            if(userOldMap.get(uObj.id).Operational_Area__c!=null){
                                deletepermissionSet.put(uObj.id,userOperaionAreaMap.get(userOldMap.get(uObj.id).Operational_Area__c));
                                if(userOperaionAreaQueueMap.containsKey(userOldMap.get(uObj.id).Operational_Area__c)){
                                    String AreaIds=userOperaionAreaQueueMap.get(userOldMap.get(uObj.id).Operational_Area__c);
                                    for(String gid:AreaIds.split(',')){
                                        deletequeue.put(gid,uObj.id);
                                    }
                                    
                                }
                                
                            }
                            if(userOperaionAreaQueueMap.containsKey(uObj.Operational_Area__c)){
                                String AreaIds=userOperaionAreaQueueMap.get(uObj.Operational_Area__c);
                                for(String gid:AreaIds.split(',')){
                                    GroupMember GM = new GroupMember();
                                    GM.UserOrGroupId = uObj.Id;                         
                                    GM.GroupId = gid;                           
                                    GMList.add(GM); 
                                }
                            }
                            
                        }else{
                            deletepermissionList.add(uObj.id);
                        }
                    }
                }
            }   
            if(deletepermissionSet.size()>0){
                
                List<PermissionSetAssignment>deletepermission=[select id ,PermissionSetId,AssigneeId from PermissionSetAssignment where AssigneeId in:deletepermissionSet.keySet() and PermissionSetId in:deletepermissionSet.values()];
                if(deletepermission.size()>0)
                    delete deletepermission;
            }
            if(deletequeue.size()>0){
                
                List<GroupMember> ListGM  = [ Select Id from GroupMember where UserOrGroupID in :deletequeue.values() and GroupId  in :deletequeue.keySet() ];
                if(ListGM.size() > 0 )
                {
                    delete ListGM;
                }       
            }
            
            
            if(deletepermissionList.size()>0){
                List<PermissionSetAssignment>deleteAllCustompermission=[select id ,PermissionSetId,AssigneeId from PermissionSetAssignment where AssigneeId in:deletepermissionList and PermissionSetId in:userOperaionAreaMap.values()];
                if(deleteAllCustompermission.size()>0)
                    delete deleteAllCustompermission;
                
                
                List<GroupMember> ListGM  = [ Select Id from GroupMember where UserOrGroupID in :deletepermissionList ];
                if(ListGM.size() > 0 )
                {
                    delete ListGM;
                }
            }
            if(permissionSetList.size()>0){
                upsert permissionSetList;
            }
            
            if(GMList.size()>0){
                upsert GMList;
            }
        }catch(Exception ex){
            system.debug('exception '+ex.getMessage() +' at line '+ex.getLineNumber());
        }
    }      
        public static void updatePSOnInsert(List<User>userList, Boolean isInsertBool, Boolean isUpdateBool, Map<Id,User>userOldMap, Map<Id,User>userNewMap){
        try{
            Map<Id, String> PermissionSetIdName = new Map<Id, String>();
            Set<String> PermissionSetnameSet = new Set<String>();
            Map<string, Id>permissionSetIdLabelMap = new Map<string, Id>();
            Map<string, string> permissionSetPicklistMap = new map<string, string>{'RCO-ANCS'=>'RCO_ANCS', 'RCO-Application Admin'=>'RCO_Application_Admin', 'RCO-Clinical Advisor'=>'RCO_Clinical_Advisor', 'RCO-Rebate Forecast'=>'RCO_Rebate_Forecast', 'RCO-Sales'=>'RCO_Sales', 'RCO-Triage'=>'RCO_Triage', 'RCO-Underwriter'=>'RCO_Underwriter'};
            
            for(String str: permissionSetPicklistMap.keyset()){
                //PermissionSetIdName.put(str)
                PermissionSetnameSet.add(permissionSetPicklistMap.get(str));
            }
            List <permissionSet> permissionSetList = [select id, Name, Label from permissionSet where name in:PermissionSetnameSet];
            for(permissionSet per: permissionSetList){
                permissionSetIdLabelMap.put(per.Label, per.Id);
            }
            List<PermissionSetAssignment> assignemntList = new List<PermissionSetAssignment>();
            PermissionSetAssignment assignemntObj; 
            for(Id useId: userNewMap.keyset()){
                if(!String.isBlank(userNewMap.get(useId).Change_Order_Permission__c)){ 
                    assignemntObj = new PermissionSetAssignment();
                    assignemntObj.PermissionSetId = permissionSetIdLabelMap.get(userNewMap.get(useId).Change_Order_Permission__c);
                    assignemntObj.AssigneeId = useId;
                    assignemntList.add(assignemntObj);
                }
            }
            if(assignemntList.size()>0){
                insert assignemntList;
            }
        }
        catch(Exception excp){  
            system.debug('=========excp======'+excp);
        }
    }
    public static void updatePSOnUpdate(List<User>userList, Boolean isInsertBool, Boolean isUpdateBool, Map<Id,User>userOldMap, Map<Id,User>userNewMap){
        try{
            Map<Id, String> PermissionSetIdName = new Map<Id, String>();
            Set<String> PermissionSetnameSet = new Set<String>();
            Set<Id> PermissionSetIdSet = new Set<Id>();           
            Map<string, Id>permissionSetIdLabelMap = new Map<string, Id>();
            Map<string, string> permissionSetPicklistMap = new map<string, string>{'RCO-ANCS'=>'RCO_ANCS', 'RCO-Application Admin'=>'RCO_Application_Admin', 'RCO-Clinical Advisor'=>'RCO_Clinical_Advisor', 'RCO-Rebate Forecast'=>'RCO_Rebate_Forecast', 'RCO-Sales'=>'RCO_Sales', 'RCO-Triage'=>'RCO_Triage', 'RCO-Underwriter'=>'RCO_Underwriter'};
            for(String str: permissionSetPicklistMap.keyset()){
                //PermissionSetIdName.put(str)
                PermissionSetnameSet.add(permissionSetPicklistMap.get(str));
            }
            List <permissionSet> permissionSetList = [select id, Name, Label from permissionSet where name in:PermissionSetnameSet];
            for(permissionSet per: permissionSetList){
                permissionSetIdLabelMap.put(per.Label, per.Id);
                PermissionSetIdSet.add(per.Id);
            }
            List<PermissionSetAssignment> assignemntList = new List<PermissionSetAssignment>();
            List<PermissionSetAssignment> assignemntDeleteList = new List<PermissionSetAssignment>();
            Set<Id> deleteUserIdSet = new Set<Id>();
            PermissionSetAssignment assignemntObj; 
            for(Id useId: userNewMap.keyset()){
                if(userNewMap.get(useId).Change_Order_Permission__c!=null){
                    assignemntObj = new PermissionSetAssignment();
                    assignemntObj.PermissionSetId = permissionSetIdLabelMap.get(userNewMap.get(useId).Change_Order_Permission__c);
                    assignemntObj.AssigneeId = useId;
                    assignemntList.add(assignemntObj); 
                }
                deleteUserIdSet.add(useId);
            }
            List<PermissionSetAssignment> prmSetAssgnmtDelList = [SELECT Id, AssigneeId,PermissionSetId FROM PermissionSetAssignment where AssigneeId in: deleteUserIdSet and PermissionSetId in: PermissionSetIdSet];
            system.debug(prmSetAssgnmtDelList +'Sindhu');
            if(!prmSetAssgnmtDelList.isEmpty()){
                delete prmSetAssgnmtDelList;
            }
            if(!assignemntList.isEmpty()){
                insert assignemntList;
            } 
        }
        catch(Exception excp){  
            system.debug('=========excp======'+excp);
        }
    }
 // Soumendu - 02/27 - Method to remove License/Package License for Inactive users  
   public static void removeInactiveLicenses(List<User>userList) {
   try
    {
    List<id> inactives =new List<id>();
    for(User record: userList) {
        if(record.IsActive == false) {
            inactives.add(record.Id);
        }
    }
    if(!inactives.isEmpty()) {
        delete [SELECT Id FROM PermissionSetAssignment WHERE AssigneeId IN :inactives and PermissionSetId IN (SELECT Id 
                                                      FROM PermissionSet
                                                     WHERE IsOwnedByProfile =false)];
        delete [SELECT Id FROM PermissionSetLicenseAssign WHERE AssigneeId IN :inactives];
        delete [SELECT Id FROM UserPackageLicense WHERE UserId IN :inactives];
    }
    }
    catch(Exception excp){  
            system.debug('=========excp======'+excp);
        }
}  
    
}