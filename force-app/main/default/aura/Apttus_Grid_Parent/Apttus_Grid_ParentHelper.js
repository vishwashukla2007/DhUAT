({
    doInitHelper : function(component, event, helper) {
        //component.set("v.recordId", "a010x000005siCxAAI");
        component.set("v.clickNewModal", false);
        component.set("v.isSpecialty", false);
        component.set("v.isRebate", false);
        if(component.get("{!v.ObjectName}") == "Network_Pricing__c") {
            component.set("v.btnvisible", true);
        } else {
            component.set("v.btnvisible", false);
        }
        component.set("v.btnlabel", "Add Additional Network");
        helper.getlineitem(component, event, helper);
        var cols = [
            {label: 'RETAIL NON SPECIALTY'},
            {label: 'TRADITIONAL'}
        ];
        component.set("v.tableCols", cols); 
        helper.getThisReconciliation(component, helper);
    },
    getlineitem : function(component, event, helper) 
    {
        var action = component.get("c.get_lineitem");
        action.setParams({"RecId":  component.get("v.record")})
        action.setCallback(this, $A.getCallback(function(response) {
            var state = response.getState();
            if (state == "SUCCESS") {
                if (response.getReturnValue() != 'xx') {
                    component.set("{!v.alirecord}", response.getReturnValue());
                    if(component.get("{!v.alirecord}") != null)  {
                        helper.getThisReconciliation(component, event, helper);
 
                       var action = component.get("c.get_multiplelob");
       				   action.setParams({"recordId":  component.get("v.alirecord")})
                       action.setCallback(this, $A.getCallback(function(response) {
                       var state = response.getState();
                       if (state == "SUCCESS") 
                       {  
                         var ct = response.getReturnValue();
                         if (ct > 0)
                          component.set("{!v.multiplelob}",true);
                         else
                          component.set("{!v.multiplelob}",false);
                       }
                       }));
                      $A.enqueueAction(action); 

                        
                        
                    }   
                }
            } else {
                helper.counselLogErrors(response.getError());
            }
        }));
        $A.enqueueAction(action); 
        
        var action1 = component.get("c.get_AgreementObj");
        action1.setParams({"RecId":  component.get("v.record")})
        action1.setCallback(this, $A.getCallback(function(response) {
            var state = response.getState();
            if (state == "SUCCESS") {
                if (response.getReturnValue()) {
                    component.set("{!v.agreementObj}", response.getReturnValue());
                     var agObj = response.getReturnValue();                  
                    if(agObj && agObj.Primary_Agreement_Line_Item__r && agObj.Primary_Agreement_Line_Item__r.Additional_Program_Display__c	){
                        component.set("{!v.isDiaplayAddProg}", true);
                    }
                }
            } 
        }));
        $A.enqueueAction(action1); 
    },
    getThisReconciliation : function(component, event, helper) {
        if (component.get("{!v.ObjectName}") == "Network_Pricing__c" && component.get("{!v.alirecord}") != null && component.get("{!v.alirecord}") !="undefined")
        {
            var action = component.get("c.get_GridObjectdata");
            action.setParams({"RecId":  component.get("v.alirecord"),
                              "ObjectName": component.get("{!v.ObjectName}")})
            action.setCallback(this, $A.getCallback(function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    component.set("v.objects", response.getReturnValue());
                    component.set("v.totalcount", response.getReturnValue().length);
                }
                else {
                    helper.counselLogErrors(response.getError());
                }
            }));
            $A.enqueueAction(action);
            var action = component.get("c.get_Opsid");
            action.setParams({"RecId":  component.get("v.alirecord"),
                              "ObjectName": component.get("{!v.ObjectName}")})
            action.setCallback(this, $A.getCallback(function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    if (response.getReturnValue() != null)
                    {
                        component.set("v.OpsId", response.getReturnValue());
                        if (component.get("v.OpsId")==null || component.get("v.OpsId")=="")
                        {       
                            component.set("v.disablebtn", true);
                        }
                        else
                        {
                            component.set("v.disablebtn", false);
                        }
                        var appEvent = $A.get("e.c:Apttus_Grid_Ops_Id_Event");
                        appEvent.setParams({"OpsId" : component.get("v.OpsId")})
                        appEvent.fire();
                    }
                }
                else {
                    helper.counselLogErrors(response.getError());
                }
            }));
            $A.enqueueAction(action);   
            
            
            
        }
        if (component.get("{!v.ObjectName}") == "Mail_Pricing__c")
        {
            var action = component.get("c.get_MailGridObjectdata");
            action.setParams({"RecId": component.get("v.alirecord"),
                              "ObjectName": component.get("{!v.ObjectName}")})
            action.setCallback(this, $A.getCallback(function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    component.set("v.objects", response.getReturnValue());
                    
                }
                else {
                    helper.counselLogErrors(response.getError());
                }
            }));
            $A.enqueueAction(action);
            
            
            var action = component.get("c.get_Opsid");
            action.setParams({"RecId":  component.get("v.alirecord"),
                              "ObjectName": component.get("{!v.ObjectName}")})
            action.setCallback(this, $A.getCallback(function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    component.set("v.OpsId", response.getReturnValue());
                    if (component.get("v.OpsId")==null || component.get("v.OpsId")=="")
                    {       
                        component.set("v.disablebtn", true);
                    }
                    else
                    {
                        component.set("v.disablebtn", false);
                    }
                    var appEvent = $A.get("e.c:Apttus_Grid_Ops_Id_Event");
                    appEvent.setParams({"OpsId" : component.get("v.OpsId")})
                    appEvent.fire();
                }
                else {
                    helper.counselLogErrors(response.getError());
                }
            }));
            $A.enqueueAction(action);      
            
        }
        // Specialty Fee Schedule
        if (component.get("{!v.ObjectName}") =="Specialty_Drug_Level_Pricing__c")
        {
            
            var action = component.get("c.get_SpecOpsObjectdata");
            action.setParams({"RecId":  component.get("v.alirecord"),
                              "ObjectName": component.get("{!v.ObjectName}")})
            action.setCallback(this, $A.getCallback(function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                   
                    if (JSON.stringify(response.getReturnValue()).length > 0)
                     {
                       
                     component.set("v.SpecialtyOperationObj", response.getReturnValue());
                        
                     var dataSpecOps = component.get("v.SpecialtyOperationObj");
                     console.log(dataSpecOps);
                      component.set("v.fafid", dataSpecOps.FAF_ID__c);
                      component.set("v.sopsid",dataSpecOps.Id);
                     }
                }
                else 
                {
                    helper.counselLogErrors(response.getError());
                }
            }));
            $A.enqueueAction(action);
         } 
        
        if (component.get("{!v.ObjectName}") =="Specialty_Pricing__c")
        {
            
            var action = component.get("c.get_SpecGridObjectdata");
            action.setParams({"RecId":  component.get("v.alirecord"),
                              "ObjectName": component.get("{!v.ObjectName}")})
            action.setCallback(this, $A.getCallback(function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    component.set("v.opbjects", response.getReturnValue());
                    
                }
                else {
                    helper.counselLogErrors(response.getError());
                }
            }));
            $A.enqueueAction(action);
            
            
            var action = component.get("c.get_SpecOpsGridObjectdata");
            action.setParams({"RecId": component.get("v.alirecord"),
                              "ObjectName": component.get("{!v.ObjectName}")})
            action.setCallback(this, $A.getCallback(function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    component.set("v.Addobjects", response.getReturnValue());
                    
                }
                else {
                    helper.counselLogErrors(response.getError());
                }
            }));
            $A.enqueueAction(action);   
            
            
            var action = component.get("c.get_Opsid");
            action.setParams({"RecId":  component.get("v.alirecord"),
                              "ObjectName": component.get("{!v.ObjectName}")})
            action.setCallback(this, $A.getCallback(function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    component.set("v.OpsId", response.getReturnValue());
                    if (component.get("v.OpsId")==null || component.get("v.OpsId")=="")
                    {       
                        component.set("v.disablebtn", true);
                    }
                    else
                    {
                        component.set("v.disablebtn", false);
                    }
                    var appEvent = $A.get("e.c:Apttus_Grid_Ops_Id_Event");
                    appEvent.setParams({"OpsId" : component.get("v.OpsId")})
                    appEvent.fire();
                }
                else {
                    helper.counselLogErrors(response.getError());
                }
            }));
            $A.enqueueAction(action);      
            
        }
        console.log('Rebate Object Name'+component.get("{!v.ObjectName}"));
        
        if (component.get("{!v.ObjectName}") =="Rebate_Guarantee__c") {
            
            var action = component.get("c.get_RebGridObjectdata");
            action.setParams({
                "RecId": component.get("v.alirecord"),
                "ObjectName": component.get("{!v.ObjectName}")
            })
            action.setCallback(this, $A.getCallback(function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    component.set("v.objects", response.getReturnValue());
                } 
                else 
                {
                    //helper.counselLogErrors(response.getError());
                }
            }));
            $A.enqueueAction(action);
            
            var action = component.get("c.get_RebCarveOutObjectdata");
            action.setParams({
                "RecId": component.get("v.alirecord"),
                "ObjectName": component.get("{!v.ObjectName}")
            })
            action.setCallback(this, $A.getCallback(function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    component.set("v.Carveobjects", response.getReturnValue());
                     component.set("v.isRebate",true);
                    console.log('CarveOutresponse.getReturnValue()'+response.getReturnValue());
                } else {
                    helper.counselLogErrors(response.getError());
                }
            }));
            $A.enqueueAction(action);
        }  
        
        if (component.get("{!v.ObjectName}") == "Clinical_Solutions__c")
        {
            var action = component.get("c.get_Addprogramdata");
            //alert('ali'+ component.get("v.alirecord"));
            action.setParams({"RecId": component.get("v.alirecord"),
                              "ObjectName": component.get("{!v.ObjectName}")})
            action.setCallback(this, $A.getCallback(function(response) {
                var state = response.getState();
                if (state === "SUCCESS") 
                {
                    component.set("v.objects", response.getReturnValue());          
                }
                else {
                    helper.counselLogErrors(response.getError());
                }
            }));
            $A.enqueueAction(action);        
        } 
        if (component.get("{!v.ObjectName}") == "Billing_Admin_Fee__c")
        {
            var action = component.get("c.get_BillAdmindata");
            action.setParams({"RecId": component.get("v.alirecord"),
                              "ObjectName": component.get("{!v.ObjectName}")})
            action.setCallback(this, $A.getCallback(function(response) {
                var state = response.getState();
                if (state === "SUCCESS") 
                {
                    component.set("v.objects", response.getReturnValue());          
                }
                else {
                    helper.counselLogErrors(response.getError());
                }
            }));
            $A.enqueueAction(action);        
        } 
        
        var action = component.get("c.get_Opsid");
        action.setParams({"RecId":  component.get("v.alirecord"),
                          "ObjectName": component.get("{!v.ObjectName}")})
        action.setCallback(this, $A.getCallback(function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.OpsId", response.getReturnValue());
                if (component.get("v.OpsId")==null || component.get("v.OpsId")=="")
                {       
                    component.set("v.disablebtn", true);
                }
                else
                {
                    component.set("v.disablebtn", false);
                }
                var appEvent = $A.get("e.c:Apttus_Grid_Ops_Id_Event");
                appEvent.setParams({"OpsId" : component.get("v.OpsId")})
                appEvent.fire();
            }
            else {
                helper.counselLogErrors(response.getError());
            }
        }));
        $A.enqueueAction(action);      
        
        
    },
    updatealistatus : function(component, event, helper) 
    {
        var action = component.get("c.get_updatestatusali");
        action.setParams({ "stageName":  "Setup Pricing",
                           "recordId":  component.get("v.record")})
         action.setCallback(this, $A.getCallback(function(response) {
            var state = response.getState();
            if (state == "SUCCESS") 
            {
             // Update and History Track status change
            } 
           else 
            {
             
            }
        }));
        $A.enqueueAction(action); 
    },
    counselLogErrors : function(errors) {
        if (errors) {
            if (errors[0] && errors[0].message) {
                console.log("Error message: " + errors[0].message);
            }
        } else {
            console.log("Unknown error");
        }
    },
    handleSeqNumberChange : function(component, event, helper, objectName)  {
        var newSeqNum = event.getSource().get("v.value");
        var recId = event.getSource().get('v.name');
      //  alert(newSeqNum);
      //  alert(recId);
	  //  alert('objectName'+objectName);
        if(objectName == 'Network_Pricing__c'){
            helper.handleNPSeqNumberChangeHelper(component, event, helper, recId, null, newSeqNum, false);
        }
        if(objectName == 'Rebate_Guarantees__c'){
            helper.handleRGSeqNumberChangeHelper(component, event, helper, recId, newSeqNum);
        }
        if(objectName == 'Mail_Pricing__c'){
            helper.handleMsSeqNumberChangeHelper(component, event, helper, recId, null, newSeqNum, false);
        }
		if(objectName == 'Specialty_Pricing__c'){
            helper.handleSpecialtySeqNumberChangeHelper(component, event, helper, recId, null, newSeqNum, false);
        }
        
    },
    handleUpClick : function(component, event, helper, objectName)  {
        var recId = event.getSource().get('v.name');
        //alert(recId);
        var inputcmp1 = component.find('seqtext');
        var currentSeq;
        var nextSeq;
        for(var i=0 ; i<inputcmp1.length; i++){
            if(recId == inputcmp1[i].get("v.name")){
                currentSeq = inputcmp1[i].get("v.value");
                break;
            }
        }
        nextSeq = currentSeq - 1;   
        
        if(currentSeq == 1){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "mode": 'sticky',
                "type": 'error',
                "title": "Error!",
                "message": "min Seq"
            });
            toastEvent.fire();
        } else {
            if(objectName == 'Network_Pricing__c'){
                helper.handleNPSeqNumberChangeHelper(component, event, helper, recId, null, nextSeq, false);
            }
            if(objectName == 'Rebate_Guarantees__c'){
                helper.handleRGSeqNumberChangeHelper(component, event, helper, recId, nextSeq);
            }
            if(objectName == 'Mail_Pricing__c'){
                helper.handleMsSeqNumberChangeHelper(component, event, helper, recId, currentSeq, nextSeq, false);
            }
			if(objectName == 'Specialty_Pricing__c'){
                helper.handleSpecialtySeqNumberChangeHelper(component, event, helper, recId, currentSeq, nextSeq, false);
            }
			
        }
        //alert(currentSeq);
        //alert(nextSeq);
    },
    handleDownClick : function(component, event, helper, objectName)  {
        var recId = event.getSource().get('v.name');
        //alert(recId);
        var inputcmp1 = component.find('seqtext');
        var currentSeq;
        var nextSeq;
        for(var i=0 ; i<inputcmp1.length; i++){
            if(recId == inputcmp1[i].get("v.name")){
                currentSeq = inputcmp1[i].get("v.value");
                break;
            }
        }
        nextSeq = currentSeq + 1;   
        if(objectName =='Specialty_Pricing__c'){
        var totalLen = component.get("{!v.opbjects}").length;
           
        }
        else{
          var totalLen = component.get("{!v.objects}").length;  
            
        }
        if(totalLen == currentSeq){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "mode": 'sticky',
                "type": 'error',
                "title": "Error!",
                "message": "Max Seq"
            });
            toastEvent.fire();
        } else {
            if(objectName == 'Network_Pricing__c'){
                helper.handleNPSeqNumberChangeHelper(component, event, helper, recId, null, nextSeq, false);
            }
            if(objectName == 'Rebate_Guarantees__c'){
                helper.handleRGSeqNumberChangeHelper(component, event, helper, recId, nextSeq);
            }
            if(objectName == 'Mail_Pricing__c'){
                helper.handleMsSeqNumberChangeHelper(component, event, helper, recId, currentSeq, nextSeq, false);
            }
			if(objectName == 'Specialty_Pricing__c'){
                helper.handleSpecialtySeqNumberChangeHelper(component, event, helper, recId, currentSeq, nextSeq, false);
            }
			
        }
        //alert(currentSeq);
        //alert(nextSeq);
    },
	handleSpecialtySeqNumberChangeHelper : function(component, event, helper, recId, currSeqNum, newSeqNum, isUpDown)  {
        component.set("v.DisplaySpinner", true);
        var action = component.get("c.checkValid");
        action.setParams({
            "recId":  recId,
            "aliId":  component.get("v.alirecord"),
            "currSeqNum":  currSeqNum,
            "newSeqNum":  newSeqNum,
            "isUpDown":  isUpDown
        })
        action.setCallback(this, $A.getCallback(function(response) {
            var state = response.getState();
            
            //alert(state);
            if (state == "SUCCESS") {
                //alert(response.getReturnValue());
                if (response.getReturnValue()) {
                    var action1 = component.get("c.updateSpecSeq");
                    action1.setParams({
                        "recId":  recId,
                        "aliId":  component.get("v.alirecord"),
                        "newSeqNum":  newSeqNum
                    })
                    action1.setCallback(this, $A.getCallback(function(response1) {
                        var state1 = response.getState();
                        //alert('state1 '+state1);
                        if (state1 == "SUCCESS") {
                            helper.doInitHelper(component, event, helper);
                            var appEvent = $A.get("e.c:Apttus_Grid_Refresh_Parent_Event");
                            appEvent.fire(); 
                            component.set("{!v.DisplaySpinner}", false);
                        } else {
                            component.set("{!v.DisplaySpinner}", false);
                            var errors = response.getError();
                            var message;
                            if (errors) {
                                if(errors[0] && errors[0].message) {
                                    message = "Error message: " + errors[0].message; 
                                }
                            }  else {
                                message = "Error in Updating sequence";
                            }   
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
                    $A.enqueueAction(action1); 
                }
            } else {
                component.set("{!v.DisplaySpinner}", false);
                var errors = response.getError();
                var message;
                if (errors) {
                    if(errors[0] && errors[0].message) {
                        message = "Error message: " + errors[0].message; 
                    }
                }  else {
                    message = "Sequence is not valid";
                }   
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
    },
    handleNPSeqNumberChangeHelper : function(component, event, helper, recId, currSeqNum, newSeqNum, isUpDown)  {
        component.set("v.DisplaySpinner", true);
        var action = component.get("c.checkValid");
        action.setParams({
            "recId":  recId,
            "aliId":  component.get("v.alirecord"),
            "currSeqNum":  currSeqNum,

            "isUpDown":  isUpDown
        })
        action.setCallback(this, $A.getCallback(function(response) {
            var state = response.getState();
            
            if (state == "SUCCESS") {
                //alert(response.getReturnValue());
                if (response.getReturnValue()) {
                    var action1 = component.get("c.updateNPSeq");
                    action1.setParams({
                        "recId":  recId,
                        "aliId":  component.get("v.alirecord"),
                        "newSeqNum":  newSeqNum
                    })
                    action1.setCallback(this, $A.getCallback(function(response1) {
                        var state1 = response.getState();
                        //alert('state1 '+state1);
                        if (state1 == "SUCCESS") {
                            helper.doInitHelper(component, event, helper);
                            var appEvent = $A.get("e.c:Apttus_Grid_Refresh_Parent_Event");
                            appEvent.fire(); 
                            component.set("{!v.DisplaySpinner}", false);
                        } else {
                            component.set("{!v.DisplaySpinner}", false);
                            var errors = response.getError();
                            var message;
                            if (errors) {
                                if(errors[0] && errors[0].message) {
                                    message = "Error message: " + errors[0].message; 
                                }
                            }  else {
                                message = "Error in Updating sequence";
                            }   
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
                    $A.enqueueAction(action1); 
                }
            } else {
                component.set("{!v.DisplaySpinner}", false);
                var errors = response.getError();
                var message;
                if (errors) {
                    if(errors[0] && errors[0].message) {
                        message = "Error message: " + errors[0].message; 
                    }
                }  else {
                    message = "Sequence is not valid";
                }   
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
    },
    handleRGSeqNumberChangeHelper : function(component, event, helper, recId, newSeqNum)  {
        component.set("v.DisplaySpinner", true);
        var action1 = component.get("c.updateRGSeq");
        action1.setParams({
            "recId":  recId,
            "aliId":  component.get("v.alirecord"),
            "newSeqNum":  newSeqNum
        })
        action1.setCallback(this, $A.getCallback(function(response) {
            var state1 = response.getState();
            //alert('state1 '+state1);
            if (state1 == "SUCCESS") {
                helper.doInitHelper(component, event, helper);
                var appEvent = $A.get("e.c:Apttus_Grid_Refresh_Parent_Event");
                appEvent.fire(); 
                component.set("{!v.DisplaySpinner}", false);
            } else {
                component.set("{!v.DisplaySpinner}", false);
                var errors = response.getError();
                var message;
                if (errors) {
                    if(errors[0] && errors[0].message) {
                        message = "Error message: " + errors[0].message; 
                    }
                }  else {
                    message = "Error in Updating sequence";
                }   
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
        $A.enqueueAction(action1); 
        
    },
    handleMsSeqNumberChangeHelper : function(component, event, helper, recId, currSeqNum, newSeqNum, isUpDown)  {
        component.set("v.DisplaySpinner", true);
        var action = component.get("c.updateMPSeq");
        action.setParams({
            "recId":  recId,
            "aliId":  component.get("v.alirecord"),
            "currSeqNum":  currSeqNum,
            "newSeqNum":  newSeqNum,
            "isUpDown":  isUpDown
        });
        action.setCallback(this, $A.getCallback(function(response) {
                        var state1 = response.getState();
                        //alert('state1 '+state1);
                        if (state1 == "SUCCESS") {
                            helper.doInitHelper(component, event, helper);
                            var appEvent = $A.get("e.c:Apttus_Grid_Refresh_Parent_Event");
                            appEvent.fire(); 
                            component.set("{!v.DisplaySpinner}", false);
                        } else {
                            component.set("{!v.DisplaySpinner}", false);
                            var errors = response.getError();
                            var message;
                            if (errors) {
                                if(errors[0] && errors[0].message) {
                                    message = "Error message: " + errors[0].message; 
                                }
                            }  else {
                                message = "Error in Updating sequence";
                            }   
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
        
        console.log(recId + "@" + currSeqNum + "@" + newSeqNum + "@" +isUpDown + "@" + component.get("v.alirecord"));
    }
})