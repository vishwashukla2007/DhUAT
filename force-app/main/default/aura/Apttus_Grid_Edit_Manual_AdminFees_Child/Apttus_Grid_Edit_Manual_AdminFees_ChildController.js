({
	doInit : function(component, event, helper) {

    var yr = [];
    for (var i = 0; i < component.get("v.yearcount"); i++) 
    {
      var j = i+1;
      yr.push({value: j});
    }
    yr.push({
        value: 'All'
      });
     component.set("{!v.yearoptions}", yr);
     component.set("{!v.baserequired}", true);
   if (component.get("{!v.objects.Admin_Fee_Type__c}") !=null && component.get("{!v.objects.Admin_Fee_Type__c}") == "Paper Per Claim" && component.get("{!v.objects.Base_Amount__c}") == null)
     {
         component.set("{!v.objects.Base_Amount__c}","1.50");
     }
     helper.fetchpicklistvalue(component, helper);
   
	},
    handleChange : function(component, event, helper) {
		var inputcmp1 = component.find("input1");
        var value = inputcmp1.get("v.value");
        component.set("{!v.objects.Year__c}",value);
        
        var inputcmp3 = component.find("input3");
        var value = inputcmp3.get("v.value");
        component.set("{!v.objects.LOB__c}",value);
        
        var inputcmp4 = component.find("input4");
        var value = inputcmp4.get("v.value");
        component.set("{!v.objects.Admin_Fee_Type__c}",value);
        
       if (component.get("{!v.objects.Admin_Fee_Type__c}") !=null && component.get("{!v.objects.Admin_Fee_Type__c}") == "Paper Per Claim" && component.get("{!v.objects.Base_Amount__c}") == null)
        {
         component.set("{!v.objects.Base_Amount__c}","1.50");
        }
        
        var inputcmp5 = component.find("input5");
        var value = inputcmp5.get("v.value");
        component.set("{!v.objects.Base_Amount__c}",value);
    
        var inputcmp6 = component.find("input6");
        var value = inputcmp6.get("v.value");
        component.set("{!v.objects.Broker_Amount__c}",value);
    
	},
  handleSave : function(component, event, helper) { 
   component.set("{!v.objects.Custom_Description__c}",component.get("{!v.desc}"));
   if(component.get("v.display") == true)
        {
        var Req1 = 0;
        var Req2 = 0;
        var Req3 = 0;
        var Req4 = 0;
        var Req5 = 0;
        var Req6 = 0;
        var messagestr;
        var inputcmp1 = component.find("input1");
        var value = inputcmp1.get("v.value");
        if(value == null || value =="")
        {
        messagestr = 'Year: Required Field. \n ';
        Req1 =1;       
        $A.util.addClass(inputcmp1, "slds-has-error");
        }
        var inputcmp3 = component.find("input3");
        var value = inputcmp3.get("v.value");
        if(value == null || value =="")
        {
        $A.util.addClass(inputcmp3, "slds-has-error");
        if (messagestr== null)
        messagestr = 'LOB: Required Field. \n';
        else
        {
        messagestr += 'LOB: Required Field. \n';
        }
        Req2 =1;       
        }
        
        var inputcmp4 = component.find("input4");
        var value = inputcmp4.get("v.value");
        if(value == null || value =="")
        {
     
        $A.util.addClass(inputcmp4, "slds-has-error");
        if (messagestr== null)
        messagestr = 'Admin Fee Type: Required Field. \n';
        else
        {
        messagestr += 'Admin Fee Type: Required Field. \n';
        }
        Req3 =1;  
        }
        
        var inputcmp5 = component.find("input5");
        var value = inputcmp5.get("v.value");
        if((value == null || value =="") && value !="0")
        {
     
        $A.util.addClass(inputcmp5, "slds-has-error");
        if (messagestr== null)
        messagestr = 'Base Amount $: Required Field. \n';
        else
        {
        messagestr += 'Base Amount $: Required Field. \n';
        }
        Req4 =1;  
        }
        
       
     
        if (Req1 == 1 || Req2 == 1 || Req3 == 1 || Req4 == 1 )
        {
                var appEvent = $A.get("e.c:Apttus_Grid_NT_Notify_Error_Event");
                appEvent.setParams({ "Error" : messagestr});
                appEvent.fire();   
        }

        if(Req1 == 0 && Req2 == 0 && Req3 == 0 && Req4 == 0 && component.get("{!v.Errordesc}")=="false")
        {
            
              if (component.get("{!v.objects.Broker_Amount__c}") != null)
        	   {
            	component.set("{!v.objects.Additive__c}", true);
        	   }
              else
               {
                component.set("{!v.objects.Additive__c}", false);
               }
                var inputcmp1 = component.find("input1");
				$A.util.removeClass(inputcmp1, "slds-has-error");
				var inputcmp2 = component.find("input2");
				$A.util.removeClass(inputcmp2, "slds-has-error");
				var inputcmp3 = component.find("input3");
				$A.util.removeClass(inputcmp3, "slds-has-error");
				var inputcmp4 = component.find("input4");
				$A.util.removeClass(inputcmp4, "slds-has-error");
				var inputcmp5 = component.find("input5");
				$A.util.removeClass(inputcmp5, "slds-has-error");
				var inputcmp6 = component.find("input6");
				$A.util.removeClass(inputcmp6, "slds-has-error");
        var action = component.get("c.get_saveadminfeedata");
        action.setParams({ "ad" : component.get("{!v.objects}")});
        // Create a callback that is executed after 
        // the server-side action returns
       action.setCallback(this, function(response) {
       var state = response.getState();
            if (state === "SUCCESS") 
               {
                if (response.getReturnValue() == 0)
                {
                component.set("v.duplicaterow","0"); 
                var cmpTarget = component.find("tablerow");
                $A.util.removeClass(cmpTarget, "slds-has-error");
                var appEvent = $A.get("e.c:Apttus_Grid_NT_Notify_Save_Event");
                var adminobj = component.get("v.objects");
                appEvent.setParams({ "SaveRec" : true});
                appEvent.setParams({ "Admin" : adminobj});
                appEvent.setParams({ "Grid" : "MANUAL"});
                appEvent.fire();
                }
                else
                {
                    
                component.set("v.duplicaterow","0"); 
                var cmpTarget = component.find("tablerow");
                $A.util.removeClass(cmpTarget, "slds-has-error");
                var appEvent = $A.get("e.c:Apttus_Grid_NT_Notify_Save_Event");
                //component.set("v.mailobjects", mail);
                var adminobj = component.get("v.objects");
                appEvent.setParams({ "SaveRec" : "false"});
                appEvent.setParams({ "Admin" : adminobj});
                appEvent.setParams({ "Grid" : "MANUAL"});
                appEvent.fire();    
                    
                /*var inputcmp1 = component.find("input1");
				$A.util.addClass(inputcmp1, "slds-has-error");
				var inputcmp2 = component.find("input2");
				$A.util.addClass(inputcmp2, "slds-has-error");
				var inputcmp3 = component.find("input3");
				$A.util.addClass(inputcmp3, "slds-has-error");
				var inputcmp4 = component.find("input4");
				$A.util.addClass(inputcmp4, "slds-has-error");
				var inputcmp5 = component.find("input5");
				$A.util.addClass(inputcmp5, "slds-has-error");
				var inputcmp6 = component.find("input6");
				$A.util.addClass(inputcmp6, "slds-has-error");
                message = "Admin Fee Type record already exists for the Year, LOB and Admin Fee Type combination. Please create a unique record using the combination.";  
                var appEvent = $A.get("e.c:Apttus_Grid_NT_Notify_Error_Event");
                appEvent.setParams({ "Error" : message});
                appEvent.fire();*/
                }
               }
            else if (state === "ERROR")
               {
                //var errors = "Error in Updating Mail Pricing Information";
                component.set("v.duplicaterow","1"); 
                var cmpTarget = component.find("tablerow");
                $A.util.addClass(cmpTarget, "slds-has-error");
                var errors = response.getError();
                var message;
                if (errors) {
                   if(errors[0] && errors[0].message) {
                        message = "Error message: " + errors[0].message; 
                           }
                } 
                else {
                    message = "Error in Updating Administrative Fees Information";
                     }   
                var appEvent = $A.get("e.c:Apttus_Grid_NT_Notify_Error_Event");
                appEvent.setParams({ "Error" : message});
                appEvent.fire();        
               }
        });
        $A.enqueueAction(action);
        }
    }  
   if(component.get("v.display") == false)
        {    
               /* var appEvent = $A.get("e.c:Apttus_Grid_NT_Notify_Save_Event");
                appEvent.setParams({ "SaveRec" : true});
                appEvent.fire();    */
        
        }     
         
    },
    handleduplicate : function(component, event, helper) 
    {  
        var yr = event.getParam("Year");
        var lob = event.getParam("LOB");
        var adminfee = event.getParam("AdminFee");
        if (component.get("v.objects.Year__c") == yr && component.get("v.objects.LOB__c") == lob && component.get("v.objects.Admin_Fee_Type__c") == adminfee)
        {
                var cmpTarget = component.find("tablerow");
                $A.util.addClass(cmpTarget, "slds-has-error");
                var message = "Admin Fee Type record already exists for the Year, LOB and Admin Fee Type combination. Please create a unique record using the combination.";  
                var appEvent = $A.get("e.c:Apttus_Grid_NT_Notify_Error_Event");
                appEvent.setParams({ "Error" : message});
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
    handleupdate : function(component, event, helper) {
        component.set("{!v.desc}", event.getParam("desc"));
        console.log('event.getParam("desc")'+event.getParam("desc"));
		component.set("{!v.objects.Custom_Description__c}",component.get("{!v.desc}"));
    },
    //changes done by Mohit Srivastava : Custom Description
    customdesError : function(component, event, helper) {
        component.set("{!v.Errordesc}", event.getParam("Error"));
        console.log('Error Event'+event.getParam("Error"));
    },
    deleteSelectedRec : function(component, event, helper) {
        component.set("{!v.isDeleteAlertOpen}", false);
         if (component.get("{!v.objects.Id}") == null || component.get("{!v.objects.Id}") == 'undefined')
        {
        component.set("{!v.display}", false);
         var appEvent = $A.get("e.c:Apttus_Delete_Verify_Event");
         appEvent.setParams("message","MANUAL");
         appEvent.fire();
         var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title : 'Success Message',
                    message: 'Selected record(s) were deleted.',
                    type: 'success',
                    mode: 'pester'
                });
        toastEvent.fire();
        }
        if (component.get("{!v.objects.Id}") != null && component.get("{!v.objects.Id}") != 'undefined')
        {
         var appEvent = $A.get("e.c:Apttus_Grid_Inactive_Parent_Event");
         appEvent.fire();
         helper.deleteSelectedRecords(component,event,helper);
        }

    }
})