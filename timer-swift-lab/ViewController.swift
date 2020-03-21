//
//  ViewController.swift
//  timer-swift-lab
//
//  Created by Filipe Jorge on 15/03/2020.
//  Copyright © 2020 Filipe Jorge. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
    // MARK: - Lifecycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        //
        NotificationCenter.default.addObserver(self, selector: #selector(onTimerInterval), name: NSNotification.Name(TimerService.Notification.interval.rawValue), object: nil)
    }
    
    deinit
    {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Actions
    @IBAction func onFiveSeconds(_ sender: Any)
    {
        startTimer(seconds: 5)
    }
    
    @IBAction func onTweentySeconds(_ sender: Any)
    {
        startTimer(seconds: 20)
    }
    
    // MARK: - Time
    @IBOutlet weak var timeLabel: UILabel!
    
    func startTimer(seconds: Int)
    {
        timeLabel.text = "\(seconds)s"
        TimerService.shared.startTimer(seconds)
    }
    
    func stopTimer()
    {
        TimerService.shared.stopTimer()
    }
    
    @objc func onTimerInterval(notification:Notification)
    {
        guard let userInfo = notification.userInfo else { return }
        timeLabel.text = "\(userInfo["remainingSeconds"] ?? 0)s"
    }
}
