({
	fetchpicklistvalue : function(component, helper) {
		
        /*var action = component.get("c.findPicklistOptions");
        action.setParams({
            "objAPIName":  "Clinical_Solutions__c",
            "fieldAPIname": "Year__c"
        })
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
        action.setParams({
            "objAPIName":  "Clinical_Solutions__c",
            "fieldAPIname": "Clinical_Solution_Type__c"
        })
        action.setCallback(this, $A.getCallback(function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.cliSolType", response.getReturnValue());
            }
            else {
                helper.counselLogErrors(response.getError());
            }
        }));
        $A.enqueueAction(action);
        
        var action = component.get("c.findPicklistOptions");
        action.setParams({
            "objAPIName":  "Clinical_Solutions__c",
            "fieldAPIname": "Clinical_Solution__c"
        })
        action.setCallback(this, $A.getCallback(function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.cliSol", response.getReturnValue());
            }
            else {
                helper.counselLogErrors(response.getError());
            }
        }));
        $A.enqueueAction(action);
        
        var action = component.get("c.findPicklistOptions");
        action.setParams({
            "objAPIName":  "Clinical_Solutions__c",
            "fieldAPIname": "Fee_Basis__c"
        })
        action.setCallback(this, $A.getCallback(function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.feeBasis", response.getReturnValue());
            }
            else {
                helper.counselLogErrors(response.getError());
            }
        }));
        $A.enqueueAction(action); 
        
        var action = component.get("c.findPicklistOptions");
        action.setParams({
            "objAPIName":  "Clinical_Solutions__c",
            "fieldAPIname": "Contingent__c"
        })
        action.setCallback(this, $A.getCallback(function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.contingent", response.getReturnValue());
            }
            else {
                helper.counselLogErrors(response.getError());
            }
        }));
        $A.enqueueAction(action);
        
        var action = component.get("c.findPicklistOptions");
        action.setParams({
            "objAPIName":  "Clinical_Solutions__c",
            "fieldAPIname": "Opt_In_Out__c"
        })
        action.setCallback(this, $A.getCallback(function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.optinout", response.getReturnValue());
            }
            else {
                helper.counselLogErrors(response.getError());
            }
        }));
        $A.enqueueAction(action);
    },
    
    deleteSelectedRecords : function(component, event, helper) {
        var action = component.get("c.delAddProg");
        action.setParams({
            "obId" : component.get("v.objects.Id")
        });
        action.setCallback(this, function(result) {
            var state = result.getState();
            if (state === "SUCCESS") {
                var result = result.getReturnValue();
                
                var appEvent1 = $A.get("e.c:Apttus_Grid_Delete_RG_RowEvent");
                appEvent1.setParams({ 
                    "isDeleteSuccess" : true,
                    "delIndex" : component.get("v.currentIndex")
                });
                appEvent1.fire();
                
                //alert('sp--'+result);
                /**result = 2;
                if(result == 1) {
                    var appEvent = $A.get("e.c:Apttus_Grid_Cancel_Parent_Event");
                    appEvent.fire();    
                } else {
                    var appEvent = $A.get("e.c:Apttus_Grid_Refresh_Parent_Event");
                    appEvent.fire(); 
                }**/
                
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
    
    handleSaveNewHelper:function(component, event, helper){
        if(component.get("v.display") == true){
            component.set("{!v.DisplaySpinner}", true);
            var action = component.get("c.saveAddProg");
            action.setParams({ 
                "addPrg" : component.get("{!v.objects}")
            });
            // Create a callback that is executed after 
            // the server-side action returns
            action.setCallback(this, function(response) {
                var state = response.getState();
                component.set("{!v.DisplaySpinner}", false);
                //alert('state--'+state);
                if (state === "SUCCESS")   {
                    
                    //if (response.getReturnValue() == 0) {
                    if(response.getReturnValue()){
                        var obj = component.get("{!v.objects}");
                        obj.Id = response.getReturnValue();
                        component.set("{!v.objects}", obj);
                    }
                    
                    var cmpTarget = component.find("tablerow");
                    $A.util.removeClass(cmpTarget, "slds-has-error");
                    
                    var appEventS = $A.get("e.c:Apttus_Grid_Copy_Complete_Event");
                    appEventS.setParams({ 
                        "SaveRec" : true
                    });
                    appEventS.fire();      
                    
                } else if (state === "ERROR")  {
                    //var errors = "Error in Updating Additional Program Information";
                    component.set("v.duplicaterow","1"); 
                    var cmpTarget = component.find("tablerow");
                    $A.util.addClass(cmpTarget, "slds-has-error");
                    var errors = response.getError();
                    var message;
                    if (errors) {
                        if(errors[0] && errors[0].message) {
                            message = "Error message: " + errors[0].message; 
                        }
                    } 
                    else {
                        message = "Error in Updating Additional Programs Information";
                    }   
                    var appEvent = $A.get("e.c:Apttus_Grid_NT_Notify_Error_Event");
                    appEvent.setParams({ "Error" : message});
                    appEvent.fire();        
                }
            });
            $A.enqueueAction(action);
        }
    },
})