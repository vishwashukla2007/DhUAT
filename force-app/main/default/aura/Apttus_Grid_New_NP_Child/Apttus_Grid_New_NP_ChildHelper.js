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
     deleteSelectedRecords : function(component, event, helper) {
         //alert('objects           '+component.get("v.objects.Id"));
        var action = component.get("c.deleteSelectedRecords");
        action.setParams({
            "netprId" : component.get("v.objects.Id")
        });
        action.setCallback(this, function(result) {
            var state = result.getState();
            if (state === "SUCCESS") {
                var result = result.getReturnValue();
                if(result == 1)
                {
                    var appEvent = $A.get("e.c:Apttus_Grid_Cancel_Parent_Event");
                	appEvent.fire();    
                }
                else
                {
                    var appEvent = $A.get("e.c:Apttus_Grid_Refresh_Parent_Event");
                	appEvent.fire(); 
                }
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title : 'Success Message',
                    message: 'Selected record(s) were deleted.',
                    type: 'success',
                    mode: 'pester'
                });
                toastEvent.fire(); 
              
            }
            else if (state === "INCOMPLETE") {
                // Need to Provide Error Message
            }
                else if (state === "ERROR") {
                    var errors = result.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + 
                                        errors[0].message);
                             var toastEvent = $A.get("e.force:showToast");
                           toastEvent.setParams({
                  			 title : 'Error',
                             message: errors[0].message,
                             type: 'error',
                             mode: 'pester'
                            }); 
             				 toastEvent.fire(); 
                        }
                    } else {
                        console.log("Unknown error");
                    }
                }
        });
        $A.enqueueAction(action);
    },
})