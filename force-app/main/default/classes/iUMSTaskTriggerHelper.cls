Global with sharing class iUMSTaskTriggerHelper {
@future
 public static void Permissionsetaddition(String Status) {
     try
     {
     List<PermissionSetAssignment> permissionSetList = new List<PermissionSetAssignment>();
      if (Status == 'Ready to Load')
      {
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
  public static void Permissionsetremoval(String Status) {
     try
     {
      if (Status == 'Complete' || Status == 'Error')
      {
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