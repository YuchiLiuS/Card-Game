//
//  SetCardDeck.m
//  Matchismo2
//
//  Created by yuchiliu on 10/15/13.
//  Copyright (c) 2013 CS193P. All rights reserved.
//

#import "SetCardDeck.h"
@implementation SetCardDeck
- (instancetype)init
{
    self = [super init];
    if (self) {
        for (NSUInteger symbol=0; symbol < [[SetCard validSymbols] count]; symbol++) {
            for (NSUInteger shading=0; shading < [[SetCard validShadings] count]; shading++){
                for (NSUInteger cardColor=0; cardColor < [[SetCard validColors] count]; cardColor++){
                    for (NSUInteger number = 1; number <= [SetCard maxNumber]; number++){
                        SetCard *card = [[SetCard alloc] init];
                        card.number = number;
                        card.symbol = symbol;
                        card.shading = shading;
                        card.cardColor = cardColor;
                        [self addCard:card];
                    }
                }
            }
        }
    }
    
    return self;
}
@end
