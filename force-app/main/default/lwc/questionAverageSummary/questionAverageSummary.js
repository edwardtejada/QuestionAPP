import { LightningElement, api } from 'lwc';

export default class QuestionAverageSummary extends LightningElement {
    @api amountCorrectQuestion;
    @api amountQuestion;
}