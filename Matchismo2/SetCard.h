//
//  SetCard.h
//  Matchismo2
//
//  Created by yuchiliu on 10/15/13.
//  Copyright (c) 2013 CS193P. All rights reserved.
//

#import "Card.h"

@interface SetCard : Card

@property (nonatomic) NSUInteger symbol;
@property (nonatomic) NSUInteger number;
@property (nonatomic) NSUInteger shading;
@property (nonatomic) NSUInteger cardColor;

+ (NSArray *)validSymbols;
+ (NSUInteger)maxNumber;
+ (NSArray *)validShadings;
+ (NSArray *)validColors;

@end
