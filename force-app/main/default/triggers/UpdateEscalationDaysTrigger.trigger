/**************************************************************************************************
    Purpose   : Change Order escalation emails will trigger to business days only
    Apex Class: BusinessDays
    Test_Class: Test_UpdateEscalationDaysTrigger
****************************************************************************************************/
trigger UpdateEscalationDaysTrigger on Case (before insert, before update) 
{
    for (Case newRecord : trigger.new)
    {
        // Check if the trigger is for new Record or Update Record with Status change else check if the status is not changed from ANCS or Rebate Forecast review and the Reviewer name changed
        if ( (Trigger.isInsert) || ( (Trigger.isUpdate) && (Trigger.OldMap.get(newRecord.ID).Status!=newRecord.Status)))
        {
            //Check for new Record Respective Review Status and Require Review marked as "Yes"
            if ( (newRecord.Status=='Triage Team Review'))
            {
                newRecord.Queue_Assigned_Date__c = System.NOW();
                newRecord.Review_Escalation_Date_1__c=BusinessDays.addDays(newRecord.Queue_Assigned_Date__c,1);
                newRecord.Review_Escalation_Date_2__c=BusinessDays.addDays(newRecord.Queue_Assigned_Date__c,2);
                newRecord.Review_Escalation_Date_3__c=BusinessDays.addDays(newRecord.Queue_Assigned_Date__c,3);
            }
            else if ((newRecord.Status=='Underwriting Review') && (newRecord.Require_Underwriting_Review__c == 'Yes'))
            {
                newRecord.Queue_Assigned_Date__c = System.NOW();
                newRecord.Review_Escalation_Date_1__c=BusinessDays.addDays(newRecord.Queue_Assigned_Date__c,2);
                newRecord.Review_Escalation_Date_2__c=BusinessDays.addDays(newRecord.Queue_Assigned_Date__c,5);
                newRecord.Review_Escalation_Date_3__c=BusinessDays.addDays(newRecord.Queue_Assigned_Date__c,10);
            }
            else if ((newRecord.Status=='ANCS Team Review') && (newRecord.Require_ANCS_Review__c == 'Yes'))
            {
                newRecord.Queue_Assigned_Date__c = System.NOW();
                newRecord.Reviewer_Name_Counter__c=1;
                newRecord.Review_Escalation_Date_1__c=BusinessDays.addDays(newRecord.Queue_Assigned_Date__c,3);
            }
            else if ((newRecord.Status=='Rebate Forecast Team Review') && (newRecord.Require_Rebate_Forecast_Review__c=='Yes'))
            {
                newRecord.Queue_Assigned_Date__c = System.NOW();
                newRecord.Review_Escalation_Date_1__c=BusinessDays.addDays(newRecord.Queue_Assigned_Date__c,7);
            }
            else if (newRecord.Status=='Client Approved')
            {
                newRecord.Queue_Assigned_Date__c = System.NOW();
                newRecord.Review_Escalation_Date_1__c=BusinessDays.addDays(newRecord.Queue_Assigned_Date__c,3);
                newRecord.Review_Escalation_Date_2__c=BusinessDays.addDays(newRecord.Queue_Assigned_Date__c,5);
                newRecord.Review_Escalation_Date_3__c=BusinessDays.addDays(newRecord.Queue_Assigned_Date__c,10);
                newRecord.Review_Escalation_Date_4__c=BusinessDays.addDays(newRecord.Queue_Assigned_Date__c,20);
            }
            else if (newRecord.Status=='Submitted to Client')
            {
                newRecord.Queue_Assigned_Date__c = System.NOW();
                newRecord.Review_Escalation_Date_1__c=newRecord.Queue_Assigned_Date__c+30;
                newRecord.Review_Escalation_Date_2__c=newRecord.Queue_Assigned_Date__c+60;
                newRecord.Review_Escalation_Date_3__c=newRecord.Queue_Assigned_Date__c+90;
                newRecord.Review_Escalation_Date_4__c=newRecord.Queue_Assigned_Date__c+120;
                newRecord.Review_Escalation_Date_5__c=newRecord.Queue_Assigned_Date__c+150;
                newRecord.Review_Escalation_Date_6__c=newRecord.Queue_Assigned_Date__c+180;                
            }
            else
            {
                newRecord.Queue_Assigned_Date__c = NULL;
                newRecord.Review_Assigned_Date__c = NULL;
                newRecord.Reviewer_Name_Counter__c = NULL;
                newRecord.Review_Escalation_Date_1__c=NULL;
                newRecord.Review_Escalation_Date_2__c=NULL;
                newRecord.Review_Escalation_Date_3__c=NULL;
                newRecord.Review_Escalation_Date_4__c=NULL;
                newRecord.Review_Escalation_Date_5__c=NULL;
            }
        }
        else if ( (Trigger.isUpdate) && (Trigger.OldMap.get(newRecord.ID).Status==newRecord.Status) )
        {
            if ( ( Trigger.OldMap.get(newRecord.ID).Status=='ANCS Team Review' && newRecord.ANCS_Reviewer_Name__c <> Trigger.OldMap.get(newRecord.ID).ANCS_Reviewer_Name__c)  )
            {
                if (newRecord.Reviewer_Name_Counter__c==1)
                {
                    newRecord.Review_Assigned_Date__c = System.Now();   
                }
                newRecord.Reviewer_Name_Counter__c = newRecord.Reviewer_Name_Counter__c + 1;
                newRecord.Review_Escalation_Date_2__c=BusinessDays.addDays(newRecord.Review_Assigned_Date__c,7);
                newRecord.Review_Escalation_Date_3__c=BusinessDays.addDays(newRecord.Review_Assigned_Date__c,10);
                newRecord.Review_Escalation_Date_4__c=BusinessDays.addDays(newRecord.Review_Assigned_Date__c,15);
                newRecord.Review_Escalation_Date_5__c=BusinessDays.addDays(newRecord.Review_Assigned_Date__c,20);
            }
        }
    }  
    
    // Added TriggerHandler
    GFRIRecordTypeAssignmentTriggerHandler.handleTriggerEvents();
    
}