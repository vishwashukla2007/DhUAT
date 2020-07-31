global class getQuestion {
    @InvocableMethod
    public static list<list<PBM_Questions__c>> getQuest(list<list<string>> collectionFields) {
        
        
        //Create ApexFlow return outputVar
        list<list<PBM_Questions__c>> collectQuestOutputVar= new list<list<PBM_Questions__c>>();
        
        
        //Extract collectionFields
        list<string> processFields = new list<string>();
        processFields = collectionFields[0];
        
        //get all empty field
        list<string> outEmpField = new list<string>();
        for(string emptFields : processFields){
            List<String> res = emptFields.split('-', 2);
            if(res[1] == 'Empty'){
                outEmpField.add(res[0]);
                system.debug(res);
            }
        }
       
        if(outEmpField.size() > 0){
            list<PBM_Questions__c> listQuest = [SELECT Sort_Order__c,Question__c, Field_API__c, Section_Header__c, Object_API__c, Disabled__c, Required__c FROM PBM_Questions__c 
                                                WHERE Field_API__c IN : outEmpField 
                                                AND Active__c = True AND Required__c = false ORDER BY Sort_Order__c ASC ];
            if(listQuest.size() > 0){
                collectQuestOutputVar.add(listQuest);
            }
        }
        
        
        system.debug(collectQuestOutputVar);
       
 
       return collectQuestOutputVar;
       
   }
}