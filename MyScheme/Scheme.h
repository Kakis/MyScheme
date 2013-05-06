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


typedef void (^GetStudentResponce)(NSArray *getStudent);



@interface Scheme : NSObject


-(id)initWithLessons:(NSArray *)lessonsToAdd
            students:(NSArray *)studentsToAdd
                week:(int *)week;


-(BOOL)addLesson:(Lesson *)lesson
   adminPassword:(Admin *)admin;


-(BOOL)updateLesson:(Lesson *)lesson
       adminPassword:(Admin *)admin;


-(BOOL)addStudent:(Student *)student
    adminPassword:(Admin *)admin;


-(BOOL)sendMessage:(NSString *)msg toStudent:(Student *)id adminPassword:(Admin *)admin;


-(BOOL)sendAllStudentsMessage:(NSString *)msg adminPassword:(Admin *)admin;


#pragma mark - Helper methods handling connections to couch

//-(void) saveStudent:(Student *)student;

-(void)saveStudentToDb:(Student *)student;


-(void) getStudentWithID:(NSString*)_id
            onCompletion:(GetStudentResponce) getStudentResponce;


-(BOOL)updateStudent:(Student *)student withID:(NSString *)id andRevNumber:(NSString*)rev;


////////////// Ej färdigt försök att göra getStudent-anropet smidigare från main //////////////
//
//-(void) getStudent:(Student*)student
//            onCompletion:(GetStudentResponce) getStudentResponce;


@end
