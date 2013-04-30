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
@property (nonatomic, copy) NSString *rev;
@property (nonatomic, copy) NSString *course;
@property (nonatomic, copy) NSString *weekday;
@property (nonatomic, copy) NSString *lessontime;
@property (nonatomic, copy) NSString *teacher;
@property (nonatomic, copy) NSString *classroom;
@property (nonatomic, copy) NSString *assignment;

-(id)initWithCourse:(NSString *)course
                weekday:(NSString *)weekday
         lessontime:(NSString *)lessontime
            teacher:(NSString *)teacher
          classroom:(NSString *)classroom
         assignment:(NSString *)assignment;



@end
