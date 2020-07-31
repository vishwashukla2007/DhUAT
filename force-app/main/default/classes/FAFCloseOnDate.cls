global class FAFCloseOnDate implements Database.Batchable<SObject>,Database.Stateful, Schedulable {
  //--------------------------------------------------------------------------
  // Database.Batchable interface
    TransactionLogsC__c[] logsList = new TransactionLogsC__c[]{};
    TransactionLogs__b [] bigLogs = new TransactionLogs__b[]{}; 
    string profileName = [SELECT Name FROM Profile WHERE Id=:userInfo.getProfileId()].Name;
 global Database.QueryLocator start(Database.BatchableContext context)
 {
    String query = 'SELECT Id, Name,FAF_Status__c, FAF_Close_On_Date__c FROM Central_Hub__c WHERE FAF_Close_On_Date__c<TODAY AND FAF_Status__c NOT IN (\'Closed\', \'Deleted\')';
    return Database.getQueryLocator(query);
  }
  
  global void execute(Database.BatchableContext context, List<sObject> scope) 
  {
      logsList.clear();
    List<Central_Hub__c> fafObjectList = (List<Central_Hub__c>) scope;
    List<Central_Hub__c> updateFAFList = new List<Central_Hub__c>();
    
    UtilClass.logTransactionHistoryFlag = false;
    UtilClass.logTransactionHistoryFlagAppReq = false;
    
    for(Central_Hub__c fafObject:fafObjectList) 
    {
        if(fafObject.FAF_Status__c =='Implemented') 
        {
            fafObject.FAF_Status__c = 'Closed';
        } 
        else if (fafObject.FAF_Status__c!='Implemented') 
        {
            fafObject.FAF_Status__c = 'Deleted';
        }
        updateFAFList.add(fafObject);
    }
    
    if(!updateFAFList.isEmpty()) 
    {
        UtilClass.logTransactionHistoryFlag = false;
        update updateFAFList;
        
        for(Central_Hub__c fafObject:updateFAFList) 
        {
            
            logsList.add( new TransactionLogsC__c(
                            FAFId__c = fafObject.Id,
                            //Id__c = fafObject.Name,
                            TransactionBy__c= UserInfo.getUserId(),
                            FafObject__c= 'FAF',
                            TimeStamp__c = DateTime.now(),
                            TransactionDetail__c = fafObject.FAF_Status__c,
                            TransactionType__c = Label.TransactionTypeStatus,
                            UserProfile__c= profileName,
                            RecordName__c = fafObject.Name,
                            RecordId__c = fafObject.Id,
                            Is_Batch_Job__c = true
                        ) );
        
            bigLogs.add( new TransactionLogs__b(
                            FAFId__c = fafObject.Id,
                            Id__c = fafObject.Name,
                            TransactionBy__c= UserInfo.getUserId(),
                            FafObject__c= 'FAF',
                            TimeStamp__c = DateTime.now(),
                            TransactionDetail__c = fafObject.FAF_Status__c,
                            TransactionType__c = Label.TransactionTypeStatus,
                            UserProfile__c= profileName,
                            RecordName__c = fafObject.Name,
                            RecordId__c = fafObject.Id
                        ) );
        }
        Database.insert(logsList);
        //DataBase.insertImmediate(bigLogs);
    }
  }
         
  global void finish(Database.BatchableContext context) {
    if( !bigLogs.isEmpty() && !Test.isRunningTest() )
    {
        Database.insertImmediate(bigLogs);
        //Database.insert(logsList);
    }
  }
  
  // Schedulable interface
  global void execute(SchedulableContext context) {
    Database.executeBatch(new FAFCloseOnDate(), 200);
  }
}