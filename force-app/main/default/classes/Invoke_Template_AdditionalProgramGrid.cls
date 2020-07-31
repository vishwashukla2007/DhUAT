/* =================================================================================
 * @Class Name        : Invoke_Template_AdditionalProgramGrid
 * @author            : Soumendu Chowdhury
 * @created date      : 07/18/2019
 * @Purpose           : Populate Start and End Date , Show in Grid Flag and Data structure for Customer Facing Grid in Apttus Template
=======================================================================================*/
global class Invoke_Template_AdditionalProgramGrid{

/*=================================================================================
 * @Method Name       : Template_AdditionalProgramGrid
 * @author            : Soumendu Chowdhury
 * @created date      : 07/18/2019
 * @Purpose           : Populate Start and End Date , Show in Grid Flag and Data structure for Customer Facing Grid in Apttus Template
=======================================================================================*/
@InvocableMethod
global static void Template_AdditionalProgramGrid(List<id> objId)
{
try
 {
  if(DeepCloneUtility.OFF_INVOCABLE_CLASS)
  {
        DeepCloneUtility.OFF_TRIGGERS_PROCBUILDER=false;
        Clinical_Solutions__c[] ListCsols = new List<Clinical_Solutions__c>();
        Clinical_Solutions__c[] ShowinGrid = new List<Clinical_Solutions__c>();
        map<String,String> mapstr=new map<String,String>();
        Boolean ShowGrid = false;
        Boolean CSExist = false;
        PCD_FAF_Status__mdt FAFStatus = [SELECT Value__c FROM PCD_FAF_Status__mdt LIMIT 1]; 
        List<string> FAFStat = new List<string>();
        for(string s: FAFStatus.Value__c.split(','))
              {
                 FAFStat.add(s);
              }        
        List<PCD_Fee_Basis_Translation__mdt> FeeBasisMetaList=[SELECT Fee_Basis__c,Modeled_Fee_Basis__c FROM   PCD_Fee_Basis_Translation__mdt];
        List<Clinical_Solutions__c> Csols =[SELECT ID,Clinical_Operations__c,Show_in_Grid__c,FAF_ID__c,Name,
                                        Year_Start_Date__c,Year_End_Date__c,Clinical_Solution__c,Clinical_Solution_Type__c,Fee_Basis__c,Fee_Amount__c,Year__c,Template_Fee_Basis_Text__c,
                                        Template_Fee_Basis_Display__c,Template_Fee_Basis_Formula__c 
                                        FROM Clinical_Solutions__c where FAF_ID__r.FAF_Status__c IN:FAFStat and Show_in_Grid__c = true and Clinical_Operations__c IN:objId];

        Map<String,AggregateResult> MinNameAgreegate = new Map<String,AggregateResult>([SELECT Clinical_Solution__c Id, min(Name) MinName
                                        FROM Clinical_Solutions__c 
                                        WHERE FAF_ID__r.FAF_Status__c IN:FAFStat  
                                        AND   Show_in_Grid__c = true AND Clinical_Operations__c IN:objId
                                        GROUP BY Clinical_Solution__c]);
                                        
        List<Clinical_Solutions__c> AgreegateRate =[SELECT ID,Clinical_Operations__c,Show_in_Grid__c,FAF_ID__c,Name,
                                        Year_Start_Date__c,Year_End_Date__c,Clinical_Solution__c,Clinical_Solution_Type__c,Fee_Basis__c,Fee_Amount__c,Year__c,Template_Fee_Basis_Text__c,
                                        Template_Fee_Basis_Display__c,Template_Fee_Basis_Formula__c 
                                        FROM Clinical_Solutions__c where FAF_ID__r.FAF_Status__c IN:FAFStat and Show_in_Grid__c = true and Clinical_Operations__c IN:objId];

        for(PCD_Fee_Basis_Translation__mdt fb:FeeBasisMetaList)
            {
              mapstr.put(fb.Fee_Basis__c,fb.Modeled_Fee_Basis__c);
            }

        for(Clinical_Solutions__c  CSObj : Csols)
        {
        ShowGrid = false;
        CSExist = false;
        String CSRate = '';
        if(MinNameAgreegate != null && MinNameAgreegate.get(CSObj.Clinical_Solution__c) != null)
                {
                  AggregateResult  vName = MinNameAgreegate.get(CSObj.Clinical_Solution__c);
                  if ((vName.get('MinName') == CSObj.Name) && (vName.get('Id')==CSObj.Clinical_Solution__c))
                  {
                     ShowGrid = true;
                     for (Clinical_Solutions__c CSRecord : AgreegateRate)
                     {
                       if(AgreegateRate != null && !AgreegateRate.isEmpty() && (CSObj.Clinical_Solution__c == CSRecord.Clinical_Solution__c))
                          {
                            if (CSObj.Fee_Basis__c != null)
                            {
                            CSRate+= CSRecord.Template_Fee_Basis_Formula__c + ' ' + mapstr.get(CSObj.Fee_Basis__c) +  '\n' ;
                            }
                            else
                            {
                            CSRate+= CSRecord.Template_Fee_Basis_Formula__c + ' ' +  '\n' ;
                            }
                            CSExist = true;
                          }
                     }
                     
                  if(CSExist == true)
                   { 
                     CSObj.Template_Fee_Basis_Text__c = CSRate;   
                     CSObj.Template_Fee_Basis_Display__c = true;                                              
                   }
                  else
                  {
                      CSObj.Template_Fee_Basis_Text__c = ' ';
                      CSObj.Template_Fee_Basis_Display__c = false; 
                  }
                    
                  }
                 }
                 if(ShowGrid != true)
                   { 
                       CSObj.Show_in_Grid__c = false;
                       ShowinGrid.add(CSObj); 
                   }    
                 ListCsols.add(CSObj);     
        }
       if (ListCsols != null && !ListCsols.isEmpty())
        {
           Update ListCsols;
        }

       if (ShowinGrid != null && !ShowinGrid.isEmpty())
        {
           Update ShowinGrid;
        }

  }
 }

catch(Exception Ex)
  {
    system.debug('Exception....'+ex.getMessage());
  }
 }
}