//
//  Student+Json.m
//  MyScheme
//
//  Created by Jens Hagfeldt on 2013-04-30.
//  Copyright (c) 2013 Jens Hagfeldt. All rights reserved.
//

#import "Student+Json.h"

@implementation Student (Json)

-(id)jsonValue
{
    NSMutableDictionary *selfAsJson = [[NSMutableDictionary alloc] init];
    
    selfAsJson[@"_id"] = self.id;
    selfAsJson[@"lastName"] = self.lastName;
    selfAsJson[@"firstName"] = self.firstName;
    selfAsJson[@"type"] = self.type;
    selfAsJson[@"course"] = self.course;
    
    return selfAsJson;
}

@end
