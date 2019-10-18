@isTest
public with sharing class DuplicateEnrollmentTriggerTest {
   @TestSetup
    static void makeData()
    {
        SchoolDataCreator.createData();
        ClassEnrollmentCreator.createClassEnrollment();
    }  

    @isTest
    public static void testSingleInsert()
    {
        Test.startTest();
        ClassEnrollment__c ce = [SELECT Id, Student__c, Class__c FROM ClassEnrollment__c LIMIT 1];
        ClassEnrollment__c ce1 = new CLassEnrollment__c();
        ce1.Student__c = ce.Student__c;
        ce1.Class__c = ce.Class__c;
        ce1.Credits__c = 7;

        try 
        {
            insert ce1;
        } catch (Exception e) 
        {
            System.assertEquals(1, [SELECT Id FROM ClassEnrollment__c].size());
            System.assert(e.getMessage().contains('already enrolled'));    
        }


        Test.stopTest();
    }


    @isTest
    public static void testMultipleInsert()
    {
        Test.startTest();
        ClassEnrollment__c ce = [SELECT Id, Student__c, Class__c FROM ClassEnrollment__c LIMIT 1];
        List<Student__c> s = [SELECT Id FROM Student__c LIMIT 3];
        List<Class__c> c = [SELECT Id FROM Class__c LIMIT 3];
        List<CLassEnrollment__c> ceList = new List<ClassEnrollment__c>();

        ClassEnrollment__c ce1 = new ClassEnrollment__c();
        ce1.Student__c = ce.Student__c;
        ce1.Class__c = ce.Class__c;
        ce1.Credits__c = 7;
        ceList.add(ce1);

        CLassEnrollment__c ce2 = new ClassEnrollment__c();
        ce2.Student__c = s[1].Id;
        ce2.Class__c = c[1].Id;
        ce2.Credits__c = 6;
        ceList.add(ce2);

        ClassEnrollment__c ce3 = new ClassEnrollment__c();
        ce3.Student__c = s[2].Id;
        ce3.Class__c = c[2].Id;
        ce3.Credits__c = 9;
        ceList.add(ce3);

        List<Database.SaveResult> results = Database.insert(ceList, false);
        System.assertEquals(1, [SELECT Id FROM CLassEnrollment__c].size());
        System.assertEquals(results[0].getErrors()[0].getMessage(), 'already enrolled');


        Test.stopTest();
    }
}