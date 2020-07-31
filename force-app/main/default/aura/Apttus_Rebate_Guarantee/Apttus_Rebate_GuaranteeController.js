({
	doInit : function(component, event, helper) {
             component.set("v.vfHost",window.location.hostname);
		     console.log(window.location.hostname);
	},
   
    clickEdit : function(component, event, helper) {
      //  component.set("v.clickEditModal", true);
        component.set("v.RGEdit",true);
		var RGId = component.get("v.RGuarantee").Id;
        component.set("v.RGParams","id="+RGId+'&isExpandableView=true');
		
    }
 	   
})