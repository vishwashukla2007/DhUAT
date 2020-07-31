({
    retrievemlob: function(component, event, helper) {
        var action = component.get("c.get_AdditionalLOB");
        action.setParams({
            "Basealiid" : component.get("{!v.ali}")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("{!v.lstmultplelob}",response.getReturnValue());
                var loblist = response.getReturnValue();
                var data = component.get("v.lstmultplelob");
                var itemcount = data.length;
                component.set("v.LOBcount", itemcount);
                var selectedtabId = component.get("v.selectedtabId");
                var selectedLOB = component.get("v.selectedLOB"); 
                
                for(var lob in loblist)  {
                    if (loblist[lob].Additional_LOB_Numeric_ID__c == '1') {
                        component.set("v.lob1visible", true);
                        component.set("v.lob1", loblist[lob]);
                        if(selectedtabId){}else{
                            selectedtabId = "LOB1";
                            selectedLOB = loblist[lob];
                        }
                    }
                    if (loblist[lob].Additional_LOB_Numeric_ID__c == '2') {
                        component.set("v.lob2visible", true);
                        component.set("v.lob2", loblist[lob]);
                        if(selectedtabId){}else{
                            selectedtabId = "LOB2";
                            selectedLOB = loblist[lob];
                        }
                    }
                    if (loblist[lob].Additional_LOB_Numeric_ID__c == '3') {
                        component.set("v.lob3visible", true);
                        component.set("v.lob3", loblist[lob]);
                        if(selectedtabId){}else{
                            selectedtabId = "LOB3";
                            selectedLOB = loblist[lob];
                        }
                    }
                    if (loblist[lob].Additional_LOB_Numeric_ID__c == '4') {
                        component.set("v.lob4visible", true);
                        component.set("v.lob4", loblist[lob]);
                        if(selectedtabId){}else{
                            selectedtabId = "LOB4";
                            selectedLOB = loblist[lob];
                        }
                    }
                    if (loblist[lob].Additional_LOB_Numeric_ID__c == '5') {
                        component.set("v.lob5visible", true);
                        component.set("v.lob5", loblist[lob]);
                        if(selectedtabId){}else{
                            selectedtabId = "LOB5";
                            selectedLOB = loblist[lob];
                        }
                    }
                    if (loblist[lob].Additional_LOB_Numeric_ID__c == '6') {
                        component.set("v.lob6visible", true);
                        component.set("v.lob6", loblist[lob]);
                        if(selectedtabId){}else{
                            selectedtabId = "LOB6";
                            selectedLOB = loblist[lob];
                        }
                    }
                }
                if(selectedtabId){
                    component.set("v.selectedtabId", selectedtabId);
                }
                if(selectedLOB){ 
                    component.set("v.selectedLOB", selectedLOB);
                    component.set("v.baseLobId", selectedLOB.Base_LOB__c);
                    component.set("v.basefafId", selectedLOB.Base_FAF_ID__c);
                    component.set("v.baselobDesId", selectedLOB.Base_LOB__r.LOB_Description__c);
                }
                
                
                
                helper.loadData(component, event, helper);
            } else {
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
    },
    loadTabs: function (component, event, helper) {
        var tab = event.getSource();
        var lob;
        switch (tab.get('v.id')) {
            case 'LOB1' :
                lob = component.get("v.lob1");
                break;
            case 'LOB2' :
                lob = component.get("v.lob2");
                break;
            case 'LOB3' :
                lob = component.get("v.lob3");
                break;
            case 'LOB4' :
                lob = component.get("v.lob4");
                break;
            case 'LOB5' :
                lob = component.get("v.lob5");
                break;
            case 'LOB6' :
                lob = component.get("v.lob6");
                break;
        }
        component.set("v.selectedtabId", tab.get('v.id'));
        component.set("v.selectedLOB", lob);
        helper.loadData(component, event, helper);
    },
    loadData: function (component, event, helper) {
        var selectedLOB = component.get("v.selectedLOB");
        
        if(selectedLOB && selectedLOB.Additional_FAF_ID__c){
            //alert(selectedLOB.Additional_FAF_ID__c);
            var action = component.get("c.get_NetworkWrapperList");
            action.setParams({
                "fafId" : selectedLOB.Additional_FAF_ID__c
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    component.set("{!v.norecord}",false);
                    var count = response.getReturnValue();
                    var itemcount = count.length;
                    if (itemcount == 0) {
                        component.set("{!v.norecord}",true);
                    }
                    component.set("{!v.wrapperList}",response.getReturnValue());
                }
            });
            $A.enqueueAction(action);  
        }
    },
    retrievelob: function(component, event, helper) {
        var action = component.get("c.get_AddToLOB");
        action.setParams({
            "Basealiid" : component.get("{!v.ali}")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("{!v.lobList}",response.getReturnValue());
            }
        });
        $A.enqueueAction(action);  
        
        var action1 = component.get("c.get_allLOB");
        action1.setParams({
            "Basealiid" : component.get("{!v.ali}")
        });
        action1.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS")  {
                var loblist = response.getReturnValue();
                var data = component.get("v.lstmultplelob");
                var itemcount = data.length;
                component.set("v.loboption",component.get("v.loboptiondefault")); 
                for(var lob in loblist)  {
                    
                    if (loblist[lob].LobId__c == '1')  {
                        if ((loblist[lob].FAF_Agreement_Line_Item__c != component.get("{!v.ali}")) && component.get("v.lob1visible") != true) {
                            var loboption = component.get("v.loboption");
                            var lob1desc = {'label' :'LOB 1 - ' + loblist[lob].LOB_Description__c,'value': loblist[lob].Id,'selected':''};
                            loboption.push(lob1desc);
                            component.set("v.loboption",loboption);
                        }
                    }
                    if (loblist[lob].LobId__c == '2')  {
                        if ((loblist[lob].FAF_Agreement_Line_Item__c != component.get("{!v.ali}")) && component.get("v.lob2visible") != true){  
                            var loboption = component.get("v.loboption");
                            var lob2desc = {'label' :'LOB 2 - ' + loblist[lob].LOB_Description__c,'value': loblist[lob].Id,'selected':''};
                            loboption.push(lob2desc);
                            component.set("v.loboption",loboption);
                        }
                    }
                    if (loblist[lob].LobId__c == '3') {
                        if ((loblist[lob].FAF_Agreement_Line_Item__c != component.get("{!v.ali}")) && component.get("v.lob3visible") != true) {
                            var loboption = component.get("v.loboption");
                            var lob3desc = {'label' :'LOB 3 - ' + loblist[lob].LOB_Description__c,'value': loblist[lob].Id,'selected':''};
                            loboption.push(lob3desc);
                            component.set("v.loboption",loboption);
                        }
                    }
                    if (loblist[lob].LobId__c == '4')  {
                        if ((loblist[lob].FAF_Agreement_Line_Item__c != component.get("{!v.ali}")) && component.get("v.lob4visible") != true) {
                            var loboption = component.get("v.loboption");
                            var lob4desc = {'label' :'LOB 4 - ' + loblist[lob].LOB_Description__c,'value': loblist[lob].Id,'selected':''};
                            loboption.push(lob4desc);
                            component.set("v.loboption",loboption);
                        }
                    }
                    if (loblist[lob].LobId__c == '5')  {
                        if ((loblist[lob].FAF_Agreement_Line_Item__c != component.get("{!v.ali}")) && component.get("v.lob5visible") != true) {
                            var loboption = component.get("v.loboption");
                            var lob5desc = {'label' :'LOB 5 - ' + loblist[lob].LOB_Description__c,'value': loblist[lob].Id,'selected':''};
                            loboption.push(lob5desc);
                            component.set("v.loboption",loboption);
                        }
                    }
                    if (loblist[lob].LobId__c == '6')  {
                        if ((loblist[lob].FAF_Agreement_Line_Item__c != component.get("{!v.ali}")) && component.get("v.lob6visible") != true) {
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
            } else {
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
        $A.enqueueAction(action1);  
    },
    createmlob: function(component, event, helper){
        var action = component.get("c.create_mlob");
        action.setParams({
            "Basealiid" : component.get("{!v.ali}"),
            "mlob" : component.get("{!v.mlobcreation}")});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var selectedLOB = response.getReturnValue();
                var selectedtabId = 'LOB' + selectedLOB.Additional_LOB_Numeric_ID__c;
                
                if(selectedtabId){
                    component.set("v.selectedtabId", selectedtabId);
                }
                if(selectedLOB){ 
                    component.set("v.selectedLOB", selectedLOB);
                    component.set("v.baseLobId", selectedLOB.Base_LOB__c);
                    component.set("v.basefafId", selectedLOB.Base_FAF_ID__c);
                    component.set("v.baselobDesId", selectedLOB.Base_LOB__r.LOB_Description__c);
                }
                helper.retrievemlob(component, event, helper);  
                helper.retrievelob(component, event, helper);
            } else {
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
    saveButtonHelper : function(component, event, helper) {
		var wrapperList = component.get("v.wrapperList");
        console.log('wrapperList.length    == ' +wrapperList.length );
        var selectedNpIds = [];
        
        for(var i=0  ; i < wrapperList.length ; i++){
            if(wrapperList[i] && wrapperList[i].npList){
                for(var j=0 ; j < wrapperList[i].npList.length ; j++){
                    console.log('wrapperList[i].npList[j].isSelected   == ' +wrapperList[i].npList[j].isSelected);
                    if(wrapperList[i].npList[j].isSelected == true){
                        selectedNpIds.push(wrapperList[i].npList[j].np.Id);
                    }
                }
            }
        }
	},
})