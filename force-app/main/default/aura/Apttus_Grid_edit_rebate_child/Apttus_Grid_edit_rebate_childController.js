({
	doInit : function(component, event, helper) {
		console.log("Percentage check"+component.get("v.percentageCheck"));
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
     helper.fetchpicklistvalue(component, helper);
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
        //component.set("{!v.networkname}", event.getParam("networkname"));
        //component.set("{!v.networktype}", event.getParam("networktype"));
        component.set("{!v.lob}", event.getParam("lob"));
        //component.set("{!v.desc}", event.getParam("desc"));
        //component.set("{!v.objects.Network_Name__c}",component.get("{!v.networkname}"));
        //component.set("{!v.objects.Network_Type__c}",component.get("{!v.networktype}"));
        component.set("{!v.objects.LOB2__c}",component.get("{!v.lob}"));
        //component.set("{!v.objects.Custom_Network_Description__c}",component.get("{!v.desc}"));
        
    },
    handleChange : function(component, event, helper) {
		var inputcmp1 = component.find("inputYear");
        var value = inputcmp1.get("v.value");
        component.set("{!v.objects.Year__c}",value);
        
        var inputcmp131 = component.find("inputPlan");
        var value = inputcmp131.get("v.value");
        component.set("{!v.objects.Plan_Design__c}",value);
        
        var inputcmp411 = component.find("inputGSTP");
        var value = inputcmp411.get("v.value");
		if( component.get("{!v.objects.GSTP__c}")!=value){
		    component.set("v.GSTPBol",true);
	    }
        component.set("{!v.objects.GSTP__c}",value);
		
    
        var inputcmp2 = component.find("inputNonspec");
        var value = inputcmp2.get("v.value");
		if(component.get("{!v.objects.Non_Specialty_Formulary_2__c}")!=value){
		component.set("v.NonSpecBol",true);
		
		}
        component.set("{!v.objects.Non_Specialty_Formulary_2__c}",value);
    
        var inputcmp3 = component.find("inputSpec");
        var value = inputcmp3.get("v.value");
		if(component.get("{!v.objects.Specialty_Formulary__c}")!=value){
		component.set("v.SpecBol",true);	
		}
        component.set("{!v.objects.Specialty_Formulary__c}",value);
		
        var inputcmp4 = component.find("inputBrandBasis");
        var value = inputcmp4.get("v.value");
        component.set("{!v.objects.Basis__c}",value);
        
    
	},
    deleteSelectedRec : function(component, event, helper) {
        component.set("{!v.isDeleteAlertOpen}", false);
       if (component.get("{!v.objects.Id}") == null || component.get("{!v.objects.Id}") == 'undefined')
        {
        component.set("{!v.display}", false);
            
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
    },
    handleSave:function(component, event, helper){
       if(component.get("v.display") == true)
        {
			var Req1 = 0;
			var Req2 = 0;
			var Req3 = 0;
			var Req4 = 0;
			var Req5 = 0;
			var Req6 = 0;
			var Req7 = 0;
			var Req8 = 0;
			var Req9 = 0;
			var Req10 = 0;
			var Req11 = 0;
			var Req12 = 0;
			var Req13 = 0;
			var Req14 = 0;
			var Req15 = 0;
			var Req16 = 0;
			var Req17 = 0;
			var Req18 = 0;
			var Req19 = 0;
			var Req20 = 0;
			
			var messagestr;
			 var messagestr1;
			var inputcmp1 = component.find("inputYear");
			var value = inputcmp1.get("v.value");
			if(value == null || value =="")
			{
			messagestr = 'Year: Required Field. \n ';
			Req1 =1;       
			$A.util.addClass(inputcmp1, "slds-has-error");
			}
			var inputcmp2 = component.find("inputPlan");
			var value = inputcmp2.get("v.value");
			if(value == null || value =="")
			{
			$A.util.addClass(inputcmp2,"slds-has-error");
			if (messagestr== null)
			messagestr = 'Plan Design: Required Field. \n';
			else
			{
			messagestr +='Plan Design: Required Field. \n';
			}
			Req2 =1;       
			}
			var inputcmp3 = component.find("inputNonspec");
			var value = inputcmp3.get("v.value");
			if((value == null || value =="") )
			{
		 
			$A.util.addClass(inputcmp3, "slds-has-error");
			if (messagestr== null)
			messagestr = 'Non-Specialty Formulary: Required Field. \n';
			else
			{
			messagestr +='Non-Specialty Formulary: Required Field. \n';
			}
			Req3 =1;  
			}
			
			var inputcmp4 = component.find("inputBrandBasis");
			var value = inputcmp4.get("v.value");
			if((value == null || value ==""))
			{
		 
			$A.util.addClass(inputcmp4, "slds-has-error");
			if (messagestr== null)
			messagestr ='Basis: Required Field. \n';
			else
			{
			messagestr +='Basis: Required Field. \n';
			}
			Req4 =1;  
			}
			
			if (Req1 == 1 || Req2 == 1 || Req3 == 1 || Req4 ==1)
			{
				var appEvent = $A.get("e.c:Apttus_Grid_NT_Notify_Error_Event");
				appEvent.setParams({ "Error" : messagestr});
				appEvent.fire();   
			}
			// Validation for formular and Percenatge fields.
			if(component.get("v.percentageCheck")==true){
				var inputcmp5 = component.find("inputRetail30Per");
				var value = inputcmp5.get("v.value");
				if((value == null || value ==""))
				{
				Req5 =1;  
				}
				var inputcmp6 = component.find("inputRetail90Per");
				var value = inputcmp6.get("v.value");
				if((value == null || value ==""))
				{
				Req6 =1;  
				}
				var inputcmp7 = component.find("inputClient30Per");
				var value = inputcmp7.get("v.value");
				if((value == null || value ==""))
				{
				Req7 =1;  
				}
				var inputcmp8 = component.find("inputClient90Per");
				var value = inputcmp8.get("v.value");
				if((value == null || value ==""))
				{
				Req8 =1;  
				}
				var inputcmp9 = component.find("inputMailPer");
				var value = inputcmp9.get("v.value");
				if((value == null || value ==""))
				{
				Req9 =1;  
				}
				var inputcmp10 = component.find("inputMChoicePer");
				var value = inputcmp10.get("v.value");
				if((value == null || value ==""))
				{
				Req10 =1;  
				}
				var inputcmp11 = component.find("inputSpecialtyPer");
				var value = inputcmp11.get("v.value");
				if((value == null || value ==""))
				{
				Req11 =1;  
				}
				var inputcmp12 = component.find("inputSpecialtyRetailPer");
				var value = inputcmp12.get("v.value");
				if((value == null || value ==""))
				{
				Req12 =1;  
				}
			}
			else{
				var inputcmp5 = component.find("inputRetail30Dol");
				var value = inputcmp5.get("v.value");
				if((value == null || value ==""))
				{
				Req13 =1;  
				}
				var inputcmp6 = component.find("inputRetail90Dol");
				var value = inputcmp6.get("v.value");
				if((value == null || value ==""))
				{
				Req14 =1;  
				}
				var inputcmp7 = component.find("inputClient30Dol");
				var value = inputcmp7.get("v.value");
				if((value == null || value ==""))
				{
				Req15 =1;  
				}
				var inputcmp8 = component.find("inputClient90Dol");
				var value = inputcmp8.get("v.value");
				if((value == null || value ==""))
				{
				Req16 =1;  
				}
				var inputcmp9 = component.find("inputMailDol");
				var value = inputcmp9.get("v.value");
				if((value == null || value ==""))
				{
				Req17 =1;  
				}
				var inputcmp10 = component.find("inputMChoiceDol");
				var value = inputcmp10.get("v.value");
				if((value == null || value ==""))
				{
				Req18 =1;  
				}
				var inputcmp11 = component.find("inputSpecialtyDol");
				var value = inputcmp11.get("v.value");
				if((value == null || value ==""))
				{
				Req19 =1;  
				}
				var inputcmp12 = component.find("inputSpecialtyRetailDol");
				var value = inputcmp12.get("v.value");
				if((value == null || value ==""))
				{
				Req20 =1;  
				}
			}
			if(Req5==1 && Req6==1 && Req7==1 && Req8==1 && Req9==1 && Req10==1 && Req11==1 && Req12==1 ){
				
                var inputcmp5 = component.find("inputRetail30Per");
				$A.util.addClass(inputcmp5, "slds-has-error");
				
				var inputcmp6 = component.find("inputRetail90Per");
				$A.util.addClass(inputcmp6, "slds-has-error");
				
				var inputcmp7 = component.find("inputClient30Per");
				$A.util.addClass(inputcmp7, "slds-has-error");
				
				var inputcmp8 = component.find("inputClient90Per");
				$A.util.addClass(inputcmp8, "slds-has-error");
				
				var inputcmp9 = component.find("inputMailPer");
				$A.util.addClass(inputcmp9, "slds-has-error");
				
				var inputcmp10 = component.find("inputMChoicePer");
				$A.util.addClass(inputcmp10, "slds-has-error");
				
				var inputcmp11 = component.find("inputSpecialtyPer");
				$A.util.addClass(inputcmp11, "slds-has-error");
				
				var inputcmp12= component.find("inputSpecialtyRetailPer");
				$A.util.addClass(inputcmp12, "slds-has-error");
                
				var appEvent = $A.get("e.c:Apttus_Grid_NT_Notify_Error_Event");
				appEvent.setParams({ "Error" : "At least one of the Percentage amount fields needs to be entered."});
				appEvent.fire();
			}
			if(Req13==1 && Req14==1 && Req15==1 && Req16==1 && Req17==1 && Req18==1 && Req19==1 && Req20==1 ){
				var inputcmp5 = component.find("inputRetail30Dol");
				$A.util.addClass(inputcmp5, "slds-has-error");
				
				var inputcmp6 = component.find("inputRetail90Dol");
				$A.util.addClass(inputcmp6, "slds-has-error");
				
				var inputcmp7 = component.find("inputClient30Dol");
				$A.util.addClass(inputcmp7, "slds-has-error");
				
				var inputcmp8 = component.find("inputClient90Dol");
				$A.util.addClass(inputcmp8, "slds-has-error");
				
				var inputcmp9 = component.find("inputMailDol");
				$A.util.addClass(inputcmp9, "slds-has-error");
				
				var inputcmp10 = component.find("inputMChoiceDol");
				$A.util.addClass(inputcmp10, "slds-has-error");
				
				var inputcmp11 = component.find("inputSpecialtyDol");
				$A.util.addClass(inputcmp11, "slds-has-error");
				
				var inputcmp12= component.find("inputSpecialtyRetailDol");
				$A.util.addClass(inputcmp12, "slds-has-error");
				var appEvent = $A.get("e.c:Apttus_Grid_NT_Notify_Error_Event");
				appEvent.setParams({ "Error" : "At least one of the Dollar amount fields needs to be entered."});
				appEvent.fire();
			}
			
			if(Req1 == 0 && Req2 == 0 && Req3 == 0 && Req4 == 0 && (Req5 == 0 || Req6 == 0 || Req7 == 0 || Req8== 0 || Req9 == 0 || Req10 == 0 || Req11 == 0 || Req12 == 0) && (Req13 == 0 || Req14 == 0 || Req15 == 0 || Req16 == 0 
                                                                                                                                                                                || Req17 == 0 || Req19 == 0 || Req20 == 0))
			{
             
			//******************************************************** Updating Rebate data**********************************//
			if(component.get("v.NonSpecBol")==true||component.get("v.SpecBol")==true||component.get("v.GSTPBol")==true){
				
			var action = component.get("c.get_UpdateRebatedata");
			action.setParams({"ID":component.get("{!v.objects.FAF_ID__c}"),"nonspec":component.get("v.NonSpecBol"),"spec":component.get("v.SpecBol"),"gstp":component.get("v.GSTPBol")});
			action.setCallback(this, function(response) {
			var state = response.getState();
				if (state === "SUCCESS") 
				{
					if (response.getReturnValue()==0)
					{
					component.set("v.duplicaterow","0"); 
					var cmpTarget = component.find("tablerow");
					$A.util.removeClass(cmpTarget, "slds-has-error");
					var appEvent = $A.get("e.c:Apttus_Grid_NT_Notify_Save_Event");
					appEvent.setParams({ "SaveRec" : true});
					appEvent.fire();
					}
					else
					{
					message = "testing";  
					var appEvent = $A.get("e.c:Apttus_Grid_NT_Notify_Error_Event");
					appEvent.setParams({ "Error" : message});
					appEvent.fire();
					}
				}
				else if (state === "ERROR")
				{
				   var errors = "Error in Updating Rebate  Guarantees";
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
						message = "Error in Updating Rebate Guarantees";
						 }   
					var appEvent = $A.get("e.c:Apttus_Grid_NT_Notify_Error_Event");
					appEvent.setParams({ "Error" : message});
					appEvent.fire();     
				 }
			});
			$A.enqueueAction(action);
            }
			var action = component.get("c.get_saveRebatedata");
			action.setParams({"rb":component.get("{!v.objects}")});
			action.setCallback(this, function(response) {
			var state = response.getState();
				if (state === "SUCCESS") 
				{
					if (response.getReturnValue()==0)
					{
					component.set("v.duplicaterow","0"); 
					var cmpTarget = component.find("tablerow");
					$A.util.removeClass(cmpTarget, "slds-has-error");
					var appEvent = $A.get("e.c:Apttus_Grid_NT_Notify_Save_Event");
					appEvent.setParams({ "SaveRec" : true});
					appEvent.fire();
					}
					else
					{
					message = "testing";  
					var appEvent = $A.get("e.c:Apttus_Grid_NT_Notify_Error_Event");
					appEvent.setParams({ "Error" : message});
					appEvent.fire();
					}
				}
				else if (state === "ERROR")
				{
				   var errors = "Error in Updating Rebate  Guarantees";
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
						message = "Error in Updating Rebate Guarantees";
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
                var appEvent = $A.get("e.c:Apttus_Grid_NT_Notify_Save_Event");
                appEvent.setParams({ "SaveRec" : true});
                appEvent.fire();    
        
        }       
            
	}
	
})