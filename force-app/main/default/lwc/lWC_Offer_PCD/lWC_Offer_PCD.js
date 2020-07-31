/* eslint-disable no-mixed-spaces-and-tabs */

import { LightningElement,track,wire, api } from 'lwc';
import { CurrentPageReference} from 'lightning/navigation';
import { registerListener, unregisterAllListeners} from 'c/pubsub';
import {updateRecord} from 'lightning/uiRecordApi';
import ID_FIELD from '@salesforce/schema/Offer__c.Id';
import LAUNCHPB_FIELD from '@salesforce/schema/Offer__c.LaunchPB__c';
import PCDFIELD from '@salesforce/schema/Apttus__APTS_Agreement__c.Id';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import { getFieldValue } from 'lightning/uiRecordApi';
import { refreshApex } from '@salesforce/apex';
import PCDLabel from '@salesforce/label/c.PCD_Generate_URL';
//let testURL =window.location.href;
//let newURL = new URL(testURL).searchParams;



//import WARNINGEXIST from '@salesforce/schema/Offer__c.Warning_Exist__c';
import { NavigationMixin } from 'lightning/navigation';

import getAgreement from '@salesforce/apex/Offer_PCD_Lwc_Controller.getAgreement';
import getAgreement1 from '@salesforce/apex/Offer_PCD_Lwc_Controller.getAgreement1';

//const fields1= [PCDFIELD];

export default class LWC_Offer_PCD extends NavigationMixin(LightningElement) {


    @track ac;
    @api isLoaded = false;
    @api recordId1;
    @track bShowModal = false;
    @track bShowModal1 = false;
    @track PCD;
    @track PCDName;
    @track Task;
    @track Status;
    @track Opportunity;
    @track Alertmsg;
    @track PCDId;
    @track recordlink;
    @track GeneratePCD;
    @track errorMessage;
    @track inpVal;
    @track urlRef;
    @track UpdatePCD;
    @track UpdatePCDName;
    @track UpdatedResult;
    @track UpdatedResult1;
    @track Pending;
    @api PCDIdoffer;
    @track PCDId1;
    @track disableCancelButton=false;
    @track UpdatePCDName1;
    @track LastPCD;
  
 

	@track NotPending;
    @wire(CurrentPageReference) pageRef;


    
    connectedCallback() {
      // subscribe to inputChangeEvent event
      //location.reload('');
     
      registerListener('inputChangeEvent', this.handleChange, this);
    }
  disconnectedCallback() {
    // unsubscribe from inputChangeEvent event
    unregisterAllListeners(this);
  }
  handleRedirect() {
    window.console.log('In Handle');
    window.console.log('$$$$$'+this.inpVal);
    getAgreement1({Key:this.inpVal})
	  .then(result =>{
                //if(this.result!==null){
                    this.UpdatedResult1=JSON.stringify(result);
                    //if(this.UpdatedResult1.length!==2){
                      window.console.log("this.PCDIDDDDDDDDDDDDDDDDDDDDDDd**"+ getFieldValue(this.UpdatedResult1, PCDFIELD));
                      window.console.log("this.P@@@**"+ this.UpdatedResult1); 
                      const json = JSON.parse(this.UpdatedResult1);
                      this.PCDId1=json[0].Id;
                      this.PCDIdoffer=json[0].Offer__c;
                      this.UpdatePCDName1=json[0].Name;
                      this.LastPCD=json[0].Primary_Agreement_Line_Item__c;
                  window.console.log("this.PCD###3**"+this.PCDId1);
                  this[NavigationMixin.Navigate]({
                    type: 'standard__recordPage',
                     attributes: {
                       recordId:json[0].Id,
                       objectApiName: 'Apttus__APTS_Agreement__c',
                       actionName: 'view'
                     },
                     state: {
                     c__AgreementId:this.LastPCD
                    }
                  }
                    
                 );
                 this.closeModal1();
                 
                 
                    //}
               
               // }
	        }
  )
  // Navigate to a URL
  
  
}
  handleChange(inpVal) {
    this.inpVal = inpVal;
    window.console.log("this.inpVal"+this.inpVal);
	getAgreement({Key:this.inpVal})
	.then(result => {
    this.UpdatedResult=result;
                if(this.UpdatedResult!==null){
                    this.PCD=JSON.stringify(this.UpdatedResult);
                    window.console.log('this.PCD.length'+this.PCD.length+'this.PCD'+this.PCD);
              if(this.PCD.length!==2){
						  window.console.log("this.PCD**"+this.PCD.length);
						const json = JSON.parse(this.PCD);
					   
						this.PCDName=json[0].Name;
						this.recordlink=json[0].PCD_Agreement_link__c;
						this.PCDId=json[0].Id;
						window.console.log('this.urlRef'+this.urlRef);
						window.console.log('this.PCDId'+ this.PCDId);
								this.GeneratePCD=json[0].Generate_PCD__c;
					   
						this.urlRef=PCDLabel+this.PCDId;
						window.console.log('this.GeneratePCD'+this.GeneratePCD);
						if(this.GeneratePCD==='Pending..'){
							this.Pending='Pending';
							this.NotPending=false;
						}
						else{
						this.Pending='';
						this.NotPending='Pending';	
			        }
						window.console.log('this.Pending'+this.Pending);
						window.console.log('this.NotPending'+this.NotPending);
						this.Opportunity=json[0].Opportunity__c;
						this.Alertmsg=json[0].Alert__c;
						
						this.Status=json[0].PCD_Status__c;
						this.Task=json[0].Task_Offer__c;

						this.errorMessage='';
						window.console.log({abc:json});
						window.console.log("this.PCD"+this.PCD);
            }
            else if(this.UpdatedResult1!==undefined){
              window.console.log("this.PCD**"+this.PCD.length);
                  const json = JSON.parse(this.UpdatedResult1);
                 
                this.PCDName=json[0].Name;
                this.recordlink=json[0].PCD_Agreement_link__c;
                this.PCDId=json[0].Id;
                window.console.log('this.urlRef'+this.urlRef);
                window.console.log('this.PCDId'+ this.PCDId);
                    this.GeneratePCD=json[0].Generate_PCD__c;
                 
                this.urlRef=PCDLabel+this.PCDId;
                window.console.log('this.GeneratePCD'+this.GeneratePCD);
                if(this.GeneratePCD==='Pending..'){
                  this.Pending='Pending';
                  this.NotPending=false;
                }
                else{
                this.Pending='';
                this.NotPending='Pending';	
                      }
                window.console.log('this.Pending'+this.Pending);
                window.console.log('this.NotPending'+this.NotPending);
                this.Opportunity=json[0].Opportunity__c;
                this.Alertmsg=json[0].Alert__c;
                
                this.Status=json[0].PCD_Status__c;
                this.Task=json[0].Task_Offer__c;
    
                this.errorMessage='';
                window.console.log({abc:json});
                window.console.log("this.PCD"+this.PCD);
              }

					
            else{
            this.errorMessage='No PCD found for Selected Offer';
            this.PCDName='';
             }
           }
				   
                else{
                  this.errorMessage='No PCD found for Selected Offer';

                }
     })
     
  }
  closeModal() {    
    // to close modal window set 'bShowModal' tarck value as false
    this.bShowModal = false;
}
closeModal1() {    
  // to close modal window set 'bShowModal' tarck value as false
  this.bShowModal1 = false;
}
openModal() {    
  // to open modal window set 'bShowModal' tarck value as true
  this.recordId1=this.inpVal;
  this.bShowModal = true;
  window.console.log('id popup'+ this.recordId1);
}
openModal1() {    
  // to open modal window set 'bShowModal' tarck value as true
  
  this.bShowModal1 = true;
  
}
  updateAccount() {
    this.isLoaded = !this.isLoaded;
    this.disableCancelButton=true;
    const fields = {};
    fields[ID_FIELD.fieldApiName] =this.inpVal;
    fields[LAUNCHPB_FIELD.fieldApiName] =true;
    //fields[WARNINGEXIST.fieldApiName] =true;
    const recordInput = { fields };
    updateRecord(recordInput)
    .then(result => {
      this.message =result;
      //this.dispatchEvent(
         // new ShowToastEvent({
              //title: 'Success',
              //message:'PCD for Selected offer is created Sucessfully',
              //variant: 'success'
          //})
      //);
      // Display fresh data in the form
      
      this.closeModal();
      this.openModal1();
      //this.handleChange(this.inpVal);

     })
     .catch(error =>{
      this.closeModal(); 
      window.console.log('error loading page data:');
      window.console.log(error);
      const evt = new ShowToastEvent({
        title: 'Application Error',
        message: 'Error in PCD Creation',
        variant: 'error',
        mode: 'dismissable'
    });
    this.dispatchEvent(evt);
      })
     
    }
    handleSuccess() {
      return refreshApex(this.handleChange);
  }
       
}