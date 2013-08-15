//
//  Message.m
//  MyScheme
//
//  Created by Jens Hagfeldt on 2013-08-01.
//  Copyright (c) 2013 Jens Hagfeldt. All rights reserved.
//

#import "Message.h"

@implementation Message

- (id)init
{
    return [self initWithRecipient:@""
                           subject:@""
                           message:@""
                              type:@""];
}


-(id)initWithRecipient:(NSString *)recipient
               subject:(NSString *)subject
               message:(NSString *)message
                  type:(NSString *)type
{
    self = [super init];
    
    if (self) {
        self.recipient = recipient;
        self.subject = subject;
        self.message = message;
        self.type = type;
        self->_id = [[NSUUID UUID] UUIDString];
    }
    return self;
}


-(NSUInteger)hash
{
    return 37 * [self.id hash];
}


-(BOOL)isEqual:(id)message
{
    if(message == self)
    {
        return YES;
    }
    if (message && [message isMemberOfClass:[self class]]){
        return [[message id] isEqualToString:self.id];
    }
    return NO;
}


-(NSString *)description
{
    return [NSString stringWithFormat:@"%@, you got a message with subject: %@. \n The message was: %@",self.recipient, self.subject, self.message];
}


@end
