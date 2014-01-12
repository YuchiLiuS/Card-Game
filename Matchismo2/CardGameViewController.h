//
//  CardGameViewController.h
//  Matchismo2
//
//  Created by yuchiliu on 10/6/13.
//  Copyright (c) 2013 CS193P. All rights reserved.
//
//Abstract Class
#import <UIKit/UIKit.h>
#import "Deck.h"
@interface CardGameViewController : UIViewController

- (Deck *)createDeck;
- (BOOL)setThreeCardMode;
- (NSUInteger)defaultNumofCards;
- (UIView *)newSubview:(CGRect)subviewFrame withCard:(Card *)card;
- (void)updateSubview:(UIView *)subview usingCard:(Card *)card;
- (void)flipSubview: (UIView*)subview;
- (BOOL)removeMatched;

@end
