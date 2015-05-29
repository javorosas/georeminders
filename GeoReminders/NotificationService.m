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
    notification.alertBody = reminder.details;
    notification.alertTitle = reminder.title;
    notification.fireDate = reminder.date;
    notification.userInfo = @{ @"uuid": reminder.uuid };
    UIApplication *app = [UIApplication sharedApplication];
    [app scheduleLocalNotification:notification];
}

+ (void)cancelReminderNotification:(NSString *)uid {
    UIApplication *app = [UIApplication sharedApplication];
    for (UILocalNotification *notification in [app scheduledLocalNotifications]) {
        if (notification.userInfo[@"uuid"]) {
            [app cancelLocalNotification:notification];
        }
    }
}

@end
