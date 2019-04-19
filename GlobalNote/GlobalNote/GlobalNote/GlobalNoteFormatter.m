//
//  GlobalNoteFormatter.m
//  CarPrice
//
//  Created by shengxin on 2019/4/16.
//  Copyright © 2019 Autohome. All rights reserved.
//

#import "GlobalNoteFormatter.h"

@implementation GlobalNoteFormatter

- (NSString *)formatLogMessage:(DDLogMessage *)logMessage {
    NSString *logLevel;
    switch (logMessage->_flag) {
        case DDLogFlagError    : logLevel = @"E"; break;
        case DDLogFlagWarning  : logLevel = @"W"; break;
        case DDLogFlagInfo     : logLevel = @"I"; break;
        case DDLogFlagDebug    : logLevel = @"D"; break;
        default                : logLevel = @"V"; break;
    }
    
    return [NSString stringWithFormat:@"%@ | %@", logMessage.timestamp, logMessage->_message];
}

@end
