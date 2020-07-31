({
	createpricing : function(component,event,helper) {
        
        
        
        var action = component.get("c.get_createdata");
        action.setParams({"fafid":  component.get("{!v.fafid}"),
                          "nname" : component.get("{!v.networkname}"),
                          "ntype" : component.get("{!v.networktype}"),
                          "lob" : component.get("{!v.lob}"),
                          "des" : component.get("{!v.desc}")})
        action.setCallback(this, $A.getCallback(function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                if (response.getReturnValue() == 0)
                 {
                	 var action = component.get("c.get_newpricingdata");
       			     action.setParams({"fafid":  component.get("{!v.fafid}"),
                          "NetName": component.get("{!v.networkname}"),
                          "NetType": component.get("{!v.networktype}"),
                          "des": component.get("{!v.desc}"),
                          "lob": component.get("{!v.lob}")})
        			 action.setCallback(this, $A.getCallback(function(response) {
           			 var state = response.getState();
            	     if (state === "SUCCESS") {
                      component.set("v.netobjects", response.getReturnValue());
                      component.set("v.btndisplay",true);
                      var data = component.get("v.netobjects");
                      var itemcount = data.length;
                      component.set("v.pricingcount", itemcount);
                      component.set("v.displaychild", true);
                      component.set("v.DisplaySpinner",false);
                         
                         
                        var action = component.get("c.get_yearcountali");
       				   action.setParams({"ali":  component.get("{!v.ali}")})
        			   action.setCallback(this, $A.getCallback(function(response) {
            			var state = response.getState();
            			if (state === "SUCCESS") {
                		component.set("v.yearcount", response.getReturnValue());
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
                    var appEvent = $A.get("e.c:Apttus_Grid_Height_Event");
                    appEvent.fire();

                 }
                
                 if (response.getReturnValue() == 1)
                 {
                    var errors = "Retail Network Pricing record already exists for the Network Name,Network Type, LOB and Custom Network Description combination. Please create a unique record using the combination.";
                    var appEvent = $A.get("e.c:Apttus_Grid_NT_Notify_Error_Event");
                    appEvent.setParams({ "Error" : errors});
                    appEvent.fire();   
                 }
                
               }
            else if (state = "ERROR")
               {
                component.set("v.DisplaySpinner",false);
                var errors = response.getError();
                var message;
                if (errors) {
                   if(errors[0] && errors[0].message) {
                        message = "Error message: " + errors[0].message; 
                           }
                } 
                else {
                    message = "Error in Creation of Network Pricing Information";
                     }   
                var appEvent = $A.get("e.c:Apttus_Grid_NT_Notify_Error_Event");
                appEvent.setParams({ "Error" : message});
                appEvent.fire();        
               }
        }));
        $A.enqueueAction(action);
        
        
      
        
       },
    
    
    
    fetchpicklist : function(component,event,helper) {
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
        
    },
   
  getThisReconciliation : function(component,event,helper) 
           {
               
        
               
			       var action = component.get("c.get_newpricingdata");
       			     action.setParams({"fafid":  component.get("{!v.fafid}"),
                          "NetName": component.get("{!v.networkname}"),
                          "NetType": component.get("{!v.networktype}"),
                          "des": component.get("{!v.desc}"),
                          "lob": component.get("{!v.lob}")})
        			 action.setCallback(this, $A.getCallback(function(response) {
           			 var state = response.getState();
            	     if (state === "SUCCESS") {
                      component.set("v.netobjects", response.getReturnValue());                   
                      component.set("v.btndisplay",true);
                      var data = component.get("v.netobjects");
                      var itemcount = data.length;
                      component.set("v.pricingcount", itemcount);
                      component.set("v.displaychild", true);
                      component.set("v.DisplaySpinner",false);
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
                  component.set("v.DisplaySpinner",false);
           }      
        
})