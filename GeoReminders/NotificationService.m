//
//  NotificationService.m
//  GeoReminders
//
//  Created by Javier Rosas on 5/28/15.
//  Copyright (c) 2015 Javier Rosas. All rights reserved.
//

#import "NotificationService.h"
#import <UIKit/UIKit.h>

@implementation NotificationService

+ (void)scheduleReminderNotification:(Reminder *)reminder {
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    
    if ([notification respondsToSelector:@selector(setAlertTitle:)]) {
        notification.alertTitle = reminder.title;
        notification.alertBody = reminder.details;
    } else {
        notification.alertBody = reminder.title;
    }
    if (reminder.date) {
        notification.fireDate = reminder.date;
    } else {
        notification.fireDate = [NSDate dateWithTimeIntervalSinceNow:1];
    }
    
    notification.userInfo = @{ @"uuid": reminder.uuid };
    notification.timeZone = [NSTimeZone defaultTimeZone];
    UIApplication *app = [UIApplication sharedApplication];
    [app scheduleLocalNotification:notification];
}

+ (void)cancelReminderNotification:(NSString *)uuid {
    UIApplication *app = [UIApplication sharedApplication];
    for (UILocalNotification *notification in [app scheduledLocalNotifications]) {
        if ([notification.userInfo[@"uuid"] isEqualToString:uuid]) {
            [app cancelLocalNotification:notification];
        }
    }
}

@end
