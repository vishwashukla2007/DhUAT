public class testutil {
 public static boolean  logTransactionHistoryFlagAppReq = true;
   public static boolean logTransactionHistoryFlagClentInfo = true;
   public static boolean  logTransactionHistoryFlag = true;
   public static map<Id,AggregateResult> fafMap = new map<Id,AggregateResult>();
   
   //@future
   public static void logTransactionHistory( string newMapString, string oldMapString, string sObjectName, string fafField, 
                                        list<string> fieldsToTrack, string operation  )
    {
        TransactionLogsC__c[] logsList = new TransactionLogsC__c[]{};
        map<Id,sObject> newMap = (map<Id,sObject>)System.JSON.deserialize(newMapString, map<Id,sObject>.class);
        map<Id,sObject> oldMap = (map<Id,sObject>)System.JSON.deserialize(oldMapString, map<Id,sObject>.class);
        string profileName = [SELECT Name FROM Profile WHERE Id=:userInfo.getProfileId()].Name;

        Schema.SObjectType targetType = Schema.getGlobalDescribe().get( sObjectName );
        Map<String,Schema.SObjectField> fieldsMap = targetType.getDescribe().fields.getMap();
        string sObjectLabel = targetType.getDescribe().getLabel();
        id recid ;
        if( sObjectName == 'Platform_Specifics__c' )
        {
            
            list<Platform_Specifics__c> psList = ( operation == 'delete' ) ? oldMap.values() : newMap.values();
            set<Id> levelIdSet = new set<Id>();
            for( Platform_Specifics__c rec : psList )
            {
                levelIdSet.add( rec.Level_1_Record_ID__c);
                levelIdSet.add( rec.Level_2_record_ID__c );
                levelIdSet.add( rec.Level_3_record_ID__c );
            }
            map<Id,CAG__c> cagMap = new map<Id,CAG__c>([SELECT Id, Name, Carrier_ID__c,Group_ID__c,Account_ID__c FROM CAG__c WHERE Id IN:levelIdSet]);
            
            for( Platform_Specifics__c rec : psList )
            {
                System.debug(rec.Id);
                System.debug(oldMap);
                Platform_Specifics__c oldrec;
                if( operation == 'insert') {
                    oldrec= new Platform_Specifics__c();
                } else {
                    oldrec= oldMap.containsKey(rec.Id) ?  (Platform_Specifics__c)oldMap.get(rec.Id) : new Platform_Specifics__c();
                }
                //Platform_Specifics__c oldrec= oldMap.containsKey(rec.Id) ?  (Platform_Specifics__c)oldMap.get(rec.Id) : new Platform_Specifics__c();
                if( operation == 'insert' || operation == 'delete' || 
                (  rec.Level_1_Record_ID__c <> oldrec.Level_1_Record_ID__c  ) ||
                (  rec.Level_2_record_ID__c <> oldrec.Level_2_record_ID__c  ) ||
                (  rec.Level_3_record_ID__c <> oldrec.Level_3_record_ID__c  ) ||
                (  rec.Instruction__c <> oldrec.Instruction__c  ) ||
                (  rec.Platform__c <> oldrec.Platform__c  )  )
                {
                    //sObject oldRec = oldMap.get(rec.Id);
                    string[] levels = new string[]{};
                    for( string fld : new string[]{'Level_1_ID__c','Level_2_ID__c','Level_3_ID__c'} )
                    {
                            //if( rec.get(fld) <> null  )
                            // levels.add( cagMap.get((Id)rec.Level_1_Record_ID__c ).Carrier_ID__c );
                            //levels.add( cagMap.get((Id)rec.Level_2_record_ID__c ).Account_ID__c );
                            //levels.add( cagMap.get((Id)rec.Level_3_record_ID__c ).Group_ID__c );
                    }
                    
                    string transType = rec.Name+' '+(operation == 'insert' ? 'Add': ( operation == 'update' ? 'Update' : 'Delete' ));
                    string transDetail = rec.Instruction__c+'-'+rec.Platform__c+' '
                                        +(rec.Level_1_ID__c <> null ? rec.Level_1_ID__c:'') +' : '
                                        +(rec.Level_2_ID__c <> null ? rec.Level_2_ID__c:'') +' : '
                                        +(rec.Level_3_ID__c <> null ? rec.Level_3_ID__c:'') +'  ';
                    
                    logsList.add( new TransactionLogsC__c(
                                    FAFId__c = (Id)rec.get(fafField),
                                    TransactionBy__c= UserInfo.getUserId(),
                                    FafObject__c= sObjectLabel,
                                    TimeStamp__c = DateTime.now(),
                                    TransactionDetail__c = transDetail,
                                    TransactionType__c = transType,
                                    RecordName__c = ''+rec.get('Name'),
                                    UserProfile__c= profileName,
                                    RecordId__c = rec.Id
                                ) );
                                
                }
            }
                
        }
                if( !logsList.isEmpty() && !Test.isRunningTest() ){
            
                database.insert(logsList);
 
        }
}
}