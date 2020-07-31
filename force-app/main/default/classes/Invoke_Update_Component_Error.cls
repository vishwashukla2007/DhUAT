/*=================================================================================
 * @Method Name       : Invoke_Update_Component_Error
 * @author            : Mohit Srivastava
 * @created date      : 11/05/2019
 * @Last modified by  : Mohit Srivastava
 * @Purpose           : Apex class to check FAF Data Quality at PCD process and capture Validation Error to notify
=======================================================================================*/
public class Invoke_Update_Component_Error
{
/*=================================================================================
 * @Method Name       : Invoke_Update_Component_Error_Method
 * @author            : Mohit Srivastava
 * @created date      : 11/05/2019
 * @Last modified by  : Mohit Srivastava
 * @Purpose           : Apex class to check FAF Data Quality at PCD process and capture Validation Error to notify
=======================================================================================*/
    
    public static void Invoke_Update_Component_Error_Method(Set<ID> AgreementID,Boolean callType)
    {
    DeepCloneUtility.OFF_TRIGGERS_PROCBUILDER=false;
      if(DeepCloneUtility.OFF_INVOCABLE_CLASS){
        String Error;
        Integer Counter=0;
        map<ID,String> mapError=new map<ID,String>();
        map<ID,Integer> mapCounter=new map<ID,Integer>();
        List<Apttus__APTS_Agreement__c> agrUpdateList=new List<Apttus__APTS_Agreement__c>(); 
        List<Apttus__AgreementLineItem__c> agrline=[SELECT Id,Apttus__AgreementId__c,Component_Error__c,PCD_FAF__c,FAF_Name__c,Network_Operation_Link__c,
                       Network_Pricing_Link__c,Mail_Operation_Link__c,Mail_Pricing_Link__c,Billing_Admin_Link__c,Rebate_Operation_Link__c,Rebate_Guarantee_Link__c,
                       Client_Information_Link__c,Clinical_Solution_Link__c,
                       Specialty_Operation_Link__c,Specialty_Pricing_Link__c,Rebate_Carve_Out_Link__c 
                       FROM Apttus__AgreementLineItem__c Where Apttus__AgreementId__c IN:AgreementID];
        
        for(Apttus__AgreementLineItem__c agrlineObj:agrline){
        system.Debug('agrlineObj.Component_Error__c'+agrlineObj.Component_Error__c);
        System.debug('Errorrrrrrrrrrrrr'+Error);
        if(agrlineObj.Component_Error__c!=null){
        if(Error!=null){
            Error+=agrlineObj.Component_Error__c+'\n'+'\n';
         }
         else{
         Error=agrlineObj.Component_Error__c+'\n'+'\n';
         }
         
      }
           System.debug('Errorrrrrrrrrrrrr'+Error);
          
          mapError.put(agrlineObj.Apttus__AgreementId__c,Error);
         
           if(agrlineObj.Network_Pricing_Link__c==true|| 
                agrlineObj.Mail_Operation_Link__c==true||
                    agrlineObj.Mail_Pricing_Link__c ==true||
                        agrlineObj.Rebate_Operation_Link__c==true ||
                            agrlineObj.Rebate_Guarantee_Link__c==true||
                                agrlineObj.Network_Operation_Link__c==true||
                                    agrlineObj.Client_Information_Link__c==true||
                                        agrlineObj.Clinical_Solution_Link__c==true||
                                            agrlineObj.Specialty_Operation_Link__c==true||
                                                agrlineObj.Specialty_Pricing_Link__c==true||
                                                    agrlineObj.Billing_Admin_Link__c==true||
                                                        agrlineObj.Rebate_Carve_Out_Link__c==true)
            {
                Counter=Counter+1;
                mapCounter.put(agrlineObj.Apttus__AgreementId__c,Counter);
                System.debug('Countersssssss...........'+Counter);
            }
        }
        List<Apttus__APTS_Agreement__c> agreementList=[Select ID,Validation_Status__c,Invalid_FAF__c,Async_Mode_PCD__c,Component_Error__c from  Apttus__APTS_Agreement__c where id IN :AgreementID];
        for(Apttus__APTS_Agreement__c agrObj:agreementList){
        
        system.debug('mapError.get(agrObj.ID)'+mapError.get(agrObj.ID));
        if(mapError.get(agrObj.ID)!='null\n\n' || mapError.get(agrObj.ID)!=null){
            agrObj.Component_Error__c=mapError.get(agrObj.ID);
        }
        System.debug('Coponent Erro'+agrObj.Component_Error__c);
            
            if(mapCounter.get(agrObj.ID)!=null){
             System.debug('In Async Mode'+'=======++++++========>'+mapCounter.get(agrObj.ID));
            agrObj.Invalid_FAF__c=true;
            //agrObj.Async_Mode_PCD__c=false;
            }
            else{
            System.debug('In Async Mode'+'===============>'+mapCounter.get(agrObj.ID));
            agrObj.Invalid_FAF__c=false;
            //agrObj.Async_Mode_PCD__c=True;
            }
            if(callType==false){
            agrObj.Validation_Status__c='Finished';
            }
            agrUpdateList.add(agrObj);
        }
        if(!agrUpdateList.isEmpty()){
            Database.Update(agrUpdateList);
        }
        for(Apttus__APTS_Agreement__c agrObj:agrUpdateList){
             if(callType==true && agrObj.Component_Error__c!=null ){
             //emailSendingPCD.sendMail(agrObj.Component_Error__c);
             }
        }
     }
     DeepCloneUtility.HistoryCheck=true;
    }
    
}