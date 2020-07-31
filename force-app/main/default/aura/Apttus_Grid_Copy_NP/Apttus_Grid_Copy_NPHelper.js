({
	getThisReconciliation : function(component, helper) {
        
        var action = component.get("c.get_yearcount");
        action.setParams({"fafid":  component.get("{!v.fafid}")})
        action.setCallback(this, $A.getCallback(function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.yearcount", response.getReturnValue());
               
                
                  var action = component.get("c.get_pricingdata");
        action.setParams({"fafid":  component.get("{!v.fafid}"),
                          "NetName": component.get("{!v.networkname}"),
                          "NetType": component.get("{!v.networktype}"),
                          "des": component.get("{!v.desc}"),
                          "lob": component.get("{!v.lob}")})
        action.setCallback(this, $A.getCallback(function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.netobjects", response.getReturnValue());
                var data = component.get("v.netobjects");
                var itemcount = data.length;
                component.set("v.pricingcount", itemcount);
                 component.set("v.isJqueryLoaded",true);
        		component.set("v.needToProcessReRenderLogic",true);
                component.set("v.activerownum", itemcount); 
                 if (component.get("v.pricingcount") >= component.get("v.yearcount"))
       			 {
             		component.set("v.disablebtn", true);
        		 }
        		else
        		{
            		component.set("v.disablebtn", false);
        		}
            }
            else {
                helper.counselLogErrors(response.getError());
            }
        }));
        $A.enqueueAction(action);
        
                
                
            }
            else {
                helper.counselLogErrors(response.getError());
            }
        }));
        $A.enqueueAction(action);  
        
           
        
        var action = component.get("c.findPicklistOptions");
        action.setParams({"objAPIName":  "Network_Pricing__c",
                          "fieldAPIname": "Network_Name__c"})
        action.setCallback(this, $A.getCallback(function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.nnameoptions", response.getReturnValue());
            }
            else {
                helper.counselLogErrors(response.getError());
            }
        }));
        $A.enqueueAction(action);
        
        var action = component.get("c.findPicklistOptions");
        action.setParams({"objAPIName":  "Network_Pricing__c",
                          "fieldAPIname": "Network_Type__c"})
        action.setCallback(this, $A.getCallback(function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.ntypeoptions", response.getReturnValue());
            }
            else {
                helper.counselLogErrors(response.getError());
            }
        }));
        $A.enqueueAction(action);
        
        var action = component.get("c.findPicklistOptions");
        action.setParams({"objAPIName":  "Network_Pricing__c",
                          "fieldAPIname": "LOB__c"})
        action.setCallback(this, $A.getCallback(function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.loboptions", response.getReturnValue());
            }
            else {
                helper.counselLogErrors(response.getError());
            }
        }));
        $A.enqueueAction(action);
    }
   
})