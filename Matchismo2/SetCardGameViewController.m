//
//  SetCardGameViewController.m
//  Matchismo2
//
//  Created by yuchiliu on 10/15/13.
//  Copyright (c) 2013 CS193P. All rights reserved.
//

#import "SetCardGameViewController.h"
#import "SetCardDeck.h"
#import "SetCardView.h"
@interface SetCardGameViewController ()

@end

@implementation SetCardGameViewController

- (Deck *)createDeck
{
    return [[SetCardDeck alloc] init];
}

#define NUMOFCARDSFORSET 12
- (NSUInteger)defaultNumofCards
{
    return NUMOFCARDSFORSET;
}

-(BOOL)setThreeCardMode
{
    return YES;
}

- (void)setSubViewFromCard: (SetCardView *)subview withCard:(Card*)card
{
    if ([card isKindOfClass:[SetCard class]]) {
        SetCard *setcard = (SetCard*)card;
        subview.symbol = setcard.symbol;
        subview.number = setcard.number;
        subview.shading = setcard.shading;
        subview.cardColor = setcard.cardColor;
        subview.chosen = setcard.isChosen;
        subview.alpha = setcard.isMatched? 0.5 : 1.0;
    }
}

- (UIView *)newSubview:(CGRect)subviewFrame withCard:(Card *)card
{
    SetCardView *subview = [[SetCardView alloc] initWithFrame:subviewFrame];
    [self setSubViewFromCard:subview withCard:card];
    return subview;
}

- (void)updateSubview:(UIView *)subview usingCard:(Card *)card
{
    SetCardView *updateSubview = (SetCardView *)subview;
    [self setSubViewFromCard:updateSubview withCard:card];
}

- (BOOL)removeMatched
{
    return YES;
}

@end