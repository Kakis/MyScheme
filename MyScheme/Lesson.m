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
    return [self initWithCourse:@""
                        weekday:@""
                     lessontime:@""
                        teacher:@""
                      classroom:@""
                     assignment:@""];
}


- (id)initWithCourse:(NSString *)course
             weekday:(NSString *)weekday
          lessontime:(NSString *)lessontime
             teacher:(NSString *)teacher
           classroom:(NSString *)classroom
          assignment:(NSString *)assignment
{
    self = [super init];
    if (self) {
        self.course = course;
        self.weekday = weekday;
        self.lessontime = lessontime;
        self.teacher = teacher;
        self.classroom = classroom;
        self.assignment = assignment;
        self->_id = [[NSUUID UUID] UUIDString];
        self->_rev = [[NSUUID UUID] UUIDString];
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
    return [NSString stringWithFormat:@"You have an %@-lesson with %@ at %@ in room %@ on %@. Your assignment is to: %@", self.course, self.teacher, self.lessontime, self.classroom, self.weekday, self.assignment];
}



@end
