//
//  CardView.m
//  Matchismo2
//
//  Created by yuchiliu on 10/27/13.
//  Copyright (c) 2013 CS193P. All rights reserved.
//

#import "CardView.h"

@implementation CardView

#pragma mark - Initialization
- (void)setup
{
    self.backgroundColor = nil;
    self.opaque = NO;
    self.contentMode = UIViewContentModeRedraw;
}

- (void)awakeFromNib
{
    [self setup];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
        // Initialization code
    }
    return self;
}

@end
