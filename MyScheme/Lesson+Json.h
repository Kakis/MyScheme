//
//  Lesson+Json.h
//  MyScheme
//
//  Created by Jens Hagfeldt on 2013-04-30.
//  Copyright (c) 2013 Jens Hagfeldt. All rights reserved.
//

#import "Lesson.h"
#import "JsonFormat.h"

@interface Lesson (Json) <JsonFormat>

-(id)jsonValue;

@end
