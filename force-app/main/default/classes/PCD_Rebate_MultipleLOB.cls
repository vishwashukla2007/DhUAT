public class PCD_Rebate_MultipleLOB 
{

 @AuraEnabled
    public static List<LOB__c> get_allLOB(String Basealiid){
       try {
            List<LOB__c> lstallLOB =  new List<LOB__c>();
            Apttus__AgreementLineItem__c lstali = [select Id,Apttus__AgreementId__c from  Apttus__AgreementLineItem__c where Id = :Basealiid
                                  ];                    
            if (lstali.Apttus__AgreementId__c != null)
             {  
              lstallLOB= [select Id,LOB_Description__c,Lob__c,LobId__c,FAF__c,FAF_Agreement_Line_Item__c,Agreement_Line_Item__c,Client_Pricing_Offer__c,Active__c from LOB__c 
                          where Agreement__c = :lstali.Apttus__AgreementId__c
                         ];   
            }                 
            return lstallLOB; 
            } 
        catch(exception e)
            {
            throw new AuraHandledException(e.getMessage());
            }
    }  
 
 @AuraEnabled
    public static Boolean create_mlob(String Basealiid, List<String> mlob){
       try {
            List<PCD_Multiple_LOB__c> newmlob = new List<PCD_Multiple_LOB__c>();
            LOB__c lstallLOB = new LOB__c();
            system.debug('aa');
            Apttus__AgreementLineItem__c lstali = [select Id,Apttus__AgreementId__c,LOB_ID__c from  Apttus__AgreementLineItem__c where Id = :Basealiid
                                  ];                    
            if (lstali.Apttus__AgreementId__c != null)
             {  
                lstallLOB = [select Id,LOB_Description__c,Lob__c,LobId__c,FAF__c,Agreement_Line_Item__c,Client_Pricing_Offer__c,Active__c from LOB__c 
                          where Agreement__c = :lstali.Apttus__AgreementId__c and Id = :lstali.LOB_ID__c
                         ];   
            } 
            List<LOB__c> lstallmLOB= [select Id,LOB_Description__c,Lob__c,LobId__c,FAF__c,Agreement_Line_Item__c,Client_Pricing_Offer__c,Active__c from LOB__c 
                          where Id IN :mlob
                         ];               
            for (LOB__c lob : lstallmLOB)
            {
               PCD_Multiple_LOB__c  mlobid = new PCD_Multiple_LOB__c();
               mlobid.Base_FAF_ID__c = lstallLOB.FAF__c;
               mlobid.Base_LOB__c = lstallLOB.Id;
               mlobid.Base_LOB_ID__c = lstallLOB.LOB_Description__c;
               mlobid.Additional_FAF_ID__c = lob.FAF__c;
               mlobid.Additional_LOB__c = lob.Id;
               mlobid.Additional_LOB_ID__c = lob.LOB_Description__c;
               newmlob.add(mlobid);
            }           
            system.debug('ee');
             List<Database.UpsertResult> result = Database.upsert(newmlob, false);
                for(Integer i=0;i<result.size();i++){
                    if(!result.get(i).isSuccess()) {
                        Database.Error error = result.get(i).getErrors().get(0);
                        String failedDML = error.getMessage();
                        throw new AuraHandledException(failedDML);
                    }
                }           
                                          
            return true; 
            } 
        catch(exception e)
            {
            throw new AuraHandledException(e.getMessage());
            }
    }  
 
 @AuraEnabled
    public static List<PCD_Multiple_LOB__c> get_AdditionalLOB(String Basealiid){
       try {
            List<PCD_Multiple_LOB__c> lstMultipleLOB= [select Id,Base_FAF_ID__c,Base_LOB__c,Base_LOB_ID__c,ALI_ID__c,Additional_ALI_ID__c,Additional_FAF_ID__c,Additional_LOB__c,Additional_LOB_ID__c,Additional_LOB_Numeric_ID__c,Base_LOB_Numeric_ID__c from PCD_Multiple_LOB__c where ALI_ID__c= :Basealiid
                                                       order by Additional_LOB_Numeric_ID__c];
            return lstMultipleLOB; 
            } 
        catch(exception e)
        {
            throw new AuraHandledException(e.getMessage());
        }
    }  
    
    @AuraEnabled
    public static List<Mail_Pricing__c> get_MPLOB(String fafid){
       try {
            List<Mail_Pricing__c> lstMP= [select Id,name,Year__c,LOB__c,Custom_Description__c,Brand_Basis__c,Generic_Basis__c,Plan_Year__c from Mail_Pricing__c where FAF_ID__c= :fafid];
            return lstMP; 
            } 
        catch(exception e)
        {
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    @AuraEnabled
    public static List<Rebate_Guarantees__c> get_Pricing(String fafid){
       try {
            List<Rebate_Guarantees__c> lstRG= [select Id,Modeled_Non_Specialty_Formulary_Name__c,Modeled_Specialty_Formulary_Name__c,Non_Specialty_Formulary_2__c,Specialty_Formulary__c,GSTP__c from Rebate_Guarantees__c where FAF_ID__c= :fafid
                                              and Grid_flag__c=true
                                              ]; // and (Show_in_Specialty_Grid__c = true or Grid_flag__c=true)
            
            
            return lstRG; 
            } 
        catch(exception e)
        {
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    @AuraEnabled
    public static List<Rebate_Guarantees__c> get_listPricing(String fafid,String nonspecialty,String specialty,String gstp){
       try {
            List<Rebate_Guarantees__c> lstRG= [select Id,Year__c,LOB2__c,Basis__c,Plan_Design__c,GSTP__c,Modeled_Non_Specialty_Formulary_Name__c,Modeled_Specialty_Formulary_Name__c,Non_Specialty_Formulary_2__c,Specialty_Formulary__c from Rebate_Guarantees__c 
                                               where FAF_ID__c= :fafid and Modeled_Non_Specialty_Formulary_Name__c=:nonspecialty and GSTP__c=:gstp
                                               order by Year__c,Non_Specialty_Formulary_2__c,Specialty_Formulary__c
                                              ]; 
            
            
            return lstRG; 
            } 
        catch(exception e)
        {
            throw new AuraHandledException(e.getMessage());
        }
    }
   
   @AuraEnabled
    public static void save_mlobrebate(String baseali,String addali, List<String> selectedrec)
     {
     
     try {
           DeepCloneUtility.OFF_TRIGGERS_PROCBUILDER=false;
           Map<String,List<Rebate_Guarantees__c>> mapstr=new Map<String,List<Rebate_Guarantees__c>>();
           set<String> NonSpecialtySet=new Set<String>();
           Map<String,Decimal> SortingMap=new Map<String,Decimal>();
          //Map for Speciality formulary and Denorm object 
           Map<String, Rebate_Guarantee_Denorm__c> formularyIdToDenormMap = new Map<String, Rebate_Guarantee_Denorm__c>();    
           List<Rebate_Guarantee_Denorm__c> finalListToInsert=new List<Rebate_Guarantee_Denorm__c>();
           Apttus__AgreementLineItem__c lstali = [select Id,Apttus__AgreementId__c,PCD_FAF__c from  Apttus__AgreementLineItem__c where Id = :baseali
                                                 ];   
                                  
          if (lstali.Id != null)
          { 
           List<Rebate_Guarantees__c> RbgList =[
            SELECT ID,Agreement__c,Custom_Description__c,Specialty_Display_Name__c,UniqueCheck__c,Agreement_Line_Item__c,Retail_30__c,PCD_Aggregate_Rate__c,Grid_flag__c,
            Dollar_Rate_Combination__c,Rate_Percentage_Combination__c,Percentage_Check__c,Retail_90__c,
            Mchoice__c,Mail__c,Client_Owned_30__c,Client_Owned_90__c,Retail_30_1__c,Retail_90_1__c,Mchoice_1__c,Mail_1__c,Client_Owned_30_1__c,Client_Owned_90_1__c,
            rebate_Modeled_Non_Specialty_PlanDe_New__c,PCD_Same_dollar_and_Percentage_Value__c,Name,Rebate_Operations__c,Rebate_Sorting_Order__c,Sorting_Number__c,FAF_ID__c,
            Pecentage_Guarantee__c,Year_Begin_Date__c,Year_End_Date__c,Invokable_Update__c,Year__c,Template_Non_Specialty_Grid_Name_Text__c,Plan_Year__c,Template_Mail_Label_Text__c,
            LOB2__c,Plan_Design__c,Basis__c,GSTP__c,Batch_Update__c,Modeled_Non_Specialty_Formulary_Name__c,Modeled_Specialty_Formulary_Name__c,Specialty_1__c,Specialty_Retail_1__c,
            Modeled_Non_Specialty_PlanDesign__c,Modeled_Specialty_PlanDesign__c,Template_Specialty_Grid_Name__c,Template_Non_Specialty_Grid_Name__c,Show_in_Non_Specialty_Grid__c,
            Show_in_Specialty_Grid__c,Specialty__c,Specialty_Retail__c,Specialty_Formulary__c,Non_Specialty_Formulary_2__c, Template_ClientOwned30_Formula__c,Template_Clientowned30_Text__c,
            Template_ClientOwned90_Formula__c,
            Template_Clientowned90_Text__c,Template_Clientowned_Text__c,Template_Mail_Formula__c,Template_Mail_Label__c,Template_Mail_Text__c,Template_Mchoice_Formula__c,Template_Mchoice_Text__c,
            Template_Non_Specialty_Plan_Design__c,Template_Retail30_Formula__c,Template_Retail30_Text__c,Template_Retail90_Formula__c,Template_Retail90_Text__c,Template_Retail_Text__c,
            Template_SpecialtyatCVS_Text__c,Template_SpecialtyatRetail_Formula__c,Template_SpecialtyatRetail_Text__c,Template_Specialty_Carveout_Label_Text__c, Template_Specialty_Carveout_Text__c,
            Template_Specialty_Formula__c,Template_Specialty_Grid_Name_Text__c,Template_Specialty_Plan_Design__c,ClientOwned30_Display__c, ClientOwned90_Display__c,
            ClientOwned_Display__c,Mail_Display__c,Maintenance_Choice_Display__c,Retail30_Display__c,Retail90_Display__c,Retail_Display__c,SpecialtyatRetail_Display__c,Specialty_Display__c,
            Template_Retail_Display__c,Template_Retail30_Display__c,Template_Retail90_Display__c,Template_ClientOwned_Display__c,Template_ClientOwned30_Display__c,Template_ClientOwned90_Display__c,
            Template_Mail_Display__c,Rebate_Key__c,Template_Mchoice_Display__c,Template_SpecialtyatRetail_Display__c,Template_SpecialtyatCVS_Display__c,Template_Rcurve_Display__c,
            Sequence_Number__c
            FROM Rebate_Guarantees__c WHERE Id IN:selectedrec order by PCD_Plan_design_Sort__c ASC
           ];    
        
        
        List<AggregateResult> result =[SELECT Non_Specialty_Formulary_2__c Key
                                       FROM Rebate_Guarantees__c 
                                       WHERE Id IN:selectedrec
                                       GROUP BY Non_Specialty_Formulary_2__c];
        
     
        
        List<Rebate_Guarantee_Denorm__c> lstToInsert = new List<Rebate_Guarantee_Denorm__c>();
        List<Rebate_Guarantee_Denorm__c> lstTodelete=[Select ID from Rebate_Guarantee_Denorm__c where Orginal_Agreement_Line_Item__c = :addali
                                                      and Multiple_LOB__c = true and Agreement_Line_Item__c = :baseali];
        If(!RbgList.isEmpty()){ 
            
            for(Rebate_Guarantees__c rbg:RbgList){
                SortingMap.put(rbg.Non_Specialty_Formulary_2__c,rbg.Sorting_Number__c);
                if(!mapstr.containsKey(rbg.Rebate_Key__c)){
                    mapstr.put(rbg.Rebate_Key__c, new List<Rebate_Guarantees__c>{});
                }
                mapstr.get(rbg.Rebate_Key__c).add(rbg);
            }
            
            
            for(String eachRes : mapstr.keyset()){
                Integer CounterSpec=1;
                Rebate_Guarantee_Denorm__c uniqueDenorm =new Rebate_Guarantee_Denorm__c();
                for(Rebate_Guarantees__c rb : mapstr.get(eachRes)){
                    // start logic to carry Speciality formulary based denorm creation
                    Rebate_Guarantee_Denorm__c denormObj;
                    // if Speciality formulary is already present in map
                    if(formularyIdToDenormMap.containsKey(rb.Non_Specialty_Formulary_2__c+rb.Specialty_Formulary__c+rb.Plan_Design__c+rb.GSTP__c)){
                        //denormObj.Sequence_Number__c = rb.Sequence_Number__c;
                        denormObj = formularyIdToDenormMap.get(rb.Non_Specialty_Formulary_2__c+rb.Specialty_Formulary__c+rb.Plan_Design__c+rb.GSTP__c);
                        denormObj.Sequence_Number__c = rb.Sequence_Number__c;
                    }else{
                        denormObj =new Rebate_Guarantee_Denorm__c();
                        denormObj.Sequence_Number__c = rb.Sequence_Number__c;
                        formularyIdToDenormMap.put(rb.Non_Specialty_Formulary_2__c+rb.Specialty_Formulary__c+rb.Plan_Design__c+rb.GSTP__c, denormObj);
                    }
                    // end logic to carry Speciality formulary based denorm creation

                    if(rb.Year__c == '1'){
                        
                        if(rb.Percentage_Check__c == true){
                            if(rb.Retail30_Display__c==true){
                                uniqueDenorm.RETAIL30_Y1_Percentage__c  = rb.Retail_30_1__c;
                            }
                            if(rb.Retail90_Display__c==true){
                                uniqueDenorm.RETAIL90_Y1_Percentage__c  = rb.Retail_90_1__c;
                            }
                            if(rb.Maintenance_Choice_Display__c==true){
                                uniqueDenorm.MCHOICE_Y1_Percentage__c   = rb.Mchoice_1__c;
                            }
                            if(rb.Mail_Display__c==true){
                                uniqueDenorm.MAIL_Y1_Percentage__c      = rb.Mail_1__c;
                            }
                            if(rb.ClientOwned30_Display__c==true){
                                uniqueDenorm.CLIENTOWNED30_Y1_Percentage__c = rb.Client_Owned_30_1__c;
                            }
                            if(rb.ClientOwned90_Display__c==true){
                                uniqueDenorm.CLIENTOWNED90_Y1_Percentage__c = rb.Client_Owned_90_1__c;
                            }
                            uniqueDenorm.Basis_Y1__c     = rb.Basis__c;
                            uniqueDenorm.Template_Mail_Text_Y1__c=rb.Template_Mail_Label_Text__c;
                            uniqueDenorm.Plan_Year_Y1__c = rb.Plan_Year__c;
                            //uniqueDenorm.Retail_30_Display_Y1__c=rb.Template_Retail30_Display__c;
                            //uniqueDenorm.Retail_90_Display_Y1__c=rb.Template_Retail90_Display__c;
                            if(rb.Show_in_Non_Specialty_Grid__c==true){
                                uniqueDenorm.Grid1__c = rb.Grid_flag__c;
                            }
                            uniqueDenorm.SPECIALTY_RETAIL_Y1_Percentage__c = rb.Specialty_Retail_1__c;
                            if(rb.ClientOwned_Display__c==true){
                                uniqueDenorm.CLIENTOWNED_Y1_Percentage__c=rb.Client_Owned_30_1__c;
                            }
                            if(rb.Retail_Display__c==true){
                                uniqueDenorm.RETAIL_Y1_Percentage__c=rb.Retail_30_1__c;
                            }
                            // field mapping for Speciality formulary
                            if(rb.Specialty_1__c!=null){
                                denormObj.SPECIALTY_Y1_Percentage__c       = rb.Specialty_1__c;
                                denormObj.Basis_Y1__c       = rb.Basis__c;
                                denormObj.Plan_Year_Y1__c   = rb.Plan_Year__c;
                                denormObj.Specialty_Grid__c = true;
                            }
                        }else{
                            if(rb.Retail30_Display__c==true){
                                uniqueDenorm.RETAIL30_Y1__c = rb.Retail_30__c;
                            }
                            if(rb.Retail90_Display__c==true){
                                uniqueDenorm.RETAIL90_Y1__c   = rb.Retail_90__c;
                            }
                            if(rb.Mail_Display__c==true){
                                uniqueDenorm.MAILY1__c      = rb.Mail__c;
                            }
                            if(rb.Maintenance_Choice_Display__c==true){
                                uniqueDenorm.MCHOICEY1__c   = rb.Mchoice__c;
                            }
                            if(rb.ClientOwned30_Display__c==true){
                                uniqueDenorm.CLIENT_OWNED30_Y1__c = rb.Client_Owned_30__c;
                            }
                            if(rb.ClientOwned90_Display__c==true){
                                uniqueDenorm.CLIENT_OWNED90_Y1__c = rb.Client_Owned_90__c;
                            }
                            uniqueDenorm.Basis_Y1__c     = rb.Basis__c;
                            uniqueDenorm.Plan_Year_Y1__c = rb.Plan_Year__c;
                            uniqueDenorm.SPECIALTY_RETAIL_Y1__c = rb.Specialty_Retail__c;
                            uniqueDenorm.Template_Mail_Text_Y1__c=rb.Template_Mail_Label_Text__c;
                            //uniqueDenorm.Retail_30_Display_Y1__c=rb.Template_Retail30_Display__c;
                            //uniqueDenorm.Retail_90_Display_Y1__c=rb.Template_Retail90_Display__c;
                            if(rb.Show_in_Non_Specialty_Grid__c==true){
                                uniqueDenorm.Grid1__c = rb.Grid_flag__c;
                            }
                            if(rb.Retail_Display__c==true){
                                uniqueDenorm.RETAIL_Y1__c=rb.Retail_30__c;
                            }
                            if(rb.ClientOwned_Display__c==true){
                                uniqueDenorm.CLIENT_OWNED_Y1__c=rb.Client_Owned_30__c;
                            }
                            // field mapping for Speciality formulary
                            if(rb.Specialty__c!=null){
                                denormObj.SPECIALTYY1__c         = rb.Specialty__c;
                                denormObj.Specialty_Grid__c = true;
                                denormObj.Basis_Y1__c       = rb.Basis__c;
                                denormObj.Plan_Year_Y1__c   = rb.Plan_Year__c;
                            }
                            
                        }
                    }
                    
                    if(rb.Year__c == '2'){
                        
                        if(rb.Percentage_Check__c == true){
                            if(rb.Retail30_Display__c==true){
                                uniqueDenorm.RETAIL30_Y2_Percentage__c      = rb.Retail_30_1__c;
                            }
                            if(rb.Retail90_Display__c==true){
                                uniqueDenorm.RETAIL90_Y2_Percentage__c      = rb.Retail_90_1__c;
                            }
                            if(rb.Maintenance_Choice_Display__c==true){
                                uniqueDenorm.MCHOICE_Y2_Percentage__c       = rb.Mchoice_1__c;
                            }
                            if(rb.Mail_Display__c==true){
                                uniqueDenorm.MAIL_Y2_Percentage__c          = rb.Mail_1__c;
                            }
                            if(rb.ClientOwned30_Display__c==true){
                                uniqueDenorm.CLIENTOWNED30_Y2_Percentage__c = rb.Client_Owned_30_1__c;
                            }
                            if(rb.ClientOwned90_Display__c==true){
                                uniqueDenorm.CLIENTOWNED90_Y2_Percentage__c = rb.Client_Owned_90_1__c;
                            }
                            uniqueDenorm.Basis_Y2__c     = rb.Basis__c;
                            uniqueDenorm.Plan_Year_Y2__c = rb.Plan_Year__c;
                            uniqueDenorm.SPECIALTY_RETAIL_Y2_Percentage__c = rb.Specialty_Retail_1__c;
                            uniqueDenorm.Template_Mail_Text_Y2__c=rb.Template_Mail_Label_Text__c;
                            //uniqueDenorm.Retail_30_Display_Y2__c=rb.Template_Retail30_Display__c;
                            //uniqueDenorm.Retail_90_Display_Y2__c=rb.Template_Retail90_Display__c;
                            if(rb.Show_in_Non_Specialty_Grid__c==true){
                                uniqueDenorm.Grid2__c = rb.Grid_flag__c;
                            }
                            if(rb.Retail_Display__c==true){
                                uniqueDenorm.RETAIL_Y2_Percentage__c=rb.Retail_30_1__c;
                            }
                            if(rb.ClientOwned_Display__c==true){
                                uniqueDenorm.CLIENTOWNED_Y2_Percentage__c=rb.Client_Owned_30_1__c;
                            }
                            
                            // field mapping for Speciality formulary
                            if(rb.Specialty_1__c!=null){
                                denormObj.SPECIALTY_Y2_Percentage__c        = rb.Specialty_1__c;
                                
                                denormObj.Basis_Y2__c       = rb.Basis__c;
                                denormObj.Plan_Year_Y2__c   = rb.Plan_Year__c;
                                denormObj.Specialty_Grid__c = true;
                            }
                            
                            
                        }else{
                            if(rb.Retail30_Display__c==true){
                                uniqueDenorm.RETAIL30_Y2__c = rb.Retail_30__c;
                            }
                            if(rb.Retail90_Display__c==true){
                                uniqueDenorm.RETAIL90_Y2__c   = rb.Retail_90__c;
                            }
                            if(rb.Mail_Display__c==true){
                                uniqueDenorm.MAILY2__c      = rb.Mail__c;
                            }
                            if(rb.Maintenance_Choice_Display__c==true){
                                uniqueDenorm.MCHOICEY2__c   = rb.Mchoice__c;
                            }
                            if(rb.ClientOwned30_Display__c==true){
                                uniqueDenorm.CLIENT_OWNED30_Y2__c = rb.Client_Owned_30__c;
                            }
                            if(rb.ClientOwned90_Display__c==true){
                                uniqueDenorm.CLIENT_OWNED90_Y2__c = rb.Client_Owned_90__c;
                            }
                            uniqueDenorm.Basis_Y2__c = rb.Basis__c;
                            uniqueDenorm.Plan_Year_Y2__c = rb.Plan_Year__c;
                            uniqueDenorm.SPECIALTY_RETAIL_Y2__c = rb.Specialty_Retail__c;
                            uniqueDenorm.Template_Mail_Text_Y2__c=rb.Template_Mail_Label_Text__c;
                            //uniqueDenorm.Retail_30_Display_Y2__c=rb.Template_Retail30_Display__c;
                            //uniqueDenorm.Retail_90_Display_Y2__c=rb.Template_Retail90_Display__c;
                            if(rb.Show_in_Non_Specialty_Grid__c==true){
                                uniqueDenorm.Grid2__c = rb.Grid_flag__c;
                            }
                            if(rb.Retail_Display__c==true){
                                uniqueDenorm.RETAIL_Y2__c=rb.Retail_30__c;
                            }
                            if(rb.ClientOwned_Display__c==true){
                                uniqueDenorm.CLIENT_OWNED_Y2__c=rb.Client_Owned_30__c;
                            }
                            // field mapping for Speciality formulary
                            if(rb.Specialty__c!=null){
                                denormObj.SPECIALTYY2__c         = rb.Specialty__c;
                                
                                denormObj.Specialty_Grid__c = true;
                                denormObj.Plan_Year_Y2__c   = rb.Plan_Year__c;
                                denormObj.Basis_Y2__c       = rb.Basis__c;
                            }
                            
                        }
                    }   
                    if(rb.Year__c == '3'){
                        
                        if(rb.Percentage_Check__c == true){
                            if(rb.Retail30_Display__c==true){
                                uniqueDenorm.RETAIL30_Y3_Percentage__c  = rb.Retail_30_1__c;
                            }
                            if(rb.Retail90_Display__c==true){
                                uniqueDenorm.RETAIL90_Y3_Percentage__c  = rb.Retail_90_1__c;
                            }
                            if(rb.Maintenance_Choice_Display__c==true){
                                uniqueDenorm.MCHOICE_Y3_Percentage__c   = rb.Mchoice_1__c;
                            }
                            if(rb.Mail_Display__c==true){
                                uniqueDenorm.MAIL_Y3_Percentage__c      = rb.Mail_1__c;
                            }
                            if(rb.ClientOwned30_Display__c==true){
                                uniqueDenorm.CLIENTOWNED30_Y3_Percentage__c = rb.Client_Owned_30_1__c;
                            }
                            if(rb.ClientOwned90_Display__c==true){
                                uniqueDenorm.CLIENTOWNED90_Y3_Percentage__c = rb.Client_Owned_90_1__c;
                            }
                            uniqueDenorm.Basis_Y3__c     = rb.Basis__c;
                            uniqueDenorm.Plan_Year_Y3__c = rb.Plan_Year__c;
                            uniqueDenorm.SPECIALTY_RETAIL_Y3_Percentage__c = rb.Specialty_Retail_1__c;
                            uniqueDenorm.Template_Mail_Text_Y3__c=rb.Template_Mail_Label_Text__c;
                            //uniqueDenorm.Retail_30_Display_Y3__c=rb.Template_Retail30_Display__c;
                            //uniqueDenorm.Retail_90_Display_Y3__c=rb.Template_Retail90_Display__c;
                            if(rb.Show_in_Non_Specialty_Grid__c==true){
                                uniqueDenorm.Grid3__c = rb.Grid_flag__c;
                            }
                            if(rb.Retail_Display__c==true){
                                uniqueDenorm.RETAIL_Y3_Percentage__c=rb.Retail_30_1__c;
                            }
                            if(rb.ClientOwned_Display__c==true){
                                uniqueDenorm.CLIENTOWNED_Y3_Percentage__c=rb.Client_Owned_30_1__c;
                            }
                            // field mapping for Speciality formulary
                            if(rb.Specialty_1__c!=null){
                                denormObj.SPECIALTY_Y3_Percentage__c        = rb.Specialty_1__c;
                                denormObj.Basis_Y3__c       = rb.Basis__c;
                                denormObj.Plan_Year_Y3__c   = rb.Plan_Year__c;
                                denormObj.Specialty_Grid__c = true;
                            }
                            
                            
                        }else{
                            if(rb.Retail30_Display__c==true){
                                uniqueDenorm.RETAIL30_Y3__c = rb.Retail_30__c;
                            }
                            if(rb.Retail90_Display__c==true){
                                uniqueDenorm.RETAIL90_Y3__c   = rb.Retail_90__c;
                            }
                            if(rb.Mail_Display__c==true){
                                uniqueDenorm.MAILY3__c      = rb.Mail__c;
                            }
                            if(rb.Maintenance_Choice_Display__c==true){
                                uniqueDenorm.MCHOICEY3__c   = rb.Mchoice__c;
                            }
                            if(rb.ClientOwned30_Display__c==true){
                                uniqueDenorm.CLIENT_OWNED30_Y3__c = rb.Client_Owned_30__c;
                            }
                            if(rb.ClientOwned90_Display__c==true){
                                uniqueDenorm.CLIENT_OWNED90_Y3__c = rb.Client_Owned_90__c;
                            }
                            uniqueDenorm.Basis_Y3__c     = rb.Basis__c;
                            uniqueDenorm.Plan_Year_Y3__c = rb.Plan_Year__c;
                            uniqueDenorm.SPECIALTY_RETAIL_Y3__c  = rb.Specialty_Retail__c;
                            uniqueDenorm.Template_Mail_Text_Y3__c=rb.Template_Mail_Label_Text__c;
                            //uniqueDenorm.Retail_30_Display_Y3__c=rb.Template_Retail30_Display__c;
                            //uniqueDenorm.Retail_90_Display_Y3__c=rb.Template_Retail90_Display__c;
                            if(rb.Show_in_Non_Specialty_Grid__c==true){
                                uniqueDenorm.Grid3__c = rb.Grid_flag__c;
                            }
                            if(rb.Retail_Display__c==true){
                                uniqueDenorm.RETAIL_Y3__c=rb.Retail_30__c;
                                
                            }
                            if(rb.ClientOwned_Display__c==true){
                                uniqueDenorm.CLIENT_OWNED_Y3__c=rb.Client_Owned_30__c;
                            }
                            // field mapping for Speciality formulary
                            if(rb.Specialty__c!=null){
                                denormObj.SPECIALTY_Y3__c         = rb.Specialty__c;
                                denormObj.Basis_Y3__c     = rb.Basis__c;
                                denormObj.Plan_Year_Y3__c = rb.Plan_Year__c;
                                denormObj.Specialty_Grid__c = true;
                            }
                            
                            
                        }
                    }
                    if(rb.Year__c == '4'){
                        
                        if(rb.Percentage_Check__c == true){
                            if(rb.Retail30_Display__c==true){
                                uniqueDenorm.RETAIL30_Y4_Percentage__c    = rb.Retail_30_1__c;
                            }
                            if(rb.Retail90_Display__c==true){
                                uniqueDenorm.RETAIL90_Y4_Percentage__c      = rb.Retail_90_1__c;
                            }
                            if(rb.Maintenance_Choice_Display__c==true){
                                uniqueDenorm.MCHOICE_Y4_Percentage__c       = rb.Mchoice_1__c;
                            }
                            if(rb.Mail_Display__c==true){
                                uniqueDenorm.MAIL_Y4_Percentage__c          = rb.Mail_1__c;
                            }
                            if(rb.ClientOwned30_Display__c==true){
                                uniqueDenorm.CLIENTOWNED30_Y4_Percentage__c = rb.Client_Owned_30_1__c;
                            }
                            if(rb.ClientOwned90_Display__c==true){
                                uniqueDenorm.CLIENTOWNED90_Y4_Percentage__c = rb.Client_Owned_90_1__c;
                            }
                            uniqueDenorm.Basis_Y4__c     = rb.Basis__c;
                            uniqueDenorm.Plan_Year_Y4__c = rb.Plan_Year__c;
                            uniqueDenorm.SPECIALTY_RETAIL_Y4_Percentage__c = rb.Specialty_Retail_1__c;
                            //uniqueDenorm.Retail_30_Display_Y4__c=rb.Template_Retail30_Display__c;
                            uniqueDenorm.Template_Mail_Text_Y4__c=rb.Template_Mail_Label_Text__c;
                            //uniqueDenorm.Retail_90_Display_Y4__c=rb.Template_Retail90_Display__c;
                            if(rb.Show_in_Non_Specialty_Grid__c==true){
                                uniqueDenorm.Grid4__c = rb.Grid_flag__c;
                            }
                            
                            if(rb.Retail_Display__c==true){
                                uniqueDenorm.RETAIL_Y4_Percentage__c=rb.Retail_30_1__c;
                            }
                            if(rb.ClientOwned_Display__c==true){
                                uniqueDenorm.CLIENTOWNED_Y4_Percentage__c=rb.Client_Owned_30_1__c;
                            }
                            // field mapping for Speciality formulary
                            if(rb.Specialty_1__c!=null){
                                denormObj.SPECIALTY_Y4_Percentage__c        = rb.Specialty_1__c;
                                denormObj.SPECIALTY_RETAIL_Y4_Percentage__c = rb.Specialty_Retail_1__c;
                                denormObj.Basis_Y4__c       = rb.Basis__c;
                                denormObj.Plan_Year_Y4__c   = rb.Plan_Year__c;
                                denormObj.Specialty_Grid__c = true;
                            }
                            
                            
                        }else{
                            if(rb.Retail30_Display__c==true){
                                uniqueDenorm.RETAIL30_Y4__c     = rb.Retail_30__c;
                            }
                            if(rb.Retail90_Display__c==true){
                                uniqueDenorm.RETAIL90_Y4__c       = rb.Retail_90__c;
                            }
                            if(rb.Mail_Display__c==true){
                                uniqueDenorm.MAILY4__c          = rb.Mail__c;
                            }
                            if(rb.Maintenance_Choice_Display__c==true){
                                uniqueDenorm.MCHOICEY4__c       = rb.Mchoice__c;
                            }
                            if(rb.ClientOwned30_Display__c==true){
                                uniqueDenorm.CLIENT_OWNED30_Y4__c = rb.Client_Owned_30__c;
                            }
                            if(rb.ClientOwned90_Display__c==true){
                                uniqueDenorm.CLIENT_OWNED90_Y4__c = rb.Client_Owned_90__c;
                            }
                            uniqueDenorm.Basis_Y4__c     = rb.Basis__c;
                            uniqueDenorm.Plan_Year_Y4__c = rb.Plan_Year__c;
                            uniqueDenorm.SPECIALTY_RETAIL_Y4__c  = rb.Specialty_Retail__c;
                            uniqueDenorm.Template_Mail_Text_Y4__c=rb.Template_Mail_Label_Text__c;
                            //uniqueDenorm.Retail_30_Display_Y4__c=rb.Template_Retail30_Display__c;
                            //uniqueDenorm.Retail_90_Display_Y4__c=rb.Template_Retail90_Display__c;
                            if(rb.Show_in_Non_Specialty_Grid__c==true){
                                uniqueDenorm.Grid4__c = rb.Grid_flag__c;
                            }
                            if(rb.Retail_Display__c==true){
                                uniqueDenorm.RETAIL_Y4__c=rb.Retail_30__c;
                            }
                            if(rb.ClientOwned_Display__c==true){
                                uniqueDenorm.CLIENT_OWNED_Y4__c=rb.Client_Owned_30__c;
                            }
                            
                            // field mapping for Speciality formulary 
                            if(rb.Specialty__c!=null){
                                denormObj.SPECIALTY_Y4__c         = rb.Specialty__c;
                                denormObj.Specialty_Grid__c       = true;
                                denormObj.Basis_Y4__c = rb.Basis__c;
                                denormObj.Plan_Year_Y4__c = rb.Plan_Year__c;
                            }
                            
                        }
                        
                    }
                    if(rb.Year__c == '5'){
                        
                        if(rb.Percentage_Check__c == true){ 
                            if(rb.Retail30_Display__c==true){  
                                uniqueDenorm.RETAIL30_Y5_Percentage__c      = rb.Retail_30_1__c;
                            }
                            if(rb.Retail90_Display__c==true){
                                uniqueDenorm.RETAIL90_Y5_Percentage__c      = rb.Retail_90_1__c;
                            }
                            if(rb.Maintenance_Choice_Display__c==true){
                                uniqueDenorm.MCHOICE_Y5_Percentage__c       = rb.Mchoice_1__c;
                            }
                            if(rb.Mail_Display__c==true){
                                uniqueDenorm.MAIL_Y5_Percentage__c          = rb.Mail_1__c;
                            }
                            if(rb.ClientOwned30_Display__c==true){
                                uniqueDenorm.CLIENTOWNED30_Y5_Percentage__c = rb.Client_Owned_30_1__c;
                            }
                            if(rb.ClientOwned90_Display__c==true){
                                uniqueDenorm.CLIENTOWNED90_Y5_Percentage__c = rb.Client_Owned_90_1__c;
                            }
                            uniqueDenorm.Basis_Y5__c     = rb.Basis__c;
                            uniqueDenorm.Plan_Year_Y5__c = rb.Plan_Year__c;
                            uniqueDenorm.Template_Mail_Text_Y5__c=rb.Template_Mail_Label_Text__c;
                            //uniqueDenorm.Retail_30_Display_Y5__c=rb.Template_Retail30_Display__c;
                            //uniqueDenorm.Retail_90_Display_Y5__c=rb.Template_Retail90_Display__c;
                            if(rb.Show_in_Non_Specialty_Grid__c==true){
                                uniqueDenorm.Grid5__c = rb.Grid_flag__c;
                            }
                            uniqueDenorm.SPECIALTY_RETAIL_Y5_Percentage__c = rb.Specialty_Retail_1__c;
                            if(rb.Retail_Display__c==true){
                                uniqueDenorm.RETAIL_Y5_Percentage__c=rb.Retail_30_1__c;
                            }
                            if(rb.ClientOwned_Display__c==true){
                                uniqueDenorm.CLIENTOWNED_Y5_Percentage__c=rb.Client_Owned_30_1__c;
                            }
                            
                            // field mapping for Speciality formulary
                            if(rb.Specialty_1__c!=null){
                                denormObj.SPECIALTY_Y5_Percentage__c        = rb.Specialty_1__c;
                                denormObj.Basis_Y5__c = rb.Basis__c;
                                denormObj.Specialty_Grid__c=true;
                                denormObj.Plan_Year_Y5__c = rb.Plan_Year__c;
                            }
                            
                            
                        }else{
                            if(rb.Retail30_Display__c==true){ 
                                uniqueDenorm.RETAIL30_Y5__c = rb.Retail_30__c;
                            }
                            if(rb.Retail90_Display__c==true){
                                uniqueDenorm.RETAIL90Y5__c   = rb.Retail_90__c;
                            }
                            if(rb.Mail_Display__c==true){
                                uniqueDenorm.MAILY5__c      = rb.Mail__c;
                            }
                            if(rb.Maintenance_Choice_Display__c==true){
                                uniqueDenorm.MCHOICEY5__c   = rb.Mchoice__c;
                            }
                            if(rb.ClientOwned30_Display__c==true){
                                uniqueDenorm.CLIENT_OWNED30_Y5__c = rb.Client_Owned_30__c;
                            }
                            if(rb.ClientOwned90_Display__c==true){
                                uniqueDenorm.CLIENT_OWNED90_Y5__c=rb.Client_Owned_90__c;
                            }
                            uniqueDenorm.Basis_Y5__c      = rb.Basis__c;
                            uniqueDenorm.Plan_Year_Y5__c = rb.Plan_Year__c;
                            uniqueDenorm.SPECIALTY_RETAIL_Y5__c  = rb.Specialty_Retail__c;
                            uniqueDenorm.Template_Mail_Text_Y5__c=rb.Template_Mail_Label_Text__c;
                            //uniqueDenorm.Retail_30_Display_Y5__c=rb.Template_Retail30_Display__c;
                            //uniqueDenorm.Retail_90_Display_Y5__c=rb.Template_Retail90_Display__c;
                            if(rb.Show_in_Non_Specialty_Grid__c==true){
                                uniqueDenorm.Grid5__c = rb.Grid_flag__c;
                            }
                            if(rb.Retail_Display__c==true){
                                uniqueDenorm.RETAIL_Y5__c=rb.Retail_30__c;
                            }
                            if(rb.ClientOwned_Display__c==true){
                                uniqueDenorm.CLIENT_OWNED_Y5__c=rb.Client_Owned_30__c;
                            }
                            
                            // field mapping for Speciality formulary 
                            if(rb.Specialty__c!=null){
                                denormObj.SPECIALTY_Y4__c         = rb.Specialty__c;
                                denormObj.Specialty_Grid__c       = true; 
                                denormObj.Basis_Y5__c = rb.Basis__c;
                                denormObj.Plan_Year_Y5__c   = rb.Plan_Year__c;
                            }
                            
                        }
                    }
                    
                    if(rb.Year__c == 'All'){
                        
                        if(rb.Percentage_Check__c == true){
                            if(rb.Retail30_Display__c==true){
                                uniqueDenorm.RETAIL30_Y6_Percentage__c     = rb.Retail_30_1__c;
                            }
                            if(rb.Retail90_Display__c==true){
                                uniqueDenorm.RETAIL90_Y6_Percentage__c      = rb.Retail_90_1__c;
                            }
                            if(rb.Maintenance_Choice_Display__c==true){
                                uniqueDenorm.MCHOICE_Y6_Percentage__c       = rb.Mchoice_1__c;
                            }
                            if(rb.Mail_Display__c==true){
                                uniqueDenorm.MAIL_Y6_Percentage__c          = rb.Mail_1__c;
                            }
                            if(rb.ClientOwned30_Display__c==true){
                                uniqueDenorm.CLIENTOWNED30_Y6_Percentage__c = rb.Client_Owned_30_1__c;
                            }
                            if(rb.ClientOwned90_Display__c==true){
                                uniqueDenorm.CLIENTOWNED90_Y6_Percentage__c = rb.Client_Owned_90_1__c;
                            }
                            uniqueDenorm.Basis_Y6__c     = rb.Basis__c;
                            uniqueDenorm.Template_Mail_Text_Y6__c=rb.Template_Mail_Label_Text__c;
                            //uniqueDenorm.Retail_30_Display_Y6__c=rb.Template_Retail30_Display__c;
                            //uniqueDenorm.Retail_90_Display_Y6__c=rb.Template_Retail90_Display__c;
                            if(rb.Show_in_Non_Specialty_Grid__c==true){
                                uniqueDenorm.Grid6__c = rb.Grid_flag__c;
                            }
                            uniqueDenorm.SPECIALTY_RETAIL_Y6_Percentage__c = rb.Specialty_Retail_1__c;
                            if(rb.Retail_Display__c==true){
                                uniqueDenorm.RETAIL_Y6_Percentage__c=rb.Retail_30_1__c;
                            }
                            if(rb.ClientOwned_Display__c==true){
                                uniqueDenorm.CLIENTOWNED_Y6_Percentage__c=rb.Client_Owned_30_1__c;
                            }
                            
                            // field mapping for Speciality formulary
                            if(rb.Specialty_1__c!=null){
                                denormObj.SPECIALTY_Y6_Percentage__c        = rb.Specialty_1__c;
                                
                                denormObj.Basis_Y6__c       = rb.Basis__c;
                                denormObj.Specialty_Grid__c = true;
                            }
                            
                            
                        }else{
                            if(rb.Retail30_Display__c==true){
                                uniqueDenorm.RETAIL30_Y6__c = rb.Retail_30__c;
                            }
                            if(rb.Retail90_Display__c==true){
                                uniqueDenorm.RETAIL90Y6__c = rb.Retail_90__c;
                            }
                            if(rb.Mail_Display__c==true){
                                uniqueDenorm.MAILY6__c      = rb.Mail__c;
                            }
                            if(rb.Maintenance_Choice_Display__c==true){
                                uniqueDenorm.MCHOICEY6__c   = rb.Mchoice__c;
                            }
                            if(rb.ClientOwned30_Display__c==true){
                                uniqueDenorm.CLIENT_OWNED30_Y6__c = rb.Client_Owned_30__c;
                            }
                            if(rb.ClientOwned90_Display__c==true){
                                uniqueDenorm.CLIENT_OWNED90_Y6__c = rb.Client_Owned_90__c;
                            }
                            uniqueDenorm.Basis_Y6__c     = rb.Basis__c;
                            uniqueDenorm.SPECIALTY_RETAIL_Y6__c = rb.Specialty_Retail__c;
                            uniqueDenorm.Template_Mail_Text_Y6__c=rb.Template_Mail_Label_Text__c;
                            //uniqueDenorm.Retail_30_Display_Y6__c=rb.Template_Retail30_Display__c;
                            //uniqueDenorm.Retail_90_Display_Y6__c=rb.Template_Retail90_Display__c;
                            if(rb.Show_in_Non_Specialty_Grid__c==true){
                                uniqueDenorm.Grid6__c = rb.Grid_flag__c;
                            }
                            if(rb.Retail_Display__c==true){
                                uniqueDenorm.RETAIL_Y6__c=rb.Retail_30__c;
                            }
                            if(rb.ClientOwned_Display__c==true){
                                uniqueDenorm.CLIENT_OWNED_Y6__c=rb.Client_Owned_30__c;
                            }
                            
                            // field mapping for Speciality formulary
                            if(rb.Specialty__c!=null){
                                denormObj.SPECIALTY_Y6__c         = rb.Specialty__c;
                                denormObj.Specialty_Grid__c = true;
                                denormObj.Basis_Y6__c       = rb.Basis__c;
                            }
                            
                        }   
                    }                      
                    
                    uniqueDenorm.Sequence_Number__c = rb.Sequence_Number__c;
                    uniqueDenorm.Rebate_Operations__c       = rb.Rebate_Operations__c;
                    uniqueDenorm.Non_Specialty_Grid__c      = true;
                    uniqueDenorm.LOB__c                     = rb.LOB2__c;
                    uniqueDenorm.GSTP__c                    = rb.GSTP__c;
                    uniqueDenorm.Plan_Design__c             = rb.rebate_Modeled_Non_Specialty_PlanDe_New__c;
                    uniqueDenorm.Non_Specialty_Formulary__c = rb.Non_Specialty_Formulary_2__c;
                    uniqueDenorm.Specialty_Formulary__c     = rb.Specialty_Formulary__c;
                    uniqueDenorm.FAF__c                     = lstali.PCD_FAF__c;
                    uniqueDenorm.Agreement_Line_Item__c     =rb.Agreement_Line_Item__c;
                    uniqueDenorm.Agreement__c               =rb.Agreement__c;
                    uniqueDenorm.Modeled_Non_Specialty_Formulary_Name__c =rb.Modeled_Non_Specialty_Formulary_Name__c;    
                    uniqueDenorm.Modeled_Non_Specialty_PlanDesign__c=rb.Modeled_Non_Specialty_PlanDesign__c;
                    uniqueDenorm.Modeled_Specialty_Formulary_Name__c=rb.Modeled_Specialty_Formulary_Name__c;
                    uniqueDenorm.Percentage_Check__c=rb.Percentage_Check__c;
                    uniqueDenorm.Custom_Description__c=rb.Custom_Description__c;
                    uniqueDenorm.Agreement_Line_Item__c     =lstali.Id;  // Newly added for Multiple LOB
                    uniqueDenorm.Orginal_Agreement_Line_Item__c   = rb.Agreement_Line_Item__c;
                    uniqueDenorm.Orginal_FAF_ID__c          = rb.FAF_ID__c;   
                    uniqueDenorm.Multiple_LOB__c = true;  // Newly added for Multiple LOB
                    if(rb.Specialty_1__c!=null && rb.Percentage_Check__c==true){ 
                        denormObj.Rebate_Operations__c       = rb.Rebate_Operations__c;
                        denormObj.Specialty_Grid__c          = true;
                        denormObj.LOB__c                     = rb.LOB2__c;
                        denormObj.GSTP__c                    = rb.GSTP__c;
                        denormObj.Plan_Design__c             = rb.Plan_Design__c;
                        denormObj.Non_Specialty_Formulary__c = rb.Non_Specialty_Formulary_2__c;
                        denormObj.Specialty_Formulary__c     = rb.Specialty_Formulary__c;
                        denormObj.FAF__c                     = lstali.PCD_FAF__c;
                        denormObj.Agreement_Line_Item__c     =lstali.Id;
                        denormObj.Orginal_Agreement_Line_Item__c   = rb.Agreement_Line_Item__c;
                        denormObj.Orginal_FAF_ID__c          = rb.FAF_ID__c;    // Newly added for Multiple LOB
                        denormObj.Multiple_LOB__c = true;  // Newly added for Multiple LOB
                        denormObj.Agreement__c               =rb.Agreement__c;
                        denormObj.Specialty_Display_Name__c     =rb.Specialty_Display_Name__c;
                        denormObj.Modeled_Non_Specialty_Formulary_Name__c=rb.Modeled_Non_Specialty_Formulary_Name__c;    
                        denormObj.Modeled_Specialty_Formulary_Name__c=rb.Modeled_Specialty_Formulary_Name__c;
                        denormObj.Modeled_Non_Specialty_PlanDesign__c=rb.Modeled_Non_Specialty_PlanDesign__c;
                        denormObj.Percentage_Check__c=rb.Percentage_Check__c;
                        if(SortingMap.get(rb.Non_Specialty_Formulary_2__c)!=null ){
                            denormObj.SORT__c=SortingMap.get(rb.Non_Specialty_Formulary_2__c)+CounterSpec;
                        }
                        
                        denormObj.UniqueCheck__c=true;
                    }
                    if(rb.Specialty__c!=null && rb.Percentage_Check__c==false){
                        denormObj.Rebate_Operations__c       = rb.Rebate_Operations__c;
                        denormObj.Specialty_Grid__c          = true;
                        denormObj.LOB__c                     = rb.LOB2__c;
                        denormObj.GSTP__c                    = rb.GSTP__c;
                        denormObj.Plan_Design__c             = rb.Plan_Design__c;
                        denormObj.Non_Specialty_Formulary__c = rb.Non_Specialty_Formulary_2__c;
                        denormObj.Specialty_Formulary__c     = rb.Specialty_Formulary__c;
                        denormObj.FAF__c                     = lstali.PCD_FAF__c;
                        denormObj.Agreement_Line_Item__c     =lstali.Id;
                        denormObj.Orginal_Agreement_Line_Item__c  = rb.Agreement_Line_Item__c;
                        denormObj.Orginal_FAF_ID__c          = rb.FAF_ID__c;    // Newly added for Multiple LOB
                        denormObj.Multiple_LOB__c = true;  // Newly added for Multiple LOB
                        denormObj.Agreement__c               =rb.Agreement__c;
                        denormObj.Specialty_Display_Name__c     =rb.Specialty_Display_Name__c;
                        denormObj.Modeled_Non_Specialty_Formulary_Name__c=rb.Modeled_Non_Specialty_Formulary_Name__c;    
                        denormObj.Modeled_Specialty_Formulary_Name__c=rb.Modeled_Specialty_Formulary_Name__c;
                        denormObj.Modeled_Non_Specialty_PlanDesign__c=rb.Modeled_Non_Specialty_PlanDesign__c;
                        denormObj.Percentage_Check__c=rb.Percentage_Check__c;
                        if(SortingMap.get(rb.Non_Specialty_Formulary_2__c)!=null){
                            denormObj.SORT__c=SortingMap.get(rb.Non_Specialty_Formulary_2__c)+CounterSpec;
                        }
                        denormObj.UniqueCheck__c=true;
                    }
                    if(rb.Show_in_Non_Specialty_Grid__c==true ){
                        uniqueDenorm.Plan_Design__c=rb.rebate_Modeled_Non_Specialty_PlanDe_New__c;
                        uniqueDenorm.PCD_Aggregate_Rate__c=rb.PCD_Aggregate_Rate__c;
                        uniqueDenorm.UniqueCheck__c=rb.UniqueCheck__c;
                        uniqueDenorm.PCD_Same_dollar_and_Percentage_Value__c=rb.PCD_Same_dollar_and_Percentage_Value__c;
                        uniqueDenorm.SORT__c=rb.Sorting_Number__c;
                        //uniqueDenorm.Grid_flag__c=rb.Grid_flag__c;
                    }
                    
                    
                    
                    if(rb.PCD_Same_dollar_and_Percentage_Value__c==true){
                        NonSpecialtySet.add(rb.Non_Specialty_Formulary_2__c);
                        
                    }
                }//ends main if    
                CounterSpec=CounterSpec+1;                              
                
                lstToInsert.add(uniqueDenorm);
                
            }
            
            // offload the formulary records to lsttoInsert
            system.debug('formularyIdToDenormMap.values()'+formularyIdToDenormMap.values());
            if(formularyIdToDenormMap.values().size()>0){
                lstToInsert.addAll(formularyIdToDenormMap.values());
            }
            for(AggregateResult  aggr :result){
                Integer Counter=0;
                String NonSpec;
                for(Rebate_Guarantee_Denorm__c rbdeno:lstToInsert){
                    if(aggr.get('Key')==rbdeno.Non_Specialty_Formulary__c){
                        NonSpec=String.ValueOf(aggr.get('Key'));
                        
                        
                        if(counter==0 && rbdeno.Non_Specialty_Grid__c==true && (rbdeno.PCD_Same_dollar_and_Percentage_Value__c==true ||rbdeno.UniqueCheck__c==true)){
                            //rbdeno.Grid_flag__c=true;
                        }
                        //Retails 30 Display
                        if(rbdeno.Grid1__c==true||rbdeno.Grid2__c==true||rbdeno.Grid3__c==true||rbdeno.Grid4__c==true||rbdeno.Grid5__c==true||rbdeno.Grid6__c==true){
                            rbdeno.Grid_flag__c=true;
                        }
                        
                        if(rbdeno.RETAIL30_Y1_Percentage__c!=null||rbdeno.RETAIL30_Y2_Percentage__c!=null||rbdeno.RETAIL30_Y3_Percentage__c!=null||rbdeno.RETAIL30_Y4_Percentage__c!=null
                           ||rbdeno.RETAIL30_Y5_Percentage__c!=null ||rbdeno.RETAIL30_Y6_Percentage__c!=null||rbdeno.RETAIL30_Y1__c!=null||rbdeno.RETAIL30_Y2__c!=null
                           ||rbdeno.RETAIL30_Y3__c!=null||rbdeno.RETAIL30_Y4__c!=null||rbdeno.RETAIL30_Y5__c!=null||rbdeno.RETAIL30_Y6__c!=null){
                               rbdeno.Template_Retail30_Display__c=true;
                               
                           }           
                        
                        //Retails 90 display
                        if(rbdeno.RETAIL90_Y1_Percentage__c!=null||rbdeno.RETAIL90_Y2_Percentage__c!=null||rbdeno.RETAIL90_Y3_Percentage__c!=null||rbdeno.RETAIL90_Y4_Percentage__c!=null
                           ||rbdeno.RETAIL90_Y5_Percentage__c!=null ||rbdeno.RETAIL90_Y6_Percentage__c!=null||rbdeno.RETAIL90_Y1__c!=null||rbdeno.RETAIL90_Y2__c!=null
                           ||rbdeno.RETAIL90_Y3__c!=null||rbdeno.RETAIL90_Y4__c!=null|| rbdeno.RETAIL90Y5__c!=null||rbdeno.RETAIL90Y6__c!=null){
                               rbdeno.Template_Retail90_Display__c=true;
                           }
                        //Mchoice Display
                        if(rbdeno.MCHOICE_Y1_Percentage__c!=null||rbdeno.MCHOICE_Y2_Percentage__c!=null||rbdeno.MCHOICE_Y3_Percentage__c!=null||rbdeno.MCHOICE_Y4_Percentage__c!=null
                           ||rbdeno.MCHOICE_Y5_Percentage__c!=null ||rbdeno.MCHOICE_Y6_Percentage__c!=null||rbdeno.MCHOICEY1__c!=null||rbdeno.MCHOICEY2__c!=null
                           ||rbdeno.MCHOICEY3__c!=null||rbdeno.MCHOICEY4__c!=null|| rbdeno.MCHOICEY5__c!=null||rbdeno.MCHOICEY6__c!=null){
                               rbdeno.Template_Mchoice_Display__c=true;
                           }
                        //Mail Display
                        if(rbdeno.MAIL_Y1_Percentage__c!=null||rbdeno.MAIL_Y2_Percentage__c!=null||rbdeno.MAIL_Y3_Percentage__c!=null||rbdeno.MAIL_Y4_Percentage__c!=null
                           ||rbdeno.MAIL_Y5_Percentage__c!=null ||rbdeno.MAIL_Y6_Percentage__c!=null||rbdeno.MAILY1__c!=null||rbdeno.MAILY2__c!=null
                           ||rbdeno.MAILY3__c!=null||rbdeno.MAILY4__c!=null|| rbdeno.MAILY5__c!=null||rbdeno.MAILY6__c!=null){
                               rbdeno.Template_Mail_Display__c=true;
                           }
                        //Client Owned30 Display
                        if(rbdeno.CLIENTOWNED30_Y1_Percentage__c!=null||rbdeno.CLIENTOWNED30_Y2_Percentage__c!=null||rbdeno.CLIENTOWNED30_Y3_Percentage__c!=null||rbdeno.CLIENTOWNED30_Y4_Percentage__c!=null
                           ||rbdeno.CLIENTOWNED30_Y5_Percentage__c!=null ||rbdeno.CLIENTOWNED30_Y6_Percentage__c!=null||rbdeno.CLIENT_OWNED30_Y1__c!=null||rbdeno.CLIENT_OWNED30_Y2__c!=null
                           ||rbdeno.CLIENT_OWNED30_Y3__c!=null||rbdeno.CLIENT_OWNED30_Y4__c!=null|| rbdeno.CLIENT_OWNED30_Y5__c!=null||rbdeno.CLIENT_OWNED30_Y6__c!=null){
                               rbdeno.Template_ClientOwned30_Display__c=true;
                           }
                        //Client Owned90 Display
                        if(rbdeno.CLIENTOWNED90_Y1_Percentage__c!=null||rbdeno.CLIENTOWNED90_Y2_Percentage__c!=null||rbdeno.CLIENTOWNED90_Y3_Percentage__c!=null||rbdeno.CLIENTOWNED90_Y4_Percentage__c!=null
                           ||rbdeno.CLIENTOWNED90_Y5_Percentage__c!=null ||rbdeno.CLIENTOWNED90_Y6_Percentage__c!=null||rbdeno.CLIENT_OWNED90_Y1__c!=null||rbdeno.CLIENT_OWNED90_Y2__c!=null
                           ||rbdeno.CLIENT_OWNED90_Y3__c!=null||rbdeno.CLIENT_OWNED90_Y4__c!=null|| rbdeno.CLIENT_OWNED90_Y5__c!=null||rbdeno.CLIENT_OWNED90_Y6__c!=null){
                               rbdeno.Template_ClientOwned90_Display__c=true;
                           }
                        //Specialty at Retails Display 
                        if(rbdeno.SPECIALTY_RETAIL_Y1_Percentage__c!=null||rbdeno.SPECIALTY_RETAIL_Y2_Percentage__c!=null||rbdeno.SPECIALTY_RETAIL_Y3_Percentage__c!=null||rbdeno.SPECIALTY_RETAIL_Y4_Percentage__c!=null
                           ||rbdeno.SPECIALTY_RETAIL_Y5_Percentage__c!=null ||rbdeno.SPECIALTY_RETAIL_Y6_Percentage__c!=null||rbdeno.SPECIALTY_RETAIL_Y1__c!=null||rbdeno.SPECIALTY_RETAIL_Y2__c !=null  
                           ||rbdeno.SPECIALTY_RETAIL_Y3__c!=null||rbdeno.SPECIALTY_RETAIL_Y4__c!=null|| rbdeno.SPECIALTY_RETAIL_Y5__c!=null||rbdeno.SPECIALTY_RETAIL_Y6__c!=null){
                               rbdeno.Template_SpecialtyatRetail_Display__c=true;
                           }
                        // Specialty Display
                        if(rbdeno.SPECIALTY_Y1_Percentage__c!=null||rbdeno.SPECIALTY_Y2_Percentage__c!=null||rbdeno.SPECIALTY_Y3_Percentage__c!=null||rbdeno.SPECIALTY_Y4_Percentage__c!=null
                           ||rbdeno.SPECIALTY_Y5_Percentage__c!=null ||rbdeno.SPECIALTY_Y6_Percentage__c!=null||rbdeno.SPECIALTYY1__c!=null||rbdeno.SPECIALTYY2__c!=null 
                           ||rbdeno.SPECIALTY_Y3__c!=null||rbdeno.SPECIALTY_Y4__c!=null|| rbdeno.SPECIALTY_Y5__c!=null||rbdeno.SPECIALTY_Y6__c!=null){
                               rbdeno.Template_SpecialtyatCVS_Display__c=true;
                           }
                        // Client Owned Displayed
                        if(rbdeno.CLIENTOWNED_Y1_Percentage__c!=null||rbdeno.CLIENTOWNED_Y2_Percentage__c!=null||rbdeno.CLIENTOWNED_Y3_Percentage__c!=null||rbdeno.CLIENTOWNED_Y4_Percentage__c!=null
                           ||rbdeno.CLIENTOWNED_Y5_Percentage__c!=null ||rbdeno.CLIENTOWNED_Y6_Percentage__c!=null||rbdeno.CLIENT_OWNED_Y1__c!=null||rbdeno.CLIENT_OWNED_Y2__c!=null 
                           ||rbdeno.CLIENT_OWNED_Y3__c!=null||rbdeno.CLIENT_OWNED_Y4__c!=null|| rbdeno.CLIENT_OWNED_Y5__c!=null||rbdeno.CLIENT_OWNED_Y6__c!=null){
                               rbdeno.Template_ClientOwned_Display__c=true;
                           }
                        //Retail Display
                        if(rbdeno.RETAIL_Y1_Percentage__c!=null||rbdeno.RETAIL_Y2_Percentage__c!=null||rbdeno.RETAIL_Y3_Percentage__c!=null||rbdeno.RETAIL_Y4_Percentage__c!=null
                           ||rbdeno.RETAIL_Y5_Percentage__c!=null ||rbdeno.RETAIL_Y6_Percentage__c!=null||rbdeno.RETAIL_Y1__c!=null||rbdeno.RETAIL_Y2__c!=null 
                           ||rbdeno.RETAIL_Y3__c!=null||rbdeno.RETAIL_Y4__c!=null|| rbdeno.RETAIL_Y5__c!=null||rbdeno.RETAIL_Y6__c!=null){
                               rbdeno.Template_Retail_Display__c=true;
                               
                               
                           }
                        //Populating Label Mail/Mchoice
                        if(rbdeno.Template_Mail_Text_Y1__c=='MAIL'||rbdeno.Template_Mail_Text_Y2__c=='MAIL'||rbdeno.Template_Mail_Text_Y3__c=='MAIL'||rbdeno.Template_Mail_Text_Y4__c=='MAIL'
                           ||rbdeno.Template_Mail_Text_Y5__c=='MAIL' ||rbdeno.Template_Mail_Text_Y6__c=='MAIL'){
                               rbdeno.Template_Mail_Label__c = 'MAIL';
                           }
                        else{
                            rbdeno.Template_Mail_Label__c = 'MAIL/MAINTENANCE CHOICE';
                            rbdeno.Template_Mchoice_Display__c=false;
                        }
                        if(rbdeno.PCD_Same_dollar_and_Percentage_Value__c==true){
                            rbdeno.UniqueCheck__c=false;
                        }
                        if(rbdeno.Non_Specialty_Grid__c==true && (rbdeno.PCD_Same_dollar_and_Percentage_Value__c==true ||rbdeno.UniqueCheck__c==true)){
                            Counter++;
                        }
                        if(rbdeno.Plan_Design__c==null||rbdeno.Plan_Design__c==''){
                            rbdeno.UniqueCheck__c=false;
                            rbdeno.PCD_Same_dollar_and_Percentage_Value__c=false;
                            rbdeno.Non_Specialty_Grid__c=false;
                        }
                        finalListToInsert.add(rbdeno); 
                    }
                    
                }
            }
            
            
            
            
        }
        if(!lstTodelete.isEmpty()){
            Database.delete(lstTodelete);   
        }
        if(!finalListToInsert.isEmpty()){
            insert finalListToInsert;
        }
           
       }    
      
     }
          
      catch(exception e)
        {
            throw new AuraHandledException(e.getMessage());
        }  
    
        } 
    
   }