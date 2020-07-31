public without sharing class RebateOperationsTriggerHelper {

 //Logic to Replace Flows due to SOQL Limit and add logic in Trigger. Logic to update Retail90 , Specialty and Mchoice for Mirror update
   public static void updateRebateGuaranteesRetail90(Map<Id,Rebate_Operations__c> OldMap, Map<Id,Rebate_Operations__c> NewMap) {   
      /*  try {
            List<Rebate_Guarantees__c> updateRetail90 = new List<Rebate_Guarantees__c>();
            List<Rebate_Guarantees__c> updateSpecialty = new List<Rebate_Guarantees__c>();
            List<Rebate_Guarantees__c> updateMchoice = new List<Rebate_Guarantees__c>();    
               
        for(Rebate_Operations__c rg:NewMap.values())
         {
          if ((Oldmap.get(rg.Id).Retail_90_Mirror_Retail_30__c != Newmap.get(rg.Id).Retail_90_Mirror_Retail_30__c) || (Oldmap.get(rg.Id).Percentage_Guarantee__c != Newmap.get(rg.Id).Percentage_Guarantee__c))
           {
           List<Rebate_Guarantees__c> retail90List = [Select Retail_90__c,Rebate_Operations__r.Retail_90_Mirror_Retail_30__c,Retail_30__c,Retail_90_1__c,Retail_30_1__c,Rebate_Operations__c,Rebate_Operations__r.Percentage_Guarantee__c  from Rebate_Guarantees__c where Rebate_Operations__c = :Newmap.get(rg.Id).Id];
            for(Rebate_Guarantees__c rbg : retail90List){
            if(rbg.Rebate_Operations__r.Retail_90_Mirror_Retail_30__c == true  && rbg.Rebate_Operations__r.Percentage_Guarantee__c == true){
                rbg.Retail_90_1__c = rbg.Retail_30_1__c;
            }
            if(rbg.Rebate_Operations__r.Retail_90_Mirror_Retail_30__c == true  && rbg.Rebate_Operations__r.Percentage_Guarantee__c == false){
                rbg.Retail_90__c = rbg.Retail_30__c;
            }                               
            updateRetail90.add(rbg);
                                                         }
           }
           if ((Oldmap.get(rg.Id).Specialty_Retail_Mirror_Retail_30__c != Newmap.get(rg.Id).Specialty_Retail_Mirror_Retail_30__c) || (Oldmap.get(rg.Id).Percentage_Guarantee__c != Newmap.get(rg.Id).Percentage_Guarantee__c))
           {
           List<Rebate_Guarantees__c> specialtyList = [Select Specialty_Retail__c,Rebate_Operations__r.Specialty_Retail_Mirror_Retail_30__c,Retail_30__c,Specialty_Retail_1__c,Retail_30_1__c,Specialty__c,Specialty_1__c,Rebate_Operations__c,Rebate_Operations__r.Percentage_Guarantee__c  from Rebate_Guarantees__c where Rebate_Operations__c = :Newmap.get(rg.Id).Id];
           
            for(Rebate_Guarantees__c rbg : specialtyList){
            if(rbg.Rebate_Operations__r.Specialty_Retail_Mirror_Retail_30__c == true && rbg.Rebate_Operations__r.Percentage_Guarantee__c == true){
                rbg.Specialty_Retail_1__c = rbg.Retail_30_1__c;
            }
            if(rbg.Rebate_Operations__r.Specialty_Retail_Mirror_Retail_30__c == true && rbg.Rebate_Operations__r.Percentage_Guarantee__c == false){
                rbg.Specialty_Retail__c = rbg.Retail_30__c; 
            }  
                          
            updateSpecialty.add(rbg);
        }
           
           
           }
            if ((Oldmap.get(rg.Id).Mchoice_Mirror_Mail__c != Newmap.get(rg.Id).Mchoice_Mirror_Mail__c) || (Oldmap.get(rg.Id).Percentage_Guarantee__c != Newmap.get(rg.Id).Percentage_Guarantee__c))
           {
           List<Rebate_Guarantees__c> mchoiceList = [Select Mchoice__c,Rebate_Operations__r.Mchoice_Mirror_Mail__c,Mail__c,Mchoice_1__c,Mail_1__c,Rebate_Operations__c,Rebate_Operations__r.Percentage_Guarantee__c  from Rebate_Guarantees__c where Rebate_Operations__c = :Newmap.get(rg.Id).Id];
           for(Rebate_Guarantees__c rbg : mchoiceList){
            if( rbg.Rebate_Operations__r.Mchoice_Mirror_Mail__c == true && rbg.Rebate_Operations__r.Percentage_Guarantee__c == true){
                rbg.Mchoice_1__c = rbg.Mail_1__c;
            }
            if( rbg.Rebate_Operations__r.Mchoice_Mirror_Mail__c == true && rbg.Rebate_Operations__r.Percentage_Guarantee__c == false){
                rbg.Mchoice__c = rbg.Mail__c; 
            }  
                        
            updateMchoice.add(rbg);
        } 
           }
      
        }  
        
                if (updateRetail90 != null && !updateRetail90.isEmpty())
        {
          update updateRetail90;
        }  
        if (updateSpecialty != null && !updateSpecialty.isEmpty())
        {
          update updateSpecialty;
        }
        if (updateMchoice != null && !updateMchoice.isEmpty())
        {
          update updateMchoice;
        }  
        
          }catch(exception e){
          for( String so : NewMap.keySet()){
                NewMap.get(so).adderror(e.getDmlMessage(0));
            } } */
        
        }

    public static void updateFAFOnInsert(List<Rebate_Operations__c> rebateOpsList) {
        try{
        List<Central_Hub__c> fafToUpdate = new List<Central_Hub__c>();
        
        List<Id> fafIds = new List<Id>();
        
        for(Rebate_Operations__c rebateOps: rebateOpsList)
        {  
          if(rebateOps.FAF_ID__c!= null && rebateOps.FAF_ID__r.Copy_Pending__c == false){
              fafIds.add(rebateOps.FAF_ID__c); 
            }           
        }
        
        Map<id,id> invalidFaf = UtilClass.validateLinkFAF(fafIds);
        
       for(Rebate_Operations__c rebateOps: rebateOpsList)
        {   
 /*           if(rebateOps.FAF_ID__c!= null){
                 if(invalidFaf.containskey(rebateOps.FAF_ID__c)){
                  rebateOps.adderror('The current Partial FAF needs to be linked to an existing Full FAF');
                  }else{
                        Central_Hub__c faf = new Central_Hub__c();
                        faf.id = rebateOps.FAF_ID__c;
                        faf.Rebate_Operations__c = true;
                        fafToUpdate.add(faf);
                       } 
            } */ 
             
            Central_Hub__c faf = new Central_Hub__c();
            faf.id = rebateOps.FAF_ID__c;
            faf.Rebate_Operations__c = true;
            fafToUpdate.add(faf);        
        }       

          if(fafToUpdate.size()>0){
          update fafToUpdate;
          }
          }catch(exception e){rebateOpsList[0].addError(e.getDmlMessage(0));
          
           }
   }
   
   public static void updateFAFOnDelete(List<Rebate_Operations__c> rebateOpsList) {
        try{
        List<Central_Hub__c> fafToUpdate = new List<Central_Hub__c>();

        for(Rebate_Operations__c rebateOps: rebateOpsList)
        {   
            if(rebateOps.FAF_ID__c!= null){
            Central_Hub__c faf = new Central_Hub__c();
            faf.id = rebateOps.FAF_ID__c;
            faf.Rebate_Operations__c = False;
            fafToUpdate.add(faf);
            }           
        }       

          if(fafToUpdate.size()>0){
          update fafToUpdate;
          }
          }catch(exception e){rebateOpsList[0].addError(e.getDmlMessage(0)); }
   }
   
   public static void checkCountOnBeforeInsert(List<Rebate_Operations__c> rebateOpsList) {
        try{
        set<id> fafIds = new set<Id>();
        Map<id,integer> fafnetworkMap =new Map<id,integer>();
        
        for(Rebate_Operations__c rebate: rebateOpsList)
        {   
            fafIds.add(rebate.FAF_ID__c);          
        }       
        
        for(AggregateResult a: [SELECT Count(Id) Total,FAF_ID__c FROM Rebate_Operations__c WHERE FAF_ID__c in: fafIds 
         and FAF_ID__r.Data_Loading__c= false GROUP BY FAF_ID__c]){
            Integer Count =  (Integer)a.get('Total');
            fafnetworkMap.put(string.valueOf(a.get('FAF_ID__c')), Count );
        }
        
        for(Rebate_Operations__c rebate: rebateOpsList)
        { 
            if(fafnetworkMap.get(rebate.FAF_ID__c) >0){
             rebate.adderror('Cannot add more than One Rebate Operations to FAF');
            }        
        }
        }catch(exception e){rebateOpsList[0].addError(e.getDmlMessage(0)); 
        
        }
   }
      
   //--------------method added by Priyanka for mirroring functionality------
   //-----------Rebate Guarantee Mirroring Options(US38220)-- Method updated by Srini ----
   
   public static void RebateGuaranteeMirroringOptions(List<Rebate_Operations__c> roNewList,List<Rebate_Operations__c> roOldList, Map<Id, Rebate_Operations__c> rebOpsOldMap){
        try{
       
        List<Rebate_Gtees_Specialty_Class_Carve_Outs__c> RebateGtessSpecialtyList = new List<Rebate_Gtees_Specialty_Class_Carve_Outs__c>();
        set<id> RebateGtessSpecialtyIds=new set<id>();
        
        List<Rebate_Guarantees__c> RebateGuaraList= new List<Rebate_Guarantees__c>();
        set<id> PGupdates=new set<id>();
        set<id> GSTOptionupdates=new set<id>();
        set<id> RGupdates=new set<id>();
        
        for(Rebate_Operations__c r : roNewList){
            
            //get eligible RGSids
            if(rebOpsOldMap.get(r.id).Class_Carve_Out_Guarantee_Percentage__c != r.Class_Carve_Out_Guarantee_Percentage__c){
                RebateGtessSpecialtyIds.add(r.id);
            }
            
            //identify all scenarios that require updates to RG records based on mirror flag changes on Rebate operations
            if(rebOpsOldMap.get(r.id).Percentage_Guarantee__c != r.Percentage_Guarantee__c){
                RGupdates.add(r.id);
                PGupdates.add(r.id);
            } 
            if(r.Rebate_Offering_Type__c != ConstantsUtil.SPLIT_TYPE && r.GSTP_Option__c == ConstantsUtil.NULLVALUE && rebOpsOldMap.get(r.id).GSTP_Option__c!=ConstantsUtil.NULLVALUE){
                RGupdates.add(r.id);
                GSTOptionupdates.add(r.id);
            }
            if( (r.Retail_90_Mirror_Retail_30__c == true && r.Retail_90_Mirror_Retail_30__c != rebOpsOldMap.get(r.id).Retail_90_Mirror_Retail_30__c)  || 
                (r.Specialty_Retail_Mirror_Retail_30__c != rebOpsOldMap.get(r.id).Specialty_Retail_Mirror_Retail_30__c )  ||
                (r.MChoice_Mirror_Mail__c ==true && r.MChoice_Mirror_Mail__c != rebOpsOldMap.get(r.id).MChoice_Mirror_Mail__c )  ){
                       RGupdates.add(r.id);
            }
            
        }
        
        //update RebateGtessSpecialtyList 
        if(RebateGtessSpecialtyIds.size()>0){
            for(Rebate_Gtees_Specialty_Class_Carve_Outs__c r:[select id, Specialty_Dollar_Amount__c, Specialty_Percentage_Amount__c,
                                                              Specialty_Retail_Dollar_Amt__c, Specialty_Retail_Percentage_Amount__c from Rebate_Gtees_Specialty_Class_Carve_Outs__c where Rebate_Operations__c in:RebateGtessSpecialtyIds]){
                    r.Specialty_Dollar_Amount__c = null;
                    r.Specialty_Percentage_Amount__c = null;
                    r.Specialty_Retail_Dollar_Amt__c = null;
                    r.Specialty_Retail_Percentage_Amount__c = null;
                    r.Required_Validation_Bool__c = true;
                    RebateGtessSpecialtyList.add(r);
            }
            if(RebateGtessSpecialtyList.size()>0){
                update RebateGtessSpecialtyList;
            }
        }
        
        //update Rebate Gurantee records
        if(RGupdates.size()>0){
            Map<id,Rebate_Operations__c> RebateOperationsMap=new Map<id,Rebate_Operations__c>([select id,(select id,Client_Owned_30__c, Client_Owned_30_1__c,Client_Owned_90__c, Client_Owned_90_1__c,
                                                                                                          Mail__c,Mail_1__c,Mchoice__c,Mchoice_1__c,Retail_30__c,Retail_30_1__c,
                                                                                                          Retail_90__c,Retail_90_1__c,Specialty__c,Specialty_1__c,Specialty_Retail__c,Specialty_Retail_1__c,
                                                                                                          GSTP__c from Rebate_Guarantees__r ) from Rebate_Operations__c where id In:RGupdates  ]);
             for(Rebate_Operations__c r : roNewList){
                 
                 if(!RebateOperationsMap.get(r.id).Rebate_Guarantees__r.isEmpty()){
                     for(Rebate_Guarantees__c rg:RebateOperationsMap.get(r.id).Rebate_Guarantees__r){
                         //reset mirror values if percentage Gurantee is changed
                         if(PGupdates.contains(r.id)){
                                rg.Client_Owned_30__c = null;
                                rg.Client_Owned_30_1__c = null;
                                rg.Client_Owned_90__c = null;
                                rg.Client_Owned_90_1__c = null;
                                rg.Mail__c = null;
                                rg.Mail_1__c = null;
                                rg.Mchoice__c = null;
                                rg.Mchoice_1__c = null;
                                rg.Retail_30__c = null;
                                rg.Retail_30_1__c = null;
                                rg.Retail_90__c = null;
                                rg.Retail_90_1__c = null;
                                rg.Specialty__c = null;
                                rg.Specialty_1__c = null;
                                rg.Specialty_Retail__c = null;
                                rg.Specialty_Retail_1__c = null;
                                
                         }
                         //update GSTP flag
                         if(GSTOptionupdates.contains(r.id)){
                             rg.GSTP__c = ConstantsUtil.NULLVALUE;
                         }
                         //update retail value
                         if(r.Retail_90_Mirror_Retail_30__c == true && r.Retail_90_Mirror_Retail_30__c != rebOpsOldMap.get(r.id).Retail_90_Mirror_Retail_30__c ){
                             if(r.Percentage_Guarantee__c == true){
                                    rg.Retail_90_1__c = rg.Retail_30_1__c;
                             }else{
                                    rg.Retail_90__c = rg.Retail_30__c;
                             } 
                         }
                         //update specality retail value
                         if(r.Specialty_Retail_Mirror_Retail_30__c != rebOpsOldMap.get(r.id).Specialty_Retail_Mirror_Retail_30__c){
                             if(r.Specialty_Retail_Mirror_Retail_30__c == true){
                                 system.debug('+++executing if++');
                                 if(r.Percentage_Guarantee__c == true){
                                        rg.Specialty_Retail_1__c = rg.Retail_30_1__c;
                                 }else{
                                        rg.Specialty_Retail__c = rg.Retail_30__c;
                                 }
                             }
                             else{
                                 if(r.Percentage_Guarantee__c == true){
                                     rg.Specialty_Retail_1__c = rg.Specialty_1__c;
                                  }
                                  else{
                                      rg.Specialty_Retail__c = rg.Specialty__c;
                                  }
                             }
                             
                         }
                         //update mchoice value
                         if(r.MChoice_Mirror_Mail__c == true && r.MChoice_Mirror_Mail__c != rebOpsOldMap.get(r.id).MChoice_Mirror_Mail__c){
                             if(r.Percentage_Guarantee__c == true){
                                    rg.Mchoice_1__c = rg.Mail_1__c;
                             }else{
                                    rg.Mchoice__c = rg.Mail__c;
                             } 
                         }
                         
                         RebateGuaraList.add(rg);
                     }
                 }
                 
             }
             if(!RebateGuaraList.isempty()) {
                 update RebateGuaraList;
             }                                                                                            
         }

        }catch(exception e){
        roNewList[0].addError(e.getDmlMessage(0)); }
   }
   // Iteration 6 requirement for child Guarantee records to be deleted when Rebate Offering Type is Split Only
    public static void deleteChildGuaranteerecords(List<Rebate_Operations__c> rebateOpsList) {
        try{
        List<Rebate_Guarantees__c> childRecList = new List<Rebate_Guarantees__c>();
        List<Id> rebateOpIds = new List<Id>();
      if(rebateOpsList.size() > 0){
        for(Rebate_Operations__c rebateOps: rebateOpsList)
        {   

            if(rebateOps.Rebate_Offering_Type__c == ConstantsUtil.SPLIT_TYPE && !string.isBlank(rebateOps.Rebate_Offering_Type__c) &&
   // Add Specialty Rebate offering type options to save RG - PT US260B by Sneha inturi.
       rebateOps.Specialty_Rebate_Offering_Type__c!= ConstantsUtil.GUARANTEE_ONLY &&
       rebateOps.Specialty_Rebate_Offering_Type__c!= ConstantsUtil.SPLIT_WITH_MIN_GUARANTEE &&
       rebateOps.Specialty_Rebate_Offering_Type__c!= ConstantsUtil.MIN_GUARANTEE_WITH_SPLIT_OF_OVER_PER){
            rebateOpIds.add(rebateOps.id);
            }           
        }
        }
      if(rebateOpIds.size() > 0){ 
        childRecList = [Select Id from Rebate_Guarantees__c where FAF_Status__c <> 'Uploaded' AND Rebate_Operations__c In :rebateOpIds];
        }
        if(childRecList.size()>0){
            system.debug('==childRecList=='+childRecList.size());        
            delete childRecList;
        }
        }catch(exception e){
        rebateOpsList[0].addError(e.getDmlMessage(0)); 
        
        }
     }
     
   //Logic to update DifferentGSTPFormularyEffectiveDates__c flag to false based on field value change in Rebate Operation on GSTP , Specialty Formulary and Non Specialty 
    //Formulary Options

 public static void updateplatformspec(map<id,Rebate_Operations__c> rebateNewmap,map<id,Rebate_Operations__c> rebateOldmap) 
 {
     try{
                  List<Platform_Specifics__c> psupdateList = new List<Platform_Specifics__c>();
                  set<id> changedRebateIds=new set<id>();
                  for(Rebate_Operations__c r: rebateNewmap.values()){
                         Rebate_Operations__c oldRP=rebateOldmap.get(r.id);
                      if( (r.GSTP_Option__c != oldRP.GSTP_Option__c) || 
                          (r.Specialty_Formulary_Option__c != oldRP.Specialty_Formulary_Option__c ) ||
                          (r.Non_Specialty_Formulary_Option__c != oldRP.Non_Specialty_Formulary_Option__c ) 
                        ){
                          changedRebateIds.add(r.id);
                         }
                  }
                  
                  if(changedRebateIds.size()>0){
                      for(Platform_Specifics__c  p: [Select id,Rebate_Operations__c,EffectiveDate__c,DifferentGSTPFormularyEffectiveDates__c,GSTPEffectiveDate__c,GSTPEndDate__c,
                                                     NonSpecialtyFormularyEffectiveDate__c,NonSpecialtyFormularyRebateEndDate__c,SpecialtyFormularyEffectiveDate__c,
                                                     SpecialtyFormularyEndDate__c ,GSTP_Choice__c,Non_Specialty_Formulary_Choice__c,Specialty_Formulary_Choice__c
                                                     from Platform_Specifics__c where Rebate_Operations__c IN :changedRebateIds ]){
                        
                                                         p.GSTP_Choice__c=rebateNewmap.get(p.Rebate_Operations__c).GSTP_Option__c;
                                                         p.Specialty_Formulary_Choice__c=rebateNewmap.get(p.Rebate_Operations__c).Specialty_Formulary_Option__c;
                                                         p.Non_Specialty_Formulary_Choice__c=rebateNewmap.get(p.Rebate_Operations__c).Non_Specialty_Formulary_Option__c;
                                                         
                                                         if(rebateNewmap.get(p.Rebate_Operations__c).GSTP_Option__c != 'Choice' && p.GSTPEffectiveDate__c!=null){
                                                            p.GSTPEffectiveDate__c=null;
                                                            p.GSTPEndDate__c=null;
                                                         }
                                                         if(rebateNewmap.get(p.Rebate_Operations__c).GSTP_Option__c == 'Choice' && p.GSTPEffectiveDate__c==null && p.DifferentGSTPFormularyEffectiveDates__c){
                                                            
                                                            p.GSTPEffectiveDate__c=p.EffectiveDate__c;
                                                         }
                                                         if(rebateNewmap.get(p.Rebate_Operations__c).Specialty_Formulary_Option__c != 'Client Choice' && p.SpecialtyFormularyEffectiveDate__c!=null){
                                                            p.Specialty_Formulary_Choice__c=null;
                                                            p.SpecialtyFormularyEndDate__c=null;
                                                         }
                                                         if(rebateNewmap.get(p.Rebate_Operations__c).Specialty_Formulary_Option__c == 'Client Choice' && p.SpecialtyFormularyEffectiveDate__c==null && p.DifferentGSTPFormularyEffectiveDates__c){
                                                            p.SpecialtyFormularyEffectiveDate__c=p.EffectiveDate__c;
                                                         }
                                                         if(rebateNewmap.get(p.Rebate_Operations__c).Non_Specialty_Formulary_Option__c != 'Client Choice' && p.NonSpecialtyFormularyEffectiveDate__c!=null){
                                                            p.NonSpecialtyFormularyEffectiveDate__c=null;
                                                            p.NonSpecialtyFormularyEndDate__c=null;
                                                         }
                                                         if(rebateNewmap.get(p.Rebate_Operations__c).Non_Specialty_Formulary_Option__c == 'Client Choice' && p.NonSpecialtyFormularyEffectiveDate__c==null && p.DifferentGSTPFormularyEffectiveDates__c){
                                                            p.NonSpecialtyFormularyEffectiveDate__c=p.EffectiveDate__c;
                                                         }
                                                         if(rebateNewmap.get(p.Rebate_Operations__c).GSTP_Option__c != 'Choice' && rebateNewmap.get(p.Rebate_Operations__c).Specialty_Formulary_Option__c != 'Client Choice' &&  
                                                            rebateNewmap.get(p.Rebate_Operations__c).Non_Specialty_Formulary_Option__c != 'Client Choice' && p.DifferentGSTPFormularyEffectiveDates__c  ){
                                                            p.DifferentGSTPFormularyEffectiveDates__c =false;
                                                        }
                                           psupdateList.add(p);
                                       
                      }
                  }
                 
     if(!psupdateList.isEmpty())                               
            update psupdateList;
                  
  }catch(exception e)
  {
    String ErrorCaught=e.getDmlMessage(0);
    if(ErrorCaught.contains('amp;')){
         string newError=ErrorCaught.replace('amp;','');    
         rebateNewmap.values().get(0).addError(newError); 
    }
    else{
    rebateNewmap.values().get(0).addError(e.getDmlMessage(0)); 
   
    }
  }
 }
 //Logic to update guarantee info GNC value to be in sync with Rebate Operation GNC value - Sindhu A
 public static void populateGNC(List<Rebate_Operations__c> rebList) {
       try{
        set<id> fafIds = new set<Id>();
        Map<id,String> GNCMap = new Map<id,String>();
        for(Rebate_Operations__c reb: rebList)
        {
           if(reb.FAF_ID__r.Copy_Pending__c == false){   
            fafIds.add(reb.FAF_ID__c);
            GNCMap.put(reb.FAF_ID__c,reb.Guaranteed_Net_Cost_Gnc_Guarantee__c);
            }          
        }   
        
        List<Guarantees_Information__c > infoList = [Select id,FAF_ID__c,Guaranteed_Net_Cost_Gnc_Guarantee__c from Guarantees_Information__c where FAF_ID__c in: fafIds];
        
        for(Guarantees_Information__c info: infoList){  
        if(info.Guaranteed_Net_Cost_Gnc_Guarantee__c != GNCMap.get(info.FAF_ID__c)){                 
            info.Guaranteed_Net_Cost_Gnc_Guarantee__c = GNCMap.get(info.FAF_ID__c);             
            info.Gnc_Claim_Exclusions__c = null;
            info.Custom_Requirements_or_Restrictions__c = null;
            info.Gnc_Guarantee_Risk_Sharing__c = null;
            info.CVSH_Share_Percent__c = null;
            info.Gnc_Guarantee_Frequency__c = null;
            info.Gnc_Guarantee_Basis__c= null;
            info.Gnc_Corridor_Lower_Amount__c = null;
            info.Gnc_Corridor_Lower__c = null;
            info.Gnc_Corridor_Upper_Amount__c = null;
            info.Gnc_Corridor_Upper__c = null;
            info.Gnc_Guarantee_Corridor_Threshold__c = null;
            info.Gnc_Guarantee_Share_Type__c = null;
            info.Gnc_Payout_Cap__c = null;
            info.Gnc_Payout_Cap_Amount__c = null;
            info.Gnc_Recon_Level__c = null;
            info.Gnc_Retain_Rebates_After_Reconciliation__c = null;        
            info.Gnc_Recon_Timeframe__c = null;
            info.Client_Share_Percent__c = null;
            }
        }  
        if(!infolist.isEmpty()){
            system.debug(infolist+'Sindhu');
            update infoList;
        }  
        }catch(exception e){ApexPages.addMessages(e);}   
 }
 //Logic to delete Rebate guarantee records when GNC value in Rebate operation changes from No To Yes  -Sindhu A
 public static void deleteRebgChildRecords(Map<Id, Rebate_Operations__c > oldMap, Map<Id, Rebate_Operations__c > newMap) {
      try{
        Set<Id> rebIdSet = new Set<Id>();

        for(Id id: newMap.keySet()){    
            if(oldMap.get(Id).Guaranteed_Net_Cost_Gnc_Guarantee__c == 'No' && newMap.get(Id).Guaranteed_Net_Cost_Gnc_Guarantee__c == 'Yes') {
                rebIdSet.add(id);
            }          
        }   
        
        List<Rebate_Guarantees__c> rebgList = [SELECT Id FROM Rebate_Guarantees__c WHERE Rebate_Operations__c IN:rebIdSet];
        if(!rebgList.isEmpty()) {
            delete rebgList;
        } 
        }catch(exception e){ApexPages.addMessages(e);}            
  } 
}