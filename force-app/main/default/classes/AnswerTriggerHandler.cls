public class AnswerTriggerHandler extends TriggerHandler {

    private list<Answer__c> newAnswers;
    private list<Answer__c> oldAnswers;
    private map<Id, Answer__c> newAnswersMap;
    private map<Id, Answer__c> oldAnswersMap;

    public AnswerTriggerHandler() {
        newAnswers = (list<Answer__c>)Trigger.new;
        oldAnswers = (list<Answer__c>)Trigger.old;
        if (Trigger.isInsert || Trigger.isUpdate) newAnswersMap = (map<Id, Answer__c>)Trigger.newMap;
        if (Trigger.isUpdate || Trigger.isDelete) oldAnswersMap = (map<Id, Answer__c>)Trigger.oldMap;
    }

    public override void beforeInsert() {
        validateIscorrectAnswerWithQuestionTypeRadioButton();
    }
    public override void beforeUpdate() {
        validateIscorrectAnswerWithQuestionTypeRadioButton();
    }
    public override void beforeDelete() {}
    public override void afterInsert() {}
    public override void afterUpdate() {}
    public override void afterDelete() {}
    public override void afterUndelete() {}

    private void validateIscorrectAnswerWithQuestionTypeRadioButton() {
        set<Id> questionIds = new set<Id>();
        for (Answer__c answer : newAnswers) {
            questionIds.add(answer.Question__c);
        }

        map<Id, String> answersMap = new map<Id, String>();
        List<Answer__c> answers = [
            SELECT Id, Name, Question__c, Is_correct__c
            FROM Answer__c
            WHERE Question__c IN :questionIds
            AND Is_correct__c = true
            AND Question__r.Type__c = 'Radio button'
        ];
        for (Answer__c answer : answers) {
            answersMap.put(answer.Question__c, answer.Name);
        }

        for (Answer__c answer : newAnswers) {
            if (answer.Is_correct__c) {
                if (answersMap.containsKey(answer.Question__c)) {
                    answer.addError('You can only select a single correct answer when the question is of type radio Button');
                }
            }
        }
    }
}
