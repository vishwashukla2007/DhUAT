({
	getsGuarateeinfo : function(component, event) {
		 var action = component.get("c.getSpecialtyguarantee");
         action.setParams({ spriceid : component.get("v.spriceid") });
         action.setCallback(this, function(result) {
           var state = result.getState();
           if (state === "SUCCESS") {
           component.set("v.specialtyguarantee", result.getReturnValue());
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
                    }
                } else {
                  console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
     },
    deleteSelectedSPGRecords : function(component, event, selctedRec) {
        var action = component.get("c.deleteSelectedRecords");
        action.setParams({
            "sPriceId" : component.get("v.spriceid"),
            "selectedRecordList": selctedRec
        });
        action.setCallback(this, function(result) {
            var state = result.getState();
            if (state === "SUCCESS") {
                var result = result.getReturnValue();
                if(result !== undefined)
                component.set("v.specialtyguarantee", result);
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
                    type: 'Error',
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
    /*
    isCreatable : function(cmp) {
		var action = cmp.get("c.isNewButtonVisible");
        action.setParams({ });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                cmp.set("v.isCreateable", response.getReturnValue());
            }
            else if (state === "INCOMPLETE") {
                console.log('INCOMPLETE----- do something');
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                 errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
	},
isDeleteAccess : function(cmp) {
		var action = cmp.get("c.isDeleteButtonVisible");
        action.setParams({ });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                cmp.set("v.isDeletable", response.getReturnValue());
            }
            else if (state === "INCOMPLETE") {
                console.log('INCOMPLETE----- do something');
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                 errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
	},
    
    isEditAccess : function(cmp) {
		var action = cmp.get("c.isEditButtonVisible");
        action.setParams({ });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                cmp.set("v.isEditable", response.getReturnValue());
            }
            else if (state === "INCOMPLETE") {
                console.log('INCOMPLETE----- do something');
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                 errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
	},
    */
})