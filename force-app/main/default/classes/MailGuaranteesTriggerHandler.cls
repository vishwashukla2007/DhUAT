/* ================================================
 * @Trigger Name      : MailGuaranteestrigger 
 * @author            : Kiran
 * @Purpose           : Helper class for updating SSG into Brands=False
 ===================================================
 * @Modified          : To fix SSG Exclusion List and SSG Exclusivity Period values are set to'null'  ***by Sneha Inturi****
 * @Test_Class        : Test_MailGuaranteesTriggerHandler
================================================*/ 
public class MailGuaranteesTriggerHandler 
{
    public static void mgAfterDeleteHandler( list<Mail_Guarantees__c> mgOldList )
    {
           try{ //req: make SSGs_into_Brands__c as False 
            set<Id> mpIdSet = new set<Id>();
        
            for( Mail_Guarantees__c mg : mgOldList )
            {
                mpIdSet.add(mg.Mail_Pricing__c);
            }
            
            List<Mail_Pricing__c> MPList = new List<Mail_Pricing__c>();
            List<Mail_Pricing__c> MPListUpdate = new List<Mail_Pricing__c>();
            
            MPList=[select id,SSG_Exclusion_List__c,SSG_Exclusivity_Period__c,SSGs_into_Brands__c,(select id,SSG__C,Type__c  from Mail_Guarantee__r where SSG__C = 'No' OR Type__c = 'BER' OR Type__c = 'SSG'  ) from Mail_Pricing__c where id IN:mpIdSet and (SSG_Exclusion_List__c!='' OR SSG_Exclusivity_Period__c!='' OR SSGs_into_Brands__c=true) ];
            
            if(MPList.size()>0){
                    for(Mail_Pricing__c MP:MPList){
                        If(MP.Mail_Guarantee__r.isempty()){
                             Mail_Pricing__c temp=new Mail_Pricing__c (id=MP.id,SSG_Exclusion_List__c='',SSG_Exclusivity_Period__c='',SSGs_into_Brands__c=false);
                             MPListUpdate.add(temp);
                        }
                        else{
                            boolean brands=false;
                            boolean SSG=false;
                            for(Mail_Guarantees__c Mg:MP.Mail_Guarantee__r){
                                if(Mg.SSG__C=='No')
                                    SSG=true;
                                 if(mg.Type__c == 'BER' || mg.Type__c == 'SSG' )
                                     brands=true;
                            }
                            
                            if(!brands || !SSG){
                                Mail_Pricing__c temp=new Mail_Pricing__c (id=MP.id);
                                
                                if(!brands)
                                  temp.SSGs_into_Brands__c =false;
                                if(!SSG){
                                    temp.SSG_Exclusivity_Period__c = null;
                                    temp.SSG_Exclusion_List__c = null;
                                }
                                MPListUpdate.add(temp);
                                
                            }
                            
                        }
                    }
                    
             }
            if(MPListUpdate.size()>0)
                  update MPListUpdate;
            }catch(exception e){mgOldList[0].adderror(e.getMessage());}  
    }
}