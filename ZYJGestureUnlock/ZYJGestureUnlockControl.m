//
//  ZYJGestureUnlockControl.m
//  ZYJGestureUnlock
//
//  Created by 张雁军 on 12/06/2017.
//  Copyright © 2017 张雁军. All rights reserved.
//

#import "ZYJGestureUnlockControl.h"

@interface ZYJGestureUnlockControl ()
@property (nonatomic, copy) NSArray <UIButton *> *points;
@property (nonatomic) NSMutableArray <UIButton *> *throughPoints;
@property (nonatomic) NSValue *fingerPoint;
@property (nonatomic) CAShapeLayer *drawingLayer;
@end

@implementation ZYJGestureUnlockControl

- (instancetype)init{
    if (self = [super init]) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    [self setup];
}

- (void)setup{
    self.backgroundColor = [UIColor clearColor];
    
    _lineColor = [UIColor redColor];
    _lineWidth = 6;
    _pointSize = CGSizeMake(40, 40);
    _contentInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    
    _drawingLayer = [CAShapeLayer layer];
    _drawingLayer.strokeColor = _lineColor.CGColor;
    _drawingLayer.lineWidth = _lineWidth;
    _drawingLayer.lineCap = kCALineCapRound;
    _drawingLayer.lineJoin = kCALineJoinRound;
    _drawingLayer.fillColor = [UIColor clearColor].CGColor;
    _drawingLayer.strokeStart = 0.f;
    _drawingLayer.strokeEnd = 1.f;
    [self.layer addSublayer:_drawingLayer];
    
    _throughPoints = [[NSMutableArray alloc] init];
    
    NSMutableArray *points = [[NSMutableArray alloc] initWithCapacity:9];
    for (int i = 0; i<9; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = i + 1;
        btn.userInteractionEnabled = NO;
        btn.selected = NO;
        [self.layer addSublayer:btn.layer];
        [points addObject:btn];
    }
    self.points = points;
}

- (void)setLineColor:(UIColor *)lineColor{
    _drawingLayer.strokeColor = lineColor.CGColor;
}

- (void)setLineWidth:(CGFloat)lineWidth{
    _drawingLayer.lineWidth = lineWidth;
}

- (void)setPointSize:(CGSize)pointSize{
    _pointSize = pointSize;
}

- (void)setContentInsets:(UIEdgeInsets)contentInsets{
    _contentInsets = contentInsets;
}

- (void)setNormalImage:(UIImage *)normalImage{
    [_points enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj setImage:normalImage forState:UIControlStateNormal];
    }];
}

- (void)setSelectedImage:(UIImage *)selectedImage{
    [_points enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj setImage:selectedImage forState:UIControlStateSelected];
    }];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat w = (self.bounds.size.width - _contentInsets.left - _pointSize.width / 2 - _pointSize.width / 2 - _contentInsets.right) / 2;
    CGFloat h = (self.bounds.size.height - _contentInsets.top - _pointSize.height / 2 - _pointSize.height / 2 - _contentInsets.bottom) / 2;
    [_points enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSInteger row = idx / 3;
        NSInteger col = idx % 3;
        obj.bounds = CGRectMake(0, 0, _pointSize.width, _pointSize.height);
        obj.center = CGPointMake(_contentInsets.left + _pointSize.width / 2 + w * col, _contentInsets.top + _pointSize.height / 2 + h * row);
    }];
}

- (void)draw{
    if (_throughPoints.count) {
        UIBezierPath *path = [UIBezierPath bezierPath];
        CGPoint p0 = _throughPoints.firstObject.center;
        [path moveToPoint:p0];
        [_throughPoints enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (idx != 0) {
                [path addLineToPoint:obj.center];
            }
        }];
        if (_fingerPoint != nil) {
            [path addLineToPoint:_fingerPoint.CGPointValue];
        }
        _drawingLayer.path = path.CGPath;
    }else{
        _drawingLayer.path = NULL;
    }
}

#pragma mark - UIControl

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(nullable UIEvent *)event{
    [self clean];
    __block BOOL shouldBegin;
    [_points enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (CGRectContainsPoint(obj.frame, [touch locationInView:self])) {
            shouldBegin = YES;
            [_throughPoints addObject:obj];
            obj.selected = YES;
            *stop = YES;
        }
    }];
    [self draw];
    return shouldBegin;
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    [super continueTrackingWithTouch:touch withEvent:event];
    _fingerPoint = [NSValue valueWithCGPoint:[touch locationInView:self]];
    [_points enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (CGRectContainsPoint(obj.frame, [touch locationInView:self])) {
            if (![_throughPoints containsObject:obj]) {
                [_throughPoints addObject:obj];
            }
        }
        if ([_throughPoints containsObject:obj]) {
            obj.selected = YES;
            [self.layer insertSublayer:obj.layer above:_drawingLayer];
        }else{
            obj.selected = NO;
            [self.layer insertSublayer:obj.layer below:_drawingLayer];
        }
    }];
    
    [self draw];
    [self sendActionsForControlEvents:UIControlEventValueChanged];
    
    return YES;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    [super endTrackingWithTouch:touch withEvent:event];
    if (self.didFinishDrawing) {
        NSArray *tags = [_throughPoints valueForKeyPath:@"tag"];
        NSString *pwd = [tags componentsJoinedByString:@""];
        self.didFinishDrawing(self, pwd);
    }
}

#pragma mark -

- (void)clean{
    [_points enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.selected = NO;
    }];
    [_throughPoints removeAllObjects];
    _fingerPoint = nil;
    [self draw];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
