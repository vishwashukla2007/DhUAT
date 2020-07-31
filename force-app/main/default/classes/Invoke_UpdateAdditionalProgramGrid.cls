/* =================================================================================
 * @Class Name        : Invoke_UpdateAdditionalProgramGrid
 * @author            : Soumendu Chowdhury
 * @created date      : 07/18/2019
 * @Purpose           : Populate Start and End Date , Show in Grid Flag and Data structure for Customer Facing Grid in Apttus Template
=======================================================================================*/
global class Invoke_UpdateAdditionalProgramGrid{

/*=================================================================================
 * @Method Name       : UpdateAdditionalProgramGrid
 * @author            : Soumendu Chowdhury
 * @created date      : 07/18/2019
 * @Purpose           : Populate Start and End Date , Show in Grid Flag and Data structure for Customer Facing Grid in Apttus Template
=======================================================================================*/
@InvocableMethod
global static void UpdateAdditionalProgramGrid(List<id> objId)
{
try
 {
  if(DeepCloneUtility.OFF_INVOCABLE_CLASS)
  {
        DeepCloneUtility.OFF_TRIGGERS_PROCBUILDER=false;
        Set<id> ids=new set<id>();
        Set<id> FAFids=new set<id>();
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
        Set<String> additionprog=new Set<String>();
        Map<String,String> MapGridDisplay=new Map<String,String>();
        Map<id,Clinical_Solutions__c> MapYearComb = new Map<id,Clinical_Solutions__c>();
        Set<String> yearstr=new Set<String>();
        

        PCD_FAF_Status__mdt FAFStatus = [SELECT Value__c FROM PCD_FAF_Status__mdt LIMIT 1]; 
        List<string> FAFStat = new List<string>();
        for(string s: FAFStatus.Value__c.split(','))
              {
                 FAFStat.add(s);
              }                                                                                             

        List<Clinical_Solutions__c> Scope =[SELECT ID,IUMS_Upload__c,Custom_Description__c,Clinical_Operations__c,Clinical_Solution_Unique_Comb__c,Show_in_Grid__c,FAF_ID__c ,
                                        Year_Start_Date__c,Year_End_Date__c,Clinical_Solution__c,Clinical_Solution_Type__c,Fee_Basis__c,Fee_Amount__c,Year__c 
                                        FROM Clinical_Solutions__c where FAF_ID__r.FAF_Status__c IN:FAFStat and Clinical_Operations__c IN:objId];
        
            for(Clinical_Solutions__c  clinicalObj : scope){
               ids.add(clinicalObj.id);
               FAFids.add(clinicalObj.FAF_ID__c);
               additionprog.add(clinicalObj.Clinical_Solution_Unique_Comb__c);
               yearstr.add(clinicalObj.Year__c);
               if(clinicalObj.Year__c=='All'){
               MapYearComb.put(clinicalObj.Id,clinicalObj);
               }
            }
        List<Grid_Display_Name_Setting__c> gridDisplayList=[Select ID,Additional_Program_Grid_Name__c,Additional_Program_Combination__c,Object_Name__c,FAF__c FROM Grid_Display_Name_Setting__c where FAF__c IN:FAFids and Object_Name__c='Clinical Solution'];
        for(Grid_Display_Name_Setting__c gdr:gridDisplayList){
            MapGridDisplay.put(gdr.Additional_Program_Combination__c,gdr.Additional_Program_Grid_Name__c);
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
         List<Clinical_Solutions__c>  clinicalObj = new List<Clinical_Solutions__c>();    
            for(Clinical_Solutions__c  clinObj : scope)
              {
                 clinObj.Show_in_Grid__c=true;
                 for(Clinical_Solutions__c cs: MapYearComb.values())
                   {
                    if((clinObj.Year__c=='1'|| clinObj.Year__c=='2' ||clinObj.Year__c=='3' ||clinObj.Year__c=='4'|| clinObj.Year__c=='5') && cs.Year__c=='All' && (clinObj.Clinical_Solution__c == cs.Clinical_Solution__c))
                    {
                        clinObj.Show_in_Grid__c=false;
                    }
                   }
                
                if(clinObj.Year__c=='All')
                {
                clinObj.Show_in_Grid__c=true;
                }
               if(clinObj.Year__c=='1' && clinObj.Year_Start_Date__c==null){
                clinObj.Year_Start_Date__c=MapYear1Begin.get(clinObj.FAF_ID__c);
                }
                if(clinObj.Year__c=='2' && clinObj.Year_Start_Date__c==null){
                    clinObj.Year_Start_Date__c=MapYear2Begin.get(clinObj.FAF_ID__c);
                }
                if(clinObj.Year__c=='3' && clinObj.Year_Start_Date__c==null){
                    clinObj.Year_Start_Date__c=MapYear3Begin.get(clinObj.FAF_ID__c);
                }
                if(clinObj.Year__c=='4' && clinObj.Year_Start_Date__c==null){
                    clinObj.Year_Start_Date__c=MapYear4Begin.get(clinObj.FAF_ID__c);
                }
                if(clinObj.Year__c=='5' && clinObj.Year_Start_Date__c==null){
                    clinObj.Year_Start_Date__c=MapYear5Begin.get(clinObj.FAF_ID__c);
                }
                // Year End Date 
                
                if(clinObj.Year__c=='1' && clinObj.Year_End_Date__c==null){
                clinObj.Year_End_Date__c=MapYear1End.get(clinObj.FAF_ID__c);
                }
                if(clinObj.Year__c=='2' && clinObj.Year_End_Date__c==null){
                    clinObj.Year_End_Date__c=MapYear2End.get(clinObj.FAF_ID__c);
                }
                if(clinObj.Year__c=='3' && clinObj.Year_End_Date__c==null){
                    clinObj.Year_End_Date__c=MapYear3End.get(clinObj.FAF_ID__c);
                }
                if(clinObj.Year__c=='4' && clinObj.Year_End_Date__c==null){
                    clinObj.Year_End_Date__c=MapYear4End.get(clinObj.FAF_ID__c);
                }
                if(clinObj.Year__c=='5' && clinObj.Year_End_Date__c==null){
                    clinObj.Year_End_Date__c=MapYear5End.get(clinObj.FAF_ID__c);
                }
                //For Year All
                
                if(clinObj.Year__c=='All'){
                    clinObj.Year_End_Date__c=MapContractEndDt.get(clinObj.FAF_ID__c);
                }
                if(clinObj.Year__c=='All'){
                    clinObj.Year_Start_Date__c=MapContractDt.get(clinObj.FAF_ID__c);
                }       
                clinObj.Template_Fee_Basis_Text__c = ' ';  
                if(clinObj.IUMS_Upload__c==true){
                    if(clinObj.Custom_Description__c==''|| clinObj.Custom_Description__c==null){
                        if(MapGridDisplay!=null){
                        clinObj.Custom_Description__c=MapGridDisplay.get(clinObj.Clinical_Solution_Unique_Comb__c); 
                        }
                        else{
                             clinObj.Custom_Description__c='ADDITIONAL PROGRAMS'; 
                        }
                    }
                }
                else{
                    if(clinObj.Custom_Description__c==''|| clinObj.Custom_Description__c==null){
                        clinObj.Custom_Description__c='ADDITIONAL PROGRAMS'; 
                    }
                }
                clinicalObj.add(clinObj);
                
        }
        if(!clinicalObj.isEmpty())
          {
            update clinicalObj;
          }
 


  }
 }

catch(Exception Ex)
  {
    system.debug('Exception....'+ex.getMessage());
  }
 }
}