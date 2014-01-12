//
//  SetCardView.h
//  Matchismo2
//
//  Created by yuchiliu on 10/26/13.
//  Copyright (c) 2013 CS193P. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardView.h"

@interface SetCardView : CardView
@property (nonatomic) NSUInteger symbol;
@property (nonatomic) NSUInteger number;
@property (nonatomic) NSUInteger shading;
@property (nonatomic) NSUInteger cardColor;
@property (nonatomic) BOOL chosen;
@end
