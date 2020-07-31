/* =================================================================================
 * @Class Name        : Invoke_UpdateNetworkPricing
 * @author            : Mohit Srivastava(Accenture)
 * @created date      : 05/24/2019
 * @Purpose           : PopulatePricingEffective
=======================================================================================*/
global class Invoke_UpdateNetworkPricing{



/*=================================================================================
 * @Method Name       : UpdateNetworkPricing
 * @author            : Mohit Srivastava(Accenture)
 * @created date      : 05/24/2019
 * @Last modified by  : Mohit Srivastava(Accenture)
 * @Purpose           : Populate Effective Date
=======================================================================================*/
@InvocableMethod
global static void UpdateNetworkPricing(List<id> objId)
{
  if(DeepCloneUtility.OFF_INVOCABLE_CLASS){
        DeepCloneUtility.OFF_TRIGGERS_PROCBUILDER=false;
        Set<id> ids=new set<id>();
        Set<id> FAFids=new set<id>();
        map<Id,Decimal> mapGuar=new map<Id,Decimal>();
        map<Id,Decimal> mapMER=new map<Id,Decimal>();
        map<Id,Decimal> mapNED=new map<Id,Decimal>();
        map<Id,Decimal> mapGER=new map<Id,Decimal>(); // updated on 06/06
        map<Id,Decimal> mapSSG=new map<Id,Decimal>(); // updated on 06/23
        map<Id,Boolean> mapBol=new map<Id,Boolean>();
        map<Id,Decimal> mapOED=new map<Id,Decimal>(); 
        map<String,String> mapstr=new map<String,String>();
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
        Map<String,String> MapGridDisplay = new Map<String,String>();
        Map<id,List<Network_Pricing__c>> MapYearComb = new Map<id,List<Network_Pricing__c>>();
        List<Network_Pricing__c> netAll=new List<Network_Pricing__c>();
         Set<String> yearstr=new Set<String>();
        
        List<Retail_Network_Name_Translations__mdt> CustomMetaList=[SELECT Label,Translated_Network_Name__c,Retail_Network_Name__c
                                                                    FROM Retail_Network_Name_Translations__mdt];
         PCD_FAF_Status__mdt FAFStatus = [SELECT Value__c FROM PCD_FAF_Status__mdt LIMIT 1]; 
        List<string> FAFStat = new List<string>();
         set<string> NameCombo = new set<string>();
        for(string s: FAFStatus.Value__c.split(','))
              {
                 FAFStat.add(s);
              }                                                       
        List<Network_Pricing__c> Scope =[SELECT ID,IUMS_Upload__c,Network_Name_Combination__c,Custom_Description__c,FAF_Network_Ops__c,Template_BER_Guarantee_Rate__c,Network_Type__c, Show_in_Grid__c,Maintenance_Choice__c,FAF_ID__c ,
                                        Year_Begin_Date__c,Generic_Basis__c,Year_End_Date__c,Custom_Network_Description__c,MER_Guarantee_Rate__c,NED_Guarantee_Rate__c,GER_Guarantee_Rate__c,
                                        Network_Name__c,Network_Name_for_Grid__c,Invokable_Update__c,BER_Guarantee_Rate__c,SSG_Guarantee_Rate__c,Year__c,Template_Network_Name_Text__c,Template_Network_Name__c,Template_MCCP__c 
                                        FROM Network_Pricing__c where FAF_ID__r.FAF_Status__c IN:FAFStat and FAF_Network_Ops__c IN:objId];
        
            for(Network_Pricing__c  netObj : scope){
               ids.add(netObj.id);
               
               FAFids.add(netObj.FAF_ID__c);
               if(netObj.IUMS_Upload__c==true){
               NameCombo.add(netObj.Network_Name_Combination__c);
               }
               yearstr.add(netObj.Year__c);
               if(netObj.Year__c=='All'){
               netAll.add(netObj);
               //MapYearComb.put(netObj.FAF_Network_Ops__c,netObj);
               MapYearComb.put(netObj.FAF_Network_Ops__c,netAll);
               }
            }
            system.debug('NameCombo'+NameCombo);
            if(!NameCombo.isEmpty()){
                    List<Grid_Display_Name_Setting__c> gridDisplayList=[Select ID,Network_Combination__c,Network_Name_Combination__c,Object_Name__c,FAF__c,Grid_Display_Name__c FROM Grid_Display_Name_Setting__c where FAF__c IN:FAFids and Object_Name__c='Network Pricing' and Network_Combination__c IN:NameCombo];
                    for(Grid_Display_Name_Setting__c gdr:gridDisplayList){
                     MapGridDisplay.put(gdr.Network_Combination__c,gdr.Grid_Display_Name__c);
                    }
            }
          system.debug('MapGridDisplay'+MapGridDisplay);
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
         /*** Transalation Name Update ****/
            for(Retail_Network_Name_Translations__mdt nr:CustomMetaList){
              mapstr.put(nr.Retail_Network_Name__c,nr.Translated_Network_Name__c);
            }
         /*** Transalation Name Update ****/
         /****Brand Rate update according to the gurantee type*****/
            List<Retail_Network_Guarantees__c> Grlist=[SELECT ID ,Type__c,Rate__c,Network_Pricing__c from Retail_Network_Guarantees__c where Network_Pricing__c IN :ids Order By LastModifiedDate ASC];
                for (Retail_Network_Guarantees__c guarObj :Grlist ){
                    if(guarObj.Type__c=='BER'){
                    mapGuar.put(guarObj.Network_Pricing__c,guarObj.Rate__c);
                    }
                    if(guarObj.Type__c=='MER'){
                    mapMER.put(guarObj.Network_Pricing__c,guarObj.Rate__c);
                    }
                    if(guarObj.Type__c=='NED'){
                    mapNED.put(guarObj.Network_Pricing__c,guarObj.Rate__c);
                    }
                    if(guarObj.Type__c=='GER'){
                    mapGER.put(guarObj.Network_Pricing__c,guarObj.Rate__c);
                    }
                    if(guarObj.Type__c=='SSG'){
                    mapSSG.put(guarObj.Network_Pricing__c,guarObj.Rate__c);
                    }
                    if(guarObj.Type__c=='OED'){
                    mapOED.put(guarObj.Network_Pricing__c,guarObj.Rate__c);
                    }
                    
                }
        /****Brand Rate update according to the gurantee type*****/
           
         
           
            List<Network_Pricing__c >  netpriceObj = new List<Network_Pricing__c>();
          
            for(Network_Pricing__c  netObj : scope){
            Boolean exclude = false;
            netObj.Show_in_Grid__c=true;
            netObj.Specialty_Show_in_Grid__c=false;
            if(netObj.Network_Name__c=='Specialty'){
                    netObj.Show_in_Grid__c=false;
                    netObj.Specialty_Show_in_Grid__c=true;
                    exclude = false;
                    //netObj.Template_Network_Name_Text__c=' ';
                }
                 for(Network_Pricing__c np:netAll)
                 {
                    if((netObj.Year__c=='1'|| netObj.Year__c=='2' ||netObj.Year__c=='3' ||netObj.Year__c=='4'|| netObj.Year__c=='5') && (netObj.Network_Name__c == np.Network_Name__c) && (netObj.Network_Type__c == np.Network_Type__c) && np.Year__c=='All')
                    {
                        netObj.Show_in_Grid__c=false;
                        netObj.Specialty_Show_in_Grid__c=false;
                        exclude = true;
                        netObj.Template_Network_Name_Text__c=' ';
                    }
                    
                }
               
                if(netObj.Year__c=='All' && netObj.Network_Name__c!='Specialty' ){
                netObj.Show_in_Grid__c=true;
                }
                netObj.Template_MCCP__c = false;
                if (netObj.Network_Name__c == Label.MCCP)
                {
                 netObj.Template_MCCP__c = true;
                }
                String strmatch = netObj.Network_Name__c + ',';
                if(netObj.Network_Name__c == Label.MCCVS || netObj.Network_Name__c == Label.BGHLTH || Label.PCD_Exclude_Networks.contains(strmatch)){
                netObj.Show_in_Grid__c=false;
                exclude = true;
                netObj.Template_Network_Name_Text__c=' ';
                }
                
                if(netObj.Network_Name__c!='Custom' && netObj.Network_Name__c!='Custom Secondary' && exclude == false){
                netObj.Network_Name_for_Grid__c=mapstr.get(netObj.Network_Name__c);
                      if (netObj.Network_Type__c != null)
                      netObj.Template_Network_Name_Text__c=mapstr.get(netObj.Network_Name__c)+'-'+netObj.Network_Type__c;
                      else if (netObj.Network_Type__c == null)
                      netObj.Template_Network_Name_Text__c=mapstr.get(netObj.Network_Name__c)+'-';
                }
                else if ((netObj.Network_Name__c=='Custom' || netObj.Network_Name__c=='Custom Secondary') && exclude == false){
                 netObj.Network_Name_for_Grid__c= netObj.Custom_Network_Description__c;
                  if (netObj.Network_Type__c != null)
                  netObj.Template_Network_Name_Text__c=netObj.Custom_Network_Description__c+'-'+netObj.Network_Type__c;
                  else if (netObj.Network_Type__c == null)
                  netObj.Template_Network_Name_Text__c=netObj.Custom_Network_Description__c+'-';
                 
                }
                 netObj.Template_BER_Guarantee_Rate_Text__c=' ';
                 netObj.Template_Brand_Rate_Text__c=' ';
                 netObj.Template_Generic_Rate_Text__c=' ';
                 netObj.Template_GER_Guarantee_Rate_Text__c=' ';
                 netObj.Template_MER_Guarantee_Rate_Text__c=' ';
                 netObj.Template_NED_Guarantee_Rate_Text__c=' ';
                 netObj.Template_Non_MAC_Generic_Rate_Text__c=' ';
                 netObj.Template_SSG_Guarantee_Rate_Text__c=' ';
                 netObj.Template_Dispensing_Fee_Text__c= ' ';
                 netObj.Template_OED_Guarantee_Rate_Text__c=' ';
                 netObj.Template_Generic_OR_Mac_Text__c = ' ';
                if(netObj.Year__c=='1' ){
                netObj.Year_Begin_Date__c=MapYear1Begin.get(netObj.FAF_ID__c);
                }
                if(netObj.Year__c=='2' ){
                    netObj.Year_Begin_Date__c=MapYear2Begin.get(netObj.FAF_ID__c);
                }
                if(netObj.Year__c=='3' ){
                    netObj.Year_Begin_Date__c=MapYear3Begin.get(netObj.FAF_ID__c);
                }
                if(netObj.Year__c=='4' ){
                    netObj.Year_Begin_Date__c=MapYear4Begin.get(netObj.FAF_ID__c);
                }
                if(netObj.Year__c=='5'){
                    netObj.Year_Begin_Date__c=MapYear5Begin.get(netObj.FAF_ID__c);
                }
                // Year End Date 
                
                if(netObj.Year__c=='1' ){
                netObj.Year_End_Date__c=MapYear1End.get(netObj.FAF_ID__c);
                }
                if(netObj.Year__c=='2' ){
                    netObj.Year_End_Date__c=MapYear2End.get(netObj.FAF_ID__c);
                }
                if(netObj.Year__c=='3' ){
                    netObj.Year_End_Date__c=MapYear3End.get(netObj.FAF_ID__c);
                }
                if(netObj.Year__c=='4' ){
                    netObj.Year_End_Date__c=MapYear4End.get(netObj.FAF_ID__c);
                }
                if(netObj.Year__c=='5' ){
                    netObj.Year_End_Date__c=MapYear5End.get(netObj.FAF_ID__c);
                }
                //For Year All
                
                if(netObj.Year__c=='All'){
                    netObj.Year_End_Date__c=MapContractEndDt.get(netObj.FAF_ID__c);
                }
                if(netObj.Year__c=='All'){
                    netObj.Year_Begin_Date__c=MapContractDt.get(netObj.FAF_ID__c);
                }
                // For BER Guarantee Rate
                
                netObj.BER_Guarantee_Rate__c=mapGuar.get(netObj.id);
                
               // For Updating Flag on Network Pricing
                
                if(netObj.Invokable_Update__c==false){
                netObj.Invokable_Update__c=true;}
                else{
                 netObj.Invokable_Update__c=false;
                }
                
                String cLabel = System.Label.Flat_Generic_Discount;
                List<String> choosingGenericRate = new List<String>();
                choosingGenericRate=cLabel.split(',');
                netObj.MER_Guarantee_Rate__c=null;
                netObj.NED_Guarantee_Rate__c=null;
                netObj.GER_Guarantee_Rate__c=null;
                netObj.OED_Guarantee_Rate__c=null;
                netObj.SSG_Guarantee_Rate__c=null;
                if(!choosingGenericRate.contains(netObj.Generic_Basis__c)){
                netObj.MER_Guarantee_Rate__c=mapMER.get(netObj.id);
                netObj.NED_Guarantee_Rate__c=mapNED.get(netObj.id); 
                netObj.GER_Guarantee_Rate__c=mapGER.get(netObj.id);
                netObj.OED_Guarantee_Rate__c=mapOED.get(netObj.id);
                }
                netObj.SSG_Guarantee_Rate__c=mapSSG.get(netObj.id);  
                //Custom Description Changes ..
                //Changes Done By Mohit Srivastava for Custom Description
                if(netObj.IUMS_Upload__c==true){
                  if(netObj.Custom_Description__c==''||netObj.Custom_Description__c==null){
                   system.debug('MapGridDisplayMapGridDisplayMapGridDisplay'+MapGridDisplay);
                        if(!MapGridDisplay.isEmpty()){
                            if(MapGridDisplay.get(netObj.Network_Name_Combination__c)!=null){
                                netObj.Custom_Description__c=MapGridDisplay.get(netObj.Network_Name_Combination__c);
                            }
                        }
                        else{
                             if(netObj.Network_Name__c=='Specialty'){
                                 netObj.Custom_Description__c='SPECIALTY AT RETAIL';
                              }
                              else{
                               netObj.Custom_Description__c='RETAIL NON SPECIALTY';
                              }
                        }
                    }
                }
                else{
                    if(netObj.Network_Name__c=='Specialty' && netObj.Custom_Description__c=='RETAIL NON SPECIALTY' ){
                        netObj.Custom_Description__c='SPECIALTY AT RETAIL';
                    }
                    if(netObj.Network_Name__c!='Specialty' && netObj.Custom_Description__c=='SPECIALTY AT RETAIL' ){
                        netObj.Custom_Description__c='RETAIL NON SPECIALTY';
                    }
                    if(netObj.Custom_Description__c==''||netObj.Custom_Description__c==null){
                       if(netObj.Network_Name__c=='Specialty'){
                        netObj.Custom_Description__c='SPECIALTY AT RETAIL';
                        }
                        else{
                          netObj.Custom_Description__c='RETAIL NON SPECIALTY';
                        }
                    }
                }
                netpriceObj.add(netObj);
            }
    try{
        if(!netpriceObj.isEmpty()){
            update netpriceObj;
        }
    }
    
    catch(Exception Ex){
    
    system.debug('Exception....'+ex.getMessage());
    }
 }
}
}