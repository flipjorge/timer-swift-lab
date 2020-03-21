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
    
    var currentTime:Int = 0
    
    var isActive: Bool
    {
        timer != nil
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
            self.postInterval(seconds: self.currentTime)
            //
            if self.currentTime <= 0
            {
                self.stopTimer()
                self.postCompleted()
            }
        }
        guard let timer = timer else { return }
        timer.tolerance = 0.1
        RunLoop.current.add(timer, forMode: .common)
        
        //saving the end time
        let endTime = Date(timeIntervalSinceNow: TimeInterval(seconds))
        saveEndTime(endTime.timeIntervalSince1970)
        
        //
        NotificationsService.shared.sendNotification(identifier: "timerEnded", title: "Timer Ended", body: "Well done!", sound: "time.aiff", in: TimeInterval(seconds))
    }
    
    func resumeTimer()
    {
        let endTimeValue =  UserDefaults.standard.double(forKey: ValueKeys.endTime.rawValue)
        guard endTimeValue > 0 else { return }
        
        let endTimeDate = Date(timeIntervalSince1970: endTimeValue)
        let now = Date()
        
        let remainingSeconds = endTimeDate.timeIntervalSince(now)
        if remainingSeconds <= 0 {
            postInterval(seconds: 0)
            postCompleted()
            stopTimer()
            return
        }
        
        startTimer(Int(remainingSeconds))
    }
    
    func stopTimer()
    {
        timer?.invalidate()
        timer = nil
        UserDefaults.standard.removeObject(forKey: ValueKeys.endTime.rawValue)
    }
    
    // MARK: - User Defaults
    enum ValueKeys: String
    {
        case remainingSeconds = "remainingSeconds"
        case endTime = "endTime"
    }
    
    private func saveEndTime(_ endTime: TimeInterval)
    {
        UserDefaults.standard.set(endTime, forKey: ValueKeys.endTime.rawValue)
    }
    
    // MARK: - Notification
    enum Notification: String
    {
        case interval = "TimerInterval"
        case completed = "TimerCompleted"
    }
    
    private func postInterval(seconds: Int)
    {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: Notification.interval.rawValue), object: self, userInfo: [ValueKeys.remainingSeconds.rawValue : seconds])
    }
    
    private func postCompleted()
    {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: Notification.completed.rawValue), object: self, userInfo: [ValueKeys.remainingSeconds.rawValue : 0])
    }
}
