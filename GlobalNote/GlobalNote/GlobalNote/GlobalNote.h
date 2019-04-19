//
//  GlobalNote.h
//  CarPrice
//
//  Created by shengxin on 2019/4/16.
//  Copyright © 2019 Autohome. All rights reserved.
//  报价全量日志监测

#import <Foundation/Foundation.h>
/** 全量日志*/
#import <CocoaLumberjack/CocoaLumberjack.h>
#import <os/log.h>
#import <fishhook/fishhook.h>

/** 打印日志 */
#define LOG_LEVEL_DEF ddLogLevel
#ifdef DEBUG
static const DDLogLevel ddLogLevel = DDLogLevelVerbose;
#else
static const DDLogLevel ddLogLevel = DDLogLevelWarning;

#endif  /* DEBUG */

//#define NSLog(FORMAT, ...) LOG_MAYBE(LOG_ASYNC_ENABLED, LOG_LEVEL_DEF, DDLogFlagWarning|DDLogFlagError, 0, nil, __PRETTY_FUNCTION__, FORMAT, ##__VA_ARGS__)

static void (*orig_nslog)(NSString *format, ...);

NS_ASSUME_NONNULL_BEGIN

@interface GlobalNote : NSObject

@property (nonatomic, strong,readonly) NSString *noteFilePath;

+ (id)shareInstance;
/** 全量日志监测*/
- (void)setUpGlobalNote;
/** 获取全量日志*/
- (NSString *)getFileData;
@end

NS_ASSUME_NONNULL_END
