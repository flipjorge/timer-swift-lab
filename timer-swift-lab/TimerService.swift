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

        currentTime = seconds
        //
        timer = Timer.init(timeInterval: 1, repeats: true) { [weak self] timer in
            guard let self = self else { return }
            //
            self.currentTime -= 1
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: Notification.interval.rawValue), object: self, userInfo: [Keys.remainingSeconds.rawValue : self.currentTime])
            //
            if self.currentTime <= 0
            {
                self.stopTimer()
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: Notification.completed.rawValue), object: self, userInfo: [Keys.remainingSeconds.rawValue : self.currentTime])
            }
        }
        guard let timer = timer else { return }
        timer.tolerance = 0.1
        RunLoop.current.add(timer, forMode: .common)
        
        //saving the end time
        let endTime = Date(timeIntervalSinceNow: TimeInterval(currentTime))
        saveEndTime(endTime.timeIntervalSince1970)
    }
    
    func resumeTimer()
    {
        let endTimeValue =  UserDefaults.standard.double(forKey: Keys.endTime.rawValue)
        guard endTimeValue > 0 else { return }
        
        let endTimeDate = Date(timeIntervalSince1970: endTimeValue)
        let now = Date()
        
        let remainingSeconds = endTimeDate.timeIntervalSince(now)
        guard remainingSeconds > 0 else { return }
        
        startTimer(Int(remainingSeconds))
    }
    
    func stopTimer()
    {
        timer?.invalidate()
        timer = nil
        UserDefaults.standard.removeObject(forKey: Keys.endTime.rawValue)
    }
    
    // MARK: - User Defaults
    private enum Keys: String
    {
        case remainingSeconds = "remainingSeconds"
        case endTime = "endTime"
    }
    
    private func saveEndTime(_ endTime: TimeInterval)
    {
        UserDefaults.standard.set(endTime, forKey: Keys.endTime.rawValue)
    }
}
