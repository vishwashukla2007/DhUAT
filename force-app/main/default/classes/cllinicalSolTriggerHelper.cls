public class cllinicalSolTriggerHelper {
    

    public static void dulicateCheckSol(list<Clinical_Solutions__c> clinicalSolList){
        Set<Id> clinicalOpsId = new Set<ID>();
        
        for(Clinical_Solutions__c cSol :clinicalSolList){
            clinicalOpsId.add(cSol.Clinical_Operations__c);
        }
        
        List<Clinical_Solutions__c> clinicalOpsList = [Select Year__c,Clinical_Solution_Type__c,Clinical_Solution__c,Clinical_Operations__c From Clinical_Solutions__c where Clinical_Operations__c in:clinicalOpsId];
        Map<id,List<Clinical_Solutions__c>> clinicalOpsSolMap = new Map<id,List<Clinical_Solutions__c>>();
        
        if(clinicalOpsList.size()>0){
            for(Clinical_Solutions__c cSol : clinicalOpsList ){
                if(clinicalOpsSolMap.containskey(cSol.Clinical_Operations__c)){
                    List<Clinical_Solutions__c> childSolList = clinicalOpsSolMap.get(cSol.Clinical_Operations__c);
                    childSolList.add(cSol);
                    clinicalOpsSolMap.put(cSol.Clinical_Operations__c,childSolList);
                }else{
                    List<Clinical_Solutions__c> childSolList = new List<Clinical_Solutions__c>();
                    childSolList.add(cSol);
                    clinicalOpsSolMap.put(cSol.Clinical_Operations__c,childSolList);
                } 
            }              
        }
        for(Clinical_Solutions__c cSol :clinicalSolList) {
            if(clinicalOpsSolMap.containskey(cSol.Clinical_Operations__c)){
                for(Clinical_Solutions__c cSolchild: clinicalOpsSolMap.get(cSol.Clinical_Operations__c)) {
                    if(cSol.Year__c == cSolchild.Year__c  && cSol.Clinical_Solution_Type__c== cSolchild.Clinical_Solution_Type__c&& cSol.Clinical_Solution__c== cSolchild.Clinical_Solution__c){
                        cSol.addError('Clinical Solutions  record already exists for Clinical Solution Type, Year, and Clinical Solution specified');                 
                    }
                }         
            }             
        }       
        
    }
    
    //Below Method is used to check the Elections on Fee services record before detete the Clinical Solutions record.
    public static void updateElectionOnDelete(List<Clinical_Solutions__c> clinicalSolsList) {
        try{
            set<id> fafIds = new set<Id>();
            List<id> FeeServicesIds = new List<Id>();
            List<PBM_Services__c> PBMLst = new List<PBM_Services__c>();
            
            for(Clinical_Solutions__c clinicalSol: clinicalSolsList)
            {   
//                fafIds.add(clinicalSol.FAF_ID__c); 
                FeeServicesIds.add(clinicalSol.Id);          
            }
//            for(Fee_Services__c feeObj : [select id,FAF_ID__c from Fee_Services__c where FAF_ID__c IN:fafIds]){
//                FeeServicesIds.add(feeObj.Id);
//            }
            
            PBMLst = [SELECT Id,FAF_ID__c,Election__c,Clinical_Solutions__c,Sync_Source__c,DelFlag__c  FROM PBM_Services__c WHERE Clinical_Solutions__c =: FeeServicesIds AND Election__c =true];
            if(PBMLst.size()>0)
            {
                for(PBM_Services__c PBMObj : PBMLst)
                {
                    PBMObj.Election__c= false;
                    PBMObj.DelFlag__c = true;
                    PBMObj.Sync_Source__c='Target';
                    PBMObj.Clinical_Solutions__c=null;
                }
                update PBMLst;
            }
        }catch(exception e){clinicalSolsList[0].addError(e.getDmlMessage(0)); }
    }
    
    //Method used to validate PBM Services exist
    public static void validatePBMServices(List<Clinical_Solutions__c> solutionList, Boolean isInsertBool, Boolean isUpdateBool) {
        try{
            set<Id> FAFIds = new set<Id>();
            List<Fee_Services__c> feeServiceLst = new List<Fee_Services__c>();
            List<Fee_Service_Template__c> templateLst = new List<Fee_Service_Template__c>();
            for( Clinical_Solutions__c clinicalSolObj : solutionList){
                FAFIds.add(clinicalSolObj.FAF_ID__c);
            }
            feeServiceLst = [select id,PBM_Count__c from Fee_Services__c where FAF_ID__c =:FAFIds AND PBM_Count__c=0];
            if(feeServiceLst.Size()>0){
                templateLst = [select id,FAF_Component_Type__c,Item__c from Fee_Service_Template__c where Active__c = True AND FAF_Component__c = 'Clinical OPS.Clinical Solutions'];
                if(templateLst.size()>0)
                {
                    for(Clinical_Solutions__c solObj : solutionList)
                    {
                        for(Fee_Service_Template__c tempObj : templateLst)
                        {
                            if(tempObj.FAF_Component_Type__c == solObj.Clinical_Solution_Type__c && tempObj.Item__c == solObj.Clinical_Solution__c){
                                solObj.addError(ConstantsUtil.Check_PBM_Services_CS);
                            }
                        }
                        break;
                    }
                }
            }
        }catch(exception e){solutionList[0].addError(e.getDmlMessage(0)); }
    }
}