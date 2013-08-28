//
//  Scheme.h
//  MyScheme
//
//  Created by Jens Hagfeldt on 2013-04-29.
//  Copyright (c) 2013 Jens Hagfeldt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Admin.h"
#import "Student.h"
#import "Student+Json.h"
#import "Lesson.h"
#import "Lesson+Json.h"
#import "Message.h"
#import "Message+Json.h"

typedef void (^GetStudentResponce)(NSArray *getStudent);
typedef void (^GetObjectResponce)(NSArray *getObject);

@interface Scheme : NSObject

-(id)initWithLessons:(NSArray *)lessonsToAdd
            students:(NSArray *)studentsToAdd
                week:(int *)week;

#pragma mark - Managing lessons
-(BOOL)addNewLesson:(Lesson *)lesson
      adminPassword:(NSString *)password;

-(BOOL)saveLessonToDb:(Lesson *)lesson
        adminPassword:(NSString *)password;

-(BOOL)getLesson:(NSString *)name
    onCompletion:(GetObjectResponce)getObjectResponce;

-(BOOL)updateLesson:(Lesson *)lesson
             withId:(NSString *)lessonId
             andRev:(NSString *)lessonRev
      adminPassword:(NSString *)password;

#pragma mark - Managing schedule
-(BOOL)getScheduleForCourse:(NSString *)course
                       Week:(NSString *)week
               onCompletion:(GetObjectResponce)getObjectResponce;

-(BOOL)getScheduleForCourse:(NSString *)course
                       Week:(NSString *)week
                     andDay:(NSString *)day
               onCompletion:(GetObjectResponce)getObjectResponce;

#pragma mark - Managing assignments
-(BOOL)getAssignmentsForCourse:(NSString *)course
                          Week:(NSString *)week
                  onCompletion:(GetObjectResponce)getObjectResponce;

-(BOOL)getAssignmentsForCourse:(NSString *)course
                          Week:(NSString *)week
                        andDay:(NSString *)day
                  onCompletion:(GetObjectResponce)getObjectResponce;

#pragma mark - Managing messages
-(BOOL)addNewMessage:(Message *)message
       adminPassword:(NSString *)adminpassword;

-(BOOL)saveMessage:(Message *)message
     adminPassword:(NSString *)adminpassword;

-(BOOL)getPrivateMessagesFor:(Student *)student
                onCompletion:(GetObjectResponce)getObjectResponce;

-(BOOL)getMessagesForCourse:(NSString *)course
               onCompletion:(GetObjectResponce)getObjectResponce;

#pragma mark - Managing students
-(BOOL)addNewStudent:(Student *)student
       adminPassword:(NSString *)adminpassword;

-(BOOL)saveStudentToDb:(Student *)student
         adminPassword:(NSString *)adminpassword;

-(BOOL)getStudent:(Student *)studentName
     onCompletion:(GetObjectResponce)getObjectResponce;

//-(BOOL)updateStudent:(Student *)student
//              withId:(NSString *)studentId
//              andRev:(NSString *)studentRev
//       adminPassword:(NSString *)password;



@end
