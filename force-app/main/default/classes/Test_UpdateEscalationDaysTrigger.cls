@isTest(SeeAllData=true)
public class Test_UpdateEscalationDaysTrigger 
{
	static testMethod void  runTest1(){
    try
    {    
    	list <Case> COList = new list <Case>(); 
        COList =[select id, Status,Require_Triage_Review__c,Require_Rebate_Forecast_Review__c,Require_Underwriting_Review__c ,Require_ANCS_Review__c  from Case where status!='closed' limit 7];           
        integer i=0;
        for(case c:COList)
        {
        	if(i==0)
            {
            	c.status='Triage Team Review';
			}
            if(i==1)
            {
            	c.Status='Underwriting Review';
                c.Require_Underwriting_Review__c = 'Yes';
             }
             if(i==2)
             {
             	c.status='ANCS Team Review';
                c.Require_ANCS_Review__c ='Yes';
              }
              if(i==3)
              {
                c.status='Rebate Forecast Team Review';
                c.Require_Rebate_Forecast_Review__c='Yes';
              }
              if(i==4)
              {
              	c.status='Client Approved';
              }
              if (i==5)
              {
              	c.status='Submitted to Client';
              }
              if(i==6)
              {
              	c.status='Completed';
              }
              i=i+1;
          }
          update COList;
		}catch(exception e){system.debug('+++++++++++=no coveragre++++++++'+e.getmessage());}
	}
}