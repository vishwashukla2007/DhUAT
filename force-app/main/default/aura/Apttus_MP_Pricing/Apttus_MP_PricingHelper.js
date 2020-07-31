({
    deleteMpRecord: function(component, event) {
        var recordId = component.get("v.mailPricing").Id;
        var action = component.get("c.deleteMailPricingRecord");
        //alert(recordId)
        action.setParams({
            pricingRecId : recordId,
        });
        action.setCallback(this, function(result) {
            var state = result.getState();
            component.set("v.isDeletAlertOpen", false);
            if (state === "SUCCESS") {
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
                    "recordId": component.get("v.mailOperationsId")
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
})