({
	fetchpicklistvalue : function(component, helper) {
		
        /* var action = component.get("c.findPicklistOptions");
        action.setParams({"objAPIName":  "Network_Pricing__c",
                          "fieldAPIname": "Year__c"})
        action.setCallback(this, $A.getCallback(function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.yearoptions", response.getReturnValue());
            }
            else {
                helper.counselLogErrors(response.getError());
            }
        }));
        $A.enqueueAction(action); */
        
        var action = component.get("c.findPicklistOptions");
        action.setParams({"objAPIName":  "Network_Pricing__c",
                          "fieldAPIname": "Brand_Basis__c"})
        action.setCallback(this, $A.getCallback(function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.brandbasis", response.getReturnValue());
            }
            else {
                helper.counselLogErrors(response.getError());
            }
        }));
        $A.enqueueAction(action);
        
        var action = component.get("c.findPicklistOptions");
        action.setParams({"objAPIName":  "Network_Pricing__c",
                          "fieldAPIname": "Generic_Basis__c"})
        action.setCallback(this, $A.getCallback(function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.genericbasis", response.getReturnValue());
            }
            else {
                helper.counselLogErrors(response.getError());
            }
        }));
        $A.enqueueAction(action);
	},
})