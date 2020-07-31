({
   doInit : function(component, event, helper) {
		component.set("v.vfHost",window.location.hostname);
		//console.log(window.location.hostname);
	}, 

	
	clickEdit : function(component, event, helper) {
		component.set("v.mgEdit",true);
		var mgId = component.get("v.mailGuarantee").Id;
		component.set("v.mgParams","id="+mgId+'&isExpandableView=true');
	},
        handleClick: function (component, event, helper) {
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": component.get("v.mailGuarantee.Id")
        });
        navEvt.fire();
    }
})