({
	retrievepricing: function(component, event, helper) 
    {
       
       var action = component.get("c.get_listPricing");
       action.setParams({
            "fafid" : component.get("{!v.fafid}"),
            "nonspecialty" : component.get("{!v.rebateguarantee.Modeled_Non_Specialty_Formulary_Name__c}"),
            "specialty" : component.get("{!v.rebateguarantee.Modeled_Specialty_Formulary_Name__c}"),
            "gstp" : component.get("{!v.rebateguarantee.GSTP__c}")});
       action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") 
                 {
                   component.set("{!v.norecord}",true);
                   component.set("{!v.rgpricinglist}",response.getReturnValue());
                   var count = response.getReturnValue();
 				   var itemcount = count.length;
                   if (itemcount == 0)
                   component.set("{!v.norecord}",false);
                 
                 }
            else {
                 var toastEvent = $A.get("e.force:showToast");
    			  toastEvent.setParams({
                  "title": "Error!",
                  "type":"error",
                  "mode": "pester",
                  "message": "Problem in displaying Network Pricing."
                                      });
    			  toastEvent.fire(); 
                 }
        });
        $A.enqueueAction(action);  
     }  
})