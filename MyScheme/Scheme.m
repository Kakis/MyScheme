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
static NSString * const appdevKey = @"appdev_Key";
static NSString * const javaKey = @"java_key";


@implementation Scheme
{
    NSDictionary *lessons;
    NSDictionary *students;
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
        
        students = @{appdevKey:[[NSMutableSet alloc] init],
                    javaKey:[[NSMutableSet alloc] init]};
        
        queue = [[NSOperationQueue alloc] init];
    }
    return self;
}


-(BOOL)addLesson:(Lesson *)lesson adminPassword:(Admin *)admin
{
    if([admin.password isEqualToString:@"coredev"]){
        
        // Check course-key of lesson to be added
        if([lesson.course isEqualToString:@"appdev"]){
            
            // Check weekday-key of appdev-lesson and add it accordingly
            if([lesson.weekday isEqualToString:@"monday"]){
                [lessons[appdevKey] addObject:lesson];
            } else if ([lesson.weekday isEqualToString:@"tuesday"]){
                [lessons[appdevKey] addObject:lesson];
            } else if ([lesson.weekday isEqualToString:@"wednesday"]){
                [lessons[appdevKey] addObject:lesson];
            } else if ([lesson.weekday isEqualToString:@"thursday"]){
                [lessons[appdevKey] addObject:lesson];
            } else { // or lesson is at friday
                [lessons[appdevKey] addObject:lesson];
            }
            
        } else {
            // Check weekday-key of java-lesson and add it accordingly
            if([lesson.weekday isEqualToString:@"monday"]){
                [lessons[appdevKey] addObject:lesson];
            } else if ([lesson.weekday isEqualToString:@"tuesday"]){
                [lessons[appdevKey] addObject:lesson];
            } else if ([lesson.weekday isEqualToString:@"wednesday"]){
                [lessons[appdevKey] addObject:lesson];
            } else if ([lesson.weekday isEqualToString:@"thursday"]){
                [lessons[appdevKey] addObject:lesson];
            } else { // or lesson is at friday
                [lessons[appdevKey] addObject:lesson];
            }

        }
    }
    return YES;
}


-(BOOL)updateLesson:(Lesson *)lesson adminPassword:(Admin *)admin
{
    return YES;
}


-(BOOL)addStudent:(Student *)student adminPassword:(Admin *)admin
{
    if([admin.password isEqualToString:@"coredev"]){
        if([student.course isEqualToString:@"appdev"])
        {
            [students[appdevKey] addObject:student];
        } else {
            [students[javaKey] addObject:student];
        }
        return YES;
    }
    return YES;
}


-(BOOL)updateStudent:(Student *)student adminPassword:(Admin *)admin
{
    return YES;
}


-(BOOL)sendMessage:(NSString *)msg toStudent:(Student *)id adminPassword:(Admin *)admin
{
    return YES;
}


-(BOOL)sendAllStudentsMessage:(NSString *)msg adminPassword:(Admin *)admin
{
    return YES;
}


-(NSSet*) allStudents
{
    //Returns a set with students from all courses
    return [students[appdevKey]setByAddingObjectsFromSet:students[javaKey]];
}


#pragma mark - Serialize student to json

-(id)serializeStudentToJson:(id) object
{
    // Serialiserar en student till JSON-format
    NSObject *result = [[NSObject alloc] init];
    result = [object jsonValue];
    return result;
}


#pragma mark - Save a student to couch.db

-(void) saveStudent:(Student *)student
{
    // Kör serialiserar av en student till JSON-format
    NSDictionary *studentAsJson = [self serializeStudentToJson:student];
    
    // Skapar ett NSData-objekt som håller i en JSON-formaterad student
    NSData *studentAsData = [NSJSONSerialization dataWithJSONObject:studentAsJson
                                                            options:NSJSONWritingPrettyPrinted
                                                              error:NULL];
    
    // Sätter adressen till min databas som url
    NSURL *url = [NSURL URLWithString:@"http://kakis.iriscouch.com/schedule"];
    
    // Skapar en request från min url
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[url standardizedURL]];
    
    // Sätter HTTP metoden till POST
    [request setHTTPMethod:@"POST"];
    
    // Ställer i HTTP headern in att jag kommer att skicka värden av typen application/json
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    // Lägger min student i HTTP bodyn
    [request setHTTPBody:studentAsData];
    
    // Skapar min NSURLConnection
    NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:nil];
    [connection start];
}


#pragma mark - Get a student from couch.db

-(void)getStudentWithID:(NSString *)_id onCompletion:(GetStudentResponce)getStudentResponce
{
    // Vi skapar en URL-pekare och tilldelar den en sträng med url'en till min databas students på iriscouch, matchat mot en students id
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://kakis.iriscouch.com/students/%@", _id]];
    
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
    
}


@end
