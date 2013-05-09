//
//  ArticleListController.h
//  hope
//
//  Created by toby on 13-4-15.
//  Copyright (c) 2013年 toby. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataContext.h"
#import "EGORefreshTableHeaderView.h"

@protocol ArticleListControllerDelegate;
@interface ArticleListController : UIViewController<EGORefreshTableHeaderDelegate,UITableViewDataSource, UITableViewDelegate>
{
    UIView *bgView;
    UITableView *tblView;
    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL _reloading;

}
@property (nonatomic, copy) NSString *urlpath;
@property (nonatomic,copy) NSString *title;
@property (nonatomic, assign)id <ArticleListControllerDelegate> delegate;

@property (nonatomic, strong) NSArray* newsArray;

- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;
@end


@protocol HomeViewControllerDelegate <NSObject>
- (void)refreshTable;

@end
