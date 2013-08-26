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
-(BOOL)addNewLesson:(Lesson *)lesson;

-(void)saveLessonToDb:(Lesson *)lesson;

-(void)getScheduleForWeek:(NSString *)week
             onCompletion:(GetObjectResponce)getObjectResponce;

-(void)getScheduleForWeek:(NSString *)week
                   andDay:(NSString *)day
             onCompletion:(GetObjectResponce)getObjectResponce;

-(BOOL)updateLesson:(Lesson *)lesson
             withId:(NSString *)lessonId
             andRev:(NSString *)lessonRev
      adminPassword:(NSString *)password;

#pragma mark - Managing assignments
-(void)getAssignmentsForCourse:(NSString *)course
                          Week:(NSString *)week
                  onCompletion:(GetObjectResponce)getObjectResponce;

-(void)getAssignmentsForCourse:(NSString *)course
                          Week:(NSString *)week
                        andDay:(NSString *)day
                  onCompletion:(GetObjectResponce)getObjectResponce;

#pragma mark - Managing messages
-(BOOL)addNewMessage:(Message *)message
       adminPassword:(NSString *)adminpassword;

-(BOOL)saveMessage:(Message*)message
     adminPassword:(NSString *)adminpassword;

-(BOOL)getMessageWithId:(NSString *)dataId
           onCompletion:(GetObjectResponce)getObjectResponce;

-(BOOL)getPrivateMessagesFor:(Student *)student
                onCompletion:(GetObjectResponce)getObjectResponce;

-(BOOL)getMessagesForCourse:(NSString *)course
               onCompletion:(GetObjectResponce)getObjectResponce;

-(BOOL)updateMessage:(Message*)message
              withId:(NSString *)messageId
              andRev:(NSString *)revNumber
       adminPassword:(NSString *)adminpassword;

#pragma mark - Managing students
-(BOOL)addNewStudent:(Student *)student
       adminPassword:(NSString *)password;

-(void)saveStudentToDb:(Student *)student;

-(void)getStudent:(Student *)studentName
     onCompletion:(GetStudentResponce)getStudentResponce;

-(void)getAllStudents:(NSString *)typeStudent
         onCompletion:(GetStudentResponce)getStudentResponce;

-(BOOL)updateStudent:(Student *)student
              withId:(NSString *)studentId
              andRev:(NSString *)studentRev
       adminPassword:(NSString *)password;



@end
