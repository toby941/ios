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
#define isIPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)  

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
    
    if(!isIPhone5){
        
        CGRect frame = CGRectMake(self.navView.frame.origin.x, self.navView.frame.origin.y-(568-480), 320, 46);
      //  frame.origin.y = frame.origin.y-(568-480);
        self.navView.frame=frame;
    }
    
    // Do any additional setup after loading the view from its nib.
    NSURL* detailURL = [NSURL URLWithString:self.article.href];
    NSURLRequest* request = [NSURLRequest requestWithURL:detailURL];
    self.webView.delegate=self;
    [self.webView loadRequest:request];
}

- (void) webViewDidStartLoad:(UIWebView *)webView
{
    
    //创建UIActivityIndicatorView背底半透明View
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
//    [view setTag:108];
//    [view setBackgroundColor:[UIColor blackColor]];
//    [view setAlpha:0.5];
//    [self.view addSubview:view];
    
    _activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 32.0f, 32.0f)];
    [_activityIndicator setCenter:self.view.center];
    
    [_activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [self.view addSubview:_activityIndicator];
    
    [_activityIndicator startAnimating];
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [_activityIndicator stopAnimating];
    [_activityIndicator removeFromSuperview];
}


-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [_activityIndicator stopAnimating];
    [_activityIndicator removeFromSuperview];
    
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
