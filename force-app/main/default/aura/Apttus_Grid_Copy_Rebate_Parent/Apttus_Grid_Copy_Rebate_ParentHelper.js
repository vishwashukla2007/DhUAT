({
    getThisReconciliation : function(component,event, helper) {
        var action = component.get("c.get_yearcount");
        action.setParams({"fafid":  component.get("{!v.fafid}")})
        action.setCallback(this, $A.getCallback(function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.yearcount", response.getReturnValue());
            } else {
                helper.counselLogErrors(response.getError());
            }
        }));
        $A.enqueueAction(action);  
        
        helper.getRebateData(component,event,helper);
        
        var action = component.get("c.findPicklistOptions");
        action.setParams({
            "objAPIName":"Rebate_Guarantees__c",
            "fieldAPIname":"Non_Specialty_Formulary_2__c"
        });
        action.setCallback(this, $A.getCallback(function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.nnameoptions", response.getReturnValue());
                console.log('response.getReturnValue()'+response.getReturnValue());
            } else {
                console.log('eror'+response.getError());
            }
        }));
        $A.enqueueAction(action);
        
        var action = component.get("c.findPicklistOptions");
        action.setParams({
            "objAPIName":"Rebate_Guarantees__c",
            "fieldAPIname":"GSTP__c"
        });
        action.setCallback(this, $A.getCallback(function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.gstpoptions", response.getReturnValue());
                console.log('response.getReturnValue()'+response.getReturnValue());
            }
            else {
                console.log('eror'+response.getError());
            }
        }));
        $A.enqueueAction(action);
        
        var action = component.get("c.findPicklistOptions");
        action.setParams({
            "objAPIName":"Rebate_Guarantees__c",
            "fieldAPIname":"Basis__c"
        });
        action.setCallback(this, $A.getCallback(function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.ntypeoptions", response.getReturnValue());
                console.log('response.getReturnValue()'+response.getReturnValue());
            } else {
                console.log('eror'+response.getError());
            }
        }));
        $A.enqueueAction(action);
        
        var action = component.get("c.findPicklistOptions");
        action.setParams({
            "objAPIName":  "Rebate_Guarantees__c",
            "fieldAPIname": "LOB2__c"
        });
        action.setCallback(this, $A.getCallback(function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.loboptions", response.getReturnValue());
            } else {
                helper.counselLogErrors(response.getError());
            }
        }));
        $A.enqueueAction(action);
    },
    
    getRebateData : function(component, event, helper)  {
        var action = component.get("c.get_RebatedataNonSpec");
        action.setParams({
            "fafid":component.get("{!v.fafid}"),
            "plan":component.get("{!v.plan}"),
            "basis":component.get("{!v.basis}"),
            "nonspecForm":component.get("{!v.nonspecForm}"),
            "gstp":component.get("{!v.gstp}"),
            "lob":component.get("{!v.lob}")
        });
        action.setCallback(this, $A.getCallback(function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.nonSpecObjects", response.getReturnValue());
                var data = component.get("v.nonSpecObjects");
                var itemcount = data.length;
                component.set("v.pricingNonSpeccount", itemcount);
                
                var data2TQ = component.get("v.nonSpecObjects.rg2TQ");
                var data3TQ = component.get("v.nonSpecObjects.rg3TQ");
                var data3TNQ = component.get("v.nonSpecObjects.rg3TNQ");
                var dataClosed = component.get("v.nonSpecObjects.closed");
                var dataSpec = component.get("v.nonSpecObjects.specialty");
                
                component.set("v.recordcount2TQ", data2TQ.length);
                component.set("v.recordcount3TQ", data3TQ.length);
                component.set("v.recordcount3TNQ", data3TNQ.length);
                component.set("v.recordcountClosed", dataClosed.length);
                //alert('dataSpec.length------'+dataSpec.length);
                component.set("v.recordcountSpec", dataSpec.length);

                if(data != undefined && data.is2TQ){
                    var appEvent1 = $A.get("e.c:Apttus_Grid_Rebate_SectionAvailableEvent");
					appEvent1.setParams({ 
                        "isAvailable" : true,
                        "section" : "2TQ"
                    });
					appEvent1.fire();
                }  else {
                    var appEvent1 = $A.get("e.c:Apttus_Grid_Rebate_SectionAvailableEvent");
					appEvent1.setParams({ 
                        "isAvailable" : false,
                        "section" : "2TQ"
                    });
					appEvent1.fire();
                }        
                if(data != undefined && data.is3TQ){
                    var appEvent2 = $A.get("e.c:Apttus_Grid_Rebate_SectionAvailableEvent");
					appEvent2.setParams({ 
                        "isAvailable" : true,
                        "section" : "3TQ"
                    });
					appEvent2.fire();
                }  else {
                    var appEvent2 = $A.get("e.c:Apttus_Grid_Rebate_SectionAvailableEvent");
					appEvent2.setParams({ 
                        "isAvailable" : false,
                        "section" : "3TQ"
                    });
					appEvent2.fire();
                }        
                if(data != undefined && data.is3TNQ){
                    var appEvent3 = $A.get("e.c:Apttus_Grid_Rebate_SectionAvailableEvent");
					appEvent3.setParams({ 
                        "isAvailable" : true,
                        "section" : "3TNQ"
                    });
					appEvent3.fire();
                }  else {
                    var appEvent3 = $A.get("e.c:Apttus_Grid_Rebate_SectionAvailableEvent");
					appEvent3.setParams({ 
                        "isAvailable" : false,
                        "section" : "3TNQ"
                    });
					appEvent3.fire();
                }        
                if(data != undefined && data.isClosed){
                    var appEvent4 = $A.get("e.c:Apttus_Grid_Rebate_SectionAvailableEvent");
					appEvent4.setParams({ 
                        "isAvailable" : true,
                        "section" : "Closed"
                    });
					appEvent4.fire();
                }  else {
                    var appEvent4 = $A.get("e.c:Apttus_Grid_Rebate_SectionAvailableEvent");
					appEvent4.setParams({ 
                        "isAvailable" : false,
                        "section" : "Closed"
                    });
					appEvent4.fire();
                }        
                if(data != undefined && data.isSpec){
                    var appEvent5 = $A.get("e.c:Apttus_Grid_Rebate_SectionAvailableEvent");
					appEvent5.setParams({ 
                        "isAvailable" : true,
                        "section" : "Specialty"
                    });
					appEvent5.fire();
                }  else {
                    var appEvent5 = $A.get("e.c:Apttus_Grid_Rebate_SectionAvailableEvent");
					appEvent5.setParams({ 
                        "isAvailable" : false,
                        "section" : "Specialty"
                    });
					appEvent5.fire();
                }        
                console.log('$$$response.getReturnValue()'+response.getReturnValue());
            } else {
                console.log('response.getError()'+response.getError());
                //helper.counselLogErrors(response.getError());
            }
        }));
        $A.enqueueAction(action);
    },
    
    createRGNonSpec : function(component, event, helper, latestRec)  {
        
        var newobj = new Object(); //component.get("v.newobject");
        component.get("v.newobject");
        if(component.get("v.lob")!=null){
            newobj.LOB2__c=component.get("v.lob");
        }
        newobj.FAF_ID__c =component.get("v.fafid");
        newobj.Rebate_Operations__c= component.get("{!v.objects.Rebate_Operations__c}");
        newobj.Year__c = null;
        newobj.Basis__c = null;
        newobj.Plan_Design__c = null;
        newobj.GSTP__c = null;
        newobj.Specialty_Formulary__c = null;
        newobj.Show_in_Non_Specialty_Grid__c = true;
        newobj.Show_in_Specialty_Grid__c = false;
        newobj.Year_Begin_Date__c = null;
        newobj.Year_End_Date__c = null;  
        newobj.Retail_30_1__c = null;
        newobj.Retail_90_1__c = null;
        newobj.Mchoice_1__c = null;
        newobj.Mail_1__c = null;
        newobj.Specialty_1__c = null;
        newobj.Specialty_Retail_1__c = null;
        newobj.Client_Owned_30_1__c = null;
        newobj.Client_Owned_90_1__c = null;  
        newobj.Retail_30__c = null;
        newobj.Retail_90__c = null;
        newobj.Mchoice__c = null;
        newobj.Mail__c = null;
        newobj.Specialty__c = null;
        newobj.Specialty_Retail__c = null;
        newobj.Client_Owned_30__c = null;
        newobj.Client_Owned_90__c = null;
        
        //alert('latestRec------' +latestRec);
        if(latestRec){
            newobj.Basis__c = latestRec.Basis__c;
            newobj.Retail_30__c = latestRec.Retail_30__c
            newobj.Retail_90__c = latestRec.Retail_90__c;
            newobj.Mail__c = latestRec.Mail__c;
            newobj.Mchoice__c = latestRec.Mchoice__c;
            newobj.Specialty_Retail__c = latestRec.Specialty_Retail__c;
            newobj.Client_Owned_30__c = latestRec.Client_Owned_30__c;
            newobj.Client_Owned_90__c = latestRec.Client_Owned_90__c;
            newobj.Retail_30_1__c = latestRec.Retail_30_1__c;
            newobj.Retail_90_1__c = latestRec.Retail_90_1__c;
            newobj.Mail_1__c = latestRec.Mail_1__c;
            newobj.Mchoice_1__c = latestRec.Mchoice_1__c;
            newobj.Specialty_Retail_1__c = latestRec.Specialty_Retail_1__c;                   
            newobj.Client_Owned_30_1__c = latestRec.Client_Owned_30_1__c;
            newobj.Client_Owned_90_1__c = latestRec.Client_Owned_90_1__c;
        }
        
        
        component.set("v.newobject",newobj);
        
    },
    
    createRGSpec : function(component, event, helper, latestRec)  {
        
        var newobj = new Object(); //component.get("v.newobject");
        //component.get("v.newobject");
        if(component.get("v.lob")!=null){
            newobj.LOB2__c=component.get("v.lob");
        }
        newobj.FAF_ID__c =component.get("v.fafid");
        newobj.Rebate_Operations__c= component.get("{!v.objects.Rebate_Operations__c}");
        newobj.Year__c = null;
        newobj.Basis__c = null;
        newobj.Plan_Design__c = null;
        newobj.GSTP__c = null;
        newobj.Specialty_Formulary__c = null;
        newobj.Show_in_Non_Specialty_Grid__c = false;
        newobj.Show_in_Specialty_Grid__c = true;
        newobj.PCD_Same_dollar_and_Percentage_Value__c = true;
        newobj.Specialty_1__c = null;
        newobj.Specialty__c = null;
        
        if (latestRec) {
            
            newobj.Specialty_Formulary__c = latestRec.Specialty_Formulary__c;
            newobj.Specialty_Display_Name__c = latestRec.Specialty_Display_Name__c;
            newobj.Specialty__c = latestRec.Specialty__c;
            newobj.Specialty_1__c = latestRec.Specialty_1__c;
        }
        component.set("v.newobject",newobj);
        
    }, 
    
    deleteSelectedRecords : function(component, event, helper) {
        var planDesignOption = component.get("v.planDesignOption");
        var wrapper = component.get("v.nonSpecObjects");
        
        component.set("{!v.DisplaySpinner}", false);
        var delList = []; 
        if(planDesignOption == '2 Tier Q'){
            delList = wrapper.rg2TQ;
        }
        if(planDesignOption == '3 Tier Q'){
            delList = wrapper.rg3TQ;
        }
        if(planDesignOption == '3 Tier NQ'){
            delList = wrapper.rg3TNQ;
        }
        if(planDesignOption == 'Closed'){
            delList = wrapper.closed;
        }
        if(delList) {
            for(var i = 0; i < delList.length; i++){
                 if(wrapper.specialty) {
                    var len = wrapper.specialty.length;
                    for(var j = 0 ; j< len ;j++){
                        if(wrapper.specialty[j] != undefined){
                            //alert('to-----------'+delList[i].Id);
                            //alert('1-----------'+wrapper.specialty[j].Id);
                            if(delList[i].Plan_Design__c == wrapper.specialty[j].Plan_Design__c){
                                var recordcountSpec = component.get("v.recordcountSpec");
                                recordcountSpec = recordcountSpec - 1;
                                component.set("v.recordcountSpec", recordcountSpec);
                                wrapper.specialty.splice(j, 1);
                                
                                if(component.get("v.recordcountSpec") < 1){
                                    component.set("v.nonSpecObjects.isSpec", false);
                                    var appEvent5 = $A.get("e.c:Apttus_Grid_Rebate_SectionAvailableEvent");
                                    appEvent5.setParams({ 
                                        "isAvailable" : false,
                                        "section" : "Specialty"
                                    });
                                    appEvent5.fire();
                                }
                            }
                        }
                    }
                }
            }
        }
        
        var temp = [];
        if(planDesignOption == '2 Tier Q'){
            wrapper.rg2TQ = temp;
            component.set("v.recordcount2TQ", 0);
        }
        if(planDesignOption == '3 Tier Q'){
            wrapper.rg3TQ = temp;
            component.set("v.recordcount3TQ", 0);
        }
        if(planDesignOption == '3 Tier NQ'){
            wrapper.rg3TNQ = temp;
            component.set("v.recordcount3TNQ", 0);
        }
        if(planDesignOption == 'Closed'){
            wrapper.closed = temp;
            component.set("v.recordcountClosed", 0);
        }
        component.set("v.nonSpecObjects",wrapper);
    },
    
    cancleDeleteAlertHelper : function(component, event, helper)  {
        var planDesignOption = component.get("v.planDesignOption");
        if(planDesignOption == '2 Tier Q'){
            component.set("v.nonSpecObjects.is2TQ", true);
        }
        if(planDesignOption == '3 Tier Q'){
            component.set("v.nonSpecObjects.is3TQ", true);
        }
        if(planDesignOption == '3 Tier NQ'){
            component.set("v.nonSpecObjects.is3TNQ", true);
        }
        if(planDesignOption == 'Closed'){
            component.set("v.nonSpecObjects.isClosed", true);
        }
        component.set("v.isDeleteAlertOpen", false);
    },
    
    processCopyMatchToHelper : function(component, event, helper){
        var matchToFromGrid = component.get("v.matchToFromGrid");
        var matchToToGrid = component.get("v.matchToToGrid");
        var wrapper = component.get("v.nonSpecObjects");
        //alert('matchToFromGrid---'+matchToFromGrid);
        //alert('matchToToGrid---'+matchToToGrid);
        var fromList = [];
        if(matchToFromGrid == "2TQ"){
            fromList = wrapper.rg2TQ;
        }
        if(matchToFromGrid == "3TQ"){
            fromList = wrapper.rg3TQ;
        }
        if(matchToFromGrid == "3TNQ"){
            fromList = wrapper.rg3TNQ;
        }
        if(matchToFromGrid == "Closed"){
            fromList = wrapper.closed;
        }
        /////////////////////////////////////
        var toList = []; 
        if(matchToToGrid == "2TQ"){
            toList = wrapper.rg2TQ;
        }
        if(matchToToGrid == "3TQ"){
            toList = wrapper.rg3TQ;
        }
        if(matchToToGrid == "3TNQ"){
            toList = wrapper.rg3TNQ;
        }
        if(matchToToGrid == "Closed"){
            toList = wrapper.closed;
        }
        if(toList) {
            for(var i = 0; i < toList.length; i++){
                 if(wrapper.specialty) {
                    var len = wrapper.specialty.length;
                    for(var j = 0 ; j< len ;j++){
                        if(wrapper.specialty[j] != undefined){
                            //alert('to-----------'+toList[i].Id);
                            //alert('1-----------'+wrapper.specialty[j].Id);
                            if(toList[i].Id == wrapper.specialty[j].Id){
                                var recordcountSpec = component.get("v.recordcountSpec");
                                recordcountSpec = recordcountSpec - 1;
                                component.set("v.recordcountSpec", recordcountSpec);
                                wrapper.specialty.splice(j, 1);
                                
                                if(component.get("v.recordcountSpec") < 1){
                                    component.set("v.nonSpecObjects.isSpec", false);
                                    var appEvent5 = $A.get("e.c:Apttus_Grid_Rebate_SectionAvailableEvent");
                                    appEvent5.setParams({ 
                                        "isAvailable" : false,
                                        "section" : "Specialty"
                                    });
                                    appEvent5.fire();
                                }
                            }
                        }
                    }
                }
            }
        }
        if(matchToToGrid == "2TQ"){
            var temp = [];
            for(var i = 0; i < fromList.length; i++){
                var temp1 = new Object();
                var obj = Object.assign(temp1, fromList[i]);
                obj.Plan_Design__c = '2 Tier Q';
                obj.Id = null;
                obj.Is_Match_To_Copy__c = true;
                temp.push(obj);
            }
            wrapper.rg2TQ = temp;
            component.set("v.recordcount2TQ", temp.length);
        }
        if(matchToToGrid == "3TQ"){ 
            var temp = [];
            for(var i = 0; i < fromList.length; i++){
                var temp1 = new Object();
                var obj = Object.assign(temp1, fromList[i]);
                obj.Plan_Design__c = '3 Tier Q';
                obj.Id = null;
                obj.Is_Match_To_Copy__c = true;
                temp.push(obj);
            }
            wrapper.rg3TQ = temp;
            component.set("v.recordcount3TQ", temp.length);
        }
        if(matchToToGrid == "3TNQ"){
            var temp = [];
            for(var i = 0; i < fromList.length; i++){
                var temp1 = new Object();
                var obj = Object.assign(temp1, fromList[i]);
                obj.Plan_Design__c = '3 Tier NQ';
                obj.Id = null;
                obj.Is_Match_To_Copy__c = true;
                temp.push(obj);
            }
            wrapper.rg3TNQ = temp;
            component.set("v.recordcount3TNQ", temp.length);
        }
        if(matchToToGrid == "Closed"){
            var temp = [];
            for(var i = 0; i < fromList.length; i++){
                var temp1 = new Object();
                var obj = Object.assign(temp1, fromList[i]);
                obj.Plan_Design__c = 'Closed';
                obj.Id = null;
                obj.Is_Match_To_Copy__c = true;
                temp.push(obj);
            }
            wrapper.closed = temp;
            component.set("v.recordcountClosed", temp.length);
        }
        component.set("v.nonSpecObjects",wrapper);
    },
})