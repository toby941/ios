//
//  MatchFirstViewController.h
//  Match
//
//  Created by toby on 13-6-13.
//  Copyright (c) 2013年 toby. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Cell.h"
@class QBPopupMenu;
@protocol MatchFirstViewController;
@interface MatchFirstViewController : UIViewController<UITableViewDataSource, UITableViewDelegate,callChangeDelegate>
{
       UITableView *tblView;    
}
@property (nonatomic, assign)id <MatchFirstViewController> delegate;

@property (nonatomic, assign) NSInteger point;

@property (nonatomic, strong) NSArray* newsArray;
@property (nonatomic, retain) QBPopupMenu *popupMenu;
@end
