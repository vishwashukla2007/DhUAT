({
	doInit : function(component, event, helper) {
        if(component.get("v.sobjecttype")=='Apttus__APTS_Agreement__c'){
            component.find("navService").navigate({
                type: "standard__component",
                attributes: {
                    componentName: "c__changeDashboard" 
                },
                state: { 
                    "c__myAttr": component.get("v.recordId") 
                }
        	});
        }else if(component.get("v.sobjecttype")=='Opportunity'){
            var action = component.get("c.getCRFAuraWrapper");
            action.setParams({"opportunityId": component.get("v.recordId")});
            action.setCallback(this, function(response){
                var state = response.getState();
                if (state === "SUCCESS"){
                    var result = response.getReturnValue();
                    component.set("v.crfAuraWrapper", result);
                    var fafCount = component.get("v.crfAuraWrapper.fafCount");
                    var crfDraftCount = component.get("v.crfAuraWrapper.crfDraftCount");
                    var crfSubmittedCount = component.get("v.crfAuraWrapper.crfSubmittedCount");
                    if (fafCount > 0){
                    	helper.showToastHelper(component, $A.get("$Label.c.createCRFValidationFAFIsAvailable"), 'error');
                	}else if (crfDraftCount > 0){
                    	helper.showToastHelper(component, $A.get("$Label.c.createCRFValidationCRFAlreadyExists"), 'error');
                	}else if (crfSubmittedCount > 0){
                    	helper.showToastHelper(component, $A.get("$Label.c.createCRFValidationCRFAlreadySubmitted"), 'error');
                	}else{
                    	helper.createNewRecordHelper(component, event);
                    }
                }
            });
            $A.enqueueAction(action);
        }else if(component.get("v.sobjecttype")=='Contract_Request_Form__c'){
            var action = component.get("c.submitCRFRequest");
            action.setParams({"crfId": component.get("v.recordId")});
            action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                helper.showToastHelper(component, 'Contract Request Submitted successfully.', 'success');
                helper.navigateToRecordHelper(component, event, 'Contract_Request_Form__c');
            }
            else if(state === "ERROR") {
                var errors = helper.getErrorMessageHelper(component, event, response.getError());
                helper.showToastHelper(component, errors, 'error');
                if (!errors.includes('Refresh'))
                {
                    helper.navigateToRecordHelper(component, event, 'Contract_Request_Form__c');
                }
            } 
            else {
                helper.showToastHelper(component, 'System encounter error, Please reach out to System Admin.', 'error');
            }
            });
            $A.enqueueAction(action);
        }

	}
})