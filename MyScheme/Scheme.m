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
static NSString * const urlForMessages = @"http://kakis.iriscouch.com/schedule_mesages/";
static NSString * const urlForStudents = @"http://kakis.iriscouch.com/schedule_students/";

// Views for sorting schedule
static NSString * const viewScheduleForWeek = @"http://kakis.iriscouch.com/schedule_lessons/_design/week_schedule/_view/schedule_for_week?key=";
static NSString * const viewTodaysSchedule = @"http://kakis.iriscouch.com/schedule_lessons/_design/todays_schedule/_view/schedule_for_today?key=";

// Views for sorting assignments
static NSString * const viewIOSAssignmentsForWeek = @"this_weeks_ios_assignments/_view/ios_assignments_for_this_week?key=";
static NSString * const viewObjectiveCAssignmentsForWeek = @"this_weeks_objective_c_assignments/_view/objective_c_assignments_for_this_week?key=";
static NSString * const viewTodaysIOSAssignments = @"todays_ios_assignments/_view/ios_assignments_for_today?key=";
static NSString * const viewTodaysObjectiveCAssignments = @"todays_objective_c_assignments/_view/objective_c_assignments_for_today?key=";
static NSString * const viewAllTodaysAssignments = @"http://kakis.iriscouch.com/schedule_lessons/_design/all_todays_assignments/_view/all_assignments_for_today";

// Views for sorting messages
static NSString * const viewPrivateMessages = @"http://kakis.iriscouch.com/schedule_messages/_design/private_message/_view/messages_for?key=";
static NSString * const viewIosCourseMessages = @"_view/ios_course_message";
static NSString * const viewObjectiveCCourseMessages = @"_view/objective_c_course_message";

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


#pragma mark - Managing lessons

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


-(void)saveLessonToDb:(Lesson *)lesson
{
    // Kör serialisering av vår lektion till JSON-format
    NSDictionary *lessonAsJson = [self serializeObjectToJson:lesson];
    
    // Skapar ett NSData-objekt som håller i vår lektion, JSON-formaterad
    NSData *lessonAsData = [NSJSONSerialization dataWithJSONObject:lessonAsJson
                                                           options:NSJSONWritingPrettyPrinted
                                                             error:NULL];
    
    // Sätter adressen till min databas som url
    NSURL *url = [NSURL URLWithString:@"http://kakis.iriscouch.com/schedule_lessons"];
    
    // Skapar en request till min url
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    // Sätter HTTP metoden till POST
    [request setHTTPMethod:@"POST"];
    
    // Ställer i HTTP headern in att jag kommer att skicka värden av typen application/json
    [request setValue:@"application/json"
   forHTTPHeaderField:@"Content-Type"];
    
    // Lägger min lektion i HTTP bodyn
    [request setHTTPBody:lessonAsData];
    
    // Skapar min NSURLConnection och kör igång den
    NSURLConnection *connection = [NSURLConnection connectionWithRequest:request
                                                                delegate:nil];
    [connection start];
    
    NSRunLoop *loop = [NSRunLoop currentRunLoop];
    [loop run];
}


-(void)getScheduleForWeek:(NSString *)week
            onCompletion:(GetObjectResponce)getObjectResponce
{
    NSMutableString *strUrl = [[NSMutableString alloc]initWithString:viewScheduleForWeek];
    [strUrl appendString:@"%22"];
    [strUrl appendString:week];
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


-(void)getScheduleForWeek:(NSString *)week
                   andDay:(NSString *)day
             onCompletion:(GetObjectResponce)getObjectResponce
{
    NSMutableString *strUrl = [[NSMutableString alloc]initWithString:viewTodaysSchedule];
    [strUrl appendString:@"%22"];
    [strUrl appendString:week];
    [strUrl appendString:@"%22"];
    
    NSURL *url = [NSURL URLWithString:strUrl];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:queue
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               
                               NSArray *foundLessons = @[data];

//                               for (int i = 0; i < [foundLessons count]; i++) {
//                                   if ([[[foundLessons objectAtIndex:i] valueForKey:@"%5B%22day%22%5D"] isEqualToString:day]) {
//                                       NSArray *listItems = [[foundLessons objectAtIndex: i] valueForKeyPath:@"%5B%22day%22%5D"];
//                                       getObjectResponce(listItems);
//                                   }
//                               }
                               getObjectResponce(foundLessons);
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
        // Kör serialisering av vår student till JSON-format
        NSDictionary *lessonAsJson = [self serializeObjectToJson:lesson];
        
        // Skapar ett NSData-objekt som håller i vår student, JSON-formaterad
        NSData *lessonAsData = [NSJSONSerialization dataWithJSONObject:lessonAsJson
                                                                options:NSJSONWritingPrettyPrinted
                                                                  error:NULL];
        
        // Vi skapar en URL-pekare och tilldelar den en sträng med url'en till min databas schedule på iriscouch,
        // matchat mot den student som vi vill uppdatera genom att ange id- och rev-nummer
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://kakis.iriscouch.com/schedule_lessons/%@?rev=%@",lessonId, lessonRev]];
        
        // Vi initierar en request med den url vi angivit
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        
        // Vi sätter HTTP metoden till PUT
        [request setHTTPMethod:@"PUT"];
        
        // Lägger min student i HTTP bodyn
        [request setHTTPBody:lessonAsData];
        
        // Ställer i HTTP headern in att jag kommer att skicka värden av typen application/json
        // [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        
        // Skapar min NSURLConnection och kör igång den
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

-(BOOL)addNewMessage:(Message *)message;
{
    if (messages[message.id]) {
        return NO;
    } else{
        [messages[allMessagesKey] addObject:message];
        return YES;
        
    }
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

-(BOOL)getMessageWithId:(NSString *)dataId
           onCompletion:(GetObjectResponce)getObjectResponce
{
    return YES;
}

-(BOOL)getPrivateMessagesFor:(Student *)student
               onCompletion:(GetObjectResponce)getObjectResponce
{
    // Vi skapar en URL-pekare och tilldelar den en sträng med url'en till min databas schedule på iriscouch,
    // matchat mot enlektionss namn
    
    NSString *name = student.firstName;
    
    NSMutableString *strUrl = [[NSMutableString alloc]initWithString:viewPrivateMessages];
    [strUrl appendString:@"%22"];
    [strUrl appendString:name];
    [strUrl appendString:@"%22"];
    
    NSURL *url = [NSURL URLWithString:strUrl];
    
    // Vi skapar en NSMutableURLRequest, allokerar minnet och initerar den med url'en vi nyss skapade
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    // Vi säger att vi vill få tillbaka json-värden med vår HTTP-förfrågan
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    // Vi vill lägga en asynhron NSURLconection på kön och köra vårt block (^GetStudentResponce) som vi definierat i h-filen
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:queue
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               
                               // Vi serialiserar de data vi får tillbaka från json till ett student-objekt
                               // och sätter pekaren foundStudent att peka mot detta.
                               NSArray *foundMessages = @[data];
                               
                               // Vi kör det block vi skickade som argument.
                               // Och skickar det vi får tillbaka (callback).
                               getObjectResponce(foundMessages);
                           }];
    
    NSRunLoop *loop = [NSRunLoop currentRunLoop];
    [loop run];
    
    return YES;
}

-(BOOL)getMessagesForCourse:(NSString *)course
               onCompletion:(GetObjectResponce)getObjectResponce
{
    NSMutableString *strUrl = [[NSMutableString alloc]initWithString:@"http://kakis.iriscouch.com/schedule_messages/_design/course_message/"];
    
    if ([course isEqualToString:@"iOS"]) {
        [strUrl appendString:viewIosCourseMessages];
    } else {
        [strUrl appendString:viewObjectiveCCourseMessages];
    }
    
    NSURL *url = [NSURL URLWithString:strUrl];
    
    // Vi skapar en NSMutableURLRequest, allokerar minnet och initerar den med url'en vi nyss skapade
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    // Vi säger att vi vill få tillbaka json-värden med vår HTTP-förfrågan
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    // Vi vill lägga en asynhron NSURLconection på kön och köra vårt block (^GetStudentResponce) som vi definierat i h-filen
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:queue
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               
                               // Vi serialiserar de data vi får tillbaka från json till ett student-objekt
                               // och sätter pekaren foundStudent att peka mot detta.
                               NSArray *foundMessages = @[data];
                               
                               // Vi kör det block vi skickade som argument.
                               // Och skickar det vi får tillbaka (callback).
                               getObjectResponce(foundMessages);
                           }];
    
    NSRunLoop *loop = [NSRunLoop currentRunLoop];
    [loop run];
    return YES;
}


-(BOOL)updateMessage:(Message *)message
              withId:(NSString *)messageId
              andRev:(NSString *)revNumber
       adminPassword:(NSString *)adminpassword
{
    return YES;
}


#pragma mark - Managing students

-(BOOL)addNewStudent:(Student *)student
       adminPassword:(NSString *)password;
{
    if([password isEqualToString:@"admin"]){
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

-(void)saveStudentToDb:(Student *)student
{
    // Kör serialisering av vår student till JSON-format
    NSDictionary *studentAsJson = [self serializeObjectToJson:student];
    
    // Skapar ett NSData-objekt som håller i vår student, JSON-formaterad
    NSData *studentAsData = [NSJSONSerialization dataWithJSONObject:studentAsJson
                                                            options:NSJSONWritingPrettyPrinted
                                                              error:NULL];
    
    // Sätter adressen till min databas som url
    NSURL *url = [NSURL URLWithString:@"http://kakis.iriscouch.com/schedule_students"];
    
    // Skapar en request till min url
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    // Sätter HTTP metoden till POST
    [request setHTTPMethod:@"POST"];
    
    // Ställer i HTTP headern in att jag kommer att skicka värden av typen application/json
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    // Lägger min student i HTTP bodyn
    [request setHTTPBody:studentAsData];
    
    // Skapar min NSURLConnection och kör igång den
    NSURLConnection *connection = [NSURLConnection connectionWithRequest:request
                                                                delegate:nil];
    [connection start];
    
    NSRunLoop *loop = [NSRunLoop currentRunLoop];
    [loop run];
}


-(void)getStudent:(Student *)studentName
     onCompletion:(GetStudentResponce)getStudentResponce
{
    // Vi skapar en URL-pekare och tilldelar den en sträng med url'en till min databas schedule på iriscouch,
    // matchat mot en students namn
    NSMutableString *strUrl = [[NSMutableString alloc]initWithString:viewStudent];
    [strUrl appendString:@"%22"];
    [strUrl appendString:studentName.firstName ];
    [strUrl appendString:@"%22"];
    
    NSURL *url = [NSURL URLWithString:strUrl];
    
    // Vi skapar en NSMutableURLRequest, allokerar minnet och initerar den med url'en vi nyss skapade
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    // Vi säger att vi vill få tillbaka json-värden med vår HTTP-förfrågan
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    // Vi vill lägga en asynhron NSURLconection på kön och köra vårt block (^GetStudentResponce) som vi definierat i h-filen
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:queue
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               
                               // Vi serialiserar de data vi får tillbaka från json till ett student-objekt
                               // och sätter pekaren foundStudent att peka mot detta.
                               NSArray *foundStudent = @[data];
                               
                               // Vi kör det block vi skickade som argument.
                               // Och skickar det vi får tillbaka (callback).
                               getStudentResponce(foundStudent);
                           }];
    
    NSRunLoop *loop = [NSRunLoop currentRunLoop];
    [loop run];
}


-(void)getAllStudents:(NSString *)typeStudent
         onCompletion:(GetStudentResponce)getStudentResponce
{
    // Vi skapar en URL-pekare och tilldelar den en sträng med url'en till min databas schedule på iriscouch,
    // matchat mot en students namn
    NSMutableString *strUrl = [[NSMutableString alloc]initWithString:viewAllStudents];
    
    NSURL *url = [NSURL URLWithString:strUrl];
    
    // Vi skapar en NSMutableURLRequest, allokerar minnet och initerar den med url'en vi nyss skapade
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    // Vi säger att vi vill få tillbaka json-värden med vår HTTP-förfrågan
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    // Vi vill lägga en asynhron NSURLconection på kön och köra vårt block (^GetStudentResponce) som vi definierat i h-filen
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:queue
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               
                               // Vi serialiserar de data vi får tillbaka från json till ett student-objekt
                               // och sätter pekaren foundStudent att peka mot detta.
                               NSArray *foundStudent = @[data];
                               
                               // Vi kör det block vi skickade som argument.
                               // Och skickar det vi får tillbaka (callback).
                               getStudentResponce(foundStudent);
                           }];
    
    NSRunLoop *loop = [NSRunLoop currentRunLoop];
    [loop run];
}


-(BOOL)updateStudent:(Student *)student
              withId:(NSString *)studentId
              andRev:(NSString *)studentRev
       adminPassword:(NSString *)password
{
    if([password isEqualToString:@"admin"]){
    // Kör serialisering av vår student till JSON-format
    NSDictionary *studentAsJson = [self serializeObjectToJson:student];
    
    // Skapar ett NSData-objekt som håller i vår student, JSON-formaterad
    NSData *studentAsData = [NSJSONSerialization dataWithJSONObject:studentAsJson
                                                            options:NSJSONWritingPrettyPrinted
                                                              error:NULL];
    
    // Vi skapar en URL-pekare och tilldelar den en sträng med url'en till min databas schedule på iriscouch,
    // matchat mot den student som vi vill uppdatera genom att ange id- och rev-nummer
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://kakis.iriscouch.com/schedule_students/%@?rev=%@",studentId, studentRev]];
    
    // Vi initierar en request med den url vi angivit
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    // Vi sätter HTTP metoden till PUT
    [request setHTTPMethod:@"PUT"];
    
    // Lägger min student i HTTP bodyn
    [request setHTTPBody:studentAsData];
    
    // Ställer i HTTP headern in att jag kommer att skicka värden av typen application/json
    // [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    // Skapar min NSURLConnection och kör igång den
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
    //Returns a set with students from all courses
    return [students[objCKey]setByAddingObjectsFromSet:students[iOSKey]];
}


#pragma mark - Serializing objects to json

-(id)serializeObjectToJson:(id) object
{
    // Serialiserar ett objekt till JSON-format
    NSObject *result = [[NSObject alloc] init];
    result = [object jsonValue];
    return result;
}


@end
