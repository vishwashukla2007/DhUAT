({
	doInit : function(component, event, helper) {     
        var c__myAttr = '';
        var c__myAttr2 = '';
        var action = component.get("c.getFAF");
        action.setParams({
            "FAFId": component.get("v.recordId")
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS"){                
                var result = response.getReturnValue();                
                var isValid = true;
                if(result.masterAgreementId != 'undefined' && result.masterAgreementId != null){
                    isValid = false;                                                            
                }else if(result.FAFStatus == 'Deleted' || result.FAFStatus == 'Closed' || result.FAFStatus == 'Template'){
                    isValid = false;
                }else{                                        
                    component.set("v.FAFName", result.FAFName);
                    if(result.pbmRequestId == 'undefined' || result.pbmRequestId == null){
                        c__myAttr = component.get("v.recordId");
                        c__myAttr2 = component.get("v.sObjectName");
                    }else{
                        c__myAttr = result.pbmRequestId;
                        c__myAttr2 = 'PBMRequest__c';
                    }                                                
                    component.find("navService").navigate({
                        type: "standard__component",
                        attributes: {
                            componentName: "c__PBMRequestAuraHolderLWC" 
                        },
                        state: { 
                            "c__myAttr": c__myAttr,
                            "c__myAttr2": c__myAttr2,
                        }
                    });                                                                                
                }
                if(!isValid){
                    var toastMessage;
                    if(result.masterAgreementId != 'undefined' && result.masterAgreementId != null){
                        toastMessage = $A.get("$Label.c.pbmRequestMasterAgreementAlreadyAvailable");                                                            
                    }else if(result.FAFStatus == 'Deleted' || result.FAFStatus == 'Closed' || result.FAFStatus == 'Template'){
                        toastMessage = $A.get("$Label.c.pbmRequestInvalidStatus");                                                            
                    }
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title : '',
                        message: toastMessage,                        
                        duration:' 2000',                      
                        type: 'error',
                        mode: 'dismissible'
                    });
                    toastEvent.fire();
                                       
                    var navLink = component.find("navService");
                    var pageRef = {
                        type: 'standard__recordPage',
                        attributes: {
                            actionName: 'view',
                            objectApiName: 'Central_Hub__c',
                            recordId : component.get("v.recordId") // change record id. 
                        },
                    };
                    navLink.navigate(pageRef, true);
                }                
            }                                  
        });
        $A.enqueueAction(action);
                             
	},
    showSpinner : function(component, event, helper) {
        //helper.selectAllCheckbox(component, event, "Document");
        component.set("v.IsSpinner", true); 
    },
    hideSpinner : function(component, event, helper) {
        //helper.selectAllCheckbox(component, event, "Document");
        component.set("v.IsSpinner", false);
    },
})