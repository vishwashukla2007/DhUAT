({
	retrievenote : function(component, event, helper) 
    {
	   var action = component.get("c.get_Attachment");
       action.setParams({
            "docverionid" : component.get("{!v.docs.Id}")});
       action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") 
                 {
                  component.set("{!v.attobj}",response.getReturnValue());    
                 }
            else {
                 console.log("Failed with state: " + state);
                 }
        });
        $A.enqueueAction(action);
	},
    deletedocument : function(component, event, helper) 
    {
	   var action = component.get("c.delete_Attachment");
       action.setParams({
            "docverionid" : component.get("{!v.docs.Id}")});
       action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") 
                 {
                  component.set("{!v.isDisplay}", false);
                  var appEvent = $A.get("e.c:Apttus_PCD_Document_Event");
                  appEvent.fire();
                 }
            else {
                 console.log("Failed with state: " + state);
                 }
        });
        $A.enqueueAction(action);
	},
    
    
})