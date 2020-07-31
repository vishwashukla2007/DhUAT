public class NewALIController{/*

   // public NewALIController(ApexPages.StandardController controller) {

    }

//public String currentRecordId {get;set;}
//public String parameterValue {get;set;}
//public Account acc{get;set;}
 
public PageReference PageRedirect() {}/*
        String AggId;
         List<Apttus__AgreementLineItem__c> AggList = new List<Apttus__AgreementLineItem__c>();
        currentRecordId  = ApexPages.CurrentPage().getparameters().get('id');
        If (currentRecordId != null)
        {
          AggList = [select Id,Apttus__AgreementId__c from Apttus__AgreementLineItem__c where id =: currentRecordId LIMIT 1];
        }
        if (AggList != null)
         {
           AggId = AggList[0].Apttus__AgreementId__c;
         }
        PageReference ReturnPage = new PageReference('/' + AggId); 
        ReturnPage.setRedirect(true); 
        return ReturnPage;
        return null;
      */ 
       
     }