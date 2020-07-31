/*********************************************************************************************
 * @ClassName         : ActionfieldController 
 * @created date      : 12/09/2018
 * @Purpose           : This is the controller class to display Action field dynamically for Salesuser 
 **/

public class ActionfieldController {
    
public String clientinfoId {get; set;}
public Boolean displayAction {get; set;} 
    
public ActionfieldController(ApexPages.StandardController controller) {
    this.Actionvisible();
}

public Boolean Actionvisible()
{
this.clientinfoId = Apexpages.currentPage().getParameters().get('Id'); 
user u =[select id ,Name, profile.Id from user where id=:Userinfo.getUserId()];
if (u.profile.Id == Label.Apttus_sales_Profile || test.isRunningTest())
{
    Client_Information__c clientInfo = [select Client_Subtype__c,FAF_ID__r.Account_Name__c,FAF_ID__r.Id,FAF_ID__r.Opportunity_Name__c,FAF_ID__r.Oppty_Winner_Formula__c,FAF_ID__r.Med_D_Sales_Lead_Formula__c,FAF_ID__r.Account_Name__r.iUMS_Client_Subtype__c from Client_Information__c where id=: clientinfoId ];
    try {
     if(clientInfo.Client_Subtype__c != null){
       if(clientInfo.Client_Subtype__c == Label.Subtype_Health_Plan_Master || clientInfo.Client_Subtype__c == Label.Subtype_Coalition_Master || clientInfo.Client_Subtype__c == Label.Subtype_TPA_Master)     
           {
            if (clientInfo.FAF_ID__r.Med_D_Sales_Lead_Formula__c == u.Name || clientInfo.FAF_ID__r.Oppty_Winner_Formula__c == u.Name)
                              {
                                  displayAction=true;
                                  return displayAction;
                              }   
               
          
            List<Central_Hub__c> sales = [select Salesperson__c from Central_Hub__c where Id = :clientInfo.FAF_ID__r.Id];
            if(sales.size() > 0 )   
                       {
                             for(Central_Hub__c salesitem : sales)
                              {
                              if (salesitem.Salesperson__c == u.Id)
                              {
                                  displayAction=true;
                                  return displayAction;  
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
                  displayAction=true;
                  return displayAction; 
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
                  displayAction=true;
                  return displayAction; 
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
                  displayAction=true;
                  return displayAction; 
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
                  displayAction=true;
                  return displayAction; 
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
                  displayAction=true;
                  return displayAction; 
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
                  displayAction=true;
                  return displayAction; 
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
                  displayAction=true;
                  return displayAction; 
              }
             }  
            }
            }}             
               
            list<AccountTeamMember> atm = [SELECT AccountAccessLevel,AccountId,CaseAccessLevel,ContactAccessLevel,CreatedById,CreatedDate,TeamMemberRole,Title,UserId FROM AccountTeamMember where AccountId = :clientInfo.FAF_ID__r.Account_Name__c and
                                    UserId = :u.id];
            if(atm.size() > 0 ){
            for(AccountTeamMember atmItem : atm)
            {
                List<PlatformSpecific_Roles__mdt> psrmdt = [select Label  from PlatformSpecific_Roles__mdt where Label  = :atmItem.TeamMemberRole];
                 if(psrmdt.size() > 0 )       
                 {
                  displayAction=true;
                  return displayAction;            
                 }
                 else {displayAction=false; return displayAction;}
             }
            } 
            else 
            { 
            displayAction=false; return displayAction;  
            
            }
            
            } else { displayAction=false; return displayAction;}
       }
     else { displayAction=false; return displayAction;}  }
           catch(Exception ex){
               displayAction=false; return displayAction;}
     return displayAction;
}
else {
     displayAction=true;
     return displayAction;

     }
}

}