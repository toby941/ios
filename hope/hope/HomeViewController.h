//
//  HomeViewController.h
//  hope
//
//  Created by toby on 13-4-12.
//  Copyright (c) 2013年 toby. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HomeViewControllerDelegate;

@interface HomeViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
 UIView *bgView;
UITableView *tblView;
}

@property (nonatomic, assign)   id <HomeViewControllerDelegate> delegate;
@property (nonatomic, strong)   UITableView     *indexTableView;
@property (nonatomic, strong) NSArray* newsArray;
@end


@protocol HomeViewControllerDelegate <NSObject>
- (void)refreshHomeTable;

@end
