//
//  ZKAlertManager.m
//  ZKAlertPriorityDemo
//
//  Created by bestdew on 2018/11/22.
//  Copyright © 2018 bestdew. All rights reserved.
//

#import "ZKAlertManager.h"

@interface ZKAlert ()

@property (nonatomic, strong) UIAlertController *alertController;

@end

@implementation ZKAlert

#pragma mark -- Init
- (instancetype)init
{
    return [self initWithTitle:nil message:nil priority:0 handler:nil];
}

- (instancetype)initWithTitle:(NSString *)title
                      message:(NSString *)message
                     priority:(NSInteger)priority
                      handler:(ZKAlertHandler)handler
{
    if (self = [super init]) {
        
        _delay = 0.f;
        _title = title;
        _message = message;
        _priority = priority;
        _handler = handler;
        
        [self initAlertController];
    }
    return self;
}

+ (instancetype)alertWithTitle:(NSString *)title
                       message:(NSString *)message
                      priority:(NSInteger)priority
                       handler:(ZKAlertHandler)handler
{
    ZKAlert *alert = [[self alloc] initWithTitle:title message:message priority:priority handler:handler];
    return alert;
}

- (void)initAlertController
{
    _alertController = [UIAlertController alertControllerWithTitle:_title message:_message preferredStyle:UIAlertControllerStyleAlert];
    
    __weak typeof(self) weakSelf = self;
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf.handler) strongSelf.handler(YES);
        /**
         此Demo仅提供一种思路😂
         自定义弹窗可以下代码放在弹窗消失动画的完成回调里
         */
        if (strongSelf.didDismiss) strongSelf.didDismiss();
    }];
    [_alertController addAction:cancelAction];
    
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf.handler) strongSelf.handler(NO);
        if (strongSelf.didDismiss) strongSelf.didDismiss();
    }];
    [_alertController addAction:confirmAction];
}

#pragma mark -- Public Methods
- (void)show
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(_delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIViewController *rootVC = [UIApplication sharedApplication].delegate.window.rootViewController;
        [rootVC presentViewController:_alertController animated:YES completion:nil];
    });
}

#pragma mark -- Other
+ (BOOL)accessInstanceVariablesDirectly
{
    return NO; // 返回NO时，外部不能通过KVC赋值
}

- (void)dealloc
{
    NSLog(@"%s", __func__);
}

@end

@interface ZKAlertManager ()

@property (nonatomic, strong) NSMutableArray<ZKAlert *> *alertQueue;

@end

@implementation ZKAlertManager

static ZKAlertManager *_manager = nil;

#pragma mark -- Init
+ (instancetype)shareManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[super allocWithZone:NULL] init];
    });
    return _manager;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    return [ZKAlertManager shareManager];
}

- (instancetype)init
{
    if (self = [super init]) {
        
        _alertQueue = [NSMutableArray array];
    }
    return self;
}

#pragma mark -- Public Methods
- (void)addAlert:(ZKAlert *)alert
{
    if (_manager == nil || alert == nil) return;
    
    [_alertQueue addObject:alert];
}

- (void)addAlerts:(NSSet<ZKAlert *> *)alerts
{
    if (_manager == nil || alerts == nil) return;
    
    [_alertQueue addObjectsFromArray:alerts.allObjects];
}

- (void)showAlerts
{
    if (_manager == nil || _alertQueue.count <= 0) return;
    
    _alertQueue = [_alertQueue sortedArrayUsingComparator:^NSComparisonResult(ZKAlert * _Nonnull obj1, ZKAlert * _Nonnull obj2) {
        NSNumber *num1 = [NSNumber numberWithInteger:obj1.priority];
        NSNumber *num2 = [NSNumber numberWithInteger:obj2.priority];
        return [num1 compare:num2];
    }].mutableCopy;
    
    [self showAlertInOrder];
}

- (void)showAlertInOrder
{
    if (_alertQueue.count <= 0) {
        _manager = nil; // 销毁单例
        return;
    }
    
    ZKAlert *alert = [_alertQueue firstObject];
    __weak typeof(self) weakSelf = self;
    __weak typeof(alert) weakAlert = alert;
    alert.didDismiss = ^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        __strong typeof(weakAlert) strongAlert = weakAlert;
        [strongSelf.alertQueue removeObject:strongAlert];
        [strongSelf showAlertInOrder];
    };
    [alert show];
}

- (void)dealloc
{
    NSLog(@"%s", __func__);
}

@end
