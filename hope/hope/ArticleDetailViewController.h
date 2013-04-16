//
//  ArticleDetailViewController.h
//  hope
//
//  Created by toby on 13-4-15.
//  Copyright (c) 2013年 toby. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Article;
@interface ArticleDetailViewController : UIViewController

@property (nonatomic, strong) Article* article;

@property (nonatomic, strong) IBOutlet UIWebView* webView;



@property (nonatomic,strong) IBOutlet UIButton *backBtn;

- (IBAction)clickBack;

@end
