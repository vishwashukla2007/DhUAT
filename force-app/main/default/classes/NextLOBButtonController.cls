/*********************************************************************************************
 * @ClassName         : NextLOBButtonController
 * @created date      : 09/06/2019
 * @Purpose           : This is the controller class to dynamicaly make visible of Next LOB Button 
 **/

public class NextLOBButtonController {
/*
    
public String AgreementId {get; set;}
public String AgreementLTIId {get; set;}
public Boolean displayLOB {get; set;} 
    
public NextLOBButtonController(ApexPages.StandardController controller) {
    this.LOBvisible();
}

public Boolean LOBvisible()
{
this.AgreementId = Apexpages.currentPage().getParameters().get('Id'); 

List<Apttus__AgreementLineItem__c> ALI = [select Id,Apttus__AgreementId__c from Apttus__AgreementLineItem__c where Apttus__AgreementId__c=: AgreementId ];
try {
if(ALI.Size()>1)
{
displayLOB = true;
}
else
{
displayLOB = false;
}
   }
catch(exception e)
 {
     System.debug('The following exception has occurred: ' + e.getMessage());
}
return displayLOB;
}
public PageReference LOBUpdate()
{
 String NewALIId;
 String PCDStatus;
 Decimal AGINumber;
 this.AgreementId = Apexpages.currentPage().getParameters().get('Id'); 
 List<Apttus__APTS_Agreement__c> AG = [select Id,Primary_Agreement_Line_Item__c,PCD_Status__c,ALI_LineNumber__c from Apttus__APTS_Agreement__c where Id=: AgreementId ];
 List<Apttus__AgreementLineItem__c> ALI = [select Id,Apttus__AgreementId__c,PCD_Status__c,LOBSequence__c from Apttus__AgreementLineItem__c where Apttus__AgreementId__c=: AgreementId ];
 List<Apttus__APTS_Agreement__c> AGupdate = new List<Apttus__APTS_Agreement__c>();
 try {
   for (Apttus__APTS_Agreement__c agree: AG)
     {
         AgreementLTIId = agree.Primary_Agreement_Line_Item__c;
         AGINumber = agree.ALI_LineNumber__c;
         
     }
   for (Apttus__AgreementLineItem__c alitem: ALI)
     {
       if ((alitem.Id <> AgreementLTIId) && NewALIId == null &&((alitem.LOBSequence__c > AGINumber) ||  (alitem.LOBSequence__c==1 && AGINumber ==ALI.Size())))
         {
           NewALIId = alitem.Id;
           PCDStatus = alitem.PCD_Status__c;
           for (Apttus__APTS_Agreement__c agreem: AG)
            {
              if (NewALIId != null)
              {
              agreem.Primary_Agreement_Line_Item__c = NewALIId;
              }
              if (PCDStatus != null)
              {
              agreem.PCD_Status__c = PCDStatus ;
              }
              else
              {
               agreem.PCD_Status__c = 'Initiated';
              }
              
              AGupdate.add(agreem);
            }
         }
         
        
         
         
       
     }
     
     
    if (AGupdate.Size()>0)
     {
         Update AGupdate;    
         
     }
     
    }
Catch(exception e)
    {
        System.debug('The following exception has occurred: ' + e.getMessage());
    }
PageReference tempPage = new PageReference ('https://pbmfinancecvshealth--pbmfinpd.lightning.force.com/' + AgreementId);            
//tempPage.setRedirect(true);
return null;
}

public PageReference LOBUpdatePrevious()
{
 String NewALIId;
 String PCDStatus;
 Decimal AGINumber;
 this.AgreementId = Apexpages.currentPage().getParameters().get('Id'); 
 List<Apttus__APTS_Agreement__c> AG = [select Id,Primary_Agreement_Line_Item__c,PCD_Status__c,ALI_LineNumber__c from Apttus__APTS_Agreement__c where Id=: AgreementId ];
 List<Apttus__AgreementLineItem__c> ALI = [select Id,Apttus__AgreementId__c,PCD_Status__c,LOBSequence__c from Apttus__AgreementLineItem__c where Apttus__AgreementId__c=: AgreementId Order by LOBSequence__c Desc];
 List<Apttus__APTS_Agreement__c> AGupdate = new List<Apttus__APTS_Agreement__c>();
 try {
   for (Apttus__APTS_Agreement__c agree: AG)
     {
         AgreementLTIId = agree.Primary_Agreement_Line_Item__c;
         AGINumber = agree.ALI_LineNumber__c;
         
     }
   for (Apttus__AgreementLineItem__c alitem: ALI)
     {
       if ((alitem.Id <> AgreementLTIId) && NewALIId == null &&((alitem.LOBSequence__c < AGINumber) ||  (alitem.LOBSequence__c== ALI.Size()&& AGINumber ==1)))
         {
           NewALIId = alitem.Id;
           PCDStatus = alitem.PCD_Status__c;
           for (Apttus__APTS_Agreement__c agreem: AG)
            {
              if (NewALIId != null)
              {
              agreem.Primary_Agreement_Line_Item__c = NewALIId;
              }
              if (PCDStatus != null)
              {
              agreem.PCD_Status__c = PCDStatus ;
              }
              else
              {
               agreem.PCD_Status__c = 'Initiated';
              }
              
              AGupdate.add(agreem);
            }
         }
         
        
         
         
       
     }
     
     
    if (AGupdate.Size()>0)
     {
         Update AGupdate;    
         
     }
     
    }
Catch(exception e)
    {
        System.debug('The following exception has occurred: ' + e.getMessage());
    }
PageReference tempPage = new PageReference ('https://pbmfinancecvshealth--pbmfinpd.lightning.force.com/' + AgreementId);            
//tempPage.setRedirect(true);
return null;
}*/

     }