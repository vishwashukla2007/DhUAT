/*
Usage                           :   This class is used to set the Run as true 
by reading the WM_Q_Controller__c where TAT_Due_Date__c <= Now()
Created By                      :   Anudeep Dale
Last ModifiedBy/Why             :

*/
public class SetRunInWMQController {
    
    @InvocableMethod
    public static void setRun(){
        
        system.debug('::In side SetRun::');
        
        List<WM_Q_Controller__c> WM_Q_ControllerList = new List<WM_Q_Controller__c>();
        
        for(WM_Q_Controller__c wmQcList: [select id, Run__c, TAT_Due_Date__c from WM_Q_Controller__c 
                                          where TAT_Due_Date__c <= :System.Now() AND Run__c = false]){
                                              
                                              WM_Q_Controller__c newWM_Q_Controller = new WM_Q_Controller__c();
                                              newWM_Q_Controller.id = wmQcList.id;    
                                              newWM_Q_Controller.Run__c = true;
                                              WM_Q_ControllerList.add(newWM_Q_Controller);
                                          }
        
        system.debug('::WM_Q_ControllerList'+WM_Q_ControllerList.size());
        if(WM_Q_ControllerList.size()>0){
            update WM_Q_ControllerList;
        }        
    }
    
}