//
//  Person.h
//  Match
//
//  Created by toby on 13-6-17.
//  Copyright (c) 2013年 toby. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject

@property (nonatomic, copy) NSString* id;
@property (nonatomic, copy) NSString* name;
@property (nonatomic) NSInteger* pts;//总得分
@property (nonatomic) NSInteger* blk;//篮板球
@property (nonatomic) NSInteger* ast;//助攻
@property (nonatomic) NSInteger* ft;//罚球次数
@property (nonatomic) NSInteger* pf;//犯规次数
@property (nonatomic) NSInteger* threepm;//三分球
@property (nonatomic) NSInteger* fg;//投篮
@property (nonatomic) NSInteger* st;//抢断


@property (nonatomic, copy) NSString* img;           // Picture URL
@property (nonatomic, copy) NSString* href;        // News Detail URL
@property (nonatomic, strong) UIImage*  picImage;


@end
