trigger AccountTrigger on Account (after Update) {
    
    system.debug('@@@@@@@@@@@@@@@@@@@@@');
List<SwitchValidation__mdt> switchValidationList = new List<SwitchValidation__mdt>();
    Boolean isRun = false;
    switchValidationList = [SELECT id, Enable_Trigger__c, DeveloperName FROM SwitchValidation__mdt];
    for (SwitchValidation__mdt sv : switchValidationList) {
        if(sv.DeveloperName == 'Account' && sv.Enable_Trigger__c){
            isRun = true;
            break;
        }
    }

    if(isRun){
        
        if(trigger.isupdate && trigger.isafter){
            AccountTriggerHandler.afterupdate(trigger.newmap, trigger.oldmap);  
            AccountTriggerHandler.FafShareWithAccountTeam(trigger.newmap, trigger.oldmap); 
            //added by sonal sharma
            AccountTriggerFutureHandler.AccessToAccountOwner(trigger.newmap, trigger.oldmap); 
            AccountTriggerFutureHandler.futureFAFupdates(trigger.newmap, trigger.oldmap);      
            
        }
    }  
        
}