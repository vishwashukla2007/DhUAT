({
    fetchFeebasis : function( component ) { 
        component.set("v.spinner",true);
        var action = component.get( "c.getFeeservicechildlist");         
        action.setParams({
            "RecordId" : component.get("v.recordId"),
            "srchKey" : component.get("v.SearchKeyWord"),
            "recordLimit" : '50',
            "recordOffset" : '0'
        });
        action.setCallback(this, function( response ) {    
            var state = response.getState();    
            if (state === "SUCCESS")
            {
                var res = response.getReturnValue();
                console.log('res1 : '+ JSON.stringify(res));
                if(res.success){
                    // set total rows count from response wrapper
                    component.set("v.totalRows",res.totalRecords); 
                    component.set("v.profileName",res.profileName);
                    var rdslist = res.listRDSServices; 
                    var mainisSubmitForReview = false;
                    var mainApprove = false;
                    var mainisApprove = false;                        
                    var mainNew = false;
                    var isShowError = false;
                    if(res.profileName != 'Apttus Sales')
                    {
                        mainNew = true;
                    }
                    rdslist.forEach(function(item) {
                        var isSubmitForReview = true;
                        if(item['Service_Last_Modified_Date__c'] == null && item['Service_Request_Date__c'] == null && item['Approved_Date__c'] == null)
                        {
                            isSubmitForReview = false;
                        }
                        if(item['Service_Last_Modified_Date__c'] <= item['Service_Request_Date__c'] && isSubmitForReview)
                        {
                            isSubmitForReview = false;
                        }
                        if(item['Election__c'] == false || res.profileName=='Apttus Underwriting')
                        {
                            isSubmitForReview = false;
                        }
                        
                        if(item['Status__c'] == '' || item['Status__c'] == null || item['Status__c'] == 'Review' || item['Status__c'] == 'Approved')
                        {
                            isSubmitForReview = false;
                        }
                        
                        if(item['Status__c'] == 'Review')
                        {
                            if(mainisApprove == false)mainisApprove = true;
                        }
                        
                        if((res.profileName=='Apttus Underwriting' || res.profileName=='System Administrator') && item['Status__c'] == 'Review')
                        {
                            if(mainApprove == false)mainApprove = true;
                        }
                        
                        var strStatus = (item['Status__c']!=null)?(item['Status__c']):'';  
                        if(strStatus.toLowerCase().indexOf("error") != -1)
                        {
                            isShowError = true;
                        }
                        
                        item['isSubmitForReview'] = isSubmitForReview;
                        
                        console.log("item['Status__c']==="+item['Status__c']);
                        
                        item['RDSURL'] = '/lightning/r/Retiree_Drug_Subsidy__c/' + item['Id'] + '/view';  
                        //item['RDSURLNote'] = '/lightning/r/Retiree_Drug_Subsidy__c/' + item['Id'] + '/view';  
                        item['RDSURLNote'] = $A.util.isUndefinedOrNull(item['Notes__c']) ?'/apex/NewRetireeDrugsubsidyPage?Id=' + item['Id'] :'/lightning/r/Retiree_Drug_Subsidy__c/' + item['Id'] + '/view';
                        item['SERVICEcss'] = item['Additional_Service__c'] === false ? 'slds-cell-edit readOnly' : 'slds-cell-edit normal';
                        item['Service_Description2__c'] = item['Service_Description2__c'] ? item['Service_Description2__c'].replace( /(<([^>]+)>)/ig,'') :'';
                        item['lastModifedOn'] = item['Last_Date_Modified__c'] ? Date.parse(item['Last_Date_Modified__c']):null;
                        item['note'] = $A.util.isUndefinedOrNull(item['Notes__c']) ? 'Add Note':'View Note';
                    });
                    rdslist.forEach(function(item) {
                        if(item['isSubmitForReview']){
                            if(!mainisSubmitForReview)mainisSubmitForReview = true;
                        }
                    });
                    if(isShowError == true)
                    {
                        mainisApprove = false;
                        mainisSubmitForReview = false;
                    }
                    component.set("v.rdsList", rdslist); 
                    component.set("v.isShowSubmitReview", mainisSubmitForReview);
                    component.set("v.isShowApprove",mainApprove);
                    component.set("v.isShowApprove2",mainisApprove);
                    component.set("v.isShowNew", mainNew);
                    component.set("v.isShowError", isShowError);
                    var currentCount = component.get("v.currentCount");
                    currentCount = component.get("v.initialRows");
                    // set the current count with number of records loaded 
                    component.set("v.currentCount",currentCount);
                }
            }     
            component.set("v.spinner",false); 
        });    
        $A.enqueueAction(action);   
        
    },  
    
    toastMsg : function( strType, strMessage,title ) 
    {    
        var showToast = $A.get( "e.force:showToast" );   
        showToast.setParams({               
            message : strMessage,  
            type : strType,  
            mode : 'dismissible' ,
            title : title
        });   
        showToast.fire();       
    } ,
    sortBy: function(field, reverse, primer) {
        var key = primer
        ? function(x) {
            return primer(x[field]);
        }
        : function(x) {
            return x[field];
        };
        
        return function(a, b) {
            a = key(a);
            b = key(b);
            return reverse * ((a > b) - (b > a));
        };
    },
    handleSort: function(cmp, event) {
        var sortedBy = event.getParam('fieldName');
        var sortDirection = event.getParam('sortDirection');                
        let fieldsTosort = sortedBy=== 'RDSURL' ? 'Service__c':(sortedBy ==='RDSURLNote'?'note':sortedBy);
        console.log('sortedBy : ' +fieldsTosort + ';  sortDirection : '+sortDirection );
        var cloneData = cmp.get( "v.rdsList");//this.DATA.slice(0);
        cloneData.sort((this.sortBy(fieldsTosort, sortDirection === 'asc' ? 1 : -1)));
        
        cmp.set( "v.rdsList", cloneData);                
        cmp.set('v.sortDirection', sortDirection);
        cmp.set('v.sortedBy', sortedBy);
    },
    loadData : function(component){
        return new Promise($A.getCallback(function(resolve){
            var limit = component.get("v.initialRows");
            var offset = component.get("v.currentCount");
            var totalRows = component.get("v.totalRows");
            if(limit + offset > totalRows){
                limit = totalRows - offset;
            }
            var action = component.get( "c.getFeeservicechildlist"); 
            action.setParams({
                "RecordId" : component.get("v.recordId"),
                "srchKey" : component.get("v.SearchKeyWord"),
                "recordLimit" : limit,
                "recordOffset" : offset
            });            
            action.setCallback(this,function(response){
                var state = response.getState();
                var res = response.getReturnValue();                
                if(res.success){
                    // set total rows count from response wrapper
                    component.set("v.totalRows",res.totalRecords); 
                    var rdslist = res.listRDSServices;           	
                    rdslist.forEach(function(item) {
                        item['RDSURL'] = '/lightning/r/Retiree_Drug_Subsidy__c/' + item['Id'] + '/view';
                        item['RDSURLNote'] = $A.util.isUndefinedOrNull(item['Notes__c']) ?'/apex/NewRetireeDrugsubsidyPage?Id=' + item['Id'] :'/lightning/r/Retiree_Drug_Subsidy__c/' + item['Id'] + '/view';  
                        item['SERVICEcss'] = item['Additional_Service__c'] === false ? 'slds-cell-edit readOnly' : 'slds-cell-edit normal';
                        item['Service_Description2__c'] = item['Service_Description2__c'] ? item['Service_Description2__c'].replace( /(<([^>]+)>)/ig,'') :'';
                        item['lastModifedOn'] = item['Last_Date_Modified__c'] ? Date.parse(item['Last_Date_Modified__c']):null;
                        item['note'] = $A.util.isUndefinedOrNull(item['Notes__c']) ? 'Add Note':'View Note';
                    });
                    resolve(rdslist);
                    var currentCount = component.get("v.currentCount");
                    currentCount += component.get("v.initialRows");
                    // set the current count with number of records loaded 
                    component.set("v.currentCount",currentCount);
                }
            });
            $A.enqueueAction(action);
        }));
    },
    updatedata : function(component,datalist,approve){
        //console.log('log111==='+JSON.stringify(datalist));
        //var updatedRecords = component.find( "pbmTable" ).get( "v.draftValues" );
        component.set("v.spinner",true);
        var action = component.get("c.updateRDSService");  
        action.setParams({             
            'updatedRDSServiceList' : datalist ,
            'approve':approve
        });  
        action.setCallback( this, function( response ) {  
            var state = response.getState();   
            if ( state === "SUCCESS" ) {
                component.set("v.draftValues", []);
                //$A.get('e.force:refreshView').fire();
                let msg = (approve === true)?'Records approved Successfully.': 'Records Saved Successfully.';
                this.toastMsg( 'success', msg);
                this.fetchFeebasis(component);                
            } else {
                if(state === "ERROR"){
                    var errors = response.getError();
                    console.log('error1=='+JSON.stringify(errors));
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            this.toastMsg('error', errors[0].message,'Something went wrong while update');
                        }
                    }
                }                                
            }  
            component.set("v.spinner",false);
        });  
        $A.enqueueAction( action ); 
    },
    updatedataReview : function(component,datalist){
        component.set("v.spinner",true);
        var action = component.get("c.updateRDSServiceReview");  
        action.setParams({             
            'updatedRDSServiceList' : datalist
        });  
        action.setCallback( this, function( response ) {  
            var state = response.getState();   
            if ( state === "SUCCESS" ) {
                component.set("v.draftValues", []);
                let msg = 'Records Submitted Successfully.';
                this.toastMsg('success', msg);
                this.fetchFeebasis(component);                
            } else {
                if(state === "ERROR"){
                    var errors = response.getError();
                    console.log('error=='+JSON.stringify(errors));
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            this.toastMsg('error', errors[0].message,'Something went wrong while update');
                        }
                    }
                }                                
            }  
            component.set("v.spinner",false);
        });  
        $A.enqueueAction( action ); 
    }
})