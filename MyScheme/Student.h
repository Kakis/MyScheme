//
//  Student.h
//  MyScheme
//
//  Created by Jens Hagfeldt on 2013-04-29.
//  Copyright (c) 2013 Jens Hagfeldt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Student : NSObject

@property (nonatomic, copy) NSString *lastName;
@property (nonatomic, copy) NSString *firstName;
@property (nonatomic, copy) NSString *course;
@property (nonatomic, copy, readonly) NSString *id;
@property (nonatomic, copy) NSString *rev;


-(id)initWithLastName:(NSString *)lastName
            firstName:(NSString *)firstName
            course:(NSString *)course;


-(BOOL)getPersonalMessage:(Student *)id msg:(NSString *)msg;


-(BOOL)getCourseMessages:(NSString *)msg;


@end
