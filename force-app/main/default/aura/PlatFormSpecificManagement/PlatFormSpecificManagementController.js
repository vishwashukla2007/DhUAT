({
  
 //Init method to calls during rendering and fetch plaform specifics information and check if Sales user to
 //make invisible of Buttons
	doInit : function(component, event, helper) 
     {
        var recordid= component.get("v.recordId");
        var uniquesession='fixed'+recordid;
        if (sessionStorage.getItem('pluginBugFixedByReloading') !=uniquesession )
        {
           sessionStorage.setItem('pluginBugFixedByReloading',uniquesession);
          //$A.get('e.force:refreshView').fire();
           window.location.reload(true);
        }
        component.set("v.isFocus",true);
        var currentPage = component.get("v.data.navigatePage");
		helper.loadData(component,event);
        helper.getClietInfo(component);
        helper.getSalesuseraccess(component);
        helper.getTotalPlatSpecific(component);
		helper.loadComboOptions(component);
        helper.gfriUserRole(component);      
	},
   
	 scrollback : function(component, event, helper) 
    {
           component.set("v.isScrollmode",true);
               
    },    
    offfocus : function(component, event, helper) 
        {       
            var isScrollmode =  component.get("v.isScrollmode");
            component.set("v.isFocus",true);
            var appEvent = $A.get("e.c:PlatformSpecific_OFFFocus_Event");
            appEvent.fire();
            
        if (isScrollmode==false)
        {
            var divtarget = component.find("headerdiv");
         	divtarget.scrollTo('custom',0,0);
         	document.getElementById("bodyid").scrollLeft =0;
            document.getElementById("bodyid").scrollRight=0;
        }
               
    },    
     scrollhz : function(component, event, helper) 
    {
         component.set("v.isScrollmode",false);
         component.set("v.isFocus",false);
         var divsourceleft = document.getElementById("bodyid").scrollLeft;
         var divsourceright = document.getElementById("bodyid").scrollRight;
         var divsourcetop = document.getElementById("bodyid").scrollTop;
         var divtarget = component.find("headerdiv");
         divtarget.scrollTo('custom',divsourceleft,divsourcetop);
        var appEvent = $A.get("e.c:PlatformSpecific_OnFocus_Event");
        appEvent.fire();
     
   
    },
	
    handleChange: function (cmp, event) {
        // This will contain the string of the "value" attribute of the selected option
        var selectedOptionValue = event.getParam("value");
		cmp.set("v.levelkey",selectedOptionValue);
        //let disblInput=cmp.find('searchKey').get('v.value');
        cmp.set("v.reset","");
        cmp.set('v.isdisable',false);
        
        //alert('Level Key'+selectedOptionValue);
        //alert("Option selected with value: '" + selectedOptionValue + "'");
    },
	
	searchKeyChange: function(component, event,helper) {
		component.set("v.selectedPageNo", 1);
        component.set('v.ifSearchKey',true);
        var isSorted= component.get("v.ifSort");
        var isL1Sortd= component.get("v.ifSortlevel1");
        var isL2Sortd= component.get("v.ifSortlevel2");
        var isL3Sortd= component.get("v.ifSortlevel3");
        if(isSorted==true){
            console.log('records are already sorted before search');
            if(isL1Sortd==true){
                console.log('level1 is already sorted before search');
                helper.searchKeyChangeMet(component, event, 'Level_1_ID__c');
            }
             if(isL2Sortd==true){
                console.log('level1 is already sorted before search');
                helper.searchKeyChangeMet(component, event, 'Level_2_ID__c');
            }
             if(isL3Sortd==true){
                console.log('level1 is already sorted before search');
                helper.searchKeyChangeMet(component, event, 'Level_3_ID__c');
            }
        }else{
            console.log('in the seachkeychange');
            component.set("v.ifSort",false);
            component.set("v.ifSortlevel1",false);
            component.set("v.ifSortlevel2",false);
            component.set("v.ifSortlevel3",false);
            helper.searchKeyChangeMet(component, event, '');
        }
        component.set("v.currentPage", 1);
        helper.loadOptions(component);
    },
	//end of method added by sonal sharma
	
	//added by sonal sharma for sorting functionality
	sortlevel1: function(component, event, helper) {
        var changeElement = component.find("hideIcon1");
        // by using $A.util.toggleClass add-remove slds-hide class
     	$A.util.removeClass(changeElement, "slds-hide");
        component.set("v.selectedPageNo", 1);
		component.set("v.ifSort",true);
		component.set("v.ifSortlevel1",true);
		component.set("v.ifSortlevel2",false);
		component.set("v.ifSortlevel3",false);
		
		//component.set('v.ifSearchKey',false);
       // set current selected header field on selectedTabsoft attribute.     
       component.set("v.selectedTabsoft", 'Level_1_ID__c');
       // call the helper function with pass sortField Name  
		helper.sortHelper(component, event, 'Level_1_ID__c');
		
    },
 
    sortlevel2: function(component, event, helper) {
        var changeElement = component.find("hideIcon2");
        // by using $A.util.toggleClass add-remove slds-hide class
     	$A.util.removeClass(changeElement, "slds-hide");
        component.set("v.selectedPageNo", 1);
		component.set("v.ifSort",true);
		component.set("v.ifSortlevel2",true);
		component.set("v.ifSortlevel1",false);
		component.set("v.ifSortlevel3",false);
		//component.set('v.ifSearchKey',false);
       // set current selected header field on selectedTabsoft attribute.     
       component.set("v.selectedTabsoft", 'Level_2_ID__c');
       // call the helper function with pass sortField Name  
		helper.sortHelper(component, event, 'Level_2_ID__c');
		
    },
 
    sortlevel3: function(component, event, helper) {
         var changeElement = component.find("hideIcon3");
        // by using $A.util.toggleClass add-remove slds-hide class
     	$A.util.removeClass(changeElement, "slds-hide");
        component.set("v.selectedPageNo", 1);
		component.set("v.ifSortlevel3",true);
		component.set("v.ifSortlevel2",false);
		component.set("v.ifSortlevel1",false);
		component.set("v.ifSort",true);
		//component.set('v.ifSearchKey',false);
       // set current selected header field on selectedTabsoft attribute.     
       component.set("v.selectedTabsoft", 'Level_3_ID__c');
       // call the helper function with pass sortField Name  
		helper.sortHelper(component, event, 'Level_3_ID__c');
		
    },

	//end of method added by sonal sharma
 //Load Platform Specifics using XAE  - 12/06
    loadplatform : function(component, event, helper) {
           var cinfo = component.get("v.recordId");
           var vfhost = component.get("v.vfHost");
           var urlEvent = $A.get("e.force:navigateToURL");
           urlEvent.setParams({
          "url": 'https://' + vfhost + '/apex/Apttus_XApps__EditInExcelLaunch?parentRecordId=' + cinfo +'&appName=Platform_Specifics'
                             });
           urlEvent.fire();
    }, 
 //Print Platform Specifics using XAE  - 7/22
    printplatform : function(component, event, helper) {
           var cinfo = component.get("v.recordId");
           var vfhost = component.get("v.vfHost");
           var urlEvent = $A.get("e.force:navigateToURL");
           urlEvent.setParams({
          "url": 'https://' + vfhost + '/apex/Apttus_XApps__EditInExcelLaunch?parentRecordId=' + cinfo +'&appName=AttachExcelToFAF'
                             });
           urlEvent.fire();
    },  
    exportplatform : function(component, event, helper) {   // Open Report to Download Excel
           var cinfo = component.get("v.recordId");
           var vfhost = component.get("v.vfHost");
           var cInfo = component.get("v.clientInfo");
           var fafid = cInfo.FAF_ID__c;
           var faf = fafid.substring(0, 15);
           var reporturl = $A.get("$Label.c.Print_Report_URL") + faf;
           window.open(reporturl);
    },  
  // Handel Cancel Button logic and it shows New , Edit Button and fetch records from server
    handleCancle: function(component, event, helper){
        // console.log("-------handleCancel()------");
        component.set("v.showNewBtn", true);
        component.set("v.showEditBtn", true);
        component.set("v.isEditMode", false);
        helper.loadData(component);
        helper.showHideArrow(component);
       /* var cmpTarget1 = component.find('checkbox');
        $A.util.addClass(cmpTarget1, 'slds-cell-fixed'); 
        var cmpTarget2 = component.find('link');
        $A.util.addClass(cmpTarget2, 'slds-cell-fixed'); 
        var cmpTarget3 = component.find('platform');
        $A.util.addClass(cmpTarget3, 'slds-cell-fixed'); 
        var cmpTarget4 = component.find('lob');
        $A.util.addClass(cmpTarget4, 'slds-cell-fixed'); 
        var cmpTarget5 = component.find('instruction');
        $A.util.addClass(cmpTarget5, 'slds-cell-fixed'); 
        var cmpTarget6 = component.find('level1id');
        $A.util.addClass(cmpTarget6, 'slds-cell-fixed'); 
        var cmpTarget7 = component.find('level1name');
        $A.util.addClass(cmpTarget7, 'slds-cell-fixed'); */
        
    },
    handleNext: function(component, event, helper){
        component.set("v.showNewBtn", true);
        component.set("v.showEditBtn", true);
        component.set("v.isEditMode", false);
        helper.loadData(component);
    },
  // Handel New Button and it create new row in Lightning Data table
    handleNewBtn : function(component, event, helper) {
        component.set("v.showNewBtn", true);
        component.set("v.showEditBtn", false);
        var dataObj = component.get("v.data");
        var newObj = JSON.parse(JSON.stringify(dataObj.newPlatFormSpecificItem));
        var cinfoDate = component.get("v.clientInfo.Pricing_Effective_Date__c"); 
        if(cinfoDate){
            newObj.platformSpecific.EffectiveDate__c =  cinfoDate;
        }  
        var appEvent = $A.get("e.c:PlaformSpecificNewAction_Event");
        appEvent.fire();
           /* var cmpTarget1 = component.find('checkbox');
            $A.util.removeClass(cmpTarget1, 'slds-cell-fixed'); 
       	    var cmpTarget2 = component.find('link');
            $A.util.removeClass(cmpTarget2, 'slds-cell-fixed'); 
            var cmpTarget3 = component.find('platform');
            $A.util.removeClass(cmpTarget3, 'slds-cell-fixed'); 
            var cmpTarget4 = component.find('lob');
            $A.util.removeClass(cmpTarget4, 'slds-cell-fixed'); 
            var cmpTarget5 = component.find('instruction');
            $A.util.removeClass(cmpTarget5, 'slds-cell-fixed'); 
            var cmpTarget6 = component.find('level1id');
            $A.util.removeClass(cmpTarget6, 'slds-cell-fixed'); 
            var cmpTarget7 = component.find('level1name');
            $A.util.removeClass(cmpTarget7, 'slds-cell-fixed');
            $A.util.removeClass(cmpTarget1, 'checkbox'); 
            $A.util.addClass(cmpTarget1, 'checkboxedit'); 
            $A.util.removeClass(cmpTarget2, 'link'); 
            $A.util.addClass(cmpTarget2, 'linkedit'); 
            $A.util.removeClass(cmpTarget3, 'platform'); 
            $A.util.addClass(cmpTarget3, 'platformedit'); 
            $A.util.removeClass(cmpTarget4, 'lob'); 
            $A.util.addClass(cmpTarget4, 'lobedit');
            $A.util.removeClass(cmpTarget5, 'instruction'); 
            $A.util.addClass(cmpTarget5, 'instructionedit');
            $A.util.removeClass(cmpTarget6, 'level1id'); 
            $A.util.addClass(cmpTarget6, 'level1idedit');
            $A.util.removeClass(cmpTarget7, 'level1name'); 
            $A.util.addClass(cmpTarget7, 'level1nameedit');*/

        console.log("---newobj---"+JSON.stringify(newObj));
        dataObj.platformSpecifics.push(newObj);
        component.set("v.data", dataObj);
        helper.getAccountData(component);
	 },
  // Edit Button Logic, It sets Boolean valriable to show PlatformItem records at Edit mode
  // Flag is in use in markup to show editable list or readonly information
	handleEditBtn : function(component, event, helper) {
        var data = component.get("v.data");
        var itamsCount = data.platformSpecifics.length;
        console.log("itamsCount:"+itamsCount);
        if(data.platformSpecifics.length <= 0){
            return;
        }
        component.set("v.showEditBtn", false);
        component.set("v.showNewBtn", false);
        component.set("v.isEditMode", true);
        helper.getAccountData(component);
        var acct = component.get("v.AccountId");
          /*  var cmpTarget1 = component.find('checkbox');
            $A.util.removeClass(cmpTarget1, 'slds-cell-fixed'); 
            $A.util.removeClass(cmpTarget1, 'checkbox'); 
            $A.util.addClass(cmpTarget1, 'checkboxedit'); 
       	    var cmpTarget2 = component.find('link');
            $A.util.removeClass(cmpTarget2, 'slds-cell-fixed'); 
            $A.util.removeClass(cmpTarget2, 'link'); 
            $A.util.addClass(cmpTarget2, 'linkedit'); 
            var cmpTarget3 = component.find('platform');
            $A.util.removeClass(cmpTarget3, 'slds-cell-fixed'); 
            $A.util.removeClass(cmpTarget3, 'platform'); 
            $A.util.addClass(cmpTarget3, 'platformedit'); 
            var cmpTarget4 = component.find('lob'); 
            $A.util.removeClass(cmpTarget4, 'slds-cell-fixed'); 
            $A.util.removeClass(cmpTarget4, 'lob'); 
            $A.util.addClass(cmpTarget4, 'lobedit');
            var cmpTarget5 = component.find('instruction');
            $A.util.removeClass(cmpTarget5, 'slds-cell-fixed'); 
            $A.util.removeClass(cmpTarget5, 'instruction'); 
            $A.util.addClass(cmpTarget5, 'instructionedit');
            var cmpTarget6 = component.find('level1id');
            $A.util.removeClass(cmpTarget6, 'slds-cell-fixed'); 
            $A.util.removeClass(cmpTarget6, 'level1id'); 
            $A.util.addClass(cmpTarget6, 'level1idedit');
            var cmpTarget7 = component.find('level1name');
            $A.util.removeClass(cmpTarget7, 'slds-cell-fixed');
            $A.util.removeClass(cmpTarget7, 'level1name'); 
            $A.util.addClass(cmpTarget7, 'level1nameedit');
            var cmpTarget8 = component.find('level2id');
            $A.util.removeClass(cmpTarget8, 'level2id'); 
            $A.util.addClass(cmpTarget8, 'level2idedit');
            var cmpTarget9 = component.find('level3id');
            $A.util.removeClass(cmpTarget9, 'level3id'); 
            $A.util.addClass(cmpTarget9, 'level3idedit');
            var cmpTarget10 = component.find('effectivedate');
            $A.util.removeClass(cmpTarget10, 'effectivedate'); 
            $A.util.addClass(cmpTarget10, 'effectivedateedit');
            var cmpTarget11 = component.find('termed');
            $A.util.removeClass(cmpTarget11, 'termed'); 
            $A.util.addClass(cmpTarget11, 'termededit');
            var cmpTarget12 = component.find('editdetails');
            $A.util.removeClass(cmpTarget12, 'editdetails'); 
            $A.util.addClass(cmpTarget12, 'editdetailsedit');
            var cmpTarget13 = component.find('termeddate');
            $A.util.removeClass(cmpTarget13, 'termeddate'); 
            $A.util.addClass(cmpTarget13, 'termeddateedit'); */
	},
  // Save Button is use to call set different Bollean flags which make invisible to Buttons and also
  // fire events to send signalat PlatformItem component, it use each records and validate, save records
  // Once save, Save and Cancel Buttons are not visible 
	handleSaveBtn : function(component, event, helper) {
        component.set("v.isEditMode", true);
        component.set("v.isSaveError", false);
        component.set("v.counter" , "0");
        var allSpecificItems = component.get("v.data.platformSpecifics");
        var itemscount = allSpecificItems.length;
        component.set("v.itemscount",itemscount);
        var isInvalidItem = false;
        for(var i = 0; i< itemscount; i++){
            var pItem = allSpecificItems[i];
            if(pItem.isNewDelete){
                //new Item deleted, then continue with next item
                continue;
            }
            if(pItem.isSelected){
                //This is selected for delete
                continue;
            }
            isInvalidItem = helper.validateLineItem(pItem);
            if(isInvalidItem){
               // alert("Please check all Platform Specifics Effective Date messages.");
               // return;
            }
        }
        
        console.log("--------------isInvalidItems---------"+isInvalidItem);
        if(isInvalidItem){
            console.log("-----Having invalid items due to Effective date---------");
           // alert("Please check Effective Date validation.");
           // return;
        }
        var isNewSave = component.get("v.showNewBtn");
        var isEditSave = component.get("v.showEditBtn");
        var data = component.get("v.data");
        
        var itamsCount = data.platformSpecifics.length;
        helper.showHideArrow(component);
        console.log("itamsCount:"+itamsCount);
        if(data.platformSpecifics.length <= 0){
            component.set("v.isEditMode", false);
            
             var cmpTarget1 = component.find('checkbox');
        $A.util.addClass(cmpTarget1, 'slds-cell-fixed'); 
        var cmpTarget2 = component.find('link');
        $A.util.addClass(cmpTarget2, 'slds-cell-fixed'); 
        var cmpTarget3 = component.find('platform');
        $A.util.addClass(cmpTarget3, 'slds-cell-fixed'); 
        var cmpTarget4 = component.find('lob');
        $A.util.addClass(cmpTarget4, 'slds-cell-fixed'); 
        var cmpTarget5 = component.find('instruction');
        $A.util.addClass(cmpTarget5, 'slds-cell-fixed'); 
        var cmpTarget6 = component.find('level1id');
        $A.util.addClass(cmpTarget6, 'slds-cell-fixed'); 
        var cmpTarget7 = component.find('level1name');
        $A.util.addClass(cmpTarget7, 'slds-cell-fixed');
            
            return;
        }
        else
        {
            component.set("v.disabled", true);
        }
        	var evtFire = $A.get("e.c:Level_Save_ChangeValue");
        	evtFire.fire();
        	helper.getTotalPlatSpecific(component);
        
        
            //component.set("v.total", itamsCount);
        
	},    
// CAG Search method is in use to set flag which opens SDG Modal window in lightning Grid, It fetches
// CAG information by default filtered on FAF Account
    cagSearch : function (component, event, helper) {
        var cInfo = component.get("v.clientInfo");  
        var url = '/lightning/n/CAG_Search1?id='+cInfo.Id+'&FAFId='+cInfo.FAF_ID__c;
        //window.open(url); No need, It changed to Modal window
       component.set("v.isPopUp",true);
       
    },  
  // Method to set flag which in use to hide CAG Search Modal window
     hideSearch : function (component, event, helper) {
       component.set("v.isPopUp",false);
    },
  // Method to capture Event fired from CAG Search and its close
     eventSearch : function (component, event, helper) {
       component.set("v.isPopUp",false);
       //helper.loadData(component);
        var currentPage = component.get("v.data.navigatePage");
        component.set("v.selectedPageNo", 1);
        helper.loadData(component);
        component.set("v.currentPage", 1);
        helper.loadOptions(component);
    },
  // Method to handel Cancel Button from Multi Delete dialog box/confirmation window
    cancel: function(component, event, helper) {
        // console.log("---------Cancel()-------");
    	$A.util.addClass(component.find("multideletedialogs"), "slds-hide");    
    
  },
  // Method to handel Delete functionality when user confirm after Delete 
    handleDelete: function(component, event, helper){
        console.log("---------handleDelete()-----------");
        var data = component.get("v.data");
        var itamsCount = data.platformSpecifics.length;
        console.log("itamsCount:"+itamsCount);
        var selectedrecords = 0;
        if(data.platformSpecifics.length <= 0){
            return;
        } else {
            for(var i=0;i<data.platformSpecifics.length;i++) {
                if(data.platformSpecifics[i].isSelected) {
                    selectedrecords++;
                }
            }
        }
        if(!selectedrecords) {
                    var toastEvent = $A.get("e.force:showToast");
        			toastEvent.setParams({
            		message: "No record selected!, Please select record(s) to Delete" ,
           			key: 'info_alt',
           		    type: 'error',
            		mode: 'sticky'
      					  });
        			toastEvent.fire();
                    return;
        }
    	$A.util.removeClass(component.find("multideletedialogs"), "slds-hide");
        helper.getTotalPlatSpecific(component);
        // helper.showHideArrow(component);
        
    },
  // Method to handel when user clicks Delete Button to remove platform specific information.
  // It call Helper method to perform server operation
    handleDeleteBtn: function(component, event, helper){
        console.log("---------handleDeleteBtn()-----------");
        helper.deleteItems(component);
        $A.util.addClass(component.find("multideletedialogs"), "slds-hide");
        var isfocusvalue = component.get("v.isFocus");
        if (isfocusvalue == true)
        component.find("massCheckbox1").set("v.value", false);
        else
        component.find("massCheckbox2").set("v.value", false);    
        helper.getTotalPlatSpecific(component);
        helper.showHideArrow(component);
    },
  //Method to handel Event fired from PlatformItem level when it encounters error at individual record, It register 
  //Error at PlatformManagement component level
    RequiredHighlight: function(component, event, helper) 
       {
           component.set("v.isSaveError" , true);
           var counter= component.get("v.counter");
           var counter= ++counter;
           component.set("v.counter" , counter);
           component.set("v.disabled", false);
       },
  //Method to handel Event fired from PlatformItem level when it encounters success of individual record, It register 
  //Success at PlatformManagement component level. It set the flag if all records are success
    NotifySuccess: function(component, event, helper) 
       {
           //debugger;
           var counter= component.get("v.counter");
           var counter= ++counter;
           component.set("v.counter" , counter);
           var isSaveError = component.get("v.isSaveError");
           if (isSaveError = false) {
               component.set("v.isSaveError" , false); }
                   var isSaveError = component.get("v.isSaveError");
       	   var itemscount = component.get("v.itemscount");
          if (counter == itemscount) {
         	if (isSaveError == false)
       		 {
       		 component.set("v.isEditMode", false);
                 component.set("v.selectedPageNo",1);
             helper.loadData(component);
        	 component.set("v.showNewBtn", true);
             component.set("v.showEditBtn", true);
            
        	}    component.set("v.disabled", false);                    }
            helper.showHideArrow(component); 
       },
  //Method to Handel Event which fired when Duplicate scenario happens, It display Toast message
  //for Duplicate records with CAG , Platform information 
    DuplicateCheck: function(component, event, helper) 
       {   var Errormessage= event.getParam("message");
           component.set("v.isSaveError" , true);
           component.set("v.disabled", false);
           var toastEvent = $A.get("e.force:showToast");
    	   toastEvent.setParams({
       				 "mode": "sticky",
                     "type": "error",
        			 "message": Errormessage
    							});
    		toastEvent.fire();
       },
  //Method to Handel Event which fired when LOB is required happens, It display Toast message
  //for LOB requied scenario 
    LobRequired:function(component, event, helper) {
        var consexistingMessage= event.getParam("message");
        component.set("v.disabled", false);
        component.set("v.isSaveError" , true);
        var toastEvent = $A.get("e.force:showToast");
    	      			toastEvent.setParams({
       					 "mode": "sticky",
                    	 "type": "error",
        			 	"message":  consexistingMessage
    							});
    		         	toastEvent.fire();
    },
 //Loads Platform Specifics record and call helper method
    LoadPlatformSpecific: function(component, event, helper){
         var data = component.get("v.data");       
        var itamsCount = data.platformSpecifics.length;
        console.log("itamsCount:"+itamsCount);
        var counter=0;
        if(data.platformSpecifics.length <= 0){
            for(var i=0; i<data.platformSpecifics.length; i++) {
                console.log(data.platformSpecifics[i])
                /*if(data.platformSpecifics[i].error) {
                	counter++;
                }*/
            }
        }
        if(!counter) {
          
           helper.loadData(component); 

        }
        
    },
 //Method is in use for Delete and Multi Delete functionality
    selectAllUnticked:function (component, event, helper) {
        //debugger;
        var cmpEvent = component.find("compB");
        var checkbox = event.getSource();
		var checked1 = checkbox.get("v.value");
        if(cmpEvent!=undefined && checked1!=undefined){
            if(cmpEvent.length==undefined)
            	{ cmpEvent.sampleMethod(checked1);
                } 
            else {var j=cmpEvent.length;
                     for(var i = 0;i < j;i++){
                       cmpEvent[i].sampleMethod(checked1);
                     }
            }
        } 
        //Added for GFRI button by Vishakha
        component.find("creategfri").set("v.disabled",false);
    },
        
    loadPageData : function(component, event, helper) {
		var searchLevelKey = component.find("searchKey").get("v.value");
        component.set("v.selectedPageNo", event.getSource().get("v.value"));
         //component.set("v.currentPage", event.getSource().get("v.value"));
        console.log('searchLevelKey= '+searchLevelKey);
                console.log('searchLevelKey= '+searchLevelKey);
       	var ifSearchEmpty= component.get('v.ifSearchKey');
		var ifSortEmpty1=component.get('v.ifSortlevel1');
		var ifSortEmpty2=component.get('v.ifSortlevel2');
		var ifSortEmpty3=component.get('v.ifSortlevel3');
		var ifSortEmpty=component.get('v.ifSort');
        //var NavigatePage=currentPage+1;
        console.log('@@@ifSearchEmpty  '+ ifSearchEmpty);
        if(ifSearchEmpty==true && ifSortEmpty==false){
            console.log('should call searchKeyChange ');
            helper.searchKeyChangeMet(component);
        }
		else if(ifSortEmpty==true){
			if(ifSortEmpty1==true){
				helper.SortSearchHelper(component, event, "Level_1_ID__c");
			}
			if(ifSortEmpty2==true){
				//$A.enqueueAction(component.get('c.sortlevel2'));
				helper.SortSearchHelper(component, event, "Level_2_ID__c");
			}
			if(ifSortEmpty3==true){
				//$A.enqueueAction(component.get('c.sortlevel3'));
				helper.SortSearchHelper(component, event, "Level_3_ID__c");
			}
		}
        else{
            // console.log('should call loadData ');
            helper.loadData(component);
        }
    },
    loadPageDataNext : function(component, event, helper) {
        var searchLevelKey = component.find("searchKey").get("v.value");
        //console.log('searchlevel key is ==='+searchLevelKey);
		var ifSearchEmpty= component.get('v.ifSearchKey');
        //var NavigatePage=currentPage+1;
        //console.log('@@@ifSearchEmpty  '+ ifSearchEmpty);
		var ifSortEmpty1=component.get('v.ifSortlevel1');
		var ifSortEmpty2=component.get('v.ifSortlevel2');
		var ifSortEmpty3=component.get('v.ifSortlevel3');
		var ifSortEmpty=component.get('v.ifSort');
        //var NavigatePage=currentPage+1;
        //console.log('@@@ifSearchEmpty  '+ ifSearchEmpty);
        
        var currentPage = component.get("v.data.navigatePage");
		component.set("v.selectedPageNo",currentPage+1);
        if(ifSearchEmpty==true && ifSortEmpty==false){
            //console.log('should call searchKeyChange ');
            helper.searchKeyChangeMet(component);
        }
		else if(ifSortEmpty==true){
			if(ifSortEmpty1==true){
				//$A.enqueueAction(component.get('c.sortlevel1'));
				//this.sortlevel1(component,event,helper);
				helper.SortSearchHelper(component, event, "Level_1_ID__c");
			}
			if(ifSortEmpty2==true){
				//$A.enqueueAction(component.get('c.sortlevel2'));
				helper.SortSearchHelper(component, event, "Level_2_ID__c");
			}
			if(ifSortEmpty3==true){
				//$A.enqueueAction(component.get('c.sortlevel3'));
				helper.SortSearchHelper(component, event, "Level_3_ID__c");
			}
		}
        else{
        //console.log('should call loadData ');
        helper.loadData(component);
        }
        
        component.set("v.currentPage", currentPage+1);
        helper.loadOptions(component);
    },
    loadPageDataPrev : function(component, event, helper) {
        var currentPage = component.get("v.data.navigatePage");
		var ifSearchEmpty= component.get('v.ifSearchKey');
       // var NavigatePage=currentPage-1;
        //console.log('@@@ifSearchEmpty  '+ ifSearchEmpty);
		var ifSortEmpty1=component.get('v.ifSortlevel1');
		var ifSortEmpty2=component.get('v.ifSortlevel2');
		var ifSortEmpty3=component.get('v.ifSortlevel3');
		var ifSortEmpty=component.get('v.ifSort');
        //var NavigatePage=currentPage+1;
		component.set("v.selectedPageNo",currentPage-1);
        
       if(ifSearchEmpty==true && ifSortEmpty==false){
          //  console.log('should call searchKeyChange ');
            helper.searchKeyChangeMet(component);
        }
		else if(ifSortEmpty==true){
			if(ifSortEmpty1==true){
				//$A.enqueueAction(component.get('c.sortlevel1'));
				//this.sortlevel1(component,event,helper);
				helper.SortSearchHelper(component, event, "Level_1_ID__c");
			}
			if(ifSortEmpty2==true){
				//$A.enqueueAction(component.get('c.sortlevel2'));
				helper.SortSearchHelper(component, event, "Level_2_ID__c");
			}
			if(ifSortEmpty3==true){
				//$A.enqueueAction(component.get('c.sortlevel3'));
				helper.SortSearchHelper(component, event, "Level_3_ID__c");
			}
		}
        else{
        //console.log('should call loadData ');
        helper.loadData(component);
        }
        //var currentPage = component.get("v.data.navigatePage");
		//component.set("v.selectedPageNo",currentPage-1);
        component.set("v.currentPage", currentPage-1);
        helper.loadOptions(component);
    
        
	
    },
    
    //Create GFRI Record - 04/06 - Added by Vishakha
    createGfriBtn : function(component, event, helper) {
        var data = component.get("v.data");
        var toastEvent = $A.get("e.force:showToast");
        // disabled button
        component.find("creategfri").set("v.disabled",true);
		toastEvent.setParams({
                        mode: 'pester',
                        type: 'info',
                        message: 'Processing, Please wait...'
                    });
                    toastEvent.fire();
        console.log("data: new "+data);
        
        var selectedRecords = helper.getSelectedPlatformSpecifications(component,event,helper);
        console.log('selectedrecords>>'+JSON.stringify(selectedRecords));
        
        if(selectedRecords !=null 
           && selectedRecords !='undefined' 
           && selectedRecords !=''
           )
        {
            console.log("In getGfriData cmp");
            var toastEvent = $A.get("e.force:showToast");
            var action = component.get("c.getGfriData");
            console.log("Component1");            
            action.setParams({
                clientId: component.get("v.recordId"),
                platformSpecifics : JSON.stringify(component.get("v.data"))
            })
            action.setCallback(this, function(response){
                var state = response.getState();
                if (state === "SUCCESS") {                
                    var result = response.getReturnValue();
                    
                    console.log("Component2" + JSON.stringify(result));
                    console.log("result.Id" + result[0].Id);
                    toastEvent.setParams({
                        mode: 'pester',
                        title: 'Success:',
                        type: 'success',
                        message: 'GFRI Created'
                    });
                    toastEvent.fire();
                    var navEvt = $A.get("e.force:navigateToSObject");
                    navEvt.setParams({
                        "recordId": result[0].Id
                    });
                    navEvt.fire();
                }
                else if (state === "ERROR") {
                    let errors = response.getError();
                    let message = 'Unknown error'; // Default error message
                    // Retrieve the error message sent by the server
                    if (errors && Array.isArray(errors) && errors.length > 0) {
                        message = errors[0].message.includes("Attempt to de-reference a null object")?"Invalid Data: Please check the Carrier Id on Mac Validation Lookup and Level 1 Id is matching":errors[0].message;
                        toastEvent.setParams({
                            mode: 'pester',
                            title: 'Error:',
                            type: 'error',
                            message: message
                        });
                        toastEvent.fire();
                    }
                    
                    console.log('error>>'+ message);
                    // Display the message
                    console.error(message);
                    // Process error returned by server
                   
                    // show button
       				component.set("v.checkboxGFRI",false);
                }
            });
            $A.enqueueAction(action);
        }
    }, 
    
    // Set the visibility of GFRI button on record selection.
    onchangeOnRecordSelection : function(cmp,event,helper){
        var  completeData = cmp.get("v.data");
      	console.log('isGfriUserRole>>'+cmp.get("v.isGfriUserRole"));
        if(completeData !=null 
           && completeData !='undefined' 
           && completeData !=''
           && cmp.get("v.isGfriUserRole") 
           ) 
        {
            var count = 0;
            completeData.platformSpecifics.forEach(function plfs(selRec) {
                if(selRec.isSelected) {
                    count++;
                }
            });
            console.log('count>>'+count);
            
            cmp.find("creategfri").set("v.disabled",count === 0);
            cmp.set("v.checkboxGFRI",count === 0);
    	}
    }
    
})