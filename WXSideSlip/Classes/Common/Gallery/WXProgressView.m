//
//  WXProgressView.m
//  WXSideSlip
//
//  Created by macOS on 2017/10/11.
//  Copyright © 2017年 WX. All rights reserved.
//

#import "WXProgressView.h"

static const CGFloat kMinWidth = 50.0;
static const CGFloat kLineWidth = 2.0;

@interface WXProgressView ()
@property (strong, nonatomic) CAShapeLayer *linkLayer;
@property (strong, nonatomic) CAShapeLayer *pieLayer;
@end

@implementation WXProgressView

#pragma mark - Life cycle

- (instancetype)init {
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, kMinWidth, kMinWidth);
        
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGFloat xCenter = rect.size.width * 0.5;
    CGFloat yCenter = rect.size.height * 0.5;
    CGFloat radius = MIN(xCenter, yCenter) - kLineWidth * 2;
    
    [[UIColor whiteColor] set];
    CGContextSetLineWidth(context, 1);
    CGContextMoveToPoint(context, xCenter, yCenter);
    CGContextAddLineToPoint(context, xCenter, 0);
    CGFloat endAngle = -M_PI_2 + MIN(_progress, 0.999) * M_PI * 2 + 0.001;
    CGContextAddArc(context, xCenter, yCenter, radius, - M_PI * 0.5, endAngle, 1);
    CGContextFillPath(context);
}

- (void)commonInit {
    self.backgroundColor = [UIColor clearColor];
    
    CGPathRef linkPathRef = [UIBezierPath bezierPathWithOvalInRect:self.bounds].CGPath;
    _linkLayer = [CAShapeLayer layer];
    _linkLayer.strokeColor = [UIColor whiteColor].CGColor;
    _linkLayer.fillColor = [UIColor clearColor].CGColor;
    _linkLayer.strokeStart = 0.0f;
    _linkLayer.strokeEnd = 1.0f;
    _linkLayer.lineWidth = 2.0f;
    _linkLayer.path = linkPathRef;
    [self.layer addSublayer:_linkLayer];
    
    CGFloat width = CGRectGetWidth(self.bounds);
    CGFloat pieWidth = width - 8;
    CGPathRef piePathRef = [UIBezierPath bezierPathWithArcCenter:CGPointMake(width / 2.0f, width / 2.0f) radius:pieWidth / 2.0f startAngle:M_PI_2 * 3.0 endAngle:M_PI_2 * 3.0 + M_PI * 2.0 clockwise:YES].CGPath;
    _pieLayer = [CAShapeLayer layer];
    _pieLayer.strokeColor = [UIColor whiteColor].CGColor;
    _pieLayer.fillColor = [UIColor clearColor].CGColor;
    _pieLayer.lineWidth = pieWidth / 2.0f;
    _pieLayer.strokeStart = 0.0f;
    _pieLayer.strokeEnd = 1.0f;
    _pieLayer.path = piePathRef;
//    [self.layer addSublayer:_pieLayer];
}

#pragma mark - Setter

- (void)setProgress:(CGFloat)progress {
    _progress = progress;
    
    self.pieLayer.strokeStart = progress;
    self.pieLayer.strokeEnd = 1.0f;
    [self setNeedsDisplay];
}

@end
