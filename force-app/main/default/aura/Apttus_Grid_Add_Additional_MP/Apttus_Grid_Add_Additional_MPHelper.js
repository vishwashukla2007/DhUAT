({
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
                  var lobDataMap = component.get("v.lobData");
                  var mapObj = {};
                  var currLob = '';   
 				  component.set("v.LOBcount", itemcount);
                   for(var lob in loblist) 
         			{
                       if (loblist[lob].Additional_LOB_Numeric_ID__c == '1') {
                           component.set("v.lob1visible", true);
                           mapObj['LOB1'] = loblist[lob];
                           if(!currLob) currLob = 'LOB1';
                       }
                        if (loblist[lob].Additional_LOB_Numeric_ID__c == '2') {
                            component.set("v.lob2visible", true);
                            mapObj['LOB2'] = loblist[lob];
                            if(!currLob) currLob = 'LOB2';
                        }
                        if (loblist[lob].Additional_LOB_Numeric_ID__c == '3') {
                            component.set("v.lob3visible", true);
                            mapObj['LOB3'] = loblist[lob];
                            if(!currLob) currLob = 'LOB3';
                        }
                        if (loblist[lob].Additional_LOB_Numeric_ID__c == '4') {
                            component.set("v.lob4visible", true);
                            mapObj['LOB4'] = loblist[lob];
                            if(!currLob) currLob = 'LOB4';
                        }
                        if (loblist[lob].Additional_LOB_Numeric_ID__c == '5') {
                            component.set("v.lob5visible", true);
                            mapObj['LOB5'] = loblist[lob];
                            if(!currLob) currLob = 'LOB5';
                        }
                        if (loblist[lob].Additional_LOB_Numeric_ID__c == '6') {
                            component.set("v.lob6visible", true);
                            mapObj['LOB6'] = loblist[lob];
                            if(!currLob) currLob = 'LOB6';
                        }
                        
                     /* if (lob > 0)
                       {
                       var selectedLOBs = component.get("v.selectedLOBs"); 
                       let alist = [];
                       
                       selectedLOBs.push({ label: loblist[lob].LOB_Description__c, value: loblist[lob].LOB_Description__c });
                       component.set("v.selectedLOBs",selectedLOBs); 
                       } */
                    }
     				Object.assign(lobDataMap, mapObj);
                    this.retrieveSelectedlob(component, currLob);
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
        
        // get all lobs
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
  
    retrieveSelectedlob: function(component, tabId) 
    {
       var fafid = component.get("v.lobData")[tabId].Additional_FAF_ID__c;
       component.set("v.lobNum",component.get("v.lobData")[tabId].Additional_LOB_Numeric_ID__c);
       component.set("v.LobName",component.get("v.lobData")[tabId].Additional_LOB_ID__c);
       var action = component.get("c.get_MPLOB");
       action.setParams({
           "fafid" : fafid});
       action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") 
            {
                var allMP = response.getReturnValue();
                allMP.forEach((o) => {o.isChecked = false;});
 				component.set("v.lstMPObj", allMP);
            }
       });
        $A.enqueueAction(action);
     },
                                      
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
    updateMailDenorm: function(component, event, helper) {
      var action = component.get("c.save_mlobMail");
      var tabId = component.get("v.selTabId");
      var additionalAli = component.get("v.lobData")[tabId].Additional_ALI_ID__c;
      action.setParams({
            "baseali" : component.get("{!v.ali}"),
          	"addali" : additionalAli,
            "selectedrec" : component.get("{!v.selectedIds}")});
              action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") 
                 {
                   //helper.retrievemlob(component, event, helper); 
                   console.log("3333333333");
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
    }                                  

})