({
    
    tasksubtype : function(component, event, helper) 
    {
      var action = component.get("c.get_Task");
       action.setParams({
            "offerid" : component.get("{!v.offerid}")});
       action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") 
                 {
                  component.set("{!v.tasksubtype}",response.getReturnValue());    
                 }
            else {
                 var toastEvent = $A.get("e.force:showToast");
    			  toastEvent.setParams({
                  "title": "Error!",
                  "type":"error",
                  "mode": "pester",
                  "message": "No Task Subtype available."
                                      });
    			  toastEvent.fire(); 
                 }
        });
        $A.enqueueAction(action);  
      },
    
    
    
    
	retrievepcd : function(component, event, helper) 
    {

      var action = component.get("c.get_lineofbusiness");
       action.setParams({
            "offerid" : component.get("{!v.offerid}")});
       action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") 
                 {
                  component.set("{!v.loblist}",response.getReturnValue());
                  var loblist = response.getReturnValue();
                  var data = component.get("v.loblist");
 				  var itemcount = data.length;
 				  component.set("v.LOBcount", itemcount);
                   for(var lob in loblist) 
         			{
                      if (lob > 0)
                       {
                       var selectedLOBs = component.get("v.selectedLOBs"); 
                       let alist = [];
                       
                       selectedLOBs.push({ label: loblist[lob].LOB_Description__c, value: loblist[lob].LOB_Description__c });
                       component.set("v.selectedLOBs",selectedLOBs); 
                       }
                    }
                   component.set("v.options",component.get("v.selectedLOBs"));   
                 }
            else {
                 var toastEvent = $A.get("e.force:showToast");
    			  toastEvent.setParams({
                  "title": "Error!",
                  "type":"error",
                  "mode": "pester",
                  "message": "Problem in new PCD Creation."
                                      });
    			  toastEvent.fire(); 
                 }
        });
        $A.enqueueAction(action);  
              
        
       var action = component.get("c.get_LOB");
       action.setParams({
            "offerid" : component.get("{!v.offerid}")});
       action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") 
                 {
                  component.set("{!v.objects}",response.getReturnValue());    
                  
                 }
            else {
                 var toastEvent = $A.get("e.force:showToast");
    			  toastEvent.setParams({
                  "title": "Error!",
                  "type":"error",
                  "mode": "pester",
                  "message": "Problem in extraction of Information."
                                      });
    			  toastEvent.fire(); 
                 }
        });
        $A.enqueueAction(action);
	},
    
    createpcd : function(component, event, helper) 
    {
      var selectlob = component.find("selectlob");
      var changeValue = selectlob.get("v.value");
      var optionlob = component.find("lobgroup");
      var changeoptionlob;
      if (changeoptionlob != null)
      {
      var changeoptionlob = optionlob.get("v.value");
      }
      var addlobs = component.get("v.newLOBs");
      for (var lob in changeoptionlob)
      {
        addlobs.push(changeoptionlob[lob]); 
      }
      var action = component.get("c.get_createpcd");
       action.setParams({
            "offerid" : component.get("{!v.offerid}"),
            "baselobid" : changeValue,
            "addlobs" : addlobs
            });
            action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") 
            {           
            var action = component.get("c.get_pcd");
      		 action.setParams({
            "offerid" : component.get("{!v.offerid}")});
            action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") 
                 {         
                  component.set("{!v.offerlist}",response.getReturnValue());
                  var lobid = component.find("selectlob").get("v.value");
                  var action = component.get("c.updatepriali");
      		 	action.setParams({
            	"agreeid" : component.get("{!v.offerlist.PCD__c}"),
                "lobid" : lobid});
            	action.setCallback(this, function(response) {
           		 var state = response.getState();
            	if (state === "SUCCESS") 
                 {         
                  component.set("{!v.DisplaySpinner}",false);
                  component.set("{!v.isCreatePCDOpen}",false);
                  var urlEvent = $A.get("e.force:navigateToURL");
         		  urlEvent.setParams({
                  "url": 'https://'+ component.get("{!v.vfHost}") + '/lightning/r/Apttus__APTS_Agreement__c/' + component.get("{!v.offerlist.PCD__c}") + '/view'
                           });
                  urlEvent.fire();   
                     
                 }
            else {
                 component.set("{!v.DisplaySpinner}",false);
                 var toastEvent = $A.get("e.force:showToast");
    			  toastEvent.setParams({
                  "title": "Error!",
                  "type":"error",
                  "mode": "pester",
                  "message": "Problem in new PCD Creation."
                                      });
    			  toastEvent.fire(); 
                 }
        });
        $A.enqueueAction(action);     
                                
                 }
            else {
                 component.set("{!v.DisplaySpinner}",false);
                 var toastEvent = $A.get("e.force:showToast");
    			  toastEvent.setParams({
                  "title": "Error!",
                  "type":"error",
                  "mode": "pester",
                  "message": "Problem in new PCD Creation."
                                      });
    			  toastEvent.fire(); 
                 }
        });
        $A.enqueueAction(action);     
                 }
            else {
                 component.set("{!v.DisplaySpinner}",false);
                 var toastEvent = $A.get("e.force:showToast");
    			  toastEvent.setParams({
                  "title": "Error!",
                  "type":"error",
                  "mode": "pester",
                  "message": "Problem in new PCD Creation."
                                      });
    			  toastEvent.fire(); 
                 }
        });
        $A.enqueueAction(action); 
    }
})