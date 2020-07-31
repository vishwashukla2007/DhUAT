/* ================================================
 * @Trigger Name      : TR_User_PubliGrpAssignment
 * @author            : Abhishek Tiwari(Accenture)
 * @created date      : 16/07/2018
 * @Last modified by  : Abhishek Tiwari(Accenture)
 * @Last modified date: 25/07/2018
 * @Purpose           : Trigger for User
 * @ 10/12/2018 - Change - Add Permissionset to Operation user. During new Ops User Creation and Update, Ops User permission
 * set will be assigned. New addUserTOPermissionSetInsert and addUserTOPermissionSetUpdate method added in the trigger
================================================*/
trigger TR_User_PubliGrpAssignment on User(before insert, after insert, before update, after update, before delete, after delete, after undelete){
List<SwitchValidation__mdt> switchValidationList = new List<SwitchValidation__mdt>();
    Boolean isRun = false;
    switchValidationList = [SELECT id, Enable_Trigger__c, DeveloperName FROM SwitchValidation__mdt];
    for (SwitchValidation__mdt sv : switchValidationList) {
        if(sv.DeveloperName == 'User' && sv.Enable_Trigger__c){
            isRun = true;
            break;
        }
    }
    if(isRun){
        if(Trigger.isUpdate && Trigger.isBefore)
        {       

        }
    
        if(Trigger.isInsert && Trigger.isAfter ){
        //Method called on insert of the User record to Insert the public group Assignment
            UserTriggerHelper.updatePublicGrpOnInsert(Trigger.New, Trigger.isInsert, Trigger.isUpdate, Trigger.oldMap, Trigger.newMap);
            
        //Method will use to add user to Permission set based on custom setting dynamically added by Preetham
           UserTriggerHelper.addUserTOPermissionSetInsert(Trigger.New);
           UserTriggerHelper.updatePSOnInsert(Trigger.New, Trigger.isInsert, Trigger.isUpdate, Trigger.oldMap, Trigger.newMap);
        }
     
        if(Trigger.ISUpdate && Trigger.ISAfter ){
        //Method called on UPdate of the User record to modify the public group Assignment 
            UserTriggerHelper.updatePublicGrpOnUpdate(Trigger.New, Trigger.isInsert, Trigger.isUpdate, Trigger.oldMap, Trigger.newMap);
            
            //Method will use to add user to Permission set based on custom setting dynamically added by Preetham
            UserTriggerHelper.addUserTOPermissionSetUpdate(Trigger.New,Trigger.oldMap);
            UserTriggerHelper.updatePSOnUpdate(Trigger.New, Trigger.isInsert, Trigger.isUpdate, Trigger.oldMap, Trigger.newMap);
            UserTriggerHelper.removeInactiveLicenses(Trigger.New); // Remove Licenses for Inactive Users
        }   
    }
}