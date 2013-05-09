//
//  HomeViewController.h
//  首页viewcontroller，显示分类为0的信息
//
//  Created by toby on 13-4-12.
//  Copyright (c) 2013年 toby. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"
#import "STableViewController.h"

@protocol HomeViewControllerDelegate;

@interface HomeViewController : STableViewController<EGORefreshTableHeaderDelegate, UITableViewDataSource, UITableViewDelegate>
{
 UIView *bgView;

    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL _reloading;

}

@property (nonatomic, assign)   id <HomeViewControllerDelegate> delegate;
@property (nonatomic, strong)   UITableView     *indexTableView;
@property (nonatomic, strong) NSMutableArray* newsArray;
- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;

@end


@protocol HomeViewControllerDelegate <NSObject>
- (void)refreshHomeTable;

@end
