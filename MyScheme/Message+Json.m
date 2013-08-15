//
//  Message+Json.m
//  MyScheme
//
//  Created by Jens Hagfeldt on 2013-08-04.
//  Copyright (c) 2013 Jens Hagfeldt. All rights reserved.
//

#import "Message+Json.h"

@implementation Message (Json)

-(id)jsonValue
{
    NSMutableDictionary *selfAsJson = [[NSMutableDictionary alloc] init];
    
    selfAsJson[@"recipient"] = self.recipient;
    selfAsJson[@"subject"] = self.subject;
    selfAsJson[@"message"] = self.message;
    selfAsJson[@"type"] = self.type;
    
    return selfAsJson;
}

@end
