/******************************************************************************************************************************
* Name        - 
* Description - 
* Modification Log :
* ---------------------------------------------------------------------------
* Developer                              Date                   Description
* ---------------------------------------------------------------------------
* 
*******************************************************************************************************************************/
@isTest(seeAllData = false)
public class PegaIpiWaSOAPcallTest{
    @isTest static void test1(){
    
    Org_Constants__c og = new Org_Constants__c();
    og.name = 'Pega_IPI';
    og.Prod_Value__c = 'https://cvs-16.pegacloud.com:443/prweb/PRSOAPServlet/SOAP/WorkAssignmentService/Services';
    og.Non_Prod_Value__c = 'https://cvs-16.pegacloud.com:443/prweb/PRSOAPServlet/SOAP/WorkAssignmentService/Services';
    insert og;
    
      list<Account> accList = new list<Account>();
      list<Opportunity> oppList = new list<Opportunity>();
      Account acct = TestDataFactory.createAccount();  
      acct.Market_Segment__c='Employer';  
      acct.Status__c='Active';
      accList.add(acct) ;
      insert accList;
      
      Opportunity opp = TestDataFactory.createOpportunity(accList[0].Id);
      opp.PBM_18_digit_ID__c  =  '006m0000008rYGxAAM';
      oppList.add(opp);
      insert oppList;
    
    IPI_WA_Tasks__c IWT = new IPI_WA_Tasks__c();
    IWT.Carrier_ID__c = '7734' ;
    IWT.FAF_ID__c = '33333' ;
    IWT.IPI_Opp_Id__c = '006m0000008rYGxAAM';
    IWT.Pricing_Effective_Date__c   = system.today();
    IWT.Super_Client_ID__c = '2286PSFA007';
    IWT.Task_Case_ID__c = 'T-1555509';
    IWT.Task_ID__c='T-UNDW-16' ;
    IWT.Work_Assignment_Case_ID__c = 'WA-599294';
    IWT.Work_Assignment_ID__c ='UNDW1' ;
    
    insert IWT;
    
    Test.startTest();
    PegaIpiWaSOAPcall.callPegaWAIPI(String.valueOf(IWT.ID));
    Test.stopTest();
    
     Test.setMock(WebServiceMock.class, new TestPegarulesSoapMockImpl());
     PegaIpiWaSOAPcall.callPegaWAIPI(String.valueOf(IWT.ID));
    }
    
}