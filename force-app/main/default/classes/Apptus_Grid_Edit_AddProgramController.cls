public class Apptus_Grid_Edit_AddProgramController {
	@AuraEnabled  
    public static List<picklistWrapper> findPicklistOptions(string objAPIName, string fieldAPIname) {
        list<picklistWrapper> returnValue = new list<picklistWrapper>();
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Schema.sObjectType objType = schemaMap.get(objAPIName);
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
        map < String, Schema.SObjectField > fieldMap = objDescribe.fields.getMap(); 
        list < Schema.PicklistEntry > values = fieldMap.get(fieldAPIname).getDescribe().getPickListValues();
        for (Schema.PicklistEntry a: values) {
            picklistWrapper aa = new picklistWrapper();
            aa.pickListLabel = a.getLabel();
            aa.pickListValue = a.getValue();
            returnValue.add(aa);
        }
        return returnValue; 
    }
    public class picklistWrapper{
        @AuraEnabled 
        public string pickListLabel;
        @AuraEnabled 
        public string pickListValue;
    }
    
    @AuraEnabled
    public static integer get_yearcount(String fafid) {
        try {
            integer cntyear=0;
            List<Client_Information__c>  clientinfo = [SELECT ID,Year_1__c,Year_2__c,Year_3__c,Year_4__c,Year_5__c from Client_Information__c where FAF_ID__c=:fafid];
            for(Client_Information__c cinfo: clientinfo){ 
                if (cinfo.Year_1__c == '1') {
                    cntyear = 1;
                }
                if (cinfo.Year_2__c == '2') {
                    cntyear = 2;
                }
                if (cinfo.Year_3__c == '3') {
                    cntyear = 3;
                }
                if (cinfo.Year_4__c == '4') {
                    cntyear = 4;
                }
                if (cinfo.Year_5__c == '5') {
                    cntyear = 5;
                }
            }
            return cntyear;
        } catch(Dmlexception e){
            throw new AuraHandledException(e.getMessage());   
        }
    }
    
    @AuraEnabled
    public static List<Clinical_Solutions__c> get_AddProgramData(String fafid) {
        List<Clinical_Solutions__c> clinicList = new List<Clinical_Solutions__c>();
        clinicList = [
            Select Id, Additional_Info__c, Agreement__c, Agreement_Line_Item__c, Batch_Update__c, Client_Share__c, Clinical_Operations__c, Clinical_Operations_Link__c, Clinical_Solution__c,
            Clinical_Solution_Type__c, Contingent__c, CSG_Amount__c, CSG_Basis__c, CSG_Percentage__c, CSG_Type__c, CVS_Share__c, Do_not_modify_below_information__c, FAF_ID__c, Fee_Amount__c, 
            Fee_Basis__c, Guarantee__c, Highlight_Panel_Link__c, Included_In_Client_Savings_Guarantee__c, Link__c, Modeled_Fee_Basis__c, Object_Name__c, Opt_In_Out__c, Print_FAF_Client_Share__c, 
            Print_FAF_CVS_Share__c, Print_FAF_ROI_Percent__c, Recon_Level__c, Recon_Timeframe__c, Recon_Type__c, ROI_Amount__c, ROI_Percentage__c, ROI_Metric__c, Show_in_Grid__c, SOS__c, 
            Source_Record_ID__c, Template_Fee_Amount_Formula__c, Template_Fee_Basis_Display__c, Template_Fee_Basis_Formula__c, Template_Fee_Basis_Text__c, Year__c, Year_End_Date__c, 
            Year_Start_Date__c , Plan_Year__c
            From Clinical_Solutions__c
            Where FAF_ID__c = :fafid
        ];
        return clinicList;
    }
    @AuraEnabled
    public static String saveAddProg(Clinical_Solutions__c addPrg) {
        try{
            if(addPrg != null){
                upsert addPrg;
                return addPrg.Id;
            }
            return null;
        }catch(Dmlexception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    @AuraEnabled
    public static void delAddProg(String obId) {
        Clinical_Solutions__c delObj = [Select Id From Clinical_Solutions__c Where Id = :obId];
        delete delObj;
    }
    
    @AuraEnabled
    public static Boolean isDup( Clinical_Solutions__c cs, String clinicalSolType, String fafid) {
       
        Boolean isDuplicate = false;
        String yr = '';
        String clinicalSol = '';
        
        if(cs != null){
            yr = cs.Year__c;
            clinicalSolType = cs.Clinical_Solution_Type__c;
            clinicalSol = cs.Clinical_Solution__c;
        }
        system.debug('yr-----------'+yr);
        system.debug('fafid-----------'+fafid);
        system.debug('clinicalSolType-----------'+clinicalSolType);
        List<Clinical_Solutions__c> rgDupList = new List<Clinical_Solutions__c>();
        if(cs != null && cs.Id != null){
            system.debug('cs.Id-----------'+cs.Id);
            rgDupList = [Select Id From Clinical_Solutions__c Where Year__c = :yr and Clinical_Solution_Type__c = :clinicalSolType and FAF_ID__c=:fafid 
                         and Clinical_Solution__c = :clinicalSol and Id != :cs.Id];
        } else {
            rgDupList = [Select Id From Clinical_Solutions__c Where Year__c = :yr and Clinical_Solution_Type__c = :clinicalSolType and Clinical_Solution__c = :clinicalSol and FAF_ID__c=:fafid];
        }
        system.debug('rgDupList-----------'+rgDupList);
        if(!rgDupList.isEmpty()){
            isDuplicate = true;
        }
        
        return isDuplicate;
    }
    
}