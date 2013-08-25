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

// Views for this weeks schedule
static NSString * const viewScheduleForWeek = @"http://kakis.iriscouch.com/schedule_lessons/_design/week_schedule/_view/schedule_for_week?key=";

// View for schedule this day
static NSString * const viewTodaysSchedule = @"http://kakis.iriscouch.com/schedule_lessons/_design/todays_schedule/_view/schedule_for_today?key=";

// Views for this weeks assignments
static NSString * const viewAssignmentsForWeek = @"http://kakis.iriscouch.com/schedule_lessons/_design/week_assignments/_view/assignments_for_week?key=";

// Views for assignments this day
static NSString * const viewTodaysAssignments = @"http://kakis.iriscouch.com/schedule_lessons/_design/todays_assignments/_view/assignments_for_today";

// Views for sorting students
static NSString * const viewStudent = @"http://kakis.iriscouch.com/schedule_students/_design/view_student/_view/get_student?key=";

typedef enum
{
    mondayLessons, tuesdayLessons, wednesdayLessons, thursdaylessons, fridayLessons
    
} viewLessonForDay;


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

-(void)getAssignmentsForWeek:(NSString *)week
             onCompletion:(GetObjectResponce)getObjectResponce
{
    // Vi skapar en URL-pekare och tilldelar den en sträng med url'en till min databas schedule på iriscouch,
    // matchat mot enlektionss namn
    NSMutableString *strUrl = [[NSMutableString alloc]initWithString:viewAssignmentsForWeek];
    [strUrl appendString:@"%22"];
    [strUrl appendString:week];
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
                               NSArray *foundLesson = @[data];
                               
                               // Vi kör det block vi skickade som argument.
                               // Och skickar det vi får tillbaka (callback).
                               getObjectResponce(foundLesson);
                           }];
    
    NSRunLoop *loop = [NSRunLoop currentRunLoop];
    [loop run];
}


-(void)getAssignmentsForCourse:(NSString *)course
                          Week:(NSString *)week
                        andDay:(NSString *)day
                  onCompletion:(GetObjectResponce)getObjectResponce
{
    NSMutableString *strUrl = [[NSMutableString alloc]initWithString:viewTodaysSchedule];
    
    NSURL *url = [NSURL URLWithString:strUrl];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    NSMutableString *keyString = [[NSMutableString alloc]init];
    [keyString appendString:@"%22lesson%22,%22"];
    [keyString appendString:course];
    [keyString appendString:@"%22,%22"];
    [keyString appendString:week];
    [keyString appendString:@"%22,%22"];
    [keyString appendString:day];
    [keyString appendString:@"%22"];

    NSArray *keys = @[keyString];
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:@{@"keys": keys}
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:NULL];
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPBody:jsonData];
    [request setHTTPMethod:@"POST"];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:queue
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               NSArray *foundLesson = @[data];
                               getObjectResponce(foundLesson);
                           }];
    
    NSRunLoop *loop = [NSRunLoop currentRunLoop];
    [loop run];
}


//-(void)getAssignmentsForCourse:(NSString *)course
//                          Week:(NSString *)week
//                        andDay:(NSString *)day
//                  onCompletion:(GetObjectResponce)getObjectResponce
//{
//    NSMutableString *strUrl = [[NSMutableString alloc]initWithString:viewTodaysSchedule];
//    
//    if ([day isEqualToString:@"monday"]) {
//        strUrl = [[NSMutableString alloc]initWithString:viewMondaysLessons];
//    } else if ([day isEqualToString:@"tuesday"]){
//        strUrl = [[NSMutableString alloc]initWithString:viewTuesdaysLessons];
//    } else if ([day isEqualToString:@"wedneday"]){
//        strUrl = [[NSMutableString alloc]initWithString:viewWednesdaysLessons];
//    } else if ([day isEqualToString:@"thursday"]){
//        strUrl = [[NSMutableString alloc]initWithString:viewThursdaysLessons];
//    } else {
//        // day isEqualToString:@"friday" 
//        strUrl = [[NSMutableString alloc]initWithString:viewFridaysLessons];
//    }
//    
//    [strUrl appendString:@"%5B%22"];
//    [strUrl appendString:course];
//    [strUrl appendString:@"%22,%22"];
//    [strUrl appendString:week];
//    [strUrl appendString:@"%22,%22"];
//    [strUrl appendString:day];
//    [strUrl appendString:@"%22%5D"];
//    
//    
//    
//    NSURL *url = [NSURL URLWithString:strUrl];
//    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
//    
//    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
//    
//    [NSURLConnection sendAsynchronousRequest:request
//                                       queue:queue
//                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
//                               NSArray *foundLesson = @[data];
//                               getObjectResponce(foundLesson);
//                           }];
//    
//    NSRunLoop *loop = [NSRunLoop currentRunLoop];
//    [loop run];
//}


#pragma mark - Managing messages

-(BOOL)addNewMessage:(Message *)message
       adminPassword:(NSString *)adminpassword;
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
            
            //JENS Lägg in din länk här tack :)
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


-(BOOL)updateMessage:(Message *)message
              withId:(NSString *)messageId
              andRev:(NSString *)revNumber
       adminPassword:(NSString *)adminpassword
{
    return YES;
}


-(BOOL)sendPrivateMessage:(Message *)message
                toStudent:(Student *)student
            adminPassword:(NSString *)password
{
    return YES;
}


-(BOOL)sendCollectiveMessage:(Message *)message
          toStudentsInCourse:(NSString *)course
                 withSubject:(NSString *)subject
               adminPassword:(Admin *)admin
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
    NSMutableString *strUrl = [[NSMutableString alloc]initWithString:@"http://kakis.iriscouch.com/schedule_students/_design/view_student/_view/get_student?key="];
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
    // Koden här tack
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

//
//#pragma mark - Helper methods
//
//-(void)getItemsForKeys:(NSArray *)keys
//                inView:(NSString *)view
//          onCompletion:(callbackWithDictionary)callback
//{
//    NSMutableString *strUrl = [[NSMutableString alloc]initWithString:viewTodaysSchedule];
//    NSMutableURLRequest *request = [self requestWithUrl:strUrl];
//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:@{@"keys": keys} options:NSJSONWritingPrettyPrinted error:NULL];
//    
//    [request setHTTPBody:jsonData];
//    [request setHTTPMethod:@"POST"];
//    
//    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *responce, NSData *data, NSError *error) {
//        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
//        NSMutableArray *items = [[[NSMutableArray alloc] initWithCapacity:[result[@"rows"]count]];
//        for (NSDictionary *d in result[@"rows"]) {
//            [items addObject:d[@"value"]];
//        }
//        callback(items);
//    }];
//}


@end
