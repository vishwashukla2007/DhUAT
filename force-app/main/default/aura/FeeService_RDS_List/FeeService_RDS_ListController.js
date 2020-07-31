({
    onInit : function( component, event, helper ) 
    {    
        component.set( 'v.mycolumns', [                
            {label: 'Category', fieldName: 'Section_Limited__c', type: 'text',sortable: true},  
            {label: 'Service', fieldName: 'RDSURL', type: 'url',sortable: true,typeAttributes: {label: { fieldName: 'Service__c' }, target: '_blank'}},
            {label: 'Election', fieldName: 'Election__c', type: 'boolean',sortable: true,editable: true},
            {label: 'Status', fieldName: 'Status__c', type: 'text',sortable: true,editable: false},
            {label: 'Fee', fieldName: 'Amount__c', type: 'currency',sortable: true,cellAttributes: {alignment: 'left'}, typeAttributes: { currencyCode: 'USD'}, editable: true}, 
            {label: 'Basis', fieldName: 'Basis2__c', type: 'text',sortable: true},
            {label: 'Service Effective Date', fieldName: 'Service_Effective_Date__c', type: 'date-local',sortable: true,editable: true},
            {label: 'Last Modified Date', fieldName: 'Last_Date_Modified__c', type: 'text',sortable: true},
            //{label: 'Last Modified Date', fieldName: 'lastModifedOn', type: 'date-local',sortable: true,typeAttributes:{month: "short",day: "2-digit"}},
            {label: 'Notes', fieldName: 'RDSURLNote', type: 'url',sortable: false,typeAttributes: {label: { fieldName: 'note' }, target: '_blank'}},
        ]);    
            helper.fetchFeebasis(component);          
            },
            closeError : function( component, event, helper ){
            component.set("v.isShowError", false);     
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
            createNewFeeServices :function(cmp, event, helper) 
            {        
            let currentURL = window.location.href;
            
            var url = '/apex/NewRetireeDrugSubsidyPage?CF00N0x000003UMpa_lkid='+cmp.get("v.recordId")+'&redUrl='+ currentURL;
            var urlEvent = $A.get("e.force:navigateToURL");
            urlEvent.setParams({
            "url": url
            });
            urlEvent.fire();
            },
            loadMoreData : function(component,event,helper){
            if(!(component.get("v.currentCount") >= component.get("v.totalRows"))){
            //To display the spinner
            event.getSource().set("v.isLoading", true); 
            //To handle data returned from Promise function
            helper.loadData(component).then(function(data){ 
            var currentData = component.get("v.rdsList");
            var newData = currentData.concat(data);
            var mainisSubmitForReview = false;
            var mainApprove = false;
            var mainNew = false;
            var mainisApprove = false;
            var isShowError = false;
            var profileName = component.get("v.profileName");
            if(profileName != 'Apttus Sales')
            {
            mainNew = true;
            }
            newData.forEach(function(item) {
            var isSubmitForReview = true;
            if(item['Service_Last_Modified_Date__c'] == null && item['Service_Request_Date__c'] == null && item['Approved_Date__c'] == null)
        {
            isSubmitForReview = false;
        }
        if(item['Service_Last_Modified_Date__c'] <= item['Service_Request_Date__c'] && isSubmitForReview)
        {
            isSubmitForReview = false;
        }
        if(item['Election__c'] == false || profileName=='Apttus Underwriting')
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
        
        if((profileName=='Apttus Underwriting' || profileName== 'System Administrator') && item['Status__c'] == 'Review')
        {
            if(mainApprove == false)mainApprove = true;
        } 
        
        var strStatus = (item['Status__c']!=null)?(item['Status__c']):''; 
        if(strStatus.toLowerCase().indexOf("error") != -1)
        {
            isShowError = true;
        }
        item['isSubmitForReview'] = isSubmitForReview;
    });
    newData.forEach(function(item) {
    if(item['isSubmitForReview']){
    if(!mainisSubmitForReview)mainisSubmitForReview = true;
}
 });

if(isShowError == true)
{
    mainisApprove = false;
    mainisSubmitForReview = false;
}
component.set("v.isShowSubmitReview", mainisSubmitForReview);
component.set("v.isShowApprove",mainApprove);
component.set("v.isShowApprove2",mainisApprove);
component.set("v.rdsList", newData);
component.set("v.isShowNew", mainNew);
component.set("v.isShowError", isShowError);
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
},
    approveService : function(component,event,helper){
        var currentData = component.get("v.rdsList");
        var toUpdatedata =[];
        if(currentData && Array.isArray(currentData))
        {
            currentData.forEach(function(item){
                if(item['Election__c'] == true && item['Status__c']=='Review')
                {
                    toUpdatedata.push(item);
                } 
            });
        }
        if(toUpdatedata.length>0)
        {
            helper.updatedata(component,toUpdatedata,true);             
        }else
        {
            helper.toastMsg('Error','Either all records are already approved or No new record found to approved! ','No record found to approve');          
        }
    },
        submitForReview : function(component,event,helper){
            var currentData = component.get("v.rdsList");
            var toUpdatedata =[];
            if(currentData && Array.isArray(currentData))
            {
                currentData.forEach(function(item){
                    if(item['Election__c'] == true && item['isSubmitForReview']==true)
                    {
                        toUpdatedata.push(item);
                    } 
                });
            }
            if(toUpdatedata.length>0)
            {
                helper.updatedataReview(component,toUpdatedata);             
            }else
            {
                helper.toastMsg('Error','Either all records are already submitted for review or No new record found to be submitted for review! ','No record found to be submitted for review');          
            }
        }
})