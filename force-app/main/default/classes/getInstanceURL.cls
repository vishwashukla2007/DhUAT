/*=================================================================================================================================
     * @Class Name       : getInstanceURL
     * @author            : John Paul Revilla
     * @Last modified by  : John Paul Revilla
     * @Last modified date: 04/07/2020
     * @Purpose           : Helper Class to get Instance URL and Check Object Type
    ==================================================================================================================================*/
public without sharing class getInstanceURL {
    //modified by John Paul Revilla 04/08/2020 for US41710
    //Gets the instance URL of the environment and returns it. Being used in AgreementHierarchyByAccount Aura Application
    //Param: None
    //return: string instanceURLString
    @AuraEnabled
    public static string getInstanceURL(){
        Organization instance = [select InstanceName from Organization limit 1];
        string instanceURLString = URL.getSalesforceBaseUrl().toExternalForm() + '.'+ instance.InstanceName;
        return instanceURLString;
    }

    //modified by John Paul Revilla 04/15/2020 for US39823  
    //checks from which object type the ID came from and returns it. Being used in 	viewAgreementHierarcyByAccount flow
    //Parameter List<string> RecordIdList
    //return: string List<string> objList
    @InvocableMethod
    public static List<String> checkObjectType(list<string> recordIdList){
        string objType = '';
        for(Id recId : recordIdList){
             objType = string.valueOf(recId.getsobjecttype());
             break;
        }
        list<string> objList = new list<string>();
        objList.add(objType);
        return objList;
    }
}