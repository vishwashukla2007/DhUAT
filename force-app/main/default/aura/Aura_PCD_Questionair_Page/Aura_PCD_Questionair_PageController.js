({
    doInit: function(component, event, helper) {
        //Calling Agreement Data method
        helper.getAggrementData(component, event);
        helper.getAggrementLineItemData(component, event);
        
        
        
        
		// Populate Picklist value for Addition specialty
        helper.getAdditionalSpecialtyPicklist(component, event);
		//Populate Value for Network Type
        helper.getAdditionalSpecialtyPicklist1(component, event);
       // Populate multiSelect Picklist 
        var action = component.get("c.getPiklistValues");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS"){
                var result = response.getReturnValue();
                var plValues = [];
                for (var i = 0; i < result.length; i++) {
                    plValues.push({
                        label: result[i],
                        value: result[i]
                    });
                }
                component.set("v.GenreList", plValues);
            }
        }
      
                          
      );
    
        $A.enqueueAction(action);
    },
	// Submit Button functionality
	create : function(component, event, helper) {
		 component.set("v.AgreementID",component.get("v.record")); 
		
		if(component.get("v.selectedLookUpRecord").Id==null &&component.get("v.selectedLookUpRecord1").Id==null &&
		component.get("v.selectedLookUpRecord2").Id==null && component.get("v.selectedLookUpRecord3").Id==null &&
		component.get("v.selectedLookUpRecord4").Id==null && component.get("v.Radioa1")!=true){
			var toastEvent = $A.get("e.force:showToast");
			toastEvent.setParams({
							  title :'Error!', 
							  mode : 'sticky',
							  type : 'Error',
							  message :'Atleast one of the Network Name is required.',
							  duration:'4000'});
							  toastEvent.fire();
			
	    }
		else{
		component.set("v.spinner", true);
				var action1 = component.get("c.getAuraAgreementData");
				action1.setParams({Aggrid:component.get("v.record")});
				action1.setCallback(this, function(response) {
					var state = response.getState();
					if (state === "SUCCESS") {
							var json1 = JSON.parse(JSON.stringify(response.getReturnValue()));
							component.set("v.AgrrementLineItem",json1.Primary_Agreement_Line_Item__c);
							component.set("v.FAFID",json1.PCD_FAF__c);
							var tempPcd = component.get("v.PCD");
							var looku=component.get("v.selectedLookUpRecord").Id;
			 if(component.get("v.Radio1")==false){
			  tempPcd.Are_there_Any_Changes__c='NO';
			  }
			  else{
				 tempPcd.Are_there_Any_Changes__c='YES';  
			  }
			  if(component.get("v.RadioHIF1")==false){
			  tempPcd.Med_D_HIF__c='NO';
			  }
			  else{
				 tempPcd.Med_D_HIF__c='YES';  
			  }
			  if(component.get("v.RadioLTC")==false){
			  tempPcd.Med_D_LTC__c='NO';
			  }
			  else{
				 tempPcd.Med_D_LTC__c='YES';  
			  }
			  if(component.get("v.RadioIHF")==false){
			  tempPcd.Med_D_IHS__c='NO';
			  }
			  else{
				 tempPcd.Med_D_IHS__c='YES';  
			  }
			  if(component.get("v.RadioTER")==false){
			  tempPcd.Med_D_TER__c='NO';
			  }
			  else{
				 tempPcd.Med_D_TER__c='YES';  
			  }
			  if(component.get("v.Radioa1")==true){
			  tempPcd.Do_you_want_to_provide_Network_name__c='NO';}
			  else{
				tempPcd.Do_you_want_to_provide_Network_name__c='YES';
			  }
			  if(component.get("v.Radiob1")==true){
			  tempPcd.Include_Optional_Network_Option_to_T_T__c='NO';
			  }
			  else{
				 tempPcd.Include_Optional_Network_Option_to_T_T__c='YES';  
			  }
			  if(component.get("v.Radioc1")==true){
				  tempPcd.Speciality_Option__c='NO';
			  }
			  else{
				  tempPcd.Speciality_Option__c='YES'; 
			  }
			  if(component.get("v.displayedSection_d1")=='true')
			  tempPcd.Formulary_Type_Rebates__c='YES';
			  else if(component.get("v.displayedSection_d1")=='false'){
				tempPcd.Formulary_Type_Rebates__c='NO' ; 
			  }
			  if(component.get("v.Radiof1")==true){
				tempPcd.Include_Additional_Programs_grid_in_PC__c='YES';  
			  }
			  else{
				  tempPcd.Include_Additional_Programs_grid_in_PC__c='NO';
			  }
			   
			  
			  if(component.get("v.selectedLookUpRecord").Id!=null){
			  tempPcd.Network_Name_Optional1_LK__c=component.get("v.selectedLookUpRecord").Id;
			  var NetworkName=component.get("v.selectedLookUpRecord").Name;
			  
			  }
			 if(component.get("v.selectedLookUpRecord1").Id!=null){
					tempPcd.Optional_Network_Name2_LK__c=component.get("v.selectedLookUpRecord1").Id;
			 }
			 if(component.get("v.selectedLookUpRecord2").Id!=null){
					tempPcd.Optional_Network_Name3_LK__c=component.get("v.selectedLookUpRecord2").Id;
			 }
			 if(component.get("v.selectedLookUpRecord3").Id!=null){
					tempPcd.Optional_Network_Name4_LK__c=component.get("v.selectedLookUpRecord3").Id;
			 }
			 if(component.get("v.selectedLookUpRecord4").Id!=null){
					tempPcd.Optional_Network_Name5_LK__c=component.get("v.selectedLookUpRecord4").Id;
			 }
			 tempPcd.Additional_Speciality_Option__c=component.get("v.PCD.Additional_Speciality_Option__c");
			 
			  if(component.get("v.selectedLookUpRecordSpec").Id!=null){
			  tempPcd.Specialty_Formulary_option1_LK__c=component.get("v.selectedLookUpRecordSpec").Id;
			  }
			   if(component.get("v.selectedLookUpRecord1Spec").Id!=null){
			  tempPcd.Specialty_Formulary_option2_LK__c=component.get("v.selectedLookUpRecord1Spec").Id;
			  }
			   if(component.get("v.selectedLookUpRecord2Spec").Id!=null){
			  tempPcd.Specialty_Formulary_option3_LK__c=component.get("v.selectedLookUpRecord2Spec").Id;
			  }
			  if(component.get("v.selectedLookUpRecord1Non").Id!=null){
			  tempPcd.Non_Speciality_Formulary1_option_LK__c=component.get("v.selectedLookUpRecord1Non").Id;
			  }
			   if(component.get("v.selectedLookUpRecord2Non").Id!=null){
			  tempPcd.Non_Speciality_Formulary2_option_LK__c=component.get("v.selectedLookUpRecord2Non").Id;
			  }
			  if(component.get("v.selectedLookUpRecord3Non").Id!=null){
			  tempPcd.Non_Speciality_Formulary3_option_LK__c=component.get("v.selectedLookUpRecord3Non").Id;
			  }
			  tempPcd.Tier_Option_s__c=component.get("v.selectedGenreList");
			  
			  if(component.get("v.selectedLookUpRecord").Id!=null && component.get("v.LOB")=="EGWP"){
			  tempPcd.Network_Type1__c="Transparent";
			  }
			  else{
				 tempPcd.Network_Type1__c=component.get("v.PCD.Network_Type1__c"); 
			  }
			  if(component.get("v.selectedLookUpRecord1").Id!=null && component.get("v.LOB")=="EGWP"){
				 tempPcd.Network_Type2__c="Transparent"; 
			  }
			  else{
				tempPcd.Network_Type2__c=component.get("v.PCD.Network_Type2__c");  
			  }
			  if(component.get("v.selectedLookUpRecord2").Id!=null && component.get("v.LOB")=="EGWP"){
				  tempPcd.Network_Type3__c="Transparent"; 
			  }
			  else{
				  tempPcd.Network_Type3__c=component.get("v.PCD.Network_Type3__c"); 
			  }
			  if(component.get("v.selectedLookUpRecord3").Id!=null && component.get("v.LOB")=="EGWP"){
				tempPcd.Network_Type4__c="Transparent";  
			  }
			  else{
				tempPcd.Network_Type4__c=component.get("v.PCD.Network_Type4__c");  
			  }
			  if(component.get("v.selectedLookUpRecord4").Id!=null && component.get("v.LOB")=="EGWP"){
				  tempPcd.Network_Type5__c="Transparent";
			  }
			  else{
				tempPcd.Network_Type5__c=component.get("v.PCD.Network_Type5__c");  
			  }
			  tempPcd.Custom_Network_Description1__c=component.get("v.customNetwork");
			  tempPcd.Custom_Network_Description2__c=component.get("v.customNetwork1");
			  tempPcd.Custom_Network_Description3__c=component.get("v.customNetwork2");
			  tempPcd.Custom_Network_Description4__c=component.get("v.customNetwork3");
			  tempPcd.Custom_Network_Description5__c=component.get("v.customNetwork4");
        console.log('Get Agreement ID'+component.get("v.record"));   
			  tempPcd.Agreement__c=component.get("v.record");
			  tempPcd.PCD_FAF__c=component.get("v.FAFID");
			  tempPcd.Agreement_Line_Item__c=component.get("v.AgrrementLineItem");
			  
			  var action = component.get("c.createRecord");
				//Setting the Apex Parameter
				action.setParams({
					PCD:tempPcd,	
				});
				
				//Setting the Callback
				action.setCallback(this,function(a){
					console.log('In Last method call');
					//get the response state
					var state = a.getState();
					
					//check if result is successfull
					if(state == "SUCCESS"){
					 var toastEvent = $A.get("e.force:showToast");
					  toastEvent.setParams({
							  title :'Success!', 
							  mode : 'sticky',
							  type : 'Success',
							  message :'Questionnaire Submitted Successfully!',
							  duration:'4000'});
							  toastEvent.fire();

					} else if(state == "ERROR"){
						alert('Error in calling server side action');
					}
					 component.set("v.spinner", false);
				});
				 $A.enqueueAction(action);
						
			}
					
			 });
		   $A.enqueueAction(action1);
	}
   
	},
     hide0 : function(component,event,helper){
       component.set("v.Radio1",false);   
    },
    
    show0:function(component,event,helper){
        component.set("v.Radio1",true);   
        
    },
	
      hide : function(component,event,helper){
       component.set("v.displayedSection",'false' );   
    },
    
    show:function(component,event,helper){
        component.set("v.displayedSection",'true' );   
        
    },
     hide4 : function(component,event,helper){
       component.set("v.Radiob1",false);
    },
    
    show4:function(component,event,helper){
        component.set("v.Radiob1",true);
    },
     hide5 : function(component,event,helper){
       component.set("v.Radiof1",false);
    },
    
    show5:function(component,event,helper){
        component.set("v.Radiof1",true);
    },
     hide1 : function(component,event,helper){
       component.set("v.displayedSection_c1",'false' );   
    },
    
    show1:function(component,event,helper){
        component.set("v.displayedSection_c1",'true' );   
    },
     hide2 : function(component,event,helper){
         component.set("v.displayedSection_d1",'false' ); 
    },
    
    show2:function(component,event,helper){
       component.set("v.displayedSection_d1",'true' ); 
    },
    hide3: function(component,event,helper){
        component.set("v.displayedSection_e1",'false' ); 
    },
    
    show3:function(component,event,helper){
                component.set("v.displayedSection_e1",'true' ); 
    },
	
	hideHIF1 : function(component,event,helper){
       component.set("v.RadioHIF1",false);   
    },
    showHIF1:function(component,event,helper){
        component.set("v.RadioHIF1",true); 
    },
	hideIHF : function(component,event,helper){
       component.set("v.RadioIHF",false);   
    },
    showIHF:function(component,event,helper){
        component.set("v.RadioIHF",true); 
    },
	hideLTC: function(component,event,helper){
       component.set("v.RadioLTC",false);   
    },
    showLTC:function(component,event,helper){
        component.set("v.RadioLTC",true); 
    },
	hideTER: function(component,event,helper){
       component.set("v.RadioTER",false);   
    },
    showTER:function(component,event,helper){
        component.set("v.RadioTER",true); 
    },
	
	
	
     handleGenreChange: function (component, event, helper) {
        //Get the Selected values   
        var selectedValues = event.getParam("value");
        //Update the Selected Values  
        component.set("v.selectedGenreList", selectedValues);
        console.log('Multiselect value'+component.get("v.selectedGenreList"));
    },
    addRow:function(component,event,helper){
               component.set('v.counter',component.get('v.counter')+1);
         if(component.get('v.counter')+1==2){
             component.set("v.Slds1",'slds-show');
         }
        if(component.get('v.counter')+1==3){
             component.set("v.Slds2",'slds-show');
         }
          if(component.get('v.counter')+1==4){
             component.set("v.Slds3",'slds-show');
         }
        if(component.get('v.counter')+1==5){
             component.set("v.Slds4",'slds-show');
         }
         if(component.get('v.counter')+1==6){
             component.set("v.AddRowBoolean",true);
         }
    },
	addRow1:function(component,event,helper){
               component.set('v.counter1',component.get('v.counter1')+1);
         if(component.get('v.counter1')+1==2){
             component.set("v.SldsSpec1",'slds-show');
         }
        if(component.get('v.counter1')+1==3){
             component.set("v.SldsSpec2",'slds-show');
         }
         if(component.get('v.counter1')+1==4){
             component.set("v.AddRowBoolean1",true);
         }
          
    },
	addRow2:function(component,event,helper){
               component.set('v.counter2',component.get('v.counter2')+1);
         if(component.get('v.counter2')+1==2){
             component.set("v.SldsNONSpec1",'slds-show');
         }
        if(component.get('v.counter2')+1==3){
             component.set("v.SldsNONSpec2",'slds-show');
         }
         if(component.get('v.counter2')+1==4){
             component.set("v.AddRowBoolean2",true);
         }
    },
    RemoveRow:function(component,event,helper){
      
        console.log('Remove rows'+ component.get('v.counter'));
		console.log('Remove rows#######'+ component.get('v.counter'));
        if(component.get('v.counter')==1){
             component.set("v.Slds1",'slds-hide');
             component.set('v.counter',1)
            
        }
         if(component.get('v.counter')-1==1){
              component.set('v.counter',1)
             component.set("v.Slds2",'slds-hide');
            
        }
         if(component.get('v.counter')-1==3){
              component.set('v.counter',3)
             component.set("v.Slds3",'slds-hide');
            
        }
         if(component.get('v.counter')-1==4){
              component.set('v.counter',4)
             component.set("v.Slds4",'slds-hide');
            
        }
         if(component.get('v.counter')-1==5){
             component.set('v.counter',5)
             component.set("v.Slds5",'slds-hide');
             component.set("v.AddRowBoolean",true);
            
        }
    },
    onPicklistChange: function(component, event, helper) {
        // get the value of select option
        var indutry = component.get("v.PCD.Additional_Speciality_Option__c");
        //alert(indutry);
    },
     onPicklistChange1: function(component, event, helper) {
        // get the value of select option
        var indutry1 = component.get("v.PCD.Network_Type1__c");
        //alert(indutry1);
    }, onPicklistChange2: function(component, event, helper) {
        // get the value of select option
        var indutry2 = component.get("v.PCD.Network_Type2__c");
        //alert(indutry2);
    }, onPicklistChange3: function(component, event, helper) {
        // get the value of select option
        var indutry3 = component.get("v.PCD.Network_Type3__c");
        //alert(indutry3);
    },
    onPicklistChange4: function(component, event, helper) {
        // get the value of select option
        var indutry4 = component.get("v.PCD.Network_Type4__c");
        //alert(indutry4);
    },
    onPicklistChange5: function(component, event, helper) {
        // get the value of select option
        var indutry5 = component.get("v.PCD.Network_Type5__c");
        //alert(indutry5);
    },
    showSpinner: function(component, event, helper) {
        // make Spinner attribute true for displaying loading spinner 
        component.set("v.spinner", true); 
    },
     
    // function automatic called by aura:doneWaiting event 
    hideSpinner : function(component,event,helper){
        // make Spinner attribute to false for hiding loading spinner    
        component.set("v.spinner", false);
    },
     checkCustomNetwork : function(component,event,helper){
        
        var NetworkName=component.get("v.selectedLookUpRecord").Name;
        if(NetworkName!=null){
			 if(NetworkName.includes('Custom')){
				 component.set("v.CustomText","display:block");
				 component.set("v.RequireCustomNetwork",true);
			 }
			 else{
				  component.set("v.CustomText","display:none");
				 component.set("v.RequireCustomNetwork",false);
			 }
			 if(NetworkName=='MC(84-90)CP' || NetworkName=='MC(84-90)CVS'){
			 component.set("v.NetwortType1","display:none");
			 component.set("v.networkPick",false);
			 }
			 else{
             component.set("v.NetwortType1","display:block");
			 component.set("v.networkPick",true);
			 }
        }
		else{
		component.set("v.CustomText","display:none");
		component.set("v.RequireCustomNetwork",false);
        component.set("v.NetwortType1","display:none");
		component.set("v.networkPick",false);
		}
    },
	checkCustomNetwork1 : function(component,event,helper){
        
          var NetworkName=component.get("v.selectedLookUpRecord1").Name;
		if(NetworkName!=null){
			 if(NetworkName.includes('Custom')){
				 component.set("v.CustomText1","display:block");
				 component.set("v.RequireCustomNetwork1",true);
			 }
			 else{
				  component.set("v.CustomText1","display:none");
				  component.set("v.RequireCustomNetwork1",false);
			 }
			if(NetworkName=='MC(84-90)CP' || NetworkName=='MC(84-90)CVS'){
				 component.set("v.NetwortType2","display:none");
			component.set("v.networkPick1",false);
			}
			else{
            component.set("v.NetwortType2","display:block");
			component.set("v.networkPick1",true);
			}
		}
		else{
			component.set("v.CustomText1","display:none");
		    component.set("v.RequireCustomNetwork1",false);
            component.set("v.NetwortType2","display:none");
			component.set("v.networkPick1",false);
		}
            
         console.log('CUstom network******NetworkName*******'+NetworkName);
    },
	checkCustomNetwork2: function(component,event,helper){
        
          var NetworkName=component.get("v.selectedLookUpRecord2").Name;
		if(NetworkName!=null){
			 if(NetworkName.includes('Custom')){
				 component.set("v.CustomText2","display:block");
				  component.set("v.RequireCustomNetwork2",true);
			 }
			 else{
				 component.set("v.CustomText2","display:none");
				 component.set("v.RequireCustomNetwork2",false);
			 }
			if(NetworkName=='MC(84-90)CP' || NetworkName=='MC(84-90)CVS'){
			component.set("v.NetwortType3","display:none");
			component.set("v.networkPick2",false);	
			}
			else{
			component.set("v.NetwortType3","display:block");
			component.set("v.networkPick2",true);
			}
		}
		else{
			component.set("v.CustomText2","display:none");
		    component.set("v.RequireCustomNetwork2",false);
			component.set("v.NetwortType3","display:none");
			component.set("v.networkPick2",false);
		}
            
         console.log('CUstom network******NetworkName*******'+NetworkName);
    },
	checkCustomNetwork3 : function(component,event,helper){
      
          var NetworkName=component.get("v.selectedLookUpRecord3").Name;
		if(NetworkName!=null){
			 if(NetworkName.includes('Custom')){
				 component.set("v.CustomText3","display:block");
				 component.set("v.RequireCustomNetwork3",true);
			 }
			 else{
				  component.set("v.CustomText3","display:none");
				 component.set("v.RequireCustomNetwork3",false);
			 }
			if(NetworkName=='MC(84-90)CP' || NetworkName=='MC(84-90)CVS'){
			component.set("v.NetwortType4","display:none");	
			component.set("v.networkPick3",false);
			}
			else{
			component.set("v.NetwortType4","display:block");
			component.set("v.networkPick3",true);
			}
			
		}
		else{
		 component.set("v.CustomText3","display:none");
		component.set("v.RequireCustomNetwork3",false);	
		component.set("v.NetwortType4","display:none");
	    component.set("v.networkPick3",false);
		}
            
        
    },checkCustomNetwork4 : function(component,event,helper){
        
        var NetworkName=component.get("v.selectedLookUpRecord4").Name;
		if(NetworkName!=null){
			 if(NetworkName.includes('Custom')){
				 component.set("v.CustomText4","display:block");
				 component.set("v.RequireCustomNetwork4",true);
			 }
			 else{
				  component.set("v.CustomText4","display:none");
				 component.set("v.RequireCustomNetwork4",false);
			 }
			if(NetworkName=='MC(84-90)CP' || NetworkName=='MC(84-90)CVS'){
			component.set("v.NetwortType5","display:none");
			component.set("v.networkPick4",false);
			}
			else{
			component.set("v.NetwortType5","display:block");	
			component.set("v.networkPick4",true);
			}
			
		}
		else{
		component.set("v.CustomText4","display:none");
		component.set("v.RequireCustomNetwork4",false);	
		component.set("v.NetwortType5","display:none");
		component.set("v.networkPick4",true);
		}
            
    }
    

   
    
})