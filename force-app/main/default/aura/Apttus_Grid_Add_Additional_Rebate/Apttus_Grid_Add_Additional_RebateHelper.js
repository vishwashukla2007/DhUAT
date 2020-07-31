({
    createmlob: function(component, event, helper) 
    {
      var action = component.get("c.create_mlob");
      action.setParams({
            "Basealiid" : component.get("{!v.ali}"),
            "mlob" : component.get("{!v.mlobcreation}")});
              action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") 
                 {
                   helper.retrievemlob(component, event, helper); 
                 }
            else {
                 var toastEvent = $A.get("e.force:showToast");
    			  toastEvent.setParams({
                  "title": "Error!",
                  "type":"error",
                  "mode": "pester",
                  "message": "Problem in addition of LOBs."
                                      });
    			  toastEvent.fire(); 
                 }
        });
        $A.enqueueAction(action);    
        
    },
	retrievemlob: function(component, event, helper) 
    {
      var action = component.get("c.get_AdditionalLOB");
       action.setParams({
            "Basealiid" : component.get("{!v.ali}")});
       action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") 
                 {
                  component.set("{!v.lstmultplelob}",response.getReturnValue());
                  var loblist = response.getReturnValue();
                  var data = component.get("v.lstmultplelob");
 				  var itemcount = data.length;
 				  component.set("v.LOBcount", itemcount);
                  var countcheck = 1;
                   for(var lob in loblist) 
         			{
                       component.set("v.selectedtabid",null);
                       if (loblist[lob].Additional_LOB_Numeric_ID__c == '6') 
                         {
                           component.set("v.lob6visible", true);
                           component.set("v.selectedlob", loblist[lob].Additional_LOB_ID__c);
                           component.set("v.selectedlobid", loblist[lob].Additional_LOB__c);
                           component.set("v.selectedlobid6", loblist[lob].Additional_LOB__c);
                           component.set("v.selectedlob6", loblist[lob].Additional_LOB_ID__c);
                           component.set("v.selectedfafid6", loblist[lob].Additional_FAF_ID__c);
                           component.set("v.additionalaliid6", loblist[lob].Additional_ALI_ID__c);
                           component.set("v.additionalaliid", loblist[lob].Additional_ALI_ID__c);
                           component.set("v.queryfafid", component.get("v.selectedfafid6"));
                           if (component.get("v.selectedtabid") > 6)
                           component.set("v.selectedtabid", '6');
                         }
                        if (loblist[lob].Additional_LOB_Numeric_ID__c == '5') 
                         {
                           component.set("v.lob5visible", true);
                           component.set("v.selectedlob", loblist[lob].Additional_LOB_ID__c);
                           component.set("v.selectedlobid", loblist[lob].Additional_LOB__c);
                           component.set("v.selectedlobid5", loblist[lob].Additional_LOB__c);
                           component.set("v.selectedlob5", loblist[lob].Additional_LOB_ID__c);
                           component.set("v.selectedfafid5", loblist[lob].Additional_FAF_ID__c);
                           component.set("v.additionalaliid5", loblist[lob].Additional_ALI_ID__c);
                           component.set("v.additionalaliid", loblist[lob].Additional_ALI_ID__c);
                           component.set("v.queryfafid", component.get("v.selectedfafid5"));
                           if (component.get("v.selectedtabid") > 5)
                              component.set("v.selectedtabid", '5');
                         }
                         if (loblist[lob].Additional_LOB_Numeric_ID__c == '4') 
                         {
                           component.set("v.lob4visible", true);
                           component.set("v.selectedlob", loblist[lob].Additional_LOB_ID__c);
                           component.set("v.selectedlobid", loblist[lob].Additional_LOB__c);
                           component.set("v.selectedlobid4", loblist[lob].Additional_LOB__c);
                           component.set("v.selectedlob4", loblist[lob].Additional_LOB_ID__c);
                           component.set("v.selectedfafid4", loblist[lob].Additional_FAF_ID__c);
                           component.set("v.additionalaliid4", loblist[lob].Additional_ALI_ID__c);
                           component.set("v.additionalaliid", loblist[lob].Additional_ALI_ID__c);
                           component.set("v.queryfafid", component.get("v.selectedfafid4"));
                           if (component.get("v.selectedtabid") > 4)
                           component.set("v.selectedtabid", '4');
                         }
                         if (loblist[lob].Additional_LOB_Numeric_ID__c == '3')
                         {
                           component.set("v.lob3visible", true);
                           component.set("v.selectedlob", loblist[lob].Additional_LOB_ID__c);
                           component.set("v.selectedlobid", loblist[lob].Additional_LOB__c);
                           component.set("v.selectedlobid3", loblist[lob].Additional_LOB__c);
                           component.set("v.selectedlob3", loblist[lob].Additional_LOB_ID__c);
                           component.set("v.selectedfafid3", loblist[lob].Additional_FAF_ID__c);
                           component.set("v.additionalaliid3", loblist[lob].Additional_ALI_ID__c);
                           component.set("v.additionalaliid", loblist[lob].Additional_ALI_ID__c);
                           component.set("v.queryfafid", component.get("v.selectedfafid3"));
                           if (component.get("v.selectedtabid") > 3)
                           component.set("v.selectedtabid", '3');
                         }
                        if (loblist[lob].Additional_LOB_Numeric_ID__c == '2') 
                         {
                           component.set("v.lob2visible", true);
                           component.set("v.selectedlob", loblist[lob].Additional_LOB_ID__c);
                           component.set("v.selectedlobid", loblist[lob].Additional_LOB__c);
                           component.set("v.selectedlobid2", loblist[lob].Additional_LOB__c);
                           component.set("v.selectedlob2", loblist[lob].Additional_LOB_ID__c);
                           component.set("v.selectedfafid2", loblist[lob].Additional_FAF_ID__c);
                           component.set("v.additionalaliid2", loblist[lob].Additional_ALI_ID__c);
                           component.set("v.additionalaliid", loblist[lob].Additional_ALI_ID__c);
                           component.set("v.queryfafid", component.get("v.selectedfafid2"));
                           if (component.get("v.selectedtabid") > 2)
                           component.set("v.selectedtabid", '2');
                         }
                       if (loblist[lob].Additional_LOB_Numeric_ID__c == '1') 
                          {
                           component.set("v.lob1visible", true);
                           component.set("v.selectedlob", loblist[lob].Additional_LOB_ID__c);
                           component.set("v.selectedlobid", loblist[lob].Additional_LOB__c);
                           component.set("v.selectedlobid1", loblist[lob].Additional_LOB__c);
                           component.set("v.selectedlob1", loblist[lob].Additional_LOB_ID__c);
                           component.set("v.selectedfafid1", loblist[lob].Additional_FAF_ID__c);
                           component.set("v.additionalaliid1", loblist[lob].Additional_ALI_ID__c);
                           component.set("v.additionalaliid", loblist[lob].Additional_ALI_ID__c);
                           component.set("v.queryfafid", component.get("v.selectedfafid1"));
                           if (component.get("v.selectedtabid") > 1)
                           component.set("v.selectedtabid", '1');
                          }
                        if (countcheck == itemcount)
                        helper.retrievepricing(component, event, helper);
                      
                       
                      
                      
                        
                     /* if (lob > 0)
                       {
                       var selectedLOBs = component.get("v.selectedLOBs"); 
                       let alist = [];
                       
                       selectedLOBs.push({ label: loblist[lob].LOB_Description__c, value: loblist[lob].LOB_Description__c });
                       component.set("v.selectedLOBs",selectedLOBs); 
                       } */
                    }
     
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
      var action = component.get("c.get_allLOB");
       action.setParams({
            "Basealiid" : component.get("{!v.ali}")});
       action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") 
                 {
                  var loblist = response.getReturnValue();
                  var data = component.get("v.lstmultplelob");
 				  var itemcount = data.length;
                  component.set("v.loboption",component.get("v.loboptiondefault")); 
                  for(var lob in loblist) 
         	      {
                                          
                        if (loblist[lob].LobId__c == '1') 
                         {
  
                           if ((loblist[lob].FAF_Agreement_Line_Item__c != component.get("{!v.ali}")) && component.get("v.lob1visible") != true)
                           {
                               var loboption = component.get("v.loboption");
                                    var lob1desc = {'label' :'LOB 1 - ' + loblist[lob].LOB_Description__c,'value': loblist[lob].Id,'selected':''};
                                    loboption.push(lob1desc);
                                    component.set("v.loboption",loboption);
                           }
                         
                         }
                        if (loblist[lob].LobId__c == '2') 
                         {
                           
                           if ((loblist[lob].FAF_Agreement_Line_Item__c	 != component.get("{!v.ali}")) && component.get("v.lob2visible") != true)
                           {  
                               var loboption = component.get("v.loboption");
                               var lob2desc = {'label' :'LOB 2 - ' + loblist[lob].LOB_Description__c,'value': loblist[lob].Id,'selected':''};
                               loboption.push(lob2desc);
                               component.set("v.loboption",loboption);
                           }
                         
                         }
                        if (loblist[lob].LobId__c == '3') 
                         {
                           if ((loblist[lob].FAF_Agreement_Line_Item__c	 != component.get("{!v.ali}")) && component.get("v.lob3visible") != true)
                           {
                               
                               var loboption = component.get("v.loboption");
                               var lob3desc = {'label' :'LOB 3 - ' + loblist[lob].LOB_Description__c,'value': loblist[lob].Id,'selected':''};
                               loboption.push(lob3desc);
                               component.set("v.loboption",loboption);
                           }
                         
                         }
                        if (loblist[lob].LobId__c == '4') 
                         {
                           if ((loblist[lob].FAF_Agreement_Line_Item__c	 != component.get("{!v.ali}")) && component.get("v.lob4visible") != true)
                           {
                               
                             var loboption = component.get("v.loboption");
                               var lob4desc = {'label' :'LOB 4 - ' + loblist[lob].LOB_Description__c,'value': loblist[lob].Id,'selected':''};
                               loboption.push(lob4desc);
                               component.set("v.loboption",loboption);
                           }
                         
                         }
                        if (loblist[lob].LobId__c == '5') 
                         {
                           if ((loblist[lob].FAF_Agreement_Line_Item__c	 != component.get("{!v.ali}")) && component.get("v.lob5visible") != true)
                           {
                               
                            var loboption = component.get("v.loboption");
                               var lob5desc = {'label' :'LOB 5 - ' + loblist[lob].LOB_Description__c,'value': loblist[lob].Id,'selected':''};
                               loboption.push(lob5desc);
                               component.set("v.loboption",loboption);
                           }
                         }
                        if (loblist[lob].LobId__c == '6') 
                         {
                           if ((loblist[lob].FAF_Agreement_Line_Item__c	 != component.get("{!v.ali}")) && component.get("v.lob6visible") != true)
                           {
                              var loboption = component.get("v.loboption");
                               var lob6desc = {'label' :'LOB 6 - ' + loblist[lob].LOB_Description__c,'value': loblist[lob].Id,'selected':''};
                               loboption.push(lob6desc);
                               component.set("v.loboption",loboption);
                           }
                         
                         }
                      
                        var loboption =  component.get("v.loboption");
                        var itemcount = loboption.length;
                        if (itemcount == 0)
                            component.set("v.addlobcount",true);
                        else
                            component.set("v.addlobcount",false);
                   
                    }
     
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
        
        
     },
    
  retrievepricing: function(component, event, helper) 
    {
      
      var action = component.get("c.get_Pricing");
       action.setParams({
            "fafid" : component.get("{!v.queryfafid}")});
       action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") 
                 {
                   component.set("{!v.norecord}",false);
                   component.set("{!v.rgpricinglist}",response.getReturnValue());
                   var count = response.getReturnValue();
 				   var itemcount = count.length;
                   if (itemcount == 0)
                   {
                   component.set("{!v.norecord}",true);
                   }
                 
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