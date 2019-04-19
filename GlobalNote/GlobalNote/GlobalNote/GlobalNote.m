//
//  GlobalNote.m
//  CarPrice
//
//  Created by shengxin on 2019/4/16.
//  Copyright © 2019 Autohome. All rights reserved.
//

#import "GlobalNote.h"
#import "GlobalNoteFormatter.h"

#define STRING(obj) obj?[NSString stringWithFormat:@"%@",obj]:@""
@interface GlobalNote()

@end

@implementation GlobalNote

void redirect_nslog(NSString *format, ...) {
    // 可以在这里先进行自己的处理
    NSCParameterAssert(format != nil);
    //va_list 类型的变量，va_list args这个变量是指向参数地址的指针，因为得到参数的地址之后，再结合参数的类型，才能得到参数的值。
    va_list args;
    //va_start 以固定参数的地址为起点确定变参的内存起始地址，获取第一个参数的首地址
    va_start(args, format);
    //创建一条DDLog 不走NSLog逻辑了 用os_log
    [DDLog log:YES level:ddLogLevel flag:DDLogFlagWarning|DDLogFlagError context:0 file:__FILE__ function:__PRETTY_FUNCTION__ line:__LINE__ tag:nil format:format args:args];
    //将arg_ptr指针置0
    va_end(args);
//    // 继续执行原 NSLog
//    va_start(args, format);
//    NSLogv(format, args);
//    va_end(args);
}

+ (id)shareInstance{
    static GlobalNote *obj;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        obj = [[GlobalNote alloc] init];
        
        struct rebinding nslog_rebinding = {"NSLog",redirect_nslog,(void*)&orig_nslog};
        rebind_symbols(&nslog_rebinding,1); 
        
    });
    return obj;
}
/** 全量日志监测*/
- (void)setUpGlobalNote{
    GlobalNoteFormatter *formatter =[[GlobalNoteFormatter alloc] init];
    if (@available(iOS 10.0, *)) {
        //This class provides a logger for the Apple os_log facility.
        [DDOSLogger sharedInstance].logFormatter = formatter;
        [DDLog addLogger:[DDOSLogger sharedInstance] withLevel:DDLogLevelAll ];
    } else {
        // Fallback on earlier versions
        [DDLog addLogger:[DDTTYLogger sharedInstance]];
    }
    //        DDFileLogger，你的日志语句将写入到一个文件中，默认路径在沙盒的Library/Caches/Logs/目录下，文件名为bundleid+空格+日期.log。
    DDFileLogger *fileLogger = [[DDFileLogger alloc] init];
    fileLogger.rollingFrequency = 60 * 60 * 24; // 刷新频率为24小时
    fileLogger.logFileManager.maximumNumberOfLogFiles = 7; // 保存一周的日志，即7天
    _noteFilePath = fileLogger.currentLogFileInfo.filePath;
    fileLogger.logFormatter = formatter;
    [DDLog addLogger:fileLogger];
}
/** 获取全量日志*/
- (NSString *)getFileData{
    NSFileManager* fm = [NSFileManager defaultManager];
    NSData* data = [[NSData alloc] init];
    data = [fm contentsAtPath:STRING(self.noteFilePath)];
    NSString *fileStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return fileStr;
}
@end
//使用可变参数应该有以下步骤：
//⑴在程序中将用到以下这些宏:
//
//void va_start( va_list arg_ptr, prev_param );
//
//type va_arg( va_list arg_ptr, type );
//
//void va_end( va_list arg_ptr );
//
//va在这里是variable-argument(可变参数)的意思.
//
//这些宏定义在stdarg.h中,所以用到可变参数的程序应该包含这个头文件.
//
//⑵函数里首先定义一个va_list型的变量,这里是arg_ptr,这个变量是指向参数地址的指针.因为得到参数的地址之后，再结合参数的类型，才能得到参数的值。
//
//⑶然后用va_start宏初始化⑵中定义的变量arg_ptr,这个宏的第二个参数是可变参数列表的前一个参数,也就是最后一个固定参数。
//
//⑷然后依次用va_arg宏使arg_ptr返回可变参数的地址,得到这个地址之后，结合参数的类型，就可以得到参数的值。然后进行输出。
//
//⑸设定结束条件，这里的条件就是判断参数值是否为-1。注意被调的函数在调用时是不知道可变参数的正确数目的，程序员必须自己在代码中指明结束条件。至于为什么它不会知道参数的数目，读者在看完下面这几个宏的内部实现机制后，自然就会明白。
