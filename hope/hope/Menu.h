//
//  Menu.h
//  hope
//
//  Created by toby on 13-4-16.
//  Copyright (c) 2013年 toby. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Menu : NSObject

@property (nonatomic, copy) NSString* id;
@property (nonatomic, copy) NSString* name;         
@property (nonatomic, copy) NSString* path;
@property (nonatomic, copy) NSString* imgsrc;
@property (nonatomic, strong) UIImage*  picImage;

- (id)initWithDictionary:(NSDictionary*)dict;


@end
