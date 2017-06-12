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
    UILabel *fps = [[UILabel alloc] initWithFrame: CGRectMake(60, 65, 200, 30)];
    fps.textAlignment = NSTextAlignmentCenter;
    fps.backgroundColor = [UIColor redColor];
    fps.textColor = [UIColor whiteColor];
    fps.layer.cornerRadius = 15;
    fps.layer.masksToBounds = YES;
    fps.text = @"划4个点";
    [self.view addSubview:fps];
    
    ZYJGestureUnlockControl *ng = [[ZYJGestureUnlockControl alloc] initWithFrame:CGRectMake(10, 120, 300, 300)];
    ng.lineWidth = 2;
    ng.lineColor = [UIColor blueColor];
    ng.contentInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    ng.pointSize = CGSizeMake(50, 50);
    ng.normalImage = [UIImage imageNamed:@"normal"];
    ng.selectedImage = [UIImage imageNamed:@"selected"];
    [self.view addSubview:ng];
    ng.backgroundColor = [UIColor greenColor];
    ng.didFinishDrawing = ^(ZYJGestureUnlockControl *guc, NSString *password) {
        [guc clean];
        if (_unlockType == GestureUnlockCreate) {
            if (password.length < 4) {
                fps.text = @"至少4个点";
                [self shake:fps];
            }else{
                _unlockType = GestureUnlockConfirm;
                fps.text = @"再次绘制上一次的图案";
                self.pwd = password;
            }
        }else{
            if ([self.pwd isEqualToString:password]) {
                fps.text = @"成功";
            }else{
                fps.text = @"跟上次不一样 重新来";
                [self shake:fps];
            }
        }
    };
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
