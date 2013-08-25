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

    return [self initWithTitle:@""
                       subject:@""
                        sender:@""
                      receiver:@""
                          type:@""
                       message:@""
                     isPrivate:NO];
}

-(id)initWithTitle:(NSString *)title
           subject:(NSString *)subject
            sender:(NSString *)sender
          receiver:(NSString *)receiver
              type:(NSString *)type
           message:(NSString *)message
         isPrivate:(BOOL)YesOrNo
{
    self = [super init];
    
    if (self) {
        self.title = title;
        self.subject = subject;
        self.sender = sender;
        self.receiver = receiver;
        self.type = type;
        self.message = message;
        self.isPrivate = NO;
    }
    return self;
}

//-(id)initWithSMS:(NSString *)sender
//        receiver:(NSString *)receiver
//         subject:(NSString *)subject
//            type:(NSString *)type
//    messageToAll:(NSString *)messageToAll
//  privateMessage:(NSString *)privateMessage
//
//{
//    self = [super init];
//    
//    if (self) {
//        self.sender = sender;
//        self.receiver = receiver;
//        self.subject = subject;
//        self.type = type;
//        self.messageToAll = messageToAll;
//        self.privateMessage = privateMessage;
//        self->_id = [[NSUUID UUID] UUIDString];
//    }
//    return self;
//}


-(NSUInteger)hash
{
    return 37 * [self.id hash];
}


-(BOOL)isEqual:(id)message
{
    if (message == self)
    {
        return YES;
    }
    if (message && [message isMemberOfClass:[self class]])
    {
        return [[message id] isEqualToString:self.id];
    }
    return NO;
}


@end
