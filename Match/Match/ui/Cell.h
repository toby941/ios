//
//  Cell.h
//  Match
//
//  Created by toby on 13-6-15.
//  Copyright (c) 2013年 toby. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Person.h"
@class QBPopupMenu;
@class Cell;

@protocol callChangeDelegate <NSObject>

-(void) callChangeValue:(Person*)p;

@end

@interface Cell : UITableViewCell{
    
    UIButton* blk;//篮板球
    UIButton* ast;//助攻
    UIButton* ft;//罚球次数
    UIButton* pf;//犯规次数
    UIButton* threepm;//三分球
    UIButton* fg;//投篮
    UIButton* st;//抢断
    UILabel* pts;//总得分
    UIImageView* icon;
} 

@property (nonatomic, retain) Person* p;
@property (nonatomic, retain) QBPopupMenu *popupMenu;
@property (nonatomic, retain) UIButton* currentButton;
@property (nonatomic,assign) Boolean isManinCell;
@property (nonatomic,retain) NSString* teamName;

@property (nonatomic, retain) id <callChangeDelegate> delegate;

@property (nonatomic, retain) IBOutlet UILabel* pts;//总得分
@property (nonatomic, retain) IBOutlet UIButton* blk;//篮板球
@property (nonatomic, retain) IBOutlet UIButton* ast;//助攻
@property (nonatomic, retain) IBOutlet UIButton* ft;//罚球次数
@property (nonatomic, retain) IBOutlet UIButton* pf;//犯规次数
@property (nonatomic, retain) IBOutlet UIButton* threepm;//三分球
@property (nonatomic, retain) IBOutlet UIButton* fg;//投篮
@property (nonatomic, retain) IBOutlet UIButton* st;//抢断

@property (nonatomic, retain) IBOutlet UIImageView* icon;//头像

-(Person*)makePerson:(NSInteger)tagValue targetValue:(int)value;
-(void) updateByAnotherPerson:(Person*)p;
- (void)setCustomIcon:(NSString*)path;
- (IBAction)showPopupMenu:(id)sender;
- (void) initButton;

@end
