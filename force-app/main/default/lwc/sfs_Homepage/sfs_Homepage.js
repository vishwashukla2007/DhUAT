import { LightningElement, track, wire } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { getRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import Id from '@salesforce/user/Id';
import PROFILE_NAME_FIELD from '@salesforce/schema/User.Profile.Name';
export default class Sfs_Homepage extends NavigationMixin(LightningElement) {
    
    @track openmodel = false;
    @track underwriter;
    sfsOpenModel = true;
    profile;
    error = false;
    @wire(getRecord, {
        recordId: Id,
        fields: [PROFILE_NAME_FIELD]
    }) wireuser({
        error,
        data
    }) {
        if (error) {
           this.error = error ; 
        } else if (data) {
          this.profile=data.fields.Profile.value.fields.Name.value;
        }
    }
    handleReset() {
        const inputFields = this.template.querySelectorAll(
            'lightning-input-field'
        );
        if (inputFields) {
            inputFields.forEach(field => {
                field.reset();
            });
        }
        this.openmodel = false;
     }
    
    openmodal() {
        this.openmodel = true;
        if(!this.error && this.profile.includes('Underwriting')){
            this.underwriter = Id;
            console.log(this.underwriter);
        }
        console.log(this.error + ' ' + this.profile);
    }
  
    handleSuccess(event) {
        let TOAST_TITLE_SUCCESS = 'Record Created!';
        let message = 'Redirected User to IUMS Task Setup Record Page.';
        this.showToast(TOAST_TITLE_SUCCESS, message, "Success");
        this.handleReset();
            this[NavigationMixin.Navigate]({
                type: 'standard__recordPage',
                attributes: {
                    "recordId": event.detail.id,
                    "objectApiName": "iUMS_Task_Setup__c",
                    "actionName": "view"
                },
            });
        
    }
    handleError(event) {
        let message = "Error! " + event.detail.detail;
        console.log(message);
        console.log(JSON.parse(JSON.stringify(event)));
        let TOAST_TITLE_ERROR = 'iUms Task Setup Record Creation Failed';
        this.showToast(TOAST_TITLE_ERROR, message, "Error");
    }
    showToast(theTitle, theMessage, theVariant) {
        const event = new ShowToastEvent({
            title: theTitle,
            message: theMessage,
            variant: theVariant
        });
     this.dispatchEvent(event);
    }
    navigateToiUmsTaskSetupSearch(){
        this[NavigationMixin.Navigate]({
            type: 'standard__navItemPage',
            attributes: {
                apiName: 'iUMS_Task_Setup_Search'
            }
        });
    }
    navigateToiUmsTaskSetup(){
        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
                objectApiName: 'iUMS_Task_Setup__c',
                actionName: 'list'
            },
            state: {
                filterName: 'Recent'
            }
        });
    }
}