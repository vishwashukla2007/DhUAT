global without sharing class createAgreementExt {
	@InvocableMethod
    public static list<list<PBS_Agreement_Extension__c>> createAgreeExt(list<list<string>> collectionFields) {
         
        //Create ApexFlow return outputVar
        list<list<PBS_Agreement_Extension__c>> collectAgreeExOutputVar= new list<list<PBS_Agreement_Extension__c>>();
            
        //Extract collectionFields
        list<string> processFields = new list<string>();
        processFields = collectionFields[0];
        
        //get all not empty field
        map<string,string> notEmpField_map = new map<string,string>();
        for(string notemptFields : processFields){
            List<String> res = notemptFields.split('-', 2);
            if(res[1] != 'Empty'){
                notEmpField_map.put(res[0],res[1]);
            }
        }

        list<PBS_Agreement_Extension__c> agreeEx_list = new list<PBS_Agreement_Extension__c>();
        PBS_Agreement_Extension__c createAgEx = new PBS_Agreement_Extension__c();
        for (String fieldName : notEmpField_map.keySet()){
            if(notEmpField_map.get(fieldName) != null && notEmpField_map.get(fieldName) != ''){
                if(fieldName == 'Contract_Effective_Date__c' || fieldName == 'Contract_End_Date__c' || fieldName == 'Master_Client_Name__c'){
                    //Update Agreement Object
                }else{
                    SObjectType r = ((SObject)(Type.forName('Schema.'+'PBS_Agreement_Extension__c').newInstance())).getSObjectType();
                    DescribeSObjectResult d = r.getDescribe();
                    String fDataType = string.valueOf(d.fields.getMap().get(fieldName).getDescribe().getType());
                    if(fDataType == 'DATE'){
                        date vardate = date.valueOf(notEmpField_map.get(fieldName));
                        createAgEx.put(fieldName, vardate);
                    }else if (fDataType == 'BOOLEAN') {
                        boolean varBool = Boolean.valueOf(notEmpField_map.get(fieldName));
                        createAgEx.put(fieldName, varBool);
                    }else if (fDataType == 'PERCENT'){  
                        Decimal varDecimal = Decimal.valueOf(notEmpField_map.get(fieldName));
                        createAgEx.put(fieldName, varDecimal);
                    }else{
                        createAgEx.put(fieldName, notEmpField_map.get(fieldName));   
                    }
                }
            }
            
        }
        insert createAgEx;
        agreeEx_list.add(createAgEx);
		collectAgreeExOutputVar.add(agreeEx_list);
        system.debug(collectAgreeExOutputVar);
        return collectAgreeExOutputVar;
   }
}