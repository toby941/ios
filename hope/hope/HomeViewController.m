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


@interface HomeViewController ()
#define NAVIGATIONVIEWFRAME      CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y, self.view.bounds.size.width,  44)
#define TABLEVIEWFRAME      CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y+44, self.view.bounds.size.width,  self.view.bounds.size.height)

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
 
    //UIView设置阴影
    [[bgImageView layer] setShadowOffset:CGSizeMake(10, 10)];
    [[bgImageView layer] setShadowRadius:20];
    [[bgImageView layer] setShadowOpacity:1];
    [[bgImageView layer] setShadowColor:[UIColor blackColor].CGColor];
    
    //UIView设置边框
    [[bgImageView layer] setCornerRadius:5];
    [[bgImageView layer] setBorderWidth:2];
    [[bgImageView layer] setBorderColor:[UIColor blackColor].CGColor];
    
    [self.view addSubview:bgImageView];
    [self showNavigationView];

    NSURL* url=[[DataContext sharedInstance] urlFor:URLIndex];
    [[DataContext sharedInstance] fetchURL:url
                                   success:^(id items, BOOL finished){
                                       self.newsArray = [items objectForKey:@"news"];
                                       [self initTableView];
                                   }
                                   failure:^(NSError* error){
                                       
                                   }
     ];

 
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
        [leftBt setImage:[UIImage imageNamed:@"nav-left-ed"] forState:UIControlStateHighlighted];
        [leftBt addTarget:self action:@selector(clickLeftBt) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:leftBt];
        
     
        
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    
	return [self.newsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
        static NSString * cellStr = @"cell";
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




@end
