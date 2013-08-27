//
//  Lesson.h
//  MyScheme
//
//  Created by Jens Hagfeldt on 2013-04-29.
//  Copyright (c) 2013 Jens Hagfeldt. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Lesson : NSObject

@property (nonatomic, copy, readonly) NSString *id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *subject;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *course;
@property (nonatomic, copy) NSString *week;
@property (nonatomic, copy) NSString *day;
@property (nonatomic, copy) NSString *lessontime;
@property (nonatomic, copy) NSString *teacher;
@property (nonatomic, copy) NSString *classroom;
@property (nonatomic, copy) NSString *assignment;

-(id)initWithSubject:(NSString *)subject
                name:(NSString *)name
                type:(NSString *)type
              course:(NSString *)course
                week:(NSString *)week
                 day:(NSString *)day
          lessontime:(NSString *)lessontime
             teacher:(NSString *)teacher
           classroom:(NSString *)classroom
          assignment:(NSString *)assignment;



@end
