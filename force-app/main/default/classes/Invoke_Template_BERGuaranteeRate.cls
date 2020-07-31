/* =================================================================================
 * @Class Name        : Invoke_Template_BERGuaranteeRate
 * @author            : Soumendu Chowdhury
 * @created date      : 05/24/2019
 * @Purpose           : Populate BER Guarantee Rate with Pricing Effective Date to display in Apttus Template
=======================================================================================*/
public class Invoke_Template_BERGuaranteeRate{
/*=================================================================================
 * @Method Name       : Template_BERGuaranteeRate
 * @author            : Soumendu Chowdhury
 * @created date      : 05/24/2019
 * @Last modified by  : Soumendu Chowdhury
 * @Purpose           : Populate BER Guarantee Rate with Pricing Effective Date to display in Apttus Template
=======================================================================================*/
@InvocableMethod
public static void Template_BERGuaranteeRate(List<Id> objId)
{ 
try
{
DeepCloneUtility.OFF_TRIGGERS_PROCBUILDER=false;
Network_Pricing__c[] ListNpricing = new List<Network_Pricing__c>();
Network_Pricing__c[] ShowinGrid = new List<Network_Pricing__c>();
Boolean BERExist = false;
Boolean ShowGrid = false;
Boolean ifBERpass = false;
if(DeepCloneUtility.OFF_INVOCABLE_CLASS){
PCD_FAF_Status__mdt FAFStatus = [SELECT Value__c FROM PCD_FAF_Status__mdt LIMIT 1]; 
List<string> FAFStat = new List<string>();
for(string s: FAFStatus.Value__c.split(','))
   {
     FAFStat.add(s);
   }      
List<Network_Pricing__c> Nprice =[SELECT Id,Show_in_Grid__c,Maintenance_Choice__c,FAF_ID__c ,FAF_ID__r.LOB2__c,
                                         Year_Begin_Date__c,Year_End_Date__c,Custom_Network_Description__c,Print_FAF_BER_Guarantee_Rate__c,
                                         Network_Name__c,Network_Name_for_Grid__c,Network_Type__c, Brand_Rate__c,BER_Guarantee_Rate__c,Year__c,FAF_Network_Ops__c,
                                         Template_Network_Name__c, Template_Brand_Rate__c,Template_BER_Guarantee_Rate__c,
                                         Template_Network_Name_Text__c,Name,Min_Name__c,Template_BER_Display__c  
                                         FROM Network_Pricing__c WHERE FAF_ID__r.FAF_Status__c IN:FAFStat AND  Year__c != 'All' 
                                         AND FAF_Network_Ops__c IN:objId ORDER BY Year__c ASC];
                 
Map<String,AggregateResult> MinYearAgreegate = new Map<String,AggregateResult>([SELECT Template_Network_Name_Text__c Id, min(Year__c) MinYear ,min(Min_Name__c) Name 
                                        FROM Network_Pricing__c 
                                        WHERE FAF_ID__r.FAF_Status__c IN:FAFStat AND 
                                        Template_Network_Name_Text__c <> NULL AND  Year__c != 'All'  AND FAF_Network_Ops__c IN:objId 
                                        GROUP BY  Template_Network_Name_Text__c]);
       
List<Network_Pricing__c> AgreegateBERRate = new List<Network_Pricing__c>([SELECT Template_Network_Name_Text__c,Brand_Basis__c,Template_BER_Guarantee_Rate__c,BER_Guarantee_Rate__c,Print_FAF_BER_Guarantee_Rate__c 
                                        FROM Network_Pricing__c 
                                        WHERE  Year__c != 'All'  AND FAF_Network_Ops__c IN:objId ORDER BY Year__c ASC]);

 for(Network_Pricing__c  netObj : Nprice){
               String AggrBERRate = '';
               BERExist = false;
               ShowGrid = false;
               ifBERpass = false;
               if(MinYearAgreegate != null && MinYearAgreegate.get(netObj.Template_Network_Name_Text__c) != null && netObj.FAF_ID__r.LOB2__c !='EGWP')
                {
                  AggregateResult vYear = MinYearAgreegate.get(netObj.Template_Network_Name_Text__c);
                  if ((vYear.get('MinYear') == netObj.Year__c) && (vYear.get('Name') == netObj.Min_Name__c))
                  {
                    for (Network_Pricing__c BERRate : AgreegateBERRate){
                      if(AgreegateBERRate != null && !AgreegateBERRate.isEmpty() && (BERRate.Template_Network_Name_Text__c == netObj.Template_Network_Name_Text__c))
                          {
                              if (BERRate.BER_Guarantee_Rate__c != null){   // US51354
                                  AggrBERRate += BERRate.Template_BER_Guarantee_Rate__c +  '\n' ; 
                              }

                            if (netObj.BER_Guarantee_Rate__c != null || BERRate.BER_Guarantee_Rate__c != null)
                             { BERExist = true;}
                            //Pass_ Through changes By: Parvathi chunduri US51354
                            if(BERRate.Brand_Basis__c == Label.Pass_Through_Rate){ifBERpass = true;}
                          }
                       
                              ShowGrid = true;
                              
                        
                  }
                  if(BERExist == true)
                   { 
                       //Pass_ Through changes By: Parvathi chunduri US51354
                       if(ifBERpass == true){
                         AggrBERRate+= '\n' + Label.Pass_Through_Text +  '\n' ; 
                       }
                       netObj.Template_BER_Guarantee_Rate_Text__c = AggrBERRate;  
                       netObj.Template_BER_Display__c = true;                                                  
                   }
                  else
                  {
                      netObj.Template_BER_Guarantee_Rate_Text__c = ' ';
                      netObj.Template_BER_Display__c = false; 
                  }
                   }   
                  
                  if(ShowGrid != true)
                   { 
                         netObj.Show_in_Grid__c = false;
                         ShowinGrid.add(netObj); 
                   }               
                }           
                          //netObj.Batch_Update__c = false;  
                          ListNpricing.add(netObj);                             
                                         }
         }
if (ListNpricing != null && !ListNpricing.isEmpty())
{
   Update ListNpricing;
}

if (ShowinGrid != null && !ShowinGrid.isEmpty())
{
   Update ShowinGrid;
}

}
catch(DmlException e)
    {
     System.debug(e.getMessage());
    } 
}
}