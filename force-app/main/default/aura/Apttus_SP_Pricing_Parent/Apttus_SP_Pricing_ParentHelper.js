({
    getAccessInfo : function(component, event) {
		 var action = component.get("c.avoidAccessForSalesUser");
      
         action.setCallback(this, function(result) {
           var state = result.getState();
           if (state === "SUCCESS") {
           component.set("v.isAccess", result.getReturnValue());
           }
        });
        $A.enqueueAction(action);
     },	
	getSPricinginfo : function(component, event) {
		 var action = component.get("c.getSpecialtypricing");
         action.setParams({ sopId : component.get("v.sopId") });
         action.setCallback(this, function(result) {
           var state = result.getState();
           if (state === "SUCCESS") {
             component.set("v.spricings", result.getReturnValue());
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
     getUrlParameter : function(sParam) {
        var sPageURL = decodeURIComponent(window.location.search.substring(1)),
            sURLVariables = sPageURL.split('&'),
            sParameterName,
            i;
    
        for (i = 0; i < sURLVariables.length; i++) {
            sParameterName = sURLVariables[i].split('=');
    
            if (sParameterName[0] === sParam) {
                return sParameterName[1] === undefined ? true : sParameterName[1];
            }
        }
    },
    deleteSelectedRecords : function(component, event, selctedRec) {
                console.log('Selected record list'+selctedRec)

        var action = component.get("c.beforeDelSpecialtyRecord");
        action.setParams({
            "selectedRecordList": selctedRec
        });
        action.setCallback(this, function(result) {
            var state = result.getState();
            if (state === "SUCCESS") {
                var result = result.getReturnValue();
                
                if(result !== undefined)
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title : 'Success Message',
                    message: 'Selected record(s) were deleted.',
                    type: 'success',
                    mode: 'pester'
                });
                toastEvent.fire(); 
                var navEvt = $A.get("e.force:navigateToSObject");
                navEvt.setParams({
                    "recordId": component.get("v.sopId"),
                    "slideDevName": "detail"
                });
                navEvt.fire();
            }
            else if (state === "INCOMPLETE") {
                // Need to Provide Error Message
            }
                else if (state ==="ERROR") {
                    var errors = result.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + 
                                        errors[0].message);
                            
                   var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title : 'Error',
                    message:errors[0].message,
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
    } ,
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