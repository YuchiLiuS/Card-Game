//
//  SetCard.m
//  Matchismo2
//
//  Created by yuchiliu on 10/15/13.
//  Copyright (c) 2013 CS193P. All rights reserved.
//

#import "SetCard.h"
@interface SetCard()
+ (BOOL)matchNumber:(NSUInteger)firstNumber :(NSUInteger)secondNumber :(NSUInteger)thirdNumber;
@end

@implementation SetCard

- (NSString *)contents
{
    return nil;
}

+ (NSArray *)validSymbols
{
    return @[@"squiggles",@"diamonds",@"ovals"];
}

+ (NSArray *)validNumbers
{
    return @[@1,@2,@3];
}

+ (NSArray *)validShadings
{
    return @[@"solid",@"striped",@"open"];
}

+ (NSArray *)validColors
{
    return @[@"red",@"green",@"purple"];
}

+ (NSUInteger)maxNumber
{
    return [[self validNumbers] count];
}


-(void)setSymbol:(NSUInteger)symbol
{
    if (symbol <= [[SetCard validSymbols] count]){
        _symbol = symbol;
    }
}



-(void)setShading:(NSUInteger)shading
{
    if (shading <= [[SetCard validShadings] count]){
        _shading = shading;
    }
}

-(void)setcardColor:(NSUInteger)cardColor
{
    if (cardColor <= [[SetCard validColors] count]){
        _cardColor = cardColor;
    }
}


-(void)setNumber:(NSUInteger)number
{
    if (number <= [SetCard maxNumber]) {
        _number = number;
    }
}

//If cmpResult = 1, we violate the all same or all different rule.
+ (BOOL)matchNumber:(NSUInteger)firstNumber :(NSUInteger)secondNumber :(NSUInteger)thirdNumber
{
    int cmpResult = (firstNumber==secondNumber)+(firstNumber==thirdNumber)+(secondNumber==thirdNumber);
    return (cmpResult==1);
}

- (int)match:(NSArray *)otherCards
{
    int score = 0;
    if ([otherCards count] == 2){
        SetCard *firstCard = otherCards[0];
        SetCard *secondCard = otherCards[1];
        if ([SetCard matchNumber:firstCard.symbol :secondCard.symbol :self.symbol] ||
            [SetCard matchNumber:firstCard.shading :secondCard.shading :self.shading]||
            [SetCard matchNumber:firstCard.cardColor :secondCard.cardColor :self.cardColor]||
            [SetCard matchNumber:firstCard.number :secondCard.number :self.number]
            )
            score = 0;
        else score = 8;
        
    }
    return score;
}


@end
