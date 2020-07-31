({
    getThisReconciliation : function(component, helper) {
        
        var action = component.get("c.get_yearcount");
        action.setParams({"fafid":  component.get("{!v.fafid}")})
        action.setCallback(this, $A.getCallback(function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.yearcount", response.getReturnValue());
                var action = component.get("c.get_AddProgramData");
                action.setParams({
                    "fafid":  component.get("{!v.fafid}")
                })
                action.setCallback(this, $A.getCallback(function(response) {
                    var state = response.getState();
                    if (state === "SUCCESS") {
                        component.set("v.spobjects", response.getReturnValue()); 
                        var data = component.get("v.spobjects");
                        var itemcount = data.length;
                        component.set("v.pricingcount", itemcount);
                    } else {
                        helper.counselLogErrors(response.getError());
                    }
                }));
                $A.enqueueAction(action);
            } else {
                helper.counselLogErrors(response.getError());
            }
        }));
        $A.enqueueAction(action);  
    }
    
})