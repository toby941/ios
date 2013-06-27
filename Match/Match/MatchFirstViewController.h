//
//  MatchFirstViewController.h
//  Match
//
//  Created by toby on 13-6-13.
//  Copyright (c) 2013年 toby. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Cell.h"
#import "MyImagePickerMutilSelector.h"
#import "PeopleList.h"

@class QBPopupMenu;
@protocol MatchFirstViewController;
@interface MatchFirstViewController : UIViewController<MyImagePickerMutilSelectorDelegate,UITableViewDataSource, UITableViewDelegate,callChangeDelegate>
{
    UITableView *tblView;
    UIView *headView;
    UIButton *clearButton;
    UIButton *clearTableViewButton;
     UIButton *saveButton;
    UIButton *selectPersonButton;
}
@property (nonatomic, assign)id <MatchFirstViewController> delegate;

@property (nonatomic, assign) NSInteger point;

@property (nonatomic, strong) NSMutableArray* personArray;
@property (atomic,strong) Person* summaryPerson;
@property (nonatomic, retain) QBPopupMenu *popupMenu;
@property (strong,atomic) PeopleList *selectedList;

@end
