({
    doInit : function(component, event, helper) 
    {  
        component.set("v.DisplaySpinner",false);
        //component.set("{!v.lob}",component.get("{!v.objects.LOB__c}"));
        helper.retrievemlob(component, event, helper);
        helper.retrievelob(component, event, helper); 
    },
     onChange : function(component, event, helper) {
		helper.loadTabs(component, event, helper);
	},
    checkAll: function(component, event, helper) {
           var master=event.getSource().get("v.name");
           var selectedHeaderCheck = event.getSource().get("v.value");
           var boxPack = component.find("dependent");
           if (!Array.isArray(boxPack)) {
           boxPack = [boxPack];
           }
           for (var i = 0; i < boxPack.length; i++) {
                if(component.find("dependent")[i].get("v.name")==master){
                boxPack[i].set("v.value",selectedHeaderCheck);
                console.log('boxPack'+boxPack[i].get("v.text"));
              
                }
           }
    },
      checkAll1: function(component, event, helper) {
           var master=event.getSource().get("v.name");
          console.log('master199#'+master);
           var selectedHeaderCheck = event.getSource().get("v.value");
		   console.log("selectedHeaderCheck"+selectedHeaderCheck);
           var boxPack = component.find("dependent1");
           if (!Array.isArray(boxPack)) {
               boxPack.set('v.value', selectedHeaderCheck);
           } else {
          boxPack.forEach(function(cb) {
              cb.set('v.value', selectedHeaderCheck);
          });
           }

         
    },
     checkAll2: function(component, event, helper) {
           var master=event.getSource().get("v.name");
          console.log('master199#'+master);
           var selectedHeaderCheck = event.getSource().get("v.value");
		   console.log("selectedHeaderCheck"+selectedHeaderCheck);
           var boxPack = component.find("dependent2");
           if (!Array.isArray(boxPack)) {
               boxPack.set('v.value', selectedHeaderCheck);
           } else {
          boxPack.forEach(function(cb) {
              cb.set('v.value', selectedHeaderCheck);
          });
         }
    },
    handleSelectCheckBox : function(component, event, helper) {
		console.log('Checked ID'+event.getSource().get("v.text"));
	},
  
     handleSelectAllChange: function(component,event, helper) {
     if(component.get('v.isAllSelected') == false) {
              component.set('v.isAllSelected', true);
      }
        const checkbox = component.find('checkbox'); 
        let chk = (checkbox.length == null) ? [checkbox] : checkbox;
        chk.forEach(checkbox => checkbox.set('v.checked', component.get('v.isAllSelected')));
      },
       //Drop Down Changes 
   handleMouseLeave: function(component, event, helper)  {
        component.set("v.dropdownOver", false);
        var mainDiv = component.find('main-div');
        $A.util.removeClass(mainDiv, 'slds-is-open');
    },
     handleLOBChange : function(component, event, helper) {
		helper.processAddLobLogic(component, event, helper);
	},
    
    handleMouseEnter: function(component, event, helper)  {
        component.set("v.dropdownOver", true);
    }, 
    
    handleMouseOutButton: function(component, event, helper) {
        var options = component.get("v.loboption");
        component.set("v.mlobcreation", component.get("v.mlobcreation"));
        var lobid = component.get("v.mlobcreation");
        var selection = false;
        options.forEach(
            function(element) {
                if (element.selected == true)  {
                    lobid.push(element.value);
                    selection = true;
                }
            }
        );
        
        if (selection == true) {
            component.set("v.mlobcreation",lobid);
            helper.createmlob(component, event, helper);
        }
        window.setTimeout(
            $A.getCallback(function() {
                if (component.isValid()) {
                    //if dropdown over, user has hovered over the dropdown, so don't close.
                    if (component.get("v.dropdownOver"))  {
                        return;
                    }
                    var mainDiv = component.find('main-div');
                    $A.util.removeClass(mainDiv, 'slds-is-open');
                }
            }), 200
        );
        
    },
    handleClick : function(component, event, helper)  {
        var mainDiv = component.find('main-div');
        $A.util.addClass(mainDiv, 'slds-is-open');
    },
    handleSelection: function(component, event, helper)  {
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
     
 })