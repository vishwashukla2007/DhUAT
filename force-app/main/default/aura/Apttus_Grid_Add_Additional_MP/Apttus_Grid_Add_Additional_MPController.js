({
	doInit : function(component, event, helper) {
       helper.retrievemlob(component, event, helper);
	},
    onChange : function(component, event, helper) {
    	console.log("@@@@@@@@@@");
        var tabId = component.get("v.selTabId");
        helper.retrieveSelectedlob(component, tabId);
   	},
    handleSelectCheckBox : function(component, event, helper) {
		console.log("$$$$$$$$$");
        var val = event.getSource().get("v.name");
        var isChcekd = event.getSource().get("v.value");
        var checkedIds = component.get('v.selectedIds');
        if(isChcekd){
        	checkedIds.push(val);
        }else{
            var valI = checkedIds.indexOf(val);
            if (valI > -1) checkedIds.splice(valI, 1);
        }
        component.set('v.selectedIds', checkedIds);
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
    selectAll : function(component, event, helper){
        var checkState = event.getSource().get("v.value");
        var allRecs = component.get("v.lstMPObj");
        var allIds = [];
        allRecs.forEach((o) => { 
            o.isChecked = checkState;
            allIds.push(o.Id);
        });
        if(checkState){
        	component.set('v.selectedIds', allIds);
        }else{
            component.set('v.selectedIds', []);
        }
		component.set("v.lstMPObj", allRecs);                                
    },
    saveAction : function(component, event, helper) {
        console.log('!!!!!!!!');
        helper.updateMailDenorm(component, event, helper);
    }        
})