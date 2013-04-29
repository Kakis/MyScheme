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
    return [self initWithUserName:@"" password:@"" rev:@""];
}

// Committed and pushed project to GitHub

- (id)initWithUserName:(NSString *)username
              password:(NSString *)password
                   rev:(NSString *)rev
{
    self = [super init];
    if (self) {
        self.username = username;
        self.password = password;
        self->_id = [[NSUUID UUID] UUIDString];
        self.rev = rev;
    }
    return self;
}


//-(void)messageToStudent:(Student *)student
//                    msg:(NSString *)msg
//{
//    
//}
//
//-(void)messageToAll:(NSString *)msg
//{
//    
//}


-(NSUInteger)hash
{
    return 37 * [self.id hash];
}


-(BOOL)isEqual:(id)admin
{
    if(admin == self){
        return YES;
    }
    if(admin && [admin isMemberOfClass:[self class]])
    {
        return [[admin id] isEqualToString:self.id];
    }
    return NO;
}


@end
