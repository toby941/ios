//
//  ListViewController.h
//  hope
//
//  Created by toby on 13-5-10.
//  Copyright (c) 2013年 toby. All rights reserved.
//

#import "STableViewController.h"

@interface ListViewController : STableViewController{
  UIView *bgView;
}
@property (nonatomic, strong) NSMutableArray* items;
@property (nonatomic,strong) NSString* path;
@property (nonatomic) int page;
@property (nonatomic,copy) NSString *title;
@end
