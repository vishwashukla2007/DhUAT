({
	 onPageReferenceChange : function(component, event, helper) { 
        var pageReference = component.get("v.pageReference");        
        component.set("v.sObjectName", pageReference.state.c__myAttr2);                                            
        if(pageReference.state.c__myAttr2 == "Central_Hub__c"){            
            component.set("v.SrecordId", null);
            component.set("v.FAFId", pageReference.state.c__myAttr);
            component.set("v.addMode", true);
            component.set("v.editMode", false);
            component.set("v.viewMode", false);
            var action = component.get("c.getFAF");
            action.setParams({
                "FAFId": pageReference.state.c__myAttr
            });
            action.setCallback(this, function(response){
                var state = response.getState();
                if (state === "SUCCESS"){
                    var result = response.getReturnValue();                    
                    component.set("v.FAFName", result.FAFName);
                    if(result.masterAgreementId == 'undefined' || result.masterAgreementId == null){
                        component.set("v.requestSubmitted", false);
                    }else{
                        component.set("v.requestSubmitted", true);
                    }         
                }            
            });
            $A.enqueueAction(action);                                   
        }else if(pageReference.state.c__myAttr2 == "PBMRequest__c"){           
            component.set("v.SrecordId", pageReference.state.c__myAttr);            
        	component.set("v.addMode", false);
            component.set("v.editMode", false);
            component.set("v.viewMode", true);
            var action = component.get("c.getRequestInfo");
            action.setParams({
                "pbmRequestId": pageReference.state.c__myAttr
            });
            action.setCallback(this, function(response){
                var state = response.getState();
                if (state === "SUCCESS"){
                    var result = response.getReturnValue();
                    //alert(result.masterAgreementId);
                    if(result.masterAgreementId == 'undefined' || result.masterAgreementId == null){
                        //alert('false');
                        component.set("v.requestSubmitted", false);
                    }else{
                        component.set("v.requestSubmitted", true);
                    }                                        
                }            
            });
            $A.enqueueAction(action);
        }
        
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