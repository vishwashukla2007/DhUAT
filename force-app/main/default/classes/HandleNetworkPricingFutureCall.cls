/* Future Methods to execute after submission of PCD Question/Answer to update Data and display at CF Template */

global class HandleNetworkPricingFutureCall{
/*
@future
  public static void UpdateNetworkPricingFuture(List<Id> objId) {
  
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
        Map<id,List<Network_Pricing__c>> MapYearComb = new Map<id,List<Network_Pricing__c>>();
        List<Network_Pricing__c> netAll=new List<Network_Pricing__c>();
         Set<String> yearstr=new Set<String>();
        
        List<Retail_Network_Name_Translations__mdt> CustomMetaList=[SELECT Label,Translated_Network_Name__c,Retail_Network_Name__c
                                                                    FROM Retail_Network_Name_Translations__mdt];
         PCD_FAF_Status__mdt FAFStatus = [SELECT Value__c FROM PCD_FAF_Status__mdt LIMIT 1]; 
        List<string> FAFStat = new List<string>();
        for(string s: FAFStatus.Value__c.split(','))
              {
                 FAFStat.add(s);
              }                                                       
        List<Network_Pricing__c> Scope =[SELECT ID,FAF_Network_Ops__c,Template_BER_Guarantee_Rate__c,Network_Type__c, Show_in_Grid__c,Maintenance_Choice__c,FAF_ID__c ,
                                        Year_Begin_Date__c,Generic_Basis__c,Year_End_Date__c,Custom_Network_Description__c,MER_Guarantee_Rate__c,NED_Guarantee_Rate__c,GER_Guarantee_Rate__c,
                                        Network_Name__c,Network_Name_for_Grid__c,Invokable_Update__c,BER_Guarantee_Rate__c,SSG_Guarantee_Rate__c,Year__c,Template_Network_Name_Text__c,Template_Network_Name__c,Template_MCCP__c 
                                        FROM Network_Pricing__c where FAF_ID__r.FAF_Status__c IN:FAFStat and FAF_Network_Ops__c IN:objId];
        
            for(Network_Pricing__c  netObj : scope){
               ids.add(netObj.id);
               FAFids.add(netObj.FAF_ID__c);
               yearstr.add(netObj.Year__c);
               if(netObj.Year__c=='All'){
               netAll.add(netObj);
               //MapYearComb.put(netObj.FAF_Network_Ops__c,netObj);
               MapYearComb.put(netObj.FAF_Network_Ops__c,netAll);
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
            */
        
         /*
            for(Retail_Network_Name_Translations__mdt nr:CustomMetaList){
              mapstr.put(nr.Retail_Network_Name__c,nr.Translated_Network_Name__c);
            }
            */
        
           /* List<Retail_Network_Guarantees__c> Grlist=[SELECT ID ,Type__c,Rate__c,Network_Pricing__c from Retail_Network_Guarantees__c where Network_Pricing__c IN :ids Order By LastModifiedDate ASC];
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
                */
        /****Brand Rate update according to the gurantee type*****/
           
         /*
           
            List<Network_Pricing__c >  netpriceObj = new List<Network_Pricing__c>();
          
            for(Network_Pricing__c  netObj : scope){
            Boolean exclude = false;
             netObj.Show_in_Grid__c=true;
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
                if(netObj.Network_Name__c == Label.MCCVS || netObj.Network_Name__c == Label.BGHLTH){
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
                if(netObj.Year__c=='1' && netObj.Year_Begin_Date__c==null){
                netObj.Year_Begin_Date__c=MapYear1Begin.get(netObj.FAF_ID__c);
                }
                if(netObj.Year__c=='2' && netObj.Year_Begin_Date__c==null){
                    netObj.Year_Begin_Date__c=MapYear2Begin.get(netObj.FAF_ID__c);
                }
                if(netObj.Year__c=='3' && netObj.Year_Begin_Date__c==null){
                    netObj.Year_Begin_Date__c=MapYear3Begin.get(netObj.FAF_ID__c);
                }
                if(netObj.Year__c=='4' && netObj.Year_Begin_Date__c==null){
                    netObj.Year_Begin_Date__c=MapYear4Begin.get(netObj.FAF_ID__c);
                }
                if(netObj.Year__c=='5' && netObj.Year_Begin_Date__c==null){
                    netObj.Year_Begin_Date__c=MapYear5Begin.get(netObj.FAF_ID__c);
                }
                // Year End Date 
                
                if(netObj.Year__c=='1' && netObj.Year_End_Date__c==null){
                netObj.Year_End_Date__c=MapYear1End.get(netObj.FAF_ID__c);
                }
                if(netObj.Year__c=='2' && netObj.Year_End_Date__c==null){
                    netObj.Year_End_Date__c=MapYear2End.get(netObj.FAF_ID__c);
                }
                if(netObj.Year__c=='3' && netObj.Year_End_Date__c==null){
                    netObj.Year_End_Date__c=MapYear3End.get(netObj.FAF_ID__c);
                }
                if(netObj.Year__c=='4' && netObj.Year_End_Date__c==null){
                    netObj.Year_End_Date__c=MapYear4End.get(netObj.FAF_ID__c);
                }
                if(netObj.Year__c=='5' && netObj.Year_End_Date__c==null){
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
                
                if(!choosingGenericRate.contains(netObj.Generic_Basis__c)){
                netObj.MER_Guarantee_Rate__c=mapMER.get(netObj.id);
                netObj.NED_Guarantee_Rate__c=mapNED.get(netObj.id); 
                netObj.GER_Guarantee_Rate__c=mapGER.get(netObj.id);
                netObj.OED_Guarantee_Rate__c=mapOED.get(netObj.id);
                }
                netObj.SSG_Guarantee_Rate__c=mapSSG.get(netObj.id);  
                netpriceObj.add(netObj);
                
            }
    try{
        if(!netpriceObj.isEmpty()){
            update netpriceObj;
        }
             HandleNetworkPricingFutureCall.Template_BERGuaranteeRate(objId);
        }
        catch(Exception Ex){
            system.debug('Exception....'+ex.getMessage());
        }
       
} */
    
   
    
     /*
    public static void Template_BERGuaranteeRate(List<Id> objId)
    { 
    //commented by sonal sharma
   
  system.debug('======================================Infuture Call 2===========================');
        try
        {
        
        DeepCloneUtility.OFF_TRIGGERS_PROCBUILDER=false;
        Network_Pricing__c[] ListNpricing = new List<Network_Pricing__c>();
        Network_Pricing__c[] ShowinGrid = new List<Network_Pricing__c>();
        Boolean BERExist = false;
        Boolean ShowGrid = false;

        PCD_FAF_Status__mdt FAFStatus = [SELECT Value__c FROM PCD_FAF_Status__mdt LIMIT 1]; 
        List<string> FAFStat = new List<string>();
        for(string s: FAFStatus.Value__c.split(','))
           {
             FAFStat.add(s);
           }      
        List<Network_Pricing__c> Nprice =[SELECT Id,Show_in_Grid__c,Maintenance_Choice__c,FAF_ID__c ,
                                                 Year_Begin_Date__c,Year_End_Date__c,Custom_Network_Description__c,
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
               
        List<Network_Pricing__c> AgreegateBERRate = new List<Network_Pricing__c>([SELECT Template_Network_Name_Text__c,Template_BER_Guarantee_Rate__c,BER_Guarantee_Rate__c 
                                                FROM Network_Pricing__c 
                                                WHERE  Year__c != 'All'  AND FAF_Network_Ops__c IN:objId ORDER BY Year__c ASC]);

         for(Network_Pricing__c  netObj : Nprice){
                       String AggrBERRate = '';
                       BERExist = false;
                       ShowGrid = false;
                       if(MinYearAgreegate != null && MinYearAgreegate.get(netObj.Template_Network_Name_Text__c) != null)
                        {
                          AggregateResult vYear = MinYearAgreegate.get(netObj.Template_Network_Name_Text__c);
                          if ((vYear.get('MinYear') == netObj.Year__c) && (vYear.get('Name') == netObj.Min_Name__c))
                          {
                            for (Network_Pricing__c BERRate : AgreegateBERRate){
                              if(AgreegateBERRate != null && !AgreegateBERRate.isEmpty() && (BERRate.Template_Network_Name_Text__c == netObj.Template_Network_Name_Text__c))
                                  {
                                    AggrBERRate += BERRate.Template_BER_Guarantee_Rate__c +  '\n' ;
                                    if (netObj.BER_Guarantee_Rate__c != null || BERRate.BER_Guarantee_Rate__c != null)
                                     { BERExist = true;}
                                  }
                               
                                      ShowGrid = true;
                                                              
                          }
                          if(BERExist == true)
                           { 
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
                                  netObj.Batch_Update__c = false;  
                                  ListNpricing.add(netObj);                             
                                                 }
                 
            if (ListNpricing != null && !ListNpricing.isEmpty())
            {
               Update ListNpricing;
            }

            if (ShowinGrid != null && !ShowinGrid.isEmpty())
            {
               Update ShowinGrid;
            }
         HandleNetworkPricingFutureCall.Template_BERGuaranteeRate_All(objId);
        }
        catch(DmlException e)
        {
             System.debug(e.getMessage());
        }
       
    } */ 
   
    /*
        public static void Template_BERGuaranteeRate_All(List<id> objId)
        { 
        //commented by sonal sharma
   
  system.debug('======================================Infuture Call 3===========================');
        try
        {
        DeepCloneUtility.OFF_TRIGGERS_PROCBUILDER=false;
        Network_Pricing__c[] ListNpricing = new List<Network_Pricing__c>();
        Network_Pricing__c[] ShowinGrid = new List<Network_Pricing__c>();
        Boolean BERExist = false;
        Boolean ShowGrid = false;

        PCD_FAF_Status__mdt FAFStatus = [SELECT Value__c FROM PCD_FAF_Status__mdt LIMIT 1]; 
        List<string> FAFStat = new List<string>();
        for(string s: FAFStatus.Value__c.split(','))
           {
             FAFStat.add(s);
           }      
        List<Network_Pricing__c> Nprice =[SELECT Id,Show_in_Grid__c,Maintenance_Choice__c,FAF_ID__c ,
                                                 Year_Begin_Date__c,Year_End_Date__c,Custom_Network_Description__c,
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
               
        List<Network_Pricing__c> AgreegateBERRate = new List<Network_Pricing__c>([SELECT Template_Network_Name_Text__c,Template_BER_Guarantee_Rate__c,BER_Guarantee_Rate__c,FAF_ID__c  
                                                FROM Network_Pricing__c 
                                                WHERE Network_Name_for_Grid__c <> NULL   AND  Year__c = 'All' AND FAF_Network_Ops__c IN:objId
                                                ORDER BY Year__c ASC]);

         for(Network_Pricing__c  netObj : Nprice){
                       String AggrBERRate = '';
                       BERExist = false;
                       ShowGrid = false;
                       if(MinYearAgreegate != null && MinYearAgreegate.get(netObj.Template_Network_Name_Text__c) != null)
                        {
                          AggregateResult vName = MinYearAgreegate.get(netObj.Template_Network_Name_Text__c);
                          if (vName.get('Name') == netObj.Name)
                          {
                            for (Network_Pricing__c BERRate : AgreegateBERRate){
                              if(AgreegateBERRate != null && !AgreegateBERRate.isEmpty() && (BERRate.Template_Network_Name_Text__c == netObj.Template_Network_Name_Text__c))
                                  {
                                    AggrBERRate += BERRate.Template_BER_Guarantee_Rate__c +  '\n' ;
                                    if (netObj.BER_Guarantee_Rate__c != null || BERRate.BER_Guarantee_Rate__c != null)
                                     { BERExist = true;}
                                  }
                                
                                      
                                                              
                          }
                          ShowGrid = true;
                          if(BERExist == true)
                           { 
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
                                  netObj.Batch_Update__c = false;  
                                  ListNpricing.add(netObj);                           
                                                 }
           
        if (ListNpricing != null && !ListNpricing.isEmpty())
        {
           Update ListNpricing;
        }

        if (ShowinGrid != null && !ShowinGrid.isEmpty())
        {
           Update ShowinGrid;
        }
         HandleNetworkPricingFutureCall.Template_BrandGenericRate(objId);
        }
        catch(DmlException e)
            {
             System.debug(e.getMessage());
            }
            
        }*/ 
       /*
          
    
            
            public static void Template_BrandGenericRate(List<id> objId)
            { 
            //commented by sonal sharma
       try
            {
            

            DeepCloneUtility.OFF_TRIGGERS_PROCBUILDER=false;
            Network_Pricing__c[] ListNpricing = new List<Network_Pricing__c>();
            Network_Pricing__c[] ShowinGrid = new List<Network_Pricing__c>();
            Boolean BrandExist = false;
            Boolean GenericExist = false;
            Boolean OEDExist = false;
            Boolean GERGenericExist = false;
            Boolean PrefExist = false;
            Boolean MERGenericExist = false;
            Boolean NEDGenericExist = false;
            Boolean SSGGenericExist = false;
            Boolean NonMacGenericExist = false;
            Boolean DispensingExist = false;
            Boolean BGDispensing = false;
            Boolean BERExist = false;
            Boolean ShowGrid = false;

            PCD_FAF_Status__mdt FAFStatus = [SELECT Value__c FROM PCD_FAF_Status__mdt LIMIT 1]; 
            List<string> FAFStat = new List<string>();
            for(string s: FAFStatus.Value__c.split(','))
               {
                 FAFStat.add(s);
               }        
            List<Network_Pricing__c> Nprice =[SELECT Id,Show_in_Grid__c,Maintenance_Choice__c,FAF_ID__c,Brand_Basis__c,Template_Preferred_Brand_Rate__c,Template_Non_Preferred_Brand_Rate__c,
                                                     Year_Begin_Date__c,Year_End_Date__c,Custom_Network_Description__c,Generic_Rate__c,FAF_ID__r.LOB2__c,
                                                     Network_Name__c,Network_Name_for_Grid__c,Template_Brand_Display__c,Template_BER_Display__c,Network_Type__c, Brand_Rate__c,BER_Guarantee_Rate__c,Year__c,FAF_Network_Ops__c,
                                                     Template_Network_Name__c,Template_Preferred_Display__c, Template_Brand_Rate__c,Template_BER_Guarantee_Rate__c,
                                                     Template_Network_Name_Text__c,Template_BER_Guarantee_Rate_Text__c,Template_Generic_OR_Mac__c,Template_Generic_OR_Mac_Text__c,
                                                     Generic_Basis__c,Template_Generic_Rate__c,Template_Generic_Rate_Text__c,
                                                     Template_MER_Guarantee_Rate__c,Template_MER_Guarantee_Rate_Text__c,
                                                     Template_NED_Guarantee_Rate__c,Template_NED_Guarantee_Rate_Text__c,
                                                     Template_GER_Guarantee_Rate__c,Specialty_Show_in_Grid__c,Template_GER_Guarantee_Rate_Text__c,
                                                     Template_SSG_Guarantee_Rate__c,Template_SSG_Guarantee_Rate_Text__c,
                                                     Template_Non_MAC_Generic_Rate__c,Template_Non_MAC_Generic_Rate_Text__c,OED_Guarantee_Rate__c,Template_OED_Guarantee_Rate_Text__c,
                                                     Template_Brand_Dispensing_Fee__c,Template_Generic_Dispensing_Fee__c,Template_Dispensing_Fee_Text__c,
                                                     GER_Guarantee_Rate__c,MER_Guarantee_Rate__c,NED_Guarantee_Rate__c,SSG_Guarantee_Rate__c,Name,
                                                     GER_Count__c,MER_Count__c, NED_Count__c,SSG_Guarantee__c,Min_Name__c,Generic_Dispensing_Fee__c,Brand_Dispensing_Fee__c,
                                                     Template_Generic_Display__c,Template_GER_Display__c,Template_MER_Display__c,Template_NED_Display__c,Template_NonMacGeneric_Display__c,Template_OED_Display__c
                                                     FROM Network_Pricing__c WHERE FAF_ID__r.FAF_Status__c IN:FAFStat AND  Year__c != 'All' 
                                                     AND FAF_Network_Ops__c IN:objId ORDER BY Year__c ASC];

                                                     
            Map<String,AggregateResult> MinYearAgreegate = new Map<String,AggregateResult>([SELECT Template_Network_Name_Text__c Id, min(Year__c) MinYear ,min(Min_Name__c) Name
                                                    FROM Network_Pricing__c 
                                                    WHERE FAF_ID__r.FAF_Status__c IN:FAFStat  AND 
                                                    Template_Network_Name_Text__c <> NULL AND  Year__c != 'All'  AND FAF_Network_Ops__c IN:objId 
                                                    GROUP BY  Template_Network_Name_Text__c]);
                   
            List<Network_Pricing__c> AgreegateRate = new List<Network_Pricing__c>([SELECT Template_BER_Guarantee_Rate__c,Template_Network_Name_Text__c,Template_Brand_Rate__c,Brand_Rate__c,Template_Preferred_Brand_Rate__c,Template_Non_Preferred_Brand_Rate__c,
                                                    Generic_Basis__c,Template_OED_Guarantee_Rate__c,Template_Generic_Rate__c,OED_Count__c,Generic_Rate__c,MER_Guarantee_Rate__c,Template_MER_Guarantee_Rate__c,
                                                    NED_Guarantee_Rate__c,OED_Guarantee_Rate__c,Template_NED_Guarantee_Rate__c,BER_Guarantee_Rate__c,GER_Guarantee_Rate__c,Template_GER_Guarantee_Rate__c,SSG_Guarantee_Rate__c,Template_SSG_Guarantee_Rate__c,
                                                    Non_MAC_Generic_Rate__c,Template_Non_MAC_Generic_Rate__c,GER_Count__c,MER_Count__c,NED_Count__c,SSG_Guarantee__c,Generic_Dispensing_Fee__c,Brand_Dispensing_Fee__c,
                                                    Template_Brand_Dispensing_Fee__c,Template_Generic_Dispensing_Fee__c,Brand_Basis__c,Template_Generic_OR_Mac__c,Template_Generic_OR_Mac_Text__c,FAF_ID__c  
                                                    FROM Network_Pricing__c 
                                                    WHERE Year__c != 'All'  AND FAF_Network_Ops__c IN:objId ORDER BY Year__c ASC]);
             
for(Network_Pricing__c  netObj : Nprice){
               Boolean SSGexist = false;
               String AggrRate= '';
               String GenericRate= '';
               String GERGenericRate= '';
               String OEDRate= '';
               String MERGenericRate= '';
               String NEDGenericRate= '';
               String SSGGenericRate= '';
               String NonMacGenericRate= '';
               String NonMacGenericORRate= '';
               String DispensingFee= '';
               String BGDispensingFee= '';
               String AggrBERRate= '';
               String BrandDispensingFee= '';
               String AggrPrefRate= '';
               String AggrNonPrefRate= '';
               String GenericDispensingFee= '';
               BrandExist = false;
               GenericExist = false;
               OEDExist=false;
               BERExist = false;
               GERGenericExist = false;
               MERGenericExist = false;
               NEDGenericExist = false;
               SSGGenericExist = false;
               PrefExist = false;
               NonMacGenericExist = false;
               DispensingExist = false;
               BGDispensing = false;
               ShowGrid = false;
               if (netObj.FAF_ID__r.LOB2__c=='EGWP' && netObj.Network_Name__c!='Med D - IHS')
               {
                 NonMacGenericRate = 'MAC' + '\n' + 'Non – MAC:' + '\n';
               }
               if(MinYearAgreegate != null && MinYearAgreegate.get(netObj.Template_Network_Name_Text__c) != null)
                {
                  AggregateResult vYear = MinYearAgreegate.get(netObj.Template_Network_Name_Text__c);
                  if ((vYear.get('MinYear') == netObj.Year__c) && (vYear.get('Name') == netObj.Min_Name__c))
                  {
                    for (Network_Pricing__c BrandRate : AgreegateRate){
                      if( AgreegateRate != null && !AgreegateRate.isEmpty() && (BrandRate.Template_Network_Name_Text__c == netObj.Template_Network_Name_Text__c))
                          {
                            if(BrandRate.Brand_Basis__c != Label.Baked_Preferred_Rate)
                            {
                             AggrRate+= BrandRate.Template_Brand_Rate__c +  '\n' ;
                            }
                            if (netObj.Brand_Rate__c != null || BrandRate.Brand_Rate__c != null || BrandRate.Brand_Basis__c != Label.Baked_Preferred_Rate)
                              {BrandExist = true;}
                          }
                    
                      if(AgreegateRate != null && !AgreegateRate.isEmpty() && (BrandRate.Template_Network_Name_Text__c == netObj.Template_Network_Name_Text__c) && (BrandRate.Generic_Basis__c == Label.Flat_Generic_Discount))
                          {
                            GenericRate+= BrandRate.Template_Generic_Rate__c +  '\n' ;
                           // if (netObj.Generic_Rate__c != null || BrandRate.Generic_Rate__c != null)
                              GenericExist = true;
                          }
                         
                        //Start :Changes For OED Rate : Mohit Srivastava
                         if( AgreegateRate != null && !AgreegateRate.isEmpty() && (BrandRate.Template_Network_Name_Text__c == netObj.Template_Network_Name_Text__c) && (BrandRate.Generic_Basis__c!= Label.Flat_Generic_Discount) && netObj.Specialty_Show_in_Grid__c==true)
                          {
                            OEDRate+= BrandRate.Template_OED_Guarantee_Rate__c +  '\n' ;
                           // if (netObj.Generic_Rate__c != null || BrandRate.Generic_Rate__c != null)
                           if (netObj.OED_Guarantee_Rate__c != null || BrandRate.OED_Guarantee_Rate__c != null || BrandRate.OED_Count__c > 0)
                              {OEDExist = true;}
                              
                          }
                        //End :Changes For OED Rate : Mohit Srivastava 
                      if(AgreegateRate != null && !AgreegateRate.isEmpty() && (BrandRate.Template_Network_Name_Text__c == netObj.Template_Network_Name_Text__c) && (BrandRate.Generic_Basis__c != Label.Flat_Generic_Discount))
                          {
                            GERGenericRate+= BrandRate.Template_GER_Guarantee_Rate__c +  '\n' ;
                            if (netObj.GER_Guarantee_Rate__c != null || BrandRate.GER_Guarantee_Rate__c != null || BrandRate.GER_Count__c > 0)
                              {GERGenericExist = true;}
                          }
                      if( AgreegateRate != null && !AgreegateRate.isEmpty() && (BrandRate.Template_Network_Name_Text__c == netObj.Template_Network_Name_Text__c) && (BrandRate.Generic_Basis__c != Label.Flat_Generic_Discount))
                          {
                            MERGenericRate+= BrandRate.Template_MER_Guarantee_Rate__c +  '\n' ;
                            if (netObj.MER_Guarantee_Rate__c != null || BrandRate.MER_Guarantee_Rate__c != null || BrandRate.MER_Count__c > 0)
                              {MERGenericExist = true;}
                          }
                      if( AgreegateRate != null && !AgreegateRate.isEmpty() && (BrandRate.Template_Network_Name_Text__c == netObj.Template_Network_Name_Text__c) && (BrandRate.Generic_Basis__c != Label.Flat_Generic_Discount))
                          {
                            NEDGenericRate+= BrandRate.Template_NED_Guarantee_Rate__c +  '\n' ;
                            if (netObj.NED_Guarantee_Rate__c != null || BrandRate.NED_Guarantee_Rate__c != null || BrandRate.NED_Count__c > 0)
                              {NEDGenericExist = true;}
                          }  
                       if( AgreegateRate != null && !AgreegateRate.isEmpty() && (BrandRate.Template_Network_Name_Text__c == netObj.Template_Network_Name_Text__c) && (BrandRate.Generic_Basis__c != Label.Flat_Generic_Discount))
                          {
                            NonMacGenericRate+= BrandRate.Template_Non_MAC_Generic_Rate__c +  '\n' ;
                            NonMacGenericORRate+= BrandRate.Template_Generic_OR_Mac__c +  '\n' ;
                           // if (netObj.Generic_Rate__c != null || BrandRate.Generic_Rate__c != null)
                              NonMacGenericExist = true;
                          }               
                      if(AgreegateRate != null && !AgreegateRate.isEmpty() && (BrandRate.Template_Network_Name_Text__c == netObj.Template_Network_Name_Text__c))
                          {
                            SSGGenericRate+= BrandRate.Template_SSG_Guarantee_Rate__c +  '\n' ;
                            //if (netObj.SSG_Guarantee_Rate__c != null || BrandRate.SSG_Guarantee_Rate__c != null || BrandRate.SSG_Guarantee__c > 0)
                              SSGGenericExist = true;
                              if (BrandRate.SSG_Guarantee__c >= 1)
                              {
                               SSGexist = true;
                              }
                          } 
                      if(AgreegateRate != null && !AgreegateRate.isEmpty() && (BrandRate.Template_Network_Name_Text__c == netObj.Template_Network_Name_Text__c))
                          {
                            if (BrandRate.Generic_Dispensing_Fee__c == BrandRate.Brand_Dispensing_Fee__c)
                            {
                            BGDispensingFee+= BrandRate.Template_Brand_Dispensing_Fee__c +  '\n' ;                          
                            }
                            else
                            {
                            BGDispensing = true;
                            }
                            BrandDispensingFee+= BrandRate.Template_Brand_Dispensing_Fee__c +  '\n' ;
                            GenericDispensingFee+= BrandRate.Template_Generic_Dispensing_Fee__c +  '\n' ;
                            DispensingExist = true;
                          }
                          // Changes for Brand generic rate for Retail Speciality Grid :Mohit Srivastava
                         if(AgreegateRate!= null && !AgreegateRate.isEmpty() && (BrandRate.Template_Network_Name_Text__c == netObj.Template_Network_Name_Text__c))
                        {
                           AggrBERRate += BrandRate.Template_BER_Guarantee_Rate__c +  '\n';
                            if ((netObj.BER_Guarantee_Rate__c != null || BrandRate.BER_Guarantee_Rate__c != null) && netObj.FAF_ID__r.LOB2__c !='EGWP')
                             { BERExist = true;}
                             
                            if(BrandRate.Brand_Basis__c == Label.Baked_Preferred_Rate && (BrandRate.Template_Network_Name_Text__c == netObj.Template_Network_Name_Text__c))
                            {
                             AggrPrefRate += BrandRate.Template_Preferred_Brand_Rate__c +  '\n';
                             AggrNonPrefRate += BrandRate.Template_Non_Preferred_Brand_Rate__c +  '\n';
                             PrefExist = true;
                            }
                        }  
                                                 
                  }
                  ShowGrid = true;
                  netObj.Template_Generic_Display__c = false;
                  netObj.Template_Non_MAC_Generic_Display__c = true; 
                  if (netObj.Generic_Basis__c == Label.Flat_Generic_Discount)
                   {
                     netObj.Template_Generic_Display__c = true;
                     netObj.Template_Non_MAC_Generic_Display__c = false;  
                   }
                   // Specialty Grid changes : By Mohit Srivastava
                   if(PrefExist == true)
                    { 
                         netObj.Template_Preferred_Brand_Rate_Text__c = AggrPrefRate;     
                         netObj.Template_Non_Preferred_Brand_Rate_Text__c  = AggrNonPrefRate; 
                         netObj.Template_Preferred_Display__c=true;                                          
                    }
                    else
                    {
                         netObj.Template_Preferred_Brand_Rate_Text__c = ' ';     
                         netObj.Template_Non_Preferred_Brand_Rate_Text__c  = ' ';
                         netObj.Template_Preferred_Display__c=false;
                    }
                   if(BrandExist == true && BERExist == false )
                   { 
                       netObj.Template_Brand_Rate_Text__c = AggrRate;  
                       netObj.Template_Brand_Display__c = true;                                              
                   }
                   else
                  {
                      netObj.Template_Brand_Rate_Text__c = ' ';
                      netObj.Template_Brand_Display__c = false;
                  }
                    // End: Specialty grid changes : Mohit Srivastava
                  if (GenericExist == true || GERGenericExist == true || MERGenericExist == true || NEDGenericExist == true)
                  {
                      netObj.Template_Generic_Display__c = true; 
                  }
                  else
                  {
                      netObj.Template_Generic_Display__c = false; 
                  }
                  if(GenericExist == true)
                   { 
                       netObj.Template_Generic_Rate_Text__c = GenericRate;                                                  
                   }
                   else
                  {
                      netObj.Template_Generic_Rate_Text__c = ' ';
                  } 
                  //Start :Changes For OED Rate : Mohit Srivastava
                  if(OEDExist == true)
                   { 
                       netObj.Template_OED_Guarantee_Rate_Text__c = OEDRate;  
                       netObj.Template_OED_Display__c= true;                                                  
                   }
                  else
                  {
                      netObj.Template_OED_Guarantee_Rate_Text__c = ' ';
                      netObj.Template_OED_Display__c= false;
                  } 
                  //End :Changes For OED Rate : Mohit Srivastava
                  if(GERGenericExist == true)
                   { 
                       netObj.Template_GER_Guarantee_Rate_Text__c = GERGenericRate;                   
                       netObj.Template_GER_Display__c = true;                                               
                   }
                   else
                  {
                      netObj.Template_GER_Guarantee_Rate_Text__c = ' ';
                      netObj.Template_GER_Display__c = false;   
                  }  
                  if(MERGenericExist == true)
                   { 
                       netObj.Template_MER_Guarantee_Rate_Text__c = MERGenericRate;   
                       netObj.Template_MER_Display__c = true;                                                  
                   }
                   else
                  {
                      netObj.Template_MER_Guarantee_Rate_Text__c = ' ';
                      netObj.Template_MER_Display__c = false; 
                  }  
                  if(NEDGenericExist == true)
                   { 
                       netObj.Template_NED_Guarantee_Rate_Text__c = NEDGenericRate;  
                       netObj.Template_NED_Display__c = true;                                                   
                   }
                   else
                  {
                      netObj.Template_NED_Guarantee_Rate_Text__c = ' ';
                      netObj.Template_NED_Display__c = false;  
                  }  
                   if(NonMacGenericExist == true) 
                   { 
                       netObj.Template_Non_MAC_Generic_Rate_Text__c = NonMacGenericRate; 
                       netObj.Template_Generic_OR_Mac_Text__c = NonMacGenericORRate;
                       netObj.Template_NonMacGeneric_Display__c = true;                                              
                   }
                   else
                  {
                      netObj.Template_Non_MAC_Generic_Rate_Text__c = ' ';
                      netObj.Template_Generic_OR_Mac_Text__c = ' ';
                      netObj.Template_NonMacGeneric_Display__c = true;
                  }  
                  if(SSGGenericExist == true && SSGexist == true)
                   { 
                       netObj.Template_SSG_Guarantee_Rate_Text__c = SSGGenericRate; 
                       netObj.SSG_Display__c = true; 
                                               
                   }
                   else
                  {
                      netObj.Template_SSG_Guarantee_Rate_Text__c = ' ';
                      netObj.SSG_Display__c = false; 
                  }  
                  
                  if(DispensingExist == true)  
                   { 
                      if (BGDispensing == true)
                      {
                      DispensingFee = 'Brand' + '\n' + BrandDispensingFee + '\n' + 'Generic' + '\n' + GenericDispensingFee + '\n';
                      }
                      else
                      {
                      DispensingFee = 'Brand & Generic' + '\n' + BGDispensingFee;
                      }
                      netObj.Template_Dispensing_Fee_Text__c = DispensingFee;                                                   
                   }
                   else
                      {
                       netObj.Template_Dispensing_Fee_Text__c = ' ';
                      }  
                  
                   }   
                  if(ShowGrid != true)
                   { 
                       netObj.Show_in_Grid__c = false;
                       netObj.Specialty_Show_in_Grid__c=false;
                       ShowinGrid.add(netObj); 
                   }               
                }         
                
                if(BrandExist == false && netObj.Template_BER_Guarantee_Rate_Text__c== null && netObj.FAF_ID__r.LOB2__c !='EGWP')
                {netObj.Template_Brand_Rate_Text__c= netObj.Template_Brand_Rate__c;}
                          //netObj.Batch_Update__c = false;  
                          ListNpricing.add(netObj);                           
                          }
                 
            if (ListNpricing != null && !ListNpricing.isEmpty())
            {
               Update ListNpricing;
            }

            if (ShowinGrid != null && !ShowinGrid.isEmpty())
            {
               Update ShowinGrid;
            }
             HandleNetworkPricingFutureCall.UpdateNetworkPricingBrandRate_All(objId); 
            }
                catch(DmlException e)
                {
                 System.debug(e.getMessage());
                } 
      
            }*/
     /*
    public static void UpdateNetworkPricingBrandRate_All(List<id> objId)
   {
   //commented by sonal sharma
   
        try
        {
       
        DeepCloneUtility.OFF_TRIGGERS_PROCBUILDER=false;
        Network_Pricing__c[] ListNpricing = new List<Network_Pricing__c>();
        Network_Pricing__c[] ShowinGrid = new List<Network_Pricing__c>();
        Boolean BrandExist = false;
        Boolean GenericExist = false;
        Boolean OEDExist = false;
        Boolean GERGenericExist = false;
        Boolean MERGenericExist = false;
        Boolean PrefExist = false;
        Boolean BERExist = false;
        Boolean NEDGenericExist = false;
        Boolean SSGGenericExist = false;
        Boolean NonMacGenericExist = false;
        Boolean DispensingExist = false;
        Boolean BGDispensing = false;
        Boolean ShowGrid = false;

        PCD_FAF_Status__mdt FAFStatus = [SELECT Value__c FROM PCD_FAF_Status__mdt LIMIT 1]; 
        List<string> FAFStat = new List<string>();
        for(string s: FAFStatus.Value__c.split(','))
           {
             FAFStat.add(s);
           }        
        List<Network_Pricing__c> Nprice =[SELECT Id,Show_in_Grid__c,Maintenance_Choice__c,FAF_ID__c ,Brand_Basis__c,Template_Preferred_Brand_Rate__c,Template_Non_Preferred_Brand_Rate__c,FAF_ID__r.LOB2__c,
                                                 Year_Begin_Date__c,Year_End_Date__c,Custom_Network_Description__c,Generic_Rate__c,Template_Brand_Display__c,Template_BER_Display__c,
                                                 Network_Name__c,Network_Name_for_Grid__c,Network_Type__c, Brand_Rate__c,BER_Guarantee_Rate__c,Year__c,FAF_Network_Ops__c,Template_Preferred_Display__c,
                                                 Template_Network_Name__c, Template_Brand_Rate__c,Template_BER_Guarantee_Rate__c,Template_Generic_OR_Mac__c,Template_Generic_OR_Mac_Text__c,
                                                 Template_Network_Name_Text__c,Template_BER_Guarantee_Rate_Text__c,
                                                 Generic_Basis__c,Template_Generic_Rate__c,Template_Generic_Rate_Text__c,
                                                 Template_MER_Guarantee_Rate__c,Template_MER_Guarantee_Rate_Text__c,
                                                 Template_NED_Guarantee_Rate__c,Template_NED_Guarantee_Rate_Text__c,
                                                 Template_GER_Guarantee_Rate__c,Template_GER_Guarantee_Rate_Text__c,
                                                 Template_SSG_Guarantee_Rate__c,Template_OED_Guarantee_Rate_Text__c,Template_SSG_Guarantee_Rate_Text__c,
                                                 Template_Non_MAC_Generic_Rate__c,Template_Non_MAC_Generic_Rate_Text__c,
                                                 Template_Brand_Dispensing_Fee__c,Specialty_Show_in_Grid__c,Template_Generic_Dispensing_Fee__c,Template_Dispensing_Fee_Text__c,
                                                 Name,GER_Guarantee_Rate__c,OED_Guarantee_Rate__c,MER_Guarantee_Rate__c,NED_Guarantee_Rate__c,SSG_Guarantee_Rate__c,
                                                 GER_Count__c,MER_Count__c, NED_Count__c,SSG_Guarantee__c,Generic_Dispensing_Fee__c,Brand_Dispensing_Fee__c,
                                                 Template_Generic_Display__c,Template_GER_Display__c,Template_MER_Display__c,Template_NED_Display__c,Template_NonMacGeneric_Display__c,Template_OED_Display__c
                                                 FROM Network_Pricing__c WHERE FAF_ID__r.FAF_Status__c IN:FAFStat  AND  Year__c = 'All' 
                                                 AND FAF_Network_Ops__c IN:objId];
                                                 
        Map<String,AggregateResult> MinYearAgreegate = new Map<String,AggregateResult>([SELECT Template_Network_Name_Text__c Id, min(Name) Name 
                                                FROM Network_Pricing__c 
                                                WHERE FAF_ID__r.FAF_Status__c IN:FAFStat   AND 
                                                Template_Network_Name_Text__c <> NULL AND  Year__c = 'All'  AND FAF_Network_Ops__c IN:objId 
                                                GROUP BY  Template_Network_Name_Text__c]);
               
        List<Network_Pricing__c> AgreegateRate = new List<Network_Pricing__c>([SELECT Template_Network_Name_Text__c,Template_Brand_Rate__c,Brand_Rate__c,
                                                Generic_Basis__c,Brand_Basis__c,Template_BER_Guarantee_Rate__c,Template_Generic_Rate__c,BER_Guarantee_Rate__c,Generic_Rate__c,MER_Guarantee_Rate__c,Template_MER_Guarantee_Rate__c,
                                                NED_Guarantee_Rate__c,OED_Count__c,Template_OED_Guarantee_Rate__c,OED_Guarantee_Rate__c,Template_NED_Guarantee_Rate__c,GER_Guarantee_Rate__c,Template_GER_Guarantee_Rate__c,SSG_Guarantee_Rate__c,Template_SSG_Guarantee_Rate__c,
                                                Non_MAC_Generic_Rate__c,Template_Non_MAC_Generic_Rate__c,GER_Count__c,Template_Preferred_Brand_Rate__c,Template_Non_Preferred_Brand_Rate__c,MER_Count__c,NED_Count__c,SSG_Guarantee__c,Generic_Dispensing_Fee__c,Brand_Dispensing_Fee__c,
                                                Template_Brand_Dispensing_Fee__c,Template_Generic_Dispensing_Fee__c,Template_Generic_OR_Mac__c,Template_Generic_OR_Mac_Text__c,FAF_ID__c      
                                                FROM Network_Pricing__c 
                                                WHERE Network_Name_for_Grid__c <> NULL AND  Year__c = 'All'  AND FAF_Network_Ops__c IN:objId]);

 for(Network_Pricing__c  netObj : Nprice){
               Boolean SSGexist = false;
               String AggrRate= '';
               String GenericRate= '';
               String OEDRate= '';
               String GERGenericRate= '';
               String MERGenericRate= '';
               String NEDGenericRate= '';
               String AggrBERRate= '';
               String AggrPrefRate= '';
               String AggrNonPrefRate= '';
               String SSGGenericRate= '';
               String NonMacGenericRate= '';
               String NonMacGenericORRate= '';
               String DispensingFee= '';
               String BGDispensingFee= '';
               String BrandDispensingFee= '';
               String GenericDispensingFee= '';
               BrandExist = false;
               GenericExist = false;
               OEDExist = false;
               PrefExist = false;
               BERExist = false;
               GERGenericExist = false;
               MERGenericExist = false;
               NEDGenericExist = false;
               SSGGenericExist = false;
               NonMacGenericExist = false;
               DispensingExist = false;
               BGDispensing = false;
               ShowGrid = false;
               if (netObj.FAF_ID__r.LOB2__c=='EGWP' && netObj.Network_Name__c!='Med D - IHS')
               {
                 NonMacGenericRate = 'MAC' + '\n' + 'Non – MAC:' + '\n';
               }
                 
               if(MinYearAgreegate != null && MinYearAgreegate.get(netObj.Template_Network_Name_Text__c) != null)
                {
                  AggregateResult vName = MinYearAgreegate.get(netObj.Template_Network_Name_Text__c);
                  if (vName.get('Name') == netObj.Name)
                  {
                    for (Network_Pricing__c BrandRate : AgreegateRate)
                    {
                      if(AgreegateRate != null && !AgreegateRate.isEmpty() && (BrandRate.Template_Network_Name_Text__c == netObj.Template_Network_Name_Text__c))
                          {
                            if(BrandRate.Brand_Basis__c != Label.Baked_Preferred_Rate)
                            {
                             AggrRate+= BrandRate.Template_Brand_Rate__c +  '\n' ;
                            }
                            if (netObj.Brand_Rate__c != null || BrandRate.Brand_Rate__c != null || BrandRate.Brand_Basis__c != Label.Baked_Preferred_Rate)
                             { BrandExist = true;}
                          }
                       if( AgreegateRate != null && !AgreegateRate.isEmpty() && (BrandRate.Template_Network_Name_Text__c == netObj.Template_Network_Name_Text__c) &&  (netObj.Generic_Basis__c == Label.Flat_Generic_Discount))
                          {
                            GenericRate+= BrandRate.Template_Generic_Rate__c +  '\n' ;
                            //if (netObj.Generic_Rate__c != null || BrandRate.Generic_Rate__c != null)
                              GenericExist = true;
                          }
                        //Changes for OED Rate :Mohit Srivastava Start 
                       if( AgreegateRate != null && !AgreegateRate.isEmpty() && (BrandRate.Template_Network_Name_Text__c == netObj.Template_Network_Name_Text__c) && (BrandRate.Generic_Basis__c != Label.Flat_Generic_Discount) && netObj.Specialty_Show_in_Grid__c==true)
                          {
                            OEDRate+= BrandRate.Template_OED_Guarantee_Rate__c+  '\n' ;
                            if (netObj.OED_Guarantee_Rate__c != null || BrandRate.OED_Guarantee_Rate__c != null || BrandRate.OED_Count__c > 0)
                              {OEDExist = true;}
                          }
                         //Changes for OED Rate :Mohit Srivastava End 
                        if(AgreegateRate != null && !AgreegateRate.isEmpty() && (BrandRate.Template_Network_Name_Text__c == netObj.Template_Network_Name_Text__c) && (BrandRate.Generic_Basis__c != Label.Flat_Generic_Discount))
                          {
                            GERGenericRate+= BrandRate.Template_GER_Guarantee_Rate__c +  '\n' ;
                            if (netObj.GER_Guarantee_Rate__c != null || BrandRate.GER_Guarantee_Rate__c != null || BrandRate.GER_Count__c > 0)
                              {GERGenericExist = true;}
                          }
                       if(AgreegateRate != null && !AgreegateRate.isEmpty() && (BrandRate.Template_Network_Name_Text__c == netObj.Template_Network_Name_Text__c) && (BrandRate.Generic_Basis__c != Label.Flat_Generic_Discount))
                          {
                            MERGenericRate+= BrandRate.Template_MER_Guarantee_Rate__c +  '\n' ;
                            if (netObj.MER_Guarantee_Rate__c != null || BrandRate.MER_Guarantee_Rate__c != null || BrandRate.MER_Count__c > 0)
                              {MERGenericExist = true;}
                          }
                       if(AgreegateRate != null && !AgreegateRate.isEmpty() && (BrandRate.Template_Network_Name_Text__c == netObj.Template_Network_Name_Text__c) && (BrandRate.Generic_Basis__c != Label.Flat_Generic_Discount))
                          {
                            NEDGenericRate+= BrandRate.Template_NED_Guarantee_Rate__c +  '\n' ;
                            if (netObj.NED_Guarantee_Rate__c != null || BrandRate.NED_Guarantee_Rate__c != null || BrandRate.NED_Count__c > 0)
                              {NEDGenericExist = true;}
                          }      
                        if( AgreegateRate != null && !AgreegateRate.isEmpty() && (BrandRate.Template_Network_Name_Text__c == netObj.Template_Network_Name_Text__c) && (BrandRate.Generic_Basis__c != Label.Flat_Generic_Discount))
                          {
                            NonMacGenericRate+= BrandRate.Template_Non_MAC_Generic_Rate__c +  '\n' ;
                             NonMacGenericORRate+= BrandRate.Template_Generic_OR_Mac__c +  '\n' ;
                           // if (netObj.Generic_Rate__c != null || BrandRate.Generic_Rate__c != null)
                              NonMacGenericExist = true;
                          }                                 
                       if( AgreegateRate != null && !AgreegateRate.isEmpty() && (BrandRate.Template_Network_Name_Text__c == netObj.Template_Network_Name_Text__c))
                          {
                            SSGGenericRate+= BrandRate.Template_SSG_Guarantee_Rate__c +  '\n' ;
                            //if (netObj.SSG_Guarantee_Rate__c != null || BrandRate.SSG_Guarantee_Rate__c != null || BrandRate.SSG_Guarantee__c > 0)
                              SSGGenericExist = true;
                              if (BrandRate.SSG_Guarantee__c >= 1)
                              {
                               SSGexist = true;
                              }
                          } 
                      if( AgreegateRate != null && !AgreegateRate.isEmpty() && (BrandRate.Template_Network_Name_Text__c == netObj.Template_Network_Name_Text__c))
                          {
                           if (BrandRate.Generic_Dispensing_Fee__c == BrandRate.Brand_Dispensing_Fee__c)
                            {
                            BGDispensingFee+= BrandRate.Template_Brand_Dispensing_Fee__c +  '\n' ;                          
                            }
                            else
                            {
                            BGDispensing = true;
                            }
                            BrandDispensingFee+= BrandRate.Template_Brand_Dispensing_Fee__c +  '\n' ;
                            GenericDispensingFee+= BrandRate.Template_Generic_Dispensing_Fee__c +  '\n' ;
                            DispensingExist = true;
                          } 
                            // Changes for Brand generic rate for Retail Speciality Grid :Mohit Srivastava
                         if(AgreegateRate!= null && !AgreegateRate.isEmpty() && (BrandRate.Template_Network_Name_Text__c == netObj.Template_Network_Name_Text__c))
                        {
                           AggrBERRate += BrandRate.Template_BER_Guarantee_Rate__c +  '\n';
                            if ((netObj.BER_Guarantee_Rate__c != null || BrandRate.BER_Guarantee_Rate__c != null) && netObj.FAF_ID__r.LOB2__c !='EGWP')
                             { BERExist = true;}
                             
                            if(netObj.Brand_Basis__c == Label.Baked_Preferred_Rate && (BrandRate.Template_Network_Name_Text__c == netObj.Template_Network_Name_Text__c))
                            {
                             AggrPrefRate += BrandRate.Template_Preferred_Brand_Rate__c +  '\n';
                             AggrNonPrefRate += BrandRate.Template_Non_Preferred_Brand_Rate__c +  '\n';
                             PrefExist = true;
                            }
                        }  
                                                                  
                  }
                  ShowGrid = true;
                  netObj.Template_Generic_Display__c = false; 
                  netObj.Template_Non_MAC_Generic_Display__c = true; 
                  if (netObj.Generic_Basis__c == Label.Flat_Generic_Discount)
                   {
                     netObj.Template_Generic_Display__c = true;  
                     netObj.Template_Non_MAC_Generic_Display__c = false; 
                   }
                    if(PrefExist == true)
                    { 
                         netObj.Template_Preferred_Brand_Rate_Text__c = AggrPrefRate;     
                         netObj.Template_Non_Preferred_Brand_Rate_Text__c  = AggrNonPrefRate; 
                         netObj.Template_Preferred_Display__c=true;                                          
                    }
                    else
                    {
                         netObj.Template_Preferred_Brand_Rate_Text__c = ' ';     
                         netObj.Template_Non_Preferred_Brand_Rate_Text__c  = ' ';
                         netObj.Template_Preferred_Display__c=false;
                    }
                   if(BrandExist == true && BERExist == false )
                   { 
                       netObj.Template_Brand_Rate_Text__c = AggrRate;  
                       netObj.Template_Brand_Display__c = true;                                              
                   }
                   else
                  {
                      netObj.Template_Brand_Rate_Text__c = ' ';
                      netObj.Template_Brand_Display__c = false;
                  }
                    // End: Specialty grid changes : Mohit Srivastava
                  if (GenericExist == true || GERGenericExist == true || MERGenericExist == true || NEDGenericExist == true)
                  {
                      netObj.Template_Generic_Display__c = true; 
                  }
                  else
                  {
                      netObj.Template_Generic_Display__c = false; 
                  }
                  if(GenericExist == true)
                   { 
                       netObj.Template_Generic_Rate_Text__c = GenericRate;                                                 
                   }
                   else
                  {
                      netObj.Template_Generic_Rate_Text__c = ' ';
                  } 
                  //Start :Changes For OED Rate : Mohit Srivastava
                  if(OEDExist == true)
                   { 
                       netObj.Template_OED_Guarantee_Rate_Text__c = OEDRate;  
                       netObj.Template_OED_Display__c= true;                                                  
                   }
                  else
                  {
                      netObj.Template_OED_Guarantee_Rate_Text__c = ' ';
                      netObj.Template_OED_Display__c= false;
                  } 
                  //End :Changes For OED Rate : Mohit Srivastava
                  if(GERGenericExist == true)
                   { 
                       netObj.Template_GER_Guarantee_Rate_Text__c = GERGenericRate;                   
                       netObj.Template_GER_Display__c = true;                                               
                   }
                   else
                  {
                      netObj.Template_GER_Guarantee_Rate_Text__c = ' ';
                      netObj.Template_GER_Display__c = false;   
                  }  
                  if(MERGenericExist == true)
                   { 
                       netObj.Template_MER_Guarantee_Rate_Text__c = MERGenericRate;   
                       netObj.Template_MER_Display__c = true;                                                  
                   }
                   else
                  {
                      netObj.Template_MER_Guarantee_Rate_Text__c = ' ';
                      netObj.Template_MER_Display__c = false; 
                  }  
                  if(NEDGenericExist == true)
                   { 
                       netObj.Template_NED_Guarantee_Rate_Text__c = NEDGenericRate;  
                       netObj.Template_NED_Display__c = true;                                                   
                   }
                   else
                  {
                      netObj.Template_NED_Guarantee_Rate_Text__c = ' ';
                      netObj.Template_NED_Display__c = false;  
                  }  
                   if(NonMacGenericExist == true) 
                   { 
                       netObj.Template_Non_MAC_Generic_Rate_Text__c = NonMacGenericRate; 
                        netObj.Template_Generic_OR_Mac_Text__c = NonMacGenericORRate;
                       netObj.Template_NonMacGeneric_Display__c = true;                                              
                   }
                   else
                  {
                      netObj.Template_Non_MAC_Generic_Rate_Text__c = ' ';
                      netObj.Template_Generic_OR_Mac_Text__c = ' ';
                      netObj.Template_NonMacGeneric_Display__c = true;
                  }  
                  if(SSGGenericExist == true && SSGexist == true)
                   { 
                       netObj.Template_SSG_Guarantee_Rate_Text__c = SSGGenericRate; 
                       netObj.SSG_Display__c = true; 
                                               
                   }
                   else
                  {
                      netObj.Template_SSG_Guarantee_Rate_Text__c = ' ';
                      netObj.SSG_Display__c = false; 
                  }  
                    // End: Specialty grid changes : Mohit Srivastava
                  
                   if(DispensingExist == true)  
                   { 
                    if (BGDispensing == true)
                      {
                      DispensingFee = 'Brand' + '\n' + BrandDispensingFee + '\n' + 'Generic' + '\n' + GenericDispensingFee + '\n\n';
                      }
                      else
                      {
                      DispensingFee = 'Brand & Generic' + '\n' + BGDispensingFee;
                      }
                       netObj.Template_Dispensing_Fee_Text__c = DispensingFee;                                                   
                   }
                   else
                      {
                       netObj.Template_Dispensing_Fee_Text__c = ' ';
                      }  
                   }   
                  
                  if(ShowGrid != true)
                   { 
                       netObj.Show_in_Grid__c = false;
                        netObj.Specialty_Show_in_Grid__c=false;
                       ShowinGrid.add(netObj); 
                   }               
                }           
                if(BrandExist == false && netObj.Template_BER_Guarantee_Rate_Text__c== null && netObj.FAF_ID__r.LOB2__c !='EGWP')
                {netObj.Template_Brand_Rate_Text__c= netObj.Template_Brand_Rate__c;}
                          //netObj.Batch_Update__c = false;  
                          ListNpricing.add(netObj);    
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
   
    } */


/*=================================================================================
 * @Method Name       : UpdateRebateGuarantee
 * @author            : Soumendu Chowdhury
 * @created date      : 07/09/2019
 * @Last modified by  : Soumendu Chowdhury
 * @Purpose           : Populate Begin , End Date and Show in Grid Flag for Specialty / Non-Specialty Formulary Rebate Grid
=======================================================================================*/
/*@future
global static void UpdateRebateGuarantee(List<id> objId)
{
//commented by sonal sharma
    
try
{

DeepCloneUtility.OFF_TRIGGERS_PROCBUILDER=false;
Set<id> ids=new set<id>();
Set<id> FAFids=new set<id>();
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
Map<id,Rebate_Guarantees__c> MapYearComb = new Map<id,Rebate_Guarantees__c>();
Set<String> yearstr=new Set<String>();
List<PCD_Modeled_Formulary_Name__mdt> CustomFormulary=[SELECT Specialty_Formulary_Name__c,Non_Specialty_Formulary_Name__c,Modeled_Formulary_Name__c
                                                                    FROM PCD_Modeled_Formulary_Name__mdt];
List<PCD_Modeled_Plan_Design__mdt> CustomPlanDesign=[SELECT Plan_Design__c,Modeled_Plan_Design__c
                                                                    FROM PCD_Modeled_Plan_Design__mdt];
PCD_FAF_Status__mdt FAFStatus = [SELECT Value__c FROM PCD_FAF_Status__mdt LIMIT 1]; 
List<string> FAFStat = new List<string>();
for(string s: FAFStatus.Value__c.split(','))
   {
    FAFStat.add(s);
   }   
List<Rebate_Guarantees__c> Scope =[SELECT ID,Rebate_Operations__c,FAF_ID__c,Year_Begin_Date__c,Year_End_Date__c,Invokable_Update__c,Year__c,Template_Non_Specialty_Grid_Name_Text__c, 
                                        Template_Specialty_Grid_Name_Text__c,LOB2__c,Plan_Design__c,GSTP__c,Batch_Update__c,Modeled_Non_Specialty_Formulary_Name__c,Modeled_Specialty_Formulary_Name__c,
                                        Modeled_Non_Specialty_PlanDesign__c,Modeled_Specialty_PlanDesign__c,Template_Specialty_Grid_Name__c,Template_Non_Specialty_Grid_Name__c,Show_in_Non_Specialty_Grid__c,
                                        Show_in_Specialty_Grid__c,Specialty_Formulary__c,Non_Specialty_Formulary_2__c,Template_SpecialtyatCVS_Display__c,Template_SpecialtyatRetail_Display__c
                                        FROM Rebate_Guarantees__c where FAF_ID__r.FAF_Status__c IN:FAFStat  and FAF_ID__c IN:objId];

List<Rebate_Gtees_Specialty_Class_Carve_Outs__c> Rcurve = [SELECT Id,Name,Year__c,LOB2__c,FAF_ID__c,Year_Begin_Date__c,Year_End_Date__c,Drug_Therapy_Class_2__c,Specialty_Dollar_Amount__c,Print_FAF_Specialty__c,Specialty_Retail_Dollar_Amt__c,Print_FAF_Specialty_Retail__c FROM Rebate_Gtees_Specialty_Class_Carve_Outs__c WHERE FAF_ID__c IN:objId order by Drug_Therapy_Class_2__c];

for(Rebate_Guarantees__c  rebObj : scope)
             {
               ids.add(rebObj.id);
               FAFids.add(rebObj.FAF_ID__c);
               yearstr.add(rebObj.Year__c);
               if(rebObj.Year__c=='All'){
               MapYearComb.put(rebObj.Id,rebObj);
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
            }        */ 

    /*
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
   
            //commented by sonal sharma
    /*
            for(PCD_Modeled_Plan_Design__mdt plndsgn: CustomPlanDesign)
            {
                mapplandsgn.put(plndsgn.Plan_Design__c,plndsgn.Modeled_Plan_Design__c);
            }
           List<Rebate_Gtees_Specialty_Class_Carve_Outs__c>  rebatecur = new List<Rebate_Gtees_Specialty_Class_Carve_Outs__c>(); 
           for(Rebate_Gtees_Specialty_Class_Carve_Outs__c  rcObj : Rcurve)
           {
            
            if(rcObj.Year__c=='1' && rcObj.Year_Begin_Date__c==null){
                rcObj.Year_Begin_Date__c=MapYear1Begin.get(rcObj.FAF_ID__c);
                }
                if(rcObj.Year__c=='2' && rcObj.Year_Begin_Date__c==null){
                    rcObj.Year_Begin_Date__c=MapYear2Begin.get(rcObj.FAF_ID__c);
                }
                if(rcObj.Year__c=='3' && rcObj.Year_Begin_Date__c==null){
                    rcObj.Year_Begin_Date__c=MapYear3Begin.get(rcObj.FAF_ID__c);
                }
                if(rcObj.Year__c=='4' && rcObj.Year_Begin_Date__c==null){
                    rcObj.Year_Begin_Date__c=MapYear4Begin.get(rcObj.FAF_ID__c);
                }
                if(rcObj.Year__c=='5' && rcObj.Year_Begin_Date__c==null){
                    rcObj.Year_Begin_Date__c=MapYear5Begin.get(rcObj.FAF_ID__c);
                }
                // Year End Date 
                
                if(rcObj.Year__c=='1' && rcObj.Year_End_Date__c==null){
                rcObj.Year_End_Date__c=MapYear1End.get(rcObj.FAF_ID__c);
                }
                if(rcObj.Year__c=='2' && rcObj.Year_End_Date__c==null){
                    rcObj.Year_End_Date__c=MapYear2End.get(rcObj.FAF_ID__c);
                }
                if(rcObj.Year__c=='3' && rcObj.Year_End_Date__c==null){
                    rcObj.Year_End_Date__c=MapYear3End.get(rcObj.FAF_ID__c);
                }
                if(rcObj.Year__c=='4' && rcObj.Year_End_Date__c==null){
                    rcObj.Year_End_Date__c=MapYear4End.get(rcObj.FAF_ID__c);
                }
                if(rcObj.Year__c=='5' && rcObj.Year_End_Date__c==null){
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
                    if((rgObj.Year__c=='1'|| rgObj.Year__c=='2' || rgObj.Year__c=='3' || rgObj.Year__c=='4'|| rgObj.Year__c=='5') && (rgObj.Template_Specialty_Grid_Name__c == rg.Template_Specialty_Grid_Name__c) && rg.Year__c=='All')
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
                if(mapnonspecstr.get(rgObj.Non_Specialty_Formulary_2__c) !=null){
                rgObj.Modeled_Non_Specialty_Formulary_Name__c = 'REBATES - ' + mapnonspecstr.get(rgObj.Non_Specialty_Formulary_2__c);
                }
                else
                {
                rgObj.Modeled_Non_Specialty_Formulary_Name__c = 'REBATES';
                }
                if(mapspecstr.get(rgObj.Specialty_Formulary__c) !=null){
                rgObj.Modeled_Specialty_Formulary_Name__c = 'REBATES - ' + mapspecstr.get(rgObj.Specialty_Formulary__c);
                }
                else
                {
                rgObj.Modeled_Specialty_Formulary_Name__c = 'REBATES' ;
                }
                if (rgObj.GSTP__c != null){
                //Start: CHanges Done by : Mohit Srivastava to Solve null issue for Plan design
                    if(mapplandsgn.get(rgObj.Plan_Design__c)!=null){
                        rgObj.Modeled_Non_Specialty_PlanDesign__c = mapplandsgn.get(rgObj.Plan_Design__c) + ' - ' + rgObj.GSTP__c;
                    }
                    else{
                    rgObj.Modeled_Non_Specialty_PlanDesign__c =' - ' + rgObj.GSTP__c;
                    }
                }
                else{
                    if(mapplandsgn.get(rgObj.Plan_Design__c)!=null){
                            rgObj.Modeled_Non_Specialty_PlanDesign__c = mapplandsgn.get(rgObj.Plan_Design__c);
                    }
                    else{
                    rgObj.Modeled_Non_Specialty_PlanDesign__c ='  ';
                    }
                }
                //End: CHanges Done by : Mohit Srivastava to Solve null issue for Plan design
                
                rgObj.Modeled_Specialty_PlanDesign__c = mapplandsgn.get(rgObj.Plan_Design__c);
                if (excludenonspec == false && rgObj.Modeled_Non_Specialty_Formulary_Name__c != null)
                rgObj.Template_Non_Specialty_Grid_Name_Text__c = rgObj.LOB2__c + '-' + mapnonspecstr.get(rgObj.Non_Specialty_Formulary_2__c) + '-' + rgObj.Modeled_Non_Specialty_PlanDesign__c;
                if (excludenonspec == false && rgObj.Modeled_Specialty_Formulary_Name__c != null)
                rgObj.Template_Specialty_Grid_Name_Text__c = rgObj.LOB2__c + '-' + mapspecstr.get(rgObj.Specialty_Formulary__c) + '-' + rgObj.Modeled_Specialty_PlanDesign__c;
                
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
                               
                if(rgObj.Year__c=='1' && rgObj.Year_Begin_Date__c==null){
                rgObj.Year_Begin_Date__c=MapYear1Begin.get(rgObj.FAF_ID__c);
                }
                if(rgObj.Year__c=='2' && rgObj.Year_Begin_Date__c==null){
                    rgObj.Year_Begin_Date__c=MapYear2Begin.get(rgObj.FAF_ID__c);
                }
                if(rgObj.Year__c=='3' && rgObj.Year_Begin_Date__c==null){
                    rgObj.Year_Begin_Date__c=MapYear3Begin.get(rgObj.FAF_ID__c);
                }
                if(rgObj.Year__c=='4' && rgObj.Year_Begin_Date__c==null){
                    rgObj.Year_Begin_Date__c=MapYear4Begin.get(rgObj.FAF_ID__c);
                }
                if(rgObj.Year__c=='5' && rgObj.Year_Begin_Date__c==null){
                    rgObj.Year_Begin_Date__c=MapYear5Begin.get(rgObj.FAF_ID__c);
                }
                // Year End Date 
                
                if(rgObj.Year__c=='1' && rgObj.Year_End_Date__c==null){
                rgObj.Year_End_Date__c=MapYear1End.get(rgObj.FAF_ID__c);
                }
                if(rgObj.Year__c=='2' && rgObj.Year_End_Date__c==null){
                    rgObj.Year_End_Date__c=MapYear2End.get(rgObj.FAF_ID__c);
                }
                if(rgObj.Year__c=='3' && rgObj.Year_End_Date__c==null){
                    rgObj.Year_End_Date__c=MapYear3End.get(rgObj.FAF_ID__c);
                }
                if(rgObj.Year__c=='4' && rgObj.Year_End_Date__c==null){
                    rgObj.Year_End_Date__c=MapYear4End.get(rgObj.FAF_ID__c);
                }
                if(rgObj.Year__c=='5' && rgObj.Year_End_Date__c==null){
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
   HandleNetworkPricingFutureCall.Template_Rebate_Grid(objId); 
}
catch(Exception Ex)
{ 
    system.debug('Exception....'+ex.getMessage());
}

 }
*/


/*=================================================================================
 * @Method Name       : Template_Rebate_Grid
 * @author            : Soumendu Chowdhury
 * @created date      : 07/09/2019
 * @Last modified by  : Soumendu Chowdhury
 * @Purpose           : Populate complex Data structure to display Rebate Grids in Apttus CF Template
=======================================================================================*/
/*@future
public static void Template_Rebate_Grid(List<id> objId)
{ 
//commented by sonal sharma
    
try
{

DeepCloneUtility.OFF_TRIGGERS_PROCBUILDER=false;
Rebate_Guarantees__c[] ListRebate = new List<Rebate_Guarantees__c>();
Rebate_Guarantees__c[] ShowinSpecGrid = new List<Rebate_Guarantees__c>();
Rebate_Guarantees__c[] ShowinNonSpecGrid = new List<Rebate_Guarantees__c>();
Boolean RetailExist = false;
Boolean Retail30Exist = false;
Boolean Retail90Exist = false;
Boolean ClientOwnedExist = false;
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
List<Rebate_Guarantees__c> Rgeeupdate = new List<Rebate_Guarantees__c>();
Set<string> Pharbenlabel = new Set<String>();
List<string> Pharbenvalue = new List<String>();
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

Set<Rebate_Gtees_Specialty_Class_Carve_Outs__c> dupset=new Set<Rebate_Gtees_Specialty_Class_Carve_Outs__c>(); 
Map<String,Integer> myMap =new Map<String,Integer>();
String cLeftBeforeLabel=System.Label.Left_Align_Rebate_Gurantee; 
String cRightBeforeLabel=System.Label.Right_Allign;   
  

PCD_FAF_Status__mdt FAFStatus = [SELECT Value__c FROM PCD_FAF_Status__mdt LIMIT 1]; 
        List<string> FAFStat = new List<string>();
        for(string s: FAFStatus.Value__c.split(','))
              {
                 FAFStat.add(s);
              }        

List<Rebate_Guarantees__c> Rgee =[SELECT ID,Name,Rebate_Operations__c,FAF_ID__c,Pecentage_Guarantee__c,Year_Begin_Date__c,Year_End_Date__c,Invokable_Update__c,Year__c,Template_Non_Specialty_Grid_Name_Text__c,
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
                                        FROM Rebate_Guarantees__c WHERE FAF_ID__r.FAF_Status__c IN:FAFStat AND (Show_in_Specialty_Grid__c = true OR Show_in_Non_Specialty_Grid__c= true) AND FAF_ID__c IN:objId];


Map<Id,Rebate_Gtees_Specialty_Class_Carve_Outs__c> Rcurve = new Map<Id,Rebate_Gtees_Specialty_Class_Carve_Outs__c>([ SELECT Id,Rebate_Operations__c,Year__c,LOB2__c,Year_Begin_Date__c,Year_End_Date__c,Drug_Therapy_Class_2__c,Specialty_Dollar_Amount__c,FAF_Print_Specialty__c,Print_FAF_Specialty__c,Specialty_Retail_Dollar_Amt__c,Print_FAF_Specialty_Retail__c  FROM Rebate_Gtees_Specialty_Class_Carve_Outs__c WHERE FAF_ID__c IN:objId ORDER BY Drug_Therapy_Class_2__c]);

Map<String,AggregateResult> MinNonSpecAgreegate = new Map<String,AggregateResult>([SELECT Template_Non_Specialty_Grid_Name_Text__c Id, Min(Name) MinName
                                        FROM Rebate_Guarantees__c 
                                        WHERE FAF_ID__r.FAF_Status__c IN:FAFStat 
                                        AND Show_in_Non_Specialty_Grid__c = true AND FAF_ID__c IN:objId
                                        GROUP BY Template_Non_Specialty_Grid_Name_Text__c]);
                                        
Map<String,AggregateResult> MinSpecAgreegate = new Map<String,AggregateResult>([SELECT Template_Specialty_Grid_Name_Text__c Id, Min(Name) MinName
                                        FROM Rebate_Guarantees__c 
                                        WHERE FAF_ID__r.FAF_Status__c IN:FAFStat 
                                        AND Show_in_Specialty_Grid__c = true AND FAF_ID__c IN:objId
                                        GROUP BY Template_Specialty_Grid_Name_Text__c]);
                                        
List<Rebate_Guarantees__c> AgreegateRate = new List<Rebate_Guarantees__c>([SELECT Id,Name,LOB2__c,ClientOwned30_Display__c,ClientOwned90_Display__c,ClientOwned_Display__c,GSTP__c,Mail_Display__c,Maintenance_Choice_Display__c,
                                        Modeled_Non_Specialty_Formulary_Name__c,Modeled_Non_Specialty_PlanDesign__c,Modeled_Specialty_Formulary_Name__c,Modeled_Specialty_PlanDesign__c,Pecentage_Guarantee__c,
                                        Retail30_Display__c,Retail90_Display__c,Retail_Display__c,Show_in_Non_Specialty_Grid__c,Show_in_Specialty_Grid__c,SpecialtyatRetail_Display__c, Specialty_Display__c,
                                        Template_ClientOwned30_Formula__c,Template_ClientOwned90_Formula__c,Template_Mail_Formula__c,Template_Mail_Label__c,Template_Mchoice_Formula__c,Template_Non_Specialty_Grid_Name__c,
                                        Template_Non_Specialty_Plan_Design__c,Template_Retail30_Formula__c,Template_Retail90_Formula__c,Template_SpecialtyatRetail_Formula__c,Template_Specialty_Formula__c,Template_Specialty_Grid_Name__c,
                                        Template_Specialty_Plan_Design__c,Year__c,Retail_30_1__c,Retail_30__c,Retail_90__c,Retail_90_1__c,Client_Owned_30__c,Client_Owned_30_1__c,Client_Owned_90__c,Client_Owned_90_1__c,Mail__c,Mail_1__c,
                                        Mchoice__c,Mchoice_1__c,Specialty__c,Specialty_1__c,Specialty_Retail__c,Specialty_Retail_1__c
                                        FROM Rebate_Guarantees__c
                                        WHERE (Show_in_Specialty_Grid__c = true OR Show_in_Non_Specialty_Grid__c= true) AND FAF_ID__c IN:objId
                                        ORDER BY Year__c]);  
   
   
for(Rebate_Guarantees__c  rg: Rgee )
{
  RetailExist = false;
  Retail30Exist = false;
  Retail90Exist = false;
  ClientOwnedExist = false;
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
  Pharbenlabel.clear();
  Pharbenvalue.clear();
  setDupList.clear();
  myMap.clear();
  setRemoveDup.clear();
  strCheck.clear();
  mapYear.clear();
  mapYearAll.clear();
  yearset.clear();
  yearAllset.clear();
  rg.Template_Mail_Label_Text__c = rg.Template_Mail_Label__c;
  if(MinNonSpecAgreegate != null && MinNonSpecAgreegate.get(rg.Template_Non_Specialty_Grid_Name_Text__c) != null) 
                {
                  AggregateResult  vName = MinNonSpecAgreegate.get(rg.Template_Non_Specialty_Grid_Name_Text__c); /* 
                  if (vName.get('MinName') == rg.Name) 
                  {
                     ShowNonSpecGrid = true;  
                     for (Rebate_Guarantees__c rebate : AgreegateRate)
                     {
                       //Retail Information population
                       if (rebate.Retail_Display__c == true && rebate.Retail_30_1__c !=0 && rebate.Retail_30_1__c !=null && rebate.Pecentage_Guarantee__c == true && rebate.Modeled_Non_Specialty_Formulary_Name__c == rg.Modeled_Non_Specialty_Formulary_Name__c && rebate.Modeled_Non_Specialty_PlanDesign__c == rg.Modeled_Non_Specialty_PlanDesign__c && rebate.LOB2__c == rg.LOB2__c)
                       {
                         AggrRetail += rebate.Template_Retail30_Formula__c + '\n';
                         RetailExist = true;
                       }
                       if (rebate.Retail_Display__c == true && rebate.Retail_30__c !=0 && rebate.Retail_30__c !=null && rebate.Pecentage_Guarantee__c == false && rebate.Modeled_Non_Specialty_Formulary_Name__c == rg.Modeled_Non_Specialty_Formulary_Name__c && rebate.Modeled_Non_Specialty_PlanDesign__c == rg.Modeled_Non_Specialty_PlanDesign__c && rebate.LOB2__c == rg.LOB2__c)
                       {
                         AggrRetail += rebate.Template_Retail30_Formula__c + '\n';
                         RetailExist = true;
                       }
                       //Retail30 Information population
                       if (rebate.Retail30_Display__c == true && rebate.Retail_90_1__c !=0 && rebate.Retail_90_1__c!=null && rebate.Pecentage_Guarantee__c == true && rebate.Modeled_Non_Specialty_Formulary_Name__c == rg.Modeled_Non_Specialty_Formulary_Name__c && rebate.Modeled_Non_Specialty_PlanDesign__c == rg.Modeled_Non_Specialty_PlanDesign__c && rebate.LOB2__c == rg.LOB2__c)
                       {
                         AggrRetail30 += rebate.Template_Retail30_Formula__c + '\n';
                         Retail30Exist = true;
                       }
                       if (rebate.Retail30_Display__c == true && rebate.Retail_90__c !=0 && rebate.Retail_90__c!=null && rebate.Pecentage_Guarantee__c == false && rebate.Modeled_Non_Specialty_Formulary_Name__c == rg.Modeled_Non_Specialty_Formulary_Name__c && rebate.Modeled_Non_Specialty_PlanDesign__c == rg.Modeled_Non_Specialty_PlanDesign__c && rebate.LOB2__c == rg.LOB2__c)
                       {
                         AggrRetail30 += rebate.Template_Retail30_Formula__c + '\n';
                         Retail30Exist = true;
                       } 
                       //Retail90 Information population
                       if (rebate.Retail90_Display__c == true && rebate.Retail_90_1__c !=0 && rebate.Retail_90_1__c!=null && rebate.Pecentage_Guarantee__c == true && rebate.Modeled_Non_Specialty_Formulary_Name__c == rg.Modeled_Non_Specialty_Formulary_Name__c && rebate.Modeled_Non_Specialty_PlanDesign__c == rg.Modeled_Non_Specialty_PlanDesign__c && rebate.LOB2__c == rg.LOB2__c)
                       {
                         AggrRetail90 += rebate.Template_Retail90_Formula__c + '\n';
                         Retail90Exist = true;
                       }
                       if (rebate.Retail90_Display__c == true && rebate.Retail_90__c !=0  && rebate.Retail_90__c!=null && rebate.Pecentage_Guarantee__c == false && rebate.Modeled_Non_Specialty_Formulary_Name__c == rg.Modeled_Non_Specialty_Formulary_Name__c && rebate.Modeled_Non_Specialty_PlanDesign__c == rg.Modeled_Non_Specialty_PlanDesign__c && rebate.LOB2__c == rg.LOB2__c)
                       {
                         AggrRetail90 += rebate.Template_Retail90_Formula__c + '\n';
                         Retail90Exist = true;
                       }
                      //ClientOwned Information population
                       if (rebate.ClientOwned_Display__c == true && rebate.Client_Owned_30_1__c !=0 && rebate.Client_Owned_30_1__c!=null && rebate.Pecentage_Guarantee__c == true && rebate.Modeled_Non_Specialty_Formulary_Name__c == rg.Modeled_Non_Specialty_Formulary_Name__c && rebate.Modeled_Non_Specialty_PlanDesign__c == rg.Modeled_Non_Specialty_PlanDesign__c && rebate.LOB2__c == rg.LOB2__c)
                       {
                         AggrClientOwned += rebate.Template_ClientOwned30_Formula__c + '\n';
                         ClientOwnedExist = true;
                       }
                       if (rebate.ClientOwned_Display__c == true && rebate.Client_Owned_30__c !=0 && rebate.Client_Owned_30__c!=null && rebate.Pecentage_Guarantee__c == false && rebate.Modeled_Non_Specialty_Formulary_Name__c == rg.Modeled_Non_Specialty_Formulary_Name__c && rebate.Modeled_Non_Specialty_PlanDesign__c == rg.Modeled_Non_Specialty_PlanDesign__c && rebate.LOB2__c == rg.LOB2__c)
                       {
                         AggrClientOwned += rebate.Template_ClientOwned30_Formula__c + '\n';
                         ClientOwnedExist = true;
                       }
                       //ClientOwned30 Information population
                       if (rebate.ClientOwned30_Display__c == true && rebate.Client_Owned_90_1__c !=0 && rebate.Client_Owned_90_1__c!=null && rebate.Pecentage_Guarantee__c == true && rebate.Modeled_Non_Specialty_Formulary_Name__c == rg.Modeled_Non_Specialty_Formulary_Name__c && rebate.Modeled_Non_Specialty_PlanDesign__c == rg.Modeled_Non_Specialty_PlanDesign__c && rebate.LOB2__c == rg.LOB2__c)
                       {
                         AggrClientOwned30 += rebate.Template_ClientOwned30_Formula__c + '\n';
                         ClientOwned30Exist = true;
                       }
                       if (rebate.ClientOwned30_Display__c == true && rebate.Client_Owned_90__c !=0 && rebate.Client_Owned_90__c!=null && rebate.Pecentage_Guarantee__c == false && rebate.Modeled_Non_Specialty_Formulary_Name__c == rg.Modeled_Non_Specialty_Formulary_Name__c && rebate.Modeled_Non_Specialty_PlanDesign__c == rg.Modeled_Non_Specialty_PlanDesign__c && rebate.LOB2__c == rg.LOB2__c)
                       {
                         AggrClientOwned30 += rebate.Template_ClientOwned30_Formula__c + '\n';
                         ClientOwned30Exist = true;
                       } 
                       //ClientOwned90 Information population
                       if (rebate.ClientOwned90_Display__c == true && rebate.Client_Owned_90_1__c !=0 && rebate.Client_Owned_90_1__c!=null && rebate.Pecentage_Guarantee__c == true && rebate.Modeled_Non_Specialty_Formulary_Name__c == rg.Modeled_Non_Specialty_Formulary_Name__c && rebate.Modeled_Non_Specialty_PlanDesign__c == rg.Modeled_Non_Specialty_PlanDesign__c && rebate.LOB2__c == rg.LOB2__c)
                       {
                         AggrClientOwned90 += rebate.Template_ClientOwned90_Formula__c + '\n';
                         ClientOwned90Exist = true;
                       }
                       if (rebate.ClientOwned90_Display__c == true && rebate.Client_Owned_90__c !=0 && rebate.Client_Owned_90__c!=null && rebate.Pecentage_Guarantee__c == false && rebate.Modeled_Non_Specialty_Formulary_Name__c == rg.Modeled_Non_Specialty_Formulary_Name__c && rebate.Modeled_Non_Specialty_PlanDesign__c == rg.Modeled_Non_Specialty_PlanDesign__c && rebate.LOB2__c == rg.LOB2__c)
                       {
                         AggrClientOwned90 += rebate.Template_ClientOwned90_Formula__c + '\n';
                         ClientOwned90Exist  = true;
                       }  
                       
                      if(rebate.Template_Mail_Label__c == 'MAIL' && rebate.Modeled_Non_Specialty_Formulary_Name__c == rg.Modeled_Non_Specialty_Formulary_Name__c && rebate.Modeled_Non_Specialty_PlanDesign__c == rg.Modeled_Non_Specialty_PlanDesign__c && rebate.LOB2__c == rg.LOB2__c)
                       {
                            if (rg.Template_Mail_Label_Text__c ==  'MAIL/MAINTENANCE CHOICE')
                            {
                              AggrMchoice = AggrMail;
                            }
                            rg.Template_Mail_Label_Text__c =  'MAIL';
                       }
                       else if(rebate.Template_Mail_Label__c == 'MAIL/MAINTENANCE CHOICE' && rg.Template_Mail_Label_Text__c !=  'MAIL' && rebate.Modeled_Non_Specialty_Formulary_Name__c == rg.Modeled_Non_Specialty_Formulary_Name__c && rebate.Modeled_Non_Specialty_PlanDesign__c == rg.Modeled_Non_Specialty_PlanDesign__c && rebate.LOB2__c == rg.LOB2__c)
                       {
                       rg.Template_Mail_Label_Text__c =  'MAIL/MAINTENANCE CHOICE';
                       }
                       
                       //Mail Information population
                       if (rebate.Mail_Display__c == true && rebate.Mail_1__c !=0 && rebate.Mail_1__c!=null && rebate.Pecentage_Guarantee__c == true && rebate.Modeled_Non_Specialty_Formulary_Name__c == rg.Modeled_Non_Specialty_Formulary_Name__c && rebate.Modeled_Non_Specialty_PlanDesign__c == rg.Modeled_Non_Specialty_PlanDesign__c && rebate.LOB2__c == rg.LOB2__c)
                       {
                         AggrMail += rebate.Template_Mail_Formula__c + '\n';
                         MailExist = true;
                       }
                       if (rebate.Mail_Display__c == true && rebate.Mail__c !=0 && rebate.Mail__c!=null && rebate.Pecentage_Guarantee__c == false && rebate.Modeled_Non_Specialty_Formulary_Name__c == rg.Modeled_Non_Specialty_Formulary_Name__c && rebate.Modeled_Non_Specialty_PlanDesign__c == rg.Modeled_Non_Specialty_PlanDesign__c && rebate.LOB2__c == rg.LOB2__c)
                       {
                         AggrMail += rebate.Template_Mail_Formula__c + '\n';
                         MailExist  = true;
                       }  
                    
                       
                       //Mchoice Information population
                       if ((rebate.Maintenance_Choice_Display__c == true || rg.Template_Mail_Label_Text__c ==  'MAIL') && rebate.Mchoice_1__c !=0 && rebate.Mchoice_1__c!=null && rebate.Pecentage_Guarantee__c == true && rebate.Modeled_Non_Specialty_Formulary_Name__c == rg.Modeled_Non_Specialty_Formulary_Name__c && rebate.Modeled_Non_Specialty_PlanDesign__c == rg.Modeled_Non_Specialty_PlanDesign__c && rebate.LOB2__c == rg.LOB2__c)
                       {
                         AggrMchoice += rebate.Template_Mchoice_Formula__c + '\n';
                         MchoiceExist = true;
                       }
                       if ((rebate.Maintenance_Choice_Display__c == true || rg.Template_Mail_Label_Text__c ==  'MAIL') && rebate.Mchoice__c !=0 && rebate.Mchoice__c!=null && rebate.Pecentage_Guarantee__c == false && rebate.Modeled_Non_Specialty_Formulary_Name__c == rg.Modeled_Non_Specialty_Formulary_Name__c && rebate.Modeled_Non_Specialty_PlanDesign__c == rg.Modeled_Non_Specialty_PlanDesign__c && rebate.LOB2__c == rg.LOB2__c)
                       {
                         AggrMchoice += rebate.Template_Mchoice_Formula__c + '\n';
                         MchoiceExist = true;
                       }  
                       
                       //Specialty at Retail Information population
                       if (rebate.SpecialtyatRetail_Display__c == true  && rebate.Specialty_Retail_1__c !=0 && rebate.Specialty_Retail_1__c!=null && rebate.Pecentage_Guarantee__c == true && rebate.Modeled_Non_Specialty_Formulary_Name__c == rg.Modeled_Non_Specialty_Formulary_Name__c && rebate.Modeled_Non_Specialty_PlanDesign__c == rg.Modeled_Non_Specialty_PlanDesign__c && rebate.LOB2__c == rg.LOB2__c)
                       {
                         AggrSpecatRetail += rebate.Template_SpecialtyatRetail_Formula__c + '\n';
                         SpecialtyatRetailExist = true;
                       }
                        
                       if (rebate.SpecialtyatRetail_Display__c == true  && rebate.Specialty_Retail__c !=0 && rebate.Specialty_Retail__c!=null && rebate.Pecentage_Guarantee__c == false && rebate.Modeled_Non_Specialty_Formulary_Name__c == rg.Modeled_Non_Specialty_Formulary_Name__c && rebate.Modeled_Non_Specialty_PlanDesign__c == rg.Modeled_Non_Specialty_PlanDesign__c && rebate.LOB2__c == rg.LOB2__c)
                        {
                         AggrSpecatRetail += rebate.Template_SpecialtyatRetail_Formula__c + '\n';
                         SpecialtyatRetailExist = true;
                        } 
                                           
                       
                       
                     }
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
                       if (rebate.Specialty_Display__c == true  && rebate.Specialty_1__c !=0 && rebate.Specialty_1__c!=null && rebate.Pecentage_Guarantee__c == true && rebate.Modeled_Specialty_Formulary_Name__c == rg.Modeled_Specialty_Formulary_Name__c && rebate.Modeled_Specialty_PlanDesign__c == rg.Modeled_Specialty_PlanDesign__c && rebate.LOB2__c == rg.LOB2__c)
                       {
                         AggrSpecatCVS += rebate.Template_Specialty_Formula__c + '\n';
                         SpecialtyatCVSExist = true;
                       }
                       
                       if (rebate.Specialty_Display__c == true  && rebate.Specialty__c !=0 && rebate.Specialty__c!=null && rebate.Pecentage_Guarantee__c == false && rebate.Modeled_Specialty_Formulary_Name__c == rg.Modeled_Specialty_Formulary_Name__c && rebate.Modeled_Specialty_PlanDesign__c == rg.Modeled_Specialty_PlanDesign__c && rebate.LOB2__c == rg.LOB2__c)
                       {
                         AggrSpecatCVS += rebate.Template_Specialty_Formula__c + '\n';
                         SpecialtyatCVSExist = true;
                       }
                       
 
                     }
                     */
                     /********************************************************/
                        //Start--Changes for Row Alligment :Mohit Srivastava
                      /********************************************************/
                       //commented by sonal sharma
    /*
                        Boolean  rowFlag=false;
                        //Identifying if we have any duplicate drug name using Map : myMap
                        //Integer counter=1;
                        for (Rebate_Gtees_Specialty_Class_Carve_Outs__c rc: Rcurve.values())
                        {
                       
                             if(rc.Drug_Therapy_Class_2__c!=null){
                             if((rc.LOB2__c == rg.LOB2__c))
                                {
                                    setDupList.add(rc.Drug_Therapy_Class_2__c);
                                    //mapPrice.put(rc.Drug_Therapy_Class_2__c,rc.Specialty_Dollar_Amount__c);
                                    //mapReatilPrice.put(rc.Drug_Therapy_Class_2__c,rc.Specialty_Retail_Dollar_Amt__c);
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
                                system.debug('Map year '+mapYear  +'dditional '+mapYear.get('Additional Products'));
                                system.debug('Map year All '+mapYearAll  +'dditional '+mapYearAll.get('Additional Products'));
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
                     
                         Datetime stdt = rc.Year_Begin_Date__c;
                         Datetime eddt = rc.Year_End_Date__c;
                         String RightLabel=System.Label.Right_Allign;
                         if(rc.Drug_Therapy_Class_2__c!=null){
                            //if(myMap.get(rc.Drug_Therapy_Class_2__c)==1){ 
                             if((rc.LOB2__c == rg.LOB2__c) && rc.Rebate_Operations__c==rg.Rebate_Operations__c )
                            {
                             
                                RcurveExist = true;
                                    if(myMap.get(rc.Drug_Therapy_Class_2__c)==1){
                                        if(rc.Year__c!='All' && !cLeftBeforeLabel.contains(rc.Drug_Therapy_Class_2__c+',') &&!(cRightBeforeLabel.contains(rc.Drug_Therapy_Class_2__c+',') &&(rc.Specialty_Dollar_Amount__c==null && rc.Specialty_Retail_Dollar_Amt__c==null))){
                                            StrPhaben=rc.Drug_Therapy_Class_2__c +'\n'+'\n';
                                        }
                                        else{
                                        StrPhaben=rc.Drug_Therapy_Class_2__c +'\n'+'\n';
                                        }
                                        Pharbenlabel.add(StrPhaben);
                                    }
                                 
                                        
                                    if(myMap.get(rc.Drug_Therapy_Class_2__c)>1){
                                    system.debug('rc.Specialty_Dollar_Amount__c'+rc.Specialty_Dollar_Amount__c);
                                        
                                            if(mapYear.get(rc.Drug_Therapy_Class_2__c)==0 && mapYearAll.get(rc.Drug_Therapy_Class_2__c)==1){
                                                if(!cLeftBeforeLabel.contains(rc.Drug_Therapy_Class_2__c+',') 
                                                 &&!(cRightBeforeLabel.contains(rc.Drug_Therapy_Class_2__c+',') &&(rc.Specialty_Dollar_Amount__c==null && rc.Specialty_Retail_Dollar_Amt__c==null))){
                                                    StrPhaben=rc.Drug_Therapy_Class_2__c+'\n';
                                                }
                                                else{
                                                 StrPhaben=rc.Drug_Therapy_Class_2__c+'\n';
                                                }
                                            }
                                            else if(mapYear.get(rc.Drug_Therapy_Class_2__c)==1 && mapYearAll.get(rc.Drug_Therapy_Class_2__c)==1){
                                                if(!cLeftBeforeLabel.contains(rc.Drug_Therapy_Class_2__c+',')&&
                                                !(cRightBeforeLabel.contains(rc.Drug_Therapy_Class_2__c+',') &&(rc.Specialty_Dollar_Amount__c==null && rc.Specialty_Retail_Dollar_Amt__c==null))){
                                                    StrPhaben=rc.Drug_Therapy_Class_2__c+'\n'+'\n';
                                                }
                                                else{
                                                StrPhaben=rc.Drug_Therapy_Class_2__c+'\n'+'\n';
                                                }
                                            }
                                            else if(mapYear.get(rc.Drug_Therapy_Class_2__c)==2 && mapYearAll.get(rc.Drug_Therapy_Class_2__c)==1){
                                                if(!cLeftBeforeLabel.contains(rc.Drug_Therapy_Class_2__c+',')&&
                                                !(cRightBeforeLabel.contains(rc.Drug_Therapy_Class_2__c+',') &&(rc.Specialty_Dollar_Amount__c==null && rc.Specialty_Retail_Dollar_Amt__c==null))){
                                                    StrPhaben=rc.Drug_Therapy_Class_2__c+'\n'+'\n'+'\n';
                                                }
                                                else{
                                                StrPhaben=rc.Drug_Therapy_Class_2__c+'\n'+'\n'+'\n';
                                                }
                                            }
                                             else if(mapYear.get(rc.Drug_Therapy_Class_2__c)==3 && mapYearAll.get(rc.Drug_Therapy_Class_2__c)==1){
                                                if(!cLeftBeforeLabel.contains(rc.Drug_Therapy_Class_2__c+',')
                                                &&!(cRightBeforeLabel.contains(rc.Drug_Therapy_Class_2__c+',') &&(rc.Specialty_Dollar_Amount__c==null && rc.Specialty_Retail_Dollar_Amt__c==null))){
                                                    StrPhaben=rc.Drug_Therapy_Class_2__c+'\n'+'\n'+'\n'+'\n';
                                                }
                                                else{
                                                StrPhaben=rc.Drug_Therapy_Class_2__c+'\n'+'\n'+'\n'+'\n';
                                                }
                                            }
                                            else if(mapYear.get(rc.Drug_Therapy_Class_2__c)==4 && mapYearAll.get(rc.Drug_Therapy_Class_2__c)==1){
                                                if(!cLeftBeforeLabel.contains(rc.Drug_Therapy_Class_2__c+',')
                                                &&!(cRightBeforeLabel.contains(rc.Drug_Therapy_Class_2__c+',') &&(rc.Specialty_Dollar_Amount__c==null && rc.Specialty_Retail_Dollar_Amt__c==null))){
                                                    StrPhaben=rc.Drug_Therapy_Class_2__c+'\n'+'\n'+'\n'+'\n'+'\n';
                                                }
                                                else{
                                                StrPhaben=rc.Drug_Therapy_Class_2__c+'\n'+'\n'+'\n'+'\n'+'\n';
                                                }
                                             }
                                            
                                            else if(mapYear.get(rc.Drug_Therapy_Class_2__c)==2 && mapYearAll.get(rc.Drug_Therapy_Class_2__c)==null){
                                                if(!cLeftBeforeLabel.contains(rc.Drug_Therapy_Class_2__c+',')
                                                &&!(cRightBeforeLabel.contains(rc.Drug_Therapy_Class_2__c+',') &&(rc.Specialty_Dollar_Amount__c==null && rc.Specialty_Retail_Dollar_Amt__c==null))){
                                                    StrPhaben=rc.Drug_Therapy_Class_2__c+'\n'+'\n'+'\n';
                                                }
                                                else{
                                                StrPhaben=rc.Drug_Therapy_Class_2__c+'\n'+'\n'+'\n';
                                                }
                                            }
                                            else if(mapYear.get(rc.Drug_Therapy_Class_2__c)==3 && mapYearAll.get(rc.Drug_Therapy_Class_2__c)==null){
                                                if(!cLeftBeforeLabel.contains(rc.Drug_Therapy_Class_2__c+',')
                                                &&!(cRightBeforeLabel.contains(rc.Drug_Therapy_Class_2__c+',') &&(rc.Specialty_Dollar_Amount__c==null && rc.Specialty_Retail_Dollar_Amt__c==null))){
                                                    StrPhaben=rc.Drug_Therapy_Class_2__c+'\n'+'\n'+'\n'+'\n';
                                                }
                                                else{
                                                StrPhaben=rc.Drug_Therapy_Class_2__c+'\n'+'\n'+'\n'+'\n';
                                                }
                                            }
                                            else if(mapYear.get(rc.Drug_Therapy_Class_2__c)==4 && mapYearAll.get(rc.Drug_Therapy_Class_2__c)==null){
                                                if(!cLeftBeforeLabel.contains(rc.Drug_Therapy_Class_2__c+',')
                                                &&!(cRightBeforeLabel.contains(rc.Drug_Therapy_Class_2__c+',') &&(rc.Specialty_Dollar_Amount__c==null && rc.Specialty_Retail_Dollar_Amt__c==null))){
                                                    StrPhaben=rc.Drug_Therapy_Class_2__c+'\n'+'\n'+'\n'+'\n'+'\n';
                                                }
                                                else{
                                                StrPhaben=rc.Drug_Therapy_Class_2__c+'\n'+'\n'+'\n'+'\n'+'\n';
                                                }
                                            }
                                            else if(mapYear.get(rc.Drug_Therapy_Class_2__c)==1 && mapYearAll.get(rc.Drug_Therapy_Class_2__c)==null){
                                                if(!cLeftBeforeLabel.contains(rc.Drug_Therapy_Class_2__c+',')
                                                &&!(cRightBeforeLabel.contains(rc.Drug_Therapy_Class_2__c+',') &&(rc.Specialty_Dollar_Amount__c==null && rc.Specialty_Retail_Dollar_Amt__c==null))){
                                                StrPhaben=rc.Drug_Therapy_Class_2__c+'\n'+'\n';
                                                }
                                                else{
                                                StrPhaben=rc.Drug_Therapy_Class_2__c+'\n'+'\n';
                                                }
                                            }
                                            else if(mapYear.get(rc.Drug_Therapy_Class_2__c)==0 && mapYearAll.get(rc.Drug_Therapy_Class_2__c)==null){
                                                if(!cLeftBeforeLabel.contains(rc.Drug_Therapy_Class_2__c+',')
                                                &&!(cRightBeforeLabel.contains(rc.Drug_Therapy_Class_2__c+',') &&(rc.Specialty_Dollar_Amount__c==null && rc.Specialty_Retail_Dollar_Amt__c==null))){
                                                    StrPhaben=rc.Drug_Therapy_Class_2__c+'\n';
                                                }
                                                else{
                                                 StrPhaben=rc.Drug_Therapy_Class_2__c+'\n';
                                                }
                                            }
                                           Pharbenlabel.add(StrPhaben);  
                                    }
                                 }
                               
                        }
                         if((rc.LOB2__c == rg.LOB2__c)  && rc.Year__c!= 'All')
                         {
                          if(rc.FAF_Print_Specialty__c != null)
                          Pharbenvalue.add(stdt.formatGMT('MM/dd/yyyy') + ' - ' + eddt.formatGMT('MM/dd/yyyy') + ': '  + rc.FAF_Print_Specialty__c + ' Per claim' + '\n');   
                          else
                          Pharbenvalue.add(stdt.formatGMT('MM/dd/yyyy') + ' - ' + eddt.formatGMT('MM/dd/yyyy') + ': '  + ' Per claim' + '\n');        
                         }
                      */
                       /*  if((rc.LOB2__c == rg.LOB2__c)  && rc.Year__c!= 'All')
                         {
                          Pharbenvalue.add(stdt.formatGMT('MM/dd/yyyy') + ' - ' + eddt.formatGMT('MM/dd/yyyy') + ': ' + rc.Specialty_Dollar_Amount__c + ' Per claim' + '\n');        
                         } */
                        //commented by sonal sharma
    /*
                         if((rc.LOB2__c == rg.LOB2__c)  && rc.Year__c== 'All')
                         {
                          if(rc.FAF_Print_Specialty__c != null)
                          Pharbenvalue.add( rc.FAF_Print_Specialty__c + ' Per claim' + '\n'); 
                          else
                          Pharbenvalue.add(' Per claim' + '\n');       
                         }
                         if((rc.LOB2__c == rg.LOB2__c)  && rc.Year__c== 'All')
                         {
                          Pharbenvalue.add(rc.Specialty_Dollar_Amount__c + ' Per claim' + '\n');        
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
      if(RcurveExist == true)            
                  { 
                  
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
                                                                                                            
     if(ShowNonSpecGrid != true)
                   { 
                       rg.Show_in_Non_Specialty_Grid__c = false;
                   }  
     if(ShowSpecGrid != true)
                   { 
                       rg.Show_in_Specialty_Grid__c = false;
                   }   
     Rgeeupdate.add(rg);

}
if (Rgeeupdate != null && !Rgeeupdate.isEmpty())
{
   Database.Update(Rgeeupdate);
}
}

catch(DmlException e)
    {
     System.debug(e.getMessage());
    } 
    
}*/





/*=================================================================================
 * @Method Name       : UpdateSpecialtyGrid
 * @author            : Mohit Srivastava(Accenture)
 * @created date      : 07/12/2019
 * @Last modified by  : Mohit Srivastava(Accenture)
 * @Purpose           : PUpdateSpecialtyGrid
=======================================================================================*/
/*@future
global static void UpdateSpecialtyGrid(List<id> objId)
{
//commented by sonal sharma
    


        DeepCloneUtility.OFF_TRIGGERS_PROCBUILDER=false;
        Set<id> ids=new set<id>();
        Set<id> FAFids=new set<id>();
        Map<id,Specialty_Pricing__c> MapYearComb = new Map<id,Specialty_Pricing__c>();
        Set<String> yearstr=new Set<String>();
        List<Specialty_Pricing__c> updatePricing=new List<Specialty_Pricing__c>();
        
       
        PCD_FAF_Status__mdt FAFStatus = [SELECT Value__c FROM PCD_FAF_Status__mdt LIMIT 1]; 
        List<string> FAFStat = new List<string>();
        for(string s: FAFStatus.Value__c.split(',')){
            FAFStat.add(s);
        }                                                                                             
        List<Specialty_Pricing__c> Scope =[SELECT ID,FAF_ID__c,Specialty_Operations__c,Pharmacy_Benefit__c,
                                           Invokable_Update__c,Custom_Specialty_Grid__c
                                           FROM Specialty_Pricing__c where FAF_ID__r.FAF_Status__c IN:FAFStat and FAF_ID__c IN:objId];
                                           
        Map<String,Specialty_Pricing__c> uniqueBenefit = new map<String,Specialty_Pricing__c>();
        for(Specialty_Pricing__c record: Scope) {
            if(!uniqueBenefit.containsKey(record.Pharmacy_Benefit__c)) {
                uniqueBenefit.put(record.Pharmacy_Benefit__c,record);
                if(record.Pharmacy_Benefit__c != Label.Pharmacy_Benefit_Exclude)
                {
                  record.Custom_Specialty_Grid__c=true;
                }
            }
            else{
             record.Custom_Specialty_Grid__c=false;
            }
            if(record.Invokable_Update__c==false){
                record.Invokable_Update__c=true;
            }
            else{
                 record.Invokable_Update__c=false;
            }
            record.Invokable_Update__c=true;
            updatePricing.add(record);
        }
        if(!updatePricing.isEmpty()){
        update updatePricing;
        }
        
   }*/

/*=================================================================================
 * @Method Name       : UpdateAdditionalProgramGrid
 * @author            : Soumendu Chowdhury
 * @created date      : 07/18/2019
 * @Purpose           : Populate Start and End Date , Show in Grid Flag and Data structure for Customer Facing Grid in Apttus Template
=======================================================================================*/

 /*@future
global static void UpdateAdditionalProgramGrid(List<id> objId)
{
//commented by sonal sharma
   
try
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
        Map<id,Clinical_Solutions__c> MapYearComb = new Map<id,Clinical_Solutions__c>();
        Set<String> yearstr=new Set<String>();
        

        PCD_FAF_Status__mdt FAFStatus = [SELECT Value__c FROM PCD_FAF_Status__mdt LIMIT 1]; 
        List<string> FAFStat = new List<string>();
        for(string s: FAFStatus.Value__c.split(','))
              {
                 FAFStat.add(s);
              }                                                                                             

        List<Clinical_Solutions__c> Scope =[SELECT ID,Clinical_Operations__c,Show_in_Grid__c,FAF_ID__c ,
                                        Year_Start_Date__c,Year_End_Date__c,Clinical_Solution__c,Clinical_Solution_Type__c,Fee_Basis__c,Fee_Amount__c,Year__c 
                                        FROM Clinical_Solutions__c where FAF_ID__r.FAF_Status__c IN:FAFStat and Clinical_Operations__c IN:objId];
        
            for(Clinical_Solutions__c  clinicalObj : scope){
               ids.add(clinicalObj.id);
               FAFids.add(clinicalObj.FAF_ID__c);
               yearstr.add(clinicalObj.Year__c);
               if(clinicalObj.Year__c=='All'){
               MapYearComb.put(clinicalObj.Id,clinicalObj);
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
                clinicalObj.add(clinObj);
             }
        if(!clinicalObj.isEmpty())
          {
            update clinicalObj;
          }
 

    Invoke_Template_AdditionalProgramGrid.Template_AdditionalProgramGrid(objId);
 }

catch(Exception Ex)
  {
    system.debug('Exception....'+ex.getMessage());
  }
  
 }*/



}