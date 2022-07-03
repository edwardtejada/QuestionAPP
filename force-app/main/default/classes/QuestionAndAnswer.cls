public class QuestionAndAnswer {
    @AuraEnabled 
    @InvocableVariable 
    public Id questionId;

    @AuraEnabled 
    @InvocableVariable 
    public String answer;

    @AuraEnabled 
    @InvocableVariable 
    public Boolean isCorrect;
}
