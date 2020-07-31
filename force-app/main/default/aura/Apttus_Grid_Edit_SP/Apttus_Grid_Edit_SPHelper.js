({
    getThisReconciliation : function(component, helper) {
        
        var action = component.get("c.get_yearcount");
        action.setParams({"fafid":  component.get("{!v.fafid}")})
        action.setCallback(this, $A.getCallback(function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.yearcount", response.getReturnValue());
                var action = component.get("c.get_SpecialtyPricingData");
                action.setParams({
                    "fafid":  component.get("{!v.fafid}"),
                    "opid":  component.get("{!v.opid}"),
                    "phBenefit" : component.get("{!v.pharmacyBenefit}") 
                })
                action.setCallback(this, $A.getCallback(function(response) {
                    var state = response.getState();
                    if (state === "SUCCESS") {
                        component.set("v.spobjects", response.getReturnValue());
                        var data = component.get("v.spobjects");
                        var itemcount = data.length;
                        component.set("v.pricingcount", itemcount);
                        if (component.get("v.pricingcount") >= component.get("v.yearcount")) {
                            component.set("v.disablebtn", true);
                        } else {
                            component.set("v.disablebtn", false);
                        }
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