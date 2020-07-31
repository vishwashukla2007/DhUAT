/* =================================================================================
 * @Class Name        : Invoke_PCD_Warning
 * @author            : Soumendu Chowdhury
 * @created date      : 06/12/2019
 * @Purpose           : Update PCD Warning Message at Offer level for all related FAF 
=======================================================================================*/
public class Invoke_PCD_Warning{
/*=================================================================================
 * @Method Name       : Invoke_PCD_Warning_Update
 * @author            : Soumendu Chowdhury
 * @created date      : 06/12/2019
 * @Last modified by  : Soumendu Chowdhury
 * @Purpose           : Class to Update PCD Warning Message at Offer level for all related FAF 
=======================================================================================*/
@InvocableMethod
public static void Invoke_PCD_Warning_Update(List<Id> objId)
{ 
 Invoke_PCD_Warning_Update_future(objId);
}



public static void Invoke_PCD_Warning_Update_future(List<Id> objId)
{ 
try
{
Offer__c[] ListOffer = new List<Offer__c>();
Apttus__APTS_Agreement__c[] ListAgreement = new List<Apttus__APTS_Agreement__c>();

Map<Id,Central_Hub__c> FAF = new Map<Id,Central_Hub__c>([SELECT Id,LOB_ID__c,Offer_ID__c,Offer_ID1__c,Agreement__c,Data_Loading__c
                                        FROM Central_Hub__c
                                        WHERE ID IN:objId]); 
                                        
Map<Id,LOB__c>  LOB = new Map<Id,LOB__c>([SELECT Id,Client_Pricing_Offer__c    
                                        FROM LOB__c]);
                                                                                
Map<Id,Offer__c> Offer = new Map<Id,Offer__c>([SELECT Id, OfferCategory__c,Alert_Message__c 
                                       FROM Offer__c]);
PCD_FAF_Status__mdt FAFStatus = [SELECT Value__c FROM PCD_FAF_Status__mdt LIMIT 1]; 
List<string> FAFStat = new List<string>();
for(string s: FAFStatus.Value__c.split(','))
   {
     FAFStat.add(s);
   }                                                      
Map<Id,Central_Hub__c> RelatedFAF = new Map<Id,Central_Hub__c>([SELECT Id, Offer_ID__c,Offer_ID1__c, PCD_Warning__c,LOB_ID__c,LOB_ID__r.Client_Pricing_Offer__c 
                                        FROM Central_Hub__c 
                                        WHERE FAF_Status__c IN:FAFStat and LOB_ID__c != null]);                                       

String strWarningmsg = ' ';
for(Central_Hub__c  FAFlst: FAF.values()){

//Map<Id,LOB__c>  LOB = new Map<Id,LOB__c>([SELECT Id,Client_Pricing_Offer__c    
//                                        FROM LOB__c WHERE Id=:FAFlst.LOB_ID__c] );

for (LOB__c LOBlst: LOB.values())
{  
if(FAFlst.LOB_ID__c == LOBlst.ID)
{
//Map<Id,Offer__c> Offer = new Map<Id,Offer__c>([SELECT Id, OfferCategory__c,Alert_Message__c 
//                                        FROM Offer__c wHERE Id=:LOBlst.Client_Pricing_Offer__c]);                                
for (Offer__c Offerlst: Offer.values())
{
  if((LOBlst.Client_Pricing_Offer__c == Offerlst.ID) && LOBlst.Client_Pricing_Offer__c != null && Offerlst.OfferCategory__c == Label.Market_check)
   {
     strWarningmsg += Label.PCD_Warning_MC + '\n\n';     
   }
  
  if((LOBlst.Client_Pricing_Offer__c == Offerlst.ID) && LOBlst.Client_Pricing_Offer__c != null )
   {
    for (Central_Hub__c RelatedFAFlst: RelatedFAF.values())
    {
//     if((LOBlst.ID == RelatedFAFlst.LOB_ID__c))    
     if((Offerlst.ID == RelatedFAFlst.LOB_ID__r.Client_Pricing_Offer__c))
      {
        if (RelatedFAFlst.PCD_Warning__c != null && RelatedFAFlst.PCD_Warning__c != ' ')
        {
          strWarningmsg += RelatedFAFlst.PCD_Warning__c + '\n\n';  
        }
      }
     } 
    String strfinalWarningmsgoffer = ' ';
       if (strWarningmsg != null && strWarningmsg != ' ')
        {
         strfinalWarningmsgoffer = Label.PCD_Warning_Header + '\n\n' + strWarningmsg;
        }
        else
        { strfinalWarningmsgoffer =  strWarningmsg;}
    
    //Start: Changes done by Mohit Srivastava for the bug : String too long
    Schema.DescribeFieldResult F = Offer__c.Alert_Message__c.getDescribe();
    Integer lengthOfField = F.getLength();
    System.debug('lengthOfFieldlengthOfField'+lengthOfField);
    if(strfinalWarningmsgoffer.length()<=lengthOfField){
    Offerlst.Alert_Message__c = strfinalWarningmsgoffer;
    }
    else{
    strfinalWarningmsgoffer=strfinalWarningmsgoffer.substring(0,lengthOfField); 
    Offerlst.Alert_Message__c = strfinalWarningmsgoffer;
    }
    //End:Changes done by Mohit Srivastava for the bug : String too long
    Offerlst.Bypass_Acknowledgement__c = true;
    ListOffer.Clear();
    ListOffer.add(Offerlst); 
    
    Map<Id,Apttus__APTS_Agreement__c> Agreement = new Map<Id,Apttus__APTS_Agreement__c>([SELECT Id,Alert_Message__c 
                                            FROM Apttus__APTS_Agreement__c where Id = :FAFlst.Agreement__c]);     
    for (Apttus__APTS_Agreement__c Agreelst: Agreement.values())    
    {   
       String strfinalWarningmsg = ' ';
       if (strWarningmsg != null && strWarningmsg != ' ')
        {
         strfinalWarningmsg = Label.PCD_Warning_Header + '\n\n' + strWarningmsg;
         
        }
        else
        { strfinalWarningmsg =  strWarningmsg;
    
        }
        Schema.DescribeFieldResult Fagree = Apttus__APTS_Agreement__c.Alert_Message__c.getDescribe();
        Integer lengthOfFieldA = Fagree.getLength();
         System.debug('lengthOfFieldA'+lengthOfFieldA);
        // 
        if(strfinalWarningmsg.length()<=lengthOfFieldA){
               Agreelst.Alert_Message__c = strfinalWarningmsg;
        }
        else{
        strfinalWarningmsg=strfinalWarningmsg.substring(0,lengthOfFieldA);  
        Agreelst.Alert_Message__c = strfinalWarningmsg; 
        }
        ListAgreement.Clear();
        ListAgreement.add(Agreelst);    
    } 
   }
}
}                                                                       
} 
                                       }
DeepCloneUtility.OFF_TRIGGERS_PROCBUILDER=false;
if (ListOffer!= null && !ListOffer.isEmpty())
{
   Update ListOffer;
}
if (ListAgreement!= null && !ListAgreement.isEmpty())
{
   Update ListAgreement;
}

}
catch(DmlException e)
    {
     System.debug(e.getMessage());
    } 
}




}