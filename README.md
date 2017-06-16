# ZYJGestureUnlock

[简书链接](http://www.jianshu.com/p/e829c09a0bba)

 ![](https://github.com/smlkts/ZYJGestureUnlock/raw/master/0.gif) 
 ![](https://github.com/smlkts/ZYJGestureUnlock/raw/master/1.gif)

## Adding `ZYJGestureUnlock` to your project

### CocoaPods

[CocoaPods](http://cocoapods.org) is the recommended way to add ZYJGestureUnlock to your project.

1. Add a pod entry for ZYJGestureUnlock to your Podfile `pod 'ZYJGestureUnlock', '~> 0.0.2'`
2. Install the pod(s) by running `pod install`.
3. Include ZYJGestureUnlock wherever you need it with `#import "ZYJGestureUnlockControl.h"`.

## Usage:
```objc
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
```