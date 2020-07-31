global class AssignSalesPermission implements Database.batchable<sObject>{ 
   global Database.querylocator start(Database.BatchableContext BC)
          {
            String query= 'SELECT Id, Salesperson__c from Central_Hub__c where Salesperson__c != null';
            return Database.getQueryLocator(query); 
          }

   global void execute(Database.BatchableContext info, List<Central_Hub__c> scope){
       List<PermissionSetAssignment> permissionSetList = new List<PermissionSetAssignment>();
       List<PermissionSetAssignment> finalpermissionSetList = new List<PermissionSetAssignment>();
       List<PermissionSetAssignment> permissionSet = new List<PermissionSetAssignment>();
       Map<String, String> UserPermission = new Map<String, String>();
       permissionSet = [Select AssigneeId, PermissionSetId from PermissionSetAssignment where PermissionSetId = :Label.Apttus_Sales_Permissionset];
       for (PermissionSetAssignment ps : permissionSet)
       {
        UserPermission.put(ps.AssigneeId,ps.PermissionSetId);
       }
       List<User> Userlst = [select id from User where ProfileId = :Label.Sales_Profile];
       for(Central_Hub__c faf : scope)
       { 
       Boolean Salesprofile = false;
          If(faf.Salesperson__c != null)
           {
           for (User usrlst : Userlst)
           {
            if (usrlst.id == faf.Salesperson__c)
            {
             Salesprofile = true;
            }
           }
           String userId = faf.Salesperson__c;
           String PermissionSetId = Label.Apttus_Sales_Permissionset;
          If (PermissionSetId != null && userId != null && Salesprofile == true)
           {
              PermissionSetAssignment psa = new PermissionSetAssignment(PermissionSetId = PermissionSetId, AssigneeId = userId );
              permissionSetList.add(psa);
           }
          }
       } 
        for(PermissionSetAssignment pmset: permissionSetList)
            {
             Boolean exists = false;
            
               for(String ps : UserPermission.keyset())
                 {
                   String Assignee = ps;
                   String Permission = UserPermission.get(ps);
                   if (Assignee  == pmset.AssigneeId  && Permission ==pmset.PermissionSetId)
                     {
                       exists = true;
                     }
                 }
              if (exists == false)
               {
                Boolean finalexists = false;
                for(PermissionSetAssignment pm: finalpermissionSetList)
                   {
                     if (pm.AssigneeId == pmset.AssigneeId  && pm.PermissionSetId ==pmset.PermissionSetId)
                     {
                       finalexists = true;
                     }
                   }
                    if (finalexists == false)
                    {
                    finalpermissionSetList.add(pmset);
                    }
               }
            }
        if (!finalpermissionSetList.isEmpty() || finalpermissionSetList!=null)
        {
          insert finalpermissionSetList; 
        }
   }      
       global void finish(Database.BatchableContext info)
       {     
       } 
}