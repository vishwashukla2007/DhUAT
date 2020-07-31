/*=================================================================================
         * @Method Name       : FieldHistoryTracking
         * @author            : Soumendu Chowdhury
         * @created date      : 03/25/2020
         * @Purpose           : Capture History Tracking for Object Fields
         * @Test Class        : TransactionFeeSharingTriggerHandlerTest
======================================================================================= */
public with sharing class SObjectFieldHistoryTracking {   
  public static datetime TransDate;
  Public static void FieldHistoryTracking(List<SObject> NewMapList,Map<Id,SObject> OldMap, String Objname, String FAFFieldName, String ObjLabel)
    {  
    Map<Integer, list<string>> fieldlist =new Map< Integer,list<string>>();
    SObjectType objType = Schema.getGlobalDescribe().get(Objname);
    Map<String, Schema.FieldSet> FsMap = objType.getDescribe().FieldSets.getMap();
    final List<Schema.FieldSetMember> trackedFields = objType.getDescribe().FieldSets.getMap().get('HistoryTracking').getFields();
    
       
    String UserName = UserInfo.getUserId();
    //tracking transaction datetime to avoid duplicate logs
    if(TransDate==null){
        TransDate=system.now();
    }
    
    if (trackedFields.isEmpty()) return;

    final List<TransactionLogsC__c> fieldChanges = new List<TransactionLogsC__c>();
    Integer i = 0;
    for (SObject newValues : NewMapList) 
     {
        final SObject  oldValues = OldMap.get(newValues.Id);
         
        for (Schema.FieldSetMember fsm : trackedFields) 
         {
            List<string> fieldvalue =new list<string>();
            String fieldName  = fsm.getFieldPath();
            String fieldLabel = fsm.getLabel();

            if (newValues.get(fieldName) == oldValues.get(fieldName))
                continue;

            String oldValue = String.valueOf(oldValues.get(fieldName));
            String newValue = String.valueOf(newValues.get(fieldName));
             String recordName;
            if (Objname == 'Central_Hub__c')
                 recordName = String.valueOf(newValues.get('Name'));
            else
                 recordName = String.valueOf(newValues.get('LinkHistory__c'));
            String fafid = String.valueOf(oldValues.get(FAFFieldName));
            String recordId =String.valueOf(newValues.get('Id'));
            
            

            fieldvalue.clear();
            fieldvalue.add(fafid);
            fieldvalue.add(ObjLabel);
            fieldvalue.add(fieldLabel);
            fieldvalue.add(UserName);
            fieldvalue.add(oldValue);
            fieldvalue.add(newValue);
            //fieldvalue.add(TransDate);
            fieldvalue.add(recordName);
            fieldvalue.add(recordId);
            fieldlist.put(i,fieldvalue);
            i = i +1;
        }
    }
    if (DeepCloneUtility.HistoryCheck == true && !fieldlist.isEmpty() && fieldlist != null)
     {
      InsertFieldHistoryTracking(JSON.serialize(fieldlist),TransDate);
     }
    }
      
 
 @future     
 Public static void InsertFieldHistoryTracking(String fieldlistserialized,datetime TransDate)
 {
       Map<Integer, List<String>> fieldhistory= (Map<Integer, List<String>>)JSON.deserialize(fieldlistserialized, Map<Integer, List<String>>.class);
       Map<string,TransactionLogsC__c> InsertMap=new Map<string,TransactionLogsC__c>();
    
       for (Integer key : fieldhistory.keySet()) 
       {
        final TransactionLogsC__c NPHistory = new TransactionLogsC__c();
        List<String> fieldlist= fieldhistory.get(key);
         NPHistory.FAFId__c  = fieldlist[0];
         NPHistory.FafObject__c  = fieldlist[1];
         NPHistory.Field_Name__c  = fieldlist[2];
         NPHistory.TimeStamp__c = TransDate;//System.now();
         NPHistory.UserName__c = UserInfo.getUserId();
         NPHistory.OldValue__c  = fieldlist[4];
         NPHistory.NewValue__c  = fieldlist[5];
         NPHistory.Is_Batch_Job__c = true;
         NPHistory.RecordName__c = fieldlist[6];
         NPHistory.RecordId__c  = fieldlist[7];
         //generating unique key to avoid duplicate entires
         string UniqueKey=NPHistory.FAFId__c+NPHistory.FafObject__c+ NPHistory.RecordId__c  +NPHistory.UserName__c+NPHistory.TimeStamp__c+NPHistory.Field_Name__c+NPHistory.NewValue__c+NPHistory.OldValue__c;
         if(UniqueKey.length()>255){
             UniqueKey=UniqueKey.substring(0,244);
         }
         NPHistory.UniqueKey__c=UniqueKey;
         InsertMap.put(NPHistory.UniqueKey__c,NPHistory);
         //fieldChanges.add(NPHistory);
       }
       //removing duplicate entries
       set<string> EEntries= new set<string>();
       for(TransactionLogsC__c t:[select id,UniqueKey__c from TransactionLogsC__c  where UniqueKey__c IN:InsertMap.keyset()]){
           EEntries.add(t.UniqueKey__c );
       }
       //remove existing entries form current insert map
       if(!EEntries.isEmpty()){
          for(string s:EEntries){
              if(InsertMap.containsKey(s)){
                  InsertMap.remove(s);
              }
           }
        }
           
       if (!InsertMap.isEmpty()) {
            database.insert(InsertMap.values(),false);
        }
 
 }        
      
      
    
}