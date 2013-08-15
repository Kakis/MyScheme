//
//  Admin.m
//  MyScheme
//
//  Created by Jens Hagfeldt on 2013-04-29.
//  Copyright (c) 2013 Jens Hagfeldt. All rights reserved.
//

#import "Admin.h"

@implementation Admin

- (id)init
{
    return [self initWithUserName:@""
                         password:@""];
}


- (id)initWithUserName:(NSString *)username
              password:(NSString *)password
{
    self = [super init];
    if (self) {
        self.username = username;
        self.password = password;
    }
    return self;
}



@end
