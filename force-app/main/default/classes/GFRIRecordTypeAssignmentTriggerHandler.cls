public class GFRIRecordTypeAssignmentTriggerHandler {
    
    //It contain all trigger events and called from trigger --Enhancement task #876390 start
    public static void handleTriggerEvents()
    {  
        if(trigger.isBefore)  {
            if(trigger.isInsert) { 
              //  assingGFRIRecordType((Map<id,case>)trigger.newMap,null,true);
            }
            else if(trigger.isUpdate){
                assingGFRIRecordType((Map<id,case>)trigger.newMap,(Map<id,case>)trigger.Oldmap,false);
            }
        }  
    }
	
    //Enhancement task #876390 end
    public static void assingGFRIRecordType( Map<id,Case> newMap,Map<id,Case> oldMap,boolean isInsert) 
	{
		try{
			
			Set<Id> ownerIds = new Set<id>();
			for(Case cs: newMap.values())
			{
				if(isInsert || !cs.ownerId.equals(Oldmap.get(cs.id).ownerid) )
				{
					ownerIds.add(cs.ownerid);
				}
			}
            system.debug('ownerIds>>'+ownerIds);
			
			/*List<GroupMember> groupMemberRecords = [Select Group.Name,Group.Type,UserOrGroupId from GroupMember 
											  		where UserOrGroupId IN :ownerIds limit 10000];
			
            system.debug('groupMemberRecords>>'+groupMemberRecords);
			Map<string,Id> OwnerIdMapWithRecordType = New Map<string,id>();	
            
            if(groupMemberRecords.isEmpty()){
                list<group> QueueList = [select Id,Name from Group where  Type = 'Queue' AND id IN :ownerIds];
                
                if(!QueueList.isEmpty())
                {
                    for(group gr :QueueList)
                    {
                        if(gfrCOSetting.containsKey(gr.Name))  
                        {
                            OwnerIdMapWithRecordType.put(gr.Id,getRecTypeId(gfrCOSetting.get(gr.Name).Record__c));
                        }
                    }
                }
            }
            else{
                for(GroupMember gm :groupMemberRecords)
                {
                    if(gfrCOSetting.containsKey(gm.group.Name))
                    {
                        OwnerIdMapWithRecordType.put(gm.UserOrGroupId,getRecTypeId(gfrCOSetting.get(gm.group.Name).Record__c));
                    }
                }
            }*/
            Map<string,id> OwnerIdMapWithRecordType = getUserWithRecordType(ownerIds);
            system.debug('OwnerIdMapWithRecordType>>'+OwnerIdMapWithRecordType);
            
			if(!OwnerIdMapWithRecordType.keyset().isEmpty())
			{
				for(Case cs: newMap.values())
				{
					cs.RecordTypeId = OwnerIdMapWithRecordType.get(cs.ownerid);
                    system.debug('cs.RecordTypeId >>'+cs.RecordTypeId);
				}
			}
		}
		catch(exception e){
			system.debug('Error Message>'+e.getMessage()+'Error LineNumber>'+e.getLineNumber());
		}
	}
	public static id getRecTypeId(string recordTypeName){
        string recTypeName = Schema.SObjectType.Case.getRecordTypeInfosByName().get(recordTypeName).getRecordTypeId();
        system.debug('recTypeName>'+recTypeName);
        return recTypeName;		
	}
    Public static Map<string,id> getUserWithRecordType(set<id> ownerIds)
    {
        Map<string,GFRI_Change_Order__c> gfrCOSetting  =  GFRI_Change_Order__c.getAll();
        system.debug('gfrCOSetting>>'+gfrCOSetting);
        
       List<GroupMember> groupMemberRecords = getuserGroup(ownerIds, 'Regular');/*[Select Group.Name,Group.Type,UserOrGroupId from GroupMember 
											  		where UserOrGroupId IN :ownerIds limit 10000];*/
			
            system.debug('groupMemberRecords>>'+groupMemberRecords);
			Map<string,Id> OwnerIdMapWithRecordType = New Map<string,id>();	
            
            if(groupMemberRecords.isEmpty()){
                list<group> QueueList = [select Id,Name from Group where  Type = 'Queue' AND id IN :ownerIds];
                
                if(!QueueList.isEmpty())
                {
                    for(group gr :QueueList)
                    {
                        if(gfrCOSetting.containsKey(gr.Name))  
                        {
                            OwnerIdMapWithRecordType.put(gr.Id,getRecTypeId(gfrCOSetting.get(gr.Name).Record__c));
                        }
                    }
                }
            }
            else{
                for(GroupMember gm :groupMemberRecords)
                {
                    if(gfrCOSetting.containsKey(gm.group.Name))
                    {
                        OwnerIdMapWithRecordType.put(gm.UserOrGroupId,getRecTypeId(gfrCOSetting.get(gm.group.Name).Record__c));
                    }
                }
            }
        return OwnerIdMapWithRecordType;        
    }
    public static list<groupmember> getuserGroup(set<id> ownerIds, String groupType){
        return    [Select Group.Name,Group.Type,UserOrGroupId from GroupMember 
                   where UserOrGroupId IN :ownerIds AND group.type=:groupType limit 10000];
    }
}