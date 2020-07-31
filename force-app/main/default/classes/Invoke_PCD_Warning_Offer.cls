/* =================================================================================
 * @Class Name        : Invoke_PCD_Warning_Offer
 * @author            : Soumendu Chowdhury
 * @created date      : 06/12/2019
 * @Purpose           : Update PCD Warning Message at Offer level for all related FAF 
=======================================================================================*/
public class Invoke_PCD_Warning_Offer{
/*=================================================================================
 * @Method Name       : Invoke_PCD_Warning_Update_Offer
 * @author            : Soumendu Chowdhury
 * @created date      : 06/12/2019
 * @Last modified by  : Soumendu Chowdhury
 * @Purpose           : Class to Update PCD Warning Message at Offer level for all related FAF 
=======================================================================================*/
@InvocableMethod
public static void Invoke_PCD_Warning_Update_Offer(List<Id> objId)
{ 
try
{
Offer__c[] ListOffer = new List<Offer__c>();
Apttus__APTS_Agreement__c[] ListAgreement = new List<Apttus__APTS_Agreement__c>();

Map<Id,LOB__c>  LOB = new Map<Id,LOB__c>([SELECT Id,Client_Pricing_Offer__c    
                                        FROM LOB__c where Client_Pricing_Offer__c IN:objId]);
                                                                                
Map<Id,Offer__c> Offer = new Map<Id,Offer__c>([SELECT Id,Warning_Exist__c, OfferCategory__c,Alert_Message__c 
                                        FROM Offer__c where ID IN:objId]);
PCD_FAF_Status__mdt FAFStatus = [SELECT Value__c FROM PCD_FAF_Status__mdt LIMIT 1]; 
List<string> FAFStat = new List<string>();
for(string s: FAFStatus.Value__c.split(','))
   {
     FAFStat.add(s);
   }                                              
Map<Id,Central_Hub__c> RelatedFAF = new Map<Id,Central_Hub__c>([SELECT Id, Offer_ID__c,Offer_ID1__c, PCD_Warning__c,LOB_ID__c  
                                        FROM Central_Hub__c 
                                        WHERE FAF_Status__c IN:FAFStat]);
                                        
Map<Id,Apttus__APTS_Agreement__c> Agreement = new Map<Id,Apttus__APTS_Agreement__c>([SELECT Id,Alert_Message__c 
                                        FROM Apttus__APTS_Agreement__c where Offer__c IN:objId]);                                        


for (Offer__c Offerlst: Offer.values())
{
String strWarningmsg = ' ';
  if(Offerlst.OfferCategory__c == Label.Market_check)
   {
     strWarningmsg += Label.PCD_Warning_MC + '\n\n';     
   }
for (LOB__c LOBlst: LOB.values())
{                                
    for (Central_Hub__c RelatedFAFlst: RelatedFAF.values())
    {
     if((LOBlst.ID == RelatedFAFlst.LOB_ID__c))
      {
        if (RelatedFAFlst.PCD_Warning__c != null && RelatedFAFlst.PCD_Warning__c != ' ')
        {
          strWarningmsg += RelatedFAFlst.PCD_Warning__c + '\n\n';  
        }
      }
     } 
   
}
String strfinalWarningmsgoffer = ' ';
       if (strWarningmsg != null && strWarningmsg != ' ')
        {
         strfinalWarningmsgoffer = Label.PCD_Warning_Header + '\n\n' + strWarningmsg;
         Offerlst.Warning_Exist__c=true;
        }
        else
        { strfinalWarningmsgoffer =  strWarningmsg;
         Offerlst.Warning_Exist__c=false;
        }
        //Start: Changes done by Mohit Srivastava for the bug : String too long
        Schema.DescribeFieldResult F = Offer__c.Alert_Message__c.getDescribe();
        Integer lengthOfField = F.getLength();
        if(strfinalWarningmsgoffer.length()<=lengthOfField){
        Offerlst.Alert_Message__c = strfinalWarningmsgoffer;
        }
        else{
        strfinalWarningmsgoffer=strfinalWarningmsgoffer.substring(0,lengthOfField); 
        Offerlst.Alert_Message__c = strfinalWarningmsgoffer;
        }
        Offerlst.Bypass_Acknowledgement__c = true;
        
        ListOffer.Clear();
        ListOffer.add(Offerlst);                                                                     

for (Apttus__APTS_Agreement__c Agreelst: Agreement.values())
{
    String strfinalWarningmsg = ' ';
       if (strWarningmsg != null && strWarningmsg != ' ')
        {
         strfinalWarningmsg = Label.PCD_Warning_Header + '\n\n' + strWarningmsg;
        
        }
        else
        { 
        strfinalWarningmsg = strWarningmsg;
     
        }
        Schema.DescribeFieldResult Fagree = Apttus__APTS_Agreement__c.Alert_Message__c.getDescribe();
        Integer lengthOfFieldA = Fagree.getLength();
        // 
        if(strfinalWarningmsg.length()<=lengthOfFieldA){
        Agreelst.Alert_Message__c = strfinalWarningmsg;
        }else{
        strfinalWarningmsg=strfinalWarningmsg.substring(0,lengthOfFieldA);  
        Agreelst.Alert_Message__c = strfinalWarningmsg;     
            
        }
        
        ListAgreement.Clear();
        ListAgreement.add(Agreelst);    
} 
}
                                      
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