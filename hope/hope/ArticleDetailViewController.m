//
//  ArticleDetailViewController.m
//  hope
//
//  Created by toby on 13-4-15.
//  Copyright (c) 2013年 toby. All rights reserved.
//

#import "ArticleDetailViewController.h"
#import "Article.h"
#import "hopeAppDelegate.h"

@implementation ArticleDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    if (_backBtn != nil) {
        [_backBtn release];
        _backBtn = nil;
    }
    if (_webView != nil) {
        [_webView release];
        _webView = nil;
    }
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //  self.title = _news.nTitle;
    [self.navigationController setNavigationBarHidden:YES];
    
    
    
    // Do any additional setup after loading the view from its nib.
    NSURL* detailURL = [NSURL URLWithString:self.article.href];
    NSURLRequest* request = [NSURLRequest requestWithURL:detailURL];
    [self.webView loadRequest:request];
}



- (IBAction)clickBack
{
   
   // if (![_webView.request.URL.absoluteString isEqualToString:self.article.href]){
    if ([_webView canGoBack]) {
      [_webView goBack];
    }else{
        [theApp._viewController.controllerHome popToRootViewControllerAnimated:YES];
    }
   }

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
