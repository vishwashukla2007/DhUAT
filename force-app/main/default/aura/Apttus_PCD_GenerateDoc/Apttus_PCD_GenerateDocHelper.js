({
    getColumns : function(component) {
        component.set('v.columns', [
            {label: 'Name', fieldName: 'Name', type: 'text'},
            {label: 'Type', fieldName: 'Apttus__Agreement_Types__c', type: 'text'},
            {label: 'Guidance', fieldName: 'Apttus__Guidance__c', type: 'text'},
            {label: 'Category', fieldName: 'Apttus__Category__c', type: 'text'},
            {label: 'Sub-Category', fieldName: 'Apttus__Subcategory__c', type: 'text'} 
        ]);
    },
    getTemplates : function(component,event, helper) {
        var action = component.get("c.getTemplates");
        var pageSize = component.get("v.pageSize").toString();
        var pageNumber = component.get("v.pageNumber").toString();
       // var selected = event.getSource().get("v.label");
         
        action.setParams({
            'pageSize' : pageSize,
            'pageNumber' : pageNumber
        });
        
        action.setCallback(this,function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var resultData = response.getReturnValue();
                if(resultData.length < component.get("v.pageSize")){
                    component.set("v.isLastPage", true);
                } else{
                    component.set("v.isLastPage", false);
                }
                component.set("v.dataSize", resultData.length);
                component.set("v.data", resultData);
            }
        });
        $A.enqueueAction(action);
    },
     createDocVersionDetail : function(component, helper) {
        var action = component.get("c.createDocVersionRecord");
        var selectedRowList = component.get("v.selectedRowList");
         var selectedfiletype = "docx";
         if(component.find("pdf").get("v.value") == true)
         {
             selectedfiletype = "pdf";
         }
        else
        {
            selectedfiletype = "docx";
        }
         
        action.setParams({
            'selectedRowIds' : selectedRowList,
            "selectedfiletype": selectedfiletype,
           "agreementid" : component.get("v.record")
        });
        
        action.setCallback(this,function(response) {
            var state = response.getState();
            var title = '';
            var type = '';
            var message = '';
            if (state === "SUCCESS") {
                //alert('Record is Created Successfully');
                title = 'Success';
                type = 'success';
                message = 'Record is Created Successfully';
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": title,
                    "type": type,
                    "message": message
                });
                toastEvent.fire();
            }
        });
        $A.enqueueAction(action);
    },

})