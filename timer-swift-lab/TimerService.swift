//
//  TimerService.swift
//  timer-swift-lab
//
//  Created by Filipe Jorge on 16/03/2020.
//  Copyright © 2020 Filipe Jorge. All rights reserved.
//

import Foundation

class TimerService
{
    // MARK: - Singleton
    static var shared = TimerService()
    
    // MARK: - Timer
    private var timer:Timer?
    
    private var startTime:Int = 20
    var currentTime:Int = 0
    
    var isActive: Bool
    {
        timer != nil
    }
    
    enum Notification: String
    {
        case interval = "TimerInterval"
        case completed = "TimerCompleted"
    }
    
    func startTimer(_ seconds:Int)
    {
        timer?.invalidate()
        startTime = seconds
        currentTime = seconds
        //
        timer = Timer.init(timeInterval: 1, repeats: true) { [weak self] timer in
            guard let self = self else { return }
            //
            self.currentTime -= 1
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: Notification.interval.rawValue), object: self, userInfo: ["remainingSeconds" : self.currentTime])
            //
            if self.currentTime <= 0
            {
                self.stopTimer()
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: Notification.completed.rawValue), object: self, userInfo: ["remainingSeconds" : self.currentTime])
            }
        }
        timer?.tolerance = 0.1
        guard let timer = timer else { return }
        RunLoop.current.add(timer, forMode: .common)
    }
    
    func stopTimer()
    {
        timer?.invalidate()
        timer = nil
    }
}
