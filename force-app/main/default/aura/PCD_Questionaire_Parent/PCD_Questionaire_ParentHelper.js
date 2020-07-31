({
    FetchRecord: function(component, event) {
        var action = component.get("c.Extract_agreementline");
        action.setParams({
            recordId : "a010x000005gphxAAA"
        });
        action.setCallback(this, function(result) {
            var state = result.getState();
            if (state === "SUCCESS") 
            {
               component.set("v.agreementline", result.getReturnValue());
            }
            else if (state === "INCOMPLETE") 
            {
                // Need to Provide Error Message
            }
            else if (state === "ERROR") 
            {
               
            } 
        });
        $A.enqueueAction(action);
    }
})