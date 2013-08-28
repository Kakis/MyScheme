//
//  Scheme.m
//  MyScheme
//
//  Created by Jens Hagfeldt on 2013-04-29.
//  Copyright (c) 2013 Jens Hagfeldt. All rights reserved.
//

#import "Scheme.h"


// Keys for sorting lessons in a week
static NSString * const mondayKey = @"monday_key";
static NSString * const tuesdayKey = @"tuesday_key";
static NSString * const wednesdayKey = @"wednesday_key";
static NSString * const thursdayKey = @"thursday_key";
static NSString * const fridayKey = @"friday_key";

// Key for sorting all messages
static NSString * const allMessagesKey = @"allmessages_key";

// Keys for sorting students in two courses
static NSString * const objCKey = @"objC_key";
static NSString * const iOSKey = @"iOS_key";

// URL's for all databases
static NSString * const urlForLessons = @"http://kakis.iriscouch.com/schedule_lessons/_design/";
static NSString * const urlForMessages = @"http://kakis.iriscouch.com/schedule_messages/";
static NSString * const urlForStudents = @"http://kakis.iriscouch.com/schedule_students/";

// Views for sorting schedule
static NSString * const viewLesson = @"view_lesson/_view/get_lesson?key=";
static NSString * const viewIosScheduleForWeek = @"ios_week_schedule/_view/ios_schedule_for_week?key=";
static NSString * const viewObjectiveCScheduleForWeek = @"objective_c_week_schedule/_view/objective_c_schedule_for_week?key=";
static NSString * const viewTodaysIosSchedule = @"todays_ios_schedule/_view/ios_schedule_for_today?key=";
static NSString * const viewTodaysObjectiveCSchedule = @"todays_objective_c_schedule/_view/objective_c_schedule_for_today?key=";

// Views for sorting assignments
static NSString * const viewIOSAssignmentsForWeek = @"this_weeks_ios_assignments/_view/ios_assignments_for_this_week?key=";
static NSString * const viewObjectiveCAssignmentsForWeek = @"this_weeks_objective_c_assignments/_view/objective_c_assignments_for_this_week?key=";
static NSString * const viewTodaysIOSAssignments = @"todays_ios_assignments/_view/ios_assignments_for_today?key=";
static NSString * const viewTodaysObjectiveCAssignments = @"todays_objective_c_assignments/_view/objective_c_assignments_for_today?key=";
static NSString * const viewAllTodaysAssignments = @"http://kakis.iriscouch.com/schedule_lessons/_design/all_todays_assignments/_view/all_assignments_for_today";

// Views for sorting messages
static NSString * const viewPrivateMessages = @"_design/private_message/_view/messages_for?key=";
static NSString * const viewIosCourseMessages = @"_design/course_message/_view/ios_course_message";
static NSString * const viewObjectiveCCourseMessages = @"_design/course_message/_view/objective_c_course_message";

// Views for sorting students
static NSString * const viewStudent = @"http://kakis.iriscouch.com/schedule_students/_design/view_student/_view/get_student?key=";
static NSString * const viewAllStudents = @"http://kakis.iriscouch.com/schedule_students/_design/all_students/_view/in_all_courses";
static NSString * const viewAllIosStudents = @"http://kakis.iriscouch.com/schedule_students/_design/all_ios_students/_view/in_ios_course?key";
static NSString * const viewAllObjectiveCStudents = @"http://kakis.iriscouch.com/schedule_students/_design/all_objective_c_students/_view/in_objective_c_course?key";


@implementation Scheme
{
    NSDictionary *lessons;
    NSDictionary *students;
    NSDictionary *messages;
    NSOperationQueue *queue;
}


-(id)init
{
    return [self initWithLessons:@[] students:@[] week:0];
}


-(id)initWithLessons:(NSArray *)lessonsToAdd
            students:(NSArray *)studentsToAdd
                week:(int *)week
{
    self = [super init];
    
    if (self) {
        lessons = @{mondayKey:[[NSMutableSet alloc] init],
                    tuesdayKey:[[NSMutableSet alloc] init],
                    wednesdayKey:[[NSMutableSet alloc] init],
                    thursdayKey:[[NSMutableSet alloc] init],
                    fridayKey:[[NSMutableSet alloc] init]};
        
        students = @{objCKey:[[NSMutableSet alloc] init],
                    iOSKey:[[NSMutableSet alloc] init]};
        
        queue = [[NSOperationQueue alloc] init];
    }
    return self;
}


#pragma mark - Managing lessons and schedule

-(BOOL)addNewLesson:(Lesson *)lesson
      adminPassword:(NSString *)password
{
    if([password isEqualToString:@"admin"]){
        
        // Check course-key of lesson to be added
        if([lesson.course isEqualToString:@"Objective C"]){
            
            // Check weekday-key of ObjectiveC-lesson and add it accordingly
            if([lesson.day isEqualToString:@"monday"]){
                [lessons[objCKey] addObject:lesson];
            } else if ([lesson.day isEqualToString:@"tuesday"]){
                [lessons[objCKey] addObject:lesson];
            } else if ([lesson.day isEqualToString:@"wednesday"]){
                [lessons[objCKey] addObject:lesson];
            } else if ([lesson.day isEqualToString:@"thursday"]){
                [lessons[objCKey] addObject:lesson];
            } else { // lesson is at friday
                [lessons[objCKey] addObject:lesson];
            }
            
        } else {
            // Check weekday-key of iOS-lesson and add it accordingly
            if([lesson.day isEqualToString:@"monday"]){
                [lessons[iOSKey] addObject:lesson];
            } else if ([lesson.day isEqualToString:@"tuesday"]){
                [lessons[iOSKey] addObject:lesson];
            } else if ([lesson.day isEqualToString:@"wednesday"]){
                [lessons[iOSKey] addObject:lesson];
            } else if ([lesson.day isEqualToString:@"thursday"]){
                [lessons[iOSKey] addObject:lesson];
            } else { // lesson is at friday
                [lessons[iOSKey] addObject:lesson];
            }

        }
    }
    return YES;
}


-(BOOL)saveLessonToDb:(Lesson *)lesson
        adminPassword:(NSString *)password
{
    if([password isEqualToString:@"admin"])
    {
        if (!([lesson.subject isEqualToString:@""]
              ||
              [lesson.name isEqualToString:@""]
              ||
              [lesson.type isEqualToString:@""]
              ||
              [lesson.course isEqualToString:@""]
              ||
              [lesson.week isEqualToString:@""]
              ||
              [lesson.day isEqualToString:@""]
              ||
              [lesson.lessontime isEqualToString:@""]
              ||
              [lesson.teacher isEqualToString:@""]
              ||
              [lesson.classroom isEqualToString:@""]
              ||
              [lesson.assignment isEqualToString:@""]))
        {
            NSDictionary *lessonAsJson = [self serializeObjectToJson:lesson];
            
            NSData *lessonAsData = [NSJSONSerialization dataWithJSONObject:lessonAsJson
                                                                   options:NSJSONWritingPrettyPrinted
                                                                     error:NULL];
            
            NSURL *url = [NSURL URLWithString:@"http://kakis.iriscouch.com/schedule_lessons"];
            
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
            
            [request setHTTPMethod:@"POST"];
            [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            
            [request setHTTPBody:lessonAsData];
            
            NSURLConnection *connection = [NSURLConnection connectionWithRequest:request
                                                                        delegate:nil];
            [connection start];
            
            NSRunLoop *loop = [NSRunLoop currentRunLoop];
            [loop run];
            
            return YES;
        }
    }
    return NO;
}


-(void)getScheduleForCourse:(NSString *)course
                       Week:(NSString *)week
               onCompletion:(GetObjectResponce)getObjectResponce
{
    NSMutableString *strUrl = [[NSMutableString alloc]initWithString:urlForLessons];
    
    if ([course isEqualToString:@"iOS"])
    {
        [strUrl appendString:viewIosScheduleForWeek];
        [strUrl appendString:@"%22"];
        [strUrl appendString:week];
        [strUrl appendString:@"%22"];
    }
    else if ([course isEqualToString:@"Objective C"])
    {
        [strUrl appendString:viewObjectiveCScheduleForWeek];
        [strUrl appendString:@"%22"];
        [strUrl appendString:week];
        [strUrl appendString:@"%22"];
    }
    
    NSURL *url = [NSURL URLWithString:strUrl];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:queue
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               NSArray *foundSchedule = @[data];
                               getObjectResponce(foundSchedule);
                           }];
    
    NSRunLoop *loop = [NSRunLoop currentRunLoop];
    [loop run];
}


-(void)getScheduleForCourse:(NSString *)course
                       Week:(NSString *)week
                     andDay:(NSString *)day
               onCompletion:(GetObjectResponce)getObjectResponce
{
    NSMutableString *strUrl = [[NSMutableString alloc]initWithString:urlForLessons];
    
    if ([course isEqualToString:@"iOS"])
    {
        [strUrl appendString:viewTodaysIosSchedule];
        [strUrl appendString:@"%22"];
        [strUrl appendString:day];
        [strUrl appendString:@"%22"];
    }
    else if ([course isEqualToString:@"Objective C"])
    {
        [strUrl appendString:viewTodaysObjectiveCSchedule];
        [strUrl appendString:@"%22"];
        [strUrl appendString:day];
        [strUrl appendString:@"%22"];
    }
    
    NSURL *url = [NSURL URLWithString:strUrl];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:queue
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               NSArray *foundSchedule = @[data];
                               getObjectResponce(foundSchedule);
                           }];
    
    NSRunLoop *loop = [NSRunLoop currentRunLoop];
    [loop run];
}

-(void)getLesson:(NSString *)name
    onCompletion:(GetObjectResponce)getObjectResponce
{
    NSMutableString *strUrl = [[NSMutableString alloc]initWithString:urlForLessons];
    [strUrl appendString:viewLesson];
    [strUrl appendString:@"%22"];
    [strUrl appendString:name];
    [strUrl appendString:@"%22"];
    
    NSURL *url = [NSURL URLWithString:strUrl];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:queue
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               
                               NSArray *foundLesson = @[data];
                               
                               getObjectResponce(foundLesson);
                           }];
    
    NSRunLoop *loop = [NSRunLoop currentRunLoop];
    [loop run];
}

-(BOOL)updateLesson:(Lesson *)lesson
             withId:(NSString *)lessonId
             andRev:(NSString *)lessonRev
      adminPassword:(NSString *)password
{
    if([password isEqualToString:@"admin"]){

        NSDictionary *lessonAsJson = [self serializeObjectToJson:lesson];

        NSData *lessonAsData = [NSJSONSerialization dataWithJSONObject:lessonAsJson
                                                                options:NSJSONWritingPrettyPrinted
                                                                  error:NULL];

        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://kakis.iriscouch.com/schedule_lessons/%@?rev=%@",lessonId, lessonRev]];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];

        [request setHTTPMethod:@"PUT"];
        [request setHTTPBody:lessonAsData];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];

        NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:nil];
        [connection start];
        
        NSRunLoop *loop = [NSRunLoop currentRunLoop];
        [loop run];
        
        return YES;
    }
    return YES;
}


#pragma mark - Managing Assignments

-(void)getAssignmentsForCourse:(NSString *)course
                          Week:(NSString *)week
                  onCompletion:(GetObjectResponce)getObjectResponce
{
    NSMutableString *strUrl = [[NSMutableString alloc]initWithString:urlForLessons];
    
    if ([course isEqualToString:@"iOS"])
    {
        [strUrl appendString:viewIOSAssignmentsForWeek];
        [strUrl appendString:@"%22"];
        [strUrl appendString:week];
        [strUrl appendString:@"%22"];
    }
    else if ([course isEqualToString:@"Objective C"])
    {
        [strUrl appendString:viewObjectiveCAssignmentsForWeek];
        [strUrl appendString:@"%22"];
        [strUrl appendString:week];
        [strUrl appendString:@"%22"];
    }
    
    NSURL *url = [NSURL URLWithString:strUrl];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:queue
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               NSArray *foundAssignments = @[data];
                               getObjectResponce(foundAssignments);
                           }];
    
    NSRunLoop *loop = [NSRunLoop currentRunLoop];
    [loop run];
}


-(void)getAssignmentsForCourse:(NSString *)course
                          Week:(NSString *)week
                        andDay:(NSString *)day
                  onCompletion:(GetObjectResponce)getObjectResponce
{
    NSMutableString *strUrl = [[NSMutableString alloc]initWithString:urlForLessons];
    
    if ([course isEqualToString:@"iOS"])
    {
        [strUrl appendString:viewTodaysIOSAssignments];
        [strUrl appendString:@"%22"];
        [strUrl appendString:day];
        [strUrl appendString:@"%22"];
    }
    else if ([course isEqualToString:@"Objective C"])
    {
        [strUrl appendString:viewTodaysObjectiveCAssignments];
        [strUrl appendString:@"%22"];
        [strUrl appendString:day];
        [strUrl appendString:@"%22"];
    }

    NSURL *url = [NSURL URLWithString:strUrl];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:queue
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               NSArray *foundAssignments = @[data];
                               getObjectResponce(foundAssignments);
                           }];
    
    NSRunLoop *loop = [NSRunLoop currentRunLoop];
    [loop run];
}


#pragma mark - Managing messages

-(BOOL)addNewMessage:(Message *)message
       adminPassword:(NSString *)adminpassword;
{
    if ([adminpassword isEqualToString:@"admin"]) {
        if (messages[message.id]) {
            return NO;
        } else {
            [messages[allMessagesKey] addObject:message];
            return YES;
        }
    }
    return YES;
}

-(BOOL)saveMessage:(Message *)message
     adminPassword:(NSString *)adminpassword
{
    if ([adminpassword isEqualToString:@"admin"])
    {
        if (!([message.title isEqualToString:@""]
              ||
              [message.subject isEqualToString:@""]
              ||
              [message.sender isEqualToString:@""]
              ||
              [message.receiver isEqualToString:@""]
              ||
              [message.type isEqualToString:@""]
              ||
              [message.message isEqualToString:@""]))
        {
            
            NSDictionary *messageAsJson = [self serializeObjectToJson:message];
            NSData *messageAsData = [NSJSONSerialization dataWithJSONObject:messageAsJson
                                                                    options:NSJSONWritingPrettyPrinted
                                                                      error:NULL];
            
            NSURL *url = [NSURL URLWithString:@"http://kakis.iriscouch.com/schedule_messages"];
            
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[url standardizedURL]];
            
            [request setHTTPMethod:@"POST"];
            [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            [request setHTTPBody:messageAsData];
            
            NSURLConnection *connection = [NSURLConnection connectionWithRequest:request
                                                                        delegate:nil];
            [connection start];
            
            NSRunLoop *loop = [NSRunLoop currentRunLoop];
            [loop run];
            
            return YES;
        }
    }
    return NO;
}

-(BOOL)getPrivateMessagesFor:(Student *)student
               onCompletion:(GetObjectResponce)getObjectResponce
{
    NSString *name = student.firstName;
    
    NSMutableString *strUrl = [[NSMutableString alloc]initWithString:urlForMessages];
    
    [strUrl appendString:viewPrivateMessages];
    [strUrl appendString:@"%22"];
    [strUrl appendString:name];
    [strUrl appendString:@"%22"];
    
    NSURL *url = [NSURL URLWithString:strUrl];

    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];

    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];

    [NSURLConnection sendAsynchronousRequest:request
                                       queue:queue
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {

                               NSArray *foundMessages = @[data];

                               getObjectResponce(foundMessages);
                           }];
    
    NSRunLoop *loop = [NSRunLoop currentRunLoop];
    [loop run];
    
    return YES;
}

-(BOOL)getMessagesForCourse:(NSString *)course
               onCompletion:(GetObjectResponce)getObjectResponce
{
    NSMutableString *strUrl = [[NSMutableString alloc]initWithString:urlForMessages];
    
    if ([course isEqualToString:@"iOS"]) {
        [strUrl appendString:viewIosCourseMessages];
    } else {
        [strUrl appendString:viewObjectiveCCourseMessages];
    }
    
    NSURL *url = [NSURL URLWithString:strUrl];

    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];

    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];

    [NSURLConnection sendAsynchronousRequest:request
                                       queue:queue
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {

                               NSArray *foundMessages = @[data];

                               getObjectResponce(foundMessages);
                           }];
    
    NSRunLoop *loop = [NSRunLoop currentRunLoop];
    [loop run];
    return YES;
}


#pragma mark - Managing students

-(BOOL)addNewStudent:(Student *)student
       adminPassword:(NSString *)adminpassword;
{
    if([adminpassword isEqualToString:@"admin"]){
        if([student.course isEqualToString:@"Objective C"])
        {
            [students[objCKey] addObject:student];
        } else {
            [students[iOSKey] addObject:student];
        }
        return YES;
    }
    return YES;
}

-(BOOL)saveStudentToDb:(Student *)student
         adminPassword:(NSString *)adminpassword
{
    if ([adminpassword isEqualToString:@"admin"])
    {
        if (!([student.firstName isEqualToString:@""]
              ||
              [student.lastName isEqualToString:@""]
              ||
              [student.type isEqualToString:@""]
              ||
              [student.course isEqualToString:@""]))
        {
            NSDictionary *studentAsJson = [self serializeObjectToJson:student];
            
            NSData *studentAsData = [NSJSONSerialization dataWithJSONObject:studentAsJson
                                                                    options:NSJSONWritingPrettyPrinted
                                                                      error:NULL];
            
            NSURL *url = [NSURL URLWithString:urlForStudents];
            
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
            
            [request setHTTPMethod:@"POST"];
            
            [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            
            [request setHTTPBody:studentAsData];
            
            NSURLConnection *connection = [NSURLConnection connectionWithRequest:request
                                                                        delegate:nil];
            [connection start];
            
            NSRunLoop *loop = [NSRunLoop currentRunLoop];
            [loop run];
            
            return YES;
        }
    }
    return NO;
}

-(void)getStudent:(Student *)studentName
     onCompletion:(GetObjectResponce)getObjectResponce
{
    NSMutableString *strUrl = [[NSMutableString alloc]initWithString:viewStudent];
    [strUrl appendString:@"%22"];
    [strUrl appendString:studentName.firstName ];
    [strUrl appendString:@"%22"];
    
    NSURL *url = [NSURL URLWithString:strUrl];

    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];

    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];

    [NSURLConnection sendAsynchronousRequest:request
                                       queue:queue
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {

                               NSArray *foundStudent = @[data];

                               getObjectResponce(foundStudent);
                           }];
    
    NSRunLoop *loop = [NSRunLoop currentRunLoop];
    [loop run];
}

-(BOOL)updateStudent:(Student *)student
              withId:(NSString *)studentId
              andRev:(NSString *)studentRev
       adminPassword:(NSString *)password
{
    if([password isEqualToString:@"admin"])
    {
        NSDictionary *studentAsJson = [self serializeObjectToJson:student];
        
        NSData *studentAsData = [NSJSONSerialization dataWithJSONObject:studentAsJson
                                                            options:NSJSONWritingPrettyPrinted
                                                              error:NULL];
        
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://kakis.iriscouch.com/schedule_students/%@?rev=%@",studentId, studentRev]];
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        
        [request setHTTPMethod:@"PUT"];
        [request setHTTPBody:studentAsData];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        
        NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:nil];
        [connection start];
        
        NSRunLoop *loop = [NSRunLoop currentRunLoop];
        [loop run];
        
        return YES;
    }
    return YES;
}


-(NSSet*)allStudents
{
    return [students[objCKey]setByAddingObjectsFromSet:students[iOSKey]];
}


#pragma mark - Serializing objects to json

-(id)serializeObjectToJson:(id) object
{
    NSObject *result = [[NSObject alloc] init];
    result = [object jsonValue];
    return result;
}


@end
