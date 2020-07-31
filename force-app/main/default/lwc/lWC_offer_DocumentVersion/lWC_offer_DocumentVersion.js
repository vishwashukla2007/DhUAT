import { LightningElement,track,wire } from 'lwc';
import { CurrentPageReference} from 'lightning/navigation';
import { registerListener, unregisterAllListeners} from 'c/pubsub';
import getDocument from '@salesforce/apex/Offer_PCD_Lwc_Controller.getDocument';


export default class LWC_offer_DocumentVersion extends LightningElement {
    @track ac;
    @track PCD;
    @track PCDName;
    @track PCDList;
    @track errorMessage;
    @track docuType;
    @track inpVal;
    @track DocuID;
    @track ShowPopHover=false;
    @track ClosePopHover=false;
    @wire(CurrentPageReference) pageRef;

    connectedCallback() {
      // subscribe to inputChangeEvent event
      registerListener('inputChangeEventDocument', this.handleChange, this);
    }
  disconnectedCallback() {
    // unsubscribe from inputChangeEvent event
    unregisterAllListeners(this);
  }
  handleChange(inpVal) {
    this.inpVal = inpVal;
    window.console.log("this.inpVal"+this.inpVal);
	getDocument({Key:this.inpVal})
	.then(result => {
                if(result!==null){
                    this.PCD=JSON.stringify(result);
                    if(this.PCD.length!==2){
                    window.console.log("this.PCD**"+this.PCD.length);
                    const json = JSON.parse(this.PCD);
                    this.PCDList= JSON.parse(this.PCD);
                    this.PCDName=json[0].Name;
                    this.errorMessage='';
                    this.docuType=json[0].Apttus__FileType__c;
                    window.console.log({abc:json});
                    window.console.log("this.PCD"+this.PCD);
                    window.console.log(" this.docuType"+ this.docuType);
                    }
                    else{
                      this.errorMessage='No Document found';
                      this.PCDName='';
                    }
                }
                else{
                  this.errorMessage='No Document found';

                }
     })

    }
    showData(event){
      this.DocuID=event.target.dataset.value;
      this.ShowPopHover=true;
      window.console.log('DocumentID'+this.DocuID);
    }
    hideData(){
      this.ShowPopHover=false;
    }
}