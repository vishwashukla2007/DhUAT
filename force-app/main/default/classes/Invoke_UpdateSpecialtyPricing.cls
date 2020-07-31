/* =================================================================================
 * @Class Name        : Invoke_UpdateSpecialtyPricing
 * @author            : Mohit Srivastava(Accenture)
 * @created date      : 07/09/2019
 * @Purpose           : Invoke_UpdateSpecialtyPricing
=======================================================================================*/
global class Invoke_UpdateSpecialtyPricing{



/*=================================================================================
 * @Method Name       : UpdateMailPricing
 * @author            : Mohit Srivastava(Accenture)
 * @created date      : 05/24/2019
 * @Last modified by  : Mohit Srivastava(Accenture)
 * @Purpose           : Populate Effective Date
=======================================================================================*/
@InvocableMethod
global static void UpdateSpecialtyPricing(List<id> objId)
{
  if(DeepCloneUtility.OFF_INVOCABLE_CLASS){
        DeepCloneUtility.OFF_TRIGGERS_PROCBUILDER=false;
        Set<id> ids=new set<id>();
        Set<id> FAFids=new set<id>();
        Set<String> pharmacy=new set<String>();
        
        map<Id,Decimal> mapGuar=new map<Id,Decimal>();
        map<Id,Decimal> mapMER=new map<Id,Decimal>();
        map<Id,Decimal> mapNED=new map<Id,Decimal>();
        map<Id,Decimal> mapGER=new map<Id,Decimal>(); // updated on 06/06
        map<Id,Decimal> mapSSG=new map<Id,Decimal>(); // updated on 06/23
        map<Id,Boolean> mapBol=new map<Id,Boolean>();
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
        Map<id,Specialty_Pricing__c> MapYearComb = new Map<id,Specialty_Pricing__c>();
         Set<String> yearstr=new Set<String>();
        
        /*List<Retail_Network_Name_Translations__mdt> CustomMetaList=[SELECT Label,Translated_Network_Name__c,Retail_Network_Name__c 
                                                                    FROM Retail_Network_Name_Translations__mdt];*/
        PCD_FAF_Status__mdt FAFStatus = [SELECT Value__c FROM PCD_FAF_Status__mdt LIMIT 1]; 
        List<string> FAFStat = new List<string>();
        for(string s: FAFStatus.Value__c.split(','))
        {
                 FAFStat.add(s);
        }                                                                                             
        List<Specialty_Pricing__c> Scope =[SELECT ID,IUMS_Upload__c,Custom_Description__c,FAF_ID__c,Specialty_Operations__c,
                                        Year_Begin_Date__c,Pharmacy_Benefit__c,Generic_Basis__c,Year_End_Date__c,
                                        Invokable_Update__c,Year__c 
                                        FROM Specialty_Pricing__c where FAF_ID__r.FAF_Status__c IN:FAFStat and Specialty_Operations__c IN:objId];

            for(Specialty_Pricing__c  specialObj : scope){
               ids.add(specialObj.id);
               FAFids.add(specialObj.FAF_ID__c);
               yearstr.add(specialObj.Year__c);
               if(specialObj.IUMS_Upload__c==true){
               pharmacy.add(specialObj.Pharmacy_Benefit__c);
               }
               if(specialObj.Year__c=='All'){
               MapYearComb.put(specialObj.Specialty_Operations__c,specialObj);
               }
            }
        if(!pharmacy.isEmpty()){
        List<Grid_Display_Name_Setting__c> gridDisplayList=[Select ID,Specialty_Grid_Name__c,Pharmacy_Benefit_Type__c,Object_Name__c,FAF__c FROM Grid_Display_Name_Setting__c where FAF__c IN:FAFids and Object_Name__c='Specialty Pricing' and Pharmacy_Benefit_Type__c IN:pharmacy];
        for(Grid_Display_Name_Setting__c gdr:gridDisplayList){
            MapGridDisplay.put(gdr.Pharmacy_Benefit_Type__c,gdr.Specialty_Grid_Name__c);
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
            
        
         /****Brand Rate update according to the gurantee type*****/
           /* List<Specialty_Guarantee__c> Grlist=[SELECT ID ,Type__c,Rate__c,Specialty_Pricing__c from Specialty_Guarantee__c where Specialty_Pricing__c IN :ids Order By LastModifiedDate ASC];
                for (Specialty_Guarantee__c guarObj :Grlist ){
                    if(guarObj.Type__c=='BER'){
                    mapGuar.put(guarObj.Specialty_Pricing__c,guarObj.Rate__c);
                    }
                    if(guarObj.Type__c=='MER'){
                    mapMER.put(guarObj.Specialty_Pricing__c,guarObj.Rate__c);
                    }
                    if(guarObj.Type__c=='OED'){
                    mapNED.put(guarObj.Specialty_Pricing__c,guarObj.Rate__c);
                    }
                    if(guarObj.Type__c=='GER'){
                    mapGER.put(guarObj.Specialty_Pricing__c,guarObj.Rate__c);
                    }
                } */
        /****Brand Rate update according to the gurantee type*****/
            List<Specialty_Pricing__c>  SpecialpriceObj = new List<Specialty_Pricing__c>();
          
            for(Specialty_Pricing__c  SpecialObj : scope){
                 if(MapYearComb.get(SpecialObj.Specialty_Operations__c)!=null)
                {
                 for(Specialty_Pricing__c mp: MapYearComb.values())
                 {
                    if((SpecialObj.Year__c=='1'|| SpecialObj.Year__c=='2' ||SpecialObj.Year__c=='3' ||SpecialObj.Year__c=='4'|| SpecialObj.Year__c=='5') && mp.Year__c=='All' 
                    && SpecialObj.Pharmacy_Benefit__c==mp.Pharmacy_Benefit__c)
                    {
                        //SpecialObj.Show_in_Grid__c=false;
                        system.debug('In loop ***********');
                    }
                  }
                } 
                else{
                 //SpecialObj.Show_in_Grid__c=true;
                }
                
               /* if(SpecialObj.Year__c=='All' ){
                     SpecialObj.Show_in_Grid__c=true;
                  }*/
                
                 /*SpecialObj.Template_Preferred_Brand_Rate_Text__c= ' ';
                 SpecialObj.Template_Non_Preferred_Brand_Rate_Text__c=' ';
                 SpecialObj.Template_BER_Guarantee_Rate_Text__c=' ';
                 SpecialObj.Template_Brand_Rate_Text__c=' ';
                 SpecialObj.Template_Generic_Rate_Text__c=' ';
                 SpecialObj.Template_GER_Guarantee_Rate_Text__c=' ';
                 SpecialObj.Template_MER_Guarantee_Rate_Text__c=' ';
                 SpecialObj.Template_OED_Guarantee_Rate_Text__c=' ';
                 SpecialObj.Template_Non_MAC_Generic_Rate_Text__c=' ';
                 //SpecialObj.Template_SSG_Guarantee_Rate_Text__c=' ';
                 SpecialObj.Template_Dispensing_Fee_Text__c= ' ';*/
                
                if(SpecialObj.Year__c=='1' && SpecialObj.Year_Begin_Date__c==null){
                SpecialObj.Year_Begin_Date__c=MapYear1Begin.get(SpecialObj.FAF_ID__c);
                }
                if(SpecialObj.Year__c=='2' && SpecialObj.Year_Begin_Date__c==null){
                    SpecialObj.Year_Begin_Date__c=MapYear2Begin.get(SpecialObj.FAF_ID__c);
                }
                if(SpecialObj.Year__c=='3' && SpecialObj.Year_Begin_Date__c==null){
                    SpecialObj.Year_Begin_Date__c=MapYear3Begin.get(SpecialObj.FAF_ID__c);
                }
                if(SpecialObj.Year__c=='4' && SpecialObj.Year_Begin_Date__c==null){
                    SpecialObj.Year_Begin_Date__c=MapYear4Begin.get(SpecialObj.FAF_ID__c);
                }
                if(SpecialObj.Year__c=='5' && SpecialObj.Year_Begin_Date__c==null){
                    SpecialObj.Year_Begin_Date__c=MapYear5Begin.get(SpecialObj.FAF_ID__c);
                }
                // Year End Date 
                
                if(SpecialObj.Year__c=='1' && SpecialObj.Year_End_Date__c==null){
                SpecialObj.Year_End_Date__c=MapYear1End.get(SpecialObj.FAF_ID__c);
                }
                if(SpecialObj.Year__c=='2' && SpecialObj.Year_End_Date__c==null){
                    SpecialObj.Year_End_Date__c=MapYear2End.get(SpecialObj.FAF_ID__c);
                }
                if(SpecialObj.Year__c=='3' && SpecialObj.Year_End_Date__c==null){
                    SpecialObj.Year_End_Date__c=MapYear3End.get(SpecialObj.FAF_ID__c);
                }
                if(SpecialObj.Year__c=='4' && SpecialObj.Year_End_Date__c==null){
                    SpecialObj.Year_End_Date__c=MapYear4End.get(SpecialObj.FAF_ID__c);
                }
                if(SpecialObj.Year__c=='5' && SpecialObj.Year_End_Date__c==null){
                    SpecialObj.Year_End_Date__c=MapYear5End.get(SpecialObj.FAF_ID__c);
                }
                //For Year All
                
                if(SpecialObj.Year__c=='All'){
                    SpecialObj.Year_End_Date__c=MapContractEndDt.get(SpecialObj.FAF_ID__c);
                }
                if(SpecialObj.Year__c=='All'){
                    SpecialObj.Year_Begin_Date__c=MapContractDt.get(SpecialObj.FAF_ID__c);
                }
                // For BER Guarantee Rate
                
                //SpecialObj.BER_Guarantee_Rate__c=mapGuar.get(SpecialObj.id);
                
               // For Updating Flag on Network Pricing
                
                if(SpecialObj.Invokable_Update__c==false){
                SpecialObj.Invokable_Update__c=true;}
                else{
                 SpecialObj.Invokable_Update__c=false;
                }
                if(SpecialObj.IUMS_Upload__c==true){
                    if(SpecialObj.Custom_Description__c==''|| SpecialObj.Custom_Description__c==null){
                            if(!MapGridDisplay.isEmpty()){
                                    if(SpecialObj.Custom_Description__c==''|| SpecialObj.Custom_Description__c==null){
                                        SpecialObj.Custom_Description__c=MapGridDisplay.get(SpecialObj.Pharmacy_Benefit__c); 
                                    }
                            }
                            else{
                                 SpecialObj.Custom_Description__c='SPECIALTY'; 
                            }
                    }
                }
                else{
                    if(SpecialObj.Custom_Description__c==''|| SpecialObj.Custom_Description__c==null){
                        SpecialObj.Custom_Description__c='SPECIALTY'; 
                    }
                }
                
                
                String cLabel = System.Label.Flat_Generic_Discount;
                List<String> choosingGenericRate = new List<String>();
                choosingGenericRate=cLabel.split(',');
                
                if(!choosingGenericRate.contains(SpecialObj.Generic_Basis__c)){
                //SpecialObj.MER_Guarantee_Rate__c=mapMER.get(SpecialObj.id);
                //SpecialObj.OED_Guarantee_Rate__c=mapNED.get(SpecialObj.id); 
               // SpecialObj.GER_Guarantee_Rate__c=mapGER.get(SpecialObj.id);
                //SpecialObj.BER_Guarantee_Rate__c=mapSSG.get(SpecialObj.id);  
                }
                SpecialpriceObj.add(SpecialObj);
                
            }
    try{
        if(!SpecialpriceObj.isEmpty()){
            update SpecialpriceObj;
        }
    }
    
    catch(Exception Ex){
    
    system.debug('Exception....'+ex.getMessage());
    }
 }
}
}