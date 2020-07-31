public class ClientInfoEditButton {
    
    @AuraEnabled
    public static void createapproval(String clientInfoRecId)
      {  
      user u =[select id ,Name, profile.Id from user where id=:Userinfo.getUserId()];
      Client_Information__c clientInfo = [select Client_Subtype__c,FAF_ID__c,FAF_ID__r.Id  from Client_Information__c where id=: clientInfoRecId];
      if (clientInfo.Id != null && u.Id != null)
      {
      List<Apttus_Approval__Approval_Request__c> appreqlist = new List<Apttus_Approval__Approval_Request__c>();
      Apttus_Approval__Approval_Request__c appreq = new Apttus_Approval__Approval_Request__c();
          appreq.Apttus_Approval__Initial_Submitter__c = u.Id;
          appreq.Queue_List__c = 'FAF MChoice Contract';
          appreq.Related_FAF__c = clientInfo.FAF_ID__c; 
          appreq.Apttus_Approval__StepLabel__c = 'MChoice LOA';
          appreq.Apttus_Approval__Step_Name__c = 'MChoice LOA';
          appreqlist.add(appreq);
          insert appreqlist;
      }      
      }
    
//*** providing the access of new, edit and delete for  Platform Specifics  to the salesuser, if salesuser 
    //*** added to the permission set  E_Apttus_Sales 
    @AuraEnabled
    public static String getAccessForSalesUser1()
      {        
        String val='2';
        user u =[select id ,profile.Id from user where id=:Userinfo.getUserId()];
        system.debug('access' + u.profile.Id);
        if(u.profile.Id==Label.Apttus_sales_Profile || test.isRunningTest()){
            try{
            system.debug('accessss' + u.profile.Id);
            val='0';
            Permissionset ps= [select id,Name from permissionset where Id =:Label.Apttus_Sales_Permissionset];
            system.debug('access' + ps.Name);
            if(ps.Name !=null){
              PermissionSetAssignment psa=[select id ,PermissionSet.Name,PermissionSet.Id,AssigneeId  from PermissionSetAssignment where permissionset.id=:ps.id and AssigneeId=:Userinfo.getUserId()];
                if(psa.PermissionSet.Name !=null){
                    system.debug('access' + psa.PermissionSet.Name);
                    val='1';
                }else{
                     val='0';
                } 
            }
            }catch(Exception ex){
               val='0';
            }
       }
      if(u.profile.Id==Label.Apttus_Operations_Profile_Id){
          val='0';
      }
       return val;
    }
    
 
//lightning controller logic to get Account Subtype
 @AuraEnabled
    public static String getAccountSubtype1(String fafId)
    {
    String val='0';

    user u =[select id ,Name, profile.Id from user where id=:Userinfo.getUserId()];
    Client_Information__c clientInfo = [select Client_Subtype__c,FAF_ID__r.Account_Name__c,FAF_ID__r.Id,FAF_ID__r.Opportunity_Name__c,FAF_ID__r.Oppty_Winner_Formula__c,FAF_ID__r.Med_D_Sales_Lead_Formula__c,FAF_ID__r.Account_Name__r.iUMS_Client_Subtype__c from Client_Information__c where FAF_ID__c=: fafId];
    try {
   /*  if(clientInfo.Client_Subtype__c != null){
       if(clientInfo.Client_Subtype__c == Label.Subtype_Health_Plan_Master || clientInfo.Client_Subtype__c == Label.Subtype_Coalition_Master || clientInfo.Client_Subtype__c == Label.Subtype_TPA_Master)     
           {
            if (clientInfo.FAF_ID__r.Med_D_Sales_Lead_Formula__c == u.Name || clientInfo.FAF_ID__r.Oppty_Winner_Formula__c == u.Name)
                              {
                                  val='1';
                                  return val;
                              }   */
               
           /*    
            Id OppId = clientInfo.FAF_ID__r.Opportunity_Name__c; 
            system.debug('============Opportunity Find=======' +OppId);
            system.debug('============Opportunity Find=======' +clientInfo.FAF_ID__r.Med_D_Sales_Lead_Formula__c);
            List<Opportunity> opp = [select Id, Med_D_Sales_Lead__c , Oppty_Winner__c from Opportunity where Id = :OppId ];
            system.debug('============Check Loop1======='+opp.size());
            if(opp.size() > 0 )   
                      {
                           system.debug('============Check Loop2=======');
                             for(Opportunity oppitem : opp)
                              {
                                  system.debug('============Med_D_Sales_Lead__c=======' +oppitem.Med_D_Sales_Lead__c);
                                  system.debug('============Med_D_Sales_Lead__c=======' +oppitem.Oppty_Winner__c);
                              if (oppitem.Med_D_Sales_Lead__c == u.Name || oppitem.Oppty_Winner__c == u.Name)
                              {
                                  val='1';
                                  return val;
                              }
                              }   
                          }   */
            List<Central_Hub__c> sales = [select Salesperson__c from Central_Hub__c where Id = :clientInfo.FAF_ID__r.Id];
            if(sales.size() > 0 )   
                       {
                             for(Central_Hub__c salesitem : sales)
                              {
                              if (salesitem.Salesperson__c == u.Id)
                              {
                                  val='1';
                                  return val;  
                              }
                              }   
                          }  
            List<User>  man1 = [Select Id from User where ManagerId = :u.Id];
            if (man1.size() > 0 )
            {
             for(User man1item : man1)
             {
              List<Central_Hub__c> salesman1 = [select Salesperson__c from Central_Hub__c where Id = :clientInfo.FAF_ID__r.Id and Salesperson__c = :man1item.Id];
              if (salesman1.size() > 0 )
              {
                  val='1';
                  return val; 
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
              List<Central_Hub__c> salesman2 = [select Salesperson__c from Central_Hub__c where Id = :clientInfo.FAF_ID__r.Id and Salesperson__c = :man2item.Id];
              if (salesman2.size() > 0 )
              {
                  val='1';
                  return val; 
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
              List<Central_Hub__c> salesman3 = [select Salesperson__c from Central_Hub__c where Id = :clientInfo.FAF_ID__r.Id and Salesperson__c = :man3item.Id];
              if (salesman3.size() > 0 )
              {
                  val='1';
                  return val; 
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
              List<Central_Hub__c> salesman4 = [select Salesperson__c from Central_Hub__c where Id = :clientInfo.FAF_ID__r.Id and Salesperson__c = :man4item.Id];
              if (salesman4.size() > 0 )
              {
                  val='1';
                  return val; 
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
              List<Central_Hub__c> salesman5 = [select Salesperson__c from Central_Hub__c where Id = :clientInfo.FAF_ID__r.Id and Salesperson__c = :man5item.Id];
              if (salesman5.size() > 0 )
              {
                  val='1';
                  return val; 
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
              List<Central_Hub__c> salesman6 = [select Salesperson__c from Central_Hub__c where Id = :clientInfo.FAF_ID__r.Id and Salesperson__c = :man6item.Id];
              if (salesman6.size() > 0 )
              {
                  val='1';
                  return val; 
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
              List<Central_Hub__c> salesman7 = [select Salesperson__c from Central_Hub__c where Id = :clientInfo.FAF_ID__r.Id and Salesperson__c = :man7item.Id];
              if (salesman7.size() > 0 )
              {
                  val='1';
                  return val; 
              }
             }  
            }
            }}             
               
        /*    list<AccountTeamMember> atm = [SELECT AccountAccessLevel,AccountId,CaseAccessLevel,ContactAccessLevel,CreatedById,CreatedDate,TeamMemberRole,Title,UserId FROM AccountTeamMember where AccountId = :clientInfo.FAF_ID__r.Account_Name__c and
                                    UserId = :u.id];
            if(atm.size() > 0 ){
            for(AccountTeamMember atmItem : atm)
            {
                List<PlatformSpecific_Roles__mdt> psrmdt = [select Label  from PlatformSpecific_Roles__mdt where Label  = :atmItem.TeamMemberRole];
                 if(psrmdt.size() > 0 )       
                 {
                  val='1';
                  return val;            
                 }
                 else {val='0'; return val;}
             }
            } 
            else 
            { 
            val='0'; return val;  
            
            }
            
            } else { val='0'; return val;}
       }
     else { val='0'; return val;}  
*/
     }
           catch(Exception ex){
               val='0'; return val;}
     return val;
    }   

}