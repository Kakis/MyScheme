//
//  Message.h
//  MyScheme
//
//  Created by Jens Hagfeldt on 2013-08-01.
//  Copyright (c) 2013 Jens Hagfeldt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Message : NSObject

//@property (nonatomic, copy, readonly) NSString *id;
//@property (nonatomic, copy) NSString *type;
//@property (nonatomic, copy) NSString *recipient;
//@property (nonatomic, copy) NSString *subject;
//@property (nonatomic, copy) NSString *message;
//
//-(id)initWithRecipient:(NSString *)recipient
//               subject:(NSString *)subject
//               message:(NSString *)message
//                  type:(NSString *)type;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subject;
@property (nonatomic, copy) NSString *sender;
@property (nonatomic, copy) NSString *receiver;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *message;
@property BOOL *isPrivate;
@property (nonatomic, copy, readonly) NSString *id;


-(id)initWithTitle:(NSString *) title
           subject:(NSString *) subject
            sender:(NSString *) sender
          receiver:(NSString *) receiver
              type:(NSString *) type
           message:(NSString *) message
         isPrivate:(BOOL)YoN;



@end
