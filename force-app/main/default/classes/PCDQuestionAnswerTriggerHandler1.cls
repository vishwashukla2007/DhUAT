public class PCDQuestionAnswerTriggerHandler1 {
/*    
                       
Public Static void FetchAgreementLineItem(List<PCD_Question_Answer__c> PCDList){

    set<Id> ALIdSet = new set<Id>();
    Apttus__WizardRuntimeInput__c Wrtp = [SELECT id, Name ,CreatedDate, Apttus__ResponseValue__c from Apttus__WizardRuntimeInput__c 
    where Control_Name__c='Agreement line Item ID' order by CreatedDate desc limit 1 ];
    
    Apttus__AgreementLineItem__c ALI =[SELECT Id,Apttus__AgreementId__c from Apttus__AgreementLineItem__c where ID = :wrtp.Apttus__ResponseValue__c];
    
    Apttus__WizardRuntimeInput__c WrtpLob = [SELECT id, Name ,CreatedDate, Apttus__ResponseValue__c from Apttus__WizardRuntimeInput__c 
    where Control_Name__c='LOB' order by CreatedDate desc limit 1 ];
    /*Apttus__WizardRuntimeInput__c WrtpAgreement = [SELECT id, Name ,CreatedDate, Apttus__ResponseValue__c from Apttus__WizardRuntimeInput__c 
    where Control_Name__c='Agreement' order by CreatedDate desc limit 1 ]; */
    
    /*Apttus__Wizard2__c WrtpWizdesign = [SELECT id,Name from Apttus__Wizard2__c 
    order by CreatedDate desc limit 1 ];
    
    if(Wrtp != null){
        for(PCD_Question_Answer__c pcd: PCDList){
            pcd.test__c =wrtp.id;
            pcd.Agreement_Line_Item__c = wrtp.Apttus__ResponseValue__c;
            pcd.LOB1__c=WrtpLob.Apttus__ResponseValue__c;
            if (ALI != null)
            {
            pcd.Agreement__c=ALI.Apttus__AgreementId__c;
            system.debug('-PCD Agreement:'+ALI.Apttus__AgreementId__c);
            }
            pcd.WizardDesignId__c=WrtpWizdesign.id;

             if (pcd.Speciality_level_Pharamacy_Benifit_Carve__c != 'YES')
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