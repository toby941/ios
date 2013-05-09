//
//  ArticleDetailViewController.h
//  hope
//
//  Created by toby on 13-4-15.
//  Copyright (c) 2013年 toby. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Article;
@interface ArticleDetailViewController : UIViewController<UIWebViewDelegate>

@property (nonatomic, strong) Article* article;

@property (nonatomic, strong) IBOutlet UIWebView* webView;

@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;

@property (nonatomic,strong) IBOutlet UIButton *backBtn;
@property (nonatomic,strong) IBOutlet UIView *navView;

- (IBAction)clickBack;

@end
