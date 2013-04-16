//
//  Menu.m
//  hope
//
//  Created by toby on 13-4-16.
//  Copyright (c) 2013年 toby. All rights reserved.
//

#import "Menu.h"

@implementation Menu


- (id)initWithDictionary:(NSDictionary*)dict
{
    self = [super init];
    if (self) {
        self.id=[dict objectForKey:@"id"];
        self.name=[dict objectForKey:@"name"];
        self.path=[dict objectForKey:@"path"];
    }
    return self;
}

@end
