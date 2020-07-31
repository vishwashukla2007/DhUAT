import { LightningElement, api, track, wire } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
//Import apex method/s
import getContractChangeSummary from '@salesforce/apex/AgreementSyncErrorLWCController.getContractChangeSummary';
//Import custom label/s
import agreementSyncErrorMessage from '@salesforce/label/c.agreementSyncErrorMessage';
import navigateToContractChangeSummaryLinkLabel from '@salesforce/label/c.navigateToContractChangeSummaryLinkLabel';
export default class AgreementSyncError extends NavigationMixin(LightningElement) {

    @api recordId;
    @track contractChangeSummaryRecordId = null;
    @track error = null;
    @track customLabel = {
        agreementSyncErrorMessage,
        navigateToContractChangeSummaryLinkLabel,
    };

    @wire (getContractChangeSummary, {recordId: '$recordId'})
    wiredContractChangeSummary(result){
        if (result.data) {
            console.log('result.data: ' + JSON.stringify(result.data));
            this.contractChangeSummaryRecordId = result.data.Id;
        } else if (result.error) {
            console.log('result.error: ' + JSON.stringify(result.error));
            this.error = result.error;
        }
    }

    navigateToContractChangeSummary() {
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: this.contractChangeSummaryRecordId,
                objectApiName: 'Contract_Change_Summary__c',
                actionName: 'view'
            },
        });
    }

    get isChangeSummaryLinkVisible() {
        return this.contractChangeSummaryRecordId ? true : false;
    }
}