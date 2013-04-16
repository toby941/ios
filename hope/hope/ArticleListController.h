//
//  ArticleListController.h
//  hope
//
//  Created by toby on 13-4-15.
//  Copyright (c) 2013年 toby. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataContext.h"

@protocol ArticleListControllerDelegate;
@interface ArticleListController : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
    UIView *bgView;
    UITableView *tblView;
}
@property (nonatomic, strong) NSString *urlpath;
@property (nonatomic, assign)id <ArticleListControllerDelegate> delegate;

@property (nonatomic, strong) NSArray* newsArray;
@end


@protocol HomeViewControllerDelegate <NSObject>
- (void)refreshTable;

@end
