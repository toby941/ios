//
//  LeftViewController.h
//  hope
//
//  Created by toby on 13-4-12.
//  Copyright (c) 2013年 toby. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol LeftViewControllerDelegate;
@interface LeftViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>{
    UITableView *_tblView;
}

@property (nonatomic, assign)   id <LeftViewControllerDelegate> delegate;
@property (nonatomic, strong) NSMutableArray* menuList;
@end
