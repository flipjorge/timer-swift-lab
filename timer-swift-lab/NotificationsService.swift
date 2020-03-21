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
        let options = UNAuthorizationOptions.init(arrayLiteral: .alert)
        
        UNUserNotificationCenter.current().requestAuthorization(options: options) { success, error in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
        }
        
    }
}
