//
//  Message+Json.m
//  MyScheme
//
//  Created by Jens Hagfeldt on 2013-08-23.
//  Copyright (c) 2013 Jens Hagfeldt. All rights reserved.
//

#import "Message+Json.h"

@implementation Message (Json)

-(id)jsonValue
{
    NSMutableDictionary *selfAsJson = [[NSMutableDictionary alloc] init];
    
    selfAsJson[@"title"] = self.title;
    selfAsJson[@"subject"] = self.subject;
    selfAsJson[@"sender"] = self.sender;
    selfAsJson[@"receiver"] = self.receiver;
    selfAsJson[@"type"] = self.type;
    selfAsJson[@"message"] = self.message;
    
    return selfAsJson;
}


@end
