({
	redirectsetuppricing : function(component, event, helper) 
    {
        
       var action = component.get("c.update_priali");
       action.setParams({
            "agrid" : component.get("{!v.item.Apttus__AgreementId__c}"),
            "aliid" : component.get("{!v.item.Id}")});
       action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") 
                 {
                  /* var appEvent = $A.get("e.c:Apttus_PCD_Refresh_Component_Event");
  				   appEvent.setParams({ "counter" : 0});
                   appEvent.fire();*/
                  component.set("{!v.DisplaySpinner}", false);
                  var urlEvent = $A.get("e.force:navigateToURL");
         		  urlEvent.setParams({
                  "url": 'https://'+ component.get("{!v.vfHost}") + '/lightning/r/Apttus__APTS_Agreement__c/' + component.get("{!v.item.Apttus__AgreementId__c}") + '/view'
                           });
                  urlEvent.fire(); 
                  
                 }
            else {
                  component.set("{!v.DisplaySpinner}", false);
                  var toastEvent = $A.get("e.force:showToast");
    			  toastEvent.setParams({
                  "title": "Error!",
                  "type":"error",
                  "mode": "pester",
                  "message": "Problem in Redirect to Setup Pricing."
                                      });
    			  toastEvent.fire(); 
                 }
        });
        $A.enqueueAction(action);
        
	},
    
    redirectgeneratedoc : function(component, event, helper) 
    {
        
       var action = component.get("c.update_prialigen");
       action.setParams({
            "agrid" : component.get("{!v.item.Apttus__AgreementId__c}"),
            "aliid" : component.get("{!v.item.Id}")});
       action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") 
                 {
                 /* var appEvent = $A.get("e.c:Apttus_PCD_Refresh_Component_Event");
  				   appEvent.setParams({ "counter" : 1}); 
                   appEvent.fire();*/
                 component.set("{!v.DisplaySpinner}", false);
                  var urlEvent = $A.get("e.force:navigateToURL");
         		  urlEvent.setParams({
                  "url": 'https://'+ component.get("{!v.vfHost}") + '/lightning/r/Apttus__APTS_Agreement__c/' + component.get("{!v.item.Apttus__AgreementId__c}") + '/view'
                           });
                  urlEvent.fire();   
                  
                 }
            else {
                  component.set("{!v.DisplaySpinner}", false);
                  var toastEvent = $A.get("e.force:showToast");
    			  toastEvent.setParams({
                  "title": "Error!",
                  "type":"error",
                  "mode": "pester",
                  "message": "Problem in Redirect to Document Generation."
                                      });
    			  toastEvent.fire(); 
                 }
        });
        $A.enqueueAction(action);    
	},
    editcaveats : function(component, event, helper) 
    {
       
       var action = component.get("c.get_worddoc");
       action.setParams({
            "aliid" : component.get("{!v.item.Id}")});
       action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") 
                 {
                  component.set("{!v.docversion}",response.getReturnValue());
                   var data = component.get("v.docversion");
 				   if (data != null && data != "undefined")
                   {
 				    component.set("v.wordcount", 1);
                   }
                   else
                   {
                    component.set("v.wordcount", 0);
                   }
                   component.set("v.url", "/servlet/servlet.FileDownload?file=" + component.get("v.docversion.Apttus__ContentId__c"));
                   if(component.get("{!v.selected}") == 0)
     				 {
         				var cmpTarget = component.find('card');
       				    $A.util.addClass(cmpTarget, 'outerborderblue');
        				var cmpTarget = component.find('outerborders');
        				$A.util.addClass(cmpTarget, 'hidden');
                        var appEvent = $A.get("e.c:Apttus_Grid_Close_New_Event");
        				appEvent.setParams({
            				"message" : component.get("v.item.LOB_Detail__c")});
       				    appEvent.fire();
      				 }  
      				if(component.get("v.item.Template_Exclude__c") == false)
                    	{
                        var cmpTarget = component.find('card');
       				    $A.util.addClass(cmpTarget, 'outerborderblue');
        				var cmpTarget = component.find('outerborders');
        				$A.util.addClass(cmpTarget, 'hidden');
                        var appEvent = $A.get("e.c:Apttus_Grid_Close_New_Event");
        				appEvent.setParams({
            				"message" : component.get("v.item.LOB_Detail__c")});
       				    appEvent.fire();
                    	}
                     
                 }
            else {
                  component.set("v.wordcount", 0);
                   if(component.get("{!v.selected}") == 0)
     				 {
         				var cmpTarget = component.find('card');
       				    $A.util.addClass(cmpTarget, 'outerborderblue');
        				var cmpTarget = component.find('outerborders');
        				$A.util.addClass(cmpTarget, 'hidden');
                        var appEvent = $A.get("e.c:Apttus_Grid_Close_New_Event");
        				appEvent.setParams({
            				"message" : component.get("v.item.LOB_Detail__c")});
       				    appEvent.fire();
      				 }  
      				if(component.get("v.item.Template_Exclude__c") == false)
                    	{
                        var cmpTarget = component.find('card');
       				    $A.util.addClass(cmpTarget, 'outerborderblue');
        				var cmpTarget = component.find('outerborders');
        				$A.util.addClass(cmpTarget, 'hidden');
                        var appEvent = $A.get("e.c:Apttus_Grid_Close_New_Event");
        				appEvent.setParams({
            				"message" : component.get("v.item.LOB_Detail__c")});
       				    appEvent.fire();
                    	}
                  /*var toastEvent = $A.get("e.force:showToast");
    			  toastEvent.setParams({
                  "title": "Error!",
                  "type":"error",
                  "mode": "pester",
                  "message": "Problem in Extracting Generated Documents."
                                      });
    			  toastEvent.fire(); */
                 }
        });
        $A.enqueueAction(action);
    }
    
})