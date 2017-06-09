//
//  NotificationService.swift
//  ExampleServiceExtension
//
//  Created by Alba Luján on 1/6/17.
//  Copyright © 2017 Alba Luján. All rights reserved.
//

import UserNotifications
import AirshipAppExtensions

class NotificationService: UAMediaAttachmentExtension {
    
    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?

        
    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        
        var switchButtonOn: Bool = false
        
        let userDefaults = UserDefaults(suiteName: "group.com.pushNotifications")
        if let enabledNotif = userDefaults?.object(forKey: "enabledNotif") {
            switchButtonOn = enabledNotif as! Bool
        }
        
        
        
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        
        if let bestAttemptContent = bestAttemptContent, switchButtonOn == true {
            // Modify the notification content here...
            bestAttemptContent.title = "Holaaaaa m'he modificat 🖕"
            self.contentHandler!(self.bestAttemptContent!)
        } else {
            self.contentHandler!(request.content)
        }
    }
}

