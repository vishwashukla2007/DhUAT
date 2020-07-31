({

    doInit : function(component, event, helper) {
 
    },
    clickEdit : function(component, event, helper) { 
        var recordId = component.get("v.specialtyguarantee.Id");
        component.set("v.params", 'lightning=true&id='+recordId);   
        component.set("v.clickEditModal", true);  
	},
    handleClick: function (component, event, helper) {
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": component.get("v.specialtyguarantee.Id")
        });
        navEvt.fire();
    }
})