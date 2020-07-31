/* ====================================================================
* @author            : Sonal Sharma(Accenture)
* @created date      : 17 05 2019
* @Last modified by  : Sonal Sharma(Accenture)
* @Last modified date: 17/04/2019
* @Purpose           : Controller class for LegalOverrideEditNew page
========================================================================*/
public with sharing class LegalOverrideEditNewClass{
  ApexPages.StandardController controller;
  public string TermWithoutCause{get;set;} 
  public string DaysWrittenNotice{get;set;}
  //public Boolean renderedvar{get;set;}
  public Boolean termWithoutCauseBol{get;set;}//boolean variable for term without cause field
  public Boolean reviewCompRquiredbol{get;set;}//boolean variable to make contract review completed by field required.
  public Boolean ContractReviewCheck{get;set;} 
  public string ReviewCompletedBy{get;set;}
  public Boolean daysWrittenBol{get;set;}//boolean for days written notice before termination
  public ID roId;
  public Legal_Information__c leagalInformation{get;set;}
  public Legal_Information__c legalInfo= new Legal_Information__c();
  
/* ====================================================================
* @author            : Sonal Sharma(Accenture)
* @created date      : 17 05 2019
* @Last modified by  : Sonal Sharma(Accenture)
* @Last modified date: 17/04/2019
* @Purpose           : Constructor
========================================================================*/
    public LegalOverrideEditNewClass(ApexPages.StandardController controller) {
        leagalInformation= new Legal_Information__c();
    //legalInfo= new Legal_Information__c();
    this.controller = controller;
    leagalInformation = (Legal_Information__c)controller.getRecord();
    roId = ApexPages.currentPage().getParameters().get('id'); // Get Rebate Operation Record Id from URL
      //  Id fafIdId = ApexPages.currentPage().getParameters().get();// Get Parent FAF record Id from URL
    
    //when record is edited
    if(roId!=null){
    legalInfo=[Select Term_Without_Cause__c, Days_Written_Notice_Before_Termination__c,Contract_Review_Completed_By__c, Contract_Review_Completed__c from Legal_Information__c where id=:roId];
    TermWithoutCause= legalInfo.Term_Without_Cause__c;
    DaysWrittenNotice= legalInfo.Days_Written_Notice_Before_Termination__c;
    //ReviewCompletedBy=legalInfo.Contract_Review_Completed_By__c;
    ContractReviewCheck=leagalInformation.Contract_Review_Completed__c;
    if(ContractReviewCheck){
        reviewCompRquiredbol= true;
        System.debug('controller reviewCompRquiredbol==='+reviewCompRquiredbol);
    }else{
        leagalInformation.Contract_Review_Completed_By__c=null;
        reviewCompRquiredbol=false;
        System.debug('controller reviewCompRquiredbol else==='+reviewCompRquiredbol);
     }
    }
    
    }
    
/* ====================================================================
* @author            : Sonal Sharma(Accenture)
* @created date      : 17 05 2019
* @Last modified by  : Sonal Sharma(Accenture)
* @Last modified date: 17/04/2019
* @Purpose           : Method to make term without cause dependent field enable/disable
========================================================================*/
    public void LegalInfoChangeTypeField(){
         
      if(TermWithoutCause=='Yes'){
            system.debug('*****'+DaysWrittenNotice);
            termWithoutCauseBol=false;
            daysWrittenBol=false;
            if(DaysWrittenNotice==null||DaysWrittenNotice==''||DaysWrittenNotice!='90'){
                DaysWrittenNotice='90';
            }
     }
        else{
            termWithoutCauseBol=true;
            daysWrittenBol=false;
          }
    }
    
    /* ====================================================================
* @author            : Sonal Sharma(Accenture)
* @created date      : 15/04/2020
* @Last modified by  : Sonal Sharma(Accenture)
* @Last modified date: 15/04/2020
* @Purpose           : Method to make contract review completed by field enable/disable
========================================================================*/
    public void changeContractReview(){
        if(ContractReviewCheck){
        //When contractReviewCheck is true.
            reviewCompRquiredbol=false;
            leagalInformation.Contract_Review_Completed_By__c=null;
        }
        else{
            //when contractReviewCheck is false
            reviewCompRquiredbol=true;
            
        }
    }
}