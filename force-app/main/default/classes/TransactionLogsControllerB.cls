global class TransactionLogsControllerB 
{
    
    @AuraEnabled
    global static list<TransactionLogs__b> getTransactionLogs( string fafId )
    {
        system.debug('==>'+fafId);
        if( string.isNotBlank(fafId) ){
            return [ select Id,
                        Id__c,
                        FAFId__r.Name, 
                        TimeStamp__c, 
                        TransactionBy__c,
                        TransactionBy__r.Name,
                        TransactionBy__r.Profile.Name,
                        FafObject__c, 
                        TransactionDetail__c, 
                        TransactionType__c,
                        RecordName__c,
                        UserProfile__c,
                        RecordId__c
                        FROM TransactionLogs__b WHERE  FAFId__c =:fafId ];
        }
        else
        {
             return [ select Id,
                        Id__c,
                        FAFId__r.Name, 
                        TimeStamp__c, 
                        TransactionBy__c,
                        TransactionBy__r.Name,
                        TransactionBy__r.Profile.Name,
                        FafObject__c, 
                        TransactionDetail__c, 
                        TransactionType__c,
                        RecordName__c,
                        RecordId__c
                        FROM TransactionLogs__b];
        }
    }
    
    @InvocableMethod
    public static void loadBigObject( list<Id> idList )
    {
       list<TransactionLogsC__c> listCustomLogs = [ select Id,
                        Name,
                        FAFId__c, 
                        TimeStamp__c, 
                        TransactionBy__c,
                        TransactionBy__r.Name,
                        TransactionBy__r.Profile.Name,
                        FafObject__c, 
                        TransactionDetail__c, 
                        TransactionType__c,
                        RecordName__c,
                        UserProfile__c,
                        RecordId__c
                        FROM TransactionLogsC__c WHERE Id In : idList];
        
        
        if( !listCustomLogs.isEmpty() )
        {
            list<TransactionLogs__b> transLogsB = new list<TransactionLogs__b>();
           for( TransactionLogsC__c log : listCustomLogs ) 
           {
               
               transLogsB.add(
                    new TransactionLogs__b(
                            FAFId__c = log.FAFId__c,
                            Id__c = log.Name,
                            TimeStamp__c = log.TimeStamp__c,
                            TransactionBy__c = log.TransactionBy__c,
                            FafObject__c = log.FafObject__c,
                            TransactionDetail__c = log.TransactionDetail__c,
                            TransactionType__c = log.TransactionType__c,
                            RecordName__c = log.RecordName__c,
                            UserProfile__c=log.UserProfile__c,
                            RecordId__c = log.RecordId__c
                        )
                   );
                   
           }
           insertTransLogsB( JSOn.serialize(transLogsB), JSOn.serialize(listCustomLogs) );
          // System.debug(transLogsB);
        }
       
    }
    
    @future 
    
global static void insertTransLogsB( string logs, string customLogs ) 
            { 
            list<TransactionLogs__b> transLogsB = (list<TransactionLogs__b>)JSON.deserialize(logs, list<TransactionLogs__b>.class); 
            if( !test.isRunningTest() ) { 
            list<Database.SaveResult> srs = Database.insertImmediate(transLogsB); 
            system.debug('srs = ' + srs); 
            } 
            system.debug('transLogsB Big Object______'+transLogsB); 
            list<TransactionLogsC__c> listCustomLogs = (list<TransactionLogsC__c>)JSON.deserialize(customLogs, list<TransactionLogsC__c>.class); 
            //delete listCustomLogs; 
            }    

        /*global static void insertTransLogsB( string logs, string customLogs )
    {
        list<TransactionLogs__b> transLogsB = (list<TransactionLogs__b>)JSON.deserialize(logs, list<TransactionLogs__b>.class);
        if( !test.isRunningTest() )
        Database.insertImmediate(transLogsB);
        system.debug('transLogsB Big Object______'+transLogsB);
        list<TransactionLogsC__c> listCustomLogs = (list<TransactionLogsC__c>)JSON.deserialize(customLogs, list<TransactionLogsC__c>.class);
        //delete listCustomLogs;
    }
            */
}