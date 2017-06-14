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
    fps.center = CGPointMake(self.view.bounds.size.width/2, 120);
    fps.textAlignment = NSTextAlignmentCenter;
    fps.backgroundColor = [UIColor redColor];
    fps.textColor = [UIColor whiteColor];
    fps.layer.cornerRadius = 15;
    fps.layer.masksToBounds = YES;
    fps.text = @"请至少选择4个连接点";
    [self.view addSubview:fps];
    
    ZYJGestureUnlockControl *ng = [[ZYJGestureUnlockControl alloc] initWithFrame:CGRectMake(0, 0, 295, 295)];
    ng.center = CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height/2);
    ng.lineWidth = 2;
    
    ng.lineColor = [UIColor greenColor];
    ng.highlightedLineColor = [UIColor redColor];
    ng.contentInset = UIEdgeInsetsMake(15, 15, 15, 15);
    ng.pointSize = CGSizeMake(65, 65);
    ng.normalImage = [UIImage imageNamed:@"p_nl"];
    ng.selectedImage = [UIImage imageNamed:@"p_sl"];
    ng.highlightedImage = [UIImage imageNamed:@"p_hl"];
    [self.view addSubview:ng];
    ng.didFinishDrawing = ^(ZYJGestureUnlockControl *guc, NSString *password) {
        if (_unlockType == GestureUnlockCreate) {
            if (password.length < 4) {
                fps.text = @"请至少选择4个连接点";
                [self shake:fps];
                [guc highlightWithDuration:2 completion:nil];
            }else{
                _unlockType = GestureUnlockConfirm;
                fps.text = @"请再次绘制上一次的图案";
                self.pwd = password;
                [guc clean];
            }
        }else{
            if ([self.pwd isEqualToString:password]) {
                fps.text = @"成功";
                [guc cleanAfterDuration:2 completion:nil];
            }else{
                fps.text = @"跟上次不一样 重新来";
                [self shake:fps];
                [guc highlightWithDuration:2 completion:nil];
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
