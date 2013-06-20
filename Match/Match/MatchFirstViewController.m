//
//  MatchFirstViewController.m
//  Match
//
//  Created by toby on 13-6-13.
//  Copyright (c) 2013年 toby. All rights reserved.
//

#import "MatchFirstViewController.h"
#import "Cell.h"
#import "QBPopupMenu.h"
#import "Person.h"
@interface MatchFirstViewController ()
#define TABLEVIEWFRAME      CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y+44, self.view.bounds.size.width,  self.view.bounds.size.height)
@end

@implementation MatchFirstViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"First", @"First");
        self.tabBarItem.image = [UIImage imageNamed:@"first"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initTableView];
    
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)initTableView
{
    if (tblView == nil) {
        tblView = [[UITableView alloc] initWithFrame:TABLEVIEWFRAME style:UITableViewStylePlain];//CGRectMake(0, 0, 320 , 460)
        tblView.delegate = self;
        tblView.dataSource = self;
        tblView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        tblView.separatorColor = [UIColor blackColor];
        // [tblView setBackgroundColor:[UIColor clearColor]];
        
        
        
        
        
        [self.view addSubview:tblView];
        
    }
    else
    {
        [tblView reloadData];
        
    }
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 80;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section==0){
        return 1;
    }else{
        return 5;
    }
	
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if(section==0){
        return @"总计";
    }else{
        return @"个人";
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSInteger section=indexPath.section;
    
    static NSString *CellIdentifier = @"CustomCell";
    
    Cell *cell = (Cell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"Cell" owner:self options:nil];
        cell = (Cell *)[nib objectAtIndex:0];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    NSString* path=nil;
    if(section==0){
        path= [NSString stringWithFormat:@"%d.png" ,indexPath.row+1];
        [cell setIsManinCell:TRUE];
    }else{
        path= [NSString stringWithFormat:@"%d.jpeg" ,indexPath.row+1];
        cell.delegate=self;
    }
    
    [cell setCustomIcon:path];
    [cell initButton];
    return cell;
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void) callChangeValue:(Person*)p{
    Cell* summaryCell=[tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    [summaryCell updateByAnotherPerson:p];
    
    
}
@end
