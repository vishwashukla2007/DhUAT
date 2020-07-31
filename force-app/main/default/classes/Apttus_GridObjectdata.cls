global class Apttus_GridObjectdata {
    @AuraEnabled
    global static Apttus__APTS_Agreement__c get_AgreementObj(String RecId) {
        Apttus__APTS_Agreement__c retObj = [Select Id,Primary_Agreement_Line_Item__r.Additional_Program_Display__c  From Apttus__APTS_Agreement__c Where Id = :RecId];
        return retObj;        
    }
    @AuraEnabled
    global static void update_AgreementObj(String RecId , Boolean isDisplayAdProg) {
        Apttus__APTS_Agreement__c retObj = [Select Id,Primary_Agreement_Line_Item__c  From Apttus__APTS_Agreement__c Where Id = :RecId];
        if(retObj != null){
            Apttus__AgreementLineItem__c aliObj = [Select Id, Additional_Program_Display__c From Apttus__AgreementLineItem__c Where Id = :retObj.Primary_Agreement_Line_Item__c]; 
            aliObj.Additional_Program_Display__c = isDisplayAdProg;
            update aliObj;
        }
    }
    @AuraEnabled
    global static Boolean checkValid(String recId, String aliId, String currSeqNum, String newSeqNum, Boolean isUpDown) {
        Boolean isValid = true;
        Map<Integer, Network_Pricing__c> npSeqMap = new Map<Integer, Network_Pricing__c>();
        list<Network_Pricing__c> npUpdateList = new list<Network_Pricing__c>();
        return isValid;
    }
    @AuraEnabled
    global static void updateNPSeq(String recId, String aliId, String currSeqNum, String newSeqNum, Boolean isUpDown) {
        Apttus_GridObjectdataSequence.updateNPSeq( recId,  aliId,  currSeqNum,  newSeqNum,  isUpDown);
    }
    @AuraEnabled
    global static void updateMPSeq(String recId, String aliId, String currSeqNum, String newSeqNum, Boolean isUpDown) {
        Apttus_GridObjectdataSequence.updateMPSeq( recId,  aliId,  currSeqNum,  newSeqNum,  isUpDown);
    }
    @AuraEnabled
    global static void updateRGSeq(String recId, String aliId, String newSeqNum) {
        Apttus_GridObjectdataSequence.updateRGSeq( recId,  aliId, newSeqNum);
    }
    @AuraEnabled
    global static void updateSpecSeq(String recId, String aliId, String newSeqNum) {
        Apttus_GridObjectdataSequence.updateSpecSeq( recId,  aliId, newSeqNum);
    }
    @AuraEnabled
    global static list<Network_Pricing__c> get_GridObjectdata(String RecId, String ObjectName) {
        list<Network_Pricing__c> nprtn = new list<Network_Pricing__c>();
        list<Network_Pricing__c> np = [
            SELECT id,
            Year__c,                              
            Plan_Year__c,  
            SSG_Guarantee__c,
            OED_Count__c,
            Custom_Description__c,
            NED_Count__c,
            MER_Count__c,
            GER_Count__c,
            BER_Guarantee__c,                               
            Agreement__c,
            Year_Begin_Date__c,
            Year_End_Date__c,
            Brand_Basis__c,
            Non_MAC_Generic_Rate__c,                               
            FAF_ID__c,                               
            Custom_Network_Description__c,
            LOB__c,
            Network_Name_for_Grid__c,
            Template_BER_Display__c,
            Template_BER_Guarantee_Rate_Text__c,
            Template_Brand_Display__c,
            Template_Brand_Rate_Text__c,
            Template_Dispensing_Fee_Text__c,
            Template_Generic_BER_Guarantee_Rate_Text__c,
            Template_Generic_Dispensing_Fee__c,
            Template_Generic_Display__c,
            Template_Generic_OR_Mac_Text__c,
            Template_Generic_Rate_Text__c,
            Template_GER_Display__c,
            Template_GER_Guarantee_Rate_Text__c,
            Template_MCCP__c,
            Template_MER_Display__c,
            Template_MER_Guarantee_Rate_Text__c,
            Template_NED_Display__c,
            Template_NED_Guarantee_Rate_Text__c,
            Template_Network_Name_Text__c,
            Template_NonMacGeneric_Display__c,
            Template_Non_MAC_Generic_Rate_Text__c,
            Template_Non_Preferred_Brand_Rate_Text__c,
            Template_OED_Display__c,
            Template_OED_Guarantee_Rate_Text__c,
            Template_Preferred_Brand_Rate_Text__c,
            Template_Preferred_Display__c,
            SSG_Display__c,                               
            Template_SSG_Guarantee_Rate_Text__c,
            Network_Type__c,
            Retail_Network_Ordinal__c,
            Generic_Basis__c,
            Network_Name__c,
            FAF_Network_Ops__c,                               
            FAF_ID__r.LOB2__c  ,
            Sequence_Number__c , FAF_Network_Ops__r.Network_Pricing_Max_Seq__c, FAF_Network_Ops__r.Network_Pricing_Min_Seq__c
            from Network_Pricing__c where Agreement_Line_Item__c = :RecId and Network_Name__c <>'MC(84-90)CVS'  and Network_Name__c <> null
            and  (Show_in_Grid__c= true) order by  Retail_Network_Ordinal__c,Network_Name_for_Grid__c, Sequence_Number__c asc //Sequence_Number__c asc
        ];//or Specialty_Show_in_Grid__c= true
        
        for (Network_Pricing__c nprice : np) {
            nprtn.add(nprice);  
        }
        system.debug('nprtn--------1-------'+nprtn.size());
        list<Network_Pricing__c> npcp = [
            SELECT id,
            Year__c, 
            Custom_Description__c,                             
            Plan_Year__c,  
            SSG_Guarantee__c,
            OED_Count__c,
            NED_Count__c,
            MER_Count__c,
            GER_Count__c,
            BER_Guarantee__c,                               
            Agreement__c,
            Year_Begin_Date__c,
            Year_End_Date__c,
            Brand_Basis__c,
            Non_MAC_Generic_Rate__c,                               
            FAF_ID__c,                               
            Custom_Network_Description__c,
            LOB__c,
            Network_Name_for_Grid__c,
            Template_BER_Display__c,
            Template_BER_Guarantee_Rate_Text__c,
            Template_Brand_Display__c,
            Template_Brand_Rate_Text__c,
            Template_Dispensing_Fee_Text__c,
            Template_Generic_BER_Guarantee_Rate_Text__c,
            Template_Generic_Dispensing_Fee__c,
            Template_Generic_Display__c,
            Template_Generic_OR_Mac_Text__c,
            Template_Generic_Rate_Text__c,
            Template_GER_Display__c,
            Template_GER_Guarantee_Rate_Text__c,
            Template_MCCP__c,
            Template_MER_Display__c,
            Template_MER_Guarantee_Rate_Text__c,
            Template_NED_Display__c,
            Template_NED_Guarantee_Rate_Text__c,
            Template_Network_Name_Text__c,
            Template_NonMacGeneric_Display__c,
            Template_Non_MAC_Generic_Rate_Text__c,
            Template_Non_Preferred_Brand_Rate_Text__c,
            Template_OED_Display__c,
            Template_OED_Guarantee_Rate_Text__c,
            Template_Preferred_Brand_Rate_Text__c,
            Template_Preferred_Display__c,
            SSG_Display__c,                               
            Template_SSG_Guarantee_Rate_Text__c,
            Network_Type__c,
            Retail_Network_Ordinal__c,
            Generic_Basis__c,
            Network_Name__c,
            FAF_Network_Ops__c,                               
            FAF_ID__r.LOB2__c,
            Sequence_Number__c , FAF_Network_Ops__r.Network_Pricing_Max_Seq__c, FAF_Network_Ops__r.Network_Pricing_Min_Seq__c
            from Network_Pricing__c where Agreement_Line_Item__c = :RecId and Network_Name__c ='Specialty' and Network_Name__c <> null
            and  ((FAF_ID__r.LOB2__c !='EGWP') or ((FAF_ID__r.LOB2__c ='EGWP') and Network_Type__c ='Transparent'))                                 
            and  (Show_in_Grid__c= true ) order by Retail_Network_Ordinal__c,Network_Name_for_Grid__c, Sequence_Number__c asc
        ];
        
        for (Network_Pricing__c nprice : npcp) {
            nprtn.add(nprice);  
        } 
        system.debug('nprtn--------2-------'+nprtn.size());
        list<Network_Pricing__c> npspec = [
            SELECT id,
            Year__c, 
            Custom_Description__c,                             
            Plan_Year__c,  
            SSG_Guarantee__c,
            OED_Count__c,
            NED_Count__c,
            MER_Count__c,
            GER_Count__c,
            BER_Guarantee__c,                               
            Agreement__c,
            Year_Begin_Date__c,
            Year_End_Date__c,
            Brand_Basis__c,
            Non_MAC_Generic_Rate__c,                               
            FAF_ID__c,                               
            Custom_Network_Description__c,
            LOB__c,
            Network_Name_for_Grid__c,
            Template_BER_Display__c,
            Template_BER_Guarantee_Rate_Text__c,
            Template_Brand_Display__c,
            Template_Brand_Rate_Text__c,
            Template_Dispensing_Fee_Text__c,
            Template_Generic_BER_Guarantee_Rate_Text__c,
            Template_Generic_Dispensing_Fee__c,
            Template_Generic_Display__c,
            Template_Generic_OR_Mac_Text__c,
            Template_Generic_Rate_Text__c,
            Template_GER_Display__c,
            Template_GER_Guarantee_Rate_Text__c,
            Template_MCCP__c,
            Template_MER_Display__c,
            Template_MER_Guarantee_Rate_Text__c,
            Template_NED_Display__c,
            Template_NED_Guarantee_Rate_Text__c,
            Template_Network_Name_Text__c,
            Template_NonMacGeneric_Display__c,
            Template_Non_MAC_Generic_Rate_Text__c,
            Template_Non_Preferred_Brand_Rate_Text__c,
            Template_OED_Display__c,
            Template_OED_Guarantee_Rate_Text__c,
            Template_Preferred_Brand_Rate_Text__c,
            Template_Preferred_Display__c,
            SSG_Display__c,                               
            Template_SSG_Guarantee_Rate_Text__c,
            Network_Type__c,
            Retail_Network_Ordinal__c,
            Generic_Basis__c,
            Network_Name__c,
            FAF_Network_Ops__c,                               
            FAF_ID__r.LOB2__c,
            Sequence_Number__c , FAF_Network_Ops__r.Network_Pricing_Max_Seq__c, FAF_Network_Ops__r.Network_Pricing_Min_Seq__c
            from Network_Pricing__c where Agreement_Line_Item__c = :RecId 
            and  (Specialty_Show_in_Grid__c= true) order by Retail_Network_Ordinal__c, Sequence_Number__c asc
        ]; 
        
        for (Network_Pricing__c nprice : npspec) {
            nprtn.add(nprice);  
        } 
        system.debug('nprtn--------3-------'+nprtn.size());
        
        Map<Integer, List<Network_Pricing__c>> npSeqMap = new Map<Integer, List<Network_Pricing__c>>();
        list<Integer> seqList = new list<Integer>();
        set<Integer> seqSet = new set<Integer>();
        list<Network_Pricing__c> npReturnList = new list<Network_Pricing__c>();
        list<Network_Pricing__c> npNullList = new list<Network_Pricing__c>();
        for(Network_Pricing__c npo :nprtn){
            system.debug('npo ----------'+npo.Id + ' ------------------ '+npo.Sequence_Number__c);
            if(npo.Sequence_Number__c != null){
                if(npSeqMap.containsKey(Integer.valueOf(npo.Sequence_Number__c))){
                    npSeqMap.get(Integer.valueOf(npo.Sequence_Number__c)).add(npo);
                } else {
                    List<Network_Pricing__c> temp = new List<Network_Pricing__c>();
                    temp.add(npo);
                    npSeqMap.put(Integer.valueOf(npo.Sequence_Number__c) , temp);
                }
                seqList.add(Integer.valueOf(npo.Sequence_Number__c) );
            } else {
                npNullList.add(npo);
            }
        }
        system.debug('seqList---------------'+seqList);
        system.debug('npNullList.size()---------------'+npNullList.size());
        seqList.sort();
        seqSet.addAll(seqList);
        system.debug('npSeqMap---------------'+npSeqMap.keySet());
        for(Integer seq :seqSet){
            npReturnList.addAll(npSeqMap.get(seq));
        }
        if(npNullList != null && npNullList.size() > 0){
            npReturnList.addAll(npNullList);
        }
        return npReturnList;
    }
    @AuraEnabled
    global static String get_Opsid(Id RecId, String ObjectName) {
        List<Network_Operations__c> nops = [
            SELECT id,FAF_ID__c                           
            from Network_Operations__c where Agreement_Line_Item__c = :RecId LIMIT 1
        ];
        String pid;
        if (nops != null && !nops.isEmpty()) {
            pid= nops[0].id;
        }
        return pid;
    }
    
    @AuraEnabled
    global static list<Mail_Pricing__c> get_MailGridObjectdata(String RecId, String ObjectName) {
        list<Mail_Pricing__c> mp = [
            SELECT  id,
            Custom_Description__c,
            Agreement__c,
            Grid_Name__c,
            LOB__c,
            Template_BER_Display__c,
            Template_BER_Guarantee_Rate_Text__c,
            Template_Brand_Display__c,
            Template_Brand_Rate_Text__c,
            Template_Dispensing_Fee_Text__c,
            Template_Generic_Dispensing_Fee__c,
            Template_Generic_Display__c,
            Template_Generic_Rate_Text__c,
            Template_GER_Display__c,
            Template_GER_Guarantee_Rate_Text__c,
            Template_MER_Display__c,
            Template_MER_Guarantee_Rate_Text__c,
            Template_NED_Display__c,
            Template_NED_Guarantee_Rate_Text__c,
            Template_NonMacGeneric_Display__c,
            Template_Non_MAC_Generic_Rate_Text__c,
            Template_Non_Preferred_Brand_Rate_Text__c,
            Template_Preferred_Brand_Rate_Text__c,
            Template_Preferred_Display__c,
            SSG_Display__c,                               
            Template_SSG_Guarantee_Rate_Text__c,
            Generic_Basis__c,
            FAF_ID__r.LOB2__c,
            FAF_Mail_Operations__c,
            FAF_ID__c,
            Sequence_Number__c,
            FAF_Mail_Operations__r.Mail_Max_Sequence__c,
            FAF_Mail_Operations__r.Mail_Min_Sequence__c
            from Mail_Pricing__c where Agreement_Line_Item__c = :RecId
            and  Show_in_Grid__c= true
            order by Sequence_Number__c
        ];
        
        return mp;
    }
    
    @AuraEnabled
    global static list<Specialty_Pricing__c> get_SpecGridObjectdata(String RecId, String ObjectName) {
        list<Specialty_Pricing__c> sp = [
            SELECT  id,
            Agreement__c,
            Custom_Description__c,
            Pharmacy_Benefit_Text__c,
            Custom_Specialty_Grid__c,
            FAF_ID__r.LOB2__c  , 
            Specialty_Operations__c ,
            Specialty_Operations__r.Specialty_MAX_Sequence__c,
            Specialty_Operations__r.Specialty_MIN_Sequence__c,
            FAF_ID__c,
            Sequence_Number__c,
            Year__c,
            Plan_Year__c,
            Pharmacy_Benefit__c,
            Price_List__c,
            Specialty_Compare_Logic_On__c,
            Brand_Basis__c,  
            Brand_Rate__c, 
            Brand_Dispensing_Fee__c,                   
            Generic_Basis__c,
            Generic_Rate__c,
            Generic_Dispensing_Fee__c, 
            Limited_Distribution_Drug_LDD_Rate__c,
            New_to_Market_Brand_Rate__c
            from Specialty_Pricing__c where Agreement_Line_Item__c = :RecId
            and  Custom_Specialty_Grid__c= true and Pharmacy_Benefit__c != 'None' Order BY Sequence_Number__c
        ];
        
        return sp;
    }
    
    @AuraEnabled
    global static list<Specialty_Operations__c> get_SpecOpsGridObjectdata(String RecId, String ObjectName) {
        list<Specialty_Operations__c> sp = [
            SELECT  id,
            Agreement__c,
            Specialty_Legacy_Drug_Level_Pharmacy__c,
            Specialty_Legacy_Drug_Level_exist__c,
            FAF_ID__r.LOB2__c                               
            from Specialty_Operations__c where Agreement_Line_Item__c = :RecId
            and  Specialty_Legacy_Drug_Level_exist__c= true and FAF_ID__r.LOB2__c='EGWP'
        ];
        
        return sp;
    }
   
   
    //Updated by Parvathi 03/27
  @AuraEnabled
    global static List<Rebate_Guarantee_Denorm__c> get_RebGridObjectdata(String RecId, String ObjectName) {
      
        List<Rebate_Guarantee_Denorm__c> rg = [
           Select Id,RETAIL30_Y1_Percentage__c,Custom_Description__c,Specialty_Display_Name__c,CLIENT_OWNED_Y1__c,CLIENT_OWNED_Y2__c,CLIENT_OWNED_Y3__c,CLIENT_OWNED_Y4__c,CLIENT_OWNED_Y5__c,
            CLIENT_OWNED_Y6__c,Template_Retail_Display__c,Template_ClientOwned_Display__c,CLIENTOWNED_Y1_Percentage__c,CLIENTOWNED_Y2_Percentage__c,CLIENTOWNED_Y3_Percentage__c,
            CLIENTOWNED_Y4_Percentage__c,CLIENTOWNED_Y5_Percentage__c,CLIENTOWNED_Y6_Percentage__c,RETAIL_Y1_Percentage__c,RETAIL_Y2_Percentage__c,RETAIL_Y3_Percentage__c,
            RETAIL_Y4_Percentage__c,RETAIL_Y5_Percentage__c,RETAIL_Y6_Percentage__c,RETAIL30_Y2_Percentage__c,RETAIL30_Y3_Percentage__c,RETAIL30_Y4_Percentage__c,RETAIL30_Y5_Percentage__c,
            RETAIL30_Y6_Percentage__c,RETAIL90_Y1_Percentage__c,RETAIL90_Y2_Percentage__c,RETAIL90_Y3_Percentage__c,RETAIL90_Y4_Percentage__c,RETAIL90_Y5_Percentage__c,
            RETAIL90_Y6_Percentage__c,MCHOICE_Y1_Percentage__c,MCHOICE_Y2_Percentage__c,MCHOICE_Y3_Percentage__c, MCHOICE_Y4_Percentage__c,MCHOICE_Y5_Percentage__c,MCHOICE_Y6_Percentage__c,
            MAIL_Y1_Percentage__c,MAIL_Y2_Percentage__c,MAIL_Y3_Percentage__c,MAIL_Y4_Percentage__c,MAIL_Y5_Percentage__c,MAIL_Y6_Percentage__c,CLIENTOWNED30_Y1_Percentage__c,
            CLIENTOWNED30_Y2_Percentage__c,CLIENTOWNED30_Y3_Percentage__c,CLIENTOWNED30_Y4_Percentage__c,CLIENTOWNED30_Y5_Percentage__c,CLIENTOWNED30_Y6_Percentage__c,
            CLIENTOWNED90_Y1_Percentage__c,CLIENTOWNED90_Y2_Percentage__c,CLIENTOWNED90_Y3_Percentage__c,CLIENTOWNED90_Y4_Percentage__c,CLIENTOWNED90_Y5_Percentage__c,
            CLIENTOWNED90_Y6_Percentage__c,Basis_Y1__c,Basis_Y2__c,Basis_Y3__c,Basis_Y4__c,Basis_Y5__c,Basis_Y6__c,Plan_Year_Y1__c,Plan_Year_Y2__c,Plan_Year_Y3__c,Plan_Year_Y4__c,
            Plan_Year_Y5__c,Plan_Year_Y6__c,Template_Mail_Text_Y1__c,Template_Mail_Text_Y2__c,Template_Mail_Text_Y3__c,Template_Mail_Text_Y4__c,Template_Mail_Text_Y5__c,
            Template_Mail_Text_Y6__c,SPECIALTY_Y1_Percentage__c,SPECIALTY_Y2_Percentage__c,SPECIALTY_Y3_Percentage__c,SPECIALTY_Y4_Percentage__c,SPECIALTY_Y5_Percentage__c,
            SPECIALTY_Y6_Percentage__c,SPECIALTY_RETAIL_Y1_Percentage__c,SPECIALTY_RETAIL_Y2_Percentage__c,SPECIALTY_RETAIL_Y3_Percentage__c,SPECIALTY_RETAIL_Y4_Percentage__c,
            SPECIALTY_RETAIL_Y5_Percentage__c,SPECIALTY_RETAIL_Y6_Percentage__c,Specialty_Grid__c,RETAIL30_Y1__c,RETAIL30_Y2__c,RETAIL30_Y3__c,RETAIL30_Y4__c,RETAIL30_Y5__c,
            RETAIL30_Y6__c,RETAIL_Y1__c,RETAIL_Y2__c,RETAIL_Y3__c,RETAIL_Y4__c,RETAIL_Y5__c,RETAIL_Y6__c,MAILY1__c,MAILY2__c,MAILY3__c,MAILY4__c,MAILY5__c,MAILY6__c,MCHOICEY1__c,
            MCHOICEY2__c,MCHOICEY3__c,MCHOICEY4__c,MCHOICEY5__c,MCHOICEY6__c,CLIENT_OWNED30_Y1__c,CLIENT_OWNED30_Y2__c,CLIENT_OWNED30_Y3__c,CLIENT_OWNED30_Y4__c,CLIENT_OWNED30_Y5__c,
            CLIENT_OWNED30_Y6__c,CLIENT_OWNED90_Y1__c,CLIENT_OWNED90_Y2__c,CLIENT_OWNED90_Y3__c,CLIENT_OWNED90_Y4__c,CLIENT_OWNED90_Y5__c,CLIENT_OWNED90_Y6__c,SPECIALTYY1__c,
            SPECIALTYY2__c,SPECIALTY_Y3__c,SPECIALTY_Y4__c,SPECIALTY_Y5__c,SPECIALTY_Y6__c,SPECIALTY_RETAIL_Y1__c,SPECIALTY_RETAIL_Y2__c,SPECIALTY_RETAIL_Y3__c,SPECIALTY_RETAIL_Y4__c,
            SPECIALTY_RETAIL_Y5__c,SPECIALTY_RETAIL_Y6__c,Rebate_Operations__c,Non_Specialty_Grid__c,LOB__c,GSTP__c,Plan_Design__c,Non_Specialty_Formulary__c,Specialty_Formulary__c,FAF__c,
            Agreement_Line_Item__c,Agreement__c,Modeled_Non_Specialty_Formulary_Name__c,Modeled_Non_Specialty_PlanDesign__c,Modeled_Specialty_Formulary_Name__c,Percentage_Check__c,
            PCD_Aggregate_Rate__c,UniqueCheck__c,PCD_Same_dollar_and_Percentage_Value__c,Template_Retail30_Display__c,Template_Retail90_Display__c,Template_Mchoice_Display__c,
            Template_Mail_Display__c,Template_ClientOwned30_Display__c,Template_ClientOwned90_Display__c,Template_SpecialtyatRetail_Display__c,Template_SpecialtyatCVS_Display__c,
            Template_Mail_Label__c,Grid_flag__c,RETAIL90_Y1__c,RETAIL90_Y2__c,RETAIL90_Y3__c,RETAIL90_Y4__c,RETAIL90Y5__c,RETAIL90Y6__c ,Sequence_Number__c,
            Rebate_Operations__r.Rebate_Min_Sequence__c, Rebate_Operations__r.Rebate_Max_Sequence__c
            From Rebate_Guarantee_Denorm__c
            where Agreement_Line_Item__c = :RecId  And (Non_Specialty_Grid__c=true OR (Specialty_Grid__c=true AND Specialty_Formulary__c !='N/A'))
            order by Sequence_Number__c, Modeled_Non_Specialty_Formulary_Name__c, gstp__c,SORT__c Asc];//order BY Modeled_Non_Specialty_Formulary_Name__c, gstp__c,SORT__c Asc];//,];
        
     
        return rg; 
        
    
    }
       
    /*
    @AuraEnabled
    global static List<Rebate_Guarantees__c> get_RebGridObjectdata(String RecId, String ObjectName) 
    {
      
        List<Rebate_Guarantees__c> rg = [
            SELECT  id,Ranking__c,rebate_Modeled_Non_Specialty_PlanDe_New__c,Grid_flag__c,PCD_Same_dollar_and_Percentage_Value__c,UniqueCheck__c,LOB2__c,Retail_30_1__c,Template_Mail_Label_Text__c,Template_ClientOwned_Display__c,
            Rebate_Operations__c,Plan_Year__c,Retail_90_1__c,Mchoice_1__c,Mail_1__c,Specialty_1__c,Specialty_Retail_1__c,Client_Owned_90_1__c,
            Percentage_Check__c,Percentage_Guarantee__c,GSTP__c,Specialty_Formulary__c,Show_in_Non_Specialty_Grid__c,Show_in_Specialty_Grid__c,FAF_ID__c,
            Year_Begin_Date__c,Year__c,Plan_Design__c,Basis__c,Non_Specialty_Formulary_2__c,Template_SpecialtyatRetail_Text__c,Template_SpecialtyatRetail_Display__c,
            Template_ClientOwned90_Display__c,Template_Retail90_Text__c,Sorting_Number__c,Template_Retail90_Display__c,Template_Retail30_Display__c,Modeled_Non_Specialty_Formulary_Name__c,
            Modeled_Non_Specialty_PlanDesign__c,Template_Retail_Text__c,
            Template_Mail_Text__c,Template_Specialty_Formula__c,Template_Specialty_Carveout_Text__c,Template_Specialty_Carveout_Label_Text__c,
            Modeled_Specialty_PlanDesign__c,Client_Owned_30__c,Modeled_Specialty_Formulary_Name__c,
            Template_Clientowned30_Text__c,Template_ClientOwned30_Display__c,Template_Clientowned90_Text__c,Template_Clientowned_Text__c,Client_Owned_30_1__c,Client_Owned_90__c,
            Template_Mchoice_Text__c,Template_SpecialtyatCVS_Text__c,
            Retail_Display__c,ClientOwned30_Display__c,ClientOwned90_Display__c,ClientOwned_Display__c,
            Mail_Display__c,Maintenance_Choice_Display__c,Template_Retail30_Text__c,Retail30_Display__c,Retail90_Display__c,Template_SpecialtyatCVS_Display__c,Template_Rcurve_Display__c,
            Template_Mail_Display__c,Template_Retail_Display__c,Template_Mchoice_Display__c,Template_Mail_Label__c                
            from Rebate_Guarantees__c 
            where Agreement_Line_Item__c = :RecId  And (UniqueCheck__c=true OR PCD_Same_dollar_and_Percentage_Value__c=true OR Template_SpecialtyatCVS_Display__c = true) order BY Modeled_Non_Specialty_Formulary_Name__c,GSTP__c,Sorting_Number__c Asc];
        
     
        return rg;
    }
    */
    
    @AuraEnabled
    global static list<Rebate_Guarantees__c> get_RebCarveOutObjectdata(String RecId, String ObjectName) {
        list<Rebate_Guarantees__c> rg = [
            SELECT  id,rebate_Modeled_Non_Specialty_PlanDe_New__c,Grid_flag__c,PCD_Same_dollar_and_Percentage_Value__c,UniqueCheck__c,LOB2__c,Retail_30_1__c,Template_Mail_Label_Text__c,
            Template_ClientOwned_Display__c,Rebate_Operations__c,Plan_Year__c,Retail_90_1__c,Mchoice_1__c,Mail_1__c,Specialty_1__c,Specialty_Retail_1__c,Client_Owned_90_1__c,
            Percentage_Check__c,GSTP__c,Specialty_Formulary__c,FAF_ID__c,Year_Begin_Date__c,Year__c,Plan_Design__c,Basis__c,Non_Specialty_Formulary_2__c,Template_ClientOwned90_Display__c,
            Template_Retail90_Text__c,Sorting_Number__c,Template_Retail90_Display__c,Template_Retail30_Display__c,Modeled_Non_Specialty_Formulary_Name__c,
            Modeled_Non_Specialty_PlanDesign__c,Template_Retail_Text__c,
            Template_Mail_Text__c,Template_Specialty_Formula__c,Template_Specialty_Carveout_Text__c,Template_Specialty_Carveout_Label_Text__c,
            Modeled_Specialty_PlanDesign__c,Client_Owned_30__c,Modeled_Specialty_Formulary_Name__c,
            Template_Clientowned30_Text__c,Template_ClientOwned30_Display__c,Template_Clientowned90_Text__c,Template_Clientowned_Text__c,Client_Owned_30_1__c,Client_Owned_90__c,
            Template_Mchoice_Text__c,Template_SpecialtyatCVS_Text__c,
            Retail_Display__c,ClientOwned30_Display__c,ClientOwned90_Display__c,ClientOwned_Display__c,
            Mail_Display__c,Maintenance_Choice_Display__c,Template_Retail30_Text__c,Retail30_Display__c,Retail90_Display__c,Template_SpecialtyatCVS_Display__c,Template_Rcurve_Display__c,
            Template_Mail_Display__c,Template_Retail_Display__c,Template_Mchoice_Display__c,Template_Mail_Label__c ,Sequence_Number__c               
            from Rebate_Guarantees__c where Agreement_Line_Item__c = :RecId  and Template_Rcurve_Display__c=true ORDER BY Sorting_Number__c ASC
        ]; 
        return rg;
    }
    
    @AuraEnabled
    global static list<Clinical_Solutions__c> get_Addprogramdata(String RecId, String ObjectName) {
        list<Clinical_Solutions__c> cs = [
            SELECT  Id, Additional_Info__c,Custom_Description__c,Agreement__c, Agreement_Line_Item__c, Batch_Update__c, Client_Share__c, Clinical_Operations__c, Clinical_Operations_Link__c, Clinical_Solution__c,
            Clinical_Solution_Type__c, Contingent__c, CSG_Amount__c, CSG_Basis__c, CSG_Percentage__c, CSG_Type__c, CVS_Share__c, Do_not_modify_below_information__c, FAF_ID__c, Fee_Amount__c, 
            Fee_Basis__c, Guarantee__c, Highlight_Panel_Link__c, Included_In_Client_Savings_Guarantee__c, Link__c, Modeled_Fee_Basis__c, Object_Name__c, Opt_In_Out__c, Print_FAF_Client_Share__c, 
            Print_FAF_CVS_Share__c, Print_FAF_ROI_Percent__c, Recon_Level__c, Recon_Timeframe__c, Recon_Type__c, ROI_Amount__c, ROI_Percentage__c, ROI_Metric__c, Show_in_Grid__c, SOS__c, 
            Source_Record_ID__c, Template_Fee_Amount_Formula__c, Template_Fee_Basis_Display__c, Template_Fee_Basis_Formula__c, Template_Fee_Basis_Text__c, Year__c, Year_End_Date__c, 
            Year_Start_Date__c , Plan_Year__c  
            from Clinical_Solutions__c where Agreement_Line_Item__c = :RecId
            and Show_in_Grid__c= true
        ];
        return cs;
    }
    
    @AuraEnabled
    global static list<Central_Hub__c> get_BillAdmindata(String RecId, String ObjectName) {
        list<Central_Hub__c> ba = [
            SELECT  id,Custom_Description__c,Billing_Operations_Count__c,Template_Master_Electronic_Fee_text__c, 
            Template_Master_Manual_Claim_Fee_text__c,Template_340B_Display__c,Template_Master_340B_Type_text__c,Template_Master_EGWPPMPM_Type_text__c,Template_EGWPPMPM_Display__c,
            LOB2__c                      
            from Central_Hub__c where Agreement_Line_Item__c = :RecId
            and Billing_Operations_Count__c >0
        ];
        return ba;
    }
    
    @AuraEnabled
    global static list<Network_Pricing__c> get_newpricingdata(String fafid, String NetName, String NetType, String des , String lob) {
        list<Network_Pricing__c> np = new list<Network_Pricing__c>();
        if (des != null && des != '') {
            np = [
                SELECT id,
                Plan_Year__c,
                SSG_Guarantee__c,
                Custom_Description__c,
                OED_Count__c,
                NED_Count__c,
                MER_Count__c,
                GER_Count__c,
                BER_Guarantee__c,      
                Agreement__c,
                Agreement_Line_Item__c,                            
                FAF_ID__c,
                Year__c,
                Custom_Network_Description__c,
                FAF_Network_Ops__c,
                LOB__c,
                Brand_Rate__c,
                Brand_Basis__c,                            
                Preferred_Brand_Rate__c,
                Non_Preferred_Brand_Rate__c,
                Generic_Rate__c,
                GER_Guarantee_Rate__c,
                MER_Guarantee_Rate__c,
                BER_Guarantee_Rate__c,
                NED_Guarantee_Rate__c,
                SSG_Guarantee_Rate__c,
                Non_MAC_Generic_Rate__c,
                Brand_Dispensing_Fee__c,
                Generic_Dispensing_Fee__c,
                Network_Type__c,
                Retail_Network_Ordinal__c,
                Generic_Basis__c,
                Network_Name__c,
                FAF_ID__r.LOB2__c,
                Year_Begin_Date__c,
                Year_End_Date__c , FAF_Network_Ops__r.Network_Pricing_Max_Seq__c, FAF_Network_Ops__r.Network_Pricing_Min_Seq__c                           
                from Network_Pricing__c where FAF_Network_Ops__c = :fafid
                and  Network_Name__c= :NetName 
                and  Network_Type__c= :NetType
                and Custom_Network_Description__c = :des    
                and  LOB__c = :lob
                order by Year__c
            ];
        } else {
            np = [
                SELECT id,
                Plan_Year__c,
                SSG_Guarantee__c,
                OED_Count__c,
                Custom_Description__c,
                NED_Count__c,
                MER_Count__c,
                GER_Count__c,
                BER_Guarantee__c,      
                Agreement__c,
                Agreement_Line_Item__c,                            
                FAF_ID__c,
                Year__c,
                Custom_Network_Description__c,
                FAF_Network_Ops__c,
                LOB__c,
                Brand_Rate__c,
                Brand_Basis__c,                            
                Preferred_Brand_Rate__c,
                Non_Preferred_Brand_Rate__c,
                Generic_Rate__c,
                GER_Guarantee_Rate__c,
                MER_Guarantee_Rate__c,
                BER_Guarantee_Rate__c,
                NED_Guarantee_Rate__c,
                SSG_Guarantee_Rate__c,
                Non_MAC_Generic_Rate__c,
                Brand_Dispensing_Fee__c,
                Generic_Dispensing_Fee__c,
                Network_Type__c,
                Retail_Network_Ordinal__c,
                Generic_Basis__c,
                Network_Name__c,
                FAF_ID__r.LOB2__c,
                Year_Begin_Date__c,
                Year_End_Date__c  , FAF_Network_Ops__r.Network_Pricing_Max_Seq__c, FAF_Network_Ops__r.Network_Pricing_Min_Seq__c                          
                from Network_Pricing__c where FAF_Network_Ops__c = :fafid
                and  Network_Name__c= :NetName 
                and  Network_Type__c= :NetType    
                and  LOB__c = :lob                                  
                order by Year__c
            ];
        }
        return np;
    }   
    
    @AuraEnabled
    global static list<Network_Pricing__c> get_pricingdata(String fafid, String NetName, String NetType, String des , String lob) {
        list<Network_Pricing__c> np = new list<Network_Pricing__c>();
        if (des != null && des != '') {
            np = [
                SELECT id,
                Plan_Year__c,  
                SSG_Guarantee__c,
                Custom_Description__c,
                OED_Count__c,
                NED_Count__c,
                MER_Count__c,
                GER_Count__c,
                BER_Guarantee__c,
                Agreement__c,
                Agreement_Line_Item__c,                            
                FAF_ID__c,
                Year__c,   
                Custom_Network_Description__c,
                FAF_Network_Ops__c,
                LOB__c,
                Brand_Rate__c,
                Brand_Basis__c,                            
                Preferred_Brand_Rate__c,
                Non_Preferred_Brand_Rate__c,
                Generic_Rate__c,
                GER_Guarantee_Rate__c,
                MER_Guarantee_Rate__c,
                BER_Guarantee_Rate__c,
                NED_Guarantee_Rate__c,
                SSG_Guarantee_Rate__c,
                Non_MAC_Generic_Rate__c,
                Brand_Dispensing_Fee__c,
                Generic_Dispensing_Fee__c,
                Network_Type__c,
                Retail_Network_Ordinal__c,
                Generic_Basis__c,
                Network_Name__c,
                FAF_ID__r.LOB2__c,
                Year_Begin_Date__c,
                Year_End_Date__c     , FAF_Network_Ops__r.Network_Pricing_Max_Seq__c, FAF_Network_Ops__r.Network_Pricing_Min_Seq__c                       
                from Network_Pricing__c where FAF_ID__c = :fafid
                and  Network_Name__c= :NetName 
                and  Network_Type__c= :NetType
                and Custom_Network_Description__c = :des    
                and  LOB__c = :lob
                order by Year__c
            ];
        } else {
            np = [
                SELECT id,
                Plan_Year__c,
                SSG_Guarantee__c,
                OED_Count__c,
                NED_Count__c,
                Custom_Description__c,
                MER_Count__c,
                GER_Count__c,
                BER_Guarantee__c,
                Agreement__c,
                Agreement_Line_Item__c,                            
                FAF_ID__c,
                Year__c,
                Custom_Network_Description__c,
                FAF_Network_Ops__c,
                LOB__c,
                Brand_Rate__c,
                Brand_Basis__c,                            
                Preferred_Brand_Rate__c,
                Non_Preferred_Brand_Rate__c,
                Generic_Rate__c,
                GER_Guarantee_Rate__c,
                MER_Guarantee_Rate__c,
                BER_Guarantee_Rate__c,
                NED_Guarantee_Rate__c,
                SSG_Guarantee_Rate__c,
                Non_MAC_Generic_Rate__c,
                Brand_Dispensing_Fee__c,
                Generic_Dispensing_Fee__c,
                Network_Type__c,
                Retail_Network_Ordinal__c,
                Generic_Basis__c,
                Network_Name__c,
                FAF_ID__r.LOB2__c,
                Year_Begin_Date__c,
                Year_End_Date__c , FAF_Network_Ops__r.Network_Pricing_Max_Seq__c, FAF_Network_Ops__r.Network_Pricing_Min_Seq__c                           
                from Network_Pricing__c where FAF_ID__c = :fafid
                and  Network_Name__c= :NetName 
                and  Network_Type__c= :NetType    
                and  LOB__c = :lob                                  
                order by Year__c
            ];
        }
        return np;
    }    
    
    @AuraEnabled
    global static list<Specialty_Pricing__c> get_SpecialtyPricingData(String fafid, String opid, String phBenefit) {
        system.debug('opid-----------------'+opid);
        list<Specialty_Pricing__c> sp = new list<Specialty_Pricing__c>();
        
        if(String.isNotBlank(phBenefit)){
            sp = [
                SELECT id, FAF_ID__c,Custom_Description__c, Year__c, Plan_Year__c,  Pharmacy_Benefit__c, Price_List__c, Specialty_Compare_Logic_On__c, Brand_Basis__c, Brand_Rate__c, 
                Brand_Dispensing_Fee__c, Generic_Basis__c, Generic_Rate__c, Generic_Dispensing_Fee__c,  Limited_Distribution_Drug_LDD_Rate__c, New_to_Market_Brand_Rate__c,
                LDD_No_Access_Rate__c, Biosimilar_Rate__c, Specialty_Operations__c, LOB__c, Agreement__c, Agreement_Line_Item__c, FAF_ID__r.LOB2__c                      
                from Specialty_Pricing__c where Specialty_Operations__c = :opid and Pharmacy_Benefit__c =:phBenefit
                order by Year__c
            ];
        } else {
            sp = [
                SELECT id, FAF_ID__c,Custom_Description__c, Year__c, Plan_Year__c,  Pharmacy_Benefit__c, Price_List__c, Specialty_Compare_Logic_On__c, Brand_Basis__c, Brand_Rate__c, 
                Brand_Dispensing_Fee__c, Generic_Basis__c, Generic_Rate__c, Generic_Dispensing_Fee__c,  Limited_Distribution_Drug_LDD_Rate__c, New_to_Market_Brand_Rate__c,
                LDD_No_Access_Rate__c, Biosimilar_Rate__c, Specialty_Operations__c, LOB__c, Agreement__c, Agreement_Line_Item__c, FAF_ID__r.LOB2__c                      
                from Specialty_Pricing__c where Specialty_Operations__c = :opid 
                order by Year__c
            ];
        }
        
        system.debug('sp-----------------'+sp);
        return sp;
    }  
    
    @AuraEnabled
    global static list<Mail_Pricing__c> get_Mailpricingdata(String fafid) {
        list<Mail_Pricing__c> mp = [
            SELECT id,
            Custom_Description__c,
            Agreement__c,
            Agreement_Line_Item__c,
            Plan_Year__c,
            SSG_Guarantee__c,
            NED_Count__c,
            MER_Count__c,
            GER_Count__c,
            BER_Guarantee__c,                         
            FAF_Mail_Operations__c,                         
            FAF_ID__c,
            Year__c,
            LOB__c,
            Brand_Rate__c,
            Preferred_Brand_Rate__c,
            Non_Preferred_Brand_Rate__c,
            Generic_Rate__c,
            GER_Guarantee_Rate__c,
            MER_Guarantee_Rate__c,
            BER_Guarantee_Rate__c,
            NED_Guarantee_Rate__c,
            SSG_Guarantee_Rate__c,
            Non_MAC_Generic_Rate__c,
            Brand_Dispensing_Fee__c,
            Generic_Dispensing_Fee__c,
            Brand_Basis__c,                         
            Generic_Basis__c,
            FAF_ID__r.LOB2__c,
            Year_Begin_Date__c,
            Year_End_Date__c                          
            from Mail_Pricing__c where FAF_ID__c = :fafid
            order by Year__c
        ];
        return mp;
    }    
    @AuraEnabled
    global static list<Rebate_Guarantees__c> get_Rebatedata(String fafid,String plan,String basis,String nonspecForm,String gstp,String specForm) {
        list<Rebate_Guarantees__c> mp = [
            SELECT  id,Plan_Year__c,Custom_Description__c,Retail_30_1__c,Rebate_Operations__c,Template_Mail_Label_Text__c,Retail_90_1__c,Mchoice_1__c,Mail_1__c,Specialty_1__c,Specialty_Retail_1__c,Percentage_Check__c,Percentage_Guarantee__c,Year_Begin_Date__c,FAF_ID__c,Template_SpecialtyatRetail_Text__c,Template_SpecialtyatRetail_Display__c,Template_ClientOwned90_Display__c,Template_Retail90_Text__c,Sorting_Number__c,Template_Retail90_Display__c,Template_Retail30_Display__c,Modeled_Non_Specialty_Formulary_Name__c,
            Modeled_Non_Specialty_PlanDesign__c,Template_Retail_Text__c,
            Template_Mail_Text__c,Template_Specialty_Formula__c,Template_Specialty_Carveout_Text__c,Template_Specialty_Carveout_Label_Text__c,
            Modeled_Specialty_PlanDesign__c,Client_Owned_30__c,Modeled_Specialty_Formulary_Name__c,
            Template_Clientowned30_Text__c,Template_ClientOwned30_Display__c,Template_Clientowned90_Text__c,Template_Clientowned_Text__c,Client_Owned_30_1__c,Client_Owned_90__c,
            Client_Owned_90_1__c,Template_Mchoice_Text__c,Template_SpecialtyatCVS_Text__c,
            Retail_Display__c,ClientOwned30_Display__c,ClientOwned90_Display__c,ClientOwned_Display__c,
            Mail_Display__c,Maintenance_Choice_Display__c,Template_Retail30_Text__c,Retail30_Display__c,Retail90_Display__c,Template_SpecialtyatCVS_Display__c,Template_Rcurve_Display__c,
            Template_Mail_Display__c,Year__c,LOB2__c,Basis__c,Plan_Design__c,GSTP__c,Non_Specialty_Formulary_2__c,Specialty_Formulary__c,Retail_30__c,
            Retail_90__c,Mchoice__c,Mail__c,Specialty__c,Specialty_Retail__c,Template_Retail_Display__c,Template_Mchoice_Display__c,Template_Mail_Label__c                
            from Rebate_Guarantees__c where Plan_Design__c=:plan and  Non_Specialty_Formulary_2__c=:nonspecForm and GSTP__c=:gstp and FAF_ID__c=:fafid
        ];
        return mp;
    }  
    @AuraEnabled
    global static list<Rebate_Guarantees__c> get_RebatedataSpec(String fafid,String plan,String basis,String nonspecForm,String gstp,String specForm) {
        list<Rebate_Guarantees__c> mp = [
            SELECT  id,Retail_30_1__c,Custom_Description__c,Plan_Year__c,Template_Mail_Label_Text__c,Rebate_Operations__c,Retail_90_1__c,Mchoice_1__c,Mail_1__c,Specialty_1__c,Specialty_Retail_1__c,Percentage_Check__c,Percentage_Guarantee__c,Year_Begin_Date__c,FAF_ID__c,Template_SpecialtyatRetail_Text__c,Template_SpecialtyatRetail_Display__c,Template_ClientOwned90_Display__c,Template_Retail90_Text__c,Sorting_Number__c,Template_Retail90_Display__c,Template_Retail30_Display__c,Modeled_Non_Specialty_Formulary_Name__c,
            Modeled_Non_Specialty_PlanDesign__c,Template_Retail_Text__c,
            Template_Mail_Text__c,Template_Specialty_Formula__c,Template_Specialty_Carveout_Text__c,Template_Specialty_Carveout_Label_Text__c,
            Modeled_Specialty_PlanDesign__c,Client_Owned_30__c,Modeled_Specialty_Formulary_Name__c,
            Template_Clientowned30_Text__c,Template_ClientOwned30_Display__c,Template_Clientowned90_Text__c,Template_Clientowned_Text__c,Client_Owned_30_1__c,Client_Owned_90__c,
            Client_Owned_90_1__c,Template_Mchoice_Text__c,Template_SpecialtyatCVS_Text__c,
            Retail_Display__c,ClientOwned30_Display__c,ClientOwned90_Display__c,ClientOwned_Display__c,
            Mail_Display__c,Maintenance_Choice_Display__c,Template_Retail30_Text__c,Retail30_Display__c,Retail90_Display__c,Template_SpecialtyatCVS_Display__c,Template_Rcurve_Display__c,
            Template_Mail_Display__c,Year__c,LOB2__c,Basis__c,Plan_Design__c,GSTP__c,Non_Specialty_Formulary_2__c,Specialty_Formulary__c,Retail_30__c,
            Retail_90__c,Mchoice__c,Mail__c,Specialty__c,Specialty_Retail__c,Template_Retail_Display__c,Template_Mchoice_Display__c,Template_Mail_Label__c                
            from Rebate_Guarantees__c where Plan_Design__c=:plan and Basis__c=:basis and Specialty_Formulary__c=:specForm and GSTP__c=:gstp and FAF_ID__c=:fafid
        ];
        return mp;
    }   
    //--------------------anvesh------------------
    @AuraEnabled
    public static RebateWrapper get_RebatedataNonSpec(String fafid,String plan,String basis,String nonspecForm,String gstp,String specForm) {
        RebateWrapper wrapper = new RebateWrapper();
        wrapper.rg2TQ = new list<Rebate_Guarantees__c>();
        wrapper.rg3TQ = new list<Rebate_Guarantees__c>();
        wrapper.rg3TNQ = new list<Rebate_Guarantees__c>();
        wrapper.closed = new list<Rebate_Guarantees__c>();
        list<Rebate_Guarantees__c> mp = [
            SELECT  id,Retail_30_1__c,Plan_Year__c,Custom_Description__c,Rebate_Operations__c,Retail_90_1__c,Mchoice_1__c,Mail_1__c,Specialty_1__c,Specialty_Retail_1__c,
            Percentage_Check__c,Percentage_Guarantee__c,Year_Begin_Date__c,FAF_ID__c,
            Sorting_Number__c,Modeled_Non_Specialty_Formulary_Name__c,
            Modeled_Non_Specialty_PlanDesign__c,
            Modeled_Specialty_PlanDesign__c,Client_Owned_30__c,Modeled_Specialty_Formulary_Name__c,
            Client_Owned_30_1__c,Client_Owned_90__c,
            Client_Owned_90_1__c,
            Retail_Display__c,ClientOwned30_Display__c,ClientOwned90_Display__c,ClientOwned_Display__c,
            Mail_Display__c,Maintenance_Choice_Display__c,Retail30_Display__c,Retail90_Display__c,
            Year__c,LOB2__c,Basis__c,Plan_Design__c,GSTP__c,Non_Specialty_Formulary_2__c,Specialty_Formulary__c,Retail_30__c,
            Retail_90__c,Mchoice__c,Mail__c,Specialty__c,Specialty_Retail__c               
            from Rebate_Guarantees__c where Basis__c=:basis and Non_Specialty_Formulary_2__c=:nonspecForm and GSTP__c=:gstp and FAF_ID__c=:fafid
        ];
        for(Rebate_Guarantees__c rg :mp){
            if(rg.Plan_Design__c == '2 Tier Q'){
                wrapper.rg2TQ.add(rg);
            }
            if(rg.Plan_Design__c == '3 Tier NQ'){
                wrapper.rg3TQ.add(rg);
            }
            if(rg.Plan_Design__c == '3 Tier Q'){
                wrapper.rg3TNQ.add(rg);
            }
            if(rg.Plan_Design__c == 'Closed'){
                wrapper.closed.add(rg);
            }
        }
        wrapper.is2TQ = wrapper.rg2TQ.isEmpty() ? false : true;
        wrapper.is3TQ = wrapper.rg3TQ.isEmpty() ? false : true;
        wrapper.is3TNQ = wrapper.rg3TNQ.isEmpty() ? false : true;
        wrapper.isClosed = wrapper.closed.isEmpty() ? false : true;
        return wrapper;
    }   
    public class RebateWrapper {
        @AuraEnabled public list<Rebate_Guarantees__c> rg2TQ;
        @AuraEnabled public list<Rebate_Guarantees__c> rg3TQ;
        @AuraEnabled public list<Rebate_Guarantees__c> rg3TNQ;
        @AuraEnabled public list<Rebate_Guarantees__c> closed;
        @AuraEnabled public Boolean is2TQ;
        @AuraEnabled public Boolean is3TQ;
        @AuraEnabled public Boolean is3TNQ;
        @AuraEnabled public Boolean isClosed;
    }
    //--------------------anvesh------------------
    @AuraEnabled
    public static list<objectWrapper> get_aggrhistory(String Recid) {
        list<objectWrapper> returnValue = new list<objectWrapper>();
        list<User> lstUser =[select id,userName,Name from user];
        list<Offer__c> lstOffer =[select id,Name from Offer__c];
        list<Apttus__APTS_Agreement__c> agg = [SELECT Id,Offer__c,OfferNum__c FROM Apttus__APTS_Agreement__c where iUMS_Task__c= :Recid and Apttus__Agreement_Category__c=:Label.PCD];
        list<Apttus__AgreementLineItem__c> aggline = [SELECT Id,LOB_Detail__c,LOB_ID__c,Offer__c,Apttus__AgreementId__c FROM Apttus__AgreementLineItem__c where Apttus__AgreementId__c IN :agg];
        list<Apttus__AgreementLineItem__History> aggh = [
            SELECT CreatedDate,CreatedById,Field,Id,NewValue,OldValue,ParentId FROM Apttus__AgreementLineItem__History where ParentId IN :aggline
            Order by ParentId,CreatedDate desc
        ];
        
         list<Apttus__DocumentVersionDetail__c> docv = [
            SELECT Id,Agreement_Line_Item__c FROM Apttus__DocumentVersionDetail__c where  Agreement__c IN :agg];
        
         list<Apttus__DocumentVersionDetail__History> docvh = [
            SELECT CreatedDate,CreatedById,Field,Id,NewValue,OldValue,ParentId FROM Apttus__DocumentVersionDetail__History where ParentId IN :docv
            and Field <> 'created' Order by ParentId,CreatedDate desc
         ];
        
        for (Apttus__DocumentVersionDetail__History doch : docvh )  
        {
         for (Apttus__DocumentVersionDetail__c doc : docv)  
          {
          if (doch.ParentId == doc.Id)
          {   
          for (Apttus__AgreementLineItem__c agl : aggline)  
            {
             if (doc.Agreement_Line_Item__c == agl.Id)
             {
            for (Apttus__APTS_Agreement__c aggr : agg)  
            {
            if (aggr.Id == agl.Apttus__AgreementId__c)
             {
             for (User u : lstUser)  
             {
             if(doch.CreatedById == u.Id)
             {
             for (Offer__c off : lstOffer)  
             {
             if(off.Id == aggr.Offer__c)
             {
            objectWrapper aa = new objectWrapper();
            aa.OfferId=aggr.Offer__c;
            aa.OfferNum=off.Name;
            aa.LOBDetail=agl.LOB_Detail__c;
            aa.CreatedDate=doch.CreatedDate;
            aa.OldValue=doch.OldValue;
            aa.NewValue=doch.NewValue;
            aa.UserName=u.Name;
            aa.Field = doch.Field;
         
           if(doch.Field == 'Deleted__c' && doch.NewValue == true)
            {
               aa.Field = 'PCD Document Deleted';
            }
            returnValue.add(aa);
            }
            }
            }
            }
            }
            }
            }
           }   
           }
          } 
        }
        
        
        for (Apttus__AgreementLineItem__History ag : aggh)  {
           for (Apttus__AgreementLineItem__c agl : aggline)  
            {
             if (ag.ParentId == agl.Id)
             {
            for (Apttus__APTS_Agreement__c aggr : agg)  
            {
            if (aggr.Id == agl.Apttus__AgreementId__c)
             {
             for (User u : lstUser)  
             {
             if(ag.CreatedById == u.Id)
             {
             for (Offer__c off : lstOffer)  
             {
             if(off.Id == aggr.Offer__c)
             {
            objectWrapper aa = new objectWrapper();
            aa.OfferId=aggr.Offer__c;
            aa.OfferNum=off.Name;
            aa.LOBDetail=agl.LOB_Detail__c;
            aa.CreatedDate=ag.CreatedDate;
            aa.OldValue=ag.OldValue;
            aa.NewValue=ag.NewValue;
            aa.UserName=u.Name;
            aa.Field = ag.Field;
            if(ag.Field == 'created')
             {
               aa.Field = 'PCD Started';
             }
            if(ag.Field == 'PCD_Status__c' && ag.NewValue =='Generate Document')
            {
               aa.Field = 'PCD Document Generated';
            }
            if(ag.Field == 'PCD_Status__c' && ag.NewValue =='Setup Pricing')
            {
               aa.Field = 'Pricing Update';
            }
            returnValue.add(aa);
            }
            }
            }
            }
            }
            }
            }
           } 
        } 
        return returnValue;
    }    
    
    public class objectWrapper{
        @AuraEnabled 
        public String OfferId;
        @AuraEnabled 
        public String OfferNum;
        @AuraEnabled 
        public String LOBDetail;
        @AuraEnabled 
        public Datetime CreatedDate;
        @AuraEnabled 
        public Object OldValue;
        @AuraEnabled 
        public Object NewValue;
        @AuraEnabled 
        public String UserName;
        @AuraEnabled 
        public String Field;
        
    }
    @AuraEnabled
    global static void deletepricinggrid(String fafid, String NetName, String NetType, String des , String lob) {
        try {
            list<Network_Pricing__c> np = new list<Network_Pricing__c>();
            if (des != null && des != '') {
                np = [
                    SELECT id,
                    Plan_Year__c,
                    SSG_Guarantee__c,
                    OED_Count__c,
                    NED_Count__c,
                    MER_Count__c,
                    GER_Count__c,
                    BER_Guarantee__c,      
                    Agreement__c,
                    Agreement_Line_Item__c,                            
                    FAF_ID__c,
                    Year__c,
                    Custom_Network_Description__c,
                    FAF_Network_Ops__c,
                    LOB__c,
                    Brand_Rate__c,
                    Brand_Basis__c,                            
                    Preferred_Brand_Rate__c,
                    Non_Preferred_Brand_Rate__c,
                    Generic_Rate__c,
                    GER_Guarantee_Rate__c,
                    MER_Guarantee_Rate__c,
                    BER_Guarantee_Rate__c,
                    NED_Guarantee_Rate__c,
                    SSG_Guarantee_Rate__c,
                    Non_MAC_Generic_Rate__c,
                    Brand_Dispensing_Fee__c,
                    Generic_Dispensing_Fee__c,
                    Network_Type__c,
                    Retail_Network_Ordinal__c,
                    Generic_Basis__c,
                    Network_Name__c,
                    FAF_ID__r.LOB2__c,
                    Year_Begin_Date__c,
                    Year_End_Date__c,
                    Sequence_Number__c , FAF_Network_Ops__r.Network_Pricing_Max_Seq__c, FAF_Network_Ops__r.Network_Pricing_Min_Seq__c                           
                    from Network_Pricing__c where FAF_ID__c = :fafid
                    and  Network_Name__c= :NetName 
                    and  Network_Type__c= :NetType
                    and Custom_Network_Description__c = :des    
                    and  LOB__c = :lob
                ];
            } else {
                np = [
                    SELECT id,
                    Plan_Year__c,
                    SSG_Guarantee__c,
                    OED_Count__c,
                    NED_Count__c,
                    MER_Count__c,
                    GER_Count__c,
                    BER_Guarantee__c,      
                    Agreement__c,
                    Agreement_Line_Item__c,                            
                    FAF_ID__c,
                    Year__c,
                    Custom_Network_Description__c,
                    FAF_Network_Ops__c,
                    LOB__c,
                    Brand_Rate__c,
                    Brand_Basis__c,                            
                    Preferred_Brand_Rate__c,
                    Non_Preferred_Brand_Rate__c,
                    Generic_Rate__c,
                    GER_Guarantee_Rate__c,
                    MER_Guarantee_Rate__c,
                    BER_Guarantee_Rate__c,
                    NED_Guarantee_Rate__c,
                    SSG_Guarantee_Rate__c,
                    Non_MAC_Generic_Rate__c,
                    Brand_Dispensing_Fee__c,
                    Generic_Dispensing_Fee__c,
                    Network_Type__c,
                    Retail_Network_Ordinal__c,
                    Generic_Basis__c,
                    Network_Name__c,
                    FAF_ID__r.LOB2__c,
                    Year_Begin_Date__c,
                    Year_End_Date__c,
                    Sequence_Number__c , FAF_Network_Ops__r.Network_Pricing_Max_Seq__c, FAF_Network_Ops__r.Network_Pricing_Min_Seq__c
                    from Network_Pricing__c where FAF_ID__c = :fafid
                    and  Network_Name__c= :NetName 
                    and  Network_Type__c= :NetType    
                    and  LOB__c = :lob 
                ];
            } 
            if (np != null || !np.isEmpty()) {
                list<Network_Pricing__c> npAllList = new list<Network_Pricing__c>();
                list<Network_Pricing__c> npAllRecList = new list<Network_Pricing__c>();
                list<Network_Pricing__c> npAllSPList = new list<Network_Pricing__c>();
                list<Network_Pricing__c> npSPUpdateList = new list<Network_Pricing__c>();
                
                String cLabel = System.Label.Network_Pricing_Exclude_Values;
                List<String> val = new List<String>();
                
                for(String str : cLabel.split(',')){
                    val.add(str.trim());
                }
                
                Map<Integer, List<Network_Pricing__c>> npDelSeqMap = new Map<Integer, List<Network_Pricing__c>>();
                Map<Integer, List<Network_Pricing__c>> npAfterDelSeqMap = new Map<Integer, List<Network_Pricing__c>>();
                Map<Id, Network_Pricing__c> npUpdateMap =  new Map<Id, Network_Pricing__c>();
                
                Set<Id> npDelIds = new Set<Id>();
                Set<Id> opid = new Set<Id>();
                
                for(Network_Pricing__c npObj :np){
                    if(npDelSeqMap.containsKey(Integer.valueOf(npObj.Sequence_Number__c))){
                        npDelSeqMap.get(Integer.valueOf(npObj.Sequence_Number__c)).add(npObj);
                    } else {
                        List<Network_Pricing__c> temp = new List<Network_Pricing__c>();
                        temp.add(npObj);
                        npDelSeqMap.put(Integer.valueOf(npObj.Sequence_Number__c), temp);
                    }
                    opid.add(npObj.FAF_Network_Ops__c);      
                    npDelIds.add(npObj.Id);
                }
                
                npAllList = [
                    SELECT id, Name, Sequence_Number__c, FAF_ID__c, FAF_Network_Ops__c, Network_Name__c,Retail_Network_Ordinal__c, Network_Name_for_Grid__c, Network_Type__c , 
                    FAF_Network_Ops__r.Network_Pricing_Max_Seq__c, FAF_Network_Ops__r.Network_Pricing_Min_Seq__c                            
                    from Network_Pricing__c
                    Where Sequence_Number__c > :npDelSeqMap.keySet() and FAF_Network_Ops__c In :opid and Id Not IN :npDelIds and Network_Name__c <>'MC(84-90)CVS' and Network_Name__c <> null
                    and Network_Name__c NOT IN : val
                ];
                
                /*for(Network_Pricing__c npObj  : npAllRecList){
                    if(npObj.Network_Name__c == 'Specialty'){
                        npAllSPList.add(npObj);
                    } else {
                        npAllList.add(npObj);
                    }
                }*/
                for(Network_Pricing__c npObj :npAllList){
                    if(npAfterDelSeqMap.containsKey(Integer.valueOf(npObj.Sequence_Number__c))){
                        npAfterDelSeqMap.get(Integer.valueOf(npObj.Sequence_Number__c)).add(npObj);
                    } else {
                        List<Network_Pricing__c> temp = new List<Network_Pricing__c>();
                        temp.add(npObj);
                        npAfterDelSeqMap.put(Integer.valueOf(npObj.Sequence_Number__c), temp);
                    }
                }
                for(Integer seq :npAfterDelSeqMap.keySet()){
                    if(seq > 1 ){
                        for(Network_Pricing__c npObj : npAfterDelSeqMap.get(seq)){
                            npObj.Sequence_Number__c = seq - 1 ;
                            npUpdateMap.put(npObj.Id, npObj);
                        }
                    }
                }
                system.debug('np--------------------------'+np);
                if(!np.isEmpty()){
                    List<Database.DeleteResult> result = Database.delete(np, false);
                }
                system.debug('npUpdateMap.values()--------------------------'+npUpdateMap.keyset());
                if(!npUpdateMap.values().isEmpty()){
                    Database.SaveResult[] srList = Database.update(npUpdateMap.values(), false);
                }
                
                 
                /*Network_Pricing__c newNP = [
                    SELECT  id, Name, Sequence_Number__c
                    from Network_Pricing__c Where FAF_Network_Ops__c IN  :opid and Network_Name__c <>'MC(84-90)CVS' and Network_Name__c <> null 
                    and Sequence_Number__c != Null and Network_Name__c != 'Specialty'
                    order by Sequence_Number__c desc limit 1
                ];
                system.debug('newNP--------------------------'+newNP);
                for(Network_Pricing__c npObj  : npAllSPList){
                    npObj.Sequence_Number__c = newNP.Sequence_Number__c + 1;
                    npSPUpdateList.add(npObj);
                }
                if(!npSPUpdateList.isEmpty()){
                    //Database.SaveResult[] srList1 = Database.update(npSPUpdateList, false);
                }*/
                
            } 
                
       }  catch(Exception ex){
            throw new AurahandledException(ex.getDmlMessage(0));
        }       
    }     
    @AuraEnabled
    global static integer deleteSelectedRecords(String netprId)  {
        List <Network_Pricing__c> recordsToDelete = [
            SELECT Id,FAF_Network_Ops__c,Network_Name__c,Network_Type__c,Custom_Network_Description__c,LOB__c,Year__c,Sequence_Number__c 
            FROM Network_Pricing__c 
            WHERE Id = : netprId
        ];
        try{
            String cLabel = System.Label.Network_Pricing_Exclude_Values;
            List<String> val = new List<String>();
            
            for(String str : cLabel.split(',')){
                val.add(str.trim());
            }
            
            //delete recordsToDelete;
            integer countnp = 0;
            if(recordsToDelete != null && !recordsToDelete.isEmpty()) {
                List <Network_Pricing__c> np = [
                    SELECT Id  FROM Network_Pricing__c WHERE FAF_Network_Ops__c = : recordsToDelete[0].FAF_Network_Ops__c
                    and Network_Name__c=: recordsToDelete[0].Network_Name__c
                    and Network_Type__c=: recordsToDelete[0].Network_Type__c
                    and Custom_Network_Description__c=: recordsToDelete[0].Custom_Network_Description__c
                    and LOB__c=: recordsToDelete[0].LOB__c
                ];   
                if(np != null && !np.isEmpty()) {
                    countnp =  np.size();
                }
                ////////////////////////////////////////////////
                list<Network_Pricing__c> npAllList = new list<Network_Pricing__c>();
                list<Network_Pricing__c> npAllRecList = new list<Network_Pricing__c>();
                list<Network_Pricing__c> npAllSPList = new list<Network_Pricing__c>();
                list<Network_Pricing__c> npSPUpdateList = new list<Network_Pricing__c>();
                
                Map<Integer, List<Network_Pricing__c>> npAfterDelSeqMap = new Map<Integer, List<Network_Pricing__c>>();
                Map<Id, Network_Pricing__c> npUpdateMap =  new Map<Id, Network_Pricing__c>();
                
                List <Network_Pricing__c> sameNPRecList = [
                    SELECT Id,FAF_Network_Ops__c,Network_Name__c,Network_Type__c,Custom_Network_Description__c,LOB__c,Year__c,Sequence_Number__c 
                    FROM Network_Pricing__c 
                    WHERE Sequence_Number__c = : recordsToDelete[0].Sequence_Number__c and FAF_Network_Ops__c = : recordsToDelete[0].FAF_Network_Ops__c
                    and Id !=  :recordsToDelete[0].Id
                ];
                system.debug('sameNPRecList---------'+sameNPRecList);
                String opid = recordsToDelete[0].FAF_Network_Ops__c;
                if(sameNPRecList.isEmpty()){
                    npAllList = [
                        SELECT id, Name, Sequence_Number__c, FAF_ID__c, FAF_Network_Ops__c, Network_Name__c,Retail_Network_Ordinal__c, Network_Name_for_Grid__c, Network_Type__c , 
                        FAF_Network_Ops__r.Network_Pricing_Max_Seq__c, FAF_Network_Ops__r.Network_Pricing_Min_Seq__c                            
                        from Network_Pricing__c
                        Where Sequence_Number__c > :recordsToDelete[0].Sequence_Number__c and FAF_Network_Ops__c = :recordsToDelete[0].FAF_Network_Ops__c 
                         and Id !=  :recordsToDelete[0].Id and Network_Name__c <>'MC(84-90)CVS' and Network_Name__c <> null and Network_Name__c NOT IN : val
                    ];
                    /*for(Network_Pricing__c npObj  : npAllRecList){
                        if(npObj.Network_Name__c == 'Specialty'){
                            npAllSPList.add(npObj);
                        } else {
                            npAllList.add(npObj);
                        }
                    }*/
                    system.debug('npAllList---------'+npAllList);
                    for(Network_Pricing__c npObj :npAllList){
                        if(npAfterDelSeqMap.containsKey(Integer.valueOf(npObj.Sequence_Number__c))){
                            npAfterDelSeqMap.get(Integer.valueOf(npObj.Sequence_Number__c)).add(npObj);
                        } else {
                            List<Network_Pricing__c> temp = new List<Network_Pricing__c>();
                            temp.add(npObj);
                            npAfterDelSeqMap.put(Integer.valueOf(npObj.Sequence_Number__c), temp);
                        }
                    }
                    system.debug('npAfterDelSeqMap.keyset()---------'+npAfterDelSeqMap.keySet());
                    
                    for(Integer seq :npAfterDelSeqMap.keySet()){
                        if(seq > 1 ){
                            for(Network_Pricing__c npObj : npAfterDelSeqMap.get(seq)){
                                npObj.Sequence_Number__c = seq - 1 ;
                                npUpdateMap.put(npObj.Id, npObj);
                            }
                        }
                    }
                    system.debug('npUpdateMap.keyset()---------'+npUpdateMap);                
                }
                    ////////////////////////////////////////////////
                
                
                
                List<Database.DeleteResult> result = Database.delete(recordsToDelete, false);
                if(!npUpdateMap.values().isEmpty()){
                    Database.SaveResult[] srList = Database.update(npUpdateMap.values(), false);                    
                }
                
                
                /*Network_Pricing__c newNP = [
                    SELECT  id, Name, Sequence_Number__c 
                    from Network_Pricing__c Where FAF_Network_Ops__c = :opid and Network_Name__c <>'MC(84-90)CVS' and Network_Name__c <> null 
                    and Sequence_Number__c != Null and Network_Name__c != 'Specialty'
                    order by Sequence_Number__c desc limit 1
                ];
                for(Network_Pricing__c npObj  : npAllSPList){
                    npObj.Sequence_Number__c = newNP.Sequence_Number__c + 1;
                    npSPUpdateList.add(npObj);
                }
                if(!npSPUpdateList.isEmpty()){
                    //Database.SaveResult[] srList1 = Database.update(npSPUpdateList, false);
                }*/
                

                for(Integer i=0;i<result.size();i++){
                    if(!result.get(i).isSuccess()) {
                        Database.Error error = result.get(i).getErrors().get(0);
                        String failedDML = error.getMessage();
                        throw new AuraHandledException(failedDML);
                    }
                }
            }
            return countnp;
        } catch(Exception ex){
            throw new AurahandledException(ex.getDmlMessage(0));
        }    
    }
    @AuraEnabled
    global static integer deleteSelectedRebateRecords(String netprId)  {
        List <Rebate_Guarantees__c> recordsToDelete = [
            SELECT Id,FAF_ID__c,Non_Specialty_Formulary_2__c,Plan_Design__c,Specialty_Formulary__c,Year__c FROM Rebate_Guarantees__c WHERE Id = : netprId
        ];
        try{
            //delete recordsToDelete;
            integer countnp = 0;
            if(recordsToDelete != null && !recordsToDelete.isEmpty()) {
                List <Rebate_Guarantees__c> np = [
                    SELECT Id  FROM Rebate_Guarantees__c WHERE FAF_ID__c = : recordsToDelete[0].FAF_ID__c
                    and Non_Specialty_Formulary_2__c=: recordsToDelete[0].Non_Specialty_Formulary_2__c
                    and Plan_Design__c=: recordsToDelete[0].Plan_Design__c
                    and Year__c=: recordsToDelete[0].Year__c
                    and Specialty_Formulary__c=: recordsToDelete[0].Specialty_Formulary__c
                ];   
                if(np != null && !np.isEmpty()) {
                    countnp =  np.size();
                }
                List<Database.DeleteResult> result = Database.delete(recordsToDelete, false);
                for(Integer i=0;i<result.size();i++){
                    if(!result.get(i).isSuccess()) {
                        Database.Error error = result.get(i).getErrors().get(0);
                        String failedDML = error.getMessage();
                        throw new AuraHandledException(failedDML);
                    }
                }
            }
            return countnp;
        } catch(Exception ex){
            throw new AurahandledException(ex.getDmlMessage(0));
        }    
    }
    
    @AuraEnabled
    global static integer deleteSelectedSpecialtyRecords(String spPrId)  {
        List <Specialty_Pricing__c> recordsToDelete = [SELECT Id,LOB__c,Year__c FROM Specialty_Pricing__c WHERE Id = : spPrId];
        try{
            //delete recordsToDelete;
            integer countsp = 0;
            if(recordsToDelete != null && !recordsToDelete.isEmpty()) {
                List <Specialty_Pricing__c> sp = [
                    SELECT Id  FROM Specialty_Pricing__c WHERE Id = : spPrId
                ];   
                if(sp != null && !sp.isEmpty()) {
                    countsp =  sp.size();
                }
                List<Database.DeleteResult> result = Database.delete(recordsToDelete, false);
                for(Integer i=0;i<result.size();i++){
                    if(!result.get(i).isSuccess()) {
                        Database.Error error = result.get(i).getErrors().get(0);
                        String failedDML = error.getMessage();
                        throw new AuraHandledException(failedDML);
                    }
                }
            }
            return countsp;
        } catch(Exception ex){
            throw new AurahandledException(ex.getDmlMessage(0));
        }    
    }
    
    
    @AuraEnabled
    global static integer deleteSelectedmailRecords(String mailprId)  {
        List <Mail_Pricing__c> recordsToDelete = [SELECT Id,LOB__c,Year__c,FAF_Mail_Operations__c FROM Mail_Pricing__c WHERE Id = : mailprId];
        try{
            //delete recordsToDelete;
            integer countmp = 0;
            if(recordsToDelete != null && !recordsToDelete.isEmpty()) {
                List <Mail_Pricing__c> mp = [
                    SELECT Id  FROM Mail_Pricing__c WHERE FAF_Mail_Operations__c = :recordsToDelete[0].FAF_Mail_Operations__c
                    and LOB__c=:recordsToDelete[0].LOB__c
                ];   
                if(mp != null && !mp.isEmpty()) {
                    countmp =  mp.size();
                }
                List<Database.DeleteResult> result = Database.delete(recordsToDelete, false);
                for(Integer i=0;i<result.size();i++){
                    if(!result.get(i).isSuccess()) {
                        Database.Error error = result.get(i).getErrors().get(0);
                        String failedDML = error.getMessage();
                        throw new AuraHandledException(failedDML);
                    }
                }
            }
            return countmp;
        } catch(Exception ex){
            throw new AurahandledException(ex.getDmlMessage(0));
        }    
    }
    
    @AuraEnabled
    global static integer deletSpecialtypricinggrid(String fafid, String recId, String opId, String phBenefit)  {
        system.debug('fafid----------'+fafid);
        system.debug('recId----------'+recId); 
        Integer delSeq;
        Map<Integer, List<Specialty_Pricing__c>> seqToAllRebateMap =  new Map<Integer, List<Specialty_Pricing__c>>();
        Map<Integer, List<Specialty_Sequence_Setting__c>> seqToAllRebateGDMap =  new Map<Integer, List<Specialty_Sequence_Setting__c>>();
        Map<String, Specialty_Pricing__c> updateRebateMap =  new Map<String, Specialty_Pricing__c>();
        Map<String, Specialty_Sequence_Setting__c> updateRebateGDMap =  new Map<String, Specialty_Sequence_Setting__c>();
        List <Specialty_Pricing__c> recordsToDelete = [
            SELECT Id,LOB__c,Year__c,Specialty_Operations__c,Sequence_Number__c,Composite_Key__c,FAF_ID__c FROM Specialty_Pricing__c WHERE Specialty_Operations__c = :opId and Pharmacy_Benefit__c =:phBenefit
        ];
        system.debug('recordsToDelete----------'+recordsToDelete);
        try {
            //delete recordsToDelete;
            integer countsp = 0;
            if(recordsToDelete != null && !recordsToDelete.isEmpty()) {
                if(recordsToDelete != null && !recordsToDelete.isEmpty()) {
                    countsp =  recordsToDelete.size();
                }
                opId = recordsToDelete[0].Specialty_Operations__c;
                delSeq = Integer.valueOf(recordsToDelete[0].Sequence_Number__c);
                
                if(delSeq != null){
                    for(Specialty_Pricing__c rg : [
                        Select Id, Composite_Key__c, Sequence_Number__c, Specialty_Operations__c 
                        from Specialty_Pricing__c 
                        Where Specialty_Operations__c = : opId and Sequence_Number__c > :delSeq
                    ]){
                        if(seqToAllRebateMap.containsKey(Integer.valueOf(rg.Sequence_Number__c))){
                            seqToAllRebateMap.get(Integer.valueOf(rg.Sequence_Number__c)).add(rg);
                        } else {
                            list<Specialty_Pricing__c> temp = new list<Specialty_Pricing__c>();
                            temp.add(rg);
                            seqToAllRebateMap.put(Integer.valueOf(rg.Sequence_Number__c), temp);
                        }
                    }
                    
                    for(Specialty_Sequence_Setting__c rgd : [
                        Select Id, Composite_Key__c, Sequence_Number__c, Specialty_Operations__c 
                        from Specialty_Sequence_Setting__c 
                        Where Specialty_Operations__c = : opId and Sequence_Number__c > :delSeq
                    ]){
                        if(seqToAllRebateGDMap.containsKey(Integer.valueOf(rgd.Sequence_Number__c))){
                            seqToAllRebateGDMap.get(Integer.valueOf(rgd.Sequence_Number__c)).add(rgd);
                        } else {
                            list<Specialty_Sequence_Setting__c> temp = new list<Specialty_Sequence_Setting__c>();
                            temp.add(rgd);
                            seqToAllRebateGDMap.put(Integer.valueOf(rgd.Sequence_Number__c), temp);
                        }
                    }
                    
                    for(Integer i : seqToAllRebateMap.keySet()){
                        for(Specialty_Pricing__c rg : seqToAllRebateMap.get(i)){
                            rg.Sequence_Number__c = rg.Sequence_Number__c - 1;
                            updateRebateMap.put(rg.Id, rg);
                        }
                    }
                    for(Integer i : seqToAllRebateGDMap.keySet()){
                        for(Specialty_Sequence_Setting__c rgd : seqToAllRebateGDMap.get(i)){
                            rgd.Sequence_Number__c = rgd.Sequence_Number__c - 1;
                            updateRebateGDMap.put(rgd.Id, rgd);
                        }
                    }
                    
                    if(!updateRebateGDMap.values().isEmpty()){
                        Database.SaveResult[] srList = Database.update(updateRebateGDMap.values(), false);
                    }
                    if(!updateRebateMap.values().isEmpty()){
                        Database.SaveResult[] srList = Database.update(updateRebateMap.values(), false);
                    }
                }
                
                List<Database.DeleteResult> result = Database.delete(recordsToDelete, false);
                for(Integer i=0;i<result.size();i++){
                    if(!result.get(i).isSuccess()) {
                        Database.Error error = result.get(i).getErrors().get(0);
                        String failedDML = error.getMessage(); 
                        //throw new AuraHandledException(failedDML);
                    }
                }
            }
            return countsp;
        } catch(Exception ex){
            throw new AurahandledException(ex.getDmlMessage(0));
        }    
    }
    //Delete Rebate Guarantee
    @AuraEnabled
    global static integer deleteRebategrid(String fafid,String plan,String basis,String nonspecForm,String gstp,String specForm, boolean gridoption, String TierValues)  {
        List<String> str=new List<String>();
        System.debug('TierValues'+TierValues);
        Map<Integer, List<Rebate_Guarantees__c>> seqToAllRebateMap =  new Map<Integer, List<Rebate_Guarantees__c>>();
        Map<Integer, List<Rebate_Guarantee_Denorm__c>> seqToAllRebateGDMap =  new Map<Integer, List<Rebate_Guarantee_Denorm__c>>();
        
        Map<String, Rebate_Guarantees__c> updateRebateMap =  new Map<String, Rebate_Guarantees__c>();
        Map<String, Rebate_Guarantee_Denorm__c> updateRebateGDMap =  new Map<String, Rebate_Guarantee_Denorm__c>();
        
        if(TierValues.contains('3 TIER NON-QUALIFYING')){
            str.add('3 TIER NON-QUALIFYING');
        }
        if(TierValues.contains('2 TIER QUALIFYING')){
            str.add('2 TIER QUALIFYING');
        }
        if(TierValues.contains('3 TIER QUALIFYING')){
            str.add('3 TIER QUALIFYING');
        }
        if(TierValues.contains('CLOSED')){
            str.add('CLOSED');
        }
        
        System.debug('strstr'+str);
        String opId;
        Integer delSeq;
        List <Rebate_Guarantees__c> recordsToDelete;
        
        if(gridoption==true){
            recordsToDelete = [
                SELECT Id,Year__c,Plan_Design__c,FAF_ID__c,Non_Specialty_Formulary_2__c,Specialty_Formulary__c,GSTP__c ,Rebate_Operations__c, Sequence_Number__c
                FROM Rebate_Guarantees__c 
                WHERE Non_Specialty_Formulary_2__c=:nonspecForm and GSTP__c=:gstp and FAF_ID__c=:fafid
            ];
        } else{
            recordsToDelete = [
                SELECT Id,Year__c,Plan_Design__c,FAF_ID__c,Non_Specialty_Formulary_2__c,Specialty_Formulary__c,GSTP__c, Rebate_Operations__c, Sequence_Number__c 
                FROM Rebate_Guarantees__c 
                WHERE Non_Specialty_Formulary_2__c=:nonspecForm and GSTP__c=:gstp and FAF_ID__c=:fafid
            ];   
        }
        
        try {
            //delete recordsToDelete;
            integer countsp = 0;
            if(recordsToDelete != null && !recordsToDelete.isEmpty()) {
                if(recordsToDelete != null && !recordsToDelete.isEmpty()) {
                    countsp =  recordsToDelete.size();
                }
                
                opId = recordsToDelete[0].Rebate_Operations__c;
                delSeq = Integer.valueOf(recordsToDelete[0].Sequence_Number__c);
                
                if(delSeq != null){
                    for(Rebate_Guarantees__c rg : [
                        Select Id, Composite_Key__c, Sequence_Number__c, Rebate_Operations__c 
                        from Rebate_Guarantees__c 
                        Where Rebate_Operations__c = : opId and Sequence_Number__c > :delSeq
                    ]){
                        if(seqToAllRebateMap.containsKey(Integer.valueOf(rg.Sequence_Number__c))){
                            seqToAllRebateMap.get(Integer.valueOf(rg.Sequence_Number__c)).add(rg);
                        } else {
                            list<Rebate_Guarantees__c> temp = new list<Rebate_Guarantees__c>();
                            temp.add(rg);
                            seqToAllRebateMap.put(Integer.valueOf(rg.Sequence_Number__c), temp);
                        }
                    }
                    
                    for(Rebate_Guarantee_Denorm__c rgd : [
                        Select Id, Composite_Key__c, Sequence_Number__c, Rebate_Operations__c 
                        from Rebate_Guarantee_Denorm__c 
                        Where Rebate_Operations__c = : opId and Sequence_Number__c > :delSeq
                    ]){
                        if(seqToAllRebateGDMap.containsKey(Integer.valueOf(rgd.Sequence_Number__c))){
                            seqToAllRebateGDMap.get(Integer.valueOf(rgd.Sequence_Number__c)).add(rgd);
                        } else {
                            list<Rebate_Guarantee_Denorm__c> temp = new list<Rebate_Guarantee_Denorm__c>();
                            temp.add(rgd);
                            seqToAllRebateGDMap.put(Integer.valueOf(rgd.Sequence_Number__c), temp);
                        }
                    }
                    
                    for(Integer i : seqToAllRebateMap.keySet()){
                        for(Rebate_Guarantees__c rg : seqToAllRebateMap.get(i)){
                            rg.Sequence_Number__c = rg.Sequence_Number__c - 1;
                            updateRebateMap.put(rg.Id, rg);
                        }
                    }
                    for(Integer i : seqToAllRebateGDMap.keySet()){
                        for(Rebate_Guarantee_Denorm__c rgd : seqToAllRebateGDMap.get(i)){
                            rgd.Sequence_Number__c = rgd.Sequence_Number__c - 1;
                            updateRebateGDMap.put(rgd.Id, rgd);
                        }
                    }
                    
                    if(!updateRebateGDMap.values().isEmpty()){
                        Database.SaveResult[] srList = Database.update(updateRebateGDMap.values(), false);
                    }
                    if(!updateRebateMap.values().isEmpty()){
                        Database.SaveResult[] srList = Database.update(updateRebateMap.values(), false);
                    }
                }
                
                
                List<Database.DeleteResult> result = Database.delete(recordsToDelete, false);
                for(Integer i=0;i<result.size();i++){
                    if(!result.get(i).isSuccess()) {
                        Database.Error error = result.get(i).getErrors().get(0);
                        String failedDML = error.getMessage(); 
                        throw new AuraHandledException(failedDML);
                    }
                }
            }
            return countsp;
        } catch(Exception ex){
            throw new AurahandledException(ex.getDmlMessage(0));
        }    
    }
    
    @AuraEnabled
    global static integer deletemailpricinggrid(String fafid, String lob)  {
        List <Mail_Pricing__c> recordsToDelete = [SELECT Id,LOB__c,Year__c,FAF_Mail_Operations__c,FAF_ID__c FROM Mail_Pricing__c WHERE FAF_ID__c = : fafid and LOB__c = :lob];
        try {
            //delete recordsToDelete;
            integer countmp = 0;
            if(recordsToDelete != null && !recordsToDelete.isEmpty()) {
                List <Mail_Pricing__c> mp = [
                    SELECT Id  FROM Mail_Pricing__c WHERE FAF_Mail_Operations__c = :recordsToDelete[0].FAF_Mail_Operations__c
                    and LOB__c=:recordsToDelete[0].LOB__c
                ];   
                if(mp != null && !mp.isEmpty()) {
                    countmp =  mp.size();
                }
                List<Database.DeleteResult> result = Database.delete(recordsToDelete, false);
                for(Integer i=0;i<result.size();i++){
                    if(!result.get(i).isSuccess()) {
                        Database.Error error = result.get(i).getErrors().get(0);
                        String failedDML = error.getMessage(); 
                        throw new AuraHandledException(failedDML);
                    }
                }
            }
            return countmp;
        } catch(Exception ex){
            throw new AurahandledException(ex.getDmlMessage(0));
        }    
    }
    
    @AuraEnabled
    global static void deleteClinicalSolgrid(String fafid)  {
        List <Clinical_Solutions__c> recordsToDelete = [SELECT Id  FROM Clinical_Solutions__c WHERE FAF_ID__c = : fafid];
        try {
            delete recordsToDelete;
        } catch(Exception ex){
            throw new AurahandledException(ex.getDmlMessage(0));
        }    
    }
    
    @AuraEnabled
    global static Integer get_saveRebatedata(Rebate_Guarantees__c rb) {
        try  {
                integer rtn = 0;
                Rebate_Guarantees__c lnp;
                lnp = rb;
                //Database.upsert(lnp); 
            if(rb.Id != null)
            {
             Database.SaveResult result = Database.update(lnp, false);
                if(!result.isSuccess()) {
                    throw new AuraHandledException(result.getErrors()[0].getMessage());
                }
             }
            else
            {
            Database.UpsertResult result1 = Database.upsert(lnp, false);   
            if(!result1.isSuccess()) {
            throw new AuraHandledException(result1.getErrors()[0].getMessage());
            }
            }
                return rtn;
        }catch(Dmlexception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    @AuraEnabled
    global static Integer get_InsertRebatedata(Rebate_Guarantees__c rb) {
        try  {
                integer rtn = 0;
                Rebate_Guarantees__c lnp=new Rebate_Guarantees__c();
                lnp =rb.clone(false);
                Database.SaveResult result = Database.insert(lnp, false);
                if(!result.isSuccess()) {
                    throw new AuraHandledException(result.getErrors()[0].getMessage());
                }
            return rtn;
        }      
        catch(Dmlexception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    @AuraEnabled
    global static Integer get_savedata(Network_Pricing__c np)  {
        try {
            integer rtn = 0;
            List<Network_Pricing__c> rnp = [
                Select Id from Network_Pricing__c where Network_Name__c= :np.Network_Name__c and
                Network_Type__c = :np.Network_Type__c and Year__c = :np.Year__c and LOB__c = :np.LOB__c
                and Custom_Network_Description__c = :np.Custom_Network_Description__c and FAF_ID__c=:np.FAF_ID__c and Id != :np.Id
            ];
            List<SelectOption> OrdinalMap = new List<SelectOption>();
            List<String>  OrdinalStr = new List<String>();
            String nordinal;
            if (np.Network_Name__c != null) {
                OrdinalMap = getDependentSelectOptions( 'Network_Pricing__c', 'network_name__c','retail_network_ordinal__c',np.Network_Name__c);  
            }
            for(SelectOption so : OrdinalMap) {
                OrdinalStr.add(so.getValue());
            }
            nordinal = OrdinalStr[0];
            np.Retail_Network_Ordinal__c=nordinal;
            if (rnp != null && !rnp.isEmpty()) {
                rtn = 1;
            } else {
                rtn = 0;
                Network_Pricing__c lnp;
                lnp = np;
                //Database.upsert(lnp); 
                if(np.Id != null) {
                    Database.SaveResult result = Database.update(lnp, false);
                    if(!result.isSuccess()) {
                        throw new AuraHandledException(result.getErrors()[0].getMessage());
                    }
                } else {
                    Database.UpsertResult result1 = Database.upsert(lnp, false);   
                    if(!result1.isSuccess()) {
                        throw new AuraHandledException(result1.getErrors()[0].getMessage());
                    }
                }
            }
            return rtn;
        } catch(Dmlexception e) {
            throw new AuraHandledException(e.getMessage());
        } 
    }
    
    @AuraEnabled
    global static integer get_createdata(String fafid, String nname, String ntype, String lob, String des) {
        try {
            List<Network_Pricing__c> npr = new List<Network_Pricing__c>();
            List<SelectOption> OrdinalMap = new List<SelectOption>();
            List<String>  OrdinalStr = new List<String>();
            String nordinal;
            if (nname != null) {
                OrdinalMap = getDependentSelectOptions( 'Network_Pricing__c', 'network_name__c','retail_network_ordinal__c',nname);  
            }
            for(SelectOption so : OrdinalMap) {
                OrdinalStr.add(so.getValue());
            }
            nordinal = OrdinalStr[0];
            if (nname == 'Custom' || nname == 'Custom Secondary') {
                npr = [Select Year__c,Network_Name__c,Network_Type__c,LOB__c,Custom_Network_Description__c, 
                       FAF_Network_Ops__r.Network_Pricing_Max_Seq__c, FAF_Network_Ops__r.Network_Pricing_Min_Seq__c from Network_Pricing__c
                       Where Network_Name__c = :nname And Network_Type__c= :ntype And LOB__c= :lob And Custom_Network_Description__c= :des
                       And FAF_Network_Ops__c = :fafid];
            } else {
                npr = [Select Year__c,Network_Name__c,Network_Type__c,LOB__c,Custom_Network_Description__c , 
                       FAF_Network_Ops__r.Network_Pricing_Max_Seq__c, FAF_Network_Ops__r.Network_Pricing_Min_Seq__c from Network_Pricing__c
                       Where Network_Name__c = :nname And Network_Type__c= :ntype  And LOB__c= :lob And FAF_Network_Ops__c = :fafid];    
            }
            List<Network_Pricing__c> lnpc = new List<Network_Pricing__c>();
            if (npr == null || npr.isEmpty()) {
                List<Network_Operations__c> nops = [SELECT FAF_ID__c from Network_Operations__c where ID=:fafid]; 
                String noperation;
                if (nops != null && !nops.isEmpty()) {
                    noperation = nops[0].FAF_ID__c;
                }
                List<Client_Information__c>  clientinfo = [SELECT ID,Year_1__c,Year_2__c,Year_3__c,Year_4__c,Year_5__c from Client_Information__c where FAF_ID__c=:noperation];
                
                for(Client_Information__c cinfo: clientinfo){  {
                    Network_Pricing__c lnp = new Network_Pricing__c();
                    lnp.Network_Name__c = nname;
                    lnp.Network_Type__c = ntype;
                    lnp.LOB__c = lob;
                    lnp.Custom_Network_Description__c = des;
                    lnp.Year__c = '1';
                    lnp.FAF_ID__c = noperation;
                    lnp.FAF_Network_Ops__c = fafid;
                    lnp.Retail_Network_Ordinal__c = nordinal;
                    lnpc.add(lnp);
                } 
                                                             if (cinfo.Year_2__c == '2') {
                                                                 Network_Pricing__c lnp = new Network_Pricing__c();
                                                                 lnp.Network_Name__c = nname;
                                                                 lnp.Network_Type__c = ntype;
                                                                 lnp.LOB__c = lob;
                                                                 lnp.Custom_Network_Description__c = des;
                                                                 lnp.Year__c = '2';
                                                                 lnp.FAF_ID__c = noperation;
                                                                 lnp.FAF_Network_Ops__c = fafid;
                                                                 lnp.Retail_Network_Ordinal__c = nordinal;
                                                                 lnpc.add(lnp);
                                                             } 
                                                             if (cinfo.Year_3__c == '3') {
                                                                 Network_Pricing__c lnp = new Network_Pricing__c();
                                                                 lnp.Network_Name__c = nname;
                                                                 lnp.Network_Type__c = ntype;
                                                                 lnp.LOB__c = lob;
                                                                 lnp.Custom_Network_Description__c = des;
                                                                 lnp.Year__c = '3';
                                                                 lnp.FAF_ID__c = noperation;
                                                                 lnp.FAF_Network_Ops__c = fafid;
                                                                 lnp.Retail_Network_Ordinal__c = nordinal;
                                                                 lnpc.add(lnp);
                                                             } 
                                                             if (cinfo.Year_4__c == '4')  {
                                                                 Network_Pricing__c lnp = new Network_Pricing__c();
                                                                 lnp.Network_Name__c = nname;
                                                                 lnp.Network_Type__c = ntype;
                                                                 lnp.LOB__c = lob;
                                                                 lnp.Custom_Network_Description__c = des;
                                                                 lnp.Year__c = '4';
                                                                 lnp.FAF_ID__c = noperation;
                                                                 lnp.FAF_Network_Ops__c = fafid;
                                                                 lnp.Retail_Network_Ordinal__c = nordinal;
                                                                 lnpc.add(lnp);
                                                             } 
                                                             if (cinfo.Year_5__c == '5') {
                                                                 Network_Pricing__c lnp = new Network_Pricing__c();
                                                                 lnp.Network_Name__c = nname;
                                                                 lnp.Network_Type__c = ntype;
                                                                 lnp.LOB__c = lob;
                                                                 lnp.Custom_Network_Description__c = des;
                                                                 lnp.Year__c = '5';
                                                                 lnp.FAF_ID__c = noperation;
                                                                 lnp.FAF_Network_Ops__c = fafid;
                                                                 lnp.Retail_Network_Ordinal__c = nordinal;
                                                                 lnpc.add(lnp);
                                                             }
                                                             
                                                             if (cinfo.Year_1__c == null && cinfo.Year_2__c == null && cinfo.Year_3__c == null && cinfo.Year_4__c == null && cinfo.Year_5__c == null) {
                                                                 Network_Pricing__c lnp = new Network_Pricing__c();
                                                                 lnp.Network_Name__c = nname;
                                                                 lnp.Network_Type__c = ntype;
                                                                 lnp.LOB__c = lob;
                                                                 lnp.Custom_Network_Description__c = des;
                                                                 lnp.Year__c = 'All';
                                                                 lnp.FAF_ID__c = noperation;
                                                                 lnp.FAF_Network_Ops__c = fafid;
                                                                 lnp.Retail_Network_Ordinal__c = nordinal;
                                                                 lnpc.add(lnp);
                                                             } 
                                                            }
                
                //Database.insert(lnpc); 
                List<Database.SaveResult> result = Database.Insert(lnpc, false);
                for(Integer i=0;i<result.size();i++){
                    if(!result.get(i).isSuccess()) {
                        Database.Error error = result.get(i).getErrors().get(0);
                        String failedDML = error.getMessage();
                        throw new AuraHandledException(failedDML);
                    }
                }
                return 0;
            } else {
                return 1;   
            }
        } catch(Dmlexception e){
            throw new AuraHandledException(e.getMessage());   
        } 
    }
    
    @AuraEnabled
    global static integer get_yearcount(String fafid) {
        try {
            integer cntyear=0;
            List<Client_Information__c>  clientinfo = [SELECT ID,Year_1__c,Year_2__c,Year_3__c,Year_4__c,Year_5__c from Client_Information__c where FAF_ID__c=:fafid];
            for(Client_Information__c cinfo: clientinfo){ 
                if (cinfo.Year_1__c == '1') {
                    cntyear = 1;
                }
                if (cinfo.Year_2__c == '2') {
                    cntyear = 2;
                }
                if (cinfo.Year_3__c == '3') {
                    cntyear = 3;
                }
                if (cinfo.Year_4__c == '4') {
                    cntyear = 4;
                }
                if (cinfo.Year_5__c == '5') {
                    cntyear = 5;
                }
            }
            return cntyear;
        } catch(Dmlexception e){
            throw new AuraHandledException(e.getMessage());   
        }
    }
    
    @AuraEnabled
    global static integer get_yearcountali(String ali) {
        try {
            integer cntyear=0;
            List<Client_Information__c>  clientinfo = [SELECT ID,Year_1__c,Year_2__c,Year_3__c,Year_4__c,Year_5__c from Client_Information__c where  Agreement_Line_Item__c=:ali];
            for(Client_Information__c cinfo: clientinfo){ 
                if (cinfo.Year_1__c == '1')  {
                    cntyear = 1;
                }
                if (cinfo.Year_2__c == '2') {
                    cntyear = 2;
                }
                if (cinfo.Year_3__c == '3') {
                    cntyear = 3;
                }
                if (cinfo.Year_4__c == '4') {
                    cntyear = 4;
                }
                if (cinfo.Year_5__c == '5') {
                    cntyear = 5;
                }
            }
            return cntyear;
        }  catch(Dmlexception e){
            throw new AuraHandledException(e.getMessage());   
        }
    }    
    
    @AuraEnabled
    global static integer get_copydata(Network_Pricing__c np, String nname, String ntype, String lob, String des) {
        try {
            List<Network_Pricing__c> npr = new List<Network_Pricing__c>();
            List<SelectOption> OrdinalMap = new List<SelectOption>();
            List<String>  OrdinalStr = new List<String>();
            String nordinal;
            if (nname != null) {
                OrdinalMap = getDependentSelectOptions( 'Network_Pricing__c', 'network_name__c','retail_network_ordinal__c',nname);  
            }
            for(SelectOption so : OrdinalMap) {
                OrdinalStr.add(so.getValue());
            }
            nordinal = OrdinalStr[0];
            if (nname == 'Custom' || nname == ' Custom Secondary')  {
                npr = [
                    Select Year__c,Network_Name__c,Network_Type__c,LOB__c,Custom_Network_Description__c,
                    FAF_Network_Ops__r.Network_Pricing_Max_Seq__c, FAF_Network_Ops__r.Network_Pricing_Min_Seq__c from Network_Pricing__c
                    Where Network_Name__c = :nname And Network_Type__c= :ntype And LOB__c= :lob And Custom_Network_Description__c= :des
                    And FAF_ID__c = :np.FAF_ID__c And Year__c = :np.Year__c
                ];
            } else {
                npr = [
                    Select Year__c,Network_Name__c,Network_Type__c,LOB__c,Custom_Network_Description__c from Network_Pricing__c
                    Where Network_Name__c = :nname And Network_Type__c= :ntype And LOB__c= :lob  And FAF_ID__c = :np.FAF_ID__c
                    And Year__c = :np.Year__c
                ];    
            }
            if (npr == null || npr.isEmpty()) {
                Network_Pricing__c lnp = new Network_Pricing__c();
                lnp.Network_Name__c = np.Network_Name__c;
                lnp.Network_Type__c = np.Network_Type__c;
                lnp.LOB__c = np.LOB__c;
                lnp.Custom_Network_Description__c = np.Custom_Network_Description__c;
                lnp.Year__c = np.Year__c;
                lnp.FAF_ID__c = np.FAF_ID__c;
                lnp.Brand_Rate__c = np.Brand_Rate__c;
                lnp.Preferred_Brand_Rate__c = np.Preferred_Brand_Rate__c;
                lnp.Non_Preferred_Brand_Rate__c = np.Non_Preferred_Brand_Rate__c;
                lnp.Generic_Rate__c = np.Generic_Rate__c;
                lnp.GER_Guarantee_Rate__c = np.GER_Guarantee_Rate__c;
                lnp.MER_Guarantee_Rate__c = np.MER_Guarantee_Rate__c;
                lnp.BER_Guarantee_Rate__c = np.BER_Guarantee_Rate__c;
                lnp.NED_Guarantee_Rate__c = np.NED_Guarantee_Rate__c;
                lnp.Custom_Description__c = np.Custom_Description__c;
                lnp.SSG_Guarantee_Rate__c = np.SSG_Guarantee_Rate__c;
                lnp.Non_MAC_Generic_Rate__c = np.Non_MAC_Generic_Rate__c;
                lnp.Brand_Dispensing_Fee__c = np.Brand_Dispensing_Fee__c;
                lnp.Generic_Dispensing_Fee__c = np.Generic_Dispensing_Fee__c;
                lnp.Generic_Basis__c = np.Generic_Basis__c;
                lnp.FAF_Network_Ops__c = np.FAF_Network_Ops__c;
                lnp.Agreement__c = np.Agreement__c;
                lnp.Agreement_Line_Item__c = np.Agreement_Line_Item__c;
                lnp.Year_Begin_Date__c = np.Year_Begin_Date__c;
                lnp.Year_End_Date__c = np.Year_End_Date__c;   
                lnp.Brand_Basis__c = np.Brand_Basis__c;  
                lnp.Generic_Basis__c = np.Generic_Basis__c; 
                lnp.Retail_Network_Ordinal__c = nordinal;
                //Database.insert(lnp); 
                Database.SaveResult result = Database.insert(lnp, false);
                if(!result.isSuccess()) {
                    throw new AuraHandledException(result.getErrors()[0].getMessage());
                }
                return 0;
            } else {
                return 1;   
            } 
        } catch(Dmlexception e){
            throw new AuraHandledException(e.getMessage());   
        } 
    }
    
    @AuraEnabled
    global static Integer get_savemaildata(Mail_Pricing__c mp) {
        try {
            integer rtn = 0;
            List<Mail_Pricing__c> rmp;
           if(mp.Id != null) {
            rmp = [
                Select Id from Mail_Pricing__c where Year__c = :mp.Year__c and LOB__c = :mp.LOB__c
                and FAF_ID__c=:mp.FAF_ID__c and Id != :mp.Id 
            ];
            }
           if(mp.Id == null) {
            List<Mail_Pricing__c> dmp = [
                Select Id from Mail_Pricing__c where Year__c = :mp.Year__c and LOB__c = :mp.LOB__c
                and FAF_ID__c=:mp.FAF_ID__c LIMIT 1 
            ];
            if (dmp != null && !dmp.isEmpty()) {
                mp.Id = dmp[0].Id;
            } 
            }
            if (rmp != null && !rmp.isEmpty()) {
                rtn = 1;
            }  else {
                rtn = 0;
                Mail_Pricing__c lmp;
                lmp = mp;
                //Database.upsert(lmp); 
                if(mp.Id != null) {
                    Database.SaveResult result = Database.update(lmp, false);
                    if(!result.isSuccess()) {
                        throw new AuraHandledException(result.getErrors()[0].getMessage());
                    }
                } else {
                    Database.UpsertResult result1 = Database.upsert(lmp, false);   
                    if(!result1.isSuccess()) {
                        throw new AuraHandledException(result1.getErrors()[0].getMessage());
                    }
                }
         
             }  
          return rtn;
        } catch(Dmlexception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    @AuraEnabled
    global static void get_savemaildatalist(List<Mail_Pricing__c> mp, String opid) {
        try {
             List<Mail_Pricing__c> mpupd = new List<Mail_Pricing__c>();
             List<Mail_Pricing__c> mpins = new List<Mail_Pricing__c>();
              for (Mail_Pricing__c mpupsert : mp)
                 {
                   if(mpupsert.Id == null) {
                        List<Mail_Pricing__c> dmp = [
                        Select Id from Mail_Pricing__c where Year__c = :mpupsert.Year__c and LOB__c = :mpupsert.LOB__c
                        and FAF_ID__c=:mpupsert.FAF_ID__c LIMIT 1 
                          ];
                        if (dmp != null && !dmp.isEmpty()) {
                        mpupsert.Id = dmp[0].Id;
                             } 
                         }
                 
                 
                   if (mpupsert.FAF_Mail_Operations__c == null)
                   {
                     mpupsert.FAF_Mail_Operations__c = opid;
                   }
                   if(mpupsert.Id != null) 
                   {
                    mpupd.add(mpupsert);
                   }
                   else
                   {
                   mpins.add(mpupsert);
                   }
                 }
                  ConstantsUtil.OFF_TRIGGERS_DUPLICATECHECK = false;
                  if (mpupd != null && !mpupd.isEmpty())
                  {
                  List<Database.SaveResult> result = Database.update(mpupd, false);   
                   for(Integer i=0;i<result.size();i++){
                    if(!result.get(i).isSuccess()) {
                        Database.Error error = result.get(i).getErrors().get(0);
                        String failedDML = error.getMessage(); 
                        throw new AuraHandledException(failedDML);
                    }
                  }
                  }
                  if (mpins != null && !mpins.isEmpty())
                  {
                   List<Database.UpsertResult> result1 = Database.upsert(mpins, false);   
                   for(Integer i=0;i<result1.size();i++){
                    if(!result1.get(i).isSuccess()) {
                        Database.Error error = result1.get(i).getErrors().get(0);
                        String failedDML = error.getMessage(); 
                        throw new AuraHandledException(failedDML);
                    }
                }
                } 
           ConstantsUtil.OFF_TRIGGERS_DUPLICATECHECK = true;
        } catch(Dmlexception e) {
            ConstantsUtil.OFF_TRIGGERS_DUPLICATECHECK = true;
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    @AuraEnabled
    global static Integer get_saveSpecialtydata(Specialty_Pricing__c sp, String opid) {
        system.debug('sp.FAF_ID__c-------'+sp.FAF_ID__c);
        system.debug('opid-------'+opid);
        try {
            integer rtn = 0;
            
            List<Specialty_Operations__c > opsp = [
                Select Id, Pharmacy_Benefit__c from Specialty_Operations__c  where Id =:opid
            ];
            if (sp != null ) {
                if(!opsp.isEmpty() && opsp[0].Pharmacy_Benefit__c != 'Client Choice' && opsp[0].Pharmacy_Benefit__c != sp.Pharmacy_Benefit__c ){
                    opsp[0].Pharmacy_Benefit__c = 'Client Choice';
                    update opsp;
                }
                rtn = 0;
                
                if(sp.Id != null) {
                    Database.SaveResult result = Database.update(sp, false);
                    if(!result.isSuccess()) {
                        throw new AuraHandledException(result.getErrors()[0].getMessage());
                    }
                } else {
                    if(String.isNotBlank(opid)){
                        sp.Specialty_Operations__c = opid;
                    }
                    Database.UpsertResult result1 = Database.upsert(sp, false);   
                    if(!result1.isSuccess()) {
                        throw new AuraHandledException(result1.getErrors()[0].getMessage());
                    }
                }
            }
            return rtn;
        } catch(Dmlexception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    @AuraEnabled
    global static void get_updatestatus(String stageName , String recordId) {
        try {
            Apttus__APTS_Agreement__c agg = [Select Id ,Internal_Review_Completed__c,PCD_Status__c,Status_In_Progress__c from Apttus__APTS_Agreement__c where Id=:recordId] ; 
            agg.PCD_Status__c =stageName ; 
            agg.Status_In_Progress__c = stageName;
            if (stageName=='Generate Document') {
                agg.Internal_Review_Completed__c =true;
            } else {
                agg.Internal_Review_Completed__c =false;
            }
            update agg ; 
        } catch(exception e){
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    @AuraEnabled
    global static String get_status(String recordId) {
        try {
            Apttus__APTS_Agreement__c agg = [Select Id ,Internal_Review_Completed__c,PCD_Status__c,Status_In_Progress__c from Apttus__APTS_Agreement__c where Id=:recordId] ; 
            String status;
            if (agg != null) {
                status = agg.PCD_Status__c ; 
            } else {
                status = null;    
            }
            return status; 
        } catch(exception e){
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    @AuraEnabled
    global static String get_account(String recordId)  {
        try  {
            Apttus__APTS_Agreement__c agg = [Select Id ,iUMS_Task__c,Apttus__Account__c from Apttus__APTS_Agreement__c where Id=:recordId] ; 
            String accountid;
            String taskid;
            if (agg != null )  {
                accountid = agg.Apttus__Account__c; 
                taskid = agg.iUMS_Task__c;
            }
            else {
                accountid = null; 
                taskid = null;
            }
            return taskid; 
        } catch(exception e){
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    @AuraEnabled
    global static String get_lineitem(String RecId) {
        try {
            String ali;
            List<Apttus__APTS_Agreement__c> agg = [Select Id,Primary_Agreement_Line_Item__c from Apttus__APTS_Agreement__c where Id = :RecId]; 
            if (agg != null && !agg.isEmpty()) {
                ali = agg[0].Primary_Agreement_Line_Item__c; 
            }  else { ali='xx';}
            return ali;
        } catch(exception e){
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    @AuraEnabled  
    public static List<picklistWrapper> findPicklistOptions(string objAPIName, string fieldAPIname) {
        list<picklistWrapper> returnValue = new list<picklistWrapper>();
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        // Get the object type of the SObject.
        Schema.sObjectType objType = schemaMap.get(objAPIName);
        // Describe the SObject using its object type.
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
        // Get a map of fields for the SObject
        map < String, Schema.SObjectField > fieldMap = objDescribe.fields.getMap();
        // Get the list of picklist values for this field.
        list < Schema.PicklistEntry > values = fieldMap.get(fieldAPIname).getDescribe().getPickListValues();
        //pickListFieldWrapper picklistDetails = new pickListFieldWrapper();
        // Add these values to the selectoption list.
        for (Schema.PicklistEntry a: values) {
            picklistWrapper aa = new picklistWrapper();
            aa.pickListLabel = a.getLabel();
            aa.pickListValue = a.getValue();
            returnValue.add(aa);
        }
        return returnValue; 
    }
    public class picklistWrapper{
        @AuraEnabled 
        public string pickListLabel;
        @AuraEnabled 
        public string pickListValue;
        
    }
    
    /* ==============================================================================================================
* @Class Name      : getDependentSelectOptions
* @author            : Soumendu Chowdhury
* @created date      : 05/06/2019
* @Last modified by  : Soumendu Chowdhury
* @Last modified date: 05/06/2019
* @Purpose           : Method to identify Dependent picklist 'Retail Network Ordinal' of repesctive Network Name
==================================================================================================================*/
    public static List<SelectOption> getDependentSelectOptions(String objectType, String controllerName, String dependentFieldName, String parentValue) {
        List<SelectOption> dependentItems = new list<SelectOption>();
        if(null!=objectType && null!=controllerName && null!=dependentFieldName && null!=parentValue){
            Schema.DescribeFieldResult dependentField;
            Integer parentValueIndex = -1;
            
            //FIRST get the Parent PL's index value
            Schema.DescribeSObjectResult objectMeta = Schema.describeSObjects(new String[]{objectType})[0];
            Schema.SObjectField[] fields = objectMeta.fields.getMap().values();
            for (Schema.SObjectField f: fields) {
                Schema.DescribeFieldResult d = f.getDescribe();
                String fieldname = d.getName().toLowerCase();
                String ftype = String.valueOf(d.getType()).toLowerCase();
                if (fieldname.equals(controllerName.toLowerCase()) && ('picklist'.equals(ftype) || 'multipicklist'.equals(ftype))) {
                    Schema.PicklistEntry[] pplvalues = d.getPicklistValues();
                    for(Integer i=0; i<pplvalues.size(); i++) {
                        if(parentValue.equals(pplvalues[i].getValue())){
                            parentValueIndex = i;
                        }
                    }
                }
                if(fieldname.equals(dependentFieldName.toLowerCase()) && ('picklist'.equals(ftype) || 'multipicklist'.equals(ftype))) {
                    dependentField = d;
                }
            }
            
            //2nd get the dependent PL values mapped to the target parent PL's value
            if(-1!=parentValueIndex && null!=dependentField ){
                Schema.PicklistEntry[] plValues = dependentField.getPicklistValues();
                for (PicklistEntry plv: plValues) {
                    String jsonstr = JSON.serialize(plv);
                    Map<String,String> jMap = (Map<String,String>) JSON.deserialize(jsonstr, Map<String,String>.class);
                    String validFor = jMap.get('validFor');
                    String plvalue = jMap.get('value');
                    
                    List<Integer> bitValues = ConvertB64ToInts(validFor);
                    Integer bitMask = 32; // Ignore highest 2 bits
                    Integer intIndex = 0;
                    Integer bitIdx = 0;
                    for (Integer numBits = bitValues.size() * 6; numBits > 0; --numBits) {
                        Integer bits = bitValues[intIndex];
                        if ((bits & bitMask) == bitMask) {
                            if (bitIdx == parentValueIndex ) {
                                dependentItems.add(new SelectOption(plvalue, plvalue));
                            }
                        }
                        bitMask = bitMask >>> 1;
                        ++bitIdx;
                        
                        if (bitMask == 0) {
                            bitMask = 32;
                            intIndex = intIndex + 1;
                        }
                    }
                }
            }
        }
        return dependentItems;
    }
    /* ==============================================================================================================
* @Class Name      : getDependentSelectOptions1
* @author            : Mohit Srivastava
* @created date      : 10/06/2020
* @Last modified by  : Mohit Srivastava
* @Last modified date: 10/06/2020
* @Purpose           : Method to identify Dependent picklist 'Retail Network Ordinal' of repesctive Network Name
==================================================================================================================*/
@AuraEnabled
    public static List<CustomSelectOptions> getDependentSelectOptions1(String objectType, String controllerName, String dependentFieldName, String parentValue) {
        List<CustomSelectOptions> dependentItems = new list<CustomSelectOptions>();
        if(null!=objectType && null!=controllerName && null!=dependentFieldName && null!=parentValue){
            Schema.DescribeFieldResult dependentField;
            Integer parentValueIndex = -1;
            
            //FIRST get the Parent PL's index value
            Schema.DescribeSObjectResult objectMeta = Schema.describeSObjects(new String[]{objectType})[0];
            Schema.SObjectField[] fields = objectMeta.fields.getMap().values();
            for (Schema.SObjectField f: fields) {
                Schema.DescribeFieldResult d = f.getDescribe();
                String fieldname = d.getName().toLowerCase();
                String ftype = String.valueOf(d.getType()).toLowerCase();
                if (fieldname.equals(controllerName.toLowerCase()) && ('picklist'.equals(ftype) || 'multipicklist'.equals(ftype))) {
                    Schema.PicklistEntry[] pplvalues = d.getPicklistValues();
                    for(Integer i=0; i<pplvalues.size(); i++) {
                        if(parentValue.equals(pplvalues[i].getValue())){
                            parentValueIndex = i;
                        }
                    }
                }
                if(fieldname.equals(dependentFieldName.toLowerCase()) && ('picklist'.equals(ftype) || 'multipicklist'.equals(ftype))) {
                    dependentField = d;
                }
            }
            
            //2nd get the dependent PL values mapped to the target parent PL's value
            if(-1!=parentValueIndex && null!=dependentField ){
                Schema.PicklistEntry[] plValues = dependentField.getPicklistValues();
                for (PicklistEntry plv: plValues) {
                    String jsonstr = JSON.serialize(plv);
                    Map<String,String> jMap = (Map<String,String>) JSON.deserialize(jsonstr, Map<String,String>.class);
                    String validFor = jMap.get('validFor');
                    String plvalue = jMap.get('value');
                    
                    List<Integer> bitValues = ConvertB64ToInts(validFor);
                    Integer bitMask = 32; // Ignore highest 2 bits
                    Integer intIndex = 0;
                    Integer bitIdx = 0;
                    for (Integer numBits = bitValues.size() * 6; numBits > 0; --numBits) {
                        Integer bits = bitValues[intIndex];
                        if ((bits & bitMask) == bitMask) {
                            if (bitIdx == parentValueIndex ) {
                                dependentItems.add(new CustomSelectOptions(plvalue, plvalue));
                            }
                        }
                        bitMask = bitMask >>> 1;
                        ++bitIdx;
                        
                        if (bitMask == 0) {
                            bitMask = 32;
                            intIndex = intIndex + 1;
                        }
                    }
                }
            }
        }
        return dependentItems;
    }
    public class CustomSelectOptions{
        @AuraEnabled Public String label {get;set;}
        @AuraEnabled Public String value {get;set;}

        public CustomSelectOptions() {
            this.label = '';
            this.value = '';
        }

        public CustomSelectOptions(String lab, String val) {
            this.label = lab;
            this.value = val;
        }
    }
    
    private static Map<String, Integer> base64Vals = null;
    
    private static List<Integer> ConvertB64ToInts(string b64Str) {
        if (base64Vals == null) {
            base64Vals = new Map<String, Integer> {
                'A'=>00,'B'=>01,'C'=>02,'D'=>03,'E'=>04,'F'=>05,'G'=>06,'H'=>07,'I'=>08,'J'=>09,
                    'K'=>10,'L'=>11,'M'=>12,'N'=>13,'O'=>14,'P'=>15,'Q'=>16,'R'=>17,'S'=>18,'T'=>19,
                    'U'=>20,'V'=>21,'W'=>22,'X'=>23,'Y'=>24,'Z'=>25,'a'=>26,'b'=>27,'c'=>28,'d'=>29,
                    'e'=>30,'f'=>31,'g'=>32,'h'=>33,'i'=>34,'j'=>35,'k'=>36,'l'=>37,'m'=>38,'n'=>39,
                    'o'=>40,'p'=>41,'q'=>42,'r'=>43,'s'=>44,'t'=>45,'u'=>46,'v'=>47,'w'=>48,'x'=>49,
                    'y'=>50,'z'=>51,'0'=>52,'1'=>53,'2'=>54,'3'=>55,'4'=>56,'5'=>57,'6'=>58,'7'=>59,
                    '8'=>60,'9'=>61,'+'=>62,'/'=>63
                    };
                        }
        List<Integer> ints = new List<Integer>();
        for (Integer idx = 0; idx< b64Str.length(); ++idx) {
            String c = String.fromCharArray(new List<Integer> { b64Str.charAt(idx)});
            ints.add(base64Vals.get(c));
        }
        return ints;
    }  
    
    @AuraEnabled
    public static List < Apttus__APTS_Template__c > getTemplates(String pageSize, String pageNumber){
        List<Apttus__APTS_Template__c> templateList = [
            select id,Name,Apttus__Agreement_Types__c,Apttus__Guidance__c, Apttus__Category__c, Apttus__Subcategory__c from Apttus__APTS_Template__c 
            where Apttus__Agreement_Types__c='PCD' and Apttus__IsActive__c=true
            and Apttus__Agreement_Types__c='PCD' and Apttus__Type__c='Agreement'
            and Apttus__BusinessObject__c='Apttus__APTS_Agreement__c' 
        ];
        return templateList;
    }
    
    @AuraEnabled
    public static Apttus__DocumentVersionDetail__c generatedocument(String filename, String filetype, String agrid, String terms, String agreeterms, Integer proposalyear, Date pricingdate, Date duedate ){
        try {
            Apttus__DocumentVersionDetail__c Docversiondtlnew = new Apttus__DocumentVersionDetail__c();
            List<Apttus__DocumentVersionDetail__c> Docversiondtlupd = new List<Apttus__DocumentVersionDetail__c>();
            List<Apttus__DocumentVersion__c> Docvrs = [select id from Apttus__DocumentVersion__c where Apttus__AgreementId__c = :agrid ];
               
            Apttus__APTS_Agreement__c Agreerecord = [select id,Primary_Agreement_Line_Item__c,Task_SubType__c,PCD_Clause_Previous_Terms__c,Previous_Termed_Yes__c,Previous_Termed_No__c from Apttus__APTS_Agreement__c where Id = :agrid LIMIT 1 ];
            if (Agreerecord != null)
            {
               Agreerecord.PCD_Clause_Previous_Terms__c = agreeterms;
                Database.SaveResult resultagree = Database.update(Agreerecord, false);
                if(!resultagree.isSuccess()) {
                    throw new AuraHandledException(resultagree.getErrors()[0].getMessage());
                } 
                Apttus__AgreementLineItem__c Agreelinerecord = [select id,Previous_Terms__c,Proposal_Year__c,PCD_Clause_Previous_Terms__c,Pricing_Effective_Date__c,Escalating_Effective_Date__c,Due_Date__c from Apttus__AgreementLineItem__c where Id = :Agreerecord.Primary_Agreement_Line_Item__c LIMIT 1 ];
                 if (Agreelinerecord != null)
                {
                Agreelinerecord.Previous_Terms__c = terms;
                Agreelinerecord.Proposal_Year__c = proposalyear;
                Agreelinerecord.PCD_Clause_Previous_Terms__c = agreeterms;
                Agreelinerecord.Pricing_Effective_Date__c = pricingdate;
                Agreelinerecord.Due_Date__c = duedate;
                Database.SaveResult resultagreeline = Database.update(Agreelinerecord, false);
                if(!resultagreeline.isSuccess()) {
                    throw new AuraHandledException(resultagreeline.getErrors()[0].getMessage());
                } 
                }
            }
            Apttus__APTS_Template__c tpl = [
                Select Id,Next_Template__c, Apttus__IsActive__c,Apttus__BusinessObject__c,Apttus__ActiveVersionId__c,Apttus__ReferenceId__c from Apttus__APTS_Template__c 
                where Apttus__IsActive__c = True and Name= :Label.PCD_Template_Name LIMIT 1
            ];    
            Decimal maj = 1;
            Decimal minor = 0;
            Decimal revision =0;
            String nm;
            if (Docvrs == null || Docvrs.isEmpty()) 
            {
             Apttus__DocumentVersion__c Docversion = new Apttus__DocumentVersion__c();
             Docversion.Name = 'Generate Agreement';
             Docversion.Apttus__AgreementId__c = agrid;
             Docversion.Apttus__LatestVersion__c = '1.0.0';
             Docversion.Apttus__ReferenceId__c = tpl.Apttus__ReferenceId__c;
             Docversion.Apttus__TemplateId__c = tpl.Id;
             Docversion.Apttus__Title__c = filename;
             Database.SaveResult result = Database.insert(Docversion, false);
              if(!result.isSuccess()) {
                    throw new AuraHandledException(result.getErrors()[0].getMessage());
                } 
                
             Docvrs = [select id,Apttus__LatestVersion__c from Apttus__DocumentVersion__c where Apttus__AgreementId__c = :agrid ];   
            }
            if (Docvrs != null && !Docvrs.isEmpty()) {
                List<Apttus__DocumentVersionDetail__c> Docversiondtl = [
                    select id,Agreement__c,LOB_Detail__c,Name,Apttus__Title__c,Apttus__DocumentVersionId__c,
                    Apttus__VersionMajor__c,Apttus__VersionMinor__c,Apttus__VersionRevision__c
                    from Apttus__DocumentVersionDetail__c where Apttus__DocumentVersionId__c= :Docvrs[0].Id
                    order by Apttus__VersionMajor__c,Apttus__VersionMinor__c desc
                    Limit 1
                ];
                if (Docversiondtl != null && !Docversiondtl.isEmpty()) {
                    maj = Docversiondtl[0].Apttus__VersionMajor__c;
                    minor = Docversiondtl[0].Apttus__VersionMinor__c;
                    minor = minor + 1;
                     
                }
                nm = maj + '.' + minor + '.' + revision;
                String docinfo;
                if (filetype == 'docx')
                    docinfo = 'Draft';
                else
                    docinfo = 'Final';   
                    
                    
               List<Apttus__DocumentVersionDetail__c> Docversiondtlsubtype = [
                    select id,Agreement__c,LOB_Detail__c,Name,Apttus__Title__c,Apttus__DocumentVersionId__c,
                    Apttus__VersionMajor__c,Apttus__VersionMinor__c,Apttus__VersionRevision__c
                    from Apttus__DocumentVersionDetail__c where Apttus__DocumentVersionId__c= :Docvrs[0].Id
                    and Task_SubType__c=:Agreerecord.Task_SubType__c
                ];     
                    
                for (Apttus__DocumentVersionDetail__c doccstlupd : Docversiondtlsubtype )
                {
                   doccstlupd.Task_SubType__c = null;
                   Docversiondtlupd.add(doccstlupd);
                   
                }    
                    
                     
                Docversiondtlnew.Name = nm;
                Docversiondtlnew.Agreement__c = agrid;
                Docversiondtlnew.Agreement_Line_Item__c = Agreerecord.Primary_Agreement_Line_Item__c;
                Docversiondtlnew.Task_SubType__c = Agreerecord.Task_SubType__c;
                Docversiondtlnew.Apttus__Title__c= filename;
                Docversiondtlnew.Apttus__DocumentInfo__c= docinfo;
                Docversiondtlnew.Apttus__VersionMajor__c = maj;
                Docversiondtlnew.Apttus__VersionMinor__c = minor; 
                Docversiondtlnew.Apttus__VersionRevision__c = revision;
                Docversiondtlnew.Apttus__DocumentVersionId__c=Docvrs[0].Id;
                Docversiondtlnew.Apttus__Action2__c = 'Generate Agreement';
                Docversiondtlnew.Apttus__Comment__c = 'Generate Agreement';
                Docversiondtlnew.Apttus__FileType__c = 'Attachment';
                Docversiondtlnew.Apttus__IsTransient__c = false;
                Docversiondtlnew.Apttus__TemplateVersionId__c = tpl.Apttus__ActiveVersionId__c;
                if (Agreerecord.Task_SubType__c =='Initial')
                Docversiondtlnew.Sequence__c = 1;
                if (Agreerecord.Task_SubType__c =='BAFO I')
                Docversiondtlnew.Sequence__c = 2;
                if (Agreerecord.Task_SubType__c ==' BAFO II')
                Docversiondtlnew.Sequence__c = 3;
                if (Agreerecord.Task_SubType__c =='BAFO III')
                Docversiondtlnew.Sequence__c = 4;
                if (Agreerecord.Task_SubType__c =='BAFO IV')
                Docversiondtlnew.Sequence__c = 5;
                if (Agreerecord.Task_SubType__c =='BAFO V')
                Docversiondtlnew.Sequence__c = 6;
                if (Agreerecord.Task_SubType__c ==' BAFO VI')
                Docversiondtlnew.Sequence__c = 7;
                if (Agreerecord.Task_SubType__c =='BAFO VII')
                Docversiondtlnew.Sequence__c = 8; 
                if (Agreerecord.Task_SubType__c =='BAFO VIII')
                Docversiondtlnew.Sequence__c = 9; 
                
                
                Database.SaveResult result = Database.insert(Docversiondtlnew, false);
                if(!result.isSuccess()) {
                    throw new AuraHandledException(result.getErrors()[0].getMessage());
                } 
                
                
                  Docvrs[0].Apttus__LatestVersion__c = nm;     
                        List<Database.SaveResult> result1 = Database.update(Docvrs, false);
                        for(Integer i=0;i<result1.size();i++)
                         {
                           if(!result1.get(i).isSuccess()) 
                         {
                           Database.Error error = result1.get(i).getErrors().get(0);
                           String failedDML = error.getMessage();
                           throw new AuraHandledException(failedDML);
                          }
                        }  
                        
                        List<Database.SaveResult> result2 = Database.update(Docversiondtlupd, false);
                        for(Integer i=0;i<result2.size();i++)
                         {
                           if(!result2.get(i).isSuccess()) 
                         {
                           Database.Error error = result2.get(i).getErrors().get(0);
                           String failedDML = error.getMessage();
                           throw new AuraHandledException(failedDML);
                          }
                        }  
                        
                        
            }
            Apttus__DocumentVersionDetail__c Docversiondtlrtr = [
                select id,Agreement__c,LOB_Detail__c,Name,Apttus__Title__c,Apttus__DocumentVersionId__c,
                Apttus__VersionMajor__c,Apttus__VersionMinor__c,Apttus__VersionRevision__c,Apttus__Action2__c,Apttus__View__c,
                Apttus__FileType__c
                from Apttus__DocumentVersionDetail__c where  Apttus__DocumentVersionId__c= :Docvrs[0].Id
                and Agreement__c = :agrid and Name = :nm order by Apttus__VersionMajor__c desc
                Limit 1
            ];   
            if (Docversiondtlrtr != null)  { 
                //Apttus.AgreementGenerateController.createDocVersionSO(sObjectId, tpl.Id, 'Generate', docFormat, 'Generate');
                //ID docId2 = Apttus.MergeWebService.generateDoc2(tpl.Id, sObjectId,pLevel,docFormat,isDraft,sessionId,serverUrl); 
            }    
            return Docversiondtlrtr;
        } catch(exception e){
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    @AuraEnabled  
    public static void mergedocument(String agrid, String filetype){
        try {
        //if(!Test.isRunningTest()){
            String sessionId = UserInfo.getSessionId(); 
            PageReference reportPage = Page.currentUserInfoCtrl;
            // Get the content of the VF page
            String vfContent = reportPage.getContent().toString();
            System.debug('vfContent '+vfContent);
            // Find the position of Start_Of_Session_Id and End_Of_Session_Id
            Integer startP = vfContent.indexOf('Start_Of_Session_Id') + 'Start_Of_Session_Id'.length(),
                endP = vfContent.indexOf('End_Of_Session_Id');
            // Get the Session Id
            sessionId = vfContent.substring(startP, endP);   
            Apttus__APTS_Template__c tpl = [
                Select Id,Next_Template__c, Apttus__IsActive__c,Apttus__BusinessObject__c from Apttus__APTS_Template__c 
                where Apttus__IsActive__c = True and Name= :Label.PCD_Template_Name 
            ];    
            String sObjectType = tpl.Apttus__BusinessObject__c;    
            String pLevel = 'Full Access';  
            String docFormat;
            Boolean isDraft;
            if (filetype == 'docx') {
                docFormat = 'DOC';
                isDraft = false;
            } else {
                docFormat = 'PDF';
                isDraft = false;
            }
            //String serverUrl = Label.PCD_Generation_URL; 
            String serverUrl =  System.Url.getSalesforceBaseUrl().toExternalForm() + Label.Print_Merge_Service + UserInfo.getOrganizationId();
            ID sObjectId = agrid;
             //ID docId2 = Apttus.MergeWebService.submitGenerateCustomDoc(tpl.Id, sObjectId,sObjectType,pLevel,docFormat,isDraft,sessionId,serverUrl);     
            ID docId2 = Apttus.MergeWebService.generateDoc2(tpl.Id, sObjectId,pLevel,docFormat,isDraft,sessionId,serverUrl);   
            
        } catch(exception e){
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    @AuraEnabled
    public static String getDocName(String RecId){
        try {
            String docname;
            List<Apttus__APTS_Agreement__c> agreement = [select id,Name,Account_Name__c,Submitted_Questionnaire_LOB__c,Primary_Agreement_Line_Item__r.Task_SubType__c from Apttus__APTS_Agreement__c where Id= :RecId];
            if (agreement!= null && !agreement.isEmpty()) {
                docname=agreement[0].Account_Name__c + '_PCD_'+ agreement[0].Primary_Agreement_Line_Item__r.Task_SubType__c + '_'  + Datetime.now().format('yyyy-MM-dd'); //date.today();System.now();
            }
            return docname;
        } catch(exception e){
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    @AuraEnabled
    public static Apttus__DocumentVersionDetail__c contentdocument(Id RecId) {
        try {
            Apttus__DocumentVersionDetail__c Docversiondtlrtr = [
                select id,Apttus__ContentId__c,Agreement__c,LOB_Detail__c,Name,Apttus__Title__c,Apttus__DocumentVersionId__c,
                Apttus__VersionMajor__c,Apttus__VersionMinor__c,Apttus__VersionRevision__c,Apttus__Action2__c,Apttus__View__c,
                Apttus__FileType__c
                from Apttus__DocumentVersionDetail__c where  Id = :RecId
            ];    
            
            return Docversiondtlrtr;
        } catch(exception e){
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    @AuraEnabled
    public static String updatefilename(Id RecId, String Filename,String Filetype) {
        try {
            ID sObjectId;
            String contentId;
            Apttus__DocumentVersionDetail__c Docversiondtlrtr = [
                select Id,Apttus__ContentId__c,Agreement__c,LOB_Detail__c,Name,Apttus__Title__c,Apttus__DocumentVersionId__c,
                Apttus__VersionMajor__c,Apttus__VersionMinor__c,Apttus__VersionRevision__c,Apttus__Action2__c,Apttus__View__c,
                Apttus__FileType__c
                from Apttus__DocumentVersionDetail__c where  Id = :RecId
            ];
            sObjectId = Docversiondtlrtr.Agreement__c;    
            String filenametype;
            if (Filetype == 'docx') {
                filenametype = Filename + '.docx';
            } else {
                filenametype = Filename + '.pdf';
            }
            if(Docversiondtlrtr != null){
                Attachment attfile = [SELECT Id, Name FROM Attachment where  ParentId = :Docversiondtlrtr.Agreement__c   Order by SystemModStamp Desc LIMIT 1];
                Docversiondtlrtr.Apttus__Title__c = filenametype;
               if (attfile != null)
                {
                 Docversiondtlrtr.Apttus__ContentId__c = attfile.Id;
                 contentId = attfile.Id;
                } 
                Database.SaveResult result = Database.update(Docversiondtlrtr, false);
                if(!result.isSuccess()) {
                    throw new AuraHandledException(result.getErrors()[0].getMessage());
                } 
                 if(attfile != null){
                    String sessionId = UserInfo.getSessionId(); 
                    PageReference reportPage = Page.currentUserInfoCtrl;
                    String vfContent = reportPage.getContent().toString();
                    Integer startP = vfContent.indexOf('Start_Of_Session_Id') + 'Start_Of_Session_Id'.length(),
                    endP = vfContent.indexOf('End_Of_Session_Id');
                    sessionId = vfContent.substring(startP, endP);  
                    String serverUrl =  System.Url.getSalesforceBaseUrl().toExternalForm() + Label.Print_Merge_Service + UserInfo.getOrganizationId();
                    List<String>  docIds = new List<String>();
                    docIds.add(attfile.Id);
                     //Boolean successstatus = Apttus.MergeWebService.enableAuthoring(sObjectId, 'Full Access', docIds, sessionId, serverUrl); 
                   if (attfile != null)
                   {
                   attfile.Name = filenametype;
                    Database.SaveResult result1 = Database.update(attfile, false);
                    if(!result1.isSuccess()) 
                    {
                        throw new AuraHandledException(result1.getErrors()[0].getMessage());
                    } 
                    }
                } 
            } return contentId;
        } catch(exception e){
            throw new AuraHandledException(e.getMessage());
        }
    }
    //By mohit srivastava
    
    @AuraEnabled
    global static Integer get_UpdateRebatedata(String ID, boolean nonspec,boolean spec,boolean gstp) {
        try {
            integer rtn = 0;
            Rebate_Operations__c rb=[Select ID,Non_Specialty_Formulary_Option__c,GSTP_Option__c,Specialty_Formulary_Option__c,FAF_ID__c from Rebate_Operations__c where FAF_ID__c=:ID limit 1];
            if(nonspec==true){
            rb.Non_Specialty_Formulary_Option__c='Client Choice';
            }
            if(spec==true){
            rb.Specialty_Formulary_Option__c='Client Choice';
            }
            if(gstp==true){
            rb.GSTP__c='Yes';
            rb.GSTP_Option__c='Choice';
            }
            Rebate_Operations__c lnp;
            lnp = rb;
            Database.upsert(lnp); 
            if(rb.Id != null)
           {
                Database.SaveResult result = Database.update(lnp, false);
                     if(!result.isSuccess()) {
                throw new AuraHandledException(result.getErrors()[0].getMessage());
                }
            }
            else
            {
                Database.UpsertResult result1 = Database.upsert(lnp, false);   
                if(!result1.isSuccess()) {
                throw new AuraHandledException(result1.getErrors()[0].getMessage());
                }
            }
            return rtn;
        }catch(Dmlexception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    
    @AuraEnabled
    public static List<Offer__c> get_Offer(String accountid,String taskid){
        try {
            List<Offer__c> rtnOffer = new List<Offer__c>();
            List<Task__c> lstTask= [select id,Account__c,Offer__c from Task__c where  Id= :taskid order by Name Desc];
            for (Task__c task: lstTask)
            {
              if(task.Offer__c != null)
              {
              Offer__c lstOffer = [Select Id,Account__c,PCD__c,Agreement_Name__c,Alert_Message__c,Name,OfferCategory__c,OfferDescriptor__c,
                                          Offer_Revenue_PCD__c,OfferTotalRevenue__c,PCD_Offer_link__c,iUMSTask__c,iUMS_Task_Number__c from Offer__c where id= :task.Offer__c ];
              
              rtnOffer.add(lstOffer);
              }
            }
            return rtnOffer; 
        } catch(exception e){
            throw new AuraHandledException(e.getMessage());
        }
    }
    
   
 @AuraEnabled
    global static list<Billing_Administrative_Fees__c> get_BillingAdmindata(String fafid) 
    {
     List<Billing_Administrative_Fees__c> ba = new List<Billing_Administrative_Fees__c>();
     String PCD_Manual_Fee_Type = System.Label.PCD_Manual_Fee_Type;
     String PCD_340B_Fee_Type =  System.Label.PCD_340B_Fee_Type;
     String EGWP_Per_Member_Per_Month = System.Label.EGWP_Per_Member_Per_Month;
     for (Billing_Administrative_Fees__c balst : [SELECT id,
            Agreement__c,
            Agreement_Line_Item__c,
            Custom_Description__c,
            Plan_Year__c,
            Admin_Fee_Type__c,
            Additive__c,
            Base_Amount__c,
            Broker_Amount__c,
            Billing_Operations__c,                         
            FAF_ID__c,                         
            LOB__c,
            Year__c,
            PCD_Manual_Claim_Fee__c,
            PCD_Unique_340B_Fee_Type__c,
            PCD_Unique_EGWPPMPM_Fee_Type__c,
            PCD_Unique_Fee_Type__c,
            PCD_Unique_Manual_Fee_Type__c,
            Show_in_Grid__c,
            Template_340B_Type_Text__c,
            Template_Admin_Fee_Type_Text__c,
            Template_EGWPPMPM_Fee_Type_Text__c,
            Template_Manual_Claim_Admin_Text__c,
            Year_Start_Date__c,
            Year_End_Date__c                          
            from Billing_Administrative_Fees__c where FAF_ID__c = :fafid
            order by Year__c])
        {
         if (!Label.PCD_340B_Fee_Type.Contains(balst.Admin_Fee_Type__c) && !Label.PCD_Manual_Fee_Type.Contains(balst.Admin_Fee_Type__c) && !Label.EGWP_Per_Member_Per_Month.Contains(balst.Admin_Fee_Type__c)) 
          {
           ba.add(balst);
          }
        }
        return ba;
    } 
    
    @AuraEnabled
    global static Integer get_saveadminfeedata(Billing_Administrative_Fees__c ad) {
        try {
            integer rtn = 0;
            List<Billing_Operations__c> bops = [Select Id from Billing_Operations__c where  FAF_ID__c =:ad.FAF_ID__c LIMIT 1];
       
            if (bops != null && !bops.isEmpty())
            {
            List<Billing_Administrative_Fees__c> adm;
            if(ad.Id != null) 
            {
            adm = [
                Select Id from Billing_Administrative_Fees__c where Year__c = :ad.Year__c and LOB__c = :ad.LOB__c
                and FAF_ID__c=:ad.FAF_ID__c and Admin_Fee_Type__c=:ad.Admin_Fee_Type__c and Id != :ad.Id
            ];
            }
           if(ad.Id == null) 
            {
            List<Billing_Administrative_Fees__c> dmp = [
                Select Id,Billing_Operations__c from Billing_Administrative_Fees__c where Year__c = :ad.Year__c and LOB__c = :ad.LOB__c
                and FAF_ID__c=:ad.FAF_ID__c and Admin_Fee_Type__c=:ad.Admin_Fee_Type__c ];
            if (dmp != null && !dmp.isEmpty()) {
                ad.Id = dmp[0].Id;
            } 
            }
            if (adm != null && !adm.isEmpty()) {
                rtn = 1;
            }  else {
                rtn = 0;
                Billing_Administrative_Fees__c badm;
                badm = ad;
                if (badm.Billing_Operations__c == null && ad.Id == null)
                {
                 badm.Billing_Operations__c = bops[0].Id;
                }
                if (badm.Broker_Amount__c != null)
                {
                 badm.Additive__c = true;
                }
                else
                {
                 badm.Additive__c = false;
                }
                //Database.upsert(badm); 
                if(ad.Id != null) {
                    Database.SaveResult result = Database.update(badm, false);
                    if(!result.isSuccess()) {
                        throw new AuraHandledException(result.getErrors()[0].getMessage());
                    }
                } else {
                    Database.UpsertResult result1 = Database.upsert(badm, false);   
                    if(!result1.isSuccess()) {
                        throw new AuraHandledException(result1.getErrors()[0].getMessage());
                    }
                }
            }}
            return rtn;
        } catch(Dmlexception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }  


 @AuraEnabled
    global static void saveadmindatalist(List<Billing_Administrative_Fees__c> mp, String opid) {
        try {
             List<Billing_Administrative_Fees__c> mpupd = new List<Billing_Administrative_Fees__c>();
             List<Billing_Administrative_Fees__c> mpins = new List<Billing_Administrative_Fees__c>();
              for (Billing_Administrative_Fees__c mpupsert : mp)
                 {
                   if(mpupsert.Id == null) {
                        List<Billing_Administrative_Fees__c> dmp = [
                        Select Id from Billing_Administrative_Fees__c where Year__c = :mpupsert.Year__c and LOB__c = :mpupsert.LOB__c
                        and FAF_ID__c=:mpupsert.FAF_ID__c and Admin_Fee_Type__c=:mpupsert.Admin_Fee_Type__c LIMIT 1 
                          ];
                        if (dmp != null && !dmp.isEmpty()) {
                                mpupsert.Id = dmp[0].Id;
                             } 
                         }
                 
                 
                   if (mpupsert.Billing_Operations__c == null && mpupsert.Id==null)
                    {
                      mpupsert.Billing_Operations__c = opid;
                    }
                   if(mpupsert.Id != null) 
                   {
                    mpupd.add(mpupsert);
                   }
                   else
                   {
                    mpins.add(mpupsert);
                   }
                 }
                  ConstantsUtil.OFF_TRIGGERS_DUPLICATECHECK = false;
                  DeepCloneUtility.OFF_TRIGGERS_PROCBUILDER = false;
                  if (mpupd != null && !mpupd.isEmpty())
                  {
                  List<Database.SaveResult> result = Database.update(mpupd, false);   
                   for(Integer i=0;i<result.size();i++){
                    if(!result.get(i).isSuccess()) {
                        Database.Error error = result.get(i).getErrors().get(0);
                        String failedDML = error.getMessage(); 
                        throw new AuraHandledException(failedDML);
                    }
                  }
                  }
                  if (mpins != null && !mpins.isEmpty())
                  {
                   List<Database.UpsertResult> result1 = Database.upsert(mpins, false);   
                   for(Integer i=0;i<result1.size();i++){
                    if(!result1.get(i).isSuccess()) {
                        Database.Error error = result1.get(i).getErrors().get(0);
                        String failedDML = error.getMessage(); 
                        throw new AuraHandledException(failedDML);
                    }
                }
                } 
           ConstantsUtil.OFF_TRIGGERS_DUPLICATECHECK = true;
           DeepCloneUtility.OFF_TRIGGERS_PROCBUILDER = true;
        } catch(Dmlexception e) {
            ConstantsUtil.OFF_TRIGGERS_DUPLICATECHECK = true;
            DeepCloneUtility.OFF_TRIGGERS_PROCBUILDER = true;
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    
   @AuraEnabled
    global static integer deleteSelectedadminRecords(String adminId)  {
        List <Billing_Administrative_Fees__c> recordsToDelete = [SELECT Id,LOB__c,Year__c,Admin_Fee_Type__c,Billing_Operations__c FROM Billing_Administrative_Fees__c WHERE Id = : adminId];
        try{
            //delete recordsToDelete;
            integer countbad = 0;
            if(recordsToDelete != null && !recordsToDelete.isEmpty()) {
                List <Billing_Administrative_Fees__c> bad = [
                    SELECT Id  FROM Billing_Administrative_Fees__c WHERE Billing_Operations__c = :recordsToDelete[0].Billing_Operations__c];   
                if(bad != null && !bad.isEmpty()) {
                    countbad =  bad.size();
                }
                List<Database.DeleteResult> result = Database.delete(recordsToDelete, false);
                for(Integer i=0;i<result.size();i++){
                    if(!result.get(i).isSuccess()) {
                        Database.Error error = result.get(i).getErrors().get(0);
                        String failedDML = error.getMessage();
                        throw new AuraHandledException(failedDML);
                    }
                }
            }
            return countbad;
        } catch(Exception ex){
            throw new AurahandledException(ex.getDmlMessage(0));
        }    
    }  
    
   
   @AuraEnabled  
    public static List<picklistWrapper> findPicklistOptionsadmintype(string objAPIName, string fieldAPIname, string admintype) {
        list<picklistWrapper> returnValue = new list<picklistWrapper>();
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        // Get the object type of the SObject.
        Schema.sObjectType objType = schemaMap.get(objAPIName);
        // Describe the SObject using its object type.
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
        // Get a map of fields for the SObject
        map < String, Schema.SObjectField > fieldMap = objDescribe.fields.getMap();
        // Get the list of picklist values for this field.
        list < Schema.PicklistEntry > values = fieldMap.get(fieldAPIname).getDescribe().getPickListValues();
        //pickListFieldWrapper picklistDetails = new pickListFieldWrapper();
        // Add these values to the selectoption list.
        for (Schema.PicklistEntry a: values) {
            picklistWrapper aa = new picklistWrapper();
          if ((admintype=='ELECRONIC' && !Label.PCD_340B_Fee_Type.Contains(a.getValue()) && !Label.PCD_Manual_Fee_Type.Contains(a.getValue()) && !Label.EGWP_Per_Member_Per_Month.Contains(a.getValue()))
            ||(admintype=='MANUAL' && Label.PCD_Manual_Fee_Type.Contains(a.getValue()))
            ||(admintype=='340B' && Label.PCD_340B_Fee_Type.Contains(a.getValue())))
          {
            aa.pickListLabel = a.getLabel();
            aa.pickListValue = a.getValue();
            returnValue.add(aa);
          }
        }
        return returnValue; 
    }
   
  @AuraEnabled
    global static list<Billing_Administrative_Fees__c> get_BillingAdmindatamanual(String fafid) 
    {
     List<Billing_Administrative_Fees__c> ba = new List<Billing_Administrative_Fees__c>();
     String PCD_Manual_Fee_Type = System.Label.PCD_Manual_Fee_Type;
     String PCD_340B_Fee_Type =  System.Label.PCD_340B_Fee_Type;
     String EGWP_Per_Member_Per_Month = System.Label.EGWP_Per_Member_Per_Month;
     for (Billing_Administrative_Fees__c balst : [SELECT id,
            Agreement__c,
            Agreement_Line_Item__c,
            Plan_Year__c,
            Admin_Fee_Type__c,
            Additive__c,
            Base_Amount__c,
            Broker_Amount__c,
            Billing_Operations__c,                         
            FAF_ID__c,                         
            LOB__c,
            Year__c,
            PCD_Manual_Claim_Fee__c,
            PCD_Unique_340B_Fee_Type__c,
            PCD_Unique_EGWPPMPM_Fee_Type__c,
            PCD_Unique_Fee_Type__c,
            PCD_Unique_Manual_Fee_Type__c,
            Show_in_Grid__c,
            Template_340B_Type_Text__c,
            Template_Admin_Fee_Type_Text__c,
            Template_EGWPPMPM_Fee_Type_Text__c,
            Template_Manual_Claim_Admin_Text__c,
            Year_Start_Date__c,
            Year_End_Date__c                          
            from Billing_Administrative_Fees__c where FAF_ID__c = :fafid
            order by Year__c])
        {
         if (Label.PCD_Manual_Fee_Type.Contains(balst.Admin_Fee_Type__c)) 
          {
           ba.add(balst);
          }
        }
        return ba;
    }  
    
     @AuraEnabled
    global static list<Billing_Administrative_Fees__c> get_BillingAdmindata340b(String fafid) 
    {
     List<Billing_Administrative_Fees__c> ba = new List<Billing_Administrative_Fees__c>();
     String PCD_Manual_Fee_Type = System.Label.PCD_Manual_Fee_Type;
     String PCD_340B_Fee_Type =  System.Label.PCD_340B_Fee_Type;
     String EGWP_Per_Member_Per_Month = System.Label.EGWP_Per_Member_Per_Month;
     for (Billing_Administrative_Fees__c balst : [SELECT id,
            Agreement__c,
            Agreement_Line_Item__c,
            Custom_Description__c,
            Plan_Year__c,
            Admin_Fee_Type__c,
            Additive__c,
            Base_Amount__c,
            Broker_Amount__c,
            Billing_Operations__c,                         
            FAF_ID__c,                         
            LOB__c,
            Year__c,
            PCD_Manual_Claim_Fee__c,
            PCD_Unique_340B_Fee_Type__c,
            PCD_Unique_EGWPPMPM_Fee_Type__c,
            PCD_Unique_Fee_Type__c,
            PCD_Unique_Manual_Fee_Type__c,
            Show_in_Grid__c,
            Template_340B_Type_Text__c,
            Template_Admin_Fee_Type_Text__c,
            Template_EGWPPMPM_Fee_Type_Text__c,
            Template_Manual_Claim_Admin_Text__c,
            Year_Start_Date__c,
            Year_End_Date__c                          
            from Billing_Administrative_Fees__c where FAF_ID__c = :fafid
            order by Year__c])
        {
         if (Label.PCD_340B_Fee_Type.Contains(balst.Admin_Fee_Type__c)) 
          {
           ba.add(balst);
          }
        }
        return ba;
    }  
    
    
   @AuraEnabled
    global static integer deleteadminfee(String fafid)  {
        List <Billing_Administrative_Fees__c> recordsToDelete = [SELECT Id,LOB__c,Year__c,FAF_ID__c,Billing_Operations__c FROM Billing_Administrative_Fees__c WHERE FAF_ID__c = : fafid];
        try {
            //delete recordsToDelete;
            integer countbaf = 0;
            if(recordsToDelete != null && !recordsToDelete.isEmpty()) {
                List <Billing_Administrative_Fees__c> baf = [
                    SELECT Id  FROM Billing_Administrative_Fees__c WHERE Billing_Operations__c = :recordsToDelete[0].Billing_Operations__c
                ];   
                if(baf != null && !baf.isEmpty()) {
                    countbaf =  baf.size();
                }
                List<Database.DeleteResult> result = Database.delete(recordsToDelete, false);
                for(Integer i=0;i<result.size();i++){
                    if(!result.get(i).isSuccess()) {
                        Database.Error error = result.get(i).getErrors().get(0);
                        String failedDML = error.getMessage(); 
                        throw new AuraHandledException(failedDML);
                    }
                }
            }
            return countbaf;
        } catch(Exception ex){
            throw new AurahandledException(ex.getDmlMessage(0));
        }    
    } 
    
    @AuraEnabled
    global static Apttus__AgreementLineItem__c get_agreementterms(String recordId)  {
        try  {
            Apttus__AgreementLineItem__c agg = [Select Id , Proposal_Year__c,PCD_Clause_Previous_Terms__c,Pricing_Effective_Date__c,Escalating_Effective_Date__c,Due_Date__c,Task_Subtype__c from Apttus__AgreementLineItem__c where Apttus__AgreementId__c= :recordId and Template_Exclude__c = false] ; 
            return agg; 
        } catch(exception e){
            throw new AuraHandledException(e.getMessage());
        }
    }
  
   @AuraEnabled
   global static void get_updatestatusali(String stageName , String recordId) {
        try {
            Apttus__APTS_Agreement__c agg = [Select Id ,Internal_Review_Completed__c,PCD_Status__c,Status_In_Progress__c,Primary_Agreement_Line_Item__c from Apttus__APTS_Agreement__c where Id=:recordId] ; 
            if (agg != null)
            {
            Apttus__AgreementLineItem__c aggline = [Select Id ,Apttus__AgreementId__c,PCD_Status__c,BAFO_Change__c,Task_SubType__c,Previous_Task_SubType__c from Apttus__AgreementLineItem__c where Id= :agg.Primary_Agreement_Line_Item__c] ; 
            if(aggline != null)
             aggline.PCD_Status__c =stageName ; 
             if (aggline.BAFO_Change__c == true)
               {
                aggline.Previous_Task_SubType__c = aggline.Task_SubType__c; 
               }
             update aggline; 
            }
        } catch(exception e){
            throw new AuraHandledException(e.getMessage());
        }
    } 
   @AuraEnabled
   global static Integer get_multiplelob(String recordId) {
        try {
            Integer ct = 0;
            List<PCD_Multiple_LOB__c> mlob = [Select Id  from PCD_Multiple_LOB__c where ALI_ID__c=:recordId] ; 
            for (PCD_Multiple_LOB__c lob : mlob )
            {
             ct = ct +1;
            }
            return ct;
        } catch(exception e){
            throw new AuraHandledException(e.getMessage());
        }
    }   
  
   @AuraEnabled
    global static Specialty_Operations__c get_SpecOpsObjectdata(String RecId, String ObjectName) 
    {
        Specialty_Operations__c sp = [
            SELECT  id,
            FAF_ID__c
            from Specialty_Operations__c where Agreement_Line_Item__c = :RecId
        ];
        
        return sp;
    }
  
     
}