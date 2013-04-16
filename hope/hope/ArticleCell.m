//
//  ArticleCell.m
//  hope
//
//  Created by toby on 13-4-15.
//  Copyright (c) 2013年 toby. All rights reserved.
//

#import "ArticleCell.h"
#import "Article.h"

@implementation ArticleCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews{
    [super layoutSubviews];
    //    [self setFrame:CGRectMake(self.bounds.origin.x, self.bounds.origin.y, self.bounds.size.width - 40, self.bounds.size.height)];
    
    [self.textLabel setFont:[UIFont boldSystemFontOfSize:12]];
    [self.textLabel setFrame:CGRectMake(20, 15, 180, 20)];
    [self.textLabel setNumberOfLines:2];
    
    [self.detailTextLabel setFrame:CGRectMake(20, 30, 150, 20)];
    [self.detailTextLabel setFont:[UIFont systemFontOfSize:10]];
    
    //    if (arrows == nil) {
    //        arrows = [[UIImageView alloc] initWithFrame:CGRectMake(200, 38, 7, 12)];
    //        [arrows setImage:[UIImage imageNamed:@"373232"]];
    //        [self.contentView addSubview:arrows];
    //    }
    
    if (line == nil) {
        line = [[UIImageView alloc] initWithFrame:CGRectMake(self.bounds.origin.x, self.bounds.size.height + 5, self.bounds.size.width, 6)];
        [line setImage:[UIImage imageNamed:@"divider-page"]];
        [self.contentView addSubview:line];
    }
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    if (highlighted) {
        UIImage* bgImage = [UIImage imageNamed:@"cellBg_sel"];
        [self.backgroundImageView setImage:bgImage];
    }else {
        UIImage* bgImage = [UIImage imageNamed:@"cellBg"];
        [self.backgroundImageView setImage:bgImage];
    }
}

- (void)setArticle:(Article *)article{
    if (nil != _article) {
        [_article release];
    }
    _article = [article retain];
    [self updateType];
}

- (void)updateType{
//    UIImage* typeImage = [UIImage imageNamed:[NSString stringWithFormat:@"type%@", _article.nType]];
//[self.typeImageView setImage:typeImage];
}

- (void)dealloc
{
    self.typeImageView = nil;
    if (line != nil) {
        [line release];
        line = nil;
    }
    if (arrows != nil) {
        [arrows release];
        arrows = nil;
    }
    
    [super dealloc];
}




@end
