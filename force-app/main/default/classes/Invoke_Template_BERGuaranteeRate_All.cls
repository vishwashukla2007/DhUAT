/* =================================================================================
 * @Class Name        : Invoke_Template_BERGuaranteeRate_All
 * @author            : Soumendu Chowdhury
 * @created date      : 05/24/2019
 * @Purpose           : Populate BER Guarantee Rate with Pricing Effective Date to display in Apttus Template for Year = All
=======================================================================================*/
public class Invoke_Template_BERGuaranteeRate_All{
/*=================================================================================
 * @Method Name       : Template_BERGuaranteeRate_All
 * @author            : Soumendu Chowdhury
 * @created date      : 05/24/2019
 * @Last modified by  : Soumendu Chowdhury
 * @Purpose           : Populate BER Guarantee Rate with Pricing Effective Date to display in Apttus Template for Year = All
=======================================================================================*/
@InvocableMethod
public static void Template_BERGuaranteeRate_All(List<id> objId)
{ 
try
{
DeepCloneUtility.OFF_TRIGGERS_PROCBUILDER=false;
Network_Pricing__c[] ListNpricing = new List<Network_Pricing__c>();
Network_Pricing__c[] ShowinGrid = new List<Network_Pricing__c>();
Boolean BERExist = false;
Boolean ShowGrid = false;
Boolean ifBERPass = false;
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
                                         Template_Network_Name_Text__c,Name,Template_BER_Display__c  
                                         FROM Network_Pricing__c WHERE FAF_ID__r.FAF_Status__c IN:FAFStat  AND  Year__c = 'All' 
                                         AND FAF_Network_Ops__c IN:objId ORDER BY Year__c ASC];
                
Map<String,AggregateResult> MinYearAgreegate = new Map<String,AggregateResult>([SELECT Template_Network_Name_Text__c Id, min(Name) Name
                                        FROM Network_Pricing__c 
                                        WHERE FAF_ID__r.FAF_Status__c IN:FAFStat AND 
                                        Template_Network_Name_Text__c <> NULL AND  Year__c = 'All'  AND FAF_Network_Ops__c IN:objId 
                                        GROUP BY  Template_Network_Name_Text__c]);
       
List<Network_Pricing__c> AgreegateBERRate = new List<Network_Pricing__c>([SELECT Template_Network_Name_Text__c,Brand_Basis__c,Template_BER_Guarantee_Rate__c,BER_Guarantee_Rate__c,Print_FAF_BER_Guarantee_Rate__c
                                        FROM Network_Pricing__c 
                                        WHERE Network_Name_for_Grid__c <> NULL   AND  Year__c = 'All' AND FAF_Network_Ops__c IN:objId
                                        ORDER BY Year__c ASC]);

 for(Network_Pricing__c  netObj : Nprice){
               String AggrBERRate = '';
               BERExist = false;
               ShowGrid = false;
               ifBERPass = false;
               if(MinYearAgreegate != null && MinYearAgreegate.get(netObj.Template_Network_Name_Text__c) != null && netObj.FAF_ID__r.LOB2__c !='EGWP')
                {
                  AggregateResult vName = MinYearAgreegate.get(netObj.Template_Network_Name_Text__c);
                  if (vName.get('Name') == netObj.Name)
                  {
                    for (Network_Pricing__c BERRate : AgreegateBERRate){
                      if(AgreegateBERRate != null && !AgreegateBERRate.isEmpty() && (BERRate.Template_Network_Name_Text__c == netObj.Template_Network_Name_Text__c))
                          {
                              if (BERRate.BER_Guarantee_Rate__c != null){   // US51354
                                 AggrBERRate += BERRate.Template_BER_Guarantee_Rate__c +  '\n' ;  
                              }
                             if (netObj.BER_Guarantee_Rate__c != null || BERRate.BER_Guarantee_Rate__c != null)
                             {BERExist = true;}
                              //Pass_ Through changes By: Parvathi chunduri US51354
                             if(BERRate.Brand_Basis__c == Label.Pass_Through_Rate){ifBERPass = true;}
                          }
                        
                              
                                                      
                  }
                  ShowGrid = true;
                  if(BERExist == true)
                   { 
                       //Pass_ Through changes By: Parvathi Chunduri US51354
                       if(ifBERPass == true){
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