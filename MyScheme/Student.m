//
//  Student.m
//  MyScheme
//
//  Created by Jens Hagfeldt on 2013-04-29.
//  Copyright (c) 2013 Jens Hagfeldt. All rights reserved.
//

#import "Student.h"

@implementation Student


- (id)init
{
    return [self initWithLastName:@""
                        firstName:@""
                             type:@""
                           course:@""];
}


- (id)initWithLastName:(NSString *)lastName
             firstName:(NSString *)firstName
                  type:(NSString *)type
                course:(NSString *)course
{
    self = [super init];
    if (self) {
        self.lastName = lastName;
        self.firstName = firstName;
        self.type = type;
        self.course = course;
        self->_id = [[NSUUID UUID] UUIDString];
    }
    return self;
}


-(BOOL)getPersonalMessage:(Student *)id msg:(NSString *)msg
{
    return YES;
}


-(BOOL)getCourseMessages:(NSString *)msg
{
    return YES;
}


-(NSUInteger)hash
{
    return 37 * [self.id hash];
}


-(BOOL)isEqual:(id)student
{
    if(student == self){
        return YES;
    }
    if(student && [student isMemberOfClass:[self class]]){
        return [[student id] isEqualToString:self.id];
    }
    return NO;
}


-(NSString *)description
{
    return [NSString stringWithFormat:@"Student %@ %@ with id: [%@] attends the %@class", [self firstName], [self lastName], [self id], [self course]];
}


@end
