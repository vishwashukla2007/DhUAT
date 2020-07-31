({
    
    doInit : function(component, event, helper)  {  
        component.set("v.DisplaySpinner",false);
        helper.getThisReconciliation(component,event,helper);      
        component.set("v.gstp",component.get("v.objects.GSTP__c"));
        component.set("v.nonspecForm",component.get("v.objects.Non_Specialty_Formulary__c"));
        component.set("v.basis",component.get("v.objects.Basis__c"));
		component.set("v.desc",component.get("v.objects.Custom_Description__c"));
        
        component.set("v.disablebtn",false);
        component.set("v.is2TQDisabled",false);
        component.set("v.is3TQDisabled",false);
        component.set("v.is3TNQDisabled",false);
        component.set("v.isClosedDisabled",false);
        component.set("v.DisplaySpinner",false);
    },
    handleSaveVerify : function(component, event, helper)  {
        var section = event.getParam("Section");
        var isSaved = event.getParam("SaveRec");
        var isMatchToSave = event.getParam("isMatchToSave");
        var isSavedAndClose = event.getParam("isSavedAndClose");
        
       
        //alert('isMatchToSave   '+isMatchToSave);
        console.log('section   '+section);
        console.log('isSaved   '+isSaved);
        //if(isSavedAndClose){
            if (section == "2TQ" && isSaved){
                var savecount2TQ = component.get("v.savecount2TQ");
                savecount2TQ = savecount2TQ + 1;
                component.set("v.savecount2TQ", savecount2TQ);
                
                //alert('savecount2TQ   '+savecount2TQ);
                //alert('recordcount2TQ   '+component.get("v.recordcount2TQ"));
                
                if(savecount2TQ == component.get("v.recordcount2TQ")){
                    if(isMatchToSave == true || isSavedAndClose == false){
                        component.set("v.is2TQSaved", true);
                    } else {
                        //alert('savecount2TQ  close ');
                        var appEvent1 = $A.get("e.c:Apttus_Grid_NT_Close_Event");
                        appEvent1.setParams({ 
                            "Save" : true ,
                            "Section" : "2TQ"
                        });
                        appEvent1.fire();
                    }
                }
            }
            if (section == "3TQ" && isSaved){
                var savecount3TQ = component.get("v.savecount3TQ");
                savecount3TQ = savecount3TQ + 1;
                component.set("v.savecount3TQ", savecount3TQ);
                
                //alert('savecount3TQ   '+savecount3TQ);
                //alert('recordcount3TQ   '+component.get("v.recordcount3TQ"));
                
                if(savecount3TQ == component.get("v.recordcount3TQ")){                
                    if(isMatchToSave == true || isSavedAndClose == false){
                        component.set("v.is3TQSaved", true);
                    } else {
                        //alert('savecount3TQ  close ');
                        var appEvent2 = $A.get("e.c:Apttus_Grid_NT_Close_Event");
                        appEvent2.setParams({ 
                            "Save" : true ,
                            "Section" : "3TQ"
                        });
                        appEvent2.fire();
                    }
                }
            }
            if (section == "3TNQ" && isSaved){
                var savecount3TNQ = component.get("v.savecount3TNQ");
                savecount3TNQ = savecount3TNQ + 1;
                component.set("v.savecount3TNQ", savecount3TNQ);
                
                if(savecount3TNQ == component.get("v.recordcount3TNQ")){
                    if(isMatchToSave == true || isSavedAndClose == false){
                        component.set("v.is3TNQSaved", true);
                    } else {
                        //alert('savecount3TNQ  close ');
                        var appEvent3 = $A.get("e.c:Apttus_Grid_NT_Close_Event");
                        appEvent3.setParams({ 
                            "Save" : true ,
                            "Section" : "3TNQ"
                        });
                        appEvent3.fire();
                    }
                }
            }
            if (section == "Closed" && isSaved){
                var savecountClosed = component.get("v.savecountClosed");
                savecountClosed = savecountClosed + 1;
                component.set("v.savecountClosed", savecountClosed);
                
                //alert('savecountClosed   '+savecountClosed);
                //alert('recordcountClosed   '+component.get("v.recordcountClosed"));
                if(savecountClosed == component.get("v.recordcountClosed")){
                    if(isMatchToSave == true || isSavedAndClose == false){
                        component.set("v.isClosedSaved", true);
                    } else {
                        //alert('savecountClosed  close ');
                        var appEvent4 = $A.get("e.c:Apttus_Grid_NT_Close_Event");
                        appEvent4.setParams({ 
                            "Save" : true ,
                            "Section" : "Closed" 
                        });
                        appEvent4.fire();
                    }
                }
            }
            if (section == "Specialty" && isSaved){
                var savecountSpec = component.get("v.savecountSpec");
                savecountSpec = savecountSpec + 1;
                component.set("v.savecountSpec", savecountSpec);
                //alert('component.get("v.recordcountSpec")   '+component.get("v.recordcountSpec"));
                //alert('section   '+section);
                if(savecountSpec == component.get("v.recordcountSpec")){
                    if(isMatchToSave == true || isSavedAndClose == false){
                        component.set("v.isSpecSaved", true);
                    } else {
                        //alert('savecountSpecs  close ');
                        var appEvent5 = $A.get("e.c:Apttus_Grid_NT_Close_Event");
                        appEvent5.setParams({ 
                            "Save" : true ,
                            "Section" : "Specialty"
                        });
                        appEvent5.fire();
                    }
                }
            }
        //}  
        if(isMatchToSave == true || isSavedAndClose == false){
            //alert('isMatchToSave');
            var is2TQGridComplete = false;
            var is3TQGridComplete = false;
            var is3TNQGridComplete = false;
            var isClosedGridComplete = false;
            var isSpecGridComplete = false;
            if(component.get("v.nonSpecObjects.is2TQ")== true){
                if(component.get("v.is2TQSaved")== true){
                    is2TQGridComplete = true;
                }
            } else {
                is2TQGridComplete = true;
            }
            if(component.get("v.nonSpecObjects.is3TQ")== true){
                if(component.get("v.is3TQSaved")== true){
                    is3TQGridComplete = true;
                }
            } else {
                is3TQGridComplete = true;
            }
            if(component.get("v.nonSpecObjects.is3TNQ")== true){
                if(component.get("v.is3TNQSaved")== true){
                    is3TNQGridComplete = true;
                }
            } else {
                is3TNQGridComplete = true;
            }
            if(component.get("v.nonSpecObjects.isClosed")== true){
                if(component.get("v.isClosedSaved")== true){
                    isClosedGridComplete = true;
                }
            } else {
                isClosedGridComplete = true;
            }
            if(component.get("v.nonSpecObjects.isSpec")== true){
                if(component.get("v.isSpecSaved")== true){
                    isSpecGridComplete = true;
                }
            } else {
                isSpecGridComplete = true;
            }
            
            if(is2TQGridComplete ==  true && is3TQGridComplete ==  true && is3TNQGridComplete ==  true && isClosedGridComplete ==  true && isSpecGridComplete == true 
               && isSavedAndClose == true) {
                //delete to grid
                //copy from grid
                //save to grid
                //alert('processMatchToHelper');
                helper.processMatchToHelper(component, event, helper);
            } 
            if(is2TQGridComplete ==  true && is3TQGridComplete ==  true && is3TNQGridComplete ==  true && isClosedGridComplete ==  true && isSpecGridComplete == true 
               && isSavedAndClose == false) {
                //alert('getRebateData');
                helper.getRebateData(component, event, helper);
                component.set("v.disablebtn",false);
                component.set("v.is2TQDisabled",false);
                component.set("v.is3TQDisabled",false);
                component.set("v.is3TNQDisabled",false);
                component.set("v.isClosedDisabled",false);
        component.set("v.displayMessageText",false);
            } 
        } else {
            component.set("v.disablebtn",false);
            component.set("v.is2TQDisabled",false);
            component.set("v.is3TQDisabled",false);
            component.set("v.is3TNQDisabled",false);
            component.set("v.isClosedDisabled",false);
            component.set("v.DisplaySpinner",false);
        component.set("v.displayMessageText",false);
            
        }
        
    },
    
    handleSave : function(component, event, helper)  {   
        //alert('handleSave parent   ');
        component.set("v.recordcount",0);
        //component.set("v.DisplaySpinner",true);
        component.set("v.savecount2TQ",0);
        component.set("v.savecount3TQ",0);
        component.set("v.savecount3TNQ",0);
        component.set("v.savecountClosed",0);
        component.set("v.savecountSpec",0);
        component.set("v.isSavedAndClose",event.getParam("isSavedAndClose"));
        
    },
    handleError : function(component, event, helper)  {   
        component.set("v.DisplaySpinner",false);
    },
    
    displayspinner : function(component, event, helper)  {
        component.set("v.DisplaySpinner",true);
    },
    createAll : function(component, event, helper)  {
        component.set("v.disablebtn", true);
        
        var is2TQ = component.get("v.nonSpecObjects.is2TQ");
        var is3TQ = component.get("v.nonSpecObjects.is3TQ");
        var is3TNQ = component.get("v.nonSpecObjects.is3TNQ");
        var isClosed = component.get("v.nonSpecObjects.isClosed");
        var new2TQ = new Object();
        var new3TQ = new Object();
        var new3TNQ = new Object();
        var newClosed = new Object();
        var newSpec = new Object();
        var recordcount2TQ =  component.get("v.recordcount2TQ");
        var recordcount3TQ =  component.get("v.recordcount3TQ");
        var recordcount3TNQ =  component.get("v.recordcount3TNQ");
        var recordcountClosed =  component.get("v.recordcountClosed");
        var recordcountSpec =  component.get("v.recordcountSpec");
        if(recordcount2TQ == undefined) {recordcount2TQ = 0;}
        if(recordcount3TQ == undefined) {recordcount3TQ = 0;}
        if(recordcount3TNQ == undefined) {recordcount3TNQ = 0;}
        if(recordcountClosed == undefined) {recordcountClosed = 0;}
        if(recordcountSpec == undefined) {recordcountSpec = 0;}
        
        var wrapper = component.get("v.nonSpecObjects");
        
        component.set("v.displayMessageText",true);
        /*if( wrapper.specialty){
            var len = wrapper.specialty.length;
            if( len && len > 0){
                var lastSpec = wrapper.specialty[len - 1];
                if( lastSpec && lastSpec.Id != null && lastSpec.Id != '' && lastSpec.Id != undefined ){
                    helper.createRGSpec(component, event, helper);
                    newSpec = component.get("v.newobject");
                    wrapper.specialty.push(newSpec); 
                    recordcountSpec = recordcountSpec + 1;
                    component.set("v.recordcountSpec", recordcountSpec);
                }
            }
        }*/
        
        
        if(is2TQ == true){
            
            var temp = 0;
            var latestRec= new Object();
            for(var i =0 ;i< wrapper.rg2TQ.length ;i++){
                if(temp != 0){
                    if(wrapper.rg2TQ[i].Year__c != 'All' && temp < wrapper.rg2TQ[i].Year__c){
                        temp = wrapper.rg2TQ[i].Year__c;
                        latestRec = wrapper.rg2TQ[i];
                    }
                } else {
                    temp = wrapper.rg2TQ[i].Year__c;
                    latestRec = wrapper.rg2TQ[i];
                }
            }
            
            helper.createRGNonSpec(component, event, helper, latestRec);
            new2TQ = component.get("v.newobject");
            new2TQ.Plan_Design__c = '2 Tier Q';
            wrapper.rg2TQ.push(new2TQ); 
            recordcount2TQ = recordcount2TQ + 1;
            component.set("v.recordcount2TQ", recordcount2TQ);
            
            helper.createRGSpec(component, event, helper, latestRec);
            var newSpec = component.get("v.newobject");
            newSpec.Plan_Design__c = '2 Tier Q';
            wrapper.specialty.push(newSpec); 
            var recordcountSpec = component.get("v.recordcountSpec") + 1;
            component.set("v.recordcountSpec", recordcountSpec);
            
            
        }
        if(is3TQ == true){
            var temp = 0;
            var latestRec= new Object();
            for(var i =0 ;i< wrapper.rg3TQ.length ;i++){
                if(temp != 0){
                    if(wrapper.rg3TQ[i].Year__c != 'All' && temp < wrapper.rg3TQ[i].Year__c){
                        temp = wrapper.rg3TQ[i].Year__c;
                        latestRec = wrapper.rg3TQ[i];
                    }
                } else {
                    temp = wrapper.rg3TQ[i].Year__c;
                    latestRec = wrapper.rg3TQ[i];
                }
            }
            //alert('temp1----'+temp1);
            //alert('latestRec1----'+latestRec1);
            
            helper.createRGNonSpec(component, event, helper, latestRec);
            new3TQ = component.get("v.newobject");
            new3TQ.Plan_Design__c = '3 Tier Q';
            wrapper.rg3TQ.push(new3TQ);
            recordcount3TQ = recordcount3TQ + 1;
            component.set("v.recordcount3TQ", recordcount3TQ);
            
            helper.createRGSpec(component, event, helper, latestRec);
            var newSpec = component.get("v.newobject");
            newSpec.Plan_Design__c = '3 Tier Q'; 
            wrapper.specialty.push(newSpec);
            var recordcountSpec = component.get("v.recordcountSpec") + 1;
            component.set("v.recordcountSpec", recordcountSpec);
            
            
        }
        if(is3TNQ == true ){
            var temp = 0;
            var latestRec= new Object();
            for(var i =0 ;i< wrapper.rg3TNQ.length ;i++){
                if(temp != 0){
                    if(wrapper.rg3TNQ[i].Year__c != 'All' && temp < wrapper.rg3TNQ[i].Year__c){
                        temp = wrapper.rg3TNQ[i].Year__c;
                        latestRec = wrapper.rg3TNQ[i];
                    }
                } else {
                    temp = wrapper.rg3TNQ[i].Year__c;
                    latestRec = wrapper.rg3TNQ[i];
                }
            }

            helper.createRGNonSpec(component, event, helper, latestRec);
            new3TNQ = component.get("v.newobject");
            new3TNQ.Plan_Design__c = '3 Tier NQ';
            wrapper.rg3TNQ.push(new3TNQ); 
            recordcount3TNQ = recordcount3TNQ + 1;
            component.set("v.recordcount3TNQ", recordcount3TNQ);
            
            helper.createRGSpec(component, event, helper, latestRec);
            var newSpec = component.get("v.newobject");
            newSpec.Plan_Design__c = '3 Tier NQ';
            wrapper.specialty.push(newSpec); 
            var recordcountSpec = component.get("v.recordcountSpec") + 1;
            component.set("v.recordcountSpec", recordcountSpec);
            
        }
        if(isClosed == true){
            var temp = 0;
            var latestRec= new Object();
            for(var i =0 ;i< wrapper.closed.length ;i++){
                if(temp != 0){
                    if(wrapper.closed[i].Year__c != 'All' && temp < wrapper.closed[i].Year__c){
                        temp = wrapper.closed[i].Year__c;
                        latestRec = wrapper.closed[i];
                    }
                } else {
                    temp = wrapper.closed[i].Year__c;
                    latestRec = wrapper.closed[i];
                }
            }

            
            helper.createRGNonSpec(component, event, helper, latestRec);
            newClosed = component.get("v.newobject");
            newClosed.Plan_Design__c = 'Closed';
            wrapper.closed.push(newClosed); 
            recordcountClosed = recordcountClosed + 1;
            component.set("v.recordcountClosed", recordcountClosed);
            
            helper.createRGSpec(component, event, helper, latestRec);
            var newSpec = component.get("v.newobject");
            newSpec.Plan_Design__c = 'Closed';
            wrapper.specialty.push(newSpec); 
            var recordcountSpec = component.get("v.recordcountSpec") + 1;
            component.set("v.recordcountSpec", recordcountSpec);
                        
        }
        
        component.set("v.is2TQDisabled",true);
        component.set("v.is3TQDisabled",true);
        component.set("v.is3TNQDisabled",true);
        component.set("v.isClosedDisabled",true);
        
        component.set("v.nonSpecObjects",wrapper);
    },
    handle2TQ : function(component, event, helper)  {
        var is2TQ = component.get("v.nonSpecObjects.is2TQ");
        var new2TQ = new Object();
        var recordcount2TQ =  component.get("v.recordcount2TQ");
        if(recordcount2TQ == undefined) {recordcount2TQ = 0;}
        var wrapper = component.get("v.nonSpecObjects");
        if(is2TQ == true  && recordcount2TQ == 0){
            helper.createRGNonSpec(component, event, helper);
            
            new2TQ = component.get("v.newobject");
            new2TQ.Plan_Design__c = '2 Tier Q'; 
            wrapper.rg2TQ.push(new2TQ); 
            recordcount2TQ = recordcount2TQ + 1;
            
            component.set("v.recordcount2TQ", recordcount2TQ);
            
            if( wrapper.specialty){
                /*var len = wrapper.specialty.length;
                if( len && len > 0){
                    var lastSpec = wrapper.specialty[len - 1];
                    if( lastSpec && lastSpec.Id != null && lastSpec.Id != '' && lastSpec.Id != undefined ){
                        helper.createRGSpec(component, event, helper);
                        var newSpec = component.get("v.newobject");
                        newSpec.Plan_Design__c = '2 Tier Q';
                        wrapper.specialty.push(newSpec); 
                        var recordcountSpec = component.get("v.recordcountSpec") + 1;
                        component.set("v.recordcountSpec", recordcountSpec);
                    }
                }*/
                helper.createRGSpec(component, event, helper);
                var newSpec = component.get("v.newobject");
                newSpec.Plan_Design__c = '2 Tier Q';
                wrapper.specialty.push(newSpec); 
                var recordcountSpec = component.get("v.recordcountSpec") + 1;
                component.set("v.recordcountSpec", recordcountSpec);
            }
            
            component.set("v.nonSpecObjects",wrapper);
            
            component.set("v.disablebtn",true);
        component.set("v.displayMessageText",true);
            
            var appEvent1 = $A.get("e.c:Apttus_Grid_Rebate_SectionAvailableEvent");
            appEvent1.setParams({ 
                "isAvailable" : true,
                "section" : "2TQ"
            });
            appEvent1.fire();
        } else if(is2TQ == false && recordcount2TQ > 0){
            component.set("v.planDesignOption","2 Tier Q");
            component.set("v.isDeleteAlertOpen", true);
            
            var appEvent1 = $A.get("e.c:Apttus_Grid_Rebate_SectionAvailableEvent");
            appEvent1.setParams({ 
                "isAvailable" : false,
                "section" : "2TQ"
            });
            appEvent1.fire();
        } 
    },
    
    handle3TQ : function(component, event, helper)  {
        var is3TQ = component.get("v.nonSpecObjects.is3TQ");
        var new3TQ = new Object();
        var recordcount3TQ =  component.get("v.recordcount3TQ");
        if(recordcount3TQ == undefined) {recordcount3TQ = 0;}
        var wrapper = component.get("v.nonSpecObjects");
        
        if(is3TQ == true && recordcount3TQ == 0){
            helper.createRGNonSpec(component, event, helper);
            
            new3TQ = component.get("v.newobject");
            new3TQ.Plan_Design__c = '3 Tier Q';
            wrapper.rg3TQ.push(new3TQ); 
            recordcount3TQ = recordcount3TQ + 1;
            
            component.set("v.recordcount3TQ", recordcount3TQ);
            
            if( wrapper.specialty){
                /*var len = wrapper.specialty.length;
                if( len && len > 0){
                    var lastSpec = wrapper.specialty[len - 1];
                    if( lastSpec && lastSpec.Id != null && lastSpec.Id != '' && lastSpec.Id != undefined ){
                        helper.createRGSpec(component, event, helper);
                        var newSpec = component.get("v.newobject");
                        newSpec.Plan_Design__c = '3 Tier Q';
                        wrapper.specialty.push(newSpec); 
                        var recordcountSpec = component.get("v.recordcountSpec") + 1;
                        component.set("v.recordcountSpec", recordcountSpec);
                    }
                }*/
                helper.createRGSpec(component, event, helper);
                var newSpec = component.get("v.newobject");
                newSpec.Plan_Design__c = '3 Tier Q';
                wrapper.specialty.push(newSpec); 
                var recordcountSpec = component.get("v.recordcountSpec") + 1;
                component.set("v.recordcountSpec", recordcountSpec);
            }
            
            component.set("v.nonSpecObjects",wrapper);
            
            component.set("v.disablebtn",true);
        component.set("v.displayMessageText",true);
            
            var appEvent2 = $A.get("e.c:Apttus_Grid_Rebate_SectionAvailableEvent");
            appEvent2.setParams({ 
                "isAvailable" : true,
                "section" : "3TQ"
            });
            appEvent2.fire();
        } else if(is3TQ == false && recordcount3TQ > 0){
            component.set("v.planDesignOption","3 Tier Q");
            component.set("v.isDeleteAlertOpen", true);
            
            var appEvent2 = $A.get("e.c:Apttus_Grid_Rebate_SectionAvailableEvent");
            appEvent2.setParams({ 
                "isAvailable" : false,
                "section" : "3TQ"
            });
            appEvent2.fire();
        }
    },
    
    handle3TNQ : function(component, event, helper)  {
        var is3TNQ = component.get("v.nonSpecObjects.is3TNQ");
        var new3TNQ = new Object();
        var recordcount3TNQ =  component.get("v.recordcount3TNQ");
        if(recordcount3TNQ == undefined) {recordcount3TNQ = 0;}
        var wrapper = component.get("v.nonSpecObjects");
        
        if(is3TNQ == true && recordcount3TNQ == 0){
            helper.createRGNonSpec(component, event, helper);
            
            new3TNQ = component.get("v.newobject");
            new3TNQ.Plan_Design__c = '3 Tier NQ';
            wrapper.rg3TNQ.push(new3TNQ); 
            recordcount3TNQ = recordcount3TNQ + 1;
            
            component.set("v.recordcount3TNQ", recordcount3TNQ);
            
            if( wrapper.specialty){
                /*var len = wrapper.specialty.length;
                if( len && len > 0){
                    var lastSpec = wrapper.specialty[len - 1];
                    if( lastSpec && lastSpec.Id != null && lastSpec.Id != '' && lastSpec.Id != undefined ){
                        helper.createRGSpec(component, event, helper);
                        var newSpec = component.get("v.newobject");
                        newSpec.Plan_Design__c = '3 Tier NQ';
                        wrapper.specialty.push(newSpec); 
                        var recordcountSpec = component.get("v.recordcountSpec") + 1;
                        component.set("v.recordcountSpec", recordcountSpec);
                    }
                }*/
                helper.createRGSpec(component, event, helper);
                var newSpec = component.get("v.newobject");
                newSpec.Plan_Design__c = '3 Tier NQ';
                wrapper.specialty.push(newSpec); 
                var recordcountSpec = component.get("v.recordcountSpec") + 1;
                component.set("v.recordcountSpec", recordcountSpec);
            }
            
            component.set("v.nonSpecObjects",wrapper);
            
            component.set("v.disablebtn",true);
        component.set("v.displayMessageText",true);
            
            var appEvent3 = $A.get("e.c:Apttus_Grid_Rebate_SectionAvailableEvent");
            appEvent3.setParams({ 
                "isAvailable" : true,
                "section" : "3TNQ"
            });
            appEvent3.fire();
        } else if(is3TNQ == false && recordcount3TNQ > 0){
            component.set("v.planDesignOption","3 Tier NQ");
            component.set("v.isDeleteAlertOpen", true);
            
            var appEvent3 = $A.get("e.c:Apttus_Grid_Rebate_SectionAvailableEvent");
            appEvent3.setParams({ 
                "isAvailable" : false,
                "section" : "3TNQ"
            });
            appEvent3.fire();
        }
    },
    
    handleClosed : function(component, event, helper)  {
        var isClosed = component.get("v.nonSpecObjects.isClosed");
        var newClosed = new Object();
        var recordcountClosed =  component.get("v.recordcountClosed");
        if(recordcountClosed == undefined) {recordcountClosed = 0;}
        var wrapper = component.get("v.nonSpecObjects");
        
        if(isClosed == true && recordcountClosed == 0){
            helper.createRGNonSpec(component, event, helper);
            
            newClosed = component.get("v.newobject");
            newClosed.Plan_Design__c = 'Closed';
            wrapper.closed.push(newClosed); 
            recordcountClosed = recordcountClosed + 1;
            
            component.set("v.recordcountClosed", recordcountClosed);
            
            if( wrapper.specialty){
                /*var len = wrapper.specialty.length;
                if( len && len > 0){
                    var lastSpec = wrapper.specialty[len - 1];
                    if( lastSpec && lastSpec.Id != null && lastSpec.Id != '' && lastSpec.Id != undefined ){
                        helper.createRGSpec(component, event, helper);
                        var newSpec = component.get("v.newobject");
                        newSpec.Plan_Design__c = 'Closed';
                        wrapper.specialty.push(newSpec); 
                        var recordcountSpec = component.get("v.recordcountSpec") + 1;
                        component.set("v.recordcountSpec", recordcountSpec);
                    }
                }*/
                helper.createRGSpec(component, event, helper);
                var newSpec = component.get("v.newobject");
                newSpec.Plan_Design__c = 'Closed';
                wrapper.specialty.push(newSpec); 
                var recordcountSpec = component.get("v.recordcountSpec") + 1;
                component.set("v.recordcountSpec", recordcountSpec);
            }
            
            component.set("v.nonSpecObjects",wrapper);
            
            component.set("v.disablebtn",true);
        component.set("v.displayMessageText",true);
            
            var appEvent4 = $A.get("e.c:Apttus_Grid_Rebate_SectionAvailableEvent");
            appEvent4.setParams({ 
                "isAvailable" : true,
                "section" : "Closed"
            });
            appEvent4.fire();
        } else if(isClosed == false && recordcountClosed > 0){
            component.set("v.planDesignOption","Closed");
            component.set("v.isDeleteAlertOpen", true);
            
            var appEvent4 = $A.get("e.c:Apttus_Grid_Rebate_SectionAvailableEvent");
            appEvent4.setParams({ 
                "isAvailable" : false,
                "section" : "Closed"
            });
            appEvent4.fire();
        }
    },
    cancleDeleteAlert : function(component, event, helper)  {
        helper.cancleDeleteAlertHelper(component,event,helper);
    },
    deleteSelectedRec : function(component, event, helper)  {
        component.set("v.isDeleteAlertOpen", false);
        component.set("{!v.DisplaySpinner}", true);
        helper.deleteSelectedRecords(component,event,helper);
    },
    updateGstp : function(component, event, helper)  {
        component.set("v.gstp",component.find("gstp").get("v.value"));
    },
	updatedesc : function(component, event, helper)  {
        component.set("v.desc",component.find("desc").get("v.value"));
    },
    updateNonspecForm : function(component, event, helper)  {
        component.set("v.nonspecForm",component.find("nonspecForm").get("v.value"));
    },
    updateBasis : function(component, event, helper)  {
        component.set("v.basis",component.find("basis").get("v.value"));
    },
    updatelob : function(component, event, helper)  {
        component.set("v.lob",component.find("lob").get("v.value"));
    },
    deletedRGRow : function(component, event, helper)  {
        var section = event.getParam("section");
        var isDeleteSuccess = event.getParam("isDeleteSuccess");        
        var delIndex = event.getParam("delIndex"); 
        var delObjId = event.getParam("delObjId");
        var wrapper = component.get("v.nonSpecObjects");
        var planDesigned = '';
        if(section == "2TQ" ){
            planDesigned = '2 Tier Q';
        }
        if(section == '3TQ'){
            planDesigned = '3 Tier Q';
        }
        if(section == '3TNQ'){
            planDesigned = '3 Tier NQ';
        }
        if(section == 'Closed'){
            planDesigned = 'Closed';
        }
        
        if((section == "2TQ" || section == "3TQ" || section == "3TNQ" || section == "Closed") && isDeleteSuccess){
            if(wrapper.specialty){
                if(delObjId ) {
                    var len = wrapper.specialty.length;
                    for(var i = 0 ; i< len ;i++){
                        if(wrapper.specialty[i] != undefined){
                            if(delObjId == wrapper.specialty[i].Id){
                                var recordcountSpec = component.get("v.recordcountSpec");
                                recordcountSpec = recordcountSpec - 1;
                                component.set("v.recordcountSpec", recordcountSpec);
                                wrapper.specialty.splice(i, 1);
                                
                                if(component.get("v.recordcountSpec") < 1){
                                    component.set("v.nonSpecObjects.isSpec", false);
                                    var appEvent5 = $A.get("e.c:Apttus_Grid_Rebate_SectionAvailableEvent");
                                    appEvent5.setParams({ 
                                        "isAvailable" : false,
                                        "section" : "Specialty"
                                    });
                                    appEvent5.fire();
                                }
                                component.set("v.nonSpecObjects",wrapper);
                            }
                        }
                    }
                } else {
                    var len = wrapper.specialty.length;
                    for(var i = 0 ; i< len ;i++){
                        if(wrapper.specialty[i] != undefined){
                            if(wrapper.specialty[i].Id == null && wrapper.specialty[i].Plan_Design__c == planDesigned){
                                var recordcountSpec = component.get("v.recordcountSpec");
                                recordcountSpec = recordcountSpec - 1;
                                component.set("v.recordcountSpec", recordcountSpec);
                                wrapper.specialty.splice(i, 1);
                                
                                if(component.get("v.recordcountSpec") < 1){
                                    component.set("v.nonSpecObjects.isSpec", false);
                                    var appEvent5 = $A.get("e.c:Apttus_Grid_Rebate_SectionAvailableEvent");
                                    appEvent5.setParams({ 
                                        "isAvailable" : false,
                                        "section" : "Specialty"
                                    });
                                    appEvent5.fire();
                                }
                                component.set("v.nonSpecObjects",wrapper);
                            }
                        }
                    }
                }
            } 
        }
        
        if (section == "2TQ" && isDeleteSuccess  && component.get("v.recordcount2TQ") > 0){
            var recordcount2TQ = component.get("v.recordcount2TQ");
        	recordcount2TQ = recordcount2TQ - 1;
            component.set("v.recordcount2TQ", recordcount2TQ);
            wrapper.rg2TQ.splice(delIndex, 1);
        
            if(component.get("v.recordcount2TQ") < 1){
                component.set("v.nonSpecObjects.is2TQ", false);
                var appEvent1 = $A.get("e.c:Apttus_Grid_Rebate_SectionAvailableEvent");
                appEvent1.setParams({ 
                    "isAvailable" : false,
                    "section" : "2TQ"
                });
                appEvent1.fire();
        	}
          	component.set("v.nonSpecObjects",wrapper);
        }
        if (section == "3TQ" && isDeleteSuccess  && component.get("v.recordcount3TQ") > 0){
            var recordcount3TQ = component.get("v.recordcount3TQ");
        	recordcount3TQ = recordcount3TQ - 1;
            component.set("v.recordcount3TQ", recordcount3TQ);
            wrapper.rg3TQ.splice(delIndex, 1);
        
            if(component.get("v.recordcount3TQ") < 1){
                component.set("v.nonSpecObjects.is3TQ", false);
                var appEvent2 = $A.get("e.c:Apttus_Grid_Rebate_SectionAvailableEvent");
                appEvent2.setParams({ 
                    "isAvailable" : false,
                    "section" : "3TQ"
                });
                appEvent2.fire();
        	}
            component.set("v.nonSpecObjects",wrapper);
        }
        if (section == "3TNQ" && isDeleteSuccess  && component.get("v.recordcount3TNQ") > 0){         
            var recordcount3TNQ = component.get("v.recordcount3TNQ");
        	recordcount3TNQ = recordcount3TNQ - 1;
            component.set("v.recordcount3TNQ", recordcount3TNQ);
            wrapper.rg3TNQ.splice(delIndex, 1);
        
            if(component.get("v.recordcount3TNQ") < 1){
                component.set("v.nonSpecObjects.is3TNQ", false);
                var appEvent3 = $A.get("e.c:Apttus_Grid_Rebate_SectionAvailableEvent");
                appEvent3.setParams({ 
                    "isAvailable" : false,
                    "section" : "3TNQ"
                });
                appEvent3.fire();
        	}
            component.set("v.nonSpecObjects",wrapper);
        }
        if (section == "Closed" && isDeleteSuccess  && component.get("v.recordcountClosed") > 0){
            var recordcountClosed = component.get("v.recordcountClosed");
        	recordcountClosed = recordcountClosed - 1;
            component.set("v.recordcountClosed", recordcountClosed);
            wrapper.closed.splice(delIndex, 1);
        
            if(component.get("v.recordcountClosed") < 1){
                component.set("v.nonSpecObjects.isClosed", false);
                var appEvent4 = $A.get("e.c:Apttus_Grid_Rebate_SectionAvailableEvent");
                appEvent4.setParams({ 
                    "isAvailable" : false,
                    "section" : "Closed"
                });
                appEvent4.fire();
        	}
            component.set("v.nonSpecObjects",wrapper);
        }
        
        if (section == "Specialty" && isDeleteSuccess && component.get("v.recordcountSpec") > 0){
            //alert('delIndex--------------'+delIndex);
            var recordcountSpec = component.get("v.recordcountSpec");
        	recordcountSpec = recordcountSpec - 1;
            component.set("v.recordcountSpec", recordcountSpec);
            wrapper.specialty.splice(delIndex, 1);
            var len = wrapper.specialty.length;
            
            
            if(component.get("v.recordcountSpec") < 1){
                component.set("v.nonSpecObjects.isSpec", false);
                var appEvent5 = $A.get("e.c:Apttus_Grid_Rebate_SectionAvailableEvent");
                appEvent5.setParams({ 
                    "isAvailable" : false,
                    "section" : "Specialty"
                });
                appEvent5.fire();
        	}
            if(delObjId){
                if(wrapper.rg2TQ) {
                    var len = wrapper.rg2TQ.length;
                    for(var i = 0 ; i< len ;i++){
                        if(wrapper.rg2TQ[i] != undefined){
                            if(delObjId == wrapper.rg2TQ[i].Id){
                                var recordcount2TQ = component.get("v.recordcount2TQ");
                                recordcount2TQ = recordcount2TQ - 1;
                                component.set("v.recordcount2TQ", recordcount2TQ);
                                wrapper.rg2TQ.splice(i, 1);
                                
                                if(component.get("v.recordcount2TQ") < 1){
                                    component.set("v.nonSpecObjects.is2TQ", false);
                                    var appEvent1 = $A.get("e.c:Apttus_Grid_Rebate_SectionAvailableEvent");
                                    appEvent1.setParams({ 
                                        "isAvailable" : false,
                                        "section" : "2TQ"
                                    });
                                    appEvent1.fire();
                                }
                            }
                        }
                    }
                }
                if(wrapper.rg3TQ) {
                    var len = wrapper.rg3TQ.length;
                    for(var i = 0 ; i< len ;i++){
                        if(wrapper.rg3TQ[i] != undefined){
                            if(delObjId == wrapper.rg3TQ[i].Id){
                                var recordcount3TQ = component.get("v.recordcount3TQ");
                                recordcount3TQ = recordcount3TQ - 1;
                                component.set("v.recordcount3TQ", recordcount3TQ);
                                wrapper.rg3TQ.splice(i, 1);
                                
                                if(component.get("v.recordcount3TQ") < 1){
                                    component.set("v.nonSpecObjects.is3TQ", false);
                                    var appEvent2 = $A.get("e.c:Apttus_Grid_Rebate_SectionAvailableEvent");
                                    appEvent2.setParams({ 
                                        "isAvailable" : false,
                                        "section" : "3TQ"
                                    });
                                    appEvent2.fire();
                                }
                            }
                        }
                    }
                }
                if(wrapper.rg3TNQ) {
                    var len = wrapper.rg3TNQ.length;
                    for(var i = 0 ; i< len ;i++){
                        if(wrapper.rg3TNQ[i] != undefined){
                            if(delObjId == wrapper.rg3TNQ[i].Id){
                                var recordcount3TNQ = component.get("v.recordcount3TNQ");
                                recordcount3TNQ = recordcount3TNQ - 1;
                                component.set("v.recordcount3TNQ", recordcount3TNQ);
                                wrapper.rg3TNQ.splice(i, 1);
                                
                                if(component.get("v.recordcount3TNQ") < 1){
                                    component.set("v.nonSpecObjects.is3TNQ", false);
                                    var appEvent3 = $A.get("e.c:Apttus_Grid_Rebate_SectionAvailableEvent");
                                    appEvent3.setParams({ 
                                        "isAvailable" : false,
                                        "section" : "3TNQ"
                                    });
                                    appEvent3.fire();
                                }
                            }
                        }
                    }
                }
                if(wrapper.closed) {
                    var len = wrapper.closed.length;
                    for(var i = 0 ; i< len ;i++){
                        if(wrapper.closed[i] != undefined){
                            if(delObjId == wrapper.closed[i].Id){
                                var recordcountClosed = component.get("v.recordcountClosed");
                                recordcountClosed = recordcountClosed - 1;
                                component.set("v.recordcountClosed", recordcountClosed);
                                wrapper.closed.splice(i, 1);
                                
                                if(component.get("v.recordcountClosed") < 1){
                                    component.set("v.nonSpecObjects.isClosed", false);
                                    var appEvent4 = $A.get("e.c:Apttus_Grid_Rebate_SectionAvailableEvent");
                                    appEvent4.setParams({ 
                                        "isAvailable" : false,
                                        "section" : "Closed"
                                    });
                                    appEvent4.fire();
                                }
                            }
                        }
                    }
                }
            }
            component.set("v.nonSpecObjects",wrapper);
        }
        
    },
    save2TQMatchTo : function(component, event, helper)  {
        var inputcmp1 = component.find("copyFrom2TQ");
        var value = inputcmp1.get("v.value");
        if(value == null || value =="none") {
            $A.util.addClass(inputcmp1, "slds-has-error");
        } else {
            $A.util.removeClass(inputcmp1, "slds-has-error");
            component.set("v.matchToFromGrid", "2TQ");
            component.set("v.matchToToGrid", value);
            
            var appEventSave = $A.get("e.c:Apttus_Grid_NT_Save_Event");
            appEventSave.setParams({ 
                "SaveRec" : true,
                "isMatchToSave" : true,
                "matchToToGrid" :component.get("v.matchToToGrid")
            });
            appEventSave.fire();	
        }
    },
    save3TQMatchTo : function(component, event, helper)  {
        var inputcmp1 = component.find("copyFrom3TQ");
        var value = inputcmp1.get("v.value");
        if(value == null || value =="none") {
            $A.util.addClass(inputcmp1, "slds-has-error");
        } else {
            $A.util.removeClass(inputcmp1, "slds-has-error");
            component.set("v.matchToFromGrid", "3TQ");
            component.set("v.matchToToGrid", value);
            //alert('save3TQMatchTo---------'+value);
            
            var appEventSave = $A.get("e.c:Apttus_Grid_NT_Save_Event");
            appEventSave.setParams({ 
                "SaveRec" : true,
                "isMatchToSave" : true,
                "matchToToGrid" :component.get("v.matchToToGrid")
            });
            appEventSave.fire();	
        }
    },
    save3TNQMatchTo : function(component, event, helper)  {
        var inputcmp1 = component.find("copyFrom3TNQ");
        var value = inputcmp1.get("v.value");
        if(value == null || value =="none") {
            $A.util.addClass(inputcmp1, "slds-has-error");
        } else {
            $A.util.removeClass(inputcmp1, "slds-has-error");
            component.set("v.matchToFromGrid", "3TNQ");
            component.set("v.matchToToGrid", value);
            
            var appEventSave = $A.get("e.c:Apttus_Grid_NT_Save_Event");
            appEventSave.setParams({ 
                "SaveRec" : true,
                "isMatchToSave" : true,
                "matchToToGrid" :component.get("v.matchToToGrid")
            });
            appEventSave.fire();	
        }
    },
    saveClosedMatchTo : function(component, event, helper)  {
        var inputcmp1 = component.find("copyFromClosed");
        var value = inputcmp1.get("v.value");
        if(value == null || value =="none") {
            $A.util.addClass(inputcmp1, "slds-has-error");
        } else {
            $A.util.removeClass(inputcmp1, "slds-has-error");
            component.set("v.matchToFromGrid", "Closed");
            component.set("v.matchToToGrid", value);
            
            var appEventSave = $A.get("e.c:Apttus_Grid_NT_Save_Event");
            appEventSave.setParams({ 
                "SaveRec" : true,
                "isMatchToSave" : true,
                "matchToToGrid" :component.get("v.matchToToGrid")
            });
            appEventSave.fire();	
        }
    },
    
})