//
//  Lesson+Json.m
//  MyScheme
//
//  Created by Jens Hagfeldt on 2013-04-30.
//  Copyright (c) 2013 Jens Hagfeldt. All rights reserved.
//

#import "Lesson+Json.h"

@implementation Lesson (Json)

-(id)jsonValue
{
    NSMutableDictionary *selfAsJson = [[NSMutableDictionary alloc] init];

    selfAsJson[@"course"] = self.course;
    selfAsJson[@"weekday"] = self.weekday;
    selfAsJson[@"lessontime"] = self.lessontime;
    selfAsJson[@"teacher"] = self.teacher;
    selfAsJson[@"classroom"] = self.classroom;
    selfAsJson[@"assignment"] = self.assignment;
    selfAsJson[@"_id"] = self.id;
    selfAsJson[@"_rev"] = self.rev;
    
    return selfAsJson;
}

@end
