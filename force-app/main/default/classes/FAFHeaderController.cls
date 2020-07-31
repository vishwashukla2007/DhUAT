/*
    Author: Kiranmai
    Description: 
*/
public class FAFHeaderController 
{
    public string fafId {get;set;}
    public string objectType {get;set;}
    public list<string[]> fieldList{get;set;}
    //public string[] fields{get;set;}
    
    public Central_Hub__c getFAF()
    {
        string[] fields = new string[]{};
        fieldList = new list<list<string>>();
        list<Schema.FieldSetMember> fldMemberList = string.isNotBlank(objectType) && objectType == 'Client_Information__c' ?
                                                    sObjectType.Central_Hub__c.fieldSets.FAF_Header_Client_Information.getFields():
                                                    sObjectType.Central_Hub__c.fieldSets.FAFHeader.getFields();
        for( Schema.FieldSetMember f : fldMemberList )
        {
            fields.add( f.getFieldPath() );
        }
        
        string[] tempFlds = new string[]{};
        integer modVal = 4;
        for( integer i=1; i <= fields.size() ; i++  )
        {
            if( math.mod(i, modVal) == 0 )
            {
                tempFlds.add(fields[i-1]);
                //string[] lst = new string[]{};
                //lst.addAll(tempFlds);
                fieldList.add( tempFlds );
                tempFlds = new string[]{};
            }
            else
            {
                tempFlds.add(fields[i-1]);
            }
        }
        
        if( !tempFlds.isEmpty() )
        {
            fieldList.add(tempFlds);
        }
        
        fields.add('createddate');
        fields.add('lastmodifieddate');
        
        set<string> fieldSet = new set<string>(fields);
        fieldSet.remove('Id');
        
        string temp = fieldSet.isEmpty()?'':',';
        string query = 'SELECT Id '+temp+string.join(new list<string>(fieldSet),',')+' FROM Central_Hub__c WHERE Id = \''+fafId+'\'';
        return DataBase.Query(query);
    }
}