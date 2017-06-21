//
//  LockController.m
//  IZGestureLock
//
//  Created by 张雁军 on 21/06/2017.
//  Copyright © 2017 张雁军. All rights reserved.
//

#import "LockController.h"
#import "IZGestureLock.h"

typedef NS_ENUM(NSUInteger, GestureLockType) {
    GestureLockCreate,
    GestureLockConfirm
};

@interface LockController ()
@property (nonatomic) GestureLockType lockType;
@property (nonatomic, copy) NSString *pwd;
@end

@implementation LockController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    
    UILabel *fps = [[UILabel alloc] initWithFrame: CGRectMake(0, 0, 245, 30)];
    fps.center = CGPointMake(self.view.bounds.size.width/2, 120);
    fps.textAlignment = NSTextAlignmentCenter;
    fps.backgroundColor = [UIColor redColor];
    fps.textColor = [UIColor whiteColor];
    fps.layer.cornerRadius = 15;
    fps.layer.masksToBounds = YES;
    fps.text = @"请至少选择4个连接点";
    [self.view addSubview:fps];
    
    IZGestureLock *gesturelock = [[IZGestureLock alloc] init];
    gesturelock.lineWidth = 2;
    gesturelock.lineColor = [UIColor greenColor];
    gesturelock.highlightedLineColor = [UIColor redColor];
    gesturelock.contentInset = UIEdgeInsetsMake(15, 15, 15, 15);
    gesturelock.itemSize = CGSizeMake(65, 65);
    gesturelock.normalImage = [UIImage imageNamed:@"p_nl"];
    gesturelock.selectedImage = [UIImage imageNamed:@"p_sl"];
    gesturelock.highlightedImage = [UIImage imageNamed:@"p_hl"];
    gesturelock.didFinishDrawing = ^(IZGestureLock *lock, NSString *password) {
        if (_lockType == GestureLockCreate) {
            if (password.length < 4) {
                fps.text = @"请至少选择4个连接点";
                [self shake:fps];
                [lock highlightWithDuration:0.8 completion:nil];
            }else{
                _lockType = GestureLockConfirm;
                fps.text = @"请再次绘制上一次的图案";
                self.pwd = password;
                [lock clean];
            }
        }else{
            if ([self.pwd isEqualToString:password]) {
                fps.text = @"成功";
                [lock cleanAfterDuration:0.8 completion:^{
                    [self.navigationController popViewControllerAnimated:YES];
                }];
            }else{
                fps.text = @"跟上次不一样 重新来";
                [self shake:fps];
                [lock highlightWithDuration:0.8 completion:nil];
            }
        }
    };
    [self.view addSubview:gesturelock];
    
    gesturelock.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:gesturelock attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:gesturelock attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"[gesturelock(295)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(gesturelock)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[gesturelock(295)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(gesturelock)]];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
