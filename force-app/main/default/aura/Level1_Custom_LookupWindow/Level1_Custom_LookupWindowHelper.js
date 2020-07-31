({
	searchCarrierRecords : function(component, platform, lob, fafid, accid) {
      debugger;
      var action = component.get("c.fetchinitialCValues");
        action.setParams({ 
            platform : platform,
        	lob : lob,
        	fafid : fafid,
            AccountId : accid
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
    },
  
  clearFilterCarrierRecords : function(component, platform, lob, fafid, accid) {
      debugger;
      var action = component.get("c.fetchclearFilterValues");
        action.setParams({ 
            platform : platform,
        	lob : lob,
        	fafid : fafid,
            AccountId : accid
          });

        // Create a callback that is executed after 
        // the server-side action returns
         action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                // Alert the user with the value returned 
                // from the server
                var result = response.getReturnValue();
                component.set('v.data', result.CAGS);
                debugger;
                 if (result.total == 0) {
                    component.set('v.isMessage', true);
                }
                else{
                    var total = result.total;
                    if (total > 100)
                    {
                       component.set('v.total', total);
                       component.set('v.issummaryMessage', true); 
                       var message = "Displaying 100 out of " + total +  " Records. You can search for the specific Carrier ID by using the Search"; 
                       component.set('v.summaryMessage', message); 
                    }
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
    },
fetchclearFilterSearchValues : function(component, searchkey, platform, lob, fafid, accid) {
      var action = component.get("c.fetchclearFilterSearchValues");
        action.setParams({ 
            searchkey : searchkey,
            platform : platform,
        	lob : lob,
        	fafid : fafid,
            AccountId : accid
          });

        // Create a callback that is executed after 
        // the server-side action returns
         action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                // Alert the user with the value returned 
                // from the server
                 debugger;
                 var result = response.getReturnValue();
                 component.set('v.data', result.CAGS);
                 debugger;
                 if (result.total == 0) {
                    component.set('v.isMessage', true);
                } 
                 else{
                    var total = result.total;
                    if (total > 100)
                    {
                       component.set('v.total', total);
                       component.set('v.issummaryMessage', true); 
                       var message = "Displaying 100 out of " + total +  " Records. You can search for the specific Carrier ID by using the Search"; 
                       component.set('v.summaryMessage', message); 
                    }
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
    },
  searchkeyCarrierRecords : function(component, searchkey, platform, lob, fafid, accid) {
      var action = component.get("c.fetchsearchkeyCValues");
        action.setParams({ 
            searchkey : searchkey,
            platform : platform,
        	lob : lob,
        	fafid : fafid,
            AccountId : accid
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