public class TransactionLogsCTriggerHelper{

 public static void updateUserNameOnInsert( list<TransactionLogsC__c> newlist) {
      set<id> userids=new set<id>();
     for(TransactionLogsC__c t:newlist){
         if(t.NewValue__c !=null && t.NewValue__c.startsWith('005') && (t.NewValue__c.length()==15 || t.NewValue__c.length()==18) ){
            userids.add(t.NewValue__c);
          }
          if(t.OldValue__c!=null && t.OldValue__c.startsWith('005') && (t.OldValue__c.length()==15 || t.OldValue__c.length()==18) ){
            userids.add(t.OldValue__c);
          }
        }
     
    if(!userids.isEmpty()){
         map<id,User> userMap =new map<id,user>([select id,name from user where id in:userids]);
          for(TransactionLogsC__c t:newlist){
              if(t.NewValue__c !=null && t.NewValue__c.startsWith('005') && userMap.containsKey(t.NewValue__c) && (t.NewValue__c.length()==15 || t.NewValue__c.length()==18) ){
                  t.NewValue__c=userMap.get(t.NewValue__c).name;
              }
              if(t.OldValue__c!=null && t.OldValue__c.startsWith('005') && userMap.containsKey(t.OldValue__c) && (t.OldValue__c.length()==15 || t.OldValue__c.length()==18) ){
                  t.OldValue__c=userMap.get(t.OldValue__c).name;
              } 
          }          
 
      }
  }
}