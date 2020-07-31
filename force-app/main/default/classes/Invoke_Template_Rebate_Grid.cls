/* =================================================================================
 * @Class Name        : Invoke_Template_Rebate_Grid
 * @author            : Soumendu Chowdhury
 * @created date      : 07/09/2019
 * @Purpose           : Populate complex Data structure to display Rebate Grids in Apttus CF Template
=======================================================================================*/
public class Invoke_Template_Rebate_Grid{
/*=================================================================================
 * @Method Name       : Template_Rebate_Grid
 * @author            : Soumendu Chowdhury
 * @created date      : 07/09/2019
 * @Last modified by  : Soumendu Chowdhury
 * @Purpose           : Populate complex Data structure to display Rebate Grids in Apttus CF Template
=======================================================================================*/
@InvocableMethod
public static void Template_Rebate_Grid(List<id> objId)
{ 
try
{
system.debug('objIdobjId'+objId);
DeepCloneUtility.OFF_TRIGGERS_PROCBUILDER=false;
Rebate_Guarantees__c[] ListRebate = new List<Rebate_Guarantees__c>();
Rebate_Guarantees__c[] ShowinSpecGrid = new List<Rebate_Guarantees__c>();
Rebate_Guarantees__c[] ShowinNonSpecGrid = new List<Rebate_Guarantees__c>();
Set<ID> SETIDs=new  set<ID>();

Boolean RetailExist = false;
Integer intSort=0;   
Boolean Retail30Exist = false;
Boolean Retail90Exist = false;
Boolean ClientOwnedExist = false;
Boolean SameValueCheck=false;
Boolean ClientOwned30Exist = false;
Boolean ClientOwned90Exist = false;
Boolean MailExist = false;
Boolean MchoiceExist = false;
Boolean SpecialtyatRetailExist = false;
Boolean SpecialtyatCVSExist = false;
Boolean RcurveExist = false;
Boolean ShowNonSpecGrid = false;
Boolean dupflag=false;
Boolean ShowSpecGrid = false;
Boolean LoopCount = false;
List<Rebate_Guarantees__c> Rgeeupdate = new List<Rebate_Guarantees__c>();
Set<string> Pharbenlabel = new Set<String>();
List<string> Pharbenvalue = new List<String>();
List<string> ModeledformularyList = new List<String>();
Set<String> setRemoveDup =new Set<String>();
Set<String> setDup =new Set<String>();
List<String> setDupList =new List<String>();
List<String> dupflagList=new List<String>();
Set<String> dupCheck =new Set<String>();
Set<String> strCheck =new Set<String>();
set<String> setTempString = new set<String>();
set<String> duplicateTempString = new set<String>();
map<String,Integer> mapYear= new map<String,Integer>();
set<String> yearset=new set<String>();
set<String> yearAllset=new set<String>();
map<String,integer> mapYearAll= new map<String,integer>();
map<id,decimal> mapPrice= new map<id,decimal>();
map<id,decimal> mapReatilPrice= new map<id,decimal>();
List<String> str=new List<String>();
Set<Rebate_Gtees_Specialty_Class_Carve_Outs__c> dupset=new Set<Rebate_Gtees_Specialty_Class_Carve_Outs__c>(); 
Map<String,Integer> myMap =new Map<String,Integer>();
String cLeftBeforeLabel=System.Label.Left_Align_Rebate_Gurantee; 
String cRightBeforeLabel=System.Label.Right_Allign;   
  
//if(DeepCloneUtility.OFF_INVOCABLE_CLASS){
PCD_FAF_Status__mdt FAFStatus = [SELECT Value__c FROM PCD_FAF_Status__mdt LIMIT 1]; 
        List<string> FAFStat = new List<string>();
        for(string s: FAFStatus.Value__c.split(','))
              {
                 FAFStat.add(s);
              }        

List<Rebate_Guarantees__c> Rgee =[SELECT ID,Basis__c,Retail_30__c,PCD_Aggregate_Rate__c,Grid_flag__c,Dollar_Rate_Combination__c,Rate_Percentage_Combination__c,Percentage_Check__c,Retail_90__c,Mchoice__c,Mail__c,Client_Owned_30__c,Client_Owned_90__c,Retail_30_1__c,Retail_90_1__c,Mchoice_1__c,Mail_1__c,Client_Owned_30_1__c,Client_Owned_90_1__c,rebate_Modeled_Non_Specialty_PlanDe_New__c,PCD_Same_dollar_and_Percentage_Value__c,Name,Rebate_Operations__c,Rebate_Sorting_Order__c,Sorting_Number__c,FAF_ID__c,Pecentage_Guarantee__c,Year_Begin_Date__c,Year_End_Date__c,Invokable_Update__c,Year__c,Template_Non_Specialty_Grid_Name_Text__c,
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
                                        FROM Rebate_Guarantees__c WHERE FAF_ID__r.FAF_Status__c IN:FAFStat AND Rebate_Operations__c IN:objId];


Map<Id,Rebate_Gtees_Specialty_Class_Carve_Outs__c> Rcurve = new Map<Id,Rebate_Gtees_Specialty_Class_Carve_Outs__c>([ SELECT Id,Rebate_Operations__c,Year__c,LOB2__c,Year_Begin_Date__c,Year_End_Date__c,Drug_Therapy_Class_2__c,Specialty_Dollar_Amount__c,FAF_Print_Specialty__c,Print_FAF_Specialty__c,Specialty_Retail_Dollar_Amt__c,Print_FAF_Specialty_Retail__c  FROM Rebate_Gtees_Specialty_Class_Carve_Outs__c WHERE Rebate_Operations__c IN:objId ORDER BY Drug_Therapy_Class_2__c,Year_Begin_Date__c]);
Map<String,AggregateResult> MinNonSpecAgreegate = new Map<String,AggregateResult>([SELECT Template_Non_Specialty_Grid_Name_Text__c Id, Min(Name) MinName
                                        FROM Rebate_Guarantees__c 
                                        WHERE FAF_ID__r.FAF_Status__c IN:FAFStat 
                                        AND Show_in_Non_Specialty_Grid__c = true AND Rebate_Operations__c IN:objId
                                        GROUP BY Template_Non_Specialty_Grid_Name_Text__c]);
                                        
Map<String,AggregateResult> MinSpecAgreegate = new Map<String,AggregateResult>([SELECT Template_Specialty_Grid_Name_Text__c Id, Min(Name) MinName
                                        FROM Rebate_Guarantees__c 
                                        WHERE FAF_ID__r.FAF_Status__c IN:FAFStat 
                                        AND Show_in_Specialty_Grid__c = true AND Rebate_Operations__c IN:objId                                         
                                        GROUP BY Template_Specialty_Grid_Name_Text__c]);
                                        
List<Rebate_Guarantees__c> AgreegateRate = new List<Rebate_Guarantees__c>([SELECT Id,Basis__c,Grid_flag__c,Specialty_Formulary__c,PCD_Aggregate_Rate__c,Dollar_Rate_Combination__c,Rate_Percentage_Combination__c,PCD_Same_dollar_and_Percentage_Value__c,rebate_Modeled_Non_Specialty_PlanDe_New__c,Plan_Design__c ,Non_Specialty_Formulary_2__c,Name,LOB2__c,ClientOwned30_Display__c,ClientOwned90_Display__c,ClientOwned_Display__c,GSTP__c,Mail_Display__c,Maintenance_Choice_Display__c,
                                        Modeled_Non_Specialty_Formulary_Name__c,Modeled_Non_Specialty_PlanDesign__c,Modeled_Specialty_Formulary_Name__c,Modeled_Specialty_PlanDesign__c,Pecentage_Guarantee__c,
                                        Retail30_Display__c,Percentage_Check__c,Retail90_Display__c,Retail_Display__c,Show_in_Non_Specialty_Grid__c,Show_in_Specialty_Grid__c,SpecialtyatRetail_Display__c, Specialty_Display__c,
                                        Template_ClientOwned30_Formula__c,Template_ClientOwned90_Formula__c,Template_Mail_Formula__c,Template_Mail_Label__c,Template_Mchoice_Formula__c,Template_Non_Specialty_Grid_Name__c,
                                        Template_Non_Specialty_Plan_Design__c,Template_Retail30_Formula__c,Template_Retail90_Formula__c,Template_SpecialtyatRetail_Formula__c,Template_Specialty_Formula__c,Template_Specialty_Grid_Name__c,
                                        Template_Specialty_Plan_Design__c,Year__c,Retail_30_1__c,Retail_30__c,Retail_90__c,Retail_90_1__c,Client_Owned_30__c,Client_Owned_30_1__c,Client_Owned_90__c,Client_Owned_90_1__c,Mail__c,Mail_1__c,
                                        Mchoice__c,Mchoice_1__c,Specialty__c,Specialty_1__c,Specialty_Retail__c,Specialty_Retail_1__c
                                        FROM Rebate_Guarantees__c
                                        WHERE (Show_in_Specialty_Grid__c = true OR Show_in_Non_Specialty_Grid__c= true) AND Rebate_Operations__c IN:objId
                                        ORDER BY Year__c]);  
   
   
for(Rebate_Guarantees__c  rg: Rgee )
{
  RetailExist = false;
  Retail30Exist = false;
  Retail90Exist = false;
  ClientOwnedExist = false;
  SameValueCheck=false;
  ClientOwned30Exist = false;
  ClientOwned90Exist = false;
  MailExist = false;
  MchoiceExist = false;
  SpecialtyatRetailExist = false;
  SpecialtyatCVSExist = false;
  RcurveExist = false;
  ShowNonSpecGrid = false;
  ShowSpecGrid = false;
  String AggrRetail= '';
  String AggrRetail30= '';
  String AggrRetail90= '';
  String AggrClientOwned= '';
  String AggrClientOwned30= '';
  String DrugName=' ';
  String StrPhaben=' ';
  String Strline=' ';
  String AggrClientOwned90= '';
  String AggrMail= '';
  String AggrMchoice= '';
  String AggrSpecatRetail= '';
  String AggrSpecatCVS= '';
  String Modeledformulary='';
  String RemoveString='';
  Boolean CheckModeledformulary=false;
  Pharbenlabel.clear();
  Pharbenvalue.clear();
  setDupList.clear();
  myMap.clear();
  setRemoveDup.clear();
  strCheck.clear();
  mapYear.clear();
  SETIDs.clear();
  mapYearAll.clear();
  yearset.clear();
  yearAllset.clear();
  rg.Template_Mail_Label_Text__c = rg.Template_Mail_Label__c;
                if(MinNonSpecAgreegate != null && MinNonSpecAgreegate.get(rg.Template_Non_Specialty_Grid_Name_Text__c) != null) 
                {
                      AggregateResult  vName = MinNonSpecAgreegate.get(rg.Template_Non_Specialty_Grid_Name_Text__c); /* */
                    //if (vName.get('MinName') == rg.Name){
                        ShowNonSpecGrid = true;  
                        for (Rebate_Guarantees__c rebate : AgreegateRate){
                           //Retail Information population
                            if (rebate.Retail_Display__c == true && rebate.Retail_30_1__c !=0 && rebate.Retail_30_1__c !=null && rebate.Pecentage_Guarantee__c == true && rebate.Modeled_Non_Specialty_Formulary_Name__c == rg.Modeled_Non_Specialty_Formulary_Name__c && rebate.Modeled_Non_Specialty_PlanDesign__c == rg.Modeled_Non_Specialty_PlanDesign__c 
                            )
                            {
                                if(rg.Rate_Percentage_Combination__c==rebate.Rate_Percentage_Combination__c && rg.id!=rebate.id && rg.Basis__c==rebate.Basis__c){
                                 AggrRetail= rebate.Template_Retail30_Formula__c + '\n';
                                }
                                else{
                                 AggrRetail+= rebate.Template_Retail30_Formula__c + '\n';  
                                }
                                 RetailExist = true;
                            }
                            if (rebate.Retail_Display__c == true && rebate.Retail_30__c !=0 && rebate.Retail_30__c !=null && rebate.Pecentage_Guarantee__c == false && rebate.Modeled_Non_Specialty_Formulary_Name__c == rg.Modeled_Non_Specialty_Formulary_Name__c && rebate.Modeled_Non_Specialty_PlanDesign__c == rg.Modeled_Non_Specialty_PlanDesign__c
                            )
                            {
                                if(rg.Dollar_Rate_Combination__c==rebate.Dollar_Rate_Combination__c  && rg.id!=rebate.id && rg.Basis__c==rebate.Basis__c){
                                 AggrRetail= rebate.Template_Retail30_Formula__c + '\n';
                                }
                                else{
                                 AggrRetail+= rebate.Template_Retail30_Formula__c + '\n'; 
                                }
                                 RetailExist = true;
                            }
                             //Retail30 Information population
                            if (rebate.Retail30_Display__c == true && rebate.Retail_90_1__c !=0 && rebate.Retail_90_1__c!=null && rebate.Pecentage_Guarantee__c == true && rebate.Modeled_Non_Specialty_Formulary_Name__c == rg.Modeled_Non_Specialty_Formulary_Name__c && rebate.Modeled_Non_Specialty_PlanDesign__c == rg.Modeled_Non_Specialty_PlanDesign__c)
                            {
                                if(rg.Rate_Percentage_Combination__c==rebate.Rate_Percentage_Combination__c && rg.id!=rebate.id && rg.Basis__c==rebate.Basis__c){
                                 AggrRetail30= rebate.Template_Retail30_Formula__c + '\n';
                                }
                                else{
                                 AggrRetail30+=rebate.Template_Retail30_Formula__c + '\n'; 

                                }
                                 Retail30Exist = true;
                            }
                            if (rebate.Retail30_Display__c == true && rebate.Retail_90__c !=0 && rebate.Retail_90__c!=null && rebate.Pecentage_Guarantee__c == false && rebate.Modeled_Non_Specialty_Formulary_Name__c == rg.Modeled_Non_Specialty_Formulary_Name__c && rebate.Modeled_Non_Specialty_PlanDesign__c == rg.Modeled_Non_Specialty_PlanDesign__c)
                            {
                                if(rg.Dollar_Rate_Combination__c==rebate.Dollar_Rate_Combination__c && rg.id!=rebate.id && rg.Basis__c==rebate.Basis__c){
                                AggrRetail30= rebate.Template_Retail30_Formula__c + '\n';
                                }
                                else{
                                 AggrRetail30+= rebate.Template_Retail30_Formula__c + '\n';    
                                }
                                Retail30Exist = true;
                            } 
                           //Retail90 Information population
                           if (rebate.Retail90_Display__c == true && rebate.Retail_90_1__c !=0 && rebate.Retail_90_1__c!=null && rebate.Pecentage_Guarantee__c == true && rebate.Modeled_Non_Specialty_Formulary_Name__c == rg.Modeled_Non_Specialty_Formulary_Name__c && rebate.Modeled_Non_Specialty_PlanDesign__c == rg.Modeled_Non_Specialty_PlanDesign__c)
                           {
                               
                                if(rg.Rate_Percentage_Combination__c==rebate.Rate_Percentage_Combination__c   && rg.id!=rebate.id && rg.Basis__c==rebate.Basis__c){
                                 AggrRetail90= rebate.Template_Retail90_Formula__c + '\n';
                                }
                                else{
                                AggrRetail90+= rebate.Template_Retail90_Formula__c + '\n';  
                                }
                                 Retail90Exist = true;
                           }
                           if (rebate.Retail90_Display__c == true && rebate.Retail_90__c !=0  && rebate.Retail_90__c!=null && rebate.Pecentage_Guarantee__c == false && rebate.Modeled_Non_Specialty_Formulary_Name__c == rg.Modeled_Non_Specialty_Formulary_Name__c && rebate.Modeled_Non_Specialty_PlanDesign__c == rg.Modeled_Non_Specialty_PlanDesign__c)
                           {
                                if(rg.Dollar_Rate_Combination__c==rebate.Dollar_Rate_Combination__c && rg.id!=rebate.id && rg.Basis__c==rebate.Basis__c){
                                 AggrRetail90= rebate.Template_Retail90_Formula__c + '\n';
                                }
                                else{
                                AggrRetail90+= rebate.Template_Retail90_Formula__c + '\n';  
                                }
                                 Retail90Exist = true;
                           }
                          //ClientOwned Information population
                           if (rebate.ClientOwned_Display__c == true && rebate.Client_Owned_30_1__c !=0 && rebate.Client_Owned_30_1__c!=null && rebate.Pecentage_Guarantee__c == true && rebate.Modeled_Non_Specialty_Formulary_Name__c == rg.Modeled_Non_Specialty_Formulary_Name__c && rebate.Modeled_Non_Specialty_PlanDesign__c == rg.Modeled_Non_Specialty_PlanDesign__c)
                           {
                                if(rg.Rate_Percentage_Combination__c!=rebate.Rate_Percentage_Combination__c   && rg.id!=rebate.id && rg.Basis__c==rebate.Basis__c){
                                 AggrClientOwned=rebate.Template_ClientOwned30_Formula__c + '\n';
                                }
                                else{
                                AggrClientOwned+= rebate.Template_ClientOwned30_Formula__c + '\n';  
                                }
                                 ClientOwnedExist = true;
                           }
                           if (rebate.ClientOwned_Display__c == true && rebate.Client_Owned_30__c !=0 && rebate.Client_Owned_30__c!=null && rebate.Pecentage_Guarantee__c == false && rebate.Modeled_Non_Specialty_Formulary_Name__c == rg.Modeled_Non_Specialty_Formulary_Name__c && rebate.Modeled_Non_Specialty_PlanDesign__c == rg.Modeled_Non_Specialty_PlanDesign__c)
                           {
                                if(rg.Dollar_Rate_Combination__c==rebate.Dollar_Rate_Combination__c && rg.id!=rebate.id && rg.Basis__c==rebate.Basis__c){
                                 AggrClientOwned= rebate.Template_ClientOwned30_Formula__c + '\n'; 
                                }
                                else{
                                 AggrClientOwned+= rebate.Template_ClientOwned30_Formula__c + '\n';
                                    
                                }
                                 ClientOwnedExist = true;
                           }
                           //ClientOwned30 Information population
                           if (rebate.ClientOwned30_Display__c == true && rebate.Client_Owned_90_1__c !=0 && rebate.Client_Owned_90_1__c!=null && rebate.Pecentage_Guarantee__c == true && rebate.Modeled_Non_Specialty_Formulary_Name__c == rg.Modeled_Non_Specialty_Formulary_Name__c && rebate.Modeled_Non_Specialty_PlanDesign__c == rg.Modeled_Non_Specialty_PlanDesign__c)
                           {
                                if(rg.Rate_Percentage_Combination__c==rebate.Rate_Percentage_Combination__c && rg.id!=rebate.id && rg.Basis__c==rebate.Basis__c){
                                 AggrClientOwned30 = rebate.Template_ClientOwned30_Formula__c + '\n';
                                }
                                else{
                                   AggrClientOwned30+= rebate.Template_ClientOwned30_Formula__c + '\n';
                                }
                                ClientOwned30Exist = true;
                           }
                           if (rebate.ClientOwned30_Display__c == true && rebate.Client_Owned_90__c !=0 && rebate.Client_Owned_90__c!=null && rebate.Pecentage_Guarantee__c == false && rebate.Modeled_Non_Specialty_Formulary_Name__c == rg.Modeled_Non_Specialty_Formulary_Name__c && rebate.Modeled_Non_Specialty_PlanDesign__c == rg.Modeled_Non_Specialty_PlanDesign__c)
                           {
                                if(rg.Dollar_Rate_Combination__c==rebate.Dollar_Rate_Combination__c && rg.id!=rebate.id && rg.Basis__c==rebate.Basis__c){
                                 AggrClientOwned30= rebate.Template_ClientOwned30_Formula__c + '\n';
                                }
                                else{
                                 AggrClientOwned30+= rebate.Template_ClientOwned30_Formula__c + '\n';
                                }
                                 ClientOwned30Exist = true;
                           } 
                           //ClientOwned90 Information population
                           if (rebate.ClientOwned90_Display__c == true && rebate.Client_Owned_90_1__c !=0 && rebate.Client_Owned_90_1__c!=null && rebate.Pecentage_Guarantee__c == true && rebate.Modeled_Non_Specialty_Formulary_Name__c == rg.Modeled_Non_Specialty_Formulary_Name__c && rebate.Modeled_Non_Specialty_PlanDesign__c == rg.Modeled_Non_Specialty_PlanDesign__c)
                           {
                                if(rg.Rate_Percentage_Combination__c==rebate.Rate_Percentage_Combination__c && rg.id!=rebate.id && rg.Basis__c==rebate.Basis__c){
                                 AggrClientOwned90= rebate.Template_ClientOwned90_Formula__c + '\n';
                                }
                                else{
                                AggrClientOwned90+= rebate.Template_ClientOwned90_Formula__c + '\n'; 
                                    
                                }
                                 ClientOwned90Exist = true;
                           }
                           if (rebate.ClientOwned90_Display__c == true && rebate.Client_Owned_90__c !=0 && rebate.Client_Owned_90__c!=null && rebate.Pecentage_Guarantee__c == false && rebate.Modeled_Non_Specialty_Formulary_Name__c == rg.Modeled_Non_Specialty_Formulary_Name__c && rebate.Modeled_Non_Specialty_PlanDesign__c == rg.Modeled_Non_Specialty_PlanDesign__c)
                           {
                                if(rg.Dollar_Rate_Combination__c==rebate.Dollar_Rate_Combination__c  && rg.id!=rebate.id && rg.Basis__c==rebate.Basis__c){
                                 AggrClientOwned90= rebate.Template_ClientOwned90_Formula__c + '\n';
                                }
                                else{
                                AggrClientOwned90+= rebate.Template_ClientOwned90_Formula__c + '\n'; 
                                }
                                 ClientOwned90Exist  = true;
                           }  
                           
                           if(rebate.Template_Mail_Label__c == 'MAIL' && rebate.Modeled_Non_Specialty_Formulary_Name__c == rg.Modeled_Non_Specialty_Formulary_Name__c && rebate.Modeled_Non_Specialty_PlanDesign__c == rg.Modeled_Non_Specialty_PlanDesign__c)
                            {
                                if (rg.Template_Mail_Label_Text__c ==  'MAIL/MAINTENANCE CHOICE')
                                {
                                  AggrMchoice = AggrMail;
                                }
                                rg.Template_Mail_Label_Text__c =  'MAIL';
                            }
                            else if(rebate.Template_Mail_Label__c == 'MAIL/MAINTENANCE CHOICE' && rg.Template_Mail_Label_Text__c !=  'MAIL' && rebate.Modeled_Non_Specialty_Formulary_Name__c == rg.Modeled_Non_Specialty_Formulary_Name__c && rebate.Modeled_Non_Specialty_PlanDesign__c == rg.Modeled_Non_Specialty_PlanDesign__c)
                            {
                            rg.Template_Mail_Label_Text__c =  'MAIL/MAINTENANCE CHOICE';
                            }
                           
                           //Mail Information population
                           if (rebate.Mail_Display__c == true && rebate.Mail_1__c !=0 && rebate.Mail_1__c!=null && rebate.Pecentage_Guarantee__c == true && rebate.Modeled_Non_Specialty_Formulary_Name__c == rg.Modeled_Non_Specialty_Formulary_Name__c && rebate.Modeled_Non_Specialty_PlanDesign__c == rg.Modeled_Non_Specialty_PlanDesign__c)
                           {
                              if(rg.Rate_Percentage_Combination__c==rebate.Rate_Percentage_Combination__c  && rg.id!=rebate.id && rg.Basis__c==rebate.Basis__c){
                             AggrMail= rebate.Template_Mail_Formula__c + '\n';
                              }
                              else{
                                  AggrMail+= rebate.Template_Mail_Formula__c + '\n';
                              }
                             MailExist = true;
                           }
                           if (rebate.Mail_Display__c == true && rebate.Mail__c !=0 && rebate.Mail__c!=null && rebate.Pecentage_Guarantee__c == false && rebate.Modeled_Non_Specialty_Formulary_Name__c == rg.Modeled_Non_Specialty_Formulary_Name__c && rebate.Modeled_Non_Specialty_PlanDesign__c == rg.Modeled_Non_Specialty_PlanDesign__c)
                           {
                             if(rg.Rate_Percentage_Combination__c==rebate.Rate_Percentage_Combination__c && rg.id!=rebate.id && rg.Basis__c==rebate.Basis__c){
                             AggrMail= rebate.Template_Mail_Formula__c + '\n';
                             }
                             else{
                                AggrMail+= rebate.Template_Mail_Formula__c + '\n'; 
                             }
                             MailExist  = true;
                           }  
                        
                           
                           //Mchoice Information population
                           if ((rebate.Maintenance_Choice_Display__c == true || rg.Template_Mail_Label_Text__c ==  'MAIL') && rebate.Mchoice_1__c !=0 && rebate.Mchoice_1__c!=null && rebate.Pecentage_Guarantee__c == true && rebate.Modeled_Non_Specialty_Formulary_Name__c == rg.Modeled_Non_Specialty_Formulary_Name__c && rebate.Modeled_Non_Specialty_PlanDesign__c == rg.Modeled_Non_Specialty_PlanDesign__c)
                           {
                            if(rg.Rate_Percentage_Combination__c==rebate.Rate_Percentage_Combination__c && rg.id!=rebate.id && rg.Basis__c==rebate.Basis__c){
                             AggrMchoice+= rebate.Template_Mchoice_Formula__c + '\n';
                            }
                            else{
                             AggrMchoice= rebate.Template_Mchoice_Formula__c + '\n';
                            }
                             MchoiceExist = true;
                           }
                           if ((rebate.Maintenance_Choice_Display__c == true || rg.Template_Mail_Label_Text__c ==  'MAIL') && rebate.Mchoice__c !=0 && rebate.Mchoice__c!=null && rebate.Pecentage_Guarantee__c == false && rebate.Modeled_Non_Specialty_Formulary_Name__c == rg.Modeled_Non_Specialty_Formulary_Name__c && rebate.Modeled_Non_Specialty_PlanDesign__c == rg.Modeled_Non_Specialty_PlanDesign__c)
                           {
                            if(rg.Dollar_Rate_Combination__c==rebate.Dollar_Rate_Combination__c  && rg.id!=rebate.id && rg.Basis__c==rebate.Basis__c){
                             AggrMchoice= rebate.Template_Mchoice_Formula__c + '\n';
                            }
                            else{
                             AggrMchoice += rebate.Template_Mchoice_Formula__c + '\n';
                            }
                             MchoiceExist = true;
                           } 
                           //Specialty at Retail Information population
                            if (rebate.SpecialtyatRetail_Display__c == true  && rebate.Specialty_Retail_1__c !=0 && rebate.Specialty_Retail_1__c!=null && rebate.Pecentage_Guarantee__c == true && rebate.Modeled_Non_Specialty_Formulary_Name__c == rg.Modeled_Non_Specialty_Formulary_Name__c && rebate.Modeled_Non_Specialty_PlanDesign__c == rg.Modeled_Non_Specialty_PlanDesign__c)
                            {
                                if(rg.Rate_Percentage_Combination__c==rebate.Rate_Percentage_Combination__c   && rg.id!=rebate.id && rg.Basis__c==rebate.Basis__c){
                                  AggrSpecatRetail= rebate.Template_SpecialtyatRetail_Formula__c + '\n';
                                }
                                else{
                                 AggrSpecatRetail+= rebate.Template_SpecialtyatRetail_Formula__c + '\n';
                                }
                             SpecialtyatRetailExist = true;
                            }
                            System.debug('In rate loop');
                            if (rebate.SpecialtyatRetail_Display__c == true  && rebate.Specialty_Retail__c !=0 && rebate.Specialty_Retail__c!=null && rebate.Pecentage_Guarantee__c == false && rebate.Modeled_Non_Specialty_Formulary_Name__c == rg.Modeled_Non_Specialty_Formulary_Name__c && rebate.Modeled_Non_Specialty_PlanDesign__c == rg.Modeled_Non_Specialty_PlanDesign__c)
                            {
                                if(rg.Dollar_Rate_Combination__c==rebate.Dollar_Rate_Combination__c   && rg.id!=rebate.id && rg.Basis__c==rebate.Basis__c){
                                  AggrSpecatRetail= rebate.Template_SpecialtyatRetail_Formula__c + '\n';
                                }
                                else{
                                AggrSpecatRetail+= rebate.Template_SpecialtyatRetail_Formula__c + '\n';  
                                    
                                }
                             SpecialtyatRetailExist = true;
                            }
                          
                             if(rg.Percentage_Check__c==false && rebate.Non_Specialty_Formulary_2__c == rg.Non_Specialty_Formulary_2__c && rebate.GSTP__c == rg.GSTP__c && rebate.Plan_Design__c== rg.Plan_Design__c ){
                                System.debug('In rate loop'+rg.Percentage_Check__c);
                                
                                    Modeledformulary+=rg.Dollar_Rate_Combination__c+rebate.Dollar_Rate_Combination__c;
                            }
                            if(rg.Percentage_Check__c==true && rebate.Non_Specialty_Formulary_2__c == rg.Non_Specialty_Formulary_2__c && rebate.GSTP__c == rg.GSTP__c && rebate.Plan_Design__c== rg.Plan_Design__c){
                                System.debug('In rate loop'+rg.Percentage_Check__c);
                                
                                    Modeledformulary+=rg.Rate_Percentage_Combination__c+rebate.Rate_Percentage_Combination__c;
                            }
                            
                    //}
                     
                   }
                }
                if(MinSpecAgreegate != null && MinSpecAgreegate.get(rg.Template_Specialty_Grid_Name_Text__c) != null) 
                {
                  AggregateResult  vName = MinSpecAgreegate.get(rg.Template_Specialty_Grid_Name_Text__c);
                  if (vName.get('MinName') == rg.Name) 
                  {
                     ShowSpecGrid = true;
                     for (Rebate_Guarantees__c rebate : AgreegateRate)
                     {
 
 
                       //Specialty at CVS Information population
                       if (rebate.Specialty_Display__c == true  && rebate.Specialty_1__c !=0 && rebate.Specialty_1__c!=null && rebate.Pecentage_Guarantee__c == true && rebate.Modeled_Specialty_Formulary_Name__c == rg.Modeled_Specialty_Formulary_Name__c && rebate.Modeled_Specialty_PlanDesign__c == rg.Modeled_Specialty_PlanDesign__c && rebate.Modeled_Non_Specialty_Formulary_Name__c == rg.Modeled_Non_Specialty_Formulary_Name__c)
                       {
                         AggrSpecatCVS += rebate.Template_Specialty_Formula__c + '\n';
                         SpecialtyatCVSExist = true;
                       }
                       
                       if (rebate.Specialty_Display__c == true  && rebate.Specialty__c !=0 && rebate.Specialty__c!=null && rebate.Pecentage_Guarantee__c == false && rebate.Modeled_Specialty_Formulary_Name__c == rg.Modeled_Specialty_Formulary_Name__c && rebate.Modeled_Specialty_PlanDesign__c == rg.Modeled_Specialty_PlanDesign__c && rebate.Modeled_Non_Specialty_Formulary_Name__c == rg.Modeled_Non_Specialty_Formulary_Name__c)
                       {
                         AggrSpecatCVS += rebate.Template_Specialty_Formula__c + '\n';
                         SpecialtyatCVSExist = true;
                       }
                       
 
                     }
                     /********************************************************/
                        //Start--Changes for Row Alligment :Mohit Srivastava
                      /********************************************************/
                        Boolean  rowFlag=false;
                        //Identifying if we have any duplicate drug name using Map : myMap
                        //Integer counter=1;
                        for (Rebate_Gtees_Specialty_Class_Carve_Outs__c rc: Rcurve.values())
                        {
                       
                             if(rc.Drug_Therapy_Class_2__c!=null){
                            // if((rc.LOB2__c == rg.LOB2__c))   // Change as part of US 170
                               // {
                                    setDupList.add(rc.Drug_Therapy_Class_2__c);
                                    if(rc.Year__c!='All'){
                                    Integer counter=1;
                                        if(mapYear.containsKey(rc.Drug_Therapy_Class_2__c)){
                                           counter=mapYear.get(rc.Drug_Therapy_Class_2__c)+1;
                                           System.debug('Counter'+counter+'Drug Name'+rc.Drug_Therapy_Class_2__c);
                                           mapYear.put(rc.Drug_Therapy_Class_2__c,counter);
                                        }else{
                                            mapYear.put(rc.Drug_Therapy_Class_2__c,0);
                                        }   
                                    }
                                    else{
                                    yearAllset.add(rc.Year__c);
                                    mapYearAll.put(rc.Drug_Therapy_Class_2__c,yearAllset.size());
                                    }
                            }
                           
                        }
                        for(String key :setDupList)
                        {
                            if(!myMap.containsKey(key)){
                                myMap.put(key,0);
                                }
                                
                                Integer currentInt=myMap.get(key)+1;
                                
                                myMap.put(key,currentInt);
                               
                        }
                       for (Rebate_Gtees_Specialty_Class_Carve_Outs__c rc: Rcurve.values())
                       {
                     
                         Datetime stdt =rc.Year_Begin_Date__c;
                         Datetime eddt = rc.Year_End_Date__c;
                         String RightLabel=System.Label.Right_Allign;
                         if(rc.Drug_Therapy_Class_2__c!=null){
                             if(rc.Rebate_Operations__c==rg.Rebate_Operations__c ) // Removed (rc.LOB2__c == rg.LOB2__c) && Change as part of US 170 
                            {
                                RcurveExist = true;
                                
                                    if(mapYear.get(rc.Drug_Therapy_Class_2__c)==null && mapYearAll.get(rc.Drug_Therapy_Class_2__c)==1){
                                        System.debug('111'+rc.Drug_Therapy_Class_2__c);
                                        StrPhaben=rc.Drug_Therapy_Class_2__c +'\n';
                                        Pharbenlabel.add(StrPhaben);
                                    }
                                  else if(mapYear.get(rc.Drug_Therapy_Class_2__c)==0 && mapYearAll.get(rc.Drug_Therapy_Class_2__c)==1){
                                        System.debug('111'+rc.Drug_Therapy_Class_2__c);
                                        StrPhaben=rc.Drug_Therapy_Class_2__c +'\n'+'\n';
                                        Pharbenlabel.add(StrPhaben);
                                    }
                                   else if(mapYear.get(rc.Drug_Therapy_Class_2__c)==0 && mapYearAll.get(rc.Drug_Therapy_Class_2__c)==null){
                                         System.debug('222'+rc.Drug_Therapy_Class_2__c);
                                        StrPhaben=rc.Drug_Therapy_Class_2__c +'\n';
                                        Pharbenlabel.add(StrPhaben);
                                    }
                                   else if(mapYear.get(rc.Drug_Therapy_Class_2__c)==1 && mapYearAll.get(rc.Drug_Therapy_Class_2__c)==1){
                                         System.debug('3333'+rc.Drug_Therapy_Class_2__c + 'All------------'+mapYearAll.get(rc.Drug_Therapy_Class_2__c));
                                        StrPhaben=rc.Drug_Therapy_Class_2__c +'\n'+'\n'+'\n';
                                        Pharbenlabel.add(StrPhaben);
                                    }
                                   else if(mapYear.get(rc.Drug_Therapy_Class_2__c)==1 && mapYearAll.get(rc.Drug_Therapy_Class_2__c)==null){
                                         System.debug('444'+rc.Drug_Therapy_Class_2__c);
                                        StrPhaben=rc.Drug_Therapy_Class_2__c +'\n' +'\n';
                                        Pharbenlabel.add(StrPhaben);
                                    }
                                    else if(mapYear.get(rc.Drug_Therapy_Class_2__c)==2 && mapYearAll.get(rc.Drug_Therapy_Class_2__c)==1){
                                        StrPhaben=rc.Drug_Therapy_Class_2__c +'\n' +'\n'+'\n'+'\n';
                                        Pharbenlabel.add(StrPhaben);
                                    }
                                     else if(mapYear.get(rc.Drug_Therapy_Class_2__c)==2 && mapYearAll.get(rc.Drug_Therapy_Class_2__c)==null){
                                        StrPhaben=rc.Drug_Therapy_Class_2__c +'\n' +'\n'+'\n';
                                        Pharbenlabel.add(StrPhaben);
                                    }
                                    else if(mapYear.get(rc.Drug_Therapy_Class_2__c)==3 && mapYearAll.get(rc.Drug_Therapy_Class_2__c)==null){
                                        StrPhaben=rc.Drug_Therapy_Class_2__c +'\n' +'\n'+'\n'+'\n';
                                        Pharbenlabel.add(StrPhaben);
                                    }
                                    else if(mapYear.get(rc.Drug_Therapy_Class_2__c)==3 && mapYearAll.get(rc.Drug_Therapy_Class_2__c)==1){
                                        StrPhaben=rc.Drug_Therapy_Class_2__c +'\n' +'\n'+'\n'+'\n'+'\n';
                                        Pharbenlabel.add(StrPhaben);
                                    }
                                    else if(mapYear.get(rc.Drug_Therapy_Class_2__c)==4 && mapYearAll.get(rc.Drug_Therapy_Class_2__c)==null){
                                        StrPhaben=rc.Drug_Therapy_Class_2__c +'\n' +'\n'+'\n'+'\n'+'\n';
                                        Pharbenlabel.add(StrPhaben);
                                    }
                                    else if(mapYear.get(rc.Drug_Therapy_Class_2__c)==4 && mapYearAll.get(rc.Drug_Therapy_Class_2__c)==1){
                                        StrPhaben=rc.Drug_Therapy_Class_2__c +'\n' +'\n'+'\n'+'\n'+'\n'+'\n';
                                        Pharbenlabel.add(StrPhaben);
                                    }
                                   
                                }
                        }
                         if( rc.Year__c!= 'All') // (rc.LOB2__c == rg.LOB2__c)  && cHANGE AS PART OF us 170
                         {
                          if(rc.FAF_Print_Specialty__c != null)
                          Pharbenvalue.add(stdt.formatGMT('MM/dd/yyyy') + ' - ' + eddt.formatGMT('MM/dd/yyyy') + ': '  + rc.FAF_Print_Specialty__c + ' Per claim' + '\n');   
                          else
                          Pharbenvalue.add(stdt.formatGMT('MM/dd/yyyy') + ' - ' + eddt.formatGMT('MM/dd/yyyy') + ': '  + ' Per claim' + '\n');        
                         }
                         if( rc.Year__c== 'All') // (rc.LOB2__c == rg.LOB2__c)  && Change part of US 170
                         {
                          if(rc.FAF_Print_Specialty__c != null)
                          Pharbenvalue.add( rc.FAF_Print_Specialty__c + ' Per claim' + '\n'); 
                          else
                          Pharbenvalue.add(' Per claim' + '\n');       
                         }
                       }
                    }
                }
                
                       
                      
                      
                      
   
    if(RetailExist == true)
                  { 
                       rg.Template_Retail_Text__c = AggrRetail;
                       rg.Template_Retail_Display__c = true;                                                   
                   }
                   else
                  {
                       rg.Template_Retail_Text__c = ' ';
                       rg.Template_Retail_Display__c = false; 
                  }            
   if(Retail30Exist == true)
                  { 
                       rg.Template_Retail30_Text__c = AggrRetail30;
                       rg.Template_Retail30_Display__c = true;                                                   
                   }
                   else
                  {
                       rg.Template_Retail30_Text__c = ' ';
                       rg.Template_Retail30_Display__c = false; 
                  }  
    if(Retail90Exist == true)
                  { 
                       rg.Template_Retail90_Text__c = AggrRetail90;
                       rg.Template_Retail90_Display__c = true;                                                   
                   }
                   else
                  {
                       rg.Template_Retail90_Text__c = ' ';
                       rg.Template_Retail90_Display__c = false; 
                  }                   
    if(ClientOwnedExist == true)
                  { 
                       rg.Template_Clientowned_Text__c = AggrClientOwned;
                       rg.Template_ClientOwned_Display__c = true;                                                   
                   }
                   else
                  {
                       rg.Template_Clientowned_Text__c = ' ';
                       rg.Template_ClientOwned_Display__c = false; 
                  }            
   if(ClientOwned30Exist == true)
                  { 
                       rg.Template_Clientowned30_Text__c = AggrClientOwned30;
                       rg.Template_ClientOwned30_Display__c = true;                                                   
                   }
                   else
                  {
                       rg.Template_Clientowned30_Text__c = ' ';
                       rg.Template_ClientOwned30_Display__c = false; 
                  }  
     if(ClientOwned90Exist == true)
                  { 
                       rg.Template_Clientowned90_Text__c = AggrClientOwned90;
                       rg.Template_ClientOwned90_Display__c = true;                                                   
                   }
                   else
                  {
                       rg.Template_Clientowned90_Text__c = ' ';
                       rg.Template_ClientOwned90_Display__c = false; 
                  }  
    if(MailExist == true)
                  { 
                       rg.Template_Mail_Text__c = AggrMail;
                       rg.Template_Mail_Display__c = true;                                                   
                   }
                   else
                  {
                       rg.Template_Mail_Text__c = ' ';
                       rg.Template_Mail_Display__c = false; 
                  }     
     if(MchoiceExist == true)
                  { 
                       rg.Template_Mchoice_Text__c = AggrMchoice;
                       rg.Template_Mchoice_Display__c = true;                                                   
                   }
                   else
                  {
                       rg.Template_Mchoice_Text__c = ' ';
                       rg.Template_Mchoice_Display__c = false; 
                  }   
      
     if(SpecialtyatRetailExist == true)
                  { 
                       rg.Template_SpecialtyatRetail_Text__c = AggrSpecatRetail;
                       rg.Template_SpecialtyatRetail_Display__c = true;                                                   
                   }
                   else
                  {
                       rg.Template_SpecialtyatRetail_Text__c = ' ';
                       rg.Template_SpecialtyatRetail_Display__c = false; 
                  }   
                  
      if(SpecialtyatCVSExist == true)
                  { 
                       rg.Template_SpecialtyatCVS_Text__c = AggrSpecatCVS;
                            rg.Template_SpecialtyatCVS_Display__c = true;    
                       
                   }
                   else
                  {
                       rg.Template_SpecialtyatCVS_Text__c = ' ';
                       rg.Template_SpecialtyatCVS_Display__c = false; 
                  }                  
             Map<String, Integer> mapsize=new Map<String, Integer>();
      if(RcurveExist == true && LoopCount == false)            
                  { 
                        LoopCount = true;
                        for (String value: Pharbenvalue)
                        {
                         if(rg.Template_Specialty_Carveout_Text__c == null)
                          rg.Template_Specialty_Carveout_Text__c  = value;
                           else
                          rg.Template_Specialty_Carveout_Text__c += value;
                        }  
                       for (String label : Pharbenlabel)
                        {
                         if(rg.Template_Specialty_Carveout_Label_Text__c == null){
                           rg.Template_Specialty_Carveout_Label_Text__c =label;
                            mapsize.put(Label,Label.length());
                         }
                          else{
                           rg.Template_Specialty_Carveout_Label_Text__c +=label;
                            mapsize.put(Label,Label.length());
                           }
                        }
                        System.debug('==========mapsize=========='+mapsize);
                         
                       rg.Template_Rcurve_Display__c = true;                                                   
                   }
                   else
                  {
                       rg.Template_Specialty_Carveout_Label_Text__c = ' ';
                       rg.Template_Specialty_Carveout_Text__c = ' ';
                       rg.Template_Rcurve_Display__c = false; 
                  } 
                                                                                                            
       if(ShowNonSpecGrid ==false)
                   { 
                       rg.Show_in_Non_Specialty_Grid__c = false;
                   }  
        if(ShowSpecGrid == false)
                   { 
                       rg.Show_in_Specialty_Grid__c = false;
                   }  
        if((Modeledformulary!=null || Modeledformulary!='') ){
                                 rg.PCD_Aggregate_Rate__c=Modeledformulary.removeStart('null');
        }

   
     Rgeeupdate.add(rg);
System.debug('*****Rgeeupdate****'+Rgeeupdate);
}
if (Rgeeupdate != null && !Rgeeupdate.isEmpty())
{
    
   Database.Update(Rgeeupdate);
    DeepCloneUtility.OFF_INVOCABLE_CLASS = true;

   Template_Rebate_Grid_Same_Rate(Rgeeupdate);
}
  
           
}

//}
catch(DmlException e)
    {
     System.debug(e.getMessage());
    } 
}
    public static void Template_Rebate_Grid_Same_Rate(List<Rebate_Guarantees__c> rgs){
        System.debug('In next Method');
        set<ID> objId=new set<ID>();
        DeepCloneUtility.OFF_INVOCABLE_CLASS = false;
        Set<ID> SETIDs=new  set<ID>();
        Set<ID> REBATESETIDs=new  set<ID>();
        Set<ID> UniqueSETIDs=new  set<ID>();
         Set<String> NonSpecialtyDupCheck=new  set<String>();
        Boolean checkDup=false;
        Boolean UniqueCheck=false;
        map<ID,Boolean> mapUniqueCheck=new map<ID,Boolean>();
        map<ID,String> mapStringCheck=new map<ID,String>();
        map<ID,String> mapStringRebateCheck=new map<ID,String>();
        map<String,String> CHeckGridMap=new map<String,String>();
        map<String,id> SameNonSpecMap=new map<String,id>();
        map<String,String> SpecGridMap=new map<String,String>();
        map<ID,ID> mapCheck=new map<ID,ID>();
        map<id,Rebate_Guarantees__c> rebatemap = new map<id,Rebate_Guarantees__c>();
        String SameRateTier='';
        String DifferentRateTier='';

        List<Rebate_Guarantees__c> rebateList=new List<Rebate_Guarantees__c>();
         List<Rebate_Guarantees__c> rebateListUpdate=new List<Rebate_Guarantees__c>();
           List<Rebate_Guarantees__c> rebateListGridCheck=new List<Rebate_Guarantees__c>();
        for(Rebate_Guarantees__c rgObj:rgs){
            objId.add(rgObj.id);
        }
        System.debug('objIdobjId'+objId);
        PCD_FAF_Status__mdt FAFStatus = [SELECT Value__c FROM PCD_FAF_Status__mdt LIMIT 1]; 
        List<string> FAFStat = new List<string>();
        for(string s: FAFStatus.Value__c.split(','))
        {
                 FAFStat.add(s);
         }        
       
        List<Rebate_Guarantees__c> Rgee =[SELECT ID,Retail_30__c,Grid_flag__c,Ranking__c,Modeled_Non_Specialty_Plan_Dup_Check__c,UniqueCheck__c,PCD_Aggregate_Rate__c,Dollar_Rate_Combination__c,Rate_Percentage_Combination__c,Percentage_Check__c,Retail_90__c,Mchoice__c,Mail__c,Client_Owned_30__c,Client_Owned_90__c,Retail_30_1__c,Retail_90_1__c,Mchoice_1__c,Mail_1__c,Client_Owned_30_1__c,Client_Owned_90_1__c,rebate_Modeled_Non_Specialty_PlanDe_New__c,PCD_Same_dollar_and_Percentage_Value__c,Name,Rebate_Operations__c,Rebate_Sorting_Order__c,Sorting_Number__c,FAF_ID__c,Pecentage_Guarantee__c,Year_Begin_Date__c,Year_End_Date__c,Invokable_Update__c,Year__c,Template_Non_Specialty_Grid_Name_Text__c,
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
                                            FROM Rebate_Guarantees__c WHERE FAF_ID__r.FAF_Status__c IN:FAFStat  AND ID IN:objId  order by PCD_Plan_design_Sort__c Asc];
       System.debug('Rgeeeeee'+Rgee);

        List<Rebate_Guarantees__c> AgreegateRate = new List<Rebate_Guarantees__c>([SELECT Id,Ranking__c,Rebate_Sorting_Order__c,Specialty_Formulary__c,Grid_flag__c,Modeled_Non_Specialty_Plan_Dup_Check__c,UniqueCheck__c,PCD_Aggregate_Rate__c,Dollar_Rate_Combination__c,Rate_Percentage_Combination__c,PCD_Same_dollar_and_Percentage_Value__c,rebate_Modeled_Non_Specialty_PlanDe_New__c,Plan_Design__c ,Non_Specialty_Formulary_2__c,Name,LOB2__c,ClientOwned30_Display__c,ClientOwned90_Display__c,ClientOwned_Display__c,GSTP__c,Mail_Display__c,Maintenance_Choice_Display__c,
                                            Modeled_Non_Specialty_Formulary_Name__c,Modeled_Non_Specialty_PlanDesign__c,Modeled_Specialty_Formulary_Name__c,Modeled_Specialty_PlanDesign__c,Pecentage_Guarantee__c,
                                            Retail30_Display__c,Percentage_Check__c,Retail90_Display__c,Retail_Display__c,Show_in_Non_Specialty_Grid__c,Show_in_Specialty_Grid__c,SpecialtyatRetail_Display__c, Specialty_Display__c,
                                            Template_ClientOwned30_Formula__c,Template_ClientOwned90_Formula__c,Template_Mail_Formula__c,Template_Mail_Label__c,Template_Mchoice_Formula__c,Template_Non_Specialty_Grid_Name__c,
                                            Template_Non_Specialty_Plan_Design__c,Template_Retail30_Formula__c,Template_Retail90_Formula__c,Template_SpecialtyatRetail_Formula__c,Template_Specialty_Formula__c,Template_Specialty_Grid_Name__c,
                                            Template_Specialty_Plan_Design__c,Year__c,Retail_30_1__c,Retail_30__c,Retail_90__c,Retail_90_1__c,Client_Owned_30__c,Client_Owned_30_1__c,Client_Owned_90__c,Client_Owned_90_1__c,Mail__c,Mail_1__c,
                                            Mchoice__c,Mchoice_1__c,Specialty__c,Specialty_1__c,Specialty_Retail__c,Specialty_Retail_1__c
                                            FROM Rebate_Guarantees__c
                                            WHERE (Show_in_Specialty_Grid__c = true OR Show_in_Non_Specialty_Grid__c= true) AND ID IN:objId 
                                            order by PCD_Plan_design_Sort__c Asc]);
                                            //Order by Modeled_Non_Specialty_Formulary_Name__c,GSTP__c,Sorting_Number__c Asc]);  
                                            
                                            
                for(Rebate_Guarantees__c rg:Rgee){
                       for(Rebate_Guarantees__c rebate:AgreegateRate)
                       {
                            if(!SETIDs.contains(rg.id) && rg.PCD_Aggregate_Rate__c!=null && rebate.PCD_Aggregate_Rate__c!=null && rg.PCD_Aggregate_Rate__c==rebate.PCD_Aggregate_Rate__c && rg.Non_Specialty_Formulary_2__c==rebate.Non_Specialty_Formulary_2__c && rg.id!=rebate.id && rg.GSTP__c==rebate.GSTP__c && rg.Plan_design__c!=rebate.Plan_design__c ){
                                 
                                SameRateTier+=rebate.Modeled_Non_Specialty_Plan_Dup_Check__c+','; 
                                SETIDs.add(rebate.id);
                                mapStringCheck.put(rg.id,SameRateTier);
                                rebate.rebate_Modeled_Non_Specialty_PlanDe_New__c='';
                                rebate.UniqueCheck__c=false; 
                                rebate.PCD_Same_dollar_and_Percentage_Value__c=false; 
                                rebate.Grid_flag__c=false;  
                                rebate.Ranking__c=null;  
                                rebateList.add(rebate);
                                
                            }
                            if(rg.Non_Specialty_Formulary_2__c==rebate.Non_Specialty_Formulary_2__c  && rg.Show_in_Non_Specialty_Grid__c==true && rg.id!=rebate.id && !UniqueSETIDs.contains(rg.id) && rg.gstp__c==rebate.gstp__c){
                                
                                SameNonSpecMap.put(rg.Non_Specialty_Formulary_2__c+rg.GSTP__c,rg.id);
                                UniqueSETIDs.add(rebate.id);
                            }                         
                        }
                        if(SameRateTier=='' || SameRateTier==','){
                            if(rg.GSTP__c!=null){       
                                rg.rebate_Modeled_Non_Specialty_PlanDe_New__c=rg.Modeled_Non_Specialty_Plan_Dup_Check__c+'-'+rg.GSTP__c;
                            }
                            else{
                                rg.rebate_Modeled_Non_Specialty_PlanDe_New__c=rg.Modeled_Non_Specialty_Plan_Dup_Check__c;   
                            }
                            rg.PCD_Same_dollar_and_Percentage_Value__c=false;
                        }
                        else{
                            if(rg.GSTP__c!=null)
                            {
                                rg.rebate_Modeled_Non_Specialty_PlanDe_New__c=rg.Modeled_Non_Specialty_Plan_Dup_Check__c+','+SameRateTier.removeEnd(',')+'-'+rg.GSTP__c;
                            }
                            else
                            {
                               rg.rebate_Modeled_Non_Specialty_PlanDe_New__c=rg.Modeled_Non_Specialty_Plan_Dup_Check__c+','+SameRateTier.removeEnd(',');   
                            }
                            rg.PCD_Same_dollar_and_Percentage_Value__c=true;
                          if(rg.rebate_Modeled_Non_Specialty_PlanDe_New__c.contains(','))
                           {
                             CHeckGridMap.put(rg.Non_Specialty_Formulary_2__c+rg.gstp__c,rg.rebate_Modeled_Non_Specialty_PlanDe_New__c);
                            }
                          }
                        if (rg.Show_in_Non_Specialty_Grid__c== false)
                        {
                          rg.UniqueCheck__c=false; 
                        }
                        if(rg.PCD_Same_dollar_and_Percentage_Value__c==false && rg.Show_in_Non_Specialty_Grid__c== true)
                        {
                            rg.UniqueCheck__c=true;
                        }
                        else
                        {
                           rg.UniqueCheck__c=false;  
                        }
                        
                        
                        SameRateTier='';
                        rebateListUpdate.add(rg);
                       
                }
                for(Rebate_Guarantees__c rbl:rebateListUpdate){
                    rbl.Grid_flag__c=false;
                    if(CHeckGridMap.get(rbl.Non_Specialty_Formulary_2__c+rbl.gstp__c)!=null && CHeckGridMap.get(rbl.Non_Specialty_Formulary_2__c+rbl.gstp__c).contains(',') && rbl.UniqueCheck__c==false && !NonSpecialtyDupCheck.contains(rbl.Non_Specialty_Formulary_2__c+rbl.gstp__c) && rbl.Show_in_Non_Specialty_Grid__c==true){
                        rbl.Grid_flag__c=true; 
                        rbl.Sorting_Number__c=1;
                        NonSpecialtyDupCheck.add(rbl.Non_Specialty_Formulary_2__c+rbl.gstp__c);
                    }
                    else if(CHeckGridMap.keyset().contains(rbl.Non_Specialty_Formulary_2__c+rbl.gstp__c) && rbl.UniqueCheck__c==true){
                       rbl.Grid_flag__c=false;
                        rbl.Sorting_Number__c=2;
                    }
                    else if(rbl.UniqueCheck__c==true && SameNonSpecMap.get(rbl.Non_Specialty_Formulary_2__c+rbl.GSTP__c)==rbl.id){
                        rbl.Grid_flag__c=true;
                    }
                    else if(SameNonSpecMap.get(rbl.Non_Specialty_Formulary_2__c+rbl.GSTP__c)!=rbl.id && rbl.UniqueCheck__c==true && SameNonSpecMap.get(rbl.Non_Specialty_Formulary_2__c+rbl.GSTP__c)!=null){
                    rbl.Grid_flag__c=false;
                    }
                    else if(rbl.UniqueCheck__c==true && SameNonSpecMap.get(rbl.Non_Specialty_Formulary_2__c+rbl.GSTP__c)==null){
                        rbl.Grid_flag__c=true;
                    }
                    else{
                     rbl.Grid_flag__c=false;
                    }
                    if(rbl.Show_in_Non_Specialty_Grid__c==false && rbl.Show_in_Specialty_Grid__c==true){
                     rbl.Grid_flag__c=false;
                    }
                    if(rbl.rebate_Modeled_Non_Specialty_PlanDe_New__c.contains('null')){
                        //rbl.rebate_Modeled_Non_Specialty_PlanDe_New__c=rbl.rebate_Modeled_Non_Specialty_PlanDe_New__c.replace('null','');
                    }
                    
                   rebateListGridCheck.add(rbl);
                    
                }
                
                
            if(!rebateListUpdate.isEmpty()){
            
                Update rebateListGridCheck;
                Update rebateList;
            }
            DeepCloneUtility.OFF_INVOCABLE_CLASS = false;
            DeepCloneUtility.OFF_TRIGGERS_PROCBUILDER=true;
          
    }
     
}