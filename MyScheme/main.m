//
//  main.m
//  MyScheme
//
//  Created by Jens Hagfeldt on 2013-04-29.
//  Copyright (c) 2013 Jens Hagfeldt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Scheme.h"
#import "Student.h"
#import "Lesson.h"

int main(int argc, const char * argv[])
{

    @autoreleasepool {

////////////////////////////////////////// Initializing objects /////////////////////////////////////////

        
        Student *jens = [[Student alloc] initWithLastName:@"Hagfeldt"
                                                firstName:@"Jens"
                                                     type:@"student"
                                                   course:@"iOS"];
        
        Student *kristoffer = [[Student alloc] initWithLastName:@"Bergkvist"
                                                      firstName:@"Kristoffer"
                                                           type:@"student"
                                                         course:@"Objective C"];
        
        // ------------------------------------- Objective C lessons -----------------------------------//
        
        Lesson *objC_lesson1 = [[Lesson alloc] initWithSubject:@"Object Instance Variables"
                                                       name:@"objC_lesson1"
                                                       type:@"lesson"
                                                     course:@"Objective C"
                                                       week:@"21"
                                                        day:@"monday"
                                                 lessontime:@"09:00"
                                                    teacher:@"Anders"
                                                  classroom:@"4108"
                                                 assignment:@"read chapter 19 - Object Instance Variables"];
        
        Lesson *objC_lesson2 = [[Lesson alloc] initWithSubject:@"Collection Classes"
                                                          name:@"objC_lesson2"
                                                          type:@"lesson"
                                                        course:@"Objective C"
                                                          week:@"21"
                                                           day:@"tuesday"
                                                    lessontime:@"09:00"
                                                       teacher:@"Anders"
                                                     classroom:@"4108"
                                                    assignment:@"read chapter 21 - Collection Classes"];
        
        Lesson *objC_lesson3 = [[Lesson alloc] initWithSubject:@"Object Instance Variables"
                                                          name:@"objC_lesson3"
                                                          type:@"lesson"
                                                        course:@"Objective C"
                                                          week:@"21"
                                                           day:@"friday"
                                                    lessontime:@"09:00"
                                                       teacher:@"Anders"
                                                     classroom:@"4108"
                                                    assignment:@"read chapter 25 - Protocols"];
        
        Lesson *objC_lesson4 = [[Lesson alloc] initWithSubject:@"Project start"
                                                          name:@"objC_lesson4"
                                                          type:@"lesson"
                                                        course:@"Objective C"
                                                          week:@"23"
                                                           day:@"wednesday"
                                                    lessontime:@"09:00"
                                                       teacher:@"Anders"
                                                     classroom:@"Aulan"
                                                    assignment:@"start working on your project"];
        
        Lesson *objC_lesson5 = [[Lesson alloc] initWithSubject:@"Finish project"
                                                          name:@"objC_lesson5"
                                                          type:@"lesson"
                                                        course:@"Objective C"
                                                          week:@"23"
                                                           day:@"thursday"
                                                    lessontime:@"09:00"
                                                       teacher:@"Anders"
                                                     classroom:@"4108"
                                                    assignment:@"finish your project"];
        
        // -------------------------------------- iOS lessons ------------------------------------//
        
        Lesson *iOS_lesson1 = [[Lesson alloc] initWithSubject:@"View Controllers"
                                                          name:@"iOS_lesson1"
                                                          type:@"lesson"
                                                        course:@"iOS"
                                                          week:@"22"
                                                           day:@"monday"
                                                    lessontime:@"09:00"
                                                       teacher:@"Anders"
                                                     classroom:@"4108"
                                                    assignment:@"read chapter 7 - View Controllers"];
        
        Lesson *iOS_lesson2 = [[Lesson alloc] initWithSubject:@"View Controllers"
                                                         name:@"iOS_lesson2"
                                                         type:@"lesson"
                                                       course:@"iOS"
                                                         week:@"22"
                                                          day:@"tuesday"
                                                   lessontime:@"09:00"
                                                      teacher:@"Anders"
                                                    classroom:@"4108"
                                                   assignment:@"read chapter 12 - Camera"];
        
        Lesson *iOS_lesson3 = [[Lesson alloc] initWithSubject:@"WWDC 2013"
                                                         name:@"iOS_lesson3"
                                                         type:@"lesson"
                                                       course:@"iOS"
                                                         week:@"22"
                                                          day:@"friday"
                                                   lessontime:@"09:00"
                                                      teacher:@"Anders"
                                                    classroom:@"Aulan"
                                                   assignment:@"watch WWDC 2013 and make notes"];
        
        Lesson *iOS_lesson4 = [[Lesson alloc] initWithSubject:@"Popover Controllers"
                                                         name:@"iOS_lesson4"
                                                         type:@"lesson"
                                                       course:@"iOS"
                                                         week:@"23"
                                                          day:@"wednesday"
                                                   lessontime:@"09:00"
                                                      teacher:@"Anders"
                                                    classroom:@"4108"
                                                   assignment:@"read chapter 15 - Popover Controllers"];
      
        Lesson *iOS_lesson5 = [[Lesson alloc] initWithSubject:@"Exam"
                                                         name:@"iOS_lesson5"
                                                         type:@"lesson"
                                                       course:@"iOS"
                                                         week:@"23"
                                                          day:@"thursday"
                                                   lessontime:@"09:00"
                                                      teacher:@"Anders"
                                                    classroom:@"Aulan"
                                                   assignment:@"write your own app"];
        
        // ---------------------------------------- Messages ---------------------------------------//
        
        Message *private_message1 = [[Message alloc] initWithTitle:@"private_message1"
                                                         subject:@"tips kapitel 4"
                                                          sender:@"Admin"
                                                        receiver:@"Jens"
                                                            type:@"message"
                                                         message:@"Kolla YouTube klippet på url: X"
                                                       isPrivate:YES];
        
        Message *objective_c_message1 = [[Message alloc] initWithTitle:@"obj_C_course_message"
                                                               subject:@"ny sal"
                                                                sender:@"Admin"
                                                              receiver:@"Objective C"
                                                                  type:@"message"
                                                               message:@"Vi ska vara i sal 3108 på fredag"
                                                             isPrivate:NO];
        
        Scheme *scheme = [[Scheme alloc] init];
        
        
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
        
        
        
///////// En administratör ska kunna lägga in ett nytt schema för en viss kurs ////////////////////////////////

        
//        // Adding students attending the ObjectiveC-course
//        [scheme addNewStudent:jens adminPassword:@"admin"];
//        [scheme addNewStudent:kristoffer adminPassword:@"admin"];
//        
//        // Adding lessons to the ObjectiveC-course
//        [scheme addNewLesson:objC_lesson1 adminPassword:@"admin"];
//        [scheme addNewLesson:objC_lesson2 adminPassword:@"admin"];
//        [scheme addNewLesson:objC_lesson3 adminPassword:@"admin"];
//        [scheme addNewLesson:objC_lesson4 adminPassword:@"admin"];
//        [scheme addNewLesson:objC_lesson5 adminPassword:@"admin"];
//
//        // Adding lessons to the iOS-course
//        [scheme addNewLesson:iOS_lesson1 adminPassword:@"admin"];
//        [scheme addNewLesson:iOS_lesson2 adminPassword:@"admin"];
//        [scheme addNewLesson:iOS_lesson3 adminPassword:@"admin"];
//        [scheme addNewLesson:iOS_lesson4 adminPassword:@"admin"];
//        [scheme addNewLesson:iOS_lesson5 adminPassword:@"admin"];
        
        
///////////////////////////////////////////////////////////////////////////////////////////////////////////////



///////// En administratör ska kunna lägga in ett meddelande till alla elever i en kurs ///////////////////////


//        [scheme addNewMessage:objective_c_message1];
        
        
//        [scheme saveMessage:objective_c_message1];

        
//        [scheme getMessagesForCourse:@"Objective C" onCompletion:^(NSArray *getObject){
//            for(id _id in getObject) {
//                NSLog(@"%@", [[NSString alloc] initWithData:_id
//                                                   encoding:NSUTF8StringEncoding]);
//                
//            }
//        }];
        
        
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
        
        
        
///////// En administratör ska kunna lägga in ett meddelande till en viss elev ////////////////////////////////

        
//        [scheme addNewMessage:private_message1];

        
//        [scheme saveMessage:private_message1];
        

//        [scheme getPrivateMessagesFor:jens onCompletion:^(NSArray *getObject){
//            for(id _id in getObject) {
//                NSLog(@"%@", [[NSString alloc] initWithData:_id
//                                                   encoding:NSUTF8StringEncoding]);
//                
//            }
//        }];

        
///////////////////////////////////////////////////////////////////////////////////////////////////////////////


        
///////// All data ska sparas i CouchDB (Iris Couch eller lokalt installerad) /////////////////////////////////
        

//        // Save Students to couch.db
//        [scheme saveStudentToDb:jens];
//        [scheme saveStudentToDb:kristoffer];

        
//        // Save Lessons to couch.db
//        [scheme saveLessonToDb:objC_lesson1 adminPassword:@"admin"];
//        [scheme saveLessonToDb:objC_lesson2 adminPassword:@"admin"];
//        [scheme saveLessonToDb:objC_lesson3 adminPassword:@"admin"];
//        [scheme saveLessonToDb:objC_lesson4 adminPassword:@"admin"];
//        [scheme saveLessonToDb:objC_lesson5 adminPassword:@"admin"];     
//        [scheme saveLessonToDb:iOS_lesson1 adminPassword:@"admin"];
//        [scheme saveLessonToDb:iOS_lesson2 adminPassword:@"admin"];
//        [scheme saveLessonToDb:iOS_lesson3 adminPassword:@"admin"];
//        [scheme saveLessonToDb:iOS_lesson4 adminPassword:@"admin"];
//        [scheme saveLessonToDb:iOS_lesson5 adminPassword:@"admin"];
        
        
//        [scheme saveMessage:objective_c_message1];
//        [scheme saveMessage:private_message1];

        

///////////////////////////////////////////////////////////////////////////////////////////////////////////////
        
        
        
///////// En elev ska kunna se* sitt schema för veckan ////////////////////////////////////////////////////////


//        // Hämta schema för kurs Objective C vecka 21
//        [scheme getScheduleForCourse:@"Objective C"
//                                Week:@"21"
//                        onCompletion:^(NSArray *getObject){
//                            for(id _id in getObject) {
//                                NSLog(@"%@", [[NSString alloc] initWithData:_id
//                                                                   encoding:NSUTF8StringEncoding]);
//                                
//                            }
//                        }];

        

//        // Hämta schema för kurs iOS vecka 22
//        [scheme getScheduleForCourse:@"iOS"
//                                Week:@"22"
//                        onCompletion:^(NSArray *getObject){
//                            for(id _id in getObject) {
//                                NSLog(@"%@", [[NSString alloc] initWithData:_id
//                                                                   encoding:NSUTF8StringEncoding]);
//                                
//                            }
//                        }];

        
        
//        // Hämta schema för kurs Objective C vecka 23
//        [scheme getScheduleForCourse:@"Objective C"
//                                Week:@"23"
//                        onCompletion:^(NSArray *getObject){
//            for(id _id in getObject) {
//                NSLog(@"%@", [[NSString alloc] initWithData:_id
//                                                   encoding:NSUTF8StringEncoding]);
//                
//            }
//        }];

        
        
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
        
        
    
///////// En elev ska kunna se* sitt schema för dagen /////////////////////////////////////////////////////////

        
//        // Hämta schema för kurs iOS måndag vecka 22
//        [scheme getScheduleForCourse:@"iOS"
//                                Week:@"22"
//                              andDay:@"monday" onCompletion:^(NSArray *getObject){
//                                  for(id _id in getObject) {
//                                      NSLog(@"%@", [[NSString alloc] initWithData:_id
//                                                                         encoding:NSUTF8StringEncoding]);
//                                      
//                                  }
//                              }];
        
        
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
        
        
        
////////// En elev ska kunna se* läsanvisningar för veckan ////////////////////////////////////////////////////


//        // Hämta Objective C-kursens läsanvisningar för vecka 21
//        [scheme getAssignmentsForCourse:@"Objective C"
//                                   Week:@"21"
//                           onCompletion:^(NSArray *getObject){
//            for(id _id in getObject) {
//                NSLog(@"%@", [[NSString alloc] initWithData:_id
//                                                   encoding:NSUTF8StringEncoding]);
//                
//            }
//        }];

        
////////// En elev ska kunna se* läsanvisningar för dagen ////////////////////////////////////////////////////

        
//        // Hämta iOS-kursens läsanvisningar för fredagen vecka 22
//        [scheme getAssignmentsForCourse:@"iOS"
//                                   Week:@"22"
//                                 andDay:@"friday"
//                           onCompletion:^(NSArray *getObject){
//                               for(id _id in getObject) {
//                                   NSLog(@"%@", [[NSString alloc] initWithData:_id
//                                                                      encoding:NSUTF8StringEncoding]);
//                                   
//                               }
//                           }];

        
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
      

////// En administratör ska kunna ändra information i ett schema //////////////////////////////////////////////
//
//
////////////////////// OBS - NOT WORKING YET !!!
        

///////// Hämta första alla data för lesson "Camera" /////////////////////////////////////////////////////////


//        [scheme getLesson:@"Camera" onCompletion:^(NSArray *getObject){
//            for(id _id in getObject) {
//                NSLog(@"%@", [[NSString alloc] initWithData:_id
//                                                   encoding:NSUTF8StringEncoding]);
//                
//            }
//        }];
        
        // ID: 90EAC9E5-205A-4012-B17F-5291A6E654A5
        // REV: 1-e82a77833d2701cfdc2c7918c179ed69
        

///// Ändra något i lesson "Camera". Kopiera sedan in det hämtade rev-numret /////////////////
///// i strängen märkt 'andRev' här nedan och kör sedan update ////////////////////////////
        
        
//        [scheme updateLesson:jens
//                      withID:@"90EAC9E5-205A-4012-B17F-5291A6E654A5"
//                      andRev:@""
//               adminPassword:@"admin"];

     
    
        
        
        
        
        
        
        
        
        
        
///////// Hämta första alla data för student Jens /////////////////////////////////////////////////////////////

        
//        [scheme getStudent:jens onCompletion:^(NSArray *getStudent){
//            for(id _id in getStudent) {
//                NSLog(@"%@", [[NSString alloc] initWithData:_id
//                                                   encoding:NSUTF8StringEncoding]);
//
//            }
//        }];


///// Ändra något i student Jens. Kopiera sedan in det hämtade rev-numret /////////////////
///// i strängen märkt 'andRev' här nedan och kör sedan update ////////////////////////////


//        [scheme updateStudent:jens
//                       withID:@"7F010E1D-7A63-42E0-BB7C-F54A0AFEF2A8"
//                       andRev:@""
//                adminPassword:@"admin"];
        

        
///////// Hämta alla data för student Kristoffer //////////////////////////////////////////////////////////////
//
//        [scheme getStudent:kristoffer onCompletion:^(NSArray *getStudent){
//            for(id _id in getStudent) {
//                NSLog(@"%@", [[NSString alloc] initWithData:_id
//                                                   encoding:NSUTF8StringEncoding]);
//                
//            }
//        }];


///// Ändra något i student Jens. Kopiera sedan in det hämtade rev-numret /////////////////
///// i strängen märkt 'andRev' här nedan och kör sedan update ////////////////////////////
        

//
//        [scheme updateStudent:kristoffer
//                       withID:@"BD6D791E-C6B3-4897-8864-2F50B313BE00"
//                       andRev:@""
//                adminPassword:@"admin"];
        
    

///////// Hämta alla studenter ///////////////////////////////////////////////////////////////////////////////
//
//        [scheme getAllStudents:@"student" onCompletion:^(NSArray *getStudent){
//                    for(id _id in getStudent) {
//                        NSLog(@"%@", [[NSString alloc] initWithData:_id
//                                                           encoding:NSUTF8StringEncoding]);
//
//                    }
//                }];

        

        
    }
 
    return 0;
}

