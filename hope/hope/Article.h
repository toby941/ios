//
//  Article.h
//  hope
//
//  Created by toby on 13-4-15.
//  Copyright (c) 2013年 toby. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Article : NSObject

@property (nonatomic, copy) NSString* id;
@property (nonatomic, copy) NSString* title;
@property (nonatomic, copy) NSString* summary;
@property (nonatomic, copy) NSString* time;
@property (nonatomic, copy) NSString* img;           // Picture URL
@property (nonatomic, copy) NSString* href;        // News Detail URL
@property (nonatomic, copy) NSString* type;          // News type, such as video,origin,etc.
@property (nonatomic, strong) UIImage*  picImage;

- (id)initWithDictionary:(NSDictionary*)dict;



@end
