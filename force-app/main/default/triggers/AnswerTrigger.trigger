trigger AnswerTrigger on Answer__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    new AnswerTriggerHandler().run();
}