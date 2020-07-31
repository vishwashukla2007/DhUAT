({
	createApprovalRequest : function(component) { 
        var record = component.get("v.recordId");
        var action = component.get("c.createapproval"); 
        action.setParams({
            "clientInfoRecId" : record
        })
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var toastEvent = $A.get("e.force:showToast");
        		toastEvent.setParams({
            	message: 'Email Sent',
            	key: 'info_alt',
            	type: 'Success',
           		mode: 'sticky'});
        		toastEvent.fire();
            
            }
           if (state ==="ERROR")
           {
                var toastEvent = $A.get("e.force:showToast");
        		toastEvent.setParams({
            	message: 'Problem in Send MChoice LOA',
            	key: 'info_alt',
            	type: 'info',
           		mode: 'sticky'
        							});
        		toastEvent.fire();
           }
        })
        $A.enqueueAction(action);   
    },
     
})