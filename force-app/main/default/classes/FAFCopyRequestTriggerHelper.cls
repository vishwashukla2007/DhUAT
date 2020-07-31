Global with sharing class FAFCopyRequestTriggerHelper {
@future
 public static void Permissionsetaddition(String FAFStatus) {
     try
     {
     List<PermissionSetAssignment> permissionSetList = new List<PermissionSetAssignment>();
      if (FAFStatus == 'In Progress')
      {
      DeepCloneUtility.OFF_TRIGGERS_PROCBUILDER=false;
  //  DeepCloneUtility.OFF_INVOCABLE_CLASS = false;
      String PermissionSetId = Label.iUMS_Permission_Set_ID;
      String userId = UserInfo.getUserId();
      If (PermissionSetId != null && userId != null)
      {
        PermissionSetAssignment psa = new PermissionSetAssignment(PermissionSetId = PermissionSetId, AssigneeId = userId );
        permissionSetList.add(psa);
      }
      }
      if (!permissionSetList.IsEmpty())
      {
        insert permissionSetList;  
      } 
     }
     catch(DmlException e)
      {
      System.debug('The following exception has occurred: ' + e.getMessage());
      }  
    }  
  @future
  public static void Permissionsetremoval(String FAFStatus) {
     try
     {
      if (FAFStatus == 'Completed' || FAFStatus == 'Error')
      {
      DeepCloneUtility.OFF_TRIGGERS_PROCBUILDER=true;
 //   DeepCloneUtility.OFF_INVOCABLE_CLASS = true;   
      string userId = UserInfo.getUserId();
      string permSetId = Label.iUMS_Permission_Set_ID;
        If (permSetId != null && userId != null){
            delete [SELECT Id from PermissionSetAssignment WHERE PermissionSetId = : permSetId AND AssigneeId = : userId];

        } 
        }
        }
     catch(DmlException e)
      {
      System.debug('The following exception has occurred: ' + e.getMessage());
      }                                       
}    
      
                               
}