import { LightningElement } from 'lwc';

export default class DynamicForm extends LightningElement {
    emailField;
    phoneField;
    options = [
        { label: 'Phone', value: 'phone' },
        { label: 'Email', value: 'email' },
    ]

    handleChange(event) {
        this.emailField = event.target.value === 'email';
        this.phoneField = event.target.value === 'phone';
    }
}             