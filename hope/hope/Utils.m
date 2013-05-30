//
//  Utils.m
//  hope
//
//  Created by toby on 13-5-22.
//  Copyright (c) 2013年 toby. All rights reserved.
//

#import "Utils.h"

@implementation Utils



+(Boolean) isEmptyOrNull:(NSString *) str {
    if (!str) {
        // null object空对象
        return true;
    } else {
        NSString *trimedString = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if ([trimedString length] == 0) {
            // empty string空字符串@”"
            return true;
        } else {
            // is neither empty nor null 非null也非空@”   ”
            return false;
        }
    }
}
@end