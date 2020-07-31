({
    deleteRecord : function(component, event) {
        console.log('Helper fucntion::');
        var recordId = component.get("v.ntpricing.Id");
        var action = component.get("c.deletePricingRecord");
        action.setParams({
            pricingRecId : recordId
        });
        action.setCallback(this, function(result) {
            var state = result.getState();
            if (state === "SUCCESS") {
                component.set("v.isDeleteAlertOpen", false);
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
                    "recordId": component.get("v.networkOperationsId")
                });
                navEvt.fire();
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
    closeDeleteAlertPopup : function (component, event){
        component.set("v.isDeleteAlertOpen", false);
    },
 
})