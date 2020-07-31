({
	retrievedocument : function(component, event, helper) 
    {
       var action = component.get("c.get_DocVersionDetail");
       action.setParams({
            "aliid" : component.get("{!v.item.Id}")});
       action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") 
                 {
                  component.set("{!v.objects}",response.getReturnValue());
                   var data = component.get("v.objects");
 				   var itemcount = data.length;
 				   component.set("v.doccount", itemcount);
                 }
            else {
                 console.log("Failed with state: " + state);
                 }
        });
        $A.enqueueAction(action);
        
        
	}
})