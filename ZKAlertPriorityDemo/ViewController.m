//
//  ViewController.m
//  ZKAlertPriorityDemo
//
//  Created by bestdew on 2018/11/22.
//  Copyright © 2018 bestdew. All rights reserved.
//

#import "ViewController.h"
#import "ZKAlertManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:({
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.f, 0.f, self.view.bounds.size.width, 50.f)];
        label.center = self.view.center;
        label.font = [UIFont boldSystemFontOfSize:20.f];
        label.text = @"点我，点我！";
        label.textAlignment = NSTextAlignmentCenter;
        label;
    })];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    ZKAlert *alert6 = [ZKAlert alertWithTitle:@"弹窗6" message:@"我是用来测试的6" priority:6 handler:^(BOOL isCancel) {
        if (!isCancel) self.view.backgroundColor = [UIColor cyanColor];
    }];
    //alert6.delay = 1.f;
    
    ZKAlert *alert1 = [ZKAlert alertWithTitle:@"弹窗1" message:@"我是用来测试的1" priority:1 handler:^(BOOL isCancel) {
        if (!isCancel) self.view.backgroundColor = [UIColor purpleColor];
    }];
    //alert1.delay = 0.5;
    
    ZKAlert *alert4 = [ZKAlert alertWithTitle:@"弹窗4" message:@"我是用来测试的4" priority:4 handler:^(BOOL isCancel) {
        if (!isCancel) self.view.backgroundColor = [UIColor yellowColor];
    }];
    //alert4.delay = 1.5;
    
    ZKAlert *alert2 = [ZKAlert alertWithTitle:@"弹窗2" message:@"我是用来测试的2" priority:2 handler:^(BOOL isCancel) {
        if (!isCancel) self.view.backgroundColor = [UIColor brownColor];
    }];
    //alert2.delay = 2.f;
    
    ZKAlert *alert5 = [ZKAlert alertWithTitle:@"弹窗5" message:@"我是用来测试的5" priority:5 handler:^(BOOL isCancel) {
        if (!isCancel) self.view.backgroundColor = [UIColor greenColor];
    }];
    //alert5.delay = 2.5;
    
    ZKAlert *alert3 = [ZKAlert alertWithTitle:@"弹窗3" message:@"我是用来测试的3" priority:3 handler:^(BOOL isCancel) {
        if (!isCancel) self.view.backgroundColor = [UIColor grayColor];
    }];
    //alert3.delay = 1.8;
    
    ZKAlertManager *manager = [ZKAlertManager shareManager];
    [manager addAlerts:@[alert6, alert2, alert1, alert4, alert3, alert5]];
    [manager showAlerts];
}

@end
