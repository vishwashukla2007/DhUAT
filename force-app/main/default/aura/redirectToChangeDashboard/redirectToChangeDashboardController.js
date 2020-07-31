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
        }
	}
})