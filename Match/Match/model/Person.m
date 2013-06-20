//
//  Person.m
//  Match
//
//  Created by toby on 13-6-17.
//  Copyright (c) 2013年 toby. All rights reserved.
//

#import "Person.h"

@implementation Person

-(void) update:(Person*)updatePerson{
    self.fg+=updatePerson.fg;
    self.threepm+=updatePerson.threepm;
    self.blk+=updatePerson.blk;
    self.ast+=updatePerson.ast;
    self.st+=updatePerson.st;
    self.ft+=updatePerson.ft;
    self.pf=updatePerson.pf;
    [self updatePts];
}
-(void) updatePts{
    NSInteger fgValue = self.fg*2;
    NSInteger threeValue = self.threepm*3;
    NSInteger ftValue = self.ft;
     self.pts=fgValue+threeValue+ftValue;
}
@end
