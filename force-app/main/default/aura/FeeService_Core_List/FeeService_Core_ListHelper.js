({
	fetchFeebasis : function( component ) {
        component.set("v.spinner",true);
        var action = component.get( "c.getFeeserviceCorelist");         
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
                //console.log('res PBM_List: '+ JSON.stringify(res));
                if(res.success){
                    // set total rows count from response wrapper
                    component.set("v.totalRows",res.totalRecords);
                    //component.set("v.profileName",res.profileName);
                    
                    var corelist = res.listCoreServices; 
                    component.set("v.coreList", corelist);
                    var currentCount = component.get("v.currentCount");
                    currentCount = component.get("v.initialRows");
                    // set the current count with number of records loaded 
                    component.set("v.currentCount",currentCount);
                    component.set("v.enableInfiniteLoading",true);
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
        //let fieldsTosort = sortedBy=== 'PBMURL' ? 'Service__c':(sortedBy ==='PBMURLNote'?'note':sortedBy);
        //console.log('sortedBy : ' +fieldsTosort + ';  sortDirection : '+sortDirection );
        var cloneData = cmp.get( "v.coreList");//this.DATA.slice(0);
        cloneData.sort((this.sortBy(fieldsTosort, sortDirection === 'asc' ? 1 : -1)));
        
        cmp.set( "v.coreList", cloneData);                
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
            var action = component.get( "c.getFeeserviceCorelist"); 
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
                    //alert(res.profileName);
                    //component.set("v.isShowApprove",(res.profileName=='Apttus Underwriting'));
                    var corelist = res.listCoreServices; 
                    resolve(corelist);
                    var currentCount = component.get("v.currentCount");
                    currentCount += component.get("v.initialRows");
                    // set the current count with number of records loaded 
                    component.set("v.currentCount",currentCount);
                }
            });
            $A.enqueueAction(action);
        }));
    }
})