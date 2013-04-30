//
//  Student+Json.h
//  MyScheme
//
//  Created by Jens Hagfeldt on 2013-04-30.
//  Copyright (c) 2013 Jens Hagfeldt. All rights reserved.
//


#import "JsonFormat.h"
#import "Student.h"

@interface Student (Json) <JsonFormat>

-(id)jsonValue;

@end
