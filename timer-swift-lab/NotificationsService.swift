//
//  NotificationsService.swift
//  timer-swift-lab
//
//  Created by Filipe Jorge on 21/03/2020.
//  Copyright © 2020 Filipe Jorge. All rights reserved.
//

import UserNotifications

class NotificationsService
{
    // MARK: - Singleton
    static let shared = NotificationsService()
    
    // MARK: - Authorization
    func requestAuthorization()
    {
        let options = UNAuthorizationOptions.init(arrayLiteral: .alert, .sound)
        
        UNUserNotificationCenter.current().requestAuthorization(options: options) { success, error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    // MARK: - Send
    func sendNotification(identifier: String, title: String, body: String, sound: String? = nil, in seconds: TimeInterval? = nil)
    {
        //content
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = title
        notificationContent.body = body
        if let sound = sound {
            notificationContent.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: sound))
        }
        
        //trigger
        var trigger: UNTimeIntervalNotificationTrigger? = nil
        if let seconds = seconds {
            trigger = UNTimeIntervalNotificationTrigger(timeInterval: seconds, repeats: false)
        }
        
        //request
        let request = UNNotificationRequest(identifier: identifier, content: notificationContent, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
}
