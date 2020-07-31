({
    doInit : function(component, event, helper) {
        
        var yr = [];
        for (var i = 0; i < component.get("v.yearcount"); i++)  {
            var j = i+1;
            yr.push({value: j});
        }
        yr.push({  value: 'All' });
        component.set("{!v.yearoptions}", yr);
        helper.fetchpicklistvalue(component, helper);
        component.set("{!v.objects.Custom_Description__c}",component.get("v.desc"));
        
    },
    handleChange : function(component, event, helper) {
        
        var inputcmp1 = component.find("input1");
        var value = inputcmp1.get("v.value");
        component.set("{!v.objects.Year__c}",value);
        
        var inputcmp3 = component.find("input3");
        var value = inputcmp3.get("v.value");
        component.set("{!v.objects.Clinical_Solution_Type__c}",value);
        
        var inputcmp4 = component.find("input4");     
        var value = inputcmp4.get("v.value");
        component.set("{!v.objects.Clinical_Solution__c}",value);
        
        var inputcmp5 = component.find("input5");
        var value = inputcmp5.get("v.value");
        component.set("{!v.objects.Opt_In_Out__c}",value);
        
        var inputcmp6 = component.find("input6");
        var value = inputcmp6.get("v.value");
        component.set("{!v.objects.Contingent__c}",value);
        
        var inputcmp7 = component.find("input7");
        var value = inputcmp7.get("v.value");
        component.set("{!v.objects.Fee_Basis__c}",value);
        
        var inputcmp8 = component.find("input8");
        var value = inputcmp8.get("v.value");
        component.set("{!v.objects.Fee_Amount__c}",value);
    },
    handleSave : function(component, event, helper) {
        
        if(component.get("v.display") == true) {  
            
            var Req1 = 0;
            var Req2 = 0;
            var Req3 = 0;
            var Req4 = 0;
            var Req5 = 0;
            var Req6 = 0;
            var Req7 = 0;
            var Req9 = 0;
            var messagestr;
            var inputcmp1 = component.find("input1");
            var value = inputcmp1.get("v.value");
            if(value == null || value =="") {
                messagestr = 'Year: Required Field. \n ';
                Req5 =1;       
                $A.util.addClass(inputcmp1, "slds-has-error");
            }
            
            var inputcmp3 = component.find("input3");
            var value3 = inputcmp3.get("v.value");
            if(value3 == null || value3 =="")  {
                $A.util.addClass(inputcmp3, "slds-has-error");
                if (messagestr== null)
                    messagestr = 'Clinical Solution Type: Required Field. \n';
                else {
                    messagestr += 'Clinical Solution Type: Required Field. \n';
                }
                Req2 =1;  
            }
            
            var inputcmp4 = component.find("input4");
            var value4 = inputcmp4.get("v.value");
            if(value4 == null || value4 =="") {
                $A.util.addClass(inputcmp4, "slds-has-error");
                if (messagestr== null)
                    messagestr = 'Clinical Solution: Required Field. \n';
                else {
                    messagestr += 'Clinical Solution: Required Field. \n';
                }
                Req3 =1;       
            }
            
            var inputcmp5 = component.find("input5");
            var value5 = inputcmp5.get("v.value");
            if(value5 == null || value5 =="") {
                $A.util.addClass(inputcmp5, "slds-has-error");
                if (messagestr== null)
                    messagestr = 'Opt In/Out: Required Field. \n';
                else {
                    messagestr += 'Opt In/Out: Required Field. \n';
                }
                Req4 =1;  
            }
            
            var inputcmp6 = component.find("input6");
            var value6 = inputcmp6.get("v.value");
            if(value == null || value =="") {
                $A.util.addClass(inputcmp6, "slds-has-error");
                if (messagestr== null)
                    messagestr = 'Contingent: Required Field. \n';
                else {
                    messagestr += 'Contingent: Required Field. \n';
                }
                Req5 =1;       
            }
            
            var inputcmp7 = component.find("input7");
            var value7 = inputcmp7.get("v.value");
            if(value7 == null || value7 =="") {
                $A.util.addClass(inputcmp7, "slds-has-error");
                if (messagestr== null)
                    messagestr = 'Fee Basis: Required Field. \n';
                else {
                    messagestr += 'Fee Basis: Required Field. \n';
                }
                Req6 =1;       
            }
            
            var inputcmp8 = component.find("input8");
            var value8 = inputcmp8.get("v.value");
            if(value8 == null || value8 =="") {
                $A.util.addClass(inputcmp8, "slds-has-error");
                if (messagestr== null)
                    messagestr = 'Fee Amount: Required Field. \n';
                else {
                    messagestr += 'Fee Amount: Required Field. \n';
                }
                Req7 =1;       
            }
            if (component.get("{!v.objects.Custom_Description__c}")== null || component.get("{!v.objects.Custom_Description__c}")== "")
             {
                 if (messagestr== null|| messagestr==""){
                  messagestr = 'Additional Programs Display Name: Required Field. \n';
                 }
              else
               {
                   messagestr += 'Additional Programs Display Name: Required Field. \n';
               }
               Req9 =1;  
             }
            
            if (Req1 == 1 || Req2 == 1 || Req3 == 1 || Req4 == 1 || Req5 == 1 || Req6 == 1 || Req7 == 1 || Req9==1) {
                var appEvent = $A.get("e.c:Apttus_Grid_NT_Notify_Error_Event");
                appEvent.setParams({ "Error" : messagestr});
                appEvent.fire();   
            }
            
            if(Req1 == 0 && Req2 == 0 && Req3 == 0 && Req4 == 0 && Req5 == 0 && Req6 == 0 && Req7 == 0 && Req9==0) {
                component.set("{!v.DisplaySpinner}", true);
                var allObjList = component.get("{!v.apobjects}");
                var currIndex = component.get("v.currentIndex");
                var currObj = component.get("{!v.objects}");
                var isError = false;
                if ((component.get("{!v.objects.Id}") == null || component.get("{!v.objects.Id}") == 'undefined') && allObjList) {
                    for(var i = 0; i< allObjList.length ; i++){
                        if( i != currIndex && allObjList[i].Year__c == currObj.Year__c && allObjList[i].Clinical_Solution_Type__c == currObj.Clinical_Solution_Type__c 
                           && allObjList[i].Clinical_Solution__c == currObj.Clinical_Solution__c && allObjList[i].FAF_ID__c == currObj.FAF_ID__c){
                            var cmpTarget = component.find("tablerow");
                            $A.util.addClass(cmpTarget, "slds-has-error");
                            var errorStr = 'Additional Program with Yr, Clinical Solution Type, Clinical Solution Record already exists';
                            
                            var toastEvent = $A.get("e.force:showToast");
                            toastEvent.setParams({
                                "mode": 'sticky',
                                "type": 'error',
                                "title": "Error!",
                                "message": errorStr
                            });
                            toastEvent.fire();
                            
                            isError= true;
                        }
                    }
                }
                //alert('fafid  '+component.get("v.fafid"));
                //if (component.get("{!v.objects.Id}") != null && component.get("{!v.objects.Id}") != 'undefined') {
                //} else {
                    var action = component.get("c.isDup");
                    action.setParams({
                        "fafid":component.get("{!v.fafid}"),
                        "clinicalSolType":component.get("{!v.clinicalSolType}"),
                        "cs":component.get("{!v.objects}")
                    });
                    action.setCallback(this, $A.getCallback(function(response) {
                        var state = response.getState();
                        component.set("{!v.DisplaySpinner}", false);
                        //alert('state---'+state);
                        if (state === "SUCCESS") {
                            component.set("{!v.DisplaySpinner}", false);
                            var isDup = response.getReturnValue();
                            //alert('--isDup--'+isDup );
                            if(isDup && isDup == true ){
                                
                                var cmpTarget = component.find("tablerow");
                                $A.util.addClass(cmpTarget, "slds-has-error");
                                var errorStr = 'Additional Program with Yr, Clinical Solution Type, Clinical Solution Record already exists';
                                
                                var toastEvent = $A.get("e.force:showToast");
                                toastEvent.setParams({
                                    "mode": 'sticky',
                                    "type": 'error',
                                    "title": "Error!",
                                    "message": errorStr
                                });
                                toastEvent.fire();
                                
                            } else if (isError == false) {
                                var cmpTarget = component.find("tablerow");
                                $A.util.removeClass(cmpTarget, "slds-has-error");
                                
                                var appEventS = $A.get("e.c:Apttus_Grid_NT_Notify_Save_Event");
                                appEventS.setParams({ 
                                    "SaveRec" : true
                                });
                                appEventS.fire();     
                            }
                            
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
                                message = "Error in Updating Additional Program Information";
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
                    $A.enqueueAction(action);
                //}
                
            }
        }  
        if(component.get("v.display") == false)  {    
            var appEvent = $A.get("e.c:Apttus_Grid_NT_Notify_Save_Event");
            appEvent.setParams({ "SaveRec" : true});
            appEvent.fire();   
        }   
        
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
            var appEvent1 = $A.get("e.c:Apttus_Grid_Delete_RG_RowEvent");
            appEvent1.setParams({ 
                "isDeleteSuccess" : true,
                "delIndex" : component.get("v.currentIndex")
            });
            appEvent1.fire();
        }
        if (component.get("{!v.objects.Id}") != null && component.get("{!v.objects.Id}") != 'undefined') {
            //var appEvent = $A.get("e.c:Apttus_Grid_Inactive_Parent_Event");
            //appEvent.fire();
            helper.deleteSelectedRecords(component,event,helper);
        }
    },
    handleupdate : function(component, event, helper) {
        component.set("{!v.desc}", event.getParam("desc"));
		component.set("{!v.objects.Custom_Description__c}",component.get("{!v.desc}"));
    },
    copystart: function(component, event, helper) {
        //alert('copystart');
        helper.handleSaveNewHelper(component, event, helper);
    },
})