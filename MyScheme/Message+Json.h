//
//  Message+Json.h
//  MyScheme
//
//  Created by Jens Hagfeldt on 2013-08-23.
//  Copyright (c) 2013 Jens Hagfeldt. All rights reserved.
//

#import "Message.h"
#import "JsonFormat.h"

@interface Message (Json) <JsonFormat>

-(id)jsonValue;

@end
