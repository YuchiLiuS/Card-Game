//
//  PlayingCard.m
//  Matchismo2
//
//  Created by yuchiliu on 10/6/13.
//  Copyright (c) 2013 CS193P. All rights reserved.
//

#import "PlayingCard.h"
@interface PlayingCard()
+ (BOOL)matchSuit:(PlayingCard *)firstCard :(PlayingCard *)secondCard;
+ (BOOL)matchRank:(PlayingCard *)firstCard :(PlayingCard *)secondCard;
@end
@implementation PlayingCard

+ (BOOL)matchSuit:(PlayingCard *)firstCard :(PlayingCard *)secondCard
{
    return [firstCard.suit isEqualToString:secondCard.suit];
}

+ (BOOL)matchRank:(PlayingCard *)firstCard :(PlayingCard *)secondCard
{
    return (firstCard.rank == secondCard.rank);
}

- (int)match:(NSArray *)otherCards
{
    int score = 0;
    if ([otherCards count] == 1) {
        PlayingCard *otherCard = [otherCards firstObject];
        if ([PlayingCard matchRank:otherCard :self]) {
            score = 8;
        } else if ([PlayingCard matchSuit :otherCard :self]){
            score = 2;
        }
    }
    else if ([otherCards count] == 2){
        PlayingCard *firstCard = otherCards[0];
        PlayingCard *secondCard = otherCards[1];
        //The scoring rule is:
        //If all three match in rank, get 10 points.
        //If all three match in suit, get 2 points.
        //If any two of them match in rank, get +5 points.
        //If any two of them match in suit, get +1 points.
        //So for the case of ( 6 club, 6 heart, 8 heart) we would get 5+1=6 points.
        //for the case of ( 6 club, 6 hear, 8 spade) we get 5 points.
        if ([PlayingCard matchRank:self :firstCard]||[PlayingCard matchRank:self :secondCard])
            score += 5;
        if ([PlayingCard matchRank:firstCard :secondCard])
            score += 5;
        if ([PlayingCard matchSuit:self :firstCard]||[PlayingCard matchSuit:self :secondCard])
            score += 1;
        if ([PlayingCard matchSuit: firstCard :secondCard])
            score += 1;
        
    }
    return score;
}

- (NSString *)contents
{
    NSArray *rankStrings = [PlayingCard rankStrings];
    return [rankStrings[self.rank] stringByAppendingString:self.suit];
}

@synthesize suit = _suit;

+ (NSArray *)validSuits
{
    return @[@"♥",@"♦",@"♠",@"♣"];
}

- (void)setSuit:(NSString *)suit
{
    if ([[PlayingCard validSuits] containsObject:suit]){
        _suit = suit;
    }
}

- (NSString *)suit
{
    return _suit ? _suit : @"?";
}

+ (NSArray *)rankStrings
{
    return @[@"?",@"A",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"J",@"Q",@"K"];
}

+ (NSUInteger)maxRank { return [[self rankStrings] count]-1; }

- (void)setRank:(NSUInteger)rank
{
    if (rank <= [PlayingCard maxRank]) {
        _rank = rank;
    }
}

@end
