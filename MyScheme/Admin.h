//
//  Admin.h
//  MyScheme
//
//  Created by Jens Hagfeldt on 2013-04-29.
//  Copyright (c) 2013 Jens Hagfeldt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StudentService.h"
#import "Student.h"

@interface Admin : NSObject

@property (nonatomic, copy, readonly) NSString *id;
@property (nonatomic, copy) NSString *rev;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *password;

-(id)initWithUserName:(NSString *)username
             password:(NSString *)password
                  rev:(NSString *)rev;


//-(void)messageToStudent:(Student *)student
//                    msg:(NSString *)msg;
//
//
//-(void)messageToAll:(NSString *)msg;


-(BOOL)isEqual:(id)admin;


@end
