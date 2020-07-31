({
	createNewRecordHelper : function(component, event) {
        var accountId = component.get("v.crfAuraWrapper.accountRecord.Id");
        var createRecordEvent = $A.get("e.force:createRecord");
        createRecordEvent.setParams({
            "entityApiName": "Contract_Request_Form__c",
            "defaultFieldValues": {
                "Account__c": accountId,
                "Opportunity_Name__c": component.get("v.recordId"),
                "Sales_Or_Account_Manager__c": $A.get("$SObjectType.CurrentUser.Id")
            }
        });
        createRecordEvent.fire();
	},
    
    showToastHelper : function(component, messageData, type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            message: messageData,
            key: 'info_alt',
            type: type,
            mode: 'sticky'
        });
        toastEvent.fire();
    },
    
    redirectTorecordEditFormHelper : function(component, event) {
    /*component.find("navService").navigate({
        type: "standard__component",
        attributes: {
            componentName: "c__createCRF" 
        },
        state: { 
            "c__myAttr": component.get("v.recordId") 
        }
    });*/
	},
    
    navigateToRecordHelper : function(component, event, objectApiName) {
        $A.get('e.force:refreshView').fire();
        //Invoke the navigate service to show the scroll bar after refreshing the page 
        var navService = component.find("navService");
        var pageRef = {
            type: 'standard__recordPage',
            attributes: {
                actionName: 'view',
                objectApiName: objectApiName,
                recordId : component.get("v.recordId")
            },
        };
        navService.navigate(pageRef, true);
    },
    
    getErrorMessageHelper : function(component, event, errors) {
        var errmessage = [];
        if (errors) {
            for(var i=0; i < errors.length; i++) {
                for(var j=0; errors[i].pageErrors && j < errors[i].pageErrors.length; j++) {
                    errmessage += (errmessage.length > 0 ? '\n' : '') + errors[i].pageErrors[j].message;
                }
                if(errors[i].fieldErrors) {
                    for(var fieldError in errors[i].fieldErrors) {
                        var thisFieldError = errors[i].fieldErrors[fieldError];
                        for(var j=0; j < thisFieldError.length; j++) {
                            errmessage += (errmessage.length > 0 ? '\n' : '') + thisFieldError[j].message;
                        }
                    }
                }
                if(errors[i].message) {
                    errmessage += (errmessage.length > 0 ? '\n' : '') + errors[i].message;
                }
            }
        }
        return errmessage;
    }
})