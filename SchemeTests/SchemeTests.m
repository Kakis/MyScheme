//
//  SchemeTests.m
//  SchemeTests
//
//  Created by Jens Hagfeldt on 2013-08-28.
//  Copyright (c) 2013 Jens Hagfeldt. All rights reserved.
//

#import "SchemeTests.h"
#import "Scheme.h"
#import "Admin.h"
#import "Lesson.h"
#import "Student.h"
#import "Message.h"


// Keys for sorting lessons in a week
static NSString * const mondayKey = @"monday_key";
static NSString * const tuesdayKey = @"tuesday_key";
static NSString * const wednesdayKey = @"wednesday_key";
static NSString * const thursdayKey = @"thursday_key";
static NSString * const fridayKey = @"friday_key";

// Keys for sorting students in two courses
static NSString * const appdevKey = @"appdev_Key";
static NSString * const javaKey = @"java_key";

//typedef void (^GetObjectResponce)(NSArray *getObject);


@implementation SchemeTests
{
    NSDictionary *lessons;
    NSDictionary *students;
    Scheme *scheme;
    Lesson *appdevLesson;
    Student *appdevStudent;
    Admin *admin;
    Message *course_message;
    Message *private_message;
}

- (void)setUp
{
    lessons = @{mondayKey:[[NSMutableSet alloc] init],
                tuesdayKey:[[NSMutableSet alloc] init],
                wednesdayKey:[[NSMutableSet alloc] init],
                thursdayKey:[[NSMutableSet alloc] init],
                fridayKey:[[NSMutableSet alloc] init]};
    
    students = @{appdevKey:[[NSMutableSet alloc] init],
                 javaKey:[[NSMutableSet alloc] init]};
    
    appdevLesson = [[Lesson alloc] initWithSubject:@"UIresponder"
                                              name:@"appdevLesson"
                                              type:@"lesson"
                                            course:@"Objective C"
                                              week:@"24"
                                               day:@"monday"
                                        lessontime:@"09:00"
                                           teacher:@"Anders"
                                         classroom:@"4108"
                                        assignment:@"Lämna in projektet och få godkännt av Anders"];
    
    course_message = [[Message alloc]initWithTitle:@"course_message"
                                           subject:@"lämna in projekt"
                                            sender:@"Admin"
                                          receiver:@"iOS"
                                              type:@"message"
                                           message:@"Idag lämnar vi in projektek äntligen!" ];
    
    private_message = [[Message alloc] initWithTitle:@"private_message"
                                             subject:@"testar om det funkar"
                                              sender:@"Admin"
                                            receiver:@"Jens"
                                                type:@"message"
                                             message:@"Testar om det går att skicka ett privat meddelande"];
    
    
    appdevStudent = [[Student alloc] initWithLastName:@"Hagfeldt"
                                            firstName:@"Jens"
                                                 type:@"student"
                                               course:@"appdev"];
    
    admin = [[Admin alloc] initWithUserName:@"Anders"
                                   password:@"admin"];
    
    scheme = [[Scheme alloc] init];
}

- (void)tearDown
{
    lessons = nil;
    students = nil;
    appdevLesson = nil;
    appdevStudent = nil;
    admin = nil;
    scheme = nil;
    course_message = nil;
    private_message = nil;
}

//-(void) testAddLesson
//{
//    BOOL result =[scheme addNewLesson:appdevLesson adminPassword:@"admin"];
//    STAssertTrue(result, @"Det borde vara möljigt att lägga till en lektion.");
//
//}


//-(void) testSaveLessonToDb
//{
//    BOOL result = [scheme saveLessonToDb:appdevLesson adminPassword:@"admin"];
//    STAssertTrue(result, @"Det skall ha sparats en lektion på databasen.");
//
//}


//-(void) testGetLesson
//{
//    BOOL result = [scheme getLesson:@"appdevLesson" onCompletion:^(NSArray *getObject)
//                   {
//                       for (id _id in getObject) {
//                           NSLog(@"%@", [[NSString alloc] initWithData:_id encoding:NSUTF8StringEncoding]);
//                       }
//                   }];
//    STAssertTrue(result, @"");
//
//}


//-(void) testUpdateLesson
//{
//    BOOL result [[scheme updateLesson:appdevLesson
//                              withId:@"7AD0F3D9-5D21-4685-AB25-2E461334950A"
//                              andRev:@"1-4e7115a6ecd054c9035ce89e7d96ec23" adminPassword:@"admin"]];
//
//    STAssertTrue(result, @"Lektionen borde vara uppdaterad");
//
//}


//-(void) testGetScheduleForWeek
//{
//    BOOL result = [scheme getScheduleForCourse:@"Objective C" Week:@"21" onCompletion:^(NSArray *getObject){
//        for (id _id in getObject) {
//            NSLog(@"%@", [[NSString alloc] initWithData:_id encoding:NSUTF8StringEncoding]);
//        }
//    }];
//
//    STAssertTrue(result, @"En elev ska kunna se hela veckans schema för sin kurs");
//}


//-(void) testGetScheduleForCourseWeekAndDay
//{
//    BOOL result = [scheme getScheduleForCourse:@"iOS"
//                                          Week:@"22"
//                                        andDay:@"friday"
//                                  onCompletion:^(NSArray *getObject)
//    {
//        for (id _id in getObject) {
//            NSLog(@"%@", [[NSString alloc] initWithData:_id encoding:NSUTF8StringEncoding]);
//        }
//
//    }];
//
//    STAssertTrue(result, @"En elev ska kunna se sitt schema för dagen");
//}


//-(void) testGetAssignmentsForCourseWeek
//{
//    BOOL result = [scheme getAssignmentsForCourse:@"Objective C" Week:@"21"
//                                     onCompletion:^(NSArray *getObject)
//        {
//            for (id _id in getObject) {
//                NSLog(@"%@", [[NSString alloc] initWithData:_id encoding:NSUTF8StringEncoding]);
//            }
//        }];
//
//    STAssertTrue(result, @"En elev ska kunna se alla veckans läsanvisningar för sin kurs");
//}


//-(void) testAddNewMessage
//{
//    BOOL result = [scheme addNewMessage:course_message adminPassword:@"Admin"];
//
//    STAssertTrue(result, @"Att lägga till ett medelande borde vara möljigt");
//}


//-(void) testSaveMessageToDB
//{
//    BOOL result [[scheme saveMessage:course_message adminPassword:@"admin"]];
//
//    STAssertTrue(result, @"Ett meddelande ska ha skickats till alla elever i klassen");
//}


//-(void) testGetMessagesForCourse
//{
//    BOOL result = [scheme getMessagesForCourse:@"iOS"
//                                  onCompletion:^(NSArray *getObject)
//    {
//        for (id _id in getObject) {
//            NSLog(@"%@", [[NSString alloc] initWithData:_id encoding:NSUTF8StringEncoding]);
//        }
//    }];
//
//    STAssertTrue(result, @"Studenter i iOS-kursen ska kunna hämta ett gemensamt meddelande");
//
//}


//-(void) testAddNewMessage
//{
//    BOOL result = [scheme addNewMessage:private_message adminPassword:@"Admin"];
//
//    STAssertTrue(result, @"Att lägga till ett medelande borde vara möljigt");
//}


//-(void) testSaveMessageToDB
//{
//    BOOL result [[scheme saveMessage:private_message adminPassword:@"admin"]];
//
//    STAssertTrue(result, @"Ett meddelande ska ha skickats till en specifik elev i klassen");
//}


//-(void) testGetPrivateMessagesForStudent
//{
//    BOOL result = [scheme getPrivateMessagesFor:appdevStudent onCompletion:^(NSArray * getObject)
//                   {
//                       for (id _id in getObject) {
//                           NSLog(@"%@", [[NSString alloc] initWithData:_id encoding:NSUTF8StringEncoding]);
//                       }
//                   }];
//    STAssertTrue(result, @"Aktuell student ska kunna få alla sina privata meddelande");
//}


//-(void) testAddNewStudent
//{
//    BOOL result = [scheme addNewStudent:appdevStudent adminPassword:@"admin"];
//
//    STAssertTrue(result, @"En student ska ha lagts till");
//}


//-(void) testSaveStudenToDb
//{
//    BOOL result = [scheme saveStudentToDb:appdevStudent adminPassword:@"admin"];
//
//    STAssertTrue(result, @"En student ska ha sparats i databasen");
//
//}


//-(void) testGetStudent
//{
//    BOOL result = [scheme getStudent:appdevStudent
//                        onCompletion:^(NSArray *getObject)
//                   {
//                       for (id _id in getObject) {
//                           NSLog(@"%@", [[NSString alloc] initWithData:_id encoding:NSUTF8StringEncoding]);
//                       }
//                   }];
//
//    STAssertTrue(result, @"Alla data för en student ska kunna hämtas");
//}


@end
