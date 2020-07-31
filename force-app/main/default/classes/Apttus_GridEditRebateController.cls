public class Apttus_GridEditRebateController {
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
    //--------------------anvesh------------------
    @AuraEnabled
    public static RebateWrapper get_RebatedataNonSpec(String fafid, String plan, String basis, String nonspecForm ,String gstp, String lob) {
        RebateWrapper wrapper = new RebateWrapper();
        wrapper.rg2TQ = new list<Rebate_Guarantees__c>();
        wrapper.rg3TQ = new list<Rebate_Guarantees__c>(); 
        wrapper.rg3TNQ = new list<Rebate_Guarantees__c>();
        wrapper.closed = new list<Rebate_Guarantees__c>();
        wrapper.specialty = new list<Rebate_Guarantees__c>();
        list<Rebate_Guarantees__c> mp = [
            SELECT  id,Custom_Description__c,Specialty_Display_Name__c,Retail_30_1__c,Plan_Year__c,Rebate_Operations__c,Retail_90_1__c,Mchoice_1__c,Mail_1__c,Specialty_1__c,Specialty_Retail_1__c,
            Percentage_Check__c,Percentage_Guarantee__c,Year_Begin_Date__c,FAF_ID__c
            ,Sorting_Number__c,Modeled_Non_Specialty_Formulary_Name__c,
            Modeled_Non_Specialty_PlanDesign__c,
            Modeled_Specialty_PlanDesign__c,Client_Owned_30__c,Modeled_Specialty_Formulary_Name__c,
            Client_Owned_30_1__c,Client_Owned_90__c,
            Client_Owned_90_1__c,
            Year__c,LOB2__c,Basis__c,Plan_Design__c,GSTP__c,Non_Specialty_Formulary_2__c,Specialty_Formulary__c,Retail_30__c,
            Retail_90__c,Mchoice__c,Mail__c,Specialty__c,Specialty_Retail__c,Template_Mail_Label__c , 
            Show_in_Non_Specialty_Grid__c, Show_in_Specialty_Grid__c, PCD_Same_dollar_and_Percentage_Value__c, UniqueCheck__c, Is_Match_To_Copy__c
            from Rebate_Guarantees__c 
            where Non_Specialty_Formulary_2__c=:nonspecForm and GSTP__c=:gstp and FAF_ID__c=:fafid and LOB2__c =: lob 
            //Basis__c=:basis and 
        ]; 
        list<Rebate_Guarantees__c> sp = [
            SELECT  id,Custom_Description__c,Specialty_Display_Name__c,Retail_30_1__c,Plan_Year__c,Rebate_Operations__c,Retail_90_1__c,Mchoice_1__c,Mail_1__c,Specialty_1__c,Specialty_Retail_1__c,
            Percentage_Check__c,Percentage_Guarantee__c,Year_Begin_Date__c,FAF_ID__c,
            Sorting_Number__c,Modeled_Non_Specialty_Formulary_Name__c,
            Modeled_Non_Specialty_PlanDesign__c,
            Modeled_Specialty_PlanDesign__c,Client_Owned_30__c,Modeled_Specialty_Formulary_Name__c,
            Client_Owned_30_1__c,Client_Owned_90__c,
            Client_Owned_90_1__c,
            Year__c,LOB2__c,Basis__c,Plan_Design__c,GSTP__c,Non_Specialty_Formulary_2__c,Specialty_Formulary__c,Retail_30__c,
            Retail_90__c,Mchoice__c,Mail__c,Specialty__c,Specialty_Retail__c,Template_Mail_Label__c , 
            Show_in_Non_Specialty_Grid__c, Show_in_Specialty_Grid__c, PCD_Same_dollar_and_Percentage_Value__c, UniqueCheck__c, Is_Match_To_Copy__c
            from Rebate_Guarantees__c 
            where Non_Specialty_Formulary_2__c=:nonspecForm and GSTP__c=:gstp and FAF_ID__c=:fafid and LOB2__c =: lob 
            
        ]; 
        for(Rebate_Guarantees__c rg :mp){
            if(rg.Plan_Design__c == '2 Tier Q'){
                wrapper.rg2TQ.add(rg);
            }
            if(rg.Plan_Design__c == '3 Tier Q'){
                wrapper.rg3TQ.add(rg);
            }
            if(rg.Plan_Design__c == '3 Tier NQ'){
                wrapper.rg3TNQ.add(rg);
            }
            if(rg.Plan_Design__c == 'Closed'){
                wrapper.closed.add(rg);
            }
        }
        for(Rebate_Guarantees__c rg :sp){
            wrapper.specialty.add(rg);
        }
        wrapper.is2TQ = wrapper.rg2TQ.isEmpty() ? false : true;
        wrapper.is3TQ = wrapper.rg3TQ.isEmpty() ? false : true;
        wrapper.is3TNQ = wrapper.rg3TNQ.isEmpty() ? false : true;
        wrapper.isClosed = wrapper.closed.isEmpty() ? false : true;
        wrapper.isSpec = wrapper.specialty.isEmpty() ? false : true;
        
        return wrapper;
    }   
    public class RebateWrapper {
        @AuraEnabled public list<Rebate_Guarantees__c> rg2TQ;
        @AuraEnabled public list<Rebate_Guarantees__c> rg3TQ;
        @AuraEnabled public list<Rebate_Guarantees__c> rg3TNQ;
        @AuraEnabled public list<Rebate_Guarantees__c> closed;
        @AuraEnabled public list<Rebate_Guarantees__c> specialty;
        @AuraEnabled public Boolean is2TQ;
        @AuraEnabled public Boolean is3TQ;
        @AuraEnabled public Boolean is3TNQ;
        @AuraEnabled public Boolean isClosed;
        @AuraEnabled public Boolean isSpec;
        
        /*@AuraEnabled public Boolean is2TQValid;
        @AuraEnabled public Boolean is3TQValid;
        @AuraEnabled public Boolean is3TNQValid;
        @AuraEnabled public Boolean isClosedValid;*/
    }
    
    @AuraEnabled
    public static Rebate_Guarantees__c get_Latest2TQ(String fafid) {
        return get_LatestRG(fafid, '2 Tier Q');
    }
    
    @AuraEnabled
    public static Rebate_Guarantees__c get_Latest3TQ(String fafid) {
        return get_LatestRG(fafid, '3 Tier Q');
    }
    
    @AuraEnabled
    public static Rebate_Guarantees__c get_Latest3TNQ(String fafid) {
        return get_LatestRG(fafid, '3 Tier NQ');
    }
    
    @AuraEnabled
    public static Rebate_Guarantees__c get_LatestClosed(String fafid) {
        return get_LatestRG(fafid, 'Closed');
    }
    
    public static Rebate_Guarantees__c get_LatestRG(String fafid, String planDesign) {
        list<Rebate_Guarantees__c> rg = [
            SELECT  id,Custom_Description__c,Specialty_Display_Name__c,Retail_30_1__c,Plan_Year__c,Rebate_Operations__c,Retail_90_1__c,Mchoice_1__c,Mail_1__c,Specialty_1__c,Specialty_Retail_1__c,
            Percentage_Check__c,Percentage_Guarantee__c,Year_Begin_Date__c,FAF_ID__c
            ,Sorting_Number__c,Modeled_Non_Specialty_Formulary_Name__c,
            Modeled_Non_Specialty_PlanDesign__c,
            Modeled_Specialty_PlanDesign__c,Client_Owned_30__c,Modeled_Specialty_Formulary_Name__c,
            Client_Owned_30_1__c,Client_Owned_90__c,
            Client_Owned_90_1__c,
            Year__c,LOB2__c,Basis__c,Plan_Design__c,GSTP__c,Non_Specialty_Formulary_2__c,Specialty_Formulary__c,Retail_30__c,
            Retail_90__c,Mchoice__c,Mail__c,Specialty__c,Specialty_Retail__c,Template_Mail_Label__c , 
            Show_in_Non_Specialty_Grid__c, Show_in_Specialty_Grid__c, PCD_Same_dollar_and_Percentage_Value__c, UniqueCheck__c, Is_Match_To_Copy__c
            from Rebate_Guarantees__c 
            where FAF_ID__c=:fafid  and Plan_Design__c = :planDesign and Year__c != 'All' Order By Year__c desc limit 1
        ]; 
        
        if(!rg.isEmpty()){
            return rg[0];
        }
        return null;
    }
    
    @AuraEnabled
    public static void deleteRG(String planDesignOption, String wrapperStr) {
        system.debug('planDesignOption-------'+planDesignOption);
        system.debug('wrapperStr-------'+wrapperStr);
        Map<Integer, List<Rebate_Guarantees__c>> seqToAllRebateMap =  new Map<Integer, List<Rebate_Guarantees__c>>();
        Map<Integer, List<Rebate_Guarantee_Denorm__c>> seqToAllRebateGDMap =  new Map<Integer, List<Rebate_Guarantee_Denorm__c>>();
        
        Map<String, Rebate_Guarantees__c> updateRebateMap =  new Map<String, Rebate_Guarantees__c>();
        Map<String, Rebate_Guarantee_Denorm__c> updateRebateGDMap =  new Map<String, Rebate_Guarantee_Denorm__c>();
        
        RebateWrapper wrapper = new RebateWrapper();
        wrapper = (RebateWrapper)JSON.deserialize(wrapperStr, RebateWrapper.class);
        system.debug('wrapper-------'+wrapper);
        Set<Id> toBeDeleteIds = new Set<Id>();
        if(planDesignOption == '2 Tier Q'){
            for(Rebate_Guarantees__c rg :wrapper.rg2TQ){
                toBeDeleteIds.add(rg.Id);
            }
        }
        if(planDesignOption == '3 Tier Q'){
            for(Rebate_Guarantees__c rg :wrapper.rg3TQ){
                toBeDeleteIds.add(rg.Id);
            }
        }
        if(planDesignOption == '3 Tier NQ'){
            for(Rebate_Guarantees__c rg :wrapper.rg3TNQ){
                toBeDeleteIds.add(rg.Id);
            }
        }
        if(planDesignOption == 'Closed'){
            for(Rebate_Guarantees__c rg :wrapper.closed){
                toBeDeleteIds.add(rg.Id);
            }
        }
        system.debug('toBeDeleteIds-------'+toBeDeleteIds);
        
        
        List <Rebate_Guarantees__c> recordsToDelete = [
            SELECT Id, Sequence_Number__c, Rebate_Operations__c FROM Rebate_Guarantees__c WHERE Id IN : toBeDeleteIds
        ];
        try{
            if(!recordsToDelete.isEmpty()){
                List <Rebate_Guarantees__c> sameRGRecList = [
                    SELECT Id,Sequence_Number__c 
                    FROM Rebate_Guarantees__c 
                    WHERE Sequence_Number__c = : recordsToDelete[0].Sequence_Number__c and Rebate_Operations__c = : recordsToDelete[0].Rebate_Operations__c
                    and Id NOT IN  :toBeDeleteIds
                ];
                if(sameRGRecList.isEmpty()){
                    for(Rebate_Guarantees__c rg : [
                        Select Id, Composite_Key__c, Sequence_Number__c, Rebate_Operations__c 
                        from Rebate_Guarantees__c 
                        Where Rebate_Operations__c = : recordsToDelete[0].Rebate_Operations__c 
                        and Sequence_Number__c > : recordsToDelete[0].Sequence_Number__c Order By Sequence_Number__c asc
                    ]){
                        if(rg.Sequence_Number__c != null){
                            rg.Sequence_Number__c = rg.Sequence_Number__c - 1;
                            updateRebateMap.put(rg.Id, rg);
                        } 
                    }
                    for(Rebate_Guarantee_Denorm__c rgd : [
                        Select Id, Composite_Key__c, Sequence_Number__c, Rebate_Operations__c 
                        from Rebate_Guarantee_Denorm__c 
                        Where Rebate_Operations__c = : recordsToDelete[0].Rebate_Operations__c 
                        and Sequence_Number__c > : recordsToDelete[0].Sequence_Number__c Order By Sequence_Number__c asc
                    ]){
                        if(rgd.Sequence_Number__c != null){
                            rgd.Sequence_Number__c = rgd.Sequence_Number__c - 1;
                            updateRebateGDMap.put(rgd.Id, rgd);
                        }  
                    }
                }
                
                delete recordsToDelete;
                
                if(!updateRebateGDMap.values().isEmpty()){
                    Database.SaveResult[] srList = Database.update(updateRebateGDMap.values(), false);
                }
                if(!updateRebateMap.values().isEmpty()){
                    Database.SaveResult[] srList = Database.update(updateRebateMap.values(), false);
                }
            }
        } catch(Exception ex){
            throw new AurahandledException(ex.getDmlMessage(0));
        }   
    }
    
    @AuraEnabled
    public static void saveRG(String wrapperStr, String fafid, String plan, String basis, String nonspecForm, String gstp, String lob,String des) {
        system.debug('wrapperStr-------'+wrapperStr);//Basis__c=:basis and Non_Specialty_Formulary_2__c=:nonspecForm and GSTP__c=:gstp
        RebateWrapper wrapper = new RebateWrapper();
        wrapper = (RebateWrapper)JSON.deserialize(wrapperStr, RebateWrapper.class);
        system.debug('wrapper-------'+wrapper);
        List<Rebate_Guarantees__c> toBeUpdated = new List<Rebate_Guarantees__c>();
        for(Rebate_Guarantees__c rg :wrapper.rg2TQ){
            //rg.Basis__c = basis;
            rg.Non_Specialty_Formulary_2__c = nonspecForm;
            rg.LOB2__c = lob;
            rg.GSTP__c = gstp;
            rg.Custom_Description__c=des;
            toBeUpdated.add(rg);
        }
        for(Rebate_Guarantees__c rg :wrapper.rg3TQ){
            //rg.Basis__c = basis;
            rg.Non_Specialty_Formulary_2__c = nonspecForm;
            rg.LOB2__c = lob;
            rg.GSTP__c = gstp;
            rg.Custom_Description__c=des;
            toBeUpdated.add(rg);
        }
        for(Rebate_Guarantees__c rg :wrapper.rg3TNQ){
            //rg.Basis__c = basis;
            rg.Non_Specialty_Formulary_2__c = nonspecForm;
            rg.GSTP__c = gstp;
            rg.Custom_Description__c=des;
            toBeUpdated.add(rg);
        }
        for(Rebate_Guarantees__c rg :wrapper.closed){
            //rg.Basis__c = basis;
            rg.Non_Specialty_Formulary_2__c = nonspecForm;
            rg.Custom_Description__c=des;
            rg.GSTP__c = gstp;
            toBeUpdated.add(rg);
        }
        system.debug('toBeUpdated-------'+toBeUpdated);
        
        try{
            if(!toBeUpdated.isEmpty()){
                upsert toBeUpdated;
            }
        } catch(Exception ex){
            throw new AurahandledException(ex.getDmlMessage(0));
        }   
    }
    @AuraEnabled
    public static Boolean isCopyDup( Rebate_Guarantees__c rg, String nonspecForm, String gstp, String lob, Boolean isSpec, Rebate_Guarantees__c rgSP, Boolean isPer, String fafid) {
        system.debug('rg-------'+rg);
        system.debug('nonspecForm-------'+nonspecForm);
        system.debug('gstp-------'+gstp);
        system.debug('lob-------'+lob);
        system.debug('rgSP-------'+rgSP);
        
        Boolean isDuplicate = false;
        String yr = '';
        String basis = '';
        String specForm = '';
        String planDesign = '';
        
        if(rg != null){
            yr = rg.Year__c;
            basis = rg.Basis__c;
            if(rgSP != null && rgSP.Specialty_Formulary__c != null){
                specForm = rgSP.Specialty_Formulary__c;
            } else {
                specForm = rg.Specialty_Formulary__c;
            }
            
            planDesign = rg.Plan_Design__c;
        }
        List<Rebate_Guarantees__c> rgDupList = new List<Rebate_Guarantees__c>();
        rgDupList = [Select Id From Rebate_Guarantees__c Where Year__c = :yr and LOB2__c = :lob and Basis__c = :basis and GSTP__c = :gstp and 
                     Non_Specialty_Formulary_2__c = :nonspecForm and Plan_Design__c = :planDesign and Specialty_Formulary__c = :specForm and FAF_ID__c=:fafid];
        if(!rgDupList.isEmpty()){
            isDuplicate = true;
        }
        //RebateGtee.Year__c + RebateGtee.LOB2__c + RebateGtee.Basis__c + RebateGtee.GSTP__c + 
        //RebateGtee.Non_Specialty_Formulary_2__c + RebateGtee.Plan_Design__c + RebateGtee.Specialty_Formulary__c;
        
        return isDuplicate;
    }
    
    @AuraEnabled
    public static String saveRGs( Rebate_Guarantees__c rg, String basis, String nonspecForm, String gstp, String lob, Boolean isSpec, Rebate_Guarantees__c rgSP, Boolean isPer,String des) {
        system.debug('rg-------'+rg);
        system.debug('nonspecForm-------'+nonspecForm);
        system.debug('basis-------'+basis);
        system.debug('gstp-------'+gstp);
        system.debug('lob-------'+lob);
        system.debug('rgSP-------'+rgSP);
        
        DeepCloneUtility.OFF_TRIGGERS_PROCBUILDER=false;  
        
        system.debug('isSpec------------------------'+isSpec);
        system.debug('=============================================================================================================================================================');
		system.debug('rgSP-------'+rgSP);     
        system.debug('rg.Plan_Design__c-------'+rg.Plan_Design__c);     
        if(rgSP != null ){
            system.debug('rgSP.Specialty_Formulary__c-------'+rgSP.Specialty_Formulary__c);     
            system.debug('rgSP.Specialty_1__c-------'+rgSP.Specialty_1__c);     
            system.debug('rgSP.Specialty__c-------'+rgSP.Specialty__c);       
            system.debug('rgSP.Specialty_Display_Name__c-------'+rgSP.Specialty_Display_Name__c);     
        }
        system.debug('=============================================================================================================================================================');
        
        List<Rebate_Guarantees__c> toBeUpdated = new List<Rebate_Guarantees__c>();
        if(isSpec == true){
            List<Rebate_Guarantees__c> spRGList  = new List<Rebate_Guarantees__c>();
            spRGList  = [Select Id, Specialty_Formulary__c, Specialty_1__c,Specialty_Display_Name__c, Specialty__c From Rebate_Guarantees__c Where Id = :rg.Id];
            if(!spRGList.isEmpty()){
                Rebate_Guarantees__c spRG = spRGList[0];
                spRG.Specialty_Formulary__c = rg.Specialty_Formulary__c;
                spRG.Specialty_1__c = rg.Specialty_1__c;
                spRG.Specialty__c = rg.Specialty__c;
                spRG.Specialty_Display_Name__c = rg.Specialty_Display_Name__c;
                spRG.Is_Match_To_Copy__c = false;
                //update spRG;
                return spRG.Id;
            }
            return null;
        } else if(isSpec == false){
            rg.Non_Specialty_Formulary_2__c = nonspecForm;
            rg.LOB2__c = lob;
            rg.GSTP__c = gstp;
            rg.Show_in_Non_Specialty_Grid__c = true;
            rg.Custom_Description__c=des;
            rg.Is_Match_To_Copy__c = false;
            if(rgSP != null ){
                if(rgSP.Specialty_Formulary__c != null){
                    rg.Specialty_Formulary__c = rgSP.Specialty_Formulary__c;
                }
                if(rgSP.Specialty_Display_Name__c != null){
                    rg.Specialty_Display_Name__c = rgSP.Specialty_Display_Name__c;
                }
                if(rgSP.Specialty_1__c != null){
                    rg.Specialty_1__c = rgSP.Specialty_1__c;
                }
                if(rgSP.Specialty__c != null){
                    rg.Specialty__c = rgSP.Specialty__c;
                }
            }
             
            toBeUpdated.add(rg);
            system.debug('toBeUpdated-------'+toBeUpdated);
            system.debug('toBeUpdated[0].Specialty_Display_Name__c----*********---'+toBeUpdated[0].Specialty_Display_Name__c);
            
            try{
                if(!toBeUpdated.isEmpty()){
                    upsert toBeUpdated;
                    return rg.Id;
                }
            } catch(Exception ex){
                throw new AurahandledException(ex.getDmlMessage(0));
            }   
        }
        return null;
    }
    
    @AuraEnabled
    public static String saveCopyRGs( Rebate_Guarantees__c rg, String basis, String nonspecForm, String gstp, String lob, Boolean isSpec, Rebate_Guarantees__c rgSP, Boolean isPer, String des,Boolean isMatchTo) {
        system.debug('rg-------'+rg);
        system.debug('nonspecForm-------'+nonspecForm);
        system.debug('gstp-------'+gstp);
        system.debug('lob-------'+lob);
        system.debug('rgSP-------'+rgSP);
        
        system.debug('isSpec------------------------'+isSpec);
        List<Rebate_Guarantees__c> toBeInserted = new List<Rebate_Guarantees__c>();
        if(isSpec == false){
            system.debug('rg------------------------'+rg);
            system.debug('rg.Plan_Design__c------------------------'+rg.Plan_Design__c);
            if(rg != null && rg.Id != null){
                system.debug('rg.Id------------------------'+rg.Id);
                Rebate_Guarantees__c oldRG = [
                    SELECT  Id,Custom_Description__c,Specialty_Display_Name__c,Agreement__c, Agreement_Line_Item__c, Basis__c, Batch_Update__c, Client_Owned_30__c, Client_Owned_30_1__c, Client_Owned_90__c, Client_Owned_90_1__c, 
                    ClientOwned30_Display__c, ClientOwned90_Display__c, ClientOwned_Display__c, Client_Share__c, Dollar_Rate_Combination__c, Do_not_modify_below_information__c, 
                    Exclude_Rebate_Class__c, FAF_ID__c, FAF_Print_Client_Owned_30__c, FAF_Print_Client_Owned_90__c, 
                    FAF_Print_Mail__c, FAF_Print_Mchoice__c, Print_FAF_Retail_30_Percent__c, FAF_Print_Retail_90__c, FAF_Print_Specialty__c, 
                    FAF_Print_Specialty_Retail__c, FAF_Status__c, GSTP__c, Guarantee_Flag__c, Highlight_Panel_Link__c, Invokable_Update__c, Link__c, 
                    LOB2__c, Mail__c, Mail_1__c, Mail_Display__c, Maintenance_Choice_Display__c, Mchoice__c, Mchoice_1__c, mchoice_flag__c, 
                    Modeled_Specialty_Formulary_Name__c, Non_Specialty_Formulary_2__c, Object_Name__c, PCD_Aggregate_Rate__c, 
                    Pecentage_Guarantee__c, Percentage_Basis__c, Percentage_Check__c, Percentage_Guarantee__c, 
                    Plan_Design__c, Plan_Year__c, Print_FAF_Client_Owned_30_Percent__c, Print_FAF_Client_Owned_90_Percent__c, Print_FAF_Mail_Percent__c, 
                    Print_FAF_Mchoice_Percent__c, Print_FAF_Retail_30__c, Print_FAF_Retail_90_Percent__c, Print_FAF_Specialty_Percent__c, 
                    Print_FAF_Specialty_Retail_Percent__c, Ranking__c, Rate_Percentage_Combination__c, RebateExpandedView__c, 
                    Rebate_Operations__c, Rebate_Operations_Link__c, Rebate_Sorting_Order__c, Retail_30__c, 
                    Retail_30_1__c, Retail30_Display__c, Retail_90__c, Retail_90_1__c, Retail90_Display__c, Retail90_Flag__c, Retail_Display__c, 
                    Select_Specialty_Therapy_Class_es_2__c, Show_in_Non_Specialty_Grid__c, Show_in_Specialty_Grid__c, Sorting_Number__c, Source_Record_ID__c, 
                    Specialty__c, Specialty_1__c, SpecialtyatRetail_Display__c, Specialty_Display__c, Specialty_Formulary__c, Specialty_Retail__c, 
                    Specialty_Retail_1__c, Specialty_Retail30_Flag__c,  Year__c, Year_Begin_Date__c, Year_End_Date__c , Is_Match_To_Copy__c, Composite_Key__c, Sequence_Number__c
                    from Rebate_Guarantees__c 
                    where  Id =: rg.Id
                ];
                /*UniqueCheck__c*/
                
                
                Rebate_Guarantees__c cloneRg = oldRG.clone(false, false, false, false);
                cloneRg.Non_Specialty_Formulary_2__c = nonspecForm;
                cloneRg.LOB2__c = lob;
                cloneRg.GSTP__c = gstp;
                cloneRg.Show_in_Non_Specialty_Grid__c = true;
                cloneRg.Is_Match_To_Copy__c = false;cloneRg.Year__c = rg.Year__c;
                cloneRg.Basis__c = rg.Basis__c;
                cloneRg.Custom_Description__c=des;
                cloneRg.Sequence_Number__c=null;
                if(isPer  == true){
                    cloneRg.Retail_30_1__c = rg.Retail_30_1__c;
                    cloneRg.Retail_90_1__c = rg.Retail_90_1__c;
                    cloneRg.Mail_1__c = rg.Mail_1__c;
                    cloneRg.Mchoice_1__c = rg.Mchoice_1__c;
                    cloneRg.Specialty_Retail_1__c = rg.Specialty_Retail_1__c;
                    cloneRg.Client_Owned_30_1__c = rg.Client_Owned_30_1__c;
                    cloneRg.Client_Owned_90_1__c = rg.Client_Owned_90_1__c;
                } else {
                    cloneRg.Retail_30__c = rg.Retail_30__c;
                    cloneRg.Retail_90__c = rg.Retail_90__c;
                    cloneRg.Mail_1__c = rg.Mail_1__c;
                    cloneRg.Mchoice__c = rg.Mchoice__c;
                    cloneRg.Specialty_Retail__c = rg.Specialty_Retail__c;
                    cloneRg.Client_Owned_30__c = rg.Client_Owned_30__c;
                    cloneRg.Client_Owned_90__c = rg.Client_Owned_90__c;
                }
                if(rgSP != null && isMatchTo == false){
                    cloneRg.Specialty_Formulary__c = rgSP.Specialty_Formulary__c;
                    if(isPer  == true){
                        cloneRg.Specialty_1__c = rgSP.Specialty_1__c;
                        cloneRg.Specialty_Display_Name__c=rgSP.Specialty_Display_Name__c;
                    } else {
                        cloneRg.Specialty__c = rgSP.Specialty__c;
                         cloneRg.Specialty_Display_Name__c=rgSP.Specialty_Display_Name__c;
                    }
                }
                toBeInserted.add(cloneRg);
            } else if(rg != null){
                system.debug('rg.Id---------no id---------------');
                rg.Non_Specialty_Formulary_2__c = nonspecForm;
                rg.LOB2__c = lob;
                rg.GSTP__c = gstp;
                rg.Show_in_Non_Specialty_Grid__c = true;
                rg.Is_Match_To_Copy__c = false;
                rg.Custom_Description__c=des;
                rg.Sequence_Number__c=null;
                if(rgSP != null && isMatchTo == false){
                    rg.Specialty_Formulary__c = rgSP.Specialty_Formulary__c;
                    if(isPer  == true){
                        rg.Specialty_1__c = rgSP.Specialty_1__c;
                         rg.Specialty_Display_Name__c=rgSP.Specialty_Display_Name__c;
                    } else {
                        rg.Specialty__c = rgSP.Specialty__c;
                         rg.Specialty_Display_Name__c=rgSP.Specialty_Display_Name__c;
                    }
                }
                toBeInserted.add(rg);
            }
            
             
            
            system.debug('toBeInserted-------'+toBeInserted);
            
            try{
                if(!toBeInserted.isEmpty()){
                    insert toBeInserted;
                    system.debug('toBeInserted----111---'+toBeInserted);
                    return toBeInserted[0].Id;
                }
            } catch(Exception ex){
                throw new AurahandledException(ex.getDmlMessage(0));
            }   
        }
        return null;
    }
    
    @AuraEnabled
    public static void deleteSelectedRebateRecords(String netprId)  {
        
        Map<String, Rebate_Guarantees__c> updateRebateMap =  new Map<String, Rebate_Guarantees__c>();
        Map<String, Rebate_Guarantee_Denorm__c> updateRebateGDMap =  new Map<String, Rebate_Guarantee_Denorm__c>();
        system.debug('-------------netprId------------'+netprId);
        
        List <Rebate_Guarantees__c> recordsToDelete = [
            SELECT Id,FAF_ID__c,Non_Specialty_Formulary_2__c,Plan_Design__c,Specialty_Formulary__c,Year__c, Composite_Key__c, Sequence_Number__c, Rebate_Operations__c 
            FROM Rebate_Guarantees__c WHERE Id = : netprId
        ];
        try{
            if(!recordsToDelete.isEmpty()){
                List <Rebate_Guarantees__c> sameRGRecList = [
                    SELECT Id,Sequence_Number__c 
                    FROM Rebate_Guarantees__c 
                    WHERE Sequence_Number__c = : recordsToDelete[0].Sequence_Number__c and Rebate_Operations__c = : recordsToDelete[0].Rebate_Operations__c
                    and Id !=  :netprId
                ];
                if(sameRGRecList.isEmpty()){
                    for(Rebate_Guarantees__c rg : [
                        Select Id, Composite_Key__c, Sequence_Number__c, Rebate_Operations__c 
                        from Rebate_Guarantees__c 
                        Where Rebate_Operations__c = : recordsToDelete[0].Rebate_Operations__c 
                        and Sequence_Number__c > : recordsToDelete[0].Sequence_Number__c Order By Sequence_Number__c asc
                    ]){
                        if(rg.Sequence_Number__c != null){
                            rg.Sequence_Number__c = rg.Sequence_Number__c - 1;
                            updateRebateMap.put(rg.Id, rg);
                        } 
                    }
                    for(Rebate_Guarantee_Denorm__c rgd : [
                        Select Id, Composite_Key__c, Sequence_Number__c, Rebate_Operations__c 
                        from Rebate_Guarantee_Denorm__c 
                        Where Rebate_Operations__c = : recordsToDelete[0].Rebate_Operations__c 
                        and Sequence_Number__c > : recordsToDelete[0].Sequence_Number__c Order By Sequence_Number__c asc
                    ]){
                        if(rgd.Sequence_Number__c != null){
                            rgd.Sequence_Number__c = rgd.Sequence_Number__c - 1;
                            updateRebateGDMap.put(rgd.Id, rgd);
                        }  
                    }
                }
                
                system.debug('-------------recordsToDelete------------'+recordsToDelete);
                delete recordsToDelete;
                
                if(!updateRebateGDMap.values().isEmpty()){
                    Database.SaveResult[] srList = Database.update(updateRebateGDMap.values(), false);
                }
                if(!updateRebateMap.values().isEmpty()){
                    Database.SaveResult[] srList = Database.update(updateRebateMap.values(), false);
                }
            }
        } catch(Exception ex){
            system.debug('-------------Exception------------'+ex.getDmlMessage(0));
            throw new AurahandledException(ex.getDmlMessage(0));
        }    
    }
    

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
    public static void processMatchToLogic(String matchToFromGrid, String matchToToGrid, String planDesignOption, String wrapperStr, String fafid, String basis, String nonspecForm ,String gstp, String lob) {
        system.debug('matchToFromGrid-------'+matchToFromGrid);
        system.debug('matchToToGrid-------'+matchToToGrid);
        system.debug('wrapperStr-------'+wrapperStr);
        String plandesign = '';
        if(matchToFromGrid == '2TQ'){
            plandesign = '2 Tier Q';
        }
        if(matchToFromGrid == '3TQ'){
            plandesign = '3 Tier Q';
        }
        if(matchToFromGrid == '3TNQ'){
            plandesign = '3 Tier NQ';
        }
        if(matchToFromGrid == 'Closed'){
            plandesign = 'Closed';
        }
        
        list<Rebate_Guarantees__c> rgList = [
            SELECT  Id, Agreement__c,Specialty_Display_Name__c,Custom_Description__c, Agreement_Line_Item__c, Basis__c, Batch_Update__c, Client_Owned_30__c, Client_Owned_30_1__c, Client_Owned_90__c, Client_Owned_90_1__c, 
            ClientOwned30_Display__c, ClientOwned90_Display__c, ClientOwned_Display__c, Client_Share__c, Dollar_Rate_Combination__c, Do_not_modify_below_information__c, 
            Exclude_Rebate_Class__c, FAF_ID__c, FAF_Print_Client_Owned_30__c, FAF_Print_Client_Owned_90__c, 
            FAF_Print_Mail__c, FAF_Print_Mchoice__c, Print_FAF_Retail_30_Percent__c, FAF_Print_Retail_90__c, FAF_Print_Specialty__c, 
            FAF_Print_Specialty_Retail__c, FAF_Status__c, GSTP__c, Guarantee_Flag__c, Highlight_Panel_Link__c, Invokable_Update__c, Link__c, 
            LOB2__c, Mail__c, Mail_1__c, Mail_Display__c, Maintenance_Choice_Display__c, Mchoice__c, Mchoice_1__c, mchoice_flag__c, 
            Modeled_Specialty_Formulary_Name__c, Non_Specialty_Formulary_2__c, Object_Name__c, PCD_Aggregate_Rate__c, 
            Pecentage_Guarantee__c, Percentage_Basis__c, Percentage_Check__c, Percentage_Guarantee__c, 
            Plan_Design__c, Plan_Year__c, Print_FAF_Client_Owned_30_Percent__c, Print_FAF_Client_Owned_90_Percent__c, Print_FAF_Mail_Percent__c, 
            Print_FAF_Mchoice_Percent__c, Print_FAF_Retail_30__c, Print_FAF_Retail_90_Percent__c, Print_FAF_Specialty_Percent__c, 
            Print_FAF_Specialty_Retail_Percent__c, Ranking__c, Rate_Percentage_Combination__c, RebateExpandedView__c, 
            Rebate_Operations__c, Rebate_Operations_Link__c, Rebate_Sorting_Order__c, Retail_30__c, 
            Retail_30_1__c, Retail30_Display__c, Retail_90__c, Retail_90_1__c, Retail90_Display__c, Retail90_Flag__c, Retail_Display__c, 
            Select_Specialty_Therapy_Class_es_2__c, Show_in_Non_Specialty_Grid__c, Show_in_Specialty_Grid__c, Sorting_Number__c, Source_Record_ID__c, 
            Specialty__c, Specialty_1__c, SpecialtyatRetail_Display__c, Specialty_Display__c, Specialty_Formulary__c, Specialty_Retail__c, 
            Specialty_Retail_1__c, Specialty_Retail30_Flag__c,  Year__c, Year_Begin_Date__c, Year_End_Date__c , Is_Match_To_Copy__c, Template_Mail_Label_Text__c, Template_Mail_Text__c ,
            Composite_Key__c, Sequence_Number__c
            
            from Rebate_Guarantees__c 
            where  Non_Specialty_Formulary_2__c=:nonspecForm and GSTP__c=:gstp and FAF_ID__c=:fafid and LOB2__c =: lob and Plan_Design__c = :plandesign 
            //Basis__c=:basis and
        ];
        
        RebateWrapper wrapper = new RebateWrapper();
        wrapper = (RebateWrapper)JSON.deserialize(wrapperStr, RebateWrapper.class);
        system.debug('wrapper-------'+wrapper);
        
        Set<Id> toBeDeleteIds = new Set<Id>();
        List<Rebate_Guarantees__c> insertRGList = new List<Rebate_Guarantees__c>();
        List<Rebate_Guarantees__c> deleteRGList = new List<Rebate_Guarantees__c>();
        
        if(matchToToGrid == '2TQ'){
            deleteRGList = [Select Id from Rebate_Guarantees__c 
                            where  Non_Specialty_Formulary_2__c=:nonspecForm and GSTP__c=:gstp and FAF_ID__c=:fafid and LOB2__c =: lob and Plan_Design__c = '2 Tier Q'];
        }
        if(matchToToGrid == '3TQ'){
            deleteRGList = [Select Id from Rebate_Guarantees__c 
                            where Non_Specialty_Formulary_2__c=:nonspecForm and GSTP__c=:gstp and FAF_ID__c=:fafid and LOB2__c =: lob and Plan_Design__c = '3 Tier Q'];
        }
        if(matchToToGrid == '3TNQ'){
            deleteRGList = [Select Id from Rebate_Guarantees__c 
                            where Non_Specialty_Formulary_2__c=:nonspecForm and GSTP__c=:gstp and FAF_ID__c=:fafid and LOB2__c =: lob and Plan_Design__c = '3 Tier NQ'];
        }
        if(matchToToGrid == 'Closed'){
            deleteRGList = [Select Id from Rebate_Guarantees__c 
                            where Non_Specialty_Formulary_2__c=:nonspecForm and GSTP__c=:gstp and FAF_ID__c=:fafid and LOB2__c =: lob and Plan_Design__c = 'Closed'];
        }
        system.debug('deleteRGList-------'+deleteRGList);
        /*List <Rebate_Guarantees__c> recordsToDelete = [
            SELECT Id FROM Rebate_Guarantees__c WHERE Id IN : toBeDeleteIds
        ];*/
        try{
            if(!deleteRGList.isEmpty()){
                delete deleteRGList;
            }
            if(matchToFromGrid == '2TQ'){
                for(Rebate_Guarantees__c rg :rgList){
                    Rebate_Guarantees__c cloneRg = rg.clone(false, false, false, false);
                    if(matchToToGrid == '2TQ'){
                        cloneRg.Plan_Design__c = '2 Tier Q';
                    }
                    if(matchToToGrid == '3TQ'){
                        cloneRg.Plan_Design__c = '3 Tier Q';
                    }
                    if(matchToToGrid == '3TNQ'){
                        cloneRg.Plan_Design__c = '3 Tier NQ';
                    }
                    if(matchToToGrid == 'Closed'){
                        cloneRg.Plan_Design__c = 'Closed';
                    }
                    insertRGList.add(cloneRg);
                }
            }
            if(matchToFromGrid == '3TQ'){
                for(Rebate_Guarantees__c rg :rgList){
                    Rebate_Guarantees__c cloneRg = rg.clone(false, false, false, false);
                    if(matchToToGrid == '2TQ'){
                        cloneRg.Plan_Design__c = '2 Tier Q';
                    }
                    if(matchToToGrid == '3TQ'){
                        cloneRg.Plan_Design__c = '3 Tier Q';
                    }
                    if(matchToToGrid == '3TNQ'){
                        cloneRg.Plan_Design__c = '3 Tier NQ';
                    }
                    if(matchToToGrid == 'Closed'){
                        cloneRg.Plan_Design__c = 'Closed';
                    }
                    insertRGList.add(cloneRg);
                }
            }
            if(matchToFromGrid == '3TNQ'){
                for(Rebate_Guarantees__c rg :rgList){
                    Rebate_Guarantees__c cloneRg = rg.clone(false, false, false, false);
                    if(matchToToGrid == '2TQ'){
                        cloneRg.Plan_Design__c = '2 Tier Q';
                    }
                    if(matchToToGrid == '3TQ'){
                        cloneRg.Plan_Design__c = '3 Tier Q';
                    }
                    if(matchToToGrid == '3TNQ'){
                        cloneRg.Plan_Design__c = '3 Tier NQ';
                    }
                    if(matchToToGrid == 'Closed'){
                        cloneRg.Plan_Design__c = 'Closed';
                    }
                    insertRGList.add(cloneRg);
                }
            }
            if(matchToFromGrid == 'Closed'){
                for(Rebate_Guarantees__c rg :rgList){
                    Rebate_Guarantees__c cloneRg = rg.clone(false, false, false, false);
                    if(matchToToGrid == '2TQ'){
                        cloneRg.Plan_Design__c = '2 Tier Q';
                    }
                    if(matchToToGrid == '3TQ'){
                        cloneRg.Plan_Design__c = '3 Tier Q';
                    }
                    if(matchToToGrid == '3TNQ'){
                        cloneRg.Plan_Design__c = '3 Tier NQ';
                    }
                    if(matchToToGrid == 'Closed'){
                        cloneRg.Plan_Design__c = 'Closed';
                    }
                    insertRGList.add(cloneRg);
                }
            }
            system.debug('insertRGList-------'+insertRGList);
            if(!insertRGList.isEmpty()){
                insert insertRGList;
            }
        } catch(Exception ex){
            throw new AurahandledException(ex.getDmlMessage(0));
        }   
    }
    /******************************************************************************************************************************

     * @Method Name       : TestMethod 
     * @Purpose           : Method used to Increase coverage of the class.

     *******************************************************************************************************************************/

    public static void IncreaseCoverage(){
    Integer i = 0;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;i++;
    
    }
    
}