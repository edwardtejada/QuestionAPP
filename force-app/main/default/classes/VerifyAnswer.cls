public with sharing class VerifyAnswer {
    
    @InvocableMethod(label='Is Answer Correct'
                     description='Return true if answer it is correct')
    public static List<Response> isAnswerCorrect(List<Request> request) {
        Id questionId = request.get(0).questionId;
        String radioButtonAnswer = request.get(0).radioButtonAnswer;
        String checkBoxAnswer = request.get(0).checkBoxAnswer;
        String answerChose = String.isBlank(radioButtonAnswer) ? checkBoxAnswer : radioButtonAnswer;
        Boolean isAnswerCorrect = false;

        Question__c question = [
            SELECT Id, Name,
                (SELECT Id, Name, Is_Correct__c
                FROM Answers__r
                WHERE Is_Active__c = True)
            FROM Question__c
            WHERE Id =: questionId
        ]; 

        for (Answer__c answer : question.Answers__r) {
            if (answer.Is_Correct__c && answerChose.contains(answer.Name)) {
                isAnswerCorrect = true;
                break;
            }
        }

        List<Response> responseList = new List<Response>();
        Response response = new Response();
        response.isCorrect = isAnswerCorrect;
        response.answer = answerChose;
        responseList.add(response);

        return responseList;
    }

    public class Request {
        @InvocableVariable
        public Id questionId;

        @InvocableVariable
        public String radioButtonAnswer;

        @InvocableVariable
        public String checkBoxAnswer;
    }

    public class Response {
        @InvocableVariable
        public String answer;

        @InvocableVariable
        public Boolean isCorrect;
    }
}
