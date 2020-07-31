({
	fireevent : function(component, event) {
		          var appEvent = $A.get("e.c:Apttus_NT_Grid_Modal_Close_Event");
                  alert(appEvent);
                  appEvent.setParams({ "message" : true });
                  appEvent.fire();
	}
})