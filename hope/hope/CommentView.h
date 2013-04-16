//
//  CommentView.h
//  hope
//
//  Created by toby on 13-4-14.
//  Copyright (c) 2013年 toby. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentView : UIView
- (id)initWithView:(UIView*)contentView parentView:(UIView*) parentView;

@property (nonatomic, strong) UIView *parentView; //抽屉视图的父视图
@property (nonatomic, strong) UIView *contentView; //抽屉显示内容的视图
@end