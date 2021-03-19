//
//  WZFlashButton.m
//  WZRippleButton
//
//  Created by z on 15-1-6.
//  Copyright (c) 2015年 SatanWoo. All rights reserved.
//

#import "WZFlashButton.h"

const CGFloat WZFlashInnerCircleInitialRaius = 20;

@interface WZFlashButton()
{
    CAShapeLayer *circleShape;
    CGFloat scale;
    CGFloat width,height;
    CAAnimationGroup *groupAnimation;
    NSTimer * animateTimer;
}
@property (nonatomic, strong) UILabel *textLabel;
@end

@implementation WZFlashButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tapping) name:@"tapme" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopTimer) name:@"stopRipple" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startTimer) name:@"startRipple" object:nil];

        
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapping)];
//   [self addGestureRecognizer:tap];
    
    UIButton * tapBtn =[UIButton buttonWithType:UIButtonTypeCustom];
//    [tapBtn addTarget:self action:@selector(tapping) forControlEvents:UIControlEventTouchUpInside];
    tapBtn.frame=self.bounds;
    tapBtn.backgroundColor=[UIColor clearColor];
    [self addSubview:tapBtn];
//    
    self.textLabel = [[UILabel alloc] initWithFrame:self.bounds];
    self.textLabel.backgroundColor = [UIColor clearColor];
    [self.textLabel setTextColor:[UIColor whiteColor]];
    [self.textLabel setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:self.textLabel];
    
    
//    [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(tapping) userInfo:nil repeats:YES];
//    animateTimer=[NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(tapping) userInfo:nil repeats:NO]; // no repeate first time
    [self performSelector:@selector(tapping) withObject:nil afterDelay:0.1];
    animateTimer=[NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(tapping) userInfo:nil repeats:YES];
    
    self.backgroundColor = [UIColor grayColor];
//    self.buttonType = WZFlashButtonTypeInner;
    
    
}

-(void)stopTimer
{
    [animateTimer invalidate];
    
}

-(void)startTimer
{
    animateTimer=[NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(tapping) userInfo:nil repeats:YES];

}

#pragma mark - Public
- (void)setText:(NSString *)text
{
    [self setText:text withTextColor:nil];
}

- (void)setTextColor:(UIColor *)textColor
{
    [self setText:nil withTextColor:textColor];
}

- (void)setText:(NSString *)text withTextColor:(UIColor *)textColor
{
    if (textColor) {
        [self.textLabel setTextColor:textColor];
    }
    
    if (text) {
        [self.textLabel setText:text];
    }
}

- (void)setButtonType:(WZFlashButtonType)buttonType
{
    if (buttonType == WZFlashButtonTypeInner) {
        self.clipsToBounds = YES;
    } else {
        self.clipsToBounds = NO;
    }
    
    _buttonType = buttonType;
}

#pragma mark - Private
- (void)didTap:(UITapGestureRecognizer *)tapGestureHandler
{
    
}


-(void)tapping
{
    {
//    CGPoint tapLocation = [tapGestureHandler locationInView:self];
//        circleShape = nil;
         scale = 1.0f;
        
        width = self.bounds.size.width;
        height = self.bounds.size.height;
        
        
            
            
            
        scale = 3.5f;
        circleShape = [self createCircleShapeWithPosition:CGPointMake(width/2, height/2)
                                                     pathRect:CGRectMake(-CGRectGetMidX(self.bounds), -CGRectGetMidY(self.bounds), width, height)
                                                       radius:self.layer.cornerRadius];
        
        
        [self.layer addSublayer:circleShape];
        
        groupAnimation = [self createFlashAnimationWithScale:scale duration:3.2f];
        
        /* Use KVC to remove layer to avoid memory leak */
        [groupAnimation setValue:circleShape forKey:@"circleShaperLayer"];
        
        [circleShape addAnimation:groupAnimation forKey:nil];
//        [circleShape setDelegate:self]; // kp
        
        if (self.clickBlock) {
            self.clickBlock();
        }
    }
}
- (CAShapeLayer *)createCircleShapeWithPosition:(CGPoint)position pathRect:(CGRect)rect radius:(CGFloat)radius
{
    circleShape = [CAShapeLayer layer];
    circleShape.path = [self createCirclePathWithRadius:rect radius:radius];
    circleShape.position = position;
    
    if (self.buttonType == WZFlashButtonTypeInner) {
        circleShape.bounds = CGRectMake(0, 0, radius * 2, radius * 2);
        circleShape.fillColor = self.flashColor ? self.flashColor.CGColor : [UIColor whiteColor].CGColor;
    } else {
        circleShape.fillColor = [UIColor colorWithRed:(20.0/255.0) green:(147.0/255.0) blue:(5.0/255.0) alpha:1].CGColor;
//        circleShape.fillColor = [APP_DELEGATE colorWithHexString:dark_green_color].CGColor;
        circleShape.strokeColor = self.flashColor ? self.flashColor.CGColor : [UIColor purpleColor].CGColor;
    }
   
    circleShape.opacity = 0;
    circleShape.lineWidth = 1;
    
    return circleShape;
}

- (CAAnimationGroup *)createFlashAnimationWithScale:(CGFloat)scale1 duration:(CGFloat)duration
{
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    scaleAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(scale1, scale1, 1)];
    
    CABasicAnimation *alphaAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    alphaAnimation.fromValue = @1;
    alphaAnimation.toValue = @0;
    
    CAAnimationGroup *animation = [CAAnimationGroup animation];
    animation.animations = @[scaleAnimation, alphaAnimation];
    animation.delegate = self;
    animation.duration = duration;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    return animation;
}

- (CGPathRef)createCirclePathWithRadius:(CGRect)frame radius:(CGFloat)radius
{
    return [UIBezierPath bezierPathWithRoundedRect:frame cornerRadius:radius].CGPath;
}

#pragma mark - CAAnimationDelegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
//    CALayer *layer = [anim valueForKey:@"circleShaperLayer"];
//    if (layer) {
//        [layer removeFromSuperlayer];
//    }

}

@end
