@isTest
private class HolidaysCalculatorForFAFTest {
    
    static testMethod void calculateHolidaysMethod(){
        //faf1.FAF_Status__c = 'Draft';
        //faf1.FAF_Close_On_Date__c = Date.today()-1;
        //fafList.add(faf1);        
		
		List<Id> FAFList = new List<Id>();
        Central_Hub__c newFAF = new Central_Hub__c( From_Date__c = system.today(), To_Date__c = system.today() + 10 );		
		insert newFAF;
        FAFList.add(newFAF.id);
		
		system.debug('::From_Date::'+newFAF.From_Date__c);
		system.debug('::To_Date::'+newFAF.To_Date__c);
		HolidaysCalculatorForFAF.calculateHolidays(FAFList);
		system.debug('::HolidaysDays::'+newFAF.Holidays__c);
		
	}

}