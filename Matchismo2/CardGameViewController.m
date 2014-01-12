//
//  CardGameViewController.m
//  Matchismo2
//
//  Created by yuchiliu on 10/6/13.
//  Copyright (c) 2013 CS193P. All rights reserved.
//

#import "CardGameViewController.h"
#import "CardMatchingGame.h"
#import "Grid.h"
@interface CardGameViewController ()
@property (strong, nonatomic) CardMatchingGame *game;
@property (weak, nonatomic) IBOutlet UIView *drawBoundView;
@property (strong, nonatomic) Grid *drawGrid;
@property (strong, nonatomic) UIDynamicAnimator *animator;
@property (strong, nonatomic) NSMutableArray *attachments;
@property (weak, nonatomic) IBOutlet UIButton *plusThreeButton;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (nonatomic) BOOL pinched;
@end

@implementation CardGameViewController

#pragma mark - Properties
- (CardMatchingGame *)game
{
    if (!_game) {
        _game = [[CardMatchingGame alloc]initWithCardCount:[self defaultNumofCards]
                                                 usingDeck:[self createDeck]
                                                   setMode:[self setThreeCardMode]];
    }
    return _game;
}

- (Grid *)drawGrid
{
    if (!_drawGrid){
        _drawGrid = [[Grid alloc] initWithPara:self.drawBoundView.bounds.size
                                        Aspect:0.8
                                    numofCells:[self defaultNumofCards]];
    }
    return _drawGrid;
}

- (UIDynamicAnimator *)animator
{
    if (!_animator) {
        _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.drawBoundView];
    }
    return _animator;
}

- (NSMutableArray *)attachments
{
    if (!_attachments){
        _attachments = [[NSMutableArray alloc] init];
    }
    return _attachments;
}

#pragma mark - Abstract method
-(BOOL)setThreeCardMode
{
    return NO;
}

- (Deck *)createDeck
{
    return nil;
}

- (UIView *)newSubview:(CGRect)subviewFrame withCard:(Card *)card
{
    return nil;
}

- (void)updateSubview:(UIView *)subview usingCard:(Card *)card
{
    //abstract
}
- (BOOL)removeMatched
{
    return NO;
}

#define DEFAULTNUMBEROFCARDS 12
- (NSUInteger)defaultNumofCards
{
    return DEFAULTNUMBEROFCARDS;
}

- (void)flipSubview: (UIView*)subview
{
    //abstract
}

#pragma mark - Redeal and Plus
// A game is considered finished when you press the redeal button.
- (IBAction)touchRedealButton:(UIButton *)sender
{
    self.game = nil;
    self.drawGrid = nil;
    self.plusThreeButton.enabled = YES;
    [self animateRemovingCards:self.drawBoundView.subviews];
    [UIView animateWithDuration:0.0
                          delay:1.2
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{}
                     completion:^(BOOL fin){if(fin)[self initialize];}];
}

//draw three more cards
- (IBAction)plusThreeCard:(UIButton *)sender {
    NSUInteger oldNumOfCards = [self.game getNumOfCards];
    sender.enabled = [self.game addNumOfCards:3];
    self.drawGrid.minimumNumberOfCells = [self.drawBoundView.subviews count] + 3;
    for (int i=0;i<([self.game getNumOfCards]-oldNumOfCards);i++){
        NSUInteger newCardIndex = oldNumOfCards+i;
        Card *card = self.game.cards[newCardIndex];
        UIView *newSubview = [self newSubview:[self.drawGrid frameOfCellAtRow:0 inColumn:0] withCard:card];
        [self drawNewSubview:newSubview];
        [newSubview addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(flipCard:)]];
    }
    [self updateCardViewsWhenGridChange];
}

#pragma mark - HelperFunction
#define CARDSIZESCALEFACTOR 0.95
- (CGRect)getFrameFromIndex:(NSUInteger)index
{
    NSUInteger columnCount = self.drawGrid.columnCount;
    NSUInteger row = index/columnCount;
    NSUInteger column = index%columnCount;
    CGRect frameInGrid = [self.drawGrid frameOfCellAtRow:row inColumn:column];
    CGRect newFrame = CGRectMake(frameInGrid.origin.x, frameInGrid.origin.y, frameInGrid.size.width*CARDSIZESCALEFACTOR, frameInGrid.size.height*CARDSIZESCALEFACTOR);
    return newFrame;
}

- (void)drawNewSubview:(UIView*)newSubview
{
    [self.drawBoundView addSubview:newSubview];
}

#pragma mark - Animation

- (void)updateCardViewsWhenGridChange
{
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         for (UIView *subview in self.drawBoundView.subviews){
                             NSUInteger indexOfSubview = [self.drawBoundView.subviews indexOfObject:subview];
                             subview.frame= [self getFrameFromIndex:indexOfSubview];
                         }
                     }
                     completion:nil];
    
}

//Pile views in viewToPile to center at toPoint.
- (void)animatePileCardsToPoint: (NSArray *)viewsToPile toPoint:(CGPoint)point
{
    for (id obj in viewsToPile){
        if ([obj isKindOfClass:[UIView class]]) {
            UIView *subview = (UIView *)obj;
            [UIView animateWithDuration:0.5
                                  delay:0
                                options:UIViewAnimationOptionCurveEaseInOut
                             animations:^{subview.center = point; }
                             completion:nil];
            subview.center = point;
        }
    }
}

- (void)animateSetCardToFrame:(UIView*)cardView withFrame:(CGRect)newFrame
{
    [UIView animateWithDuration:0.5
                          delay:0.5
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{cardView.center = CGPointMake(newFrame.origin.x + newFrame.size.width/2,newFrame.origin.y + newFrame.size.height/2); }
                     completion:nil];
}

- (void)animateRemovingCards:(NSArray *)viewsToRemove
{
    [UIView animateWithDuration:1.0
                          delay:0.2
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         for (UIView *subview in viewsToRemove) {
                             int x = (arc4random()%(int)(self.view.bounds.size.width*5)) - (int)self.view.bounds.size.width*2;
                             int y = self.view.bounds.size.height;
                             subview.center = CGPointMake(x, -y);
                         }
                     }
                     completion:^(BOOL finished) {
                         if (finished) {
                             [viewsToRemove makeObjectsPerformSelector:@selector(removeFromSuperview)];
                             [self updateCardViewsWhenGridChange];
                         }
                     }];
}

- (void)updateUI
{
    NSMutableArray *subviewsToRemove = [[NSMutableArray alloc] init];
    NSMutableArray *cardsToRemove = [[NSMutableArray alloc] init];
    for (UIView *subview in self.drawBoundView.subviews) {
        NSUInteger subviewIndex = [self.drawBoundView.subviews indexOfObject:subview];
        Card *card = [self.game cardAtIndex:subviewIndex];
        [self updateSubview:subview usingCard:card];
        if (card.isMatched) {
            [subviewsToRemove addObject:subview];
            [cardsToRemove addObject:card];
        }
    }
    NSString *score = [NSString stringWithFormat:@"Score: %d", (int)self.game.score ];
    self.scoreLabel.attributedText = [[NSAttributedString alloc] initWithString:score
                                                                     attributes:@{NSStrokeWidthAttributeName:@3}];
    if ([self removeMatched] && [cardsToRemove count]) {
        [self.game removeCards:cardsToRemove];
        self.drawGrid.minimumNumberOfCells = [self.game getNumOfCards];
        [self animateRemovingCards:subviewsToRemove];
    }
}

#pragma mark - GestureRecognization
//Handle flipCard.
- (void)flipCard:(UITapGestureRecognizer *)gesture;
{
    if (self.pinched) {
        [self updateCardViewsWhenGridChange];
        self.pinched = NO;
        //Remove pan gesture recognizers, so when the game is in normal playmode, we don't want to move cards around.
        for (UIView *subview in self.drawBoundView.subviews)
            for (id panrecognizer in subview.gestureRecognizers){
                if ([panrecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
                    [subview removeGestureRecognizer:panrecognizer];
                }
            }
    }else{
        UIView *tappedView = [gesture view];
        NSInteger index = [self.drawBoundView.subviews indexOfObject:tappedView];
        if ((index>-1)&&(index<[self.game.cards count])) {
            [self.game chooseCardAtIndex:index];
            [self flipSubview:self.drawBoundView.subviews[index]];
        }
        [self updateUI];
    }
}

- (void)pinchCards:(UIPinchGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateBegan) {
        CGPoint centerOfView = CGPointMake(self.drawBoundView.bounds.size.width/2, self.drawBoundView.bounds.size.height/2);
        [self animatePileCardsToPoint:self.drawBoundView.subviews toPoint:centerOfView];
        for (UIView *subview in self.drawBoundView.subviews){
            [subview addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveCards:)]];
        }
    }
    self.pinched = YES;
}

- (void)moveCards:(UIPanGestureRecognizer *)gesture
{
    CGPoint gesturePoint = [gesture locationInView:self.drawBoundView];
    if (gesture.state == UIGestureRecognizerStateBegan) {
        [self attachCardViewsToPoint:gesturePoint];
    }else if (gesture.state == UIGestureRecognizerStateChanged){
        for (UIAttachmentBehavior *attachment in self.attachments){
            attachment.anchorPoint = gesturePoint;
        }
    }else if (gesture.state == UIGestureRecognizerStateEnded) {
        for (UIAttachmentBehavior *attachment in self.attachments){
            [self.animator removeBehavior:attachment];
        }
        self.attachments = nil;
    }
    
}

- (void)attachCardViewsToPoint:(CGPoint)anchorPoint
{
    for (UIView *cardSubView in self.drawBoundView.subviews){
        UIAttachmentBehavior *attachment = [[UIAttachmentBehavior alloc] initWithItem:cardSubView attachedToAnchor:anchorPoint];
        [self.attachments addObject:attachment];
        [self.animator addBehavior:attachment];
    }
}

#pragma Initialization

- (void)initialize
{
    for (NSUInteger cardIndex=0;cardIndex<[self.game getNumOfCards];cardIndex++){
        CGRect subviewFrame = [self getFrameFromIndex:cardIndex];
        Card *card = self.game.cards[cardIndex];
        UIView *newSubview = [self newSubview:subviewFrame withCard:card];
        [newSubview addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(flipCard:)]];
        newSubview.center = CGPointMake(subviewFrame.size.width/2, subviewFrame.size.height/2);
        [self drawNewSubview:newSubview];
        [self animateSetCardToFrame:newSubview withFrame:subviewFrame];
    }
    NSString *score = [NSString stringWithFormat:@"Score: %d", (int)self.game.score ];
    self.scoreLabel.attributedText = [[NSAttributedString alloc] initWithString:score
                                                                     attributes:@{NSStrokeWidthAttributeName:@3}];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initialize];
    [self.drawBoundView addGestureRecognizer:[[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(pinchCards:)]];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.drawGrid = nil;
    self.drawGrid.minimumNumberOfCells = [self.game getNumOfCards];
    [self updateCardViewsWhenGridChange];
    
}

@end
