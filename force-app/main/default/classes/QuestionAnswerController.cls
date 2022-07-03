public with sharing class QuestionAnswerController {
    
    @AuraEnabled(Cacheable=true)
    public static List<Question> getQuestion() {
        List<Question__c> questions = [
            SELECT Id, Name, Description__c, Type__c,
                (SELECT Id, Name, Is_Correct__c
                FROM Answers__r
                WHERE Is_Active__c = True)
            FROM Question__c
            WHERE Is_Active__c = true
        ];

        List<Question> questionList = new List<Question>();
        for (Question__c question : questions) { 
            Question questionObject = new Question();
            questionObject.QuestionId = question.Id;
            questionObject.Name = question.Name;
            questionObject.Type = question.Type__c;
            questionObject.IsCheckBoxType = question.Type__c == 'Checkbox';
            questionObject.IsRadioButtonType = question.Type__c == 'Radio button';
            questionObject.Description = question.Description__c;
            List<Answer> answerList = new List<Answer>();
            for (Answer__c answer : question.Answers__r) {
                Answer answerObject = new Answer();
                answerObject.AnswerId = answer.Id;
                answerObject.Name = answer.Name;
                answerObject.IsCorrect = answer.Is_Correct__c;
                answerObject.IsChose = false;
                answerList.add(answerObject);
            }
            questionObject.Answers = answerList;
            questionList.add(questionObject);
        }

        return questionList;
    }

    public class Question {
        @AuraEnabled
        public Id QuestionId {get;set;}

        @AuraEnabled
        public String Name {get;set;}

        @AuraEnabled
        public String Type {get;set;}

        @AuraEnabled
        public Boolean IsCheckBoxType {get;set;}

        @AuraEnabled
        public Boolean IsRadioButtonType {get;set;}

        @AuraEnabled
        public String Description {get;set;}

        @AuraEnabled
        public List<Answer> Answers {get; set; }
    }

    public class Answer {
        @AuraEnabled
        public Id AnswerId {get;set;}

        @AuraEnabled
        public String Name {get;set;}

        @AuraEnabled
        public Boolean IsCorrect {get;set;}

        @AuraEnabled
        public Boolean IsChose {get;set;}
    }
}
