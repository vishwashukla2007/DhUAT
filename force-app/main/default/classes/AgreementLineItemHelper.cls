/*public class AgreementLineItemHelper {
Public Static void FetchWizrdDesignId(List<Apttus__AgreementLineItem__c> AgreementList){
Apttus__Wizard2__c WrtpWizdesign = [SELECT id from Apttus__Wizard2__c 
order by CreatedDate desc limit 1 ];
if(WrtpWizdesign != null){
for(Apttus__AgreementLineItem__c AGL: AgreementList){
AGL.Last_PCD_Question_Answer__c=WrtpWizdesign.id;

}
}
}
} */
public class AgreementLineItemHelper {
    Public Static void FetchWizrdDesignId(List<Apttus__AgreementLineItem__c> AgreementList){
        Set<Id> FAFID = new Set<Id>();
        for(Apttus__AgreementLineItem__c AGL: AgreementList){
            FAFID.add(AGL.PCD_FAF__c);
        }
        List<Clinical_Operations__c> ClinicalSol = [SELECT Clinical_Solutions_Count__c from Clinical_Operations__c
                                                    where FAF_ID__c IN :FAFID LIMIT 1];
        List<Specialty_Operations__c> SpecialtyOps = [SELECT Pharmacy_Benefit__c,Specialty_Pricing_Pharmacy_Benefit_Count__c from Specialty_Operations__c
                                                      where FAF_ID__c IN :FAFID LIMIT 1];
        List<Network_Operations__c> NetworkOps = [SELECT Med_D_HIF__c,Med_D_IHS__c,Med_D_LTC__c,Med_D_TER__c from Network_Operations__c
                                                  where FAF_ID__c IN :FAFID LIMIT 1];
        if(ClinicalSol != null && !ClinicalSol.isEmpty()){
            for(Apttus__AgreementLineItem__c AGL: AgreementList)
            {
                AGL.Clinical_Solution_Count__c=ClinicalSol[0].Clinical_Solutions_Count__c;
            }   
        }
        if(SpecialtyOps != null && !SpecialtyOps.isEmpty() )
        {
            for(Apttus__AgreementLineItem__c AGL: AgreementList){
                if(SpecialtyOps[0].Pharmacy_Benefit__c != null)
                {
                    AGL.Specialty_Operation_Pharmacy_Benefit__c=SpecialtyOps[0].Pharmacy_Benefit__c;
                }
                if (SpecialtyOps[0].Specialty_Pricing_Pharmacy_Benefit_Count__c != null && SpecialtyOps[0].Specialty_Pricing_Pharmacy_Benefit_Count__c > 0)
                { 
                    AGL.Specialty_Pricing_Pharmacy_Benefit__c = true;
                }
            }
        } 
        
        if(NetworkOps != null && !NetworkOps.isEmpty())
        {
            for(Apttus__AgreementLineItem__c AGL: AgreementList){
                AGL.Med_D_HIF__c=NetworkOps[0].Med_D_HIF__c;
                AGL.Med_D_IHS__c=NetworkOps[0].Med_D_IHS__c;
                AGL.Med_D_LTC__c=NetworkOps[0].Med_D_LTC__c;
                AGL.Med_D_TER__c=NetworkOps[0].Med_D_TER__c;
            }   
        }
        
    }
    
}