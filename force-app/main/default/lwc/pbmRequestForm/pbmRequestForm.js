import { LightningElement,api, wire, track} from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { getPicklistValues } from 'lightning/uiObjectInfoApi';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
//import { getRecord } from 'lightning/uiRecordApi';
import PBMREQUEST_OBJECT from '@salesforce/schema/PBMRequest__c';
import CONTYPE_FIELD from '@salesforce/schema/PBMRequest__c.Contract_Type__c';
import ECONTYPE_FIELD from '@salesforce/schema/PBMRequest__c.Existing_Client_Contract_Type__c';
import NONCLINICALTYPE_FIELD from '@salesforce/schema/PBMRequest__c.Non_Clinical_Appeals_Type__c';
import CLINICALTYPE_FIELD from '@salesforce/schema/PBMRequest__c.Clinical_Appeals_Type__c';
import getUserByGroup from '@salesforce/apex/pbmRequestWrapper.getUserByGroup';
import submitRequest from '@salesforce/apex/pbmRequestWrapper.submitRequest';
import createAgreement from '@salesforce/apex/pbmRequestWrapper.createAgreement';
import syncStatus from '@salesforce/apex/pbmRequestWrapper.syncStatus';

export default class pbmRequestForm extends NavigationMixin(LightningElement) {
    
    @api recordId;
    @api objectApiName;
    @api FAFId;
    @api FAFName;
    @api addMode;
    @api editMode;
    @api viewMode;
    @api requestSubmitted;

    //Other Variables    
    ecTypeselectedValue = [];
    ecTypeOptions = [];
    buttonName = '';
    value = '';
    activeSectionsT1 = ['T1A', 'T1B'];
    activeSectionsT2 = ['T2A'];
    activeSectionsT3 = ['T3A'];

    //tabFocusValue = 'Contract Information';    
    timeoutId;

    //Spinner
    isLoading = false;
    
    //Use for MultiPicklist Field
    ecTypeselectedValue2_string;
    ecTypeselectedValue2_arr = [];
    proposalType_string;
    proposalType_arr = [];
    appealType_string;
    appealType_arr = [];
    prevCareDrugType_string;
    prevCareDrugType_arr = [];

    //Use for Picklist Field
    cTypeselectedValue;
    cTypeOptions = [];
    nonClinicalTypeSelectedValue;
    nonClinicalTypeOptions = [];
    clinicalTypeSelectedValue;
    clinicalTypeSelectedLabel;
    clinicalTypeOptions = [];
   
    //Disabled Variables
    isButtonDisabled = false;
    isDisabledeCtype = true;
    isDisablePrevCareDrugType = true;
    isDisableAppealsType = true;
    isDisabledOtherAmendment = true;
    isDisabledOtherLegalDoc = true;
    isDisabledHardStopDt = true;
    isDisabledFinalMeetingDt = true;
    isDisabledDaysAfterBid = true;
    isDisablednonClinicalType = true;
    isDisableclinicalType = true;
    
    //Fields
    EditCtype;
    otherAmendmentDesc;
    otherLegalDocDesc;
    otherText;
    PerfGuarTeamCont;
    additionalEmail;
    relReqPropChk;
    HardStopDate;
    FinalistMeetingDate;
    DaysAfterBbid;
    vaccineService;
    appeals;
    prevCareDrug;
    paralegalId;
    attorneyId;
    RFPStage;
    ExecContDueDate;

    //Picklist Values//
    //Existing Contract Type
    pvRenewal = false;
    pvMarketCheck = false;
    pvOtherAmendment = false;
    pvOtherLegalDocument = false;
    //ProposalType
    pvHardStop = false;
    pvFinalistMeeting = false;
    pvDaysAfterBid = false;
    //Appeal Type
    pvClinicalAppeals = false;
    pvNonClinicalAppeals = false;
    //Preventive Care Drug Type
    pvgenericOnly = false;
    pvgeneric = false;
    pvbrand = false;
    pvcustom = false;

    //For data table
    error;
    paralegalData = [];
    paralegalAllData = [];
    paralegalColumns
    paralegalpreSelectedRows = [];
    paralegalsortBy;
    paralegalsortDirection;
    attorneyData = [];
    attorneyAllData = [];
    attorneyColumns
    attorneypreSelectedRows = [];
    attorneysortBy;
    attorneysortDirection;
    
    @wire(getObjectInfo, { objectApiName: PBMREQUEST_OBJECT })
    objectInfo;

    @wire(getUserByGroup,{userGroup : 'Paralegal'})
    wiredParalegal({error,data}) {
        if (data) {
            this.paralegalAllData = data;
            this.paralegalData = data;           
        } else if (error) {
            this.error = error;
        }
    }

    @wire(getUserByGroup,{userGroup : 'Attorney'})
    wiredAttorney({error,data}) {
        if (data) {
            this.attorneyAllData = data;
            this.attorneyData = data;           
        } else if (error) {
            this.error = error;
        }
    }
    
    renderedCallback() {
        //TBD
    }

   
    connectedCallback() {
        //this.recordId = 'a820x0000004XJpAAM';                       
        if(this.recordId == 'undefined' || this.recordId == null || this.recordId == "" ){
            //Add Mode            
        }else{
            //View Mode
            this.viewMode = true;
            this.editMode = false;
            this.addMode = false;            
            this.isLoading = true;
            syncStatus({pbmReqId : this.recordId})
            .then(result => {                
                if(result.requestStatusHasChange){
                    this.requestSubmitted = result.pbmRequestStatus;
                    //this.refreshWire();
                }                                
                this.isLoading = false;                
            })
            .catch(error => {                
                this.error = error;
                alert(JSON.stringify(this.error));
                this.isLoading = false;
            });

        }               

        this.userColumns = [{           
                label: 'FirstName',
                fieldName: 'FirstName',
                type: 'text',
                initialWidth: 200,
                sortable: true
            },
            {
                label: 'LastName',
                fieldName: 'LastName',
                type: 'text',
                initialWidth: 200,
                sortable: true
            },
            {
                label: 'Email',
                fieldName: 'Email',
                type: 'Text',
                initialWidth: 303,
                sortable: true
            }

        ];    
    }

    //Populate card title
    @api
    get cardTitle(){        
        let _cardTitle = '';
        if(this.addMode == true){
            _cardTitle = 'New PBM Request -';
        }else if(this.editMode == true){
            _cardTitle = 'Edit PBM Request -';
        }else if(this.viewMode == true){
            _cardTitle = 'View PBM Request -';
        };
        return _cardTitle;
    }

    
    handleOnLoadEditView(event) {
        this.isLoading = true;        
        if(this.tabFocusValue != null){
            this.template.querySelector('lightning-tabset').activeTabValue = this.tabFocusValue;         
        }
                   
        var record = event.detail.records;
        var fields = record[this.recordId].fields; 
        this.cTypeselectedValue  = fields.Contract_Type__c.value;        
        this.FAFId = fields.FAF__c.value; 
        this.FAFName = fields.FAF_Id__c.value;   
        this.otherAmendmentDesc = fields.Other_Amendment_Description__c.value;
        this.otherLegalDocDesc = fields.Other_Legal_Document_Description__c.value;
        this.relReqPropChk = fields.Related_to_Request_For_Proposal__c.value;
        this.HardStopDate = fields.Hard_Stop_Date__c.value;
        this.FinalistMeetingDate = fields.Finalist_Meeting_Date__c.value;
        this.DaysAfterBbid = fields.Days_after_bid_response__c.value;
        this.vaccineService = fields.Vaccine_Services__c.value;
        this.appeals = fields.Appeals__c.value;
        this.nonClinicalTypeSelectedValue = fields.Non_Clinical_Appeals_Type__c.value;
        this.clinicalTypeSelectedLabel = fields.Clinical_Appeals_Type__c.value;        
        this.prevCareDrug = fields.Preventive_Care_Drug_Program__c.value;
        this.otherText = fields.Others_Text__c.value;
        this.paralegalId = fields.Paralegal__c.value;
        this.attorneyId = fields.Attorney__c.value;
        this.PerfGuarTeamCont = fields.Performance_Guarantee_Team_Contact__c.value;
        this.additionalEmail = fields.Additional_email_addresses__c.value;        
        this.requestSubmitted = fields.Request_Submitted__c.value;
        this.RFPStage = fields.RFP_Stage_when_Executable_Contract_due__c.value;
        this.ExecContDueDate = fields.Executable_Contract_Due_Date__c.value;

        if( fields.Existing_Client_Contract_Type__c.value !== null){
            this.ecTypeselectedValue2_arr = fields.Existing_Client_Contract_Type__c.value.split(';');
            this.ecTypeselectedValue2_string = fields.Existing_Client_Contract_Type__c.value;
        }                
        for (var i = 0; i < this.ecTypeselectedValue2_arr.length; i++) {
            if(this.ecTypeselectedValue2_arr[i]=='Renewal'){
                this.pvRenewal = true;
            }else if(this.ecTypeselectedValue2_arr[i]=='Market Check'){
                this.pvMarketCheck = true;
            }else if(this.ecTypeselectedValue2_arr[i]=='Other Amendment'){
                this.pvOtherAmendment = true;
                this.isDisabledOtherAmendment = false;
            }else if(this.ecTypeselectedValue2_arr[i]=='Other Legal Document'){
                this.pvOtherLegalDocument = true;
                this.isDisabledOtherLegalDoc = false;
            }            
        }

        if(fields.Preventive_Care_Drug_Program_Type__c.value !== null){
            this.prevCareDrugType_arr = fields.Preventive_Care_Drug_Program_Type__c.value.split(';');
            this.prevCareDrugType_string = fields.Preventive_Care_Drug_Program_Type__c.value;
        }                
        for (var i = 0; i < this.prevCareDrugType_arr.length; i++) {
            if(this.prevCareDrugType_arr[i]=='Generic Only'){
                this.pvgenericOnly = true;
            }else if(this.prevCareDrugType_arr[i]=='Generic'){
                this.pvgeneric = true;
            }else if(this.prevCareDrugType_arr[i]=='Brand'){
                this.pvbrand = true;                
            }else if(this.prevCareDrugType_arr[i]=='Custom'){
                this.pvcustom = true;                
            }            
        }

        if(fields.Related_to_Request_For_Proposal_Type__c.value !== null){
            this.proposalType_arr = fields.Related_to_Request_For_Proposal_Type__c.value.split(';');
            this.proposalType_string = fields.Related_to_Request_For_Proposal_Type__c.value;
        }                
        for (var i = 0; i < this.proposalType_arr.length; i++) {
            if(this.proposalType_arr[i]=='Hard Stop'){
                this.pvHardStop = true;
                this.isDisabledHardStopDt = false;
            }else if(this.proposalType_arr[i]=='Finalist Meeting'){
                this.pvFinalistMeeting = true;
                this.isDisabledFinalMeetingDt = false;
            }else if(this.proposalType_arr[i]=='Days after bid response'){
                this.pvDaysAfterBid = true;
                this.isDisabledDaysAfterBid = false;
            }            
        }
        
        if(fields.Appeals_Type__c.value !== null){
            this.appealType_arr = fields.Appeals_Type__c.value.split(';');
            this.appealType_string = fields.Appeals_Type__c.value;
        }                
        for (var i = 0; i < this.appealType_arr.length; i++) {
            if(this.appealType_arr[i]=='Non-Clinical Appeals'){
                this.pvNonClinicalAppeals = true;                
            }else if(this.appealType_arr[i]=='Clinical Appeals'){
                this.pvClinicalAppeals = true;                
            }            
        }
                
        var inp=this.template.querySelectorAll("lightning-input");
        inp.forEach(function(element){
             if(element.name=="Non-Clinical Appeals"){                  
                if(this.pvNonClinicalAppeals == true){                  
                    element.checked = true;
                }else{                   
                    element.checked = false;
                }    
             }else if(element.name=="Clinical Appeals"){
                if(this.pvClinicalAppeals == true){                    
                    element.checked = true;
                }else{                    
                    element.checked = false;
                }
             }else if(element.name=="Renewal"){                
                if(this.pvRenewal == true){                    
                    element.checked = true;
                }else{                    
                    element.checked = false;
                }
             }
        },this);
                                
        if(this.appeals){
            this.isDisableAppealsType = false;
        }
        if(this.cTypeselectedValue=='Existing Client'){
            this.isDisabledeCtype = false;
        }
        if(this.prevCareDrug){
            this.isDisablePrevCareDrugType = false;
        }

        if(this.pvNonClinicalAppeals){
            this.isDisablednonClinicalType  = false;
        }

        if(this.pvClinicalAppeals){
            this.isDisableclinicalType = false;
        }
                       
        //this.nonClinicalTypeSelectedValue.forEach(option => option.checked = option.value === this.nonClinicalTypeSelectedValue);        
        let optionsValues = [];
        for(let i = 0; i < this.nonClinicalTypeOptions.length; i++) {
            if(this.nonClinicalTypeSelectedValue== this.nonClinicalTypeOptions[i].value){
                optionsValues.push({
                    label: this.nonClinicalTypeOptions[i].label,
                    value: this.nonClinicalTypeOptions[i].value,
                    checked: true
                })
            } else{
                optionsValues.push({
                    label: this.nonClinicalTypeOptions[i].label,
                    value: this.nonClinicalTypeOptions[i].value,
                    checked: false
                })
            }            
        }
        this.nonClinicalTypeOptions = optionsValues;
        
        //Clinical type        
        let optionsValues2 = [];
        for(let i = 0; i < this.clinicalTypeOptions.length; i++) {
            if(this.clinicalTypeSelectedLabel== this.clinicalTypeOptions[i].label){                
                optionsValues2.push({
                    label: this.clinicalTypeOptions[i].label,
                    value: this.clinicalTypeOptions[i].value,
                    checked: true
                })
            } else{                
                optionsValues2.push({
                    label: this.clinicalTypeOptions[i].label,
                    value: this.clinicalTypeOptions[i].value,
                    checked: false
                })
            }            
        }
        this.clinicalTypeOptions = optionsValues2;

        let my_Pids = [];
        my_Pids.push(this.paralegalId);
        this.paralegalpreSelectedRows = my_Pids;
        
        let my_Aids = [];
        my_Aids.push(this.attorneyId);
        this.attorneypreSelectedRows = my_Aids;
        this.isLoading = false;
    }

    refreshViewForm(){     
        var inp=this.template.querySelectorAll("lightning-input");
        inp.forEach(function(element){
             if(element.name=="Non-Clinical Appeals"){  
                if(this.pvNonClinicalAppeals == true){
                    element.checked = true;
                }else{                  
                    element.checked = false;
                }    
             }else if(element.name=="Clinical Appeals"){
                if(this.pvClinicalAppeals == true){                    
                    element.checked = true;
                }else{                    
                    element.checked = false;
                }
             }else if(element.name=="Renewal"){
                if(this.pvRenewal == true){                    
                    element.checked = true;
                }else{                    
                    element.checked = false;
                }
             }
        },this);
    }

    refreshAddForm(){        
        //this.template.querySelector('lightning-tabset').activeTabValue = 'Contract Information';        
        this.editMode = false;
        this.viewMode = false;
        this.cTypeselectedValue  = "New Client";
        this.pvRenewal = false;
        this.pvMarketCheck = false;
        this.pvOtherAmendment = false;
        this.otherAmendmentDesc = "";
        this.pvOtherLegalDocument = false;
        this.otherLegalDocDesc = "";
        this.isDisabledeCtype = true;
        this.isDisabledOtherAmendment = true;
        this.isDisabledOtherLegalDoc = true;
        this.relReqPropChk = false;
        this.isDisabledHardStopDt = true;
        this.HardStopDate = null;
        this.isDisabledFinalMeetingDt = true;
        this.FinalistMeetingDate = null;
        this.isDisabledDaysAfterBid = true;
        this.DaysAfterBbid = null;
        this.vaccineService = false;
        this.appeals = false;
       
        this.appealType_arr = [];
        this.appealType_string = '';
        this.pvNonClinicalAppeals = false;                
        this.pvClinicalAppeals = false;
        
        this.prevCareDrug = false;
        this.prevCareDrugType_arr = [];
        this.prevCareDrugType_string = '';
        
        this.pvgenericOnly = false;        
        this.pvgeneric = false;        
        this.pvbrand = false;                        
        this.pvcustom = false;                
        this.isDisablePrevCareDrugType = true;          
            
        this.otherText = '';

        this.paralegalId = '';
        this.attorneyId = '';

        this.paralegalpreSelectedRows = [];                
        this.attorneypreSelectedRows = [];

        this.PerfGuarTeamCont = '';
        this.additionalEmail = '';

        if(this.cTypeselectedValue=='Existing Client'){
            this.isDisabledeCtype = false;
        }
    }
    
    handleOnLoadAdd(event) {
        this.refreshAddForm();
    }

    //Contract Type Change
    CTypeChange(event) {        
        this.cTypeselectedValue = event.target.value;
    }

    // Getting Contract Type Picklist values using wire service
    @wire(getPicklistValues, { recordTypeId: '$objectInfo.data.defaultRecordTypeId', fieldApiName: CONTYPE_FIELD})
    ctypePicklistValues({error, data}) {
        if(data) {
            let optionsValues = [];
            for(let i = 0; i < data.values.length; i++) {
                optionsValues.push({
                    label: data.values[i].label,
                    value: data.values[i].value
                })
            }
            this.cTypeOptions = optionsValues;
            window.console.log('optionsValues ===> '+JSON.stringify(optionsValues));
        }
        else if(error) {
            window.console.log('error ===> '+JSON.stringify(error));
        }
    }

    // Getting Non Clinical Type Picklist values using wire service
    @wire(getPicklistValues, { recordTypeId: '$objectInfo.data.defaultRecordTypeId', fieldApiName: NONCLINICALTYPE_FIELD})
    nonClinicalTypePicklistValues({error, data}) {
        if(data) {
            let optionsValues = [];
            for(let i = 0; i < data.values.length; i++) {
                optionsValues.push({
                    label: data.values[i].label,
                    value: data.values[i].value,
                    checked: false
                })
            }
            this.nonClinicalTypeOptions = optionsValues;
            window.console.log('optionsValues ===> '+JSON.stringify(optionsValues));
        }
        else if(error) {
            window.console.log('error ===> '+JSON.stringify(error));
        }
    }

    //Getting Clinical Type Picklist values using wire service
    @wire(getPicklistValues, { recordTypeId: '$objectInfo.data.defaultRecordTypeId', fieldApiName: CLINICALTYPE_FIELD})
    clinicalTypePicklistValues({error, data}) {
        if(data) {
            let optionsValues2 = [];
            for(let i = 0; i < data.values.length; i++) {
                optionsValues2.push({
                    label: data.values[i].label,
                    value: 'c-'+ data.values[i].value,
                    checked: false
                })
            }
            this.clinicalTypeOptions = optionsValues2;
            window.console.log('optionsValues ===> '+JSON.stringify(optionsValues2));
        }
        else if(error) {
            window.console.log('error ===> '+JSON.stringify(error));
        }
    }

    handleChangeCType(event) {
        this.cTypeselectedValue = event.detail.value;
        if(event.detail.value=='Existing Client'){
            this.isDisabledeCtype = false;
        }else{
            this.ecTypeselectedValue2_arr = [];
            this.ecTypeselectedValue2_string = '';
            this.isDisabledeCtype = true;
            this.pvRenewal = false;
            this.pvMarketCheck = false;
            this.pvOtherAmendment = false;
            this.pvOtherLegalDocument = false;
            var inp=this.template.querySelectorAll("lightning-input");
            inp.forEach(function(element){
                if(element.name=="Market Check" || element.name=="Other Amendment" || element.name== "Renewal" || element.name== "Other Legal Document"){  
                    element.checked = false;
                }
            },this);

            var inp=this.template.querySelectorAll("lightning-input-field");
            inp.forEach(function(element){
                if(element.name=="Other_Amendment_Description__c" || element.name=="Other_Legal_Document_Description__c" ){
                    element.value = "";
                }   
            },this);
            this.isDisabledOtherAmendment = true;
            this.isDisabledOtherLegalDoc = true;
            this.otherAmendmentDesc = "";
            this.otherLegalDocDesc = "";    
        }
    }

    handleChangeNonClinicalAppeal(event) {              
        this.nonClinicalTypeSelectedValue = event.target.value;         

        let optionsValues = [];
        for(let i = 0; i < this.nonClinicalTypeOptions.length; i++) {
            if(this.nonClinicalTypeSelectedValue== this.nonClinicalTypeOptions[i].value){
                optionsValues.push({
                    label: this.nonClinicalTypeOptions[i].label,
                    value: this.nonClinicalTypeOptions[i].value,
                    checked: true
                })
            } else{
                optionsValues.push({
                    label: this.nonClinicalTypeOptions[i].label,
                    value: this.nonClinicalTypeOptions[i].value,
                    checked: false
                })
            }            
        }
        this.nonClinicalTypeOptions = optionsValues;                
        
    }

    handleChangeClinicalAppeal(event) {              
        this.clinicalTypeSelectedValue = event.target.value;         
        
        let optionsValues2 = [];
        for(let i = 0; i < this.clinicalTypeOptions.length; i++) {
            if(this.clinicalTypeSelectedValue== this.clinicalTypeOptions[i].value){
                optionsValues2.push({
                    label: this.clinicalTypeOptions[i].label,
                    value: this.clinicalTypeOptions[i].value,
                    checked: true
                })
                this.clinicalTypeSelectedLabel = this.clinicalTypeOptions[i].label;
            } else{
                optionsValues2.push({
                    label: this.clinicalTypeOptions[i].label,
                    value: this.clinicalTypeOptions[i].value,
                    checked: false
                })
            }            
        }
        this.clinicalTypeOptions = optionsValues2;      
    }

    handleChangeRelReqProp(event){        
        this.relReqPropChk = event.detail.checked;
        if(event.detail.checked == false){
            this.isDisabledHardStopDt = true;
            this.isDisabledFinalMeetingDt = true;
            this.isDisabledDaysAfterBid = true;
            this.pvHardStop = false;
            this.pvFinalistMeeting = false;
            this.pvDaysAfterBid = false;
            this.HardStopDate = null;
            this.FinalistMeetingDate = null;
            this.DaysAfterBbid = null;
            this.proposalType_string = '';
            this.proposalType_arr = [];

        }
    }
    
    // Getting Existing Contract Type Picklist values using wire service
    @wire(getPicklistValues, { recordTypeId: '$objectInfo.data.defaultRecordTypeId', fieldApiName: ECONTYPE_FIELD})
    ectypePicklistValues({error, data}) {
        if(data) {
            let optionsValues = [];
            for(let i = 0; i < data.values.length; i++) {
                optionsValues.push({
                    label: data.values[i].label,
                    value: data.values[i].value
                })
            }
            this.ecTypeOptions = optionsValues;
            window.console.log('optionsValues ===> '+JSON.stringify(optionsValues));
        }
        else if(error) {
            window.console.log('error ===> '+JSON.stringify(error));
        }
    }

    
    handleChangeEachECType(e) {
        const index = this.ecTypeselectedValue2_arr.indexOf(e.currentTarget.name);
        if (index > -1) {
            this.ecTypeselectedValue2_arr.splice(index, 1);
        }else{
            this.ecTypeselectedValue2_arr.push(e.currentTarget.name);
        }
        if(this.ecTypeselectedValue2_arr.length !== 0){
            this.ecTypeselectedValue2_string = this.ecTypeselectedValue2_arr.join(';');
        }else{
            this.ecTypeselectedValue2_string = '';
        }
      
        if(e.currentTarget.name == 'Renewal'){
            this.pvRenewal = e.target.checked;
        }else if(e.currentTarget.name == 'Market Check'){
            this.pvMarketCheck = e.target.checked;
        }else if(e.currentTarget.name == 'Other Amendment'){
            this.pvOtherAmendment = e.target.checked;
            if(e.target.checked){
                this.isDisabledOtherAmendment = false;
            }else{
                this.isDisabledOtherAmendment = true;
                this.otherAmendmentDesc = ""; 
                var inp=this.template.querySelectorAll('lightning-textarea.OtherAmendmentDescription');
                inp.forEach(function(element){    
                element.value = "";                    
                },this);                              
            }
        }else if(e.currentTarget.name == 'Other Legal Document'){
            this.pvOtherLegalDocument = e.target.checked;
            if(e.target.checked){
                this.isDisabledOtherLegalDoc = false;
            }else{
                this.isDisabledOtherLegalDoc = true;
                this.otherLegalDocDesc = "";                                 
                var inp=this.template.querySelectorAll('lightning-textarea.OtherLegalDocDesc');
                inp.forEach(function(element){                
                    element.value = "";                    
                },this); 
            }
        }               
    }

    handleChangePrevCareDrugType(e) {    
        const index = this.prevCareDrugType_arr.indexOf(e.currentTarget.name);
        if (index > -1) {
            this.prevCareDrugType_arr.splice(index, 1);
        }else{
            this.prevCareDrugType_arr.push(e.currentTarget.name);
        }
        if(this.prevCareDrugType_arr.length !== 0){
            this.prevCareDrugType_string = this.prevCareDrugType_arr.join(';');
        }else{
            this.prevCareDrugType_string = '';
        }
      
        if(e.currentTarget.name == 'Generic Only'){
            this.pvgenericOnly = e.target.checked;
        }else if(e.currentTarget.name == 'Generic'){
            this.pvgeneric = e.target.checked;
        }else if(e.currentTarget.name == 'Brand'){
            this.pvbrand = e.target.checked;            
        }else if(e.currentTarget.name == 'Custom'){
            this.pvcustom = e.target.checked;            
        }               
    }


    handleChangeAppealsType(e) {        
        const index = this.appealType_arr.indexOf(e.currentTarget.name);
        if (index > -1) {
            this.appealType_arr.splice(index, 1);
        }else{
            this.appealType_arr.push(e.currentTarget.name);
        }
        if(this.appealType_arr.length !== 0){
            this.appealType_string = this.appealType_arr.join(';');
        }else{
            this.appealType_string = '';
        }        
        if(e.currentTarget.name == 'Non-Clinical Appeals'){
            this.pvNonClinicalAppeals = e.target.checked;
            if(e.target.checked){
                this.isDisablednonClinicalType = false;
            }else{
                this.isDisablednonClinicalType = true;
                let optionsValues = [];
                for(let i = 0; i < this.nonClinicalTypeOptions.length; i++) {                
                    optionsValues.push({
                        label: this.nonClinicalTypeOptions[i].label,
                        value: this.nonClinicalTypeOptions[i].value,
                        checked: false
                    })                            
                }
                this.nonClinicalTypeOptions = optionsValues;
                this.nonClinicalTypeSelectedValue = '';
            }            
        }
        
        if(e.currentTarget.name == 'Clinical Appeals'){
            this.pvClinicalAppeals = e.target.checked;
            if(e.target.checked){
                this.isDisableclinicalType = false;
            }else{
                this.isDisableclinicalType = true;
                let optionsValues2 = [];
                for(let i = 0; i < this.clinicalTypeOptions.length; i++) {                                
                    optionsValues2.push({
                        label: this.clinicalTypeOptions[i].label,
                        value: this.clinicalTypeOptions[i].value,
                        checked: false
                    })                            
                }
                this.clinicalTypeOptions = optionsValues2;
                this.clinicalTypeSelectedLabel = '';
            }            
        }               
    }

    handleChangePropType(e) {        
        const index = this.proposalType_arr.indexOf(e.currentTarget.name);
        if (index > -1) {
            this.proposalType_arr.splice(index, 1);
        }else{
            this.proposalType_arr.push(e.currentTarget.name);
        }
        
         if(this.proposalType_arr.length !== 0){
            this.proposalType_string = this.proposalType_arr.join(';');
        }else{
            this.proposalType_string = '';
        }
      
       
        if(e.currentTarget.name == 'Hard Stop'){
            this.pvHardStop = e.target.checked;
            if(e.target.checked){
                this.isDisabledHardStopDt = false;
            }else{
                this.isDisabledHardStopDt = true;
                this.HardStopDate = null;
                var inp=this.template.querySelectorAll('lightning-input.Hard_Stop_Date__c');
                inp.forEach(function(element){                    
                element.value = null;                    
            },this);

            }
        }

         
        if(e.currentTarget.name == 'Finalist Meeting'){
            this.pvFinalistMeeting = e.target.checked;
            if(e.target.checked){
                this.isDisabledFinalMeetingDt = false;
            }else{
                this.isDisabledFinalMeetingDt = true;
                this.FinalistMeetingDate = null;
                var inp=this.template.querySelectorAll('lightning-input.FinalistMeeting');
                inp.forEach(function(element){                    
                element.value = null;                    
            },this);
            }
        }

        if(e.currentTarget.name == 'Days after bid response'){
            this.pvDaysAfterBid = e.target.checked;
            if(e.target.checked){
                this.isDisabledDaysAfterBid = false;
            }else{
                this.isDisabledDaysAfterBid = true;
                this.DaysAfterBbid = null
                var inp=this.template.querySelectorAll('lightning-input.DaysAfterBid');
                 inp.forEach(function(element){                    
                    element.value = null;                    
                },this);
            }
        }

    }
    
    
    handleSectionToggle(event) {
        const openSections = event.detail.openSections;
        if (openSections.length === 0) {
            this.activeSectionsMessage = 'All sections are closed';
        } else {
            this.activeSectionsMessage =
                'Open sections: ' + openSections.join(', ');
        }
    }

    cancelBack(event) {    
        let recId = '';
        let recObj = '';
        if(this.recordId == 'undefined' || this.recordId == null || this.recordId == "" || event.currentTarget.name == 'Back' || this.addMode){
            recId = this.FAFId;                
            recObj = 'Central_Hub__c';         
        }else{
            recId = this.recordId;
            recObj = 'PBMRequest__c';
            this.tabFocusValue = this.template.querySelector('lightning-tabset').activeTabValue;
        }
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: recId,
                objectApiName: recObj,
                actionName: 'view'
            },
        });

        if(this.recordId == 'undefined' || this.recordId == null || this.recordId == "" || event.currentTarget.name == 'Back' || this.addMode){
            this.refreshAddForm();  
        }           
    }

    navigateToViewFAF(event) {
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: this.FAFId,
                objectApiName: 'Central_Hub__c',
                actionName: 'view'
            },
        });        
        this.refreshAddForm();  
    }

    storeButtonName(event) {
        this.buttonName = event.target.dataset.name;        
    }

    handleEdit(event) {
        this.addMode = false;
        this.editMode = true;
        this.viewMode = false;
        this.tabFocusValue = this.template.querySelector('lightning-tabset').activeTabValue;        
    }

    handleSubmit(event) {        
        this.isButtonDisabled = true;
        this.isLoading = true;
        event.preventDefault(); // stop the form from submitting
        const fields = event.detail.fields;
        console.log(JSON.stringify(fields));           
        fields.Contract_Type__c = this.cTypeselectedValue;
        fields.Existing_Client_Contract_Type__c = this.ecTypeselectedValue2_string;
        fields.FAF__c = this.FAFId;        
        fields.Other_Amendment_Description__c = this.otherAmendmentDesc;        
        fields.Other_Legal_Document_Description__c = this.otherLegalDocDesc;        
        fields.Hard_Stop_Date__c = this.HardStopDate;
        fields.Finalist_Meeting_Date__c = this.FinalistMeetingDate;
        fields.Days_after_bid_response__c = this.DaysAfterBbid;        
        fields.Related_to_Request_For_Proposal__c = this.relReqPropChk;
        fields.Related_to_Request_For_Proposal_Type__c = this.proposalType_string;
        fields.Vaccine_Services__c = this.vaccineService;        
        fields.Appeals__c = this.appeals;        
        fields.Appeals_Type__c = this.appealType_string;
        fields.Clinical_Appeals__c = this.pvClinicalAppeals;
        fields.Non_Clinical_Appeals__c = this.pvNonClinicalAppeals;
        fields.Non_Clinical_Appeals_Type__c = this.nonClinicalTypeSelectedValue;        
        fields.Clinical_Appeals_Type__c = this.clinicalTypeSelectedLabel;
        fields.Preventive_Care_Drug_Program__c = this.prevCareDrug;
        fields.Preventive_Care_Drug_Program_Type__c = this.prevCareDrugType_string;
        fields.Generic_Only__c = this.pvgenericOnly; 
        fields.Generic__c = this.pvgeneric;
        fields.Brand__c = this.pvbrand;
        fields.Custom__c = this.pvcustom;
        fields.Others_Text__c = this.otherText;
        fields.Others_Text2__c = this.otherText;
        fields.Paralegal__c	= this.paralegalId;
        fields.Attorney__c	= this.attorneyId;
        fields.Performance_Guarantee_Team_Contact__c = this.PerfGuarTeamCont;
        fields.Additional_email_addresses__c = this.additionalEmail;
        fields.Market_Check__c = this.pvMarketCheck;
        if(this.buttonName=='submitReq'){            
            submitRequest({FAFId : this.FAFId})
            .then(result => {
                //alert(result.FAFId + ' ' + result.isValidRequest + ' ' + result.invalidMessage);
                if(this.paralegalId == '' || this.attorneyId == ''){
                    this.showToast('Paralegal or Attorney should not be empty when submitting request.', '', 'error','dismissable');
                    this.tabFocusValue = 'Contact Information';
                    if(!this.addMode){
                        this.addMode = false;
                        this.editMode = true;
                        this.viewMode = false;
                    }else{
                        this.template.querySelector('lightning-tabset').activeTabValue = 'Contact Information';
                    }                    
                    
                    this.isButtonDisabled = false; 
                    this.isLoading = false; 
                }else if(!result.isValidRequest){
                    this.showToast(result.invalidMessage, '', 'error','dismissable');
                    this.isButtonDisabled = false; 
                    this.isLoading = false; 
                }else{
                    fields.Request_Submitted__c = true;
                    this.template.querySelector('lightning-record-edit-form').submit(fields);                    
                }                
            })
            .catch(error => {
                this.error = error;
            });
        }else{
            fields.Request_Submitted__c = this.requestSubmitted;
            this.template.querySelector('lightning-record-edit-form').submit(fields);
        }         
        this.tabFocusValue = this.template.querySelector('lightning-tabset').activeTabValue  
    }

    handleSuccess(event) {
        const payload = event.detail;
        console.log(JSON.stringify(payload));
        const updatedRecord = event.detail.id;
        this.recordId = updatedRecord;
        console.log('onsuccess: ', updatedRecord);
        if(this.buttonName=='submitReq'){
            this.handleSubmitReq()
        }else{
            if(this.addMode == true){
                this.showToast('Contract request successfully created', 'Record Saved!', 'success','dismissable');                                
            }else if(this.editMode == true){
                this.showToast('Contract request successfully updated', 'Record Updated!', 'success','dismissable');        
            }
            this.isLoading = false;
            this[NavigationMixin.Navigate]({
                type: 'standard__recordPage',
                attributes: {
                    recordId: this.recordId,
                    objectApiName: 'PBMRequest__c',
                    actionName: 'view'
                },
            });            
            clearTimeout(this.timeoutId); // no-op if invalid id
            this.timeoutId = setTimeout(this.refreshBrowser.bind(this), 1000);                
        }
                                         
    }

    enabledSaveButton() {
        this.isButtonDisabled = false;
    }

    refreshBrowser() {
        window.location.reload();
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

    handleOtherAmendmentDesc(event){             
        this.otherAmendmentDesc = event.detail.value;
    }

    handleOtherText(event){             
        this.otherText = event.detail.value;
    }

    handlePerfGuarTeamCont(event){             
        this.PerfGuarTeamCont = event.detail.value;
    }

    handleAdditionalEmail(event){             
        this.additionalEmail = event.detail.value;
    }
        
    handleOtherLegalDocDesc(event){        
        this.otherLegalDocDesc = event.detail.value;
    }

    handleHardStopDate(event){
        this.HardStopDate = event.detail.value;
    }

    handleFinalistMeetingDate(event){
        this.FinalistMeetingDate = event.detail.value;
    }

    handleDaysAfterBbid(event){        
        this.DaysAfterBbid = event.detail.value;
    }
    
    handleChangeVacServ(event){
        this.vaccineService = event.detail.checked;
    }

    handleChangeAppeals(event){
        this.appeals = event.detail.checked;
        if(event.detail.checked){
            this.isDisableAppealsType = false;
        }else{
            this.isDisableAppealsType = true;
            this.appealType_string = '';
            this.appealType_arr = [];
            this.pvNonClinicalAppeals = false;
            this.pvClinicalAppeals = false;
            this.isDisablednonClinicalType = true
            this.isDisableclinicalType = true    
            //this.nonClinicalTypeSelectedValue.forEach(option => option.checked = option.value === this.nonClinicalTypeSelectedValue);        
            let optionsValues = [];
            for(let i = 0; i < this.nonClinicalTypeOptions.length; i++) {                
                optionsValues.push({
                    label: this.nonClinicalTypeOptions[i].label,
                    value: this.nonClinicalTypeOptions[i].value,
                    checked: false
                })                            
            }
            this.nonClinicalTypeOptions = optionsValues;
            this.nonClinicalTypeSelectedValue = '';
            
            //Clinical type        
            let optionsValues2 = [];
            for(let i = 0; i < this.clinicalTypeOptions.length; i++) {                                
                optionsValues2.push({
                    label: this.clinicalTypeOptions[i].label,
                    value: this.clinicalTypeOptions[i].value,
                    checked: false
                })                            
            }
            this.clinicalTypeOptions = optionsValues2;
            this.clinicalTypeSelectedLabel = '';

        }
    }


    handleChangePrevCareDrug(event){
        this.prevCareDrug = event.detail.checked;
        if(event.detail.checked){            
            this.isDisablePrevCareDrugType = false;
        }else{
            this.isDisablePrevCareDrugType = true;
            this.prevCareDrugType_string = '';
            this.prevCareDrugType_arr = [];
            this.pvgenericOnly = false;
            this.pvgeneric = false;
            this.pvcustom = false;
            this.pvbrand = false;                           
        }
    }

    handleOnSearchChangeParalegal(event) {                        
        if(event.target.value !== null || event.target.value !== '' ){
            var paralegalFilterData = this.paralegalAllData;
            var searchFilter = event.target.value.toUpperCase();
            
            var tempArray = [];
            var i;            
            for(i=0; i < paralegalFilterData.length; i++){
                if((paralegalFilterData[i].FirstName && paralegalFilterData[i].FirstName.toUpperCase().indexOf(searchFilter) != -1) ||
                    (paralegalFilterData[i].LastName && paralegalFilterData[i].LastName.toUpperCase().indexOf(searchFilter) != -1 ) || 
                    (paralegalFilterData[i].Email && paralegalFilterData[i].Email.toUpperCase().indexOf(searchFilter) != -1 ) )
                {
                    tempArray.push(paralegalFilterData[i]);
                }        
            }
            this.paralegalData = tempArray;    
        }else{
            this.paralegalData = this.paralegalAllData;
        }
        
    }

    handleOnSearchChangeAttorney(event) {                        
        if(event.target.value !== null || event.target.value !== '' ){
            var attorneyFilterData = this.attorneyAllData;
            var searchFilter = event.target.value.toUpperCase();
            
            var tempArray = [];
            var i;            
            for(i=0; i < attorneyFilterData.length; i++){
                if((attorneyFilterData[i].FirstName && attorneyFilterData[i].FirstName.toUpperCase().indexOf(searchFilter) != -1) ||
                    (attorneyFilterData[i].LastName && attorneyFilterData[i].LastName.toUpperCase().indexOf(searchFilter) != -1 ) || 
                    (attorneyFilterData[i].Email && attorneyFilterData[i].Email.toUpperCase().indexOf(searchFilter) != -1 ) )
                {
                    tempArray.push(attorneyFilterData[i]);
                }        
            }
            this.attorneyData = tempArray;    
        }else{
            this.attorneyData = this.attorneyAllData;
        }
        
    }


    getSelectedParalegal(event){
        const selectedRows = event.detail.selectedRows;
        for (let i = 0; i < selectedRows.length; i++){            
            this.paralegalId = selectedRows[i].Id;
        }
    }

    getSelectedAttorney(event){
        const selectedRows = event.detail.selectedRows;
        for (let i = 0; i < selectedRows.length; i++){            
            this.attorneyId = selectedRows[i].Id;
        }
    }

    handleSortdataParalegal(event) {        
        this.paralegalsortBy = event.detail.fieldName;
        // sort direction
        this.paralegalsortDirection = event.detail.sortDirection;
        // calling sortdata function to sort the data based on direction and selected field
        this.paralegalsortData(event.detail.fieldName, event.detail.sortDirection, 'paraData');
    }

    handleSortdataAttorney(event) {        
        this.attorneysortBy = event.detail.fieldName;
        // sort direction
        this.attorneysortDirection = event.detail.sortDirection;
        // calling sortdata function to sort the data based on direction and selected field
        this.paralegalsortData(event.detail.fieldName, event.detail.sortDirection, 'attyData');
    }

    paralegalsortData(fieldname, direction, tableData) {        
        // serialize the data before calling sort function
        let parseData;
        if(tableData == 'paraData'){
            parseData = JSON.parse(JSON.stringify(this.paralegalData));
        }else if(tableData == 'attyData'){
            parseData = JSON.parse(JSON.stringify(this.attorneyData));
        }
        

        // Return the value stored in the field
        let keyValue = (a) => {
            return a[fieldname];
        };

        // cheking reverse direction 
        let isReverse = direction === 'asc' ? 1: -1;

        // sorting data 
        parseData.sort((x, y) => {
            x = keyValue(x) ? keyValue(x) : ''; // handling null values
            y = keyValue(y) ? keyValue(y) : '';

            // sorting values based on direction
            return isReverse * ((x > y) - (y > x));
        });

        if(tableData == 'paraData'){
            this.paralegalData = parseData;
        }else if(tableData == 'attyData'){
            this.attorneyData = parseData;            
        }

        // set the sorted data to data table data        
    }

    handleError(event) {
        alert(JSON.stringify(event.detail));
        this.isLoading = false;
    }
             
    handleSubmitReq(){
        this.isButtonDisabled = true; 
        this.isLoading = true;       
        submitRequest({FAFId : this.FAFId})
            .then(result => {
                //alert(result.FAFId + ' ' + result.isValidRequest + ' ' + result.invalidMessage);                
                if(this.paralegalId == '' || this.attorneyId == '' || this.paralegalId == null || this.attorneyId == null){
                    this.showToast('Paralegal or Attorney should not be empty when submitting request.', '', 'error','dismissable');
                    this.tabFocusValue = 'Contact Information';
                    this.addMode = false;
                    this.editMode = true;
                    this.viewMode = false;
                    //this.template.querySelector('lightning-tabset').activeTabValue = 'Contact Information';
                    this.isButtonDisabled = false; 
                    this.isLoading = false;               
                }else if(!result.isValidRequest){
                    this.showToast(result.invalidMessage, '', 'error','dismissable');
                    this.isButtonDisabled = false;
                    this.isLoading = false;                    
                }else{                                        
                    createAgreement({FAFId : this.FAFId, AttorneyId : this.attorneyId, ParalegalId : this.paralegalId})
                    .then(result2 => {                        
                        this.showToast('Contract request has been successfully submitted.', '', 'success','sticky');
                        this[NavigationMixin.Navigate]({
                            type: 'standard__recordPage',
                            attributes: {
                                recordId: this.recordId,
                                objectApiName: 'PBMRequest__c',
                                actionName: 'view'
                            },
                        });
                        this.requestSubmitted = true;
                        this.addMode = false;
                        this.editMode = true;
                        this.viewMode = false;
                        clearTimeout(this.timeoutId); // no-op if invalid id
                        this.timeoutId = setTimeout(this.refreshBrowser.bind(this), 2000);
                        this.isLoading = false;                       
                    })
                    .catch(error2 => {                        
                        var errmessage;
                        if(error2.body.pageErrors.length > 0){
                            errmessage = error2.body.pageErrors[0].message;
                        }else if(error2.body.fieldErrors.length > 0){
                            errmessage = error2.body.fieldErrors[0].message;
                        }else{
                            errmessage = 'Unknown error. Please contact system administrator';
                        }
                        this.showToast('Request unsuccessful because of error on FAF record. ' + errmessage, '', 'error','dismissable');
                        this.isLoading = false;
                        this.isButtonDisabled = false; 
                    });

                }                
            })
            .catch(error => {
                this.error = error;
                this.isLoading = false
            });
    }

}