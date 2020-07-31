({
    
// Init method to perform operation during rendering of this component, It setup indexes of record to identify
// individual record and pass it to child component    
    doInit : function(component, event, helper) {
        var isNew = component.get("v.isNew");
        var platformId = component.get("v.pItem.platformSpecific.Id");
        var platform = component.get("v.pItem.platformSpecific.Platform__c");
        var lob = component.get("v.pItem.platformSpecific.LOB__c");
        var ins = component.get("v.pItem.platformSpecific.Instruction__c");
        var level1 = component.get("v.pItem.platformSpecific.Level_1_Record_ID__c");
        var level2 = component.get("v.pItem.platformSpecific.Level_2_record_ID__c");
        var level3 = component.get("v.pItem.platformSpecific.Level_3_record_ID__c");
        //  Identify Unique record and pass it to child components to perform actions
        var index = component.get("v.indexPlatValue");
        var uniquerec = index;
        component.set("v.recordIdentify", uniquerec);
        var pItem = component.get("v.pItem");
        var eDate = pItem.platformSpecific.EffectiveDate__c;
        if(eDate){
            	//console.log("here vinitha");
                helper.validateEffectiveDate(component);
            }
        if (isNew == false)
        {
        var cmpTarget1 = component.find('checkbox');
        $A.util.addClass(cmpTarget1, 'sticky'); 
        var cmpTarget2 = component.find('link');
        $A.util.addClass(cmpTarget2, 'sticky'); 
        var cmpTarget3 = component.find('platform');
        $A.util.addClass(cmpTarget3, 'sticky'); 
        var cmpTarget4 = component.find('lob');
        $A.util.addClass(cmpTarget4, 'sticky'); 
        var cmpTarget5 = component.find('instruction');
        $A.util.addClass(cmpTarget5, 'sticky'); 
        var cmpTarget6 = component.find('level1id');
        $A.util.addClass(cmpTarget6, 'sticky'); 
        var cmpTarget7 = component.find('level1name');
        $A.util.addClass(cmpTarget7, 'sticky'); 
        }
    },
    onfocus : function(component, event, helper) 
    {
        var cmpTarget1 = component.find('checkbox');
        $A.util.addClass(cmpTarget1, 'sticky'); 
        var cmpTarget2 = component.find('link');
        $A.util.addClass(cmpTarget2, 'sticky'); 
        var cmpTarget3 = component.find('platform');
        $A.util.addClass(cmpTarget3, 'sticky'); 
        var cmpTarget4 = component.find('lob');
        $A.util.addClass(cmpTarget4, 'sticky'); 
        var cmpTarget5 = component.find('instruction');
        $A.util.addClass(cmpTarget5, 'sticky'); 
        var cmpTarget6 = component.find('level1id');
        $A.util.addClass(cmpTarget6, 'sticky'); 
        var cmpTarget7 = component.find('level1name');
        $A.util.addClass(cmpTarget7, 'sticky'); 
    },
    offfocus : function(component, event, helper) 
    {
      var cmpTarget1 = component.find('checkbox');
        	$A.util.removeClass(cmpTarget1, 'sticky'); 
       	    var cmpTarget2 = component.find('link');
            $A.util.removeClass(cmpTarget2, 'sticky'); 
            var cmpTarget3 = component.find('platform');
            $A.util.removeClass(cmpTarget3, 'sticky'); 
            var cmpTarget4 = component.find('lob');
            $A.util.removeClass(cmpTarget4, 'sticky'); 
            var cmpTarget5 = component.find('instruction');
            $A.util.removeClass(cmpTarget5, 'sticky'); 
            var cmpTarget6 = component.find('level1id');
            $A.util.removeClass(cmpTarget6, 'sticky'); 
            var cmpTarget7 = component.find('level1name');
            $A.util.removeClass(cmpTarget7, 'sticky'); 

    },
    handleNewModeChange : function(component, event, helper) 
    {
            var cmpTarget1 = component.find('checkbox');
        	$A.util.removeClass(cmpTarget1, 'sticky'); 
       	    var cmpTarget2 = component.find('link');
            $A.util.removeClass(cmpTarget2, 'sticky'); 
            var cmpTarget3 = component.find('platform');
            $A.util.removeClass(cmpTarget3, 'sticky'); 
            var cmpTarget4 = component.find('lob');
            $A.util.removeClass(cmpTarget4, 'sticky'); 
            var cmpTarget5 = component.find('instruction');
            $A.util.removeClass(cmpTarget5, 'sticky'); 
            var cmpTarget6 = component.find('level1id');
            $A.util.removeClass(cmpTarget6, 'sticky');
            var cmpTarget7 = component.find('level1name');
           $A.util.removeClass(cmpTarget7, 'sticky'); 
    },
 //It handle during Edit mode and establish exising Platform , LOB information
    handleEditModeChange : function(component, event, helper) {
       // console.log("-----------handleEditModeChange()-------------");
        try{
        	var isEditEnabled = component.get("v.isEditMode");
            if(isEditEnabled){
                
            var cmpTarget1 = component.find('checkbox');
        	$A.util.removeClass(cmpTarget1, 'sticky'); 
       	    var cmpTarget2 = component.find('link');
            $A.util.removeClass(cmpTarget2, 'sticky'); 
            var cmpTarget3 = component.find('platform');
            $A.util.removeClass(cmpTarget3, 'sticky'); 
            var cmpTarget4 = component.find('lob');
            $A.util.removeClass(cmpTarget4, 'sticky'); 
            var cmpTarget5 = component.find('instruction');
            $A.util.removeClass(cmpTarget5, 'sticky'); 
            var cmpTarget6 = component.find('level1id');
            $A.util.removeClass(cmpTarget6, 'sticky'); 
            var cmpTarget7 = component.find('level1name');
           $A.util.removeClass(cmpTarget7, 'sticky'); 
                
               // console.log("---isEditEnabled--------"+isEditEnabled);
                component.find("editPlatformSelectOption").set("v.value", component.get("v.pItem").platformSpecific.Platform__c);    
                component.find("editlobSelectOption").set("v.value", component.get("v.pItem").platformSpecific.LOB__c);
                component.find("editInstructionSelectOption").set("v.value", component.get("v.pItem").platformSpecific.Instruction__c);
                helper.validateEffectiveDate(component);
            }    
        }catch(e){
            console.log("Invalid Exception at HandleEditModeChange---"+e.message);
        }
        
	},
 //Method to Handle Platform value change. Fires Event to clear Level1 , 2 and 3 values incase of Platform
 //value change
	platFormChange : function(component, event, helper) {
        debugger;
		var platFormValue = component.find("platformSelectOption").get("v.value");
       // console.log("-----platformSelectOption----------"+platFormValue);
        component.set("v.pItem.platformSpecific.Platform__c", platFormValue);
        var platformId = component.get("v.pItem.platformSpecific.Id");
        var platform = component.get("v.pItem.platformSpecific.Platform__c");
        var lob = component.get("v.pItem.platformSpecific.LOB__c");
        var ins = component.get("v.pItem.platformSpecific.Instruction__c");
        var level1 = component.get("v.pItem.platformSpecific.Level_1_Record_ID__c");
        var level2 = component.get("v.pItem.platformSpecific.Level_2_record_ID__c");
        var level3 = component.get("v.pItem.platformSpecific.Level_3_record_ID__c");
         //  Identify Unique record and pass it to child components to perform actions
       var index = component.get("v.indexPlatValue");
        var uniquerec = index;
        component.set("v.recordIdentify", uniquerec);
       var lookupvisibility= $A.get("e.c:LevelLookupVisibilityPlatformChange");
      // set the Lookup visibility to the event attribute.  
       lookupvisibility.setParams({"isLevel2Visible" : 'true',
                            "isLevel3Visible" : 'true',
                            "recordIdentify" : uniquerec});  
      // fire the event  
       lookupvisibility.fire();
       component.set("v.pItem.platformSpecific.Do_not_modify_below_information__c", "CHANGE");
	},
  // Method to Handle LOB Value change
    lobChange : function(component, event, helper) {
		var lobValue = component.find("lobSelectOption").get("v.value");
      //  console.log("-----lobValue----------"+lobValue);
        component.set("v.pItem.platformSpecific.LOB__c", lobValue);
        var platformId = component.get("v.pItem.platformSpecific.Id");
        var platform = component.get("v.pItem.platformSpecific.Platform__c");
        var lob = component.get("v.pItem.platformSpecific.LOB__c");
        var ins = component.get("v.pItem.platformSpecific.Instruction__c");
        var level1 = component.get("v.pItem.platformSpecific.Level_1_Record_ID__c");
        var level2 = component.get("v.pItem.platformSpecific.Level_2_record_ID__c");
        var level3 = component.get("v.pItem.platformSpecific.Level_3_record_ID__c");
         //  Identify Unique record and pass it to child components to perform actions
        var index = component.get("v.indexPlatValue");
        var uniquerec = index;
        component.set("v.recordIdentify", uniquerec);
        /*var isEditModeParent = component.get("v.isEditModeParent");
        if (isEditModeParent = true) {
            component.set("v.isEditMode", true);
        }
        else{
            component.set("v.isEditMode", false);
        }*/
        component.set("v.pItem.platformSpecific.Do_not_modify_below_information__c", "CHANGE");    
	},
 //Method to handle Instruction value change in Platform Item
    instructionsChange : function(component, event, helper) {
		var instructionValue = component.find("instructionSelectOption").get("v.value");
      //  console.log("-----instructionValue----------"+instructionValue);
        component.set("v.pItem.platformSpecific.Instruction__c", instructionValue);
        var platformId = component.get("v.pItem.platformSpecific.Id");
        var platform = component.get("v.pItem.platformSpecific.Platform__c");
        var lob = component.get("v.pItem.platformSpecific.LOB__c");
        var ins = component.get("v.pItem.platformSpecific.Instruction__c");
        var level1 = component.get("v.pItem.platformSpecific.Level_1_Record_ID__c");
        var level2 = component.get("v.pItem.platformSpecific.Level_2_record_ID__c");
        var level3 = component.get("v.pItem.platformSpecific.Level_3_record_ID__c");
         //  Identify Unique record and pass it to child components to perform actions
       var index = component.get("v.indexPlatValue");
       var uniquerec = index;
        component.set("v.recordIdentify", uniquerec);
        component.set("v.pItem.platformSpecific.Do_not_modify_below_information__c", "CHANGE");
	},
   //Method to Handle Platform value change. Fires Event to clear Level1 , 2 and 3 values incase of Platform
   //value change
	editPlatFormChange : function(component, event, helper) {
		var platFormValue = component.find("editPlatformSelectOption").get("v.value");
      //  console.log("-----editPlatFormChange()----------"+platFormValue);
        component.set("v.pItem.platformSpecific.Platform__c", platFormValue);
        var platformId = component.get("v.pItem.platformSpecific.Id");
        var platform = component.get("v.pItem.platformSpecific.Platform__c");
        var lob = component.get("v.pItem.platformSpecific.LOB__c");
        var ins = component.get("v.pItem.platformSpecific.Instruction__c");
        var level1 = component.get("v.pItem.platformSpecific.Level_1_Record_ID__c");
        var level2 = component.get("v.pItem.platformSpecific.Level_2_record_ID__c");
        var level3 = component.get("v.pItem.platformSpecific.Level_3_record_ID__c");
        var index = component.get("v.indexPlatValue");
        //  Identify Unique record and pass it to child components to perform actions
        var uniquerec = index;
        component.set("v.recordIdentify", uniquerec);
       var lookupvisibility= $A.get("e.c:LevelLookupVisibilityPlatformChange");
      // set the Lookup visibility to the event attribute.  
       lookupvisibility.setParams({"isLevel2Visible" : 'true',
                            "isLevel3Visible" : 'true',
                            "recordIdentify" : uniquerec});  
      // fire the event  
       lookupvisibility.fire();
      component.set("v.pItem.platformSpecific.Do_not_modify_below_information__c", "CHANGE");
	},
   // Method to Handle LOB Value change
    editLobChange : function(component, event, helper) {
		var lobValue = component.find("editlobSelectOption").get("v.value");
     //   console.log("-----editLobChange()----------"+lobValue);
        component.set("v.pItem.platformSpecific.LOB__c", lobValue);
        var platformId = component.get("v.pItem.platformSpecific.Id");
        var platform = component.get("v.pItem.platformSpecific.Platform__c");
        var lob = component.get("v.pItem.platformSpecific.LOB__c");
        var ins = component.get("v.pItem.platformSpecific.Instruction__c");
        var level1 = component.get("v.pItem.platformSpecific.Level_1_Record_ID__c");
        var level2 = component.get("v.pItem.platformSpecific.Level_2_record_ID__c");
        var level3 = component.get("v.pItem.platformSpecific.Level_3_record_ID__c");
        //  Identify Unique record and pass it to child components to perform actions
        var index = component.get("v.indexPlatValue");
        var uniquerec = index;
        component.set("v.recordIdentify", uniquerec);
        component.set("v.pItem.platformSpecific.Do_not_modify_below_information__c", "CHANGE");
	},
  //Method to handle Edit Instruction field value Change
    editInstructionsChange : function(component, event, helper) {
		var instructionValue = component.find("editInstructionSelectOption").get("v.value");
     //   console.log("-----editInstructionsChange()----------"+instructionValue);
        component.set("v.pItem.platformSpecific.Instruction__c", instructionValue);
        var platformId = component.get("v.pItem.platformSpecific.Id");
        var platform = component.get("v.pItem.platformSpecific.Platform__c");
        var lob = component.get("v.pItem.platformSpecific.LOB__c");
        var ins = component.get("v.pItem.platformSpecific.Instruction__c");
        var level1 = component.get("v.pItem.platformSpecific.Level_1_Record_ID__c");
        var level2 = component.get("v.pItem.platformSpecific.Level_2_record_ID__c");
        var level3 = component.get("v.pItem.platformSpecific.Level_3_record_ID__c");
        var index = component.get("v.indexPlatValue");
        var uniquerec = index;
        component.set("v.recordIdentify", uniquerec);
        component.set("v.pItem.platformSpecific.Do_not_modify_below_information__c", "CHANGE");
	},
    
 // Method to Handel individual Cancel of records after New Button
   removeItem : function(component, event, helper) {
	//	console.log("-----removeItem()----------");
        component.set("v.pItem.isNewDelete", true);
        component.set("v.pItem.platformSpecific.Id", "EXCLUDE-CANCEL");
       component.set("v.pItem.platformSpecific.Do_not_modify_below_information__c", "CHANGE");
	},
 // Method to Open Edit Details Visual Force Page
    editDetails: function(component, event, helper) {
    //	console.log("-----editDetails()----------");
        var platformSpecificId =event.currentTarget.getAttribute("data-attriVal");
        console.log('billId'+platformSpecificId);
        var url = "/apex/EditPlatformSpecific?id=" + platformSpecificId ;
        window.open(url,'_blank');
               
    },
  // Opens Detail Page after click FAF Links and redirection
    openPlatformSpecific: function(component, event, helper){
        var navigationSObject = $A.get("e.force:navigateToSObject");
        var platformSpecificId =event.currentTarget.getAttribute("data-attrId");
        navigationSObject.setParams({
            "recordId": platformSpecificId
        });
        navigationSObject.fire();
    },
  // Validate Pricing Effective Date after change in Date value
    handleDateChange: function(component, event, helper){
        component.set("v.pItem.platformSpecific.Do_not_modify_below_information__c", "CHANGE");
        helper.validateEffectiveDate(component);
    },
  // Method to handel Checkbox functionality for Multidelete
	selectAllUnTicked: function(component, event) {
        var args = event.getParam("arguments");
        var checked = args.checked;
        var item = component.get("v.pItem", true);
        item.isSelected = checked;
        component.set("v.pItem", item);
    },
  // This function call when the end User Select any record from the Lookup 1 result list.   
    handleComponentEvent : function(component, event, helper) {
    // get the selected Carrier record from the COMPONENT event  
        debugger;
        var platformId = component.get("v.pItem.platformSpecific.Id");
        var platform = component.get("v.pItem.platformSpecific.Platform__c");
        var lob = component.get("v.pItem.platformSpecific.LOB__c");
        var ins = component.get("v.pItem.platformSpecific.Instruction__c");
        var level1 = component.get("v.pItem.platformSpecific.Level_1_Record_ID__c");
        var level2 = component.get("v.pItem.platformSpecific.Level_2_record_ID__c");
        var level3 = component.get("v.pItem.platformSpecific.Level_3_record_ID__c");
        var index = component.get("v.indexPlatValue");
      	var uniquerec = index;
        component.set("v.recordIdentify", uniquerec);
        var rec = event.getParam("recordIdentify");
        var selectedCarrierGetFromEvent = event.getParam("recordByEvent");
        var level1rec = selectedCarrierGetFromEvent.Id;
        if (uniquerec == rec)
        {
	     component.set("v.pItem.platformSpecific.Level_1_Record_ID__c" , selectedCarrierGetFromEvent.Id); 
         component.set("v.pItem.platformSpecific.Level1_Name__c" , selectedCarrierGetFromEvent.Carrier_Name__c); 
         component.set("v.pItem.platformSpecific.Do_not_modify_below_information__c", "CHANGE");
		}
      
	},

// Handle Event when User select Carrier record from Lookup Window
 handleCarrierWEvent : function(component,event,helper){  
        debugger;
        var platformId = component.get("v.pItem.platformSpecific.Id");
        var platform = component.get("v.pItem.platformSpecific.Platform__c");
        var lob = component.get("v.pItem.platformSpecific.LOB__c");
        var ins = component.get("v.pItem.platformSpecific.Instruction__c");
        var ins = component.get("v.pItem.platformSpecific.Instruction__c");
        var level1 = component.get("v.pItem.platformSpecific.Level_1_Record_ID__c");
        var level2 = component.get("v.pItem.platformSpecific.Level_2_record_ID__c");
        var level3 = component.get("v.pItem.platformSpecific.Level_3_record_ID__c");
      	var index = component.get("v.indexPlatValue");
      	var uniquerec = index;
        component.set("v.recordIdentify", uniquerec);
        var rec = event.getParam("recordIdentify");
        var carrier = event.getParam("carrier");
        var carrId = carrier[0].Id;
        var carrName = carrier[0].Carrier_Name__c;
        if (uniquerec == rec)
        {
	      component.set("v.pItem.platformSpecific.Level_1_Record_ID__c" , carrId); 
          component.set("v.pItem.platformSpecific.Level1_Name__c" , carrName); 
          component.set("v.pItem.platformSpecific.Do_not_modify_below_information__c", "CHANGE");
		}
      
    },
 // Handle Event when User create Non-validate Carrier
  handleCarrierEvent : function(component,event,helper){
        var platformId = component.get("v.pItem.platformSpecific.Id");
        var platform = component.get("v.pItem.platformSpecific.Platform__c");
        var lob = component.get("v.pItem.platformSpecific.LOB__c");
        var ins = component.get("v.pItem.platformSpecific.Instruction__c");
        var level1 = component.get("v.pItem.platformSpecific.Level_1_Record_ID__c");
        var level2 = component.get("v.pItem.platformSpecific.Level_2_record_ID__c");
        var level3 = component.get("v.pItem.platformSpecific.Level_3_record_ID__c");
      	var index = component.get("v.indexPlatValue");
        var uniquerec = index;
        component.set("v.recordIdentify", uniquerec);
        var rec = event.getParam("recordIdentify");
        var carrier = event.getParam("carrierid");
        var carrId = carrier[0].Id;
        var carrName = carrier[0].Carrier_Name__c;
        if (uniquerec == rec)
        {
	     component.set("v.pItem.platformSpecific.Level_1_Record_ID__c" , carrId); 
         component.set("v.pItem.platformSpecific.Level1_Name__c" , carrName); 
         component.set("v.pItem.platformSpecific.Do_not_modify_below_information__c", "CHANGE");
        }
    },
 // Handle event when User remove Carrier from Selection or Lookup 1 component
   removeCarrierEvent : function(component,event,helper){
        var platformId = component.get("v.pItem.platformSpecific.Id");
        var platform = component.get("v.pItem.platformSpecific.Platform__c");
        var lob = component.get("v.pItem.platformSpecific.LOB__c");
        var ins = component.get("v.pItem.platformSpecific.Instruction__c");
        var level1 = component.get("v.pItem.platformSpecific.Level_1_Record_ID__c");
        var level2 = component.get("v.pItem.platformSpecific.Level_2_record_ID__c");
        var level3 = component.get("v.pItem.platformSpecific.Level_3_record_ID__c");
     	var index = component.get("v.indexPlatValue");
        var uniquerec = index;
        component.set("v.recordIdentify", uniquerec);
        var rec = event.getParam("recordIdentify");
         if (uniquerec == rec)
          {
	        component.set("v.pItem.platformSpecific.Level_1_Record_ID__c" , null); 
            component.set("v.pItem.platformSpecific.Level1_Name__c" , null); 
            component.set("v.pItem.platformSpecific.Level_2_record_ID__c" , null); 
            component.set("v.pItem.platformSpecific.Level2_Name__c" , null); 
            component.set("v.pItem.platformSpecific.Level_3_record_ID__c" , null); 
            component.set("v.pItem.platformSpecific.Level3_Name__c" , null); 
            component.set("v.pItem.platformSpecific.Do_not_modify_below_information__c", "CHANGE");
		  }
   },
 
 // Method call from PlatformManagement and it Scans individual Item records , Validates and Save record
 // It checks Level1 required, LOB and Duplicate record checks
    saveValue: function(component, event, helper){
     var isDelete = component.get("v.pItem.platformSpecific.Id");
     var isChange = component.get("v.pItem.platformSpecific.Do_not_modify_below_information__c");
     if (isDelete !=  "EXCLUDE-CANCEL") {    // Don't consider Cancel records
      if (isChange == "CHANGE" || isDelete == null) {
      var platformId = component.get("v.pItem.platformSpecific.Id");
      var platform = component.get("v.pItem.platformSpecific.Platform__c");
      var lob = component.get("v.pItem.platformSpecific.LOB__c");
      var level1 = component.get("v.pItem.platformSpecific.Level_1_Record_ID__c");
      var level1name = component.get("v.pItem.platformSpecific.Level1_Name__c");
      var level2name = component.get("v.pItem.platformSpecific.Level2_Name__c");
      var level3name = component.get("v.pItem.platformSpecific.Level3_Name__c");
      var level2 = component.get("v.pItem.platformSpecific.Level_2_record_ID__c");
      var level3 = component.get("v.pItem.platformSpecific.Level_3_record_ID__c");
      var instruction = component.get("v.pItem.platformSpecific.Instruction__c");
      var Ins = component.get("v.pItem.platformSpecific.Instruction__c");
      var clientinfo = component.get("v.pItem.platformSpecific.FAF_Client_Information__c");
      var effdate = component.get("v.pItem.platformSpecific.EffectiveDate__c");
      var fafid = component.get("v.FAFID");
          var diff = component.get("v.pItem.platformSpecific.DifferentGSTPFormularyEffectiveDates__c");
           		var SFEffectiveDate = component.get("v.pItem.platformSpecific.SpecialtyFormularyEffectiveDate__c");
                var GSTPEffectiveDate = component.get("v.pItem.platformSpecific.GSTPEffectiveDate__c");
                var NSFEffectiveDate = component.get("v.pItem.platformSpecific.NonSpecialtyFormularyEffectiveDate__c");
                var sfSectionRequired = component.get("v.sfSectionRequired");
        		var gstpSectionRequired = component.get("v.gstpSectionRequired");
        		var nsfSectionRequired = component.get("v.nsfSectionRequired");
          
      if (level2 != null && level3 != null && level1 != null)
      {       
          var cagid = component.get("v.pItem.platformSpecific.Level_1_Record_ID__c") + 
          component.get("v.pItem.platformSpecific.Level_2_record_ID__c") + 
          component.get("v.pItem.platformSpecific.Level_3_record_ID__c") + 
          component.get("v.pItem.platformSpecific.FAF_Client_Information__c") +
          component.get("v.pItem.platformSpecific.Platform__c") + 
          component.get("v.pItem.platformSpecific.LOB__c")+ 
          component.get("v.pItem.platformSpecific.Instruction__c");
          
          
      }
      if (level2 != null && level3 == null)
      {
          
          var cagid = component.get("v.pItem.platformSpecific.Level_1_Record_ID__c") + 
          component.get("v.pItem.platformSpecific.Level_2_record_ID__c") + 
          component.get("v.pItem.platformSpecific.FAF_Client_Information__c") +
          component.get("v.pItem.platformSpecific.Platform__c") + 
          component.get("v.pItem.platformSpecific.LOB__c")+ 
          component.get("v.pItem.platformSpecific.Instruction__c");
          
          
      }
      if (level2 == null && level3 == null && level1 != null)
      {
          
          var cagid = component.get("v.pItem.platformSpecific.Level_1_Record_ID__c") + 
          component.get("v.pItem.platformSpecific.FAF_Client_Information__c") +
          component.get("v.pItem.platformSpecific.Platform__c") + 
          component.get("v.pItem.platformSpecific.LOB__c")+ 
          component.get("v.pItem.platformSpecific.Instruction__c");
          
      }
      if (level1 == null)
      {
          
          var cagid = 
          component.get("v.pItem.platformSpecific.FAF_Client_Information__c") +
          component.get("v.pItem.platformSpecific.Platform__c") + 
          component.get("v.pItem.platformSpecific.LOB__c")+ 
          component.get("v.pItem.platformSpecific.Instruction__c");
          
      }

      component.set("v.platFormItemvalu.Id", platformId);
      component.set("v.platFormItemvalu.Platform__c", platform);
      component.set("v.platFormItemvalu.LOB__c", lob);
      component.set("v.platFormItemvalu.Level_1_Record_ID__c", level1);
      component.set("v.platFormItemvalu.Level1_Name__c", level1name);
      component.set("v.platFormItemvalu.Level_2_record_ID__c", level2);
      component.set("v.platFormItemvalu.Level2_Name__c", level2name);
      component.set("v.platFormItemvalu.Level_3_record_ID__c", level3);
      component.set("v.platFormItemvalu.Level3_Name__c", level3name);
      component.set("v.platFormItemvalu.FAF_Client_Information__c", clientinfo);
      component.set("v.platFormItemvalu.Instruction__c", Ins);
      component.set("v.platFormItemvalu.EffectiveDate__c", effdate);
     	 if(!diff){	    
          if(sfSectionRequired){
                	component.set("v.platFormItemvalu.SpecialtyFormularyEffectiveDate__c", effdate);
                }
                 if(gstpSectionRequired){
               		 component.set("v.platFormItemvalu.GSTPEffectiveDate__c", effdate);
                 }
                 if(nsfSectionRequired){
               		 component.set("v.platFormItemvalu.NonSpecialtyFormularyEffectiveDate__c", effdate);
                 }
         }  
      component.set("v.platFormItemvalu.FAF_ID__c", fafid);
      component.set("v.platFormItemvalu.CAG_ID__c", cagid);
      var platFormItemval = component.get("v.platFormItemvalu");
      var action = component.get("c.SavePlaformSpec");
        action.setParams({ "Platformspec" : platFormItemval });
        // Create a callback that is executed after 
        // the server-side action returns
       action.setCallback(this, function(response) {
       var state = response.getState();
            if (state === "SUCCESS") {
                // Alert the user with the value returned 
                // from the server
                var returnval = response.getReturnValue(); 
                if (returnval == 0)
                {
                var NotifySuccess = $A.get("e.c:Required_Highlight"); 
                       	NotifySuccess.setParams({           
                         });
                 NotifySuccess.fire();
                }
			   /*else if(returnval == 1){
                        debugger;
                        var index = component.get("v.indexPlatValue");
     					var uniquerec = index;
                        component.set("v.pItem.error", true);
                        var Carrierid= component.get("v.pItem.platformSpecific.Level_1_Record_ID__r.Carrier_ID__c");
						var Accountid= component.get("v.pItem.platformSpecific.Level_2_ID__c");
						var Groupid= component.get("v.pItem.platformSpecific.Level_3_ID__c");
						var existingMessage ="Error Message: Platform Specifics record already added, please review - ";
						if (Accountid != null && Groupid !=null) {
                 		var consexistingMessage =  existingMessage + 'CARRIER -' + Carrierid + 
                                         	    ' ACCOUNT -' + Accountid + 
                                                ' GROUP -' + Groupid + 
                                                ' PLATFORM -' + platform + 
                                                ' LOB - ' + lob; 
                             }
						if (Accountid  != null && Groupid ==null) {
                  		var consexistingMessage =  existingMessage + ' CARRIER -' + Carrierid + 
                                               ' ACCOUNT -' + Accountid +
                                               ' PLATFORM -' + platform + 
                                               ' LOB - ' + lob; 
                             }
						if (Accountid == null && Carrierid !=null ) {
                    	var consexistingMessage  =  existingMessage + ' CARRIER -' + Carrierid + 
                                               ' PLATFORM -' + platform + 
                                               ' LOB - ' + lob;  
                             }
                       if (Carrierid == null ) {
                    	var consexistingMessage  =  existingMessage + ' CARRIER - NOT SELECTED'  + 
                                               ' PLATFORM -' + platform + 
                                               ' LOB - ' + lob;  
                             }
                        component.set("v.duplicaterow","1"); 	  
                        var Duplicatecheck = $A.get("e.c:Level_Duplicate_Validation"); 
                       	Duplicatecheck.setParams({"message" : consexistingMessage ,
                                                "recordIdentify" : uniquerec,
                                                "iserror" : '1'});
                        Duplicatecheck.fire();
                    }  */
                  else if(returnval == 2){
                        debugger;
                        var index = component.get("v.indexPlatValue");
     					var uniquerec = index;
                        component.set("v.pItem.error", true);
                        var Carrierid= component.get("v.pItem.platformSpecific.Level_1_Record_ID__r.Carrier_ID__c");
						var Accountid= component.get("v.pItem.platformSpecific.Level_2_ID__c");
						var Groupid= component.get("v.pItem.platformSpecific.Level_3_ID__c");
						var existingMessage ="Error Message: LOB is required, please review - ";
						if (Accountid != null && Groupid !=null) {
                 		var consexistingMessage = existingMessage + 'CARRIER -' + Carrierid + 
                                         	    ' ACCOUNT -' + Accountid + 
                                                ' GROUP -' + Groupid + 
                                                ' PLATFORM -' + platform + 
                                                ' LOB - ' + lob; 
                             }
						if (Accountid  != null && Groupid ==null) {
                  		var consexistingMessage = existingMessage +' CARRIER -' + Carrierid + 
                                               ' ACCOUNT -' + Accountid +
                                               ' PLATFORM -' + platform + 
                                               ' LOB - ' + lob; 
                             }
						if (Accountid == null && Carrierid != null) {
                    	var consexistingMessage  =  existingMessage + ' CARRIER -' + Carrierid + 
                                               ' PLATFORM -' + platform + 
                                               ' LOB - ' + lob;  
                             }
                        if (Carrierid == null ) {
                    	var consexistingMessage  =  existingMessage + ' CARRIER - NOT SELECTED'  + 
                                               ' PLATFORM -' + platform + 
                                               ' LOB - ' + lob;  
                             }
                        var LobRequired = $A.get("e.c:LOB_Required"); 
                            LobRequired.setParams({"mode": "sticky",
                            "type": "error",
                            "message":  consexistingMessage});
                        LobRequired.fire();
                    	}  
                
            }
            else if (state === "INCOMPLETE") {
                console.log('INCOMPLETE----- Problem in Platform Record Save');
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors){
                    if(errors[0] && errors[0].message) {
                        var errMsg = "Error message: " + errors[0].message;                       
                        console.log(errMsg); 
                   
                  	if(errMsg.includes('Level')){
                        var index = component.get("v.indexPlatValue");
     					var uniquerec = index;
                        component.set("v.pItem.error", true);
                        var errMsg = "Error: Level 1 is required";
                        var RequiredField = $A.get("e.c:Required_Field"); 
                        RequiredField.setParams({"message" : errMsg ,
                                                "recordIdentify" : uniquerec,
                                                "iserror" : '1'});
                        RequiredField.fire();
                     }
                     else // 11/29 - Added to consider Unhandled Exception scenarios and Enable Save button.
                                    {
                                        var LobRequired = $A.get("e.c:LOB_Required"); 
                                        LobRequired.setParams({"mode": "sticky",
                                                                "type": "error",
                                                                "message":errMsg});
                                        LobRequired.fire();
                                    } // End of Change - Added to consider Unhandled Exception scenarios
                   }
               else {
                   var Carrierid= component.get("v.pItem.platformSpecific.Level_1_Record_ID__r.Carrier_ID__c");
				   var Accountid= component.get("v.pItem.platformSpecific.Level_2_ID__c");
				   var Groupid= component.get("v.pItem.platformSpecific.Level_3_ID__c");
                   var existingMessage ="Problem in Saving Records -";
                   if (Accountid != null && Groupid !=null) {
                 		var consexistingMessage =  existingMessage + 'CARRIER -' + Carrierid + 
                                         	    ' ACCOUNT -' + Accountid + 
                                                ' GROUP -' + Groupid + 
                                                ' PLATFORM -' + platform + 
                                                ' LOB - ' + lob; 
                             }
						if (Accountid  != null && Groupid ==null) {
                  		var consexistingMessage =  existingMessage + ' CARRIER -' + Carrierid + 
                                               ' ACCOUNT -' + Accountid +
                                               ' PLATFORM -' + platform + 
                                               ' LOB - ' + lob; 
                             }
						if (Accountid == null && Carrierid != null) {
                    	var consexistingMessage  =  existingMessage + ' CARRIER -' + Carrierid + 
                                               ' PLATFORM -' + platform + 
                                               ' LOB - ' + lob;  
                             }
                        if (Carrierid == null ) {
                    	var consexistingMessage  =  existingMessage + ' CARRIER - NOT SELECTED'  + 
                                               ' PLATFORM -' + platform + 
                                               ' LOB - ' + lob;  
                             }
                         	            
						var LobRequired = $A.get("e.c:LOB_Required"); 
                        LobRequired.setParams({"mode": "sticky",
                    	"type": "error",
        			 	"message":  consexistingMessage});
                        LobRequired.fire();
                } 
                }}
        });
			
        // $A.enqueueAction adds the server-side action to the queue.
        $A.enqueueAction(action); 
      }
       else {  // For Non Change Records
                var NotifySuccess = $A.get("e.c:Required_Highlight"); 
                       	NotifySuccess.setParams({           
                         });
                 NotifySuccess.fire();
          }
      }
       else {  // For Cancelled Records
                var NotifySuccess = $A.get("e.c:Required_Highlight"); 
                       	NotifySuccess.setParams({           
                         });
                 NotifySuccess.fire();
           }
  },
    
// This function call when the end User Select any record from the Level 2 result list.   
    handleComponentEventlevel2 : function(component, event, helper) {
    // get the selected Carrier record from the COMPONENT event  
        var platformId = component.get("v.pItem.platformSpecific.Id");
        var platform = component.get("v.pItem.platformSpecific.Platform__c");
        var lob = component.get("v.pItem.platformSpecific.LOB__c");
        var ins = component.get("v.pItem.platformSpecific.Instruction__c");
        var level1 = component.get("v.pItem.platformSpecific.Level_1_Record_ID__c");
        var level2 = component.get("v.pItem.platformSpecific.Level_2_record_ID__c");
        var level3 = component.get("v.pItem.platformSpecific.Level_3_record_ID__c");
        var index = component.get("v.indexPlatValue");
        var uniquerec = index;
        component.set("v.recordIdentify", uniquerec);
        var rec = event.getParam("recordIdentify");
        var selectedCarrierGetFromEvent = event.getParam("recordByEvent");
        var level1rec = selectedCarrierGetFromEvent.Id;
        var AccName = selectedCarrierGetFromEvent.Account_Name__c;
        if (uniquerec == rec)
        {
	        component.set("v.pItem.platformSpecific.Level_2_record_ID__c" , selectedCarrierGetFromEvent.Id); 
            component.set("v.pItem.platformSpecific.Level2_Name__c" , AccName); 
            component.set("v.pItem.platformSpecific.Do_not_modify_below_information__c", "CHANGE");
		}
      
	},

// This function call when the end User Select any record from the Level 2 LookupWindow list.   
   handleCarrierWEventlevel2 : function(component,event,helper){  
        var platformId = component.get("v.pItem.platformSpecific.Id");
        var platform = component.get("v.pItem.platformSpecific.Platform__c");
        var lob = component.get("v.pItem.platformSpecific.LOB__c");
        var ins = component.get("v.pItem.platformSpecific.Instruction__c");
        var ins = component.get("v.pItem.platformSpecific.Instruction__c");
        var level1 = component.get("v.pItem.platformSpecific.Level_1_Record_ID__c");
        var level2 = component.get("v.pItem.platformSpecific.Level_2_record_ID__c");
        var level3 = component.get("v.pItem.platformSpecific.Level_3_record_ID__c");
        var index = component.get("v.indexPlatValue");
        var uniquerec = index;
        component.set("v.recordIdentify", uniquerec);
        var rec = event.getParam("recordIdentify");
        var carrier = event.getParam("carrier");
        var carrId = carrier[0].Id;
        var AccName = carrier[0].Account_Name__c;
       if (uniquerec == rec)
        {
	   		component.set("v.pItem.platformSpecific.Level_2_record_ID__c" , carrId); 
            component.set("v.pItem.platformSpecific.Level2_Name__c" , AccName); 
            component.set("v.pItem.platformSpecific.Do_not_modify_below_information__c", "CHANGE");
		}
      
    },

// This function call when the end User Create any Nonvalidated record from the Level 2 list.   
  handleCarrierEventlevel2 : function(component,event,helper){
        var platformId = component.get("v.pItem.platformSpecific.Id");
        var platform = component.get("v.pItem.platformSpecific.Platform__c");
        var lob = component.get("v.pItem.platformSpecific.LOB__c");
        var ins = component.get("v.pItem.platformSpecific.Instruction__c");
        var level1 = component.get("v.pItem.platformSpecific.Level_1_Record_ID__c");
        var level2 = component.get("v.pItem.platformSpecific.Level_2_record_ID__c");
        var level3 = component.get("v.pItem.platformSpecific.Level_3_record_ID__c");
        var index = component.get("v.indexPlatValue");
        var uniquerec = index;
        component.set("v.recordIdentify", uniquerec);
        var rec = event.getParam("recordIdentify");
        var carrier = event.getParam("carrierid");
        var carrId = carrier[0].Id;
        var AccName = carrier[0].Account_Name__c;
        if (uniquerec == rec)
        {
	     component.set("v.pItem.platformSpecific.Level_2_record_ID__c" , carrId); 
         component.set("v.pItem.platformSpecific.Level2_Name__c" , AccName); 
         component.set("v.pItem.platformSpecific.Do_not_modify_below_information__c", "CHANGE");
        }
    },
    
 // Method to handle Account removed from Lookup 2 and update at Item level
    removeCarrierEventlevel2 : function(component,event,helper){
        var platformId = component.get("v.pItem.platformSpecific.Id");
        var platform = component.get("v.pItem.platformSpecific.Platform__c");
        var lob = component.get("v.pItem.platformSpecific.LOB__c");
        var ins = component.get("v.pItem.platformSpecific.Instruction__c");
        var level1 = component.get("v.pItem.platformSpecific.Level_1_Record_ID__c");
        var level2 = component.get("v.pItem.platformSpecific.Level_2_record_ID__c");
        var level3 = component.get("v.pItem.platformSpecific.Level_3_record_ID__c");
        var index = component.get("v.indexPlatValue");
        var uniquerec = index;
        component.set("v.recordIdentify", uniquerec);
        var rec = event.getParam("recordIdentify");
         if (uniquerec == rec)
          {
	        component.set("v.pItem.platformSpecific.Level_2_record_ID__c" , null); 
            component.set("v.pItem.platformSpecific.Level2_Name__c" , null); 
            component.set("v.pItem.platformSpecific.Level_3_record_ID__c" , null); 
            component.set("v.pItem.platformSpecific.Level3_Name__c" , null); 
            component.set("v.pItem.platformSpecific.Do_not_modify_below_information__c", "CHANGE");
		  }
   },
    
// This function call when the end User Select any record from the Level 3 result list.   
    handleComponentEventlevel3 : function(component, event, helper) {
    // get the selected Carrier record from the COMPONENT event  
        var platformId = component.get("v.pItem.platformSpecific.Id");
        var platform = component.get("v.pItem.platformSpecific.Platform__c");
        var lob = component.get("v.pItem.platformSpecific.LOB__c");
        var ins = component.get("v.pItem.platformSpecific.Instruction__c");
        var level1 = component.get("v.pItem.platformSpecific.Level_1_Record_ID__c");
        var level2 = component.get("v.pItem.platformSpecific.Level_2_record_ID__c");
        var level3 = component.get("v.pItem.platformSpecific.Level_3_record_ID__c");
        var index = component.get("v.indexPlatValue");
        var uniquerec = index;
        component.set("v.recordIdentify", uniquerec);
        var rec = event.getParam("recordIdentify");
        var selectedCarrierGetFromEvent = event.getParam("recordByEvent");
        var level1rec = selectedCarrierGetFromEvent.Id;
        var GroupName = selectedCarrierGetFromEvent.Group_Name__c;
        if (uniquerec == rec)
        {
	   	    component.set("v.pItem.platformSpecific.Level_3_record_ID__c" , selectedCarrierGetFromEvent.Id);
            component.set("v.pItem.platformSpecific.Level3_Name__c" , GroupName); 
            component.set("v.pItem.platformSpecific.Do_not_modify_below_information__c", "CHANGE");
		}
      
	},

// This function call when the end User Select any record from the Level 3 LookupWindow list.   
   handleCarrierWEventlevel3 : function(component,event,helper){  
        var platformId = component.get("v.pItem.platformSpecific.Id");
        var platform = component.get("v.pItem.platformSpecific.Platform__c");
        var lob = component.get("v.pItem.platformSpecific.LOB__c");
        var ins = component.get("v.pItem.platformSpecific.Instruction__c");
        var ins = component.get("v.pItem.platformSpecific.Instruction__c");
        var level1 = component.get("v.pItem.platformSpecific.Level_1_Record_ID__c");
        var level2 = component.get("v.pItem.platformSpecific.Level_2_record_ID__c");
        var level3 = component.get("v.pItem.platformSpecific.Level_3_record_ID__c");
        var index = component.get("v.indexPlatValue");
        var uniquerec = index;
        component.set("v.recordIdentify", uniquerec);
        var rec = event.getParam("recordIdentify");
        var carrier = event.getParam("carrier");
        var carrId = carrier[0].Id;
        var GroupName = carrier[0].Group_Name__c;
       if (uniquerec == rec)
        {
	  			 component.set("v.pItem.platformSpecific.Level_3_record_ID__c" , carrId); 
                 component.set("v.pItem.platformSpecific.Level3_Name__c" , GroupName); 
                 component.set("v.pItem.platformSpecific.Do_not_modify_below_information__c", "CHANGE");
		}
      
    },

// This function call when the end User Create any Nonvalidated record from the Level 3 list.   
  handleCarrierEventlevel3 : function(component,event,helper){
        var platformId = component.get("v.pItem.platformSpecific.Id");
        var platform = component.get("v.pItem.platformSpecific.Platform__c");
        var lob = component.get("v.pItem.platformSpecific.LOB__c");
        var ins = component.get("v.pItem.platformSpecific.Instruction__c");
        var level1 = component.get("v.pItem.platformSpecific.Level_1_Record_ID__c");
        var level2 = component.get("v.pItem.platformSpecific.Level_2_record_ID__c");
        var level3 = component.get("v.pItem.platformSpecific.Level_3_record_ID__c");
        var index = component.get("v.indexPlatValue");
        var uniquerec = index;
        component.set("v.recordIdentify", uniquerec);
        var rec = event.getParam("recordIdentify");
        var carrier = event.getParam("carrierid");
        var carrId = carrier[0].Id;
        var GroupName = carrier[0].Group_Name__c;
        if (uniquerec == rec)
        {
	     	component.set("v.pItem.platformSpecific.Level_3_record_ID__c" , carrId); 
            component.set("v.pItem.platformSpecific.Level3_Name__c" , GroupName); 
            component.set("v.pItem.platformSpecific.Do_not_modify_below_information__c", "CHANGE");
        }
    },
 // Handle when User remove Group information from Level 3 Lookup
   removeCarrierEventlevel3 : function(component,event,helper){
        var platformId = component.get("v.pItem.platformSpecific.Id");
        var platform = component.get("v.pItem.platformSpecific.Platform__c");
        var lob = component.get("v.pItem.platformSpecific.LOB__c");
        var ins = component.get("v.pItem.platformSpecific.Instruction__c");
        var level1 = component.get("v.pItem.platformSpecific.Level_1_Record_ID__c");
        var level2 = component.get("v.pItem.platformSpecific.Level_2_record_ID__c");
        var level3 = component.get("v.pItem.platformSpecific.Level_3_record_ID__c");
        var index = component.get("v.indexPlatValue");
        var uniquerec = index;
        component.set("v.recordIdentify", uniquerec);
        var rec = event.getParam("recordIdentify");
         if (uniquerec == rec)
          {
            component.set("v.pItem.platformSpecific.Level_3_record_ID__c" , null); 
            component.set("v.pItem.platformSpecific.Level3_Name__c" , null); 
            component.set("v.pItem.platformSpecific.Do_not_modify_below_information__c", "CHANGE");
          }
   },
   // On Selection of Record for GFRI button. Added by Vishakha 25/6/20
    onChangeOfSelection : function(cmp,event,helper) {
        var  dd = cmp.find("checkboxLeads");
        console.log('dd.get("v.value")>>'+dd.get("v.value"));
        
        cmp.set("v.checkboxGFRI",!dd.get("v.value"));
    },    
    
})