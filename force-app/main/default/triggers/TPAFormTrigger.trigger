trigger TPAFormTrigger on TPA_Form__c (before insert,after insert){
     if(trigger.IsInsert && trigger.IsBefore) {
        //TPAFormTriggerhelper.updateTPAForm(Trigger.OldMap,Trigger.NewMap);
        TPAFormTriggerhelper.updateTPAForm(Trigger.New);
     }
}