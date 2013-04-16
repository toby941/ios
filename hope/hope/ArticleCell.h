//
//  ArticleCell.h
//  hope
//
//  Created by toby on 13-4-15.
//  Copyright (c) 2013年 toby. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Article;
@interface ArticleCell : UITableViewCell
{
UIImageView     *arrows;
UIImageView     *line;
}

@property (nonatomic, strong) Article*      article;
@property (nonatomic, strong) UIImageView*  titleImageView;
@property (nonatomic, strong) UIImageView*  typeImageView;
@property (nonatomic, strong) UIImageView*  backgroundImageView;

- (void)updateType;

@end
