({
    fetchpicklistvalue : function(component, helper) {
        
        var action = component.get("c.findPicklistOptions");
        action.setParams({
            "objAPIName":  "Rebate_Guarantees__c",
            "fieldAPIname": "Plan_Design__c"
        })
        action.setCallback(this, $A.getCallback(function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.Plandesign", response.getReturnValue());
            } else {
                helper.counselLogErrors(response.getError());
            }
        }));
        $A.enqueueAction(action);
        
        var action = component.get("c.findPicklistOptions");
        action.setParams({
            "objAPIName":  "Rebate_Guarantees__c",
            "fieldAPIname": "GSTP__c"
        })
        action.setCallback(this, $A.getCallback(function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.GstpOption", response.getReturnValue());
            } else {
                helper.counselLogErrors(response.getError());
            }
        }));
        $A.enqueueAction(action);
        
        var action = component.get("c.findPicklistOptions");
        action.setParams({
            "objAPIName":  "Rebate_Guarantees__c",
            "fieldAPIname": "Non_Specialty_Formulary_2__c"
        })
        action.setCallback(this, $A.getCallback(function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.NonSpec", response.getReturnValue());
            } else {
                helper.counselLogErrors(response.getError());
            }
        }));
        $A.enqueueAction(action);
        
        var action = component.get("c.findPicklistOptions");
        action.setParams({
            "objAPIName":  "Rebate_Guarantees__c",
            "fieldAPIname": "Specialty_Formulary__c"
        })
        action.setCallback(this, $A.getCallback(function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.Spec", response.getReturnValue());
            } else {
                helper.counselLogErrors(response.getError());
            }
        }));
        $A.enqueueAction(action);
        
        var action = component.get("c.findPicklistOptions");
        action.setParams({
            "objAPIName":"Rebate_Guarantees__c",
            "fieldAPIname":"Basis__c"
        });
        action.setCallback(this, $A.getCallback(function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.ntypeoptions", response.getReturnValue());
                console.log('response.getReturnValue()'+response.getReturnValue());
            } else {
                console.log('eror'+response.getError());
            }
        }));
        $A.enqueueAction(action);
    },
    deleteSelectedRecords : function(component, event, helper) {
        component.set("{!v.DisplaySpinner}", true);
        var objId = component.get("{!v.objects.Id}");
        var action = component.get("c.deleteSelectedRebateRecords");
        action.setParams({
            "netprId" : component.get("{!v.objects.Id}")
        });
        action.setCallback(this, function(result) {
            var state = result.getState();
            component.set("{!v.DisplaySpinner}", false);
            if (state === "SUCCESS") {
                //var result = result.getReturnValue();
                /*var appEventRefresh = $A.get("e.c:Apttus_Grid_Refresh_Parent_Event");
                appEventRefresh.fire();   */
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title : 'Success Message',
                    message: 'Selected record(s) were deleted.',
                    type: 'success',
                    mode: 'pester'
                });
                toastEvent.fire(); 
                var appEvent1 = $A.get("e.c:Apttus_Grid_Delete_RG_RowEvent");
                appEvent1.setParams({ 
                    "isDeleteSuccess" : true,
                    "section" : component.get("v.planDesignOption"),
                    "delIndex" : component.get("v.currentIndex"),
                    "delObjId" : objId
                });
                appEvent1.fire();
            } else if (state === "INCOMPLETE") {
                // Need to Provide Error Message
            } else if (state === "ERROR") {
                var errors = result.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " +  errors[0].message);
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