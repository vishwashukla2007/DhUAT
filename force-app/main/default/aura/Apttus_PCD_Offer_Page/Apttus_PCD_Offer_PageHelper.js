({
	retrieveoffer : function(component, event, helper) 
    {
	   //component.set("{!v.accountid}","0010x00000bGHp7AAG");
       var action = component.get("c.get_Offer");
       action.setParams({
            "accountid" : component.get("{!v.accountid}"),
            "taskid" : component.get("{!v.taskid}")});
       action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") 
                 {
                  component.set("{!v.objects}",response.getReturnValue());
                  var offer = component.get("{!v.objects}");
                  var offercount = offer.length;
                  if (offercount > 0)
                  component.set("{!v.title}","Offers for " + component.get("v.objects[0].iUMS_Task_Number__c"));
                  else
                  component.set("{!v.title}","Offers");
                     
                 }
            else {
                console.log("Failed with state: " + state);
            }
        });
        $A.enqueueAction(action);
	}    
        
})