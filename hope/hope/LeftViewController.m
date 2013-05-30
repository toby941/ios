//
//  LeftViewController.m
//  右侧导航栏
//
//  Created by toby on 13-4-12.
//  Copyright (c) 2013年 toby. All rights reserved.
//

#import "LeftViewController.h"
#import "ArticleListController.h"
#import "hopeAppDelegate.h"
#import "Menu.h"
#import "MenuCell.h"
#import "ListViewController.h"


@interface LeftViewController (){
}
@end

@implementation LeftViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - uitableview datasource methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
	return [[self menuList] count];
}

- (void) initMenu
{
    NSString *dataPath = [[NSBundle mainBundle]pathForResource:@"menu.plist" ofType:nil];
    NSMutableArray  *menuArray = [NSMutableArray arrayWithContentsOfFile:dataPath];
    self.menuList=[NSMutableArray arrayWithCapacity:10];
    for (NSDictionary* menuDict in menuArray) {
        Menu* menu = [[Menu alloc] initWithDictionary:menuDict];
        [[self menuList] addObject:menu];
        [menu release];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    [bgImageView setImage:[UIImage imageNamed:@"bg"]];
    [self.view addSubview:bgImageView];
    [self initMenu];
    
    //  _tblView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];//CGRectMake(0, 0, 320 , 460)
    //控制tabview最后一行cell紧贴footer
    _tblView = [[UITableView alloc] initWithFrame:CGRectMake(self.view.bounds.origin.x, self.view.bounds.size.height-_menuList.count*50 , self.view.bounds.size.width , self.view.bounds.size.height) style:UITableViewStylePlain];
    _tblView.delegate = self;
    _tblView.dataSource = self;
    //    _tblView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tblView.separatorColor = [UIColor clearColor];
    [_tblView setBackgroundColor:[UIColor clearColor]];
    _tblView.scrollEnabled=NO;
    [self.view addSubview:_tblView];
    [_tblView reloadData];
    [NSThread sleepForTimeInterval:1.8];   //设置进程暂停 显示lanuch image
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString * cellStr = [NSString stringWithFormat:@"cell%d", indexPath.row];
    MenuCell * cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
    if (!cell)
    {
        cell = [[[MenuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellStr] autorelease];
    }
    
    Menu* menu = [self.menuList objectAtIndex:indexPath.row];
    [cell setMenu:menu];
    [cell setSelectionStyle:UITableViewCellSelectionStyleBlue];
    [cell.textLabel setText:menu.name];
    //    [cell.selectedBackgroundView setBackgroundColor:[UIColor blueColor]];
    
    //    NSURL* imageURL = [NSURL URLWithString:menu.imgsrc];
    //  [cell.titleImageView setImageWithURL:imageURL];
    // [cell setSelectedBackgroundView:[[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"didCellBg"]]autorelease]];
    return cell;
    
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 50;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    // [self initMenu];
    
    Menu *menu=[[self menuList] objectAtIndex:indexPath.row];
    NSString* url=menu.path;
    ListViewController *viewController=[[ListViewController alloc]init];
    [viewController setPath:url];
    [viewController setPage:1];
    [viewController setTitle:menu.name];
    [theApp._viewController showViewController:viewController animated:YES];
    [viewController release];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
