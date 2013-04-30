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
        
        Admin *admin = [[Admin alloc] initWithUserName:@"Anders"
                                              password:@"cordev"];
        
        Student *appdevStudent1 = [[Student alloc] initWithLastName:@"Hagfeldt"
                                                    firstName:@"Jens"
                                                       course:@"appdev"];
        
        Lesson *appdevLesson1 = [[Lesson alloc] initWithCourse:@"appdev"
                                                       weekday:@"monday"
                                                    lessontime:@"09:00"
                                                       teacher:@"Anders"
                                                     classroom:@"4108"
                                                    assignment:@"Read about NSArray"];
        
        Scheme *scheme = [[Scheme alloc] init];
        
        [scheme addStudent:appdevStudent1 adminPassword:admin];
        [scheme saveStudent:appdevStudent1];
        
        [scheme addLesson:appdevLesson1 adminPassword:admin];
        
        NSLog(@"%@", appdevLesson1);
        
    }
    
    NSRunLoop *loop = [NSRunLoop currentRunLoop];
    [loop run];
    
    return 0;
}

