@isTest
private class HolidaysCalculatorTest {

    static testMethod void calculateHolidaysMethod(){
        
        List<Id> wmqcList = new List<Id>();
        WM_Q_Controller__c wmqc = new WM_Q_Controller__c();
        
        wmqc.From_Date__c = system.today();
        wmqc.To_Date__c = system.today() + 10;      
        insert wmqc;
        wmqcList.add(wmqc.id);
        
        system.debug('::From_Date::'+wmqc.From_Date__c);
        system.debug('::To_Date::'+wmqc.To_Date__c);
        HolidaysCalculator.calculateHolidays(wmqcList);
        system.debug('::HolidaysDays::'+wmqc.Holidays__c);
        
    }

}