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
                                       lessontime:@"9:15"
                                          teacher:@"Anders"
                                        classroom:@"4108"
                                       assignment:@"Read about NSArray"];

    
    appdevStudent = [[Student alloc] initWithLastName:@"Hagfeldt"
                                            firstName:@"Jens"
                                               course:@"appdev"];
    
    admin = [[Admin alloc] initWithUserName:@"Anders"
                                   password:@"coredev"];
}

- (void)tearDown
{
    lessons = nil;
    students = nil;
    appdevLesson = nil;
    appdevStudent = nil;
}


-(void)testCanAddStudent:(Student *)student adminPassword:(Admin *)adminPasswordü
{
    BOOL addedStudent = [students addStudent:appdevStudent];
    STAssertTrue(addStudent, @"A student should have been added.");
}


@end
