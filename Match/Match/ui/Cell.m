//
//  Cell.m
//  Match
//
//  Created by toby on 13-6-15.
//  Copyright (c) 2013年 toby. All rights reserved.
//

#import "Cell.h"
#import "QBPopupMenu.h"
#import "Person.h"
@implementation Cell


@synthesize blk;//篮板球
@synthesize ast;//助攻
@synthesize ft;//罚球次数
@synthesize pf;//犯规次数
@synthesize  threepm;//三分球
@synthesize fg;//投篮
@synthesize  st;
@synthesize  pts;
@synthesize icon;
@synthesize isManinCell;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

- (void) initButton{
    // popupMenu
    QBPopupMenu *popupMenu = [[QBPopupMenu alloc] init];
    
    QBPopupMenuItem *item1 = [QBPopupMenuItem itemWithTitle:@"+"  target:self action:@selector(add:)];
    item1.width = 64;
    
    QBPopupMenuItem *item2 = [QBPopupMenuItem itemWithTitle:@"-"  target:self action:@selector(reduce:)];
    item2.width = 64;
    
    popupMenu.items = [NSArray arrayWithObjects:item1, item2, nil];
    
    self.popupMenu = popupMenu;
    [popupMenu release];
    
    
    pts.text=@"0";
    [fg setTitle:@"0" forState:UIControlStateNormal]; fg.tag=1;
    [threepm setTitle:@"0" forState:UIControlStateNormal];threepm.tag=2;
    [blk setTitle:@"0" forState:UIControlStateNormal];blk.tag=3;
    [ast setTitle:@"0" forState:UIControlStateNormal];ast.tag=4;
    [st setTitle:@"0" forState:UIControlStateNormal];st.tag=5;
    [ft setTitle:@"0" forState:UIControlStateNormal];ft.tag=6;
    [pf setTitle:@"0" forState:UIControlStateNormal];pf.tag=7;
    
    
    
    if(!isManinCell){
        
        [blk addTarget:self action:@selector(showPopupMenu:) forControlEvents:UIControlEventTouchUpInside];
        [ast addTarget:self action:@selector(showPopupMenu:) forControlEvents:UIControlEventTouchUpInside];
        [ft addTarget:self action:@selector(showPopupMenu:) forControlEvents:UIControlEventTouchUpInside];
        [pf addTarget:self action:@selector(showPopupMenu:) forControlEvents:UIControlEventTouchUpInside];
        [threepm addTarget:self action:@selector(showPopupMenu:) forControlEvents:UIControlEventTouchUpInside]; [fg addTarget:self action:@selector(showPopupMenu:) forControlEvents:UIControlEventTouchUpInside];
        [fg addTarget:self action:@selector(showPopupMenu:) forControlEvents:UIControlEventTouchUpInside];
        [st addTarget:self action:@selector(showPopupMenu:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
}


- (void)layoutSubviews{
    [super layoutSubviews];
    
    
}

- (IBAction)showPopupMenu:(id)sender {
    UIButton *button = (UIButton *)sender;
    self.currentButton=button;
    [self.popupMenu showInView:self atPoint:CGPointMake(button.center.x, button.frame.origin.y)];
}


-(void) updatePts{
    NSInteger fgValue = [[fg currentTitle ] intValue]*2;
    NSInteger threeValue = [[threepm currentTitle] intValue]*3;
    NSInteger ftValue = [[ft currentTitle] intValue];
    
    [pts setText:[NSString stringWithFormat:@"%d",fgValue+threeValue+ftValue]];
    
}

- (void)add:(id)sender
{
    UIButton *button = self.currentButton;
    NSString* value = [button currentTitle];
    NSInteger point= [value intValue ]+1;
    
    [button setTitle:[NSString stringWithFormat: @"%d", point] forState:UIControlStateNormal];
    [self updatePts];
    Person* p= [self makePerson:button.tag targetValue:1];
    if(!isManinCell&&[_delegate respondsToSelector:@selector(callChangeValue:)]){
        [_delegate callChangeValue:p];
    }
    
}

-(Person*)makePerson:(NSInteger)tagValue targetValue:(NSInteger)value{
    Person* p=[[Person alloc]init];
    switch (tagValue) {
        case 1:
            p.fg=value;
            break;
        case 2:
            p.threepm=value;
            break;
        case 3:
            p.blk=value;
            break;
        case 4:
            p.ast=value;
            break;
        case 5:
            p.st=value;
            break;
        case 6:
            p.ft=value;
            break;
        case 7:
            p.pf=value;
            break;
        default:
            break;
            
    }
    return p;
}

-(void) updateByAnotherPerson:(Person*)p{
    UIButton *button =nil;
    NSInteger updateValue=nil;
    if(p.fg!=0){
        button=fg;
        updateValue=p.fg;
    }else if (p.threepm!=0){
        button=threepm;
         updateValue=p.threepm;
    }else if (p.blk!=0){
        button=blk;
         updateValue=p.blk;
    }else if (p.ast!=0){
        button=ast;
         updateValue=p.ast;
    }else if (p.st!=0){
        button=st;
         updateValue=p.st;
    }else if (p.ft!=0){
        button=ft;
         updateValue=p.ft;
    }else if (p.pf!=0){
        button=pf;
         updateValue=p.pf;
    }
    NSString* value = button.currentTitle;
    NSInteger point= [value intValue ];
      point=point+updateValue;
    if (point<0) {
        point=0;
    }
    [button setTitle:[NSString stringWithFormat: @"%d", point] forState:UIControlStateNormal];
    [self updatePts];
}


- (void)reduce:(id)sender
{
    UIButton *button = self.currentButton;
    NSString* value = button.currentTitle;
    NSInteger point= [value intValue ];
    if(point>0){
        point=point-1;
    }
    [button setTitle:[NSString stringWithFormat: @"%d", point] forState:UIControlStateNormal];
    [self updatePts];
    Person* p= [self makePerson:button.tag targetValue:-1];
    if(!isManinCell&&[_delegate respondsToSelector:@selector(callChangeValue:)]){
        [_delegate callChangeValue:p];
    }
    
    
    
}

-(void)setCustomIcon:(NSString*)path{
    [icon setImage:[UIImage imageNamed:path]];
}
@end