({
    doInit : function(component, event, helper) {
        var myAttribute = component.get("v.pbmQuestAnsItem.PBM_Question__c");
        var action = component.get("c.getQuestion");
        action.setParams({ "myIdParam" : myAttribute });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.pbmQestItem", response.getReturnValue());
                var getDataType = component.get("v.pbmQestItem.Data_Type__c");
                var getFieldNm = component.get("v.pbmQestItem.Field_API__c");
                var getdisabled = component.get("v.pbmQestItem.Disabled__c");
                //alert(getFieldNm + '=====' + getdisabled);
                //alert(response.getReturnValue());
                component.set("v.getDisabled", getdisabled);
                if(component.get("v.pbmQestItem.Object_API__c") == "Account"){
                    component.set("v.disabledInput2", "true");
                }
                
                if(getDataType == "Text"){
                    component.set("v.isText", "true");
                }else if (getDataType == "Date"){
                    component.set("v.isDate", "true");
                }else if (getDataType == "Picklist"){
                    component.set("v.isPicklist", "true");
                }else if (getDataType == "Number"){
                    if(getFieldNm=="Client_Share__c"){
                        component.set("v.isClientShareField", "true");
                    }
                }else if(getDataType == "Lookup"){
                    component.set("v.isLookup", "true");
                }
                
                // Generate picklist values from Apex
                var action2 = component.get("c.getPicklistOptions");
                var myParamFieldNm = component.get("v.pbmQestItem.Field_API__c");
                var myParamObjNm = component.get("v.pbmQestItem.Object_API__c");
                //alert(myParamFieldNm);
                //alert(myParamObjNm);
                action2.setParams({ "fieldName" : myParamFieldNm,
                                 "sObjectName": myParamObjNm});
                
                action2.setCallback(this, function(response){
                    var state = response.getState();
                    if (component.isValid() && state === "SUCCESS") {
                        component.set("v.PickVal", response.getReturnValue());
                        
                    }else if(state === "ERROR"){
                        var errors = response.getError();
                        if (errors) {
                            if (errors[0] && errors[0].message) {
                                console.log("Error message: " + 
                                            errors[0].message);
                            }
                        }else{
                            console.log("Unknown error");
                        }
                    }
                });
                $A.enqueueAction(action2);
               
            }
        });
	 	$A.enqueueAction(action);
        
    },
	handleChange : function(component, event, helper) {
		var questcmpEvent = component.getEvent("questcmpEvent");
        var idNameConcat = event.getSource().get('v.name');
        var qAnsVar = event.getSource().get('v.value');
        var arrayIdNm = idNameConcat.split("-",2);
        var qIdVar = arrayIdNm[0];
        var qFieldNmVar = arrayIdNm[1];
        var isDisable = false;
        var isValid = true;
        var disableFieldNm = null;
        //alert(qIdVar2);
        //
        var inputField = event.getSource();
        
        if(qFieldNmVar == 'Client_Share__c'){
            //alert(qFieldNmVar);
            //var value = inputField.get('v.value');
            //var value = inputField.get('v.value');
            if(qAnsVar > 100) {
                //alert('testing');
                //inputField.set('v.validity', {valid:false, badInput :true});
                //inputField.showHelpMessageIfInvalid();
                inputField.setCustomValidity('Client Share Value should be between 0 to 100');
                isValid = false;    
            }else{
               inputField.setCustomValidity(''); 
            } 
            inputField.reportValidity();
        }else if (qFieldNmVar == 'Pharmacy_Audit_Retention__c'){
            if(qAnsVar != 'Base (Custom)' && qAnsVar != 'Premier (Custom)' ){
                //alert('idisabled');
                
                component.set("v.isClientShareField", "false");
                //alert(component.get("v.isClientShareField"));
                //component.find("Client_Share__c").set("v.disabled", "true");
                isDisable = true;
            }
            disableFieldNm = "Client_Share__c";
        }
        
        
        questcmpEvent.setParams({
            "qId": qIdVar,
            "qAns": qAnsVar,
            "qFieldNm": qFieldNmVar ,
            "qdisableFieldNm": disableFieldNm,
            "qisValid": isValid,
            "qdisable": isDisable });
        questcmpEvent.fire();
        
	},
    handleValueChange : function(component, event, helper) {
        //alert(component.get("v.selectedId"));
        var questcmpEvent = component.getEvent("questcmpEvent");
        questcmpEvent.setParams({
            "qId": component.get("v.pbmQuestAnsItem.PBM_Question__c"),
            "qAns": component.get("v.selectedId"),
            "qFieldNm": component.get("v.pbmQestItem.Field_API__c") ,
            "qdisableFieldNm": null,
            "qisValid": true,
            "qdisable": false });
        questcmpEvent.fire();
    }
})