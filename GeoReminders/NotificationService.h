//
//  NotificationService.h
//  GeoReminders
//
//  Created by Javier Rosas on 5/28/15.
//  Copyright (c) 2015 Javier Rosas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reminder.h"

@interface NotificationService : NSObject

+ (void)scheduleReminderNotification:(Reminder *)reminder;
+ (void)cancelReminderNotification:(NSString *)uid;

@end
