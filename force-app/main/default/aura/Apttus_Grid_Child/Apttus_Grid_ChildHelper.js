({
    deleteSelectedRecords : function(component, event, helper) {
        if (component.get("{!v.ObjectName}") == "Network_Pricing__c") {
            var action = component.get("c.deletepricinggrid");
            action.setParams({
                "fafid":  component.get("v.objects.FAF_ID__c"),
                "NetName": component.get("v.objects.Network_Name__c"),
                "NetType": component.get("v.objects.Network_Type__c"),
                "des": component.get("v.objects.Custom_Network_Description__c"),
                "lob": component.get("v.objects.LOB__c")
            })
            action.setCallback(this, $A.getCallback(function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    component.set("{!v.DisplaySpinner}", false);
                    var appEvent = $A.get("e.c:Apttus_Grid_Cancel_Event");
                    appEvent.fire();	
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "mode": 'dismissible',
                        "type": 'success',
                        "title": "Success!",
                        "message": "Network Pricing Grid Deleted Successfully."
                    });
                    toastEvent.fire();
                }
                else {
                    component.set("{!v.DisplaySpinner}", false);
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "mode": 'sticky',
                        "type": 'error',
                        "title": "Error!",
                        "message": "Problem in Network Pricing Grid Deletion."
                    });
                    toastEvent.fire();
                }
            }));
            $A.enqueueAction(action);   
        }
        
        if (component.get("{!v.ObjectName}") == "Mail_Pricing__c") {
            var action = component.get("c.deletemailpricinggrid");
            action.setParams({"fafid":  component.get("v.objects.FAF_ID__c"),
                              "lob": component.get("v.objects.LOB__c")})
            action.setCallback(this, $A.getCallback(function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    component.set("{!v.DisplaySpinner}", false);
                    var appEvent = $A.get("e.c:Apttus_Grid_Cancel_Event");
                    appEvent.fire();	
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "mode": 'dismissible',
                        "type": 'success',
                        "title": "Success!",
                        "message": "Mail Pricing Grid Deleted Successfully."
                    });
                    toastEvent.fire();
                }
                else {
                    component.set("{!v.DisplaySpinner}", false);
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "mode": 'sticky',
                        "type": 'error',
                        "title": "Error!",
                        "message": "Problem in Mail Pricing Grid Deletion."
                    });
                    toastEvent.fire();
                }
            }));
            $A.enqueueAction(action);   
        } 
        if (component.get("{!v.ObjectName}") == "Specialty_Pricing__c")  {
            var action = component.get("c.deletSpecialtypricinggrid");
            //alert('rec '+ component.get("v.objects.Id"));
            action.setParams({
                "fafid":  component.get("v.objects.FAF_ID__c"),
                "recId": component.get("v.objects.Id") ,
                "opId": component.get("v.opid") ,
                "phBenefit": component.get("v.objects.Pharmacy_Benefit__c") 
            })
            action.setCallback(this, $A.getCallback(function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    component.set("{!v.DisplaySpinner}", false);
                    var appEvent = $A.get("e.c:Apttus_Grid_Cancel_Event");
                    appEvent.fire();	
                    var appEvent2 = $A.get("e.c:Apttus_Grid_Name_Event"); 
                    appEvent2.setParams({ "gridname" : component.get("{!v.ObjectName}")});
                    appEvent2.fire();
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "mode": 'dismissible',
                        "type": 'success',
                        "title": "Success!",
                        "message": "Specialty Pricing Grid Deleted Successfully."
                    });
                    toastEvent.fire();
                } else {
                    component.set("{!v.DisplaySpinner}", false);
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "mode": 'sticky',
                        "type": 'error',
                        "title": "Error!",
                        "message": "Problem in Specialty Pricing Grid Deletion."
                    });
                    toastEvent.fire();
                }
            }));
            $A.enqueueAction(action);   
        }
		//for rebate guarantee delete
        if (component.get("{!v.ObjectName}") == "Rebate_Guarantee__c"){
            var action = component.get("c.deleteRebategrid");
            action.setParams({
                "fafid":  component.get("v.objects.FAF__c"),
                "plan":component.get("v.objects.Plan_Design__c"),
			    "basis":component.get("v.objects.Basis__c"),
			    "nonspecForm":component.get("v.objects.Non_Specialty_Formulary__c"),
			    "specForm":component.get("v.objects.Specialty_Formulary__c"),
			    "gstp":component.get("v.objects.GSTP__c"),
                "gridoption":component.get("v.objects.Non_Specialty_Grid__c"),
                "TierValues":component.get("v.objects.Plan_Design__c")
            })
            action.setCallback(this, $A.getCallback(function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    component.set("{!v.DisplaySpinner}", false);
                    var appEvent = $A.get("e.c:Apttus_Grid_Cancel_Event");
                    appEvent.fire();	
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "mode": 'dismissible',
                        "type": 'success',
                        "title": "Success!",
                        "message": "Rebate Guarantee Grid Deleted Successfully."
                    });
                    toastEvent.fire();
                } else {
                    component.set("{!v.DisplaySpinner}", false);
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "mode": 'sticky',
                        "type": 'error',
                        "title": "Error!",
                        "message": "Problem in Rebate Guarantee Grid Deletion."
                    });
                    toastEvent.fire();
                }
            }));
            $A.enqueueAction(action);   
        } 
        if (component.get("{!v.ObjectName}") == "Clinical_Solutions__c") {
            var action = component.get("c.deleteClinicalSolgrid");
            action.setParams({"fafid":  component.get("v.objects.FAF_ID__c")})
            action.setCallback(this, $A.getCallback(function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    component.set("{!v.DisplaySpinner}", false);
                    var appEvent = $A.get("e.c:Apttus_Grid_Cancel_Event");
                    appEvent.fire();	
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "mode": 'dismissible',
                        "type": 'success',
                        "title": "Success!",
                        "message": "Additional Programs Grid Deleted Successfully."
                    });
                    toastEvent.fire();
                }
                else {
                    component.set("{!v.DisplaySpinner}", false);
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "mode": 'sticky',
                        "type": 'error',
                        "title": "Error!",
                        "message": "Problem in Additional Programs Grid Deletion."
                    });
                    toastEvent.fire();
                }
            }));
            $A.enqueueAction(action);   
        } 
        if (component.get("{!v.ObjectName}") == "Billing_Admin_Fee__c") {
            var action = component.get("c.deleteadminfee");
            action.setParams({
                "fafid":  component.get("v.objects.Id")
            })
            action.setCallback(this, $A.getCallback(function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    component.set("{!v.DisplaySpinner}", false);
                    var appEvent = $A.get("e.c:Apttus_Grid_Cancel_Event");
                    appEvent.fire();	
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "mode": 'dismissible',
                        "type": 'success',
                        "title": "Success!",
                        "message": "Administrative Fee Grid Deleted Successfully."
                    });
                    toastEvent.fire();
                }
                else {
                    component.set("{!v.DisplaySpinner}", false);
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "mode": 'sticky',
                        "type": 'error',
                        "title": "Error!",
                        "message": "Problem in Administrative Fee Grid Deletion."
                    });
                    toastEvent.fire();
                }
            }));
            $A.enqueueAction(action);   
        }   
        
    },
    getConcatString : function(fVal, mVal, LVal, isInPercent){
        var res = '';
        if(fVal){
            res = res + fVal + ': ';
        }
        if(mVal){
            mVal = mVal.toFixed(2);
            if (isInPercent == true)
            res = res + mVal + '% ';
            else
            res = res +'$'+ mVal +' ';
        }
        if(LVal){
            res = res + LVal;
        }
        if(res){
        	res = res + '\n';
        }    
        return res;
    }
})