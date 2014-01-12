//
//  CardMatchingGame.h
//  Matchismo2
//
//  Created by yuchiliu on 10/6/13.
//  Copyright (c) 2013 CS193P. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Deck.h"
@interface CardMatchingGame : NSObject

//designated initializer
- (instancetype)initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck setMode:(BOOL)threeCard;

- (void)chooseCardAtIndex:(NSUInteger)index;
- (Card *)cardAtIndex:(NSUInteger)index;
- (BOOL)addNumOfCards:(NSUInteger)plusNum;
- (NSUInteger)getNumOfCards;
- (void)removeCards:(NSArray*)cards;
@property (nonatomic) BOOL threeCardMode;
@property (nonatomic, readonly) NSInteger score;
@property (nonatomic, readonly) NSInteger scoreDiff;
@property (nonatomic, readonly) BOOL matchSucceed;
@property (nonatomic, strong,readonly) NSMutableArray *matchresult;
@property (nonatomic, strong,readonly) NSMutableArray *cards;
@end
