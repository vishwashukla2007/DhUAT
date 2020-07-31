/* ==============================================================================================================
 * @Class Name      : PCDQuestionAnswerTriggerHandler
 * @author            : Soumendu Chowdhury
 * @created date      : 05/06/2019
 * @Last modified by  : Soumendu Chowdhury
 * @Last modified date: 05/06/2019
 * @Purpose           : Trigger Handler class to create Network Pricing, Specialty Prcing and Rebate Guarantee record based on PCD Question Answer record created from Agreement Line Item
==================================================================================================================*/
public class PCDQuestionAnswerTriggerHandler {
/*
Public Static void FAFupdateafterinsert(List<PCD_Question_Answer__c> PCDQAList){
    
   try{
      DeepCloneUtility.OFF_TRIGGERS_PROCBUILDER=false;
      DeepCloneUtility.OFF_INVOCABLE_CLASS = false;
      Boolean firstloop = false;
      Map<Id, SObject> networkpriceObj = new Map<Id, SObject>();
      Map<String,List<PCD_Question_Answer__c>> FAFMap = new Map<String,List<PCD_Question_Answer__c>>();
      Map<ID,Network_Name__c> NetworkNameMap = new Map<ID,Network_Name__c>([ Select Id, Name From Network_Name__c Where Active__c = true]);
      Map<String,List<Network_Pricing__c>> NetworkPricingMap = new Map<String,List<Network_Pricing__c>>(); 
      List<Network_Pricing__c> lstNetworkpricingToInsert = new List<Network_Pricing__c>();
      List<PCD_Question_Answer__c>  PCDqs= [SELECT  FAF_ID__c FROM PCD_Question_Answer__c WHERE ID IN: PCDQAList]; 
      List<Network_Operations__c>  Ops = [SELECT FAF_ID__c,Agreement_Line_Item__c FROM Network_Operations__c WHERE FAF_ID__c = :PCDqs[0].FAF_ID__c]; 
      List<Specialty_Operations__c>  SOps = [SELECT FAF_ID__c,Agreement_Line_Item__c,Exclude_Specialty_Class__c,Select_Specialty_Exclusion__c FROM Specialty_Operations__c WHERE FAF_ID__c = :PCDqs[0].FAF_ID__c]; // Specialty Pricing Record creation and Operation record update
      Map<String,Specialty_Pricing__c> SpecPricingMap = new Map<String,Specialty_Pricing__c>([SELECT ID,FAF_ID__c,Specialty_Operations__c,Brand_Basis__c,Exclude_Specialty_Class__c,LOB__c,Select_Specialty_Exclusion__c,Year__c FROM Specialty_Pricing__c where FAF_ID__c=:PCDqs[0].FAF_ID__c]);
      Map<Id, SObject> specobj = new Map<Id, SObject>([ Select Id, Name,Agreement_Line_Item__c From Specialty_Operations__c Where FAF_ID__c = :PCDqs[0].FAF_ID__c ]); 
      Map<Id, SObject> specpriceObj = new Map<Id, SObject>();
      Map<Id, SObject> rebategteeObj = new Map<Id, SObject>();
      List<Specialty_Operations__c>  SupdOps = new List<Specialty_Operations__c>();
      set<id> ids=new set<id>();
      set<String> Formulary=new set<String>();
      set<String> NonFormulary=new set<String>();
      map<id,String> mapPlandesign=new map<id,String>();
      map<id,id> mapRebate=new map<id,id>();
      List<Rebate_Guarantees__c> rebateGurlist = new List<Rebate_Guarantees__c>();
      String FAFID = PCDqs[0].FAF_ID__c;
      Map<Id, SObject> RGtee = new Map<Id, SObject>([SELECT ID,LOB2__c,Year__c,FAF_ID__c,Rebate_Operations__c,Drug_Therapy_Class_2__c FROM Rebate_Gtees_Specialty_Class_Carve_Outs__c WHERE FAF_ID__c = :PCDqs[0].FAF_ID__c]);
      List<Rebate_Gtees_Specialty_Class_Carve_Outs__c> RGteeinsert = new List<Rebate_Gtees_Specialty_Class_Carve_Outs__c>();
      List<Rebate_Operations__c>  ROps = [SELECT FAF_ID__c,Percentage_Guarantee__c,Rebate_Offering_Type__c FROM Rebate_Operations__c WHERE FAF_ID__c = :PCDqs[0].FAF_ID__c]; 
      Map<Id,SObject> rebateGtee = new Map<Id,SObject>([Select ID,FAF_ID__c,LOB2__c,Year__c,Non_Specialty_Formulary_2__c,Specialty_Formulary__c From Rebate_Guarantees__c where FAF_ID__c = :PCDqs[0].FAF_ID__c]);
      Map<ID,Non_Specialty_Formulary_Option__c> NonSpecialFormulary = new Map<ID,Non_Specialty_Formulary_Option__c>([ Select Id, Name From Non_Specialty_Formulary_Option__c Where Active__c = true]);
      Map<ID,Formulary_Option__c> SpecialFormulary = new Map<ID,Formulary_Option__c   >([ Select Id, Name From Formulary_Option__c Where Active__c = true]);
      List<Network_Pricing__c>  NetOps = [SELECT ID,FAF_ID__c,FAF_Network_Ops__c,Network_Name__c,Network_Type__c,LOB__c,Retail_Network_Ordinal__c,Year__c,Custom_Network_Description__c FROM Network_Pricing__c where FAF_ID__c=:PCDqs[0].FAF_ID__c];
                      List<Network_Pricing__c> NPFinalList = new List<Network_Pricing__c>();
      for(Network_Pricing__c np:NetOps) {
                    String keyStr = np.ID;  
                    List<Network_Pricing__c> NPTempList = NetworkPricingMap.get(keyStr); 
                    if(NPTempList ==null) {
                        NPTempList = new List<Network_Pricing__c>();
                                          }
                        NPFinalList.add(np);  
                        NetworkPricingMap.put(keyStr, NPFinalList);  
                }
      for(PCD_Question_Answer__c pd :PCDQAList)
       {
       ids.add(pd.FAF_ID__c);
       Formulary.add(pd.Specialty_Formulary_option1_LK__c);
       Formulary.add(pd.Specialty_Formulary_option2_LK__c);
       Formulary.add(pd.Specialty_Formulary_option3_LK__c);
       NonFormulary.add(pd.Non_Speciality_Formulary1_option_LK__c);
       NonFormulary.add(pd.Non_Specialty_Formulary_option2_LK__c);
       NonFormulary.add(pd.Non_Specialty_Formulary_option3_LK__c);
       mapPlandesign.put(pd.FAF_ID__c,pd.Tier_Option_s__c);
        }
      List<String>  year = new String[]{};
      List<Client_Information__c>  clientinfo = [SELECT ID,Year_1__c,Year_2__c,Year_3__c,Year_4__c,Year_5__c from Client_Information__c where FAF_ID__c=:PCDqs[0].FAF_ID__c];
      for(Client_Information__c cinfo: clientinfo){ 
       if (cinfo.Year_1__c == '1')
       {
              year.add('1');
       } 
       if (cinfo.Year_2__c == '2')
       {
             year.add('2');
       } 
        if (cinfo.Year_3__c == '3')
       {
            year.add('3');
       } 
       if (cinfo.Year_4__c == '4')
       {
           year.add('4');
       } 
       if (cinfo.Year_5__c == '5')
       {
           year.add('5');
       }
           
      } 
      if (year == null || year.isEmpty())
      {
          year.add('All');
      }
      for(String yr: year)
      {
      for(PCD_Question_Answer__c pcdqa : PCDQAList){  
      
     /* ==============================================================================================================  
     * @author            : Mohit Srivastava
     * @created date      : 20/06/2019
     * @Purpose           : To create Rebate Guarantee record based on PCD Question Answer record created at Agreement Line Item
    ==================================================================================================================*/
        /* if (pcdqa.Agreement_Line_Item__c != null &&
                       (pcdqa.Specialty_Formulary_option1_LK__c != null || 
                        pcdqa.Specialty_Formulary_option2_LK__c!= null ||
                        pcdqa.Specialty_Formulary_option3_LK__c!= null ||
                        pcdqa.Non_Speciality_Formulary1_option_LK__c!= null ||
                        pcdqa.Non_Specialty_Formulary_option2_LK__c != null ||
                        pcdqa.Non_Specialty_Formulary_option3_LK__c != null
                        )
                    )
            {
                    Formulary_Option__c Specialty1 = SpecialFormulary.get(pcdqa.Specialty_Formulary_option1_LK__c);
                    Formulary_Option__c Specialty2 = SpecialFormulary.get(pcdqa.Specialty_Formulary_option2_LK__c);
                    Formulary_Option__c Specialty3 = SpecialFormulary.get(pcdqa.Specialty_Formulary_option3_LK__c);
                    Non_Specialty_Formulary_Option__c NonSpecialty1 =NonSpecialFormulary.get(pcdqa.Non_Speciality_Formulary1_option_LK__c);
                    Non_Specialty_Formulary_Option__c NonSpecialty2 =NonSpecialFormulary.get(pcdqa.Non_Specialty_Formulary_option2_LK__c);
                    Non_Specialty_Formulary_Option__c NonSpecialty3 =NonSpecialFormulary.get(pcdqa.Non_Specialty_Formulary_option3_LK__c);
                    Boolean Curveout1exist = false; 
                    Boolean Curveout2exist = false;
                    Boolean Curveout3exist = false;  
                    List<Rebate_Guarantees__c> rebateList = new List<Rebate_Guarantees__c>();
                    if(((Specialty1 !=null )|| (NonSpecialty1!=null)) && !Label.Rebate_Offering_Type.contains(ROps[0].Rebate_Offering_Type__c))
                    {
                    for (SObject Rgteemap : rebateGtee.values())
                    {
                     if(Specialty1 !=null && NonSpecialty1!=null)
                     {
                     if (Rgteemap.get('Specialty_Formulary__c') == Specialty1.Name && Rgteemap.get('Non_Specialty_Formulary_2__c') == NonSpecialty1.Name && Rgteemap.get('Year__c') == yr &&  Rgteemap.get('LOB2__c') == pcdqa.LOBFormula__c)
                     {
                      Curveout1exist = true;
                     }
                     }
                      if(Specialty1 ==null && NonSpecialty1!=null)
                     {
                     if (Rgteemap.get('Specialty_Formulary__c') == null && Rgteemap.get('Non_Specialty_Formulary_2__c') == NonSpecialty1.Name && Rgteemap.get('Year__c') == yr &&  Rgteemap.get('LOB2__c') == pcdqa.LOBFormula__c)
                     {
                      Curveout1exist = true;
                     }
                     }
                      if(Specialty1 !=null && NonSpecialty1==null)
                     {
                     if (Rgteemap.get('Specialty_Formulary__c') == Specialty1.Name && Rgteemap.get('Non_Specialty_Formulary_2__c') == null && Rgteemap.get('Year__c') == yr &&  Rgteemap.get('LOB2__c') == pcdqa.LOBFormula__c)
                     {
                      Curveout1exist = true;
                     }
                     }
                     
                     
                     
                    }
                    for (Rebate_Guarantees__c rg : rebateList)
                     {
                     if(Specialty1 !=null && NonSpecialty1!=null)
                     {
                     if (rg.Specialty_Formulary__c == Specialty1.Name && rg.Non_Specialty_Formulary_2__c == NonSpecialty1.Name && rg.Year__c == yr &&  rg.LOB2__c == pcdqa.LOBFormula__c)
                     {
                      Curveout1exist = true;
                     } 
                     }
                     if(Specialty1 ==null && NonSpecialty1!=null)
                     {
                     if (rg.Specialty_Formulary__c == null && rg.Non_Specialty_Formulary_2__c == NonSpecialty1.Name && rg.Year__c == yr &&  rg.LOB2__c == pcdqa.LOBFormula__c)
                     {
                      Curveout1exist = true;
                     } 
                     }
                     if(Specialty1 !=null && NonSpecialty1 ==null)
                     {
                     if (rg.Specialty_Formulary__c == Specialty1.Name && rg.Non_Specialty_Formulary_2__c == null && rg.Year__c == yr &&  rg.LOB2__c == pcdqa.LOBFormula__c)
                     {
                      Curveout1exist = true;
                     } 
                     }
                            
                     }
                     List<String> strtier =new List<String>();
                     if(pcdqa.Tier_Option_s__c!=null){
                     strtier = pcdqa.Tier_Option_s__c.split(';');
                    }
                    if (Curveout1exist == false && strtier != null)
                    {
                   for(String tier : strtier)
                    {
                    Rebate_Guarantees__c rebateGur = new Rebate_Guarantees__c();
                    rebateGur.FAF_ID__c = pcdqa.FAF_ID__c;
                    rebateGur.Plan_Design__c= tier;
                    rebateGur.Year__c = yr;
                    rebateGur.Rebate_Operations__c=ROps[0].ID;
                    if (ROps[0].Percentage_Guarantee__c == true)
                    rebateGur.RecordTypeId = Label.RGPercentageType;
                    else
                    rebateGur.RecordTypeId = Label.RGDollarType;
                    rebateGur.LOB2__c=pcdqa.LOBFormula__c;
                    //rebateGur.Basis__c='Formulary Brand';
                    if(Specialty1.Name!=null){
                    rebateGur.Specialty_Formulary__c=Specialty1.Name;
                    }
                    if(NonSpecialty1.Name!=null){
                    rebateGur.Non_Specialty_Formulary_2__c=NonSpecialty1.Name;
                    }
                    rebateGurlist.add(rebateGur);
                    rebateList.add(rebateGur);
                   }
                   }
                }
                if(((Specialty2 !=null)||(NonSpecialty2 !=null)) && !Label.Rebate_Offering_Type.contains(ROps[0].Rebate_Offering_Type__c))
                {
                  for (SObject Rgteemap : rebateGtee.values())
                    {
                    
                     if(Specialty2 !=null && NonSpecialty2!=null)
                     {
                     if (Rgteemap.get('Specialty_Formulary__c') == Specialty2.Name && Rgteemap.get('Non_Specialty_Formulary_2__c') == NonSpecialty2.Name && Rgteemap.get('Year__c') == yr &&  Rgteemap.get('LOB2__c') == pcdqa.LOBFormula__c)
                     {
                      Curveout2exist = true;
                     }
                     }
                    
                    if(Specialty2 ==null && NonSpecialty2!=null)
                     {
                     if (Rgteemap.get('Specialty_Formulary__c') == null && Rgteemap.get('Non_Specialty_Formulary_2__c') == NonSpecialty2.Name && Rgteemap.get('Year__c') == yr &&  Rgteemap.get('LOB2__c') == pcdqa.LOBFormula__c)
                     {
                      Curveout2exist = true;
                     }
                     }
                     
                     if(Specialty2 !=null && NonSpecialty2 ==null)
                     {
                     if (Rgteemap.get('Specialty_Formulary__c') == Specialty2.Name && Rgteemap.get('Non_Specialty_Formulary_2__c') == null && Rgteemap.get('Year__c') == yr &&  Rgteemap.get('LOB2__c') == pcdqa.LOBFormula__c)
                     {
                      Curveout2exist = true;
                     }
                     }
                       
                    }
                     for (Rebate_Guarantees__c rg:rebateList)
                     {
                     if(Specialty2 !=null && NonSpecialty2!=null)
                     {
                     if (rg.Specialty_Formulary__c == Specialty2.Name && rg.Non_Specialty_Formulary_2__c == NonSpecialty2.Name && rg.Year__c == yr &&  rg.LOB2__c == pcdqa.LOBFormula__c)
                     {
                      Curveout2exist = true;
                     }
                     }
                        
                     if(Specialty2 ==null && NonSpecialty2!=null)
                     {
                     if (rg.Specialty_Formulary__c == null && rg.Non_Specialty_Formulary_2__c == NonSpecialty2.Name && rg.Year__c == yr &&  rg.LOB2__c == pcdqa.LOBFormula__c)
                     {
                      Curveout2exist = true;
                     }
                     }   
                         
                     if(Specialty2 !=null && NonSpecialty2==null)
                     {
                     if (rg.Specialty_Formulary__c == Specialty2.Name && rg.Non_Specialty_Formulary_2__c == null && rg.Year__c == yr &&  rg.LOB2__c == pcdqa.LOBFormula__c)
                     {
                      Curveout2exist = true;
                     }
                     }    
                             
                     }
                    String[] strtier;
                    if (pcdqa.Tier_Option_s__c != null)
                    {
                     strtier = pcdqa.Tier_Option_s__c.split(';');
                    }
                    if (Curveout2exist == false && strtier != null)
                    {
                    for(String tier : strtier)
                    {
                    Rebate_Guarantees__c rebateGur = new Rebate_Guarantees__c();
                    rebateGur.FAF_ID__c = pcdqa.FAF_ID__c;
                    rebateGur.Year__c = yr;
                    rebateGur.Plan_Design__c= tier;
                    rebateGur.Rebate_Operations__c=ROps[0].ID;
                    if (ROps[0].Percentage_Guarantee__c == true)
                    rebateGur.RecordTypeId = Label.RGPercentageType;
                    else
                    rebateGur.RecordTypeId = Label.RGDollarType;
                    rebateGur.LOB2__c=pcdqa.LOBFormula__c;
                    //rebateGur.Basis__c='Formulary Brand';
                    if(Specialty2 !=null){
                    rebateGur.Specialty_Formulary__c=Specialty2.Name;
                    }
                    if(NonSpecialty2 !=null){
                    rebateGur.Non_Specialty_Formulary_2__c=NonSpecialty2.Name;
                    }
                    rebateGurlist.add(rebateGur);
                    rebateList.add(rebateGur);
                   }
                   }
                }
                if(((Specialty3 !=null )||(NonSpecialty3 !=null)) && !Label.Rebate_Offering_Type.contains(ROps[0].Rebate_Offering_Type__c))
                {
                  for (SObject Rgteemap : rebateGtee.values())
                    {
                     if(Specialty3 !=null && NonSpecialty3!=null)
                     {
                     if (Rgteemap.get('Specialty_Formulary__c') == Specialty3.Name && Rgteemap.get('Non_Specialty_Formulary_2__c') == NonSpecialty3.Name && Rgteemap.get('Year__c') == yr &&  Rgteemap.get('LOB2__c') == pcdqa.LOBFormula__c)
                     {
                      Curveout3exist = true;
                     }
                     }
                     
                     if(Specialty3 ==null && NonSpecialty3!=null)
                     {
                     if (Rgteemap.get('Specialty_Formulary__c') == null && Rgteemap.get('Non_Specialty_Formulary_2__c') == NonSpecialty3.Name && Rgteemap.get('Year__c') == yr &&  Rgteemap.get('LOB2__c') == pcdqa.LOBFormula__c)
                     {
                      Curveout3exist = true;
                     }
                     }
                     
                     if(Specialty3 !=null && NonSpecialty3 ==null)
                     {
                     if (Rgteemap.get('Specialty_Formulary__c') == Specialty3.Name && Rgteemap.get('Non_Specialty_Formulary_2__c') == null && Rgteemap.get('Year__c') == yr &&  Rgteemap.get('LOB2__c') == pcdqa.LOBFormula__c)
                     {
                      Curveout3exist = true;
                     }
                     }
                    }
                     for (Rebate_Guarantees__c rg:rebateList)
                     {
                     if(Specialty3 !=null && NonSpecialty3!=null)
                     {
                     if (rg.Specialty_Formulary__c == Specialty3.Name && rg.Non_Specialty_Formulary_2__c == NonSpecialty3.Name && rg.Year__c == yr &&  rg.LOB2__c == pcdqa.LOBFormula__c)
                     {
                      Curveout3exist = true;
                     } 
                     }  
                     if(Specialty3 ==null && NonSpecialty3!=null)
                     {
                     if (rg.Specialty_Formulary__c == null && rg.Non_Specialty_Formulary_2__c == NonSpecialty3.Name && rg.Year__c == yr &&  rg.LOB2__c == pcdqa.LOBFormula__c)
                     {
                      Curveout3exist = true;
                     } 
                     }  
                        
                     if(Specialty3 !=null && NonSpecialty3==null)
                     {
                     if (rg.Specialty_Formulary__c == Specialty3.Name && rg.Non_Specialty_Formulary_2__c == null && rg.Year__c == yr &&  rg.LOB2__c == pcdqa.LOBFormula__c)
                     {
                      Curveout3exist = true;
                     } 
                     }       
                     }
                    String[] strtier;
                    if (pcdqa.Tier_Option_s__c != null)
                    {
                     strtier = pcdqa.Tier_Option_s__c.split(';');
                    }
                    if (Curveout3exist == false && strtier != null)
                    {
                    
                  for(String tier : strtier)
                   {
                    Rebate_Guarantees__c rebateGur = new Rebate_Guarantees__c();
                    rebateGur.FAF_ID__c = pcdqa.FAF_ID__c;
                    rebateGur.Year__c = yr;
                    rebateGur.Plan_Design__c= tier;
                    rebateGur.Rebate_Operations__c=ROps[0].ID;
                    if (ROps[0].Percentage_Guarantee__c == true)
                    rebateGur.RecordTypeId = Label.RGPercentageType;
                    else
                    rebateGur.RecordTypeId = Label.RGDollarType;
                    rebateGur.LOB2__c=pcdqa.LOBFormula__c;
                    //rebateGur.Basis__c='Formulary Brand';
                    if(Specialty3 !=null){
                    rebateGur.Specialty_Formulary__c=Specialty3.Name;
                    }
                    if(NonSpecialty3 !=null){
                    rebateGur.Non_Specialty_Formulary_2__c=NonSpecialty3.Name;
                    }
                    rebateGurlist.add(rebateGur);
                    rebateList.add(rebateGur);
                   }
                   }
                }   
            } 
      
    
    
     /* if(SOps != null && !SOps.isEmpty())
        {  
           if (pcdqa.Speciality_level_Pharamacy_Benifit_Carve__c == 'YES' && (pcdqa.Carve_Out_Option_1__c != null || pcdqa.Carve_Out_Option_2__c != null || pcdqa.Carve_Out_Option_3__c != null))
            {
             for(Specialty_Operations__c so : SOps)
              {
                 so.Exclude_Specialty_Class__c = true;
                 if (pcdqa.Carve_Out_Option_1__c != null && firstloop == false)
                   {
                     if (so.Select_Specialty_Exclusion__c == null)
                     {
                      so.Select_Specialty_Exclusion__c = pcdqa.Carve_Out_Option_1__c;
                     }
                     else if(so.Select_Specialty_Exclusion__c != null)
                     {
                      if(!so.Select_Specialty_Exclusion__c.contains(pcdqa.Carve_Out_Option_1__c))
                       so.Select_Specialty_Exclusion__c += ';' + pcdqa.Carve_Out_Option_1__c;
                     }
                     
                   }
                 if (pcdqa.Carve_Out_Option_2__c != null && (pcdqa.Carve_Out_Option_2__c !=pcdqa.Carve_Out_Option_1__c) && firstloop == false)
                   {
                     
                     if (so.Select_Specialty_Exclusion__c == null)
                     so.Select_Specialty_Exclusion__c =  pcdqa.Carve_Out_Option_2__c;
                     else if(so.Select_Specialty_Exclusion__c != null)
                     {
                       if (!so.Select_Specialty_Exclusion__c.contains(pcdqa.Carve_Out_Option_2__c))
                         so.Select_Specialty_Exclusion__c += ';' + pcdqa.Carve_Out_Option_2__c;
                     }
                    
                   }
                 if (pcdqa.Carve_Out_Option_3__c != null && (pcdqa.Carve_Out_Option_3__c !=pcdqa.Carve_Out_Option_2__c) && (pcdqa.Carve_Out_Option_3__c !=pcdqa.Carve_Out_Option_1__c) && firstloop == false)
                   {
                     if (so.Select_Specialty_Exclusion__c == null)
                     so.Select_Specialty_Exclusion__c = pcdqa.Carve_Out_Option_3__c;
                     else if(so.Select_Specialty_Exclusion__c != null)
                     {
                        if (!so.Select_Specialty_Exclusion__c.contains(pcdqa.Carve_Out_Option_3__c))
                          so.Select_Specialty_Exclusion__c += ';' + pcdqa.Carve_Out_Option_3__c;
                      }
                   }
                 if (firstloop == false)
                 {
                  SupdOps.add(so);
                 }
                 firstloop = true;
                 Boolean Therapyexist1 = false;
                 Boolean Therapyexist2 = false;
                 Boolean Therapyexist3 = false;
                 for (SObject Rg: RGtee.values())
                     {
                       if(Rg.get('Year__c')==yr && pcdqa.Carve_Out_Option_1__c==Rg.get('Drug_Therapy_Class_2__c') && Rg.get('LOB2__c')==pcdqa.LOBFormula__c && pcdqa.Carve_Out_Option_1__c != null)
                       {
                        Therapyexist1 = true;
                       }
                       if(Rg.get('Year__c')==yr && pcdqa.Carve_Out_Option_2__c==Rg.get('Drug_Therapy_Class_2__c') && Rg.get('LOB2__c')==pcdqa.LOBFormula__c && pcdqa.Carve_Out_Option_2__c != null)
                       {
                        Therapyexist2 = true;
                       }
                       if(Rg.get('Year__c')==yr && pcdqa.Carve_Out_Option_3__c==Rg.get('Drug_Therapy_Class_2__c') && Rg.get('LOB2__c')==pcdqa.LOBFormula__c && pcdqa.Carve_Out_Option_3__c != null)
                       {
                        Therapyexist3 = true;
                       }
                     }
                  if (Therapyexist1 == false && pcdqa.Carve_Out_Option_1__c != null)
                     {
                       Rebate_Gtees_Specialty_Class_Carve_Outs__c RGteenew = new Rebate_Gtees_Specialty_Class_Carve_Outs__c();
                       RGteenew.Year__c = yr;
                       RGteenew.FAF_ID__c = pcdqa.FAF_ID__c;
                       RGteenew.Rebate_Operations__c=ROps[0].ID;
                       if (ROps[0].Percentage_Guarantee__c == true)
                       RGteenew.RecordTypeId = Label.RGteeRecordType_Percentage;
                       else
                       RGteenew.RecordTypeId = Label.RGteeRecordType;
                       RGteenew.Drug_Therapy_Class_2__c = pcdqa.Carve_Out_Option_1__c;
                       RGteenew.LOB2__c = pcdqa.LOBFormula__c;
                       RGteeinsert.add(RGteenew);
                     }
                  if (Therapyexist2 == false && pcdqa.Carve_Out_Option_2__c != null &&  pcdqa.Carve_Out_Option_2__c !=  pcdqa.Carve_Out_Option_1__c)
                     {
                       Rebate_Gtees_Specialty_Class_Carve_Outs__c RGteenew = new Rebate_Gtees_Specialty_Class_Carve_Outs__c();
                       RGteenew.Year__c = yr;
                       if (ROps[0].Percentage_Guarantee__c == true)
                       RGteenew.RecordTypeId = Label.RGteeRecordType_Percentage;
                       else
                       RGteenew.RecordTypeId = Label.RGteeRecordType;
                       RGteenew.FAF_ID__c = pcdqa.FAF_ID__c;
                       RGteenew.Rebate_Operations__c=ROps[0].ID;
                       RGteenew.Drug_Therapy_Class_2__c = pcdqa.Carve_Out_Option_2__c;
                       RGteenew.LOB2__c = pcdqa.LOBFormula__c;
                       RGteeinsert.add(RGteenew);
                     }
                  if (Therapyexist3 == false && pcdqa.Carve_Out_Option_3__c != null && pcdqa.Carve_Out_Option_3__c !=  pcdqa.Carve_Out_Option_2__c &&  pcdqa.Carve_Out_Option_3__c !=  pcdqa.Carve_Out_Option_1__c)
                     {
                       Rebate_Gtees_Specialty_Class_Carve_Outs__c RGteenew = new Rebate_Gtees_Specialty_Class_Carve_Outs__c();
                       RGteenew.Year__c = yr;
                       if (ROps[0].Percentage_Guarantee__c == true)
                       RGteenew.RecordTypeId = Label.RGteeRecordType_Percentage;
                       else
                       RGteenew.RecordTypeId = Label.RGteeRecordType;
                       RGteenew.FAF_ID__c = pcdqa.FAF_ID__c;
                       RGteenew.Rebate_Operations__c=ROps[0].ID;
                       RGteenew.Drug_Therapy_Class_2__c = pcdqa.Carve_Out_Option_3__c;
                       RGteenew.LOB2__c = pcdqa.LOBFormula__c;
                       RGteeinsert.add(RGteenew);
                     }
                    
                     
                }                      
              }
              if (pcdqa.Speciality_Option__c == 'YES' && (pcdqa.Additional_Speciality_Option__c != null || pcdqa.Additional_Speciality_Option_EGWP__c != null) && !SpecPricingMap.isEmpty())
              {
    //**************Start - Specialty Pricing Cloning of Existing Record****************/
                   /*   Map<String, String> fieldsToResetChild = new Map<String, String>();
                      if (pcdqa.LOBFormula__c == 'EGWP' && pcdqa.Additional_Speciality_Option_EGWP__c != null)
                      {
                       fieldsToResetChild.put('Pharmacy_Benefit__c',pcdqa.Additional_Speciality_Option_EGWP__c);
                      }
                      else
                      {
                      fieldsToResetChild.put('Pharmacy_Benefit__c',pcdqa.Additional_Speciality_Option__c);
                      }
                      fieldsToResetChild.put('Agreement_Line_Item__c',Ops[0].Agreement_Line_Item__c);
                      fieldsToResetChild.put('PCDQSCreation__c','FALSE');
                      fieldsToResetChild.put('Source_Record_ID__c', null);
                      fieldsToResetChild.put('Brand_Rate__c', null);
                      fieldsToResetChild.put('Brand_Dispensing_Fee__c', null);
                      fieldsToResetChild.put('Generic_Dispensing_Fee__c', null);
                      fieldsToResetChild.put('Generic_Rate__c', null);
                      fieldsToResetChild.put('Non_MAC_Rate__c', null);
                      fieldsToResetChild.put('New_to_Market_Brand_Rate__c', null);
                      fieldsToResetChild.put('New_to_Market_Generic_Rate__c', null);
                      fieldsToResetChild.put('LDD__c', null);
                      fieldsToResetChild.put('LDD_No_Access_Rate__c', null);
                      fieldsToResetChild.put('Limited_Distribution_Drug_LDD_Rate__c', null);               
                      specpriceObj = DeepCloneUtility.PCDcloneRelatedSObject('Specialty_Pricing__c','FAF_ID__c', 
                                                                                new Map<String, Map<Id, Id>> {
                                                                                    'FAF_ID__c'=> new Map<Id, Id>{pcdqa.FAF_ID__c => pcdqa.FAF_ID__c},
                                                                                    'Specialty_Operations__c'=>DeepCloneUtility.getSObjectIds(specobj)
                                                                                }, 
                                                                                null,fieldsToResetChild,null);  
                        
              }
            
            }
      
  //*****************End of Specialty Pricing Record creation*******************/  
    
  //**************Start - Network Pricing Record Creation ****************//
      
     /*   if (pcdqa.Agreement_Line_Item__c != null 
            && (pcdqa.Network_Name_Optional1_LK__c != null || 
                pcdqa.Optional_Network_Name2_LK__c != null ||
                pcdqa.Optional_Network_Name3_LK__c != null ||
                pcdqa.Optional_Network_Name4_LK__c != null ||
                pcdqa.Optional_Network_Name5_LK__c != null ||
                pcdqa.Med_D_HIF__c == 'YES'||
                pcdqa.Med_D_IHS__c == 'YES'||
                pcdqa.Med_D_LTC__c == 'YES'||
                pcdqa.Med_D_TER__c == 'YES')) {
                  Network_Name__c NetworkName1 = NetworkNameMap.get(pcdqa.Network_Name_Optional1_LK__c);
                  Network_Name__c NetworkName2 = NetworkNameMap.get(pcdqa.Optional_Network_Name2_LK__c);
                  Network_Name__c NetworkName3 = NetworkNameMap.get(pcdqa.Optional_Network_Name3_LK__c);
                  Network_Name__c NetworkName4 = NetworkNameMap.get(pcdqa.Optional_Network_Name4_LK__c);
                  Network_Name__c NetworkName5 = NetworkNameMap.get(pcdqa.Optional_Network_Name5_LK__c);
             List<SelectOption> OrdinalMap1 = new List<SelectOption>();
             List<SelectOption> OrdinalMap2 = new List<SelectOption>();
             List<SelectOption> OrdinalMap3 = new List<SelectOption>();
             List<SelectOption> OrdinalMap4 = new List<SelectOption>();
             List<SelectOption> OrdinalMap5 = new List<SelectOption>();
             if (NetworkName1 != null)
             {
               OrdinalMap1 = getDependentSelectOptions( 'Network_Pricing__c', 'network_name__c','retail_network_ordinal__c',NetworkName1.Name);  
             }
             if (NetworkName2 != null)
             {
               OrdinalMap2 = getDependentSelectOptions( 'Network_Pricing__c', 'network_name__c','retail_network_ordinal__c',NetworkName2.Name); 
             }
             if (NetworkName3 != null)
             { 
               OrdinalMap3 = getDependentSelectOptions( 'Network_Pricing__c', 'network_name__c','retail_network_ordinal__c',NetworkName3.Name);  
             }
             if (NetworkName4 != null)
             { 
               OrdinalMap4 = getDependentSelectOptions( 'Network_Pricing__c', 'network_name__c','retail_network_ordinal__c',NetworkName4.Name); 
             }
             if (NetworkName5 != null)
             {  
               OrdinalMap5 = getDependentSelectOptions( 'Network_Pricing__c', 'network_name__c','retail_network_ordinal__c',NetworkName5.Name);  
             }
             List<String>  OrdinalStr1 = new List<String>();
             List<String>  OrdinalStr2 = new List<String>();
             List<String>  OrdinalStr3 = new List<String>();
             List<String>  OrdinalStr4 = new List<String>();
             List<String>  OrdinalStr5 = new List<String>();

             for(SelectOption so : OrdinalMap1)
             {
               OrdinalStr1.add(so.getValue());
             }
             for(SelectOption so : OrdinalMap2)
             {
               OrdinalStr2.add(so.getValue());
             }
             for(SelectOption so : OrdinalMap3)
             {
               OrdinalStr3.add(so.getValue());
             }
             for(SelectOption so : OrdinalMap4)
             {
               OrdinalStr4.add(so.getValue());
             }
             for(SelectOption so : OrdinalMap5)
             {
               OrdinalStr5.add(so.getValue());
             }
              Boolean NName1 = false;
              Boolean NName2 = false;
              Boolean NName3 = false;
              Boolean NName4 = false;
              Boolean NName5 = false;
              Boolean MedHIF = false;
              Boolean MedIHS = false;
              Boolean MedLTC = false;
              Boolean MedTER = false;
             for(Network_Pricing__c np:NetOps) {
              if (np.FAF_Network_Ops__c  != null)      // Network Operation record exists
              {   NetworkName1 = NetworkNameMap.get(pcdqa.Network_Name_Optional1_LK__c);
                  NetworkName2 = NetworkNameMap.get(pcdqa.Optional_Network_Name2_LK__c);
                  NetworkName3 = NetworkNameMap.get(pcdqa.Optional_Network_Name3_LK__c);
                  NetworkName4 = NetworkNameMap.get(pcdqa.Optional_Network_Name4_LK__c);
                  NetworkName5 = NetworkNameMap.get(pcdqa.Optional_Network_Name5_LK__c);
               // verify Pricing Record exists
               // 10/24/2019 - Start US153 Network pricing record creation for EGWP LOB  
                 
               if (pcdqa.Med_D_HIF__c == 'YES')
                 {
                 if (Label.Med_D_HIF != null  && (Label.Med_D_HIF == np.Network_Name__c) && (pcdqa.LOBFormula__c == np.LOB__c) && (Label.PCD_Network_Type_Transparent == np.Network_Type__c) && (yr == np.Year__c) )
                   {
                     MedHIF = true;
                   }
                 }
                 
                 if (pcdqa.Med_D_IHS__c == 'YES')
                 {
                 if (Label.Med_D_IHS != null  && (Label.Med_D_IHS == np.Network_Name__c) && (pcdqa.LOBFormula__c == np.LOB__c) && (Label.PCD_Network_Type_Transparent == np.Network_Type__c) && (yr == np.Year__c) )
                   {
                     MedIHS = true;
                   }
                 }
                 
                 if (pcdqa.Med_D_LTC__c == 'YES')
                 {
                 if (Label.Med_D_LTC != null  && (Label.Med_D_LTC == np.Network_Name__c) && (pcdqa.LOBFormula__c == np.LOB__c) && (Label.PCD_Network_Type_Transparent == np.Network_Type__c) && (yr == np.Year__c) )
                   {
                     MedLTC = true;
                   }
                 }
                 
                 if (pcdqa.Med_D_TER__c == 'YES')
                 {
                 if (Label.Med_D_TER != null  && (Label.Med_D_TER == np.Network_Name__c) && (pcdqa.LOBFormula__c == np.LOB__c) && (Label.PCD_Network_Type_Transparent == np.Network_Type__c) && (yr == np.Year__c) )
                   {
                     MedTER = true;
                   }
                 }
                 // 10/24/2019 - End US153 Network pricing record creation for EGWP LOB    
                 if (NetworkName1 != null && NetworkName1.Name != Label.BGHLTH)
                 {
                 if (NetworkName1.Name != null  && (NetworkName1.Name == np.Network_Name__c) && (pcdqa.LOBFormula__c == np.LOB__c) && (pcdqa.Network_Type1__c == np.Network_Type__c) && (yr == np.Year__c) && (pcdqa.Custom_Network_Description1__c == np.Custom_Network_Description__c))
                   {
                     NName1 = true;
                   }
                 if ((NetworkName1.Name == Label.MCCP || NetworkName1.Name == Label.MCCVS ) && (NetworkName1.Name == np.Network_Name__c) && (pcdqa.LOBFormula__c == np.LOB__c) && (yr == np.Year__c))
                   {
                     NName1 = true;
                   }
                 }
                 if (NetworkName2 != null && NetworkName2.Name != Label.BGHLTH)
                 {
                 if (NetworkName2.Name != null  && (NetworkName2.Name == np.Network_Name__c) && (pcdqa.LOBFormula__c == np.LOB__c) && (pcdqa.Network_Type2__c == np.Network_Type__c) && (yr == np.Year__c) && (pcdqa.Custom_Network_Description2__c == np.Custom_Network_Description__c))
                   {
                     NName2 = true;
                   }
                 if ((NetworkName2.Name == Label.MCCP || NetworkName2.Name == Label.MCCVS ) && (NetworkName2.Name == np.Network_Name__c) && (pcdqa.LOBFormula__c == np.LOB__c) && (yr == np.Year__c))
                   {
                     NName2 = true;
                   }
                 }
                 if (NetworkName3 != null && NetworkName3.Name != Label.BGHLTH)
                 {
                 if (NetworkName3.Name != null  && (NetworkName3.Name == np.Network_Name__c) && (pcdqa.LOBFormula__c == np.LOB__c) && (pcdqa.Network_Type3__c == np.Network_Type__c) && (yr == np.Year__c) && (pcdqa.Custom_Network_Description3__c == np.Custom_Network_Description__c))
                   {
                     NName3 = true;
                   }
                 if ((NetworkName3.Name == Label.MCCP || NetworkName3.Name == Label.MCCVS ) && (NetworkName3.Name == np.Network_Name__c) && (pcdqa.LOBFormula__c == np.LOB__c) && (yr == np.Year__c))
                   {
                     NName3 = true;
                   }
                 }
                 if (NetworkName4 != null && NetworkName4.Name != Label.BGHLTH)
                 {
                 if (NetworkName4.Name != null  && (NetworkName4.Name == np.Network_Name__c) && (pcdqa.LOBFormula__c == np.LOB__c) && (pcdqa.Network_Type4__c == np.Network_Type__c) && (yr == np.Year__c) && (pcdqa.Custom_Network_Description4__c == np.Custom_Network_Description__c))
                   {
                     NName4 = true;
                   }
                  if ((NetworkName4.Name == Label.MCCP || NetworkName4.Name == Label.MCCVS ) && (NetworkName4.Name == np.Network_Name__c) && (pcdqa.LOBFormula__c == np.LOB__c) && (yr == np.Year__c))
                   {
                     NName4 = true;
                   }
                  }
                 if (NetworkName5 != null && NetworkName5.Name != Label.BGHLTH)
                 {
                 if (NetworkName5.Name != null  && (NetworkName5.Name == np.Network_Name__c) && (pcdqa.LOBFormula__c == np.LOB__c) && (pcdqa.Network_Type5__c == np.Network_Type__c) && (yr == np.Year__c) && (pcdqa.Custom_Network_Description5__c == np.Custom_Network_Description__c))
                   {
                     NName5 = true;
                   }
                   if ((NetworkName5.Name == Label.MCCP || NetworkName5.Name == Label.MCCVS ) && (NetworkName5.Name == np.Network_Name__c) && (pcdqa.LOBFormula__c == np.LOB__c) && (yr == np.Year__c))
                   {
                     NName5 = true;
                   }
                 }
 
              }  
              
             }
              NetworkName1 = NetworkNameMap.get(pcdqa.Network_Name_Optional1_LK__c);
              NetworkName2 = NetworkNameMap.get(pcdqa.Optional_Network_Name2_LK__c);
              NetworkName3 = NetworkNameMap.get(pcdqa.Optional_Network_Name3_LK__c);
              NetworkName4 = NetworkNameMap.get(pcdqa.Optional_Network_Name4_LK__c);
              NetworkName5 = NetworkNameMap.get(pcdqa.Optional_Network_Name5_LK__c);
              String NetworkUnique1 = NetworkName1 + pcdqa.Network_Type1__c + pcdqa.Custom_Network_Description1__c;
              String NetworkUnique2 = NetworkName2 + pcdqa.Network_Type2__c + pcdqa.Custom_Network_Description2__c;
              String NetworkUnique3 = NetworkName3 + pcdqa.Network_Type3__c + pcdqa.Custom_Network_Description3__c;
              String NetworkUnique4 = NetworkName4 + pcdqa.Network_Type4__c + pcdqa.Custom_Network_Description4__c;
              String NetworkUnique5 = NetworkName5 + pcdqa.Network_Type5__c + pcdqa.Custom_Network_Description5__c;
             if(Ops != null && !Ops.isEmpty())
             {  
             if (NetworkName1 != null)
             {
             if (NName1 == false && NetworkName1.Name != null)
             {
               Network_Pricing__c netpricing = new Network_Pricing__c();
               netpricing.FAF_ID__c = pcdqa.FAF_ID__c;
               netpricing.Year__c = yr;
               if(OrdinalStr1.size()>0)
               {
                netpricing.Retail_Network_Ordinal__c = OrdinalStr1[0]; 
               }
               
               if(Ops!=null){
               netpricing.FAF_Network_Ops__c = Ops[0].ID;
               }
               netpricing.Network_Name__c = NetworkName1.Name;
               netpricing.LOB__c = pcdqa.LOBFormula__c;
               if (NetworkName1.Name == Label.MCCP || NetworkName1.Name == Label.MCCVS)
               {
               netpricing.Network_Type__c = 'Transparent';
               }
               else
               {
               netpricing.Network_Type__c = pcdqa.Network_Type1__c;
               }
               netpricing.Agreement__c = pcdqa.Agreement__c;
               netpricing.Agreement_Line_Item__c = pcdqa.Agreement_Line_Item__c;
               if (NetworkName1.Name == 'Custom' || NetworkName1.Name == 'Custom Secondary')
               {
                 netpricing.Custom_Network_Description__c = pcdqa.Custom_Network_Description1__c;
               }
               lstNetworkpricingToInsert.add(netpricing);
             
             }
             }
             if (NetworkName2 != null)
             {
             if (NName2 == false && NetworkName2.Name != null && (NetworkUnique2 != NetworkUnique1))
             {
               Network_Pricing__c netpricing = new Network_Pricing__c();
               netpricing.FAF_ID__c = pcdqa.FAF_ID__c;
               netpricing.Year__c = yr;
               if (!OrdinalStr2.isEmpty() || OrdinalStr2 != null)
               {
               netpricing.Retail_Network_Ordinal__c = OrdinalStr2[0]; 
               }
               netpricing.FAF_Network_Ops__c = Ops[0].ID;
               netpricing.Network_Name__c = NetworkName2.Name;
               netpricing.LOB__c = pcdqa.LOBFormula__c;
               if (NetworkName2.Name == Label.MCCP || NetworkName2.Name == Label.MCCVS)
               {
               netpricing.Network_Type__c = 'Transparent';
               }
               else
               {
               netpricing.Network_Type__c = pcdqa.Network_Type2__c;
               }
               netpricing.Agreement__c = pcdqa.Agreement__c;
               netpricing.Agreement_Line_Item__c = pcdqa.Agreement_Line_Item__c;
               if (NetworkName2.Name == 'Custom' || NetworkName2.Name == 'Custom Secondary')
               {
                 netpricing.Custom_Network_Description__c = pcdqa.Custom_Network_Description2__c;
               }
               lstNetworkpricingToInsert.add(netpricing);
             }
             }
             if (NetworkName3 != null)
             {
              if (NName3 == false && NetworkName3.Name != null && ((NetworkUnique3 != NetworkUnique2) && (NetworkUnique3 != NetworkUnique1)))
             {
               Network_Pricing__c netpricing = new Network_Pricing__c();
               netpricing.FAF_ID__c = pcdqa.FAF_ID__c;
               netpricing.Year__c = yr;
               if (!OrdinalStr3.isEmpty() || OrdinalStr3 != null)
               {
               netpricing.Retail_Network_Ordinal__c = OrdinalStr3[0]; 
               }
               netpricing.FAF_Network_Ops__c = Ops[0].ID;
               netpricing.Network_Name__c = NetworkName3.Name;
               netpricing.LOB__c = pcdqa.LOBFormula__c;
               if (NetworkName3.Name == Label.MCCP || NetworkName3.Name == Label.MCCVS)
               {
               netpricing.Network_Type__c = 'Transparent';
               }
               else
               {
               netpricing.Network_Type__c = pcdqa.Network_Type3__c;
               }
               netpricing.Agreement__c = pcdqa.Agreement__c;
               netpricing.Agreement_Line_Item__c = pcdqa.Agreement_Line_Item__c;
               if (NetworkName3.Name == 'Custom' || NetworkName3.Name == 'Custom Secondary')
               {
                 netpricing.Custom_Network_Description__c = pcdqa.Custom_Network_Description3__c;
               }
               lstNetworkpricingToInsert.add(netpricing);
             }
             }
             if (NetworkName4 != null)
             {
              if (NName4 == false && NetworkName4.Name != null && ((NetworkUnique4 != NetworkUnique3) && (NetworkUnique4 != NetworkUnique2) && (NetworkUnique4 != NetworkUnique1)))
             {
               Network_Pricing__c netpricing = new Network_Pricing__c();
               netpricing.FAF_ID__c = pcdqa.FAF_ID__c;
               netpricing.Year__c = yr;
               if (!OrdinalStr4.isEmpty() || OrdinalStr4 != null)
               {
               netpricing.Retail_Network_Ordinal__c = OrdinalStr4[0]; 
               }
               netpricing.FAF_Network_Ops__c = Ops[0].ID;
               netpricing.Network_Name__c = NetworkName4.Name;
               netpricing.LOB__c = pcdqa.LOBFormula__c;
               if (NetworkName4.Name == Label.MCCP || NetworkName4.Name == Label.MCCVS)
               {
               netpricing.Network_Type__c = 'Transparent';
               }
               else
               {
               netpricing.Network_Type__c = pcdqa.Network_Type4__c;
               }
               netpricing.Agreement__c = pcdqa.Agreement__c;
               netpricing.Agreement_Line_Item__c = pcdqa.Agreement_Line_Item__c;
               if (NetworkName4.Name == 'Custom' || NetworkName4.Name == 'Custom Secondary')
               {
                 netpricing.Custom_Network_Description__c = pcdqa.Custom_Network_Description4__c;
               }
               lstNetworkpricingToInsert.add(netpricing);
             }
             }
             if (NetworkName5 != null)
             {
              if (NName5 == false && NetworkName5.Name != null && ((NetworkUnique5 != NetworkUnique4) && (NetworkUnique5 != NetworkUnique3) && (NetworkUnique5 != NetworkUnique2) && (NetworkUnique5 != NetworkUnique1)))
             {
               Network_Pricing__c netpricing = new Network_Pricing__c();
               netpricing.FAF_ID__c = pcdqa.FAF_ID__c;
               netpricing.Year__c = yr;
               if (!OrdinalStr5.isEmpty() || OrdinalStr5 != null)
               {
               netpricing.Retail_Network_Ordinal__c = OrdinalStr5[0]; 
               }
               netpricing.FAF_Network_Ops__c = Ops[0].ID;
               netpricing.Network_Name__c = NetworkName5.Name;
               netpricing.LOB__c = pcdqa.LOBFormula__c;
               if (NetworkName5.Name == Label.MCCP || NetworkName5.Name == Label.MCCVS)
               {
               netpricing.Network_Type__c = 'Transparent';
               }
               else
               {
               netpricing.Network_Type__c = pcdqa.Network_Type5__c;
               }
               netpricing.Agreement__c = pcdqa.Agreement__c;
               netpricing.Agreement_Line_Item__c = pcdqa.Agreement_Line_Item__c;
               if (NetworkName5.Name == 'Custom' || NetworkName5.Name == 'Custom Secondary')
               {
                 netpricing.Custom_Network_Description__c = pcdqa.Custom_Network_Description5__c;
               }
               lstNetworkpricingToInsert.add(netpricing);
             }
             
            }
            
         // 10/24/2019 - Start US153 Network pricing record creation for EGWP LOB    
                     
            if (pcdqa.Med_D_HIF__c == 'YES' && MedHIF == false)
             {
              if ((Label.Med_D_HIF != NetworkUnique5) && (Label.Med_D_HIF != NetworkUnique4) && (Label.Med_D_HIF != NetworkUnique3) && (Label.Med_D_HIF != NetworkUnique2) && (Label.Med_D_HIF != NetworkUnique1))
             {
               Network_Pricing__c netpricing = new Network_Pricing__c();
               netpricing.FAF_ID__c = pcdqa.FAF_ID__c;
               netpricing.Year__c = yr;
               netpricing.Retail_Network_Ordinal__c = Label.PCD_Ordinal_Tertiary; 
               netpricing.FAF_Network_Ops__c = Ops[0].ID;
               netpricing.Network_Name__c = Label.Med_D_HIF;
               netpricing.LOB__c = pcdqa.LOBFormula__c;
               netpricing.Network_Type__c = Label.PCD_Network_Type_Transparent;
               netpricing.Agreement__c = pcdqa.Agreement__c;
               netpricing.Agreement_Line_Item__c = pcdqa.Agreement_Line_Item__c;
               netpricing.Brand_Rate__c = decimal.valueOf(Label.PCD_Brand_Rate_HIF);
               netpricing.Non_MAC_Generic_Rate__c = decimal.valueOf(Label.PCD_NonMAC_Rate_HIF);
               netpricing.Brand_Dispensing_Fee__c = decimal.valueOf(Label.PCD_Brand_HIF);
               netpricing.Generic_Dispensing_Fee__c = decimal.valueOf(Label.PCD_Generic_HIF);
               netpricing.Brand_Basis__c=Label.PCD_Brand_Basis;
               netpricing.Generic_Basis__c = Label.PCD_Generic_Basis;
               lstNetworkpricingToInsert.add(netpricing);
             }
             
            }
            
            if (pcdqa.Med_D_IHS__c == 'YES' && MedIHS == false)
             {
              if ((Label.Med_D_IHS != NetworkUnique5) && (Label.Med_D_IHS != NetworkUnique4) && (Label.Med_D_IHS != NetworkUnique3) && (Label.Med_D_IHS != NetworkUnique2) && (Label.Med_D_IHS != NetworkUnique1))
             {
               Network_Pricing__c netpricing = new Network_Pricing__c();
               netpricing.FAF_ID__c = pcdqa.FAF_ID__c;
               netpricing.Year__c = yr;
               netpricing.Retail_Network_Ordinal__c = Label.PCD_Ordinal_Tertiary; 
               netpricing.FAF_Network_Ops__c = Ops[0].ID;
               netpricing.Network_Name__c = Label.Med_D_IHS;
               netpricing.LOB__c = pcdqa.LOBFormula__c;
               netpricing.Network_Type__c = Label.PCD_Network_Type_Transparent;
               netpricing.Agreement__c = pcdqa.Agreement__c;
               netpricing.Agreement_Line_Item__c = pcdqa.Agreement_Line_Item__c;
               netpricing.Brand_Rate__c = decimal.valueOf(Label.PCD_Brand_Rate_IHS);
               netpricing.Non_MAC_Generic_Rate__c = decimal.valueOf(Label.PCD_NonMAC_Rate_IHS);
               netpricing.Brand_Dispensing_Fee__c = decimal.valueOf(Label.PCD_Brand_IHS);
               netpricing.Generic_Dispensing_Fee__c = decimal.valueOf(Label.PCD_Generic_IHS);
               netpricing.Brand_Basis__c=Label.PCD_Brand_Basis;
               netpricing.Generic_Basis__c = Label.PCD_Generic_Basis_Flat;
               lstNetworkpricingToInsert.add(netpricing);
             }
             
            }
            
          if (pcdqa.Med_D_LTC__c == 'YES' && MedLTC == false)
             {
              if ((Label.Med_D_LTC != NetworkUnique5) && (Label.Med_D_LTC != NetworkUnique4) && (Label.Med_D_LTC != NetworkUnique3) && (Label.Med_D_LTC != NetworkUnique2) && (Label.Med_D_LTC != NetworkUnique1))
             {
               Network_Pricing__c netpricing = new Network_Pricing__c();
               netpricing.FAF_ID__c = pcdqa.FAF_ID__c;
               netpricing.Year__c = yr;
               netpricing.Retail_Network_Ordinal__c = Label.PCD_Ordinal_Tertiary; 
               netpricing.FAF_Network_Ops__c = Ops[0].ID;
               netpricing.Network_Name__c = Label.Med_D_LTC;
               netpricing.LOB__c = pcdqa.LOBFormula__c;
               netpricing.Network_Type__c = Label.PCD_Network_Type_Transparent;
               netpricing.Agreement__c = pcdqa.Agreement__c;
               netpricing.Agreement_Line_Item__c = pcdqa.Agreement_Line_Item__c;
               netpricing.Brand_Rate__c = decimal.valueOf(Label.PCD_Brand_Rate_LTC);
               netpricing.Non_MAC_Generic_Rate__c = decimal.valueOf(Label.PCD_NonMAC_Rate_LTC);
               netpricing.Brand_Dispensing_Fee__c = decimal.valueOf(Label.PCD_Brand_LTC);
               netpricing.Generic_Dispensing_Fee__c = decimal.valueOf(Label.PCD_Generic_LTC);
               netpricing.Brand_Basis__c=Label.PCD_Brand_Basis;
               netpricing.Generic_Basis__c = Label.PCD_Generic_Basis;
               lstNetworkpricingToInsert.add(netpricing);
             }
             
            }  
            
            if (pcdqa.Med_D_TER__c == 'YES' && MedTER == false)
             {
              if ((Label.Med_D_TER != NetworkUnique5) && (Label.Med_D_TER != NetworkUnique4) && (Label.Med_D_TER != NetworkUnique3) && (Label.Med_D_TER != NetworkUnique2) && (Label.Med_D_TER != NetworkUnique1))
             {
               Network_Pricing__c netpricing = new Network_Pricing__c();
               netpricing.FAF_ID__c = pcdqa.FAF_ID__c;
               netpricing.Year__c = yr;
               netpricing.Retail_Network_Ordinal__c = Label.PCD_Ordinal_Tertiary; 
               netpricing.FAF_Network_Ops__c = Ops[0].ID;
               netpricing.Network_Name__c = Label.Med_D_TER;
               netpricing.LOB__c = pcdqa.LOBFormula__c;
               netpricing.Network_Type__c = Label.PCD_Network_Type_Transparent;
               netpricing.Agreement__c = pcdqa.Agreement__c;
               netpricing.Agreement_Line_Item__c = pcdqa.Agreement_Line_Item__c;
               netpricing.Brand_Rate__c = decimal.valueOf(Label.PCD_Brand_Rate_TER);
               netpricing.Non_MAC_Generic_Rate__c = decimal.valueOf(Label.PCD_NonMAC_Rate_TER);
               netpricing.Brand_Dispensing_Fee__c = decimal.valueOf(Label.PCD_Brand_TER);
               netpricing.Generic_Dispensing_Fee__c = decimal.valueOf(Label.PCD_Generic_TER);
               netpricing.Brand_Basis__c=Label.PCD_Brand_Basis;
               netpricing.Generic_Basis__c = Label.PCD_Generic_Basis;
               lstNetworkpricingToInsert.add(netpricing);
             }
             
            }  
       // 10/24/2019 - End US153 Network pricing record creation for EGWP LOB 
            
            }
                }
}
}
  
  if(SupdOps != null && !SupdOps.isEmpty())
                {
                    Database.update(SupdOps,false);
                } 
  if(RGteeinsert != null && !RGteeinsert.isEmpty())
                {
                    Database.insert(RGteeinsert);
                } 
 if(!rebateGurlist.isEmpty()){
               insert rebateGurlist;
        }
      /*    //For clonning for rebate Guranatee record last modified
            String RGBGURANTEE='Rebate_Guarantees__c';
            String ID_FIELD='ID';
            List<Sobject> sobjectList=new List<Sobject>();
            List<Rebate_Guarantees__c> rebateGuranateeList=[Select ID,FAF_ID__c,Non_Specialty_Formulary_2__c,Specialty_Formulary__c From Rebate_Guarantees__c where FAF_ID__c IN: ids Order By LastModifiedDate ASC limit 1 ];
            for(Rebate_Guarantees__c rbG:rebateGuranateeList){
                if(mapPlandesign.get(rbG.FAF_ID__c)!=null){
                SObject cloneSObj1=DeepCloneUtility.getSObjectRecords(RGBGURANTEE,ID_FIELD, new Set<Id>{rbG.id}, null, null)[0];
                SObject cloneSObj=cloneSObj1.clone(false,false);
                Rebate_Guarantees__c cloneQS=(Rebate_Guarantees__c)cloneSObj;
                cloneQS.Plan_Design__c=mapPlandesign.get(rbG.FAF_ID__c);
                sobjectList.add(cloneQS);
                }
            }
            if(!sobjectList.isEmpty()){
            insert sobjectList;
            } */
 /*if(lstNetworkpricingToInsert != null && !lstNetworkpricingToInsert.isEmpty())
        {
                    Database.upsert(lstNetworkpricingToInsert,false);
        } 
                
//If Question - 'Do you want to provide an optional Network Type option to include both Traditional and Transparent?' is 'YES' need to have another set of record with other set of Network Type
for(PCD_Question_Answer__c pcdqa : PCDQAList){
  
  if(pcdqa.Additional_Tier_Options__c == 'YES' && !rebateGtee.isEmpty())
              {
    //**************Rebate Guarantee Cloning of Existing Record****************/
           /* String[] strtier;
                    if (pcdqa.Tier_Option_s__c != null)
                    {
                     strtier = pcdqa.Tier_Option_s__c.split(';');
                    }
            List<Rebate_Guarantees__c> sobjectList=new List<Rebate_Guarantees__c>();
            List<Rebate_Guarantees__c> rebateGuranateeList=[Select ID,Basis__c,GSTP__c,Select_Specialty_Therapy_Class_es_2__c,Agreement__c,year__c,LOB2__c,FAF_ID__c,Non_Specialty_Formulary_2__c,Specialty_Formulary__c,Plan_Design__c,
            Agreement_Line_Item__c,Retail_30__c,Retail_30_1__c,Retail_90__c,Retail_90_1__c,Client_Owned_30__c,Client_Owned_30_1__c,Client_Owned_90__c,
            Client_Owned_90_1__c,Mail__c,Mail_1__c,Mchoice__c,Mchoice_1__c,Specialty_Retail__c,Specialty_Retail_1__c,Source_Record_ID__c,Rebate_Operations__c  From Rebate_Guarantees__c where FAF_ID__c IN: ids  ];
            if (strtier != null)
            {
            for(String tier : strtier)
             {
              for(Rebate_Guarantees__c rbG:rebateGuranateeList)
              {
                SObject cloneSObj= rbG.clone(false,false);
                Rebate_Guarantees__c cloneQS=(Rebate_Guarantees__c)cloneSObj;
                      cloneQS.Plan_Design__c=tier;
                      cloneQS.Agreement_Line_Item__c =Ops[0].Agreement_Line_Item__c;
                      cloneQS.Retail_30__c=null;
                      cloneQS.Retail_30_1__c=null;
                      cloneQS.Retail_90__c=null;
                      cloneQS.Retail_90_1__c=null;
                      cloneQS.Client_Owned_30__c=null;
                      cloneQS.Client_Owned_30_1__c=null;
                      cloneQS.Client_Owned_90__c=null;
                      cloneQS.Client_Owned_90_1__c=null;
                      cloneQS.Mail__c=null;
                      cloneQS.Mail_1__c=null;
                      cloneQS.Mchoice__c=null;
                      cloneQS.Mchoice_1__c=null;
                      cloneQS.Specialty_Retail__c=null;
                      cloneQS.Specialty_Retail_1__c=null;
                      cloneQS.Specialty__c=null;
                      cloneQS.Specialty_1__c=null;
                      cloneQS.Source_Record_ID__c= null;
                      cloneQS.Rebate_Operations__c= ROps[0].ID;
                      Boolean recexist = false;
                      for (Rebate_Guarantees__c rg : rebateGuranateeList)
                                          {
                                           if ((cloneQS.Year__c == rg.Year__c) && (cloneQS.LOB2__c == rg.LOB2__c) && (cloneQS.Plan_Design__c == rg.Plan_Design__c) && (cloneQS.GSTP__c == rg.GSTP__c) && (cloneQS.Non_Specialty_Formulary_2__c == rg.Non_Specialty_Formulary_2__c)  && (cloneQS.Specialty_Formulary__c == rg.Specialty_Formulary__c) && cloneQS.Plan_Design__c != null) 
                                           {
                                            recexist = true;
                                           }
                                          }
                      if(recexist == false)
                      {
                      for(Rebate_Guarantees__c so : sobjectList)
                      {
                      if ((cloneQS.Year__c == so.Year__c) && (cloneQS.LOB2__c == so.LOB2__c) && (cloneQS.Plan_Design__c == so.Plan_Design__c) && (cloneQS.GSTP__c == so.GSTP__c) && (cloneQS.Non_Specialty_Formulary_2__c == so.Non_Specialty_Formulary_2__c)  && (cloneQS.Specialty_Formulary__c == so.Specialty_Formulary__c))
                      recexist = true;
                      }
                      }
                      if(recexist == false)
                      { 
                       sobjectList.add(cloneQS);
                      }
              }
             
                      Map<String, String> fieldsToResetChild = new Map<String, String>();
                      fieldsToResetChild.put('Plan_Design__c',tier);
                      fieldsToResetChild.put('Agreement_Line_Item__c',Ops[0].Agreement_Line_Item__c);
                      fieldsToResetChild.put('Retail_30__c',null);
                      fieldsToResetChild.put('Retail_30_1__c',null);
                      fieldsToResetChild.put('Retail_90__c',null);
                      fieldsToResetChild.put('Retail_90_1__c',null);
                      fieldsToResetChild.put('Client_Owned_30__c',null);
                      fieldsToResetChild.put('Client_Owned_30_1__c',null);
                      fieldsToResetChild.put('Client_Owned_90__c',null);
                      fieldsToResetChild.put('Client_Owned_90_1__c',null);
                      fieldsToResetChild.put('Mail__c',null);
                      fieldsToResetChild.put('Mail_1__c',null);
                      fieldsToResetChild.put('Mchoice__c',null);
                      fieldsToResetChild.put('Mchoice_1__c',null);
                      fieldsToResetChild.put('Specialty_Retail__c',null);
                      fieldsToResetChild.put('Specialty_Retail_1__c',null);
                      fieldsToResetChild.put('Source_Record_ID__c', null);
                      fieldsToResetChild.put('Rebate_Operations__c', ROps[0].ID);
                      fieldsToResetChild.put('PCDQSCreation__c','FALSE');
                      Map<Id,Id> Ropsid= new Map<Id,Id>();
                      Ropsid.put(ROps[0].ID,ROps[0].ID);
                    /*  rebategteeObj = DeepCloneUtility.PCDcloneRelatedSObject('Rebate_Guarantees__c','FAF_ID__c', 
                                                                                new Map<String, Map<Id, Id>> {
                                                                                    'FAF_ID__c'=> new Map<Id, Id>{pcdqa.FAF_ID__c => pcdqa.FAF_ID__c},
                                                                                    'Rebate_Operations__c'=> Ropsid
                                                                                }, 
                                                                                null,fieldsToResetChild,null); */
             /*} 
             }
             if(!sobjectList.isEmpty())
              {
              
              insert sobjectList;
              }
              }


 if (pcdqa.Include_Optional_Network_Option_to_T_T__c == 'YES')
 {
 
  Map<Id, SObject> networkobj = new Map<Id, SObject>([ Select Id, Name,Agreement_Line_Item__c From Network_Operations__c Where FAF_ID__c = :pcdqa.FAF_ID__c ]);
  List<Network_Pricing__c>  NetPri = [SELECT ID,FAF_ID__c,Network_Type__c FROM Network_Pricing__c where FAF_ID__c=:pcdqa.FAF_ID__c];
  Map<ID,Retail_Network_Guarantees__c>  NetGtee = new Map<Id, Retail_Network_Guarantees__c>([SELECT ID,Network_Pricing__c,FAF_ID__c FROM Retail_Network_Guarantees__c where FAF_ID__c=:pcdqa.FAF_ID__c]);

  //Network Pricing */
  /*Map<String, String> fieldsToResetChild = new Map<String, String>();
  fieldsToResetChild.put('Brand_Rate__c',null);
  fieldsToResetChild.put('Preferred_Brand_Rate__c',null);
  fieldsToResetChild.put('Non_Preferred_Brand_Rate__c',null);
  fieldsToResetChild.put('Generic_Rate__c',null);
  fieldsToResetChild.put('Non_MAC_Generic_Rate__c',null);
  fieldsToResetChild.put('Generic_Dispensing_Fee__c',null);
  fieldsToResetChild.put('Brand_Dispensing_Fee__c',null);
   fieldsToResetChild.put('Network_Type__c','PCD');
   fieldsToResetChild.put('Agreement_Line_Item__c',Ops[0].Agreement_Line_Item__c);
   fieldsToResetChild.put('PCDQSCreation__c','FALSE');
   fieldsToResetChild.put('Source_Record_ID__c', null);
 
    networkpriceObj= DeepCloneUtility.PCDcloneRelatedSObject('Network_Pricing__c','FAF_ID__c', 
                                                                                new Map<String, Map<Id, Id>> {
                                                                                    'FAF_ID__c'=> new Map<Id, Id>{pcdqa.FAF_ID__c => pcdqa.FAF_ID__c},
                                                                                    'FAF_Network_Ops__c'=>DeepCloneUtility.getSObjectIds(networkobj)
                                                                                }, 
                                                                                null,fieldsToResetChild,null);                                                                       
    
     List<Network_Pricing__c>  ClonePric = [Select ID,SOURCE_RECORD_ID__C,PCDQSCreation__c FROM Network_Pricing__c where FAF_ID__c=:PCDqs[0].FAF_ID__c
     and PCDQSCreation__c = true];
     List<Network_Pricing__c>  updnp = new List<Network_Pricing__c>();
     Map<String, String> fieldsToResetGrandChild = new Map<String, String>();
     fieldsToResetGrandChild.put('Rate__c',null);
     for(Network_Pricing__c np: ClonePric) {
     Id cId = np.Id;
     Id sId = np.Source_Record_Id__c;
     fieldsToResetGrandChild.put('Network_Pricing__c',cId);
     Map<Id,Id> NetPrice= new Map<Id,Id>();
     NetPrice.put(sId,cId);
     if (sId != null)
     {
      Map<Id, SObject> networkpriceGrObj= DeepCloneUtility.PCDcloneRelatedSObject('Retail_Network_Guarantees__c','Network_Pricing__c', 
                                                                                new Map<String, Map<Id, Id>> {
                                                                                'Network_Pricing__c'=> new Map<Id, Id>{sId => cId },
                                                                                'Network_Pricing__c'=>NetPrice
                                                                                }, 
                                                                                null,fieldsToResetGrandChild,null);                             
      }  
      np.PCDQSCreation__c = false;
      updnp.add(np);
      }  
      if(updnp!= null && !updnp.isEmpty())
      {

        Database.update(updnp,false);
      } 
 }
                                             }
List<id> objId = new List<id>();
List<id> fafIds = new List<id>();
List<id> clinicId = new List<id>();
objId.add(Ops[0].Id);
fafIds.add(FAFID);
HandleNetworkPricingFutureCall.UpdateNetworkPricingFuture(objId);

HandleNetworkPricingFutureCall.UpdateRebateGuarantee(fafIds); 
HandleNetworkPricingFutureCall.UpdateSpecialtyGrid(fafIds); 
List<Clinical_Operations__c>  Clinical = [Select ID FROM Clinical_Operations__c where FAF_ID__c=:FAFID];
clinicId.add(Clinical[0].Id);

HandleNetworkPricingFutureCall.UpdateAdditionalProgramGrid(clinicId); 
Invoke_Update_FAF.Invoke_Update_FAF_Update_Async(fafIds);
DeepCloneUtility.OFF_INVOCABLE_CLASS = true;
}
Catch(Exception ex)
          {     
              system.debug(':::exception:::'+ex);
             
          }
}
}
/* ==============================================================================================================
 * @Class Name      : getDependentSelectOptions
 * @author            : Soumendu Chowdhury
 * @created date      : 05/06/2019
 * @Last modified by  : Soumendu Chowdhury
 * @Last modified date: 05/06/2019
 * @Purpose           : Method to identify Dependent picklist 'Retail Network Ordinal' of repesctive Network Name
==================================================================================================================*/
/*public static List<SelectOption> getDependentSelectOptions(String objectType, String controllerName, String dependentFieldName, String parentValue) {
   /*List<SelectOption> dependentItems = new list<SelectOption>();
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
                if (bitIdx == parentValueIndex )
                {
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
    /************************************************************************
                          Fetch Agreement Line Item 
    
    *************************************************************************/
        
    /*Public Static void FetchAgreementLineItem(List<PCD_Question_Answer__c> PCDList){
    
            set<Id> ALIdSet = new set<Id>();
         /*   Apttus__WizardRuntimeInput__c Wrtp = [SELECT id, Name ,CreatedDate, Apttus__ResponseValue__c from Apttus__WizardRuntimeInput__c 
            where Control_Name__c='Agreement line Item ID' order by CreatedDate desc limit 1 ];
            
            Apttus__AgreementLineItem__c ALI =[SELECT Id,Apttus__AgreementId__c from Apttus__AgreementLineItem__c where ID = :wrtp.Apttus__ResponseValue__c];
            
            Apttus__WizardRuntimeInput__c WrtpLob = [SELECT id, Name ,CreatedDate, Apttus__ResponseValue__c from Apttus__WizardRuntimeInput__c 
            where Control_Name__c='LOB' order by CreatedDate desc limit 1 ]; */
            /*Apttus__WizardRuntimeInput__c WrtpAgreement = [SELECT id, Name ,CreatedDate, Apttus__ResponseValue__c from Apttus__WizardRuntimeInput__c 
            where Control_Name__c='Agreement' order by CreatedDate desc limit 1 ]; */
            
           /* Apttus__Wizard2__c WrtpWizdesign = [SELECT id,Name from Apttus__Wizard2__c 
            order by CreatedDate desc limit 1 ]; */
            
         /*   if(Wrtp != null){ */
                /*for(PCD_Question_Answer__c pcd: PCDList){
                    //pcd.test__c =wrtp.id;
                   /* pcd.Agreement_Line_Item__c = wrtp.Apttus__ResponseValue__c;
                    pcd.LOB1__c=WrtpLob.Apttus__ResponseValue__c; 
                    if (ALI != null)
                    {
                    pcd.Agreement__c=ALI.Apttus__AgreementId__c;
                    system.debug('-PCD Agreement:'+ALI.Apttus__AgreementId__c);
                    }
                    pcd.WizardDesignId__c=WrtpWizdesign.id; */

                     /*if (pcd.Speciality_level_Pharamacy_Benifit_Carve__c != 'YES')
                    {
                     pcd.Carve_Out_Option_1__c = null;
                     pcd.Carve_Out_Option_2__c = null;
                     pcd.Carve_Out_Option_3__c = null;
                     
                    }
                     if (pcd.Formulary_Type_Rebates__c != 'YES')
                    {
                     pcd.Specialty_Formulary_option1_LK__c = null;
                     pcd.Specialty_Formulary_option2_LK__c = null;
                     pcd.Specialty_Formulary_option3_LK__c = null;
                     pcd.Non_Speciality_Formulary1_option_LK__c = null;
                     pcd.Non_Specialty_Formulary_option2_LK__c = null;
                     pcd.Non_Specialty_Formulary_option3_LK__c = null;
                    }
                    if (pcd.Do_you_want_to_provide_Network_name__c != 'YES')
                    {
                     pcd.Network_Name_Optional1_LK__c = null;
                     pcd.Optional_Network_Name2_LK__c = null;
                     pcd.Optional_Network_Name3_LK__c = null;
                     pcd.Optional_Network_Name4_LK__c = null;
                     pcd.Optional_Network_Name5_LK__c = null;
                     pcd.Network_Type1__c = null;
                     pcd.Network_Type2__c = null;
                     pcd.Network_Type3__c = null;
                     pcd.Network_Type4__c = null;
                     pcd.Network_Type5__c = null;
                     pcd.Custom_Network_Description1__c = null;
                     pcd.Custom_Network_Description2__c = null;
                     pcd.Custom_Network_Description3__c = null;
                     pcd.Custom_Network_Description4__c = null;
                     pcd.Custom_Network_Description5__c = null; 
                    }
                    if (pcd.Network_Name_Optional1_LK__c == null)
                    {
                    pcd.Network_Type1__c = null;
                    pcd.Custom_Network_Description1__c = null;
                    }
                    if (pcd.Optional_Network_Name2_LK__c == null)
                    {
                    pcd.Network_Type2__c = null;
                    pcd.Custom_Network_Description2__c = null;
                    }
                    if (pcd.Optional_Network_Name3_LK__c == null)
                    {
                    pcd.Network_Type3__c = null;
                    pcd.Custom_Network_Description3__c = null;
                    }
                    if (pcd.Optional_Network_Name4_LK__c == null)
                    {
                    pcd.Network_Type4__c = null;
                    pcd.Custom_Network_Description4__c = null;
                    }
                    if (pcd.Optional_Network_Name5_LK__c == null)
                    {
                    pcd.Network_Type5__c = null;
                    pcd.Custom_Network_Description5__c = null;
                    }
                    if (pcd.Network_Name_Optional1_LK__c != System.Label.Custom && pcd.Network_Name_Optional1_LK__c != System.Label.Custom_Secondary)
                    {
                    pcd.Custom_Network_Description1__c = null;
                    }
                    if (pcd.Optional_Network_Name2_LK__c != System.Label.Custom && pcd.Optional_Network_Name2_LK__c != System.Label.Custom_Secondary)
                    {
                    pcd.Custom_Network_Description2__c = null;
                    }
                    if (pcd.Optional_Network_Name3_LK__c != System.Label.Custom && pcd.Optional_Network_Name3_LK__c != System.Label.Custom_Secondary)
                    {
                    pcd.Custom_Network_Description3__c = null;
                    }
                   if (pcd.Optional_Network_Name4_LK__c != System.Label.Custom && pcd.Optional_Network_Name4_LK__c != System.Label.Custom_Secondary)
                    {
                    pcd.Custom_Network_Description4__c = null;
                    }
                   if (pcd.Optional_Network_Name5_LK__c != System.Label.Custom && pcd.Optional_Network_Name5_LK__c != System.Label.Custom_Secondary)
                    {
                    pcd.Custom_Network_Description5__c = null;
                    }
                    if (pcd.Additional_Tier_Options__c != 'YES')
                    {
                      pcd.Tier_Option_s__c = null;
                    }
                    if (pcd.Speciality_Option__c != 'YES')
                    {
                      pcd.Additional_Speciality_Option__c = null;
                    }
                    if (pcd.Speciality_at_Retail_Pricing__c != 'YES')
                    {
                      pcd.Match_with_Network_pricing__c = null;
                    }
            }    
          
        }
}
}*/
}