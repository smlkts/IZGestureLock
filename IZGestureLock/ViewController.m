//
//  ViewController.m
//  IZGestureLock
//
//  Created by 张雁军 on 21/06/2017.
//  Copyright © 2017 张雁军. All rights reserved.
//

#import "ViewController.h"
#import "LockController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)lock:(id)sender {
    LockController *vc = [[LockController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
