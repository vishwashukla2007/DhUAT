@isTest
private class SetRunInWMQControllerTest {

    static testMethod void calculateHolidaysMethod(){  
        List<Id> wmqcList = new List<Id>();
        WM_Q_Controller__c wmqc = new WM_Q_Controller__c();
        
        wmqc.From_Date__c = system.today();
        wmqc.To_Date__c = system.today() + 10; 
        wmqc.Run__c = false;
        wmqc.TAT_Due_Date__c = System.Now();
        insert wmqc;
        wmqcList.add(wmqc.id);
        
        SetRunInWMQController.setRun();        
    }

}