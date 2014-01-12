//
//  PlayingCardGameViewController.m
//  Matchismo2
//
//  Created by yuchiliu on 10/15/13.
//  Copyright (c) 2013 CS193P. All rights reserved.
//

#import "PlayingCardGameViewController.h"
#import "PlayingCardDeck.h"
#import "PlayingCardView.h"
@interface PlayingCardGameViewController ()

@end

@implementation PlayingCardGameViewController

- (Deck *)createDeck
{
    return [[PlayingCardDeck alloc] init];
}

#define NUMOFCARDSFORPLAY 16
- (NSUInteger)defaultNumofCards
{
    return NUMOFCARDSFORPLAY;
}

- (void)setSubViewFromCard: (PlayingCardView *)subview withCard:(Card*)card
{
    if ([card isKindOfClass:[PlayingCard class]]) {
        PlayingCard *playingcard = (PlayingCard*)card;
        subview.suit = playingcard.suit;
        subview.rank = playingcard.rank;
        subview.faceUp = playingcard.isChosen;
        subview.matched = playingcard.isMatched;
        subview.alpha = playingcard.isMatched? 0.5 : 1.0;
    }
}

- (UIView *)newSubview:(CGRect)subviewFrame withCard:(Card *)card
{
    PlayingCardView *subview = [[PlayingCardView alloc] initWithFrame:subviewFrame];
    [self setSubViewFromCard:subview withCard:card];
    return subview;
}

- (void)updateSubview:(UIView *)subview usingCard:(Card *)card
{
    PlayingCardView *updateSubview = (PlayingCardView *)subview;
    [self setSubViewFromCard:updateSubview withCard:card];
}

- (void)flipSubview: (UIView*)subview
{
    PlayingCardView *updateSubview = (PlayingCardView *)subview;
    if (!updateSubview.matched){
        updateSubview.flipped = !updateSubview.flipped;
    }
}
@end
