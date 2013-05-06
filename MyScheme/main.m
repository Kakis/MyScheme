//
//  main.m
//  MyScheme
//
//  Created by Jens Hagfeldt on 2013-04-29.
//  Copyright (c) 2013 Jens Hagfeldt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Scheme.h"
#import "Admin.h"
#import "Student.h"

int main(int argc, const char * argv[])
{

    @autoreleasepool {

/////////////////////////////////////// Initializing objects in Schedule /////////////////////////////////////

        
        Admin *admin = [[Admin alloc] initWithUserName:@"Anders"
                                              password:@"admin"];
        
        Student *appdevStudent1 = [[Student alloc] initWithLastName:@"Hagfeldt"
                                                    firstName:@"Jens"
                                                       course:@"appdev"];
        
        Student *appdevStudent2 = [[Student alloc] initWithLastName:@"Nygård"
                                                          firstName:@"Stefan"
                                                             course:@"appdev"];
        
        Lesson *appdevLesson1 = [[Lesson alloc] initWithCourse:@"appdev"
                                                       weekday:@"monday"
                                                    lessontime:@"09:00"
                                                       teacher:@"Anders"
                                                     classroom:@"4108"
                                                    assignment:@"Read chapter 19: Object Instance Variables"];

        Lesson *appdevLesson2 = [[Lesson alloc] initWithCourse:@"appdev"
                                                       weekday:@"tuesday"
                                                    lessontime:@"09:00"
                                                       teacher:@"Anders"
                                                     classroom:@"4108"
                                                    assignment:@"Read chapter 21: Collection Classes"];
        
        Scheme *scheme = [[Scheme alloc] init];

///////////////////////////////////////////////////////////////////////////////////////////////////////////////


        
///////////////////////////////////////// Managing students in Schedule ///////////////////////////////////////

        
        // Student 1 - attending appdevclass
        [scheme addStudent:appdevStudent1 adminPassword:admin];
        [scheme saveStudentToDb:appdevStudent1];
        [scheme getStudentWithID:@"0F8BE278-927F-4904-A3D2-AD48027F59B1" onCompletion:^(NSArray *getStudent){
             for(id _id in getStudent) {
                 NSLog(@"%@", [[NSString alloc] initWithData:_id
                                                    encoding:NSUTF8StringEncoding]);
                 
             }
         }];
        
        // Student 2 - attending appdevclass
        [scheme addStudent:appdevStudent2 adminPassword:admin];
//        [scheme saveStudentToDb:appdevStudent2];
//        [scheme saveStudent:appdevStudent2];
        
        [scheme getStudentWithID:@"AB616859-63E6-4C38-BA2C-A17703189867" onCompletion:^(NSArray *getStudent){
             for(id _id in getStudent) {
                 NSLog(@"%@", [[NSString alloc] initWithData:_id
                                                    encoding:NSUTF8StringEncoding]);
                 
             }
         }];
        
        
///////////////////////////////////////////////////////////////////////////////////////////////////////////////

        
///////////////////////////////////////// Managing lessons in Schedule ////////////////////////////////////////
        
        [scheme addLesson:appdevLesson1 adminPassword:admin];
        [scheme addLesson:appdevLesson2 adminPassword:admin];
        
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
        
        
///////////////////////////////////////// Loggs for objects in Schedule ///////////////////////////////////////
//
//        NSLog(@"%@", appdevLesson1);
//        puts ("");        
//        NSLog(@"%@", appdevStudent1);
//        puts ("");
//        NSLog(@"%@", appdevStudent2);
//    
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
        
    }
    
    
    [[NSRunLoop currentRunLoop] run];
 
    return 0;
}

