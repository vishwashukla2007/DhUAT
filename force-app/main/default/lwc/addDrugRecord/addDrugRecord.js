import { LightningElement, api, wire} from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { getPicklistValues } from 'lightning/uiObjectInfoApi';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import SLDP_OBJECT from '@salesforce/schema/Specialty_Drug_Level_Pricing__c';
import DRUGTHERAPHY_FIELD from '@salesforce/schema/Specialty_Drug_Level_Pricing__c.Drug_Therapy__c';
import YEAR_FIELD from '@salesforce/schema/Specialty_Drug_Level_Pricing__c.Year__c';
import DRUGTYPE_FIELD from '@salesforce/schema/Specialty_Drug_Level_Pricing__c.Drug_Type__c';
import createDrugLevelPricing from '@salesforce/apex/addDrugRecordApexController.createDrugLevelPricing';
import checkDuplicateExist from '@salesforce/apex/addDrugRecordApexController.checkDuplicateExist';
import getYear from '@salesforce/apex/addDrugRecordApexController.getYear';


export default class addDrugRecord extends NavigationMixin(LightningElement) {
    //@api fafId = 'a5X0x0000000Oz8EAE';
    //@api specialOpsId = 'a5u0x0000001sUMAAY';
    @api specialOpsId;
    keyIndex = 0;
    isButtonDisabled = false;
    isLoading = true;
    isPicklistLoaded = false;
    
    get itemListSize(){        
        return this.itemList.length >= 2 ? true: false;
    }

    itemList = [
        {
            id: 0,
            drugTherapy : null,
            drugName : null,
            rate : null,
            disabledRate : false,
            year : null,
            notes : null,
            mac : false,
            drugType : null

        }
    ];

    
    @wire(getObjectInfo, { objectApiName: SLDP_OBJECT })
    objectInfo;

    // Getting Drug Theraphy Picklist values using wire service
    drugTherapyOptions = [];
    @wire(getPicklistValues, { recordTypeId: '$objectInfo.data.defaultRecordTypeId', fieldApiName: DRUGTHERAPHY_FIELD})
    drugTherapyValues({error, data}) {
        if(data) {
            let optionsValues = [];
            for(let i = 0; i < data.values.length; i++) {
                optionsValues.push({
                    label: data.values[i].label,
                    value: data.values[i].value
                })
            }           
            this.drugTherapyOptions = optionsValues;
            window.console.log('optionsValues ===> '+JSON.stringify(optionsValues));
        }
        else if(error) {
            window.console.log('error ===> '+JSON.stringify(error));
        }
    }

     //Getting Year Picklist values from FAF > Client Info
     yearOptions2 = [];
     @wire(getYear, { specOpsId: '$specialOpsId'})
     yearValues2({error, data}) {
         if(data) {
             let optionsValues = [];
             for(let i = 0; i < data.length; i++) {
                 optionsValues.push({
                     label: data[i],
                     value: data[i]
                 })
             }                  
             this.yearOptions2 = optionsValues;
             window.console.log('optionsValues ===> '+JSON.stringify(optionsValues));
         }
         else if(error) {
             alert(JSON.stringify(error));
             window.console.log('error ===> '+JSON.stringify(error));
         }
     }

    // Getting Drug Type Picklist values using wire service
    drugTypeOptions = [];
    @wire(getPicklistValues, { recordTypeId: '$objectInfo.data.defaultRecordTypeId', fieldApiName: DRUGTYPE_FIELD})
    drugTypeValues({error, data}) {
        if(data) {
            let optionsValues = [];
            for(let i = 0; i < data.values.length; i++) {
                optionsValues.push({
                    label: data.values[i].label,
                    value: data.values[i].value
                })
            }           
            this.drugTypeOptions = optionsValues;
            window.console.log('optionsValues ===> '+JSON.stringify(optionsValues));
        }
        else if(error) {
            window.console.log('error ===> '+JSON.stringify(error));
        }
    }
    
    get openSpinner() {
        //let spinner = this.isLoading;
        if(!this.isPicklistLoaded){
            if((!this.yearValues2.data && !this.yearValues2.error) && (!this.drugTherapyValues.data && !this.drugTherapyValues.error) && (!this.drugTypeValues.data && !this.drugTypeValues.error)){                
                this.isPicklistLoaded = true;
                this.isLoading = false;                
            }            
        }
        return this.isLoading;
    }

    connectedCallback() {
        //TBD        
    }

    
    addRow() {
        ++this.keyIndex;
        let newItem = [{ id: this.keyIndex, drugTherapy : null, 
            drugName : null, rate : null, disabledRate : false,
            year : null, notes : null, mac : false, drugType : null}];

        this.itemList = [...this.itemList,...newItem];
    }

    cloneRow(event) {      
        let drugIndex = this.itemList.findIndex((item)=>item.id==event.target.accessKey);               
        const cloneDrugItem = this.itemList.filter((item)=>{
            return item.id==event.target.accessKey
        });    
        let newItem;        
        cloneDrugItem.forEach((item)=>{
            ++this.keyIndex;
            newItem = { id: this.keyIndex, drugTherapy : item.drugTherapy, 
                drugName : item.drugName, rate : item.rate, disabledRate : item.disabledRate,
                year : null, notes : item.notes, mac : item.mac, drugType : item.drugType};
        })
        
        this.itemList.splice(++drugIndex,0,newItem);            
        this.itemList = [...this.itemList];               
    }
    
    removeRow(event) {
        if (this.itemList.length >= 2) {
            this.itemList = this.itemList.filter(function (element) {
                return parseInt(element.id) !== parseInt(event.target.accessKey);
            });
        }
    }

    updateItemList(itemId,itemKey,itemValue){        
        let drug = this.itemList.find((item)=> {
            if(item.id==itemId){                
                return item[itemKey] = itemValue;
            }
        })             
    }

    handleChange(event){         
        if(event.target.name=='mac'){                            
            const rateElements = this.template.querySelectorAll('.rate');
            rateElements.forEach(item=>{                
                if(event.target.accessKey == item.accessKey){                        
                    item.disabled = event.target.checked ? true : false;
                    item.value = event.target.checked ? null : item.value;
                    if(event.target.checked){
                        item.parentNode.classList.remove('fieldHighlight');
                    }                          
                }                    
            })
            let drug = this.itemList.find((item)=> {
                if(item.id==event.target.accessKey){                
                    return item['disabledRate'] = event.target.checked;
                }
            })
            if(event.target.checked){
                let drug = this.itemList.find((item)=> {
                    if(item.id==event.target.accessKey){                
                        return item['Rate'] = null;
                    }
                })    
            }               
            this.updateItemList(event.target.accessKey, event.target.name, event.target.checked);
        }else{
            if(event.target.value != null){                
                const col = `.${event.target.name}`;
                const elements = this.template.querySelectorAll(col);        
                elements.forEach(item=>{  
                    const itemId = item.getAttribute('id').split('-',2)[0];                    
                    if(itemId == event.target.accessKey ){                       
                        item.parentNode.classList.remove('fieldHighlight');
                    }                                                                                       
                })

            }
            this.updateItemList(event.target.accessKey, event.target.name, event.target.value);
        }      
        
    }
   
      
    handleSubmit() {        
        this.isButtonDisabled = true;
        this.isLoading = true;
                
        let isValid = true;

        if(this.isEmptyFieldsFound()){
            isValid = false;            
            this.isButtonDisabled = false;
            this.isLoading = false;
        }

        if(isValid){
            if(this.isDuplicateFound()){
                isValid = false;                
                this.showToast('Duplicate records identified within the submission for the Year, Drug Therapy, and Drug Name combination.', 'Record Submission Failed!', 'error','dismissable');
                this.isButtonDisabled = false;
                this.isLoading = false;
            }
        }
       
        
        if(isValid){
            const fieldValParam = JSON.stringify(this.itemList);
            checkDuplicateExist({fieldValParam : fieldValParam, specOpsId : this.specialOpsId})
            .then(result => {                
                if(result.isDuplicateFound){                   
                    this.showToast('Record already exists for the Year, Drug Therapy, and Drug Name combination.', 'Record Submission Failed!', 'error','dismissable');
                    let elements = this.template.querySelectorAll('.rowItem');
                    elements.forEach(item=>{                                         
                        item.style.backgroundColor = 'white';                                                                   
                    }) 
                    if(result.fieldValueList.length > 0){                        
                        elements.forEach(item=>{
                            let itemId = item.getAttribute('id').split('-',2)[0];               
                            result.fieldValueList.forEach((item2)=>{
                                if(item2.id == itemId){
                                    item.style.backgroundColor =  '#BDC3C7';                        
                                }
                            })                                                     
                        })
                    }
                    this.isButtonDisabled = false;
                    this.isLoading = false;   
                }else{                    
                    createDrugLevelPricing({fieldValParam : fieldValParam, specOpsId : this.specialOpsId})
                    .then(result => {                        
                        this.showToast('Specialty Drug Level Pricing Successfully created', 'Record Saved!', 'success','dismissable');
                        this.isButtonDisabled = false;
                        this.isLoading = false;
                        const selectedEvent = new CustomEvent("closemodal");     
                        this.dispatchEvent(selectedEvent);         
                    })
                    .catch(error => {
                        let errmessage;
                        if(error.body.pageErrors.length > 0){
                            errmessage = error.body.pageErrors[0].message;
                        }else if(error.body.fieldErrors.length > 0){
                            errmessage = error.body.fieldErrors[0].message;
                        }else{
                            errmessage = 'Unknown error. Please contact system administrator';
                        }                       
                        this.showToast('Submission Failed', errmessage, 'error','dismissable');
                        this.isButtonDisabled = false;
                        this.isLoading = false;
                    });      
                }                                               
            })
            .catch(error => {
                //alert(JSON.stringify(error));
                this.isButtonDisabled = false;
                this.isLoading = false;
            })                           
        }
        
    }
    
    isEmptyFieldsFound(){
        let isEmptyFieldExist = false;        
        const isEmptyYearExist = this.highlightNullFields('.year');
        const isEmptyDrugTherapyExist = this.highlightNullFields('.drugTherapy');
        const isEmptyDrugNameExist = this.highlightNullFields('.drugName');
        const isEmptyDrugTypeExist = this.highlightNullFields('.drugType');
        const isEmptyRateExist = this.highlightNullFields('.rate');
        
        if(isEmptyYearExist || isEmptyDrugTherapyExist || isEmptyDrugNameExist || isEmptyDrugTypeExist || isEmptyRateExist){
            isEmptyFieldExist = true;            
            const emptyFields = `${isEmptyYearExist ? 'Year, ' : ''}${isEmptyDrugTherapyExist ? 'Drug Therapy, ' : ''}${isEmptyDrugNameExist ? 'Drug Name, ' : ''}${isEmptyDrugTypeExist ? 'Drug Type, ' : ''}${isEmptyRateExist ? 'AWP Discount, ' : ''}`;
            const emptyFields2 = emptyFields.slice(0, -2);         
            const emptyMessage = `Required field(s) missing: ${emptyFields2}.`
            this.showToast(emptyMessage, '', 'error','dismissable');            
        }
        return isEmptyFieldExist;
    }

  
    isDuplicateFound(){
        let isDupRecExist = false;        
        const itemListMap = this.itemList.map((item)=>{ 
            return {id : item.id, key : `${item.year}${item.drugTherapy}${item.drugName}`.toUpperCase()}
        })        
        const itemListDup = this.getDuplicateArrayElements(itemListMap);
        
        
        let dupOutput = []; 
        itemListDup.forEach((itemDup)=>{
            itemListMap.forEach((itemOrig)=>{
                if(itemDup.key == itemOrig.key){
                    dupOutput = [...dupOutput, itemOrig];
                }
            })
        })
       
        let elements = this.template.querySelectorAll('.rowItem');
        elements.forEach(item=>{                                         
            item.style.backgroundColor = 'white';                                                                   
        }) 
        if(dupOutput.length > 0){
            isDupRecExist = true;
            elements.forEach(item=>{
                let itemId = item.getAttribute('id').split('-',2)[0];               
                dupOutput.forEach((item2)=>{
                    if(item2.id == itemId){          
                        item.style.backgroundColor =  '#BDC3C7';                        
                    }
                })                                                     
            })
        }
        return isDupRecExist;
    }

    getDuplicateArrayElements(arr){        
        const sorted_arr = arr.sort((a, b) => (a.key > b.key) ? 1 : -1);        
        let results = [];
        for (var i = 0; i < sorted_arr.length - 1; i++) {
            if (sorted_arr[i + 1].key === sorted_arr[i].key) {
                results.push(sorted_arr[i]);            
            }
        }
        return results;
    }

    highlightNullFields(column){
        let isEmptyFieldExist = false;        
        const elements = this.template.querySelectorAll(column);        
        elements.forEach(item=>{              
            item.parentNode.classList.remove('fieldHighlight');         
            if((item.value == null || item.value == '') && !item.disabled){                
                item.parentNode.classList.add('fieldHighlight');
                isEmptyFieldExist = true;            
            }                                        
        })
        return isEmptyFieldExist;
    }

    closeModal(){
        const selectedEvent = new CustomEvent("closemodal");     
        this.dispatchEvent(selectedEvent);
    }

    showToast(theTitle, theMessage, theVariant, theMode) {
        const event = new ShowToastEvent({
            title: theTitle,
            message: theMessage,
            variant: theVariant,
            mode: theMode
        });
     this.dispatchEvent(event);
    }

}