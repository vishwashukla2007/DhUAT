({
    onInit : function( component, event, helper ) 
    {    
        component.set( 'v.mycolumns', [  
            //{label: 'Service', fieldName: 'PBMURL', type: 'url',sortable: true,typeAttributes: {label: { fieldName: 'Service__c' }, target: '_blank'}},
           {label: 'Category', fieldName: 'Section__c', type: 'text',sortable: true,editable: false},
            {label: 'Service', fieldName: 'Service__c', type: 'text',sortable: true,editable: false},
            
        ]);    
            helper.fetchFeebasis(component);
            },  
            handleNext : function(component, event, helper) { 
            var pageNumber = component.get("v.pageNumber");
            component.set("v.pageNumber", pageNumber+1);
            helper.fetchFeebasis(component, helper);
            },
            
            handlePrev : function(component, event, helper) {        
            var pageNumber = component.get("v.pageNumber");
            component.set("v.pageNumber", pageNumber-1);
            helper.fetchFeebasis(component, helper);
            },    
            onSave : function( component, event, helper ) {
            var updatedRecords = event.getParam('draftValues');
            helper.updatedata(component,updatedRecords,false);
            //component.find( "pbmTable" ).set( "v.draftValues", null );
            //console.log('Success!');
            },
            Searchlist :function( component, event, helper ) {
            helper.fetchFeebasis(component);
            },
            ClearSearch:function( component, event, helper ) {
            component.set("v.SearchKeyWord",null);
            helper.fetchFeebasis(component);
            },
            handleSort: function(cmp, event, helper) {
            helper.handleSort(cmp, event);
            },
            
            loadMoreData : function(component,event,helper){
            if(!(component.get("v.currentCount") >= component.get("v.totalRows"))){
                //To display the spinner
                event.getSource().set("v.isLoading", true); 
                //To handle data returned from Promise function
                helper.loadData(component).then(function(data){ 
                var currentData = component.get("v.coreList");
                var newData = currentData.concat(data);
                component.set("v.coreList", newData);
                
                //To hide the spinner
                event.getSource().set("v.isLoading", false); 
              });
        }
          else{
            //To stop loading more rows
            component.set("v.enableInfiniteLoading",false);
            event.getSource().set("v.isLoading", false);
            helper.toastMsg('Success',"All records are loaded",'Success');          
            }
    }
})