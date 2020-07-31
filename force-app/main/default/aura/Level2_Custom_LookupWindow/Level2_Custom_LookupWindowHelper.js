({
	searchCarrierRecords : function(component, platform, lob, fafid) {
        debugger;
      var carrier = component.get("v.SelectedCarrier");
      var action = component.get("c.fetchinitialCValues");
        var accid = component.get("v.AccountId");
        action.setParams({ 
            platform : platform,
            Carrier : carrier
          });

        // Create a callback that is executed after 
        // the server-side action returns
         action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                // Alert the user with the value returned 
                // from the server
                component.set('v.data', response.getReturnValue());
                 if (response.getReturnValue().length == 0) {
                    component.set('v.isMessage', true);
                }
            }
            else if (state === "INCOMPLETE") {
                var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        mode: 'sticky',
                        message: 'Problem in Account Record Fetch.',
                        type : 'info'
                    });
                toastEvent.fire();
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        mode: 'sticky',
                        message: 'Problem in Account Record Fetch.',
                        type : 'error'
                    });
                toastEvent.fire();
            }
        });
        $A.enqueueAction(action);
    },
    
  searchkeyCarrierRecords : function(component, searchkey, platform, lob, fafid) {
      debugger;
      var carrier = component.get("v.SelectedCarrier");
      var action = component.get("c.fetchsearchkeyCValues");
        action.setParams({ 
            searchkey : searchkey,
            platform : platform,
            Carrier : carrier
          });

        // Create a callback that is executed after 
        // the server-side action returns
         action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                // Alert the user with the value returned 
                // from the server
                 debugger;
                 component.set('v.data', response.getReturnValue());
                 if (response.getReturnValue().length == 0) {
                    component.set('v.isMessage', true);
                }
            }
            else if (state === "INCOMPLETE") {
                var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        mode: 'sticky',
                        message: 'Problem in Carrier Record Fetch.',
                        type : 'info'
                    });
                toastEvent.fire();
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        mode: 'sticky',
                        message: errors,
                        type : 'error'
                    });
                toastEvent.fire();
            }
        });
        $A.enqueueAction(action);
    }
})