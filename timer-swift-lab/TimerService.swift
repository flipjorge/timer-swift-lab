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
    private var currentTime:Int = 0
    
    func startTimer(seconds:Int, interval:@escaping(Int) -> Void, completion:@escaping() -> Void)
    {
        timer?.invalidate()
        startTime = seconds
        currentTime = seconds
        //
        timer = Timer.init(timeInterval: 1, repeats: true) { [weak self] timer in
            guard let self = self else { return }
            //
            self.currentTime -= 1
            interval(self.currentTime)
            //
            if self.currentTime <= 0
            {
                self.stopTimer()
                completion()
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
