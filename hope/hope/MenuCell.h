//
//  MenuCell.h
//  hope
//
//  Created by toby on 13-4-16.
//  Copyright (c) 2013年 toby. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Menu;
@interface MenuCell : UITableViewCell
{
    UIImageView     *arrows;
    UIImageView     *line;
}

@property (nonatomic, strong) Menu*      menu;
@property (nonatomic, strong) UIImageView*  titleImageView;
@property (nonatomic, strong) UIImageView*  typeImageView;
@property (nonatomic, strong) UIImageView*  backgroundImageView;

@end
