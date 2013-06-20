//
//  ListViewController.m
//  hope
//
//  Created by toby on 13-5-10.
//  Copyright (c) 2013年 toby. All rights reserved.
//

#import "ListViewController.h"
#import "TableFooterView.h"
#import "TableHeaderView.h"
#import "DataContext.h"
#import "ArticleCell.h"
#import "hopeAppDelegate.h"
#import "Article.h"
#import "Utils.h"

#import<QuartzCore/QuartzCore.h>
#import "ArticleDetailViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "STableViewController.h"


@interface ListViewController ()
#define NAVIGATIONVIEWFRAME      CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y, self.view.bounds.size.width,  44)
#define TABLEVIEWFRAME      CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y+44, self.view.bounds.size.width,  self.view.bounds.size.height)
#define HOME_API @"/api/hope/news/category/0?page=%d"
// Private helper methods
- (void) addItemsOnTop;
- (void) addItemsOnBottom;
@end

@implementation ListViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.page=0;
        self.path=HOME_API;
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
    self.page=0;
    [self.tableView setBackgroundColor:[UIColor lightGrayColor]];
    
    
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    [bgImageView setImage:[UIImage imageNamed:@"bg.png"]];
    
    
    NSURL* url=[[DataContext sharedInstance] getUrl:self.path page:self.page];
    [[DataContext sharedInstance] fetchURL:url
                                   success:^(id result, BOOL finished){
                                       self.items = [result objectForKey:@"news"];
                                       [self initTableView];
                                   }
                                   failure:^(NSError* error){
                                       
                                   }
     ];
    
    
    //设置阴影
    bgImageView.layer.shadowColor = [UIColor blackColor].CGColor;
    bgImageView.layer.shadowOpacity = 1;
    bgImageView.layer.shadowRadius = 10;
    bgImageView.layer.shadowOffset = CGSizeMake(1, 11);
    bgImageView.clipsToBounds = NO;
    
    //UIView设置边框
   // [[bgImageView layer] setCornerRadius:10];
    [[bgImageView layer] setBorderWidth:2];
    [[bgImageView layer] setBorderColor:[UIColor blackColor].CGColor];
    
    [self.view addSubview:bgImageView];
    
    
    [self showNavigationView];
    
    
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
        // set the custom view for "pull to refresh". See DemoTableHeaderView.xib.
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TableHeaderView" owner:self options:nil];
        TableHeaderView *headerView = (TableHeaderView *)[nib objectAtIndex:0];
        self.headerView = headerView;
        
        
        nib = [[NSBundle mainBundle] loadNibNamed:@"TableFooterView" owner:self options:nil];
        TableFooterView *footerView = (TableFooterView *)[nib objectAtIndex:0];
        self.footerView = footerView;
        
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
        if(self.title==nil){
            title.text=@"首页";
        }else{
            title.text=self.title;
        }
        
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 150;
}
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Pull to Refresh

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void) pinHeaderView
{
    [super pinHeaderView];
    
    // do custom handling for the header view
    TableHeaderView *hv = (TableHeaderView *)self.headerView;
    [hv.activityIndicator startAnimating];
    hv.title.text = NSLocalizedString( @"Loading...", @"Pull down to refresh");
}


- (void) unpinHeaderView
{
    [super unpinHeaderView];
    
    // do custom handling for the header view
    [[(TableHeaderView *)self.headerView activityIndicator] stopAnimating];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
//
// Update the header text while the user is dragging
//
- (void) headerViewDidScroll:(BOOL)willRefreshOnRelease scrollView:(UIScrollView *)scrollView
{
    TableHeaderView *hv = (TableHeaderView *)self.headerView;
    if (willRefreshOnRelease)
        hv.title.text =  NSLocalizedString(@"Release to refresh...", @"Pull down to refresh status");
    else
        hv.title.text = NSLocalizedString(@"Pull down to refresh...", @"Pull down to refresh");
}

////////////////////////////////////////////////////////////////////////////////////////////////////
//
// refresh the list. Do your async calls here.
//
- (BOOL) refresh
{
    if (![super refresh])
        return NO;
    self.page=1;
    // Do your async call here
    NSURL* url=[[DataContext sharedInstance] getUrl:self.path page:(self.page)];
    [[DataContext sharedInstance] fetchURL:url
                                   success:^(id items, BOOL finished){
                                       self.items = [items objectForKey:@"news"];
                                       [self performSelector:@selector(addItemsOnTop) withObject:nil afterDelay:2.0];
                                   }
                                   failure:^(NSError* error){
                                       
                                   }
     ];
    
    
    
    // This is just a dummy data loader:
    
    // See -addItemsOnTop for more info on how to finish loading
    return YES;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Load More

////////////////////////////////////////////////////////////////////////////////////////////////////
//
// The method -loadMore was called and will begin fetching data for the next page (more).
// Do custom handling of -footerView if you need to.
//
- (void) willBeginLoadingMore
{
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
    if (![super loadMore])
        return NO;
    
    self.page=self.page+1;
    //NSLog(@"page  size:%d",self.page);
    
    NSURL* url=[[DataContext sharedInstance] getUrl:self.path page:(self.page)];
    [[DataContext sharedInstance] fetchURL:url
                                   success:^(id items, BOOL finished){
                                       NSArray* array = [items objectForKey:@"news"];
                                       // Do your async loading here
                                       [self addItemsOnBottom:array];
                                       
                                   }
                                   failure:^(NSError* error){
                                       
                                       UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:[error localizedDescription] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                                       alert.alertViewStyle=UIAlertViewStyleDefault;
                                       [alert show];
                                       
                                   }
     ];
    return YES;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Dummy data methods

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void) addItemsOnTop
{
    [self.tableView reloadData];
    
    // Call this to indicate that we have finished "refreshing".
    // This will then result in the headerView being unpinned (-unpinHeaderView will be called).
    [self refreshCompleted];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void) addItemsOnBottom:(NSArray*)array
{
    for (int i = 0; i < array.count; i++)
        [self.items addObject:[array objectAtIndex:i]];
    
    [self.tableView reloadData];
    
    if (self.items.count > 50)
        self.canLoadMore = NO; // signal that there won't be any more items to load
    else
        self.canLoadMore = YES;
    
    // Inform STableViewController that we have finished loading more items
    [self loadMoreCompleted];
}



#pragma mark - Standard TableView delegates

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if(!self.items|| [self.items count]==0 ){
        return 0;
    }
    NSInteger count=self.items.count;
    return count;
    
}


- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * cellStr = @"cell";
    ArticleCell * cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
    if (!cell)
    {
        cell = [[[ArticleCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellStr] autorelease];
    }
    Article* art = [self.items objectAtIndex:indexPath.row];
    [cell setArticle:art];
    [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    [cell.textLabel setText:art.title];
    [cell.detailTextLabel setText:art.time];
   
//    if([Utils isEmptyOrNull:art.img]){
//        NSLog(@"art img:%@",art.img);
//        NSURL* imageURL = [NSURL URLWithString:@"http://media.pubsage.com/media/news/20130520/635046563281516799.jpg"];
//        [cell.titleImageView setImageWithURL:imageURL];
//        
//    }else{
//        NSURL* imageURL = [NSURL URLWithString:@"http://media.pubsage.com/media/news/20130520/635046563281516799.jpg"];
//        //NSURL* imageURL = [NSURL URLWithString:art.img];
//        [cell.titleImageView setImageWithURL:imageURL];
//    }
    [cell setSelectedBackgroundView:[[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"didCellBg"]]autorelease]];
    return cell;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
    Article* article = [self.items objectAtIndex:indexPath.row];
    ArticleDetailViewController *articleDetailsViewCrl = [[ArticleDetailViewController alloc] initWithNibName:@"ArticleView" bundle:nil];
    //    ArticleDetailViewController *articleDetailsViewCrl = [[ArticleDetailViewController alloc] init];
    
    [articleDetailsViewCrl setArticle:article];
    [articleDetailsViewCrl setHidesBottomBarWhenPushed:YES];
    // [theApp.viewController showViewController:articleDetailsViewCrl animated:YES];
    //      [self.navigationController pushViewController:articleDetailsViewCrl animated:YES];
    [theApp._viewController pushViewController:articleDetailsViewCrl animated:YES];
    
    [articleDetailsViewCrl release];
    
}



@end
