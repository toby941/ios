//
//  ArticleCell.m
//  hope
//
//  Created by toby on 13-4-15.
//  Copyright (c) 2013年 toby. All rights reserved.
//

#import "ArticleCell.h"
#import "Article.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "Utils.h"

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
    
    NSInteger titleX=self.bounds.origin.x+10;
    NSInteger titleY=5;
    NSInteger titleW=300;
    NSInteger titleH=50;
    
    NSInteger footX=self.bounds.origin.x+25;
    NSInteger footY=135;
    NSInteger footW=300;
    NSInteger footH=13;
    
    NSInteger footIconX=self.bounds.origin.x+10;
    NSInteger footIconY=135;
    NSInteger footIconW=13;
    NSInteger footIconH=13;
    
    NSInteger imageX=self.frame.origin.x+10;
    NSInteger imageY=60;
    NSInteger imageW=100;
    NSInteger imageH=68;
    
    NSInteger lineX=self.bounds.origin.x;
    NSInteger lineY=148;
    NSInteger lineW=self.frame.size.width;
    NSInteger lineH=2;
    
    
    NSInteger summaryX=self.frame.origin.x+120;
    NSInteger summaryY=60;
    NSInteger summaryW=self.bounds.size.width-130;
    NSInteger summaryH=72;
    
    //    if(!self.article.img||[self.article.img length]==0){
    //        summaryX=self.frame.origin.x+10;
    //        summaryW=300;
    //    }
    
    
    [super layoutSubviews];
    [self.textLabel setFont:[UIFont boldSystemFontOfSize:20]];
    [self.textLabel setFrame:CGRectMake(titleX, titleY, titleW, titleH)];
    [self.textLabel setNumberOfLines:2];
    // [self.textLabel setAdjustsFontSizeToFitWidth:true];
    [self.textLabel setTextColor:[UIColor blueColor]];
    
    [self.detailTextLabel setFrame:CGRectMake(footX, footY, footW, footH)];
    [self.detailTextLabel setFont:[UIFont systemFontOfSize:12]];
    timeIcon=[[UIImageView alloc] initWithFrame:CGRectMake(footIconX, footIconY, footIconW, footIconH)];
    [timeIcon setImage:[UIImage imageNamed:@"icon-time"]];
    [self.contentView addSubview:timeIcon];
    
    NSLog(@"art summary :%@",_article.summary);
    if(summaryView==nil){
        summaryView=  [[UILabel alloc] initWithFrame:CGRectMake(summaryX,  summaryY, summaryW, summaryH)];
        [summaryView setFont:[UIFont systemFontOfSize:12]];
        summaryView.backgroundColor=[UIColor clearColor];
        [summaryView setNumberOfLines:5];
        [summaryView setAdjustsFontSizeToFitWidth:true];
        
        summaryView.text=_article.summary;
        [self.contentView addSubview:summaryView];
    }else{
        summaryView.text=_article.summary;
    }
    
    arrows=(UIImageView *)[self.contentView viewWithTag:1818];
    if(arrows){
        arrows.removeFromSuperview;
    }
    arrows = [[UIImageView alloc] initWithFrame:CGRectMake(imageX,  imageY, imageW, imageH)];
    arrows.contentMode = UIViewContentModeScaleAspectFit;
    arrows.backgroundColor=[UIColor clearColor];
    arrows.tag=1818;
    
    //  self.imageView
    if ( ![Utils isEmptyOrNull:self.article.img]) {
        //NSURL* imageURL = [NSURL URLWithString:[self.article.img stringByAppendingString:@"!100"]];
        NSURL* imageURL = [NSURL URLWithString:self.article.img];
        
        [arrows setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"bg.png" ]];
        [self.contentView addSubview:arrows];
    }else{
        //没有图片采用内置图片占位
        arrows.image=[UIImage imageNamed:@"default.jpg" ];
        [self.contentView addSubview:arrows];
    }
    if (line == nil) {
        line = [[UIImageView alloc] initWithFrame:CGRectMake(lineX,   lineY, lineW, lineH)];
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
