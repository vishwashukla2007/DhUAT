({
    //Added by sonal sharma
    //method to get total number of platform specific records.
    getTotalPlatSpecific:function(cmp,event,helper) {
        var action = cmp.get("c.getTotalPlatformSpecific");
        action.setParams({
              clientId: cmp.get("v.recordId")
         })
         action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                //var count = component.get("v.total");
                
                cmp.set("v.total", response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
    //method to display a combobox with picklist values level 1, level 2 and level 3.
    
    loadComboOptions: function (component, event, helper) {
        var options = [
            {label: 'LEVEL 1 ID', value: 'LEVEL 1 ID'},
            {label: 'LEVEL 2 ID', value: 'LEVEL 2 ID'},
            {label: 'LEVEL 3 ID', value: 'LEVEL 3 ID'},
        ];
        component.set("v.comboOptions", options);
        
  
    },
	
     showHideArrow:function(component,event){
            // console.log("----showHideArrow-----");
        var ifSearchEmpty= component.get('v.ifSearchKey');	
        var ifSortEmpty1=component.get('v.ifSortlevel1');
		var ifSortEmpty2=component.get('v.ifSortlevel2');
		var ifSortEmpty3=component.get('v.ifSortlevel3');
		var ifSortEmpty=component.get('v.ifSort');
       try{
       if(ifSearchEmpty==true ){
             component.set("v.reset","");
            if(ifSortEmpty==true){
			if(ifSortEmpty1==true ){
				 var changeElement = component.find("hideIcon1");
        // by using $A.util.toggleClass add-remove slds-hide class
                 $A.util.addClass(changeElement, "slds-hide");
                }
                if(ifSortEmpty2==true){
                     var changeElement = component.find("hideIcon2");
            // by using $A.util.toggleClass add-remove slds-hide class
                 $A.util.addClass(changeElement, "slds-hide");
                }
                if(ifSortEmpty3==true){
                var changeElement = component.find("hideIcon3");
            // by using $A.util.toggleClass add-remove slds-hide class
                 $A.util.addClass(changeElement, "slds-hide");
                }
       		 }
        }
		else if(ifSortEmpty==true){
			if(ifSortEmpty1==true){
				 var changeElement = component.find("hideIcon1");
        // by using $A.util.toggleClass add-remove slds-hide class
     		 $A.util.addClass(changeElement, "slds-hide");
			}
			if(ifSortEmpty2==true){
				 var changeElement = component.find("hideIcon2");
        // by using $A.util.toggleClass add-remove slds-hide class
     		 $A.util.addClass(changeElement, "slds-hide");
			}
			if(ifSortEmpty3==true){
				 var changeElement = component.find("hideIcon3");
        // by using $A.util.toggleClass add-remove slds-hide class
     		 $A.util.addClass(changeElement, "slds-hide");
			}
		}
            }catch(e){
            //	console.log('error updating arrow');
            }
            
     },
            
     searchKeyChangeMet: function(component, event, sortField) {
		//helper.searchKeyChangeHelper(component);
        var searchKey = component.find("searchKey").get("v.value");
        //var searchKey=component.get("v.key");
        // console.log('searchKey:::::'+searchKey);
        var action = component.get("c.findByCagID");
        action.setParams({
			"clientId": component.get("v.recordId"),
            pageNo: component.get("v.selectedPageNo"),
            "searchCagKey": searchKey,
			"level":component.get("v.levelkey"),
			sortField: sortField,
            'isAsc': component.get("v.isAsc")
        });
        action.setCallback(this, function(response) {													 
             var state = response.getState();
			 // console.log("state ==== "+state);
                if (state === "SUCCESS") {
                    try{
                        var returnedData=response.getReturnValue();
                        // console.log('after response @@@ ');
                        var parseData=JSON.parse(returnedData);
                        console.log('parsedata before parse ');
                        //for page navigation
                        component.set("v.currentPage",parseData.navigatePage);
                        // console.log('parsedata  @@@ ');
                        component.set("v.data", parseData);
                        //for page nvigation
                        //console.log('data.plistsize  ===  '+parseData.pslistsize);
                        //this.loadOptions(component);
                    }catch(e){
                        // console.log("Exception in SearchKeyChange---"+e);
                    }
                     // console.log('data.plistsize  ===  '+parseData.pslistsize);
                     this.loadOptions(component);
                }
				else if (state === "INCOMPLETE") {
                // console.log('INCOMPLETE----- do something');
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        // console.log("Error Message: " + errors[0].message);
                    }
                } else {
                    // console.log("Error in PS");
                }
            }
            //else{
            //    alert('Error in PS'+component.get("v.recordId")+'searchCagKey'+component.find("searchKey").get("v.value")+'level'+component.get("v.levelkey"));
            //}
        });
        $A.enqueueAction(action);
    },
    //end of method added by sonal sharma
   // Method is in use to fetch FAF Account level information to cater requirement to filter CAG based on
   // Account level
    getAccountData : function(component,event,helper) {
        var cinfo = component.get("v.recordId");
        var action = component.get("c.GetFAFInfo");
        action.setParams({ 
            cinfo : cinfo });

        // Create a callback that is executed after the server-side action returns
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                // Alert the user with the value returned 
                // from the server
                try{
                	var dataObj = response.getReturnValue();
                    console.log("From server: " +dataObj);
                    //var datav = JSON.parse(dataObj);
                    component.set("v.AccountId", dataObj);    
                }catch(e){
                    console.log("Invalid Exception---"+e);
                }
                
            }
            else if (state === "INCOMPLETE") {
                console.log('INCOMPLETE----- Problem in Account Data fetch');
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                 errors[0].message);
                    }
                } else {
                    console.log("Unknown error - Problem in Account Data fetch");
                }
            }
        });
        // $A.enqueueAction adds the server-side action to the queue.
        $A.enqueueAction(action);
	},
//Method calls to fetch platform specifics records during initial rendering
	loadData : function(cmp,event) {
	   var action = cmp.get("c.aura_getPlatformSpecificData");
        action.setParams({ 
			clientInfoRecId : cmp.get("v.recordId"), 
			pageNo: cmp.get("v.selectedPageNo")
		});
        
        // Create a callback that is executed after 
        // the server-side action returns
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                // Alert the user with the value returned 
                // from the server
                try{
                	var dataObj = response.getReturnValue();
                    console.log("From server: " +dataObj);
                    
                    var datav = JSON.parse(dataObj);
                    cmp.set("v.currentPage",datav.navigatePage);
                    cmp.set("v.data", datav);   
                    this.loadOptions(cmp);
                }catch(e){
                    console.log("Invalid exception---"+e);
                }
                
            }
            else if (state === "INCOMPLETE") {
                console.log('INCOMPLETE----- do something');
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error Message: " + 
                                 errors[0].message);
                       }
                    } else {
                        console.log("Unknown Error");
                    }
                }
        });
        
        // $A.enqueueAction adds the server-side action to the queue.
        $A.enqueueAction(action);
    },

		//function added by sonal sharma for sort functionality
	sortHelper: function(component, event, sortFieldName) {
        // console.log("-----inside sortHelper-----");
      var currentDir = component.get("v.arrowDirection");
		var ifcallsearch= component.get("v.ifSearchKey");
      if (currentDir == 'arrowdown') {
         // set the arrowDirection attribute for conditionally rendred arrow sign  
         component.set("v.arrowDirection", 'arrowup');
         // set the isAsc flag to true for sort in Assending order.  
         component.set("v.isAsc", true);
      } else {
         component.set("v.arrowDirection", 'arrowdown');
         component.set("v.isAsc", false);
      }
      // call the loadSortedData function for call server side method with pass sortFieldName 
	  //if(ifcallsearch==true){
			this.searchKeyChangeMet(component, event, sortFieldName);
		//}else{
		//	this.loadSortedData(component, event, sortFieldName);
		//}
   },
   
   SortSearchHelper:function(component, event, sortFieldName) {
	   	var ifcallsearch= component.get("v.ifSearchKey");
	   	// console.log("inside sortSearchHelper");
		//if(ifcallsearch==true){
			this.searchKeyChangeMet(component, event, sortFieldName);
		//}else{
		//	this.loadSortedData(component, event, sortFieldName);
		//}
   },

	 
    getClietInfo : function(cmp) {
        var record = cmp.get("v.recordId");
		var action = cmp.get("c.aura_GetClientInfo");
        action.setParams({ clientInfoRecId : cmp.get("v.recordId") });
        
        // Create a callback that is executed after 
        // the server-side action returns
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log('---test-'+response.getReturnValue());
            if (state === "SUCCESS") {
                cmp.set("v.clientInfo", response.getReturnValue());
            }
            else if (state === "INCOMPLETE") {
                console.log('INCOMPLETE----- do something');
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                 errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });

        // $A.enqueueAction adds the server-side action to the queue.
        $A.enqueueAction(action);
	},
        loadNavigation: function(component) {
        var pageNoList = new Array();
        var recordSize = component.get("v.data.navigatePage");
        /*if(recordSize!=null && recordSize!=undefined) {
            var totalPageNos = Math.ceil(recordSize/10);
            for(var i=0; i<totalPageNos; i++) {
                pageNoList.push(i+1);
            }            
        }*/
        component.set('v.currentPage', recordSize);
        },  
    	loadOptions: function(component) {
        var pageNoList = new Array();
        var recordSize = component.get("v.data.pslistsize");
        if(recordSize!=null && recordSize!=undefined) {
            var totalPageNos = Math.ceil(recordSize/100);
            for(var i=0; i<totalPageNos; i++) {
                pageNoList.push(i+1);
            }            
        }
        component.set('v.options', pageNoList);
        component.set('v.TotalPages',totalPageNos);
        component.find("pageNo").set("v.value", component.get("v.currentPage"));
    }, 
    deleteItems : function(component) {
        console.log("--------deleteItems()-----------");
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
        
        var dataStr = JSON.stringify(data);
        console.log("--------deleteItems-------data----"+dataStr);
        var delAction = component.get("c.aura_doDelete");
        delAction.setParams({ jsonData : dataStr });
        delAction.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {                
                var dataObj = response.getReturnValue();               
                console.log("From server: " +dataObj);
                try{
                	var datav = JSON.parse(dataObj);
                    
                    if(datav.isValidSave){
                    	//save went ok
                        this.showToast(component, 'Confirmation Message:Selected record(s) were deleted.');
                    	component.set("v.showNewBtn", true);
        				component.set("v.showEditBtn", true);
                        component.set("v.data", datav);
                    }else{                        
                        //save went not ok, then display toast message
                        this.showToast(component, datav.errorMessage);
                        console.log(datav.errorMessage);
                    }  
                }catch(e){
                    //this.showToast(component,'Error' );
                    console.log("---exception---"+e);
                }
            }
            else if (state === "INCOMPLETE") {
               		var toastEvent = $A.get("e.force:showToast");
        			toastEvent.setParams({
            		message: "Problem in Deleting selected records" ,
           			key: 'info_alt',
           		    type: 'error',
            		mode: 'sticky'
      					  });
        			toastEvent.fire();
                    
            }
            else if (state === "ERROR") {
					 var toastEvent = $A.get("e.force:showToast");
        			toastEvent.setParams({
            		//title : 'Info Message',
            		message: "Problem in Deleting selected records" ,
           			key: 'info_alt',
           		    type: 'error',
            		mode: 'sticky'
      					  });
        			toastEvent.fire();
                    }
           
        });
        $A.enqueueAction(delAction);
    },
    showToast : function(component, messageData) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            //title : 'Info Message',
            message: messageData,
            key: 'info_alt',
            type: 'info',
            mode: 'sticky'
        });
        toastEvent.fire();
    },
    validateLineItem: function(pItem){
        var eDate = pItem.platformSpecific.EffectiveDate__c;
        var pricingEffectiveDate = pItem.pricingEffectiveDate;
        //var val = eDate.split("-");
        //var dayfst = val[2];
        var eDateMsg = '';
        var isInvalidPlatformSpecific = false;
        if(eDate){
            eDate = new Date(eDate);
            //Get the day as a number (1-31)
            var dayfirst = eDate.getDate();
            console.log("-----edate----"+eDate+"---------dayfirst------"+dayfirst);
            if(dayfirst != 1){
                isInvalidPlatformSpecific = true;
                //eDateMsg = "The Platform Specifics Effective Date is not the first day of the month.";
            }
            if(pricingEffectiveDate){
            	pricingEffectiveDate = new Date(pricingEffectiveDate);
                if(eDate > pricingEffectiveDate){
                    isInvalidPlatformSpecific = true;
					//eDateMsg+= " The Platform Specifics Effective Date is earlier than the Pricing Effective Date.";                    
                }
        	}
            return isInvalidPlatformSpecific;
        }
     },
    
 // Below logic to check Sales User Access level and Account Subtype, Checks Controller logic
    getSalesuseraccess : function(component) { 
        var record = component.get("v.recordId");
        var action = component.get("c.getAccountSubtype");
        action.setParams({
            "clientInfoRecId" : record
        })
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
            //debugger
            component.set("v.isSubType", response.getReturnValue()); 
            //this.getProfile(component);  
            // Start of Get Profile information code
               
                 var action = component.get("c.getAccessForSalesUser");
        action.setParams({
             })
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                 component.set("v.isSales", response.getReturnValue());  
                // debugger;
				var profileName = component.get("v.isSales");
        		if (profileName =='1'){
                    component.set("v.isPrintUser", true);
           			 	var effDate = component.get("v.isSubType");
            			if(effDate == '1')
            				{
            					component.set("v.isCreateable", true);
            					component.set("v.isEditable", true);
            					component.set("v.isDeletable", true);
                                var btn = component.get("v.isCreateable");
       							var SalesBtnEvent = $A.get("e.c:ButtonVisibleSales");
        						SalesBtnEvent.setParams({ "btnvisible" : btn });
        						SalesBtnEvent.fire();
           					 }
            			else {
                				component.set("v.isCreateable", false);
            					component.set("v.isEditable", false);
            					component.set("v.isDeletable", false);
                                var btn = component.get("v.isCreateable");
       							var SalesBtnEvent = $A.get("e.c:ButtonVisibleSales");
        						SalesBtnEvent.setParams({ "btnvisible" : btn });
        						SalesBtnEvent.fire();
           					 }
       		 		}
       			if (profileName =='0'){
           
                    component.set("v.isPrintUser", true);
               		 component.set("v.isCreateable", false);
               		 component.set("v.isEditable", false);
               		 component.set("v.isDeletable", false);
                     var btn = component.get("v.isCreateable");
       				 var SalesBtnEvent = $A.get("e.c:ButtonVisibleSales");
        		     SalesBtnEvent.setParams({ "btnvisible" : btn });
        			 SalesBtnEvent.fire();
           
       				}
                if (profileName =='3'){
                     component.set("v.isCreateable", false);
               		 component.set("v.isEditable", false);
               		 component.set("v.isDeletable", false);
                     component.set("v.isOpsUser", true);
                     var btn = component.get("v.isCreateable");
       				 var SalesBtnEvent = $A.get("e.c:ButtonVisibleSales");
        		     SalesBtnEvent.setParams({ "btnvisible" : btn });
        			 SalesBtnEvent.fire();
       				}
                if (profileName =='4'){
                 component.set("v.isPrintUser", true);   
                }
           		 
            }
           if (state ==="ERROR")
            {
                var toastEvent = $A.get("e.force:showToast");
        		toastEvent.setParams({
            	message: 'Problem in Platform Specifics information fetch',
            	key: 'info_alt',
            	type: 'info',
           		mode: 'sticky'
        							});
        		toastEvent.fire();
            }
            
        })
        $A.enqueueAction(action);
                
                
            //      End of Get profile information code      
            }
           if (state ==="ERROR")
           {
                var toastEvent = $A.get("e.force:showToast");
        		toastEvent.setParams({
            	message: 'Problem in Platform Specifics information fetch',
            	key: 'info_alt',
            	type: 'info',
           		mode: 'sticky'
        							});
        		toastEvent.fire();
           }
        })
        $A.enqueueAction(action);   
    },
   // Below method to find if Apttus Sales user and also it checks Account Subtype. Buttons in Platform Specifics are not
   // visible to Sales User with out permission set. Also, Buttons are not visible to Sales user other than three Subtype
   // TPA , Coalition Master 
    getProfile : function(component ) {
        var action = component.get("c.getAccessForSalesUser");
        action.setParams({
             })
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                 component.set("v.isSales", response.getReturnValue());  
               //  debugger;
          	var profileName = component.get("v.isSales");
        		if (profileName =='1'){
           			 	var effDate = component.get("v.isSubType");
            			if(effDate == '1')
            				{
            					component.set("v.isCreateable", true);
            					component.set("v.isEditable", true);
            					component.set("v.isDeletable", true);
           					 }
            			else {
                				component.set("v.isCreateable", false);
            					component.set("v.isEditable", false);
            					component.set("v.isDeletable", false);
           					 }
       		 		}
       			if (profileName =='0'){
           
               		 component.set("v.isCreateable", false);
               		 component.set("v.isEditable", false);
               		 component.set("v.isDeletable", false);
           
       				}
           		 
            }
           if (state ==="ERROR")
            {
                var toastEvent = $A.get("e.force:showToast");
        		toastEvent.setParams({
            	message: 'Problem in Platform Specifics information fetch',
            	key: 'info_alt',
            	type: 'info',
           		mode: 'sticky'
        							});
        		toastEvent.fire();
           }
            
        })
        $A.enqueueAction(action);
    },
        
        // get Selected Platform Specification record - added by Vishakha - 07/06
        getSelectedPlatformSpecifications : function(component, event, helper) {
            var data 			   = component.get("v.data");
            var selectedrecordList = [];
            
            if(data.platformSpecifics.length >= 0) 
            {
                data.platformSpecifics.forEach(function(plts) {  
                    if(plts.isSelected) 
                        selectedrecordList.push(plts.platformSpecific);  
                });
            }
            console.log('selectedrecordList>'+JSON.stringify(selectedrecordList));
            return selectedrecordList; 
        },
            
            // get user role for GFRI
            gfriUserRole : function(component,event,helper){
                var action = component.get("c.getGfriUserRole");
                action.setCallback(this,function(response){
                    var state = response.getState();
                    console.log('state>>'+ state);
                    if(state === "SUCCESS"){
                        var result = response.getReturnValue();
                        component.set("v.isGfriUserRole", result);
                        console.log('result>>'+ JSON.stringify(result));
                    }
                    
                });
                $A.enqueueAction(action);
            },

})