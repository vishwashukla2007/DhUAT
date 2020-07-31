/*=================================================================================
         * @Method Name       : FieldHistoryTrackingInsDelete
         * @author            : Soumendu Chowdhury
         * @created date      : 03/25/2020
         * @Purpose           : Capture History Tracking for Object Fields
         * @Test Class        : FieldHistoryTrackingTest
======================================================================================= */
public with sharing class SObjectFieldHistoryTrackingInsDelete {
   
   Public static void FieldHistoryTrackingInsDelete(List<SObject> NewMapList,Map<Id,SObject> OldMap, String Objname, String FAFFieldName, String ObjLabel, String Operation)
      {  
    Map<Integer, list<string>> fieldlist =new Map< Integer,list<string>>();  
    SObjectType objType = Schema.getGlobalDescribe().get(Objname);
    Map<String, Schema.FieldSet> FsMap = objType.getDescribe().FieldSets.getMap();      
    String UserName = UserInfo.getUserId();
    DateTime TransDate = System.now();
    final List<TransactionLogsC__c> fieldChanges = 
        new List<TransactionLogsC__c>();
    Integer i = 0;
    for (SObject newValues : NewMapList) 
     {
       List<string> fieldvalue =new list<string>();
       String fieldName  = 'FieldList__c';
       String fieldLabel = '';
       String fafid;
       String recordName;
       String oldValue;
       String newValue;
       String recordId;
       if (Operation == 'DELETE')
        {
        final SObject  oldValues = OldMap.get(newValues.Id);
         oldValue = String.valueOf(oldValues.get(fieldName));
         fafid = String.valueOf(oldValues.get(FAFFieldName));
         if (Objname == 'Central_Hub__c')
                 recordName = String.valueOf(oldValues.get('Name'));
         else
                 recordName = String.valueOf(oldValues.get('LinkHistory__c'));
         recordId =String.valueOf(oldValues.get('Id'));
        }

       if (Operation == 'INSERT')
        {
          newValue = String.valueOf(newValues.get(fieldName));
          fafid = String.valueOf(newValues.get(FAFFieldName));
            if (Objname == 'Central_Hub__c')
                 recordName = String.valueOf(newValues.get('Name'));
            else
                 recordName = String.valueOf(newValues.get('LinkHistory__c'));
                 
           recordId =String.valueOf(newValues.get('Id'));
        }
      
            if (Operation == 'INSERT')
            {
            oldValue = '';
         // newValue = '';
            fieldLabel = 'RECORD CREATED';
            }
            if (Operation == 'DELETE')
            {
            newValue = '';
            fieldLabel = 'RECORD DELETED';
            }
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
       if (DeepCloneUtility.HistoryCheck == true && !fieldlist.isEmpty() && fieldlist != null)
        {
         InsertFieldHistoryTrackingInsDelete(JSON.serialize(fieldlist));
        }
      }
      
 @future     
 Public static void InsertFieldHistoryTrackingInsDelete(String fieldlistserialized)
 {
 Map<Integer, List<String>> fieldhistory= (Map<Integer, List<String>>)JSON.deserialize(fieldlistserialized, Map<Integer, List<String>>.class);
     final List<TransactionLogsC__c> fieldChanges = 
        new List<TransactionLogsC__c>();

   for (Integer key : fieldhistory.keySet()) 
   {
    final TransactionLogsC__c NPHistory = new TransactionLogsC__c();
    List<String> fieldlist= fieldhistory.get(key);
     NPHistory.FAFId__c  = fieldlist[0];
     NPHistory.FafObject__c  = fieldlist[1];
     NPHistory.Field_Name__c  = fieldlist[2];
     NPHistory.TimeStamp__c = System.now();
     NPHistory.UserName__c = UserInfo.getUserId();
     NPHistory.OldValue__c  = fieldlist[4];
     NPHistory.NewValue__c  = fieldlist[5];
     NPHistory.Is_Batch_Job__c = true;
     NPHistory.RecordName__c = fieldlist[6];
     NPHistory.RecordId__c  = fieldlist[7]; 
     fieldChanges.add(NPHistory);
   }
       
   if (!fieldChanges.isEmpty()) 
   {
        insert fieldChanges;
    }
 
 }        
 
}