({
    doInit : function(component, event, helper) {
        var pageReference = component.get("v.pageReference");
        component.set("{!v.LineitemID}",pageReference.state.c__AgreementId);
        console.log('Record Line item id'+component.get("v.LineitemID"));
        component.set("{!v.record}", component.get("v.recordId"));
    },
    recordidupd : function(component, event, helper) {
        var recordid =  event.getParam("recordid");
        component.set("{!v.record}", recordid);     
    },
	refreshView : function(component, event, helper) {
		var counter = event.getParam("counter");
        if (counter==0)
        {
            component.set("{!v.DisplayQs}", false);
            component.set("{!v.DisplayGrid}", true);
            component.set("{!v.DisplayGenDoc}", false);
        }
        if (counter==1)
        {
            component.set("{!v.DisplayQs}", false);
            component.set("{!v.DisplayGrid}", false);
            component.set("{!v.DisplayGenDoc}", true);
        }
	},
    doInit : function(component, event, helper)
    {
            component.set("{!v.DisplayQs}", true);
            component.set("{!v.DisplayGrid}", false);
            component.set("{!v.DisplayGenDoc}", false);
    }
})