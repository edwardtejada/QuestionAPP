import { LightningElement, wire, track, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getUserByEmail from '@salesforce/apex/QuestionUserController.getUserByEmail';
import { FlowNavigationNextEvent } from 'lightning/flowSupport';

const COLUMNS = [
    { label: 'Name', fieldName: 'Name' },
    { label: 'Last Name', fieldName: 'LastName' },
    { label: 'Email', fieldName: 'Email' },
    { label: 'Phone', fieldName: 'Phone' },
];

export default class SelectQuestionUser extends LightningElement {
    @api email;
    @api userId = null;

    @track users = [];
    @track columns = COLUMNS;

    @wire(getUserByEmail, { email: '$email' })
    wiredGetUserByEmail({error, data}) {
        if (data) {
            this.users = data;
        }
        else if (error) {
            this.toastError(error);
        }
    }

    handleRowSelection(event) {
        const selectedRows = event.target.selectedRows;
        this.userId = selectedRows;
    }

    handleCreateUser() {
        this.userId = null;
        this.handleNextActionFlow();
    }

    handleNextActionFlow() {
        const navigateNextEvent = new FlowNavigationNextEvent();
        this.dispatchEvent(navigateNextEvent);
    }

    toastError(error) {
        const event = new ShowToastEvent({
            variant: 'error',
            title: 'Error',
            message: 'Error getting user records - ' + error
        });
        this.dispatchEvent(event);
    }
}