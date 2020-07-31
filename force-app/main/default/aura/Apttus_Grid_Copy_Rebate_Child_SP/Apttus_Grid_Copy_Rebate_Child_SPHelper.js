({
    fetchpicklistvalue : function(component, helper) {
        
        var action = component.get("c.findPicklistOptions");
        action.setParams({
            "objAPIName":  "Rebate_Guarantees__c",
            "fieldAPIname": "Plan_Design__c"
        })
        action.setCallback(this, $A.getCallback(function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.Plandesign", response.getReturnValue());
            } else {
                helper.counselLogErrors(response.getError());
            }
        }));
        $A.enqueueAction(action);
        
        var action = component.get("c.findPicklistOptions");
        action.setParams({
            "objAPIName":  "Rebate_Guarantees__c",
            "fieldAPIname": "GSTP__c"
        })
        action.setCallback(this, $A.getCallback(function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.GstpOption", response.getReturnValue());
            } else {
                helper.counselLogErrors(response.getError());
            }
        }));
        $A.enqueueAction(action);
        
        var action = component.get("c.findPicklistOptions");
        action.setParams({
            "objAPIName":  "Rebate_Guarantees__c",
            "fieldAPIname": "Non_Specialty_Formulary_2__c"
        })
        action.setCallback(this, $A.getCallback(function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.NonSpec", response.getReturnValue());
            } else {
                helper.counselLogErrors(response.getError());
            }
        }));
        $A.enqueueAction(action);
        
        var action = component.get("c.findPicklistOptions");
        action.setParams({
            "objAPIName":  "Rebate_Guarantees__c",
            "fieldAPIname": "Specialty_Formulary__c"
        })
        action.setCallback(this, $A.getCallback(function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.Spec", response.getReturnValue());
            } else {
                helper.counselLogErrors(response.getError());
            }
        }));
        $A.enqueueAction(action);
        
        var action = component.get("c.findPicklistOptions");
        action.setParams({
            "objAPIName":"Rebate_Guarantees__c",
            "fieldAPIname":"Basis__c"
        });
        action.setCallback(this, $A.getCallback(function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.ntypeoptions", response.getReturnValue());
                console.log('response.getReturnValue()'+response.getReturnValue());
            } else {
                console.log('eror'+response.getError());
            }
        }));
        $A.enqueueAction(action);
    },
    handleValidateHelper:function(component, event, helper){
        //alert('spec handleSaveNew');
        //var isMatchToSave = event.getParam("isMatchToSave");
        var isError = false;
        var percentageCheck = component.get("v.percentageCheck");

        if(component.get("v.display") == true) {
            var Req1 = 0; var Req2 = 0; var Req3 = 0; var Req4 = 0; var Req5 = 0;var Req6=0; 
            var messagestr;
            var inputcmp1 = component.find("inputYear");
            var value;
           
            var inputcmp5 = component.find("inputSpecForm");
            var value5;
            if(inputcmp5 != undefined)
                value5 = inputcmp5.get("v.value");
            if((value5 == undefined || value5 == null || value5 =="")) { 
                Req2 =1;  
                $A.util.addClass(inputcmp5, "slds-has-error");
                if (messagestr== null)
                    messagestr = 'Specialty Formulary: Required Field. \n';
                else {
                    messagestr += 'Specialty Formulary: Required Field. \n';
                }
            } else {
                $A.util.removeClass(inputcmp5, "slds-has-error");
            }
            //Changes Done By Mohit Srivastava for the Custom description.
            var inputcmp15 = component.find("inputSpecialtyDisplayName");
            var value5;
            if(inputcmp15 != undefined)
                value5 = inputcmp15.get("v.value");
            if((value5 == undefined || value5 == null || value5 =="")) { 
                Req6=1;  
                $A.util.addClass(inputcmp15, "slds-has-error");
                if (messagestr== null)
                    messagestr = 'Specialty Formulary Display Name: Required Field. \n';
                else {
                    messagestr += 'Specialty Formulary Display Name: Required Field. \n';
                }
            } else {
                $A.util.removeClass(inputcmp15, "slds-has-error");
            }
            
            
            if(component.get("v.percentageCheck")==true){
                var inputcmp6 = component.find("inputSpecialtyPer");
                var value6;
                if(inputcmp6 != undefined)
                    value6 = inputcmp6.get("v.value");
                if((value6 == undefined || value6 == null || value6 =="")) { 
                    Req4 =1;  
                    $A.util.addClass(inputcmp6, "slds-has-error");
                    if (messagestr== null)
                        messagestr = 'Specialty(%): Required Field. \n';
                    else {
                        messagestr += 'Specialty(%): Required Field. \n';
                    }
                    isError = true;
                } else {
                    $A.util.removeClass(inputcmp6, "slds-has-error");
                }
            } else if(component.get("v.percentageCheck")==false){
                
                var inputcmp9 = component.find("inputSpecialtyDol");
                var value9;
                if(inputcmp9 != undefined)
                    value9 = inputcmp9.get("v.value");
                if((value9 == undefined || value9 == null || value9 =="")) {
                    Req5 =1; 
                    $A.util.addClass(inputcmp9, "slds-has-error");
                    if (messagestr== null)
                        messagestr = 'Specialty $: Required Field. \n';
                    else {
                        messagestr += 'Specialty $: Required Field. \n';
                    }
                    isError = true;
                } else {
                    $A.util.removeClass(inputcmp9, "slds-has-error");
                }
            }                
                
            
            if (Req2 == 1 ||Req6==1|| isError == true) {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "mode": 'sticky',
                    "type": 'error',
                    "title": "Error!",
                    "message": messagestr
                });
                toastEvent.fire();
            } 
            
            if(Req2 == 0 && Req6==0  && isError == false){
                //alert('sp validation complete');
                var appEventS = $A.get("e.c:Apttus_Grid_NT_Notify_Save_Event");
                appEventS.setParams({ 
                    "SaveRec" : true,
                    "Section" : component.get("v.planDesignOption"),
                    "isSavedAndClose" : component.get("v.isSavedAndClose")
                });
                appEventS.fire();        
            }
    	}
    },
    handleSaveNewHelper:function(component, event, helper){
        if(component.get("v.display") == true){
            var appEventS = $A.get("e.c:Apttus_Grid_Copy_Complete_Event");
            appEventS.setParams({ 
                "SaveRec" : true,
                "Section" : component.get("v.planDesignOption"),
                "isSavedAndClose" : component.get("v.isSavedAndClose")
            });
            appEventS.fire();          
        }
    },
})