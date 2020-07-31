/*
 * Copyright (c) 2018, salesforce.com, inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */
({
    doInit: function(component, event, helper) {
       if(component.get("v.extraFilterFromCag")=='Filter'){	// enabled clear filter for Via CAG Search display all CAG Records by Preetham
       component.set("v.EnableClearFilter", false);


       }
        var TargetSize = component.get("v.width");
        var DisableResponsive = component.get("v.PreventResponsiveness");
        
        if (DisableResponsive) {
            TargetSize = "LARGE";
        } else {
            if (TargetSize === undefined) {
                var formFactor = $A.get("$Browser.formFactor");
                
                TargetSize = "MEDIUM";
                if (formFactor === "PHONE") {
                    TargetSize = "SMALL";
                }
                if (formFactor === "DESKTOP") {
                    TargetSize = "LARGE";
                }
            }
        }
        
        component.set("v.TargetSize", TargetSize);
        
        if (TargetSize === "LARGE") component.set("v.filtersize", 4);
        if (TargetSize === "MEDIUM") component.set("v.filtersize", 6);
        if (TargetSize === "SMALL") component.set("v.filtersize", 12);
        
        component.set("v.TitleName", component.get("v.Title"));
        helper.getSDG(component);
        helper.getNamespace(component);
    },
    handleObjectManagerEvent: function(component, event, helper) {},
    paging: function(component, event, helper) {
        component.set("v.isPaging", true);
        helper.getResponseData(component);
    },
    CreateNew: function(component, event, helper) {
        var navEvt = $A.get("e.force:createRecord");
        
        var objname = component.get("v.SDG").sObjectName;
        navEvt.setParams({
            entityApiName: objname,
            recordTypeId: null
        });
        navEvt.fire();
    },
    reload: function(component, event, helper) {

        component.set("v.reloadseed", Date.now());
        helper.getResponseData(component);
    },
    filterUpdated: function(component, event, helper) {

        component.set("v.ShowSDGError", false);
        var filters = component.get("v.SDGFilters");
        var filterlistlength = filters.length;
        var newfilters = [];
        var newSDGFieldID = event.getParam("SDGFieldID");
        
        // create a map to deduplicate here...
        for (var i = 0; i < filterlistlength; i++) {
            if (filters[i].SDGFieldID !== newSDGFieldID) {
                newfilters.push(filters[i]);
            }
        }
        
        //Add the new value:
        var newfilter = {
            FilterValue: event.getParam("FilterValue"),
            FilterOperator: event.getParam("FilterOperator"),
            SDGFieldID: event.getParam("SDGFieldID")
        };
        
        var dtatemp=component.get("v.SDGFiltersDefinition");

    
         console.log(event.getParam("SDGFieldID"));
        for (var i = 0; i < dtatemp.length; i++) {
  

                if(dtatemp[i].ID==event.getParam("SDGFieldID")){  // passing the fieldvalue if we have alredy for filter, getting this value from sdgFilet component
                    console.log(dtatemp[i].ID);
                    dtatemp[i].Preferences=newfilter; 
                }
            
        }

        component.set("v.SDGFiltersDefinition", dtatemp);
        newfilters.push(newfilter);
        var enable=true;
        for (var i = 0; i < newfilters.length; i++) {
            if(newfilters[i].FilterValue!=null && newfilters[i].FilterValue!='' && newfilters[i].FilterValue && newfilters[i].FilterValue.length>0)
                enable= false;// checking for the filter 
            
        } 
        component.set("v.SDGFilters", newfilters);
        component.set("v.EnableClearFilter", enable);// enabling clear filter button if any filter is there otherwise disabled 
        helper.AddToLog(component, "Filters updated");
        helper.getResponseData(component);
    },
    handleSort: function(cmp, event, helper) {
        var val = event.getParam("value");
        var vals = val.split(":");
        cmp.set("v.SortColumn", vals[0]);
        cmp.set("v.SortOrder", vals[1]);
        helper.getResponseData(cmp);
    },
    sort: function(component, event, helper) {
        component.set("v.SortColumn", event.getParam("SDGFieldID"));
        component.set("v.SortOrder", event.getParam("SortOrder"));
        helper.getResponseData(component);
    },
    ClearFilters: function(component, event, helper) {
        var filters = component.find("cmpFilter");
        
        if (filters) {
            var filterlistlength = filters.length;
            
            // clear the values
            for (var i = 0; i < filterlistlength; i++) {
                filters[i].set("v.FilterValue", "");
            }
            
            helper.AddToLog(component, "Filters cleared");
        }
    },
    checkboxchange: function(component, event, helper) {
        var idlist = component.get("v.CheckedRowIDs");
        if (event.getSource().get("v.checked")) {
            idlist.push(event.getSource().get("v.value"));
        } else {
            var index = idlist.indexOf(event.getSource().get("v.value"));
            idlist.splice(index, 1);
        }
        component.set("v.CheckedRowIDs", idlist);
    },
    ToggleDebug: function(component, event, helper) {
        var cmpTarget = component.find("debuglogpanel");
        
        $A.util.toggleClass(cmpTarget, "debugsize");
    },
    ToggleFilters: function(component, event, helper) {
        //Determine whether to show the filters:
        var FiltersSet = component.get("v.SDGFiltersDefinition");
        if (FiltersSet.length === 0) {

            var SDGObject = component.get("v.SDG");
            component.set("v.SDGFiltersDefinition", SDGObject.SDGFields);
        }
        
        var newvalue = !component.get("v.ShowFilters");
        var cmpTarget = component.find("FilterToggle");
        
        if (newvalue) {
            $A.util.addClass(cmpTarget, "slds-is-selected");
            $A.util.removeClass(cmpTarget, "slds-not-selected");
        } else {
            $A.util.removeClass(cmpTarget, "slds-is-selected");
            $A.util.addClass(cmpTarget, "slds-not-selected");
        }
        component.set("v.ShowFilters", newvalue);
    },
    CheckAll: function(component, event, helper) {
        //var idlist = component.get("v.CheckedRowIDs");
        
        var idlist = [];
        var checkboxes = component.find("checkrow");
        var checkboxeslength = (checkboxes!=undefined)?checkboxes.length:0;
        var targetstate = event.getSource().get("v.checked");
        for (var i = 0; i < checkboxeslength; i++) {
            checkboxes[i].set("v.checked", targetstate);
            idlist.push(checkboxes[i].get("v.value"));
        }
        
        if (!targetstate) {
            idlist = [];
        }
        
        component.set("v.CheckedRowIDs", idlist);
    },
    ShowAll: function(component, event, helper) {
        var evt = $A.get("e.force:navigateToComponent");
        var c = component;
        
        evt.setParams({
            componentDef: "c:sdgList",
            componentAttributes: {
                SDGConfiguration: c.get("v.SDGConfiguration"),
                HideOnError: false,
                recordId: c.get("v.recordId"),
                Title: c.get("v.Title"),
                ShowDebug: c.get("v.ShowDebug"),
                UseCache: c.get("v.UseCache"),
                FieldSetName: c.get("v.FieldSetName"),
                SVGName: c.get("v.SVGName")
            }
        });
        evt.fire();
    },
    RaiseListEventMenu: function(component, event, helper) {
        var menuItem = event.detail.menuItem;
        var actionid = menuItem.get("v.value");
        helper.FireEvent(component, actionid);
    },
    RaiseListEventButton: function(component, event, helper) {
        var actionid = event.getSource().get("v.value");
        var netopsid = component.get("v.recordId");
        helper.FireEvent(component, actionid);

    },
    RaiseListMultiEventButton: function(component, event, helper) {
        //debugger;
        
        var actionid = event.getSource().get("v.value");

        var actions = component.get("v.SDG.SDGActions");
        var eventLabel;
        for (var i = 0; i < actions.length; i++) {
            if (actions[i].Id === actionid) {
                eventLabel = actions[i].Label;
            }
        }

        if (eventLabel == "Add") {
            /*
              var sPageURL = decodeURIComponent(window.location.search.substring(1));
              var values = sPageURL.split("&");
              var idPageURL = values[0];
              var idvalues = idPageURL.split("=");
              var ClintinfoId = idvalues[1];
              var fafidPageURL = values[1];
              var fafidvalues = fafidPageURL.split("=");
              var ClintinfofafId = fafidvalues[1];	
              */
            var ClintinfoId= component.get('v.ClintinfoId');
             var ClintinfofafId= component.get('v.ClintinfofafId');
              helper.createPSRRecords(component,actionid,ClintinfoId,ClintinfofafId);

        } else if(eventLabel =='Delete Selected') { //Code added by Ajay for Bulk Delete

             helper.deleteMultipleRecords(component,actionid);
            
        } else if(component.get("v.SDGConfiguration")=='CustomObject:Billing_Admin_Fees_Grid_UM'){ // multi-delete functionlity for billing administrative fee matches with billing ancillary fee added Preetham padala 
            component.set("v.isBillingcon",true);
            component.set("v.actionId",actionid);
        }
            else { helper.FireEvent(component, actionid); }
    },
    RaiseRowEventMenu: function(component, event, helper) {
        var menuItem = event.detail.menuItem;
        var valuesString = menuItem.get("v.value");
        helper.RaiseRowEvent(component, helper, valuesString);
    },
    RaiseRowEventButton: function(component, event, helper) {
        var valuesString = event.getSource().get("v.value");
        helper.RaiseRowEvent(component, helper, valuesString);
    },
    clearFilter:function(component, event, helper){ // to clear filter citeria when we click on clear filter button
        
        var SDGObject = component.get("v.SDG");
        component.set("v.CheckedRowIDs", '');
        var dtatemp1= SDGObject.SDGFields;
        if(dtatemp1){
               for (var i = 0; i < dtatemp1.length; i++) {
                var temp=dtatemp1[i].Preferences;
                if(dtatemp1[i].Preferences){
                    temp.FieldValueTemp= null;// passing null to clearing all filter value 
                    temp.FilterValue= null; 
                }
           dtatemp1[i].Preferences=temp;
            }
         component.set("v.SDGFiltersDefinition", dtatemp1);
            component.set("v.SDG.SDGObject.SDGFields",dtatemp1);
        }

        
         component.set("v.ShowFilters", false); //closing the filetr popup
        component.set("v.SDGFilters", []); //assigning empty array to clear the filter
           var dtatemp =  component.get("v.SDGFiltersDefinition"); // getting already existing filter
       
        if(dtatemp){

            for (var i = 0; i < dtatemp.length; i++) {
                var temp=dtatemp[i].Preferences;
                if(dtatemp[i].Preferences){
                    temp.FieldValueTemp= null;// passing null to clearing all filter value 
                    temp.FilterValue= null;   
                }
                dtatemp[i].Preferences=temp;
            }
            component.set("v.SDGFiltersDefinition", dtatemp);
            component.set("v.SDGObject.SDGFields",dtatemp );
            helper.AddToLog(component, "Filters cleared");
            component.set("v.extraFilterFromCag",null);
            helper.getResponseData(component);
        }
         component.set("v.EnableClearFilter", true);
    },
    DownloadCSV: function(component, event, helper){// to downoad the csv 
        helper.getAllResponseData(component); 
    },
      RaiseRowDeleteButton : function(component,event,helper){
        var valuesString1 = event.getSource().get("v.value");
         var deleteURL=component.get("v.vfURLDelete");
          if(deleteURL!=null && deleteURL.length>0 &&  deleteURL!=''){
              deleteURL=deleteURL+'='+valuesString1+'&retURL='+component.get("v.recordId");
              
              var urlEvent = $A.get("e.force:navigateToURL");
              urlEvent.setParams({
                  "url": deleteURL
              });
              urlEvent.fire();
          }else{
        helper.deleteRowData(component,valuesString1);
          }
    },
//Start change in Initial Confirmation message to display Delete Billing Admin   
    hideBillingModel :function(component,event,helper){
        component.set("v.isBilling",false);
        component.set("v.isBillingcon",false);
    },
    deleteBillingModelcon :function(component,event,helper){
         component.set("v.isBillingcon",false);
         var actionid = component.get("v.actionId");
         if (actionid != null)
         {
          helper.deleteBillingAdmin(component,actionid);
         }
    },
    deleteBillingModel :function(component,event,helper){
        debugger;
        helper.deleteBillingAdminFees(component);
    },
    redirectToVF: function(component,event,helper){


        var VFURl=component.get("v.vfURL");
        if(VFURl!=null && VFURl!='' && VFURl.length>0){
            VFURl=VFURl+'='+component.get("v.recordId")+'&retURL='+component.get("v.recordId");

             var urlEvent = $A.get("e.force:navigateToURL");
    urlEvent.setParams({
      "url": VFURl
    });
    urlEvent.fire(); 
        }
    },
    bilingrefresh:function(component,event,helper){
        if(component.get("v.SDGConfiguration")=='CustomObject:Billing_Ancillary_Fees_Grid_UM'){
              helper.getResponseData(component);
            
        }
    }

});