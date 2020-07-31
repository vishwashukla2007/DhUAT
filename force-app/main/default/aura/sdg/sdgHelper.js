/*
 * Copyright (c) 2018, salesforce.com, inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */
({
    getNamespace: function(component) {
        debugger;
        var helper = this;
        try {
            this.callMethod(
                component,
                "c.GetNamespace",
                {},
                { isStorable: true, isAbortable: true },
                
                function(results) {
                    if (results !== null) {
                        component.set("v.namespace", results);
                    }
                }
            );
        } catch (ex) {	
            helper.AddToLog(component, "Error retrieving namespace: " + ex.message);
        }
    },
    getCoreParams: function(component) {
        var config = component.get("v.SDGConfiguration");
        if (config === undefined)
            config = "CustomObject:" + component.get("v.SDGTag");
        
        var params = {
            ParentRecordID: component.get("v.recordId"),
            SDGTag: config,
            RelationshipName: component.get("v.RelationshipName"),
            FieldSetName: component.get("v.FieldSetName"),
        };
        return params;
    },
    getSDG: function(component) {
        
        
        this.Waiting(component);
        
        var params = this.getCoreParams(component);
        
       var sPageSize = "10";
        try {
            sPageSize = component.get("v.DefaultPageSize");
        } catch (PageSize) {
            //ignore
        }
        params.DefaultPageSize = sPageSize;
        params.extraFilterFromCag=component.get("v.extraFilterFromCag");
        
        component.set("v.isPaging", false);
        var thishelper = this;
        this.callMethod(
            component,
            "c.GetSDGInitialLoad",
            params,
            {
                 //isStorable: component.get("v.UseCache"), 
                isAbortable: true,
                isBackground: component.get("v.UseBackground")
            },
            function(results) {
                if (results !== null) {
                    if (results.isError) {
                        thishelper.AddToLog(component, "Error: " + results.ErrorMessage);
                        if (component.get("v.HideOnError")) {
                            component.set("v.ShowComponent", false);
                        }
                        
                        component.set("v.ShowSDGError", true);
                        component.set("v.ErrorMessage", results.ErrorMessage);
                        
                        thishelper.showtoast("Error", results.ErrorMessage, component);
                    } else {
                        
                        
                        if(results.editOrAddAccess=='true'){
                            component.set("v.EditOrDeleteAccessForSalesuser",true);  
                        }
                        
                        if(results.editOrAddAccess=='false'){
                            component.set("v.EditOrDeleteAccessForSalesuser",false);  
                        }
                        
                        // getting records based on filter citeria restricted to New Via CAG Search added preetham padala
                        var callfilter=false;
                        var fields = results.SDGObject.SDGFields;
                          if(  component.get("v.extraFilterFromCag")=='Filter' ){
                            for (var i = 0; i < fields.length; i++) {
                                if(fields[i].Preferences){
                                    var temp=fields[i].Preferences;
                                    if(temp.FilterValue){  

                                        callfilter=true;
                                        //component.set("v.extraFilterFromCag",'unfiltered');
                                        //thishelper.getSDG(component);
                                        //return;
                                    }
                                } 
                            }
                            
                        }
                        if(callfilter && results.Results.FullQueryCount<=0){
                            component.set("v.extraFilterFromCag",'unfiltered'); 
                             component.set("v.showspinner",true);
							thishelper.getSDG(component);
                            return;
                        }
                         component.set("v.showspinner",false);
                        component.set("v.SDG", results.SDGObject);
                        var fieldlistlength = fields.length;
                        var hasFilters = false;
                        var hasSummary = false;
                        
                        for (var i = 0; i < fieldlistlength; i++) {
                            var field = fields[i];
                            if (field.canFilter) hasFilters = true;
                            if (
                                field.FieldStyle &&
                                field.FieldStyle.startsWith("Summarize")
                            ) {
                                hasSummary = true;
                            }
                        }
                        component.set("v.hasSummary", hasSummary);
                        component.set("v.hasFilters", hasFilters);
                        //Set up Actions
                        if (results.SDGObject.SDGActions !== null) {
                            var listsize = results.SDGObject.SDGActions.length;
                            
                            var hasListMenu = false;
                            var hasRowMenu = false;
                            var hasRowActions = false;
                            var hasMulti = false;
                            
                            component.set("v.SDGActions", results.SDGObject.SDGActions);
                            for (var j = 0; j < listsize; j++) {
                                var actiontype = results.SDGObject.SDGActions[j].Type;
                                
                                if (actiontype === "List") hasListMenu = true;
                                if (actiontype === "List Multi") hasMulti = true;
                                if (actiontype === "Row Button") hasRowActions = true;
                                if (actiontype === "Row") {
                                    hasRowMenu = true;
                                    hasRowActions = true;
                                }
                            }
                            component.set("v.hasRowMenu", hasRowMenu);
                            component.set("v.hasListMenu", hasListMenu);
                            component.set("v.hasRowActions", hasRowActions);
                            component.set("v.MultiSelectMode", hasMulti);
                        }
                        
                        component.set("v.isLoaded", true);
                        thishelper.handleResults(component, results.Results);
                        
                    }
                } else {
                    component.set("v.ShowSDGError", true);
                    showtoast(
                        "Error",
                        "Cannot load configuration data:  Please reconfigure the component in the designer.",
                        component
                    );
                }
            }
        );
    },
    Waiting: function(component) {
        this.AddToLog(component, "Mode: Waiting");
        var table = component.find("sdgdatatablewrapper");
        $A.util.addClass(table, "working");
    },
    showtoast: function(title, message, component) {
        if (component.get("v.ShowComponent")) {
            var navtoast = $A.get("e.force:showToast");
            navtoast.setParams({
                title: title,
                message: message
            });
            
            navtoast.fire();
        }
    },
    DoneWaiting: function(component) {
        var table = component.find("sdgdatatablewrapper");
        $A.util.removeClass(table, "working");
        this.AddToLog(component, "Mode: DoneWaiting");
    },
    GetCaseInsensitiveAttr: function(obj, propname) {
        var propvalue;
        propname = (propname + "").toLowerCase();
        for (var p in obj) {
            if (obj.hasOwnProperty(p) && propname === (p + "").toLowerCase()) {
                propvalue = obj[p];
                break;
            }
        }
        return propvalue;
    },
    
    handleResults: function(component, resultsobj) {
        if (resultsobj.isError) {
            component.set("v.ShowSDGError", true);
            component.set("v.ErrorMessage", resultsobj.ErrorMessage);
            showtoast("Error", resultsobj.ErrorMessage, component);
            
            this.AddToLog(component, resultsobj.ErrorMessage);
            this.DoneWaiting(component);
            this.showtoast("", resultsobj.ErrorMessage, component);
        } else {
            var toggleButton = component.find("FilterToggleButton");
            
            if (resultsobj.isFiltered) {
                component.set("v.ToggleFilterStyle", "slds-is-selected");
                
                component.set("v.EnableClearFilter", false);// enabling clear filter button 
            } else {
                component.set("v.ToggleFilterStyle", "");
            }
            
            //Now process the data into a list of data:
            var fields = component.get("v.SDG.SDGFields");
            var fieldlistlength = fields.length;
            
            var rows = [];
            // var dataurl;
            
            var payload = resultsobj.data;
            var DataList=[];
            for (var rowcounter = 0; rowcounter < payload.length; rowcounter++) {
                var datarow = payload[rowcounter];
                var row = [];
                var Data=[];
                //dataurl = '';
                for (var i = 0; i < fieldlistlength; i++) {
                    var field = fields[i];
                    var fieldparts = field.ColumnName.split(".");
                    var FieldName = fieldparts[fieldparts.length - 1];
                    
                    var datachunk = datarow;
                    var datachunkid = null;
                    var FormattedValue = null;
                    for (var z = 0; z < fieldparts.length; z++) {
                        if (datachunk) {
                            if (z === fieldparts.length - 1) {
                                if (datachunk["Id"]) datachunkid = datachunk["Id"];
                                try {
                                    if (field.FieldType === "CURRENCY") {
                                        FormattedValue = this.GetCaseInsensitiveAttr(
                                            datachunk,
                                            fieldparts[z] + "Formatted"
                                        );
                                    }
                                } catch (getFormattedEx) {
                                    showtoast(
                                        "Error",
                                        "Unable to get formatted Currency",
                                        component
                                    );
                                }
                            }
                            datachunk = this.GetCaseInsensitiveAttr(datachunk, fieldparts[z]);
                            //This handles reference items on the record:
                            if (field.FieldType === "REFERENCE") {
                                datachunkid = datachunk;
                            }
                        } else {
                            datachunk = null;
                            datachunkid = null;
                        }
                    }
                    Data.push(datachunk);
                    row.push({
                        Path: field.ColumnName,
                        FieldType: field.FieldType,
                        FieldLabel: field.Label + ": ",
                        FieldName: FieldName,
                        FieldStyle: field.FieldStyle,
                        FormattedValue: FormattedValue,
                        datachunk: datachunk,
                        datachunkid: datachunkid,
                        isHTMLFormatted: field.isHTMLFormatted,
                        scale: field.scale
                    });
                }
                
                //add to array
                rows.push({
                    rowID: datarow["Id"],
                    data: row
                });
                DataList.push(Data);  
            }
            var generateSummary = component.get("v.hasSummary");
            component.set("v.customDataList",DataList);
            var summaryrow = [];
            
            if (generateSummary) {
                for (var j = 0; j < fieldlistlength; j++) {
                    var summaryvalue = 0;
                    field = fields[j];
                    var coltotal = 0;
                    var colmin = null;
                    var colmax = null;
                    var prefix = "";
                    if (field.FieldStyle && field.FieldStyle.startsWith("Summarize")) {
                        //Add the fields up:
                        
                        for (
                            var rowsummarizer = 0;
                            rowsummarizer < payload.length;
                            rowsummarizer++
                        ) {
                            var val = rows[rowsummarizer].data[i].datachunk;
                            
                            if (typeof val === "number" || typeof val === "currency") {
                                coltotal += val;
                                colmin = Math.min(colmin === null ? val : colmin, val);
                                colmax = Math.max(colmax === null ? val : colmax, val);
                            }
                        }
                        
                        if (field.FieldStyle === "Summarize:Total") {
                            summaryvalue = coltotal.toFixed(2);
                            prefix = "Total: ";
                        }
                        
                        if (field.FieldStyle === "Summarize:Average") {
                            prefix = "Avg: ";
                            if (payload.length > 0)
                                summaryvalue = (coltotal / payload.length).toFixed(2);
                        }
                        if (field.FieldStyle === "Summarize:Max") {
                            prefix = "Max: ";
                            summaryvalue = colmax;
                        }
                        if (field.FieldStyle === "Summarize:Min") {
                            prefix = "Min: ";
                            summaryvalue = colmin;
                        }
                    } else {
                        summaryvalue = "";
                        prefix = "";
                    }
                    summaryrow.push({
                        FieldType: "SUMMARY",
                        FieldLabel: "",
                        datachunk: summaryvalue,
                        Path: "",
                        FieldName: "",
                        FieldStyle: "",
                        datachunkid: "",
                        FormattedValue: prefix + summaryvalue,
                        isHTMLFormatted: false
                    });
                }
            }
            component.set("v.summarydata", summaryrow);
            component.set("v.FullQueryCount", resultsobj.FullQueryCount);
            
            this.AddToLog(
                component,
                "Query returns: " + resultsobj.FullQueryCount + " rows"
            );
            //current page:
             component.set("v.maxrecord",resultsobj.pagecount);
            var pagecount = component.get("v.maxrecord");
            if (resultsobj.pagecount >= 50 )
            {
                component.set("v.maxrecord", 50);
                var pagecount = component.get("v.maxrecord");
            }
            if (component.get("v.isPaging") === false) {
                var opts = [];
                for (j = 0; j < pagecount; j++) {
                    opts.push({ label: j + 1, value: j + 1 });
                }
                //Bind to the component
                component.set("v.Pages", opts);
                var optsrec1 = (resultsobj.FullQueryCount/ pagecount );
                component.set("v.RecordCount", optsrec1);
                var pp = component.find("PagerPage");
                var ps = component.find("PagerSize");
                var psv = component.get("v.PagerSizeValue");
                if (psv != null)
                {
                    ps.set("v.value", psv);
                }
                else
                {
                if (optsrec1 < 10 )
                {
                    ps.set("v.value", "10");
                }
                if (optsrec1 >= 10 && optsrec1 < 20)
                {
                    ps.set("v.value", "10");
                }
                if (optsrec1 >= 20 && optsrec1 < 50)
                {
                    ps.set("v.value", "20");
                }
                if (optsrec1 >= 50 && optsrec1 < 100)
                {
                    ps.set("v.value", "50");
                }
                if (optsrec1 >= 100 )
                {
                    ps.set("v.value", "100");
                }
                }
                if (pp) {
                    pp.set("v.value", "1");
                }
            }
            component.set("v.isPaging", false);
            component.set("v.processeddata", rows);
            
            var newTitle = component.get("v.Title");
            newTitle =
                newTitle + " " + " (" + component.get("v.FullQueryCount") + ")";
            component.set("v.TitleName", newTitle);
            
            this.DoneWaiting(component);
        }
    },
    
    getResponseData: function(component) {
        var thishelper = this;
        try {
            this.Waiting(component);
            
            var params = this.getCoreParams(component);
            
            params.PageID = parseInt(component.find("PagerPage").get("v.value"), 10);
            params.Filters = component.get("v.SDGFilters");
            params.PageSize = parseInt(
                component.find("PagerSize").get("v.value"),
                10
            );
            params.SortOrder = component.get("v.SortOrder");
            params.SortColumn = component.get("v.SortColumn");
            params.reloadseed = component.get("v.reloadseed");
            params.extraFilterFromCag=component.get("v.extraFilterFromCag");
            
            
            if (component.get("v.SDGFilters").length > 0) {
                component.set("v.FilterButtonClass", "slds-is-selected");
            } else {
                component.set("v.FilterButtonClass", "");
            }
            
            var req = { jsonrequest: JSON.stringify(params) };
            
            this.callMethod(
                component,
                "c.getSDGResult",
                req,
                {
                    isStorable: false,
                    isAbortable: true,
                    isBackground: component.get("v.UseBackground")
                },
                function(results) {
                    thishelper.handleResults(component, results);
                }
            );
        } catch (getResponseDataErr) {
            thishelper.AddToLog(component, "Error: " + getResponseDataErr.message);
        }
    },
    
    /**** START - Method to Create Platform Specific Record from CAG Search ****/
    createPSRRecords: function(component, actionid,ClintinfoId,ClintinfofafId) {
        var evt;
        var Clientinformationid = ClintinfoId;
        var Clientinformationfafid = ClintinfofafId;
        var actions = component.get("v.SDG.SDGActions");
        var opts = [];
        for (var i = 0; i < actions.length; i++) {
            if (actions[i].Id === actionid) {
                evt = actions[i];
            }
        }
        if(evt != null) {
            //build payload:
            
            var idlist = component.get("v.CheckedRowIDs");
            
            var actionCreatePSR = component.get("c.createPlatformSpec");
            var redirection = 1;
            var returnmessage;
            actionCreatePSR.setParams({
                "lstCAGIds" : idlist,
                "Clientinfoid" : Clientinformationid,
                "ClintinfofafId" : ClintinfofafId
            }); 
            
            actionCreatePSR.setCallback(this,function(a){
                var res = a.getReturnValue();
                console.log(res);
                returnmessage = a.getReturnValue();
                var toastEvent = $A.get("e.force:showToast");
                if(res.includes('success')){
                //if(res!=null && res.includes('success')){
                    toastEvent.setParams({
                        mode: 'dismissible',
                        duration: "4000",
                        message: 'Platform Specifics records created successfully.',
                        type : 'info'
                    });
                    
                }else{
                    toastEvent.setParams({
                        mode: 'dismissible',
                        duration: "4000",
                        message: a.getReturnValue(),
                        type : 'error'
                        
                    });
                    //redirection =0;
                }
                
                toastEvent.fire();
                if(res.includes('success')){
                    component.getEvent("CAGComponentEvent").fire();
                }
                
            });      
            $A.enqueueAction(actionCreatePSR);  
            // if (returnmessage !='Platform Specifics record created successfully') {
            //redirection =0;
            //}
            debugger;
            //if (redirection == 1 ) {
            //var URLredirection = window.location.href;
            //var values = URLredirection.split("/n/");
            //var urlEvent = $A.get("e.force:navigateToURL");
            //urlEvent.setParams({"url": values[0] + '/r/Client_Information__c/'+ Clientinformationid +'/view'});
            //urlEvent.fire(); 
            
            
            
        }
    },
    
    /**** END  Method to Create Platform Specific Record from CAG Search ****/
    
    FireEvent: function(component, actionid, datarow) {
        var evt;
        var actions = component.get("v.SDG.SDGActions");
        var opts = [];
        for (var i = 0; i < actions.length; i++) {
            if (actions[i].Id === actionid) {
                evt = actions[i]
            }
        }
        
        if (evt != null) {
            //build payload:
            var payload = evt.Payload;
            payload = payload.replace(
                /#parentrecordId#/gi,
                component.get("v.recordId")
            );
            
            var idlist = component.get("v.CheckedRowIDs");
            payload = payload.replace(/#Ids#/gi, idlist.join());
            
            if (datarow) {
                payload = payload.replace(/#Id#/gi, datarow.rowID);
            }
            
            if (datarow) {
                for (var fieldkey in datarow.data) {
                    var field = datarow.data[fieldkey];
                    payload = payload.replace("#" + field.Path + "#", field.datachunk);
                    try {
                        //this only works in Chrome/FF/Edge+ - ie no IE
                        if (field.Path.lastIndexOf("Name") === field.Path.length - 4) {
                            //if (field.Path.endsWith('Name'))
                            var newpath =
                                field.Path.substring(0, field.Path.length - 4) + "Id";
                            
                            if (field.datachunkid)
                                payload = payload.replace(
                                    "#" + newpath + "#",
                                    field.datachunkid
                                );
                        }
                    } catch (endwithex) {
                        //ignore - this is a javascript problem - probably IE
                    }
                }
            }
            
            var payloadobj = JSON.parse(payload);
            var internalevent = component.get("v.internalEvent");
            if (evt.Event !== internalevent) {
                var navEvt = $A.get(evt.Event);
                
                if (navEvt === null) {
                    this.showtoast(
                        "Error",
                        "Invalid event name - cannot identify event",
                        component
                    );
                } else {
                    navEvt.setParams(payloadobj);
                    navEvt.fire();
                }
            } else {
                var objhelper = component.find("ObjectHelper");
                objhelper.doMethod(payloadobj);
            }
        }
    },
    
    RaiseRowEvent: function(component, helper, valuesString) {
        var values = valuesString.split(",");
        var actionid = values[0];
        var rowID = values[1];
        //get the data row:
        var allrows = component.get("v.processeddata");
        var selectedrow;
        for (var key in allrows) {
            var datarow = allrows[key];
            if (datarow.rowID === rowID) {
                selectedrow = datarow;
            }
        }
        
        this.FireEvent(component, actionid, selectedrow);
    }, 
    convertArrayOfObjectsToCSV : function(component,objectRecords){
        // declare variables
        var csvStringResult, counter, keys, columnDivider, lineDivider;
        
        
        if (objectRecords == null || !objectRecords.length) {
            return null;
        }
        
        columnDivider = ',';
        lineDivider =  '\n';
        
        
        var fields= component.get("v.SDG.SDGFields");
        var keys= new Array();
        for(var i=0; i < fields.length; i++){  
            var field = fields[i];
            var fieldparts = field.Label.split(".");
            var FieldLabel = fieldparts[fieldparts.length - 1];
            keys.push(FieldLabel);
        }
        
        csvStringResult = '';
        csvStringResult += keys.join(columnDivider);
        csvStringResult += lineDivider;
        
        for(var i=0; i < objectRecords.length; i++){   
            counter = 0;
            console.log('objectRecordsMy[i] '+objectRecords[i]);
            for(var sTempkey in keys) {
                var skey = keys[sTempkey] ;  
                
                // add , [comma] after every String value,. [except first]
                if(counter > 0){ 
                    csvStringResult += columnDivider; 
                }   
                                // Changes for Story W-000808 : Mohit Srivastava(Accenture Offshore)
                
                if(objectRecords[i][sTempkey]){
                    if((sTempkey== $A.get("$Label.c.PlatformSpecific_Level1") ||sTempkey== $A.get("$Label.c.PlatformSpecific_Level2") || sTempkey==$A.get("$Label.c.PlatformSpecific_Level3")) 
                                &&(objectRecords[i][1]== $A.get("$Label.c.PlatformSpecific_CATS") ||objectRecords[i][1]== $A.get("$Label.c.PlatformSpecific_RxCLAIM") 
                          				||objectRecords[i][1]== $A.get("$Label.c.PlatformSpecific_RBU")))
                    {
                     var cvsAppendsingleQuotes;
                     cvsAppendsingleQuotes="'"+ objectRecords[i][sTempkey]+"'";
                     csvStringResult +=cvsAppendsingleQuotes; 
                     console.log('csvStringResult'+csvStringResult);
                    }
                    else{
                         csvStringResult += '"'+ objectRecords[i][sTempkey]+'"'; 
                    }
                    console.log('objectRecords my data '+objectRecords[i][sTempkey]);
                }else{
                    csvStringResult += '" "'; 
                    console.log('objectRecords data '+objectRecords[i][sTempkey]);
                }
                
                counter++;
                
            } // inner for loop close 
            csvStringResult += lineDivider;
        }// outer main for loop close 
        
        
        return csvStringResult;        
    },
    getAllResponseData: function(component) {
        var thishelper = this;
        try {
            this.Waiting(component);
            
            var params = this.getCoreParams(component);
            
            params.PageID = parseInt(component.find("PagerPage").get("v.value"), 10);
            params.Filters = component.get("v.SDGFilters");
            params.PageSize = component.get("v.FullQueryCount");
            params.SortOrder = component.get("v.SortOrder");
            params.SortColumn = component.get("v.SortColumn");
            params.reloadseed = component.get("v.reloadseed");
            
            if (component.get("v.SDGFilters").length > 0) {
                component.set("v.FilterButtonClass", "slds-is-selected");
            } else {
                component.set("v.FilterButtonClass", "");
            }
            
            var req = { jsonrequest: JSON.stringify(params) };
            
            this.callMethod(
                component,
                "c.getSDGResult",
                req,
                {
                    isStorable: component.get("v.UseCache"),
                    isAbortable: true,
                    isBackground: component.get("v.UseBackground")
                },
                function(results) {
                    thishelper.handleAllResults(component, results);
                    thishelper.downloadAllRecordToCSV(component);
                }
            );
        } catch (getResponseDataErr) {
            thishelper.AddToLog(component, "Error: " + getResponseDataErr.message);
        }
    },
    handleAllResults: function(component, resultsobj) {
        if (resultsobj.isError) {
            component.set("v.ShowSDGError", true);
            component.set("v.ErrorMessage", resultsobj.ErrorMessage);
            showtoast("Error", resultsobj.ErrorMessage, component);
            
            this.AddToLog(component, resultsobj.ErrorMessage);
            this.DoneWaiting(component);
            this.showtoast("", resultsobj.ErrorMessage, component);
        } else {
            var toggleButton = component.find("FilterToggleButton");
            
            if (resultsobj.isFiltered) {
                component.set("v.ToggleFilterStyle", "slds-is-selected");
            } else {
                component.set("v.ToggleFilterStyle", "");
            }
            
            //Now process the data into a list of data:
            var fields = component.get("v.SDG.SDGFields");
            var fieldlistlength = fields.length;
            
            
            // var dataurl;
            
            var payload = resultsobj.data;
            var DataList=[];  
            for (var rowcounter = 0; rowcounter < payload.length; rowcounter++) {
                var datarow = payload[rowcounter];
                
                var Data=[];
                //dataurl = '';
                for (var i = 0; i < fieldlistlength; i++) {
                    var field = fields[i];
                    var fieldparts = field.ColumnName.split(".");
                    var FieldName = fieldparts[fieldparts.length - 1];
                    
                    var datachunk = datarow;
                    var datachunkid = null;
                    var FormattedValue = null;
                    for (var z = 0; z < fieldparts.length; z++) {
                        if (datachunk) {
                            if (z === fieldparts.length - 1) {
                                if (datachunk["Id"]) datachunkid = datachunk["Id"];
                                try {
                                    if (field.FieldType === "CURRENCY") {
                                        FormattedValue = this.GetCaseInsensitiveAttr(
                                            datachunk,
                                            fieldparts[z] + "Formatted"
                                        );
                                    }
                                } catch (getFormattedEx) {
                                    showtoast(
                                        "Error",
                                        "Unable to get formatted Currency",
                                        component
                                    );
                                }
                            }
                            datachunk = this.GetCaseInsensitiveAttr(datachunk, fieldparts[z]);
                            //This handles reference items on the record:
                            if (field.FieldType === "REFERENCE") {
                                datachunkid = datachunk;
                            }
                        } else {
                            datachunk = null;
                            datachunkid = null;
                        }
                    }
                    Data.push(datachunk);
                    
                }
                
                //add to array
                
                DataList.push(Data);   
            }
            component.set("v.customDataList",DataList);
            component.set("v.FullQueryCount", resultsobj.FullQueryCount);
            this.DoneWaiting(component);
        }
    },
    
    downloadAllRecordToCSV: function(component){
        var stockData = component.get("v.customDataList");
        var csv = this.convertArrayOfObjectsToCSV(component,stockData);   
        if (csv == null){return;} 
        
        // ####--code for create a temp. <a> html tag [link tag] for download the CSV file--####     
        var hiddenElement = document.createElement('a');
        hiddenElement.href = 'data:text/csv;charset=utf-8,' + encodeURI(csv);
        hiddenElement.target = '_self'; // 
        hiddenElement.download = 'ExportData.csv';  // CSV file Name* you can change it.[only name not .csv] 
        document.body.appendChild(hiddenElement); // Required for FireFox browser
        hiddenElement.click(); // using click() js function to download csv file  
    },
    deleteRowData:function(component,valID){
        
        var thishelper = this;
        var params = {
            RecordID: valID,
        };
        this.callMethod(
            component,
            "c.deleteSDGRowData",
            params,
            {},
            function(results) {
                if (results !== null) {
                    if (results.isError) {
                        thishelper.AddToLog(component, "Error: " + results.ErrorMessage);
                        var navtoast = $A.get("e.force:showToast");
                        navtoast.setParams({
                            title: 'Error',
                            message: results.ErrorMessage,
                            type:'error'
                        });
                        
                        navtoast.fire();
                    } else {
                        component.set("v.reloadseed", Date.now());
                        thishelper.getResponseData(component);
                        var navtoast = $A.get("e.force:showToast");
                        navtoast.setParams({
                            title: 'Success',
                            message: 'Row has been deleted Successfully',
                            type:'success'
                        });
                        
                        navtoast.fire();
                    }
                } else {
                    component.set("v.ShowSDGError", true);
                    showtoast(
                        "Error",
                        "Cannot load configuration data:  Please reconfigure the component in the designer.",
                        component
                    );
                }
            }
        );
    },
    /**** START - Method to Delete Multiple by Ajay ****/
    deleteMultipleRecords: function(component, actionid) {
        
        
        var idlist = component.get("v.CheckedRowIDs");
        var deleteIdsAction = component.get("c.deleteSDGMultipleRowData");
        var redirection = 1;
        var returnmessage;
        deleteIdsAction.setParams({
            "RecordID" : idlist
        }); 
        
        deleteIdsAction.setCallback(this,function(a){
            var res = a.getReturnValue();
            returnmessage = a.getReturnValue();
            var toastEvent = $A.get("e.force:showToast");
            if(res.includes('success')){
                toastEvent.setParams({
                    mode: 'sticky',
                    message: 'Records deleted successfully',
                    type : 'info'
                });
                
            }else{
                toastEvent.setParams({
                    mode: 'sticky',
                    message: a.getReturnValue(),
                    type : 'error'
                    
                });
                redirection =0;
            }
            
            toastEvent.fire();
            
        });      
        $A.enqueueAction(deleteIdsAction);  
        
        
    },
    
    /**** END  Method to Create Platform Specific Record from CAG Search ****/
    
    
    /****Added by Preetham padala***/
    deleteBillingAdmin: function(component, actionid) {
        var thishelper = this;
        debugger;
        var idlist = component.get("v.CheckedRowIDs");
        var action = component.get("c.deleteBillingAdminRowData");
        
        var returnmessage;
        action.setParams({
            "RecordID" : idlist
        }); 
        action.setCallback(this,function(a){
            
            returnmessage = a.getReturnValue();
            if( returnmessage.billing){
                //Start change in Initial Confirmation message to display Delete Billing Admin   
                component.set("v.isBilling",true);
                thishelper.getResponseData(component);
                console.log(returnmessage);
                component.set("v.BillingAdminList",returnmessage.billing);
                component.set("v.BillingAcillList",returnmessage.ancill);
            }else{
                component.set("v.reloadseed", Date.now());
                component.set("v.CheckedRowIDs",[]);
                var checkall=component.find("checkall"); 
                checkall.set("v.checked",false);
                thishelper.getResponseData(component);
                var navtoast = $A.get("e.force:showToast");
                navtoast.setParams({
                    title: 'Success',
                    message: 'Row has been deleted Successfully',
                    type:'success'
                });
                navtoast.fire();
                component.set("v.isBilling",false);
            }
        });      
        $A.enqueueAction(action); 
    },
    deleteBillingAdminFees: function(component, actionid) {
        debugger;
        var thishelper = this;
        var idlist = component.get("v.CheckedRowIDs");
        var deleteIdsAction = component.get("c.deleteBillingAdminAndAncillData");
        
        var returnmessage;
        deleteIdsAction.setParams({ 
            "todeletebillAdminList" :  component.get("v.BillingAdminList"),
            
            "todeletebillancList": component.get("v.BillingAcillList")
        }); 
        
        deleteIdsAction.setCallback(this,function(a){
            
            returnmessage = a.getReturnValue();
            if(returnmessage=='Success'){	
                component.set("v.reloadseed", Date.now());
                thishelper.getResponseData(component);
                var navtoast = $A.get("e.force:showToast");
                navtoast.setParams({
                    title: 'Success',
                    message: 'Row has been deleted Successfully',
                    type:'success'
                });
                navtoast.fire();
                component.set("v.CheckedRowIDs",[]);
                var checkall=component.find("checkall");
                checkall.set("v.checked",false);
                
                $A.get('e.force:refreshView').fire(); 
                component.set("v.isBilling",false);
            }
        });      
        $A.enqueueAction(deleteIdsAction);  
        
        
    }
});