//
//  ArticleListController.m
//  文章列表 UI一样，通过api uil区分内容
//
//  Created by toby on 13-4-15.
//  Copyright (c) 2013年 toby. All rights reserved.
//

#import "ArticleListController.h"
#import<QuartzCore/QuartzCore.h>
#import "DataContext.h"
#import "Article.h"
#import "ArticleCell.h"
#import "ArticleDetailViewController.h"
#import "hopeAppDelegate.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface ArticleListController ()
#define NAVIGATIONVIEWFRAME      CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y, self.view.bounds.size.width,  44)
#define TABLEVIEWFRAME      CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y+44, self.view.bounds.size.width,  self.view.bounds.size.height)
@end

@implementation ArticleListController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
     [self.navigationController setNavigationBarHidden:YES];
    CGRect frame =   self.view.bounds;
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height)];
    [bgImageView setImage:[UIImage imageNamed:@"bg"]];
    
    //UIView设置阴影
    bgImageView.layer.shadowColor = [UIColor blackColor].CGColor;
    bgImageView.layer.shadowOpacity = 0.5;
    bgImageView.layer.shadowRadius = 20;
    bgImageView.layer.shadowOffset = CGSizeMake(-100, 50);
    bgImageView.clipsToBounds = NO;
    
//    //UIView设置边框
    [[bgImageView layer] setCornerRadius:1];
    [[bgImageView layer] setBorderWidth:1];
    [[bgImageView layer] setBorderColor:[UIColor blackColor].CGColor];
    self.view.backgroundColor=[UIColor blackColor];
    [self.view addSubview:bgImageView];
    [self showNavigationView];
    [bgImageView release];
    
    
    NSURL* url=[[DataContext sharedInstance]getUrl: [self urlpath]];
    [[DataContext sharedInstance] fetchURL:url
                                   success:^(id items, BOOL finished){
                                       self.newsArray = [items objectForKey:@"news"];
                                       [self initTableView];
                                   }
                                   failure:^(NSError* error){
                                       
                                   }
     ];
     [_refreshHeaderView refreshLastUpdatedDate];
}

- (void)initTableView
{
    if (tblView == nil) {
        tblView = [[UITableView alloc] initWithFrame:TABLEVIEWFRAME];//CGRectMake(0, 0, 320 , 460)
        tblView.delegate = self;
        tblView.dataSource = self;
        tblView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        tblView.separatorColor = [UIColor clearColor];
        [tblView setBackgroundColor:[UIColor clearColor]];
        
        [self.view addSubview:tblView];
        if (_refreshHeaderView == nil) {
            
            EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - tblView.bounds.size.height, self.view.frame.size.width, tblView.bounds.size.height)];
            view.delegate = self;
            [tblView addSubview:view];
            _refreshHeaderView = view;
            [view release];
            
        }
    }
    else
    {
        [tblView reloadData];
        
    }
    
    
}

- (void)showNavigationView
{
    if (bgView == nil) {
        bgView = [[UIView alloc] initWithFrame:NAVIGATIONVIEWFRAME];
        [bgView setBackgroundColor:[UIColor blackColor]];
        [self.view addSubview:bgView];
        
        UIImageView *bgImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
        [bgImage setImage:[UIImage imageNamed:@"nav-bg"]];
        [bgView addSubview:bgImage];
        [bgImage release];
        
        UIButton *leftBt = [UIButton buttonWithType:UIButtonTypeCustom];
        [leftBt setFrame:CGRectMake(7, 2, 40, 40)];
        [leftBt setBackgroundColor:[UIColor clearColor]];
        [leftBt setImage:[UIImage imageNamed:@"nav-left"] forState:UIControlStateNormal];
        //  [leftBt setImage:[UIImage imageNamed:@"nav-left-ed"] forState:UIControlStateHighlighted];
        [leftBt addTarget:self action:@selector(clickLeftBt) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:leftBt];
        
        
        UILabel *titleView=[[UILabel alloc] initWithFrame:CGRectMake(128, 2, 160, 40)];
        titleView.text=[self title];
        [titleView setFont:[UIFont boldSystemFontOfSize:20]];
        titleView.backgroundColor=[UIColor clearColor];
        titleView.textColor=[UIColor whiteColor];
        [bgView addSubview:titleView];
        [titleView release];
        
        
        
        UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(0, bgView.bounds.size.height - 1, 320, 1)];
        [line setImage:[UIImage imageNamed:@"line"]];
        [bgView addSubview:line];
        [line release];
    }
    
}
- (void)clickLeftBt
{
    [theApp._viewController showLeftView:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 150;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [self.newsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString * cellStr = [NSString stringWithFormat:@"cell%d", indexPath.row];
    ArticleCell * cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
    if (!cell)
    {
        cell = [[[ArticleCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellStr] autorelease];
    }
    Article* art = [self.newsArray objectAtIndex:indexPath.row];
    [cell setArticle:art];
    [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    [cell.textLabel setText:art.title];
    [cell.detailTextLabel setText:art.time];
    NSURL* imageURL = [NSURL URLWithString:art.img];
    [cell.titleImageView setImageWithURL:imageURL];
    [cell setSelectedBackgroundView:[[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"didCellBg"]]autorelease]];
    
    return cell;
    
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
    Article* article = [self.newsArray objectAtIndex:indexPath.row];
    ArticleDetailViewController *articleDetailsViewCrl = [[ArticleDetailViewController alloc] initWithNibName:@"ArticleView" bundle:nil];
    [articleDetailsViewCrl setArticle:article];
    [articleDetailsViewCrl setHidesBottomBarWhenPushed:YES];
    [theApp._viewController pushViewController:articleDetailsViewCrl animated:YES];
    
    [articleDetailsViewCrl release];
}

#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource{
	_reloading = YES;
	//  should be calling your tableviews data source model to reload
	//  put here just for demo
    NSURL* url=[[DataContext sharedInstance]getUrl: [self urlpath]];
    [[DataContext sharedInstance] fetchURL:url
                                   success:^(id items, BOOL finished){
                                       self.newsArray = [items objectForKey:@"news"];
                                   }
                                   failure:^(NSError* error){
                                       
                                   }
     ];

    
    [self doneLoadingTableViewData];
	
}

- (void)doneLoadingTableViewData{
	
	//  model should call this when its done loading
	_reloading = NO;
    [tblView reloadData];
	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:tblView];
	
}


#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
	
	[_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	
	[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
	
}


#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
	
	[self reloadTableViewDataSource];
	[self performSelector:@selector(doneLoadingTableViewData) withObject:self.newsArray afterDelay:1.0];
	
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	
	return _reloading; // should return if data source model is reloading
	
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	
	return [NSDate date]; // should return date data source was last changed
	
}






@end
