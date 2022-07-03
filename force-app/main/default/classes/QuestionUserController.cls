public with sharing class QuestionUserController {
    
    @AuraEnabled(Cacheable=true)
    public static List<QuestionUser> getUserByEmail(String email) {
        List<Question_User__c> questionUsers = [
            SELECT Id, Name, Last_Name__c, Email__c, Phone__c
            FROM Question_User__c
            WHERE Email__c =: email
        ];

        List<QuestionUser> questionUserList = new List<QuestionUser>();
        for (Question_User__c user : questionUsers) {
            QuestionUser questionUser = new QuestionUser();
            questionUser.Id = user.Id;
            questionUser.Name = user.Name;
            questionUser.LastName = user.Last_Name__c;
            questionUser.Phone = user.Phone__c;
            questionUser.email = user.Email__c;
            questionUserList.add(questionUser);
        }

        return questionUserList;
    }

    public class QuestionUser {
        @AuraEnabled
        public String Id {get; set;}
        @AuraEnabled
        public String Name {get; set;}
        @AuraEnabled
        public String LastName {get; set;}
        @AuraEnabled
        public String Email {get; set;}
        @AuraEnabled
        public String Phone {get; set;}
    }
}
