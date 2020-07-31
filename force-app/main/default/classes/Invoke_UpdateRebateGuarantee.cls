/* =================================================================================
 * @Class Name        : Invoke_UpdateRebateGuarantee
 * @author            : Soumendu Chowdhury
 * @created date      : 07/09/2019
 * @Purpose           : Populate Begin , End Date and Show in Grid Flag for Specialty / Non-Specialty Formulary Rebate Grid
=======================================================================================*/
global class Invoke_UpdateRebateGuarantee{

/*=================================================================================
 * @Method Name       : UpdateRebateGuarantee
 * @author            : Soumendu Chowdhury
 * @created date      : 07/09/2019
 * @Last modified by  : Soumendu Chowdhury
 * @Purpose           : Populate Begin , End Date and Show in Grid Flag for Specialty / Non-Specialty Formulary Rebate Grid
=======================================================================================*/
@InvocableMethod
global static void UpdateRebateGuarantee(List<id> objId)
{
try
{
if(DeepCloneUtility.OFF_INVOCABLE_CLASS)
{
DeepCloneUtility.OFF_TRIGGERS_PROCBUILDER=false;
Set<id> ids=new set<id>();
Set<id> FAFids=new set<id>();
Set<String> RebateKeySet=new Set<String>();
map<Id,Boolean> mapBol=new map<Id,Boolean>();
map<String,String> mapspecstr=new map<String,String>();
map<String,String> mapnonspecstr=new map<String,String>();
map<String,String> mapplandsgn=new map<String,String>();
Map<id,date> MapYear1Begin = new Map<id,date>();
Map<id,date> MapYear1End = new Map<id,date>();
Map<id,date> MapYear2Begin = new Map<id,date>();
Map<id,date> MapYear2End = new Map<id,date>();
Map<id,date> MapYear3Begin = new Map<id,date>();
Map<id,date> MapYear3End = new Map<id,date>();
Map<id,date> MapYear4Begin = new Map<id,date>();
Map<id,date> MapYear4End = new Map<id,date>();
Map<id,date> MapYear5Begin = new Map<id,date>();
Map<id,date> MapYear5End = new Map<id,date>();
Map<id,date> MapContractDt = new Map<id,date>();
Map<id,date> MapContractEndDt = new Map<id,date>();
Map<String,boolean> customDes = new Map<String,boolean>();
List<String> NonSpecSet=new List<String>();
Set<String> SpecSet=new Set<String>();
Map<id,Rebate_Guarantees__c> MapYearComb = new Map<id,Rebate_Guarantees__c>();
Set<String> yearstr=new Set<String>();
Map<String,String> MapNonDisplay = new Map<String,String>();
Map<String,String> MapSpecDisplay = new Map<String,String>();
        List<PCD_Modeled_Formulary_Name__mdt> CustomFormulary=[SELECT Specialty_Formulary_Name__c,Non_Specialty_Formulary_Name__c,Modeled_Formulary_Name__c
                                                                            FROM PCD_Modeled_Formulary_Name__mdt];
        for(PCD_Modeled_Formulary_Name__mdt mdtObj:CustomFormulary){
            NonSpecSet.add(mdtObj.Modeled_Formulary_Name__c);
            customDes.put(mdtObj.Modeled_Formulary_Name__c,true);
            //System.debug('*********'+mdtObj.Modeled_Formulary_Name__c);
              system.debug('*****customDes'+customDes);
        }
                                                                              
        
        List<PCD_Modeled_Plan_Design__mdt> CustomPlanDesign=[SELECT Plan_Design__c,Modeled_Plan_Design__c
                                                                            FROM PCD_Modeled_Plan_Design__mdt];
        PCD_FAF_Status__mdt FAFStatus = [SELECT Value__c FROM PCD_FAF_Status__mdt LIMIT 1]; 
        List<string> FAFStat = new List<string>();
        for(string s: FAFStatus.Value__c.split(','))
           {
            FAFStat.add(s);
           }   
        List<Rebate_Guarantees__c> Scope =[SELECT ID,IUMS_Upload__c,Specialty_Key__c,Rebate_Key__c,Custom_Description__c,Specialty_Display_Name__c,Rebate_Operations__c,Modeled_Non_Specialty_Plan_Dup_Check__c,FAF_ID__c,Year_Begin_Date__c,Year_End_Date__c,Invokable_Update__c,Year__c,Template_Non_Specialty_Grid_Name_Text__c, 
                                                Template_Specialty_Grid_Name_Text__c,LOB2__c,Plan_Design__c,GSTP__c,Batch_Update__c,Modeled_Non_Specialty_Formulary_Name__c,Modeled_Specialty_Formulary_Name__c,
                                                Modeled_Non_Specialty_PlanDesign__c,Modeled_Specialty_PlanDesign__c,Template_Specialty_Grid_Name__c,Template_Non_Specialty_Grid_Name__c,Show_in_Non_Specialty_Grid__c,
                                                Show_in_Specialty_Grid__c,Specialty_Formulary__c,Non_Specialty_Formulary_2__c,Template_SpecialtyatCVS_Display__c,Template_SpecialtyatRetail_Display__c,Sorting_Number__c,Percentage_Guarantee__c,Percentage_Check__c
                                                FROM Rebate_Guarantees__c where FAF_ID__r.FAF_Status__c IN:FAFStat  and Rebate_Operations__c IN:objId];

            List<Rebate_Gtees_Specialty_Class_Carve_Outs__c> Rcurve = [SELECT Id,Name,Year__c,LOB2__c,FAF_ID__c,Year_Begin_Date__c,Year_End_Date__c,Drug_Therapy_Class_2__c,Specialty_Dollar_Amount__c,Print_FAF_Specialty__c,Specialty_Retail_Dollar_Amt__c,Print_FAF_Specialty_Retail__c FROM Rebate_Gtees_Specialty_Class_Carve_Outs__c WHERE Rebate_Operations__c IN:objId order by Drug_Therapy_Class_2__c];
            

            for(Rebate_Guarantees__c  rebObj : scope)
             {
               ids.add(rebObj.id);
               FAFids.add(rebObj.FAF_ID__c);
               yearstr.add(rebObj.Year__c);
               if(rebObj.IUMS_Upload__c==true){
               RebateKeySet.add(rebObj.Rebate_Key__c);
               }
               if(rebObj.Year__c=='All'){
               MapYearComb.put(rebObj.Id,rebObj);
               }
            }
            if(!RebateKeySet.isEmpty()){
                List<Grid_Display_Name_Setting__c> gridDisplayList=[Select ID,Specialty_Key__c,Rebate_Key__c,Rebate_Non_Specialty_Grid_Name__c,Rebate_Specialty_Grid_Name__c,Object_Name__c,FAF__c,Grid_Display_Name__c FROM Grid_Display_Name_Setting__c where FAF__c IN:FAFids and Object_Name__c='Rebate Guarantees' and Rebate_Key__c IN:RebateKeySet];
                for(Grid_Display_Name_Setting__c gdr:gridDisplayList){
                     MapNonDisplay.put(gdr.Rebate_Key__c,gdr.Rebate_Non_Specialty_Grid_Name__c);
                     MapSpecDisplay.put(gdr.Specialty_Key__c,gdr.Rebate_Specialty_Grid_Name__c);
                }
            }
             If ( FAFids == null || FAFids.isEmpty())
             {
                         for(Rebate_Gtees_Specialty_Class_Carve_Outs__c  recObj : Rcurve)
                         {
                           FAFids.add(recObj.FAF_ID__c);
                         }
              }
            List<Client_Information__c> clientInfo=[Select ID,FAF_ID__c,Year_1_Begin_Date__c,Year_1_End_Date__c,Year_1__c,
                                                     Year_2__c,Year_2_Begin_Date__c,Year_2_End_Date__c,
                                                     Year_3__c,Year_3_Begin_Date__c,Year_3_End_Date__c,
                                                     Year_4__c,Year_4_Begin_Date__c,Year_4_End_Date__c,
                                                     Year_5__c,Year_5_Begin_Date__c,Year_5_End_Date__c,
                                                     Contract_Effective_Date__c,Contract_End_Date__c
                                                     from Client_Information__c where FAF_ID__c IN:FAFids];
                                                 
            for(Client_Information__c clt:clientInfo){
                MapYear1Begin.put(clt.FAF_ID__c,clt.Year_1_Begin_Date__c);
                System.debug('**** Year 1'+clt.Year_1_Begin_Date__c);
                MapYear2Begin.put(clt.FAF_ID__c,clt.Year_2_Begin_Date__c);
                MapYear3Begin.put(clt.FAF_ID__c,clt.Year_3_Begin_Date__c);
                MapYear4Begin.put(clt.FAF_ID__c,clt.Year_4_Begin_Date__c);
                MapYear5Begin.put(clt.FAF_ID__c,clt.Year_5_Begin_Date__c);
                MapYear1End.put(clt.FAF_ID__c,clt.Year_1_End_Date__c);
                MapYear2End.put(clt.FAF_ID__c,clt.Year_2_End_Date__c);
                MapYear3End.put(clt.FAF_ID__c,clt.Year_3_End_Date__c);
                MapYear4End.put(clt.FAF_ID__c,clt.Year_4_End_Date__c);
                MapYear5End.put(clt.FAF_ID__c,clt.Year_5_End_Date__c);
                MapContractDt.put(clt.FAF_ID__c,clt.Contract_Effective_Date__c);
                MapContractEndDt.put(clt.FAF_ID__c,clt.Contract_End_Date__c);
            }         
/*** Modeled Formulary Name Update ****/
            for(PCD_Modeled_Formulary_Name__mdt form:CustomFormulary)
            {
              if(form.Specialty_Formulary_Name__c != null)
              {
                mapspecstr.put(form.Specialty_Formulary_Name__c,form.Modeled_Formulary_Name__c);
              }
              if(form.Non_Specialty_Formulary_Name__c != null)
              {
                mapnonspecstr.put(form.Non_Specialty_Formulary_Name__c,form.Modeled_Formulary_Name__c);
              }
            }
/*** Modeled Formulary Name Update ****/
/***Translated Plan Design Update ****/
            for(PCD_Modeled_Plan_Design__mdt plndsgn: CustomPlanDesign)
            {
                mapplandsgn.put(plndsgn.Plan_Design__c,plndsgn.Modeled_Plan_Design__c);
            }
           List<Rebate_Gtees_Specialty_Class_Carve_Outs__c>  rebatecur = new List<Rebate_Gtees_Specialty_Class_Carve_Outs__c>(); 
           for(Rebate_Gtees_Specialty_Class_Carve_Outs__c  rcObj : Rcurve)
           {
            
            if(rcObj.Year__c=='1' ){
                  Date dat=MapYear1Begin.get(rcObj.FAF_ID__c);
                rcObj.Year_Begin_Date__c=dat;
                }
                system.debug(' rcObj.Year_Begin_Date__c'+ rcObj.Year_Begin_Date__c);
                System.debug('MapYear1Begin.get(rcObj.FAF_ID__c)'+MapYear1Begin.get(rcObj.FAF_ID__c));
                if(rcObj.Year__c=='2' ){
                    rcObj.Year_Begin_Date__c=MapYear2Begin.get(rcObj.FAF_ID__c);
                }
                if(rcObj.Year__c=='3'){
                    rcObj.Year_Begin_Date__c=MapYear3Begin.get(rcObj.FAF_ID__c);
                }
                if(rcObj.Year__c=='4' ){
                    rcObj.Year_Begin_Date__c=MapYear4Begin.get(rcObj.FAF_ID__c);
                }
                if(rcObj.Year__c=='5'){
                    rcObj.Year_Begin_Date__c=MapYear5Begin.get(rcObj.FAF_ID__c);
                }
                // Year End Date 
                
                if(rcObj.Year__c=='1'){
                rcObj.Year_End_Date__c=MapYear1End.get(rcObj.FAF_ID__c);
                }
                if(rcObj.Year__c=='2'){
                    rcObj.Year_End_Date__c=MapYear2End.get(rcObj.FAF_ID__c);
                }
                if(rcObj.Year__c=='3' ){
                    rcObj.Year_End_Date__c=MapYear3End.get(rcObj.FAF_ID__c);
                }
                if(rcObj.Year__c=='4' ){
                    rcObj.Year_End_Date__c=MapYear4End.get(rcObj.FAF_ID__c);
                }
                if(rcObj.Year__c=='5' ){
                    rcObj.Year_End_Date__c=MapYear5End.get(rcObj.FAF_ID__c);
                }
                //For Year All
                
                if(rcObj.Year__c=='All'){
                    rcObj.Year_End_Date__c=MapContractEndDt.get(rcObj.FAF_ID__c);
                }
                if(rcObj.Year__c=='All'){
                    rcObj.Year_Begin_Date__c=MapContractDt.get(rcObj.FAF_ID__c);
                }   
             rebatecur.add(rcObj); 
            
           } 
           List<Rebate_Guarantees__c>  rebateObj = new List<Rebate_Guarantees__c>();         
           for(Rebate_Guarantees__c  rgObj : scope)
           {
            Boolean excludenonspec = false;
            Boolean excludespec = false;
            rgObj.Show_in_Non_Specialty_Grid__c=true;
            rgObj.Show_in_Specialty_Grid__c=true;
                 for(Rebate_Guarantees__c rg: MapYearComb.values())
                   {
                    if((rgObj.Year__c=='1'|| rgObj.Year__c=='2' || rgObj.Year__c=='3' || rgObj.Year__c=='4'|| rgObj.Year__c=='5') && (rgObj.Template_Non_Specialty_Grid_Name__c == rg.Template_Non_Specialty_Grid_Name__c) && rg.Year__c=='All')
                    {
                        rgObj.Show_in_Non_Specialty_Grid__c=false;
                        excludenonspec = true;
                        rgObj.Template_Non_Specialty_Grid_Name_Text__c=' ';
                    }
                    if((rgObj.Year__c=='1'|| rgObj.Year__c=='2' || rgObj.Year__c=='3' || rgObj.Year__c=='4'|| rgObj.Year__c=='5')  && (rgObj.Modeled_Non_Specialty_Formulary_Name__c == rg.Modeled_Non_Specialty_Formulary_Name__c) && (rgObj.Template_Specialty_Grid_Name__c == rg.Template_Specialty_Grid_Name__c) && rg.Year__c=='All')
                    {
                        rgObj.Show_in_Specialty_Grid__c=false;
                        excludespec = true;
                        rgObj.Template_Specialty_Grid_Name_Text__c=' ';
                    }
                   }
              
                if(rgObj.Year__c=='All')
                {
                      rgObj.Show_in_Non_Specialty_Grid__c=true;
                      rgObj.Show_in_Specialty_Grid__c=true;
                } 
                //Changes done for custom description :Mohit SRivastava
                if(mapnonspecstr.get(rgObj.Non_Specialty_Formulary_2__c) !=null){
                   rgObj.Modeled_Non_Specialty_Formulary_Name__c = 'REBATES - ' + mapnonspecstr.get(rgObj.Non_Specialty_Formulary_2__c);
                    if(rgObj.IUMS_Upload__c==true){
                        if(rgObj.Custom_Description__c==''||rgObj.Custom_Description__c==null){
                            if(!MapNonDisplay.isEmpty()){
                             rgObj.Custom_Description__c= MapNonDisplay.get(rgObj.Rebate_Key__c);
                            }
                            else{
                                if(mapnonspecstr.get(rgObj.Non_Specialty_Formulary_2__c)!=null){
                                rgObj.Custom_Description__c='REBATES -'+ mapnonspecstr.get(rgObj.Non_Specialty_Formulary_2__c);
                                }
                                else{
                                 rgObj.Custom_Description__c='REBATES'; 
                                }
                            }
                        }
                    }
                    else{
                    if(rgObj.Custom_Description__c!=null){
                    String S1=rgObj.Custom_Description__c;
                    String S2=s1.substringAfter('REBATES -');
                    String S3=s2.trim();
                         if(mapnonspecstr.values().contains(S3)|| rgObj.Custom_Description__c=='REBATES' &&(rgObj.Custom_Description__c!=null)){
                              rgObj.Custom_Description__c = 'REBATES - ' + mapnonspecstr.get(rgObj.Non_Specialty_Formulary_2__c);
                        }
                       }
                        if(rgObj.Custom_Description__c==''||rgObj.Custom_Description__c==null){
                            rgObj.Custom_Description__c='REBATES -'+ mapnonspecstr.get(rgObj.Non_Specialty_Formulary_2__c);
                        }
                     }
                }
                else
                {
                    rgObj.Modeled_Non_Specialty_Formulary_Name__c = 'REBATES';
                    if(rgObj.Custom_Description__c==''||rgObj.Custom_Description__c==null){
                            rgObj.Custom_Description__c='REBATES';
                    }
                }
                if(mapspecstr.get(rgObj.Specialty_Formulary__c) !=null){
                    rgObj.Modeled_Specialty_Formulary_Name__c = 'REBATES - ' + mapspecstr.get(rgObj.Specialty_Formulary__c);
                     if( rgObj.IUMS_Upload__c==true){
                        if(rgObj.Specialty_Display_Name__c==''||rgObj.Specialty_Display_Name__c==null){
                           if(!MapSpecDisplay.isEmpty()){
                           rgObj.Specialty_Display_Name__c= MapSpecDisplay.get(rgObj.Specialty_Key__c);
                           }
                           else{
                               rgObj.Specialty_Display_Name__c='REBATES - '+ mapspecstr.get(rgObj.Specialty_Formulary__c); 
                           }
                         
                        }
                    }
                    else{
                            
                           if(rgObj.Specialty_Display_Name__c!=null){
                               String S1=rgObj.Specialty_Display_Name__c;
                               String S2=s1.substringAfter('REBATES -');
                               String S3=s2.trim();
                                if(NonSpecSet.contains(S3) || rgObj.Specialty_Display_Name__c=='REBATES'){
                                    rgObj.Specialty_Display_Name__c='REBATES - '+ mapspecstr.get(rgObj.Specialty_Formulary__c);
                                }
                            }
                            if(rgObj.Specialty_Display_Name__c==''||rgObj.Specialty_Display_Name__c==null){
                                rgObj.Specialty_Display_Name__c='REBATES - '+ mapspecstr.get(rgObj.Specialty_Formulary__c);
                            }
                    }
                }
                else
                {
                rgObj.Modeled_Specialty_Formulary_Name__c = 'REBATES' ;
                if(rgObj.Specialty_Display_Name__c==''||rgObj.Specialty_Display_Name__c==null){
                        rgObj.Specialty_Display_Name__c='REBATES' ;
                    }
                }
                if (rgObj.GSTP__c != null){
                //Start: CHanges Done by : Mohit Srivastava to Solve null issue for Plan design
                    if(mapplandsgn.get(rgObj.Plan_Design__c)!=null){
                        rgObj.Modeled_Non_Specialty_PlanDesign__c = mapplandsgn.get(rgObj.Plan_Design__c) + ' - ' + rgObj.GSTP__c;
                        rgObj.Modeled_Non_Specialty_Plan_Dup_Check__c=mapplandsgn.get(rgObj.Plan_Design__c);
                    }
                    else{
                    rgObj.Modeled_Non_Specialty_PlanDesign__c =' - ' + rgObj.GSTP__c;
                     rgObj.Modeled_Non_Specialty_Plan_Dup_Check__c='';
                    }
                }
                else{
                    if(mapplandsgn.get(rgObj.Plan_Design__c)!=null){
                            rgObj.Modeled_Non_Specialty_PlanDesign__c = mapplandsgn.get(rgObj.Plan_Design__c);
                           rgObj.Modeled_Non_Specialty_Plan_Dup_Check__c=mapplandsgn.get(rgObj.Plan_Design__c);
                    }
                    else{
                    rgObj.Modeled_Non_Specialty_PlanDesign__c ='  ';
                      rgObj.Modeled_Non_Specialty_Plan_Dup_Check__c='';
                    }
                }
                //End: CHanges Done by : Mohit Srivastava to Solve null issue for Plan design
                
                 if (rgObj.GSTP__c != null){
                //Start: Changes Done by : soumendu chowdhury US # 164
                    if(mapplandsgn.get(rgObj.Plan_Design__c)!=null){
                        rgObj.Modeled_Specialty_PlanDesign__c = mapplandsgn.get(rgObj.Plan_Design__c) + ' - ' + rgObj.GSTP__c;
                         
                    }
                    else{
                    rgObj.Modeled_Specialty_PlanDesign__c =' - ' + rgObj.GSTP__c;
                    }
                }
                else{
                    if(mapplandsgn.get(rgObj.Plan_Design__c)!=null){
                            rgObj.Modeled_Specialty_PlanDesign__c = mapplandsgn.get(rgObj.Plan_Design__c);
                    }
                    else{
                    rgObj.Modeled_Specialty_PlanDesign__c ='  ';
                    }
                }
                //Completed: Changes Done by : soumendu chowdhury US # 164
                
                //rgObj.Modeled_Specialty_PlanDesign__c = mapplandsgn.get(rgObj.Plan_Design__c);
                if (excludenonspec == false && rgObj.Modeled_Non_Specialty_Formulary_Name__c != null)
                rgObj.Template_Non_Specialty_Grid_Name_Text__c = rgObj.LOB2__c + '-' + mapnonspecstr.get(rgObj.Non_Specialty_Formulary_2__c) + '-' + rgObj.Modeled_Non_Specialty_PlanDesign__c;
                if (excludenonspec == false && rgObj.Modeled_Specialty_Formulary_Name__c != null)
                rgObj.Template_Specialty_Grid_Name_Text__c = rgObj.LOB2__c + '-' + mapspecstr.get(rgObj.Specialty_Formulary__c) + '-' + rgObj.Modeled_Specialty_PlanDesign__c + '-' + rgObj.Modeled_Non_Specialty_Formulary_Name__c;
                
                rgObj.Template_Clientowned30_Text__c = ' ';
                rgObj.Template_Clientowned90_Text__c = ' ';
                rgObj.Template_Clientowned_Text__c = ' ';
                rgObj.Template_Mail_Text__c = ' ';
                rgObj.Template_Mchoice_Text__c = ' ';
                rgObj.Template_Retail30_Text__c = ' ';
                rgObj.Template_Retail90_Text__c = ' ';
                rgObj.Template_Retail_Text__c = ' ';
                rgObj.Template_SpecialtyatCVS_Text__c = ' ';
                rgObj.Template_SpecialtyatRetail_Text__c = ' ';
                rgObj.Template_Specialty_Carveout_Label_Text__c = ' ';
                rgObj.Template_Specialty_Carveout_Text__c = ' ';
                rgObj.Template_SpecialtyatCVS_Display__c = false;
                rgObj.Template_SpecialtyatRetail_Display__c = false;
                rgObj.Template_Mail_Label_Text__c = ' ';
                rgObj.Percentage_Guarantee__c=rgObj.Percentage_Check__c;               
                if(rgObj.Year__c=='1'){
                rgObj.Year_Begin_Date__c=MapYear1Begin.get(rgObj.FAF_ID__c);
                }
                if(rgObj.Year__c=='2' ){
                    rgObj.Year_Begin_Date__c=MapYear2Begin.get(rgObj.FAF_ID__c);
                }
                if(rgObj.Year__c=='3'){
                    rgObj.Year_Begin_Date__c=MapYear3Begin.get(rgObj.FAF_ID__c);
                }
                if(rgObj.Year__c=='4'){
                    rgObj.Year_Begin_Date__c=MapYear4Begin.get(rgObj.FAF_ID__c);
                }
                if(rgObj.Year__c=='5'){
                    rgObj.Year_Begin_Date__c=MapYear5Begin.get(rgObj.FAF_ID__c);
                }
                // Year End Date 
                
                if(rgObj.Year__c=='1'){
                rgObj.Year_End_Date__c=MapYear1End.get(rgObj.FAF_ID__c);
                }
                if(rgObj.Year__c=='2'){
                    rgObj.Year_End_Date__c=MapYear2End.get(rgObj.FAF_ID__c);
                }
                if(rgObj.Year__c=='3'){
                    rgObj.Year_End_Date__c=MapYear3End.get(rgObj.FAF_ID__c);
                }
                if(rgObj.Year__c=='4'){
                    rgObj.Year_End_Date__c=MapYear4End.get(rgObj.FAF_ID__c);
                }
                if(rgObj.Year__c=='5'){
                    rgObj.Year_End_Date__c=MapYear5End.get(rgObj.FAF_ID__c);
                }
                //For Year All
                
                if(rgObj.Year__c=='All'){
                    rgObj.Year_End_Date__c=MapContractEndDt.get(rgObj.FAF_ID__c);
                }
                if(rgObj.Year__c=='All'){
                    rgObj.Year_Begin_Date__c=MapContractDt.get(rgObj.FAF_ID__c);
                } 
                 rgObj.Invokable_Update__c=true;  
                 
               if (rgObj.Plan_Design__c  == '3 Tier Q')
                {
                  rgObj.Sorting_Number__c  = 1.0;
                }
                if (rgObj.Plan_Design__c  == '3 Tier NQ')
                {
                  rgObj.Sorting_Number__c  = 2.0;
                }
                if (rgObj.Plan_Design__c  == '2 Tier Q')
                {
                  rgObj.Sorting_Number__c  = 3.0;
                } 
                if (rgObj.Plan_Design__c  == 'Closed')
                {
                  rgObj.Sorting_Number__c  = 4.0;
                } 
               rebateObj.add(rgObj);                  
             }
            if(!rebateObj.isEmpty())
            {
            //DeepCloneUtility.OFF_TRIGGERS_PROCBUILDER=true;
             Database.update(rebateObj);
            }
            if(!rebatecur.isEmpty())
            {
             Database.update(rebatecur);
            }
}
}
catch(Exception Ex)
{ 
    system.debug('Exception....'+ex.getMessage());
}
 }
}