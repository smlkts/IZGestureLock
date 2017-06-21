# IZGestureLock

[简书链接](http://www.jianshu.com/p/e829c09a0bba)

 ![](https://github.com/smlkts/IZGestureLock/raw/master/0.gif) 
 ![](https://github.com/smlkts/IZGestureLock/raw/master/1.gif)

## Adding `IZGestureLock` to your project

### CocoaPods

`pod 'IZGestureLock', '~> 0.0.1'`

## Usage:
```objc
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
```