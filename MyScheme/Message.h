//
//  Message.h
//  MyScheme
//
//  Created by Jens Hagfeldt on 2013-08-01.
//  Copyright (c) 2013 Jens Hagfeldt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Message : NSObject

@property (nonatomic, copy, readonly) NSString *id;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *recipient;
@property (nonatomic, copy) NSString *subject;
@property (nonatomic, copy) NSString *message;

-(id)initWithRecipient:(NSString *)recipient
               subject:(NSString *)subject
               message:(NSString *)message
                  type:(NSString *)type;


@end
