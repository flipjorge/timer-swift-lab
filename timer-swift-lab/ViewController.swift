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
    
    var timer:Timer?
    var startTime:Int = 20
    var currentTime:Int = 0
    
    func startTimer(seconds: Int)
    {
        timer?.invalidate()
        startTime = seconds
        currentTime = seconds
        timeLabel.text = "\(currentTime)s"
        timer = Timer.init(timeInterval: 1, target: self, selector: #selector(onTimeInterval), userInfo: nil, repeats: true)
        timer?.tolerance = 0.1
        guard let timer = timer else { return }
        RunLoop.current.add(timer, forMode: .common)
    }
    
    func stopTimer()
    {
        timer?.invalidate()
        timer = nil
    }
    
    @objc func onTimeInterval(timer:Timer)
    {
        currentTime -= 1
        timeLabel.text = "\(currentTime)s"
        //
        if currentTime <= 0
        {
            stopTimer()
        }
    }
}
