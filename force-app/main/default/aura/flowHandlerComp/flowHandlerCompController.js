({
	doInit : function(component, event, helper) {
       component.set('v.isOpen', true);
       var flow = component.find("flow");
        var inputVariables = [
        {
            name : "recordId",
            type : "String",
            value : component.get("v.fafid")

        }

    	];
     
       flow.startFlow("createPBSAgreementFlow",inputVariables);
    },
    closeFlowModal : function(component, event, helper) {
        component.set("v.isOpen", false);
        var navService = component.find('navService');
            var pageReference = {
            type: 'standard__recordPage',
            attributes: {
                recordId: component.get("v.fafid"),
                objectApiName: 'Central_Hub__c',
                actionName: 'view'
            }
        }
        navService.navigate(pageReference); 
    },
	closeModalOnFinish : function(component, event, helper) {
        if(event.getParam('status') === "FINISHED") {
            component.set("v.isOpen", false);
        }
    },
})