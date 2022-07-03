import { LightningElement, api, wire, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getQuestion from '@salesforce/apex/QuestionAnswerController.getQuestion';

export default class QuestionAnswerSummary extends LightningElement {
    @api questionAndAnswer = [];

    @track questions = [];
    @track newQuestionArray = [];
    @track questionsToView = [];

    showList = true;
    page = 1; 
    startingRecord = 1;
    endingRecord = 0; 
    pageSize = 3; 
    totalRecountCount = 0;
    totalPage = 0;

    get disablePreviousButton() {
        return this.page == 1;
    }

    get disableNextButton() {
        return this.page == this.totalPage;
    }

    @wire(getQuestion)
    wiredGetQuestion({error, data}) {
        if (data) {
            this.questions = data;
            this.choseQuestion();
            this.totalRecountCount = data.length; 
            this.totalPage = Math.ceil(this.totalRecountCount / this.pageSize); 
            this.questionsToView = this.questions.slice(0,this.pageSize); 
            this.endingRecord = this.pageSize;
        }
        else if (error) {
            this.toastError(error);
        }
    }

    choseQuestion() {
        let newQuestionArray = JSON.parse(JSON.stringify(this.questions));
        let newQuestionArrayResult = newQuestionArray.map(question => {
            let questionAnswer = this.questionAndAnswer.find(x => x.questionId == question.QuestionId);
            if (questionAnswer) {
                if (question.IsCheckBoxType) {
                    let answerArray = [];
                    if (questionAnswer.answer.indexOf(';') !== -1) {
                        answerArray = questionAnswer.answer.split(';');
                    } else {
                        answerArray.push(questionAnswer.answer); 
                    }

                    question.Answers.map((answer, index) => {
                        answerArray.map(ans => {
                            if (answer.Name == ans) {
                                answer.IsChose = true;
                                answer.IsChoseCorrect = answer.IsChose && !answer.IsCorrect;
                            }
                        });
                    });
                }

                if (question.IsRadioButtonType) {
                    question.Answers.map((answer, index) => {
                        if (answer.Name == questionAnswer.answer) {
                            answer.IsChose = true;
                            answer.IsChoseCorrect = answer.IsChose && !answer.IsCorrect;
                        }
                    });
                }
            }
            return question;
        });
        this.questions = newQuestionArrayResult;
    }

    handlePrevious() {
        if (this.page > 1) {
            this.page = this.page - 1; 
            this.displayRecordPerPage();
        }
    }

    handleNext() {
        if ((this.page < this.totalPage) && this.page !== this.totalPage) {
            this.page = this.page + 1; 
            this.displayRecordPerPage();            
        }             
    }

    displayRecordPerPage() {
        this.startingRecord = ((this.page -1) * this.pageSize);
        this.endingRecord = (this.pageSize * this.page);

        this.endingRecord = (this.endingRecord > this.totalRecountCount) 
                                ? this.totalRecountCount : this.endingRecord; 

        this.questionsToView = this.questions.slice(this.startingRecord, this.endingRecord);

        this.startingRecord = this.startingRecord + 1;
    } 

    toastError(error) {
        const event = new ShowToastEvent({
            variant: 'error',
            title: 'Error',
            message: 'Error getting question records - ' + error
        });
        this.dispatchEvent(event);
    }
}