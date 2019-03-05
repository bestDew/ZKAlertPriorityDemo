//
//  ZKAlertManager.h
//  ZKAlertPriorityDemo
//
//  Created by bestdew on 2018/11/22.
//  Copyright © 2018 bestdew. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ZKAlertHandler)(BOOL isCancel);

@interface ZKAlert : NSObject

/** 显示优先级 */
@property (nonatomic, readonly) NSInteger priority;
/** 标题 */
@property (nonatomic, readonly, copy) NSString *title;
/** 文本 */
@property (nonatomic, readonly, copy) NSString *message;
/** 点击回调 */
@property (nonatomic, readonly, copy) ZKAlertHandler handler;

/** 延迟显示时间 */
@property (nonatomic) CGFloat delay;
/** 消失回调 */
@property (nonatomic, copy) dispatch_block_t didDismiss;

/** 指定初始化 */
- (instancetype)initWithTitle:(NSString *)title
                      message:(NSString *)message
                     priority:(NSInteger)priority
                      handler:(ZKAlertHandler)handler NS_DESIGNATED_INITIALIZER;

+ (instancetype)alertWithTitle:(NSString *)title
                       message:(NSString *)message
                      priority:(NSInteger)priority
                       handler:(ZKAlertHandler)handler;

/** 显示 */
- (void)show;

@end

NS_ASSUME_NONNULL_BEGIN

@interface ZKAlertManager : NSObject

/** 单例 */
+ (instancetype)shareManager;

/** 向队列中添加弹窗 */
- (void)addAlert:(ZKAlert *)alert;
- (void)addAlerts:(NSSet<ZKAlert *> *)alerts;

/** 按优先级依次显示弹窗 */
- (void)showAlerts;

@end

NS_ASSUME_NONNULL_END
