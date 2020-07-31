/*=================================================================================================================================
     * @Class Name          : CentralHubShareModifyTriggerHelper
     * @author              : Accenture
     * @Last modified by    : Accenture
     * @Created date        : 12/07/2018
     * @Last modified date  : 12/10/2018
     * @Purpose             : Handle TR_CentralHubShareModify Trigger Action
 ===================================================================================================================================*/
public class CentralHubShareModifyTriggerHelper{
    
    /*=================================================================================================================================
     * @Method Name         : deleteFAFShare
     * @author              : Accenture
     * @Last modified by    : Accenture
     * @Created date        : 12/07/2018
     * @Last modified date  : 12/10/2018
     * @Purpose             : create Central_Hub_Share_Modify__c for further iteration and find those record in which userId not present in any of two field Med_D_Sales_Lead_Formula__c or Oppty_Winner_Formula__c, and delete the all Central_Hub_Share_Modify__c record with record Type Delete
    ===================================================================================================================================*/
    Public Static void deleteFAFShare(List<Central_Hub_Share_Modify__c>newList, List<Central_Hub_Share_Modify__c>oldList, Map<id, Central_Hub_Share_Modify__c>newMap, Map<id, Central_Hub_Share_Modify__c>oldMap){
        Map<id, Central_Hub_Share_Modify__c>fafShareModifyMap = new Map<id, Central_Hub_Share_Modify__c>();   // Map to store the id as the key and Central_Hub_Share_Modify__c object as the value 
        Central_Hub_Share_Modify__c cenHubShareObj;
        Set<Id>fafIdSet = new Set<Id>();   // Set to store the faf id 
        Boolean isBool = false;      
        List<Central_Hub_Share_Modify__c> cenHubShare = new List<Central_Hub_Share_Modify__c>();
        try {
            for(Central_Hub_Share_Modify__c chsm: newMap.Values()){   // iterate the Map
                isBool = false;
                cenHubShareObj = new Central_Hub_Share_Modify__c(); 
                if(ConstantsUtil.DeleteStr.equals(chsm.Record_Type__c)){
                    if(!String.isBlank(chsm.FAF__c) && !String.isBlank(chsm.User__c)){
                        //for check user name is present in Med_D_Sales_Lead_Formula__c
                        if((!string.isBlank(chsm.Med_D_Sales_Lead_Formula__c)) && (chsm.UserName__c.toUppercase().equals(chsm.Med_D_Sales_Lead_Formula__c.toUppercase()))){
                            isBool = true;
                        }
                        //for check user name is present in Oppty_Winner_Formula__c
                        if((!string.isBlank(chsm.Oppty_Winner_Formula__c)) && (chsm.UserName__c.toUppercase().equals(chsm.Oppty_Winner_Formula__c.toUppercase()))){
                            isBool = true;
                        }
                        if(!isBool){
                            fafIdSet.add(chsm.FAF__c);
                            fafShareModifyMap.put(chsm.id, chsm);
                        }
                    }
                    cenHubShareObj.id = chsm.id;
                    cenHubShare.add(cenHubShareObj);
                }
            }
            if(!fafIdSet.isEmpty()){
                fafShareDelMethod(fafIdSet, fafShareModifyMap);
            }
            if(!cenHubShare.isEmpty()){
                delete cenHubShare;
            }
        }catch(Exception e){
            Trigger.new[0].addError(e.getMessage());   
        }
    }
    
    /*======================================================================================================================================
     * @Method Name         : fafShareDelMethod
     * @author              : Accenture
     * @Last modified by    : Accenture
     * @Created date        : 12/07/2018
     * @Last modified date  : 12/10/2018
     * @Purpose             : iterate Faf share and delete those record which Faf Id and UserId combination is present in Central_Hub_Share_Modify__c record
    =======================================================================================================================================*/
    Public Static void fafShareDelMethod(Set<id>fafIdSet, Map<id, Central_Hub_Share_Modify__c>fafShareModifyMap){
        try{
            List<Central_Hub__Share> delFafShareRec = new List<Central_Hub__Share>();
            // Iterate on Faf share record
            for(central_hub__share chs: ([select id, UserOrGroupId, ParentId, RowCause from central_Hub__share where ParentId in :fafIdSet and RowCause = 'Manual'])){
                for(Central_Hub_Share_Modify__c chsm: fafShareModifyMap.values()){
                    if(chsm.User__c.equals(chs.UserOrGroupId) && chsm.Faf__c.equals(chs.ParentId)){ // check faf id and user id combination present in Faf share or not
                        delFafShareRec.add(chs);
                        break;
                    }
                }
            }
            if(!delFafShareRec.isEmpty()){  // check list is empty or not
                delete delFafShareRec;
            }
        }catch(Exception e){
            Trigger.new[0].addError(e.getMessage());   
        }
        
    }
}