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
@property (nonatomic,assign) int pts;//总得分
@property (nonatomic,assign)int blk;//篮板球
@property (nonatomic,assign) int ast;//助攻
@property (nonatomic,assign)int ft;//罚球次数
@property (nonatomic,assign)int pf;//犯规次数
@property (nonatomic,assign) int threepm;//三分球
@property (nonatomic,assign) int fg;//投篮
@property (nonatomic,assign) int st;//抢断


@property (nonatomic, copy) NSString* img;           // Picture URL
@property (nonatomic, copy) NSString* href;        // News Detail URL
@property (nonatomic, strong) UIImage*  picImage;

-(void) update:(Person*)updatePerson;
-(void) updatePts;

@end
