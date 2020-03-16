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
    override func viewDidLoad() {
        super.viewDidLoad()
        //
        
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
        TimerService.shared.startTimer(seconds: seconds, interval: { [weak self] remaining in
            self?.timeLabel.text = "\(remaining)s"
        }) {
            print("complete!")
        }
    }
    
    func stopTimer()
    {
        TimerService.shared.stopTimer()
    }
}
