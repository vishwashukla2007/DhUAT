({
	doInit : function(cmp, event, helper) {
        var action = cmp.get("c.getTotalPlatformSpecific");
        action.setParams({
            clientId: cmp.get("v.recordId")
        })
		 action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                //var count = component.get("v.total");
                
                cmp.set("v.total", response.getReturnValue());
            }
             else if(state==="Error"){
                 //console.log('Error in updating total platform specific ');
             }
        });
        $A.enqueueAction(action);
    }
})