//
//  CardMatchingGame.m
//  Matchismo2
//
//  Created by yuchiliu on 10/6/13.
//  Copyright (c) 2013 CS193P. All rights reserved.
//

#import "CardMatchingGame.h"

@interface CardMatchingGame()

@property (nonatomic, readwrite) NSInteger score;
@property (nonatomic, readwrite) NSInteger scoreDiff;
@property (nonatomic, readwrite) BOOL matchSucceed;
@property (nonatomic, strong, readwrite) NSMutableArray *matchresult;
@property (nonatomic, strong, readwrite) NSMutableArray *cards;// of Card
@property (nonatomic, strong) Deck *deck;
@end

@implementation CardMatchingGame

- (NSMutableArray *)cards
{
    if(!_cards) _cards = [[NSMutableArray alloc] init];
    return _cards;
}

- (NSMutableArray *)matchresult
{
    if(!_matchresult) _matchresult = [[NSMutableArray alloc] init];
    return _matchresult;
}

- (instancetype)initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck setMode:(BOOL)threeCard
{
    self = [super init];
    
    if (self) {
        self.deck = deck;
        for (int i=0; i < count; i++){
            Card *card = [deck drawRandomCard];
            if (card){
                [self.cards addObject:card];
            } else {
                self = nil;
                break;
            }
        }
    }
    self.threeCardMode = threeCard;
    return self;
}

- (void)removeCards:(NSArray *)cards
{
    [self.cards removeObjectsInArray:cards];
}

- (BOOL)addNumOfCards:(NSUInteger)plusNum
{
    for (int i=0; i<plusNum; i++){
        Card *card = [self.deck drawRandomCard];
        if (card) {
            [self.cards addObject:card];
        } else {
            return NO;
        }
    }
    return YES;
}

- (NSUInteger)getNumOfCards
{
    return [self.cards count];
}

#define MISMATCH_PENALTY 2
#define MATCH_BONUS 4
#define COST_TO_CHOOSE 1
- (void)chooseCardAtIndex:(NSUInteger)index
{
    self.matchresult = nil;
    Card *card = [self cardAtIndex:index];
    [self.matchresult addObject:card];
    if (!card.isMatched){
        if (card.isChosen) {
            card.chosen = NO;
        }else{
            if (!self.threeCardMode) {
                //match against other chosen cards
                for (Card *otherCard in self.cards) {
                    if (otherCard.isChosen && !otherCard.isMatched) {
                        int matchScore = [card match:@[otherCard]];
                        if (matchScore) {
                            self.scoreDiff = matchScore * MATCH_BONUS;
                            self.score += self.scoreDiff;
                            self.matchSucceed = YES;
                            card.matched = YES;
                            otherCard.matched = YES;
                            
                        } else{
                            self.score -= MISMATCH_PENALTY;
                            self.scoreDiff = MISMATCH_PENALTY;
                            self.matchSucceed = NO;
                            otherCard.chosen = NO;
                        }
                        [self.matchresult addObject:otherCard];
                        break;
                    }
                }
                card.chosen = YES;
                self.score -= COST_TO_CHOOSE;
                
            }
            else{
                NSMutableArray *toMatchCard = [[NSMutableArray alloc] init];
                for (Card *otherCard in self.cards) {
                    if (otherCard.isChosen && !otherCard.isMatched){
                        [toMatchCard addObject:otherCard];
                        [self.matchresult addObject:otherCard];
                    }
                    
                }
                if ([toMatchCard count] >= 2) {
                    int matchScore = [card match:toMatchCard];
                    if (matchScore) {
                        self.scoreDiff = matchScore * MATCH_BONUS;
                        self.score += self.scoreDiff;
                        self.matchSucceed = YES;
                        card.matched = YES;
                        for (Card *matchedCard in toMatchCard)
                            matchedCard.matched = YES;
                    }
                    else {
                        self.scoreDiff = MISMATCH_PENALTY;
                        self.score -= MISMATCH_PENALTY;
                        self.matchSucceed = NO;
                        Card *firstCard = [toMatchCard firstObject];
                        firstCard.chosen = NO;
                    }
                }
                
                card.chosen = YES;
                self.score -= COST_TO_CHOOSE;
            }
            
        }
    }
}

-(Card *)cardAtIndex:(NSUInteger)index
{
    return (index < [self.cards count]) ? self.cards[index] : nil;
}

@end
