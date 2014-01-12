//
//  PlayingCard.h
//  Matchismo2
//
//  Created by yuchiliu on 10/6/13.
//  Copyright (c) 2013 CS193P. All rights reserved.
//

#import "Card.h"

@interface PlayingCard : Card

@property (strong, nonatomic) NSString *suit;
@property (nonatomic) NSUInteger rank;

+ (NSArray *)validSuits;
+ (NSUInteger)maxRank;

@end
