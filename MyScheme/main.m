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
        
        Student *appdevStudent3 = [[Student alloc] initWithLastName:@"Jansson"
                                                          firstName:@"Nisse"
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
        [scheme saveStudent:appdevStudent1];
//        [scheme getStudentWithID:@"0380635B-25FA-49FA-8DB5-3D7B3EDE255C" onCompletion:^(NSArray *getStudent){
//             for(id _id in getStudent) {
//                 NSLog(@"%@", [[NSString alloc] initWithData:_id
//                                                    encoding:NSUTF8StringEncoding]);
//                 
//             }
//         }];
        
        // Student 2 - attending appdevclass
        [scheme addStudent:appdevStudent2 adminPassword:admin];
        [scheme saveStudent:appdevStudent2];
//        [scheme getStudentWithID:@"7655822B-3E2F-41CB-8AB4-C8544148E65C" onCompletion:^(NSArray *getStudent){
//             for(id _id in getStudent) {
//                 NSLog(@"%@", [[NSString alloc] initWithData:_id
//                                                    encoding:NSUTF8StringEncoding]);
//                 
//             }
//         }];
        
        // Student 3 - attending appdevclass
        [scheme addStudent:appdevStudent3 adminPassword:admin];
        [scheme saveStudent:appdevStudent3];
//        [scheme getStudentWithID:@"2BD53231-2038-4E4E-B931-4BA5D0A7E39F" onCompletion:^(NSArray *getStudent){
//            for(id _id in getStudent) {
//                NSLog(@"%@", [[NSString alloc] initWithData:_id
//                                                   encoding:NSUTF8StringEncoding]);
//                
//            }
//        }];
        
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
    
    NSRunLoop *loop = [NSRunLoop currentRunLoop];
    [loop run];
    
    return 0;
}

