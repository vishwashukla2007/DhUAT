({
	doInit : function(component, event, helper)  {
		helper.retrievemlob(component, event, helper); 
		helper.retrievelob(component, event, helper); 
	},
    onChange : function(component, event, helper) {
		helper.loadTabs(component, event, helper);
	},
    handleSelectCheckBox : function(component, event, helper) {
		
	},
    handleSaveButton : function(component, event, helper) {
		helper.saveButtonHelper(component, event, helper);
	},
    handleSelectAll : function(component, event, helper) {
		var selectedGrid = event.getSource().get("v.text");   
        var checkboxVale = event.getSource().get('v.value');
        console.log('selectedGrid   '+selectedGrid);
        console.log('yyyyyyy      '+ checkboxVale);
        var wrapperList = component.get("v.wrapperList");
        console.log('wrapperList.length    == ' +wrapperList.length );
        for(var i=0  ; i < wrapperList.length ; i++){
            console.log('wrapperList[i].networkName   == ' +wrapperList[i].networkName);
            console.log('selectedGrid   == ' +selectedGrid);
            if(wrapperList[i] && wrapperList[i].networkName == selectedGrid && wrapperList[i].npList){
                for(var j=0 ; j < wrapperList[i].npList.length ; j++){
                    console.log('wrapperList[i].npList[j].isSelected   == ' +wrapperList[i].npList[j].isSelected);
                    wrapperList[i].npList[j].isSelected = checkboxVale;
                }
                break;
            }
        }
        component.set("v.wrapperList", wrapperList);
       
    },
    
    handleMouseLeave: function(component, event, helper)  {
        component.set("v.dropdownOver", false);
        var mainDiv = component.find('main-div');
        $A.util.removeClass(mainDiv, 'slds-is-open');
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
            }
            component.set("v.loboption", options);
        }   
    },
})