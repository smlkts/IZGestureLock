//
//  ViewController.m
//  ZYJGestureUnlock
//
//  Created by 张雁军 on 12/06/2017.
//  Copyright © 2017 张雁军. All rights reserved.
//

#import "ViewController.h"
#import "ZYJGestureUnlockControl.h"

typedef NS_ENUM(NSUInteger, GestureUnlockType) {
    GestureUnlockCreate,
    GestureUnlockConfirm
};

@interface ViewController ()
@property (nonatomic) GestureUnlockType unlockType;
@property (nonatomic, copy) NSString *pwd;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UILabel *fps = [[UILabel alloc] initWithFrame: CGRectMake(0, 0, 245, 30)];
    fps.center = CGPointMake(self.view.bounds.size.width/2, 120);
    fps.textAlignment = NSTextAlignmentCenter;
    fps.backgroundColor = [UIColor redColor];
    fps.textColor = [UIColor whiteColor];
    fps.layer.cornerRadius = 15;
    fps.layer.masksToBounds = YES;
    fps.text = @"请至少选择4个连接点";
    [self.view addSubview:fps];
    
    ZYJGestureUnlockControl *lock = [[ZYJGestureUnlockControl alloc] init];    
    lock.lineWidth = 2;
    lock.lineColor = [UIColor greenColor];
    lock.highlightedLineColor = [UIColor redColor];
    lock.contentInset = UIEdgeInsetsMake(15, 15, 15, 15);
    lock.itemSize = CGSizeMake(65, 65);
    lock.normalImage = [UIImage imageNamed:@"p_nl"];
    lock.selectedImage = [UIImage imageNamed:@"p_sl"];
    lock.highlightedImage = [UIImage imageNamed:@"p_hl"];
    lock.didFinishDrawing = ^(ZYJGestureUnlockControl *guc, NSString *password) {
        if (_unlockType == GestureUnlockCreate) {
            if (password.length < 4) {
                fps.text = @"请至少选择4个连接点";
                [self shake:fps];
                [guc highlightWithDuration:0.8 completion:nil];
            }else{
                _unlockType = GestureUnlockConfirm;
                fps.text = @"请再次绘制上一次的图案";
                self.pwd = password;
                [guc clean];
            }
        }else{
            if ([self.pwd isEqualToString:password]) {
                fps.text = @"成功";
                [guc cleanAfterDuration:0.8 completion:^{
                    [self.navigationController popViewControllerAnimated:YES];
                }];
            }else{
                fps.text = @"跟上次不一样 重新来";
                [self shake:fps];
                [guc highlightWithDuration:0.8 completion:nil];
            }
        }
    };
    [self.view addSubview:lock];

    lock.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:lock attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:lock attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"[lock(295)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(lock)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[lock(295)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(lock)]];
}

- (void)shake:(UIView *)view {
    CGPoint from = CGPointMake(view.layer.position.x, view.layer.position.y);
    CGPoint to = CGPointMake(view.layer.position.x + 8, view.layer.position.y);
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.fromValue = [NSValue valueWithCGPoint:from];
    animation.toValue = [NSValue valueWithCGPoint:to];
    animation.autoreverses = YES;
    animation.duration = .09;
    animation.repeatCount = 2;
    [view.layer addAnimation:animation forKey:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
