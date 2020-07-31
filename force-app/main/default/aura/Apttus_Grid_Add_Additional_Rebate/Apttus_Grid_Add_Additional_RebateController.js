({
	doInit : function(component, event, helper) 
    {
		helper.retrievemlob(component, event, helper); 
	},
    onChange : function(component, event, helper) 
    {
	    var tab = event.getSource();
        if(tab.get('v.id') == '1')
          {
            component.set("v.queryfafid", component.get("v.selectedfafid1"));
            component.set("v.selectedtabid", '1');
            component.set("v.selectedlob", component.get("v.selectedlob1"));
            component.set("v.selectedlobid", component.get("v.selectedlobid1"));
            component.set("v.additionalaliid", component.get("v.additionalaliid1"));
            helper.retrievepricing(component, event, helper);
          }
        if(tab.get('v.id') == '2')
          {
            component.set("v.queryfafid", component.get("v.selectedfafid2"));
            component.set("v.selectedtabid", '2');
            component.set("v.selectedlob", component.get("v.selectedlob2"));
            component.set("v.selectedlobid", component.get("v.selectedlobid2"));
            component.set("v.additionalaliid", component.get("v.additionalaliid2"));
            helper.retrievepricing(component, event, helper);
          }
        if(tab.get('v.id') == '3')
          {
            component.set("v.queryfafid", component.get("v.selectedfafid3"));
            component.set("v.selectedtabid", '3');
            component.set("v.selectedlob", component.get("v.selectedlob3"));
            component.set("v.selectedlobid", component.get("v.selectedlobid3"));
            component.set("v.additionalaliid", component.get("v.additionalaliid3"));
            helper.retrievepricing(component, event, helper);
          }
       if(tab.get('v.id') == '4')
          {
           component.set("v.queryfafid", component.get("v.selectedfafid4")); 
           component.set("v.selectedtabid", '4');
           component.set("v.selectedlob", component.get("v.selectedlob4"));
           component.set("v.selectedlobid", component.get("v.selectedlobid4"));
           component.set("v.additionalaliid", component.get("v.additionalaliid4"));
           helper.retrievepricing(component, event, helper);
          }
       if(tab.get('v.id') == '5')
          {
           component.set("v.queryfafid", component.get("v.selectedfafid5"));
           component.set("v.selectedtabid", '5');
           component.set("v.selectedlob", component.get("v.selectedlob5"));
           component.set("v.selectedlobid", component.get("v.selectedlobid5"));
           component.set("v.additionalaliid", component.get("v.additionalaliid5"));
           helper.retrievepricing(component, event, helper);
          }
       if(tab.get('v.id') == '6')
          {
           component.set("v.queryfafid", component.get("v.selectedfafid6"));
           component.set("v.selectedtabid", '6');
           component.set("v.selectedlob", component.get("v.selectedlob6"));
           component.set("v.selectedlobid", component.get("v.selectedlobid6"));
           component.set("v.additionalaliid", component.get("v.additionalaliid6"));
           helper.retrievepricing(component, event, helper);
          }
	},
   handleMouseLeave: function(component, event, helper) 
    {
        component.set("v.dropdownOver", false);
        var mainDiv = component.find('main-div');
        $A.util.removeClass(mainDiv, 'slds-is-open');
    },

    handleMouseEnter: function(component, event, helper) 
    {
        component.set("v.dropdownOver", true);
    }, 
    
   handleMouseOutButton: function(component, event, helper) {
        var options = component.get("v.loboption");
        component.set("v.mlobcreation", component.get("v.mlobcreation"));
        var lobid = component.get("v.mlobcreation");
        var selection = false;
        options.forEach(function(element) 
                 {
                    if (element.selected == true) 
                    {
                        lobid.push(element.value);
                        selection = true;
                    }
                  });
      
       if (selection == true)
       {
            component.set("v.mlobcreation",lobid);
            helper.createmlob(component, event, helper);
       }
        window.setTimeout(
            $A.getCallback(function() {
                if (component.isValid()) {
                    //if dropdown over, user has hovered over the dropdown, so don't close.
                    if (component.get("v.dropdownOver")) 
                    {
                        return;
                    }
                    var mainDiv = component.find('main-div');
                    $A.util.removeClass(mainDiv, 'slds-is-open');
                }
            }), 200
        );
        
    },
   handleClick : function(component, event, helper) 
    {
        var mainDiv = component.find('main-div');
        $A.util.addClass(mainDiv, 'slds-is-open');
    },
   handleSelection: function(component, event, helper) 
    {
      var item = event.currentTarget;
        if (item && item.dataset) {
            var value = item.dataset.value;
            var selected = item.dataset.selected;
            var options = component.get("v.loboption");
            //contro(ctrl) key ADDS to the list (unless clicking on a previously selected item)
            //also, ctrl key does not close the dropdown (uses mouse out to do that)
            if (event.ctrlKey) {
                options.forEach(function(element) {
                    if (element.label === value) {
                        element.selected = selected === "true" ? false : true;
                    }
                });
            } else {
                options.forEach(function(element) {
                    if (element.label === value) {
                        element.selected = selected === "true" ? false : true;
                    } else {
                        //element.selected = false;
                    }
                });
                var mainDiv = component.find('main-div');
                //$A.util.removeClass(mainDiv, 'slds-is-open');
            }
            component.set("v.loboption", options);
        }   
        
    },
    handleCountEvent: function(component, event, helper) 
    {
        var checked = event.getParam("count");
        var selectedcount = component.get("v.selectedcount");
        if (checked == true)
        {
            selectedcount = selectedcount +1;
        }
        if (checked == false && selectedcount > 0)
        {
            selectedcount = selectedcount -1;
        }
        component.set("v.selectedcount",selectedcount);
    },
    handleRebateEvent: function(component, event, helper) 
    {
        var rebate = event.getParam("rebate");
        var selectedcount = component.get("v.selectedcount");
        component.set("v.rebate",rebate);
        if (rebate != null)
        var len = rebate.length;
        else
        var len = 0;

        if (len != 0 && len == selectedcount)
        {
            event.stopPropagation();
            var action = component.get("c.save_mlobrebate");
            action.setParams({
            "baseali" : component.get("{!v.ali}"),
            "addali" : component.get("v.additionalaliid"),
            "selectedrec" : component.get("{!v.rebate}")});
              action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") 
                 {
                  var saveChange = $A.get("e.c:Apttus_Grid_Add_MLOB_Save_Event");
                  saveChange.fire();
                  var toastEvent = $A.get("e.force:showToast");
    			  toastEvent.setParams({
                  "title": "Success!",
                  "type":"success",
                  "mode": "pester",
                  "message": "Rebate Guarantees added Successfully."
                                      });
    			  toastEvent.fire(); 
                     
                 }
            else {
                  var toastEvent = $A.get("e.force:showToast");
    			  toastEvent.setParams({
                  "title": "Error!",
                  "type":"error",
                  "mode": "pester",
                  "message": "Problem in addition of Rebate Guarantees."
                                      });
    			  toastEvent.fire(); 
                 }
                });
                $A.enqueueAction(action);  
            
            
            
        }
        
    },
})