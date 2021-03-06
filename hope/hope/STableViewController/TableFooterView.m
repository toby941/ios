//
// DemoTableFooterView.m
//
// @author Shiki
//

#import "TableFooterView.h"


@implementation TableFooterView

@synthesize activityIndicator;
@synthesize infoLabel;


- (void) awakeFromNib
{
  self.backgroundColor = [UIColor clearColor];
  [super awakeFromNib];
}

- (void) dealloc
{
  [activityIndicator release];
  [infoLabel release];
  [super dealloc];
}

@end
