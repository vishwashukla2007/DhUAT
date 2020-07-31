({
	showChangeDashboard : function(component, event, helper) {
        component.find("navService").navigate({
            type: "standard__component",
            attributes: {
                componentName: "c__changeDashboard" 
            },
            state: { 
                "c__myAttr": component.get("v.recordId") 
            }
        }); 
	},
})