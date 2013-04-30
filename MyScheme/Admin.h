//
//  Admin.h
//  MyScheme
//
//  Created by Jens Hagfeldt on 2013-04-29.
//  Copyright (c) 2013 Jens Hagfeldt. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Admin : NSObject

@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *password;


-(id)initWithUserName:(NSString *)username
             password:(NSString *)password;


@end
