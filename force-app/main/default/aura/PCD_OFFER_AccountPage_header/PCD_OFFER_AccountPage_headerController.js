({
	init : function(component, event, helper) {
        var card = component.find('card');
        $A.util.addClass(card, 'card'); 
		var pageReference = component.get("v.pageReference");
        //alert('test'+sessionStorage.getItem('pluginBugFixedByReloading'));
        if (sessionStorage.getItem('pluginBugFixedByReloading') !='fixed' )
        {
          sessionStorage.setItem('pluginBugFixedByReloading','fixed');
          window.location.reload(true);
        }
        var action = component.get("c.getAccountId");
        action.setParams({strID:pageReference.state.c__accountName});
        action.setCallback(this, function(response) 
          {
            var state = response.getState();
            if (state === "SUCCESS") 
            {
              component.set("v.accountid",response.getReturnValue());
            }
            else 
            {
                console.log("Failed with state: " + state);
            }
         });
           $A.enqueueAction(action);

        
        
		//component.set("v.accountName", pageReference.state.c__accountName.Name);
		//ahrefvalue.set("v.ahrefvalue","https://pbmfinancecvshealth--pbmfinpd.lightning.force.com/lightning/r/Account/"+"{!v.accountid}"+"/view");
        var action = component.get("c.getAccount");
        component.set("{!v.taskid}", pageReference.state.c__accountName);
        var taskid = pageReference.state.c__accountName;
        var accntid = component.get("v.accountid");
        var appEvent = $A.get("e.c:Apttus_Grid_AccountId_Event");
        appEvent.setParams({
            "accountid" : component.get("{!v.accountid}"),
            "accntid" : taskid});
        appEvent.fire();
        action.setParams({strID:pageReference.state.c__accountName});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                 var json1 = JSON.parse(JSON.stringify(response.getReturnValue()));
                 for (var key in json1){
                     component.set("v.accountName",json1[key]);
                     break;
                 }
              
            }
            else {
                console.log("Failed with state: " + state);
            }
        });
        $A.enqueueAction(action);


	},
     reInit : function(component, event, helper) {
        $A.get('e.force:refreshView').fire();
    }
})