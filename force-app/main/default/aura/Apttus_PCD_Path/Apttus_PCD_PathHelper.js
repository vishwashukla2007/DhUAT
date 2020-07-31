({
	statusupdate : function(component,event,helper) {
		var action = component.get("c.get_updatestatus");
        action.setParams({"stageName":  component.get("{!v.status}"),
                          "recordId": component.get("{!v.recordId}")})
        action.setCallback(this, $A.getCallback(function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
              $A.get('e.force:refreshView').fire();
              var appEvent = $A.get("e.c:Apttus_PCD_Refresh_Component_Event");
       		  appEvent.setParams({ "counter" : component.get("v.counter")});
        	  appEvent.fire();
            }
            else {
                //helper.counselLogErrors(response.getError());
            }
        }));
        $A.enqueueAction(action);
	},
    getstatus : function(component,event,helper) {
		var action = component.get("c.get_status");
        action.setParams({"recordId": component.get("{!v.recordId}")})
        action.setCallback(this, $A.getCallback(function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
              component.set("{!v.statusvalue}", response.getReturnValue());
               var status = component.get("{!v.statusvalue}");
                var appEvent = $A.get("e.c:Apttus_Grid_RecordId_Event");
                appEvent.setParams({ "recordid" : component.get("v.recordId")});
                appEvent.fire();
        if (component.get("{!v.statusvalue}")=="Setup Pricing")
        {
            component.set("{!v.status}","Setup Pricing")
            //component.find("path").set("v.value","Setup Pricing");
             $A.get('e.force:refreshView').fire();
       		component.set("v.DisplayBack",true);
        	component.set("v.DisplayNext",false);
            component.set("v.counter", 0);
        }
        
        if (component.get("{!v.statusvalue}")=="Generate Document")
        {   component.set("{!v.status}","Generate Document")
            //component.find("path").set("v.value","Generate Document");
             $A.get('e.force:refreshView').fire();
       		component.set("v.DisplayBack",false);
        	component.set("v.DisplayNext",true);
            component.set("v.counter", 1);
        }
        
      /*  if (stepName=="Internal Review Completed")
        {
       		component.set("v.DisplayBack",true);
        	component.set("v.DisplayNext",true);
            component.set("v.counter", 2);
        }
        if (stepName=="PCD Generated")
        {
       		component.set("v.DisplayBack",true);
        	component.set("v.DisplayNext",true);
            component.set("v.counter", 2);
        } */
  
        	var appEvent = $A.get("e.c:Apttus_PCD_Refresh_Component_Event");
        	appEvent.setParams({ "counter" : component.get("v.counter")});
        	appEvent.fire();

            }
            else {
               // helper.counselLogErrors(response.getError());
            }
        }));
        $A.enqueueAction(action);     
    },
        getaccount : function(component,event,helper) {
		var action = component.get("c.get_account");
        action.setParams({"recordId": component.get("{!v.recordId}")})
        action.setCallback(this, $A.getCallback(function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
              component.set("{!v.accountid}", response.getReturnValue());
            }
            else {
                //helper.counselLogErrors(response.getError());
            }
        }));
        $A.enqueueAction(action);
	}
})