/* =================================================================================
 * @Class Name        : Invoke_Template_Rebate_Grid
 * @author            : Mohit Srivastava
 * @created date      : 10/25/2019
 * @Purpose           : Sort Rebate Specialty formulary grid
=======================================================================================*/
public class Invoke_Rebate_Sort_Grid{
/* =================================================================================
 * @Class Name        : Invoke_Template_Rebate_Grid
 * @author            : Mohit Srivastava
 * @created date      : 10/25/2019
 * @Purpose           : Sort Rebate Specialty formulary grid
=======================================================================================*/
    @InvocableMethod
    public static void Invoke_Rebate_Sort_Grid_Method(List<id> objId)
    { 
        try
        {
                DeepCloneUtility.OFF_TRIGGERS_PROCBUILDER=false;
                Rebate_Guarantees__c[] ListRebate = new List<Rebate_Guarantees__c>();
                List<Rebate_Guarantees__c> UpdateRabteList = new List<Rebate_Guarantees__c>();
                Rebate_Guarantees__c[] ShowinNonSpecGrid = new List<Rebate_Guarantees__c>();
                Set<String> Duplicatecriteria = new Set<String>();
                Boolean RetailExist = false;
                List<Rebate_Guarantees__c> Rgeeupdate = new List<Rebate_Guarantees__c>();
                Map<String,String> newMapSortSort=new Map<String,String>();
                Map<String,String> newMapDupCheck=new Map<String,String>();
                Map<String,String> newUniqueCheck=new Map<String,String>();
                Map<String,String> mapGridFlag=new Map<String,String>();
                Integer counter;
                  
                //if(DeepCloneUtility.OFF_INVOCABLE_CLASS){
                PCD_FAF_Status__mdt FAFStatus = [SELECT Value__c FROM PCD_FAF_Status__mdt LIMIT 1]; 
                        List<string> FAFStat = new List<string>();
                        for(string s: FAFStatus.Value__c.split(','))
                              {
                                 FAFStat.add(s);
                              }        

                List<Rebate_Guarantees__c> Rgee =[SELECT ID,Name,Ranking__c,Rebate_Operations__c,Grid_Flag__c,PCD_Same_dollar_and_Percentage_Value__c,UniqueCheck__c,Rebate_Sorting_Order__c,Sorting_Number__c,FAF_ID__c,Pecentage_Guarantee__c,Year_Begin_Date__c,Year_End_Date__c,Invokable_Update__c,Year__c,Template_Non_Specialty_Grid_Name_Text__c,
                                                        LOB2__c,Plan_Design__c,GSTP__c,Batch_Update__c,Modeled_Non_Specialty_Formulary_Name__c,Modeled_Specialty_Formulary_Name__c,
                                                        Modeled_Non_Specialty_PlanDesign__c,Modeled_Specialty_PlanDesign__c,Template_Specialty_Grid_Name__c,Template_Non_Specialty_Grid_Name__c,Show_in_Non_Specialty_Grid__c,
                                                        Show_in_Specialty_Grid__c,Specialty_Formulary__c,Non_Specialty_Formulary_2__c, Template_ClientOwned30_Formula__c,Template_Clientowned30_Text__c,Template_ClientOwned90_Formula__c,
                                                        Template_Clientowned90_Text__c,Template_Clientowned_Text__c,Template_Mail_Formula__c,Template_Mail_Label__c,Template_Mail_Text__c,Template_Mchoice_Formula__c,Template_Mchoice_Text__c,
                                                        Template_Non_Specialty_Plan_Design__c,Template_Retail30_Formula__c,Template_Retail30_Text__c,Template_Retail90_Formula__c,Template_Retail90_Text__c,Template_Retail_Text__c,
                                                        Template_SpecialtyatCVS_Text__c,Template_SpecialtyatRetail_Formula__c,Template_SpecialtyatRetail_Text__c,Template_Specialty_Carveout_Label_Text__c, Template_Specialty_Carveout_Text__c,
                                                        Template_Specialty_Formula__c,Template_Specialty_Grid_Name_Text__c,Template_Specialty_Plan_Design__c,ClientOwned30_Display__c, ClientOwned90_Display__c,
                                                        ClientOwned_Display__c,Mail_Display__c,Maintenance_Choice_Display__c,Retail30_Display__c,Retail90_Display__c,Retail_Display__c,SpecialtyatRetail_Display__c,Specialty_Display__c,
                                                        Template_Retail_Display__c,Template_Retail30_Display__c,Template_Retail90_Display__c,Template_ClientOwned_Display__c,Template_ClientOwned30_Display__c,Template_ClientOwned90_Display__c,
                                                        Template_Mail_Display__c,Template_Mchoice_Display__c,Template_SpecialtyatRetail_Display__c,Template_SpecialtyatCVS_Display__c,Template_Rcurve_Display__c
                                                        FROM Rebate_Guarantees__c WHERE FAF_ID__r.FAF_Status__c IN:FAFStat AND Rebate_Operations__c IN:objId AND (PCD_Same_dollar_and_Percentage_Value__c = true OR UniqueCheck__c= true OR Template_SpecialtyatCVS_Display__c = true)
                                                        order by Template_Non_Specialty_Grid_Name__c,Grid_Flag__c Desc ];
                    
                for(Rebate_Guarantees__c rg: Rgee)
                {
                counter=0;
                   if(rg.UniqueCheck__c==true || rg.PCD_Same_dollar_and_Percentage_Value__c==true || rg.Template_SpecialtyatCVS_Display__c==true)
                    {
                    newMapSortSort.put(rg.Plan_Design__c+rg.GSTP__c+rg.Non_Specialty_Formulary_2__c,rg.Rebate_Sorting_Order__c);
                    }
                    if(rg.PCD_Same_dollar_and_Percentage_Value__c==true ){
                    newMapDupCheck.put(rg.Plan_Design__c+rg.GSTP__c+rg.Non_Specialty_Formulary_2__c,rg.Rebate_Sorting_Order__c);
                    }
                    if(rg.UniqueCheck__c==true ){
                     newUniqueCheck.put(rg.Plan_Design__c+rg.GSTP__c+rg.Non_Specialty_Formulary_2__c,rg.Rebate_Sorting_Order__c);
                    }
                    if(rg.grid_flag__c==true){
                    mapGridFlag.put(rg.Plan_Design__c+rg.GSTP__c+rg.Non_Specialty_Formulary_2__c,rg.Rebate_Sorting_Order__c);
                    }
                
                }
                String NonSpec;
                for(Rebate_Guarantees__c rg: Rgee)
                {
                   /* if(rg.Template_SpecialtyatCVS_Display__c==true && rg.UniqueCheck__c==false && rg.PCD_Same_dollar_and_Percentage_Value__c==false){
                        if(newMapDupCheck.get(rg.Plan_Design__c+rg.GSTP__c+rg.Non_Specialty_Formulary_2__c)!=null && newUniqueCheck.get(rg.Plan_Design__c+rg.GSTP__c+rg.Non_Specialty_Formulary_2__c)!=null){
                            rg.Sorting_Number__c=Integer.valueOF(newUniqueCheck.get(rg.Plan_Design__c+rg.GSTP__c+rg.Non_Specialty_Formulary_2__c))+0.2;
                        }
                        else if(newMapDupCheck.get(rg.Plan_Design__c+rg.GSTP__c+rg.Non_Specialty_Formulary_2__c)!=null && newUniqueCheck.get(rg.Plan_Design__c+rg.GSTP__c+rg.Non_Specialty_Formulary_2__c)==null){
                             rg.Sorting_Number__c=Integer.valueOF(newMapDupCheck.get(rg.Plan_Design__c+rg.GSTP__c+rg.Non_Specialty_Formulary_2__c))+0.2;
                        }
                        else{
                            rg.Sorting_Number__c=Integer.valueOF(newMapSortSort.get(rg.Plan_Design__c+rg.GSTP__c+rg.Non_Specialty_Formulary_2__c))+0.2;
                        }
                    }
                    if(rg.PCD_Same_dollar_and_Percentage_Value__c==true){
                       if(mapGridFlag.get(rg.Plan_Design__c+rg.GSTP__c+rg.Non_Specialty_Formulary_2__c)!=null && rg.Grid_Flag__c==false && newMapDupCheck.get(rg.Plan_Design__c+rg.GSTP__c+rg.Non_Specialty_Formulary_2__c)==null){
                        rg.Sorting_Number__c=Integer.valueOF(mapGridFlag.get(rg.Plan_Design__c+rg.GSTP__c+rg.Non_Specialty_Formulary_2__c))+0.1;
                        }
                        if(mapGridFlag.get(rg.Plan_Design__c+rg.GSTP__c+rg.Non_Specialty_Formulary_2__c)!=null && rg.Grid_Flag__c==true && newMapDupCheck.get(rg.Plan_Design__c+rg.GSTP__c+rg.Non_Specialty_Formulary_2__c)==null ){
                        rg.Sorting_Number__c=Integer.valueOF(mapGridFlag.get(rg.Plan_Design__c+rg.GSTP__c+rg.Non_Specialty_Formulary_2__c));
                        }
                        if(mapGridFlag.get(rg.Plan_Design__c+rg.GSTP__c+rg.Non_Specialty_Formulary_2__c)!=null && rg.Grid_Flag__c==true && newMapDupCheck.get(rg.Plan_Design__c+rg.GSTP__c+rg.Non_Specialty_Formulary_2__c)!=null ){
                        rg.Sorting_Number__c=Integer.valueOF(mapGridFlag.get(rg.Plan_Design__c+rg.GSTP__c+rg.Non_Specialty_Formulary_2__c));
                        }                      
                   }
                    if(rg.UniqueCheck__c==true){
                       if(mapGridFlag.get(rg.Plan_Design__c+rg.GSTP__c+rg.Non_Specialty_Formulary_2__c)!=null && rg.Grid_Flag__c==false && newMapDupCheck.get(rg.Plan_Design__c+rg.GSTP__c+rg.Non_Specialty_Formulary_2__c)==null){
                        rg.Sorting_Number__c=Integer.valueOF(mapGridFlag.get(rg.Plan_Design__c+rg.GSTP__c+rg.Non_Specialty_Formulary_2__c))+0.1;
                        }
                        if(mapGridFlag.get(rg.Plan_Design__c+rg.GSTP__c+rg.Non_Specialty_Formulary_2__c)!=null && rg.Grid_Flag__c==true && newMapDupCheck.get(rg.Plan_Design__c+rg.GSTP__c+rg.Non_Specialty_Formulary_2__c)==null ){
                        rg.Sorting_Number__c=Integer.valueOF(mapGridFlag.get(rg.Plan_Design__c+rg.GSTP__c+rg.Non_Specialty_Formulary_2__c));
                        } 
                        if(mapGridFlag.get(rg.Plan_Design__c+rg.GSTP__c+rg.Non_Specialty_Formulary_2__c)!=null && rg.Grid_Flag__c==true && newMapDupCheck.get(rg.Plan_Design__c+rg.GSTP__c+rg.Non_Specialty_Formulary_2__c)!=null ){
                        rg.Sorting_Number__c=Integer.valueOF(mapGridFlag.get(rg.Plan_Design__c+rg.GSTP__c+rg.Non_Specialty_Formulary_2__c));
                        }                 
                    } */
                   
                   if(rg.Non_Specialty_Formulary_2__c != NonSpec && NonSpec != null)
                        {
                        counter=counter+1;
                        }
                        NonSpec = rg.Non_Specialty_Formulary_2__c;
                        rg.Ranking__c=counter;  

                   // }
                    //else{
                    //rg.Ranking__c=null; 
                    //}
                    UpdateRabteList.add(rg);
                }
                if(!UpdateRabteList.isEmpty()){
                    Update UpdateRabteList;
                }
        }

        catch(DmlException e)
            {
             System.debug(e.getMessage());
            } 
    }
    
}