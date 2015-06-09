//
//  NotificationService.swift
//  GeoReminders
//
//  Created by Javier Rosas on 6/2/15.
//  Copyright (c) 2015 Javier Rosas. All rights reserved.
//

import UIKit
import Foundation

class NotificationService: NSObject {
    
    static func scheduleReminderNotification(reminder: Reminder) {
        var notification = UILocalNotification();
        if (notification.respondsToSelector(Selector("alertTitle"))) {
            notification.alertTitle = reminder.title;
            notification.alertBody = reminder.details;
        } else {
            notification.alertBody = reminder.title;
        }
        if ((reminder.date) != nil) {
            notification.fireDate = reminder.date;
        } else {
            notification.fireDate = NSDate.new().dateByAddingTimeInterval(1);
        }
        
        notification.userInfo = ["uuid": reminder.uuid];
        notification.timeZone = NSTimeZone.defaultTimeZone();
        
        var app = UIApplication.sharedApplication();
        app.scheduleLocalNotification(notification);
    }
    
    static func cancelReminderNotification(uuid: String) {
        var app = UIApplication.sharedApplication();
        for notification in app.scheduledLocalNotifications {
            let info:[NSObject : AnyObject]? = notification.userInfo;
            let infoUUID = info?["uuid"] as! String
            if (infoUUID == uuid) {
                app.cancelLocalNotification(notification as! UILocalNotification);
            }
        }
    }
   
}
