//
//  Lesson.m
//  MyScheme
//
//  Created by Jens Hagfeldt on 2013-04-29.
//  Copyright (c) 2013 Jens Hagfeldt. All rights reserved.
//

#import "Lesson.h"

@implementation Lesson


- (id)init
{
    return [self initWithSubject:@""
                            name:@""
                            type:@""
                          course:@""
                            week:@""
                             day:@""
                      lessontime:@""
                         teacher:@""
                       classroom:@""
                      assignment:@""];
}


-(id)initWithSubject:(NSString *)subject
                name:(NSString *)name
                type:(NSString *)type
              course:(NSString *)course
                week:(NSString *)week
                 day:(NSString *)day
          lessontime:(NSString *)lessontime
             teacher:(NSString *)teacher
           classroom:(NSString *)classroom
          assignment:(NSString *)assignment
{
    self = [super init];
    if (self) {
        self.name = name;
        self.subject = subject;
        self.type = type;
        self.course = course;
        self.week = week;
        self.day = day;
        self.lessontime = lessontime;
        self.teacher = teacher;
        self.classroom = classroom;
        self.assignment = assignment;
        self->_id = [[NSUUID UUID] UUIDString];
    }
    return self;
}


-(NSUInteger)hash
{
    return 37 * [self.id hash];
}


-(BOOL)isEqual:(id)lesson
{
    if(lesson == self){
        return YES;
    }
    if(lesson && [lesson isMemberOfClass:[self class]]){
        return [[lesson id] isEqualToString:self.id];
    }
    return NO;
}



-(NSString *)description
{
    return [NSString stringWithFormat:@"\nYour %@ lesson about %@ in room %@ on %@ week %@ starts at %@. \nYour teacher %@ have given you the assignment to %@", self.course, self.subject, self.classroom, self.day, self.week, self.lessontime, self.teacher, self.assignment];
}



@end
