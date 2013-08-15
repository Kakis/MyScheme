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

// Keys for sorting students in two courses
static NSString * const objCKey = @"objC_key";
static NSString * const iOSKey = @"iOS_key";

// Views for sorting schedule
static NSString * const viewScheduleForWeek = @"http://kakis.iriscouch.com/schedule_lessons/_design/schedule_week/_view/schedule_week?key=";
static NSString * const viewMondaysLessons = @"http://kakis.iriscouch.com/schedule_lessons/_design/view_mondays/_view/monday_lessons?key=";
static NSString * const viewTuesdaysLessons = @"http://kakis.iriscouch.com/schedule_lessons/_design/view_tuesdays/_view/tuesday_lessons?key=";
static NSString * const viewWednesdaysLessons = @"http://kakis.iriscouch.com/schedule_lessons/_design/view_wednesdays/_view/wednesday_lessons?key";
static NSString * const viewThursdaysLessons = @"http://kakis.iriscouch.com/schedule_lessons/_design/view_thurdays/_view/thursday_lessons?key=";
static NSString * const viewFridaysLessons = @"http://kakis.iriscouch.com/schedule_lessons/_design/view_fridays/_view/friday_lessons?key=";

// Views for sorting assignments
static NSString * const viewAssignmentsForWeek = @"http://kakis.iriscouch.com/schedule_lessons/_design/assignments_week/_view/assignments_week?key=";

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
                      day:(NSString *)day
             onCompletion:(GetObjectResponce)getObjectResponce
{
    // Bygg ut här...
}


-(BOOL)updateLesson:(Lesson *)lesson
      adminPassword:(NSString *)password
{
    // Bygg ut här...
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



-(void)getAssignmentsForWeek:(NSString *)week
                         day:(NSString *)day
                onCompletion:(GetObjectResponce)getObjectResponce
{
    // Här ska man kunna välja en annan dag än fredag också
    NSMutableString *strUrl = [[NSMutableString alloc]initWithString:viewFridaysLessons];
    
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


#pragma mark - Managing messages

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
    NSMutableString *strUrl = [[NSMutableString alloc]initWithString:@"http://kakis.iriscouch.com/schedule_students/_design/student/_view/get_student?key="];
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



-(BOOL)updateStudent:(Student *)student
              withID:(NSString *)studentId
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
