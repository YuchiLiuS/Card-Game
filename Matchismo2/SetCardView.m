//
//  SetCardView.m
//  Matchismo2
//
//  Created by yuchiliu on 10/26/13.
//  Copyright (c) 2013 CS193P. All rights reserved.
//

#import "SetCardView.h"

@implementation SetCardView
#pragma mark - Properties

#define DEFAULT_FACE_CARD_SCALE_FACTOR 0.90

- (void)setSymbol:(NSUInteger)symbol
{
    _symbol = symbol;
    [self setNeedsDisplay];
}

- (void)setNumber:(NSUInteger)number
{
    _number = number;
    [self setNeedsDisplay];
}

- (void)setShading:(NSUInteger)shading
{
    _shading = shading;
    [self setNeedsDisplay];
}

- (void)setCardColor:(NSUInteger)cardColor
{
    _cardColor = cardColor;
    [self setNeedsDisplay];
}

- (void)setChosen:(BOOL)chosen
{
    _chosen = chosen;
    [self setNeedsDisplay];
}

#pragma mark - Drawing

#define CORNER_FONT_STANDARD_HEIGHT 180.0
#define CORNER_RADIUS 12.0

- (CGFloat)cornerScaleFactor { return self.bounds.size.height / CORNER_FONT_STANDARD_HEIGHT; }
- (CGFloat)cornerRadius { return CORNER_RADIUS * [self cornerScaleFactor]; }
- (CGFloat)cornerOffset { return [self cornerRadius] / 3.0; }

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:[self cornerRadius]];
    [roundedRect addClip];
    if (self.chosen) {
        [[UIColor colorWithWhite:0.8 alpha:1.0] setFill];
    }
    else{
        [[UIColor whiteColor] setFill];
    }
    UIRectFill(self.bounds);
    [[UIColor blackColor] setStroke];
    [roundedRect stroke];
    [self drawSymbols];
}

#define HOFFSET_PERCENTAGE 0.25
- (void) drawSymbols
{
    CGPoint symbolCenter = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    CGFloat hoffset = self.bounds.size.width*HOFFSET_PERCENTAGE;
    symbolCenter.x -= ((self.number-1)*hoffset/2);
    for (NSUInteger i=0; i<self.number; i++) {
        [self drawSymbolAtCenter:symbolCenter];
        symbolCenter.x += hoffset;
    }
}

- (UIColor *)getColor
{
    switch (self.cardColor) {
        case 0:
            return [UIColor redColor];
        case 1:
            return [UIColor greenColor];
        case 2:
            return [UIColor purpleColor];
        default:
            return nil;
    }
}

- (void) drawSymbolAtCenter:(CGPoint)center
{
    switch (self.symbol) {
        case 0:
            [self drawSquiggleAtCenter:center];
            break;
        case 1:
            [self drawDiamondAtCenter:center];
            break;
        case 2:
            [self drawOvalAtCenter:center];
            break;
        default:
            break;
    }
}

#define SQUIGGLE_WIDTH 0.15
#define SQUIGGLE_HALFHEIGHT 0.25
#define SQUIGGLE_CONTROLHOFFSET 0.2
#define SQUIGGLE_CONTROLVOFFSET 0.3

- (void) drawSquiggleAtCenter:(CGPoint)center
{
    CGFloat width = self.bounds.size.width * SQUIGGLE_WIDTH;
    CGFloat halfheight = self.bounds.size.height * SQUIGGLE_HALFHEIGHT;
    CGFloat hoffset = self.bounds.size.width * SQUIGGLE_CONTROLHOFFSET;
    CGFloat voffset = self.bounds.size.height * SQUIGGLE_CONTROLVOFFSET;
    UIBezierPath *path = [[UIBezierPath alloc] init];
    [path moveToPoint:CGPointMake(center.x-width, center.y-halfheight)];
    [path addCurveToPoint:CGPointMake(center.x, center.y+halfheight) controlPoint1:CGPointMake(center.x+hoffset-width,center.y) controlPoint2:CGPointMake(center.x-hoffset, center.y)];
    [path addQuadCurveToPoint:CGPointMake(center.x+width, center.y+halfheight) controlPoint:CGPointMake(center.x+width, center.y+voffset)];
    [path addCurveToPoint:CGPointMake(center.x, center.y-halfheight) controlPoint1:CGPointMake(center.x-hoffset+width,center.y) controlPoint2:CGPointMake(center.x+hoffset, center.y)];
    [path addQuadCurveToPoint:CGPointMake(center.x-width, center.y-halfheight) controlPoint:CGPointMake(center.x-width, center.y-voffset)];
    [self shadeForPath:path];
}

#define DIAMOND_HALFWIDTH 0.1
#define DIAMOND_HALFHEIGHT 0.25

- (void) drawDiamondAtCenter:(CGPoint)center
{
    CGFloat halfwidth = self.bounds.size.width * DIAMOND_HALFWIDTH;
    CGFloat halfheight = self.bounds.size.height * DIAMOND_HALFHEIGHT;
    UIBezierPath *path = [[UIBezierPath alloc] init];
    [path moveToPoint:CGPointMake(center.x-halfwidth, center.y)];
    [path addLineToPoint:CGPointMake(center.x, center.y-halfheight)];
    [path addLineToPoint:CGPointMake(center.x+halfwidth, center.y)];
    [path addLineToPoint:CGPointMake(center.x, center.y+halfheight)];
    [path closePath];
    [self shadeForPath:path];
    
}

#define OVAL_WIDTH 0.2
#define OVAL_HEIGHT 0.5

- (void) drawOvalAtCenter:(CGPoint)center
{
    CGFloat width = self.bounds.size.width*OVAL_WIDTH;
    CGFloat height = self.bounds.size.height*OVAL_HEIGHT;
    UIBezierPath *oval= [UIBezierPath bezierPathWithOvalInRect:CGRectMake(center.x-width/2, center.y-height/2,width, height)];
    [self shadeForPath:oval];
}

- (void) shadeForPath:(UIBezierPath *)path
{
    [[self getColor] setStroke];
    [path stroke];
    switch (self.shading) {
        case 0:   //solid
            [[self getColor] setFill];
            [path fill];
            break;
        case 1:   //striped
            [self stripeForPath:path];
            break;
        case 2:   //open
            [[UIColor clearColor] setFill];
            [path fill];
            break;
        default:
            break;
    }
    
}

#define STRIPE_OFFSET 0.05

- (void) stripeForPath:(UIBezierPath *)path
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    [path addClip];
    CGFloat hoffset = self.bounds.size.width * STRIPE_OFFSET;
    CGFloat voffset = self.bounds.size.height * STRIPE_OFFSET;
    CGPoint start = self.bounds.origin;
    CGPoint end = self.bounds.origin;
    UIBezierPath *stripes = [[UIBezierPath alloc] init];
    for (int i=0; i< 1/STRIPE_OFFSET; i++){
        [stripes moveToPoint:start];
        [stripes addLineToPoint:end];
        start.x += hoffset;
        end.y += voffset;
    }
    start.x = self.bounds.origin.x;
    start.y = self.bounds.origin.y + self.bounds.size.height;
    end.x = self.bounds.origin.x + self.bounds.size.width;
    end.y = self.bounds.origin.y;
    for (int i=0; i <1/STRIPE_OFFSET; i++){
        [stripes moveToPoint:start];
        [stripes addLineToPoint:end];
        start.x += hoffset;
        end.y += voffset;
    }
    [stripes stroke];
    CGContextRestoreGState(UIGraphicsGetCurrentContext());
}



#pragma mark - Initialization
- (void)setup
{
    self.backgroundColor = nil;
    self.opaque = NO;
    self.contentMode = UIViewContentModeRedraw;
}

- (void)awakeFromNib
{
    [self setup];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

@end
