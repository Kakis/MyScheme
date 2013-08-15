//
//  SchemeTests.m
//  SchemeTests
//
//  Created by Jens Hagfeldt on 2013-04-30.
//  Copyright (c) 2013 Jens Hagfeldt. All rights reserved.
//

#import "SchemeTests.h"
#import "Scheme.h"
#import "Admin.h"
#import "Lesson.h"
#import "Student.h"


// Keys for sorting lessons in a week
static NSString * const mondayKey = @"monday_key";
static NSString * const tuesdayKey = @"tuesday_key";
static NSString * const wednesdayKey = @"wednesday_key";
static NSString * const thursdayKey = @"thursday_key";
static NSString * const fridayKey = @"friday_key";

// Keys for sorting students in two courses
static NSString * const appdevKey = @"appdev_Key";
static NSString * const javaKey = @"java_key";


@implementation SchemeTests
{
    NSDictionary *lessons;
    NSDictionary *students;
    Scheme *scheme;
    Lesson *appdevLesson;
    Student *appdevStudent;
    Admin *admin;
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
    
    appdevLesson = [[Lesson alloc] initWithCourse:@"appdev"
                                             type:@"lesson"
                                             week:@"1"
                                              day:@"monday"
                                       lessontime:@"09:00"
                                          teacher:@"Anders"
                                        classroom:@"4108"
                                       assignment:@"Read chapter 19: Object Instance Variables"];

    
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
}


//-(void)testAddNewStudent:(Student *)student adminPassword:(Admin *)admin
//{
//    BOOL addedStudent = [scheme addNewStudent:appdevStudent adminPassword:admin];
//    STAssertTrue(addedStudent, @"A student should have been added.");
//}


@end
