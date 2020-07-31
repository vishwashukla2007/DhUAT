/*
Usage                           :   This class is used to calculate the Working Days Between Two Dates 
                                    and update the result value in Holidays__c field on object name
Created By                      :   Anudeep Dale
Last ModifiedBy/Why             :   
How to Test the functionality?  : Hey very simle execute HolidaysCalculatorTest class :)

*/
public class HolidaysCalculator {

    @InvocableMethod
    public static void calculateHolidays(List<Id> WM_Q_ControllerIds){
        
        system.debug('::WM_Q_ControllerIds::'+WM_Q_ControllerIds.size());
        
        if(WM_Q_ControllerIds.size()>0){
            
            List<WM_Q_Controller__c> WM_Q_ControllerList = new List<WM_Q_Controller__c>();
            
            for(WM_Q_Controller__c wmQcList: [select id, From_Date__c, To_Date__c from WM_Q_Controller__c where id IN : WM_Q_ControllerIds]){
                
                WM_Q_Controller__c newWM_Q_Controller = new WM_Q_Controller__c();
                newWM_Q_Controller.id = wmQcList.id;    
                system.debug('::Holidays Count::'+calculateWorkingDaysBetweenTwoDates(wmQcList.From_Date__c, wmQcList.To_Date__c));
                newWM_Q_Controller.Holidays__c = calculateWorkingDaysBetweenTwoDates(wmQcList.From_Date__c, wmQcList.To_Date__c);
                WM_Q_ControllerList.add(newWM_Q_Controller);
            }
            
            system.debug('::WM_Q_ControllerList'+WM_Q_ControllerList.size());
            if(WM_Q_ControllerList.size()>0){
                update WM_Q_ControllerList;
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