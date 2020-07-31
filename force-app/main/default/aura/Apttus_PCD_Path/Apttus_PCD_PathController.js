({
    doInit : function (component, event, helper) {
        helper.getstatus(component, event);
        helper.getaccount(component, event);
	
    },
     refreshView : function (component, event, helper) 
    {   
        //helper.getstatus(component, event);
    },
    handleSelect : function (component, event, helper) {
        var stepName = event.getParam("detail").value;
        component.set("v.Refreshdone",false);
        var action = component.get("c.get_updatestatus");
        action.setParams({stageName:stepName , recordId : component.get("v.recordId")});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                $A.get('e.force:refreshView').fire();
                 var appEvent = $A.get("e.c:Apttus_Grid_RecordId_Event");
                appEvent.setParams({ "recordid" : component.get("v.recordId")});
                appEvent.fire();
        if (stepName=="Setup Pricing")
        {
       		component.set("v.DisplayBack",true);
        	component.set("v.DisplayNext",false);
            component.set("v.counter", 0);
        }
        
        if (stepName=="Generate Document")
        {
       		component.set("v.DisplayBack",false);
        	component.set("v.DisplayNext",true);
            component.set("v.counter", 1);
        }
        
   
        var appEvent = $A.get("e.c:Apttus_PCD_Refresh_Component_Event");
        appEvent.setParams({ "counter" : component.get("v.counter")});
        appEvent.fire();
                
            }
        });
        $A.enqueueAction(action);
    },
    cancel : function (component, event, helper) 
    {    component.set("v.Refreshdone",false);
         var urlEvent = $A.get("e.force:navigateToURL");
         urlEvent.setParams({
         "url": 'https://'+ component.get("{!v.vfHost}") + '/lightning/cmp/c__PCD_OFFER_AccountPage_header?c__accountName='+ component.get("{!v.accountid}")
                           });
         urlEvent.fire();
    },
    back : function (component, event, helper) 
    {
        component.set("v.Refreshdone",false);
        var countervar = component.get("v.counter");
        countervar = countervar - 1;
        if (countervar == 0)
        {
         component.set("{!v.status}","Setup Pricing")
         component.set("v.DisplayNext",false);
         component.set("v.DisplayBack",true);
         helper.statusupdate(component,event);
        } 
        component.set("v.counter",countervar);
        var appEvent = $A.get("e.c:Apttus_PCD_Refresh_Component_Event");
        appEvent.setParams({ "counter" : countervar});
        appEvent.fire();	  
    },
    next : function (component, event, helper) 
    {   var countervar = component.get("v.counter");
        countervar = countervar + 1;
        if (countervar == 1)
        {
         component.set("v.DisplayNext",true);
         component.set("v.DisplayBack",false);
         component.set("{!v.status}","Generate Document")
         helper.statusupdate(component,event); 
        }
        component.set("v.counter",countervar);
        var appEvent = $A.get("e.c:Apttus_PCD_Refresh_Component_Event");
        appEvent.setParams({ "counter" : countervar});
        appEvent.fire();	
    },
})