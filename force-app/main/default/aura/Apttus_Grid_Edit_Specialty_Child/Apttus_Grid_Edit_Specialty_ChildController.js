({
    doInit : function(component, event, helper) {
        console.log("Percentage check1111"+component.get("v.percentageCheck"));
        //alert("Percentage check1111"+component.get("v.percentageCheck"));
        var yr = [];
        for (var i = 0; i < component.get("v.yearcount"); i++)  {
            var j = i+1;
            yr.push({value: j});
        }
        yr.push({
            value: 'All'
        });
        component.set("{!v.yearoptions}", yr);
        helper.fetchpicklistvalue(component, helper);
        component.set("v.basis",component.get("v.objects.Basis__c"));
        component.set("v.desc",component.get("v.objects.Specialty_Display_Name__c"));

    },
    handledelete : function(component, event, helper) {
        var cmpTarget = component.find("tablerow");
        $A.util.addClass(cmpTarget, "slds-has-error");
        component.set("{!v.isDeleteAlertOpen}", true);
    },
    closeDeleteAlert : function(component, event, helper) {
        var cmpTarget = component.find("tablerow");
        $A.util.removeClass(cmpTarget, "slds-has-error");
        component.set("{!v.isDeleteAlertOpen}", false);
    },
    handleupdate : function(component, event, helper) {
        component.set("{!v.lob}", event.getParam("lob"));
        component.set("{!v.objects.LOB2__c}",component.get("{!v.lob}"));
        
    },
    handleChange : function(component, event, helper) {
        var inputcmp1 = component.find("inputYear");
        if(inputcmp1 != undefined){
            var value = inputcmp1.get("v.value");
            component.set("{!v.objects.Year__c}",value);
        }
        var inputcmp2 = component.find("inputSpecForm");
        if(inputcmp2 != undefined){
            var value = inputcmp2.get("v.value");
            component.set("{!v.objects.Specialty_Formulary__c}",value);
        }
        var inputcmp3 = component.find("inputBasis");
        if(inputcmp3 != undefined){
            var value = inputcmp3.get("v.value");
            component.set("{!v.objects.Basis__c}",value);
        }
    },
    deleteSelectedRec : function(component, event, helper) {
        component.set("{!v.isDeleteAlertOpen}", false);
        if (component.get("{!v.objects.Id}") == null || component.get("{!v.objects.Id}") == 'undefined') {
            component.set("{!v.display}", false);
            
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                title : 'Success Message',
                message: 'Selected record(s) were deleted.',
                type: 'success',
                mode: 'pester'
            });
            toastEvent.fire();
            //var appEventD = $A.get("e.c:Apttus_Grid_Delete_RG_RowEvent");
            //appEventD.fire();
            //alert('currentIndex--------------'+component.get("v.currentIndex"));
            var appEvent1 = $A.get("e.c:Apttus_Grid_Delete_RG_RowEvent"); 
            appEvent1.setParams({ 
                "isDeleteSuccess" : true,
                "section" : component.get("v.planDesignOption"),
                "delIndex" : component.get("v.currentIndex"),
                "delObjId" : null
            });
            appEvent1.fire();
        }
        if (component.get("{!v.objects.Id}") != null && component.get("{!v.objects.Id}") != 'undefined') {
            //var appEvent = $A.get("e.c:Apttus_Grid_Inactive_Parent_Event");
            //appEvent.fire();
            helper.deleteSelectedRecords(component,event,helper);
        }
    },
    handleSaveNew:function(component, event, helper){
        //alert('spec handleSaveNew');
        var isMatchToSave = event.getParam("isMatchToSave");
        component.set("v.isSavedAndClose",event.getParam("isSavedAndClose"));
        var isError = false;
        var percentageCheck = component.get("v.percentageCheck");
        
        if(isMatchToSave != undefined && isMatchToSave == true){
            var appEventS = $A.get("e.c:Apttus_Grid_NT_Notify_Save_Event");
            appEventS.setParams({ 
                "SaveRec" : true,
                "Section" : component.get("v.planDesignOption"),
                "isMatchToSave" : isMatchToSave,
                "isSavedAndClose" : component.get("v.isSavedAndClose")
            });
            appEventS.fire(); 
        } else {
            if(component.get("v.display") == true) {
                var Req1 = 0; var Req2 = 0; var Req3 = 0; var Req4 = 0; var Req5 = 0;var Req6 = 0; 
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
                
                
                if (Req2 == 1 || Req6 == 1 || isError == true) {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "mode": 'sticky',
                        "type": 'error',
                        "title": "Error!",
                        "message": messagestr
                    });
                    toastEvent.fire();
                } 
                
                if(Req2 == 0 && Req6== 0  && isError == false){
                    var cmpTarget = component.find("tablerow");
                    $A.util.removeClass(cmpTarget, "slds-has-error");
                    component.set("v.duplicaterow","0"); 
                    
                    var appEventS = $A.get("e.c:Apttus_Grid_NT_Notify_Save_Event");
                    appEventS.setParams({ 
                        "SaveRec" : true,
                        "Section" : component.get("v.planDesignOption"),
                        "isMatchToSave" : isMatchToSave,
                        "isSavedAndClose" : component.get("v.isSavedAndClose")
                    });
                    appEventS.fire();   
                    /*if (component.get("{!v.objects.Id}") == null || component.get("{!v.objects.Id}") == 'undefined') {
                        //alert('specialty id  null');
                        var appEventS = $A.get("e.c:Apttus_Grid_NT_Notify_Save_Event");
                        appEventS.setParams({ 
                            "SaveRec" : true,
                            "Section" : component.get("v.planDesignOption"),
                            "isMatchToSave" : isMatchToSave
                        });
                        appEventS.fire();  
                    } else {
                        //alert('specialty id  save');
                        component.set("v.DisplaySpinner",true);
                        var actionS = component.get("c.saveRGs");
                        actionS.setParams({
                            "isSpec" : true,
                            "rg":component.get("{!v.objects}"),
                            "isPer" : component.get("v.percentageCheck")
                        });
                        actionS.setCallback(this, $A.getCallback(function(response) {
                            var state = response.getState();
                            //alert('state---'+state + '--' + component.get("v.planDesignOption"));
                            if (state === "SUCCESS") {
                                component.set("{!v.DisplaySpinner}", false);
                                var cmpTarget = component.find("tablerow");
                                $A.util.removeClass(cmpTarget, "slds-has-error");
                                component.set("v.duplicaterow","0"); 
                                
                                var appEventS = $A.get("e.c:Apttus_Grid_NT_Notify_Save_Event");
                                appEventS.setParams({ 
                                    "SaveRec" : true,
                                    "Section" : component.get("v.planDesignOption"),
                                    "isMatchToSave" : isMatchToSave
                                });
                                appEventS.fire();                    
                            } else if (state === "ERROR") {
                                var cmpTarget = component.find("tablerow");
                                $A.util.addClass(cmpTarget, "slds-has-error");
                                
                                var errors = response.getError();
                                var message;
                                if (errors) {
                                    if(errors[0] && errors[0].message) {
                                        message = "Error message: " + errors[0].message; 
                                    }
                                }  else {
                                    message = "Error in Updating Rebate Pricing Information";
                                }   
                                component.set("{!v.DisplaySpinner}", false);
                                //helper.cancleDeleteAlertHelper(component,event,helper);
                                var toastEvent = $A.get("e.force:showToast");
                                toastEvent.setParams({
                                    "mode": 'sticky',
                                    "type": 'error',
                                    "title": "Error!",
                                    "message": message
                                });
                                toastEvent.fire();
                            }
                        }));
                        $A.enqueueAction(actionS);
                    }*/
                }
            }
        }
    },
    
})