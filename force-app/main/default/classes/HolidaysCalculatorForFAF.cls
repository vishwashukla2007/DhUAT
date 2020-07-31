/*
Usage                           :   This class is used to calculate the Working Days Between Two Dates 
                                    and update the result value in Holidays__c field on object name
Created By                      :   Anudeep Dale
Last ModifiedBy/Why             :   
How to Test the functionality?  : Hey very simle execute HolidaysCalculatorTest class :)

*/
public class HolidaysCalculatorForFAF {

    @InvocableMethod
    public static void calculateHolidays(List<Id> FAFIds){
        
        system.debug('::FAFIds::'+FAFIds.size());
        
        if(FAFIds.size()>0){
            
            List<Central_Hub__c> FAFList = new List<Central_Hub__c>();
            
            for(Central_Hub__c faf: [select id, From_Date__c, To_Date__c from Central_Hub__c where id IN : FAFIds]){
                
                Central_Hub__c newFAF = new Central_Hub__c();
                newFAF.id = faf.id;    
                system.debug('::Holidays Count::'+calculateWorkingDaysBetweenTwoDates(faf.From_Date__c, faf.To_Date__c));
                newFAF.Holidays__c = calculateWorkingDaysBetweenTwoDates(faf.From_Date__c, faf.To_Date__c);
                FAFList.add(newFAF);
            }
            
            system.debug('::FAFList'+FAFList.size());
            if(FAFList.size()>0){
                update FAFList;
            }
            
        }
        
    }
    
    public static Integer calculateWorkingDaysBetweenTwoDates(Date date1, Date date2){
        
        List<Holiday> holidayList =[Select Id,Name,ActivityDate from Holiday 
                                where ActivityDate <= :date2 
                                AND 
                                ActivityDate >= :date1 ];
        system.debug('::holidayListSize'+holidayList.size());
        return holidayList.size();
    }   
}