//
//  HomeViewController.m
//  hope
//
//  Created by toby on 13-4-12.
//  Copyright (c) 2013年 toby. All rights reserved.
//

#import "HomeViewController.h"
#import<QuartzCore/QuartzCore.h>
#import "DataContext.h"
#import "Article.h"
#import "ArticleCell.h"
#import "ArticleDetailViewController.h"
#import "hopeAppDelegate.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "TableFooterView.h"
#import "STableViewController.h"

@interface HomeViewController ()
#define NAVIGATIONVIEWFRAME      CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y, self.view.bounds.size.width,  44)
#define TABLEVIEWFRAME      CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y+44, self.view.bounds.size.width,  self.view.bounds.size.height)
// Private helper methods
- (void) addItemsOnTop;
- (void) addItemsOnBottom;
- (NSString *) createRandomValue;
@end

@implementation HomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
      
  //  self.view.backgroundColor = [UIColor blackColor];
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    [bgImageView setImage:[UIImage imageNamed:@"bg"]];
 
       
    NSURL* url=[[DataContext sharedInstance] urlFor:URLIndex];
    [[DataContext sharedInstance] fetchURL:url
                                   success:^(id items, BOOL finished){
                                       self.newsArray = [items objectForKey:@"news"];
                                       [self initTableView];
                                   }
                                   failure:^(NSError* error){
                                       
                                   }
     ];

    //UIView设置阴影
    //    [[bgImageView layer] setShadowOffset:CGSizeMake(10, 10)];
    //    [[bgImageView layer] setShadowRadius:20];
    //    [[bgImageView layer] setShadowOpacity:1];
    //    [[bgImageView layer] setShadowColor:[UIColor blackColor].CGColor];
    
    
    //设置阴影
    bgImageView.layer.shadowColor = [UIColor blackColor].CGColor;
    bgImageView.layer.shadowOpacity = 1;
    bgImageView.layer.shadowRadius = 10;
    bgImageView.layer.shadowOffset = CGSizeMake(1, 11);
    bgImageView.clipsToBounds = NO;
    
    //UIView设置边框
    [[bgImageView layer] setCornerRadius:10];
    [[bgImageView layer] setBorderWidth:2];
    [[bgImageView layer] setBorderColor:[UIColor blackColor].CGColor];
    
    [self.view addSubview:bgImageView];
    [self showNavigationView];
    
    // set the custom view for "load more". See TableFooterView.xib.
      NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TableFooterView" owner:self options:nil];
    TableFooterView *footerView = (TableFooterView *)[nib objectAtIndex:0];
    self.footerView = footerView;

    
    [_refreshHeaderView refreshLastUpdatedDate];
}

- (void)initTableView
{
    
    if (self.tableView == nil) {
        self.tableView = [[UITableView alloc] initWithFrame:TABLEVIEWFRAME];//CGRectMake(0, 0, 320 , 460)
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        self.tableView.separatorColor = [UIColor clearColor];
        [self.tableView setBackgroundColor:[UIColor clearColor]];
        
        [self.view addSubview:self.tableView];
        if (_refreshHeaderView == nil) {
            
            EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.tableView.bounds.size.height, self.view.frame.size.width, self.tableView.bounds.size.height)];
            view.delegate = self;
            [self.tableView addSubview:view];
            _refreshHeaderView = view;
            [view release];
            
        }
    }
    else
    {
        [self.tableView reloadData];
    }
}


- (void)showNavigationView
{
    if (bgView == nil) {
        bgView = [[UIView alloc] initWithFrame:NAVIGATIONVIEWFRAME];
        [bgView setBackgroundColor:[UIColor clearColor]];
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
        
     
        UILabel *title=[[UILabel alloc] initWithFrame:CGRectMake(128, 2, 160, 40)];
        title.text=@"首页";
        [title setFont:[UIFont boldSystemFontOfSize:20]];
        title.backgroundColor=[UIColor clearColor];
        title.textColor=[UIColor whiteColor];
        [bgView addSubview:title];
        
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    return 150;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    
	return [self.newsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
        NSString * cellStr = @"cell";
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
//    ArticleDetailViewController *articleDetailsViewCrl = [[ArticleDetailViewController alloc] init];
    
        [articleDetailsViewCrl setArticle:article];
        [articleDetailsViewCrl setHidesBottomBarWhenPushed:YES];
       // [theApp.viewController showViewController:articleDetailsViewCrl animated:YES];
//      [self.navigationController pushViewController:articleDetailsViewCrl animated:YES];
    [theApp._viewController pushViewController:articleDetailsViewCrl animated:YES];
    
        [articleDetailsViewCrl release];
   
}

- (void)doneLoadingTableViewData{
	
	//  model should call this when its done loading
	_reloading = NO;
    [self.tableView reloadData];
	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
	
}


#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
	
    [super scrollViewDidScroll:scrollView];
	[_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	
    [super scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    
	[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
	
}


#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods
- (void)reloadTableViewDataSource{
	_reloading = YES;
	//  should be calling your tableviews data source model to reload
	//  put here just for demo
    NSURL* url=[[DataContext sharedInstance] urlFor:URLIndex];
    [[DataContext sharedInstance] fetchURL:url
                                   success:^(id items, BOOL finished){
                                       self.newsArray = [items objectForKey:@"news"];
                                   }
                                   failure:^(NSError* error){
                                       
                                   }
     ];
    
    
    [self doneLoadingTableViewData];
	
}


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

#pragma mark - Load More

////////////////////////////////////////////////////////////////////////////////////////////////////
//
// The method -loadMore was called and will begin fetching data for the next page (more).
// Do custom handling of -footerView if you need to.
//
- (void) willBeginLoadingMore
{
    
    NSLog(@"willBeginLoadingMore");
    TableFooterView *fv = (TableFooterView *)self.footerView;
    [fv.activityIndicator startAnimating];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
//
// Do UI handling after the "load more" process was completed. In this example, -footerView will
// show a "No more items to load" text.
//
- (void) loadMoreCompleted
{
    NSLog(@"loadMoreCompleted");
    
    [super loadMoreCompleted];
    
    TableFooterView *fv = (TableFooterView *)self.footerView;
    [fv.activityIndicator stopAnimating];
    
    if (!self.canLoadMore) {
        // Do something if there are no more items to load
        
        // We can hide the footerView by: [self setFooterViewVisibility:NO];
        
        // Just show a textual info that there are no more items to load
        fv.infoLabel.hidden = NO;
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL) loadMore
{
    
    NSLog(@"load more");
    if (![super loadMore])
        return NO;
    NSArray* array=nil;
    NSURL* url=[[DataContext sharedInstance] urlFor:URLIndex];
    [[DataContext sharedInstance] fetchURL:url
                                   success:^(id items, BOOL finished){
                                   NSArray* array = [items objectForKey:@"news"];
                        // Do your async loading here
                                       [self addItemsOnBottom:array];

                                   }
                                   failure:^(NSError* error){
                                       
                                   }
     ];

    
    
    
       // See -addItemsOnBottom for more info on what to do after loading more items
    
    return YES;
}

- (void) addItemsOnBottom:(NSArray*) array
{
    for (int i = 0; i < array.count; i++)
        [self.newsArray addObject:[array objectAtIndex:i]];
    
    [self.tableView reloadData];
    
    if (self.newsArray.count > 50)
        self.canLoadMore = NO; // signal that there won't be any more items to load
    else
        self.canLoadMore = YES;
    
    // Inform STableViewController that we have finished loading more items
    [self loadMoreCompleted];
}
@end
