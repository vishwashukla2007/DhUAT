/*
Created By  : Anudeep Dale
Purpose     : 

The class will do the following

1.  Read the Queue_List__c field
2.  Parse #1 based on comma delimited list
3.  For each element in #2
a.  Read the SFDC Queue Members for the Queue and obtain eMail address
b.  Update the Queue_Users__c field (delimit each with comma)
*/

Global class QueueListExtractor {
    
    @InvocableMethod
    public static void extractor(List<Id> ApprovalRequestIds) {         
        
        Set<String> QueueList = new Set<String>();
        
        for (Apttus_Approval__Approval_Request__c aar : [Select id,Queue_List__c from Apttus_Approval__Approval_Request__c 
                                                        where id IN :ApprovalRequestIds]) {
                
            if (aar.Queue_List__c != null) {
                System.debug('::Inside If::');  
                for (String Queues : aar.Queue_List__c.split(',')) {
                    String toTrimmed = Queues.trim();
                    if (toTrimmed.length() > 0) 
                    QueueList.add(toTrimmed);
// Add Debug statement - QueueList
  System.debug('**QueueList*****'+ QueueList + aar.id  );  
                }   
            }
        }
        
        if(QueueList.size()>0){
            
            Set<Id> groupId = new Set<Id>();
            for(Group q : [Select Id from Group where type = 'Queue' AND  Name In : QueueList]){
                groupId.add(q.id);
// Add Debug statement - groupId       
  System.debug('**QueueList Group*****'+ groupId ); 
            }
            if(groupId.size()>0){               
                Set<Id> userids = new Set<Id>();
                for(GroupMember gm : [Select UserOrGroupId From GroupMember where GroupId In : groupId]){
                    userids.add(gm.UserOrGroupId);
// Add Debug statement - userids           
System.debug('**QueueList user*****'+ userids ); 
                }
                
                if(userids.size()>0){
                    
                    List<String> userEmailids = new List<String>();
                    for(User u : [Select email from user where FAF_Release_Email_Opt_Out__c <> TRUE AND id IN :userids ]){
                        userEmailids.add(u.email);
// Add Debug statement  userEmailids              
System.debug('**QueueList userEmail*****'+ userEmailids ); 
                    }
                    if(userEmailids.size()>0){
                        
                        List<Apttus_Approval__Approval_Request__c> aarList = new List<Apttus_Approval__Approval_Request__c>();
                        
                        for(Apttus_Approval__Approval_Request__c aar : [Select id,Queue_Users__c,Queue_List__c from Apttus_Approval__Approval_Request__c 
                                                        where id IN :ApprovalRequestIds]){
                            if(aar.Queue_List__c != null){
                                //userEmailids.remove(null);
                                string allstring = string.join(userEmailids,',');                                                              
                                aar.Queue_Users__c = allstring;
//                                aar.Send_Email_CC_Address_Long__c = allstring;
                                aarList.add(aar);
                                System.debug('**QueueList allstring*****'+ allstring ); 
                                System.debug('**QueueList aarList*****'+ aarList ); 
                            }                           
                        }
                        if(aarList.size()>0){
                            update aarList;
                        }
                    }
                }
            }
        }
    }
}