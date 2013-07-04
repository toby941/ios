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
#import "MyImagePickerMutilSelector.h"


@interface MatchFirstViewController ()
#define TABLEVIEWFRAME      CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y, self.view.bounds.size.width,  self.view.bounds.size.height-90)
#define HEADVIEWFRAME      CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y+ self.view.bounds.size.height-90, self.view.bounds.size.width,  44)
#define TAG_TEMA_CLEAR 1
#define TAG_POINT_CLEAR 2
@end

@implementation MatchFirstViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"0";
        
        //  self.tabBarItem.image = [UIImage imageNamed:@"first"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    headView=[[UIView alloc] initWithFrame:HEADVIEWFRAME];
    headView.backgroundColor=[UIColor redColor];
    
    selectPersonButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [selectPersonButton setFrame:CGRectMake(self.view.bounds.origin.x+6, self.view.bounds.origin.y, 65,  40)];
    [selectPersonButton addTarget:self action:@selector(pickMutilImage:) forControlEvents:UIControlEventTouchUpInside];
    [selectPersonButton setTitle:NSLocalizedString(@"choose", @"choose")
 forState:UIControlStateNormal];
    
    clearButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [clearButton setFrame:CGRectMake(self.view.bounds.origin.x+250, self.view.bounds.origin.y, 65,  40)];
    [clearButton addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    [clearButton setTitle:NSLocalizedString(@"clearpoint", @"clearpoint") forState:UIControlStateNormal];
    
    
    clearTableViewButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [clearTableViewButton setFrame:CGRectMake(self.view.bounds.origin.x+88, self.view.bounds.origin.y, 65,  40)];
    [clearTableViewButton addTarget:self action:@selector(clearTeambuttonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    [clearTableViewButton setTitle:NSLocalizedString(@"clearteam", @"clearpoint") forState:UIControlStateNormal];
    
    
    saveButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [saveButton setFrame:CGRectMake(self.view.bounds.origin.x+169, self.view.bounds.origin.y, 65,  40)];
    [saveButton addTarget:self action:@selector(saveResult2:) forControlEvents:UIControlEventTouchUpInside];
    
    [saveButton setTitle:NSLocalizedString(@"save", @"save") forState:UIControlStateNormal];
    
    
    [headView addSubview:clearButton];
    [headView addSubview:selectPersonButton];
    [headView addSubview:clearTableViewButton];
    [headView addSubview:saveButton];
    [self.view addSubview:headView];
    [self initTableView];
    
	// Do any additional setup after loading the view, typically from a nib.
}
-(IBAction) buttonTapped:(id) sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"clearpoint", @"clearpoint")
                                                    message:NSLocalizedString(@"alerttitlepoint", @"alerttitlepoint")
                                                   delegate:self
                                          cancelButtonTitle:NSLocalizedString(@"cancel", @"cancel")
                                          otherButtonTitles:NSLocalizedString(@"clearpointBtn", @"clearpointBtn"), nil];
    alert.tag=TAG_POINT_CLEAR;
    [alert show];
    [alert release];
}

-(IBAction) clearTeambuttonTapped:(id) sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"clearteam", @"clearteam")
                                                    message:NSLocalizedString(@"alerttitleteam", @"alerttitleteam")
                                                   delegate:self
                                          cancelButtonTitle:NSLocalizedString(@"cancel", @"cancel")
                                          otherButtonTitles:NSLocalizedString(@"clearteamBtn", @"clearteamBtn"), nil];
    alert.tag=TAG_TEMA_CLEAR;
    [alert show];
    [alert release];
}


-(void)alertView:(UIAlertView*) alertView didDismissWithButtonIndex:(NSInteger) buttonIndex {
    
    if(buttonIndex != [alertView cancelButtonIndex]) {
        if(alertView.tag==TAG_POINT_CLEAR){
            [self clearCell];
        }else{
            [self clearTeam];
        }
        
    }
}

-(void) clearTeam{
    _summaryPerson=nil;
    _personArray=nil;
    self.title=@"0";
    [tblView reloadData];
}


- (void)clearCell{
    [_summaryPerson clear];
    for (Person* p in _personArray) {
        [p clear];
    }
    self.title=@"0";
    [tblView reloadData];
}

-(IBAction) saveResult:(id)sender{
    //支持retian高分辨率
    
    UIGraphicsBeginImageContextWithOptions(tblView.frame.size, YES, 0.0);
    
    float curH = tblView.contentSize.height;
    
    UIImageView *allView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, curH)];
    
    for (float f = 0; f < curH; f+=400)
    {
        tblView.contentOffset = CGPointMake(0, f);
        [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImageView *imgV = [[UIImageView alloc]initWithImage:UIGraphicsGetImageFromCurrentImageContext()];
        
        imgV.frame = CGRectMake(0, f, 320, 400);
        [allView addSubview:imgV];
        [imgV release];
    }
    
    UIGraphicsEndImageContext();
    
    //保存图片
    UIGraphicsBeginImageContextWithOptions(allView.frame.size, YES, 0.0);
    [allView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [allView release];
    UIImageWriteToSavedPhotosAlbum(img, nil, nil, nil);
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"saveImgTitle", @"saveImgTitle")
                                                    message:NSLocalizedString(@"saveImg", @"saveImg")
                                                   delegate:self
                                          cancelButtonTitle:NSLocalizedString(@"ok", @"ok")
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];
}



-(IBAction) saveResult2:(id)sender{
    //支持retian高分辨率
    
    UIGraphicsBeginImageContextWithOptions(tblView.frame.size, YES, 0.0);
    
    float curH = tblView.contentSize.height;
    
    UIImageView *allView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, curH)];
    
    int f=0;
    tblView.contentOffset = CGPointMake(0, f);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImageView *imgV = [[UIImageView alloc]initWithImage:UIGraphicsGetImageFromCurrentImageContext()];
    
    imgV.frame = CGRectMake(0, f, 320, 420);
    [allView addSubview:imgV];
    [imgV release];
    
    f=f+420;
    tblView.contentOffset = CGPointMake(0, f);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    imgV = [[UIImageView alloc]initWithImage:UIGraphicsGetImageFromCurrentImageContext()];
    
    imgV.frame = CGRectMake(0, f, 320, 420);
    [allView addSubview:imgV];
    [imgV release];
    
    
    f=f+400;
    tblView.contentOffset = CGPointMake(0, f);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    imgV = [[UIImageView alloc]initWithImage:UIGraphicsGetImageFromCurrentImageContext()];
    
    imgV.frame = CGRectMake(0, f, 320, 400);
    [allView addSubview:imgV];
    [imgV release];
    
    
    UIGraphicsEndImageContext();
    
    //保存图片
    UIGraphicsBeginImageContextWithOptions(allView.frame.size, YES, 0.0);
    [allView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [allView release];
    UIImageWriteToSavedPhotosAlbum(img, nil, nil, nil);
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"saveImgTitle", @"saveImgTitle")
                                                    message:NSLocalizedString(@"saveImg", @"saveImg")
                                                   delegate:self
                                          cancelButtonTitle:NSLocalizedString(@"ok", @"ok")
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];

}





-(IBAction) pickMutilImage:(id)sender
{
    
    
    MyImagePickerMutilSelector* imagePickerMutilSelector= [[MyImagePickerMutilSelector alloc] initWithPhotoList:_selectedList];//自动释放
    imagePickerMutilSelector.delegate=self;//设置代理
    
   
    imagePickerMutilSelector.teamTitle=_summaryPerson.name;
    
    
    UIImagePickerController* picker=[[UIImagePickerController alloc] init];
    picker.delegate=imagePickerMutilSelector;//将UIImagePicker的代理指向到imagePickerMutilSelector
    [picker setAllowsEditing:NO];
    picker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
    picker.modalTransitionStyle= UIModalTransitionStyleCoverVertical;
    picker.navigationController.delegate=imagePickerMutilSelector;//将UIImagePicker的导航代理指向到imagePickerMutilSelector
    
    imagePickerMutilSelector.imagePicker=picker;//使imagePickerMutilSelector得知其控制的UIImagePicker实例，为释放时需要。
    
    [self presentModalViewController:picker animated:YES];
    [picker release];
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
        return _personArray.count;
    }
	
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if(section==0){
        return NSLocalizedString(@"sum", @"sum");
    }else{
        return NSLocalizedString(@"person", @"person");
    }
    
}

-(void)imagePickerMutilSelectorDidGetImages:(PeopleList*)peopleList;
{
    
    PeopleList* importList=peopleList;
    if(_summaryPerson==nil){
        Person *p= [[Person alloc]init];
        p.name=importList.name;
        _summaryPerson=p;
        self.title =importList.name;
    }
  
    
    
    
    
    if(_personArray==nil){
        self.personArray=[[NSMutableArray alloc] init];
    }
    for(int i=0;i<importList.pics.count;i++){
        Person *p= [[Person alloc]init];
        p.picImage=importList.pics[i];
        [self.personArray addObject:p];
    }
    
    //    if(_selectedList==nil){
    //        [self addRecord:importList];
    //    }else{
    //        [self updateRecord:importList];
    //    }
    //    _selectedList=nil;
    //    [self refreshItem];
    [tblView reloadData];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSInteger section=indexPath.section;
    
    
    static NSString *CellIdentifier = @"CustomCell";
    
    Cell *cell = (Cell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil||(cell.isManinCell&&section!=0)) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"Cell" owner:self options:nil];
        cell = (Cell *)[nib objectAtIndex:0];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        [cell initButton];
    }
    
    NSString* path=nil;
    if(section==0){
        path= [NSString stringWithFormat:@"%d.png" ,indexPath.row+1];
        [cell setIsManinCell:TRUE];
        [cell setP:_summaryPerson];
        [cell setTeamName: self.summaryPerson.name];
    }else{
        path= [NSString stringWithFormat:@"%d.jpeg" ,indexPath.row+1];
        cell.delegate=self;
        [cell setIsManinCell:FALSE];
        
        Person* p = [self.personArray objectAtIndex:indexPath.row];
        [cell setP:p];
        
    }
    
    [cell setCustomIcon:path];
    
    return cell;
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void) callChangeValue:(Person*)p{
    Cell* summaryCell=[tblView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    [_summaryPerson update:p];
    [summaryCell updateByAnotherPerson:p];
    self.title=summaryCell.pts.text;
    
}
@end
