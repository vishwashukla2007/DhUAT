({
	handleClick : function(component, event, helper) {
        
		var action = component.get("c.runJob");
         action.setParams({"myIdParam": component.get("v.agId")});
         action.setCallback(this, function(response){
             var state = response.getState();
             var title;
             var message;
             var type;
             var mode;
             if (state === "SUCCESS"){
                 var result = response.getReturnValue();
                 if(result !== null){
                     title = 'Job is now on queue.';
                     message = 'Please wait for the notification';
                     type = 'success';
                     mode = 'dismissible';
                 }else{
                     title = 'Job Failed';
                     message = 'Please make sure your agreement has criteria(RecordTyp=Legal, FAF not blank, Data Sync = Yes, Status Category IN Request OR In Authoring OR In Signature OR In filing OR In Effect)';
                     type = 'error';
                     mode = 'sticky';
                 }
                 var toastEvent = $A.get("e.force:showToast");
                 toastEvent.setParams({
                     title : title,
                     message: message,
                     type: type,
                     mode: mode
                 });
                 toastEvent.fire();
                 $A.get("e.force:closeQuickAction").fire();  
             }
         });
         $A.enqueueAction(action);
         
        
	}
})