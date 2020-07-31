public class FilesHistoryTracking{
    
    public static Map<String, Schema.SObjectType> schemaMap=new Map<String, Schema.SObjectType>();
    //method to return objet label when we pass object API name
    public static string getObjectLabel(string sObjectApiname){
        if(schemaMap.isEmpty()){
            schemaMap=Schema.getGlobalDescribe();
        }
        return schemaMap.get(sObjectApiname).getDescribe().getLabel();
    }
    
    //method to log history when user upload files/notes on faf and ralted object
    public static void InsertFileHistory(list<ContentDocumentLink> newlist,string action){
        //get file info
        set<id> cdIds=new set<id>();
        for(contentdocumentlink cdl:newlist){
            cdIds.add(cdl.contentdocumentid);
        }
        //populate hisotry by fectching corresponding FAF ID.
        if(!cdIds.isEmpty()){
            map<id,contentdocument> cdMap=new map<id,contentdocument>([select id,title,filetype from contentdocument where id IN:cdIds]);
            list<TransactionLogsC__c> insetlist=new list<TransactionLogsC__c>();
            for(contentdocumentlink cdl:newlist){
                if(cdl.linkedentityId!=null && cdMap.containsKey(cdl.contentDocumentId)){
                     String sObjName = cdl.LinkedEntityId.getSObjectType().getDescribe().getName();
                     FileHistoryHelper__c fh=FileHistoryHelper__c.getInstance(sObjName);
                     if(fh!=null){
                         string query;
                         if(sObjName=='Central_Hub__c'){
                             query='select id,name from '+sObjName+' where id ='+'\''+cdl.LinkedEntityId+'\'';
                         }
                         else{
                             query='select id,name,'+fh.FAF_Field_API_Name__c+' from '+sObjName+' where id ='+'\''+cdl.LinkedEntityId+'\'';
                         }
                         sObject s = Database.query(query);
                            TransactionLogsC__c t=new TransactionLogsC__c();
                            t.UserName__c=userinfo.getUserId();
                            t.RecordId__c=String.valueOf(s.get('id'));
                            t.TimeStamp__c=system.now();
                            t.RecordName__c=string.valueOf(s.get('name'));
                            t.FafObject__c=getObjectLabel(sObjName);
                            string FAFId= string.valueOf(s.get(fh.FAF_Field_API_Name__c));
                            t.FAFId__c=FAFId;
                            t.TransactionBy__c=userinfo.getUserid();
                            t.Field_Name__c=cdMap.get(cdl.contentDocumentId).FileType=='SNOTE'?'NOTE '+action:'FILE '+action;
                            t.NewValue__c=cdMap.get(cdl.contentDocumentId).Title; //+' ( File/Note Id: '+cdl.contentDocumentId +' )';
                            t.Is_Batch_Job__c=true;
                            insetlist.add(t);
                     }
                    
                }
            }
            if(!insetlist.isEmpty())
                insert insetlist;
            
        }
    }
    
    //method to log attachment uploads
     public static void InsertAttachmentHistory(list<attachment> newlist,string action){
        
        //populate hisotry by fectching corresponding FAF ID.
            list<TransactionLogsC__c> insetlist=new list<TransactionLogsC__c>();
            for(attachment a:newlist){
                if(a.parentId!=null){
                     String sObjName = a.parentid.getSObjectType().getDescribe().getName();
                     FileHistoryHelper__c fh=FileHistoryHelper__c.getInstance(sObjName);
                     if(fh!=null){
                         string query;
                         if(sObjName=='Central_Hub__c'){
                             query='select id,name from '+sObjName+' where id ='+'\''+a.parentid+'\'';
                         }
                         else{
                             query='select id,name,'+fh.FAF_Field_API_Name__c+' from '+sObjName+' where id ='+'\''+a.parentid+'\'';
                         }
                            sObject s = Database.query(query);
                            TransactionLogsC__c t=new TransactionLogsC__c();
                            t.UserName__c=userinfo.getUserId();
                            t.RecordId__c=String.valueOf(s.get('id'));
                            t.TimeStamp__c=system.now();
                            t.RecordName__c=string.valueOf(s.get('name'));
                            t.FafObject__c=getObjectLabel(sObjName);
                            string FAFId= string.valueOf(s.get(fh.FAF_Field_API_Name__c));
                            t.FAFId__c=FAFId;
                            t.TransactionBy__c=userinfo.getUserid();
                            t.Field_Name__c='ATTACHMENT '+action;
                            t.NewValue__c=a.name; //+' ( Attachment Id: '+a.id+' )';
                            t.Is_Batch_Job__c=true;
                            insetlist.add(t);
                     }
                }
            }
            if(!insetlist.isEmpty())
                insert insetlist;
            
    }
}