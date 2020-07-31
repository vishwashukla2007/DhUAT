({
	getThisReconciliation : function(component, helper) 
    {
        var action = component.get("c.get_yearcount");
        action.setParams({"fafid":  component.get("{!v.fafid}")})
        action.setCallback(this, $A.getCallback(function(response) {
        var state = response.getState();
        if (state === "SUCCESS") {
        component.set("v.yearcount", response.getReturnValue());
        var action = component.get("c.get_BillingAdmindata");
        action.setParams({"fafid":  component.get("{!v.fafid}")})
        action.setCallback(this, $A.getCallback(function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.adminobjects", response.getReturnValue());
                var data = component.get("v.adminobjects");
                var itemcount = data.length;
                component.set("v.pricingcount", itemcount);
                 if (component.get("v.pricingcount") >= component.get("v.yearcount"))
                {
                   component.set("v.disablebtn", true);
                }
                else
                {
                   component.set("v.disablebtn", false);
                }
            }
            else {
                //helper.counselLogErrors(response.getError());
            }
        }));
        $A.enqueueAction(action);
            
        }
        else {
                //helper.counselLogErrors(response.getError());
             }
        }));
        $A.enqueueAction(action);   
        
        var action = component.get("c.findPicklistOptions");
        action.setParams({"objAPIName":  "Billing_Administrative_Fees__c",
                          "fieldAPIname": "LOB__c"})
        action.setCallback(this, $A.getCallback(function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.loboptions", response.getReturnValue());
            }
            else {
                helper.counselLogErrors(response.getError());
            }
        }));
        $A.enqueueAction(action);
            
},
})